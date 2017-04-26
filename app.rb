#!/usr/bin/env ruby

require 'sinatra'

DATA_DIR = File.absolute_path(ENV['DATA_DIR'] || './data')


get '/:collection_name' do |collection_name|
  halt 404 if !collection_exists? collection_name
  strings_for(collection_name).join("\n")
end

post '/:collection_name' do |collection_name|
  request.body.rewind
  add_to_collection(collection_name, request.body.read)
end

helpers do

  def collection_exists? collection_name
    File.exists? path_for collection_name
  end

  def strings_for collection_name
    content_of(collection_name).split("\n")
  end

  def add_to_collection collection_name, string
    File.open(path_for(collection_name), 'a') do |fh|
      fh.puts string
    end
  end

  def path_for name
    File.join DATA_DIR, "#{name}.txt"
  end

  def content_of collection_name
    File.read(path_for(collection_name))
  rescue Errno::ENOENT
    ""
  end
end

