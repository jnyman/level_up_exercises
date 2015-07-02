#!/usr/bin/env ruby

require 'hirb'

require_relative 'importer'
require_relative 'converter'
require_relative 'rolodex'
require_relative 'dinosaur'

class DinoDex
  attr_accessor :options

  def initialize(config = {})
    extend Hirb::Console
    @options = {
      path: config[:path] || 'data/*.csv',
      headers: true,
      converters: config[:converters] || Converter.dino_data_convert,
      header_converters: config[:header_converters] || Converter.header_convert,
    }
    create_file_path
    @data = Importer.new(options, Dinosaur)
    @rolodex = Rolodex.new(Dinosaur::HEADERS)
    display_title
    execute_command_loop
  end

  private

  def display_title
    puts '-' * 30 << "\nDINODEX\n" << '-' * 30
  end

  def execute_command_loop
    loop do
      print 'DinoDex $ '
      command = gets.chomp
      exit if command == 'quit'
      execute_command(command)
    end
  end

  def execute_command(command)
    list if command == 'list'
    details if command == 'details'
    query if command == 'query'
  end

  def list
    table(@data.data_set.values, fields: Dinosaur.headers)
  end

  def details
    list = menu(@data.data_set.values, fields: Dinosaur.headers)
    item = @rolodex.show_details(@data.data_set, *list)
    table(item.values, fields: Dinosaur.headers)
  end

  def query
    command = ''
    until command == 'exit'
      print 'DinoDex <Query Mode> $ '
      command = gets.chomp
      results = @rolodex.query(@data.data_set, command)
      table(results.values, fields: Dinosaur.headers)
    end
  end

  def create_file_path
    return unless File.extname(options[:path]).empty?
    @options[:path] += '/' unless ends_with_slash?(options[:path])
    @options[:path] += '*.csv' if no_extension?(options[:path])
  end

  def no_extension?(path)
    File.extname(path).empty?
  end

  def ends_with_slash?(path)
    path.split('').last == '/'
  end
end

DinoDex.new
