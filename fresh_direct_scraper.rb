require 'mechanize'
require 'sqlite3'

mechanize = Mechanize.new
fd_db = SQLite3::Database.new("fd.db")

page = mechanize.get('https://www.freshdirect.com/srch.jsp?pageType=search&searchParams=*&pageSize=30&all=false&activePage=1&sortBy=Sort_Name&orderAsc=true&activeTab=product&departmentFilterGroup=clearall')

links = []

links << page.links_with(:dom_class => 'portrait-item-header-name')

links.flatten.each do |link|
	product_page = link.click
	product_page.search(".productDisplay-akaName").remove

	if product_page.at('span[itemprop="name"]') != nil
		product_name = product_page.at('span[itemprop="name"]').text.strip.tr('"', '')
		p product_name
	else
		p "stuck?"
	end
		
	add_row_cmd = <<-row_to_add
	INSERT INTO TEST(test) VALUES ("#{product_name}")
	row_to_add
	fd_db.execute(add_row_cmd)
end

display_cmd = <<-row_to_display
SELECT * FROM TEST
row_to_display

sql_display = fd_db.execute(display_cmd)
p sql_display

# page = mechanize.get('https://www.freshdirect.com/pdp.jsp?productId=ban_yllw&catId=ban')
# page.search(".productDisplay-akaName").remove
# product_name = page.at('span[itemprop="name"]').text.strip.tr('"', '')
# p product_name