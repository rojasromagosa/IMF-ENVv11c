
$SETLOCAL batincludeFile %1

* otherArguments = {"slicePercentage"}

$SETLOCAL otherArguments %2

* Model standard variables

*                             | variable/param | indices    | mode     | startvalue  | condition | arguments

$BATINCLUDE %batincludeFile%    tmarg           r,i,rp        "var"      "tsim-1"         1         %otherArguments%
$BATINCLUDE %batincludeFile%    theta           r,k,h         "var"      "tsim-1"         1         %otherArguments%
$BATINCLUDE %batincludeFile%    savf            r             "var"      "tsim-1"         1         %otherArguments%
$BATINCLUDE %batincludeFile%    pop             r             "var"      "tsim-1"         1         %otherArguments%
$BATINCLUDE %batincludeFile%    k0              r,a           "param"    "tsim-1"         1         %otherArguments%
$BATINCLUDE %batincludeFile%    LFPR            r,l,z         "var"      "tsim-1"         1         %otherArguments%
$BATINCLUDE %batincludeFile%    glabz           r,l,z         "var"      "0"              1         %otherArguments%
$BATINCLUDE %batincludeFile%    UNR             r,l,z         "var"      "tsim-1"         1         %otherArguments%
$BATINCLUDE %batincludeFile%    popWA           r,l,z         "var"      "tsim-1"         1         %otherArguments%
$BATINCLUDE %batincludeFile%    grrgdppc        r             "var"      "0"              1         %otherArguments%

$IfTheni.Var %SimType%=="variant"
    $$BATINCLUDE %batincludeFile% LFPR_bau  r,l,z      "param"      "tsim-1" 1  %otherArguments%
    $$BATINCLUDE %batincludeFile% rwage_bau r,l,z      "param"      "tsim-1" 1  %otherArguments%
    $$BATINCLUDE %batincludeFile% gl        r          "var"        0        1  %otherArguments%
$Endif.Var

* Exogenous productivity improvements

$BATINCLUDE %batincludeFile% g_fp   r,a    "param"  "0"  1 %otherArguments%
$BATINCLUDE %batincludeFile% g_kt   r,a,v  "param"  "0"  1 %otherArguments%
$BATINCLUDE %batincludeFile% g_xp   r,a,v  "param"  "0"  1 %otherArguments%

* Other exogenous variables

$BATINCLUDE %batincludeFile% rgovshr  r "var" "tsim-1"  1 %otherArguments%
$BATINCLUDE %batincludeFile% invshr   r "var" "tsim-1"  1 %otherArguments%
*$BATINCLUDE %batincludeFile% extra_savg  r,gov "param" "tsim-1" 1 %otherArguments%
*$BATINCLUDE %batincludeFile% extra_savh  r,h   "param" "tsim-1" 1 %otherArguments%

* Total factor productivity and efficiency variables

$BATINCLUDE %batincludeFile% TFP_xpx  r,a,v   "var" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% TFP_xs   r,i     "var" "tsim-1" 1  %otherArguments%

* [2023-04-06] [EditJean]: on bloque ca
*$BATINCLUDE %batincludeFile% TFP_fp   r,a     "var" "tsim-1" 1  %otherArguments%

* [EditJean]: in my version
$BATINCLUDE %batincludeFile% lambdapow  r,pb,elyi   "param"  "tsim-1" 1  %otherArguments%

* [EditJean]: add-ons
$BATINCLUDE %batincludeFile% lambdapb   r,a,elyi    "param"  "tsim-1" 1 %otherArguments%
$BATINCLUDE %batincludeFile% g_xs       r,i         "param"  "0"      1 %otherArguments%

$BATINCLUDE %batincludeFile% lambdat  r,a,v   "var" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% lambdal  r,l,a   "var" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% lambdaio r,i,a   "var" "tsim-1" 1  %otherArguments%

$IfTheni %SliceLambdae%=="ON"
    $$BATINCLUDE %batincludeFile% lambdae  r,e,a   "var" "tsim-1" 1  %otherArguments%
    $$BATINCLUDE %batincludeFile% lambdace r,e,k,h "var" "tsim-1" 1  %otherArguments%
$Endif

$BATINCLUDE %batincludeFile% lambdafd r,i,fd  "var" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% lambdak  r,a,v   "var" "tsim-1" 1  %otherArguments%

* [EditJean]: not in my version
*$BATINCLUDE %batincludeFile% lambdaas r,a,i   "var" "tsim-1" 1  %otherArguments%

$BATINCLUDE %batincludeFile% chinrf   r,a     "var" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% chiLand  r       "var" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% tland    r       "var" "tsim-1" 1  %otherArguments%

* Production CES-parameters

$BATINCLUDE %batincludeFile% and1  r,a,v      "param"  "tsim-1"   "nd1Flag(r,a)"  %otherArguments%
$BATINCLUDE %batincludeFile% ava   r,a,v      "param"  "tsim-1"   "xpFlag(r,a)"  %otherArguments%
$BATINCLUDE %batincludeFile% alab  r,l,a      "param"  "tsim-1"   1  %otherArguments%
$BATINCLUDE %batincludeFile% alab1 r,a,v      "param"  "tsim-1"   "lab1Flag(r,a)"  %otherArguments%
*$BATINCLUDE %batincludeFile% akef  r,a,v      "param"  "tsim-1"   1  %otherArguments%
$BATINCLUDE %batincludeFile% ava1  r,a,v      "param"  "tsim-1"   "va1Flag(r,a)"  %otherArguments%
$BATINCLUDE %batincludeFile% aland r,a,v      "param"  "tsim-1"   1  %otherArguments%
*$BATINCLUDE %batincludeFile% akf   r,a,v      "param"  "tsim-1"   1  %otherArguments%
$BATINCLUDE %batincludeFile% ae    r,a,v      "param"  "tsim-1"   1  %otherArguments%
$BATINCLUDE %batincludeFile% anrf  r,a,v      "param"  "tsim-1"   1  %otherArguments%
$BATINCLUDE %batincludeFile% aio   r,i,a      "param"  "tsim-1"   1  %otherArguments%
*$BATINCLUDE %batincludeFile% anely r,a,v      "param"  "tsim-1"   1  %otherArguments%
*$BATINCLUDE %batincludeFile% aolg  r,a,v      "param"  "tsim-1"   1  %otherArguments%
*$BATINCLUDE %batincludeFile% anrg  r,a,NRG,v  "param"  "tsim-1"   1  %otherArguments%
*$BATINCLUDE %batincludeFile% aeio  r,e,a,v    "param"  "tsim-1"   1  %otherArguments%
*$BATINCLUDE %batincludeFile% ak    r,a,v      "param"  "tsim-1"   1  %otherArguments%
*$BATINCLUDE %batincludeFile% aksw  r,a,v      "param"  "tsim-1"   1  %otherArguments%

* [EditJean]: these are parameters in my version
$BATINCLUDE %batincludeFile% as     r,a,i      "param"  "tsim-1"   "xpFlag(r,a)"  %otherArguments%
$BATINCLUDE %batincludeFile% apb    r,pb,elyi  "param"  "tsim-1"   1  %otherArguments%

$BATINCLUDE %batincludeFile% alphafd   r,i,fd  "param"  "tsim-1"   1  %otherArguments%

$BATINCLUDE %batincludeFile% emir      r,AllEmissions,EmiSource,aa  "param" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% muc       r,k,h                        "var"   "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% mus       r,h                          "var"   "tsim-1" 1  %otherArguments%

$IfTheni.Var %SimType%=="variant"
$BATINCLUDE %batincludeFile% xfd       r,gov  "var" "tsim-1"  1  %otherArguments%
$EndIf.Var

*   Taxes

* Government closure: only sliced if exogenous

$BATINCLUDE %batincludeFile% kappah    r      "var" "tsim-1"  "GovBalance(r) ne 0"  %otherArguments%
$BATINCLUDE %batincludeFile% rsg       r      "var" "tsim-1"  "GovBalance(r) ne 1"  %otherArguments%
$BATINCLUDE %batincludeFile% trg       r      "var" "tsim-1"  "GovBalance(r) ne 2"  %otherArguments%
$BATINCLUDE %batincludeFile% chiVAT    r      "var" "tsim-1"  "GovBalance(r) ne 4"  %otherArguments%

* [TBU] --> one kappa var + case recycling
*$BATINCLUDE %batincludeFile% kappafp   r,fp   "var" "tsim-1"  "GovBalance(r) ne 3 AND l(fp)" %otherArguments%
$BATINCLUDE %batincludeFile% kappal   r,l   "var" "tsim-1"  "GovBalance(r) ne 3"  %otherArguments%
$BATINCLUDE %batincludeFile% kappak   r     "var" "tsim-1"  1                     %otherArguments%
$BATINCLUDE %batincludeFile% kappat   r     "var" "tsim-1"  1                     %otherArguments%
$BATINCLUDE %batincludeFile% kappan   r     "var" "tsim-1"  1                     %otherArguments%

* Climate scenario variables: emiTax exogenous only if emiCap is not

$BATINCLUDE %batincludeFile% emiCap     ra,em "var"  "start"   "IfEmCap(ra,em)"      %otherArguments%
$BATINCLUDE %batincludeFile% emiCapFull ra    "var"  "start"   "IfCap(ra)"           %otherArguments%
$BATINCLUDE %batincludeFile% emiTax     r,em  "var"  "tsim-1"  "NOT emFlag(r,em)"    %otherArguments%
$BATINCLUDE %batincludeFile% emiRegTax  ra,em "var"  "tsim-1"  "NOT IfEmCap(ra,em)"  %otherArguments%

$BATINCLUDE %batincludeFile% ptax    r,a     "var" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% paTax   r,i,aa  "var" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% mTax    r,i,rp  "var" "tsim-1" 1  %otherArguments%
$BATINCLUDE %batincludeFile% eTax    r,i,rp  "var" "tsim-1" 1  %otherArguments%

* [EditJean]: add-ons
$BATINCLUDE %batincludeFile% p_emissions    r,CO2,EmiFosComb,aa  "param" "tsim-1" 1  %otherArguments%

* [TBU] -->

*$BATINCLUDE %batincludeFile% Taxfp r,a,fp  "var" "tsim-1" 1 %otherArguments%
*$BATINCLUDE %batincludeFile% Subfp r,a,fp  "var" "tsim-1" 1 %otherArguments%

* [EditJean]: my version
$BATINCLUDE %batincludeFile% ltax    r,l,a  "var" "tsim-1" "labFlag(r,l,a)" %otherArguments%
$BATINCLUDE %batincludeFile% ktax    r,a,v  "var" "tsim-1" "kFlag(r,a)"     %otherArguments%
$BATINCLUDE %batincludeFile% landTax r,a    "var" "tsim-1" "LandFlag(r,a)"  %otherArguments%
$BATINCLUDE %batincludeFile% nrfTax  r,a    "var" "tsim-1" "nrfFlag(r,a)"   %otherArguments%

* Other policy variables

$BATINCLUDE %batincludeFile% overAcc r,a,v   "var"    "tsim-1"   1  %otherArguments%

* Endogenous variables that are sometimes endogenized

$BATINCLUDE %batincludeFile% xc      r,k,h   "var"    "tsim-1"  1   %otherArguments%

!! initialization of depr is set for equation kstockeq to be verified
!! when kstock and xfd are initialized at their tsim-1 value

*$BATINCLUDE %batincludeFile% depr   r       "param"   depr_start(r,tsim)  1  %otherArguments%

*   Targetting Calibration parameters in Baseline mode

$IFI %SIMTYPE%=="Baseline" $BATINCLUDE %batincludeFile% SectoralTarget  SetSectTgt,r,js,aa  "param" "tsim-1"  1  %otherArguments%

* Suppress instructions associated to %module_SectInv% &
* and %module_ClimateTransitionCosts% from here --> see ENV-Linkages\trunk

