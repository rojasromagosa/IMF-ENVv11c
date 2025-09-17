$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] project V.1. - Data aggregation procedure
    name        :  %SetsDir%\setIEA\03-sets_emissions.gms"
    purpose     :  Defined emission sets for External IEA database
                        - SourcesNONCO2
    created date:
    created by  : Jean Chateau
    called by   : "%SetsDir%\setIEA\setIEA.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/common_sets/setIEA/03-sets_emissions.gms $
   last changed revision: $Rev: 251 $
   last changed date    : $Date:: 2023-03-23 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText


* Memo for NONCO2 methodology from the 2006 IPCC Guidelines for GHG inventories

set SourcesNONCO2 "IEA: Sources Emissions NONCO2 DataSet" /

    CO2COMB    "CO2 - Fuel combustion           "
    CO2FUG     "CO2 - Fugitive                  "
    CO2IND     "CO2 - Industrial processes      "
    CO2OTHER   "CO2 - Other                     "
    CH4ENERGY  "CH4 - Energy                    "
    CH4AGRI    "CH4 - Agriculture               "
    CH4WASTE   "CH4 - Waste                     "
    CH4OTHER   "CH4 - Other                     "
    N2OENERGY  "N2O - Energy                    "
    N2OAGRI    "N2O - Agriculture               "
    N2OIND     "N2O - Industrial processes      "
    N2OOTHER   "N2O - Other                     "
    HFCIND     "HFC - Industrial processes      "
    PFCIND     "PFC - Industrial processes      "
    SF6IND     "SF6 - Industrial processes      "

* The sources below are not extracted in the file
*   "%SatDataDir%\Energy\IEA\NONCO2\%NONCO2_date%.gdx"
* see "ENV-SmallDev\Jean\DataEco\OECD\dotStat\Export_IEA_DotStat_Data.gms"

    $$OnText
        CH4TOT	    "CH4 - Total"
        CO2TOT	    "CO2 - Total"
        N2OTOT	    "N2O - Total"
        TOTAL	    "TOTAL"
        ESHARE	    "Share of energy in total GHG (%)"
        N2OESHARE	"N2O - Share of energy in total"
        CH4ESHARE	"CH4 - Share of energy in total"
        CO2ESHARE	"CO2 - Share of energy in total"
        GHGGDP	    "Total GHG emissions / GDP PPP"
    $$Offtext
/ ;


*------------------------------------------------------------------------------*
*              emissions de CO2 associees a combustion energie                 *
*------------------------------------------------------------------------------*

* e.g. detail des emissions de CO2 associees a combustion
* SourceNONCO2 = combustion
* les autres sources de CO2, energies fugitives ou industrielles,... ne sont pas dans cettte
* base - en revanche on a le detail des soutes internationales.
* IEA CO2 Emissions from Fuel Combustion -  CO2 Emissions from Fuel Combustion Vol 2007 release 01

set IEA_CO2_fuel_typeTMP /
    Transport
    MAINPROD
    IND
    OTHEN
    TOTOTHER
    Residential
    itlb_aviation
    itlb_navire
* Other Agr & Sevices excluding residential
    OTHER
    TOTAL

    "Unallocated autoproducers"
    "Memo: International aviation bunkers"
    "CO2 Sectoral Approach"
    "Main activity producer electricity and heat"
    "Memo: International marine bunkers"
    "Other energy industry own use"
    "of which: residential"
    "of which: road"
    "Statistical differences"
    "Manufacturing industries and construction"
    "Other sectors"
    "Differences due to losses and/or transformation"

/;

* Sous ensemble vielle procedure

set type_CO2_COMB(IEA_CO2_fuel_typeTMP) "sous ensemble des emissions de CO2 associees a combustion selon IEA" /
    total                 "emissions totales de CO2 dues � la combustion energie calculees en appliquant la m�thode sectorielle de niveau 1 du GIEC"
    itlb_aviation         "aviation internationale"
    itlb_navire           "soutes maritimes internationales"
/;

* Other subset IEA_CO2_fuel_typeTMP = IEA_CO2_fuel_type without TOTOTHER that is empty after
* its allocation between categories Residential and OTHER, so no need to report these data in EL database

set IEA_CO2_fuel_type(IEA_CO2_fuel_typeTMP) "ensemble des emissions de CO2 associees a combustion selon IEA" /
    Transport        "Transport"
    MAINPROD         "Main Activity Producer Electricity and Heat"
    IND              "Manufacturing Industries and Construction + Unallocated Autoproducers"
    OTHEN            "Other Energy Industries"
    Residential      "Household"
    itlb_aviation    "International Aviation Bunkers"
    itlb_navire      "International Marine Bunkers"
    OTHER            "Other Agr & Sevices excluding residential"
    TOTAL            "All sources of emissions"
/;

*---    [2019-09-13]: Remove old and useless sets
*   full_fuel_CO2_COMB and fuel_CO2_COMB(full_fuel_CO2_COMB)

*------------------------------------------------------------------------------*
* Sources Emissions of CO2, CH4, N2O, HFCs, PFCs and SF6 (IEA-DotStat:NONCO2)  *
*       Reference publication IEA: "CO2 emissions from fuel combustion"        *
*------------------------------------------------------------------------------*

$OnText
Details from "CO2 emissions from fuel combustion"

   Other CO2 emissions refer to direct emissions
        - from solvent use (IPCC Source/Sink Category 3),
        - from application of urea and agricultural lime (IPCC Source/Sink Category 4)
        - from fossil fuel fires (coal fires & the Kuwait oil fires) (IPCC Source/Sink Category 7).

   Other CH4 emissions includes
        - industrial process emissions (e.g. methanol production),
        - forest and peat fires and other vegetation (IPCC Source/Sink Categories 2 and 5)

   Other N2O emissions includes
        - N2O usage (IPCC Source/Sink Categories 3).
        - forest and peat fires (including post-burn decay emissions from remaining biomass) and other vegetation fires, (IPCC Source/Sink Categories 5).
        - human sewage + discharge and waste incineration (non-energy) (IPCC Source/Sink Categories 6).
        - indirect N2O from atmospheric deposition of NOx and NH3 from non-agricultural sources (IPCC Source/Sink Categories 7).

$OffText



