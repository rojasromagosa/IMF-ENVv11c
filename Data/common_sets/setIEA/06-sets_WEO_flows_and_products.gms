
$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] project V1  - Aggregation procedure
   GAMS file: sets_WEO_flows_and_products.gms
   created date: 6 Juin 2017 / revised 28 Janvier 2022
   created by: Jean Chateau
   called by:
--------------------------------------------------------------------------------
$OffText

$IF NOT SET weoUSD $SetGlobal weoUSD "2017"

set WeoGood  "WEO Products" /
    "Total"
    "Heat"
    ""
    "<empty>"
    "Coal"
    "Oil"
    "Gas"
    "Electricity"
    "Hydrogen"
    "Biomass_Waste"

* Categorie agrege (remove it)
*   Other_Renewables

*   Additional Subset for Power Generation

    "Nuclear"
    "Hydro"
    "Wind"
    "Geothermal"
    "Solar_PV"
    "Concentrated_Solar_Power"
    "Tide_and_Wave"
    "Other"

*   Subset for Road transport subsector (caduc ?)
    "PLDV_Gasoline"
    "PLDV_Diesel"
    "PLDV_Natural_Gas"
    "PLDV_Electricity"
    "PLDV_Ethanol"
    "PLDV_Biodiesel"
    "PLDV_Hydrogen"

*   Subset for Non-Energy Sector (Investments)
    "CCS"
    "Efficiency"

    "Coal_Efficiency"
    "Oil_Efficiency"
    "Gas_Efficiency"
    "More_efficient_coal"
    "More_efficient_gas"
    "Oil_CCS"
    "Coal_CCS"
    "Gas_CCS"
    "Solar"

*   Alternative Names

    "Aviation"

    "Biodiesel"
    "Bioenergy"
    "Biomass"
    "Ethanol"

    "Renewables"
    "Geo"
    "Solar CSP"
    "Solar PV"
    "Tide&Wave"
    "Non-efficiency"

*   For mapping with GTAP

    "OtherBL"
    "SolarP"

* WEO 2018

    "Diesel"
    "Gasoline"
    "Other renewables"
    "Natural Gas"


/;

$OnText

    Assign WeoGood to aggregate categories

Memo: - "oil" is a generic term for CO2 emissions, demand...
         it is crude oil for ieaVar = {"net trade", "Supply", "Wholesale price"}

       - Other renewables include marine and geothermal energy
         --> Mostly for Power

Assumptions: Biofuel are produced by sector ROIL

"Bioenergy" --> only for "End-use prices"
"hydrogen"  --> only for "demand" for "transport" & "Other transformations"

$OffText

* Mapping checked for WEO 2018

SETS
    WEOROILi(WeoGood)       / "oil", "Gasoline", "Diesel", "Aviation" /
    WEOCOAi(WeoGood)        / "Coal" /
    WEONGASi(WeoGood)       / "gas", "Natural gas"/
    WEOELYi(WeoGood)        / "Electricity", "Heat",  "Other renewables" /
    WEOBIOMi(WeoGood)       / "Biomass", "Bioenergy"  /
    WEOHydrogeni(WeoGood)   / "Hydrogen" /
    WEOBiofuelsi(WeoGood)   / "Biodiesel", "Ethanol"  /
    ENONNRGi(WeoGood)       / "oil", "gas", "Coal" /
;

set power_type(WeoGood)   "Type energie primaire entrant dans production electricite pour projection WEO" /
    Coal
    Oil
    Gas
    Biomass_Waste
    Nuclear
    Hydro
    Wind
    Geothermal
    Solar_PV
    Concentrated_Solar_Power
    Tide_and_Wave
    Other

*---    Alternative Names (WEO 2017 and after)

    "Bioenergy"
    "Biomass"
    "Other renewables"
    "Natural Gas"
    "Geo"
    "Solar PV"
    "Solar CSP"
    "Tide&Wave"
    "Renewables"
    "Total"

*---    For mapping with GTAP

    "OtherBL"
    "SolarP"
/;

SET ieaSubSect /
    "Total"
    "<empty>"
    ""

    TPED
    TFC
    AGR

    "Agriculture"
    "Industry"
    "Residential"
    "Services"

    "Chemicals"
    "Iron_Steel"
    "Non-metallic_Minerals"
    "Pulp_Paper"
    "Aluminium"
    "Other_Industry"
    "Non_En_Use_of_which_Feedstock"
    "Non_energy_Use"
    "NEU"
    "Cement"
    "Steel"
    "Paper"

    Other_Energy_Sector
*    OtherEnSect_of_which_Coal_BlastFurnacesOvens
*    OtherEnSect_of_which_Coal_own_use
*    OtherEnSect_of_which_Elec_OilGasExtraction
*    OtherEnSect_of_which_Gas_OilGasExtraction
*    OtherEnSect_of_which_Total_OilGasExtraction
*    OtherEnSect_of_which_Elec_OwnUseRefineries
*    OtherEnSect_of_which_Gas_OwnUseRefineries
*    OtherEnSect_of_which_Heat_OwnUseRefineries
*    OtherEnSect_of_which_Oil_OwnUseRefineries
*    OtherEnSect_of_which_Total_OwnUseRefineries

    Power_Generation
    RES
    SER

    "Power&Heat"    "For WEM Co2 emissions"

    "Transport"
    "Rail"
    "Road"
    "Road - PLDV"
    "Domestic_Aviation"
    "Navigation"
    "Non_specified_Transport"
    "Pipeline"
    "Road_of_which_PLDV"
    "Transportation"
    "OTHERTR"
    "Road_of_which_LCV"
    "Road_of_which_OtherRoad"

    "Downstream"
    "Infrastructure"
    "Losses"
    "Mining"
    "Upstream"
    "Refining"
    "Non-specified"
    "Refineries"
    "Non road"

    "Plants"
    "Domestic Aviation"

    "BF&CO"
    "Oil&Gas Extraction"
    "Petchem. Feedstocks"

    "Power"
    "oil"
    "gas"
    "NUCLEAR"
    "HYDRO"
    "WIND"
    "HEAT"
    "Coal"
    "GEO"
    "Electricity"
    "Biomass"
    "Other renewables"
    "Solar PV"
    "Solar CSP"
    "Tide&Wave"
    "Biomass_Waste"
    "Geothermal"
    "Solar_PV"
    "Concentrated_Solar_Power"
    "Tide_and_Wave"
    "Other"
    "Bioenergy"
    "Natural gas"
    "Renewables"

    "Ethylene"
    "Propylene"
    "Aromatics"
    "Ammonia"
    "Methanol"
    "Paper and paperboard"

* For recycling

    HDPE        "High density polyethylene"
    PET         "Polyethylene terephtalate"
    PS          "Polystyrene"
    ABS         "Acrylonitrile butadiene styrene"
    PVC         "Polyvinylchloride"
    PC          "Polycarbonate"
    PP          "Polypropylene"
    LDPE        "Low density polyethylene"
    LLDPE       "Liner low-density polyethylene"
    Fuel        "Fuel input"

    "Other transformations"
    "Supply-side"
    "Biofuels"
    "Industry (incl. BF&CO and Petchem. Feedstocks)"
    "Non-energy uses"
    "TPED (incl. Process)"
    "Process"
    "Industry (incl. BF&CO)"
    "Demand-side"
    "Buildings"

* Add to simplify
    "BF&CO and Petchem. Feedstocks"
    "International bunkers"
    "Inputs to power and heat sector"
    "Road Non-PLDV"
    "Non-Feedstocks"


*---    Add for Carbon Price categories
    PG
    OES
    IRON
    CHEM
    NMM
    OTHIND
    AVIATION
/;

SET CT_categories(ieaSubSect) /
    PG
    OES
    IRON
    CHEM
    NMM
    PAPER
    ALUMINIUM
    OTHIND
    AVIATION
    ROAD
    NAVIGATION
    RES
    SER
    RAIL
    PIPELINE
    OTHERTR
    AGR
    NEU
/;

SET CT_HIGH(ieaSubSect)  /
    PG
    OES
    AVIATION
    / ;

SET CT_LOW(ieaSubSect)  /
    IRON
    CHEM
    NMM
    PAPER
    ALUMINIUM
    OTHIND
    / ;

SET End_Use_Sect(ieaSubSect) "End-use sectors" /
    "<empty>"
    ""
    "Industry"
    "Services"
    "Agriculture"
    "Transportation"
    "Non_energy_Use"
    "Other_Energy_Sector"
    "Power_Generation"
    "Residential"
    "TFC"
    "TPED"
/;

set ieaUnits /
    "Mtoe"
    "TWh"
    "GW"
    "PJ"
    "Mb/d"
    "bcm"
    "Million"
    "MtCO2"
    "Million square metres"
    "Billion vkm"
    "Billion tkm"
    "Dmnl"
    "$%weoUSD%, per barrel"
    "$%weoUSD%, per MWh"
    "$%weoUSD%, per tCO2"
    "$%weoUSD%, per metric tonne"
    "$%weoUSD%, per toe"
    "$%weoUSD% million"
    "$%weoUSD% billion, MER"
    "$%weoUSD% billion, PPP"
    "$%weoUSD%, PPP"
    $$IfThenI.dif_unit NOT %weoUSD%==%weoUSD%
        "$%weoUSD% million"
        "$%weoUSD% billion, MER"
        "$%weoUSD% billion, PPP"
        "$%weoUSD%, PPP"
    $$ENDIF.dif_unit
    "mtce"
    "Mt"

    "share" "Between 0 and 1"
/ ;

set iea_comments /
    "<empty>"
    ""
    "Incl. International bunkers"
    "Includes power sector investments"
    "Investments for New Plant/Refurb."
    "Investments for Transmission & Distribution"
    "Inputs to power and heat sector"
    "Includes electric vehicles"
    'MEMO: "BF&CO and Petchem. Feedstocks" are otherwise in OES and'
    'MEMO: "BF&CO" are otherwise in OES'
    "Renewables support in power sector"
    "Hard coal"
/;

set map_iea_sector(ieaSubSect,End_Use_Sect) /
    Agriculture.Agriculture

    Chemicals.Industry
    Industry.Industry
    Iron_Steel.Industry
    Non-metallic_Minerals.Industry
    Other_Industry.Industry
    Pulp_Paper.Industry

    Non_En_Use_of_which_Feedstock.Non_energy_Use
    Non_energy_Use.Non_energy_Use

    Other_Energy_Sector                         .Other_Energy_Sector
*    OtherEnSect_of_which_Coal_BlastFurnacesOvens.Other_Energy_Sector
*    OtherEnSect_of_which_Coal_own_use          .Other_Energy_Sector
*    OtherEnSect_of_which_Elec_OilGasExtraction .Other_Energy_Sector
*    OtherEnSect_of_which_Elec_OwnUseRefineries .Other_Energy_Sector
*    OtherEnSect_of_which_Gas_OilGasExtraction  .Other_Energy_Sector
*    OtherEnSect_of_which_Gas_OwnUseRefineries.Other_Energy_Sector
*    OtherEnSect_of_which_Heat_OwnUseRefineries.Other_Energy_Sector
*    OtherEnSect_of_which_Oil_OwnUseRefineries.Other_Energy_Sector
*    OtherEnSect_of_which_Total_OilGasExtraction.Other_Energy_Sector
*    OtherEnSect_of_which_Total_OwnUseRefineries.Other_Energy_Sector

    Power_Generation.Power_Generation

    Residential.Residential
    Services.Services
    Domestic_Aviation.Transportation
    Navigation.Transportation
    Non_specified_Transport.Transportation
    Pipeline.Transportation
    Rail.Transportation
    Road.Transportation
    Road_of_which_PLDV.Transportation
    Transportation.Transportation

    TFC.TFC
    TPED.TPED
* For Invesment
    Road_of_which_LCV.Transportation
    Road_of_which_OtherRoad.Transportation

/;


*EXECUTE_UNLOAD "old";
