#!/usr/bin/env ruby

require "sqlite3"

db = SQLite3::Database.new "countries.db"

db.execute <<-SQL
	CREATE TABLE Continents (
		Name VARCHAR(10) NOT NULL
	)
SQL

db.execute <<-SQL
	CREATE TABLE Subcontinents (
		Name varchar(25) NOT NULL,
		Continent tinyint NOT NULL,
		FOREIGN KEY (Continent) REFERENCES Continent(rowid)
	)
SQL

db.execute <<-SQL
	CREATE TABLE Countries (
		ISO varchar(3) NOT NULL,
		Name varchar(44) NOT NULL,
		Subcontinent tinyint NOT NULL,
		FOREIGN KEY (Subcontinent) REFERENCES Subcontinent(rowid)
	)
SQL

# https://unstats.un.org/unsd/methodology/m49/
continents = [
	"Africa",
	"Americas",
	"Antarctica",
	"Asia",
	"Europe",
	"Oceania"
]

# continental regions, per UN
subcontinents = [
	["Africa",			"Northern Africa"],
	["Africa",			"Eastern Africa"],
	["Africa",			"Middle Africa"],
	["Africa",			"Southern Africa"],
	["Africa",			"Western Africa"],
	["Americas",		"Caribbean"],
	["Americas",		"Central America"],
	["Americas",		"South America"],
	["Americas",		"Northern America"],
	["Antarctica",	"Antarctica"],
	["Asia",				"Central Asia"],
	["Asia",				"Eastern Asia"],
	["Asia",				"South-eastern Asia"],
	["Asia",				"Southern Asia"],
	["Asia",				"Western Asia"],
	["Europe",			"Eastern Europe"],
	["Europe",			"Northern Europe"],
	["Europe",			"Southern Europe"],
	["Europe",			"Western Europe"],
	["Oceania",			"Australia and New Zealand"],
	["Oceania",			"Melanesia"],
	["Oceania",			"Micronesia"],
	["Oceania",			"Polynesia"]
]

countries = [
	["Northern Africa",						"DZA",		"Algeria"],
	["Northern Africa",						"EGY",		"Egypt"],
	["Northern Africa",						"LBY",		"Libya"],
	["Northern Africa",						"MAR",		"Morocco"],
	["Northern Africa",						"SDN",		"Sudan"],
	["Northern Africa",						"TUN",		"Tunisia"],
	["Northern Africa",						"ESH",		"Western Sahara"],
	["Eastern Africa",						"IOT",		"British Indian Ocean Territory"],
	["Eastern Africa",						"BDI",		"Burundi"],
	["Eastern Africa",						"COM",		"Comoros"],
	["Eastern Africa",						"DJI",		"Djibouti"],
	["Eastern Africa",						"ERI",		"Eritrea"],
	["Eastern Africa",						"ETH",		"Ethiopia"],
	["Eastern Africa",						"ATF",		"French Southern Territories"],
	["Eastern Africa",						"KEN",		"Kenya"],
	["Eastern Africa",						"MDG",		"Madagascar"],
	["Eastern Africa",						"MWI",		"Malawi"],
	["Eastern Africa",						"MUS",		"Mauritius"],
	["Eastern Africa",						"MYT",		"Mayotte"],
	["Eastern Africa",						"MOZ",		"Mozambique"],
	["Eastern Africa",						"REU",		"Réunion"],
	["Eastern Africa",						"RWA",		"Rwanda"],
	["Eastern Africa",						"SYC",		"Seychelles"],
	["Eastern Africa",						"SOM",		"Somalia"],
	["Eastern Africa",						"SSD",		"South Sudan"],
	["Eastern Africa",						"UGA",		"Uganda"],
	["Eastern Africa",						"TZA",		"United Republic of Tanzania"],
	["Eastern Africa",						"ZMB",		"Zambia"],
	["Eastern Africa",						"ZWE",		"Zimbabwe"],
	["Middle Africa",							"AGO",		"Angola"],
	["Middle Africa",							"CMR",		"Cameroon"],
	["Middle Africa",							"CAF",		"Central African Republic"],
	["Middle Africa",							"TCD",		"Chad"],
	["Middle Africa",							"COG",		"Congo"],
	["Middle Africa",							"COD",		"Democratic Republic of the Congo"],
	["Middle Africa",							"GNQ",		"Equatorial Guinea"],
	["Middle Africa",							"GAB",		"Gabon"],
	["Middle Africa",							"STP",		"Sao Tome and Principe"],
	["Middle Africa",							"MWI",		"Malawi"],
	["Middle Africa",							"MUS",		"Mauritius"],
	["Middle Africa",							"MYT",		"Mayotte"],
	["Middle Africa",							"MOZ",		"Mozambique"],
	["Middle Africa",							"REU",		"Réunion"],
	["Middle Africa",							"RWA",		"Rwanda"],
	["Middle Africa",							"SYC",		"Seychelles"],
	["Middle Africa",							"SOM",		"Somalia"],
	["Middle Africa",							"SSD",		"South Sudan"],
	["Middle Africa",							"UGA",		"Uganda"],
	["Middle Africa",							"TZA",		"United Republic of Tanzania"],
	["Middle Africa",							"ZMB",		"Zambia"],
	["Middle Africa",							"ZWE",		"Zimbabwe"],
	["Southern Africa",						"BWA",		"Botswana"],
	["Southern Africa",						"LSO",		"Lesotho"],
	["Southern Africa",						"NAM",		"Namibia"],
	["Southern Africa",						"ZAF",		"South Africa"],
	["Southern Africa",						"SWZ",		"Swaziland"],
	["Western Africa",						"BEN",		"Benin"],
	["Western Africa",						"BFA",		"Burkina Faso"],
	["Western Africa",						"CPV",		"Cabo Verde"],
	["Western Africa",						"CIV",		"Côte d'Ivoire"],
	["Western Africa",						"GMB",		"Gambia"],
	["Western Africa",						"GHA",		"Ghana"],
	["Western Africa",						"GIN",		"Guinea"],
	["Western Africa",						"GNB",		"Guinea-Bissau"],
	["Western Africa",						"LBR",		"Liberia"],
	["Western Africa",						"MLI",		"Mali"],
	["Western Africa",						"MRT",		"Mauritania"],
	["Western Africa",						"NER",		"Niger"],
	["Western Africa",						"NGA",		"Nigeria"],
	["Western Africa",						"SHN",		"Saint Helena"],
	["Western Africa",						"SEN",		"Senegal"],
	["Western Africa",						"SLE",		"Sierra Leone"],
	["Western Africa",						"TGO",		"Togo"],
	["Caribbean",									"AIA",		"Anguilla"],
	["Caribbean",									"ATG",		"Antigua and Barbuda"],
	["Caribbean",									"ABW",		"Aruba"],
	["Caribbean",									"BHS",		"Bahamas"],
	["Caribbean",									"BRB",		"Barbados"],
	["Caribbean",									"BES",		"Bonaire, Sint Eustatius and Saba"],
	["Caribbean",									"VGB",		"British Virgin Islands"],
	["Caribbean",									"CYM",		"Cayman Islands"],
	["Caribbean",									"CUB",		"Cuba"],
	["Caribbean",									"CUW",		"Curaçao"],
	["Caribbean",									"DMA",		"Dominica"],
	["Caribbean",									"DOM",		"Dominican Republic"],
	["Caribbean",									"GRD",		"Grenada"],
	["Caribbean",									"GLP",		"Guadeloupe"],
	["Caribbean",									"HTI",		"Haiti"],
	["Caribbean",									"JAM",		"Jamaica"],
	["Caribbean",									"MTQ",		"Martinique"],
	["Caribbean",									"MSR",		"Montserrat"],
	["Caribbean",									"PRI",		"Puerto Rico"],
	["Caribbean",									"BLM",		"Saint Barthélemy"],
	["Caribbean",									"KNA",		"Saint Kitts and Nevis"],
	["Caribbean",									"LCA",		"Saint Lucia"],
	["Caribbean",									"MAF",		"Saint Martin (French Part)"],
	["Caribbean",									"VCT",		"Saint Vincent and the Grenadines"],
	["Caribbean",									"SXM",		"Sint Maarten (Dutch part)"],
	["Caribbean",									"TTO",		"Trinidad and Tobago"],
	["Caribbean",									"TCA",		"Turks and Caicos Islands"],
	["Caribbean",									"VIR",		"United States Virgin Islands"],
	["Central America",						"BLZ",		"Belize"],
	["Central America",						"CRI",		"Costa Rica"],
	["Central America",						"SLV",		"El Salvador"],
	["Central America",						"GTM",		"Guatemala"],
	["Central America",						"HND",		"Honduras"],
	["Central America",						"MEX",		"Mexico"],
	["Central America",						"NIC",		"Nicaragua"],
	["Central America",						"PAN",		"Panama"],
	["South America",							"ARG",		"Argentina"],
	["South America",							"BOL",		"Bolivia"],
	["South America",							"BVT",		"Bouvet Island"],
	["South America",							"BRA",		"Brazil"],
	["South America",							"CHL",		"Chile"],
	["South America",							"COL",		"Colombia"],
	["South America",							"ECU",		"Ecuador"],
	["South America",							"FLK",		"Falkland Islands (Malvinas)"],
	["South America",							"GUF",		"French Guiana"],
	["South America",							"GUY",		"Guyana"],
	["South America",							"PRY",		"Paraguay"],
	["South America",							"PER",		"Peru"],
	["South America",							"SGS",		"South Georgia and the South Sandwich Islands"],
	["South America",							"SUR",		"Suriname"],
	["South America",							"URY",		"Uruguay"],
	["South America",							"VEN",		"Venezuela"],
	["Northern America",					"BMU",		"Bermuda"],
	["Northern America",					"CAN",		"Canada"],
	["Northern America",					"GRL",		"Greenland"],
	["Northern America",					"SPM",		"Saint Pierre and Miquelon"],
	["Northern America",					"USA",		"United States of America"],
	["Antarctica",								"ATA",		"Antarctica"],
	["Central Asia",							"KAZ",		"Kazakhstan"],
	["Central Asia",							"KGZ",		"Kyrgyzstan"],
	["Central Asia",							"TJK",		"Tajikistan"],
	["Central Asia",							"TKM",		"Turkmenistan"],
	["Central Asia",							"UZB",		"Uzbekistan"],
	["Eastern Asia",							"CHN",		"China"],
	["Eastern Asia",							"HKG",		"Hong Kong"],
	["Eastern Asia",							"MAC",		"Macao"],
	["Eastern Asia",							"PRK",		"North Korea"],
	["Eastern Asia",							"JPN",		"Japan"],
	["Eastern Asia",							"MNG",		"Mongolia"],
	["Eastern Asia",							"KOR",		"South Korea"],
	["Eastern Asia",							"TWN",		"Taiwan (Chinese Taipei)"],
	["South-eastern Asia",				"BRN",		"Brunei Darussalam"],
	["South-eastern Asia",				"KHM",		"Cambodia"],
	["South-eastern Asia",				"IDN",		"Indonesia"],
	["South-eastern Asia",				"LAO",		"Laos (Lao People's Democratic Republic)"],
	["South-eastern Asia",				"MYS",		"Malaysia"],
	["South-eastern Asia",				"MMR",		"Myanmar"],
	["South-eastern Asia",				"PHL",		"Philippines"],
	["South-eastern Asia",				"SGP",		"Singapore"],
	["South-eastern Asia",				"THA",		"Thailand"],
	["South-eastern Asia",				"TLS",		"Timor-Leste"],
	["South-eastern Asia",				"VNM",		"Vietnam (Viet Nam)"],
	["Southern Asia",							"AFG",		"Afghanistan"],
	["Southern Asia",							"BGD",		"Bangladesh"],
	["Southern Asia",							"BTN",		"Bhutan"],
	["Southern Asia",							"IND",		"India"],
	["Southern Asia",							"IRN",		"Iran (Islamic Republic of)"],
	["Southern Asia",							"MDV",		"Maldives"],
	["Southern Asia",							"NPL",		"Nepal"],
	["Southern Asia",							"PAK",		"Pakistan"],
	["Southern Asia",							"LKA",		"Sri Lanka"],
	["Western Asia",							"ARM",		"Armenia"],
	["Western Asia",							"AZE",		"Azerbaijan"],
	["Western Asia",							"BHR",		"Bahrain"],
	["Western Asia",							"CYP",		"Cyprus"],
	["Western Asia",							"GEO",		"Georgia"],
	["Western Asia",							"IRQ",		"Iraq"],
	["Western Asia",							"ISR",		"Israel"],
	["Western Asia",							"JOR",		"Jordan"],
	["Western Asia",							"KWT",		"Kuwait"],
	["Western Asia",							"LBN",		"Lebanon"],
	["Western Asia",							"OMN",		"Oman"],
	["Western Asia",							"QAT",		"Qatar"],
	["Western Asia",							"SAU",		"Saudi Arabia"],
	["Western Asia",							"PSE",		"State of Palestine"],
	["Western Asia",							"SYR",		"Syrian Arab Republic"],
	["Western Asia",							"TUR",		"Turkey"],
	["Western Asia",							"ARE",		"United Arab Emirates"],
	["Western Asia",							"YEM",		"Yemen"],
	["Eastern Europe",						"BLR",		"Belarus"],
	["Eastern Europe",						"BGR",		"Bulgaria"],
	["Eastern Europe",						"CZE",		"Czechia (Czech Republic)"],
	["Eastern Europe",						"HUN",		"Hungary"],
	["Eastern Europe",						"POL",		"Poland"],
	["Eastern Europe",						"MDA",		"Republic of Moldova"],
	["Eastern Europe",						"ROU",		"Romania"],
	["Eastern Europe",						"RUS",		"Russian Federation"],
	["Eastern Europe",						"SVK",		"Slovakia"],
	["Eastern Europe",						"UKR",		"Ukraine"],
	["Western Europe",						"AUT",		"Austria"],
	["Western Europe",						"BEL",		"Belgium"],
	["Western Europe",						"FRA",		"France"],
	["Western Europe",						"DEU",		"Germany"],
	["Western Europe",						"LIE",		"Liechtenstein"],
	["Western Europe",						"LUX",		"Luxembourg"],
	["Western Europe",						"MCO",		"Monaco"],
	["Western Europe",						"NLD",		"Netherlands"],
	["Western Europe",						"CHE",		"Switzerland"],
	["Australia and New Zealand",	"AUS",		"Australia"],
	["Australia and New Zealand",	"CXR",		"Christmas Island"],
	["Australia and New Zealand",	"CCK",		"Cocos (Keeling) Islands"],
	["Australia and New Zealand",	"HMD",		"Heard Island and McDonald Islands"],
	["Australia and New Zealand",	"NZL",		"New Zealand"],
	["Australia and New Zealand",	"NFK",		"Norfolk Island"],
	["Melanesia",									"FJI",		"Fiji"],
	["Melanesia",									"NCL",		"New Caledonia"],
	["Melanesia",									"PNG",		"Papua New Guinea"],
	["Melanesia",									"SLB",		"Solomon Islands"],
	["Melanesia",									"VUT",		"Vanuatu"],
	["Micronesia",								"GUM",		"Guam"],
	["Micronesia",								"KIR",		"Kiribati"],
	["Micronesia",								"MHL",		"Marshall Islands"],
	["Micronesia",								"FSM",		"Micronesia (Federated States of)"],
	["Micronesia",								"NRU",		"Nauru"],
	["Micronesia",								"MNP",		"Northern Mariana Islands"],
	["Micronesia",								"PLW",		"Palau"],
	["Micronesia",								"UMI",		"United States Minor Outlying Islands"],
	["Polynesia",									"ASM",		"American Samoa"],
	["Polynesia",									"COK",		"Cook Islands"],
	["Polynesia",									"PYF",		"French Polynesia"],
	["Polynesia",									"NIU",		"Niue"],
	["Polynesia",									"PCN",		"Pitcairn"],
	["Polynesia",									"WSM",		"Samoa"],
	["Polynesia",									"TKL",		"Tokelau"],
	["Polynesia",									"TON",		"Tonga"],
	["Polynesia",									"TUV",		"Tuvalu"],
	["Polynesia",									"WLF",		"Wallis and Futuna Islands"]
]

# insert continents
continents.each do |continent|
	db.execute "INSERT INTO Continents VALUES (?)", continent
end

# get continents id
continents = {}
db.execute "SELECT rowid, Name FROM Continents" do |row|
	continents[ row[1] ] = row[0]
end

# insert subcontinents
subcontinents.each do |subcontinent|
	continent_id = continents[ subcontinent[0] ]
	db.execute "INSERT INTO Subcontinents VALUES (?, ?)", subcontinent[1], continent_id
end

# get subcontinents id
subcontinents = {}
db.execute "SELECT rowid, Name FROM Subcontinents" do |row|
	subcontinents[ row[1] ] = row[0]
end

# insert countries
countries.each do |country|
	subcontinent = subcontinents[ country[0] ]
	db.execute "INSERT INTO Countries VALUES (?, ?, ?)", country[1], country[2], subcontinent
end
