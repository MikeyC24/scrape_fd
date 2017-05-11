require 'sqlite3'

fd_db = SQLite3::Database.new("fd.db")

fd_db.results_as_hash = true

sqlcommand = <<-hi_chapman
SELECT product_name, price, price_deal FROM products
hi_chapman

price_info = fd_db.execute(sqlcommand)