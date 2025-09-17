$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1 -Aggregation Procedure
	GAMS file   : "ipcc_code.gms"
    purpose     : Definition of set "ipcc_source"
    Created by  : Jean Chateau
    created Date:
    called by   : ENV-SmallDev\Jean\DataEco\EDGAR\Export_2022EDGAR_Data.gms
--------------------------------------------------------------------------------
   file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
   last changed revision: $Rev: 520 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*Set ipcc_source /

*------------------------------------------------------------------------------*
*                   1996 IPCC Labels  (2nd Label is 2006 Code=                 *
*------------------------------------------------------------------------------*

* IPCC Sources (extracted from EDGAR Database)

"Public electricity and heat production"    "1A1a"
"Other Energy Industries"                   "1A1bc"
"Manufacturing Industries and Construction" "1A2"
"Domestic aviation"                         "1A3a"
"Road transportation"                       "1A3b"

"Petroleum Refining"                                      "1A1b"
"Manufacture of Solid Fuels and Other Energy Industries"  "1A1c"

"Road transportation no resuspension"       "1A3b_noRES"
"Road transportation resuspension"          "1A3b_RES"

"Rail transportation"                       "1A3c"
"Inland navigation"                         "1A3d"
"Other transportation"                      "1A3e"
"Residential and other sectors"             "1A4"

"Fugitive emissions from solid fuels"       "1B1"
"Fugitive emissions from gaseous fuels"	    "1B2"
"Fugitive emissions from liquid fuels"	    "1B2"
"Fugitive emissions from oil and gas"       "1B2"

"Memo: International aviation"              "1C1"
"Memo: International navigation"            "1C2"

* 2. Industrial Processes (non-combustion)

"Nonmetallic minerals production"           "2A"
"Cement production"                         "2A1"
"Lime production"                           "2A2"
"Limestone and dolomite use"                "2A3"
"Soda ash production and use"               "2A4"
"Production of other minerals"              "2A7"
"Production of chemicals"                   "2B"
"Production of metals"                      "2C"
"Production of pulp/paper/food/drink"       "2D"
"Non-energy use of lubricants/waxes (CO2)"  "2G"

* Electronic Industry
"Production of halocarbons and SF6"         "2E"

"Electrical Equipment"                      "2F8"
"Commerical refrigeration"                  "2F1A"
"Aerosols"                                  "2F4"
"Closed cell foam"                          "2F2a"
"Open cell foam"                            "2F2b"
"Semiconductor/Electronics Manufacture"     "2F7"
"Other F-gas use"                           "2F9"
"Domestic refrigeration"                    "2F1b"
"Industrial refrigeration"                  "2F1c"
"Transport refrigeration"                   "2F1d"
"Mobile Air Conditioning"                   "2F1e"
"Stationary Air Conditioning"               "2F1f"
"Fire Extinguishers"                        "2F3"
"Solvents"                                  "2F5"
"F-gas as Solvent"                          "2F5"
"Other ODS"                                 "2F6"

"Solvent and other product use: paint"      "3A"
"Solvent and other product use: degrease"   "3B"
"Solvent and other product use: chemicals"  "3C"
"Solvent and other product use: other"      "3D | 2G"

"Enteric fermentation"                      "4A | 3A1"
"Manure management"                         "4B | 3A2"
"Rice cultivation"                          "4C | 3C7"
"Direct soil emissions"                     "4D1 | 3C4"
"Manure in pasture/range/paddock"           "4D2"
"Indirect N2O from agriculture"             "4D3"
"Other direct soil emissions"               "4D4"
"Agricultural waste burning"                "4F | 3C1"

"Solid waste disposal on land"              "6A | 4A"
"Wastewater handling"                       "6B | 4D"
"Waste incineration"                        "6C | 4C"
"Other waste handling"                      "6D | 4B"

"Fossil fuel fires"                         "7A | 5B"
"Indirect N2O from non-agricultural NOx"    "7B"
"Indirect N2O from non-agricultural NH3"    "7C"

*------------------------------------------------------------------------------*
*                   2006 IPCC Codes: different label/source                    *
*------------------------------------------------------------------------------*

* "Petroleum Refining - Manufacture of Solid Fuels and Other Energy Industries" "1A1bc"

"Main Activity Electricity and Heat Production"                     "1A1a"
"Non-Specified"                                                     "1A5"
"Solid Fuels"                                                       "1B1"
"Civil Aviation"                                                    "1A3a"
"Railways"                                                          "1A3c"
"Water-borne Navigation"                                            "1A3d"
"Petroleum Refining - Manufacture of Solid Fuels and Other Energ"   "1A1bc"
"Oil and Natural Gas"                                               "1B2"

"Glass Production"                                                  "2A3"
"Other Process Uses of Carbonates"                                  "2A4"
"Chemical Industry"                                                 "2B"
"Metal Industry"                                                    "2C"
"Non-Energy Products from Fuels and Solvent Use"                    "2D"
"Product Uses as Substitutes for Ozone Depleting Substances"        "2F"
"Other Product Manufacture and Use"                                 "2G"
"Electronics Industry"                                              "2E"
"Other"                                                             "2H"

* "Indirect N2O emissions from the atmospheric deposition of nitrogen in NOx and NH3"
"Indirect N2O emissions from the atmospheric deposition of nitro" "5A"

"Emissions from biomass burning"                                    "3C1"
"Liming"                                                            "3C2"
"Urea application"													"3C3"
"Direct N2O Emissions from managed soils"                           "3C4"
"Indirect N2O Emissions from managed soils"							"3C5"
"Indirect N2O Emissions from manure management" 					"3C6"
"Rice cultivations"                                                 "3C7"

"Solid Waste Disposal"                                              "4A"
"Biological Treatment of Solid Waste"                               "4B"
"Incineration and Open Burning of Waste"                            "4C"
"Wastewater Treatment and Discharge"								"4D"


*/ ;
*Execute_unload "V:\CLIMATE_MODELLING\results\2023_02_16_ipcc_source.gdx", ipcc_source;

1A1bc	Petroleum Refining - Manufacture of Solid Fuels and Other Energ	N2O	fossil
