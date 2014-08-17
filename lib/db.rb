require 'sequel'

Sequel.default_timezone = :utc

class FoodDatabase
  def initialize(path)
    @db = Sequel.connect "sqlite://#{path}.db"
  end

  def create_tables
    @db.create_table? :food do
      primary_key :id
      String :food_name
      Time :time_brought
    end
  end

  def add_food(name, time=Time.now.utc)
    @db.transaction do
      @db[:food].insert food_name: name, time_brought: time
    end
  end

  def remove_food(name)
    @db.transaction do
      to_remove = @db[:food].where food_name: name
      to_remove.delete
    end
  end

  def get_all_food(order_by=:time_brought)
    @db[:food].order(order_by).all
  end

  def search(string)
    @db['select * from food where upper(food_name) like upper(?)', "%#{string}%"]
  end

  def drop_tables
    @db.drop_table? :food
  end
end
