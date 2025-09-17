* Instructions commonly used in variants for changing governement budget rules

* Change the value of the flag "GovBalance" determined using various value of
* the global variable %Recycling% defined in Main project files
*	(e.g. "RunVariant.gms" or "RunCompStat.gms")

$Ifi %Recycling%=="kappah" GovBalance(r) = 0 ;
$Ifi %Recycling%=="rsg"    GovBalance(r) = 1 ;
$Ifi %Recycling%=="trg"    GovBalance(r) = 2 ;
$Ifi %Recycling%=="wage"   GovBalance(r) = 3 ;
$Ifi %Recycling%=="vat"    GovBalance(r) = 4 ;

*	Variant Case --> #todo check that works for compStat case

$iftheni not "%simType%" == "CompStat"
***HRR: took away, making govBal=4 not run, and GovBal=0 have strange wage/empl dynamics! To discuss with Jean

IF(ifDyn,
$ontext
	AdjTaxCov(r,i,h) $ (GovBalance(r) eq 4) = 2 ; !! additive shock on vat
	chiVAT.l(r,tsim) $ (GovBalance(r) eq 4) = 0 ;

	WageIndexRule(r)      $ (GovBalance(r) eq 0) = 1 ;
	rwage_bau(r,l,z,tsim) $ (GovBalance(r) eq 0)
		= m_netwage(r,l,z,tsim) / sum(h,PI0_xc.l(r,h,tsim)) ;
$offtext

) ;


$endif