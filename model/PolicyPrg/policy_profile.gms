$OnText

$batinclude "%folder_model%\common\policy_profile.gms" [instrument] [coverage] [Level of tax instrument] [StartYear of policy] [End Convergence year] [typeExtrapolation] [FormTax]
                                                            1            2                    3                      4                 5                 6                   6
Example : paTax.fx(r,i,aa,t)
Arguments
   1     instrument              --> paTax, emiTax
   2     coverage                --> "r,mining"
   3     Targeted Level of policy instrument --> 0.1
   4     StartYear of policy     --> %YearPolicyStart%
   5     End Convergence year    --> %YearPolicyStart%+3
   6     typeExtrapolation       --> {linear,convergence,constant}
   7     FormTax                 --> {replace,onexisting, trueshock}

   $$batinclude "%folder_model%\common\policy_profile.gms" paTax     "r,mining"        0.1                                                           %YearPolicyStart% 2020 linear replace
   $$batinclude "%folder_model%\common\policy_profile.gms" lambdaio  "%rPol%,i,a" "delta_lambdaio(%rPol%,i,a,t)*stringency(%rPol%,t)" %YearPolicyStart% %YearPolicyEnd% linear onexisting
$OffText


$setlocal PolVar            "%1"
$setlocal Source            "%2"    !! Exple r,CO2,a
$setlocal Target            "%3"    !! Exple 50
$setlocal YrStart           "%4"    !! Included
$setlocal YrEnd             "%5"    !! Included
$setlocal typeExtrapolation "%6"
$setlocal FormTax           "%7"

*---    Special case Flag 4 become a speed of convergence
$setlocal ConvSpeed         "%4"

work = 0; vol = 0;
vol = %YrStart% - 1;

$Ifi %PolVar%=="emiTax"      $setlocal Target "cscale * %Target%"
$Ifi %PolVar%=="p_emissions" $setlocal Target "cscale * %Target%"

$IfTheni.linear %typeExtrapolation%=="linear"
    Loop(t$(t.val ge %YrStart% and t.val le %YrEnd%),
        work = [t.val-vol] / [%YrEnd%-vol];
        %PolVar%.fx(%Source%,t) $(%Target% gt 0)
            $$Ifi %FormTax%=="replace"    = Max( sum(tsim$(tsim.val eq vol), %PolVar%.l(%Source%,tsim)) * (1-work) + (%Target%) * work, %PolVar%.l(%Source%,t) );
            $$Ifi %FormTax%=="onexisting" = (%Target%) * work + %PolVar%.l(%Source%,t);
            $$Ifi %FormTax%=="trueshock"  = %Target% + %PolVar%.l(%Source%,t);
        %PolVar%.fx(%Source%,t) $(%Target% le 0)
            $$Ifi %FormTax%=="replace"    = Min( sum(tsim$(tsim.val eq vol), %PolVar%.l(%Source%,tsim)) * (1-work) + (%Target%) * work, %PolVar%.l(%Source%,t));
            $$Ifi %FormTax%=="onexisting" = (%Target%) * work + %PolVar%.l(%Source%,t);
            $$Ifi %FormTax%=="trueshock"  = %Target% + %PolVar%.l(%Source%,t);
    );
$EndIf.linear

$IfTheni.linear %typeExtrapolation%=="convergence"
    Loop(t $ (t.val ge %YrStart% and t.val le %YrEnd%),
        %PolVar%.fx(%Source%,t)
            =  %Target% * %ConvSpeed%
            + ( 1 - %ConvSpeed%) * %PolVar%.l(%Source%,t-1);
    );
$EndIf.linear

$IfTheni.constant %typeExtrapolation%=="constant"
    Loop(t$(t.val ge %YrStart% and t.val le %YrEnd%),
        %PolVar%.fx(%Source%,t) = %Target%
        $$Ifi %FormTax%=="onexisting" + %PolVar%.l(%Source%,t)
        ;
    );
$EndIf.constant


$droplocal PolVar
$droplocal Source
$droplocal Target
$droplocal typeExtrapolation
$droplocal ConvSpeed
$droplocal FormTax
$droplocal YrStart
$droplocal YrEnd
