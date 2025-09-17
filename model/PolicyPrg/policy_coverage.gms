$OnText

$batinclude "%PolicyPrgDir%\policy_coverage.gms" [instrument] [coverage] [Level of tax instrument] [StartYear of policy] [End Convergence year] [typeExtrapolation]
                                                            1            2                    3                      4                 5                 6
Example : paTax.fx(r,i,aa,t)
Arguments
   1     instrument              --> part or any parameter
   2     coverage                --> "r,mining"
   3     Level of tax instrument --> 0.1
   4     StartYear of policy     --> %YearPolicyStart%
   5     End Convergence year    --> %YearPolicyStart%+3
   6     typeExtrapolation       --> linear

part(r,em,EmiSource,aa,t) --> emiTax(r,em,aa,t)
mat_cov(r,i,aa,t) --> matTax(r,CCC_name,t)


   $$batinclude "%folder_model%\common\policy_profile.gms" paTax 0.1 "r,mining" %YearPolicyStart% 2020 linear

$OffText

$setlocal Coverage "%1"
$setlocal typeExtrapolation "%6"
$setlocal Target "%3"

work = 0; vol = 0;
vol   = %4 - 1;

$IfThenI.linear %typeExtrapolation%=="linear"
    Loop(t$(t.val ge %4 and t.val le %5),
        work = [t.val-vol] / [%5-vol];
        %Coverage%(%2,t)
            = sum(tsim$(tsim.val eq vol), %Coverage%(%2,tsim)) * (1-work)
            + %Target% * work;
    );
    Loop(t$(t.val gt %5 and t.val le %YearEndofSim%),
        %Coverage%(%2,t) = %Coverage%(%2,t-1);
    );
$ENDIF.linear

$IfThenI.constant %typeExtrapolation%=="constant"
    Loop(t$(t.val ge %4 and t.val le %YearEndofSim%),
        %Coverage%(%2,t) = %Target%;
    );
$ENDIF.constant

$IfThenI.multiplier %typeExtrapolation%=="multiplier"
    Loop(t$(t.val ge %4 and t.val le %YearEndofSim%),
        %Coverage%(%2,t) = %Coverage%(%2,t)*%Target%;
    );
$ENDIF.multiplier

$droplocal Coverage
$droplocal typeExtrapolation
$droplocal Target