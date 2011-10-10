require 'helper'

describe Windy do

  before(:all) do
    Windy.app_token = "abc123"
  end

  describe ".views" do
    before do
      stub_request(:get, "http://data.cityofchicago.org/api/views?limit=200&page=1").
         to_return(:status => 200, :body => fixture("views.json"), :headers => {})
      stub_request(:get, "http://data.cityofchicago.org/api/views?limit=200&page=2").
        to_return(:status => 200, :body => "[]", :headers => {})

    end

    it "should return all the Views" do
      all_views = Windy.views
      all_views.count.should == 200
    end
  end


end
