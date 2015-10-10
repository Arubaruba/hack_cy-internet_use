###

Restructures data after it was read into an array from a file exported from the worldbank data bank
see:  http://databank.worldbank.org/data/reports.aspx?source=world-development-indicators&preview=on#

Limitations:
Currently only supports data with one "Series" (Adjusted Income, GDP, etc..)

###

window.worldBankDataParser =
  # Simply find the first year mentioned and return it
  yearRange: (importedWorldBankData) ->
    range =
      startDate: null
      endDate: null

    for key in Object.keys(importedWorldBankData[0])
      matches = key.match(/^(\d{4})/)
      if matches
        range.startDate = matches[0] if range.startDate == null
        range.endDate = matches[0]

    range


  # Return an array mapping country names to an array of yearly data values
  countryData: (importedWorldBankData) ->
    importedWorldBankData
    # For some reason the CSV parser causes empty items to appear in the parsed data, remove them
    .filter (countryData) -> countryData['Country Code'].length > 0
    .map (countryData) ->
      name: countryData['Country Name']
      values:
        # Get that represent years
        Object.keys(countryData)
        .map (key) ->
          matches = key.match(/^(\d{4})/)
          # Whether the key is a year
          if matches
            firstYear = matches[0] if !firstYear
            # If it's a year we check if the data is available
            # unavailable values will be replaces with null
            val = countryData[key]
            if val == '..' then null else parseFloat(val)
        # Remove all of the rows that were not years (but keep unavailable years which are null)
        # note the != compiles to !== allowing for a distinction between undefined and null
        .filter (val) -> val != undefined
    .filter (country) -> country['values'] != undefined
