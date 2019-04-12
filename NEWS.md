kiwisR 0.1.4.5
=========================
* Testing changes to `check_hub` to address query speed degredation 


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


