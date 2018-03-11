kiwisR
================

<!-- README.md is generated from README.Rmd. Please edit that file -->
Overview
--------

A wrapper for querying KiWIS APIs to retrieve hydrometric data. Users can toggle between various databases by specifying the 'hub' argument. Currently, there are three default hubs to choose from:

-   *swmc* : [Ontario Surface Water Monitoring Centre](https://www.ontario.ca/page/surface-water-monitoring)
-   *grand* : [Grand River Conservation Authority](https://www.grandriver.ca/en/index.aspx)
-   *quinte* : [Quinte Conservation Authority](http://quinteconservation.ca/site/)

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
#> # A tibble: 3,520 x 4
#>                       station_name station_id station_latitude
#>                              <chr>      <chr>            <chr>
#>  1                    ABBOTSFORD A     133535      49.03307961
#>  2                        ABERDEEN     121939      45.45000031
#>  3                  ABITIBI CANYON     148200       49.9164159
#>  4                    ABITIBI LAKE     121135      48.66141167
#>  5 ABITIBI RIVER AT ABITIBI CANYON     136328       49.8797496
#>  6 ABITIBI RIVER AT IROQUOIS FALLS     136304      48.76000036
#>  7   ABITIBI RIVER AT ISLAND FALLS     136324      49.56974984
#>  8   ABITIBI RIVER AT OTTER RAPIDS     136332      50.17974961
#>  9     ABITIBI RIVER AT TWIN FALLS     136308      48.74974975
#> 10             ACTINOLITE (PRICES)     147948      44.54974954
#> # ... with 3,510 more rows, and 1 more variables: station_longitude <chr>

# With grand as the hub
ki_station_list(hub = 'grand')
#> # A tibble: 89 x 4
#>              station_name station_id  station_latitude  station_longitude
#>                     <chr>      <chr>             <chr>              <chr>
#>  1              Aberfoyle      14575 43.45465555555556         -80.162625
#>  2        Armstrong Mills      14512          43.63967         -80.269977
#>  3 Arthur Climate Station      14447      43.830686094      -80.540822376
#>  4                    Ayr      14856         43.274975 -80.47487777777778
#>  5  Baden Climate Station      14718      43.395533527      -80.660100299
#>  6             Beaverdale      14534 43.42189722222223  -80.3326638888889
#>  7           Below Elmira      15162         43.580107         -80.509161
#>  8            Below Shand      14440 43.73120277777778 -80.34086944444444
#>  9 Below Shand WQ Station      15355 43.73120277777778 -80.34086944444444
#> 10       Blair WQ Station      15177          43.38405 -80.38408055555556
#> # ... with 79 more rows
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
#> # A tibble: 176 x 4
#>                              station_name station_id station_latitude
#>                                     <chr>      <chr>            <chr>
#>  1                           ALBION HILLS     137457      43.93308257
#>  2           Acton Sewage Treatment Plant     149765      43.63113873
#>  3                            BELFOUNTAIN     147848      43.79974939
#>  4                           BELFOUNTAIN2     147864      43.79974999
#>  5                                   BOYD     137465      43.81641643
#>  6             BROUGHAM CREEK AT BROUGHAM     135564      43.91000014
#>  7                           BRUCE'S MILL     137477      43.94974951
#>  8                          BUTTONVILLE A     132165      43.86666985
#>  9                Black Creek below Acton     247406      43.62916667
#> 10 Black Creek near Weston (Scarlett Rd.)     144081      43.67308155
#> # ... with 166 more rows, and 1 more variables: station_longitude <chr>

# With comma separated string
my_bounding_box <- "-80.126038,43.458297,-79.002481,43.969098"
my_stations <- ki_station_list(hub = 'swmc', bounding_box = my_bounding_box)
my_stations
#> # A tibble: 176 x 4
#>                              station_name station_id station_latitude
#>                                     <chr>      <chr>            <chr>
#>  1                           ALBION HILLS     137457      43.93308257
#>  2           Acton Sewage Treatment Plant     149765      43.63113873
#>  3                            BELFOUNTAIN     147848      43.79974939
#>  4                           BELFOUNTAIN2     147864      43.79974999
#>  5                                   BOYD     137465      43.81641643
#>  6             BROUGHAM CREEK AT BROUGHAM     135564      43.91000014
#>  7                           BRUCE'S MILL     137477      43.94974951
#>  8                          BUTTONVILLE A     132165      43.86666985
#>  9                Black Creek below Acton     247406      43.62916667
#> 10 Black Creek near Weston (Scarlett Rd.)     144081      43.67308155
#> # ... with 166 more rows, and 1 more variables: station_longitude <chr>
```

#### By Search Term

You can also narrow search results using a search term. This supports the use of `*` as a wildcard.

``` r
# All stations starting with 'A'
my_stations <- ki_station_list(hub = 'swmc', search_term = "A*")
my_stations
#> # A tibble: 129 x 4
#>                       station_name station_id station_latitude
#>                              <chr>      <chr>            <chr>
#>  1                    ABBOTSFORD A     133535      49.03307961
#>  2                        ABERDEEN     121939      45.45000031
#>  3                  ABITIBI CANYON     148200       49.9164159
#>  4                    ABITIBI LAKE     121135      48.66141167
#>  5 ABITIBI RIVER AT ABITIBI CANYON     136328       49.8797496
#>  6 ABITIBI RIVER AT IROQUOIS FALLS     136304      48.76000036
#>  7   ABITIBI RIVER AT ISLAND FALLS     136324      49.56974984
#>  8   ABITIBI RIVER AT OTTER RAPIDS     136332      50.17974961
#>  9     ABITIBI RIVER AT TWIN FALLS     136308      48.74974975
#> 10             ACTINOLITE (PRICES)     147948      44.54974954
#> # ... with 119 more rows, and 1 more variables: station_longitude <chr>

# All stations starting with 'Oshawa'
my_stations <- ki_station_list(hub = 'swmc', search_term = "Oshawa*")
my_stations
#> # A tibble: 2 x 4
#>             station_name station_id station_latitude station_longitude
#>                    <chr>      <chr>            <chr>             <chr>
#> 1 Oshawa Airport - CLOCA     458060        43.923888       -78.8966667
#> 2 Oshawa Creek at Oshawa     144342      43.92808201      -78.89113781
```

### Get Time Series Information

You can use the `station_id` column returned using `ki_station_list()` to figure out which time series are available for a given station.

#### One Station

``` r
# Single station_id
available_ts <- ki_timeseries_list(hub = 'swmc', station_id = "144659")
available_ts
#> # A tibble: 145 x 4
#>                        station_name station_id      ts_id         ts_name
#>                               <chr>      <chr>      <chr>           <chr>
#>  1 Jackson Creek at Jackson Heights     144659  949057042       Q.DayMean
#>  2 Jackson Creek at Jackson Heights     144659  949048042           Q.1.O
#>  3 Jackson Creek at Jackson Heights     144659  949056042        Q.DayMax
#>  4 Jackson Creek at Jackson Heights     144659  949049042            Q.15
#>  5 Jackson Creek at Jackson Heights     144659  949061042     Q.MonthMean
#>  6 Jackson Creek at Jackson Heights     144659  949067042       Q.YearMin
#>  7 Jackson Creek at Jackson Heights     144659  949050042    Q.Baseflow.1
#>  8 Jackson Creek at Jackson Heights     144659  949058042 Q.DayMean.HYDAT
#>  9 Jackson Creek at Jackson Heights     144659  949065042 Q.YearMax.HYDAT
#> 10 Jackson Creek at Jackson Heights     144659 1126053042   Q.DayBaseflow
#> # ... with 135 more rows
```

#### Multiple Stations

If you provide a vector to `station_id`, the returned tibble will have all the available time series from *all* stations. They can be differentiated using the `station_name` column.

``` r
# Vector of station_ids
my_station_ids <- c("144659", "144342")

available_ts <- ki_timeseries_list(hub = 'swmc', station_id = my_station_ids)
available_ts
#> # A tibble: 275 x 4
#>              station_name station_id      ts_id        ts_name
#>                     <chr>      <chr>      <chr>          <chr>
#>  1 Oshawa Creek at Oshawa     144342 1131022042 TAir.24hrMin.P
#>  2 Oshawa Creek at Oshawa     144342  945562042  TAir.YearMean
#>  3 Oshawa Creek at Oshawa     144342 1131019042 TAir.24hrMax.O
#>  4 Oshawa Creek at Oshawa     144342  945557042    TAir.DayMin
#>  5 Oshawa Creek at Oshawa     144342  945560042  TAir.MonthMin
#>  6 Oshawa Creek at Oshawa     144342 1131018042       TAir.1.P
#>  7 Oshawa Creek at Oshawa     144342  945552042       TAir.1.O
#>  8 Oshawa Creek at Oshawa     144342 1131023042   TAir.6hr.Max
#>  9 Oshawa Creek at Oshawa     144342  945558042  TAir.MonthMax
#> 10 Oshawa Creek at Oshawa     144342  945561042   TAir.YearMax
#> # ... with 265 more rows
```

### Get Time Series Values

You can now use the `ts_id` column in the tibble produced by `ki_timeseries_list()` to query values for chosen time series.

By default this will return values for the past 24 hours. You can specify the dates you're interested in by setting `start_date` and `end_date`. These should be set as date strings with the format 'YYYY-mm-dd'.

#### One Time Series

``` r
# Past 24 hours
my_values <- ki_timeseries_values(hub = 'swmc', ts_id = '948928042')
my_values
#> # A tibble: 85 x 2
#>              Timestamp `Precip (millimeter)`
#>                 <dttm>                 <dbl>
#>  1 2018-03-10 00:00:00                     0
#>  2 2018-03-10 00:20:00                     0
#>  3 2018-03-10 00:40:00                     0
#>  4 2018-03-10 01:00:00                     0
#>  5 2018-03-10 01:20:00                     0
#>  6 2018-03-10 01:40:00                     0
#>  7 2018-03-10 02:00:00                     0
#>  8 2018-03-10 02:20:00                     0
#>  9 2018-03-10 02:40:00                     0
#> 10 2018-03-10 03:00:00                     0
#> # ... with 75 more rows
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
#> # A tibble: 1,632 x 2
#>              Timestamp `Precip (millimeter)`
#>                 <dttm>                 <dbl>
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
#>              Timestamp `Q (cubic meter per second)`
#>                 <dttm>                        <dbl>
#>  1 2017-08-28 05:00:00                        0.251
#>  2 2017-08-29 05:00:00                        0.243
#>  3 2017-08-30 05:00:00                        0.243
#>  4 2017-08-31 05:00:00                        0.268
#>  5 2017-09-01 05:00:00                        0.233
#>  6 2017-09-02 05:00:00                        0.270
#>  7 2017-09-03 05:00:00                        0.908
#>  8 2017-09-04 05:00:00                        1.299
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

Using Other Hubs
----------------

You can use this package for a KiWIS hub not included in this list by feeding the location of the API service to the `hub` argument.

For instance: If your URL looks like

<http://kiwis.grandriver.ca/KiWIS/KiWIS?service=kisters&type=queryServices&request=getRequestInfo&datasource=0&format=html>

specify the `hub` argument with

<http://kiwis.grandriver.ca/KiWIS/KiWIS>?

If you'd like to have a hub added to the defaults, please [Submit an Issue](https://github.com/rywhale/kiwisR/issues)
