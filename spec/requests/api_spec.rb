require 'spec_helper'

describe "API Spec" do
	
	describe "GET home" do
		it "return Hello" do
			get '/'
			(last_response.body).should eq("Hello")
		end
	end
end