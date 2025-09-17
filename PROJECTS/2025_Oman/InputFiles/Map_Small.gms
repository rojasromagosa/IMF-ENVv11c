$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] Model version 1 -- Data preparation modules
   name        : "%iFilesDir%\Map.gms.gms"
   purpose     : Set definitions and aggregation Mapping
                 for the project "2023_OCDE_Base"
   created date: 2022-09-20
   created by  : Jean Chateau
   called by   : "%DataDir%\AggGTAP.gms" and "%DataDir%\filter.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/GenericProject/InputFiles/Map.gms $
   last changed revision: $Rev: 380 $
   last changed date    : $Date:: 2023-08-30 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
 Note that this file is used for mapping all 2022_OECD_PROJECTS
--------------------------------------------------------------------------------
$OffText

$SetGlobal DYN          "ON"
$SetGlobal NCO2         "ON"
$SetGlobal ELAST        "OFF"
$SetGlobal LAB          "OFF"
$SetGlobal BoP          "OFF"
$SetGlobal SAVEMAP      "TXT"
$SetGlobal LU           "OFF"
$SetGlobal ifMRIO       "OFF"
$SetGlobal ifR_D        "OFF"
$SetGlobal DEPL         "OFF"
$SetGlobal ifGENDER     "OFF"
$SetGlobal ifDamagesOAP "OFF"
$SetGlobal EDGARData    "OFF"

*  Desired level of the advanced technologies: 0.01 = 10 000 USD

Scalar AdvElyscale / 0.0 /;

* Default sectoral aggregation is %SectorAgg%=="Small"

$If NOT SET split_gas $SetGlobal split_gas "OFF"
$If NOT SET split_lvs $SetGlobal split_lvs "OFF"
$If NOT SET split_acr $SetGlobal split_acr "OFF"
$If NOT SET split_oma $SetGlobal split_oma "OFF"
$If NOT SET split_ser $SetGlobal split_ser "OFF"

* Default values for large sector aggregation

$IfTheni.LargeAgg %SectorAgg%=="Large"
    $$SetGlobal split_gas "ON"
    $$SetGlobal split_lvs "ON"
    $$SetGlobal split_acr "ON"
    $$SetGlobal split_oma "ON"
    $$SetGlobal split_ser "ON"
$Endif.LargeAgg

* [EditJean]: pour le moment je mets ici car on en a besoin pour aggreg
* [EditJean]: we should get rid of this

* Choose a nesting for Land bundles (Only if %split_acr%=="ON")

$Ifi %split_acr%=="OFF" $SetGlobal LandBndNest "OneBundle"
$Ifi %split_acr%=="ON"  $SetGlobal LandBndNest "MAGNET"

$IF NOT SET split_skill $SetGlobal split_skill "1"

* Define aggregation for Gcub aggregated sectors

$If NOT SET GcubbedIa $SetGlobal GcubbedIa "OFF"

* Desaggregate Ely Commodity (only in case of power data)

$SetGlobal IfElyGoodDesag "OFF"

* safety instruction

$IFi %ifPower%=="OFF" $SetGlobal IfElyGoodDesag "OFF"

* [EditJean]: by default these flags are defined in AggGTAP.gms according to
* the GTAP database used, so only needed if for example we use GTAP-Power but
* want to aggregate all Power Data
*$SetGlobal IfPower   "ON"
*$SetGlobal IfWater   "OFF"

*  these global variables are used to override GTAP parameters for Env model
* this is inactive [TBU]

$SetGlobal OVRRIDEGTAPARM 0
$SetGlobal OVRRIDEGTAPINC 0

* This folder contents generic sets

$SetGlobal sDir "%FolderPROJECTS%\GenericSets"

*------------------------------------------------------------------------------*
*  Select a labor option
*------------------------------------------------------------------------------*
$OnText
    Valid options are:
    noLab        : ignore employment volumes (all wages are set to 1)
    agLab        : calculate ag and non-ag employment (wages uniform within zones)
    allLab       : assume employment data is correct for each sector
                    (wages differ for each sector)
    allLabTerrie : assume employment data is correct for each sector
                    (wages differ for each sector): Terrie data
    giddLab      : Use the GIDD labor data
$OffText

$SetGlobal IFLABOR "noLab"

*------------------------------------------------------------------------------*
*                                                                              *
*                             SET DEFINITIONS                                  *
*                                                                              *
*------------------------------------------------------------------------------*
$OnEmpty

SETS

*------------------------------------------------------------------------------*
*                             Regional sets                                    *
*------------------------------------------------------------------------------*

    r  "%BaseName% regions" /
        $$batinclude "%sDir%\rAgg%RegionalAgg%.gms" "define_region"
    /

* >>>> MUST INSERT RESIDUAL REGION (ONLY ONE)
    rres(r) "Residual region"   /  usa "United States of America" /

* >>>> MUST INSERT MUV/Numeraire regions (ONE OR MORE)
    rmuv(r) "MUV regions" /
        $$batinclude "%sDir%\rAgg%RegionalAgg%.gms" "rmuv"
    /

*------------------------------------------------------------------------------*
*               Original Activities and Commodities (based on GTAP agg.)       *
*------------------------------------------------------------------------------*

* OECD-ENV The aggregation procedure need ely to map energy projections
* to model, but this element "ely" is not mapped with i0

    a  "Original activities (included cgds)" /

        $$batinclude "%sDir%\sAggGeneric.gms" "define_act" "%IfPower%"

*   Add "ely" commodity to the set a if Power is aggregated in the commodity set

        $$IFi %IfElyGoodDesag%=="OFF" "ely"

        cgds           "Capital goods"
      /

    cgds(a) "Capital goods" / cgds "Capital goods"/

    i(a)  "Original Commodities (like a but excluded cgds)" /
        $$batinclude "%sDir%\sAggGeneric.gms" "define_act" "%IfPower%"
    /

*   [OECD-ENV]: additional working sets

    sely(i) "Power sectors (including T&D)" /
        $$batinclude "%sDir%\power.gms" "" "ON"
    /
    tmpely(a) "Temporary element for ely commmodity set used for energy projection" /
        $$Ifi %ifPower%=="ON" "ely"
    /

    mapt(a) "Merge land and capital payments in the following sectors" / /
    mapn(a) "Merge natl. res. and capital payments in the following sectors" / /

*------------------------------------------------------------------------------*
*               Sets for primary Factors of Production (fp)                    *
*------------------------------------------------------------------------------*
    fp  "Factors of production"  /
        $$Ifi %split_skill%=="2" UnSkLab "Unskilled labor"
        $$Ifi %split_skill%=="2" SkLab   "Skilled labor"
        $$Ifi %split_skill%=="1" Labour  "Total Labour Force"
                                 Capital "Capital"
                                 NatRes  "Natural resource"
* [EditJean]: New Flags by DvM
        $$iftheni.ifLU "%LU%" == "ON"
            AEZ1 "LGP000 060"
            AEZ2 "LGP060 119"
            AEZ3 "LGP120 179"
            AEZ4 "LGP180 239"
            AEZ5 "LGP240 299"
            AEZ6 "LGP300PLUS"
        $$else.ifLU
            Land "Land"
        $$endif.ifLU
      /
   l(fp)  "Categories of workers" /
        $$Ifi %split_skill%=="2" UnSkLab "Unskilled labor"
        $$Ifi %split_skill%=="2" SkLab   "Skilled labor"
        $$Ifi %split_skill%=="1" Labour  "Total Labour Force"
      /
   ul(l) "Unksilled labor (substitute to capital)" /
        $$Ifi %split_skill%=="2" UnSkLab "Unskilled labor"
        $$Ifi %split_skill%=="2" SkLab   "Skilled labor"
        $$Ifi %split_skill%=="1" Labour  "Total Labour Force"
      /
   lr(l) "Reference labor for skill premium" /
        $$Ifi %split_skill%=="2" SkLab   "Skilled labor"
        $$Ifi %split_skill%=="1" Labour  "Total Labour Force"
      /
* [EditJean]: New sets by DvM
$OnText
    wb "Intermediate labor bundle(s)" / Single "Single intermediate labor bundle" /
    maplab1(wb) "Mapping of intermediate labor demand bundle(s) to LAB1" / Single  /
    mapl(wb,l) "Mapping of labor categories to intermedate demand bundle(s)" / Single.(UnSkLab, SkLab) /
$OffText

   cap(fp) "Capital" /  Capital "Capital" /
   lnd(fp) "Land endowment" /
* [EditJean]: New Flags by DvM
        $$IfTheni.ifLU "%LU%" == "ON"
            AEZ1 "LGP000 060"
            AEZ2 "LGP060 119"
            AEZ3 "LGP120 179"
            AEZ4 "LGP180 239"
            AEZ5 "LGP240 299"
            AEZ6 "LGP300PLUS"
        $$Else.ifLU
            Land "Land"
        $$EndIf.ifLU
      /
   nrs(fp) "Natural resource" /  NatRes "Natural resource"   /
*   $Ifi %ifWater%=="ON"
    wat(fp) "Water resource" /    /

*------------------------------------------------------------------------------*
*           Segmented Labor Market: Rural vs Urban activities                  *
*  zonal mapping is for labor/volume splits between rural and urban activities *
*------------------------------------------------------------------------------*

* [EditJean] pourquoi on ne mets pas frs?
* faudrait faire ca dans Model mais on en a besoin pour calculer omegam0(r,l)

    mapz(z,a) "Mapping of activities to zones" /
        $$IfTheni.SplitCrops %split_acr%=="ON"
            rur.(pdr,wht,gro,v_f,osd,c_b,pfb,ocr)
        $$Else.SplitCrops
            rur.cro
        $$Endif.SplitCrops
        $$IfTheni.SplitLvs %split_lvs%=="ON"
            rur.(cow,nco)
        $$Else.SplitLvs
            rur.lvs
        $$Endif.SplitLvs
    /
;

mapz("urb",i) = not mapz("rur",i) ;
mapz("nsg",i) = yes ;

*------------------------------------------------------------------------------*
*                        MAPPINGS TO GTAP DATABASE                             *
*------------------------------------------------------------------------------*


SETS

* Mapping of model regions "r" to GTAP regions "r0"

    maprtmp(r,r0) "tmp region mapping (envers)" /
        $$batinclude "%sDir%\rAgg%RegionalAgg%.gms" "region_mapping"
    /
    mapr(r0,r)  "Mapping of GTAP regions to model regions"

* Mapping of GTAP sectors "a0" to Model sectors "a"

    mapa(a0,a) "Mapping of GTAP to Model sectors" /
        $$batinclude "%sDir%\sAggGeneric.gms" "define_mapa"
    /

* Mapping of GTAP production factor "fp0" to Model sectors "fp"

    mapf(fp0,fp) "Mapping of GTAP to Model production factor" /
        $$Ifi %split_skill%=="2"  (ag_othlowsk,service_shop,clerks) . UnSkLab
        $$Ifi %split_skill%=="2"  (tech_aspros,off_mgr_pros)        . SkLab
        $$Ifi %split_skill%=="1" (service_shop,ag_othlowsk,clerks,off_mgr_pros,tech_aspros). Labour
        Capital      . Capital
        $$iftheni.ifLU "%LU%" == "ON"
            Land . (AEZ1*AEZ6)
        $$else.ifLU
            Land . Land
        $$endif.ifLU
        (NatlRes,NatRes).NatRes
    /
;

mapa(a0,cgds) $ sameas("CGDS",a0) = YES ;

mapr(r0,r) = maprtmp(r,r0);

SETS

* [EditJean]: New Data by DvM
$OnText
    mapaez(fpa0, fp) /
        $$iftheni.ifLU "%LU%" == "ON"
            AEZ1 . AEZ1
            AEZ2 . AEZ2
            AEZ3 . AEZ3
            AEZ4 . AEZ4
            AEZ5 . AEZ5
            AEZ6 . AEZ6
            AEZ7 . AEZ1
            AEZ8 . AEZ2
            AEZ9 . AEZ3
            AEZ10 . AEZ4
            AEZ11 . AEZ5
            AEZ12 . AEZ6
            AEZ13 . AEZ1
            AEZ14 . AEZ2
            AEZ15 . AEZ3
            AEZ16 . AEZ4
            AEZ17 . AEZ5
            AEZ18 . AEZ6
            UnSkLab . UnSkLab
            SkLab . SkLab
            Capital . Capital
            NatlRes . NatRes
        $$else.ifLU
            (AEZ1*AEZ18). Land
        $$endif.ifLU
    /
$OffText

    mapl(lg,l) "Mapping to GIDD labor database" /
        $$Ifi %split_skill%=="1" (nsk,skl).Labour
        $$Ifi %split_skill%=="2" nsk.UnSkLab, skl.SkLab
    /

*   Save sort mapping for countries

    sortOrder / sort1*sort500 /

    mapRegSort(sortOrder,r) "Mapping to order Model regions" /
        $$batinclude "%sDir%\rAgg%RegionalAgg%.gms" "Sort_region"
    /

* [EditJean]: All the following instruction are not necessary for "AggGTAP.gms", "AlterTax.gms" and "filter.gms"

*------------------------------------------------------------------------------*
*               Aggregate Sets: ra, ia, aga (default)                          *
*------------------------------------------------------------------------------*

* [EditJean] dans ENV-L on a automatiquement r avec ra, i avec ia, etc...

    ra "Aggregate regions for emission regimes and model output" /

        $$batinclude "%sDir%\rAgg%RegionalAgg%.gms" "define_ra"

* The isolated countries are by default copied in the file "04-create_set_file.gms" [TBC]
*        $$batinclude "%sDir%\rAgg%RegionalAgg%.gms" "define_region"
    /

   ia "Aggregate commodities for model output" /

* World Bank commodities

        $$batinclude "%sDir%\WBia.gms" "define_Sector" "-c"

* List of G-Cubed commodities [option]

        $$IFi %GcubbedIa%=="ON" $batinclude "%sDir%\GCubbedAct.gms" "Activity"

      /

   aga  "Aggregate activities for model output" /

* World Bank sectors

        $$batinclude "%sDir%\WBia.gms" "define_Sector" "-a"

* List of G-Cubed sectors

        $$IFi %GcubbedIa%=="ON" $batinclude "%sDir%\GCubbedAct.gms" "Sector"

      /
*   [TBC]:  verifier a quoi ca correspond
   lagg "Aggregate labor for model output" / tot "Total labor"  /
;

* [EditJean]: New sets by DvM
* !!!! Explicit assumption about diagonality
*alias(i,a) ;
*alias(m,i) ;

*  User defined parameters (i.e. not aggregated by aggregation facility)

* [OECD-ENV]:Rev 443 move definition of etrae1 in "AggGTAP.gms"


*[EditJean]: New Data by DvM
* NEW --- MAKE ELASTICITIES
$OnText
Parameter
etraq1(a,r) "MAKE CET Elasticity"
esubq1(i,r) "MAKE CES Elasticity"
;
etraq1(a,r) = 5 ;
esubq1(i,r) = inf ;
* NEW --- EXPENDITURE ELASTICITIES
Parameter
esubg1(r) "Government expenditure CES elasticity"
esubi1(r) "Investment expenditure CES elasticity"
esubs1(m) "Transport margins CES elasticity"
;
esubg1(r) = 1 ;
esubi1(r) = 0 ;
esubs1(m) = 1 ;
$OffText

*------------------------------------------------------------------------------*
*                                                                              *
* Section dealing with model aggregations (to handle non-diagonal make matrix) *
*                                                                              *
*------------------------------------------------------------------------------*

*   Model aggregation(s)

SETS

    actf "Model activities" /

* diagonal assumption for this project

        $$batinclude "%sDir%\sAggGeneric.gms" "define_act" "%IfPower%"

    /

* Only one electricity good for this project --> %IfElyGoodDesag%=="OFF"

    commf "Model commodities" /

        $$batinclude "%sDir%\sAggGeneric.gms" "define_act" "%IfElyGoodDesag%"

    /

*   Mapping from original to model aggregation

SET mapaf(i,actf) "Mapping from Original to Modeled activities" ;

* Non-diagonal case

*SET mapaf(i,actf) "Mapping from original to modeled activities" /
*        $$batinclude "%sDir%\sAggGeneric.gms" "define_mapaf"
*    /
*;

* This project: diagonal case

LOOP( (i,actf) $ sameas(i,actf),
    mapaf(i,actf) = YES ;
) ;

* This project: matrice is not diagnonal --> all Power produce same electricity

$OnText
SET mapIF(i,commf) "Mapping from original to modeled commodities" /
        $$batinclude "%sDir%\sAggGeneric.gms" "define_mapif"
/;
$OffText

SET mapif(i,commf) "Mapping from Original to modeled commodities" ;

LOOP( (i,commf) $ sameas(i,commf), mapIF(i,commf) = YES ; ) ;

$IFi %IfElyGoodDesag%=="OFF" mapIF(sely,"ely") = YES ;


* >>>> MUST INSERT MUV COMMODITIES (ONE OR MORE)
*      !!!! Be careful of compatibility with modeled imuv
*           This one is intended for AlterTax

set imuvf(commf) "MUV commodities" /
    $$batinclude "%sDir%\nrg_int_industries.gms"
    $$batinclude "%sDir%\other_manufacturing.gms"
    $$batinclude "%sDir%\food.gms"
    $$batinclude "%sDir%\textiles.gms"
/ ;

* Mapping of Aggregation of modeled sectors and regions --> Moved after sector specific definitions

*------------------------------------------------------------------------------*
*                       Save sectoral sort mapping                             *
*------------------------------------------------------------------------------*

SETS

    mapActSort(sortOrder,actf) /
        $$batinclude "%sDir%\sAggGeneric.gms" "define_mapActSort"
    /
    mapCommSort(sortOrder,commf) /
        $$batinclude "%sDir%\sAggGeneric.gms" "define_mapCommSort"
    /
;

*------------------------------------------------------------------------------*
*                                                                              *
*                   [ENVISAGE] / [OECD-ENV] section                            *
*                                                                              *
*------------------------------------------------------------------------------*

* [OECD-ENV] Add Sets:
*       - mapaIMPACT, mapr_rweo (no more used from winter 2022)
*       - subset of modeled activity (actf) and commodities (commf)

SETS

    mapaIMPACT(a,IMPACTa0) "Mapping original activity 'a' with IMPACT sectors" /
        $$batinclude "%sDir%\mapaIMPACT.gms"
    /

*    mapr_rweo(*,r) "Mapping IEA-WEO regions to Model regions" /
*        $$batinclude "%sDir%\rAgg%RegionalAgg%.gms" "WEOmapping"
*    /

*------------------------------------------------------------------------------*
*           Modeled activity (actf) related sets and subsets                   *
*------------------------------------------------------------------------------*

* Primary activities

    cra(actf)  "Crop activities" /
        $$batinclude "%sDir%\crops.gms"
    /
    lva(actf)  "Livestock activities" /
        $$batinclude "%sDir%\livestock.gms"
    /
    ricea(actf)  "Rice sectors"   /
        $$Ifi %split_acr%=="ON" pdr "Paddy Rice"
    /
    forestrya(actf) "Forestry sector"  / frs "Forestry"  /
    fisherya(actf)  "Fisheries sector" / fsh "Fisheries" /

* Energy Intensive Industries:

    frta(actf)      "Fertilizer/Chemicals"    / crp "Fertilizer/Chemicals"  /
    cementa(actf)   "Non-metallic minerals"   / nmm "Non-metallic minerals" /
    PPPa(actf)      "Paper & Paper Products"  / ppp "Paper & Paper Products"/
    I_Sa(actf)      "Iron and Steel"          / i_s "Iron and Steel"        /

* Other Manufacturing:

    ELEa(actf)      "Electronic sectors"      / ele "Electronic sectors"      /
    FMPa(actf)      "Fabricated metal sectors"/ fmp "Fabricated metal sectors"/
    wooda(actf)     "Wood sector" /
        $$Ifi %split_oma%=="ON" lum
        /
    MTEa(actf)      "Manuf. of transport equipement and vehicles" /
        $$Ifi %split_oma%=="OFF" mvh  "Transport Equipment"
        $$Ifi %split_oma%=="ON"  mvh  "Motor vehicles"
        $$Ifi %split_oma%=="ON"  otn  "Other transport equipment"
    /
    NFMa(actf)      "Non-Ferrous Metals"      / nfm "Non-ferrous metals" /
    omana(actf)     "Other manufacturing sectors"    /
        $$IfTheni.SplitOma %split_oma%=="ON"
            omf   "Other manufacturing (includes recycling)"
            ome   "Machinery and equipment n.e.s."
            $$IfTheni.gtap10  Not %GTAP_ver%=="92" !! GTAP version 10 and above
                eeq   "Electrical equipment"        !! from old ome
                bph   "Basic pharmaceuticals"       !! from old crp sector
                rpp   "Rubber and plastic products" !! from old crp sector
            $$endif.gtap10
        $$Else.SplitOma
            oma   "Other manufacturing"
        $$Endif.SplitOma
        /
    FDPa(actf) "Food products sectors" /
        $$batinclude "%sDir%\food.gms"
        /
    TXTa(actf) "Textiles sectors" /
        $$batinclude "%sDir%\textiles.gms"
        /

*   Other Industries non-manufacturing:

    COAa(actf)  "Coal extraction"             / coa "Coal extraction"        /
    COILa(actf) "Crude oil extraction"        / oil "Crude oil extraction"   /
    ROILa(actf) "Petroleum and coal products" / p_c "Petroleum & coal prod." /
    $$Ifi %split_gas%=="OFF" GDTa(actf)  "Nat. gas: manufacture & distribution" /  /
    $$Ifi %split_gas%=="OFF" NGASa(actf) "Nat. gas: extraction plus manufacture & distribution" / gas /
    $$Ifi %split_gas%=="ON"  GDTa(actf)  "Nat. gas: manufacture & distribution" / gdt /
    $$Ifi %split_gas%=="ON"  NGASa(actf) "Nat. gas: extraction" / gas  /
    mininga(actf)   "Other mining products"   /
        $$batinclude "%sDir%\mining.gms"
        /
    constructiona(actf) "Construction sectors" /
        $$batinclude "%sDir%\construction.gms"
        /
    wtra(actf) "Water services activities" /
        $$batinclude "%sDir%\water.gms"
    /

*   Services

    pubserva(actf) "Collective services (Government)" /
        $$batinclude "%sDir%\pubserv.gms"
        /
    privserva(actf) "Other business services sectors" /
        $$batinclude "%sDir%\privserv.gms"
        /
    transporta(actf) "Transportation services"/
        $$batinclude "%sDir%\transport.gms"
    /

*   Energy aggregates

    ea(actf) "Energy activities (etd included)" /
        $$batinclude "%sDir%\pdt_emi.gms"
        $$batinclude "%sDir%\power.gms" "" "%IfPower%"
    /
    fa(actf) "Fossil fuel activities" /
        $$batinclude "%sDir%\pdt_emi.gms"
    /
    elya(actf) "Power activities (etd included)" /
        $$batinclude "%sDir%\power.gms" "" "%IfPower%"
    /
    etda(actf)  "Electricity transmission and distribution activities"   /
        $$Ifi %IfPower%=="ON" etd
    /
* [TBC] AdvNuke, why etd here ?
    primElya(actf) "Primary power activities" /
        $$Ifi %IfPower%=="ON" nuc, hyd, wnd, sol, xel, etd
    /

*------------------------------------------------------------------------------*
*           Modeled modeled commodity (commf) related sets and subsets         *
*------------------------------------------------------------------------------*

    cri(commf)  "Crop products" /
        $$batinclude "%sDir%\crops.gms"
    /
    lvi(commf)  "Livestock products" /
        $$batinclude "%sDir%\livestock.gms"
    /
    frti(commf) "Fertilizer commodities" / crp "Fertilizer/Chemicals"/
    feedi(commf) "Feed commodities" /
        $$Ifi %split_acr%=="ON"  wht, gro, ocr
        $$Ifi %split_acr%=="OFF" cro
    /
    forestryi(commf) "Forestry sector"  / frs "Forestry"  /
    Fisheryi(commf)  "Fisheries sector" / fsh "Fisheries" /

* Energy Intensive Industries:

    cementi(commf) "Non-metallic minerals"   / nmm "Non-metallic minerals"   /
    PPPi(commf)    "Paper & Paper Products"  / ppp "Paper & Paper Products"  /
    I_Si(commf)    "Iron and Steel"          / i_s "Iron and Steel"          /

* Other Manufacturing:

    ELEi(commf)  "Electronic goods"         / ele "Electronic goods"  /
    FMPi(commf)  "Fabricated metal products"/ fmp "Fabricated metal products"/
    woodi(commf) "Wood products" /
        $$Ifi %split_oma%=="ON" lum "Wood products"
        /
    MTEi(commf)  "Transport equipement and vehicles commodities" /
        $$Ifi %split_oma%=="OFF" mvh  "Motor vehicles and other transport Equipment"
        $$Ifi %split_oma%=="ON"  mvh  "Motor vehicles"
        $$Ifi %split_oma%=="ON"  otn  "Other transport equipment"
    /
    NFMi(commf) "Non-Ferrous Metals" / nfm "Non-ferrous metals" /
    omani(commf)     "Other Manufacturing commodities"    /
        $$IfTheni.SplitOma %split_oma%=="ON"
            omf   "Other manufacturing (includes recycling)"
            ome   "Machinery and equipment n.e.s."
            $$IfTheni.gtap10  Not %GTAP_ver%=="92" !! GTAP version 10 and above
                eeq   "Electrical equipment"        !! from old ome
                bph   "Basic pharmaceuticals"       !! from old crp sector
                rpp   "Rubber and plastic products" !! from old crp sector
            $$endif.gtap10
        $$Else.SplitOma
            oma   "Other manufacturing"
        $$Endif.SplitOma
        /
    FDPi(commf) "Food products" /
        $$batinclude "%sDir%\food.gms"
        /
    TXTi(commf) "Textiles products" /
        $$batinclude "%sDir%\textiles.gms"
        /

*   Other Industries non-manufacturing:

* [EditJean]: si on enleve la condition alors water dans ksw meme sans supply

    iw(commf) "Water services commodities (activated if IfWater is on)" /
        $$IFi %IfWater%=="ON" $$batinclude "%sDir%\water.gms"
    /

* [EditJean]: Add this to be distinct from iw that could be nil

    wtri(commf) "Water supply; sewerage; waste management and remediation activities" /
        $$batinclude "%sDir%\water.gms"
    /
    miningi(commf)   "Other mining products"   /
        $$batinclude "%sDir%\mining.gms"
    /
    COAi(commf)  "Coal extraction"             / coa "Coal extraction"        /
    COILi(commf) "Crude oil extraction"        / oil "Crude oil extraction"   /
    ROILi(commf) "Petroleum and coal products" / p_c "Petroleum & coal prod." /
    $$Ifi %split_gas%=="OFF" GDTi(commf)  "Natural gas: manufacture & distribution" /  /
    $$Ifi %split_gas%=="OFF" NGASi(commf) "Natural gas: extraction, manufacture & distribution" / gas "Natural gas: manufacture & distribution" /
    $$Ifi %split_gas%=="ON"  GDTi(commf)  "Natural gas: manufacture & distribution" / gdt "Natural gas: manufacture & distribution" /
    $$Ifi %split_gas%=="ON"  NGASi(commf) "Natural gas: extraction" / gas "Natural gas: extraction" /
    constructioni(commf) "Construction sectors" /
        $$batinclude "%sDir%\construction.gms"
    /

*   Services:

    transporti(commf) "Transportation services"/
        $$batinclude "%sDir%\transport.gms"
    /
    pubservi(commf)  "Collective services (Government)" /
        $$batinclude "%sDir%\pubserv.gms"
    /
    privservi(commf) "Other business services sectors" /
        $$batinclude "%sDir%\privserv.gms"
    /

*   Energy aggregates

    ei(commf) "Energy commodities" /
        $$batinclude "%sDir%\power.gms" "" "%IfElyGoodDesag%"
        $$batinclude "%sDir%\pdt_emi.gms"
    /
    fi(commf) "Fuel commodities" /
        $$batinclude "%sDir%\pdt_emi.gms"
    /
    elyi(commf) "Electricity commodities"  /
        $$batinclude "%sDir%\power.gms" "" "%IfElyGoodDesag%"
    /

;

*------------------------------------------------------------------------------*
*           Mapping of Aggregation of modeled sectors and regions              *
*------------------------------------------------------------------------------*

* [TBU]: vaudrait mieux definir ces ensemble dans la phase modele
* car en fait ils ne servent a rien dans l'aggregation

SETS
    agas1(aga) / tagr-a, tman-a, tsrv-a, toth-a, ttot-a /
    ias1(ia)   / tagr-c, tman-c, tsrv-c, toth-c, ttot-c /
;

*   Aggregate commodity Mapping

*set mapaga(aga,actf) "mapping of individual sector to aggregate sector" /
*    $$batinclude "%sDir%\sAggGeneric.gms" "define_mapia" / ;
*/ ;

set mapia(ia,commf) "mapping of individual commodity to aggregate commodity";

*   Mapping with World Bank commodities

$batinclude "%sDir%\WBia.gms" "mapping" "-c" "i" "mapia"

mapia("ttot-c",commf) = YES ;

*   Mapping with GCubbed commodities

$Ifi %GCubbed%=="ON" $$batinclude "%sDir%\GCubbedAct.gms" "mapping" "i"

*   Aggregate activity Mapping

*set mapaga(aga,actf) "mapping of individual sector to aggregate sector" /
*    $$batinclude "%sDir%\sAggGeneric.gms" "define_mapaga"
*/ ;

set mapaga(aga,actf) "mapping of individual sector to aggregate sector" ;

*   Mapping with World Bank sectors

$$batinclude "%sDir%\WBia.gms" "mapping" "-a" "a" "mapaga"

mapaga("ttot-a",actf) = yes ;

*   Mapping with GCubbed sectors

$Ifi %GCubbed%=="ON" $$batinclude "%sDir%\GCubbedAct.gms" "mappinga" "a"

*   Aggregate regional Mapping

set mapra(ra,r) "Mapping of model regions to aggregate regions" /
    $$batinclude "%sDir%\rAgg%RegionalAgg%.gms" "mapping_ra"
/;

*   World Mapping

mapra("WORLD",r) = yes;

set maplagg(lagg,l) "Mapping of model labor to aggregate labor" ;
maplagg("Tot",l) = yes ;

* [OECD-ENV]: Rev443 remove zonal mapping mapzf --> now define in %ModelDir%\22-Additional_Sets.gms

*------------------------------------------------------------------------------*
*  This zonal mapping is for labor market segmentation in final model          *
*------------------------------------------------------------------------------*

* This is used in "AggEnvElast.gms" to define omegam0(r,l) from omegam(r0)

SET
    mapzf(z,actf)  "Mapping of activities to zones" /

		$$IfTheni.SplitCrops %split_acr%=="ON"
            rur.(pdr,wht,gro,v_f,osd,c_b,pfb,ocr)
        $$Else.SplitCrops
            rur.cro
        $$Endif.SplitCrops

        $$IfTheni.SplitLvs %split_lvs%=="ON"
            rur.(cow,nco)
        $$Else.SplitLvs
            rur.lvs
        $$Endif.SplitLvs
    /

;

mapzf("urb",actf) = not mapzf("rur",actf) ;
mapzf("nsg",actf) = yes ;

*------------------------------------------------------------------------------*
*  >>>> Power Bundles sets
*------------------------------------------------------------------------------*

* [TBU] useless to define this --> defined at Model level

* Logiquement a definir au niveau du modele car sert seulement dans AggEnvElast --> sigmapb

$IfTheni.PowerData %IfPower%=="ON"
    SETS
        $$IfThenI.ElyBndNest %ElyBndNest%=="default"
            pb "5 Power bundles in power aggregation" /
                GasP    "Gas power"
                OilP    "Oil power"
                coap    "Coal power"
                nucp    "Nuclear power"
                othp    "Other power"
            /
            mappow(pb,elya) "Mapping of power activities to power bundles" /
                coap.clp
                gasp.gsp
                oilp.olp
                nucp.nuc
                othp.(hyd,wnd,sol,xel)
            /
        $$ELSEIFI.ElyBndNest %ElyBndNest%=="4Bundles"
            pb "4 Power bundles" /
                fosp    "Fossil fuel power bundle"
                nucp    "Nuclear power bundle"
                othp    "Other power bundle"
                hydp    "Hydro power bundle"
            /
            mappow(pb,elya) "Mapping of power activities to power bundles" /
                fosp.(clp,gsp,olp)
                nucp.nuc
                hydp.hyd
                othp.(wnd,sol,xel)
            /
        $$ELSEIFI.ElyBndNest  %ElyBndNest%=="ENV-LinkagesV3"
            pb "5 Power bundles" /
                ELFOSS     "Fossil fuel power bundle"
                NUCLEAR    "Nuclear power bundle"
                SOLWIND    "Solar and Wind power"
                HYDRO      "Hydro power bundle" "Other power bundle"
                COMRENEW   "Other power bundle"
            /
            mappow(pb,elya) "Mapping of power activities to power bundles" /
                ELFOSS  .(clp,gsp,olp)
                NUCLEAR .nuc
                HYDRO   .hyd
                SOLWIND .(wnd,sol)
                COMRENEW.xel
            /
        $$ELSE.ElyBndNest

            pb "Power bundles" /  Allp "All power bundle" /
            mappow(pb,elya) "Mapping of power activities to power bundles" / Allp.(clp,gsp,olp,nuc,hyd,wnd,sol,xel) /

        $$EndIf.ElyBndNest

        nspb(pb) "non-singleton power-bundles"
        HYDRO(actf)    / hyd /
        COMRENEW(actf) / xel /
        NUKE(actf)     / nuc /
        SOLWIND(actf)  "Solar and Wind power" / sol, wnd /
        s_otr(actf)    "Renewables Power excluding Hydro Power"
        s_ren(actf)    "Non Fossil-Fuel Power activities"
    ;

    LOOP(pb $ (sum(elya $ mappow(pb,elya),1) gt 1), nspb(pb) = YES;);
    s_otr(actf) = COMRENEW(actf) + SOLWIND(actf);
    s_ren(actf) = s_otr(actf) + HYDRO(actf) + NUKE(actf) + ETDa(actf);

$ELSE.PowerData

    SETS
        pb "Power bundles" /  Allp "All power bundle" /
        mappow(pb,elya) "Mapping of power activities to power bundles" / /
        nspb(pb)        /  /
        HYDRO(actf)     /  /
        COMRENEW(actf)  /  /
        NUKE(actf)      /  /
        SOLWIND(actf)   /  /
        s_otr(actf)     /  /
        s_ren(actf)     /  /
    ;

$ENDIF.PowerData

* #TODO mettre k et cie dans modele

*------------------------------------------------------------------------------*
*                       Household commodity section                            *
*------------------------------------------------------------------------------*
SETS
    k "Household commodities" /
        nrg   "Energy bundle"
        lvs   "Livestock and Fish bundle"
        frs   "Forestry"

        $$IF %split_acr%=="OFF" cro "Crop bundle"
        $$IF %split_acr%=="ON"  cer "Cereals bundle"
        $$IF %split_acr%=="ON"  xcr "Other crops bundle"

        $$batinclude "%sDir%\food.gms"
        $$batinclude "%sDir%\textiles.gms"
        $$batinclude "%sDir%\mining.gms"
        $$batinclude "%sDir%\nrg_int_industries.gms"
        $$batinclude "%sDir%\other_manufacturing.gms"
        $$batinclude "%sDir%\water.gms"
        $$batinclude "%sDir%\transport.gms"
        $$batinclude "%sDir%\other_services.gms"
        $$batinclude "%sDir%\construction.gms"
    /

* [EditJean]: New set by DvM [TBR]: car moi aussi j'ai defini un truc comme ca

	fud(k) "Household food commodities" /
        $$IF %split_acr%=="OFF" cro   "Crop bundle"
        $$IF %split_acr%=="ON"  cer   "Cereals bundle"
        $$IF %split_acr%=="ON"  xcr   "Other crops bundle"
        $$batinclude "%sDir%\food.gms"
        lvs   "Livestock and Fish bundle"
    /
    mapk(commf,k) "Mapping from model commodities to households commodities k"/

*	Primary goods

        $$IfTheni.SplitCrops %split_acr% =="ON"
            (pdr,wht,gro,osd).cer
            (v_f,c_b,pfb,ocr).xcr
        $$ELSE.SplitCrops
            cro.cro
        $$EndIf.SplitCrops

       $$IfTheni.SplitLivestock %split_lvs%=="ON"
            (cow,nco,fsh).lvs
        $$ELSE.SplitLivestock
            (lvs,fsh).lvs
        $$EndIf.SplitLivestock

        frs.frs

*	Utilities and other non-manufacturing industries

        wts.wts
        cns.cns
        omn.omn

        (coa,oil,gas,p_c).nrg
        $$IF %split_gas%=="ON" gdt.nrg

        $$IFi %IfElyGoodDesag%=="OFF" ely.nrg
        $$IFi %IfElyGoodDesag%=="ON"  (clp,olp,gsp,nuc,hyd,wnd,sol,xel,etd).nrg

*	Manufacturing goods

* ...of which energy intensive industries
        ppp.ppp
        nmm.nmm
        i_s.i_s
        crp.crp
        nfm.nfm

*  ...of which other manufacturing

        ele.ele
        fdp.fdp
        txt.txt
        mvh.mvh
        fmp.fmp
        $$IfTheni.SplitOma %split_oma%=="ON"
            lum.lum
            otn.otn
            omf.omf
            ome.ome
            $$IfTheni.gtap10 Not %GTAP_ver%=="92" !! GTAP version 10 and above
                eeq.eeq
                bph.bph
                rpp.rpp
            $$endif.gtap10
        $$else.SplitOma
            oma.oma
        $$Endif.SplitOma
        otp.otp
        atp.atp
        wtp.wtp
        osg.osg
        osc.osc
        $$IfTheni.SplitService %split_ser%=="ON"
            $$Ifi Not %GTAP_ver%=="92" edu.edu
            $$Ifi Not %GTAP_ver%=="92" hht.hht
            trd.trd
            obs.obs
        $$Endif.SplitService
    /
;

* [EditJean]: add this (not active)
*------------------------------------------------------------------------------*
*            Deletion of problematic flows                                     *
*------------------------------------------------------------------------------*
SETS
    mapxa(r,a) "Output to delete" /

* [2022-11-29]: extra cleaning during filtering

        $$IF SET split_Saudi        sau.(coa,frs)
        $$IF SET split_Argentina    arg.coa

*    $$IF SET split_Slovania     svn.gas
*    $$IF SET split_Greece       grc.gas
*    $$IF SET split_Portugal     prt.gas

        $$Ifi.SplitCrops %split_acr%=="ON" RUS.ocr

    /
    mapxm(r,i) "Commodities to delete" /
        $$IF SET split_Saudi sau.coa
    /
    mapxh(r,i) "Household Commodities to delete" /
        $$IF SET split_Saudi sau.coa
    /
;

*------------------------------------------------------------------------------*
*                       Other Bundles section                                  *
*------------------------------------------------------------------------------*
* [TBU] Logiquement a definir au niveau du modele

SETS

* Land Bundle sets (lb, lb1, maplb, lb0, maplb0)

    $$batinclude "%sDir%\land_bundles.gms"

* Water related sets [inactive]

    $$batinclude "%sDir%\water_bundles.gms"

* Energy Bundles sets (ie NRG,coa,oil,gas,ely, mape)

    $$batinclude "%sDir%\nrg_bundles.gms"

;

*------------------------------------------------------------------------------*
*              Sets required for 'growing' labor by skill                      *
*------------------------------------------------------------------------------*

set skl(l)  "Skill types for labor growth assumptions" /
    $$Ifi %split_skill%=="2" SkLab  "Skilled labor"
    $$Ifi %split_skill%=="1" Labour "Total Labour Force"
/ ;

set elev "education level" / elev0*elev3 / ;

set educMap(r,l,elev) "Mapping of skills to education levels" ;

*  Use GIDD definitions (i.e. "elev3" has no meaning)

$IfTheni.Skills %split_skill%=="2"
    educMap(r,"UnSkLab","elev0") $ mapra("lmy",r) = yes;
    educMap(r,"SkLab","elev1")   $ mapra("lmy",r) = yes;
    educMap(r,"SkLab","elev2")   $ mapra("lmy",r) = yes;
    educMap(r,"UnSkLab","elev0") $ mapra("hic",r) = yes;
    educMap(r,"UnSkLab","elev1") $ mapra("hic",r) = yes;
    educMap(r,"SkLab","elev2")   $ mapra("hic",r) = yes;
$elseifi.Skills %split_skill%=="1"
    educMap(r,"Labour","elev0") = yes;
    educMap(r,"Labour","elev1") = yes;
    educMap(r,"Labour","elev2") = yes;
$Else.Skills
    abort$('Le nombre de skill ne va pas');
$Endif.Skills

*	Use IIASA definitions

$OnText
educMap(r,"UnSkLab","elev0") $ mapra("lmy",r) = yes;
educMap(r,"UnSkLab","elev1") $ mapra("lmy",r) = yes;
educMap(r,"SkLab","elev2")   $ mapra("lmy",r) = yes;
educMap(r,"SkLab","elev3")   $ mapra("lmy",r) = yes;

educMap(r,"UnSkLab","elev0") $ mapra("hic",r) = yes;
educMap(r,"UnSkLab","elev1") $ mapra("hic",r) = yes;
educMap(r,"UnSkLab","elev2") $ mapra("hic",r) = yes;
educMap(r,"SkLab","elev3")   $ mapra("hic",r) = yes;
$OffText

$OffEmpty


