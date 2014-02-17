require 'spec_helper'

describe "API Spec" do
	
	describe "GET home" do
		it "should load" do
			get '/'
			last_response.status.should eq(200)
		end
	end

	describe "Update connection" do
		before(:each) do
			Connection.destroy
			Connection.create(:input => 'dragon', :output => 'dragon', :connected => true)
			Connection.create(:input => 'dragon', :output => 'kitchen', :connected => false)
		end
		
		it 'should disconnect' do
			post '/connection', {:input => "dragon", :output => 'dragon', :connected => false}.to_json

			last_response.status.should eq(200)

			Connection.first(:input => "dragon", :output => "dragon").connected.should be_false
			Connection.count(:input => "dragon", :output => "dragon").should eql(1)
		end

		it 'should connect' do
			post '/connection', {:input => "dragon", :output => 'kitchen', :connected => true}.to_json

			last_response.status.should eq(200)

			Connection.first(:input => "dragon", :output => "kitchen").connected.should be_true
			Connection.count(:input => "dragon", :output => "kitchen").should eql(1)
		end
	end

	describe "Mute" do
		before(:each) do
			Connection.destroy
			Connection.create(:input => 'dragon', :output => 'dragon', :connected => true)
			Connection.create(:input => 'dragon', :output => 'kitchen', :connected => true)
		end

		it 'should mute specified output' do
			post '/mute', {:output => 'dragon'}.to_json

			last_response.status.should eq(200)

			Connection.first(:output => "dragon").connected.should be_false
			Connection.first(:output => "kitchen").connected.should be_true
			Connection.count.should eql(2)
		end

		it 'should mute all outputs if no output specified' do
			post '/mute', {}.to_json

			last_response.status.should eq(200)

			Connection.first(:output => "dragon").connected.should be_false
			Connection.first(:output => "kitchen").connected.should be_false
			Connection.count.should eql(2)
		end
	end

	describe "Reset" do
		before(:each) do
			Connection.destroy
			Connection.create(:input => 'a', :output => 'b', :connected => true)
			Connection.create(:input => 'b', :output => 'b', :connected => false)
			Connection.create(:input => 'b', :output => 'a', :connected => true)
			Connection.create(:input => 'a', :output => 'a', :connected => true)
		end
		it 'should remove everything and set it to a clean one-to-one state' do
			post '/reset', {}.to_json

			last_response.status.should eq(200)

			connections = Connection.all
			connections.each do |connection|
				connection.connected.should be_true if connection.output == connection.input
				connection.connected.should be_false unless connection.output == connection.input
			end
			
			connections.count.should eql(16) #We are doing a 4x4 grid
		end
	end

end