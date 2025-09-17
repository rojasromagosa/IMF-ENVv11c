$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] project V1  - Aggregation procedure
    GAMS file   : "Extract_Main_GTAP.gms"
    purpose     : Extraction de la base GTAP complete pour retrouver I-O Table
    created date: Winter 2021
    created by  : Jean Chateau
    called by   : AggGTAP.gms
--------------------------------------------------------------------------------
      $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/debug/Extract_Main_GTAP.gms $
   last changed revision: $Rev: 283 $
   last changed date    : $Date:: 2023-04-13 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$Set GrossOutputFile "%oDirGTAP%\Output_Basic_Prices"

*$IfThen.OnlyOnce NOT exist "%GrossOutputFile%.gdx"

    PARAMETER GTAP_Output_BP(*,*,a0,r0);

*   Intermediary Demands

    GTAP_Output_BP("dom",i0,a0,r0)            = vdfa(i0,a0,r0);
    GTAP_Output_BP("imp",i0,a0,r0)            = vifa(i0,a0,r0);

*   Other final Demands (put gov in "total")

    GTAP_Output_BP("dom",i0,hh0,r0)           = vdpa(i0,r0);
    GTAP_Output_BP("imp",i0,hh0,r0)           = vipa(i0,r0);

    GTAP_Output_BP("dom",i0,"total",r0)       = vdga(i0,r0);
    GTAP_Output_BP("imp",i0,"total",r0)       = viga(i0,r0);

*   Absorption

    GTAP_Output_BP("tot",i0,a0,r0)     = vdfa(i0,a0,r0)+vifa(i0,a0,r0);
    GTAP_Output_BP("tot",i0,hh0,r0)    = vdpa(i0,r0)+vipa(i0,r0);
    GTAP_Output_BP("tot",i0,"total",r0)= vdga(i0,r0)+viga(i0,r0);

*   Gross Output

    GTAP_Output_BP("xp","total",a0,r0) = voa(a0,r0) ;

*   Factor payments

    GTAP_Output_BP("fp",fp0,a0,r0)     = evfa(fp0,a0,r0);

*   Energy volume

    GTAP_Output_BP("domMtoe",e0,a0,r0)  = EDF(e0,a0,r0);
    GTAP_Output_BP("impMtoe",e0,a0,r0)  = EIF(e0,a0,r0);
    GTAP_Output_BP("totMtoe",e0,a0,r0)  = EDF(e0,a0,r0)  + EIF(e0,a0,r0);

    GTAP_Output_BP("domMtoe",e0,hh0,r0) = EDP(e0,r0);
    GTAP_Output_BP("impMtoe",e0,hh0,r0) = EIP(e0,r0);
    GTAP_Output_BP("totMtoe",e0,hh0,r0) = EDP(e0,r0) + EIP(e0,r0);

    GTAP_Output_BP("domMtoe",e0,"total",r0) = EDG(e0,r0);
    GTAP_Output_BP("impMtoe",e0,"total",r0) = EIG(e0,r0);
    GTAP_Output_BP("totMtoe",e0,"total",r0) = EDG(e0,r0) + EIG(e0,r0);

*   CO2 emissions from fuel combustion

    GTAP_Output_BP("domCo2f",f0,a0,r0)   = MDF(f0,a0,r0);
    GTAP_Output_BP("impCo2f",f0,a0,r0)   = MIF(f0,a0,r0);
    GTAP_Output_BP("totCo2f",f0,a0,r0)   = MDF(f0,a0,r0) + MIF(f0,a0,r0);

    GTAP_Output_BP("domCo2f",f0,hh0,r0) = MDP(f0,r0);
    GTAP_Output_BP("impCo2f",f0,hh0,r0) = MIP(f0,r0);
    GTAP_Output_BP("totCo2f",f0,hh0,r0) = MDP(f0,r0) + MIP(f0,r0);

    GTAP_Output_BP("domCo2f",f0,"total",r0) = MDG(f0,r0);
    GTAP_Output_BP("impCo2f",f0,"total",r0) = MIG(f0,r0);
    GTAP_Output_BP("totCo2f",f0,"total",r0) = MDG(f0,r0) + MIG(f0,r0);

    GTAP_Output_BP("Labour share of VA","total",a0,r0)
        $ sum(fp0,evfa(fp0,a0,r0))
        = sum(l0,evfa(l0,a0,r0)) / sum(fp0,evfa(fp0,a0,r0));

    EXECUTE_UNLOAD "%GrossOutputFile%.gdx", GTAP_Output_BP;
    EXECUTE 'gdxdump %GrossOutputFile%.gdx format=CSV output=%GrossOutputFile%.csv symb=GTAP_Output_BP'
*   EXECUTE 'GDXXRW  Input=%GrossOutputFile%.gdx Output=%GrossOutputFile%.xlsx se=0 par=GTAP_Output_BP Rng=GTAP_Output_BP!a2 rdim=6'

*$EndiF.OnlyOnce

