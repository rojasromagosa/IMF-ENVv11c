$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] project V1  - Aggregation procedure
    GAMS file   : 01c-map_EEB_to_GTAP_Product.gms
    purpose     : Define set map_EEBProduct_i0(EEB_Product,i0)
                  to map EEB products to GTAP commodities
    created date: 6 Juin 2017
    created by  : Jean Chateau
    called by   : "%SetsDir%\setIEA\setIEA.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/common_sets/setIEA/01c-map_EEB_to_GTAP_Product.gms $
   last changed revision: $Rev: 339 $
   last changed date    : $Date:: 2023-06-22 #$
   last changed by      : $Author: chateau_j $
--------------------------------------------------------------------------------
 From GTAP10 Documentation Chapter 11 - An Energy Data Base for GTAP
    by Robert McDougall and Maksym Chepeliev
--------------------------------------------------------------------------------

$OffText

$OnText
    TO BE CHECKED BECAUSE SOME CATEGORIES COULD BE ALLOCATED TO DIFFERENT PRODUCT
    Example bio-fuels and COMRENEW categories
    For Now contralily to GTAP in assume that Heat is allocated to gdt

    allocate solid biofuel with Biomass
    allocate waste biofuel with Waste
    allocate liquid biofuel with BioFuel
    allocate additive with crp

    # pas dans EEB

    En fait Energies secondaires (nrg 2nd) sont telles que WBIG_gtap(EEB_Product,"INDPRO",t) = 0;

    unallocated: Total, MRENEW, ORIMUL (not in EEB)

    *c : mapped with aggregate Coal cat. for EEB

$OffText

$SetGlobal EEBMapChoice "GTAP"

set map_EEBProduct_i0(EEB_Product,i0) "map EEB products to GTAP commodities" /

*   Coal

    ANTCOAL.COA   "Anthracite"
    BITCOAL.COA   "Other bituminous coal"
    COKCOAL.COA   "Coking coal"
    LIGNITE.COA   "Lignite"
    SUBCOAL.COA   "Sub-bituminous coal"
    HARDCOAL.COA  "Hard coal  (if no detail) - Useless: Only for old years"
    BROWN.COA     "Brown coal (if no detail) - Useless: Only for old years"

* All these below with Coal for EEB and GTAP (Notice we could put PEAT with Biomass)

    $$IFi %EEBMapChoice%=="GTAP" (PEAT,PEATPROD).COA "Peat/tourbe (PEATPROD nrg 2nd)"
    $$IFi %EEBMapChoice%=="GTAP" BKB.COA     "brown Coal/peat briquettes (nrg 2nd)"
    $$IFi %EEBMapChoice%=="GTAP" PATFUEL.COA "Patent fuel (nrg 2nd)"

*   Natural gas

    NATGAS.GAS  "Natural Gas"

    $$IFi %EEBMapChoice%=="GTAPOLD" NGL.OIL       "Natural gas liquids (with Crude Oil For EEB)"
    $$IFi %EEBMapChoice%=="GTAPOLD" GASWKSGS.gdt  "Gas works gas (nrg 2nd) - with Coal for EEB"

*    $$IFi %EEBMapChoice%=="GTAP"    NGL.GAS       "Natural gas liquids"
*    $$IFi %EEBMapChoice%=="GTAP"    GASWKSGS.GAS  "Gas works gas (nrg 2nd) *c"
    $$IFi %EEBMapChoice%=="GTAP"    NGL.GDT       "Natural gas liquids"
    $$IFi %EEBMapChoice%=="GTAP"    GASWKSGS.GDT  "Gas works gas (nrg 2nd) *c"


*   Crude oil

    CRUDEOIL.OIL    "Crude oil"
    $$IFi %EEBMapChoice%=="GTAPOLD" REFFEEDS.OIL "Refinery feedstocks (nrg 2nd)"
    OILSHALE.OIL "Oil shale and oil sands "
    NONCRUDE.OIL "Other hydrocarbons  (Shale, tar sands,...) "
    $$IFi %EEBMapChoice%=="GTAPOLD" CRNGFEED.OIL "Crude-NGL-feedstocks (if no detail) (nrg 2nd)"

*   Refined Petroleum products (secondary energy)

    $$IFi %EEBMapChoice%=="GTAPOLD" BKB    .P_C  "BKB-peat briquettes (nrg 2nd) *c"
    $$IFi %EEBMapChoice%=="GTAPOLD" PATFUEL.P_C  "Patent fuel (nrg 2nd) *c"
    OVENCOKE.P_C               "Coke oven coke (nrg 2nd) *c"
    GASCOKE .P_C               "Gas coke (nrg 2nd) *c"
    $$IFi %EEBMapChoice%=="GTAP" COKEOVGS.P_C "Coke oven gas (nrg 2nd) *c"
    $$IFi %EEBMapChoice%=="GTAP" REFFEEDS.P_C "Refinery feedstocks (nrg 2nd)"
    REFINGAS.P_C               "Refinery gas (nrg 2nd)"
    ETHANE  .P_C               "Ethane (nrg 2nd)"
    LPG     .P_C               "Liquefied petroleum gases (LPG) (nrg 2nd)"
    MOTORGAS.P_C               "Motor gasoline# (nrg 2nd)"
    NONBIOGASO.P_C             "Motor gasoline (nrg 2nd)"
    JETGAS  .P_C               "Gasoline type jet fuel (nrg 2nd)"
    AVGAS   .P_C               "Aviation gasoline (nrg 2nd)"
    JETKERO .P_C               "Kerosene type jet fuel# (nrg 2nd)"
    NONBIOJETK.P_C             "Kerosene type jet fuel(nrg 2nd)"
    OTHKERO.P_C                "Other Kerosene (nrg 2nd)"
    (NONBIODIES,GASDIES).P_C   "Gas-diesel oil (nrg 2nd)"
    NAPHTHA.P_C                "Naphtha  (nrg 2nd)"
    WHITESP.P_C                "White spirit & SBP  (nrg 2nd)"
    LUBRIC.P_C                 "Lubricants (nrg 2nd)"
    BITUMEN .P_C               "Bitumen (nrg 2nd)"
    PARWAX.P_C                 "Paraffin waxes (nrg 2nd)"
    PETCOKE.P_C                "Petroleum coke (nrg 2nd)"
    ONONSPEC.P_C               "Non-specified oil products (nrg 2nd)"

    $$IFi %EEBMapChoice%=="GTAP" CRNGFEED.P_C "Crude-NGL-feedstocks (if no detail) (nrg 2nd)"

* [TBC]

    OXYSTGS.COA                "Other recovered gases# (nrg 2nd)"
    COALTAR.COA                "Coal tar (with Coal For EEB) (nrg 2nd)"
    RESFUEL.P_C                "Fuel oil (nrg 2nd)"

*   Electricity (non combustible)

    $$IfTheni.power %ifPower%=="ON"
        NUCLEAR.NuclearBL          "Nuclear"
        HYDRO.HydroBL              "Hydro"
        (SOLARPV,SOLARTH).SolarP   "Solar photovoltaics and Solar thermal"
        WIND.WindBL                "Wind"
        GEOTHERM.OtherBL           "Geothermal"
        TIDE.OtherBL               "Tide wave and ocean"
    $$ELSE.power
        (NUCLEAR,HYDRO,SOLARPV,SOLARTH,WIND,GEOTHERM,TIDE).ELY
    $$ENDIF.power

    $$IFi %EEBMapChoice%=="GTAP" HEAT  .Heat  "Heat output (nrg 2nd)"
    $$IFi %EEBMapChoice%=="GTAP" HEATNS.Heat  "Heat output from non-specified combustible fuels (nrg 2nd)"

*   TnD of gases and Heat

* Coke oven gas is obtained as a by-product of the manufacture of coke oven
* coke for the production of iron and steel.
* Here with gdt because secondary energy

    $$IFi %EEBMapChoice%=="GTAPOLD" COKEOVGS.gdt  "Coke oven gas (with Coal For EEB) (nrg 2nd)"

* Blast furnace gas is produced during the combustion of coke in blast furnaces
* in the iron and steel industry. (discarded in GTAP10)

    BLFURGS .gdt  "Blast furnace gas (nrg 2nd) *c"
    OGASES  .gdt  "Other recovered gases (nrg 2nd) *c"

    $$IFi %EEBMapChoice%=="GTAPOLD" HEAT  .gdt  " Heat output (nrg 2nd)"
    $$IFi %EEBMapChoice%=="GTAPOLD" HEATNS.gdt  " Heat output from non-specified combustible fuels (nrg 2nd)"

    $$IfTheni.power %ifPower%=="ON"
        ELECTR.Electricity   "Electricity (nrg 2nd)"
    $$ELSE.power
        ELECTR.Electricity   "Electricity (nrg 2nd)"
    $$ENDIF.power

    MANGAS.Heat  "Elec - heat output from non-specified manufactured gases (nrg 2nd)"

*   Biofuel and waste (discarded in GTAP10)

    CHARCOAL.Biomass  "Charcoal (nrg 2nd)"
    SBIOMASS.Biomass  "Primary solid biofuels# (nrg 2nd)"

*   Biogases are gases arising from the anaerobic fermentation of biomass
* (discarded in GTAP10)

    GBIOMASS.Biogas         "Biogases from biomass# (nrg 2nd)"
    BIOGASES.Biogas         "Biogases"
    BIOJETKERO.BioFuel      "Bio jet kerosene (nrg 2nd)"
    RENEWNS.Biomass         "Non-specified primary biofuels and waste (nrg 2nd)"

*   Primary energy (discarded in GTAP10)

    BIOGASOL .BioFuel      "Biogasoline"
    BIODIESEL.BioFuel      "Biodiesels"
    OBIOLIQ  .BioFuel      "Other liquid biofuels"
    PRIMSBIO .Biomass      "Primary solid biofuels"
    INDWASTE .Waste        "Industrial waste               "
    MUNWASTEN.Waste        "Municipal waste (non-renewable)"
    MUNWASTER.Waste        "Municipal waste (renewable)"

* ADDITIVE: considered as primary but traded (discarded in GTAP10)
* Additives are non-hydrocarbon substances added to or blended with a product
* to modify its properties, for example, to improve its combustion characteristics.
* Alcohols and ethers (MTBE, methyl tertiary-butyl ether)
* and chemical alloys such as tetraethyl lead are included here.
* considered as primary but traded

   $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
       ADDITIVE.chm       "Additives-blending component"
   $$else.gtap10
       ADDITIVE.crp       "Additives-blending component"
   $$endif.gtap10

*   Categories from ipcc2006 database:

    COAL.COA    "Coal, peat and oil shale (ipcc2006 database)"
    OIL.P_C     "OIL+RefOil (ipcc2006 database)"
    Other.Waste "Other sources (includes industrial waste and non-renewable municipal waste)"

/ ;

*Execute_unload "map_EEBProduct_i0", map_EEBProduct_i0;
