require 'sinatra'
require 'data_mapper'
require 'json'
require 'slim'

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
	@connections = Connection.all(:order => [:input.asc, :output.asc])
  slim :index
end

post '/reset' do
	Connection.destroy
	Connection.create(:input => 'a', :output => 'a', :connected => true)
	Connection.create(:input => 'a', :output => 'b', :connected => false)
	Connection.create(:input => 'a', :output => 'c', :connected => false)
	Connection.create(:input => 'a', :output => 'd', :connected => false)
	Connection.create(:input => 'b', :output => 'a', :connected => false)
	Connection.create(:input => 'b', :output => 'b', :connected => true)
	Connection.create(:input => 'b', :output => 'c', :connected => false)
	Connection.create(:input => 'b', :output => 'd', :connected => false)
	Connection.create(:input => 'c', :output => 'a', :connected => false)
	Connection.create(:input => 'c', :output => 'b', :connected => false)
	Connection.create(:input => 'c', :output => 'c', :connected => true)
	Connection.create(:input => 'c', :output => 'd', :connected => false)
	Connection.create(:input => 'd', :output => 'a', :connected => false)
	Connection.create(:input => 'd', :output => 'b', :connected => false)
	Connection.create(:input => 'd', :output => 'c', :connected => false)
	Connection.create(:input => 'd', :output => 'd', :connected => true)

	true
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