$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy File
   name        : "CommonPolicyFiles\DefineICPF.gms
   purpose     : This file define standard ICPF or emiTax.fx faced by each
				 country for IMF papers (set IfNDC to 2)
   created date: 24 June 2022
   created by  : Jean Chateau
   called by   : 2022_CountryStudies: CTax.gms and Policy_ICPF.gms
				 2022_IntensityTarget: Policy_ICPF.gms
				 2023_G20: 			Policy_ICPF.gms
				 CoordinationG20:	CTax.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/CommonPolicyFiles/DefineICPF.gms $
   last changed revision: $Rev: 302 $
   last changed date    : $Date: 2020-12-02 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText


$Setargs Gr1Tax Gr2Tax Gr3Tax

$IFi %Gr1Tax%=="" $SetLocal Gr1Tax "75"
$IFi %Gr2Tax%=="" $SetLocal Gr2Tax "50"
$IFi %Gr3Tax%=="" $SetLocal Gr3Tax "25"

* memo : Following values should have been defined:
* - mapr("Coalition1",r), mapr("Coalition2",r), mapr("Coalition3",r)
* - actingReg(r)

* Please precise carbon tax values in %YearUSDCT%=="2018
*   --> they will be converted in model units (ie 2014 USD)

stringency(actingReg,"%YrPhase1%") $ mapr("Coalition1",actingReg) = %Gr1Tax% ;
stringency(actingReg,"%YrPhase1%") $ mapr("Coalition2",actingReg) = %Gr2Tax% ;
stringency(actingReg,"%YrPhase1%") $ mapr("Coalition3",actingReg) = %Gr3Tax% ;

*	Countries applying NDCs in 2021 paper

    $$onText

        Simon Black:  Country that do NDCs instead of CPF
        USA, Canada, Mexico, EU, FRA, GER, UK + most of EU

    $$OffText

IF(IfNDC eq 2,

*   HIC group

    stringency(JPN,t)    $ stringency(JPN,t)    = 155 ;
    stringency(USA,t)    $ stringency(USA,t)    = 209 ;
    stringency(CAN,t)    $ stringency(CAN,t)    = 340 ;
    stringency(kor,t)    $ stringency(kor,t)    = 85  ;
    stringency(Fra,t)    $ stringency(fra,t)    = 290 ;
    stringency(deu,t)    $ stringency(deu,t)    = 235 ;
    stringency(gbr,t)    $ stringency(gbr,t)    = 343 ;
    stringency(RESTEU,t) $ stringency(RESTEU,t) = 250 ;
    stringency(Ita,t)    $ stringency(Ita,t)    = 140 ;
    stringency(Ita,t)    $(stringency(Ita,t) and (VarFlag eq 6)) = 130 ;


*   MIC group

    stringency(mex,t) $ stringency(mex,t) = 75 ;
    stringency(arg,t) $ stringency(arg,t) = 75 ;
    stringency(bra,t) $ stringency(bra,t) = 55 ;

) ;

* Remove non-acting countries

stringency(r,t) $ (NOT actingReg(r)) = 0 ;

stringency(r,t) = AdjGlobalCT(r) * stringency(r,t) ;

*	Carbon Tax in the first year of the ICPF from IMF-FAD (2022)

$onText
   [24June2021]: Starting level: Simon Black
   -   $25 carbon price is assumed to rise from $10 in 2022 to $25 in 2030
   -   $50 carbon price is assumed to rise from $20 in 2022 to $50 in 2030
   -   $75 carbon price is assumed to rise from $30 in 2022 to $75 in 2030

    different from linear interpolation
$offText

IF(IfJumpICPF,
    emiTax.fx(actingReg,%GhgTax%,"%YearPolicyStart%")
        $ (stringency(actingReg,"%YrPhase1%") ge 25)
        = AdjGlobalCT(actingReg) * 10 ;

    emiTax.fx(actingReg,%GhgTax%,"%YearPolicyStart%")
        $ (stringency(actingReg,"%YrPhase1%") ge 50)
        = AdjGlobalCT(actingReg) * 20 ;

    emiTax.fx(actingReg,%GhgTax%,"%YearPolicyStart%")
        $ (stringency(actingReg,"%YrPhase1%") ge 75)
        = AdjGlobalCT(actingReg) * 30 ;
);

* Convert carbon taxes into model units (ie 2014 USD)

emiTax.fx(actingReg,%GhgTax%,"%YearPolicyStart%")
    = emiTax.l(actingReg,%GhgTax%,"%YearPolicyStart%") / m_convCtax ;

* Adjust stringency:
*   do not multiply by cScale, this is done in policy_profile.gms
*   but convert to model units (ie 2014 USD)

stringency(r,t) = stringency(r,t) * ConvertCurToModelUSD("%YearUSDCT%");

*	Define policy : linear implementation after 2023

IF(IfJumpICPF,

* Step 1: From 2023 to %YrPhase1%

    $$IF NOT SET DelayedYear  $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "actingReg,%GhgTax%" "stringency(actingReg,'%YrPhase1%')" "2023" "%YrPhase1%" "linear" "replace"

ELSE

* Step 1 in no-jump case: From %YearPolicyStart% to %YrPhase1%

   $$IF NOT SET DelayedYear  $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "actingReg,%GhgTax%" "stringency(actingReg,'%YrPhase1%')" "%YearPolicyStart%" "%YrPhase1%" "linear" "replace"

) ;

$IFi %DelayedYear%=="2022" $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "actingReg,%GhgTax%" "stringency(actingReg,'%YrPhase1%')" "2023" "%YrPhase1%" "linear" "replace"
$IFi %DelayedYear%=="2023" $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "actingReg,%GhgTax%" "stringency(actingReg,'%YrPhase1%')" "2024" "%YrPhase1%" "linear" "replace"
$IFi %DelayedYear%=="2024" $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "actingReg,%GhgTax%" "stringency(actingReg,'%YrPhase1%')" "2025" "%YrPhase1%" "linear" "replace"
$IFi %DelayedYear%=="2025" $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "actingReg,%GhgTax%" "stringency(actingReg,'%YrPhase1%')" "2026" "%YrPhase1%" "linear" "replace"
$IFi %DelayedYear%=="2026" $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "actingReg,%GhgTax%" "stringency(actingReg,'%YrPhase1%')" "2027" "%YrPhase1%" "linear" "replace"

* Step 2: After %YrPhase1% --> %YrFinTgt% (2050)

$Ife %YrFinTgt%>%YrPhase1% $batinclude "%PolicyPrgDir%\policy_profile.gms" emiTax "actingReg,%GhgTax%" "stringency(actingReg,'%YrPhase1%')" "%YrPhase1%" "%YrFinTgt%" "constant" "replace"


*   Extend ICP after %YrPhase1% = 2030

$IfThene.LR %YearEndofSim%>2030

   LOOP(CO2,
       rwork(r) $ emiTax.l(r,CO2,"2025")
           = [emiTax.l(r,CO2,"2030") / emiTax.l(r,CO2,"2025")]**(1/5);
   ) ;

   rwork(r) $ (NOT IDN(r)) = 0.4 * [rwork(r) - 1] * 100;
   rwork(IDN) = 0.11146048 ;

   Display "Carbon tax growth rate:", rwork ;
   LOOP( t $ (t.val gt 2030),
       emiTax.fx(actingReg,%GhgTax%,t)
           = emiTax.l(actingReg,%GhgTax%,t-1) * ( 1 + rwork(actingReg) * 0.01) ;
   ) ;

$EndIf.LR

*   Safety instructions

emiTax.fx(r,AllEmissions,t) $ after(t,"%YearEndofSim%") = 0 ;
emiTax.fx(r,HighGWP,t) $ (ifGroupFGas)     = 0 ;
emiTax.fx(r,Fgas,t)    $ (NOT ifGroupFGas) = 0 ;

