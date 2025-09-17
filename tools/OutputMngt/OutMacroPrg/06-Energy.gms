$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file : "06-Energy.gms"
    purpose   : Calculate Energy related variables (ongoing)
    created by: Jean Chateau
    called by : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/06-Energy.gms $
   last changed revision: $Rev: 375 $
   last changed date    : $Date:: 2023-08-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
Note on TPES : Millions tonnes of oil equivalent (Mtoe)
        TPES = [XP(fossilea) + XP(s_ren)]
             + Imports - Exports
             - Marine and Aviation Bunkers : ca c'est complique

    car en fait on a Offre de transport itl mais pas la demande fuel associee
    quoique on peut la retouver

    Logically then TPES is then armington demands of primary energy in Mtoe
--------------------------------------------------------------------------------
$OffText

$OnDotL

raagtwork(ra,a,%1) = 0 ;
raagtwork(ra,powa,%1)
    = sum((r,elyi)$(mapr(ra,r) and xp0_TWh(r,powa)), m_true3t(x,r,powa,elyi,%1))
    / Powscale;

*	Total Power generation (from x.l(powa))

raworkT(ra,%1) = sum(powa, raagtwork(ra,powa,%1) );

out_Macroeconomic(abstype,"Energy","Electricity Generation (TWh)",volume,ra,%1)
    = raworkT(ra,%1) ;

out_Macroeconomic(abstype,"Energy","Electricity renewable (share)",volume,ra,%1)
    $ raworkT(ra,%1)
    = 100 * sum(a $ (s_otra(a) or HYDROa(a)), raagtwork(ra,a,%1)) / raworkT(ra,%1) ;

out_Macroeconomic(abstype,"Energy","Electricity Fossil (share)",volume,ra,%1)
    $ raworkT(ra,%1)
	= 100 * sum(mappow("fosp",powa), raagtwork(ra,powa,%1)) / raworkT(ra,%1) ;

* TFC = intermediate energy demand (in Mtoe) from non energy sectors
*     + Final energy demands
* Remark at world level we miss the itl. bunkers
* we do not have either renewable energy demands (incl. biomass) by TFC

out_Macroeconomic(abstype,"Energy","Total final consumption of energy",volume,ra,%1)
    = sum((r,e) $ mapr(ra,r),
          sum(a $ (NOT (elya(a) or fa(a) or tota(a))), nrj_mtoe(r,e,a,%1))
        + sum(fd,nrj_mtoe(r,e,fd,%1))
    ) ;

* Memo
*    Primary energy supply is defined as energy production + energy imports,
*    - energy exports - international bunkers +(-) stock changes.

$OnText
	“primary energy equivalent” for the electricity produced from non-combustible
	if nuke production is 100 Twh and the efficiency of a standard thermal power
	plant is 38% the input-equivalent primary energy would be 100 / 0.38 = 263TW
	Logically average efficiency level increase (0.33 is weak !)

	Assumed efficiency in electricity generation
	(for calculating "primary energy")
	Source          DOE/EIA OECD/IEA
	nuclear power   0.320   0.33
	hydroelectric   0.332   1.00
	biomass         0.332
	wind and solar  0.332   1.00
	geothermal      0.163   0.10
$OffText


*	thermal efficiency in electricity generation to convert from Twh to Mtoe

* Base

work = 0.086 ;  !! --> convert Twh in Mtoe with 1 TWh = 0.086 Mtoe

* Adjustments

rworka(a) = 0 ;
rworka(HYDROa)    = work  ;
rworka(WINDa)     = work  ;
rworka(NUKEa)     = 0.261 ; !! = work / 0.33
rworka(SOLARa)    = 0.4   ;
rworka(COMRENEWa) = 0.33  ; !! Approximation from EEB in 2014

*	1.) TES calculation with Production (= absorption):
* INDPROD + NET IMPORTS (- BUNKERS implicit / xtt) --> xa

out_Macroeconomic(abstype,"Energy","Total energy supply","volume",ra,%1)
    = sum(mapr(ra,r), sum((aa,e), nrj_mtoe(r,e,aa,%1)))

* Add primary energy for non-fossil electicity

	+ sum(powa, rworka(powa) * raagtwork(ra,powa,%1) ) 	;


*	2.) TES calculation with Consumption

* + Intrants des processus de transformation moins les outputs
* + Les distrbutions Losses

out_Macroeconomic(abstype,"Energy","Total energy supply (TFC calc.)",volume,ra,%1)

    = sum(mapr(ra,r),

        sum(e,

* Total final consumption (included non energy use)

            sum(a $ (NOT (elya(a) or fa(a) or Tota(a))), nrj_mtoe(r,e,a,%1))
          + sum(fd,nrj_mtoe(r,e,fd,%1))

* Add Transformation Sectors included Distribution Losses

          + sum(a $ elya(a), nrj_mtoe(r,e,a,%1))
          + sum(a $ (ROILa(a) or gdta(a)), nrj_mtoe(r,e,a,%1))

* Add Energy Industry own use

          + sum(fossilea,nrj_mtoe(r,e,fossilea,%1))

        )

* Power sector losses (already above)

*      + sum((elyi,powa), nrj_mtoe(r,elyi,powa,%1))

* Add primary energy for non-fossil electricity

      + sum(powa, rworka(powa) * raagtwork(ra,powa,%1) )

     ) ;

$offDotL

out_Macroeconomic(abstype,"Energy","Imported energy share",volume,ra,%1)
        $ sum(mapr(ra,r), sum((e,aa), nrj_mtoe_d(r,e,aa,%1) + nrj_mtoe_m(r,e,aa,%1)))
        = sum(mapr(ra,r), sum((e,aa), nrj_mtoe_m(r,e,aa,%1)))
        / sum(mapr(ra,r), sum((e,aa), nrj_mtoe_d(r,e,aa,%1) + nrj_mtoe_m(r,e,aa,%1)))
        ;

out_Macroeconomic(abstype,"Energy","Total energy supply per capita",volume,ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Population",volume,ra,%1)
    = out_Macroeconomic(abstype,"Energy","Total energy supply",volume,ra,%1)
    / out_Macroeconomic(abstype,"Demographic","Population",volume,ra,%1);

* Energy Intensity tonnes of oil equivalent (toe) per thousand %YearBaseMER% USD
* dollars of GDP, calculated using MER

out_Macroeconomic(abstype,"Energy","Energy Intensity",volume,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = out_Macroeconomic(abstype,"Energy","Total energy supply",volume,ra,%1)
    / [0.001 * out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)];


out_Macroeconomic(abstype,"Energy","Energy Intensity (TFC calc.)",volume,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = out_Macroeconomic(abstype,"Energy","Total energy supply (TFC calc.)",volume,ra,%1)
    / [0.001 * out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)];

* Energy Intensity tonnes of oil equivalent (toe) per thousand %YearBasePPP% US
* dollars of GDP, calculated using PPPs = Equivalent of DotStat info using 2011 PPP instead of 2005

out_Macroeconomic(abstype,"Energy","Energy Intensity (cst PPP)",volume,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = out_Macroeconomic(abstype,"Energy","Total energy supply",volume,ra,%1)
    / [0.001 * out_Macroeconomic(abstype,"GDP","GDP (cst PPP)","real",ra,%1)];
