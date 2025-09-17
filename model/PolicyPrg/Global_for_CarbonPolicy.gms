$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy
   name        : "%PolicyPrgDir%\Global_for_CarbonPolicy.gms.gms
   purpose     : default values for Global variables defining carbon policies
   created date: 25 June 2022
   created by  : Jean Chateau
   called by   : various files
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/Global_for_CarbonPolicy.gms $
   last changed revision: $Rev: 326 $
   last changed date    : $Date: 2020-12-02 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Global variables that could be defined in BATCH Mode

    Memo Default:

    $$IF Not SET rPol       $SetGlobal rPol       "r"
    $$IF Not SET GhgTax     $SetGlobal GhgTax     "EmSingle"
    $$IF Not SET SrcTax     $SetGlobal SrcTax     "EmiFosComb"
    $$IF Not SET cTaxLevel  $SetGlobal cTaxLevel  "50"
    $$IF Not SET AgentTax   $SetGlobal AgentTax   "a"
    $$IF Not SET BCA_policy $SetGlobal BCA_policy "OFF"
    $$IF Not SET OverCTax   $SetGlobal OverCTax   "ON"
    $$If Not SET YrPhase1   $SetGlobal YrPhase1   "2030"
    $$If Not SET YrPhase2   $SetGlobal YrPhase2   "2000"
    $$If Not SET YrFinTgt   $SetGlobal YrFinTgt   "2050"

$OffText

$SetGlobal YearNDC "2030"

*   1.) Selected region subject to the carbon Tax

* rPol = {r(default), OECD, ...}

$IF Not SET rPol      $SetGlobal rPol "r"

*   2.)  Default selected type of Gas subject to the carbon Tax

* GhgTax = {em(default),EmSingle,oap,emn,HighGWP,EmSingle,CH4N2O,CO2,'CH4',..}

$IF Not SET GhgTax    $SetGlobal GhgTax "EmSingle"

*   3.)  Selected source of emission subject to the carbon Tax

* SrcTax = {EmiSource,EmiUse,EmiFp,EmiComb,EmiFosComb(default),chemUse,emiact,
*                   EmiSourceAct,'coalcomb',emimainSource,..}

$IF Not SET SrcTax    $SetGlobal SrcTax "EmiFosComb"

*   4.)  Carbon tax level

$IF Not SET cTaxLevel $SetGlobal cTaxLevel "50"

*   5.)  Selected sector covered by the carbon Tax --> this will define a set

* AgentTax = {a(default),aa,'i_s',fd, EITEa, ...}

$IF Not SET AgentTax  $SetGlobal AgentTax "a"

* 6.)  Activate BCA policy

$IF Not SET BCA_policy $SetGlobal BCA_policy "OFF"

* 7.)  Replace Existing (baseline) carbon pricing

$IF Not SET OverCTax $SetGlobal OverCTax "ON"

* 8.)  Default remarkable years

$OnText
   - %YrPhase1%        : year with intermediate targets for tax or caps
   - %YrPhase2%        : year with a second intermediate target
   - %YrFinTgt%        : year with Final Targets
$OffText

$If Not SET YrPhase1 $SetGlobal YrPhase1 "2030"
$If Not SET YrFinTgt $SetGlobal YrFinTgt "2050"

* Memo: to activate 3-steps declare a %YrPhase2% > %YrPhase1% (by default: not activated)

$If Not SET YrPhase2 $SetGlobal YrPhase2 "2000"

* safety conditions

$IFe %YearEndofSim%<%YrPhase1% $SetGlobal YrPhase1 "%YearEndofSim%"
$IFe %YearEndofSim%<%YrPhase2% $SetGlobal YrPhase2 "%YearEndofSim%"
$IFe %YearEndofSim%<%YrFinTgt% $SetGlobal YrFinTgt "%YearEndofSim%"








