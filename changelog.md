# Version 3
- passing version is mandatory: we use dedicated classes for each Dhis2 versions. This lets us adapt validations, constants and methods.
- we can get raw json from Dhis2 (skip class instantiation and case change)
- we can send raw json to Dhis2 (skip case change and validations)
- to complement `list`, `fetch_paginated_data` iterates over all elements requesting each page if necessary
- `root_junction` is now an allowed query param
- fixtures contain payload from versions 2.24 to 2.28 to help you check what data is received