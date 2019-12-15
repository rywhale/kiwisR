
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
#> # A tibble: 3,879 x 5
#>    station_name     station_no station_id station_latitude station_longitu~
#>    <chr>            <chr>      <chr>                 <dbl>            <dbl>
#>  1 A SNOW TEMPLATE  SNOW-WLF-~ 952125                 NA               NA  
#>  2 AA SNOW TEMPLATE SNOW-WLF-~ 954599                 NA               NA  
#>  3 ABBOTSFORD A     CLIM-MSC-~ 133535                 49.0           -122. 
#>  4 ABERDEEN         CLIM-MSC-~ 121939                 45.5            -98.4
#>  5 ABITIBI CANYON   ZZSNOW-OP~ 148200                 49.9            -81.6
#>  6 ABITIBI LAKE     CLIM-MNR-~ 121135                 48.7            -80.1
#>  7 ABITIBI RIVER A~ HYDAT-04M~ 136328                 49.9            -81.6
#>  8 ABITIBI RIVER A~ HYDAT-04M~ 136304                 48.8            -80.7
#>  9 ABITIBI RIVER A~ HYDAT-04M~ 136324                 49.6            -81.4
#> 10 ABITIBI RIVER A~ HYDAT-04M~ 136332                 50.2            -81.6
#> # ... with 3,869 more rows
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
#> # A tibble: 168 x 5
#>    station_name    station_no  station_id station_latitude station_longitu~
#>    <chr>           <chr>       <chr>                 <dbl>            <dbl>
#>  1 ALBION HILLS    SNOW-MNR-2~ 137457                 43.9            -79.8
#>  2 ALTON           SNOW-WLF-AL 967627                 43.8            -80.1
#>  3 Acton Sewage T~ ZZ-WSC-ACT~ 149765                 43.6            -80.0
#>  4 BELFOUNTAIN     ZZSNOW-MNR~ 147848                 43.8            -80.0
#>  5 BELFOUNTAIN2    ZZSNOW-MNR~ 147864                 43.8            -80.0
#>  6 BOYD            SNOW-MNR-2~ 137465                 43.8            -79.6
#>  7 BROUGHAM CREEK~ HYDAT-02HC~ 135564                 43.9            -79.1
#>  8 BRUCE'S MILL    SNOW-MNR-2~ 137477                 43.9            -79.4
#>  9 BUTTONVILLE A   CLIM-MSC-Y~ 132165                 43.9            -79.4
#> 10 Black Creek be~ WSC-02HB024 247406                 43.6            -80.0
#> # ... with 158 more rows

# With comma separated string
my_bounding_box <- "-80.126038,43.458297,-79.002481,43.969098"
my_stations <- ki_station_list(hub = 'swmc', bounding_box = my_bounding_box)
my_stations
#> # A tibble: 168 x 5
#>    station_name    station_no  station_id station_latitude station_longitu~
#>    <chr>           <chr>       <chr>                 <dbl>            <dbl>
#>  1 ALBION HILLS    SNOW-MNR-2~ 137457                 43.9            -79.8
#>  2 ALTON           SNOW-WLF-AL 967627                 43.8            -80.1
#>  3 Acton Sewage T~ ZZ-WSC-ACT~ 149765                 43.6            -80.0
#>  4 BELFOUNTAIN     ZZSNOW-MNR~ 147848                 43.8            -80.0
#>  5 BELFOUNTAIN2    ZZSNOW-MNR~ 147864                 43.8            -80.0
#>  6 BOYD            SNOW-MNR-2~ 137465                 43.8            -79.6
#>  7 BROUGHAM CREEK~ HYDAT-02HC~ 135564                 43.9            -79.1
#>  8 BRUCE'S MILL    SNOW-MNR-2~ 137477                 43.9            -79.4
#>  9 BUTTONVILLE A   CLIM-MSC-Y~ 132165                 43.9            -79.4
#> 10 Black Creek be~ WSC-02HB024 247406                 43.6            -80.0
#> # ... with 158 more rows
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
#> # A tibble: 140 x 5
#>    station_name     station_no station_id station_latitude station_longitu~
#>    <chr>            <chr>      <chr>                 <dbl>            <dbl>
#>  1 A SNOW TEMPLATE  SNOW-WLF-~ 952125                 NA               NA  
#>  2 AA SNOW TEMPLATE SNOW-WLF-~ 954599                 NA               NA  
#>  3 ABBOTSFORD A     CLIM-MSC-~ 133535                 49.0           -122. 
#>  4 ABERDEEN         CLIM-MSC-~ 121939                 45.5            -98.4
#>  5 ABITIBI CANYON   ZZSNOW-OP~ 148200                 49.9            -81.6
#>  6 ABITIBI LAKE     CLIM-MNR-~ 121135                 48.7            -80.1
#>  7 ABITIBI RIVER A~ HYDAT-04M~ 136328                 49.9            -81.6
#>  8 ABITIBI RIVER A~ HYDAT-04M~ 136304                 48.8            -80.7
#>  9 ABITIBI RIVER A~ HYDAT-04M~ 136324                 49.6            -81.4
#> 10 ABITIBI RIVER A~ HYDAT-04M~ 136332                 50.2            -81.6
#> # ... with 130 more rows

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
#> # A tibble: 168 x 3
#>    group_name                      group_id group_type
#>    <chr>                           <chr>    <chr>     
#>  1 Ausable Bayfield CA             169270   station   
#>  2 WWW_Extranet                    181729   station   
#>  3 All Active Stream Gauges        199135   station   
#>  4 All MOE COA-RAC                 199818   station   
#>  5 All Trent Severn Waterway       199828   station   
#>  6 Archived Streamgauging Stations 199829   station   
#>  7 Aurora MNR                      199830   station   
#>  8 Bancroft MNR                    199831   station   
#>  9 Bracebridge MNR                 199832   station   
#> 10 Cataraqui CA                    199833   station   
#> # ... with 158 more rows
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
#> # A tibble: 180 x 6
#>    station_name station_id ts_id ts_name from               
#>    <chr>        <chr>      <chr> <chr>   <dttm>             
#>  1 Jackson Cre~ 144659     1143~ 3Month% 2000-02-01 05:00:00
#>  2 Jackson Cre~ 144659     1143~ 18Mont~ 2000-02-01 05:00:00
#>  3 Jackson Cre~ 144659     1143~ MonthT~ 2000-02-01 05:00:00
#>  4 Jackson Cre~ 144659     1166~ Water ~ 2018-04-23 05:00:00
#>  5 Jackson Cre~ 144659     1166~ SoilMo~ 2018-01-01 05:00:00
#>  6 Jackson Cre~ 144659     1166~ Water ~ 2018-04-23 05:00:00
#>  7 Jackson Cre~ 144659     1166~ Water ~ 2018-04-23 05:00:00
#>  8 Jackson Cre~ 144659     1166~ Soil M~ 2018-04-23 18:00:00
#>  9 Jackson Cre~ 144659     1166~ Water ~ 2018-04-01 05:00:00
#> 10 Jackson Cre~ 144659     1166~ Soil M~ 2018-04-23 18:00:00
#> # ... with 170 more rows, and 1 more variable: to <dttm>

str(available_ts)
#> Classes 'tbl_df', 'tbl' and 'data.frame':    180 obs. of  6 variables:
#>  $ station_name: chr  "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" "Jackson Creek at Jackson Heights" ...
#>  $ station_id  : chr  "144659" "144659" "144659" "144659" ...
#>  $ ts_id       : chr  "1143227042" "1143226042" "1143225042" "1166413042" ...
#>  $ ts_name     : chr  "3Month%" "18Month%" "MonthToDate%" "Water Frac.DayMax" ...
#>  $ from        : POSIXct, format: "2000-02-01 05:00:00" "2000-02-01 05:00:00" ...
#>  $ to          : POSIXct, format: "2020-01-01 05:00:00" "2020-01-01 05:00:00" ...
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
#> # A tibble: 257 x 6
#>    station_name station_id ts_id ts_name from               
#>    <chr>        <chr>      <chr> <chr>   <dttm>             
#>  1 Oshawa Cree~ 144342     1143~ Precip~ 2001-01-01 05:00:00
#>  2 Oshawa Cree~ 144342     9455~ Precip~ 1990-08-01 05:00:00
#>  3 Oshawa Cree~ 144342     9455~ Precip~ 1990-01-01 05:00:00
#>  4 Oshawa Cree~ 144342     1143~ Precip~ 1990-08-01 05:00:00
#>  5 Oshawa Cree~ 144342     9455~ Precip~ 1990-08-01 05:00:00
#>  6 Oshawa Cree~ 144342     1140~ Precip~ 2005-01-01 06:00:00
#>  7 Oshawa Cree~ 144342     9455~ Precip~ 1990-08-01 10:00:00
#>  8 Oshawa Cree~ 144342     1143~ Precip~ 2000-02-01 05:00:00
#>  9 Oshawa Cree~ 144342     1143~ Precip~ 2000-01-01 05:00:00
#> 10 Oshawa Cree~ 144342     1143~ Precip~ 2000-01-02 05:00:00
#> # ... with 247 more rows, and 1 more variable: to <dttm>

unique(available_ts$ts_name)
#>   [1] "Precip.MonthToDate"        "Precip.MonthTotal"        
#>   [3] "Precip.YearTotal"          "Precip.18MonthRunningTtl" 
#>   [5] "Precip.DayTotal"           "Precip.6hrTotal"          
#>   [7] "Precip.1.P"                "Precip.OLWRAverages"      
#>   [9] "Precip.OLWRAverages2000"   "Precip.WeeksWithoutRain"  
#>  [11] "Precip.3MonthRunningTtl"   "Precip.PGL.O"             
#>  [13] "Precip.PGL.P"              "Precip.24hr.O"            
#>  [15] "Precip.24hr.P"             "Precip.1.O"               
#>  [17] "TWater.DayMax"             "TWater.DayMean"           
#>  [19] "TWater.MonthMax"           "TWater.YearMax"           
#>  [21] "TWater.YearMean"           "TWater.MonthMean"         
#>  [23] "TWater.1.O"                "TWater.1.P"               
#>  [25] "TWater.DayMin"             "TWater.MonthMin"          
#>  [27] "TWater.YearMin"            "LVL.15.O"                 
#>  [29] "LVL.DayMin"                "LVL.YearMean"             
#>  [31] "LVL.DayMean.HYDAT"         "LVL.MonthMax"             
#>  [33] "LVL.MonthMin"              "LVL.YearMin"              
#>  [35] "LVL.1.O"                   "LVL.MonthMean"            
#>  [37] "LVL.DayMean"               "LVL.MonthMean.HYDAT"      
#>  [39] "LVL.15.P"                  "LVL.DayMax"               
#>  [41] "LVL.YearMax"               "LVL.YearMax.HYDAT"        
#>  [43] "Water Frac.DayMax"         "SoilMoisture.Year.Max"    
#>  [45] "Water Frac.DayMin"         "Water Frac.DayMean"       
#>  [47] "Soil Moisture.1.P"         "Water Frac.MonthMax"      
#>  [49] "Soil Moisture.1.O"         "Water Frac.MonthMean"     
#>  [51] "Water Frac.MonthMin"       "3Month%"                  
#>  [53] "18Month%"                  "MonthToDate%"             
#>  [55] "Q.Baseflow.1"              "Q.RunOff.1"               
#>  [57] "Q.DayMin"                  "WWP_AlarmLevel_50 %-tile" 
#>  [59] "LowestSummerFlow2000"      "Q.MonthMax"               
#>  [61] "Q.YearMax.HYDAT"           "Q.DayRunoff"              
#>  [63] "Q.Datamart"                "WWP_AlarmLevel_75 %-tile" 
#>  [65] "Q.MonthMin"                "Q.YearMean"               
#>  [67] "Q.1.O"                     "Q.DayBaseflow"            
#>  [69] "WWP_AlarmLevel_High Limit" "Q.YearMax"                
#>  [71] "Q.DayMean"                 "Q.DayMean.HYDAT"          
#>  [73] "Q.15"                      "WWP_AlarmLevel_25 %-tile" 
#>  [75] "Q.DayMax"                  "LowestSummerFlow"         
#>  [77] "Q.MonthMean"               "Q.MonthMean.HYDAT"        
#>  [79] "Q.YearMin"                 "SoilConduct.1.P"          
#>  [81] "SoilConduct.DayMean"       "SoilConduct.1.O"          
#>  [83] "SoilConduct.DayMin"        "SoilConduct.YearMin"      
#>  [85] "SoilConduct.MonthMean"     "SoilConduct.MonthMin"     
#>  [87] "SoilConduct.YearMax"       "SoilConduct.MonthMax"     
#>  [89] "SoilConduct.DayMax"        "BAT.1.O"                  
#>  [91] "Soil Cond.MonthMean"       "Soil Cond.YrMax"          
#>  [93] "Soil Cond.YrMin"           "SoilConduct MQ1.1.O"      
#>  [95] "Soil Cond.MonthMax"        "SoilConduct MQ1.1.P"      
#>  [97] "Soil Cond.DayMean"         "Soil Cond.DayMax"         
#>  [99] "Soil Cond.YrMean"          "Soil Cond.DayMin"         
#> [101] "Soil Cond.MonthMin"        "TSoil.DayMean"            
#> [103] "TSoil.MonthMin"            "TSoil.YearMean"           
#> [105] "TSoil.1.O"                 "TSoil.MonthMax"           
#> [107] "TSoil.1.P"                 "TSoil.YearMax"            
#> [109] "TSoil.MonthMean"           "TSoil.YearMin"            
#> [111] "LVL2.1.O"                  "Precip.1.Calc"            
#> [113] "LowestSummerFlow%"         "TSoil.DayMin"             
#> [115] "TSoil.DayMax"              "TAir.MonthMin"            
#> [117] "TAir.DayMean"              "TAir.DayMin"              
#> [119] "TAir.MonthMax"             "TAir.YearMax"             
#> [121] "TAir.6hr.Max"              "TAir.24hrMax.P"           
#> [123] "TAir.1.O"                  "TAir.24hrMax.O"           
#> [125] "TAir.24hrMin.P"            "TAir.DayMax"              
#> [127] "TAir.MonthMean"            "TAir.YearMean"            
#> [129] "TAir.YearMin"              "TAir.1.P"                 
#> [131] "TAir.24hrMin.O"            "TAir.6hr.Min"             
#> [133] "SoilConduct MQ2.1.O"       "SoilConduct MQ2.1.P"      
#> [135] "SMoisture.DayMax"          "SMoisture.YearMax"        
#> [137] "SMoisture.1.O"             "SMoisture.MonthMax"       
#> [139] "SMoisture.DayMin"          "SMoisture.YearMean"       
#> [141] "SMoisture.YearMin"         "SMoisture.1.P"            
#> [143] "SMoisture.MonthMean"       "SMoisture.MonthMin"       
#> [145] "SMoisture.DayMean"
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
#> # A tibble: 454 x 7
#>    Timestamp           Value ts_name ts_id  Units station_name   station_id
#>    <dttm>              <dbl> <chr>   <chr>  <chr> <chr>          <chr>     
#>  1 2019-12-14 00:00:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#>  2 2019-12-14 00:05:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#>  3 2019-12-14 00:10:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#>  4 2019-12-14 00:15:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#>  5 2019-12-14 00:20:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#>  6 2019-12-14 00:25:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#>  7 2019-12-14 00:30:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#>  8 2019-12-14 00:35:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#>  9 2019-12-14 00:40:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#> 10 2019-12-14 00:45:00  25.0 LVL.1.O 96643~ m     Attawapiskat ~ 146273    
#> # ... with 444 more rows
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
#> # A tibble: 1,264 x 7
#>    Timestamp           Value ts_name  ts_id  Units station_name  station_id
#>    <dttm>              <dbl> <chr>    <chr>  <chr> <chr>         <chr>     
#>  1 2015-09-06 05:00:00  0.19 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#>  2 2015-09-17 05:00:00  0.18 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#>  3 2015-09-26 05:00:00  0.19 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#>  4 2015-09-27 05:00:00  0.19 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#>  5 2015-09-28 05:00:00  0.19 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#>  6 2015-10-03 05:00:00  0.21 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#>  7 2015-10-08 05:00:00  0.22 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#>  8 2015-10-12 05:00:00  0.24 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#>  9 2015-10-24 05:00:00  0.41 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#> 10 2015-11-11 05:00:00  0.42 Q.DayBa~ 11258~ cumec Chippewa Cre~ 140764    
#> # ... with 1,254 more rows

unique(my_values$ts_name)
#> [1] "Q.DayBaseflow" "Q.DayMean"
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
