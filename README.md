kiwisR
================

<!-- README.md is generated from README.Rmd. Please edit that file -->

## Overview

A wrapper for querying KiWIS APIs to retrieve hydrometric data. Users
can toggle between various databases by specifying the ‘hub’ argument.
Currently, there are three default hubs to choose from:

  - *swmc* : [Ontario Surface Water Monitoring
    Centre](https://www.ontario.ca/page/surface-water-monitoring)
  - *grand* : [Grand River Conservation
    Authority](https://www.grandriver.ca/en/index.aspx)
  - *quinte* : [Quinte Conservation
    Authority](http://quinteconservation.ca/site/)
  - *creditvalley* : [Credit Valley Conservation
    Authority](https://cvc.ca/)

All data is returned as tidy
[tibbles](https://cran.r-project.org/web/packages/tibble/vignettes/tibble.html).

## Installation

To install `kiwisR` you first need to install `remotes`.

``` r
install.packages("remotes")
remotes::install_github('rywhale/kiwisR')
```

Then load the package with

``` r
library(kiwisR)
```

## Usage

### Get Station Information

#### All Available Stations

By default, `ki_station_list()` returns a tibble containing information
for all available stations for the select hub.

``` r
# With swmc as the hub
ki_station_list(hub = 'swmc')
#> # A tibble: 3,518 x 5
#>    station_name    station_no station_id station_latitude station_longitu~
#>    <chr>           <chr>      <chr>      <chr>            <chr>           
#>  1 ABBOTSFORD A    CLIM-MSC-~ 133535     49.03307961      -122.3666708    
#>  2 ABERDEEN        CLIM-MSC-~ 121939     45.45000031      -98.43308042    
#>  3 ABITIBI CANYON  ZZSNOW-OP~ 148200     49.9164159       -81.56666679    
#>  4 ABITIBI LAKE    CLIM-MNR-~ 121135     48.66141167      -80.14196139    
#>  5 ABITIBI RIVER ~ HYDAT-04M~ 136328     49.8797496       -81.56000046    
#>  6 ABITIBI RIVER ~ HYDAT-04M~ 136304     48.76000036      -80.65974982    
#>  7 ABITIBI RIVER ~ HYDAT-04M~ 136324     49.56974984      -81.38000055    
#>  8 ABITIBI RIVER ~ HYDAT-04M~ 136332     50.17974961      -81.6300003     
#>  9 ABITIBI RIVER ~ HYDAT-04M~ 136308     48.74974975      -80.5800007     
#> 10 ACTINOLITE (PR~ ZZSNOW-MN~ 147948     44.54974954      -77.33333458    
#> # ... with 3,508 more rows
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
my_stations <- ki_station_list(hub = 'swmc', bounding_box = my_bounding_box)
my_stations
#> # A tibble: 176 x 5
#>    station_name    station_no station_id station_latitude station_longitu~
#>    <chr>           <chr>      <chr>      <chr>            <chr>           
#>  1 ALBION HILLS    SNOW-MNR-~ 137457     43.93308257      -79.83333343    
#>  2 Acton Sewage T~ ZZ-WSC-AC~ 149765     43.63113873      -80.01666724    
#>  3 BELFOUNTAIN     ZZSNOW-MN~ 147848     43.79974939      -80.0166679     
#>  4 BELFOUNTAIN2    ZZSNOW-MN~ 147864     43.79974999      -80.00000079    
#>  5 BOYD            SNOW-MNR-~ 137465     43.81641643      -79.58333342    
#>  6 BROUGHAM CREEK~ HYDAT-02H~ 135564     43.91000014      -79.10000053    
#>  7 BRUCE'S MILL    SNOW-MNR-~ 137477     43.94974951      -79.35000009    
#>  8 BUTTONVILLE A   CLIM-MSC-~ 132165     43.86666985      -79.36666949    
#>  9 Black Creek be~ WSC-02HB0~ 247406     43.62916667      -80.01027778    
#> 10 Black Creek ne~ WSC-02HC0~ 144081     43.67308155      -79.50583357    
#> # ... with 166 more rows

# With comma separated string
my_bounding_box <- "-80.126038,43.458297,-79.002481,43.969098"
my_stations <- ki_station_list(hub = 'swmc', bounding_box = my_bounding_box)
my_stations
#> # A tibble: 176 x 5
#>    station_name    station_no station_id station_latitude station_longitu~
#>    <chr>           <chr>      <chr>      <chr>            <chr>           
#>  1 ALBION HILLS    SNOW-MNR-~ 137457     43.93308257      -79.83333343    
#>  2 Acton Sewage T~ ZZ-WSC-AC~ 149765     43.63113873      -80.01666724    
#>  3 BELFOUNTAIN     ZZSNOW-MN~ 147848     43.79974939      -80.0166679     
#>  4 BELFOUNTAIN2    ZZSNOW-MN~ 147864     43.79974999      -80.00000079    
#>  5 BOYD            SNOW-MNR-~ 137465     43.81641643      -79.58333342    
#>  6 BROUGHAM CREEK~ HYDAT-02H~ 135564     43.91000014      -79.10000053    
#>  7 BRUCE'S MILL    SNOW-MNR-~ 137477     43.94974951      -79.35000009    
#>  8 BUTTONVILLE A   CLIM-MSC-~ 132165     43.86666985      -79.36666949    
#>  9 Black Creek be~ WSC-02HB0~ 247406     43.62916667      -80.01027778    
#> 10 Black Creek ne~ WSC-02HC0~ 144081     43.67308155      -79.50583357    
#> # ... with 166 more rows
```

#### By Search Term

You can also narrow search results using a search term. This supports
the use of `*` as a wildcard.

``` r
# All stations starting with 'A'
my_stations <- ki_station_list(hub = 'swmc', search_term = "A*")
my_stations
#> # A tibble: 126 x 5
#>    station_name    station_no station_id station_latitude station_longitu~
#>    <chr>           <chr>      <chr>      <chr>            <chr>           
#>  1 ABBOTSFORD A    CLIM-MSC-~ 133535     49.03307961      -122.3666708    
#>  2 ABERDEEN        CLIM-MSC-~ 121939     45.45000031      -98.43308042    
#>  3 ABITIBI CANYON  ZZSNOW-OP~ 148200     49.9164159       -81.56666679    
#>  4 ABITIBI LAKE    CLIM-MNR-~ 121135     48.66141167      -80.14196139    
#>  5 ABITIBI RIVER ~ HYDAT-04M~ 136328     49.8797496       -81.56000046    
#>  6 ABITIBI RIVER ~ HYDAT-04M~ 136304     48.76000036      -80.65974982    
#>  7 ABITIBI RIVER ~ HYDAT-04M~ 136324     49.56974984      -81.38000055    
#>  8 ABITIBI RIVER ~ HYDAT-04M~ 136332     50.17974961      -81.6300003     
#>  9 ABITIBI RIVER ~ HYDAT-04M~ 136308     48.74974975      -80.5800007     
#> 10 ACTINOLITE (PR~ ZZSNOW-MN~ 147948     44.54974954      -77.33333458    
#> # ... with 116 more rows

# All stations starting with 'Oshawa'
my_stations <- ki_station_list(hub = 'swmc', search_term = "Oshawa*")
my_stations
#> # A tibble: 3 x 5
#>   station_name     station_no station_id station_latitude station_longitu~
#>   <chr>            <chr>      <chr>      <chr>            <chr>           
#> 1 OSHAWA A         CLIM-MSC-~ 132486     43.91666694      -78.90000003    
#> 2 Oshawa Airport ~ Wiski-0262 458060     43.923888        -78.8966667     
#> 3 Oshawa Creek at~ WSC-02HD0~ 144342     43.92808201      -78.89113781
```

### Get Time Series Information

You can use the `station_id` column returned using `ki_station_list()`
to figure out which time series are available for a given station.

This will also return `to` and `from` columns indicating the period of
record for that time series.

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
#>  $ to          : POSIXct, format: "2018-06-12 05:00:00" NA ...
```

#### Multiple Stations

If you provide a vector to `station_id`, the returned tibble will have
all the available time series from *all* stations. They can be
differentiated using the `station_name` column.

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

You can now use the `ts_id` column in the tibble produced by
`ki_timeseries_list()` to query values for chosen time series.

By default this will return values for the past 24 hours. You can
specify the dates you’re interested in by setting `start_date` and
`end_date`. These should be set as date strings with the format
‘YYYY-mm-dd’.

#### One Time Series

``` r
# Past 24 hours
my_values <- ki_timeseries_values(hub = 'swmc', ts_id = '948928042')
my_values
#> # A tibble: 100 x 2
#>    Timestamp           `Precip (millimeter)`
#>    <dttm>                              <dbl>
#>  1 2018-06-10 00:00:00                     0
#>  2 2018-06-10 00:20:00                     0
#>  3 2018-06-10 00:40:00                     0
#>  4 2018-06-10 01:00:00                     0
#>  5 2018-06-10 01:20:00                     0
#>  6 2018-06-10 01:40:00                     0
#>  7 2018-06-10 02:00:00                     0
#>  8 2018-06-10 02:20:00                     0
#>  9 2018-06-10 02:40:00                     0
#> 10 2018-06-10 03:00:00                     0
#> # ... with 90 more rows
```

#### Multiple Time Series

If you provide a vector to `ts_id`, a list of tibbles will be returned.
Each tibble is named according to the station name and the time series’
parameter.

``` r
# Specified date, multiple time series
my_ts_ids <- c("948928042", "948603042")
my_values <- ki_timeseries_values(hub = 'swmc', 
                                  ts_id = my_ts_ids,
                                  start_date = "2017-08-28",
                                  end_date = "2017-09-13")
my_values
#> $`Jackson Creek at Jackson Heights (Precip)`
#> # A tibble: 1,632 x 2
#>    Timestamp           `Precip (millimeter)`
#>    <dttm>                              <dbl>
#>  1 2017-08-28 00:00:00                     0
#>  2 2017-08-28 00:15:00                     0
#>  3 2017-08-28 00:30:00                     0
#>  4 2017-08-28 00:45:00                     0
#>  5 2017-08-28 01:00:00                     0
#>  6 2017-08-28 01:15:00                     0
#>  7 2017-08-28 01:30:00                     0
#>  8 2017-08-28 01:45:00                     0
#>  9 2017-08-28 02:00:00                     0
#> 10 2017-08-28 02:15:00                     0
#> # ... with 1,622 more rows
#> 
#> $`Jackson Creek at Peterborough (Q)`
#> # A tibble: 17 x 2
#>    Timestamp           `Q (cubic meter per second)`
#>    <dttm>                                     <dbl>
#>  1 2017-08-28 05:00:00                        0.251
#>  2 2017-08-29 05:00:00                        0.243
#>  3 2017-08-30 05:00:00                        0.243
#>  4 2017-08-31 05:00:00                        0.268
#>  5 2017-09-01 05:00:00                        0.233
#>  6 2017-09-02 05:00:00                        0.27 
#>  7 2017-09-03 05:00:00                        0.908
#>  8 2017-09-04 05:00:00                        1.30 
#>  9 2017-09-05 05:00:00                        0.762
#> 10 2017-09-06 05:00:00                        0.412
#> 11 2017-09-07 05:00:00                        0.444
#> 12 2017-09-08 05:00:00                        0.377
#> 13 2017-09-09 05:00:00                        0.374
#> 14 2017-09-10 05:00:00                        0.372
#> 15 2017-09-11 05:00:00                        0.365
#> 16 2017-09-12 05:00:00                        0.349
#> 17 2017-09-13 05:00:00                        0.332
```

## Using Other Hubs

You can use this package for a KiWIS hub not included in this list by
feeding the location of the API service to the `hub` argument.

For instance: If your URL looks
like

<http://kiwis.grandriver.ca/KiWIS/KiWIS?service=kisters&type=queryServices&request=getRequestInfo&datasource=0&format=html>

specify the `hub` argument with

<http://kiwis.grandriver.ca/KiWIS/KiWIS>?

If you’d like to have a hub added to the defaults, please [Submit an
Issue](https://github.com/rywhale/kiwisR/issues)
