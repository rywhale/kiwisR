kiwisR
================

Overview
--------

A wrapper for querying KiWIS APIs to retrieve hydrometric data. Users can toggle between various databases by specifying the 'hub' argument. Currently, there are three default hubs to choose from:

1.  'swmc' - Ontario Surface Water Monitoring Centre

2.  'grand' - Grand River Conservation Authority

3.  'quinte' - Quinte Conservation Authority

You can use this package for a KiWIS hub not included in this list by feeding the location of the API service to the 'hub' argument. In general, this is everything that comes before '/KiWIS/KiWIS?service=kisters' in the URL. For example:

If your URL looks like '<http://kiwis.grandriver.ca/KiWIS/KiWIS?service=kisters&type=queryServices&request=getRequestInfo&datasource=0&format=html>'

you'd specify the hub argument with '<http://kiwis.grandriver.ca/>

Installation
------------

``` r
install.packages("remotes")
remotes::install_github("rywhale/kiwisR")
```

Then load the package with

``` r
library(kiwisR)
```

Note: If you are unable to install this way due to firewall restrictions, try downloading a zip version of the project (click "Clone or download") and then

``` r
remotes::install_local("path_to_zip")
```

Getting Station Information
---------------------------

Either get the whole station information dataframe with

``` r
swmc.stn.dat <- getStationList(hub = 'swmc')
head(swmc.stn.dat)
                     station_name station_id station_latitude station_longitude
1                    ABBOTSFORD A     133535         49.03308        -122.36667
2                        ABERDEEN     121939         45.45000         -98.43308
3                  ABITIBI CANYON     148200         49.91642         -81.56667
```

``` r
grand.stn.dat <- getStationList(hub = 'grand')
head(grand.stn.dat)


or subset based on location like this
```

``` r
# Bbox format = (min_x, min_y, max_x, max_y)
bbox <- "-80.126038,43.458297,-79.002481,43.969098"
stns <- getStationList(hub = 'swmc', bounding.box = bbox)
head(stns)
                  station_name station_id station_latitude station_longitude
1                 ALBION HILLS     137457         43.93308         -79.83333
2 Acton Sewage Treatment Plant     149765         43.63114         -80.01667
3                  BELFOUNTAIN     147848         43.79975         -80.01667
```

You can also search for stations by name. This function allows the use of \* as a wildcard.

``` r
# By exact name
my.stn <- searchStations(hub = 'swmc', "Lake Ontario at Toronto")
my.stn
             station_name station_id station_latitude station_longitude
1 Lake Ontario at Toronto     144186      43.64169322      -79.38030507

# All stations starting with 'A'
a.stns <- searchStations(hub = 'swmc', "A*")
head(a.stns)
     station_name station_id station_latitude station_longitude
1    ABBOTSFORD A     133535      49.03307961      -122.3666708
2         ALERT A     132255      82.51666993       -62.2830803
3      ALEXANDRIA     147654      45.31666964      -74.61666967

# All stations ending with 'Oshawa'
oshawa.stns <- searchStations(hub = 'swmc', "*Oshawa")
oshawa.stns
              station_name station_id station_latitude station_longitude
1 Harmony Creek at Oshawa     144396      43.88334204      -78.81585606
2  Oshawa Creek at Oshawa     144342      43.92808201      -78.89113781
```

Getting Timeseries Information
------------------------------

The dataframe produced with searchStations() or getStationList() contains a column called 'station\_id'. These values can be used to generate a list of timeseries available for that station.

``` r
stn.ts <- getTimeseriesList(hub = 'swmc', station.id = "144659")
head(stn.ts)
      ts_name     ts_id
1   Q.DayMean 949057042
2       Q.1.O 949048042
3    Q.DayMax 949056042
```

Getting Timeseries Values
-------------------------

Similarly, the dataframe produced by getTimeseriesList() contains a column called 'ts\_id' which you'll use to access data for a specific timeseries. By default, data for the past 24 hours is returned (all time stamps are in UTC).

``` r
ts.dat <- getTimeseriesValues(hub = 'swmc', ts.id = "948928042")
head(ts.dat)
            Timestamp Value(millimeter)
1 2017-11-25 00:00:00               0.0
2 2017-11-25 00:15:00               0.0
```

You can provide a date range by specifying the 'from' and 'to' variables.

Acceptable date formats are: 'yyyy-MM-dd HH:mm:ss', 'yyyy-MM-dd', 'yyyy-MM', 'yyyy'.

``` r
# Query with date range
ts.dat <- getTimeseriesValues(hub = 'swmc',
                              ts.id = "948928042", 
                              from = "2017-01-01", 
                              to = "2017-02-22")
head(ts.dat)
            Timestamp Value(millimeter)
1 2017-01-01 05:15:00               0.0
2 2017-01-01 05:30:00               0.0
3 2017-01-01 05:45:00               0.0
```

Using Lapply to Get Data for Multiple Timeseries
------------------------------------------------

``` r
# Vector of ts_ids to get values for
ts.ids <- c("948928042", "948603042")

# Returns a list of dataframes
ts.dats <- lapply(ts.ids, function(x){
  getTimeseriesValues(x,
                      hub = 'swmc',
                      from = "2017-08-28", 
                      to = "2017-09-13")
  })

# First timeseries dataframe
head(ts.dats[[1]])
            Timestamp Value(millimeter)
1 2017-08-28 00:00:00               0.0
2 2017-08-28 00:15:00               0.0

# Second timeseries dataframe
head(ts.dats[[2]])
            Timestamp Value(cubic meter per second)
1 2017-08-28 05:00:00                         0.251
2 2017-08-29 05:00:00                         0.243
3 2017-08-30 05:00:00                         0.243
```

Error Message Explanations
--------------------------

"No values available for that selection" : Query returned empty table

"The ts\_id or date range is invalid" : No record was found for the chosen ts\_id/date range

"The ts\_id is invalid": No record was found for the chosen ts\_id
