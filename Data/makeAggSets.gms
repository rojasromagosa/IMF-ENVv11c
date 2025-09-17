$OnText
--------------------------------------------------------------------------------
   Envisage 10 / OECD-ENV project  -- Data preparation modules
	GAMS file   : "%DataDir%\makeAggSets.gms"
    purpose     : Save and then re-read 'final' labels
    created by  : Dominique van der Mensbrugghe
    created date: 21.10.16
    called by   : "%DataDir%\AggGTAP.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/makeAggSets.gms $
   last changed revision: $Rev: 394 $
   last changed date    : $Date:: 2023-09-11 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

file asets / tmpSets.gms / ;
put asets ;

put '$onempty' / / ;
put 'set actf "Modeled activities" /' / ;

* Use the model aggregation

loop(actf,
   strlen = card(actf.tl) ;
   put '   ', actf.tl:<strlen, '':(MaxStrLen-strlen), '     "', actf.te(actf), '"' / ;
) ;
put '/ ;' / / ;

put 'set mapact(a,actf) "Activity mapping" /' / ;
loop(actf,
   strlen = card(actf.tl) ;
   put '    ', actf.tl:<strlen, '-a', '.', actf.tl / ;
) ;
put '/ ;' / / ;

put 'set commf "Modeled commodities" /' / ;

* Use the model aggregation

loop(commf,
   strlen = card(commf.tl) ;
   put '    ', commf.tl:<strlen, '':(MaxStrLen-strlen), '     "', commf.te(commf), '"' / ;
) ;
put '/ ;' / / ;

put 'set mapcomm(i,commf) "Commodity mapping" /' / ;
loop(commf,
   strlen = card(commf.tl) ;
   put '    ', commf.tl:<strlen, '-c', '.', commf.tl / ;
) ;
put '/ ;' / / ;

put 'set elycf(commf) "Electricity commodities" /' / ;
loop(commf $ elyi(commf),
   strlen = card(commf.tl) ;
   put '    ', commf.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', commf.te(commf), '"' / ;
) ;
put '/ ;' / / ;

put 'set kf "Household commodities" /' / ;
loop(k,
   strlen = card(k.tl) ;
   put '    ', k.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', k.te(k), '"' / ;
) ;
put '/ ;' / / ;

put 'set mapkcomm(k,kf) "Household commodity mapping" /' / ;
loop(k,
   strlen = card(k.tl) ;
   put '    ', k.tl:<strlen, '-k', '.', k.tl / ;
) ;
put '/ ;' / / ;

* [EditJean]: We need these sets to be defined to run "convertLabel.gms"

$IfThenI.WriteNDBundles SET BundleChoiceInModel

    put 'set pb "Power bundles in power aggregation" /' / ;
    loop(pb,
        strlen = card(pb.tl) ;
        put '    ', pb.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', pb.te(pb), '"' / ;
    ) ;
    put '/ ;' / / ;

    put 'set lb "Land bundles" /' / ;
    loop(lb,
        strlen = card(lb.tl) ;
        put '    ', lb.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', lb.te(lb), '"' / ;
    ) ;
    put '/ ;' / / ;

$Endif.WriteNDBundles

put '$offempty' ;

putclose asets ;
