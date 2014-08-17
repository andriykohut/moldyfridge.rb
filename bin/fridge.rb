#!/usr/bin/env ruby
require 'yaml'
require_relative '../lib/fridge.rb'

config_path = '../etc/fridge.yaml'


def get_fridge(config_path)
  config = YAML.load_file(config_path)
  db_name = config['db_name']
  MoldyFridge.new "../db/#{db_name}"
end

fridge = get_fridge config_path

def run(fridge)
  action = ARGV[0]
  food = ARGV[1]
  case action
  when 'list', 'ls', nil
    fridge.list_food
  when 'add', 'insert'
    fridge.insert food
  when 'remove', 'rm'
    fridge.remove food
  when 'drop', 'clear'
    fridge.clear
  else
    puts "Error"
  end
end

run fridge
