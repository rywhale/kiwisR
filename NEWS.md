kiwisR 0.2.2
=========================
### MINOR CHANGES
* Now using `httr2` for all queries (#27)
* Minimum R version bumped to 4.2.0 to allow for use of `|>` internally (#28)
* Added code of conduct for contributing

kiwisR 0.2.1
=========================
### MINOR CHANGES
* All queries now have an optional argument `datasource` to allow for cases
where multiple KiWIS end points are available. See your KiWIS documentation for
more information on this parameter (#21)

kiwisR 0.1.9
=========================
### MINOR CHANGES
* Fixed issues related to ``exp_live`` 
* Added CONTRIBUTING (#11)
* Cleaned up README for readability

kiwisR 0.1.8
=========================
### MINOR CHANGES
* Replaced instances of `if(class(x, "foo"))` with `inherits(x, "foo")` (#11)
* `ki_timeseries_values` now returns two more columns: `ts_id` and `station_id` (#10) 

kiwisR 0.1.7
=========================
### MINOR CHANGES
* All examples are now wrapped in `\dontrun{}` to avoid failing when a specific KiWIS server used for testing goes down (#7)
* Improvements to `exp_live` utility function should avoid tests failing when server is unreachable (#7)
* Removed hard-coded reference to `station_name` column in `ki_station_list` (#8)
* Minor tweaks to tests for `ki_timeseries_list` to hopefully lower time required for testing
* **Note:** CRAN staff on vaycay until 08/18/2019. Waiting to submit. 

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


