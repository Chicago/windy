require 'helper'

describe Windy do

  before(:each) do
    Windy.app_token = "abc123"
  end

  describe "client_error" do
    it "should throw exception when invalid app_token is provided" do
      stub_request(:get, "http://data.cityofchicago.org/api/views?limit=200&page=1").
                   to_return(:status => 403, :body => fixture("invalid_app_token.json"), :headers => {'X-Error-Code' => 'permission_denied', 'X-Error-Message' => 'Invalid app_token specified'
                   })

      lambda{Windy.views.count}.should raise_error("Invalid app_token specified")
    end
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

  describe ".find_by_id" do
    it "should return the view" do
      fire_stations = Windy.views.find_by_id("28km-gtjn")
      fire_stations.should be_a Windy::View
    end
  end

  describe ".find_by_name" do
    it "should return the view when searching by name" do
      police_stations = Windy.views.find_by_name("Police Stations")
      police_stations.should be_a Windy::View
    end
  end

  describe ".rows" do
    before do
      stub_request(:get, "http://data.cityofchicago.org/api/views/28km-gtjn/rows.json").
         to_return(:status => 200, :body => fixture("rows.json"), :headers => {})
    end

    it "should return the rows view" do
      fire_stations = Windy.views.find_by_id("28km-gtjn")
      stations = fire_stations.rows
      stations.first[4].should == "386464"
    end
  end

  describe ".columns" do
    it "should return the columns view" do
      fire_stations = Windy.views.find_by_id("28km-gtjn")
      stations = fire_stations.rows
      stations.columns.should == ["sid", "id", "position", "created_at", "created_meta", "updated_at", "updated_meta", "meta", "name", "address", "city", "state", "zip", "engine", "location"]
    end
  end

  describe "#find_by_" do
    it "should return the row when searching" do
      fire_stations = Windy.views.find_by_id("28km-gtjn")
      stations = fire_stations.rows
      engine = stations.find_by_engine("E104")
      engine.address.should == "11641 S AVENUE O"
    end
  end

end
