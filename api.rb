require 'sinatra'
require 'data_mapper'

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
 
  # lets add some records to start with
  if Connection.count == 0
    Connection.create(:input => 'dragon', :output => 'kitchen', :connected => true)
  end
end


get '/' do
  "Hello"
end