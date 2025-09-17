SET

* useless now: set_WEM_WPrices

    set_WEM_WPrices "Wholesale Price" /
        "coal"        "$%weoUSD%, per metric tonne"
        "oil"         "$%weoUSD%, per barrel"
        "gas"         "$%weoUSD%, per toe"
        "Electricity" "$%weoUSD%, per MWh"
    /

    set_wem_macro "Macro Data from WEM" /
        "GDP MER"           "$%weoUSD% billion, MER"
        "GDP PPP"           "$%weoUSD% billion, PPP"
        "Population"        "Million"
        "Urban Population"  "Million"
        "Rural Population"  "Million"
        "Value Added MER"   "$%weoUSD% billion, MER"
        "Value Added PPP"   "$%weoUSD% billion, PPP"
    /

    ieaVar "Variables from IEA WEO" /
        ""
        "Population"
        "Urban Population"
        "Rural Population"
        "Share of World Population"
        "GDP"
        "Share of World GDP"
        "GDP per Capita"
        "Value Added"

* Sectoral production

        "Crude steel production"
        "Ethylene production"
        "Propylene production"
        "Aromatics production"
        "Ammonia production"
        "Methanol production"
        "Cement production"
        "Power"
        "Paper and paperboard production"
        "Aluminium production"

* Households/Buildings

        "Occupied Dwellings"
        "Floor space"
        "Stock of Passenger Light Duty Vehicles (PLDV)"
        "Total stock of road vehicles"
        "Stock of electric cars"
        "Total stock of electric vehicles"
        "Total road activity"
        "PLDV activity"
        "Total road freight activity"

*   Prices

        "Wholesale price"
        "CO2 price"
        "End-use prices"    "$%weoUSD%, per toe"

        "Demand"            "Mtoe"
        "Production"
        "Capacity"
        "CO2 emissions" "MtCO2"
        "Investment"
        "Supply"
        "Net trade"
        "Support"        "Renewables support in power sector"

* Name added

        "recycling rate"
        "Industrial production"
        "Power production"
        "Heat production"
        "Power capacity"
    /

    ieaAgents(ieaSubSect) /
        "Agriculture"
        "Total"
        "<empty>"
        ""
        "Biofuels"
        "Buildings"
        "Coal"
        "Demand-side"
        "Gas"
        "Heat"
        "Industry"
        "Industry (incl. BF&CO and Petchem. Feedstocks)"
        "Industry (incl. BF&CO)"
        "Non-energy uses"
        "Oil"
        "Other transformations"
        "Power"
        "Power&Heat"
        "Process"
        "Residential"
        "Services"
        "Supply-side"
        "TFC"
        "TPED"
        "TPED (incl. Process)"
        "Transport"

* Added to simplify
        "International bunkers"

    /
    iea_tped_demand(WeoGood)   /
        Total
        Coal
        Oil
        Gas
        Nuclear
        Hydro
        Biomass
        "Other renewables"
    /
    iea_tfc_demand(WeoGood) /
        Total
        Coal
        Oil
        Gas
        Electricity
        Heat
        Hydrogen
        Biomass
        "Other renewables"
    /
;


*   Mapping WEO ieaAgents,ieaSubSect  with GTAP activities a0

SET mapieaAgent(ieaAgents,ieaSubSect,a0) "Map WEO agents to GTAP activities a0";

$Ifi     %GTAP_ver%=="92" mapieaAgent("Industry","Chemicals","crp") = YES ;
$Ifi NOT %GTAP_ver%=="92" mapieaAgent("Industry","Chemicals","chm") = YES ;

mapieaAgent("Industry","Aluminium","nfm")  = YES ;
mapieaAgent("Industry","Cement","nmm")     = YES ;
mapieaAgent("Industry","Steel","i_s")      = YES ;
mapieaAgent("Industry","Paper","ppp")      = YES ;
mapieaAgent("Industry","Non-specified",a0) = YES ;
mapieaAgent("Industry","BF&CO and Petchem. Feedstocks","p_c") = YES ;
mapieaAgent("Industry","BF&CO and Petchem. Feedstocks","i_s") = YES ;

mapieaAgent("Services","Total",srv0)      = YES ;

mapieaAgent("Agriculture","Total",acr0)   = YES ;
mapieaAgent("Agriculture","Total",alv0)   = YES ;
mapieaAgent("Agriculture","Total","frs")  = YES ;
mapieaAgent("Agriculture","Total","fsh")  = YES ;

mapieaAgent("Transport","Domestic Aviation","atp")  = YES ;
mapieaAgent("Transport","Navigation","wtp")         = YES ;
mapieaAgent("Transport","RAIL","otp")               = YES ;
mapieaAgent("Transport","PIPELINE","otp")           = YES ;
mapieaAgent("Transport","Non-specified","otp")      = YES ;
mapieaAgent("Transport","Road Non-PLDV","otp")      = YES ;
mapieaAgent("Transport","Road - PLDV","otp")        = YES ;

mapieaAgent("Residential","Total",CGDS0)      = YES ;

mapieaAgent("Non-energy uses","Petchem. Feedstocks","p_c")  = YES ;
$Ifi     %GTAP_ver%=="92" mapieaAgent("Non-energy uses","Non-Feedstocks","crp")  = YES ;
$Ifi NOT %GTAP_ver%=="92" mapieaAgent("Non-energy uses","Non-Feedstocks","chm")  = YES ;

mapieaAgent("Power&Heat","Inputs to power and heat sector",elya0) = YES ;

* --> this cat is important need to know where
mapieaAgent("Other transformations","other",a0)  = YES ;

mapieaAgent("Other transformations","BF&CO","i_s")  = YES ; !! and logically also nfm
mapieaAgent("Other transformations","Oil&Gas Extraction","oil")  = YES ;
mapieaAgent("Other transformations","Oil&Gas Extraction","gas")  = YES ;
mapieaAgent("Other transformations","Refineries","p_c")  = YES ;

mapieaAgent("Other transformations","Losses",elya0) = YES ;

*mapieaAgent("International bunkers","Total","itlbunk")   = YES ;




