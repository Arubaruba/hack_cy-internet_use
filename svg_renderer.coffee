d3.xml('access_to_internet_over_time.svg', (xml) ->
  C_BACKGROUND = '#272530'

  BAR_OFFSET_X = 80
  MAX_COUNTRIES = 9

  BINARY_DIGIT_COUNT = 12
  BINARY_OFFSET_INITIAL_Y = 2
  BINARY_OFFSET_Y = 11
  MAX_BINARY_LINES = 23
  DOCUMENT_WIDTH = 842

  d3.select document.body
  .style 'background-color', C_BACKGROUND
  .style 'margin', 0
  .style 'font-family', 'Helvetica'

  svg = d3.select(document.body.appendChild(xml.documentElement))

  barTemplate = svg.select('#bar').remove()

  d3.csv('internet_use_over_time.csv', (importedWorldBankData) ->
    yearRange = window.worldBankDataParser.yearRange(importedWorldBankData)
    countries = window.worldBankDataParser.countryData(importedWorldBankData)

    getCountryData = (yearIndex) ->
      sortedCountries = countries
      .map((country) ->
        name: country.name
        value: country.values[yearIndex])
      .sort((country1, country2) ->
        country2.value - country1.value
      ) #.slice(0, MAX_COUNTRIES)
      countries.map (country) ->
        rank = 0
        for c, i in sortedCountries
          if country.name == c.name
            rank = i

        name: country.name
        ranking: rank
        value: country.values[yearIndex]

    asdf = getCountryData(1)
    asdf1 = getCountryData(10)

    countryGroups = svg.append('g').selectAll('g')
    .data getCountryData(10)
    .enter().append 'g'
    .html((country, countryIndex) ->
      bar = d3.select(svg.node().appendChild(barTemplate.node().cloneNode(true)))
      .transition().ease('cubic-in').duration(200)
      .attr 'transform', "translate(#{BAR_OFFSET_X * (country.ranking)}, 0)"
      .attr 'name', countryIndex

      bar.select('#country-name').text country.name

      binaryTemplate = bar.select('#binary').remove()
      binaryLineCount = MAX_BINARY_LINES * country.value / 100

      for lineIndex in [0..Math.floor(binaryLineCount)]
        binary = d3.select(bar.node().appendChild(binaryTemplate.node().cloneNode(true)))
        .style 'font-family', 'monospace'
        .attr 'transform', "translate(0, #{(MAX_BINARY_LINES - lineIndex) * BINARY_OFFSET_Y + BINARY_OFFSET_INITIAL_Y})"

        # if we're not a the last line we print the full number of digits
        # else we calculate the remainder of the binaryLineCount
        digits = if Math.floor(binaryLineCount) != lineIndex
          BINARY_DIGIT_COUNT
        else
          BINARY_DIGIT_COUNT * (binaryLineCount - Math.floor(binaryLineCount))

        randomizedBinary = ''
        for i in [0..digits]
          randomizedBinary += (Math.ceil(Math.random() * 100)) % 2

        binary.select('text').text(randomizedBinary)
        .style 'font-family', 'monospace'
    )


    d3.select('#slider-rect')
    .on('mousemove', () ->

      d3.select('#slider-sym')
      .attr('transform', "translate(#{Math.ceil(d3.mouse(@)[0]) - 50},0)")

      console.log (d3.mouse(@)[0] / DOCUMENT_WIDTH)
      data = getCountryData(Math.floor(d3.mouse(@)[0] / DOCUMENT_WIDTH * (yearRange.endDate - yearRange.startDate)))
      console.log ((yearRange.end - yearRange.start))
      d3.select(document.body).selectAll('#bar')
#      .transition().ease('cubic-in').duration(200)
      # TODO HACK - SUPER BAD :((((
      .transition().ease('cubic-in').duration(200)
      .attr 'transform', (country, countryIndex) ->
        "translate(#{BAR_OFFSET_X * (data[countryIndex].ranking)}, 0)"

      .each((c, ci) ->
        bar = d3.select(@)

        binaryTemplate = bar.select('#binary').remove()
        bar.selectAll('#binary').remove()
        binaryLineCount = MAX_BINARY_LINES * data[ci].value / 100

        for lineIndex in [0..Math.floor(binaryLineCount)]
          binary = d3.select(bar.node().appendChild(binaryTemplate.node().cloneNode(true)))
          .style 'font-family', 'monospace'
          .attr 'transform', "translate(0, #{(MAX_BINARY_LINES - lineIndex) * BINARY_OFFSET_Y + BINARY_OFFSET_INITIAL_Y})"

          # if we're not a the last line we print the full number of digits
          # else we calculate the remainder of the binaryLineCount
          digits = if Math.floor(binaryLineCount) != lineIndex
            BINARY_DIGIT_COUNT
          else
            BINARY_DIGIT_COUNT * (binaryLineCount - Math.floor(binaryLineCount))

          randomizedBinary = ''
          for i in [0..digits]
            randomizedBinary += (Math.ceil(Math.random() * 100)) % 2

          binary.select('text').text(randomizedBinary)
          .style 'font-family', 'monospace'

      )
    )
  )
)
