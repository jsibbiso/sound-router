require 'sinatra'
require 'data_mapper'
require 'json'

configure do
  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/soundRouter.db")
  
  class Connection
    include DataMapper::Resource
    
    property :id, Serial
    property :input, String
    property :output, String
    property :connected, Boolean
  end
  
  # automatically migrate database if needed
  DataMapper.auto_migrate!
end

get '/' do
  "Hello"
end

post '/connection' do
	body = JSON.parse(request.body.read)
	Connection.first(:input => body["input"],:output => body["output"]).update(:connected => body["connected"])
end

post '/mute' do
	body = JSON.parse(request.body.read)
	outputs = {}
	outputs = {:output => body["output"]} if body["output"]
	Connection.all(outputs).update(:connected => false)
end