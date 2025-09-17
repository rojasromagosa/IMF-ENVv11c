$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy
   name        : "%PolicyPrgDir%\LULUCF_Scenario.gms"
   purpose     : CO2 Lulucf assumptions
                 for all variant scenarios (including Baseline)
   created date: 2023-01-18 (from %PolicyPrgDir%\ExogenousMAC.gms)
   created by  : Jean Chateau
   called by   : "%iFilesDir%\AdjustSimOption.gms" or %PolicyFile%
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/LULUCF_Scenario.gms $
   last changed revision: $Rev: 339 $
   last changed date    : $Date:: 2023-06-22 #$
   last changed by      : $Author: chateau_j $
--------------------------------------------------------------------------------
    memo: active only if rwork > 0
$offText

$OnDotL

IF(ifDyn and (NOT ifCal),
mm
    emi.fx(fra,CO2,EmiLulucf,forestrya,tsim)
        $ (emi0(fra,CO2,EmiLulucf,forestrya) and rwork(fra))
        = [ m_true4(emi,fra,CO2,EmiLulucf,forestrya,tsim-1)
            - 0.0064 ] / emi0(fra,CO2,EmiLulucf,forestrya) ;

* NDC w/o lulucf in 2030 --> 1805 MtCO2e / emi(IDNemilulucf) = 372
* this is from climateactiontracker.org (same for Brazil, EU)

    emi.fx(IDN,CO2,EmiLulucf,forestrya,tsim)
        $ (emi0(IDN,CO2,EmiLulucf,forestrya) and rwork(IDN))
        = [ m_true4(emi,IDN,CO2,EmiLulucf,forestrya,tsim-1)
            -0.08464725 ] / emi0(IDN,CO2,EmiLulucf,forestrya) ;

    emi.fx(BRA,CO2,emilulucf,forestrya,tsim)
        $ (emi0(BRA,CO2,emilulucf,forestrya) and rwork(BRA))
        = [ m_true4(emi,BRA,CO2,emilulucf,forestrya,tsim-1)
            + 0.018 ] / emi0(BRA,CO2,emilulucf,forestrya) ;

    emi.fx(CAN,CO2,emilulucf,forestrya,tsim)
        $ (emi0(CAN,CO2,emilulucf,forestrya) and rwork(CAN))
        = [ m_true4(emi,CAN,CO2,emilulucf,forestrya,tsim-1)
            - 0.004 ] / emi0(CAN,CO2,emilulucf,forestrya) ;

    emi.fx(deu,CO2,emilulucf,forestrya,tsim)
        $ (emi0(deu,CO2,emilulucf,forestrya) and rwork(deu))
        = [ m_true4(emi,deu,CO2,emilulucf,forestrya,tsim-1)
            - 0 ] / emi0(deu,CO2,emilulucf,forestrya) ;

    emi.fx(ita,CO2,emilulucf,forestrya,tsim)
        $ (emi0(ita,CO2,emilulucf,forestrya) and rwork(ita))
        = [ m_true4(emi,ita,CO2,emilulucf,forestrya,tsim-1)
            - 0.002 ] / emi0(ita,CO2,emilulucf,forestrya) ;

    emi.fx(gbr,CO2,emilulucf,forestrya,tsim)
        $ (emi0(gbr,CO2,emilulucf,forestrya) and rwork(gbr))
        = [ m_true4(emi,gbr,CO2,emilulucf,forestrya,tsim-1)
            - 0.002 ] / emi0(gbr,CO2,emilulucf,forestrya) ;

    emi.fx(RESTEU,CO2,emilulucf,forestrya,tsim)
        $ (emi0(RESTEU,CO2,emilulucf,forestrya) and rwork(RESTEU))
        = [ m_true4(emi,RESTEU,CO2,emilulucf,forestrya,tsim-1)
*            +0.035091875 ] / emi0(RESTEU,CO2,emilulucf,forestrya) ;
            + 0 ] / emi0(RESTEU,CO2,emilulucf,forestrya) ;

* Recalculate emiOth with new emilulucf

    emiOth.fx(r,CO2,tsim)
        = sum((EmiSourceIna,aa), m_true4(emi,r,CO2,EmiSourceIna,aa,tsim)) ;

) ;

$OffDotl

