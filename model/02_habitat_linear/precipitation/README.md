# Mean annual precipitation 

ClimateBC mean annual precipitation (MAP) referenced to FWA watersheds and streams

## Method

1. Overlay ClimateBC MAP raster with fundamental watersheds, deriving MAP for each fundamental watershed
2. Calculate average (area-weighted) upstream MAP for each distinct watershed code / local code combination 

The output table can be joined to streams or points on the FWA watershed network.

## Usage

To download, process and generate mean annual precipitation for each stream segment:

    ./mean_annual_precip.sh

## Output

```
Table "bcfishpass.mean_annual_precip"
        Column        |  Type   | Collation | Nullable |                          Default
----------------------+---------+-----------+----------+-----------------------------------------------------------
 id                   | integer |           | not null | nextval('bcfishpass.mean_annual_precip_id_seq'::regclass)
 wscode_ltree         | ltree   |           |          |
 localcode_ltree      | ltree   |           |          |
 watershed_group_code | text    |           |          |
 area                 | bigint  |           |          |
 map                  | integer |           |          |
 map_upstream         | integer |           |          |
Indexes:
    "mean_annual_precip_pkey" PRIMARY KEY, btree (id)
    "mean_annual_precip_wscode_ltree_localcode_ltree_key" UNIQUE CONSTRAINT, btree (wscode_ltree, localcode_ltree)
    "mean_annual_precip_localcode_ltree_idx" gist (localcode_ltree)
    "mean_annual_precip_localcode_ltree_idx1" btree (localcode_ltree)
    "mean_annual_precip_wscode_ltree_idx" gist (wscode_ltree)
    "mean_annual_precip_wscode_ltree_idx1" btree (wscode_ltree)
```

## References

- Wang, T., Hamann, A., Spittlehouse, D.L., Murdock, T., 2012. *ClimateWNA - High-Resolution Spatial Climate Data for Western North America*. Journal of Applied Meteorology and Climatology, 51: 16-29.*


## Source data lineage

Climate BC web and api do not seem to provide urls to climate rasters. I have manually downloaded the  `Normal_1991_2020` `MAP.tif` from https://climatebc.ca/SpatialData and posted to S3 in support of automated `bcfishpass` builds:

    aws s3 cp MAP.tif s3://bcfishpass/
    aws s3api put-object-acl --bucket bcfishpass --key MAP.tif --acl public-read