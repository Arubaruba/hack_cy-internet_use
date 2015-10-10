d3.xml('access_to_internet_over_time.svg', (xml) ->
  C_BACKGROUND = '#272530'

  BAR_OFFSET_X = 80
  MAX_COUNTRIES = 9
  MAX_COUNTRY_LETTERS = 6
  BINARY_DIGIT_COUNT = 11
  BINARY_OFFSET_INITIAL_Y = 7
  BINARY_OFFSET_Y = 11

  d3.select document.body
  .style 'background-color', C_BACKGROUND
  .style 'margin', 0
  .style 'font-family', 'Helvetica'

  svg = d3.select(document.body.appendChild(xml.documentElement))

  barTemplate = svg.select('#bar').remove()

  d3.csv('internet_use_over_time.csv', (importedWorldBankData) ->
    yearRange = window.worldBankDataParser.yearRange(importedWorldBankData)
    countries = window.worldBankDataParser.countryData(importedWorldBankData)

    for country, countryIndex in countries.slice(0, MAX_COUNTRIES)
      bar = d3.select(svg.node().appendChild(barTemplate.node().cloneNode(true)))
      .attr 'transform', "translate(#{BAR_OFFSET_X * countryIndex}, 0)"

      bar.select('#country-name').text country.name.toUpperCase().slice(0, MAX_COUNTRY_LETTERS)

      binaryTemplate =  bar.select('#binary').remove()

      for percentage in [0..23]
        binary = d3.select(bar.node().appendChild(binaryTemplate.node().cloneNode(true)))
        .style 'font-family', 'monospace'
        .attr 'transform', "translate(0, #{percentage * 11 + BINARY_OFFSET_INITIAL_Y})"

        randomizedBinary = '1'
        for i in [0..BINARY_DIGIT_COUNT]
          randomizedBinary += (Math.ceil(Math.random() * 100)) % 2

        binary.select('text').text(randomizedBinary)
        .style 'font-family', 'monospace'
  )
)

d3.csv('internet_use_over_time.csv', (importedWorldBankData) ->
  return
  ## Constants
  C_BACKGROUND = '#00cc00';

  BAR_HEIGHT = 20
  BAR_SPACING = 4
  BAR_LABEL_FONT_SIZE = 13
  DOCUMENT_WIDTH = 800
  DOCUMENT_HEIGHT = 800

  yearRange = window.worldBankDataParser.yearRange(importedWorldBankData)
  countries = window.worldBankDataParser.countryData(importedWorldBankData)

  yearIndex = 0

  xScale = d3.scale.linear()
  .domain([0, 100])
  .range([0, DOCUMENT_WIDTH])

  d3.select document.body
  .style 'background-color', C_BACKGROUND
  .style 'margin', 0
  .style 'font-family', 'Helvetica'

  svg = d3.select(document.body).append 'svg'
  .attr 'viewBox', () -> "0 0 #{DOCUMENT_WIDTH} #{DOCUMENT_HEIGHT}"

  # Add the bars
  bars = svg.append('g').selectAll 'g'
  .data countries
  .enter().append 'g'
  .attr 'transform', 'translate(0, 40)'

  bars.append('rect')
  .attr(
    x: 0
    y: (country, i) -> i * (BAR_HEIGHT + BAR_SPACING )
    width: (country) -> xScale(country.values[yearIndex])
    height: BAR_HEIGHT
  )
  .style 'fill', '#000fff'

  bars.append('text')
  .style 'font-size', BAR_LABEL_FONT_SIZE + 'px'
  .attr(
    x: 0
    y: (country, i) -> i * (BAR_HEIGHT + BAR_SPACING) + BAR_LABEL_FONT_SIZE
  )
  .text (country) -> country.name.toUpperCase()

  yearSelectors = svg.append('g').selectAll('g')
  .data [yearRange.startDate..yearRange.endDate]
  .enter().append('g')

  yearSelectors.append('rect')
  .attr(
    x: (year, i) -> i * 20
    y: 0
    width: 20
    height: 20
  )
  .style 'fill', '#00ffff'
  .on('mouseover', (year, i) ->
    bars.selectAll('rect')
    .transition().delay(0).ease('cubic-out').duration(300)
    .attr 'width', (country) -> xScale(country.values[i])
  )

  yearSelectors.append 'text'
  .attr (
    x: (year, i) -> i * 20
    y: 20
  )
  .text (year) -> year
  .style 'font-size', '8px'
)