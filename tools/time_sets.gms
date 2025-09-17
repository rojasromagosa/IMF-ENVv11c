$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model - V.1 - Miscellaneous instructions
   GAMS file    : "%ToolsDir%\time_sets.gms""
   purpose      : Define various time sets from a given definition of time
                  like %1 = {t,tt,...}
   Created by   : Jean Chateau
   Created date : 15 Mars 2021
   called by    : %ModelDir%\%SimType%.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/time_sets.gms $
   last changed revision: $Rev: 198 $
   last changed date    : $Date:: 2023-01-20 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
Exple: between2(t,"2020","%YearEndWEO%")
$OffText

$setlocal time "%1"

alias(%time%,%time%2);
alias(%time%,%time%3);
sets
    before(%time%,%time%2)           "time period strictly before the second index"
    beforeOrEQ(%time%,%time%2)       "time period before or equal the second index"
    after(%time%,%time%2)            "time period strictly after the second index"
    between(%time%,%time%2,%time%3)  "time period strictly between second and third index"
    between1(%time%,%time%2,%time%3) "time period between second (included) and third (not included)"
    between2(%time%,%time%2,%time%3) "time period between second (not included) and third (included)"
    between3(%time%,%time%2,%time%3) "time period between second (included) and third (included)"
;

before(%time%,%time%2)     $(ord(%time%)<ord(%time%2))    = 1 ;

beforeOrEQ(%time%,%time%2) $(ord(%time%) le ord(%time%2)) = 1 ;

after(%time%,%time%2)      $(ord(%time%)>ord(%time%2))    = 1;

between(%time%,%time%2,%time%3)
    $(after(%time%,%time%2)   and before(%time%,%time%3) ) = 1;

between1(%time%,%time%2,%time%3)
    $(after(%time%,%time%2-1) and before(%time%,%time%3) ) = 1;

between2(%time%,%time%2,%time%3)
    $(after(%time%,%time%2)   and before(%time%,%time%3+1) ) = 1;

between3(%time%,%time%2,%time%3)
    $(after(%time%,%time%2-1) and before(%time%,%time%3+1) ) = 1;

PARAMETER tCount(%time%2,%time%)  "Nb of year between first and second";
tCount(%time%2,%time%) = ord(%time%) - ord(%time%2);

$droplocal time

