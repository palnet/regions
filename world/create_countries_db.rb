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
		ISO varchar(3) UNIQUE NOT NULL,
		Name varchar(44) UNIQUE NOT NULL,
		Population bigint NOT NULL, -- 2015-07-01
		Subcontinent tinyint NOT NULL,
		FOREIGN KEY (Subcontinent) REFERENCES Subcontinent(rowid)
	)
SQL

# https://unstats.un.org/unsd/methodology/m49/
# https://esa.un.org/unpd/wpp/Download/Standard/Population/
continents = [
	"Africa"     ,
	"Americas"   ,
	"Antarctica" ,
	"Asia"       ,
	"Europe"     ,
	"Oceania"
]

# continental regions, per UN
subcontinents = [
	[ "Africa",     "Northern Africa"           ],
	[ "Africa",     "Eastern Africa"            ],
	[ "Africa",     "Middle Africa"             ],
	[ "Africa",     "Southern Africa"           ],
	[ "Africa",     "Western Africa"            ],
	[ "Americas",   "Caribbean"                 ],
	[ "Americas",   "Central America"           ],
	[ "Americas",   "South America"             ],
	[ "Americas",   "Northern America"          ],
	[ "Antarctica", "Antarctica"                ],
	[ "Asia",       "Central Asia"              ],
	[ "Asia",       "Eastern Asia"              ],
	[ "Asia",       "South-eastern Asia"        ],
	[ "Asia",       "Southern Asia"             ],
	[ "Asia",       "Western Asia"              ],
	[ "Europe",     "Eastern Europe"            ],
	[ "Europe",     "Northern Europe"           ],
	[ "Europe",     "Southern Europe"           ],
	[ "Europe",     "Western Europe"            ],
	[ "Oceania",    "Australia and New Zealand" ],
	[ "Oceania",    "Melanesia"                 ],
	[ "Oceania",    "Micronesia"                ],
	[ "Oceania",    "Polynesia"                 ]
]

countries = [
	[ "Northern Africa",            "DZA",  39666519,    "Algeria"                                              ],
	[ "Northern Africa",            "EGY",  91508084,    "Egypt"                                                ],
	[ "Northern Africa",            "LBY",  6278438,     "Libya"                                                ],
	[ "Northern Africa",            "MAR",  34377511,    "Morocco"                                              ],
	[ "Northern Africa",            "SDN",  40234882,    "Sudan"                                                ],
	[ "Northern Africa",            "TUN",  11253554,    "Tunisia"                                              ],
	[ "Northern Africa",            "ESH",  572540,      "Western Sahara"                                       ],
	[ "Eastern Africa",             "IOT",  2500,        "British Indian Ocean Territory"                       ],
	[ "Eastern Africa",             "BDI",  11178921,    "Burundi"                                              ],
	[ "Eastern Africa",             "COM",  788474,      "Comoros"                                              ],
	[ "Eastern Africa",             "DJI",  887861,      "Djibouti"                                             ],
	[ "Eastern Africa",             "ERI",  5227791,     "Eritrea"                                              ],
	[ "Eastern Africa",             "ETH",  99390750,    "Ethiopia"                                             ],
	[ "Eastern Africa",             "ATF",  310,         "French Southern Territories"                          ],
	[ "Eastern Africa",             "KEN",  46050302,    "Kenya"                                                ],
	[ "Eastern Africa",             "MDG",  24235390,    "Madagascar"                                           ],
	[ "Eastern Africa",             "MWI",  17215232,    "Malawi"                                               ],
	[ "Eastern Africa",             "MUS",  1273212,     "Mauritius"                                            ],
	[ "Eastern Africa",             "MYT",  240015,      "Mayotte"                                              ],
	[ "Eastern Africa",             "MOZ",  27977863,    "Mozambique"                                           ],
	[ "Eastern Africa",             "REU",  861154,      "Réunion"                                              ],
	[ "Eastern Africa",             "RWA",  11609666,    "Rwanda"                                               ],
	[ "Eastern Africa",             "SYC",  96471,       "Seychelles"                                           ],
	[ "Eastern Africa",             "SOM",  10787104,    "Somalia"                                              ],
	[ "Eastern Africa",             "SSD",  12339812,    "South Sudan"                                          ],
	[ "Eastern Africa",             "UGA",  39032383,    "Uganda"                                               ],
	[ "Eastern Africa",             "TZA",  53470420,    "United Republic of Tanzania"                          ],
	[ "Eastern Africa",             "ZMB",  16211167,    "Zambia"                                               ],
	[ "Eastern Africa",             "ZWE",  15602751,    "Zimbabwe"                                             ],
	[ "Middle Africa",              "AGO",  25021974,    "Angola"                                               ],
	[ "Middle Africa",              "CMR",  23344179,    "Cameroon"                                             ],
	[ "Middle Africa",              "CAF",  4900274,     "Central African Republic"                             ],
	[ "Middle Africa",              "TCD",  14037472,    "Chad"                                                 ],
	[ "Middle Africa",              "COG",  4620330,     "Congo"                                                ],
	[ "Middle Africa",              "COD",  77266814,    "Democratic Republic of the Congo"                     ],
	[ "Middle Africa",              "GNQ",  845060,      "Equatorial Guinea"                                    ],
	[ "Middle Africa",              "GAB",  1725292,     "Gabon"                                                ],
	[ "Middle Africa",              "STP",  190344,      "Sao Tome and Principe"                                ],
	[ "Southern Africa",            "BWA",  2262485,     "Botswana"                                             ],
	[ "Southern Africa",            "LSO",  2135022,     "Lesotho"                                              ],
	[ "Southern Africa",            "NAM",  2458830,     "Namibia"                                              ],
	[ "Southern Africa",            "ZAF",  54490406,    "South Africa"                                         ],
	[ "Southern Africa",            "SWZ",  1286970,     "Swaziland"                                            ],
	[ "Western Africa",             "BEN",  10879829,    "Benin"                                                ],
	[ "Western Africa",             "BFA",  18105570,    "Burkina Faso"                                         ],
	[ "Western Africa",             "CPV",  520502,      "Cabo Verde"                                           ],
	[ "Western Africa",             "CIV",  22701556,    "Côte d'Ivoire"                                        ],
	[ "Western Africa",             "GMB",  1990924,     "Gambia"                                               ],
	[ "Western Africa",             "GHA",  27409893,    "Ghana"                                                ],
	[ "Western Africa",             "GIN",  12609590,    "Guinea"                                               ],
	[ "Western Africa",             "GNB",  1844325,     "Guinea-Bissau"                                        ],
	[ "Western Africa",             "LBR",  4503438,     "Liberia"                                              ],
	[ "Western Africa",             "MLI",  17599694,    "Mali"                                                 ],
	[ "Western Africa",             "MRT",  4067564,     "Mauritania"                                           ],
	[ "Western Africa",             "NER",  19899120,    "Niger"                                                ],
	[ "Western Africa",             "NGA",  182201962,   "Nigeria"                                              ],
	[ "Western Africa",             "SHN",  3961,        "Saint Helena"                                         ],
	[ "Western Africa",             "SEN",  15129273,    "Senegal"                                              ],
	[ "Western Africa",             "SLE",  6453184,     "Sierra Leone"                                         ],
	[ "Western Africa",             "TGO",  7304578,     "Togo"                                                 ],
	[ "Caribbean",                  "AIA",  14614,       "Anguilla"                                             ],
	[ "Caribbean",                  "ATG",  91818,       "Antigua and Barbuda"                                  ],
	[ "Caribbean",                  "ABW",  103889,      "Aruba"                                                ],
	[ "Caribbean",                  "BHS",  388019,      "Bahamas"                                              ],
	[ "Caribbean",                  "BRB",  284215,      "Barbados"                                             ],
	[ "Caribbean",                  "BES",  24861,       "Bonaire, Sint Eustatius and Saba"                     ],
	[ "Caribbean",                  "VGB",  30117,       "British Virgin Islands"                               ],
	[ "Caribbean",                  "CYM",  59967,       "Cayman Islands"                                       ],
	[ "Caribbean",                  "CUB",  11389562,    "Cuba"                                                 ],
	[ "Caribbean",                  "CUW",  157203,      "Curaçao"                                              ],
	[ "Caribbean",                  "DMA",  72680,       "Dominica"                                             ],
	[ "Caribbean",                  "DOM",  10528391,    "Dominican Republic"                                   ],
	[ "Caribbean",                  "GRD",  106825,      "Grenada"                                              ],
	[ "Caribbean",                  "GLP",  468450,      "Guadeloupe"                                           ],
	[ "Caribbean",                  "HTI",  10711067,    "Haiti"                                                ],
	[ "Caribbean",                  "JAM",  2793335,     "Jamaica"                                              ],
	[ "Caribbean",                  "MTQ",  396425,      "Martinique"                                           ],
	[ "Caribbean",                  "MSR",  5125,        "Montserrat"                                           ],
	[ "Caribbean",                  "PRI",  3683238,     "Puerto Rico"                                          ],
	[ "Caribbean",                  "BLM",  9279,        "Saint Barthélemy"                                     ],
	[ "Caribbean",                  "KNA",  55572,       "Saint Kitts and Nevis"                                ],
	[ "Caribbean",                  "LCA",  184999,      "Saint Lucia"                                          ],
	[ "Caribbean",                  "MAF",  36824,       "Saint Martin (French Part)"                           ],
	[ "Caribbean",                  "VCT",  109462,      "Saint Vincent and the Grenadines"                     ],
	[ "Caribbean",                  "SXM",  38745,       "Sint Maarten (Dutch part)"                            ],
	[ "Caribbean",                  "TTO",  1360088,     "Trinidad and Tobago"                                  ],
	[ "Caribbean",                  "TCA",  34339,       "Turks and Caicos Islands"                             ],
	[ "Caribbean",                  "VIR",  106291,      "United States Virgin Islands"                         ],
	[ "Central America",            "BLZ",  359287,      "Belize"                                               ],
	[ "Central America",            "CRI",  4807850,     "Costa Rica"                                           ],
	[ "Central America",            "SLV",  6126583,     "El Salvador"                                          ],
	[ "Central America",            "GTM",  16342897,    "Guatemala"                                            ],
	[ "Central America",            "HND",  8075060,     "Honduras"                                             ],
	[ "Central America",            "MEX",  127017224,   "Mexico"                                               ],
	[ "Central America",            "NIC",  6082032,     "Nicaragua"                                            ],
	[ "Central America",            "PAN",  3929141,     "Panama"                                               ],
	[ "South America",              "ARG",  43416755,    "Argentina"                                            ],
	[ "South America",              "BOL",  10724705,    "Bolivia"                                              ],
	[ "South America",              "BRA",  207847528,   "Brazil"                                               ],
	[ "South America",              "CHL",  17948141,    "Chile"                                                ],
	[ "South America",              "COL",  48228704,    "Colombia"                                             ],
	[ "South America",              "ECU",  16144363,    "Ecuador"                                              ],
	[ "South America",              "FLK",  2903,        "Falkland Islands (Malvinas)"                          ],
	[ "South America",              "GUF",  268606,      "French Guiana"                                        ],
	[ "South America",              "GUY",  767085,      "Guyana"                                               ],
	[ "South America",              "PRY",  6639123,     "Paraguay"                                             ],
	[ "South America",              "PER",  31376670,    "Peru"                                                 ],
	[ "South America",              "SGS",  30,          "South Georgia and the South Sandwich Islands"         ],
	[ "South America",              "SUR",  542975,      "Suriname"                                             ],
	[ "South America",              "URY",  3431555,     "Uruguay"                                              ],
	[ "South America",              "VEN",  31108083,    "Venezuela"                                            ],
	[ "Northern America",           "BMU",  62004,       "Bermuda"                                              ],
	[ "Northern America",           "CAN",  35939927,    "Canada"                                               ],
	[ "Northern America",           "GRL",  56186,       "Greenland"                                            ],
	[ "Northern America",           "SPM",  6288,        "Saint Pierre and Miquelon"                            ],
	[ "Northern America",           "USA",  321773631,   "United States of America"                             ],
	[ "Antarctica",                 "ATA",  5000,        "Antarctica"                                           ],
	[ "Central Asia",               "KAZ",  17625226,    "Kazakhstan"                                           ],
	[ "Central Asia",               "KGZ",  5939962,     "Kyrgyzstan"                                           ],
	[ "Central Asia",               "TJK",  8481855,     "Tajikistan"                                           ],
	[ "Central Asia",               "TKM",  5373502,     "Turkmenistan"                                         ],
	[ "Central Asia",               "UZB",  29893488,    "Uzbekistan"                                           ],
	[ "Eastern Asia",               "CHN",  1376048943,  "China"                                                ],
	[ "Eastern Asia",               "HKG",  7287983,     "Hong Kong"                                            ],
	[ "Eastern Asia",               "MAC",  587606,      "Macao"                                                ],
	[ "Eastern Asia",               "PRK",  25155317,    "North Korea"                                          ],
	[ "Eastern Asia",               "JPN",  126573481,   "Japan"                                                ],
	[ "Eastern Asia",               "MNG",  2959134,     "Mongolia"                                             ],
	[ "Eastern Asia",               "KOR",  50293439,    "South Korea"                                          ],
	[ "Eastern Asia",               "TWN",  23381038,    "Taiwan (Chinese Taipei)"                              ],
	[ "South-eastern Asia",         "BRN",  423188,      "Brunei Darussalam"                                    ],
	[ "South-eastern Asia",         "KHM",  15577899,    "Cambodia"                                             ],
	[ "South-eastern Asia",         "IDN",  257563815,   "Indonesia"                                            ],
	[ "South-eastern Asia",         "LAO",  6802023,     "Laos (Lao People's Democratic Republic)"              ],
	[ "South-eastern Asia",         "MYS",  30331007,    "Malaysia"                                             ],
	[ "South-eastern Asia",         "MMR",  53897154,    "Myanmar"                                              ],
	[ "South-eastern Asia",         "PHL",  100699395,   "Philippines"                                          ],
	[ "South-eastern Asia",         "SGP",  5603740,     "Singapore"                                            ],
	[ "South-eastern Asia",         "THA",  67959359,    "Thailand"                                             ],
	[ "South-eastern Asia",         "TLS",  1184765,     "Timor-Leste"                                          ],
	[ "South-eastern Asia",         "VNM",  93447601,    "Vietnam (Viet Nam)"                                   ],
	[ "Southern Asia",              "AFG",  32526562,    "Afghanistan"                                          ],
	[ "Southern Asia",              "BGD",  160995642,   "Bangladesh"                                           ],
	[ "Southern Asia",              "BTN",  774830,      "Bhutan"                                               ],
	[ "Southern Asia",              "IND",  1311050527,  "India"                                                ],
	[ "Southern Asia",              "IRN",  79109272,    "Iran (Islamic Republic of)"                           ],
	[ "Southern Asia",              "MDV",  363657,      "Maldives"                                             ],
	[ "Southern Asia",              "NPL",  28513700,    "Nepal"                                                ],
	[ "Southern Asia",              "PAK",  188924874,   "Pakistan"                                             ],
	[ "Southern Asia",              "LKA",  20715010,    "Sri Lanka"                                            ],
	[ "Western Asia",               "ARM",  3017712,     "Armenia"                                              ],
	[ "Western Asia",               "AZE",  9753968,     "Azerbaijan"                                           ],
	[ "Western Asia",               "BHR",  1377237,     "Bahrain"                                              ],
	[ "Western Asia",               "CYP",  1165300,     "Cyprus"                                               ],
	[ "Western Asia",               "GEO",  3999812,     "Georgia"                                              ],
	[ "Western Asia",               "IRQ",  36423395,    "Iraq"                                                 ],
	[ "Western Asia",               "ISR",  8064036,     "Israel"                                               ],
	[ "Western Asia",               "JOR",  7594547,     "Jordan"                                               ],
	[ "Western Asia",               "KWT",  3892115,     "Kuwait"                                               ],
	[ "Western Asia",               "LBN",  5850743,     "Lebanon"                                              ],
	[ "Western Asia",               "OMN",  4490541,     "Oman"                                                 ],
	[ "Western Asia",               "QAT",  2235355,     "Qatar"                                                ],
	[ "Western Asia",               "SAU",  31540372,    "Saudi Arabia"                                         ],
	[ "Western Asia",               "PSE",  4668466,     "State of Palestine"                                   ],
	[ "Western Asia",               "SYR",  18502413,    "Syrian Arab Republic"                                 ],
	[ "Western Asia",               "TUR",  78665830,    "Turkey"                                               ],
	[ "Western Asia",               "ARE",  9156963,     "United Arab Emirates"                                 ],
	[ "Western Asia",               "YEM",  26832215,    "Yemen"                                                ],
	[ "Eastern Europe",             "BLR",  9495826,     "Belarus"                                              ],
	[ "Eastern Europe",             "BGR",  7149787,     "Bulgaria"                                             ],
	[ "Eastern Europe",             "CZE",  10543186,    "Czechia (Czech Republic)"                             ],
	[ "Eastern Europe",             "HUN",  9855023,     "Hungary"                                              ],
	[ "Eastern Europe",             "POL",  38611794,    "Poland"                                               ],
	[ "Eastern Europe",             "MDA",  4068897,     "Republic of Moldova"                                  ],
	[ "Eastern Europe",             "ROU",  19511324,    "Romania"                                              ],
	[ "Eastern Europe",             "RUS",  143456918,   "Russian Federation"                                   ],
	[ "Eastern Europe",             "SVK",  5426258,     "Slovakia"                                             ],
	[ "Eastern Europe",             "UKR",  44823765,    "Ukraine"                                              ],
	[ "Northern Europe",            "ALA",  28007,       "Åland Islands"                                        ],
	[ "Northern Europe",            "GGY",  63026,       "Guernsey"                                             ],
	[ "Northern Europe",            "JEY",  100080,      "Jersey"                                               ],
	[ "Northern Europe",            "XSK",  600,         "Sark"                                                 ],
	[ "Northern Europe",            "DNK",  5669081,     "Denmark"                                              ],
	[ "Northern Europe",            "EST",  1312558,     "Estonia"                                              ],
	[ "Northern Europe",            "FRO",  48199,       "Faroe Islands"                                        ],
	[ "Northern Europe",            "FIN",  5503457,     "Finland"                                              ],
	[ "Northern Europe",            "ISL",  329425,      "Iceland"                                              ],
	[ "Northern Europe",            "IRL",  4688465,     "Ireland"                                              ],
	[ "Northern Europe",            "IMN",  87780,       "Isle of Man"                                          ],
	[ "Northern Europe",            "LVA",  1970503,     "Latvia"                                               ],
	[ "Northern Europe",            "LTU",  2878405,     "Lithuania"                                            ],
	[ "Northern Europe",            "NOR",  5210967,     "Norway"                                               ],
	[ "Northern Europe",            "SJM",  2642,        "Svalbard and Jan Mayen Islands"                       ],
	[ "Northern Europe",            "SWE",  9779426,     "Sweden"                                               ],
	[ "Northern Europe",            "GBR",  64715810,    "United Kingdom of Great Britain and Northern Ireland" ],
	[ "Southern Europe",            "ALB",  2896679,     "Albania"                                              ],
	[ "Southern Europe",            "AND",  70473,       "Andorra"                                              ],
	[ "Southern Europe",            "BIH",  3810416,     "Bosnia and Herzegovina"                               ],
	[ "Southern Europe",            "HRV",  4240317,     "Croatia"                                              ],
	[ "Southern Europe",            "GIB",  32217,       "Gibraltar"                                            ],
	[ "Southern Europe",            "GRC",  10954617,    "Greece"                                               ],
	[ "Southern Europe",            "XKV",  1907592,     "Kosovo"                                               ],
	[ "Southern Europe",            "VAT",  800,         "Vatican City (Hole See)"                              ],
	[ "Southern Europe",            "ITA",  59797685,    "Italy"                                                ],
	[ "Southern Europe",            "MLT",  418670,      "Malta"                                                ],
	[ "Southern Europe",            "MNE",  625781,      "Montenegro"                                           ],
	[ "Southern Europe",            "PRT",  10349803,    "Portugal"                                             ],
	[ "Southern Europe",            "SMR",  31781,       "San Marino"                                           ],
	[ "Southern Europe",            "SRB",  6943383,     "Serbia"                                               ],
	[ "Southern Europe",            "SVN",  2067526,     "Slovenia"                                             ],
	[ "Southern Europe",            "ESP",  46121699,    "Spain"                                                ],
	[ "Southern Europe",            "MKD",  2078453,     "Macedonia"                                            ],
	[ "Western Europe",             "AUT",  8544586,     "Austria"                                              ],
	[ "Western Europe",             "BEL",  11299192,    "Belgium"                                              ],
	[ "Western Europe",             "FRA",  64395345,    "France"                                               ],
	[ "Western Europe",             "DEU",  80688545,    "Germany"                                              ],
	[ "Western Europe",             "LIE",  37531,       "Liechtenstein"                                        ],
	[ "Western Europe",             "LUX",  567110,      "Luxembourg"                                           ],
	[ "Western Europe",             "MCO",  37731,       "Monaco"                                               ],
	[ "Western Europe",             "NLD",  16924929,    "Netherlands"                                          ],
	[ "Western Europe",             "CHE",  8298663,     "Switzerland"                                          ],
	[ "Australia and New Zealand",  "AUS",  23968973,    "Australia"                                            ],
	[ "Australia and New Zealand",  "CXR",  2072,        "Christmas Island"                                     ],
	[ "Australia and New Zealand",  "CCK",  596,         "Cocos (Keeling) Islands"                              ],
	[ "Australia and New Zealand",  "NZL",  4528526,     "New Zealand"                                          ],
	[ "Australia and New Zealand",  "NFK",  2210,        "Norfolk Island"                                       ],
	[ "Melanesia",                  "FJI",  892145,      "Fiji"                                                 ],
	[ "Melanesia",                  "NCL",  263118,      "New Caledonia"                                        ],
	[ "Melanesia",                  "PNG",  7619321,     "Papua New Guinea"                                     ],
	[ "Melanesia",                  "SLB",  583591,      "Solomon Islands"                                      ],
	[ "Melanesia",                  "VUT",  264652,      "Vanuatu"                                              ],
	[ "Micronesia",                 "GUM",  169885,      "Guam"                                                 ],
	[ "Micronesia",                 "KIR",  112423,      "Kiribati"                                             ],
	[ "Micronesia",                 "MHL",  52993,       "Marshall Islands"                                     ],
	[ "Micronesia",                 "FSM",  104460,      "Micronesia (Federated States of)"                     ],
	[ "Micronesia",                 "NRU",  10222,       "Nauru"                                                ],
	[ "Micronesia",                 "MNP",  55070,       "Northern Mariana Islands"                             ],
	[ "Micronesia",                 "PLW",  21291,       "Palau"                                                ],
	[ "Micronesia",                 "UMI",  316,         "United States Minor Outlying Islands"                 ],
	[ "Polynesia",                  "ASM",  55538,       "American Samoa"                                       ],
	[ "Polynesia",                  "COK",  20833,       "Cook Islands"                                         ],
	[ "Polynesia",                  "PYF",  282764,      "French Polynesia"                                     ],
	[ "Polynesia",                  "NIU",  1610,        "Niue"                                                 ],
	[ "Polynesia",                  "PCN",  56,          "Pitcairn"                                             ],
	[ "Polynesia",                  "WSM",  193228,      "Samoa"                                                ],
	[ "Polynesia",                  "TKL",  1250,        "Tokelau"                                              ],
	[ "Polynesia",                  "TON",  106170,      "Tonga"                                                ],
	[ "Polynesia",                  "TUV",  9916,        "Tuvalu"                                               ],
	[ "Polynesia",                  "WLF",  13151,       "Wallis and Futuna Islands"                            ]
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
	iso, pop, name = country[1..-1]
	db.execute "INSERT INTO Countries VALUES (?, ?, ?, ?)", iso, name, pop, subcontinent
end

# create view
db.execute <<-SQL
	CREATE VIEW CountriesView
	(Continent, Subcontinent, Country, Population, ISO) AS 
	SELECT Continents.Name,
		Subcontinents.Name,
		Countries.Name,
		Countries.Population,
		Countries.ISO
	FROM Continents
		JOIN Subcontinents
			ON Continents.rowid = Subcontinents.Continent
		JOIN Countries
			ON Subcontinents.rowid = Countries.Subcontinent
SQL
