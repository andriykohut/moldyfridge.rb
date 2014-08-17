require_relative 'db'


class MoldyFridge
  def initialize(db_path)
    @db = FoodDatabase.new db_path
    @db.create_tables
  end

  def list_food(order_by=:time_brought)
    @db.get_all_food(order_by).each do |food|
      puts "#{food[:food_name]} - #{food[:time_brought].localtime}"
    end
  end

  def insert(name)
    @db.add_food name
  end

  def remove(name)
    @db.remove_food name
  end

  def clear
    @db.drop_tables
  end
end
