units = ["/ea", "/lb"]
=begin
if price_deal = nil
	if price includes units[x]
		that units[x] = product_unit
	else
		find regex for first $, print that no units were found
else
	use price deal for price 
end
end
=end

text = %q("product_name"=>"100% Grass-Fed Local 85% Lean Ground Beef, Frozen", "price"=>"$8.99/ea 2 for $14.00", "price_deal"=>"2 for $14.00", 0=>"100% Grass-Fed Local 85% Lean Ground Beef, Frozen", 1=>"$8.99/ea 2 for $14.00", 2=>"2 for $14.00"}
"100% Grass-Fed Local 85% Lean Ground Beef, Frozen"
"100% Grass-Fed Local 85% Lean Ground Beef, Frozen")

puts text.is_a?(String)
puts text.is_a?(Integer)
#text_split1 = text.split("\"")
#print text_split1
#price = text.scan(/\$[\d,]+.[\d,]+/)[0]
#price = text_split2.scan(/\$[\d,]+.[\d,]+/)[0]
#puts price
puts " "
def pricing_vars(string_for_product)
	puts string_for_product.class
	text_split2 = String(string_for_product.split("\""))
	puts text_split2.class
	price = text_split2.scan(/\$[\d,]+.[\d,]+/)[0]
	return price
end

def unit_vars(string_for_product)
	puts string_for_product.class
	text_split2 = String(string_for_product.split("\""))
	puts text_split2.class
	#price = text_split2.scan(/\$[\d,]+.[\d,]+/)[0]
	#puts price.class
	text_split3 = String(text_split2.split(/\d+/))
	puts text_split3.class
	unit_test = text_split3.scan(/\/\w+/)[0]
	puts unit_test.class
	if unit_test == "/ea"
		unit = "each"
		#return unit
	elsif unit_test == "/lb"
		unit = "pound"
		#return unit 
	else
		puts "unit type not added"
	end
	#return unit
end




price = pricing_vars(text)
unit = unit_vars(text)	
puts price
puts unit

=begin
price = text.scan(/\$[\d,]+.[\d,]+/)[0]
unit_test = text.scan(/\/\w+/)[0]
if unit_test == "/ea"
	unit = "each"
elsif unit_test == "/lb"
	unit = "pound"
else
	puts "unit type not added"
end
puts price
puts unit
=end