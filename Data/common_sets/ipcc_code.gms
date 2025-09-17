$OnText
--------------------------------------------------------------------------------
			OECD-ENV Model version 1 -Aggregation Procedure
    GAMS file   : "%SetsDir%\ipcc_code.gms"
    purpose     : Definition of set "ipcc_Codes following EDGAR
    Created by  : Jean Chateau
    created Date:
    called by   : ENV-SmallDev\Jean\DataEco\EDGAR\Export_2022EDGAR_Data.gms
                  or "%SatDataDir%\GHG\Export_EDGAR_to_GTAP.gms"
--------------------------------------------------------------------------------
   file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
   last changed revision: $Rev: 520 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    ipcc doc:
	https://www.ipcc-nggip.iges.or.jp/public/2006gl/
    https://www.ipcc-nggip.iges.or.jp/public/2006gl/pdf/1_Volume1/V1_4_Ch4_MethodChoice.pdf
    https://www.ipcc-nggip.iges.or.jp/public/2019rf/index.html
*------------------------------------------------------------------------------*
$OffText

$IF NOT SET IPCCvers $SetGlobal IPCCvers "IPCC1996"

*Set ipcc_Codes /

*------------------------------------------------------------------------------*
*                   1996 IPCC Codes                                            *
*------------------------------------------------------------------------------*

* Note # indicates that it is also an emission source from "bio" fuel

*   Energy: Fuel Combustion (1A)

"1A1"        "Energy Industries"
"1A1a"	     "Main Activity Electricity and Heat Production#"
"1A1b"       "Petroleum Refining"
"1A1c"       "Manufacture of Solid Fuels and Other Energy Industries"
$IFi %IPCCvers%=="IPCC1996" "1A1bc"	     "Other Energy Industries#"

"1A2"	   	"Manufacturing Industries and Construction#"
"1A3"       "Transport"
"1A3a"	   	"Domestic aviation"
"1A3b"	   	"Road transportation#"
"1A3b_noRES" "Road transportation no resuspension"
"1A3b_RES"	"Road transportation resuspension"
"1A3c"      "Rail transportation#"
"1A3d"	   	"Inland navigation#"
"1A3e"	   	"Other transportation#"
"1A4"	   	"Residential and other sectors#"

*   Energy: Fugitive emissions from fuel (1B)
* Including venting and flaring from oil and gas
"1B1"       "Fugitive emissions from solid fuels"
"1B1x"      "Fugitive emissions from solid fuels"
"1B2"       "Fugitive emissions from oil and gas / liquid fuels#"
"1B2x"      "Fugitive emissions from gaseous fuels"

*   "1C" "CO2 from Transport and Storage"
"1C1"       "Memo: International aviation"
"1C2"       "Memo: International navigation"

*   2. Industrial Processes (non-combustion)

"2A"     "Nonmetallic minerals production "
"2A1"	 "Cement production"
"2A2"	 "Lime production"
$IFi %IPCCvers%=="IPCC1996" "2A3"    "Limestone and dolomite use"
$IFi %IPCCvers%=="IPCC1996" "2A4"	 "Soda ash production and use"

"2A5"    "Asphalt Roofing "
"2A6"    "Road Paving with Asphalt "
"2A7"	 "Production of other minerals"

"2B"	 "Production of chemicals"
*"2B1"	 "Ammonia production"
*"2B2"	 "Nitric acid production"
* "2B9"  "Chemical Industry: Fluorochemical Production"
"2C"	 "Production of metals#"
"2C1"    "Iron & Steel"
"2C3"    "Process emissions of primary aluminium production (PFC)"
"2C4"    "Process emissions of SF6 "
"2C4_AL" "Process emissions of SF6 used in aluminium production"
"2C4_MG" "Process emissions of SF6 used in magnesium foundries"
"2C4a"	 "process emissions of SF6 used in aluminium production"
"2C4b"	 "process emissions of SF6 used in magnesium foundries"
*"2C5"   "Lead Production"
*"2C6"   "Zinc Production"

$IFi %IPCCvers%=="IPCC1996" "2D"	 "Production of pulp/paper/food/drink"
"2E"     "Electronic Industry: Byproduct emissions of production of halocarbons and sulphur hexafluoride:Electronics Industry"
"2E1"    "Byproduct emissions of production of halocarbons and sulphur hexafluoride "

"2F1"    "Refrigeration and air conditioning  (HFC and PFC)"
"2F1a"   "Consumption of halocarbons and sulphur hexafluoride: refrigerator and air conditioning "
"2F1b"   "Domestic refrigeration"
"2F1c"   "Industrial refrigeration"
"2F1d"   "Transport refrigeration"
"2F1e"   "Mobile Air Conditioning"
"2F1f"   "Stationary Air Conditioning"

"2F2"    "Consumption of halocarbons and sulphur hexafluoride: foam blowing"
"2F2a"   "Closed cell foam"
"2F2b"   "Open cell foam"
"2F3"    "Consumption of halocarbons and sulphur hexafluoride: fire extinguishers "
"2F4"    "Consumption of halocarbons and sulphur hexafluoride: aerosols "
"2F5"    "Consumption of halocarbons and sulphur hexafluoride: solvents "
"2F6"    "Other ODS"
"2F7"    "Semiconductor electronics manufacture, Including FPDs and PV cells"
"2F7a"   "Consumption of halocarbons: semiconductors manufacturing"
"2F7b"   "Consumption of halocarbons: flat panel display production"
"2F7C"   "Consumption of halocarbons: photovoltaic cells manufacturing"
"2F8"    "Consumption of halocarbons: electrical equipment"
"2F8b"   "Consumption of halocarbons: electrical equipment use"

"2F9"    "Other F-gas use and SF6 "
"2F9a"   "Other F-gas use and SF6: adiabatic prop: shoes and others"
"2F9b"   "Other F-gas use and SF6: adiabatic prop: tyres"
"2F9c"   "Other F-gas use and SF6: sound proof windows"
"2F9d"   "Other F-gas use and SF6: accelerators"
"2F9e"   "Other F-gas use and SF6: awacs, other military, misc."
"2F9f"   "Other F-gas use and SF6: unknown SF6 use "
$IFi %IPCCvers%=="IPCC1996" "2G"	 "Non-energy use of lubricants/waxes (CO2)"

*   3. Solvent and other product use

"3A"    "Solvent and other product use: paint"
"3B"	"Solvent and other product use: degrease"
"3C"    "Solvent and other product use: chemicals"
"3D"    "Solvent and other product use: other"

*   4. Agriculture

$IFtheni.IPCC1996 %IPCCvers%=="IPCC1996"

	"4A"    "Enteric fermentation"
	"4B"	"Manure management"
	"4C"	"Rice cultivation"
	"4D"    "Direct agricultural soil emissions (fertilizers, manure, crop residues) "
	"4D1"	"Direct soil emissions"
	"4D2"	"Manure in pasture/range/paddock"
	"4D3"   "Indirect N2O from agriculture"
	"4D4"	"Other direct soil emissions"
	"4E"    "Savannah burning "
	"4F"	"Agricultural waste burning#"

$Endif.IPCC1996

*   5. Land Use Change and Forestry

* peat fires = feux de tourbe
$IFi %IPCCvers%=="IPCC1996" "5A"    "Forest fires, including peat fires"
"5C"    "Grassland fires"
* decay of drained peat soils = d�composition des sols tourbeux
"5D"    "Wetland / peat fires and decay"
"5F"    "Other vegetation fires"
"5F2"   "Forest fires decay"
"5FL"   "Forest land: net carbon stock change"

*   6. Waste

"6A"	"Solid waste disposal on land"
"6B"    "Wastewater handling"
"6C"	"Waste incineration#"
"6D"    "Other waste handling"

*   7. Other anthropogenic sources

* 7A --> "Fossil fuel fires: coal (underground) and oil (Kuwait)"

"7A"	    "Fossil fuel fires"
"7B"        "Indirect N2O from non-agricultural NOx"
"7B_1A1_PP" "Indirect N2O from non-agricultural NOx (emitted in cat. 1A1 - power plants) "
"7B_1A2_IC" "Indirect N2O from non-agricultural NOx (emitted in cat. 1A2 - industrial combustion for manufacturing) "
"7B_1A3_TR" "Indirect N2O from non-agricultural NOx (emitted in cat. 1A3 - transport) "
"7B_1A4_RE" "Indirect N2O from non-agricultural NOx (emitted in cat. 1A4 - residential) "
"7B_5_FF"   "Indirect N2O from non-agricultural NOx (emitted in cat. 5 - forest fires) "
"7C"        "Indirect N2O from non-agricultural NH3"
"7C_1A1_PP" "Indirect N2O from non-agricultural NH3 (emitted in cat. 1A1 - power plants) "
"7C_1A2_IC" "Indirect N2O from non-agricultural NH3 (emitted in cat. 1A2 - industrial combustion for manufacturing) "
"7C_1A3_TR" "Indirect N2O from non-agricultural NH3 (emitted in cat. 1A3 - transport) "
"7C_1A4_RE" "Indirect N2O from non-agricultural NH3 (emitted in cat. 1A4 - residential) "
"7C_5_FF"   "Indirect N2O from non-agricultural NH3 (emitted in cat. 5 - forest fires) "
"7D"        "Other anthropogenic sources "

$OnText
1B1	    "Fugitive emissions from solid fuels:	NMVOC"
1B1	    "Fugitive emissions from solid fuels:	CO2f"
1B1	    "Fugitive emissions from solid fuels:	CO2b"
1B1x	"Fugitive emissions from solid fuels:	NMVOC"
1B1x	"Fugitive emissions from solid fuels:	CO2b"
                                            :
1B2	    "Fugitive emissions from oil and gas:	CO2f"
1B2	    "Fugitive emissions from gaseous fuels:	CO2f"
1B2	    "Fugitive emissions from oil and gas:	NMVOC"
1B2	    "Fugitive emissions from gaseous fuels:	NMVOC"
1B2	    "Fugitive emissions from liquid fuels:	NMVOC"

1B2x	"Fugitive emissions from gaseous fuels:	NMVOC"
1B2x	"Fugitive emissions from oil and gas:	CH4"
1B2x	"Fugitive emissions from gaseous fuels:	CO2b"
$OffText

*------------------------------------------------------------------------------*
*                   2006 IPCC Codes: different label/source                    *
*------------------------------------------------------------------------------*
$OnText
        After 2006 IPCC cat. names are different
    2D: Non-Energy Products from Fuels and Solvent Use
    2D1: Lubricant Use
    2D2: Paraffin Wax Use
    2D3: Solvent Use
    2D4: Other
    2H: Other
    2H1: Pulp and Paper Industry
    2H2: Food and Beverages Industry
    2F3: Other
$OffText

"1A5"	     "Non-Specified"


$IFtheni.IPCC2006 %IPCCvers%=="IPCC2006"

* Different Labels

* "Petroleum Refining - Manufacture of Solid Fuels and Other Energy Industries"

	"1A1bc"	"Petroleum Refining - Manufacture of Solid Fuels and Other Energ"
	"2A3"	"Glass Production"
	"2A4"   "Other Process Uses of Carbonates"

* Different Sources

	"4A"    "Solid Waste Disposal"
	"4B"	"Biological Treatment of Solid Waste"
	"4C"    "Incineration and Open Burning of Waste"
	"4D"    "Wastewater Treatment and Discharge"

* "Indirect N2O emissions from the atmospheric deposition of nitrogen in NOx and NH3"

	"5A" 	"Indirect N2O emissions from the atmospheric deposition of nitro"
	"5B"    "Fossil fuel fires"

	"3A1"	"Enteric Fermentation"
	"3A2"	"Manure Management"
	"3C1"   "Emissions from biomass burning"
	"3C2"   "Liming"
	"3C3"	"Urea application"
	"3C4"   "Direct N2O Emissions from managed soils"
	"3C5"	"Indirect N2O Emissions from managed soils"
	"3C6"	"Indirect N2O Emissions from manure management"
	"3C7"   "Rice cultivations"

	"2D"	"Non-Energy Products from Fuels and Solvent Use"
	"2F" 	"Product Uses as Substitutes for Ozone Depleting Substances"
	"2G" 	"Other Product Manufacture and Use"
	"2H"	"Other"

$Endif.IPCC2006

*/ ;
*Execute_unload "V:\CLIMATE_MODELLING\results\2023_02_16_ipcc_Codes.gdx", ipcc_Codes;

