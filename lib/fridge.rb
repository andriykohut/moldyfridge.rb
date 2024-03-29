require 'formatador'
require_relative 'db'

class Utils

  def self.seconds_to_string(s)

    # d = days, h = hours, m = minutes, s = seconds
    m = (s / 60).floor
    s = s % 60
    h = (m / 60).floor
    m = m % 60
    d = (h / 24).floor
    h = h % 24

    output = "#{s} second#{Utils.pluralize(s)}" if (s > 0)
    output = "#{m} minute#{Utils.pluralize(m)}, #{s} second#{Utils.pluralize(s)}" if (m > 0)
    output = "#{h} hour#{Utils.pluralize(h)}, #{m} minute#{Utils.pluralize(m)}, #{s} second#{Utils.pluralize(s)}" if (h > 0)
    output = "#{d} day#{Utils.pluralize(d)}, #{h} hour#{Utils.pluralize(h)}, #{m} minute#{Utils.pluralize(m)}, #{s} second#{Utils.pluralize(s)}" if (d > 0)

    return output
  end

  def self.pluralize number 
    return "s" unless number == 1
    return ""
  end

end

class MoldyFridge
  def initialize(db_path)
    @db = FoodDatabase.new db_path
    @db.create_tables
  end

  def get_food(order_by=:time_brought)
    table_data = []
    @db.get_all_food(order_by).each do |food|
      brought = food[:time_brought].localtime
      age = Utils::seconds_to_string (Time.now - brought).round
      table_data << {id: food[:id], name: food[:food_name], brought: brought, age: age}
    end
    table_data
  end

  def list_food(order_by=:time_brought, columns=[:id, :name, :age])
    table_data = get_food(order_by)
    Formatador.display_table(table_data, columns)
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

  def search(name)
    food = @db.search name
    Formatador.display_table(food)
  end
end
