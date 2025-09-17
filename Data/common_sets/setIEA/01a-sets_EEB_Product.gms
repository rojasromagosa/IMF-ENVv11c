$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] Model :  Aggregation Procedure
    GAMS file   : 01a-sets_EEB_Product.gms
    purpose: IEA: Extended Energy Balance (WBIG) sets for Products
    created date: 6 Juin 2017
                    --> Modified 2019-09-23
                    --> last checked : 15 Fevrier 2023
    created by  : Jean Chateau
    called by   : %DataDir%\common_sets\setIEA.gms"
--------------------------------------------------------------------------------
   file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
   last changed revision: $Rev: 230 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------

    Energy Product in IEA-EEB (thousand tonnes of oil equivalent ktoe)

    EEB_Product: 81 Products but some are Inactive or used in other Dataset
    true number is 68

    Inactive:
        GASDIES     Gas-diesel oil
        GBIOMASS    Biogases
        JETKERO     Kerosene type jet fuel
        MOTORGAS    Motor gasoline
        OXYSTGS     Other recovered gases
        SBIOMASS    Primary solid biofuels
--------------------------------------------------------------------------------
$OffText

set EEB_Product "Energy Product in IEA Extended Energy Database (thousand tonnes of oil equivalent ktoe)"  /

*------------------------------------------------------------------------------*
*                        Coal and peat                                         *
*------------------------------------------------------------------------------*

*    Primary Coal

    HARDCOAL       " Hard coal (if no detail)    "
    BROWN          " Brown coal (if no detail)   "
    ANTCOAL        " Anthracite                  "
    COKCOAL        " Coking coal                 "
    BITCOAL        " Other bituminous coal       "
    SUBCOAL        " Sub-bituminous coal         "
    LIGNITE        " Lignite                     "

*    Secondary Coal

    PATFUEL        " Patent fuel                 "
    OVENCOKE       " Coke oven coke              "
    GASCOKE        " Gas coke                    "
    COALTAR        " Coal tar                    "
    BKB            " BKB (brown Coal Briquettes) - peat briquettes"
    COKEOVGS       " Coke oven gas     (TJ)      "
    BLFURGS        " Blast furnace gas           "
    OXYSTGS        " Other recovered gases (TJ)  "
    OGASES         " Other recovered gases (TJ)  "

    PEAT           " Peat                        "
    PEATPROD       " Peat products               "

    MANGAS         "Elec - heat output from non-specified manufactured gases"
    GASWKSGS       "Gas works gas (TJ)"

*------------------------------------------------------------------------------*
*                        Natural Gas                                           *
*------------------------------------------------------------------------------*

* Note It excludes natural gas liquids. contrarily to GTAP
    NATGAS         " Natural Gas"

*------------------------------------------------------------------------------*
*                           Oil shale                                          *
*------------------------------------------------------------------------------*
    OILSHALE       " Oil shale and oil sands "

*------------------------------------------------------------------------------*
*                  Crude + NGL + refinery feedstocks                           *
*------------------------------------------------------------------------------*

*    Crude Oil / Primary oil
* Note that NGL is with Natural Gas in GTAP database

    NGL            " Natural gas liquids"
    CRNGFEED       " Crude-NGL-feedstocks (if no detail)"
    CRUDEOIL       " Crude oil                          "
    REFFEEDS       " Refinery feedstocks                "
    ADDITIVE       " Additives-blending components      "

*    Oil Products
* Note: NONCRUDE includes synthetic crude oil from tar sands, shale oil, etc.,
*liquids from coal liquefaction, output of liquids from natural gas conversion
*into gasoline and hydrogen.

    NONCRUDE       " Other hydrocarbons  (Shale, tar sands,...) "
    REFINGAS       " Refinery gas                               "
    ETHANE         " Ethane                                     "
    LPG            " Liquefied petroleum gases (LPG)            "
    MOTORGAS       " Motor gasoline                             "
    NONBIOGASO     " Motor gasoline excl. biofuels              "
    AVGAS          " Aviation gasoline                          "
    JETGAS         " Gasoline type jet fuel                     "
    JETKERO        " Kerosene type jet fuel                     "
    NONBIOJETK     " Kerosene type jet fuel excl. biofuels      "
    OTHKERO        " Other Kerosene                             "
    GASDIES        " Gas-diesel oil                             "
    NONBIODIES     " Gas-diesel oil excl. biofuels              "
    RESFUEL        " Fuel oil                                   "
    NAPHTHA        " Naphtha                                    "
    WHITESP        " White spirit & SBP                         "
    LUBRIC         " Lubricants                                 "
    BITUMEN        " Bitumen                                    "
    PARWAX         " Paraffin waxes                             "
    PETCOKE        " Petroleum coke                             "
    ONONSPEC       " Other oil products                         "

*------------------------------------------------------------------------------*
*           Biofuels and waste: Ktoe in WBIG but TJ in WBES                    *
*------------------------------------------------------------------------------*

* memo BIODIESEL & BIOGASOL sont produit par "p_c" dans ISIC 4

* distribution de petrole --> "trd"

* Solid Biomass est produit par agr. and forestry

* MUNWASTER / MUNWASTEN / NDWASTE: --> incineration
*   Municipal waste produced by households, industry, hospitals
*   and the tertiary sector collected by local authorities
*   for incineration at specific installations.
*   Municipal waste is split into renewable and non-renewable.

* Biogases are gases arising from the anaerobic fermentation
* of biomass and the gasification of solid biomass (including biomass in wastes)

    INDWASTE       "Industrial waste"
    MUNWASTEN      "Municipal waste (non-renewable)"
    MUNWASTER      "Municipal waste (renewable)"
    SBIOMASS       "Primary solid biofuels"
    PRIMSBIO       "Primary solid biofuels"
    GBIOMASS       "Biogases from biomass"
    BIOGASES       "Biogases"
    BIOGASOL       "Biogasoline"
    BIODIESEL      "Biodiesels"
    OBIOLIQ        "Other liquid biofuels"
    RENEWNS        "Non-specified primary biofuels and waste"
    CHARCOAL       "Charcoal"
    BIOJETKERO     "Bio jet kerosene"

*------------------------------------------------------------------------------*
*                       Electricity and heat                                   *
*------------------------------------------------------------------------------*

    HEATNS         " Heat output from non-specified combustible fuels  "
    NUCLEAR        " Nuclear                                           "
    HYDRO          " Hydro                                             "
    GEOTHERM       " Geothermal   (TJ)                                 "
    SOLARPV        " Solar photovoltaics                               "
    SOLARTH        " Solar thermal   (TJ)                              "
    TIDE           " Tide wave and ocean                               "
    WIND           " Wind                                              "
    ELECTR         " Electricity                                       "

*    MRENEW = {HYDRO,GEOTHERM,SOLARPV,SOLARTH,TIDE,WIND,
*    MUNWASTER,PRIMSBIO,BIOGASES,BIOGASOL,BIODIESEL,OBIOLIQ,RENEWNS,CHARCOAL}
    MRENEW         "Memo: Renewables"


* For GTAP Heat is with Electricity but could be with gdt

* memo: Emulsified oil made of water and natural bitumen

    HEAT     "Heat"
    OTHER    "Other sources (includes industrial waste and non-renewable municipal waste)"
    TOTAL    "Total of all energy sources"
    ORIMUL   "Emulsified oils (e.g. Orimulsion): IEA BIGCO2 dataset"
    HEATPUMP
    BOILER
    CHEMHEAT

*------------------------------------------------------------------------------*
* Additional Fuel for IPCC Fuel Combustion Emissions Dataset (2006 Guidelines) *
*------------------------------------------------------------------------------*

* {COAL,NATGAS,OIL,OTHER,TOTAL)

    COAL    "Coal, peat and oil shale"
    OIL     "OIL+RefOil"

/;

*------------------------------------------------------------------------------*
*                                                                              *
*                            SubSets for EEB_Product                           *
*                                                                              *
*------------------------------------------------------------------------------*

SETS

    PRIMARY(EEB_Product) "primary energy" /

        HARDCOAL       " Hard coal (if no detail) "
        BROWN          " Brown coal (if no detail)"
        PEAT           " Peat  "
        OILSHALE       " Oil shale and oil sands"
        CRUDEOIL       " Crude oil"
        NGL            " Natural gas liquids "
        NATGAS         " Natural Gas"

* biofuels and waste

        INDWASTE       " Industrial waste                "
        MUNWASTEN      " Municipal waste (non-renewable) "
        MUNWASTER      " Municipal waste (renewable)     "
        SBIOMASS       " Primary solid biofuels          "
        PRIMSBIO       " Primary solid biofuels          "
        GBIOMASS       " Biogases                        "
        BIOGASES       " Biogases                        "
        BIOGASOL       " Biogasoline                     "
        BIODIESEL      " Biodiesels                      "

        NUCLEAR        " Nuclear                         "
        HYDRO          " Hydro                           "
        GEOTHERM       " Geothermal                      "
        SOLARPV        " Solar photovoltaics             "
        SOLARTH        " Solar thermal                   "
        TIDE           " Tide wave and ocean             "
        WIND           " Wind                            "

*--- Logically: heat from heat pumps that is extracted from the ambient environment
        HEAT           " Heat "
    /
    coal_extr(EEB_Product) /
        ANTCOAL        " Anthracite              "
        COKCOAL        " Coking coal             "
        BITCOAL        " Other bituminous coal   "
        SUBCOAL        " Sub-bituminous coal     "
        LIGNITE        " Lignite                 "
        PEAT           " Peat                    "
        PEATPROD       " Peat products           "
    /
    conv_oil(EEB_Product) /
        CRUDEOIL       " Crude oil                        "
        NGL            " Natural gas liquids              "
        REFFEEDS       " Refinery feedstocks              "
        ADDITIVE       " Additives-blending components    "
    /
    nconv_oil(EEB_Product) /
        NONCRUDE       " Other hydrocarbons  (Shale, tar sands,...)  "
        OILSHALE       " Oil shale and oil sands                     "
    /
    MRENEW(EEB_Product) / HYDRO,GEOTHERM,SOLARPV,SOLARTH,TIDE,WIND,
                            MUNWASTER,PRIMSBIO,BIOGASES,BIOGASOL,
                            BIODIESEL,OBIOLIQ,RENEWNS,CHARCOAL /

    genelect  Type energie primaire entrant dans production electricite pour projection WEO /
        Gaz        " 1.  Gaz prod & distrib"
        oil        " 2.  Petrole brut et raffine"
        Hydro      " 3.  Energie hydraulique"
        Coal       " 4.  Charbon"
        Nucl       " 5.  Nucleaire"
        biomwas    " 6.  Biomasse et dechets recycle"
        OtherR     " 7.  Ressources renouvelables hors hydro"
        wind       " 8.  Eolien (ss categorie de OtherR) "
        Geoterm    " 9.  Geothermie (ss categorie de OtherR)"
        solar      " 10. Solaire (ss categorie de OtherR)"
        Tide       " 11. Energie maremotrice (ss categorie de OtherR)"
        Total_gen
    /

    fossil(EEB_Product) /
        ADDITIVE
        ANTCOAL
        AVGAS
        BITCOAL
        BITUMEN
        BKB
        BLFURGS
        BROWN
        COALTAR
        COKCOAL
        COKEOVGS
        CRNGFEED
        CRUDEOIL
        ETHANE
        GASCOKE
        GASWKSGS
        HARDCOAL
        INDWASTE
        JETGAS
        LIGNITE
        LPG
        LUBRIC
        MANGAS
        MUNWASTER
        NAPHTHA
        NATGAS
        NGL
        NONBIODIES
        NONBIOGASO
        NONBIOJETK
        NONCRUDE
        OGASES
        OILSHALE
        ONONSPEC
        OTHKERO
        OVENCOKE
        PARWAX
        PATFUEL
        PEAT
        PEATPROD
        PETCOKE
        REFFEEDS
        REFINGAS
        RESFUEL
        SUBCOAL
        WHITESP
    /

    nonfossil(EEB_Product)  /
        BIODIESEL
        BIOGASES
        BIOGASOL
        BIOJETKERO
        CHARCOAL
        ELECTR
        GEOTHERM
        HEATNS
        HYDRO
        MUNWASTEN
        NUCLEAR
        OBIOLIQ
        OTHER
        PRIMSBIO
        RENEWNS
        SOLARPV
        SOLARTH
        TIDE
        WIND
    /

;

* Execute_unload "V:\CLIMATE_MODELLING\results\2023_02_13_EEB_Product.gdx", EEB_Product;