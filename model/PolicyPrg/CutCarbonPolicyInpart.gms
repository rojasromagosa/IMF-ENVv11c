$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy File
   name        : "%PolicyPrgDir%\CutCarbonPolicyInpart.gms"
   purpose     : cut carbon tax for facillitate solve
   created date: 19 Octobre 2021
   created by  : Jean Chateau
   called by   : "%ModelDir%\8-solve.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/CutCarbonPolicyInpart.gms $
   last changed revision: $Rev: 266 $
   last changed date    : $Date:: 2023-03-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------

    The argument of batinclude is : %1 : %ModelName%
    This file is activated only when IfCutInpart is a positive number
    IfCutInpart equals the number of slices of the shock
$OffText


* For Caps policy --> cut the target in part

tvol = sum(rq,IfCap(rq)) ;

tvol = 0 ;

work = 1 / IfCutInpart;

Display "work from IfCutInpart:", work ;

while(work lt 1,

* Exogenous Carbon Tax

    part(r,em,EmiSource,aa,tsim)
        $ (part(r,em,EmiSource,aa,tsim) and not tvol) = work;

* Exogenous Caps

    emiCap.fx(rq,em,tsim) $ tvol
        = 1.03 * (1 - work) + emiCap.l(rq,em,tsim) * work ;

*   Solve the Global model

    IF(work lt 1,
        $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%
    );

    work = work + 1 / IfCutInpart;

* Recover part : Exogenous Carbon Tax

    part(r,em,EmiSource,aa,tsim)
        $ (part(r,em,EmiSource,aa,tsim) and not tvol) = work;

* Recover true Cap
    emiCap.fx(rq,em,tsim) $ tvol
        = [emiCap.l(rq,em,tsim) - 1.03 * (1 - work)] / work;

* Adjusted cap for next iteration

    emiCap.fx(rq,em,tsim) $ tvol
        = 1.03 * (1 - work) + emiCap.l(rq,em,tsim) * work ;
);

IF(0, Execute_unload "Check_IfCutInpart.gdx", IfCutInpart, work, part ; );
