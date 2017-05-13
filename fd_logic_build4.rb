def pricing_both_2(string_for_product)
	if string_for_product.include?(%q("price_deal"=>"nil"))
		text_split2 = String(string_for_product.split("\""))
		price = text_split2.scan(/\$[\d,]+.[\d,]+/)[0]
		price2 = price.gsub("$", "")
		price3 = price2.to_f
		return price3
	else
		text_split2 = String(string_for_product.split("\""))
		#puts text_split2
		text_split3 = String(text_split2.scan(/"(?:\S+\s)?\S*for\S*(?:\s\S+)?"/)[0])
		text_split4 = String(text_split3.scan(/\$[\d,]+.[\d,]+/))
		amount = text_split4.gsub(/[\[\]$]\"/, "$" => "", "\[" => "", "\]" => "", "\"" => "")
		amount_2 = amount.gsub(/\"\]$/, "\"" => "", "\]" => "")
		amount_3 = amount_2.gsub("$", "")
		amount_4 =  amount_3.to_f
		quant = String(text_split3.scan(/\"\d+/))
		quant2 = quant.gsub(/[\"\\\[\]]/, "")
		quant3 = quant2.to_f
		unit_price = amount_4 / quant3
		return unit_price
	end
end

def unit_vars(string_for_product)
	text_split2 = String(string_for_product.split("\""))
	text_split3 = String(text_split2.split(/\d+/))
	unit_test = text_split3.scan(/\/\w+/)[0]
	if unit_test == "/ea"
		unit = "each"
	elsif unit_test == "/lb"
		unit = "pound"
	else
		puts "unit type not added"
	end
end


test1 =  %q({"product_name"=>"Organic Broccolette", "price"=>"$3.99/ea 2 for $7.00", "price_deal"=>"2 for $7.00", 0=>"Organic Broccolette", 1=>"$3.99/ea 2 for $7.00", 2=>"2 for $7.00"}
"Organic Broccolette"
"Organic Broccolette")

test2 = %q({"product_name"=>"Just FreshDirect Blanched Almond Slices", "price"=>"$6.99/ea", "price_deal"=>"nil", 0=>"Just FreshDirect Blanched Almond Slices", 1=>"$6.99/ea", 2=>"nil"}
"Just FreshDirect Blanched Almond Slices"
"Just FreshDirect Blanched Almond Slices")


unit_text1 = unit_vars(test1)
unit_text2 = unit_vars(test2)
price_text1_2nd = pricing_both_2(test1)
price_text2_2nd = pricing_both_2(test2)
puts price_text1_2nd
puts price_text2_2nd
puts unit_text1
puts unit_text2