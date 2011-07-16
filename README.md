Windy
====================

Windy is a Ruby module that allows you to easily interact with the [City of Chicago's Data Portal](http://data.cityofchicago.org/).

The city's datasets are hosted using the [Socrata](http://www.socrata.com/) software platform. This library serves as a convenience wrapper to interacting with [Socrata's Open Data API](http://dev.socrata.com/).

How to use
--------------------

Before we begin, it should be noted that there are several ways to interact with the City of Chicago's datasets. You can download the data, play with it using the Visualize or Filter functions on the city's website or query the datasets live using Socrata's API. Windy was created to assist with the third type of interaction: querying the live datasets.

We'll walk through a few steps below, and show you what Windy can do.

First off, install the Windy gem, and fire up your irb console.

    $ gem install windy
    $ irb
    >> require 'rubygems'
    >> require 'windy'

### Views

Views are at the heart of each dataset. In a nutshell, every dataset has at least one view, the original view. Users of the Data Portal are allowed to create customized views, however for the sake of this walk-through, we'll only be discussing the original view.

To get an Array of all views:

    >> all_views = Windy.views
    >> all_views.count
    => 537
    >> first_view = views.first

If you know which view you'd like to work with, you can access it directly by the View ID. In the following example, we found the the View's ID by looking at the end of the [Towed Vehicle's dataset URL](http://data.cityofchicago.org/Government/Towed-Vehicles/ygr5-vcbg).

    >> towed_vehicles = Windy.views.find_by_id("ygr5-vcbg")

Or, if you'd like to search for a view by name:

    >> bike_racks = Windy.views.find_by_name("Bike Racks")

### Rows

Much like a spreadsheet, each view contains a number of rows. These, too , can be accessed using Windy.

    >> racks = bike_racks.rows

We can see which columns exists for these rows.

    >> racks.columns
    => ["sid", "id", "position", "created_at", "created_meta", "updated_at", "updated_meta", "meta", "rackid", "address", "ward", "community area", "community name", "totinstall", "latitude", "longitude", "historical", "f12", "f13", "location", "tags"]

We can search for rows based on column names. Just use the convenient "find_by_columnname" method:

    >> first_ward_racks = racks.find_all_by_ward("1")
    >> lake_view_racks = racks.find_all_by_community_name("Lake View")

And, find values for a specific row's cell.

    >> first_rack = lake_view_racks.first
    >> first_rack.address
    => "1000 W Addison St"

Authors
--------------------

* Sam Stephenson <<sstephenson@gmail.com>>
* Scott Robbin <<srobbin@gmail.com>>

<a rel="license" href="http://creativecommons.org/publicdomain/zero/1.0/">
  <img src="http://i.creativecommons.org/p/zero/1.0/88x31.png" style="border-style: none;" alt="CC0" />
</a>

To the extent possible under law, the authors have waived all copyright and related or neighboring rights to this work.
