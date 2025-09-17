$OnText
--------------------------------------------------------------------------------
			OECD-ENV Model version 1.0 - Policy
	name        : "%PolicyPrgDir%\Automatic_Sectors_Cleaning_With_CO2price.gms"
	purpose     : Instructions commonly used in policy variants to clean
				  between 2 periods some sectors -> xpFlag(r,a) > 0
	created date: 2024-02-01
	created by  : Jean Chateau
	called by   : "%iFilesDir%\AdjustSimOption.gms" or %PolicyFile%
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/LULUCF_Scenario.gms $
	last changed revision: $Rev: 339 $
	last changed date    : $Date:: 2023-06-22 #$
	last changed by      : $Author: chateau_j $
--------------------------------------------------------------------------------
	%MinValTC%		= Minimum value of CO2 to trigger cleaning
	%CleanedSector% = Sector to be cleanned, SHOULD BE AN EXPRESSION of "a"
					  like "fa(a)" or "mappow("fosp",a) or fa(a)"
	%MaxXP%			= Maximum size of the sector (in millions USD)
					  under the value the sector is cleaned
The sector is also cleaned if value of production is lower than 1% initial value
--------------------------------------------------------------------------------
$offText

* 	Basic_Sectors_Cleaning_With_CO2price.gms

$setArgs MinValTC MaxXP CleanedSector

*
* some sector according to level of carbon price on CO2 (i.e. rwork(r))

*   Assign model carbon tax value to rwork(r)

LOOP(CO2,
	rwork(r) = Max( emiTax.l(r,CO2,tsim) , emiTax_ref(r,CO2,tsim) ) / cScale ;

* standard cleaning condition

	rwork_bis(r) $ (rwork(r) gt %MinValTC% or emFlag(r,CO2)) = 1 ;

) ;

display "Year: "  , year  ;
display "CO2 Tax ", rwork ;
display "Number of policy (i.e. VarFlag) ", VarFlag ;

* Basic sectors cleaning (Fossil-fuel Power & Fossil fuel sectors)

* Condition: Minimum of 1% of xp initial value or %MaxXP% USD

riswork(r,a) = Min(%MaxXP%, 0.01 * xpT(r,a,"%YearStart%")) ;

LOOP(a $ (%CleanedSector%),
	xpFlag(r,a)	$ ( (xpT(r,a,tsim-1) lt riswork(r,a)) AND rwork_bis(r) ) = 0 ;
) ;
