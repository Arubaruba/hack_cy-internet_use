d3.csv('internet_use_over_time.csv', (importedWorldBankData) ->
  ## Constants

  C_BACKGROUND = '#00cc00';

  BAR_HEIGHT = 10
  BAR_SPACING = 4
  DOCUMENT_WIDTH = 800
  DOCUMENT_HEIGHT = 800

  selectedYear = 0

  countries = window.worldBankDataParser.countryData(importedWorldBankData)

  d3.select document.body
  .style 'background-color', C_BACKGROUND
  .style 'margin', 0
  .style 'font-family', 'Helvetica'

  svg = d3.select(document.body).append 'svg'
  .attr 'viewBox', () -> "0 0 #{DOCUMENT_WIDTH} #{DOCUMENT_HEIGHT}"

  # Add the bars
  svg.selectAll 'rect'
  .data countries
  .enter().append 'rect'
  .attr(
    x: 0
    y: (country, i) -> i * (BAR_HEIGHT + BAR_SPACING )
    width: (country) ->
#      country.values[selectedYear]
      100

    height: BAR_HEIGHT
  )
  .style 'fill', '#000fff'

  a = 1
)