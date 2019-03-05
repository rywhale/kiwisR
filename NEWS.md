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


