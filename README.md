kiwisR
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
Overview
--------

A wrapper for querying KiWIS APIs to retrieve hydrometric data. Users can toggle between various databases by specifying the 'hub' argument. Currently, the default hubs are:

-   *swmc* : [Ontario Surface Water Monitoring Centre](https://www.ontario.ca/page/surface-water-monitoring)
-   *grand* : [Grand River Conservation Authority](https://www.grandriver.ca/en/index.aspx)
-   *quinte* : [Quinte Conservation Authority](http://quinteconservation.ca/site/)
-   *creditvalley* : [Credit Valley Conservation Authority](https://cvc.ca/)

All data is returned as tidy [tibbles](https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html).

Installation
------------

To install `kiwisR` you first need to install `remotes`.

``` r
install.packages("remotes")
remotes::install_github('rywhale/kiwisR')
```

Then load the package with

``` r
library(kiwisR)
```

Usage
-----

### Get Station Information

#### All Available Stations

By default, `ki_station_list()` returns a tibble containing information for all available stations for the select hub.

``` r
# With swmc as the hub
ki_station_list(hub = 'swmc')
#> # A tibble: 3,528 x 5
#>    station_name    station_no station_id station_latitude station_longitu~
#>    <chr>           <chr>      <chr>                 <dbl>            <dbl>
#>  1 ABBOTSFORD A    CLIM-MSC-~ 133535                 49.0           -122. 
#>  2 ABERDEEN        CLIM-MSC-~ 121939                 45.5            -98.4
#>  3 ABITIBI CANYON  ZZSNOW-OP~ 148200                 49.9            -81.6
#>  4 ABITIBI LAKE    CLIM-MNR-~ 121135                 48.7            -80.1
#>  5 ABITIBI RIVER ~ HYDAT-04M~ 136328                 49.9            -81.6
#>  6 ABITIBI RIVER ~ HYDAT-04M~ 136304                 48.8            -80.7
#>  7 ABITIBI RIVER ~ HYDAT-04M~ 136324                 49.6            -81.4
#>  8 ABITIBI RIVER ~ HYDAT-04M~ 136332                 50.2            -81.6
#>  9 ABITIBI RIVER ~ HYDAT-04M~ 136308                 48.7            -80.6
#> 10 ACTINOLITE (PR~ ZZSNOW-MN~ 147948                 44.5            -77.3
#> # ... with 3,518 more rows
```

#### Within Bounding Box

You can also specify a bounding box to look within for stations. The bounding box should be either

-   A vector like this `c(min_x, min_y, max_x, max_y)`
-   Or a comma separated string like this `"min_x,min_y,max_x,max_y"`

``` r
# With vector
my_bounding_box <- c("-80.126038", "43.458297", "-79.002481", "43.969098")
my_stations <- ki_station_list(hub = 'swmc', bounding_box = my_bounding_box)
my_stations
#> # A tibble: 176 x 5
#>    station_name    station_no station_id station_latitude station_longitu~
#>    <chr>           <chr>      <chr>                 <dbl>            <dbl>
#>  1 ALBION HILLS    SNOW-MNR-~ 137457                 43.9            -79.8
#>  2 Acton Sewage T~ ZZ-WSC-AC~ 149765                 43.6            -80.0
#>  3 BELFOUNTAIN     ZZSNOW-MN~ 147848                 43.8            -80.0
#>  4 BELFOUNTAIN2    ZZSNOW-MN~ 147864                 43.8            -80.0
#>  5 BOYD            SNOW-MNR-~ 137465                 43.8            -79.6
#>  6 BROUGHAM CREEK~ HYDAT-02H~ 135564                 43.9            -79.1
#>  7 BRUCE'S MILL    SNOW-MNR-~ 137477                 43.9            -79.4
#>  8 BUTTONVILLE A   CLIM-MSC-~ 132165                 43.9            -79.4
#>  9 Black Creek be~ WSC-02HB0~ 247406                 43.6            -80.0
#> 10 Black Creek ne~ WSC-02HC0~ 144081                 43.7            -79.5
#> # ... with 166 more rows

# With comma separated string
my_bounding_box <- "-80.126038,43.458297,-79.002481,43.969098"
my_stations <- ki_station_list(hub = 'swmc', bounding_box = my_bounding_box)
my_stations
#> # A tibble: 176 x 5
#>    station_name    station_no station_id station_latitude station_longitu~
#>    <chr>           <chr>      <chr>                 <dbl>            <dbl>
#>  1 ALBION HILLS    SNOW-MNR-~ 137457                 43.9            -79.8
#>  2 Acton Sewage T~ ZZ-WSC-AC~ 149765                 43.6            -80.0
#>  3 BELFOUNTAIN     ZZSNOW-MN~ 147848                 43.8            -80.0
#>  4 BELFOUNTAIN2    ZZSNOW-MN~ 147864                 43.8            -80.0
#>  5 BOYD            SNOW-MNR-~ 137465                 43.8            -79.6
#>  6 BROUGHAM CREEK~ HYDAT-02H~ 135564                 43.9            -79.1
#>  7 BRUCE'S MILL    SNOW-MNR-~ 137477                 43.9            -79.4
#>  8 BUTTONVILLE A   CLIM-MSC-~ 132165                 43.9            -79.4
#>  9 Black Creek be~ WSC-02HB0~ 247406                 43.6            -80.0
#> 10 Black Creek ne~ WSC-02HC0~ 144081                 43.7            -79.5
#> # ... with 166 more rows
```

#### By Search Term

You can also narrow search results using a search term. This supports the use of `*` as a wildcard.

``` r
# All stations starting with 'A'
my_stations <- ki_station_list(hub = 'swmc', search_term = "A*")
my_stations
#> # A tibble: 126 x 5
#>    station_name    station_no station_id station_latitude station_longitu~
#>    <chr>           <chr>      <chr>                 <dbl>            <dbl>
#>  1 ABBOTSFORD A    CLIM-MSC-~ 133535                 49.0           -122. 
#>  2 ABERDEEN        CLIM-MSC-~ 121939                 45.5            -98.4
#>  3 ABITIBI CANYON  ZZSNOW-OP~ 148200                 49.9            -81.6
#>  4 ABITIBI LAKE    CLIM-MNR-~ 121135                 48.7            -80.1
#>  5 ABITIBI RIVER ~ HYDAT-04M~ 136328                 49.9            -81.6
#>  6 ABITIBI RIVER ~ HYDAT-04M~ 136304                 48.8            -80.7
#>  7 ABITIBI RIVER ~ HYDAT-04M~ 136324                 49.6            -81.4
#>  8 ABITIBI RIVER ~ HYDAT-04M~ 136332                 50.2            -81.6
#>  9 ABITIBI RIVER ~ HYDAT-04M~ 136308                 48.7            -80.6
#> 10 ACTINOLITE (PR~ ZZSNOW-MN~ 147948                 44.5            -77.3
#> # ... with 116 more rows

# All stations starting with 'Oshawa'
my_stations <- ki_station_list(hub = 'swmc', search_term = "Oshawa*")
my_stations
#> # A tibble: 3 x 5
#>   station_name     station_no station_id station_latitude station_longitu~
#>   <chr>            <chr>      <chr>                 <dbl>            <dbl>
#> 1 OSHAWA A         CLIM-MSC-~ 132486                 43.9            -78.9
#> 2 Oshawa Airport ~ Wiski-0262 458060                 43.9            -78.9
#> 3 Oshawa Creek at~ WSC-02HD0~ 144342                 43.9            -78.9
```

### Get Time Series Information

You can use the `station_id` column returned using `ki_station_list()` to figure out which time series are available for a given station.

This will also return `to` and `from` columns indicating the period of record for that time series.

#### One Station

``` r
# Single station_id
available_ts <- ki_timeseries_list(hub = 'swmc', station_id = "144659")
available_ts
#> # A tibble: 130 x 6
#>    station_name          station_id ts_id   ts_name    from               
#>    <chr>                 <chr>      <chr>   <chr>      <dttm>             
#>  1 Jackson Creek at Jac~ 144659     949057~ Q.DayMean  2005-12-26 05:00:00
#>  2 Jackson Creek at Jac~ 144659     949048~ Q.1.O      NA                 
#>  3 Jackson Creek at Jac~ 144659     949056~ Q.DayMax   2005-12-26 05:00:00
#>  4 Jackson Creek at Jac~ 144659     949049~ Q.15       2005-12-26 05:00:00
#>  5 Jackson Creek at Jac~ 144659     949061~ Q.MonthMe~ 2005-12-01 05:00:00
#>  6 Jackson Creek at Jac~ 144659     949067~ Q.YearMin  2005-01-01 05:00:00
#>  7 Jackson Creek at Jac~ 144659     949058~ Q.DayMean~ 2006-04-01 05:00:00
#>  8 Jackson Creek at Jac~ 144659     949065~ Q.YearMax~ 2007-01-01 05:00:00
#>  9 Jackson Creek at Jac~ 144659     112605~ Q.DayBase~ 2005-12-26 05:00:00
#> 10 Jackson Creek at Jac~ 144659     112605~ Q.DayRuno~ 2005-12-26 05:00:00
#> # ... with 120 more rows, and 1 more variable: to <dttm>
str(available_ts)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    130 obs. of  6 variables:
#>  $ station_name: chr  "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" ...
#>  $ station_id  : chr  "144659" "144659" "144659" "144659" ...
#>  $ ts_id       : chr  "949057042" "949048042" "949056042" "949049042" ...
#>  $ ts_name     : chr  "Q.DayMean" "Q.1.O" "Q.DayMax" "Q.15" ...
#>  $ from        : POSIXct, format: "2005-12-26 05:00:00" NA ...
#>  $ to          : POSIXct, format: "2018-06-23 05:00:00" NA ...
```

#### Multiple Stations

If you provide a vector to `station_id`, the returned tibble will have all the available time series from *all* stations. They can be differentiated using the `station_name` column.

``` r
# Vector of station_ids
my_station_ids <- c("144659", "144342")

available_ts <- ki_timeseries_list(hub = 'swmc', station_id = my_station_ids)
available_ts
#> # A tibble: 259 x 6
#>    station_name          station_id ts_id   ts_name    from               
#>    <chr>                 <chr>      <chr>   <chr>      <dttm>             
#>  1 Jackson Creek at Jac~ 144659     949057~ Q.DayMean  2005-12-26 05:00:00
#>  2 Jackson Creek at Jac~ 144659     949048~ Q.1.O      NA                 
#>  3 Jackson Creek at Jac~ 144659     949056~ Q.DayMax   2005-12-26 05:00:00
#>  4 Jackson Creek at Jac~ 144659     949049~ Q.15       2005-12-26 05:00:00
#>  5 Jackson Creek at Jac~ 144659     949061~ Q.MonthMe~ 2005-12-01 05:00:00
#>  6 Jackson Creek at Jac~ 144659     949067~ Q.YearMin  2005-01-01 05:00:00
#>  7 Jackson Creek at Jac~ 144659     949058~ Q.DayMean~ 2006-04-01 05:00:00
#>  8 Jackson Creek at Jac~ 144659     949065~ Q.YearMax~ 2007-01-01 05:00:00
#>  9 Jackson Creek at Jac~ 144659     112605~ Q.DayBase~ 2005-12-26 05:00:00
#> 10 Jackson Creek at Jac~ 144659     112605~ Q.DayRuno~ 2005-12-26 05:00:00
#> # ... with 249 more rows, and 1 more variable: to <dttm>
```

### Get Time Series Values

You can now use the `ts_id` column in the tibble produced by `ki_timeseries_list()` to query values for chosen time series.

By default this will return values for the past 24 hours. You can specify the dates you're interested in by setting `start_date` and `end_date`. These should be set as date strings with the format 'YYYY-mm-dd'.

#### One Time Series

``` r
# Past 24 hours
my_values <- ki_timeseries_values(hub = 'swmc', ts_id = '948928042')
my_values
#> # A tibble: 127 x 3
#>    Timestamp           Precip Units
#>    <dttm>               <dbl> <chr>
#>  1 2018-06-21 00:00:00      0 mm   
#>  2 2018-06-21 00:20:00      0 mm   
#>  3 2018-06-21 00:40:00      0 mm   
#>  4 2018-06-21 01:00:00      0 mm   
#>  5 2018-06-21 01:20:00      0 mm   
#>  6 2018-06-21 01:40:00      0 mm   
#>  7 2018-06-21 02:00:00      0 mm   
#>  8 2018-06-21 02:20:00      0 mm   
#>  9 2018-06-21 02:40:00      0 mm   
#> 10 2018-06-21 03:00:00      0 mm   
#> # ... with 117 more rows
```

#### Multiple Time Series

If you provide a vector to `ts_id`, a list of tibbles will be returned. Each tibble is named according to the station name and the time series' parameter.

``` r
# Specified date, multiple time series
my_ts_ids <- c("948928042", "948603042")
my_values <- ki_timeseries_values(hub = 'swmc', 
                                  ts_id = my_ts_ids,
                                  start_date = "2017-08-28",
                                  end_date = "2017-09-13")
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

Using Other Hubs
----------------

You can use this package for a KiWIS hub not included in this list by feeding the location of the API service to the `hub` argument.

For instance: If your URL looks like

<http://kiwis.grandriver.ca/KiWIS/KiWIS?service=kisters&type=queryServices&request=getRequestInfo&datasource=0&format=html>

specify the `hub` argument with

<http://kiwis.grandriver.ca/KiWIS/KiWIS>?

If you'd like to have a hub added to the defaults, please [Submit an Issue](https://github.com/rywhale/kiwisR/issues)
