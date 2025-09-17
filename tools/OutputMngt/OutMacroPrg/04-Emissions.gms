$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file   : "%OutMngtDir%\OutMacroPrg\04-Emissions.gms"
    purpose     : Calculate GHGs related variable
    created date: 2021-03-10
    created by  : Jean Chateau
    called by   : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/04-Emissions.gms $
   last changed revision: $Rev: 375 $
   last changed date    : $Date:: 2023-08-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
	memo: GHG emissions in volume are in Million tonnes of CO2 equivalent
--------------------------------------------------------------------------------
$OffText

$macro m_EmiCond (mapr(ra,r) and not tota(aa) and not emiagg(EmiSource))

$OnDotL

out_Macroeconomic(abstype,"Emissions","CO2 from fossil fuel combustion",volume,ra,%1)
    = sum((r,aa,EmiFosComb,CO2) $ (mapr(ra,r) and not tota(aa)),
        m_true4(emi,r,CO2,EmiFosComb,aa,%1)) / cScale;

* CO2 emissions from LULUCF:

*	[2023-06-21] now add agric. to forestry

out_Macroeconomic(abstype,"Emissions","CO2 LULUCF",volume,ra,%1)
    = sum((r,co2,prima,emilulucf) $ mapr(ra,r),
				m_true4(emi,r,co2,emilulucf,prima,%1) ) / cScale;

*	Emission All sources

out_Macroeconomic(abstype,"Emissions","CO2 All sources",volume,ra,%1)
    = sum(mapr(ra,r), m_true2(emiTot,r,"CO2",%1)) / cScale ;
out_Macroeconomic(abstype,"Emissions","CH4 All sources",volume,ra,%1)
    = sum(mapr(ra,r), m_true2(emiTot,r,"CH4",%1)) / cScale ;
out_Macroeconomic(abstype,"Emissions","N2O All sources",volume,ra,%1)
    = sum(mapr(ra,r), m_true2(emiTot,r,"N2O",%1)) / cScale ;

IF(NOT IfGroupFgas,

	out_Macroeconomic(abstype,"Emissions","PFC All sources",volume,ra,%1)
		= sum(mapr(ra,r), m_true2(emiTot,r,"PFC",%1)) / cScale ;

	out_Macroeconomic(abstype,"Emissions","HFC All sources",volume,ra,%1)
		= sum(mapr(ra,r), m_true2(emiTot,r,"HFC",%1)) / cScale ;

	out_Macroeconomic(abstype,"Emissions","SF6 All sources",volume,ra,%1)
		= sum(mapr(ra,r), m_true2(emiTot,r,"SF6",%1)) / cScale ;

	out_Macroeconomic(abstype,"Emissions","SF6 All sources",volume,ra,%1)
		= sum(mapr(ra,r), m_true2(emiTot,r,"SF6",%1)) / cScale ;

	out_Macroeconomic(abstype,"Emissions","FGAS All sources",volume,ra,%1)
		= sum(HighGWP, sum(mapr(ra,r), m_true2(emiTot,r,HighGWP,%1))) / cScale ;
ELSE

	out_Macroeconomic(abstype,"Emissions","FGAS All sources",volume,ra,%1)
		= sum(FGAS, sum(mapr(ra,r), m_true2(emiTot,r,FGAS,%1))) / cScale ;

) ;

* Before [2023-06-21]
*out_Macroeconomic(abstype,"Emissions","CH4 All sources",volume,ra,%1)
*    = sum((r,aa,EmiSource) $ m_EmiCond,
*            m_true4(emi,r,"CH4",EmiSource,aa,%1)) / cScale;

*	All GHGs Total

out_Macroeconomic(abstype,"Emissions","GHG All sources",volume,ra,%1)
	= sum(EmSingle, sum(mapr(ra,r), m_true2(emiTot,r,EmSingle,%1))) / cScale ;

*	Excluding CO2 Lulucf

out_Macroeconomic(abstype,"Emissions","GHG All sources (excl. CO2 LULUCF)",volume,ra,%1)
	= out_Macroeconomic(abstype,"Emissions","GHG All sources",volume,ra,%1)
	- out_Macroeconomic(abstype,"Emissions","CO2 LULUCF",volume,ra,%1) ;

out_Macroeconomic(abstype,"Emissions","CO2 All sources (excl. CO2 LULUCF)",volume,ra,%1)
	= out_Macroeconomic(abstype,"Emissions","CO2 All sources",volume,ra,%1)
	- out_Macroeconomic(abstype,"Emissions","CO2 LULUCF",volume,ra,%1) ;

*------------------------------------------------------------------------------*
*           Emissions per capita (Kilograms per capita, Thousands)             *
*------------------------------------------------------------------------------*
*  by source (excl. CO2 LULUCF) = metric tons per capita

out_Macroeconomic(abstype,"Emissions","GHG per capita",volume,ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Population",volume,ra,%1)
    = out_Macroeconomic(abstype,"Emissions","GHG All sources",volume,ra,%1)
    / out_Macroeconomic(abstype,"Demographic","Population",volume,ra,%1);

out_Macroeconomic(abstype,"Emissions","CO2 per capita",volume,ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Population",volume,ra,%1)
    = out_Macroeconomic(abstype,"Emissions","CO2 All sources",volume,ra,%1)
    / out_Macroeconomic(abstype,"Demographic","Population",volume,ra,%1);

out_Macroeconomic(abstype,"Emissions","CO2 from fossil fuel combustion per capita",volume,ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Population",volume,ra,%1)
    = out_Macroeconomic(abstype,"Emissions","CO2 from fossil fuel combustion",volume,ra,%1)
    / out_Macroeconomic(abstype,"Demographic","Population",volume,ra,%1);

*------------------------------------------------------------------------------*
*   Emissions per unit of GDP (Kilograms %YearBaseMER% USD of GDP , Thousands) *
*------------------------------------------------------------------------------*
*  e.g. Kilograms per 1 000 US dollars, Thousands

out_Macroeconomic(abstype,"Emissions","GHG per GDP",volume,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = 1000
    * out_Macroeconomic(abstype,"Emissions","GHG All sources",volume,ra,%1)
    / out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1);

out_Macroeconomic(abstype,"Emissions","GHG (excl. CO2 LULUCF) per GDP",volume,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = 1000
    * out_Macroeconomic(abstype,"Emissions","GHG All sources (excl. CO2 LULUCF)",volume,ra,%1)
    / out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1);

out_Macroeconomic(abstype,"Emissions","CO2 per GDP",volume,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = 1000
    * out_Macroeconomic(abstype,"Emissions","CO2 All sources",volume,ra,%1)
    / out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1);

out_Macroeconomic(abstype,"Emissions","CO2 (excl. CO2 LULUCF) per GDP",volume,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = 1000
    * out_Macroeconomic(abstype,"Emissions","CO2 All sources (excl. CO2 LULUCF)",volume,ra,%1)
    / out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1);

out_Macroeconomic(abstype,"Emissions","CO2 from fossil fuel combustion per GDP",volume,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = 1000
    * out_Macroeconomic(abstype,"Emissions","CO2 from fossil fuel combustion",volume,ra,%1)
    / out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1);

*	Carbon Tax:  Average on all GHG (%YearUSDCT% USD, per tCO2 eq.) #todo

* CO2 Tax: "Average on CO2 (%YearUSDCT% USD, per tCO2)" --> check < 0

out_Macroeconomic(abstype,"Emissions","CO2 Price","nominal",ra,%1)
    $ sum((r,CO2,EmiSource,aa) $ (mapr(ra,r) and not tota(aa)), m_true4(emi,r,CO2,EmiSource,aa,%1) )
    = sum((r,CO2,EmiSource,aa) $ (mapr(ra,r) and not tota(aa)), m_EmiPrice(r,CO2,EmiSource,aa,%1) * m_true4(emi,r,CO2,EmiSource,aa,%1))
    / sum((r,CO2,EmiSource,aa) $ (mapr(ra,r) and not tota(aa)), m_true4(emi,r,CO2,EmiSource,aa,%1) );

* CO2 Tax (on Active Sources): Average on CO2 on Active Sources (%YearUSDCT% USD, per tCO2)

* This should give exactly the Tax we want to implement --> m_EmiPrice(r,em,emiSrc,aa,t)
* here only on intermediate demand

out_Macroeconomic(abstype,"Emissions","CO2 Price (on Active Sources)","nominal",ra,%1)
    $ sum((r,CO2,EmiSourceAct,aa) $ (mapr(ra,r) and not tota(aa) and not fd(aa)), m_true4(emi,r,CO2,EmiSourceAct,aa,%1))
    = sum((r,CO2,EmiSourceAct,aa) $ (mapr(ra,r) and not tota(aa) and not fd(aa)), m_EmiPrice(r,CO2,EmiSourceAct,aa,%1) * m_true4(emi,r,CO2,EmiSourceAct,aa,%1))
    / sum((r,CO2,EmiSourceAct,aa) $ (mapr(ra,r) and not tota(aa) and not fd(aa)), m_true4(emi,r,CO2,EmiSourceAct,aa,%1));

* Convert these Taxes in %YearUSDCT%-USD/tCO2

out_Macroeconomic(abstype,"Emissions",macrolist,"nominal",ra,%1)
    $ out_Macroeconomic(abstype,"Emissions",macrolist,"nominal",ra,%1)
    = (out_Macroeconomic(abstype,"Emissions",macrolist,"nominal",ra,%1) / cScale)
    $$Ifi NOT %SimType%=="CompStat" / ConvertCurToModelUSD("%YearUSDCT%")
    ;

*   Carbon Taxes in real terms: deflated by GDP price

out_Macroeconomic(abstype,"Emissions","Carbon Price","real",ra,%1)
    = out_Macroeconomic(abstype,"Emissions","Carbon Price","nominal",ra,%1)
    / sum(rres,m_true1(pgdpmp,rres,%1)) ;
out_Macroeconomic(abstype,"Emissions","CO2 Price","real",ra,%1)
    = out_Macroeconomic(abstype,"Emissions","CO2 Price","nominal",ra,%1)
    / sum(rres,m_true1(pgdpmp,rres,%1)) ;
out_Macroeconomic(abstype,"Emissions","CO2 Price (on Active Sources)","real",ra,%1)
    = out_Macroeconomic(abstype,"Emissions","CO2 Price (on Active Sources)","nominal",ra,%1)
    / sum(rres,m_true1(pgdpmp,rres,%1)) ;

* Air pollutants

woap(ra,oap,%1)
    = sum((r,aa,EmiSource) $ (mapr(ra,r) and not tota(aa) and not emiagg(EmiSource) ),
            m_true4(emi,r,oap,EmiSource,aa,%1)) / apscale;

out_Macroeconomic(abstype,"Air pollutants","BC (1000 t)",volume,ra,%1)    = woap(ra,"BC",%1);
out_Macroeconomic(abstype,"Air pollutants","CO (1000 t)",volume,ra,%1)    = woap(ra,"CO",%1);
out_Macroeconomic(abstype,"Air pollutants","NH3 (1000 t)",volume,ra,%1)   = woap(ra,"NH3",%1);
out_Macroeconomic(abstype,"Air pollutants","NOX (1000 t)",volume,ra,%1)   = woap(ra,"NOX",%1);
out_Macroeconomic(abstype,"Air pollutants","OC (1000 t)",volume,ra,%1)    = woap(ra,"OC",%1);
out_Macroeconomic(abstype,"Air pollutants","SO2 (1000 t)",volume,ra,%1)   = woap(ra,"SO2",%1);
out_Macroeconomic(abstype,"Air pollutants","PM10 (1000 t)",volume,ra,%1)  = woap(ra,"PM10",%1);
out_Macroeconomic(abstype,"Air pollutants","PM25 (1000 t)",volume,ra,%1)  = woap(ra,"PM25",%1);
out_Macroeconomic(abstype,"Air pollutants","NMVOC (1000 t)",volume,ra,%1) = woap(ra,"NMVOC",%1);
out_Macroeconomic(abstype,"Air pollutants","SOX (1000 t)",volume,ra,%1)   = woap(ra,"SOX",%1);

OPTION clear=woap;
$OFFDOTL
