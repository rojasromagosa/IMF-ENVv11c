********************************************************************************************
*** Adjustments to GTAP v11c 2017 base data
$oneolcom

** We also need to modify gwhr which is estimated using the original x/xp data from GTAP
parameter gwhr(a,r) "Power output in Gwh" ;
execute_loaddc "%iDataDir%\agg\%Prefix%Sat.gdx", gwhr ;

parameter adjfactor ;

********************************************************************************************
*** Add nuclear generation in Egypt using EUR cost structure as reference (power plant is built by RUS)

adjfactor = 0.001; 

gwhr("NUC","EGY") = gwhr("NUC","EUR") * adjfactor ;
*** Supply
* Domestic purchases by firms
	vdfa(i,"NUC","EGY") = vdfa(i,"NUC","EUR") * adjfactor ;
	vdfm(i,"NUC","EGY") = vdfm(i,"NUC","EUR") * adjfactor ;
*** issue that EUR uses coa, clp and xel as intermediate inputs, but EGY does have any of those
	vdfa("coa","NUC","EGY") = 0 ; 	vdfa("clp","NUC","EGY") = 0 ; 	vdfa("xel","NUC","EGY") = 0 ; 
	vdfm("coa","NUC","EGY") = 0 ; 	vdfm("clp","NUC","EGY") = 0 ; 	vdfm("xel","NUC","EGY") = 0 ;
***    
	vdfa("NUC",a,"EGY") = vdfa("NUC",a,"EUR") * adjfactor ;
	vdfm("NUC",a,"EGY") = vdfm("NUC",a,"EUR") * adjfactor ;

* Domestic purchases by households
    vdpa("NUC","EGY")   = vdpa("NUC","EUR")  * adjfactor ; 
	vdpm("NUC","EGY")   = vdpm("NUC","EUR")  * adjfactor ;

* Domestic purchases by government
    vdga("NUC","EGY")   = vdga("NUC","EUR")  * adjfactor ;
	vdgm("NUC","EGY")   = vdgm("NUC","EUR")  * adjfactor ;

* Primary factor purchases
	evfa(fp,"NUC","EGY")  = evfa(fp,"NUC","EUR") * adjfactor ;
    vfm(fp,"NUC","EGY")   = vfm(fp,"NUC","EUR") * adjfactor ;

*** Excluded trade!
* Non-margin exports (imports)
*    vxmd("NUC","EUR",d) = vxmd("NUC","EUR",d) * adjfactor ;
*    vxmd("NUC",s,"EUR") = vxmd("NUC",s,"EUR") * adjfactor ;
*
*    vxwd("NUC","EUR",d) = vxwd("NUC","EUR",d) * adjfactor ;
*    vxwd("NUC",s,"EUR") = vxwd("NUC",s,"EUR") * adjfactor ;
*** Demand
* Import purchases by firms
*  	vifa(i,"NUC","EUR") = vifa(i,"NUC","EUR") * adjfactor ;
*	vifm(i,"NUC","EUR") = vifm(i,"NUC","EUR") * adjfactor ;

************************
*** Oman Wind
adjfactor = 3; 
gwhr("WND","OMN") = gwhr("WND","JOR") * adjfactor ;
	vdfa(i,"WND","OMN") = vdfa(i,"WND","JOR") * adjfactor ;
	vdfm(i,"WND","OMN") = vdfm(i,"WND","JOR") * adjfactor ;
    vdpa("WND","OMN")   = vdpa("WND","JOR")  * adjfactor ; 
	vdpm("WND","OMN")   = vdpm("WND","JOR")  * adjfactor ;
    vdga("WND","OMN")   = vdga("WND","JOR")  * adjfactor ;
	vdgm("WND","OMN")   = vdgm("WND","JOR")  * adjfactor ;
	evfa(fp,"WND","OMN")  = evfa(fp,"WND","JOR") * adjfactor ;
    vfm(fp,"WND","OMN")   = vfm(fp,"WND","JOR") * adjfactor ;

*Solar OMAN
adjfactor = 300; 
gwhr("sol","OMN") = gwhr("sol","OMN") * adjfactor ;
	vdfa(i,"SOL","OMN") = vdfa(i,"SOL","OMN") * adjfactor ;
	vdfm(i,"SOL","OMN") = vdfm(i,"SOL","OMN") * adjfactor ;
    vdpa("SOL","OMN")   = vdpa("SOL","OMN")  * adjfactor ; 
	vdpm("SOL","OMN")   = vdpm("SOL","OMN")  * adjfactor ;
    vdga("SOL","OMN")   = vdga("SOL","OMN")  * adjfactor ;
	vdgm("SOL","OMN")   = vdgm("SOL","OMN")  * adjfactor ;
	evfa(fp,"SOL","OMN")  = evfa(fp,"SOL","OMN") * adjfactor ;
    vfm (fp,"SOL","OMN")  = vfm (fp,"SOL","OMN") * adjfactor ;


*gas OMAN
adjfactor = 2; 
gwhr("GSP","OMN") = gwhr("GSP","OMN") * adjfactor ;
	vdfa(i,"GSP","OMN") = vdfa(i,"GSP","OMN") * adjfactor ;
	vdfm(i,"GSP","OMN") = vdfm(i,"GSP","OMN") * adjfactor ;
    vdpa("GSP","OMN")   = vdpa("GSP","OMN")  * adjfactor ; 
	vdpm("GSP","OMN")   = vdpm("GSP","OMN")  * adjfactor ;
    vdga("GSP","OMN")   = vdga("GSP","OMN")  * adjfactor ;
	vdgm("GSP","OMN")   = vdgm("GSP","OMN")  * adjfactor ;
	evfa(fp,"GSP","OMN")  = evfa(fp,"GSP","OMN") * adjfactor ;
    vfm (fp,"GSP","OMN")  = vfm (fp,"GSP","OMN") * adjfactor ;

*OLP OMAN
adjfactor = 2; 
gwhr("OLP","OMN") = gwhr("OLP","OMN") * adjfactor ;
	vdfa(i,"OLP","OMN") = vdfa(i,"OLP","OMN") * adjfactor ;
	vdfm(i,"OLP","OMN") = vdfm(i,"OLP","OMN") * adjfactor ;
    vdpa("OLP","OMN")   = vdpa("OLP","OMN")  * adjfactor ; 
	vdpm("OLP","OMN")   = vdpm("OLP","OMN")  * adjfactor ;
    vdga("OLP","OMN")   = vdga("OLP","OMN")  * adjfactor ;
	vdgm("OLP","OMN")   = vdgm("OLP","OMN")  * adjfactor ;
	evfa(fp,"OLP","OMN")  = evfa(fp,"OLP","OMN") * adjfactor ;
    vfm (fp,"OLP","OMN")  = vfm (fp,"OLP","OMN") * adjfactor ;


*ETD OMN
adjfactor = 2; 
gwhr("ETD","OMN") = gwhr("ETD","OMN") * adjfactor ;
	vdfa(i,"ETD","OMN") = vdfa(i,"ETD","OMN") * adjfactor ;
	vdfm(i,"ETD","OMN") = vdfm(i,"ETD","OMN") * adjfactor ;
    vdpa("ETD","OMN")   = vdpa("ETD","OMN")  * adjfactor ; 
	vdpm("ETD","OMN")   = vdpm("ETD","OMN")  * adjfactor ;
    vdga("ETD","OMN")   = vdga("ETD","OMN")  * adjfactor ;
	vdgm("ETD","OMN")   = vdgm("ETD","OMN")  * adjfactor ;
	evfa(fp,"ETD","OMN")  = evfa(fp,"ETD","OMN") * adjfactor ;
    vfm(fp,"ETD","OMN")   = vfm(fp,"ETD","OMN") * adjfactor ;

******************************

*ETD for Iraq
adjfactor = 2; 
gwhr("ETD","IRQ") = gwhr("ETD","IRQ") * adjfactor ;
	vdfa(i,"ETD","IRQ") = vdfa(i,"ETD","IRQ") * adjfactor ;
	vdfm(i,"ETD","IRQ") = vdfm(i,"ETD","IRQ") * adjfactor ;
    vdpa("ETD","IRQ")   = vdpa("ETD","IRQ")  * adjfactor ; 
	vdpm("ETD","IRQ")   = vdpm("ETD","IRQ")  * adjfactor ;
    vdga("ETD","IRQ")   = vdga("ETD","IRQ")  * adjfactor ;
	vdgm("ETD","IRQ")   = vdgm("ETD","IRQ")  * adjfactor ;
	evfa(fp,"ETD","IRQ")  = evfa(fp,"ETD","IRQ") * adjfactor ;
    vfm(fp,"ETD","IRQ")   = vfm(fp,"ETD","IRQ") * adjfactor ;

*Solar in Iran
adjfactor = 40; 
gwhr("sol","IRN") = gwhr("sol","IRN") * adjfactor ;
	vdfa(i,"SOL","IRN") = vdfa(i,"SOL","IRN") * adjfactor ;
	vdfm(i,"SOL","IRN") = vdfm(i,"SOL","IRN") * adjfactor ;
    vdpa("SOL","IRN")   = vdpa("SOL","IRN")  * adjfactor ; 
	vdpm("SOL","IRN")   = vdpm("SOL","IRN")  * adjfactor ;
    vdga("SOL","IRN")   = vdga("SOL","IRN")  * adjfactor ;
	vdgm("SOL","IRN")   = vdgm("SOL","IRN")  * adjfactor ;
	evfa(fp,"SOL","IRN")  = evfa(fp,"SOL","IRN") * adjfactor ;
    vfm (fp,"SOL","IRN")  = vfm (fp,"SOL","IRN") * adjfactor ;

*Solar in PAK
adjfactor = 2; 
gwhr("sol","PAK") = gwhr("sol","PAK") * adjfactor ;
	vdfa(i,"SOL","PAK") = vdfa(i,"SOL","PAK") * adjfactor ;
	vdfm(i,"SOL","PAK") = vdfm(i,"SOL","PAK") * adjfactor ;
    vdpa("SOL","PAK")   = vdpa("SOL","PAK")  * adjfactor ; 
	vdpm("SOL","PAK")   = vdpm("SOL","PAK")  * adjfactor ;
    vdga("SOL","PAK")   = vdga("SOL","PAK")  * adjfactor ;
	vdgm("SOL","PAK")   = vdgm("SOL","PAK")  * adjfactor ;
	evfa(fp,"SOL","PAK")  = evfa(fp,"SOL","PAK") * adjfactor ;
    vfm (fp,"SOL","PAK")  = vfm (fp,"SOL","PAK") * adjfactor ;




 execute_unload "%iDataDir%\agg\%Prefix%Sat2.gdx",  gwhr;

$offeolcom