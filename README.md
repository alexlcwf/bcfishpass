# bcfishpass

Scripts to prioritize assessment/remediation of potential barriers to fish passage, based primarily on stream gradient.

## Background

We generate a simple model of aquatic habitat connectivity by identifying natural barriers to fish passage (plus hydro dams that are not feasible to remediate) and classifying all streams not upstream of these barriers as *'potentially accessible'*.

On 'potentially accessible' streams, we can identify known barriers and additional anthropogenic features (primarily road/railway stream crossings, ie culverts) that are potentially barriers. To prioritize these features for assessment or remediation, we report on how much 'potentially accessible' aquatic habitat the barriers may obstruct.

We refine this model further with known fish observations. Depending on the modelling scenario, all aquatic habitat downstream of a given fish observation can be classified as 'observed accessbile', overriding any downstream barriers.


### 1. Generate 'potentially accessible' aquatic habitat

Using the BC Freshwater Atlas as the base for analysis, these 'definite' barrier features are located on the stream network:

- segments of >100m linear stream that are steeper than the user provided gradient threshold(s) based on swimming ability of species of interest (eg 15, 20, 25, 30)
- major dams
- waterfalls >5m
- points corresponding to other natural stream characteristics that are potential barriers to fish passage (eg subsurface flow, intermittent flow)

All aquatic habitat downstream of these points is classified as 'potentially accessible' to fish.  In the absence of any addtional anthropogenic barriers, anadramous species should be able to access all aquatic habitat below these 'definite' barriers. Note that these 'definite' barriers can be customized, not all intermittent flows are barriers to fish passage.

### 2. Generate 'observed accessible' aquatic habitat

Points from bcfishobs are loaded and stream segments below fish observations are identified. A user can then choose a species (or group of species) of interest and classify all aquatic habitat downstream of observations of this species as 'observed accessible' and optionally that downstream 'definite' barriers do not in fact restrict passage to this species.

### 3. Locate/generate anthropogenic barriers (culverts, dams, other)

Anthropogenic barriers to fish passage (with potential for remediation) such as non-hydro dams, PSCIS crossings are referenced to the stream network. Intersection points of the stream network and roads/railways are generated (modelled road/railway stream crossings).  We then prioritize these barriers/potential barriers for assessment or remediation by reporting on how much 'potentially accessible' aquatic habitat each barrier may block.

### 4. Generate an output

Based on the above features, we can define potentially accessible / potentially constrained aquatic habitat for different species and/or different regional scenarios.


## Requirements

- Postgresql/PostGIS (tested with v12.2/3.0.1)
- a FWA database loaded via [`fwapg`](https://github.com/smnorris/fwapg)
- [bcfishobs](https://github.com/smnorris/bcfishobs) (BC fish observations and obstacles)
- gradient barriers at 15/20/30 percent (from FPTWG)
- Python >=3.7
- [bcdata](https://github.com/smnorris/bcdata)
- [pgdata](https://github.com/smnorris/pgdata)
- [psql2csv](https://github.com/fphilipe/psql2csv)


## Setup

### Environment variables

Scripts depend on several environment variables that point your postgres database:

    export PGHOST=localhost
    export PGPORT=5432
    export PGDATABASE=mydb
    export PGUSER=postgres
    # put these together
    export DATABASE_URL='postgresql://'$PGUSER'@'$PGHOST':'$PGPORT'/'$PGDATABASE
    # and a OGR compatible string
    export PGOGR='host=localhost user=postgres dbname=mydb password=mypwd port=5432'


## Create modelled road-stream crossings

See [`modelled_road_stream_crossings.md`](`modelled_road_stream_crossings.md`) for more info.

## Clean PSCIS crossings and reference to stream network

See [`pscis_events.md`](pscis_events.md) for more info.

## Create individual barrier tables

    ./04_create_barriers.sh

## Segment the streams at barriers and observations

    ./05_segment_streams.sh

This script:

1. initializes a copy of the stream network for segmenting at all features of interest
2. breaks streams at 'definite' barriers, all streams downstream of these barriers are 'potentiallly accessible'
3. breaks streams at anthropogenic barriers, all streams upstream of these barriers are 'inaccessible'
4. breaks streams at fish observations, label all streams downstream of observations

## Label streams according to species model of interest

    ./06_model.sh


