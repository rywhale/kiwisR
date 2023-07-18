
<!-- README.md is generated from README.Rmd. Please edit that file -->

# kiwisR <img src="tools/readme/kiwisR_small.png" align="right" />

<!-- badges: start -->

[![R-CMD-check](https://github.com/rywhale/kiwisR/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/rywhale/kiwisR/actions/workflows/R-CMD-check.yaml)
[![LICENSE](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/kiwisR)](https://cran.r-project.org/package=kiwisR)
[![CRAN
Download](https://cranlogs.r-pkg.org/badges/kiwisR?color=brightgreen)](https://CRAN.R-project.org/package=kiwisR)
<!-- badges: end -->

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
#> # A tibble: 3,802 × 5
#>    station_name         station_no station_id station_latitude station_longitude
#>    <chr>                <chr>      <chr>                 <dbl>             <dbl>
#>  1 A SNOW TEMPLATE      SNOW-WLF-… 952125                 NA                NA  
#>  2 AA SNOW TEMPLATE     SNOW-WLF-… 954599                 NA                NA  
#>  3 ABERDEEN             CLIM-MSC-… 121939                 45.5             -98.4
#>  4 ABITIBI CANYON       ZZSNOW-OP… 148200                 49.9             -81.6
#>  5 ABITIBI LAKE         CLIM-MNR-… 121135                 48.7             -80.1
#>  6 ABITIBI RIVER AT AB… HYDAT-04M… 136328                 49.9             -81.6
#>  7 ABITIBI RIVER AT IR… HYDAT-04M… 136304                 48.8             -80.7
#>  8 ABITIBI RIVER AT IS… HYDAT-04M… 136324                 49.6             -81.4
#>  9 Abitibi River at On… WSC-04ME0… 146775                 50.6             -81.4
#> 10 ABITIBI RIVER AT OT… HYDAT-04M… 136332                 50.2             -81.6
#> # ℹ 3,792 more rows
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
#> # A tibble: 226 × 6
#>    station_name station_id ts_id ts_name from                to                 
#>    <chr>        <chr>      <chr> <chr>   <dttm>              <dttm>             
#>  1 Jackson Cre… 144659     1143… 3Month… 2000-02-01 05:00:00 2035-01-01 05:00:00
#>  2 Jackson Cre… 144659     1143… 18Mont… 2000-02-01 05:00:00 2035-01-01 05:00:00
#>  3 Jackson Cre… 144659     1143… MonthT… 2000-02-01 05:00:00 2035-01-01 05:00:00
#>  4 Jackson Cre… 144659     9490… LVL.15… 2005-12-26 05:00:00 2023-07-18 10:00:00
#>  5 Jackson Cre… 144659     9490… LVL.Da… 2005-12-26 05:00:00 2023-07-17 05:00:00
#>  6 Jackson Cre… 144659     9490… LVL.Ye… 2005-01-01 05:00:00 2023-01-01 05:00:00
#>  7 Jackson Cre… 144659     1243… WWP.St… 1985-01-01 05:00:00 2025-01-01 05:00:00
#>  8 Jackson Cre… 144659     1166… Water … 2018-04-23 05:00:00 2023-07-17 05:00:00
#>  9 Jackson Cre… 144659     1184… SoilCo… 2019-01-16 05:00:00 2023-07-17 05:00:00
#> 10 Jackson Cre… 144659     1184… SoilCo… 2019-01-16 14:00:00 2023-07-18 10:00:00
#> # ℹ 216 more rows
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
#> # A tibble: 336 × 6
#>    station_name station_id ts_id ts_name from                to                 
#>    <chr>        <chr>      <chr> <chr>   <dttm>              <dttm>             
#>  1 Oshawa Cree… 144342     1143… Precip… 2001-01-01 05:00:00 2023-07-19 05:00:00
#>  2 Oshawa Cree… 144342     1331… Precip… NA                  NA                 
#>  3 Oshawa Cree… 144342     9455… Precip… 1990-08-01 05:00:00 2023-07-01 05:00:00
#>  4 Oshawa Cree… 144342     9455… Precip… 1990-01-01 05:00:00 2023-01-01 05:00:00
#>  5 Oshawa Cree… 144342     1143… Precip… 1990-08-01 05:00:00 2023-08-01 05:00:00
#>  6 Oshawa Cree… 144342     9455… Precip… 1990-08-01 05:00:00 2023-07-17 05:00:00
#>  7 Oshawa Cree… 144342     1140… Precip… 2005-01-01 06:00:00 2023-07-18 12:00:00
#>  8 Oshawa Cree… 144342     9455… Precip… 1990-08-01 10:00:00 2023-07-18 10:00:00
#>  9 Oshawa Cree… 144342     1143… Precip… 2000-02-01 05:00:00 2035-01-01 05:00:00
#> 10 Oshawa Cree… 144342     1143… Precip… 2000-01-01 05:00:00 2000-12-01 05:00:00
#> # ℹ 326 more rows
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
#> # A tibble: 429 × 7
#>    Timestamp           Value ts_name ts_id     Units station_name     station_id
#>    <dttm>              <dbl> <chr>   <chr>     <chr> <chr>            <chr>     
#>  1 2023-07-17 00:00:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#>  2 2023-07-17 00:05:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#>  3 2023-07-17 00:10:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#>  4 2023-07-17 00:15:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#>  5 2023-07-17 00:20:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#>  6 2023-07-17 00:25:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#>  7 2023-07-17 00:30:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#>  8 2023-07-17 00:35:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#>  9 2023-07-17 00:40:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#> 10 2023-07-17 00:45:00  23.0 LVL.1.O 966435042 m     Attawapiskat Ri… 146273    
#> # ℹ 419 more rows
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
#> # A tibble: 1,264 × 7
#>    Timestamp           Value ts_name       ts_id   Units station_name station_id
#>    <dttm>              <dbl> <chr>         <chr>   <chr> <chr>        <chr>     
#>  1 2015-09-06 05:00:00  0.19 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#>  2 2015-09-17 05:00:00  0.18 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#>  3 2015-09-26 05:00:00  0.19 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#>  4 2015-09-27 05:00:00  0.19 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#>  5 2015-09-28 05:00:00  0.19 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#>  6 2015-10-03 05:00:00  0.21 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#>  7 2015-10-08 05:00:00  0.22 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#>  8 2015-10-12 05:00:00  0.24 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#>  9 2015-10-24 05:00:00  0.41 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#> 10 2015-11-11 05:00:00  0.42 Q.DayBaseflow 112583… cumec Chippewa Cr… 140764    
#> # ℹ 1,254 more rows
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

## Contributing

See
[here](https://github.com/rywhale/kiwisR/blob/master/.github/CONTRIBUTING.md)
if you’d like to contribute.
