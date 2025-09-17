$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] project V.1.  - Aggregation procedure
    GAMS file   : "%SetsDir%\setIEA\Add_IEA_Flows_to_Set_a0.gms"
    purpose     : add additional elements from IEA EEB & WEO to GTAP set "a0"
                  elments that are used for IEA-energy data manipulations
    Created by  : Jean Chateau
    created Date: 2023-02-21
    called by   : "%SatDataDir%\Build_Scenario.gms"
               or "%SatDataDir%\Energy\Export_IEA-WEO_to_GTAP\1-preamble.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/common_sets/setIEA/Add_IEA_Flows_to_Set_a0.gms $
   last changed revision: $Rev: 339 $
   last changed date    : $Date:: 2023-06-22 #$
   last changed by      : $Author: chateau_j $
--------------------------------------------------------------------------------
    Memo:
        TES = INDPROD + IMPORTS + EXPORTS (<0) - MARBUNK - AVBUNK +/- STOCKCHA

        TRANSFER: Comprises interproduct transfers, products transferred
                  and recycled products.
                  = TFC - TOTENGY

        STATDIFF: Statistical differences:
                TPES + STATDIFF = TFC - (TOTENGY + DISTLOSS +  TOTTRANF)
--------------------------------------------------------------------------------
$OffText

TES             "IEA-EEB: Total energy supply"

INDPROD         "IEA-EEB: Production of primary energy"
IMPORTS         "IEA-EEB: Imports"
EXPORTS         "IEA-EEB: Exports (negative)"
AVBUNK          "IEA-EEB/EDGAR: International aviation bunkers"
MARBUNK         "IEA-EEB/EDGAR: International marine bunkers"
STOCKCHA        "IEA-EEB: Stock changes"
TRANSFER        "IEA-EEB: Transfers"
STATDIFF        "IEA-EEB: Statistical differences"

DISTLOSS        "IEA-EEB: Losses in energy distribution, transmission and transport"

PetFeedStock    "IEA-WEO&EEB: Feedstock use in petrochemical industry"
BlastCokeOvens  "IEA-WEO&EEB: Energy industry own use and Transformation: Blast furnaces & Coke ovens"
OTHTRANS        "IEA-WEO: OTHER transformations of energy"
ONONNRGUSE      "IEA-WEO: Other Non Energy Use than Feedstock petrochemical industry"
PLDV            "IEA-WEO: Transportation: Road - PLDV"
RAIL            "IEA-WEO: Transportation: Rail"
PIPELINE        "IEA-WEO: Transportation: Pipeline"
NonPLDV         "IEA-WEO: Transportation: Road Non-PLDV"
TRNUNSP         "IEA-WEO: Transportation: Non-specified"

* itlbunk         "International bunkers"
