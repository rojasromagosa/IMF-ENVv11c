$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy
   name        : "%PolicyPrgDir%\ExogenousMAC.gms"
   purpose     : Adjustment non-Co2 coefficients to mimic Mac curve
   created date: 2021-06-21
   created by  : Jean Chateau
   called by   : "%iFilesDir%\AdjustSimOption.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/ExogenousMAC.gms $
   last changed revision: $Rev: 282 $
   last changed date    : $Date:: 2023-04-13 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$offText

$OnDotL

IF(ifDyn and (NOT ifCal) and (NOT ifEndoMAC),

    Display "Activate Exogenous MAC" ;
    rwork(r)      = 0   ;
    rwork_bis(r)  = 0.5 ;
    rwork_bis(EU) = 1   ;

    LOOP((CO2,vOld),
        rwork(r) $ emiTax.l(r,CO2,tsim-1)
            = emiTax.l(r,CO2,tsim) / emiTax.l(r,CO2,tsim-1) ;

        emir(r,EmSingle,EmiFp,a,tsim)
            $ (rwork(r) and emir(r,EmSingle,EmiFp,a,tsim-1)
                and part(r,EmSingle,EmiFp,a,tsim) and NOT ghgFlag(r,a))
            = emir(r,EmSingle,EmiFp,a,tsim-1)
            * rwork(r)**(- rwork_bis(r) * sigmaxp(r,a,vOld)) ;

        emir(r,EmSingle,emiact,a,tsim)
            $ (rwork(r) and emir(r,EmSingle,emiact,a,tsim-1)
                and part(r,EmSingle,emiact,a,tsim) and NOT ghgFlag(r,a))
            = emir(r,EmSingle,emiact,a,tsim-1)
            * rwork(r)**(- rwork_bis(r) * sigmaxp(r,a,vOld)) ;
    ) ;

) ;

$OffDotl

