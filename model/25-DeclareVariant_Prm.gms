$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
   GAMS file    : "%ModelDir%\25-DeclareVariant_Prm.gms"
   purpose      : Declaration of Baseline values (parameters) for variant runs
   Created by   : Jean Chateau for OECD-ENV
   Created date : 4 May 2021
   called by    : %ModelDir%\Variant.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/25-DeclareVariant_Prm.gms $
   last changed revision: $Rev: 518 $
   last changed date    : $Date:: 2024-02-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$SetGlobal cal_preference  "LOAD"
$SetGlobal cal_NRG         "LOAD"
$SetGlobal cal_AGR         "LOAD"
$SetGlobal cal_GHG         "LOAD"
$SetGlobal cal_IOs         "LOAD"
$SetGlobal cal_NRS         "NOTACTIVE"

* To Define bau variables below (for variant Mode)
*   for SemiExoBAU this is written in the "SemiExoBau.gms" at step=="default"

$IF NOT SET BauDir     $SetGlobal BauDir     "%oDir%"
$IF NOT SET BauFile    $SetGlobal BauFile    "%BauDir%\%BauName%"
$IF NOT SET NrgBauFile $SetGlobal NrgBauFile "%BauFile%"
$IF NOT SET EMIBauFile $SetGlobal EMIBauFile "%BauFile%"
$IF NOT SET AgrBauFile $SetGlobal AgrBauFile "%BauFile%"
$IF NOT SET FixedEmi   $SetGlobal FixedEmi   "OFF"

$IF NOT EXIST "%NrgBauFile%.gdx" $SetGlobal cal_NRG "OFF"

PARAMETERS

    EmiRefYear(r,AllEmissions,tt)

*   trends from the BAU

    emi_bau(r,AllEmissions,EmiSource,aa,t)  "Emission from Bau"
    emiTot_bau(r,AllEmissions,t)
    LFPR_bau(r,l,z,t)       "Baseline Labour force participation rate, by skill and by geographical zone"
    rwage_bau(r,l,z,t)      "Baseline Real average wage (indexed by CPI)"
    UNR_bau(r,l,z,t)        "Baseline Unemployment rate, by skill and by geographical zone"
    savf_bau(r,t)           "Baseline Foreign saving"
    TermsOfTradeT_bau(r,t)  "Baseline Terms of trade"
    xp_bau(r,a,t)
    nd1_bau(r,a,t)
    nd2_bau(r,a,t)
    lab1_bau(r,a,t)
    lab2_bau(r,a,t)
    xat_bau(r,i,t)
    xa_bau(r,i,aa,t)
    rsg_bau(r,t)
    ps_bau(r,i,t)
    xs_bau(r,i,t)
    kv_bau(r,a,v,t)
    xfd_bau(r,fd,t)
    rgdpmp_bau(r,t)
	gdpmp_bau(r,t)

    EmiRInt_bau(r,AllEmissions,t) " BAU   : Emission intensity (emi to GDP)"

    $$IFI %cal_NRS%=="LOAD" xnrf_bau(r,a,t), pnrf_bau(r,a,t),
    $$Ifi %cal_AGR%=="LOAD" TFP_xpx_AGR_bau(r,a,v,t)

*   trends from other run

    emi_ref(r,AllEmissions,EmiSource,aa,t)  "Emission from a reference simulation"
    emiTot_ref(r,AllEmissions,t)
    p_emissions_bau(r,AllEmissions,EmiSource,aa,t)
    p_emissions_ref(r,AllEmissions,EmiSource,aa,t)
    kv_ref(r,a,v,t)
    rgdpmp_ref(r,t)

*    $$IF SET IfPostProcedure emiTax_ref(r,AllEmissions,t)

;

* Initialisation

p_emissions_bau(r,AllEmissions,EmiSource,aa,t) = 0 ;
xp_bau(r,a,t)    = 0 ;
nd1_bau(r,a,t)   = 0 ;
nd2_bau(r,a,t)   = 0 ;
lab1_bau(r,a,t)  = 0 ;
lab2_bau(r,a,t)  = 0 ;
xat_bau(r,i,t)   = 0 ;
xa_bau(r,i,aa,t) = 0 ;
xs_bau(r,i,t)    = 0 ;
kv_bau(r,a,v,t)  = 0 ;
rsg_bau(r,t)     = 0 ;
xfd_bau(r,fd,t)  = 0 ;
rgdpmp_bau(r,t)  = 0 ;
gdpmp_bau(r,t)	 = 0 ;

rgdpmp_ref(r,t)  			 = 0 ;
emiTot_ref(r,AllEmissions,t) = 0 ;
p_emissions_ref(r,AllEmissions,EmiSource,aa,t) = 0 ;
emiTax_ref(r,AllEmissions,t) = 0 ;

LFPR_bau(r,l,z,t)  = 0.6;
rwage_bau(r,l,z,t) = 1;
kv_ref(r,a,v,t)    = 0;

EmiRInt_bau(r,AllEmissions,t) = 0 ;

* Projections of Baseline Energy Mix

$IfTheni.FixElyMix %cal_NRG%=="LOAD"

    PARAMETERS
        xpb_bau(r,pb,elyi,t)
        xpow_bau(r,elyi,t)
        x_bau(r,a,i,t)
        ppb_bau(r,pb,elyi,t)
        ppowndx_bau(r,elyi,t)
        ppow_bau(r,elyi,t)
        p_bau(r,a,i,t)
        ppbndx_bau(r,pb,elyi,t)
        TFP_xpx_bau(r,a,v,t)
        TFP_xs_bau(r,i,t)
        lambdapb_bau(r,a,i,t)
        lambdapow_bau(r,pb,elyi,t)
        muc_nrg_bau(r,k,h,t)
        theta_nrg_bau(r,k,h,t)
        lambdae_bau(r,e,a,v,t)
        lambdace_bau(r,e,k,h,t)
    ;
    ppow_bau(r,elyi,t)         = 0 ;
    xpb_bau(r,pb,elyi,t)       = 0 ;
    xpow_bau(r,elyi,t)         = 0 ;
    ppb_bau(r,pb,elyi,t)       = 0 ;
    ppowndx_bau(r,elyi,t)      = 0 ;
    x_bau(r,a,i,t)             = 0 ;
    p_bau(r,a,i,t)             = 0 ;
    ppbndx_bau(r,pb,elyi,t)    = 0 ;
    TFP_xpx_bau(r,a,v,t)       = 0 ;
    TFP_xs_bau(r,i,t)          = 0 ;
    lambdapb_bau(r,a,i,t)      = 0 ;
    lambdapow_bau(r,pb,elyi,t) = 0 ;
    muc_nrg_bau(r,k,h,t)       = 0 ;
    theta_nrg_bau(r,k,h,t)     = 0 ;
    lambdae_bau(r,e,a,v,t)     = 0 ;

$EndIf.FixElyMix

*------------------------------------------------------------------------------*
*   Set of various parameters and Scalar frequently used in climate policies   *
*------------------------------------------------------------------------------*

PARAMETERS
    EmiTimeProfile(r,AllEmissions,tt)
    TmpEmitax(r,em)
    TimeProfile(r,a,t)
    Tgt_Condition(ra,t) "Set to a positive number activates endogenous policy to meet emission target"
    NDC_Condition(ra,t)  "Set to a positive number activates endogenous policy to meet NDC emission target"
    TotTransfert(r,t)
    ygov_ref(r,gy,t)
    AdjGlobalCT(r)
;

EmiTimeProfile(r,AllEmissions,tt) = 0 ;
TmpEmitax(r,em)                   = 0 ;
TimeProfile(r,a,t)                = 0 ;
TotTransfert(r,t)                 = 0 ;
ygov_ref(r,gy,t)                  = 0 ;
AdjGlobalCT(r)                    = 1 ;
Tgt_Condition(rq,t)               = 0 ;
NDC_Condition(rq,t)               = 0 ;

SCALARS

$OnText
   IfEmiIntensity = 0: No intensity target
   IfEmiIntensity = 1: emissions-to-GDP (MER) intensity target
   IfEmiIntensity = 2: emissions-to-GDP (PPP) intensity target
   IfEmiIntensity = 3: emissions-to-POP intensity target
   IfEmiIntensity = 4: emissions-to-GDP per capita (MER) intensity target
$OffText

    IfEmiIntensity "Set positive to use Caps based on emissions-intensity" / 0 /

$OnText
   Flags for experiments with intensity targets

   IfCapIntStep = 0: Only one final target:   %YrFinTgt%"
   IfCapIntStep = 1: One intermediary target: %YrPhase1%"
   IfCapIntStep = 2: Two intermediary targets: %YrPhase1%" & %YrPhase2%"
$OffText

    int_target "Final target for Emicap" / 0.1 /
    IfCapIntStep   / 1 /
    IfJumpICPF 	"Set to 1 to jump in carbon tax in 2022 (IMF-FAD assumption)" / 1 /
    IfNDC  		"Set to 1 to endogenously determine carbon price for NDC - Set 2 to exogenous NDC (IMF papers)"  / 0 /
    IfLoadEmiTgt "Set to 1 to load a reference emission trajectory" / 0 /

;

















