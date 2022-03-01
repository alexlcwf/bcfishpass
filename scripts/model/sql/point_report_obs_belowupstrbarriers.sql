-- for crossings, report on belowupstrbarriers categories is a bit different because the table has a mix of barriers/non-barriers
-- run it separately here.
WITH report AS
(SELECT
  a.aggregated_crossings_id,
  ROUND((COALESCE(a.total_network_km, 0) - SUM(COALESCE(b.total_network_km, 0)))::numeric, 2) total_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.total_stream_km, 0) - SUM(COALESCE(b.total_stream_km, 0)))::numeric, 2) total_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.total_lakereservoir_ha, 0) - SUM(COALESCE(b.total_lakereservoir_ha, 0)))::numeric, 2) total_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.total_wetland_ha, 0) - SUM(COALESCE(b.total_wetland_ha, 0)))::numeric, 2) total_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.total_slopeclass03_waterbodies_km, 0) - SUM(COALESCE(b.total_slopeclass03_waterbodies_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND((COALESCE(a.total_slopeclass03_km, 0) - SUM(COALESCE(b.total_slopeclass03_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.total_slopeclass05_km, 0) - SUM(COALESCE(b.total_slopeclass05_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.total_slopeclass08_km, 0) - SUM(COALESCE(b.total_slopeclass08_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.total_slopeclass15_km, 0) - SUM(COALESCE(b.total_slopeclass15_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.total_slopeclass22_km, 0) - SUM(COALESCE(b.total_slopeclass22_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.total_slopeclass30_km, 0) - SUM(COALESCE(b.total_slopeclass30_km, 0)))::numeric, 2) total_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.ch_co_sk_network_km, 0) - SUM(COALESCE(b.ch_co_sk_network_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.ch_co_sk_stream_km, 0) - SUM(COALESCE(b.ch_co_sk_stream_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.ch_co_sk_lakereservoir_ha, 0) - SUM(COALESCE(b.ch_co_sk_lakereservoir_ha, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.ch_co_sk_wetland_ha, 0) - SUM(COALESCE(b.ch_co_sk_wetland_ha, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.ch_co_sk_slopeclass03_waterbodies_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass03_waterbodies_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass03_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass03_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass05_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass05_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass08_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass08_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass15_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass15_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass22_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass22_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.ch_co_sk_slopeclass30_km, 0) - SUM(COALESCE(b.ch_co_sk_slopeclass30_km, 0)))::numeric, 2) ch_co_sk_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.st_network_km, 0) - SUM(COALESCE(b.st_network_km, 0)))::numeric, 2) st_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.st_stream_km, 0) - SUM(COALESCE(b.st_stream_km, 0)))::numeric, 2) st_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.st_lakereservoir_ha, 0) - SUM(COALESCE(b.st_lakereservoir_ha, 0)))::numeric, 2) st_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.st_wetland_ha, 0) - SUM(COALESCE(b.st_wetland_ha, 0)))::numeric, 2) st_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.st_slopeclass03_km, 0) - SUM(COALESCE(b.st_slopeclass03_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.st_slopeclass05_km, 0) - SUM(COALESCE(b.st_slopeclass05_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.st_slopeclass08_km, 0) - SUM(COALESCE(b.st_slopeclass08_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.st_slopeclass15_km, 0) - SUM(COALESCE(b.st_slopeclass15_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.st_slopeclass22_km, 0) - SUM(COALESCE(b.st_slopeclass22_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.st_slopeclass30_km, 0) - SUM(COALESCE(b.st_slopeclass30_km, 0)))::numeric, 2) st_belowupstrbarriers_slopeclass30_km,
  ROUND((COALESCE(a.wct_network_km, 0) - SUM(COALESCE(b.wct_network_km, 0)))::numeric, 2) wct_belowupstrbarriers_network_km,
  ROUND((COALESCE(a.wct_stream_km, 0) - SUM(COALESCE(b.wct_stream_km, 0)))::numeric, 2) wct_belowupstrbarriers_stream_km,
  ROUND((COALESCE(a.wct_lakereservoir_ha, 0) - SUM(COALESCE(b.wct_lakereservoir_ha, 0)))::numeric, 2) wct_belowupstrbarriers_lakereservoir_ha,
  ROUND((COALESCE(a.wct_wetland_ha, 0) - SUM(COALESCE(b.wct_wetland_ha, 0)))::numeric, 2) wct_belowupstrbarriers_wetland_ha,
  ROUND((COALESCE(a.wct_slopeclass03_km, 0) - SUM(COALESCE(b.wct_slopeclass03_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass03_km,
  ROUND((COALESCE(a.wct_slopeclass05_km, 0) - SUM(COALESCE(b.wct_slopeclass05_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass05_km,
  ROUND((COALESCE(a.wct_slopeclass08_km, 0) - SUM(COALESCE(b.wct_slopeclass08_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass08_km,
  ROUND((COALESCE(a.wct_slopeclass15_km, 0) - SUM(COALESCE(b.wct_slopeclass15_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass15_km,
  ROUND((COALESCE(a.wct_slopeclass22_km, 0) - SUM(COALESCE(b.wct_slopeclass22_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass22_km,
  ROUND((COALESCE(a.wct_slopeclass30_km, 0) - SUM(COALESCE(b.wct_slopeclass30_km, 0)))::numeric, 2) wct_belowupstrbarriers_slopeclass30_km,

  ROUND((COALESCE(a.ch_spawning_km, 0) - SUM(COALESCE(b.ch_spawning_km, 0)))::numeric, 2) ch_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.ch_rearing_km, 0) - SUM(COALESCE(b.ch_rearing_km, 0)))::numeric, 2) ch_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_spawning_km, 0) - SUM(COALESCE(b.co_spawning_km, 0)))::numeric, 2) co_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_rearing_km, 0) - SUM(COALESCE(b.co_rearing_km, 0)))::numeric, 2) co_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.co_rearing_ha, 0) - SUM(COALESCE(b.co_rearing_ha, 0)))::numeric, 2) co_rearing_belowupstrbarriers_ha  ,
  ROUND((COALESCE(a.sk_spawning_km, 0) - SUM(COALESCE(b.sk_spawning_km, 0)))::numeric, 2) sk_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.sk_rearing_km, 0) - SUM(COALESCE(b.sk_rearing_km, 0)))::numeric, 2) sk_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.sk_rearing_ha, 0) - SUM(COALESCE(b.sk_rearing_km, 0)))::numeric, 2) sk_rearing_belowupstrbarriers_ha  ,
  ROUND((COALESCE(a.st_spawning_km, 0) - SUM(COALESCE(b.st_spawning_km, 0)))::numeric, 2) st_spawning_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.st_rearing_km, 0) - SUM(COALESCE(b.st_rearing_km, 0)))::numeric, 2) st_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.all_spawning_km, 0) - SUM(COALESCE(b.all_spawning_km, 0)))::numeric, 2) all_spawning_belowupstrbarriers_km,
  ROUND((COALESCE(a.all_rearing_km, 0) - SUM(COALESCE(b.all_rearing_km, 0)))::numeric, 2) all_rearing_belowupstrbarriers_km  ,
  ROUND((COALESCE(a.all_spawningrearing_km, 0) - SUM(COALESCE(b.all_spawningrearing_km, 0)))::numeric, 2) all_spawningrearing_belowupstrbarriers_km

FROM bcfishpass.crossings a
INNER JOIN bcfishpass.crossings b
ON a.aggregated_crossings_id = b.crossings_dnstr[1]
WHERE 
  b.barrier_status IN ('BARRIER', 'POTENTIAL') AND 
  a.barrier_status = 'PASSABLE' AND 
  a.blue_line_key = a.watershed_key
GROUP BY a.aggregated_crossings_id
)

UPDATE bcfishpass.crossings p
SET
  total_belowupstrbarriers_network_km = r.total_belowupstrbarriers_network_km,
  total_belowupstrbarriers_stream_km = r.total_belowupstrbarriers_stream_km,
  total_belowupstrbarriers_lakereservoir_ha = r.total_belowupstrbarriers_lakereservoir_ha,
  total_belowupstrbarriers_wetland_ha = r.total_belowupstrbarriers_wetland_ha,
  total_belowupstrbarriers_slopeclass03_waterbodies_km = r.total_belowupstrbarriers_slopeclass03_waterbodies_km,
  total_belowupstrbarriers_slopeclass03_km = r.total_belowupstrbarriers_slopeclass03_km,
  total_belowupstrbarriers_slopeclass05_km = r.total_belowupstrbarriers_slopeclass05_km,
  total_belowupstrbarriers_slopeclass08_km = r.total_belowupstrbarriers_slopeclass08_km,
  total_belowupstrbarriers_slopeclass15_km = r.total_belowupstrbarriers_slopeclass15_km,
  total_belowupstrbarriers_slopeclass22_km = r.total_belowupstrbarriers_slopeclass22_km,
  total_belowupstrbarriers_slopeclass30_km = r.total_belowupstrbarriers_slopeclass30_km,
  ch_co_sk_belowupstrbarriers_network_km = r.ch_co_sk_belowupstrbarriers_network_km,
  ch_co_sk_belowupstrbarriers_stream_km = r.ch_co_sk_belowupstrbarriers_stream_km,
  ch_co_sk_belowupstrbarriers_lakereservoir_ha = r.ch_co_sk_belowupstrbarriers_lakereservoir_ha,
  ch_co_sk_belowupstrbarriers_wetland_ha = r.ch_co_sk_belowupstrbarriers_wetland_ha,
  ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km = r.ch_co_sk_belowupstrbarriers_slopeclass03_waterbodies_km,
  ch_co_sk_belowupstrbarriers_slopeclass03_km = r.ch_co_sk_belowupstrbarriers_slopeclass03_km,
  ch_co_sk_belowupstrbarriers_slopeclass05_km = r.ch_co_sk_belowupstrbarriers_slopeclass05_km,
  ch_co_sk_belowupstrbarriers_slopeclass08_km = r.ch_co_sk_belowupstrbarriers_slopeclass08_km,
  ch_co_sk_belowupstrbarriers_slopeclass15_km = r.ch_co_sk_belowupstrbarriers_slopeclass15_km,
  ch_co_sk_belowupstrbarriers_slopeclass22_km = r.ch_co_sk_belowupstrbarriers_slopeclass22_km,
  ch_co_sk_belowupstrbarriers_slopeclass30_km = r.ch_co_sk_belowupstrbarriers_slopeclass30_km,
  st_belowupstrbarriers_network_km = r.st_belowupstrbarriers_network_km,
  st_belowupstrbarriers_stream_km = r.st_belowupstrbarriers_stream_km,
  st_belowupstrbarriers_lakereservoir_ha = r.st_belowupstrbarriers_lakereservoir_ha,
  st_belowupstrbarriers_wetland_ha = r.st_belowupstrbarriers_wetland_ha,
  st_belowupstrbarriers_slopeclass03_km = r.st_belowupstrbarriers_slopeclass03_km,
  st_belowupstrbarriers_slopeclass05_km = r.st_belowupstrbarriers_slopeclass05_km,
  st_belowupstrbarriers_slopeclass08_km = r.st_belowupstrbarriers_slopeclass08_km,
  st_belowupstrbarriers_slopeclass15_km = r.st_belowupstrbarriers_slopeclass15_km,
  st_belowupstrbarriers_slopeclass22_km = r.st_belowupstrbarriers_slopeclass22_km,
  st_belowupstrbarriers_slopeclass30_km = r.st_belowupstrbarriers_slopeclass30_km,
  wct_belowupstrbarriers_network_km = r.wct_belowupstrbarriers_network_km,
  wct_belowupstrbarriers_stream_km = r.wct_belowupstrbarriers_stream_km,
  wct_belowupstrbarriers_lakereservoir_ha = r.wct_belowupstrbarriers_lakereservoir_ha,
  wct_belowupstrbarriers_wetland_ha = r.wct_belowupstrbarriers_wetland_ha,
  wct_belowupstrbarriers_slopeclass03_km = r.wct_belowupstrbarriers_slopeclass03_km,
  wct_belowupstrbarriers_slopeclass05_km = r.wct_belowupstrbarriers_slopeclass05_km,
  wct_belowupstrbarriers_slopeclass08_km = r.wct_belowupstrbarriers_slopeclass08_km,
  wct_belowupstrbarriers_slopeclass15_km = r.wct_belowupstrbarriers_slopeclass15_km,
  wct_belowupstrbarriers_slopeclass22_km = r.wct_belowupstrbarriers_slopeclass22_km,
  wct_belowupstrbarriers_slopeclass30_km = r.wct_belowupstrbarriers_slopeclass30_km,

  ch_spawning_belowupstrbarriers_km = r.ch_spawning_belowupstrbarriers_km,
  ch_rearing_belowupstrbarriers_km = r.ch_rearing_belowupstrbarriers_km,
  co_spawning_belowupstrbarriers_km = r.co_spawning_belowupstrbarriers_km,
  co_rearing_belowupstrbarriers_km = r.co_rearing_belowupstrbarriers_km,
  co_rearing_belowupstrbarriers_ha = r.co_rearing_belowupstrbarriers_ha,
  sk_spawning_belowupstrbarriers_km = r.sk_spawning_belowupstrbarriers_km,
  sk_rearing_belowupstrbarriers_km = r.sk_rearing_belowupstrbarriers_km,
  sk_rearing_belowupstrbarriers_ha = r.sk_rearing_belowupstrbarriers_ha,
  st_spawning_belowupstrbarriers_km = r.st_spawning_belowupstrbarriers_km,
  st_rearing_belowupstrbarriers_km = r.st_rearing_belowupstrbarriers_km,
  all_spawning_belowupstrbarriers_km = r.all_spawning_belowupstrbarriers_km,
  all_rearing_belowupstrbarriers_km = r.all_rearing_belowupstrbarriers_km,
  all_spawningrearing_belowupstrbarriers_km = r.all_spawningrearing_belowupstrbarriers_km
FROM report r
WHERE p.aggregated_crossings_id = r.aggregated_crossings_id;