$OnText
--------------------------------------------------------------------------------
             OECD-ENV project V.1. - Aggregation procedure
    GAMS file   : "%SetsDir%\setEmissions.gms"
    purpose     : Definition of Emissions sets: GTAP, IEA: Sets of gases (GHGs or OAP)
    Created by  : Jean Chateau
    created Date: 2020-10-27
    called by   : "%DataDir%\AggGTAP.gms"
                  "%DataDir%\filter.gms"
                  "%SatDataDir%\Build_Scenario.gms"
                  "Energy\Export_IEA-WEO_to_GTAP\1-preamble.gms"
				  "%SatDataDir%\preamble.gms"
                  "%ModelDir%\22-Additional_Sets.gms"
--------------------------------------------------------------------------------
   file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
   last changed revision: $Rev: 480 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    [2020-11-20]:
    New sets for NCO2 and AirPol emissions of GTAP10: IPCC_REP, LU_CAT, LU_SUBCAT
--------------------------------------------------------------------------------
$OffText

SETS

*------------------------------------------------------------------------------*
*                       EMISSIONS BY GAS                                       *
*------------------------------------------------------------------------------*

    AllEmissions "Pollutant Emissions: GHGs and Air pollutants" /

*   Greenhouse gases

        CH4         "Methane"
        CO2         "Carbon Dioxide"
        N2O         "Nitrous oxide"
        HFC         "Hydrofluorocarbons"
        PFC         "Perfluorinated compound"
        SF6         "Sulfur hexafluoride"

*   Total

        GHG         "All Greenhouse gases"
        FGAS        "Emissions of fluoridated gases (High Global-Warming Potential)"

*   Other Categories

        NF3         "Nitrogen trifluoride"
        SO2F2       "Sulfuryl Fluoride"
        $$IF SET ifAirPol HFC_PFC     "Unspecified mix of HFCs and PFCs"

*   Air pollutants

        BC          "Black carbon"
        CO          "Carbon monoxide"
        NH3         "Ammonia"
        NOX         "Nitrogen Oxide"
        NO2         "Nitrogen Dioxide"
        OC          "Organic Carbon"
        $$IF SET ifAirPol  PM "Particulate Matter"
        SO2         "Sulfur dioxide"
        SOX         "Sulfur oxide" !! SOX = SO2 or SO3...

*   Volatile organic compounds (VOC) are categorized as either methane (CH4) or non-methane (NMVOCs).

        VOC         "Volatile Organic Compounds"

        PM10        "Ultrafine particulate matter"
        NMVB        "non-methane volatile organic compounds (short cycle carbon)"
        NMVF        "non-methane volatile organic compounds (long cycle carbon)"
        PM25        "Fine particulate matter"

*   alternative names for various database #todo replace PM2_5 with PM25

		"PM2_5"

*   For IIASA-GAINS activity

        $$IF SET ifAirPol     "AIR"
        $$IF SET ASGENData    "AIR"
        $$IF SET ifDamagesOAP "O3" "Ozone"
        $$IF SET ifDamagesOAP "None"

*   Miscellaneous (i.e. benzene, toluene, xylen, ethanol,...)

        NMVOC       "Non-methane volatile organic compounds"

*	Detailled sets

* Perfluorocarbons (PFCs):
        $$include "%SetsDir%\SetPFCs.gms"
* Hydrofluorocarbons (HFCs):
        $$include "%SetsDir%\SetHFCs.gms"

/

    $$OnText
        OECD AIR_EMISSIONS = {CO, NMVOC, NOX, PM10, PM25, SOX}
        Units --> Tonnes, Thousands

        GTAP :  BC, CO, NH3, NMVB, NOX, OC, PM2_5, SO2, PM10,
        GAINS : BC, CO, NH3, VOC,  NOX, OC, PM25,  SO2, NMVF,
                N2O, CH4, CO2
        EDGAR : BC, CO, NH3, NMVOC, NOX, OC, PM25, SO2, PM10,
                N2O, CH4, CO2, SF6, NF3, HFC, PFC
    $$OffText


    em(AllEmissions)  "Greenhouse gas emissions (CO2-equivalent) (Mt Co2Eq.)" /
        CH4         "Methane"
        CO2         "Carbon Dioxide"
        N2O         "Nitrous oxide"				!! dioxyde d'azote
        HFC         "Hydrofluorocarbons"
        PFC         "Perfluorinated compound"
        SF6         "Sulfur hexafluoride"

* Aggregate categories

        GHG         "All Greenhouse gases"
        FGAS        "Emissions of fluoridated gases (High Global-Warming Potential)"
    /

    AllGHG(em) "All Greenhouse gases" / GHG "All Greenhouse gases"/

    OAP(AllEmissions)  "Local Outdoor air pollutants emissions (tons)" /
        BC          "Black carbon"
        CO          "Carbon monoxide" !! Monoxyde de carbone
        NH3         "Ammonia"
        NOX         "Nitrogen Oxide" !! Oxydes d'azote
        OC          "Organic Carbon"
        SO2         "Sulfur dioxide" !!  Dioxyde de soufre
        NMVOC       "Non-methane volatile organic compounds" !! Composes Organiques Volatils
        PM25        "Fine particulate matter"
        SOX         "Sulfur oxide"
        PM10        "Ultrafine particulate matter"
        NMVB
        NMVF
        $$IF SET ifDamagesOAP "O3" 	"Ozone"
        $$IF SET ifDamagesOAP "None"
        "PM2_5"
    /

    emn(em)  "Non-Co2 Greenhouse gas emissions" /
        CH4         "Methane"
        N2O         "Nitrous oxide"
        HFC         "Hydrofluorocarbons"
        PFC         "Perfluorinated compound"
        SF6         "Sulfur hexafluoride"
        FGAS        "Emissions of fluoridated gases (High Global-Warming Potential)"
    /

    HighGWP(em)  "Industrial gases emissions" /
        HFC         "Hydrofluorocarbons"
        PFC         "Perfluorinated compound"
        SF6         "Sulfur hexafluoride"

        FGAS        "Emissions of fluoridated gases (High Global-Warming Potential)"
    /

    CH4N2O(em)  "CH4 and N2O emissions" /
        CH4         "Methane"
        N2O         "Nitrous oxide"
    /

    Fgas(em) "Fluoridated gases emissions"  /
        FGAS  "Emissions of fluoridated gases (High Global-Warming Potential)"
    /

    CO2(em)  "Carbon Dioxide Emissions" / CO2 "Carbon Dioxide" /

*   [2020-11-20]: New sets for NCO2 emissions of GTAP10

    IPCC_REP "IPCC Assessment reports" /
		AR2	"IPPC AR2"
		AR4	"IPCC AR4"
		AR5	"IPCC AR5"
		AR6
		SAR	"AR2 for EDGAR"
    /

    LU_CAT "Land use category (GTAP)" /
        FrsLand
        CrpLand
        GrsLand
        BrnBiom
    /

    LU_SUBCAT "Land use sub-category (GTAP)" /
        FrsLand
        OrgSoil
        FrsConv
        TropFrs
        OthrFrs

* caduc for GTAP V11

        CrpSoil
        GrsSoil
    /

    EmSingle(em)  "GHGs emissions (CO2-equivalent) (Mt Co2Eq.): No Aggregate"

*------------------------------------------------------------------------------*
*                       EMISSIONS BY SOURCES                                   *
*------------------------------------------------------------------------------*

    EmiSource "GHGs & AIR Pollutant Emission sources"   /

        coalcomb    "Coal combustion"
        coilcomb    "Crude Oil combustion"
        roilcomb    "Refined Oil combustion"
        gascomb     "Natural Gas combustion"
        gdtcomb     "Natural Gas combustion"
        biofcomb    "Biofuels combustion"
        biomcomb    "Biomass and waste combustion"
        biogcomb    "Biogas combustion"
        hydcomb     "Hydrogen combustion"
        chemUse     "chemical  use / fertilizer (soil emissions)"
        Land        "Manure and other direct soil emissions"
        Capital     "Enteric fermentation"
        act         "Activity Processes emissions"
        fugitive    "Fugitive emissions"

        lulucf      "Land use, land-use change and forestry (CO2 LULUCF)"
        AgrBurn     "Agricultural waste burning, forest fires, Savannah burning"
        wastesld    "Solid waste"
        wastewtr    "Waste water"
        wasteinc    "Waste incineration"
        NonAllocated "Sources not allocated for EDGAR or TRANDIFF for IPCC2006"

*   Irrelevant sources

*        NatRes
*        Labour

*   Aggregate categories

        allfcomb      "All fossil fuel combustion"
        allacomb      "All fossil fuel and biomass combustion"
        allsource     "All sources of emissions (excluding bunkers & lulucf)"
        allsourceinc  "All sources of emissions (including lulucf)"
    /

    EmiUse(EmiSource) "GHG emissions from Input-use" /
        coalcomb  "Coal combustion"
        coilcomb  "Crude Oil combustion"
        roilcomb  "Refined Oil combustion"
        gascomb   "Natural Gas combustion"
        gdtcomb   "Natural Gas combustion"
        biofcomb  "Biofuels combustion"
        biomcomb  "Biomass and waste combustion"
        biogcomb  "Biogas combustion"
        hydcomb   "Hydrogen combustion"
        chemUse   "chemical/fertilizer use"
    /

    EmiComb(EmiSource) "Emissions from fossil fuel and biomass combustion" /
        coalcomb  "Coal combustion"
        coilcomb  "Crude Oil combustion"
        roilcomb  "Refined Oil combustion"
        gascomb   "Natural Gas combustion"
        gdtcomb   "Natural Gas combustion"
        biofcomb  "Biofuels combustion"
        biomcomb  "Biomass and waste combustion"
        biogcomb  "Biogas combustion"
        hydcomb   "Hydrogen combustion"
    /

    EmiFosComb(EmiSource) "GHG emissions from fossil fuel combustion" /
        coalcomb  "Coal combustion"
        coilcomb  "Crude Oil combustion"
        roilcomb  "Refined Oil combustion"
        gascomb   "Natural Gas combustion"
        gdtcomb   "Natural Gas combustion"
    /

    EmiBioComb(EmiSource) "GHG emissions from biofuel, biomass and waste (incineration) combustion"/
        biofcomb  "Biofuels combustion"
        biomcomb  "Biomass and waste combustion"
        biogcomb  "Biogas combustion"
    /

    EmiFp(EmiSource) "Emissions from primary factor uses "/
        Land      "Land use"
        Capital   "Livestock use"
*        NatRes
*        Labour
    /

* Memo: fertilizer use --> Soil nitrification

    chemUse(EmiSource) "Emissions from Chemical/Solvent/Fertilizer use" /
        chemUse "chemical/fertilizer use"
    /

    EmiWaste(EmiSource) "GHG emissions from waste management" /
        wastesld     "Solid waste"
        wastewtr     "Waste water"
        wasteinc     "Waste incineration"
    /

    EmiLulucf(EmiSource) "CO2 LULUCF (exogenous)" / lulucf /

    emiagg(EmiSource) "Aggregate categories" /
        allfcomb      "All fossil fuel combustion"
        allacomb      "All fossil fuel and biomass combustion"
        allsource     "All sources of emissions (excluding bunkers & lulucf)"
        allsourceinc  "All sources of emissions (including lulucf)"
    /
;

EmSingle(em) = CH4N2O(em) + CO2(em) + HighGWP(em);

alias(emn,NCO2) ;
alias(em,GHG)   ;

SETS
    mapnco2(nco2,nco2)

    nco2eq "NCO2 gases in GWP units" / n2o_co2eq, ch4_co2eq, fgas_co2eq /

    mapco2EQ(emn,nco2eq) /
        n2o . n2o_co2eq
        ch4 . ch4_co2eq
        fgas. fgas_co2eq
    /

    emq "Emission quantities" /
        gt            "Gigatons"
        ceq           "Carbon equivalent"
        co2eq         "CO2 equivalent"
    /

*   Sets for Climate Watch data / NDC targets

    Tgt "GHG Coverage of NDC Targets (Climate watch)" /
        GHG        "GHG (excluding LULUCF)"
        GHG_Lulucf "GHG (including LULUCF)"
        CO2        "CO2 (excluding LULUCF)"
    /

;

mapnco2(nco2,nco2) = yes ;

***HRR: added these subsets 
sets
PFCs(AllEmissions)      "Perfluorocarbons" /
    C2F6
    C3F8
    C4F10
    C5F12
    C6F14
    CF4 
    cC4F8
    C7F16 
/

HFCs(AllEmissions)      "Hydrofluorocarbons" /
    HCFC141b 
    HCFC142b 
    HFC125	
    HFC134	
    HFC134a	
    HFC143	
    HFC143a	
    HFC152a	
    HFC227ea
    HFC23	
    HFC236fa
    HFC245fa
    HFC32	
    HFC365mfc
    HFC41	
    HFC4310mee
/
;
***endHRR