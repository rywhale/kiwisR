kiwisR 0.1.6
=========================
### BREAKING CHANGES
* Rework of `ki_timeseries_values` to better conform to tidy principles (#6)
  * Now returns a tibble with the column format 
  
    |Timestamp          | Value | ts_name | Units | station_name |
    |-------------------| ----- | ------- | ----- | ------------ |
    |2019-05-01 00:00:00| 12.0  | LVL.1.O |  m    | Station_1    |
    |2019-05-02 00:00:00| 12.1  | LVL.1.O |  m    | Station_1    |
    
  * This makes querying data for multiple ts_ids/stations much more convienient
  * May break existing code that referenced parameter value column by name (e.g.- "LVL", "Q", etc.)
    
### IMPROVEMENTS
* Added `skip_if_exp_down` fun to handle skipping tests when configured example server is down
  * Addresses issues related to CRAN tests failing when this server is down
* Centralized test metadata to make switching between hubs easier for local testing web KISTERS example server is down
* Added `.name_repair = "minimal"` to `as_tibble`

### MINOR CHANGES
* Reverted to using 'swmc' hub due to issues with KISTERS default KiWIS server
* Fixed bug in `ki_station_list` that caused station_latitude to be returned as array (#5)
* Added `dplyr` dependency to clean up table formatting

kiwisR 0.1.5
=========================
### IMPROVEMENTS
* Changes to `check_hub` to address query speed degredation
  * Was previously checking the server for every query which wrecked query times for looped/repeated queries
* Added tests for faulty URLs passed to ki_* functions (to replace the degredated server checking aspects of `check_hub`)

### MINOR CHANGES
* Fixed small bug fix in `ki_station_list` that caused errors when passing optional returnfields
containing string 'lon' 


kiwisR 0.1.4
=========================
* Minor formatting changes to DESCRIPTION ('' around software names, etc)
* CRAN submission accepted :)

kiwisR 0.1.3
=========================
* Changes in response to CRAN reviewer comments

### IMPROVEMENTS
* Unit tests for `ki_group_list`
* Removed \dontrun from all examples and replaced with examples that use `kisters` hub

### MINOR CHANGES
* Added information about WISKI/KISTERS/KiWIS to DESCRIPTION


kiwisR 0.1.2
=========================
* Changes in preparation for first CRAN submission

### IMPROVEMENTS
* Unit tests added with `testthat`
* `skip_if_net_down()` function from @boshek to skip tests
  if no internet access ("failing gracefully")
* Added better HTTP request error handling using `tryCatch`
* Added a `NEWS.md` file to track changes to the package.
* Added Travis-Cl 
* Removed broken hubs and added the [KISTERS example KiWIS server](http://kiwis.kisters.de/KiWIS/KiWIS?datasource=0&service=kisters&type=queryServices&request=getrequestinfo) as a default
  * This hub is now used for the unit tests
* Default hubs now stored in list to streamline adding/removing/matching
* Added badges to README
* `check_hub()` changes
  * now checks for internet before proceeding
  * now checks server status using `httr::http_status()` and returns error message
  if server can't be reached (especially useful for piping in non-default servers)
* `check_date()` function to handle checking user-provided date strings

### MINOR CHANGES
* Spelling and grammar checked README/docs
* Switched to suggesting `devtools` for development installation (was `remotes`)
* Hex logo created (small and lg versions) and added to `tools/readme`
  * [Original kiwis image is creative commons](https://commons.wikimedia.org/wiki/File:Apteryx_owenii_0.jpg)


