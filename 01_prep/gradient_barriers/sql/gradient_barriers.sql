WITH grade100m AS
(
  SELECT
    sv.blue_line_key,
    ROUND(sv.downstream_route_measure::numeric, 2) as downstream_route_measure,
    ROUND(sv.elevation::numeric, 2) as elevation_a,
    ROUND((ST_Z((ST_Dump((ST_LocateAlong(s2.geom, sv.downstream_route_measure + 100)))).geom))::numeric, 2) as elevation_b,
    ROUND(((ST_Z((ST_Dump((ST_LocateAlong(s2.geom, sv.downstream_route_measure + 100)))).geom) - sv.elevation) / 100)::numeric, 4) as gradient
  FROM
  (SELECT
    linear_feature_id,
    blue_line_key,
    edge_type,
    ((ST_LineLocatePoint(geom, ST_PointN(geom, generate_series(1, ST_NPoints(geom) - 1))) * length_metre) + downstream_route_measure) as downstream_route_measure,
    ST_Z(ST_PointN(geom, generate_series(1, ST_NPoints(geom) - 1))) AS elevation
  FROM whse_basemapping.fwa_stream_networks_sp s
  WHERE watershed_group_code = :'wsg'
  AND blue_line_key = watershed_key
  AND edge_type != 6010
  ORDER BY blue_line_key, downstream_route_measure
  ) as sv
  INNER JOIN whse_basemapping.fwa_stream_networks_sp s2
  ON sv.blue_line_key = s2.blue_line_key AND
     sv.downstream_route_measure + 100 >= s2.downstream_route_measure AND -- find stream segment 100m up
     sv.downstream_route_measure + 100 < s2.upstream_route_measure
  WHERE sv.edge_type IN (1000,1050,1100,1150,1250,1350,1410,2000,2300)
),

-- note the slope classes
gradeclass AS
(
  SELECT
    blue_line_key,
    downstream_route_measure,
    downstream_route_measure + 100 as upstream_route_measure,
    -- create breaks at 5pct intervals from 5-30pct
    -- (fish access model does not have to use all of these,
    -- but we might as well create them all to have on hand)
    CASE
      WHEN gradient >= .05 AND gradient < .10 THEN 5
      WHEN gradient >= .10 AND gradient < .15 THEN 10
      WHEN gradient >= .15 AND gradient < .20 THEN 15
      WHEN gradient >= .20 AND gradient < .25 THEN 20
      WHEN gradient >= .25 AND gradient < .30 THEN 25
      WHEN gradient >= .30 THEN 30
      ELSE 0
    END as grade_class
  FROM grade100m
  ORDER BY blue_line_key, downstream_route_measure
)

-- Group the continuous same-slope class segments together (thank you Erwin B)
-- https://dba.stackexchange.com/questions/166374/grouping-or-window/166397#166397
INSERT INTO bcfishpass.gradient_barriers_test
(blue_line_key, downstream_route_measure, gradient_class)

SELECT
  blue_line_key,
  min(downstream_route_measure) AS downstream_route_measure,
  grade_class as gradient_class
FROM
(
  SELECT
    blue_line_key,
    downstream_route_measure,
    grade_class,
    count(step OR NULL) OVER (ORDER BY blue_line_key, downstream_route_measure) AS grp
  FROM  (
    SELECT blue_line_key, downstream_route_measure, grade_class
         , lag(grade_class, 1, grade_class) OVER (ORDER BY blue_line_key, downstream_route_measure) <> grade_class AS step
    FROM gradeclass
  ) sub1
WHERE grade_class != 0
) sub2
GROUP BY blue_line_key, grade_class, grp
ORDER BY blue_line_key, downstream_route_measure;
