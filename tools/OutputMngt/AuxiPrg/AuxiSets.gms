$OnText
--------------------------------------------------------------------------------
                    [OECD-ENV] Model V.1. - Reporting procedure
   Name of the File: "%AuxPrgDir%\AuxiSets.gms"
   purpose         : Set definition for auxilliary output variables
   created date    : 2021-03-18 (from ENV-Linkages auxilliary_variables.gms)
   created by      : Jean Chateau
   called by       : "%OutMngtDir\OutAuxi.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/AuxiPrg/AuxiSets.gms $
   last changed revision: $Rev: 326 $
   last changed date    : $Date:: 2023-06-12 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

alias(ra,origin);
alias(ra,destination);
alias(agents,*);     !! fd and a
alias(commodities,*);
alias(regions,*);    !! ra and a
alias(items,*);
alias(skills,l);

SETS

    ia_noi(ia) "Aggregate commodities for model output" /
        tagr-c      "Agriculture"
        tman-c      "Manufacturing"
        tsrv-c      "Services"
        toth-c      "Other industries"
        ttot-c      "Total"
    /

    $$IfTheni.NotCompStat NOT %SimType%=="CompStat"
***HRR: took away 2015
        $$Ifi %YearEndofSim%=="2060" ReportYr(t) / %YearStart%, 2020, 2025, 2030, 2040, 2050, 2060 /
        $$Ifi %YearEndofSim%=="2050" ReportYr(t) / %YearStart%, 2020, 2025, 2030, 2040, 2050 /
        $$Ifi %YearEndofSim%=="2040" ReportYr(t) / %YearStart%, 2020, 2025, 2030, 2040 /
        $$Ifi %YearEndofSim%=="2035" ReportYr(t) / %YearStart%, 2020, 2025, 2030, 2035 /
        $$Ifi %YearEndofSim%=="2030" ReportYr(t) / %YearStart%, 2020, 2025, 2030 /
        $$Ifi %YearEndofSim%=="2020" ReportYr(t) / %YearStart%, 2020 /
        $$Ife %YearEndofSim%<2020    ReportYr(t) / %YearStart%*%YearEndofSim% /

    $$Endif.NotCompStat


    ratioslist "list of remarkable ratios (aggregate variables)" /
        "Energy to capital"
        "Energy intensity"
        "Labour share in value added"
* Official OECD : Labour productivity is defined as real gross domestic product (GDP) per hour worked.
        "Labour productivity"
        "Unemployment rate"   !! UNR
        "Employment rate"
        "Saving rate"
        "Trade Balance to GDP"
        "Trade openness"
        "Net Investment to VA"
        "Gross Investment to VA"

        $$IFi %SimType%=="Baseline" "IMPACT_yields" "IMPACT_yields (metric tonnes per hectare)"
    /

    labourlist "list of labour market variables" /
        "Employment"	"millions of person / millions of USD"
        "Efficient Labor"
        "Gross wage"
        "Labour productivity"
        "Job creations"
        "Job destructions"
        "Total job reallocation"
        "Net employment growth"
        "Gross wage (w / pp)","real"
        "net-of-tax wage rate"
        "net-of-tax wage income"
    /

    CapitalList "list of capital market variables" /
        "Capital to labour"
        "Efficient Capital"
        "Capital to Efficient labour"
        "Capital to output"
        "Capital to value added"
        "Capital stock"
        "Gross Investment"
        "Net Investment"
    /

    Pricelist "list of main price variables (%aux_PriceIndex%)" /
        "CPI"                " Consumer Price Index (%aux_PriceIndex%) "
        "API"                " Absorbtion Price Index (%aux_PriceIndex%)"
        "World (CIF)"        " International Prices of goods as weighted average of Imports CIF prices "
        "Producer"           " Producer price (e.g. pp tax inclusive) (%aux_PriceIndex%)"
        "Armington (market)" " Price of Armington good at market price "
        "Armington (agents)" " Price of Armington good at agents' price "
        "Supply"             " Market Prices of domestically produced good 'i' (%aux_PriceIndex%)"
        "Consumer"           " Agents' Prices (%aux_PriceIndex%)"

        "PPP (Laspeyres)"
        "PPP (Paashe)"
        "PPP (Paashe - US weights)"
    /

    aglist "list of main agriculture variables" /
        "Area harvested"    "vol: (1000 ha)"
        "Land yields"       "vol: metric tonnes per hectare"
        "Gross output"      "vol: (000 mt)"
     /

    outmatlist "list of main economic variables for materials" /
        secondary_share "Share of secondary metals"
        miningShare     "Share of other mining (OMN) in cost structure"
    /

    sdgTargets "List of SDG targets - https://sustainabledevelopment.un.org/" /

    !! SDG1  End poverty in all its forms everywhere
        "1.1"   "By 2030, eradicate extreme poverty for all people everywhere, currently measured as people living on less than $1.25 a day"
        "1.2"   "By 2030, reduce at least by half the proportion of men, women and children of all ages living in poverty in all its dimensions according to national definitions"
    !! SDG2  End hunger, achieve food security and improved nutrition and promote sustainable agriculture
        "2.3"   "By 2030, double the agricultural productivity and incomes of small-scale food producers" !! in particular women, indigenous peoples, family farmers, pastoralists and fishers, incl. through secure and equal access to land, other productive resources and inputs, knowledge, financial services, markets and opportunities for value addition and non-farm employment"
    !! SDG3  Ensure healthy lives and promote well-being for all at all ages
        "3.9" "By 2030, substantially reduce the number of deaths and illnesses from hazardous chemicals and air, water and soil pollution and contamination"
    !! SDG7  Ensure access to affordable, reliable, sustainable and modern energy for all
        "7.2"   "By 2030, increase substantially the share of renewable energy in the global energy mix"
        "7.3"   "By 2030, double the global rate of improvement in energy efficiency"
    !! SDG8  Promote sustained, inclusive and sustainable economic growth, full and productive employment and decent work for all
        "8.1"   "Sustain per capita economic growth in accordance with national circumstances and, in particular, at least 7 per cent gross domestic product growth per annum in the least developed countries"
        "8.2" "Achieve higher levels of economic productivity through diversification, technological upgrading and innovation, incl. through a focus on high-value added and labour-intensive sectors"
        "8.4" "Improve global resource efficiency in consumption and production and endeavour to decouple economic growth from environmental degradation" !! in accordance with the 10-year framework of programmes on sustainable consumption and production, with developed countries taking the lead
    !! SDG9  Build resilient infrastructure, promote inclusive and sustainable industrialization and foster innovation
        "9.4"   "By 2030, upgrade infrastructure and retrofit industries to make them sustainable, with increased resource-use efficiency and greater adoption of clean and environmentally sound technologies and industrial processes" !! with all countries taking action in accordance with their respective capabilities
    !! SDG10 Reduce inequality within and among countries
        "10.1" "By 2030, progressively achieve and sustain income growth of the bottom 40 per cent of the population at a rate higher than the national average"
        "10.4" "Adopt policies, especially fiscal, wage and social protection policies, and progressively achieve greater equality"
    !! SDG11 Make cities and human settlements inclusive, safe, resilient and sustainable
        "11.3" "By 2030, enhance inclusive and sustainable urbanization and capacity for participatory, integrated and sustainable human settlement planning and management in all countries"
    !! SDG12 Ensure sustainable consumption and production patterns
        "12.2"  "By 2030, achieve the sustainable management and efficient use of natural resources"
    !! SDG13 Take urgent action to combat climate change and its impacts
    !! SDG17 Strengthen the means of implementation and revitalize the global partnership for sustainable development
        "17.1" "Strengthen domestic resource mobilization, incl. through international support to developing countries, to improve domestic capacity for tax and other revenue collection"
        "17.11" "Significantly increase the exports of developing countries, in particular with a view to doubling the least developed countries� share of global exports by 2020"
    /

    sdgIndicators "list of SDG indicators" /
    !! when third number is a letter, it is our own indicator, not SDG official one, eg 2.3.A
    !! when 4th number, it is a sub-indicator
    "1.1.A Real GDP per capita"
    "2.3.A Agricultural productivity"
    "3.9.1 Mortality rate attributed to household & air pollution"
    "3.9.1.1 Mortality rate attributed to outdoor air pollution"
    "7.2.1 Renewable energy share in the final energy consumption"
    "7.2.1.a Renewable energy share in electricity"
    "7.3.1 Energy intensity (primary energy / GDP)"
    "8.1.1 Annual growth rate of real GDP per capita"
    "8.2.1 Annual growth rate of real GDP per employed person"
    !! "8.4.1 Material footprint, material footprint per capita, and material footprint per GDP"
    "8.4.1.a Material footprint"
    "8.4.1.b Material footprint per capita"
    "8.4.1.c Material footprint per GDP"
    !! "8.4.2 Domestic material consumption, domestic material consumption per capita, and domestic material consumption per GDP"
    "8.4.2.a Domestic material consumption"
    "8.4.2.b Domestic material consumption per capita"
    "8.4.2.c Domestic material consumption per GDP"
    "9.4.1 CO2 emission per unit of value added"
    "10.4.1 Labour share of GDP (wages and social protection)" "comprising wages and social protection transfers"
    !! "10.1.1 Growth rates of household expenditure or income per capita among the bottom 40 per cent of the population and the total population"
    "10.1.1.1 GR of household expenditure among the total population"
    "10.1.1.2 GR of household expenditure among the bottom 40%"
    "10.1.1.3 GR of income per capita among the total population"
    "10.1.1.4 GR of income per capita among the bottom 40%"
    "11.3.1 Ratio of land consumption rate to population growth rate"
    "12.2.1.a Material footprint"
    "12.2.1.b Material footprint per capita"
    "12.2.1.c Material footprint per GDP"
    "12.2.2.a Domestic material consumption"
    "12.2.2.b Domestic material consumption per capita"
    "12.2.2.c Domestic material consumption per GDP"
    "17.1.1 Total government revenue as a proportion of GDP"
    !! , by source
    "17.1.1.1 Government revenue over GDP, source: XXX"
    "17.11.1 Developing countries share of global exports" !! Developing & least developed countries
    /

    envlist "list of main environment and energy variables" /
        "Carbon Tax"    "%YearBaseMER% USD, per tCO2"

        "Emission from fossil fuel combustion"
        "Emission from activity"
        "Emission all sources"          !! Here (excl. CO2 LULUCF)
        "Emission from coal combustion"
        "Emission from oil combustion"
        "Emission from gas combustion"
        "Emission from biomass combustion"
        "Emission all sources (incl. CO2 LULUCF)"
        "Emission LULUCF"

        "Air pollutants from fossil fuel combustion"
        "Air pollutants from activity"
        "Air pollutants all sources"
        "Air pollutants from coal combustion"
        "Air pollutants from oil combustion"
        "Air pollutants from gas combustion"
        "Air pollutants from biomass combustion"

* IPCC sources

        "Emission from enteric fermentation (4A)"
        "Emission from manure management (4B)"
        "Emission from rice cultivation (4C)"
        "Emission from nitrification (4D1)"
        "Fuel Combustion from Electricity and Heat Production (1A1a)"
        "Fuel Combustion from Other Energy Industries (1A1bc)"
        "Fugitive emissions from fossil fuel (1B)"
        "Nonmetallic minerals production (2A)"
        "Emission from other crops practice"

        $$IF %aux_outType%=="FULL" "Emission intensity: all sources"

        "Material use"              "Direct material use (does not include indirect flows)"
        "Material intensity"        "Direct material use over GDP"
        "Material per capita"       "Direct material use over Population"
        "Material extraction tax"   "%YearBaseMER% USD, per t"
        "Material extraction tax (average on material use)" "%YearBaseMER% USD, per t"
        "Share of secondary production"                     "Share of secondary production (in economic terms)"

* Energy

        "Electricity Generation"
        "Electricity Price" "%YearBaseMER% USD per TWh"
        "Renewable Electricity share"

* TPED/TPES

        "Energy Demand: Total"
        "Energy Demand: Coal"
        "Energy Demand: Oil"
        "Energy Demand: Gas"
        "Energy Demand: Electricity"

        "TPED: Total"
        "TPED: Coal"
        "TPED: Oil"
        "TPED: Gas"
        "TPED: Hydro"
        "TPED: Nuclear"
        "TPED: Bioenergy"
        "TPED: Other renewables"

        "TPED (calc TFC): Total"
        "TPED (calc TFC): Coal"
        "TPED (calc TFC): Oil"
        "TPED (calc TFC): Gas"
        "TPED (calc TFC): Hydro"
        "TPED (calc TFC): Nuclear"
        "TPED (calc TFC): Bioenergy"
        "TPED (calc TFC): Other renewables"

        "Energy intensity: Total"
        "Energy intensity: Fossil"

        $$IfThenI.OutFull %aux_outType%=="FULL"
            "Energy intensity: Coal"
            "Energy intensity: Oil"
            "Energy intensity: Gas"
            "Energy intensity: Electricity"
        $$ENDIF.OutFull

        "Primary energy"
        "Secondary energy"
        "Final energy"

    /

    $$IfThen.Outenergy %aux_Energy_Output%=="ON"
        nrglist(envlist) "list of main energy variables" /
            "Electricity Generation"
            "Electricity Price" "%YearBaseMER% USD per TWh"
            "Renewable Electricity share"

            "Energy Demand: Total"
            "Energy Demand: Coal"
            "Energy Demand: Oil"
            "Energy Demand: Gas"
            "Energy Demand: Electricity"

            "Energy intensity: Total"
            "Energy intensity: Fossil"

            $$IfThenI.OutFull %aux_outType%=="FULL"
                "Energy intensity: Coal"
                "Energy intensity: Oil"
                "Energy intensity: Gas"
                "Energy intensity: Electricity"
            $$ENDIF.OutFull

            "Primary energy"
            "Secondary energy"
            "Final energy"
        /

        nrgtype "list of energy carriers" /
            electricity
            coal
        /

        nrgitem "list of energy items for reporting" /
            supply
            demand
        /


    $$ENDIF.Outenergy

    ghglist(envlist) "Main Sources of Emissions (excl. CO2 LULUCF)" /
        "Emission from fossil fuel combustion"
        "Emission from activity"
        "Emission all sources"
    /

    oaplist(envlist) "Main Sources of Air Pollutant Emissions" /
        "Air pollutants from fossil fuel combustion"
        "Air pollutants from activity"
        "Air pollutants all sources"
    /

    ghgsource(envlist) "Detailled Sources of Emissions (excl. CO2 LULUCF)" /
        "Emission from fossil fuel combustion"
        "Emission from activity"
        "Emission all sources"
        "Emission from coal combustion"
        "Emission from oil combustion"
        "Emission from gas combustion"
        "Emission from biomass combustion"

        $$IF %aux_outType%=="FULL" "Emission intensity: all sources" "Kilograms of CO2eq per unit of output (Kilograms per thousand %YearBaseMER% USD)"

* IPCC sources

        "Emission from enteric fermentation (4A)"
        "Emission from manure management (4B)"
        "Emission from rice cultivation (4C)"
        "Emission from nitrification (4D1)"
        "Fuel Combustion from Electricity and Heat Production (1A1a)"
        "Fuel Combustion from Other Energy Industries (1A1bc)"
        "Fugitive emissions from fossil fuel (1B)"
        "Nonmetallic minerals production (2A)"

        "Emission from other crops practice"
    /

    oapsource(envlist) "Detailled Sources of Air Pollutants Emissions" /
        "Air pollutants from fossil fuel combustion"
        "Air pollutants from activity"
        "Air pollutants all sources"
        "Air pollutants from coal combustion"
        "Air pollutants from oil combustion"
        "Air pollutants from gas combustion"
        "Air pollutants from biomass combustion"
    /

    envunits "list of main envlist variables" /
        "CO2 (Mt CO2eq)" "millions de tons of CO2 Equivalent"
        "CH4 (Mt CO2eq)"
        "N2O (Mt CO2eq)"
        "HFC (Mt CO2eq)"
        "PFC (Mt CO2eq)"
        "SF6 (Mt CO2eq)"

* Aggregate cat

        "FGas (Mt CO2eq)"
        "GHG (Mt CO2eq)"

        "Mt"
        "CO2 per capita (Mt CO2eq)"
        "GHG per capita (Mt CO2eq)"
        "Mtoe"
        "(metric tons per capita)"
        "(kg per %YearBasePPP% PPP of GDP)"
        "(kg per %YearBaseMER% USD of GDP)"
*        "(1000 ha)"
        "TWh"
        "(%YearBaseMER% USD, per tCO2)"
        "BC (1000 t)"       "Black carbon"
        "CO (1000 t)"       "Carbon monoxide"
        "NH3 (1000 t)"      "Ammonia"
        "NOX (1000 t)"      "Nitrogen Oxide"
        "OC (1000 t)"       "Organic Carbon"
        "SO2 (1000 t)"      "Sulfur dioxide"
        "PM25 (1000 t)"     "Fine particulate matter"
        "PM10 (1000 t)"     "Ultrafine particulate matter"
        "NMVOC (1000 t)"    "Non-methane volatile organic compounds"
*        "SOX (1000 t)"      "Sulfur oxide"
        /

    $$IfThen.materials %module_materials%=="ON"
        matunits "list of main matlist variables" /
            "All materials (Gt)" "All materials - metric tonnes"
            "Biomass (Gt)" "All materials - metric tonnes"
            "Fossil fuels (Gt)" "All materials - metric tonnes"
            "Metals (Gt)" "All materials - metric tonnes"
            "Minerals (Gt)" "All materials - metric tonnes"
            "(%YearBaseMER% USD, per t)"
            "Iron & Steel"
            "Aluminium"
        $$ifThenI.SplitGtap_technos NOT %ifSplitGtap_technos%==ON
            "precious metal"
            "lead, zinc, tin"
        $$endif.SplitGtap_technos
            "Copper"
            "Other non-ferrous metals"
        /

        matlist(envlist) "Materials variables" /
            "Material use" "Direct material use (does not include indirect flows)"
            "Material intensity" "Direct material use over GDP"
            "Material per capita" "Direct material use over Population"
            "Material extraction tax" "%YearBaseMER% USD, per t"
            "Material extraction tax (average on material use)" "%YearBaseMER% USD, per t"
            "Share of secondary production"
        /

        testList "Test variables" /
            "Volume of bilateral trade"
            "Value of bilateral trade"
        /
    $$ENDIF.materials

    ghgunits(envunits)  /
        "CO2 (Mt CO2eq)" "millions de tons of CO2 Equivalent"
        "CH4 (Mt CO2eq)"
        "N2O (Mt CO2eq)"
        "HFC (Mt CO2eq)"
        "PFC (Mt CO2eq)"
        "SF6 (Mt CO2eq)"

* Aggregate cat

        "FGas (Mt CO2eq)"
        "GHG (Mt CO2eq)"
    /

    allghgs(ghgunits) / "GHG (Mt CO2eq)"  /

    oapunits(envunits) "Air Pollutant (thousands of tonnes)" /
        "BC (1000 t)"       "Black carbon"
        "CO (1000 t)"       "Carbon monoxide"
        "NH3 (1000 t)"      "Ammonia"
        "NOX (1000 t)"      "Nitrogen Oxide"
        "OC (1000 t)"       "Organic Carbon"
        "SO2 (1000 t)"      "Sulfur dioxide"
        "PM25 (1000 t)"     "Fine particulate matter"
        "PM10 (1000 t)"     "Ultrafine particulate matter"
        "NMVOC (1000 t)"    "Non-methane volatile organic compounds"
*        "SOX (1000 t)"      "Sulfur oxide"
    /

    map_emi(em,ghgunits) /
        CO2."CO2 (Mt CO2eq)" "Carbon emissions"
        N2O."N2O (Mt CO2eq)" "N2O emissions"
        CH4."CH4 (Mt CO2eq)" "Methane emissions"
        HFC."HFC (Mt CO2eq)" "Hydrofluorocarbons emissions"
        PFC."PFC (Mt CO2eq)" "Perfluorinated compound emissions"
        SF6."SF6 (Mt CO2eq)" "Sulfur hexafluoride emissions"

* All GHGs

        (CO2,N2O,CH4,HFC,PFC,SF6)."GHG (Mt CO2eq)"

* "Emissions of fluoridated gases"

        (HFC,PFC,SF6)."FGas (Mt CO2eq)"
     /

    map_oap(oap,oapunits) /
        BC   . "BC (1000 t)"      "Black carbon"
        CO   . "CO (1000 t)"      "Carbon monoxide"
        NH3  . "NH3 (1000 t)"     "Ammonia"
        NOX  . "NOX (1000 t)"     "Nitrogen Oxide"
        OC   . "OC (1000 t)"      "Organic Carbon"
        SO2  . "SO2 (1000 t)"     "Sulfur dioxide"
        PM25 . "PM25 (1000 t)"    "Fine particulate matter"
        PM10 . "PM10 (1000 t)"    "Ultrafine particulate matter"
        NMVOC. "NMVOC (1000 t)"   "Non-methane volatile organic compounds"
*        SOX     . "SOX (1000 t)"
*        NMVB . "NMVOC (1000 t)"
*        NMVF . "NMVOC (1000 t)"
     /

$IfThen.trade %aux_trade_output%=="ON"
    tradelist "Trade Related variables" /
        "Trade Structure: export"
        "Trade Structure: import"
        "Trade balance (accounting)"
        "Trade balance (FOB)"
        "Domestic demand to output"
        "Domestic demand to total demand"
        "Market Shares: export"
        "Market Shares: import"
        "Trade Flows (FOB)"      "(millions of USD)"
        "Gross exports (FOB)"
        "Gross imports (CIF)"
        "RCA"       "Revealed Comparative Advantage"
        "RCA main"  "Revealed Comparative Advantage (only regions more than 1% of world export)"
    /
$ENDIF.trade

$IfThen.gacc %aux_growth_accounting%=="ON"
    growth_accounting /
        "Factor Shares"
        "Factor Efficiency"
        "Factor Growth"         "GROWTH ACCOUNTING : PF units growth"
        "Factor Reallocation"
        "VA Growth nominal"
        "VA Growth real"
    /
$ENDIF.gacc

$IfThen.expcomp %aux_expenses_composition%=="ON"
    expenses_type /
        "Final Demand"
        "Intermediate Demand"
        "Total Demand"
*"Household Budget share" "Eg savings as expenses"
*   Rappel BP or AP same for firm point of view
        "Value Added"   "At Basic Prices"
        "Gross Output"  "At Basic Prices"
        /

    fd_expenses(expenses_type)  / "Final Demand"        /
    id_expenses(expenses_type)  / "Intermediate Demand" /
    tot_expenses(expenses_type) / "Total Demand"        /

    not_expenses(expenses_type) /
        "Value Added"   "At Basic Prices"
        "Gross Output"  "At Basic Prices"    /

$ENDIF.expcomp

;

$IFi %SimType%=="CompStat" alias(t,ReportYr) ;

