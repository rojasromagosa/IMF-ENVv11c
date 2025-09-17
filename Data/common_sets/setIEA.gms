$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] Model :  Aggregation Procedure
    GAMS file   : "setIEA.gms"
    purpose     : Definition of all existing IEA sets
                    EEB_Product, EEB_Flow, r_IEA_EEB
    Created by  : Jean Chateau
    created Date: 6 Juin 2017
    called by   : "%DataDir%\AggGTAP.gms"
--------------------------------------------------------------------------------
   file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
   last changed revision: $Rev: 480 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$SetGlobal folder_setIEA "%SetsDir%\setIEA"

*------------------------------------------------------------------------------*
*                                                                              *
*                   Extended Energy Balance Database                           *
*                                                                              *
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*       Load sets for Flows and Products of the IEA EEB database               *
*------------------------------------------------------------------------------*

* sets: EEB_Flow & EEB_Product

$include "%folder_setIEA%\01a-sets_EEB_Product.gms"
$include "%folder_setIEA%\01b-sets_EEB_Flow.gms"

* mapping: map_EEBProduct_i0_EL(EEB_Product,i0)

$include "%folder_setIEA%\01c-map_EEB_to_GTAP_Product.gms"

* mapping: map_a0_EEBFlow(EEB_Flow,a0)

$include "%folder_setIEA%\01d-map_EEB_to_GTAP_Flow.gms"

* EXECUTE_UNLOAD "C:\MODELS\TmpDir\CGE\%system.fn%.gdx"

*------------------------------------------------------------------------------*
*                        EEB regional sets (r_IEA_EEB)                         *
*------------------------------------------------------------------------------*
* Not Sure this is necessary see SVN_Modelling\ENV-Growth\countries.gms

$include "%folder_setIEA%\02-sets_EEB_regions.gms"

* mapping: map_r0_rieaeeb(r0,r_IEA_EEB)

$include "%folder_setIEA%\05-mapping_regions_GTAP_to_IEA.gms"

$OnText
*------------------------------------------------------------------------------*
*                                                                              *
*                   CO2 and GHGs Emissions                                     *
*                                                                              *
*------------------------------------------------------------------------------*
$OffText

$include "%folder_setIEA%\03-sets_emissions.gms"

*------------------------------------------------------------------------------*
*                                                                              *
*                              WEO Database                                    *
*                                                                              *
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*                           WEO Sets Regions                                   *
*------------------------------------------------------------------------------*

set r_weo "World Energy Outlook Model regions" /

    $$include "%folder_setIEA%\04-set_weo_regions.gms"

*   WEO Aggregates

    World
    'OECD'
    'OECD Americas'
    'OECD Asia Oceania'
    'OECD Europe'
    'Non-OECD'
    'Transition Economies'
    'Developing Countries'
    'Non-OECD Asia'
    'Non-OECD Latin America'
    'Africa'
    'EU28'
/ ;

set r_weos(r_weo) "World Energy Outlook/Model non-aggregate regions" /
    $$include "%folder_setIEA%\04-set_weo_regions.gms"
/;

alias(iea_r,r_weo) ;

* mapping: mapr0_rweo(r0,r_weo)

$include "%folder_setIEA%\05-mapping_regions_GTAP_to_WEO.gms"

*------------------------------------------------------------------------------*
*                     weo Flows and Products                                   *
*------------------------------------------------------------------------------*

$include "%folder_setIEA%\06-sets_WEO_flows_and_products.gms"

*------------------------------------------------------------------------------*
*  Load Sets of weo variables:  set_WEM_WPrices, set_wem_macro, ieaVar,        *
*                   ieaAgents,  mapieaAgent, iea_tped_demand, iea_tfc_demand   *
*------------------------------------------------------------------------------*

$include "%folder_setIEA%\07-sets_WEO.gms"

*------------------------------------------------------------------------------*
*                         WEO sector Mapping                                   *
*------------------------------------------------------------------------------*
$OnText
* ongoing
set map_gtap_weo_sector(a0,ieaSubSect) "Mapping between GTAP and WEO sector" /
        $$IfTheni.WtrData %ifWater%=="ON"
            (pdri,pdrn,whti,whtn,groi,gron,v_fi,v_fn,osdi,osdn).'Agriculture'
            (c_bi,c_bn,pfbi,pfbn,ocri,ocrn).'Agriculture'
        $$ELSE.WtrData
            (ctl,oap,rmk,wol,frs,fsh).'Agriculture'
        $$ENDIF.WtrData
        (ctl,oap,rmk,wol,frs,fsh).'Agriculture'

        $$IF %ifPower%=="ON"  (TnD,NuclearBL,CoalBL,GasBL,WindBL,HydroBL,OilBL,OtherBL,GasP,HydroP,OilP,SolarP,colccs,gasccs,advnuc).'Power&Heat'
        $$IF %ifPower%=="OFF" ELY.'Power&Heat'


* a faire pour Co2
*        coa.coa
*        oil.oil
*        gas.gas
*        omn.omn

        cmt.'Non-specified'
        omt.'Non-specified'
        vol.'Non-specified'
        mil.'Non-specified'
        pcr.'Non-specified'
        sgr.'Non-specified'
        ofd.'Non-specified'
        b_t.'Non-specified'
        tex.'Non-specified'
        wap.'Non-specified'
        lea.'Non-specified'
        lum.'Non-specified'
        ppp.'Paper'
        p_c.'Other transformations'
        crp.'Chemicals'
        nmm.'Cement'
        fmp.'Non-specified'
        mvh.'Non-specified'
        otn.'Non-specified'
        ele.'Non-specified'
        ome.'Non-specified'
        omf.'Non-specified'
        i_s.'Steel'
        nfm.'Aluminium' !! where is the rest of nfm?

        gdt.'Power&Heat'
        wtr.'Services'
        cns.'Non-specified'
        otp.'Road'
        otp.'Rail'
        otp.'Pipeline'
        otp.'Non_specified_Transport'
        wtp.'Navigation'
        atp.'Domestic Aviation'
        (trd,cmn,ofi,isr,obs,ros,osg,dwe).'Services'
    /;


*ruBEN : REMOVED THIS TO BE USED IN MODEL (AND NOT AGGREGATION)
set map_s0_ieaSubSect(i0,ieaSubSect) "mapping institutional sector in GTAP with IEA-WEO aggregate sectors" /
(pdr,wht,gro,v_f,osd,c_b,pfb,ocr,ctl,oap,rmk,wol,frs,fsh).Agriculture
(omn,cmt,omt,vol,mil,pcr,sgr,ofd,b_t,tex,wap,lea,lum).Other_Industry
ppp.Pulp_paper
crp.Chemicals
nmm.Non-metallic_Minerals
i_s.Iron_Steel
(nfm,fmp,mvh,otn,ele,ome,omf,wtr,cns).Other_Industry
ely.Power_Generation
COA.OtherEnSect_of_which_Coal_own_use
P_C.OtherEnSect_of_which_Total_OwnUseRefineries
OIL.OtherEnSect_of_which_Total_OilGasExtraction
GAS.OtherEnSect_of_which_Total_OilGasExtraction
GDT.OtherEnSect_of_which_Total_OilGasExtraction
otp.Road
*otp.Rail
*otp.Pipeline
*otp.Non_specified_Transport
wtp.Navigation
atp.Domestic_Aviation
(trd,cmn,ofi,isr,obs,ros,osg,dwe).Services
/;


SET bigs(ieaSubSect) 'End-use Sectors from WEO ' /
Residential
Iron_Steel
Chemicals
Non-metallic_Minerals
Pulp_paper
Other_Industry
Road
Rail
Pipeline
Non_specified_Transport
Services
Agriculture
Other_Energy_Sector
/;
$OffText

*------------------------------------------------------------------------------*
*                           WEO Sets : Scenarios                               *
*------------------------------------------------------------------------------*

set ieaScen "Labels for WEO Scenarios by IEA (ex WEO_scenarios)" /
    $$include "%folder_setIEA%\08-sets_iea_scenarios.gms"
/;

