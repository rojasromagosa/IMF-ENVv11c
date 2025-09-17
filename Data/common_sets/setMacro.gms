$OnText
--------------------------------------------------------------------------------
            OECD-ENV Model version 1.0 - Aggregation procedure
    GAMS file: setMacro.gms
    purpose: Declare the sets read during macro scenario generation
    created by  : Jean Chateau
    called by:
			- "%SatDataDir%\Build_Scenario.gms"
			- ENV-Growth\GTAP_macro_database\Generate_the_macro_database_for_GTAP_Aggregation.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/common_sets/setMacro.gms $
   last changed revision: $Rev: 483 $
   last changed date    : $Date:: 2024-01-25 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*------------------------------------------------------------------------------*
*             GTAP Macroeconomic Informations                                  *
*------------------------------------------------------------------------------*
SETS
    var_macro_gtap  "set of macro variables calculated from GTAP database" /

        PIBPM  	"GDP initiaux pour toutes les zones de la base GTAP"
        POP    	"Gtap population milliers individus"
        CONS	"Households expenditures"
        INV		"Gross Investment"
        INET	"Net-of-depreciation Investment"
        GOV		"Government expenditures"
        EXP
        IMP
        SAVE
        SAVG
        imp_rate "Imports to GDP ratio (percent)"
        inv_rate "Gross Investment to GDP ratio (percent)"

*	Names for Old baseline (to be removed when useless)

		CMEN	"Households expenditures"
		IBRUT	"Gross Investment"
		CGOV	"Government expenditures"
    /

    gdp_unit    "units of account for GDP" /
        cur_usd     "current USD"
        cst_usd     "constant USD (gtap year)"
        cur_itl     "current international USD"
        cst_itl     "constant ppp year international USD (%YearGTAP%)"
        cur_lcu     "current LCU"
        cst_lcu     "constant LCU (gtap year)"
    /

    notlcu(gdp_unit) "USD or itl. USD units" /
        cur_usd     "current USD"
        cur_itl     "current international USD"
        cst_usd     "constant USD (%YearBaseMER% year)"
        cst_itl     "constant international USD (%YearBaseMER% year)"
    /

* Calcul Taux de change PPP necessaire pour agreger les Zones

    ER_def   "Conversion rates between GDP " /
        cst_cur  "To convert from constant GTAP USD - inital year to current USD                      "
        cst_itl  "To convert from constant GTAP USD - inital year to constant 2005 international USD  "
        cur_itl  "To convert from constant GTAP USD - inital year to current international USD        "
        MER      "To convert from current USD to current LCU                                          "
        MER_itl  "To convert from current USD to constant 2005 international USD                      "
    /
	
    WBAggsectors "Sectors in world bank WDI database" /
        Industry
        Services
        Agriculture
        Manufacturing
        Food            "Food, beverages and tobacco"
        Chemicals
        Machinery       "Machinery and transport equipment"
        OtherManuf      "Other manufacturing"
        Textiles        "Textiles and clothing"
    /

    SetMacroTgt "Macro variables from ENV-Growth projections" /

        "invshr"    "Investissement to gdp ratio: nominal"
        "rinvshr"   "Investissement to gdp ratio: real"
        "rgovshr"   "Government consumption ratio: real"
        "govshr"    "Government consumption ratio: nominal"
        "InvYfd"    "Investissement consumption:nominal"
        "savf"      "Foreign saving: nominal"
        "rsg"       "Government savings: real"
        "savg"      "Government savings: nominal"
        "GovYfd"    "Government consumption:nominal"
        "GovXfd"    "Government consumption:real"
        "tland"     "Land Supply"
        "pop"       "Total population (millions of prs)" !! PTOTL
        "pop15"     "Population 15 years old and more (millions of prs)"
        "pop1574"   "Working-age population: age 15-74  (millions of prs)"
        "rgdpmp"
        "rgdppc"    "Real GDP per capita"
        "RurPopShr"
        "unr"       "Unemployement rate (percentage of active population)"
        "kaplab"    "Capital to efficient labour (real)"
        "labshr"    "Labour income share (nominal)"
        "rlabshr"   "Labour income share (real)"
        "g_gdp"     "Growth Rate: GDP (cst %YearBasePPP% USD) from ENV-Growth Model"
        "ERT"       "Aggregate employment rate (percentage of Working-age population)"
        "CBGDPR"    "Current account balance (GDP percentage)"
        "deltaT"    "Physical Depreciation rate: Projected"

* Not in macro scenario

        "lfpr"      "Average Labour force participation rate (percentage of active population)"

        "TB_to_gdpT"
        "SAVTGQ"
        "INC_to_gdpT"
        "Tax_to_gdpT"
        "MGSQ"
        "CGQ"
        "HCAP"
        "OIL_prod"
        "GAS_prod"
        "part_extraction"
        "Pub_Health_to_gdpT"
        "Pri_Health_to_gdpT"
        "Pub_Health_to_CG"
        "SSC_to_gdpT"
        "SSP_to_gdpT"

    /

;


