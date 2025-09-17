$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file   : "%OutMngtDir%\OutMacroPrg\01-final_demands.gms"
    purpose     : Calculate Final Demands variables for out_Macroeconomic
                    for GDP decomposition at expenditures
    created date: 2021-03-10
    created by  : Jean Chateau
    called by   : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/01-final_demands.gms $
	last changed revision: $Rev: 375 $
	last changed date    : $Date:: 2023-08-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$OnDotl

*------------------------------------------------------------------------------*
*         GDP measures at %YearBaseMER% market prices (millions of USD)        *
*------------------------------------------------------------------------------*

$$Ifi NOT %SimType%=="CompStat" out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1) $ between3(%1,"%YearStart%","%YearEndofSim%")
$$Ifi     %SimType%=="CompStat" out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(rgdpmp,r,%1));
out_Macroeconomic(abstype,"GDP","GDP","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(gdpmp,r,%1));
out_Macroeconomic(abstype,"GDP","GDP (cst PPP)","real",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBasePPP%PPP(r) * m_true1(rgdpmp,r,%1));

*------------------------------------------------------------------------------*
*                       Final Demands (Nominal)                                *
*------------------------------------------------------------------------------*
risjsworkt(r,is,js,%1) = 0;

* Agent Prices [for GDP]

risjsworkt(r,i,fd,%1)
    = To%YearBaseMER%MER(r) * m_true3(pa,r,i,fd,%1) * XAPT(r,i,fd,%1);

* Government spendings

out_Macroeconomic(abstype,"GDP Expenditures","Government Consumption","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = sum((gov,r,i)$(mapr(ra,r) and mapi("ttot-c",i)), risjsworkt(r,i,gov,%1));

* Household Final Consumption

out_Macroeconomic(abstype,"GDP Expenditures","Household Consumption","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","nominal",ra,%1)
    = sum((h,r,i)$(mapr(ra,r) and mapi("ttot-c",i)), risjsworkt(r,i,h,%1));

out_Macroeconomic(abstype,"GDP","Land Supply","real",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(tland,r,%1));

* Gross Investment --> k - k(-1) * (1 - delta) = fdvol

IF(1,
    out_Macroeconomic(abstype,"GDP Expenditures","Gross Investment","nominal",ra,%1)
        = sum((inv,r,i)$(mapr(ra,r) and mapi("ttot-c",i)), risjsworkt(r,i,inv,%1));
ELSE
    out_Macroeconomic(abstype,"GDP Expenditures","Gross Investment","nominal",ra,%1)
        = outscale * sum((r,inv) $ mapr(ra,r), To%YearBaseMER%MER(r)
            * m_true2(pfd,r,inv,%1) * m_true2(xfd,r,inv,%1));
);

*------------------------------------------------------------------------------*
*                       Final Demands (Real)                                   *
*------------------------------------------------------------------------------*
risjsworkt(r,is,js,%1) = 0;
risjsworkt(r,i,fd,%1)
    = sum(t0,m_true3(pa,r,i,fd,t0)) * To%YearBaseMER%MER(r) * XAPT(r,i,fd,%1);

* Government spendings

out_Macroeconomic(abstype,"GDP Expenditures","Government Consumption","real",ra,%1)
    = sum((gov,r,i)$(mapr(ra,r) and mapi("ttot-c",i)), risjsworkt(r,i,gov,%1));

* Household Final Consumption

out_Macroeconomic(abstype,"GDP Expenditures","Household Consumption","real",ra,%1)
    = sum((h,r,i) $ (mapr(ra,r) and mapi("ttot-c",i)), risjsworkt(r,i,h,%1)) ;

* Gross Investment

IF(1,
    out_Macroeconomic(abstype,"GDP Expenditures","Gross Investment","real",ra,%1)
        = sum((inv,r,i)$(mapr(ra,r) and mapi("ttot-c",i)), risjsworkt(r,i,inv,%1));
ELSE
    out_Macroeconomic(abstype,"GDP Expenditures","Gross Investment","real",ra,%1)
        = outscale * sum((r,inv,t0)$mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pfd,r,inv,t0) * m_true2(xfd,r,inv,%1));
) ;

$OffDotl

*------------------------------------------------------------------------------*
*                       Final Demands (Ratios)                                 *
*------------------------------------------------------------------------------*

out_Macroeconomic("pct","GDP Expenditures","Government Consumption to GDP (pct)",units,ra,%1)
    $ out_Macroeconomic("abs","GDP","GDP",units,ra,%1)
    = out_Macroeconomic("abs","GDP Expenditures","Government Consumption",units,ra,%1)
    / out_Macroeconomic("abs","GDP","GDP",units,ra,%1);
out_Macroeconomic("pct","GDP Expenditures","Household Consumption to GDP (pct)",units,ra,%1)
    $ out_Macroeconomic("abs","GDP","GDP",units,ra,%1)
    = out_Macroeconomic("abs","GDP Expenditures","Household Consumption",units,ra,%1)
    / out_Macroeconomic("abs","GDP","GDP",units,ra,%1);
out_Macroeconomic("abs","GDP Expenditures","Household Consumption per capita",units,ra,%1)
    $ out_Macroeconomic("abs","Demographic","Population","volume",ra,%1)
    = out_Macroeconomic("abs","GDP Expenditures","Household Consumption",units,ra,%1)
    / out_Macroeconomic("abs","Demographic","Population","volume",ra,%1);
out_Macroeconomic("pct","GDP Expenditures","Gross Investment to GDP (pct)",units,ra,%1)
    $ out_Macroeconomic("abs","GDP","GDP",units,ra,%1)
    = out_Macroeconomic("abs","GDP Expenditures","Gross Investment",units,ra,%1)
    / out_Macroeconomic("abs","GDP","GDP",units,ra,%1);
