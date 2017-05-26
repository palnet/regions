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
		Area decimal(13,1) NOT NULL,
		Subcontinent tinyint NOT NULL,
		FOREIGN KEY (Subcontinent) REFERENCES Subcontinent(rowid)
	)
SQL

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
	[ "Northern Africa",            "DZA",  39666519,    2381740,   "Algeria"                                              ],
	[ "Northern Africa",            "EGY",  91508084,    995450,    "Egypt"                                                ],
	[ "Northern Africa",            "LBY",  6278438,     1759540,   "Libya"                                                ],
	[ "Northern Africa",            "MAR",  34377511,    446300,    "Morocco"                                              ],
	[ "Northern Africa",            "SDN",  40234882,    2376000,   "Sudan"                                                ],
	[ "Northern Africa",            "TUN",  11253554,    155360,    "Tunisia"                                              ],
	[ "Northern Africa",            "ESH",  572540,      469930,    "Western Sahara"                                       ],
	[ "Eastern Africa",             "IOT",  2500,        80,        "British Indian Ocean Territory"                       ],
	[ "Eastern Africa",             "BDI",  11178921,    25680,     "Burundi"                                              ],
	[ "Eastern Africa",             "COM",  788474,      1860,      "Comoros"                                              ],
	[ "Eastern Africa",             "DJI",  887861,      23180,     "Djibouti"                                             ],
	[ "Eastern Africa",             "ERI",  5227791,     101000,    "Eritrea"                                              ],
	[ "Eastern Africa",             "ETH",  99390750,    1000000,   "Ethiopia"                                             ],
	[ "Eastern Africa",             "ATF",  310,         7670,      "French Southern Territories"                          ],
	[ "Eastern Africa",             "KEN",  46050302,    569140,    "Kenya"                                                ],
	[ "Eastern Africa",             "MDG",  24235390,    581540,    "Madagascar"                                           ],
	[ "Eastern Africa",             "MWI",  17215232,    94080,     "Malawi"                                               ],
	[ "Eastern Africa",             "MUS",  1273212,     2030,      "Mauritius"                                            ],
	[ "Eastern Africa",             "MYT",  240015,      374,       "Mayotte"                                              ],
	[ "Eastern Africa",             "MOZ",  27977863,    786380,    "Mozambique"                                           ],
	[ "Eastern Africa",             "REU",  861154,      2500,      "Réunion"                                              ],
	[ "Eastern Africa",             "RWA",  11609666,    24670,     "Rwanda"                                               ],
	[ "Eastern Africa",             "SYC",  96471,       460,       "Seychelles"                                           ],
	[ "Eastern Africa",             "SOM",  10787104,    627340,    "Somalia"                                              ],
	[ "Eastern Africa",             "SSD",  12339812,    644330,    "South Sudan"                                          ],
	[ "Eastern Africa",             "UGA",  39032383,    469930,    "Uganda"                                               ],
	[ "Eastern Africa",             "TZA",  53470420,    469930,    "United Republic of Tanzania"                          ],
	[ "Eastern Africa",             "ZMB",  16211167,    469930,    "Zambia"                                               ],
	[ "Eastern Africa",             "ZWE",  15602751,    469930,    "Zimbabwe"                                             ],
	[ "Middle Africa",              "AGO",  25021974,    1246700,   "Angola"                                               ],
	[ "Middle Africa",              "CMR",  23344179,    472710,    "Cameroon"                                             ],
	[ "Middle Africa",              "CAF",  4900274,     623000,    "Central African Republic"                             ],
	[ "Middle Africa",              "TCD",  14037472,    1259200,   "Chad"                                                 ],
	[ "Middle Africa",              "COG",  4620330,     341500,    "Congo"                                                ],
	[ "Middle Africa",              "COD",  77266814,    2267050,   "Democratic Republic of the Congo"                     ],
	[ "Middle Africa",              "GNQ",  845060,      28050,     "Equatorial Guinea"                                    ],
	[ "Middle Africa",              "GAB",  1725292,     257670,    "Gabon"                                                ],
	[ "Middle Africa",              "STP",  190344,      960,       "Sao Tome and Principe"                                ],
	[ "Southern Africa",            "BWA",  2262485,     566730,    "Botswana"                                             ],
	[ "Southern Africa",            "LSO",  2135022,     30350,     "Lesotho"                                              ],
	[ "Southern Africa",            "NAM",  2458830,     823290,    "Namibia"                                              ],
	[ "Southern Africa",            "ZAF",  54490406,    1214470,   "South Africa"                                         ],
	[ "Southern Africa",            "SWZ",  1286970,     17200,     "Swaziland"                                            ],
	[ "Western Africa",             "BEN",  10879829,    110620,    "Benin"                                                ],
	[ "Western Africa",             "BFA",  18105570,    273600,    "Burkina Faso"                                         ],
	[ "Western Africa",             "CPV",  520502,      4030,      "Cabo Verde"                                           ],
	[ "Western Africa",             "CIV",  22701556,    318000,    "Côte d'Ivoire"                                        ],
	[ "Western Africa",             "GMB",  1990924,     10000,     "Gambia"                                               ],
	[ "Western Africa",             "GHA",  27409893,    227540,    "Ghana"                                                ],
	[ "Western Africa",             "GIN",  12609590,    245720,    "Guinea"                                               ],
	[ "Western Africa",             "GNB",  1844325,     28120,     "Guinea-Bissau"                                        ],
	[ "Western Africa",             "LBR",  4503438,     96320,     "Liberia"                                              ],
	[ "Western Africa",             "MLI",  17599694,    1220190,   "Mali"                                                 ],
	[ "Western Africa",             "MRT",  4067564,     1030700,   "Mauritania"                                           ],
	[ "Western Africa",             "NER",  19899120,    1266700,   "Niger"                                                ],
	[ "Western Africa",             "NGA",  182201962,   910770,    "Nigeria"                                              ],
	[ "Western Africa",             "SHN",  3961,        390,       "Saint Helena"                                         ],
	[ "Western Africa",             "SEN",  15129273,    192530,    "Senegal"                                              ],
	[ "Western Africa",             "SLE",  6453184,     71620,     "Sierra Leone"                                         ],
	[ "Western Africa",             "TGO",  7304578,     54390,     "Togo"                                                 ],
	[ "Caribbean",                  "AIA",  14614,       90,        "Anguilla"                                             ],
	[ "Caribbean",                  "ATG",  91818,       440,       "Antigua and Barbuda"                                  ],
	[ "Caribbean",                  "ABW",  103889,      180,       "Aruba"                                                ],
	[ "Caribbean",                  "BHS",  388019,      10010,     "Bahamas"                                              ],
	[ "Caribbean",                  "BRB",  284215,      430,       "Barbados"                                             ],
	[ "Caribbean",                  "BES",  24861,       330,       "Bonaire, Sint Eustatius and Saba"                     ],
	[ "Caribbean",                  "VGB",  30117,       150,       "British Virgin Islands"                               ],
	[ "Caribbean",                  "CYM",  59967,       260,       "Cayman Islands"                                       ],
	[ "Caribbean",                  "CUB",  11389562,    109820,    "Cuba"                                                 ],
	[ "Caribbean",                  "CUW",  157203,      440,       "Curaçao"                                              ],
	[ "Caribbean",                  "DMA",  72680,       750,       "Dominica"                                             ],
	[ "Caribbean",                  "DOM",  10528391,    48320,     "Dominican Republic"                                   ],
	[ "Caribbean",                  "GRD",  106825,      340,       "Grenada"                                              ],
	[ "Caribbean",                  "GLP",  468450,      1690,      "Guadeloupe"                                           ],
	[ "Caribbean",                  "HTI",  10711067,    27560,     "Haiti"                                                ],
	[ "Caribbean",                  "JAM",  2793335,     10830,     "Jamaica"                                              ],
	[ "Caribbean",                  "MTQ",  396425,      1060,      "Martinique"                                           ],
	[ "Caribbean",                  "MSR",  5125,        100,       "Montserrat"                                           ],
	[ "Caribbean",                  "PRI",  3683238,     8870,      "Puerto Rico"                                          ],
	[ "Caribbean",                  "BLM",  9279,        21,        "Saint Barthélemy"                                     ],
	[ "Caribbean",                  "KNA",  55572,       260,       "Saint Kitts and Nevis"                                ],
	[ "Caribbean",                  "LCA",  184999,      610,       "Saint Lucia"                                          ],
	[ "Caribbean",                  "MAF",  36824,       53,        "Saint Martin (French Part)"                           ],
	[ "Caribbean",                  "VCT",  109462,      390,       "Saint Vincent and the Grenadines"                     ],
	[ "Caribbean",                  "SXM",  38745,       34,        "Sint Maarten (Dutch part)"                            ],
	[ "Caribbean",                  "TTO",  1360088,     5130,      "Trinidad and Tobago"                                  ],
	[ "Caribbean",                  "TCA",  34339,       469930,    "Turks and Caicos Islands"                             ],
	[ "Caribbean",                  "VIR",  106291,      469930,    "United States Virgin Islands"                         ],
	[ "Central America",            "BLZ",  359287,      22810,     "Belize"                                               ],
	[ "Central America",            "CRI",  4807850,     51060,     "Costa Rica"                                           ],
	[ "Central America",            "SLV",  6126583,     20720,     "El Salvador"                                          ],
	[ "Central America",            "GTM",  16342897,    107160,    "Guatemala"                                            ],
	[ "Central America",            "HND",  8075060,     111890,    "Honduras"                                             ],
	[ "Central America",            "MEX",  127017224,   1943950,   "Mexico"                                               ],
	[ "Central America",            "NIC",  6082032,     119990,    "Nicaragua"                                            ],
	[ "Central America",            "PAN",  3929141,     74340,     "Panama"                                               ],
	[ "South America",              "ARG",  43416755,    2736690,   "Argentina"                                            ],
	[ "South America",              "BOL",  10724705,    1083300,   "Bolivia"                                              ],
	[ "South America",              "BRA",  207847528,   8459420,   "Brazil"                                               ],
	[ "South America",              "CHL",  17948141,    743800,    "Chile"                                                ],
	[ "South America",              "COL",  48228704,    1109500,   "Colombia"                                             ],
	[ "South America",              "ECU",  16144363,    276840,    "Ecuador"                                              ],
	[ "South America",              "FLK",  2903,        12170,     "Falkland Islands (Malvinas)"                          ],
	[ "South America",              "GUF",  268606,      88150,     "French Guiana"                                        ],
	[ "South America",              "GUY",  767085,      196850,    "Guyana"                                               ],
	[ "South America",              "PRY",  6639123,     397300,    "Paraguay"                                             ],
	[ "South America",              "PER",  31376670,    1280000,   "Peru"                                                 ],
	[ "South America",              "SGS",  30,          3900,      "South Georgia and the South Sandwich Islands"         ],
	[ "South America",              "SUR",  542975,      156000,    "Suriname"                                             ],
	[ "South America",              "URY",  3431555,     469930,    "Uruguay"                                              ],
	[ "South America",              "VEN",  31108083,    469930,    "Venezuela"                                            ],
	[ "Northern America",           "BMU",  62004,       50,        "Bermuda"                                              ],
	[ "Northern America",           "CAN",  35939927,    9093510,   "Canada"                                               ],
	[ "Northern America",           "GRL",  56186,       410450,    "Greenland"                                            ],
	[ "Northern America",           "SPM",  6288,        230,       "Saint Pierre and Miquelon"                            ],
	[ "Northern America",           "USA",  321773631,   469930,    "United States of America"                             ],
	[ "Antarctica",                 "ATA",  5000,        14000000,  "Antarctica"                                           ],
	[ "Central Asia",               "KAZ",  17625226,    2699700,   "Kazakhstan"                                           ],
	[ "Central Asia",               "KGZ",  5939962,     191800,    "Kyrgyzstan"                                           ],
	[ "Central Asia",               "TJK",  8481855,     139960,    "Tajikistan"                                           ],
	[ "Central Asia",               "TKM",  5373502,     469930,    "Turkmenistan"                                         ],
	[ "Central Asia",               "UZB",  29893488,    469930,    "Uzbekistan"                                           ],
	[ "Eastern Asia",               "CHN",  1376048943,  9327489,   "China"                                                ],
	[ "Eastern Asia",               "HKG",  7287983,     1070,      "Hong Kong"                                            ],
	[ "Eastern Asia",               "MAC",  587606,      28,        "Macao"                                                ],
	[ "Eastern Asia",               "PRK",  25155317,    120410,    "North Korea"                                          ],
	[ "Eastern Asia",               "JPN",  126573481,   364500,    "Japan"                                                ],
	[ "Eastern Asia",               "MNG",  2959134,     1553560,   "Mongolia"                                             ],
	[ "Eastern Asia",               "KOR",  50293439,    96920,     "South Korea"                                          ],
	[ "Eastern Asia",               "TWN",  23381038,    32260,     "Taiwan (Chinese Taipei)"                              ],
	[ "South-eastern Asia",         "BRN",  423188,      5270,      "Brunei Darussalam"                                    ],
	[ "South-eastern Asia",         "KHM",  15577899,    176520,    "Cambodia"                                             ],
	[ "South-eastern Asia",         "IDN",  257563815,   1811570,   "Indonesia"                                            ],
	[ "South-eastern Asia",         "LAO",  6802023,     230800,    "Laos (Lao People's Democratic Republic)"              ],
	[ "South-eastern Asia",         "MYS",  30331007,    328550,    "Malaysia"                                             ],
	[ "South-eastern Asia",         "MMR",  53897154,    653520,    "Myanmar"                                              ],
	[ "South-eastern Asia",         "PHL",  100699395,   298170,    "Philippines"                                          ],
	[ "South-eastern Asia",         "SGP",  5603740,     697,       "Singapore"                                            ],
	[ "South-eastern Asia",         "THA",  67959359,    510890,    "Thailand"                                             ],
	[ "South-eastern Asia",         "TLS",  1184765,     14870,     "Timor-Leste"                                          ],
	[ "South-eastern Asia",         "VNM",  93447601,    469930,    "Vietnam (Viet Nam)"                                   ],
	[ "Southern Asia",              "AFG",  32526562,    652230,    "Afghanistan"                                          ],
	[ "Southern Asia",              "BGD",  160995642,   130170,    "Bangladesh"                                           ],
	[ "Southern Asia",              "BTN",  774830,      38394,     "Bhutan"                                               ],
	[ "Southern Asia",              "IND",  1311050527,  2973190,   "India"                                                ],
	[ "Southern Asia",              "IRN",  79109272,    1628550,   "Iran (Islamic Republic of)"                           ],
	[ "Southern Asia",              "MDV",  363657,      300,       "Maldives"                                             ],
	[ "Southern Asia",              "NPL",  28513700,    143350,    "Nepal"                                                ],
	[ "Southern Asia",              "PAK",  188924874,   770880,    "Pakistan"                                             ],
	[ "Southern Asia",              "LKA",  20715010,    64630,     "Sri Lanka"                                            ],
	[ "Western Asia",               "ARM",  3017712,     28200,     "Armenia"                                              ],
	[ "Western Asia",               "AZE",  9753968,     82629,     "Azerbaijan"                                           ],
	[ "Western Asia",               "BHR",  1377237,     710,       "Bahrain"                                              ],
	[ "Western Asia",               "CYP",  1165300,     9240,      "Cyprus"                                               ],
	[ "Western Asia",               "GEO",  3999812,     69490,     "Georgia"                                              ],
	[ "Western Asia",               "IRQ",  36423395,    437370,    "Iraq"                                                 ],
	[ "Western Asia",               "ISR",  8064036,     21640,     "Israel"                                               ],
	[ "Western Asia",               "JOR",  7594547,     88240,     "Jordan"                                               ],
	[ "Western Asia",               "KWT",  3892115,     17820,     "Kuwait"                                               ],
	[ "Western Asia",               "LBN",  5850743,     10230,     "Lebanon"                                              ],
	[ "Western Asia",               "OMN",  4490541,     309500,    "Oman"                                                 ],
	[ "Western Asia",               "QAT",  2235355,     11590,     "Qatar"                                                ],
	[ "Western Asia",               "SAU",  31540372,    2149690,   "Saudi Arabia"                                         ],
	[ "Western Asia",               "PSE",  4668466,     6020,      "State of Palestine"                                   ],
	[ "Western Asia",               "SYR",  18502413,    183630,    "Syrian Arab Republic"                                 ],
	[ "Western Asia",               "TUR",  78665830,    769630,    "Turkey"                                               ],
	[ "Western Asia",               "ARE",  9156963,     469930,    "United Arab Emirates"                                 ],
	[ "Western Asia",               "YEM",  26832215,    469930,    "Yemen"                                                ],
	[ "Eastern Europe",             "BLR",  9495826,     202900,    "Belarus"                                              ],
	[ "Eastern Europe",             "BGR",  7149787,     108610,    "Bulgaria"                                             ],
	[ "Eastern Europe",             "CZE",  10543186,    77250,     "Czechia (Czech Republic)"                             ],
	[ "Eastern Europe",             "HUN",  9855023,     89610,     "Hungary"                                              ],
	[ "Eastern Europe",             "POL",  38611794,    304250,    "Poland"                                               ],
	[ "Eastern Europe",             "MDA",  4068897,     32890,     "Republic of Moldova"                                  ],
	[ "Eastern Europe",             "ROU",  19511324,    229890,    "Romania"                                              ],
	[ "Eastern Europe",             "RUS",  143456918,   16377740,  "Russian Federation"                                   ],
	[ "Eastern Europe",             "SVK",  5426258,     48100,     "Slovakia"                                             ],
	[ "Eastern Europe",             "UKR",  44823765,    469930,    "Ukraine"                                              ],
	[ "Northern Europe",            "ALA",  28007,       1580,      "Åland Islands"                                        ],
	[ "Northern Europe",            "GGY",  63026,       80,        "Guernsey"                                             ],
	[ "Northern Europe",            "JEY",  100080,      120,       "Jersey"                                               ],
	[ "Northern Europe",            "XSK",  600,         5,         "Sark"                                                 ],
	[ "Northern Europe",            "DNK",  5669081,     42430,     "Denmark"                                              ],
	[ "Northern Europe",            "EST",  1312558,     42390,     "Estonia"                                              ],
	[ "Northern Europe",            "FRO",  48199,       1400,      "Faroe Islands"                                        ],
	[ "Northern Europe",            "FIN",  5503457,     304090,    "Finland"                                              ],
	[ "Northern Europe",            "ISL",  329425,      100250,    "Iceland"                                              ],
	[ "Northern Europe",            "IRL",  4688465,     68890,     "Ireland"                                              ],
	[ "Northern Europe",            "IMN",  87780,       570,       "Isle of Man"                                          ],
	[ "Northern Europe",            "LVA",  1970503,     62250,     "Latvia"                                               ],
	[ "Northern Europe",            "LTU",  2878405,     62680,     "Lithuania"                                            ],
	[ "Northern Europe",            "NOR",  5210967,     304280,    "Norway"                                               ],
	[ "Northern Europe",            "SJM",  2642,        62050,     "Svalbard and Jan Mayen Islands"                       ],
	[ "Northern Europe",            "SWE",  9779426,     410330,    "Sweden"                                               ],
	[ "Northern Europe",            "GBR",  64715810,    469930,    "United Kingdom of Great Britain and Northern Ireland" ],
	[ "Southern Europe",            "ALB",  2896679,     27400,     "Albania"                                              ],
	[ "Southern Europe",            "AND",  70473,       470,       "Andorra"                                              ],
	[ "Southern Europe",            "BIH",  3810416,     51200,     "Bosnia and Herzegovina"                               ],
	[ "Southern Europe",            "HRV",  4240317,     53910,     "Croatia"                                              ],
	[ "Southern Europe",            "GIB",  32217,       10,        "Gibraltar"                                            ],
	[ "Southern Europe",            "GRC",  10954617,    128900,    "Greece"                                               ],
	[ "Southern Europe",            "XKV",  1907592,     10890,     "Kosovo"                                               ],
	[ "Southern Europe",            "VAT",  800,         469930,    "Vatican City (Hole See)"                              ],
	[ "Southern Europe",            "ITA",  59797685,    294140,    "Italy"                                                ],
	[ "Southern Europe",            "MLT",  418670,      320,       "Malta"                                                ],
	[ "Southern Europe",            "MNE",  625781,      13450,     "Montenegro"                                           ],
	[ "Southern Europe",            "PRT",  10349803,    91500,     "Portugal"                                             ],
	[ "Southern Europe",            "SMR",  31781,       60,        "San Marino"                                           ],
	[ "Southern Europe",            "SRB",  6943383,     88360,     "Serbia"                                               ],
	[ "Southern Europe",            "SVN",  2067526,     20140,     "Slovenia"                                             ],
	[ "Southern Europe",            "ESP",  46121699,    498980,    "Spain"                                                ],
	[ "Southern Europe",            "MKD",  2078453,     25430,     "Macedonia"                                            ],
	[ "Western Europe",             "AUT",  8544586,     82450,     "Austria"                                              ],
	[ "Western Europe",             "BEL",  11299192,    30280,     "Belgium"                                              ],
	[ "Western Europe",             "FRA",  64395345,    547660,    "France"                                               ],
	[ "Western Europe",             "DEU",  80688545,    348770,    "Germany"                                              ],
	[ "Western Europe",             "LIE",  37531,       160,       "Liechtenstein"                                        ],
	[ "Western Europe",             "LUX",  567110,      2590,      "Luxembourg"                                           ],
	[ "Western Europe",             "MCO",  37731,       2,         "Monaco"                                               ],
	[ "Western Europe",             "NLD",  16924929,    33760,     "Netherlands"                                          ],
	[ "Western Europe",             "CHE",  8298663,     40000,     "Switzerland"                                          ],
	[ "Australia and New Zealand",  "AUS",  23968973,    7682300,   "Australia"                                            ],
	[ "Australia and New Zealand",  "CXR",  2072,        140,       "Christmas Island"                                     ],
	[ "Australia and New Zealand",  "CCK",  596,         10,        "Cocos (Keeling) Islands"                              ],
	[ "Australia and New Zealand",  "NZL",  4528526,     267710,    "New Zealand"                                          ],
	[ "Australia and New Zealand",  "NFK",  2210,        40,        "Norfolk Island"                                       ],
	[ "Melanesia",                  "FJI",  892145,      18270,     "Fiji"                                                 ],
	[ "Melanesia",                  "NCL",  263118,      18280,     "New Caledonia"                                        ],
	[ "Melanesia",                  "PNG",  7619321,     452860,    "Papua New Guinea"                                     ],
	[ "Melanesia",                  "SLB",  583591,      27990,     "Solomon Islands"                                      ],
	[ "Melanesia",                  "VUT",  264652,      469930,    "Vanuatu"                                              ],
	[ "Micronesia",                 "GUM",  169885,      540,       "Guam"                                                 ],
	[ "Micronesia",                 "KIR",  112423,      810,       "Kiribati"                                             ],
	[ "Micronesia",                 "MHL",  52993,       180,       "Marshall Islands"                                     ],
	[ "Micronesia",                 "FSM",  104460,      700,       "Micronesia (Federated States of)"                     ],
	[ "Micronesia",                 "NRU",  10222,       20,        "Nauru"                                                ],
	[ "Micronesia",                 "MNP",  55070,       460,       "Northern Mariana Islands"                             ],
	[ "Micronesia",                 "PLW",  21291,       460,       "Palau"                                                ],
	[ "Micronesia",                 "UMI",  316,         469930,    "United States Minor Outlying Islands"                 ],
	[ "Polynesia",                  "ASM",  55538,       200,       "American Samoa"                                       ],
	[ "Polynesia",                  "COK",  20833,       240,       "Cook Islands"                                         ],
	[ "Polynesia",                  "PYF",  282764,      3660,      "French Polynesia"                                     ],
	[ "Polynesia",                  "NIU",  1610,        260,       "Niue"                                                 ],
	[ "Polynesia",                  "PCN",  56,          47,        "Pitcairn"                                             ],
	[ "Polynesia",                  "WSM",  193228,      2830,      "Samoa"                                                ],
	[ "Polynesia",                  "TKL",  1250,        10,        "Tokelau"                                              ],
	[ "Polynesia",                  "TON",  106170,      720,       "Tonga"                                                ],
	[ "Polynesia",                  "TUV",  9916,        469930,    "Tuvalu"                                               ],
	[ "Polynesia",                  "WLF",  13151,       469930,    "Wallis and Futuna Islands"                            ]
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
	iso, pop, area, name = country[1..-1]
	db.execute "INSERT INTO Countries VALUES (?, ?, ?, ?, ?)", iso, name, pop, area, subcontinent
end

# create view
db.execute <<-SQL
	CREATE VIEW CountriesView
	(Continent, Subcontinent, Country, Population, Area, ISO) AS 
	SELECT Continents.Name,
		Subcontinents.Name,
		Countries.Name,
		Countries.Population,
		Countries.Area,
		Countries.ISO
	FROM Continents
		JOIN Subcontinents
			ON Continents.rowid = Subcontinents.Continent
		JOIN Countries
			ON Subcontinents.rowid = Countries.Subcontinent
SQL
