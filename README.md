
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

``` r
devtools::load_all()
```

## Usage

### Get Station Information

#### All Available Stations

By default, `ki_station_list()` returns a tibble containing information
for all available stations for the selected hub.

``` r
# With swmc as the hub
ki_station_list(hub = 'swmc')
#> # A tibble: 3,560 x 5
#>    station_name     station_no station_id station_latitude station_longitu~
#>    <chr>            <chr>      <chr>                 <dbl>            <dbl>
#>  1 2019SurgeUpgrad~ New-000019 642499                 NA               NA  
#>  2 2019SurgeUpgrad~ New-000020 642538                 NA               NA  
#>  3 ABBOTSFORD A     CLIM-MSC-~ 133535                 49.0           -122. 
#>  4 ABERDEEN         CLIM-MSC-~ 121939                 45.5            -98.4
#>  5 ABITIBI CANYON   ZZSNOW-OP~ 148200                 49.9            -81.6
#>  6 ABITIBI LAKE     CLIM-MNR-~ 121135                 48.7            -80.1
#>  7 ABITIBI RIVER A~ HYDAT-04M~ 136328                 49.9            -81.6
#>  8 ABITIBI RIVER A~ HYDAT-04M~ 136304                 48.8            -80.7
#>  9 ABITIBI RIVER A~ HYDAT-04M~ 136324                 49.6            -81.4
#> 10 ABITIBI RIVER A~ HYDAT-04M~ 136332                 50.2            -81.6
#> # ... with 3,550 more rows
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
#>    station_name     station_no station_id station_latitude station_longitu~
#>    <chr>            <chr>      <chr>                 <dbl>            <dbl>
#>  1 ALBION HILLS     SNOW-MNR-~ 137457                 43.9            -79.8
#>  2 Acton Sewage Tr~ ZZ-WSC-AC~ 149765                 43.6            -80.0
#>  3 BELFOUNTAIN      ZZSNOW-MN~ 147848                 43.8            -80.0
#>  4 BELFOUNTAIN2     ZZSNOW-MN~ 147864                 43.8            -80.0
#>  5 BOYD             SNOW-MNR-~ 137465                 43.8            -79.6
#>  6 BROUGHAM CREEK ~ HYDAT-02H~ 135564                 43.9            -79.1
#>  7 BRUCE'S MILL     SNOW-MNR-~ 137477                 43.9            -79.4
#>  8 BUTTONVILLE A    CLIM-MSC-~ 132165                 43.9            -79.4
#>  9 Black Creek bel~ WSC-02HB0~ 247406                 43.6            -80.0
#> 10 Black Creek nea~ WSC-02HC0~ 144081                 43.7            -79.5
#> # ... with 163 more rows

# With comma separated string
my_bounding_box <- "-80.126038,43.458297,-79.002481,43.969098"
my_stations <- ki_station_list(hub = 'swmc', bounding_box = my_bounding_box)
my_stations
#> # A tibble: 173 x 5
#>    station_name     station_no station_id station_latitude station_longitu~
#>    <chr>            <chr>      <chr>                 <dbl>            <dbl>
#>  1 ALBION HILLS     SNOW-MNR-~ 137457                 43.9            -79.8
#>  2 Acton Sewage Tr~ ZZ-WSC-AC~ 149765                 43.6            -80.0
#>  3 BELFOUNTAIN      ZZSNOW-MN~ 147848                 43.8            -80.0
#>  4 BELFOUNTAIN2     ZZSNOW-MN~ 147864                 43.8            -80.0
#>  5 BOYD             SNOW-MNR-~ 137465                 43.8            -79.6
#>  6 BROUGHAM CREEK ~ HYDAT-02H~ 135564                 43.9            -79.1
#>  7 BRUCE'S MILL     SNOW-MNR-~ 137477                 43.9            -79.4
#>  8 BUTTONVILLE A    CLIM-MSC-~ 132165                 43.9            -79.4
#>  9 Black Creek bel~ WSC-02HB0~ 247406                 43.6            -80.0
#> 10 Black Creek nea~ WSC-02HC0~ 144081                 43.7            -79.5
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
#>    station_name     station_no station_id station_latitude station_longitu~
#>    <chr>            <chr>      <chr>                 <dbl>            <dbl>
#>  1 ABBOTSFORD A     CLIM-MSC-~ 133535                 49.0           -122. 
#>  2 ABERDEEN         CLIM-MSC-~ 121939                 45.5            -98.4
#>  3 ABITIBI CANYON   ZZSNOW-OP~ 148200                 49.9            -81.6
#>  4 ABITIBI LAKE     CLIM-MNR-~ 121135                 48.7            -80.1
#>  5 ABITIBI RIVER A~ HYDAT-04M~ 136328                 49.9            -81.6
#>  6 ABITIBI RIVER A~ HYDAT-04M~ 136304                 48.8            -80.7
#>  7 ABITIBI RIVER A~ HYDAT-04M~ 136324                 49.6            -81.4
#>  8 ABITIBI RIVER A~ HYDAT-04M~ 136332                 50.2            -81.6
#>  9 ABITIBI RIVER A~ HYDAT-04M~ 136308                 48.7            -80.6
#> 10 ACTINOLITE (PRI~ ZZSNOW-MN~ 147948                 44.5            -77.3
#> # ... with 117 more rows

# All stations starting with 'Oshawa'
my_stations <- ki_station_list(
  hub = 'swmc', 
  search_term = "Oshawa*"
  )

my_stations
#> # A tibble: 3 x 5
#>   station_name     station_no  station_id station_latitude station_longitu~
#>   <chr>            <chr>       <chr>                 <dbl>            <dbl>
#> 1 OSHAWA A         CLIM-MSC-Y~ 132486                 43.9            -78.9
#> 2 Oshawa Airport ~ Wiski-0262  458060                 43.9            -78.9
#> 3 Oshawa Creek at~ WSC-02HD008 144342                 43.9            -78.9
```

#### By Group

You can retrieve a list of available station and time series groups
using `ki_group_list`

``` r
all_groups <- ki_group_list(hub = 'swmc')
all_groups
#> # A tibble: 167 x 3
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
#> # ... with 157 more rows
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
#>    station_name     station_no station_id station_latitude station_longitu~
#>    <chr>            <chr>      <chr>                 <dbl>            <dbl>
#>  1 Ausable River N~ WSC-02FF0~ 142338                 43.2            -81.8
#>  2 Ausable River a~ Wiski-0015 138406                 43.2            -81.9
#>  3 Ausable River n~ WSC-02FF0~ 142324                 43.4            -81.5
#>  4 Ausable River n~ WSC-02FF0~ 142269                 43.1            -81.7
#>  5 BRUCEFIELD (CAM~ SNOW-MNR-~ 137228                 43.5            -81.5
#>  6 Bayfield River ~ WSC-02FF0~ 142296                 43.6            -81.6
#>  7 Black Creek nea~ WSC-02FF0~ 142392                 43.4            -81.5
#>  8 Garvey Glenn at~ Wiski-0202 139749                 44.0            -81.7
#>  9 Gully Creek at ~ Wiski-0200 139731                 43.6            -81.7
#> 10 KHIVA (OROURKE)  SNOW-MNR-~ 137232                 43.3            -81.6
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
#> # A tibble: 179 x 6
#>    station_name station_id ts_id ts_name from               
#>    <chr>        <chr>      <chr> <chr>   <dttm>             
#>  1 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-16 00:00:00
#>  2 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-01 00:00:00
#>  3 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-16 14:00:00
#>  4 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-01 00:00:00
#>  5 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-16 00:00:00
#>  6 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-01 00:00:00
#>  7 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-01 00:00:00
#>  8 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-16 14:00:00
#>  9 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-01 00:00:00
#> 10 Jackson Cre~ 144659     1184~ SMoist~ 2019-01-01 00:00:00
#> # ... with 169 more rows, and 1 more variable: to <dttm>

str(available_ts)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    179 obs. of  6 variables:
#>  $ station_name: chr  "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" ...
#>  $ station_id  : chr  "144659" "144659" "144659" "144659" ...
#>  $ ts_id       : chr  "1184282042" "1184279042" "1184280042" "1184283042" ...
#>  $ ts_name     : chr  "SMoisture.DayMax" "SMoisture.YearMax" "SMoisture.1.O" "SMoisture.MonthMax" ...
#>  $ from        : POSIXct, format: "2019-01-16 00:00:00" "2019-01-01 00:00:00" ...
#>  $ to          : POSIXct, format: "2019-05-28 00:00:00" "2020-01-01 00:00:00" ...
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
#> # A tibble: 254 x 6
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
#>  9 Jackson Cre~ 144659     1184~ Precip~ 2018-10-18 05:00:00
#> 10 Jackson Cre~ 144659     9489~ Precip~ 2007-06-18 20:15:00
#> # ... with 244 more rows, and 1 more variable: to <dttm>

unique(available_ts$ts_name)
#>   [1] "Precip.MonthTotal"         "Precip.6hrTotal"          
#>   [3] "Precip.18MonthRunningTtl"  "Precip.24hr.P"            
#>   [5] "Precip.1.O"                "Precip.DayTotal"          
#>   [7] "Precip.3MonthRunningTtl"   "Precip.WeeksWithoutRain"  
#>   [9] "Precip.1.Calc"             "Precip.1.P"               
#>  [11] "Precip.OLWRAverages"       "Precip.OLWRAverages2000"  
#>  [13] "Precip.YearTotal"          "Precip.PGL.P"             
#>  [15] "Precip.24hr.O"             "Precip.PGL.O"             
#>  [17] "Precip.MonthToDate"        "TWater.DayMax"            
#>  [19] "TWater.DayMean"            "TWater.MonthMax"          
#>  [21] "TWater.YearMax"            "TWater.YearMean"          
#>  [23] "TWater.MonthMean"          "TWater.1.O"               
#>  [25] "TWater.1.P"                "TWater.DayMin"            
#>  [27] "TWater.MonthMin"           "TWater.YearMin"           
#>  [29] "Q.DayMean"                 "Q.1.O"                    
#>  [31] "Q.DayMax"                  "Q.15"                     
#>  [33] "Q.MonthMean"               "Q.YearMin"                
#>  [35] "Q.DayMean.HYDAT"           "Q.YearMax.HYDAT"          
#>  [37] "Q.DayBaseflow"             "Q.DayRunoff"              
#>  [39] "Q.MonthMean.HYDAT"         "Q.YearMean"               
#>  [41] "Q.MonthMin"                "Q.DayMin"                 
#>  [43] "Q.MonthMax"                "Q.YearMax"                
#>  [45] "LVL.1.O"                   "WWP_AlarmLevel_75 %-tile" 
#>  [47] "LVL.MonthMin"              "LVL.MonthMax"             
#>  [49] "WWP_AlarmLevel_High Limit" "LVL.DayMin"               
#>  [51] "LVL.MonthMean"             "LVL.MonthMean.HYDAT"      
#>  [53] "LVL.YearMax"               "LVL.YearMax.HYDAT"        
#>  [55] "LVL.15.P"                  "LVL.DayMean"              
#>  [57] "WWP_AlarmLevel_50 %-tile"  "LVL.15.O"                 
#>  [59] "WWP_AlarmLevel_25 %-tile"  "LVL.DayMax"               
#>  [61] "LVL.DayMean.HYDAT"         "LVL.YearMean"             
#>  [63] "LVL.YearMin"               "TSoil.YearMean"           
#>  [65] "TSoil.DayMean"             "TSoil.MonthMax"           
#>  [67] "TSoil.YearMax"             "TSoil.1.O"                
#>  [69] "TSoil.MonthMin"            "TSoil.YearMin"            
#>  [71] "TSoil.1.P"                 "TSoil.MonthMean"          
#>  [73] "3Month%"                   "18Month%"                 
#>  [75] "MonthToDate%"              "BAT.1.O"                  
#>  [77] "SMoisture.DayMax"          "SMoisture.YearMax"        
#>  [79] "SMoisture.1.O"             "SMoisture.MonthMax"       
#>  [81] "SMoisture.DayMin"          "SMoisture.YearMean"       
#>  [83] "SMoisture.YearMin"         "SMoisture.1.P"            
#>  [85] "SMoisture.MonthMean"       "SMoisture.MonthMin"       
#>  [87] "SMoisture.DayMean"         "Water Frac.DayMin"        
#>  [89] "Water Frac.MonthMax"       "Water Frac.MonthMean"     
#>  [91] "Soil Moisture.1.O"         "SoilMoisture.Year.Max"    
#>  [93] "Soil Moisture.1.P"         "Water Frac.DayMax"        
#>  [95] "Water Frac.DayMean"        "Water Frac.MonthMin"      
#>  [97] "LowestSummerFlow%"         "Soil Cond.DayMin"         
#>  [99] "SoilConduct MQ2.1.O"       "Soil Cond.DayMax"         
#> [101] "Soil Cond.YrMax"           "Soil Cond.YrMean"         
#> [103] "Soil Cond.DayMean"         "Soil Cond.MonthMean"      
#> [105] "Soil Cond.YrMin"           "SoilConduct MQ2.1.P"      
#> [107] "Soil Cond.MonthMax"        "Soil Cond.MonthMin"       
#> [109] "TSoil.DayMin"              "TSoil.DayMax"             
#> [111] "TAir.MonthMin"             "TAir.DayMean"             
#> [113] "TAir.DayMin"               "TAir.MonthMax"            
#> [115] "TAir.YearMax"              "TAir.6hr.Max"             
#> [117] "TAir.24hrMax.P"            "TAir.1.O"                 
#> [119] "TAir.24hrMax.O"            "TAir.24hrMin.P"           
#> [121] "TAir.DayMax"               "TAir.MonthMean"           
#> [123] "TAir.YearMean"             "TAir.YearMin"             
#> [125] "TAir.1.P"                  "TAir.24hrMin.O"           
#> [127] "TAir.6hr.Min"              "Q.Baseflow.1"             
#> [129] "Q.RunOff.1"                "LowestSummerFlow2000"     
#> [131] "LowestSummerFlow"          "SoilConduct.1.P"          
#> [133] "SoilConduct.DayMean"       "SoilConduct.1.O"          
#> [135] "SoilConduct.DayMin"        "SoilConduct.YearMin"      
#> [137] "SoilConduct.MonthMean"     "SoilConduct.MonthMin"     
#> [139] "SoilConduct.YearMax"       "SoilConduct.MonthMax"     
#> [141] "SoilConduct.DayMax"        "SoilConduct MQ1.1.O"      
#> [143] "SoilConduct MQ1.1.P"
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
#> # A tibble: 501 x 5
#>    Timestamp           Value ts_name Units station_name                    
#>    <dttm>              <dbl> <chr>   <chr> <chr>                           
#>  1 2019-05-26 00:00:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#>  2 2019-05-26 00:05:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#>  3 2019-05-26 00:10:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#>  4 2019-05-26 00:15:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#>  5 2019-05-26 00:20:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#>  6 2019-05-26 00:25:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#>  7 2019-05-26 00:30:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#>  8 2019-05-26 00:35:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#>  9 2019-05-26 00:40:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#> 10 2019-05-26 00:45:00  24.8 LVL.1.O m     Attawapiskat River below Mukete~
#> # ... with 491 more rows
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
#> # A tibble: 1,262 x 5
#>    Timestamp           Value ts_name       Units station_name              
#>    <dttm>              <dbl> <chr>         <chr> <chr>                     
#>  1 2015-09-06 05:00:00  0.19 Q.DayBaseflow cumec Chippewa Creek at North B~
#>  2 2015-09-17 05:00:00  0.18 Q.DayBaseflow cumec Chippewa Creek at North B~
#>  3 2015-09-26 05:00:00  0.19 Q.DayBaseflow cumec Chippewa Creek at North B~
#>  4 2015-09-27 05:00:00  0.19 Q.DayBaseflow cumec Chippewa Creek at North B~
#>  5 2015-09-28 05:00:00  0.19 Q.DayBaseflow cumec Chippewa Creek at North B~
#>  6 2015-10-03 05:00:00  0.21 Q.DayBaseflow cumec Chippewa Creek at North B~
#>  7 2015-10-08 05:00:00  0.22 Q.DayBaseflow cumec Chippewa Creek at North B~
#>  8 2015-10-12 05:00:00  0.24 Q.DayBaseflow cumec Chippewa Creek at North B~
#>  9 2015-10-24 05:00:00  0.41 Q.DayBaseflow cumec Chippewa Creek at North B~
#> 10 2015-11-11 05:00:00  0.42 Q.DayBaseflow cumec Chippewa Creek at North B~
#> # ... with 1,252 more rows

unique(my_values$ts_name)
#> [1] "Q.DayBaseflow" "Q.DayMean"
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
