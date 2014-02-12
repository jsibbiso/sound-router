require 'spec_helper'

describe "API Spec" do
	
	describe "GET home" do
		it "return Hello" do
			get '/'
			(last_response.body).should eq("Hello")
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

end