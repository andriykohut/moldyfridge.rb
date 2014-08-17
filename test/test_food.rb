require_relative "../lib/db.rb"

db = FoodDatabase.new 'test'
db.create_tables
db.add_food 'Tomato'
db.add_food 'Pepper'

puts db.get_all_food

#db.drop_tables
