
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kiwisR <img src="tools/readme/kiwisR_small.png" align="right" />

![Travis-CI Build
Status](https://travis-ci.org/rywhale/kiwisR.svg?branch=master)
[![LICENSE](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/kiwisR)](https://cran.r-project.org/package=kiwisR)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/kiwisR?color=brightgreen)](https://CRAN.R-project.org/package=kiwisR)

## Overview

A wrapper for querying [KISTERS WISKI
databases](https://www.kisters.net/NA/products/wiski/) via the [KiWIS
API](https://water.kisters.de/en/technology-trends/kisters-and-open-data/).
Users can toggle between various databases by specifying the `hub`
argument. Currently, the default hubs are:

  - *kisters* : [KISTERS KiWIS Example
    Server](http://kiwis.kisters.de/KiWIS2/index.html)
  - *swmc* : [Ontario Surface Water Monitoring
    Centre](https://www.ontario.ca/page/surface-water-monitoring)
  - *quinte* : [Quinte Conservation
    Authority](http://quinteconservation.ca/site/)

All data is returned as tidy
[tibbles](https://CRAN.R-project.org/package=tibble).

## Installation

You can install `kiwisR` from CRAN:

``` r
install.packages('kiwisR')
```

To install the development version of `kiwisR` you first need to install
`devtools`.

``` r
if(!requireNamespace("devtools")) install.packages("devtools")
devtools::install_github('rywhale/kiwisR')
```

Then load the package with

``` r
library(kiwisR)
```

## Usage

### Get Station Information

#### All Available Stations

By default, `ki_station_list()` returns a tibble containing information
for all available stations for the selected hub.

``` r
# With swmc as the hub
ki_station_list(hub = 'swmc')
#> # A tibble: 3,554 x 5
#>    station_name   station_no  station_id station_latitude station_longitud~
#>    <chr>          <chr>       <chr>      <chr>                        <dbl>
#>  1 2019SurgeUpgr~ New-000019  642499     ""                            NA  
#>  2 2019SurgeUpgr~ New-000020  642538     ""                            NA  
#>  3 ABBOTSFORD A   CLIM-MSC-Y~ 133535     49.03307961                 -122. 
#>  4 ABERDEEN       CLIM-MSC-A~ 121939     45.45000031                  -98.4
#>  5 ABITIBI CANYON ZZSNOW-OPG~ 148200     49.9164159                   -81.6
#>  6 ABITIBI LAKE   CLIM-MNR-A~ 121135     48.66141167                  -80.1
#>  7 ABITIBI RIVER~ HYDAT-04ME~ 136328     49.8797496                   -81.6
#>  8 ABITIBI RIVER~ HYDAT-04MC~ 136304     48.76000036                  -80.7
#>  9 ABITIBI RIVER~ HYDAT-04ME~ 136324     49.56974984                  -81.4
#> 10 ABITIBI RIVER~ HYDAT-04ME~ 136332     50.17974961                  -81.6
#> # ... with 3,544 more rows
```

#### Within Bounding Box

You can also specify a bounding box to look within for stations. The
bounding box should be either

  - A vector like this `c(min_x, min_y, max_x, max_y)`
  - Or a comma separated string like this `"min_x,min_y,max_x,max_y"`

<!-- end list -->

``` r
# With vector
my_bounding_box <- c("-80.126038", "43.458297", "-79.002481", "43.969098")
my_stations <- ki_station_list(
  hub = 'swmc', 
  bounding_box = my_bounding_box
  )

my_stations
#> # A tibble: 173 x 5
#>    station_name   station_no  station_id station_latitude station_longitud~
#>    <chr>          <chr>       <chr>      <chr>                        <dbl>
#>  1 ALBION HILLS   SNOW-MNR-2~ 137457     43.93308257                  -79.8
#>  2 Acton Sewage ~ ZZ-WSC-ACT~ 149765     43.63113873                  -80.0
#>  3 BELFOUNTAIN    ZZSNOW-MNR~ 147848     43.79974939                  -80.0
#>  4 BELFOUNTAIN2   ZZSNOW-MNR~ 147864     43.79974999                  -80.0
#>  5 BOYD           SNOW-MNR-2~ 137465     43.81641643                  -79.6
#>  6 BROUGHAM CREE~ HYDAT-02HC~ 135564     43.91000014                  -79.1
#>  7 BRUCE'S MILL   SNOW-MNR-2~ 137477     43.94974951                  -79.4
#>  8 BUTTONVILLE A  CLIM-MSC-Y~ 132165     43.86666985                  -79.4
#>  9 Black Creek b~ WSC-02HB024 247406     43.62916667                  -80.0
#> 10 Black Creek n~ WSC-02HC027 144081     43.67308155                  -79.5
#> # ... with 163 more rows

# With comma separated string
my_bounding_box <- "-80.126038,43.458297,-79.002481,43.969098"
my_stations <- ki_station_list(hub = 'swmc', bounding_box = my_bounding_box)
my_stations
#> # A tibble: 173 x 5
#>    station_name   station_no  station_id station_latitude station_longitud~
#>    <chr>          <chr>       <chr>      <chr>                        <dbl>
#>  1 ALBION HILLS   SNOW-MNR-2~ 137457     43.93308257                  -79.8
#>  2 Acton Sewage ~ ZZ-WSC-ACT~ 149765     43.63113873                  -80.0
#>  3 BELFOUNTAIN    ZZSNOW-MNR~ 147848     43.79974939                  -80.0
#>  4 BELFOUNTAIN2   ZZSNOW-MNR~ 147864     43.79974999                  -80.0
#>  5 BOYD           SNOW-MNR-2~ 137465     43.81641643                  -79.6
#>  6 BROUGHAM CREE~ HYDAT-02HC~ 135564     43.91000014                  -79.1
#>  7 BRUCE'S MILL   SNOW-MNR-2~ 137477     43.94974951                  -79.4
#>  8 BUTTONVILLE A  CLIM-MSC-Y~ 132165     43.86666985                  -79.4
#>  9 Black Creek b~ WSC-02HB024 247406     43.62916667                  -80.0
#> 10 Black Creek n~ WSC-02HC027 144081     43.67308155                  -79.5
#> # ... with 163 more rows
```

#### By Search Term

You can also narrow search results using a search term. This supports
the use of `*` as a wildcard.

``` r
# All stations starting with 'A'
my_stations <- ki_station_list(
  hub = 'swmc', 
  search_term = "A*"
  )

my_stations
#> # A tibble: 127 x 5
#>    station_name   station_no  station_id station_latitude station_longitud~
#>    <chr>          <chr>       <chr>      <chr>                        <dbl>
#>  1 ABBOTSFORD A   CLIM-MSC-Y~ 133535     49.03307961                 -122. 
#>  2 ABERDEEN       CLIM-MSC-A~ 121939     45.45000031                  -98.4
#>  3 ABITIBI CANYON ZZSNOW-OPG~ 148200     49.9164159                   -81.6
#>  4 ABITIBI LAKE   CLIM-MNR-A~ 121135     48.66141167                  -80.1
#>  5 ABITIBI RIVER~ HYDAT-04ME~ 136328     49.8797496                   -81.6
#>  6 ABITIBI RIVER~ HYDAT-04MC~ 136304     48.76000036                  -80.7
#>  7 ABITIBI RIVER~ HYDAT-04ME~ 136324     49.56974984                  -81.4
#>  8 ABITIBI RIVER~ HYDAT-04ME~ 136332     50.17974961                  -81.6
#>  9 ABITIBI RIVER~ HYDAT-04MC~ 136308     48.74974975                  -80.6
#> 10 ACTINOLITE (P~ ZZSNOW-MNR~ 147948     44.54974954                  -77.3
#> # ... with 117 more rows

# All stations starting with 'Oshawa'
my_stations <- ki_station_list(
  hub = 'swmc', 
  search_term = "Oshawa*"
  )

my_stations
#> # A tibble: 3 x 5
#>   station_name   station_no station_id station_latitude station_longitude[~
#>   <chr>          <chr>      <chr>      <chr>                          <dbl>
#> 1 OSHAWA A       CLIM-MSC-~ 132486     43.91666694                    -78.9
#> 2 Oshawa Airpor~ Wiski-0262 458060     43.923888                      -78.9
#> 3 Oshawa Creek ~ WSC-02HD0~ 144342     43.92808201                    -78.9
```

#### By Group

You can retrieve a list of available station and time series groups
using `ki_group_list`

``` r
all_groups <- ki_group_list(hub = 'swmc')
all_groups
#> # A tibble: 164 x 3
#>    group_name                         group_id group_type
#>    <chr>                              <chr>    <chr>     
#>  1 Ausable Bayfield CA                169270   station   
#>  2 WWW_Extranet                       181729   station   
#>  3 All Active Stream Gauges           199135   station   
#>  4 All MOE COA-RAC CA                 199818   station   
#>  5 All Trent Severn Waterway          199828   station   
#>  6 Archived Streamgauging Stations CA 199829   station   
#>  7 Aurora MNR                         199830   station   
#>  8 Bancroft MNR                       199831   station   
#>  9 Bracebridge MNR                    199832   station   
#> 10 Cataraqui CA                       199833   station   
#> # ... with 154 more rows
```

You can then pass values from the `group_id` column to `ki_station_list`
to filter for only stations included in the group

``` r
group_stations <- ki_station_list(
  hub = 'swmc', 
  group_id = '169270'
  )

group_stations
#> # A tibble: 25 x 5
#>    station_name   station_no station_id station_latitude station_longitude~
#>    <chr>          <chr>      <chr>      <chr>                         <dbl>
#>  1 Ausable River~ WSC-02FF0~ 142338     43.18974998                   -81.8
#>  2 Ausable River~ Wiski-0015 138406     43.23280027                   -81.9
#>  3 Ausable River~ WSC-02FF0~ 142324     43.35974795                   -81.5
#>  4 Ausable River~ WSC-02FF0~ 142269     43.07002734                   -81.7
#>  5 BRUCEFIELD (C~ SNOW-MNR-~ 137228     43.54974977                   -81.5
#>  6 Bayfield Rive~ WSC-02FF0~ 142296     43.55030536                   -81.6
#>  7 Black Creek n~ WSC-02FF0~ 142392     43.41891169                   -81.5
#>  8 Garvey Glenn ~ Wiski-0202 139749     43.981281                     -81.7
#>  9 Gully Creek a~ Wiski-0200 139731     43.649424                     -81.7
#> 10 KHIVA (OROURK~ SNOW-MNR-~ 137232     43.29974941                   -81.6
#> # ... with 15 more rows
```

### Get Time Series Information

You can use the `station_id` column returned using `ki_station_list()`
to figure out which time series are available for a given station.

By default, this will also return `to` and `from` columns indicating the
period of record for that time series. You can speed up queries by
setting the `coverage` argument to `FALSE`.

#### One Station

``` r
# Single station_id
available_ts <- ki_timeseries_list(
  hub = 'swmc', 
  station_id = "144659"
  )

available_ts
#> # A tibble: 143 x 6
#>    station_name station_id ts_id ts_name from               
#>    <chr>        <chr>      <chr> <chr>   <dttm>             
#>  1 Jackson Cre~ 144659     9490~ Q.DayM~ 2005-12-26 05:00:00
#>  2 Jackson Cre~ 144659     9490~ Q.1.O   NA                 
#>  3 Jackson Cre~ 144659     9490~ Q.DayM~ 2005-12-26 05:00:00
#>  4 Jackson Cre~ 144659     9490~ Q.15    2005-12-26 05:00:00
#>  5 Jackson Cre~ 144659     9490~ Q.Mont~ 2005-12-01 05:00:00
#>  6 Jackson Cre~ 144659     9490~ Q.Year~ 2005-01-01 05:00:00
#>  7 Jackson Cre~ 144659     9490~ Q.DayM~ 2006-04-01 05:00:00
#>  8 Jackson Cre~ 144659     9490~ Q.Year~ 2007-01-01 05:00:00
#>  9 Jackson Cre~ 144659     1126~ Q.DayB~ 2005-12-26 05:00:00
#> 10 Jackson Cre~ 144659     1126~ Q.DayR~ 2005-12-26 05:00:00
#> # ... with 133 more rows, and 1 more variable: to <dttm>

str(available_ts)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    143 obs. of  6 variables:
#>  $ station_name: chr  "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" ...
#>  $ station_id  : chr  "144659" "144659" "144659" "144659" ...
#>  $ ts_id       : chr  "949057042" "949048042" "949056042" "949049042" ...
#>  $ ts_name     : chr  "Q.DayMean" "Q.1.O" "Q.DayMax" "Q.15" ...
#>  $ from        : POSIXct, format: "2005-12-26 05:00:00" NA ...
#>  $ to          : POSIXct, format: "2019-04-13 05:00:00" NA ...
```

#### Multiple Stations

If you provide a vector to `station_id`, the returned tibble will have
all the available time series from *all* stations. They can be
differentiated using the `station_name` column.

``` r
# Vector of station_ids
my_station_ids <- c("144659", "144342")

available_ts <- ki_timeseries_list(
  hub = 'swmc', 
  station_id = my_station_ids
  )

available_ts
#> # A tibble: 218 x 6
#>    station_name station_id ts_id ts_name from               
#>    <chr>        <chr>      <chr> <chr>   <dttm>             
#>  1 Jackson Cre~ 144659     9489~ Precip~ 2007-06-01 05:00:00
#>  2 Jackson Cre~ 144659     1139~ Precip~ 2007-06-19 00:00:00
#>  3 Jackson Cre~ 144659     1143~ Precip~ 2007-07-01 05:00:00
#>  4 Jackson Cre~ 144659     1139~ Precip~ 2007-06-19 00:00:00
#>  5 Jackson Cre~ 144659     9489~ Precip~ 2007-06-18 20:15:00
#>  6 Jackson Cre~ 144659     9489~ Precip~ 2007-06-18 05:00:00
#>  7 Jackson Cre~ 144659     1143~ Precip~ 2007-07-01 05:00:00
#>  8 Jackson Cre~ 144659     1143~ Precip~ 2007-06-18 05:00:00
#>  9 Jackson Cre~ 144659     9489~ Precip~ 2007-06-18 20:15:00
#> 10 Jackson Cre~ 144659     1143~ Precip~ 2000-02-01 05:00:00
#> # ... with 208 more rows, and 1 more variable: to <dttm>
```

### Get Time Series Values

You can now use the `ts_id` column in the tibble produced by
`ki_timeseries_list()` to query values for chosen time series.

By default this will return values for the past 24 hours. You can
specify the dates you’re interested in by setting `start_date` and
`end_date`. These should be set as date strings with the format
‘YYYY-mm-dd’.

#### One Time Series

``` r
# Past 24 hours
my_values <- ki_timeseries_values(
  hub = 'swmc', 
  ts_id = '948928042'
  )
#> No start or end date provided, trying to return data for past 24 hours

my_values
#> # A tibble: 170 x 3
#>    Timestamp           Precip Units
#>    <dttm>               <dbl> <chr>
#>  1 2019-04-11 00:00:00      0 mm   
#>  2 2019-04-11 00:15:00      0 mm   
#>  3 2019-04-11 00:30:00      0 mm   
#>  4 2019-04-11 00:45:00      0 mm   
#>  5 2019-04-11 01:00:00      0 mm   
#>  6 2019-04-11 01:15:00      0 mm   
#>  7 2019-04-11 01:30:00      0 mm   
#>  8 2019-04-11 01:45:00      0 mm   
#>  9 2019-04-11 02:00:00      0 mm   
#> 10 2019-04-11 02:15:00      0 mm   
#> # ... with 160 more rows
```

#### Multiple Time Series

If you provide a vector to `ts_id`, a list of tibbles will be returned.
Each tibble is named according to the station name and the time series’
parameter.

``` r
# Specified date, multiple time series
my_ts_ids <- c("948928042", "948603042")
my_values <- ki_timeseries_values(
  hub = 'swmc',
  ts_id = my_ts_ids,
  start_date = "2017-08-28",
  end_date = "2017-09-13"
  )

my_values
#> $`Jackson Creek at Jackson Heights (Precip)`
#> # A tibble: 1,632 x 3
#>    Timestamp           Precip Units
#>    <dttm>               <dbl> <chr>
#>  1 2017-08-28 00:00:00      0 mm   
#>  2 2017-08-28 00:15:00      0 mm   
#>  3 2017-08-28 00:30:00      0 mm   
#>  4 2017-08-28 00:45:00      0 mm   
#>  5 2017-08-28 01:00:00      0 mm   
#>  6 2017-08-28 01:15:00      0 mm   
#>  7 2017-08-28 01:30:00      0 mm   
#>  8 2017-08-28 01:45:00      0 mm   
#>  9 2017-08-28 02:00:00      0 mm   
#> 10 2017-08-28 02:15:00      0 mm   
#> # ... with 1,622 more rows
#> 
#> $`Jackson Creek at Peterborough (Q)`
#> # A tibble: 17 x 3
#>    Timestamp               Q Units
#>    <dttm>              <dbl> <chr>
#>  1 2017-08-28 05:00:00 0.251 cumec
#>  2 2017-08-29 05:00:00 0.243 cumec
#>  3 2017-08-30 05:00:00 0.243 cumec
#>  4 2017-08-31 05:00:00 0.268 cumec
#>  5 2017-09-01 05:00:00 0.233 cumec
#>  6 2017-09-02 05:00:00 0.27  cumec
#>  7 2017-09-03 05:00:00 0.908 cumec
#>  8 2017-09-04 05:00:00 1.30  cumec
#>  9 2017-09-05 05:00:00 0.762 cumec
#> 10 2017-09-06 05:00:00 0.412 cumec
#> 11 2017-09-07 05:00:00 0.444 cumec
#> 12 2017-09-08 05:00:00 0.377 cumec
#> 13 2017-09-09 05:00:00 0.374 cumec
#> 14 2017-09-10 05:00:00 0.372 cumec
#> 15 2017-09-11 05:00:00 0.365 cumec
#> 16 2017-09-12 05:00:00 0.349 cumec
#> 17 2017-09-13 05:00:00 0.332 cumec
```

## Using Other Hubs

You can use this package for a KiWIS hub not included in this list by
feeding the location of the API service to the `hub` argument.

For instance: If your URL looks
like

`http://kiwis.kisters.de/KiWIS/KiWIS?datasource=0&service=kisters&type=queryServices&request=getrequestinfo`

specify the `hub` argument with

`http://kiwis.kisters.de/KiWIS/KiWIS?`

If you’d like to have a hub added to the defaults, please [Submit an
Issue](https://github.com/rywhale/kiwisR/issues)
