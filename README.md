
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

By default, `ki_station_list()` returns a tibble containing information
for all available stations for the selected hub.

``` r
# With swmc as the hub
ki_station_list(hub = 'swmc')
#> Warning: `...` is not empty.
#> 
#> We detected these problematic arguments:
#> * `needs_dots`
#> 
#> These dots only exist to allow future extensions and should be empty.
#> Did you misspecify an argument?
#> # A tibble: 3,903 x 5
#>    station_name        station_no   station_id station_latitude station_longitu~
#>    <chr>               <chr>        <chr>                 <dbl>            <dbl>
#>  1 A SNOW TEMPLATE     SNOW-WLF-XX  952125                 NA               NA  
#>  2 AA SNOW TEMPLATE    SNOW-WLF-TE~ 954599                 NA               NA  
#>  3 ABBOTSFORD A        CLIM-MSC-YXX 133535                 49.0           -122. 
#>  4 ABERDEEN            CLIM-MSC-ABR 121939                 45.5            -98.4
#>  5 ABITIBI CANYON      ZZSNOW-OPG-~ 148200                 49.9            -81.6
#>  6 ABITIBI LAKE        CLIM-MNR-ABL 121135                 48.7            -80.1
#>  7 ABITIBI RIVER AT A~ HYDAT-04ME0~ 136328                 49.9            -81.6
#>  8 ABITIBI RIVER AT I~ HYDAT-04MC0~ 136304                 48.8            -80.7
#>  9 ABITIBI RIVER AT I~ HYDAT-04ME0~ 136324                 49.6            -81.4
#> 10 ABITIBI RIVER AT O~ HYDAT-04ME0~ 136332                 50.2            -81.6
#> # ... with 3,893 more rows
```

### Get Time Series Information

You can use the `station_id` column returned using `ki_station_list()`
to figure out which time series are available for a given station.

#### One Station

``` r
# Single station_id
available_ts <- ki_timeseries_list(
  hub = 'swmc', 
  station_id = "144659"
  )

available_ts
#> Warning: `...` is not empty.
#> 
#> We detected these problematic arguments:
#> * `needs_dots`
#> 
#> These dots only exist to allow future extensions and should be empty.
#> Did you misspecify an argument?
#> # A tibble: 180 x 6
#>    station_name station_id ts_id ts_name from                to                 
#>    <chr>        <chr>      <chr> <chr>   <dttm>              <dttm>             
#>  1 Jackson Cre~ 144659     9489~ Precip~ 2007-06-01 05:00:00 2019-06-01 05:00:00
#>  2 Jackson Cre~ 144659     1139~ Precip~ 2007-06-19 00:00:00 2019-05-21 12:00:00
#>  3 Jackson Cre~ 144659     9489~ TAir.M~ 2007-06-01 05:00:00 2020-06-01 05:00:00
#>  4 Jackson Cre~ 144659     9490~ LVL.15~ 2005-12-26 05:00:00 2020-07-11 09:30:00
#>  5 Jackson Cre~ 144659     9490~ LVL.Da~ 2005-12-26 05:00:00 2020-07-10 05:00:00
#>  6 Jackson Cre~ 144659     9490~ LVL.Ye~ 2005-01-01 05:00:00 2021-01-01 05:00:00
#>  7 Jackson Cre~ 144659     9490~ Q.DayM~ 2005-12-26 05:00:00 2020-07-10 05:00:00
#>  8 Jackson Cre~ 144659     1166~ Soil C~ 2018-01-01 05:00:00 2021-01-01 05:00:00
#>  9 Jackson Cre~ 144659     1166~ Soil C~ 2018-04-01 05:00:00 2020-06-01 05:00:00
#> 10 Jackson Cre~ 144659     1166~ Soil C~ 2018-01-01 05:00:00 2021-01-01 05:00:00
#> # ... with 170 more rows
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
#> Warning: `...` is not empty.
#> 
#> We detected these problematic arguments:
#> * `needs_dots`
#> 
#> These dots only exist to allow future extensions and should be empty.
#> Did you misspecify an argument?
#> # A tibble: 257 x 6
#>    station_name station_id ts_id ts_name from                to                 
#>    <chr>        <chr>      <chr> <chr>   <dttm>              <dttm>             
#>  1 Oshawa Cree~ 144342     1143~ Precip~ 2001-01-01 05:00:00 2020-07-12 05:00:00
#>  2 Oshawa Cree~ 144342     9455~ TWater~ 2011-01-01 05:00:00 2021-01-01 05:00:00
#>  3 Oshawa Cree~ 144342     9456~ LVL.1.O 1986-09-01 06:00:00 2020-07-11 10:15:00
#>  4 Oshawa Cree~ 144342     9456~ LVL.Mo~ 1986-09-01 05:00:00 2020-06-01 05:00:00
#>  5 Oshawa Cree~ 144342     1124~ WWP_Al~ 1900-01-01 05:00:00 1900-01-01 05:00:00
#>  6 Oshawa Cree~ 144342     9456~ Q.Base~ 1986-09-01 09:00:00 2005-04-28 16:30:00
#>  7 Oshawa Cree~ 144342     9456~ Q.RunO~ 1986-09-01 09:00:00 2005-04-28 16:30:00
#>  8 Oshawa Cree~ 144342     9456~ Q.DayM~ 1986-09-01 05:00:00 2020-07-10 05:00:00
#>  9 Jackson Cre~ 144659     9489~ Precip~ 2007-06-01 05:00:00 2019-06-01 05:00:00
#> 10 Jackson Cre~ 144659     1139~ Precip~ 2007-06-19 00:00:00 2019-05-21 12:00:00
#> # ... with 247 more rows
```

### Get Time Series Values

You can now use the `ts_id` column in the tibble produced by
`ki_timeseries_list()` to query values for chosen time series.

By default this will return values for the past 24 hours. You can
specify the dates you’re interested in by setting `start_date` and
`end_date`. These should be set as date strings with the format
‘YYYY-mm-dd’.

You can pass either a single or multiple `ts_id`(s).

#### One Time Series

``` r
# Past 24 hours
my_values <- ki_timeseries_values(
  hub = 'swmc', 
  ts_id = '966435042'
  )
#> No start or end date provided, trying to return data for past 24 hours

my_values
#> Warning: `...` is not empty.
#> 
#> We detected these problematic arguments:
#> * `needs_dots`
#> 
#> These dots only exist to allow future extensions and should be empty.
#> Did you misspecify an argument?
#> # A tibble: 417 x 7
#>    Timestamp           Value ts_name ts_id   Units station_name       station_id
#>    <dttm>              <dbl> <chr>   <chr>   <chr> <chr>              <chr>     
#>  1 2020-07-10 00:00:00  24.2 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#>  2 2020-07-10 00:05:00  24.2 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#>  3 2020-07-10 00:10:00  24.3 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#>  4 2020-07-10 00:15:00  24.3 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#>  5 2020-07-10 00:20:00  24.3 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#>  6 2020-07-10 00:25:00  24.3 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#>  7 2020-07-10 00:30:00  24.3 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#>  8 2020-07-10 00:35:00  24.3 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#>  9 2020-07-10 00:40:00  24.2 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#> 10 2020-07-10 00:45:00  24.2 LVL.1.O 966435~ m     Attawapiskat Rive~ 146273    
#> # ... with 407 more rows
```

#### Multiple Time Series

``` r
# Specified date, multiple time series
my_ts_ids <- c("1125831042","908195042")
my_values <- ki_timeseries_values(
  hub = 'swmc',
  ts_id = my_ts_ids,
  start_date = "2015-08-28",
  end_date = "2018-09-13"
  )

my_values
#> Warning: `...` is not empty.
#> 
#> We detected these problematic arguments:
#> * `needs_dots`
#> 
#> These dots only exist to allow future extensions and should be empty.
#> Did you misspecify an argument?
#> # A tibble: 1,264 x 7
#>    Timestamp           Value ts_name   ts_id   Units station_name     station_id
#>    <dttm>              <dbl> <chr>     <chr>   <chr> <chr>            <chr>     
#>  1 2015-09-06 05:00:00  0.19 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#>  2 2015-09-17 05:00:00  0.18 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#>  3 2015-09-26 05:00:00  0.19 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#>  4 2015-09-27 05:00:00  0.19 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#>  5 2015-09-28 05:00:00  0.19 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#>  6 2015-10-03 05:00:00  0.21 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#>  7 2015-10-08 05:00:00  0.22 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#>  8 2015-10-12 05:00:00  0.24 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#>  9 2015-10-24 05:00:00  0.41 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#> 10 2015-11-11 05:00:00  0.42 Q.DayBas~ 112583~ cumec Chippewa Creek ~ 140764    
#> # ... with 1,254 more rows
```

## Using Other Hubs

You can use this package for a KiWIS hub not included in this list by
feeding the location of the API service to the `hub` argument.

For instance: If your URL looks like

`http://kiwis.kisters.de/KiWIS/KiWIS?datasource=0&service=kisters&type=queryServices&request=getrequestinfo`

specify the `hub` argument with

`http://kiwis.kisters.de/KiWIS/KiWIS?`

If you’d like to have a hub added to the defaults, please [Submit an
Issue](https://github.com/rywhale/kiwisR/issues)
