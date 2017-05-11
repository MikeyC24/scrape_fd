require 'mechanize'
require 'sqlite3'
require 'csv'

mechanize = Mechanize.new

database = File.new("fd.db", "a")
database.close

fd_db = SQLite3::Database.new("fd.db")
 
# adjust the page size param to change the number of pruducts pulled 
page = mechanize.get('https://www.freshdirect.com/srch.jsp?pageType=search&searchParams=*&pageSize=30&all=false&activePage=1&sortBy=Sort_Name&orderAsc=true&activeTab=product&departmentFilterGroup=clearall')

def pull_text(css_path_string, mechanize_page)
	if mechanize_page.at(css_path_string) != nil
		return mechanize_page.at(css_path_string).text.strip
	end
end

def not_nil(string)
	if string == nil
		return "nil"
	elsif string.length > 250
		return "nil"
	else
		return string
	end
end

def execute_sql_to_csv(sql_string,name_of_primary_table_queried, database)

	# if a csv exists that has the same name as the table we searched (ie accounts) erase everything on it. If not create that csv.
	File.open("#{name_of_primary_table_queried}.csv", "a") {|file| file.truncate(0) }
	
	headers = []
	headers << database.prepare(sql_string).columns

	File.open("#{name_of_primary_table_queried}.csv", "w") {|f| f.write(headers.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}


	database.execute(sql_string) do |row|
		entry = []
		entry << row
		File.open("#{name_of_primary_table_queried}.csv", "a") {|f| f.write(entry.inject([]) { |csv, row|  csv << CSV.generate_line(row) }.join(""))}
	end
end


headers = ["product_name", "serving_size", "servings", "total_fat", "cholesterol", "sodium", "total_carb", "dietary_fiber", "sugars", "url"]

table_header = "id INTEGER PRIMARY KEY,"
table_header_for_insert = ""
counter = 0

headers.each do |header|
	table_header +=
	" #{header} TEXT"
	counter+=1
	if counter < headers.length
		table_header +=
		","
	end
end

counter = 0
headers.each do |header|
	table_header_for_insert +=
	"#{header}"
	counter+=1
	if counter < headers.length
		table_header_for_insert +=
		", "
	end
end

create_table_cmd = <<-SQL
  CREATE TABLE IF NOT EXISTS products(
  #{table_header}
  );
SQL
fd_db.execute(create_table_cmd)



links = []

links << page.links_with(:dom_class => 'portrait-item-header-name')

links.flatten.each do |link|
	values = []
	value_for_insert = ""

	product_page = link.click
	product_page.search(".productDisplay-akaName").remove

	product_name = pull_text('span[itemprop="name"]', product_page)
	product_name = not_nil( product_name)
	product_name.strip.tr('"', '')
	
	product_name.gsub!(/"|'/, ' ')
	values << product_name

	serving_size = pull_text('td:contains("Serv. Size"), .text9', product_page)
	serving_size = not_nil( serving_size)
	serving_size.gsub!(/"|'/, ' ')
	values << serving_size

	servings = pull_text('td:contains("Calories"), .text9', product_page)
	servings = not_nil( servings)
	servings.gsub!(/"|'/, ' ')
	values << servings

	total_fat = pull_text('td:contains("Total Fat"), .text9', product_page)
	total_fat = not_nil(total_fat)
	total_fat.gsub!(/"|'/, ' ')
	values << total_fat

	cholesterol = pull_text('td:contains("Cholesterol"), .text9', product_page)
	cholesterol = not_nil( cholesterol)
	cholesterol.gsub!(/"|'/, ' ')
	values << cholesterol

	sodium = pull_text('td:contains("Sodium"), .text9', product_page)
	sodium = not_nil(sodium)
	sodium.gsub!(/"|'/, ' ')
	values << sodium


	total_carb = pull_text('td:contains("Total Carbohydrate"), .text9', product_page)
	total_carb = not_nil(total_carb)
	total_carb = total_carb.gsub(/\s+/, ' ')
	total_carb.delete!("\n")
	total_carb.gsub!(/"|'/, ' ')
	values << total_carb

	dietary_fiber = pull_text('td:contains("Dietary Fiber"), .text9', product_page)
	dietary_fiber = not_nil( dietary_fiber)
	dietary_fiber = dietary_fiber.gsub(/\s+/, ' ')
	dietary_fiber.delete!("\n")
	dietary_fiber.gsub!(/\s|"|'/, '')
	values << dietary_fiber

	sugars = pull_text('td:contains("Sugars"), .text9', product_page)
	sugars = not_nil( sugars)
	sugars = sugars.gsub(/\s+/, ' ')
	sugars.delete!("\n")
	sugars.gsub!(/"|'/, ' ')
	values << sugars

	url = product_page.uri.to_s
	values << url

	value_for_insert = ""
	counter = 0
	values.each do |value|
		preped_value = <<-value_prepper
		"#{value}"
		value_prepper
		value_for_insert += preped_value
		counter+=1
		if counter < headers.length
			value_for_insert +=
			","
		end
	end

add_row_cmd = <<-row_to_add
	INSERT INTO products(#{table_header_for_insert}) VALUES (#{value_for_insert})
	row_to_add
	add_row_cmd.gsub!(/\t/, '')
	add_row_cmd.delete!("\n")
	fd_db.execute(add_row_cmd)	
end

# # export products to csv for fun
# table_to_query = "products"

# sqlcommand = <<-sql
# SELECT * FROM #{table_to_query}
# sql

# execute_sql_to_csv(sqlcommand, table_to_query, fd_db)