#!/bin/bash
set -euxo pipefail

# publish data to s3 
# https://bcfishpass.s3.us-west-2.amazonaws.com/freshwater_fish_habitat_accessibility_MODEL.gpkg.zip

# refresh the views
psql $DATABASE_URL -v ON_ERROR_STOP=1 -f sql/freshwater_fish_habitat_accessibility_model.sql

rm -rf freshwater_fish_habitat_accessibility_MODEL.gpkg*

echo 'dumping crossings'
ogr2ogr \
    -f GPKG \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln crossings \
    -nlt PointZM \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_crossings_vw"


echo 'dump gradient barriers table'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln gradient_barriers \
    -nlt PointZM \
    -sql "select 
     ((((b.blue_line_key::bigint + 1) - 354087611) * 10000000) + round(b.downstream_route_measure::bigint))::text as gradient_barrier_id,
    s.linear_feature_id,
    b.blue_line_key,
    b.downstream_route_measure,
    s.wscode_ltree as wscode,
    s.localcode_ltree as localcode,
    b.watershed_group_code,
    ST_Force2D((ST_Dump(ST_Locatealong(s.geom, b.downstream_route_measure))).geom)::geometry(Point,3005) as geom
    from bcfishpass.gradient_barriers b
    INNER JOIN whse_basemapping.fwa_stream_networks_sp s
    ON b.blue_line_key = s.blue_line_key
    AND s.downstream_route_measure <= b.downstream_route_measure
    AND s.upstream_route_measure + .01 > b.downstream_route_measure
    LEFT OUTER JOIN bcfishpass.user_barriers_definite_control p
    ON b.blue_line_key = p.blue_line_key
    AND abs(b.downstream_route_measure - p.downstream_route_measure) < 1
    where gradient_class in (5, 10, 15, 20, 25, 30)
    and (p.barrier_ind IS NULL or p.barrier_ind is true) -- do not include records forced to be passable in control table
    limit 10"


echo 'dumping subsurface flow barriers'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln barriers_subsurfaceflow \
    -nlt PointZM \
    -sql "select 
     barriers_subsurfaceflow_id,
     barrier_type,
     barrier_name,
     linear_feature_id,
     blue_line_key,
     watershed_key,
     downstream_route_measure,
     wscode_ltree as wscode,
     localcode_ltree as localcode,
     watershed_group_code,
     geom
     from bcfishpass.barriers_subsurfaceflow"


echo 'dumping falls that are barriers'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln barriers_falls \
    -nlt PointZM \
    -sql "select 
     barriers_falls_id,
     barrier_type,
     barrier_name,
     linear_feature_id,
     blue_line_key,
     watershed_key,
     downstream_route_measure,
     wscode_ltree as wscode,
     localcode_ltree as localcode,
     watershed_group_code,
     geom
    from bcfishpass.barriers_falls"


echo 'dumping barriers_salmon'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln barriers_salmon \
    -nlt PointZM \
    -sql "select 
			 barriers_ch_cm_co_pk_sk_id,
			 barrier_type,
			 barrier_name,
			 linear_feature_id,
			 blue_line_key,
			 watershed_key,
			 downstream_route_measure,
			 wscode_ltree as wscode,
			 localcode_ltree as localcode,
			 watershed_group_code,
			 total_network_km,
			 geom
  		  from bcfishpass.barriers_ch_cm_co_pk_sk"


echo 'dumping barriers_steelhead'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln barriers_steelhead \
    -nlt PointZM \
    -sql "select 
			 barriers_st_id,
			 barrier_type,
			 barrier_name,
			 linear_feature_id,
			 blue_line_key,
			 watershed_key,
			 downstream_route_measure,
			 wscode_ltree as wscode,
			 localcode_ltree as localcode,
			 watershed_group_code,
			 total_network_km,
			 geom
  		  from bcfishpass.barriers_st"

echo 'dumping salmon'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln model_access_salmon \
    -nlt LineStringZM \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_salmon_vw"

echo 'dumping steelhead'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln model_access_steelhead \
    -nlt LineStringZM \
    -sql "select * from bcfishpass.freshwater_fish_habitat_accessibility_model_steelhead_vw"

echo 'dumping observations'
ogr2ogr \
    -f GPKG \
    -append \
    -update \
    freshwater_fish_habitat_accessibility_MODEL.gpkg \
    PG:$DATABASE_URL \
    -nln observations \
    -nlt PointZM \
    -sql "select  
     fish_observation_point_id,
     fish_obsrvtn_event_id,
     linear_feature_id,
     blue_line_key,
     wscode_ltree as wscode,
     localcode_ltree as localcode,
     downstream_route_measure,
     watershed_group_code,
     species_code,
     observation_date,
     activity_code,
     activity,
     life_stage_code,
     life_stage,
     acat_report_url,
     geom
     from bcfishpass.freshwater_fish_habitat_accessibility_model_observations_vw"   

echo 'dump to MODEL.gpkg complete'    

# zip and remove uncompressed file
zip -r freshwater_fish_habitat_accessibility_MODEL.gpkg.zip freshwater_fish_habitat_accessibility_MODEL.gpkg
rm freshwater_fish_habitat_accessibility_MODEL.gpkg

# send to s3
aws s3 cp freshwater_fish_habitat_accessibility_MODEL.gpkg.zip s3://bcfishpass/
# open it up
aws s3api put-object-acl --bucket bcfishpass --key freshwater_fish_habitat_accessibility_MODEL.gpkg.zip --acl public-read