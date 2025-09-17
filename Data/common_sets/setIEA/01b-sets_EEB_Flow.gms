$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] Model : Data and Aggregation Procedure
    GAMS file   : 01b-sets_EEB_Flow.gms
    purpose     : Define set for Flows/Carrriers from IEA Extended Energy Balance
    created date: 6 Juin 2017
                --> Modified 2019-09-23
                --> last checked : 15 Fevrier 2023
    created by  : Jean Chateau
    called by   : "%SetsDir%\setIEA\setIEA.gms"
--------------------------------------------------------------------------------
   file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
   last changed revision: $Rev: 283 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Energy Flows in IEA-EEB (thousand tonnes of oil equivalent ktoe)

    memo:  # Categories in WBES but not WBIG
           * Categories in BIGCO2

           70 active categories for WBIG
           73 active categories for WBES

    memo: FINCONS Final consumption
    is the sum of the consumption in the end-use sectors (TFCNE)
    and for non-energy use (NONENUSE)

    Energy industry own use and Losses (negative flow)
        contient utilisations et pertes energie primaire par les industries
        énergtiques (lors de la conversion en energie secondaire ou pour extraction
        production énergies primaires)

    DISTLOSS  "Losses in energy distribution, transmission and transport"
        Telles que les pertes et utilisation de gaz dans la production
        & distribution de gaz, perte dans prod petrole rafine,..
        energie utilisee dans extraction charbon, gaz et petrole,
        electricite dans production chaleur,...
    --> Logiquement c'est un sous ensemble de
        "Energy industry own use and Losses" mais je le mets à part

    Non-Energy Use (positive flow)
        Logiquement dans la categorie des industries : produits
        fossiles comme feedstock sauf a priori petrole dans industrie
        petrochimiques qui est deja contenu dans "indust" pas clair...

--------------------------------------------------------------------------------
$OffText

SETS
    EEB_Flow_Cat "Aggregate Flow categories for EEB" /
        TRANSF    "Transformation processes"
        ENGY      "Energy industry own use and Losses"
        DISTLOSS  "Losses in energy distribution, transmission and transport"
        TFCNE     "Final Consumption (Non-Energy Use excluded)"
        NONENUSE  "Non-Energy Use (included in TFC)"
        SUPPLY    "Supply-Aggregate Categories"
    /
    SUPPLY_cat(EEB_Flow_Cat) / SUPPLY /

    EEB_Flow "Extended Energy Balance: Flow Definitions" /
*------------------------------------------------------------------------------*
*                                                                              *
*               Transformation processes: "TRANSF"                             *
*                       NEGATIVE FLOWS                                         *
*------------------------------------------------------------------------------*

* Memo MAINELEC/MAINHEAT is positive for Electricity & Heat

    TOTTRANF       "Transformation processes"

* TOTTRANF equals the sum of following processses

    MAINELEC       " Main activity producer electricity plants "
    AUTOELEC       " Autoproducer electricity plants           "
    MAINCHP        " Main activity producer CHP plants#"
    AUTOCHP        " Autoproducer CHP plants                   "
    MAINHEAT       " Main activity producer heat plants        "
    AUTOHEAT       " Autoproducer heat plants                  "
    THEAT          " Heat pumps                                "
    TBOILER        " Electric boilers                          "
    TELE           " Chemical heat for electricity production  "
    TBLASTFUR      " Blast furnaces                            "
    TGASWKS        " Gas works                                 "
    TCOKEOVS       " Coke ovens                                "
    TPATFUEL       " Patent fuel plants                        "
    TBKB           " BKB plants                                "
    TREFINER       " Oil refineries                            "
    TPETCHEM       " Petrochemical plants                      "
    TCOALLIQ       " Coal liquefaction plants                  "
    TGTL           " Gas-to-liquids (GTL) plants               "
    TBLENDGAS      " For blended natural gas                   "
    TCHARCOAL      " Charcoal production plants                "
    TNONSPEC       " Non-specified (transformation)            "

    AUTOPROD       "Unallocated autoproducers*"
    MAINPROD       "Main Activity electricity and Heat production*"
    OTHEN          "Other energy industry own use*"

*------------------------------------------------------------------------------*
*                                                                              *
*                  Energy industry own use and Losses: "ENGY"                  *
*                       NEGATIVE FLOWS                                         *
*------------------------------------------------------------------------------*

    TOTENGY    " Energy industry own use                                       "
    EMINES     " Energy used directly within the coal industry                 "
    EOILGASEX  " Energy used for oil and gas extraction (excluding Flared gas) "
    EBLASTFUR  " Energy used in Blast furnaces                                 "
    EGASWKS    " Energy used in Gas works                                      "
    EBIOGAS    " Own consumption of biogas for Gasification plants for biogases"
    ECOKEOVS   " Energy used in Coke ovens                                     "
    EPATFUEL   " Energy Used in Patent fuel plants                             "
    EBKB       " Energy used in BKB plants                                     "
    EREFINER   " Energy used in Oil refineries                                 "
    ECOALLIQ   " Energy used in Coal liquefaction plants                       "
    ELNG       " Energy used in Liquefaction (LNG) - regasification plants     "
    EGTL       " Energy used in Gas-to-liquids (GTL) plants                    "

    EPOWERPLT  " Energy used in electricity CHP and heat plants                "
    EPUMPST    " Energy used in Pumped storage plants                          "
    ENUC       " Energy Used in Nuclear industry                               "
    ECHARCOAL  " Energy Used in Charcoal production plants                     "
    ENONSPEC   " Use in Non-specified (energy)                                 "

*------------------------------------------------------------------------------*
*       Losses in energy distribution, transmission and transport              *
*------------------------------------------------------------------------------*
* Comptabilise a part NEGATIVE FLOWS

    DISTLOSS   "Losses in energy distribution, transmission and transport"

*------------------------------------------------------------------------------*
*                                                                              *
*               Final consumption: TFCNE                                       *
*                                                                              *
*------------------------------------------------------------------------------*
$OnText

    TFC = TOTIND + TOTTRANS + TOTOTHER + NONENUSE

    TFC = TES + TRANSFER + STATDIFF + TOTENGY(<0) + TOTTRANF(><) + DISTLOSS(<0)

    TOTTRANF is either positive or negative
    Positive pour les produits/output genre LPG ou electricite ou Motor gasoline
    Negative pour les intrants genre CrudeOil, Lignite, Hydro

    Then TES = TFC
              - (TOTENGY + DISTLOSS + TOTTRANF(f) + TOTTRANF(e))
                  + STATDIFF + TRANSFER)

    TRANSFER + TOTENGY = TFC
    --> Consommation finale = Transfert - ce qui est consomme par nrj

$OffText

    TFC         "Total final consumption (not in WBES)"
    TFC_2nd     "Total Final Consumption (second calculation)"

*------------------------------------------------------------------------------*
*                           TFC.1 : Industry                                   *
*------------------------------------------------------------------------------*

    TOTIND         " Industry"
    IRONSTL        " Iron and steel"

* !!!WARNING Manufacture of rubber and plastics products pas dans CRP
* mais dans INONSPEC
* CHEMICAL: ISIC Rev. 4 Divisions 20 and 21
* 20: Manufacture of chemicals and chemical products
* 21: Manufacture of pharmaceuticals, medicinal chemical and botanical products
    CHEMICAL        "Chemical and petrochemical (Excl. petrochemical feedstocks)"

    NONFERR         "Non-ferrous metals            "
    NONMET          "Non-metallic minerals         "
    TRANSEQ         "Transport equipment (MVH+OTN) "
    MACHINE         "Machinery  (FMP+ELE+OME)      "
    MINING          "Mining and quarrying          "
    FOODPRO         "Food and tobacco              "
    PAPERPRO        "Paper pulp and print          "
    WOODPRO         "Wood and wood products        "
    CONSTRUC        "Construction                  "
    TEXTILES        "Textile and leather           "

*   INONSPEC contains :
*      - Manufacture of rubber and plastics products (25 isic 3 or 22 isic 4)
*      - Manufacture of furniture (31 or 36)
*      - Other manufacturing (32) --> omf?

    INONSPEC        "Non-specified (industry)"
    MANUFACT        "Manufacturing"

*------------------------------------------------------------------------------*
*                           TFC.2 : Transport                                  *
*------------------------------------------------------------------------------*

    TOTTRANS       " Total Transport               "
    WORLDAV        " World aviation bunkers        "
    DOMESAIR       " Domestic aviation             "

* Memo: Road includes fuels used in road vehicles
*   as well as agricultural and industrial highway use.

    ROAD           " Road                          "
    RAIL           " Rail                          "
    PIPELINE       " Pipeline transport            "
    WORLDMAR       " World marine bunkers          "
    DOMESNAV       " Domestic navigation           "
    TRNONSPE       " Non-specified (transport)     "

*------------------------------------------------------------------------------*
*            TFC.3 : Other: residential+services+agriculture+FF+other          *
*------------------------------------------------------------------------------*

* Memo:
*   Residential includes consumption by households, excl. fuels used for transport
*   Fishing includes fuels used for inland, coastal and deep-sea fishing.

    TOTOTHER       " Other: residential+services+agriculture+FF+other      "

    RESIDENT       " Residential                                           "
    COMMPUB        " Commercial and public services                        "
    AGRICULT       " Agriculture-forestry                                  "
    FISHING        " Fishing                                               "
    ONONSPEC       " Non-specified (other, military)                       "

*------------------------------------------------------------------------------*
*                     TFC.4 : Non-Energy Use                                   *
*------------------------------------------------------------------------------*

    NONENUSE   "Total Non-energy use"

    NEINTREN   "Non-energy use industry-transformation-energy"
    NETRANS    "Non-energy use in transport"
    NEOTHER    "Non-energy use in other (residential+services+agri..)"
    NEIND      "Memo: Non-energy use in industry"
    NECHEM     "Memo: Feedstock use in petrochemical industry"
    NEIRONSTL  "Memo: Non-energy use in iron and steel"
    NENONFERR  "Memo: Non-energy use in non-ferrous metals"
    NENONMET   "Memo: Non-energy use in non-metallic minerals"
    NETRANSEQ  "Memo: Non-energy use in transport equipment"
    NEMACHINE  "Memo: Non-energy use in machinery"
    NEMINING   "Memo: Non-energy use in mining and quarrying"
    NEFOODPRO  "Memo: Non-energy use in food/beverages/tobacco"
    NEPAPERPRO "Memo: Non-energy use in paper/pulp and printing"
    NEWOODPRO  "Memo: Non-energy use in wood and wood products"
    NECONSTRUC "Memo: Non-energy use in construction "
    NETEXTILES "Memo: Non-energy use in textiles and leather"
    NEINONSPEC "Memo: Non-energy use in non-specified industry "

*------------------------------------------------------------------------------*
*                                                                              *
*                  Supply: Electricity and Heat                                *
*                                                                              *
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*                   Electricity output (GWh)                                   *
*------------------------------------------------------------------------------*
* ELOUTPUT(f) =  ELAUTOC + ELAUTOE + ELMAINC + ELMAINE

    ELOUTPUT  "Electricity output (GWh)                                   "
    ELAUTOC   "Electricity output (GWh) autoproducer CHP plants           "
    ELAUTOE   "Electricity output (GWh) autoproducer electricity plants   "
    ELMAINC   "Electricity output (GWh) main activity producer CHP plants "
    ELMAINE   "Electricity output (GWh) main activity producer electricity plants "
    MHYDPUMP  "Main activity producers - pumped hydro production (GWh)#"
    AHYDPUMP  "Autoproducer-pumped hydro production (GWh)"

*------------------------------------------------------------------------------*
*                   Heat Output (TJ)                                           *
*------------------------------------------------------------------------------*
* HEATOUT = HEAUTOC + HEAUTOH + HEMAINC + HEMAINH

    HEATOUT        " Heat output                                    "
    HEAUTOC        " Heat output-autoproducer CHP plants            "
    HEAUTOH        " Heat output-autoproducer heat plants           "
    HEMAINC        " Heat output-main activity producer CHP plants  "
    HEMAINH        " Heat output-main activity producer heat plant  "

    ELECHEAT       " Memo: Electricity and heat production "

*------------------------------------------------------------------------------*
*                Supply categories:  SUPPLY                                    *
*------------------------------------------------------------------------------*

$OnText
Note about TES:

    DOMSUP = INDPROD
           + From other sources
           + IMPORTS + EXPORTS (neg.)
           + MARBUNK (neg.) + AVBUNK(neg.)  + STOCKCHA (pos. or neg.)

    TES    = INDPROD + IMPORTS + EXPORTS (neg.)
           + MARBUNK (neg.) + AVBUNK(neg.)  + STOCKCHA (pos. or neg.)

--> Quelle est la difference

    TES = TPED sauf au niveau mondial ou histoire de bunkers ???

    TES = Armington Good

    STOCKCHA: may be positive or negative flows according
              to country and product considered

    TRANSFER: postive some product: LPG (most of time)
              negative for some product: NGL
              positive or negative according to the country

    STATDIFF: may be positive or negative flows according
              to country and product considered

$OffText

    INDPROD   "Production of primary energy "
    IMPORTS   "Imports"
    EXPORTS   "Exports (negative flow)"
    AVBUNK    "International aviation bunkers (Kerosene Jet - negative flow)"
    MARBUNK   "International marine bunkers (Fuel oil - negative flow)"
    STOCKCHA  "Stock changes (positive or negative flow)"
    TES	      "Total energy supply (not in WBES)"
    TES_2nd   "Total energy supply (second calculation)"
    TRANSFER  "interproduct transfers, products transferred & recycled products (positive or negative flow)"
    STATDIFF  "Statistical differences(positive or negative flow)"
    DOMSUP    "Domestic supply#"
    FINCONS   "Final consumption#"

$OnText
 From other sources refers to both primary energy that has not been accounted
 for under production and secondary energy that has been accounted for in the
 production of another fuel.
 For example, under additives: benzol, alcohol and methanol produced from
 natural gas; under refinery feedstocks: backflows from the petrochemical
 industry used as refinery feedstocks; under other hydrocarbons (included with
 crude oil): liquids obtained from coal liquefaction and GTL plants;
 under primary coal: recovered slurries, middlings, recuperated coal dust
 and other low-grade coal products that cannot be classified according to
 type of coal from which they are obtained; under gas works gas: natural gas,
 refinery gas, and LPG, that are treated or mixed in gas works
 (i.e. gas works gas produced from sources other than coal).

 The presentation of production from other sources
 differs in the Oil Information publication.
$OffText

    OSCOAL     " From other sources - coal#"
    OSNATGAS   " From other sources - natural gas#"
    OSOIL      " From other sources - oil products#"
    OSRENEW    " From other sources - renewables#"
    OSNONSPEC  " From other sources - non-specified#"

*------------------------------------------------------------------------------*
*       Flows for IPCC Fuel Combustion Emissions (2006 Guidelines)             *
*           Raw_DataBases\DotStat\IPCC2006                                     *
*------------------------------------------------------------------------------*

$OnText

    {AVBUNK, MARBUNK, STATDIFF} --> already defined

    {CO2FCOMB,CO2RA,CO2SA,TRANDIFF}
    {IPPUAUTOP,IPPUEBLAST,IPPUEPOWER,IPPUFCOMB,IPPUIRON,IPPUNFERR}

    CO2RA    = CO2SA + TRANDIFF + STATDIFF

    CO2FCOMB = CO2SA + IPPUFCOMB


    IPPUFCOMB = IPPUIRON + IPPUNFERR + IPPUAUTOP + IPPUEPOWER + IPPUEBLAST

    IPPUFCOMB = IPPU CO2 Fuel combustion � Total reallocated (IPPU)
    presents the total quantity of CO2 emissions from fuel combustion
    which may be excluded from the Sectoral approach and reallocated
    to IPCC Source/Sink Category Industrial Processes
    and Product Use (IPPU) under the 2006 GLs

    TRANDIFF = Differences due to losses and/or transformation contains
    emissions that result from the transformation of energy from a
    primary fuel to a secondary or tertiary fuel. Included here are solid
    fuel transformation, oil refineries, gas works and other fuel
    transformation industries.
    These emissions are normally reported as fugitive emissions
    in the IPCC Source/Sink Category 1 B, but will be included
    in 1 A in inventories that are calculated using the
    IPCC Reference Approach. Theoretically, this category should
    show relatively small emissions representing the loss of carbon by
    other ways than combustion, such as evaporation or leakage.

                  |  NATGAS | OTHER  | TOTAL |  COAL  |  OIL
                  |         |        |       |        |
        AVBUNK    |         | 24.1   | 24.1  |        |
        MARBUNK   |         | 7.6    | 7.6   |        |
        STATDIFF  |  -4.7   |        |-2.4   |  3.7   |  -1.3
        CO2FCOMB  |  152.2  | 19     | 729.7 |  316   |  242.5
        CO2RA     |  147.5  | 19     | 700.8 |  285.1 |  249.2
        CO2SA     |  152.2  | 19     | 690.4 |  276.7 |  242.5
        IPPUAUTOP |         |        | 20.1  |  20.1  |
        IPPUFCOMB |         |        | 39.2  |  39.2  |
        IPPUIRON  |         |        | 19.1  |  19.1  |
        IPPUNFERR |         |        | 0.1   |  0.1   |
        TRANDIFF  |         |        | 12.7  |  4.7 8 |

$OffText

    CO2FCOMB     "CO2 Fuel Combustion (Energy & IPPU)"
    CO2RA        "CO2 Reference Approach (Energy)"
    CO2SA        "CO2 Sectoral Approach (Energy) DEFAULT"
    IPPUFCOMB    "IPPU CO2 Fuel combustion - Total reallocated (IPPU)"
    IPPUAUTOP    "Memo: IPPU CO2 Fuel combustion - Autoproducers (IPPU)"
    IPPUEBLAST   "Memo: IPPU CO2 Fuel combustion - Blast furnace energy (IPPU)"
    IPPUEPOWER   "Memo: IPPU CO2 Fuel combustion - Autoproducer own use (IPPU)"
    IPPUIRON     "Memo: IPPU CO2 Fuel combustion - Iron and steel (IPPU)"
    IPPUNFERR    "Memo: IPPU CO2 Fuel combustion - Non-ferrous metals (IPPU)"
    TRANDIFF     "Differences due to losses and or transformation (Energy): IPCC2006 dataset"

    check        "Personal variable to make some calc"
/;


*------------------------------------------------------------------------------*
*                                                                              *
*                            SubSets for EEB_Flow                              *
*                                                                              *
*------------------------------------------------------------------------------*

SETS

    EEB_Flow_Supply(EEB_Flow) "Supply-Aggregate Categories "/

        ELOUTPUT    "Electricity output"
        HEATOUT     "Heat output"

        INDPROD     "Production of primary energy"
        IMPORTS     "Imports"
        EXPORTS     "Exports"
        AVBUNK      "International aviation bunkers (Kerosene Jet - world only)"
        MARBUNK     "International marine bunkers (Fuel oil - world only)"
        STOCKCHA    "Stock changes"
        TES	        "Total energy supply (not in WBES)"
        TRANSFER    "interproduct transfers, products transferred & recycled products"
        STATDIFF    "Statistical differences"

        DOMSUP      "Domestic supply#"
        FINCONS     "Final consumption#"

        OSCOAL      "From other sources - coal"
        OSNATGAS    "From other sources - natural gas"
        OSOIL       "From other sources - oil products"
        OSRENEW     "From other sources - renewables"
        OSNONSPEC   "From other sources - non-specified"

    /

    EEB_Flow_Agg(EEB_Flow) /
        TOTTRANF  "Transformation processes"
        TOTENGY   "Energy industry own use"
        TOTIND    "Total final consumption : Industrie"
        TOTTRANS  "Total final consumption : Transport"
        TOTOTHER  "Total final consumption : Other and residential"
        NONENUSE  "Total final consumption : Non-Energy Use "
        TFC       "Total Final Consumption"
        TES       "Total energy supply (not in WBES)"
        TES_2nd   "Total energy supply (second calculation)"
        TFC_2nd   "Total Final Consumption (second calculation)"
        DOMSUP    "Domestic supply#"

*   BigCo2 dataset

        CO2FCOMB
        ELECHEAT
    /

    NEIND(EEB_Flow) "Non-energy use in industry (details)" /
        NECHEM     " Memo: Feedstock use in petrochemical industry"
        NEIRONSTL  " Memo: Non-energy use in iron and steel"
        NENONFERR  " Memo: Non-energy use in non-ferrous metals"
        NENONMET   " Memo: Non-energy use in non-metallic minerals"
        NETRANSEQ  " Memo: Non-energy use in transport equipment"
        NEMACHINE  " Memo: Non-energy use in machinery"
        NEMINING   " Memo: Non-energy use in mining and quarrying"
        NEFOODPRO  " Memo: Non-energy use in food/beverages/tobacco"
        NEPAPERPRO " Memo: Non-energy use in paper/pulp and printing"
        NEWOODPRO  " Memo: Non-energy use in wood and wood products"
        NECONSTRUC " Memo: Non-energy use in construction "
        NETEXTILES " Memo: Non-energy use in textiles and leather"
        NEINONSPEC " Memo: Non-energy use in non-specified industry "
    /

    TRANSF(EEB_Flow) "Transformation processes" /
        TBLASTFUR      " Blast furnaces                "
        TGASWKS        " Gas works                     "
        TCOKEOVS       " Coke ovens                    "
        TPATFUEL       " Patent fuel plants            "
        TBKB           " BKB plants                    "
        TREFINER       " Oil refineries                "
        TPETCHEM       " Petrochemical plants          "
        TCOALLIQ       " Coal liquefaction plants      "
        TGTL           " Gas-to-liquids (GTL) plants   "
        MAINELEC       " Main activity producer electricity plants  "
        AUTOELEC       " Autoproducer electricity plants            "
        MAINCHP        " Main activity producer CHP plants#"
        AUTOCHP        " Autoproducer CHP plants                    "
        MAINHEAT       " Main activity producer heat plants         "
        AUTOHEAT       " Autoproducer heat plants                   "
        THEAT          " Heat pumps                                 "
        TBOILER        " Electric boilers                           "
        TELE           " Chemical heat for electricity production   "
        TBLENDGAS      " For blended natural gas                    "
        TCHARCOAL      " Charcoal production plants                 "
        TNONSPEC       " Non-specified (transformation)             "
    /

    map_EEB_Flow(EEB_Flow_Agg,EEB_Flow)   /

*   TOTTRANF  " Transformation processes "

        TOTTRANF.MAINELEC  " Main activity producer electricity plants  "
        TOTTRANF.AUTOELEC  " Autoproducer electricity plants            "
        TOTTRANF.MAINCHP   " Main activity producer CHP plants#"
        TOTTRANF.AUTOCHP   " Autoproducer CHP plants                    "
        TOTTRANF.MAINHEAT  " Main activity producer heat plants         "
        TOTTRANF.AUTOHEAT  " Autoproducer heat plants                   "
        TOTTRANF.THEAT     " Heat pumps                                 "
        TOTTRANF.TBOILER   " Electric boilers                           "
        TOTTRANF.TELE      " Chemical heat for electricity production   "
        TOTTRANF.TBLASTFUR " Blast furnaces                             "
        TOTTRANF.TGASWKS   " Gas works                                  "
        TOTTRANF.TCOKEOVS  " Coke ovens                                 "
        TOTTRANF.TPATFUEL  " Patent fuel plants                         "
        TOTTRANF.TBKB      " BKB plants                                 "
        TOTTRANF.TREFINER  " Oil refineries                             "
        TOTTRANF.TPETCHEM  " Petrochemical plants                       "
        TOTTRANF.TCOALLIQ  " Coal liquefaction plants                   "
        TOTTRANF.TGTL      " Gas-to-liquids (GTL) plants                "
        TOTTRANF.TBLENDGAS " For blended natural gas                    "
        TOTTRANF.TCHARCOAL " Charcoal production plants                 "
        TOTTRANF.TNONSPEC  " Non-specified (transformation)             "

*   TOTENGY   "Energy industry own use" --> negative numbers

        TOTENGY.EMINES     " Energy used directly within the coal industry                 "
        TOTENGY.EOILGASEX  " Energy used for oil and gas extraction (excludin Flared gas)  "
        TOTENGY.EBLASTFUR  " Energy used in Blast furnaces                                 "
        TOTENGY.EGASWKS    " Energy used in Gas works                                      "
        TOTENGY.EBIOGAS    " Own consumption of biogas for Gasification plants for biogases"
        TOTENGY.ECOKEOVS   " Energy used in Coke ovens                                     "
        TOTENGY.EPATFUEL   " Energy Used in Patent fuel plants                             "
        TOTENGY.EBKB       " Energy used in BKB plants                                     "
        TOTENGY.EREFINER   " Energy used in Oil refineries                                 "
        TOTENGY.ECOALLIQ   " Energy used in Coal liquefaction plants                       "
        TOTENGY.ELNG       " Energy used in Liquefaction (LNG) - regasification plants     "
        TOTENGY.EGTL       " Energy used in Gas-to-liquids (GTL) plants                    "
        TOTENGY.EPOWERPLT  " Energy used in electricity CHP and heat plants                "
        TOTENGY.EPUMPST    " Energy used in Pumped storage plants                          "
        TOTENGY.ENUC       " Energy Used in Nuclear industry                               "
        TOTENGY.ECHARCOAL  " Energy Used in Charcoal production plants                     "
        TOTENGY.ENONSPEC   " Use in Non-specified (energy)                                 "

*   TOTIND  "TFC: Total Industry"

        TOTIND.IRONSTL     " Iron and steel                                                "
        TOTIND.CHEMICAL    " Chemical and petrochemical (Excl. petrochemical feedstocks)   "
        TOTIND.NONFERR     " Non-ferrous metals            "
        TOTIND.NONMET      " Non-metallic minerals         "
        TOTIND.TRANSEQ     " Transport equipment (MVH+OTN) "
        TOTIND.MACHINE     " Machinery  (FMP+ELE+OME)      "
        TOTIND.MINING      " Mining and quarrying          "
        TOTIND.FOODPRO     " Food and tobacco              "
        TOTIND.PAPERPRO    " Paper pulp and print          "
        TOTIND.WOODPRO     " Wood and wood products        "
        TOTIND.CONSTRUC    " Construction                  "
        TOTIND.TEXTILES    " Textile and leather           "
        TOTIND.INONSPEC    " Non-specified (industry)      "

*   TOTTRANS    "TFC: Total Transport "

        TOTTRANS.DOMESAIR  " Domestic aviation           "
        TOTTRANS.ROAD      " Road                        "
        TOTTRANS.RAIL      " Rail                        "
        TOTTRANS.PIPELINE  " Pipeline transport          "
        TOTTRANS.DOMESNAV  " Domestic navigation         "
        TOTTRANS.TRNONSPE  " Non-specified (transport)   "

*   TOTOTHER    "TFC: Other = residential+services+agriculture+FF+other "

        TOTOTHER.RESIDENT  " Residential                                      "
        TOTOTHER.COMMPUB   " Commercial and public services                   "
        TOTOTHER.AGRICULT  " Agriculture-forestry                             "
        TOTOTHER.FISHING   " Fishing                                          "
        TOTOTHER.ONONSPEC  " Non-specified (other, military)                  "

*   NONENUSE    "TFC:Total Non-energy use : "

        NONENUSE.NEINTREN   " Non-energy use industry-transformation-energy"
        NONENUSE.NETRANS    " Non-energy use in transport                  "
        NONENUSE.NEOTHER    " Non-energy use in other (residential+services+agri..)"
        NONENUSE.NEIND      " Memo: Non-energy use in industry"

* Details if exist

        NONENUSE.NECHEM     " Memo: Feedstock use in petrochemical industry"
        NONENUSE.NEIRONSTL  " Memo: Non-energy use in iron and steel"
        NONENUSE.NENONFERR  " Memo: Non-energy use in non-ferrous metals"
        NONENUSE.NENONMET   " Memo: Non-energy use in non-metallic minerals"
        NONENUSE.NETRANSEQ  " Memo: Non-energy use in transport equipment"
        NONENUSE.NEMACHINE  " Memo: Non-energy use in machinery"
        NONENUSE.NEMINING   " Memo: Non-energy use in mining and quarrying"
        NONENUSE.NEFOODPRO  " Memo: Non-energy use in food/beverages/tobacco"
        NONENUSE.NEPAPERPRO " Memo: Non-energy use in paper/pulp and printing"
        NONENUSE.NEWOODPRO  " Memo: Non-energy use in wood and wood products"
        NONENUSE.NECONSTRUC " Memo: Non-energy use in construction "
        NONENUSE.NETEXTILES " Memo: Non-energy use in textiles and leather"
        NONENUSE.NEINONSPEC " Memo: Non-energy use in non-specified industry "

        TFC.(IRONSTL,CHEMICAL,NONFERR,NONMET,TRANSEQ,MACHINE,MINING,FOODPRO,PAPERPRO,WOODPRO,CONSTRUC,TEXTILES,INONSPEC)
        TFC.(DOMESAIR,ROAD,RAIL,PIPELINE,DOMESNAV,TRNONSPE)
        TFC.(RESIDENT,COMMPUB,AGRICULT,FISHING,ONONSPEC)
        TFC.(NEINTREN,NETRANS,NEOTHER,NEIND,NECHEM,NEIRONSTL,NENONFERR,NENONMET,NETRANSEQ,NEMACHINE,NEMINING,NEFOODPRO,NEPAPERPRO,NEWOODPRO,NECONSTRUC,NETEXTILES,NEINONSPEC)

*   TES:    "Total Energy supply (Mtoe) "
* memo: TES = INDPROD + IMPORTS + STOCKCHA + EXPORTS (negative) + Bunkers (negative)

        TES.INDPROD        "Production: Total primary energy production (Mtoe)"
        TES.IMPORTS        "Imports"
        TES.STOCKCHA       "Stock changes"
        TES.EXPORTS        "Exports"
        TES.AVBUNK         "International aviation bunkers (Kerosene Jet)"
        TES.MARBUNK        "International marine bunkers (Fuel oil)"

*        TES_2nd.TFC        "Total final consumption"  --> to be substracted
        TES_2nd.TOTENGY    "Energy industry own use"
        TES_2nd.TOTTRANF   "Transformation processes"
        TES_2nd.STATDIFF   "Statistical differences"
        TES_2nd.DISTLOSS   "Losses in energy distribution, transmission and transport"
        TES_2nd.TRANSFER   "interproduct transfers, products transferred & recycled products"

*   " Domestic supply" for WBES

        DOMSUP.INDPROD        "Production"
        DOMSUP.OSCOAL         "From other sources - coal"
        DOMSUP.OSNATGAS       "From other sources - natural gas"
        DOMSUP.OSOIL          "From other sources - oil products"
        DOMSUP.OSRENEW        "From other sources - renewables"
        DOMSUP.OSNONSPEC      "From other sources - non-specified"
        DOMSUP.STOCKCHA       "Stock changes                                "
        DOMSUP.EXPORTS        "Exports                                      "
        DOMSUP.AVBUNK         "International aviation bunkers (Kerosene Jet)"
        DOMSUP.MARBUNK        "International marine bunkers (Fuel oil)      "

    /

    TES(EEB_Flow)  / TES /
    TFC(EEB_Flow)  / TFC, DOMSUP  /

    MAINELEC(EEB_Flow) "Electricity Flows" /
        MAINELEC       "Main activity producer electricity plants "
        AUTOELEC       "Autoproducer electricity plants           "
        MAINCHP        "Main activity producer CHP plants#"
        AUTOCHP        "Autoproducer CHP plants                   "
    /
    NOTMAINELEC(EEB_Flow) / AUTOELEC, MAINCHP, AUTOCHP /

    MAINHEAT(EEB_Flow) "Heat Flows" /
        MAINHEAT       "Main activity producer heat plants"
        AUTOHEAT       "Autoproducer heat plants"
    /

    ELOUTPUTdetail(EEB_Flow) "GWh generated by power plants"
        / ELAUTOC, ELAUTOE, ELMAINC, ELMAINE, MHYDPUMP, AHYDPUMP /

    HEATOUTdetail(EEB_Flow) "heat generated by plants"
        / HEAUTOC, HEAUTOH, HEMAINC, HEMAINH /

    EEBOUTPUT(EEB_Flow) /
        ELOUTPUT  "Electricity output (GWh)"
        HEATOUT   "Heat output"
    /

    EEBkeepELHEATdetail(EEB_Flow) "Keep Power details"/
        MAINHEAT, MAINELEC,	EPOWERPLT,
        EXPORTS, IMPORTS,
        ELOUTPUT, HEATOUT, TES, INDPROD, STOCKCHA, STATDIFF
    /
;

*Execute_unload "V:\CLIMATE_MODELLING\results\2023_02_13_EEB_Flow.gdx", EEB_Flow;