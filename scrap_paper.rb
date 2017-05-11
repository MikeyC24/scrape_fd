## search one page

	# page = mechanize.get('https://www.freshdirect.com/pdp.jsp?productId=ban_yllw&catId=ban')
	# page.search(".productDisplay-akaName").remove
	# product_name = page.at('span[itemprop="name"]').text.strip.tr('"', '')
	# p product_name

## Basic scraper from tutorial

	# require 'mechanize'

	# mechanize = Mechanize.new

	# page = mechanize.get('http://en.wikipedia.org/wiki/Main_Page')

	# link = page.link_with(text: 'Random article')

	# page = link.click

	# puts page.uri

## scraper that fills out forms form tutorial

	# require 'mechanize'

	# mechanize = Mechanize.new

	# page = mechanize.get('https://www.gov.uk/')

	# form = page.forms.first

	# form['q'] = 'passport'

	# page = form.submit

	# page.search('#results h3').each do |h3|
	#   puts h3.text.strip
	# end
	# Instead of searching by CSS selector we pick the first form on the page, and set the value of the search field, just as if we had been using a web browser directly. Then we submit the form and list out the top results.
