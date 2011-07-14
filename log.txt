>> require 'windy'
=> true

>> view = Windy.views.first
=> #<Windy::View:r3km-swf6 "Current Employee Names, Salaries, and Position Titles">
>> employees = view.rows
=> #<Windy::Rows http://data.cityofchicago.org/api/views/r3km-swf6/rows.json>
>> employees.count
Fetching http://data.cityofchicago.org/views/r3km-swf6/rows.json
=> 34218

>> employee = employees.first
=> #<Windy::Row [1, "57271067-718D-4187-B337-FC83FF54593A", 1, 1307130194, "386464", 1307130194, "386464", "{\n}", "AARON,  ELVIA J", "WATER RATE TAKER", "WATER MGMNT", "81000", "73862", []]>
>> employee.name
=> "AARON,  ELVIA J"
>> employee.job_title
=> "WATER RATE TAKER"
>> employee.employee_annual_salary
=> "81000"

>> employee = employees.find { |e| e.name =~ /\bRahm\b/i }
=> #<Windy::Row [8529, "67896ECE-CC51-4BD3-9087-6B395CE6CD9C", 8529, 1307130196, "386464", 1307130196, "386464", "{\n}", "EMANUEL,  RAHM ", "MAYOR", "MAYOR'S OFFICE", "216210", "196329", []]>
>> employee.employee_annual_salary
=> "216210"

>> employees.inject(0) { |budget, e| budget + e.employee_annual_salary.to_i }
=> 2526272624

>> view = Windy.views.find_by_name("Bike Racks")
=> #<Windy::View:cbyb-69xx "Bike Racks">
>> racks = view.rows
=> #<Windy::Rows http://data.cityofchicago.org/api/views/cbyb-69xx/rows.json>
>> racks.columns
Fetching http://data.cityofchicago.org/views/cbyb-69xx/rows.json
=> ["sid", "id", "position", "created_at", "created_meta", "updated_at", "updated_meta", "meta", "rackid", "address", "ward", "community area", "community name", "totinstall", "latitude", "longitude", "historical", "f12", "f13", "location", "tags"]
>> first_ward_racks = racks.find_all_by_ward("1")
=> [...]
>> first_ward_racks.count
=> 270
>> rack = first_ward_racks.first
=> #<Windy::Row [70, "F1256BFD-2B33-49FE-B60E-686DC9A3814E", 70, 1293044285, "386464", 1293044285, "386464", nil, "5945", "1001 N Damen Ave", "1", "24", "West Town", "1.000000", "41.899661", "-87.677036", "1.000000", "41.899661", "-87.677036", [nil, "41.899661", "-87.677036", nil, false], []]>
>> [rack.latitude, rack.longitude]
=> ["41.899661", "-87.677036"]

>> view = Windy.views.find_by_id("ygr5-vcbg")
=> #<Windy::View:ygr5-vcbg "Towed Vehicles">
>> vehicles = view.rows
=> #<Windy::Rows http://data.cityofchicago.org/api/views/ygr5-vcbg/rows.json>
>> vehicles.find_by_plate("G679335")
Fetching http://data.cityofchicago.org/views/ygr5-vcbg/rows.json
=> #<Windy::Row [1001, "06045633-4E01-4A68-ABC3-E8B6B237F1A8", 1001, 1310284807, "386464", 1310284807, "386464", "{\n}", "2011-07-01T00:00:00", "CHEV", "LL", nil, "BLK", "G679335", "IL", "10300 S. Doty", "(773) 568-8495 ", "02651440", []]>

>> porsches = vehicles.find_all_by_make("PORS")
=> [#<Windy::Row [2178, "E7DE3699-82F5-4726-8C90-22EE8B2E3D23", 2178, 1310284807, "386464", 1310284807, "386464", "{\n}", "2011-06-17T00:00:00", "PORS", "LL", nil, "WHI", "836BHW", "IN", "10300 S. Doty", "(773) 568-8495 ", "02650189", []]>, #<Windy::Row [4501, "1AC29400-E116-4495-A6A3-6702F39F5841", 4501, 1310284808, "386464", 1310284808, "386464", "{\n}", "2011-05-10T00:00:00", "PORS", "4D", nil, "SIL", "H346247", "IL", "400 E. Lower Wacker", "(312) 744-7550", "00840652", []]>, #<Windy::Row [4606, "624D2DCE-5E81-4E60-871B-467FF71E6C7D", 4606, 1310284808, "386464", 1310284808, "386464", "{\n}", "2011-05-07T00:00:00", "PORS", "4D", nil, "GRY", "K439169", "IL", "701 N. Sacramento", "(773) 265-7605", "06678619", []]>]

>> vehicles.group_by(&:color).map { |k, v| [k, v.count] }.sort_by(&:last).reverse
=> [["BLK", 858], ["WHI", 858], ["BLU", 659], ["GRN", 603], ["GRY", 581], ["RED", 560], ["SIL", 519], ["TAN", 311], ["MAR", 299], ["GLD", 140], ["PLE", 79], ["BRO", 56], ["BGE", 45], [" ", 24], ["YEL", 17], ["CRM", 10], ["ONG", 9], ["DBL", 6], ["PNK", 2], ["LBL", 2], ["TRQ", 2], ["DGR", 2], ["BRZ", 1], ["Color", 1]]
