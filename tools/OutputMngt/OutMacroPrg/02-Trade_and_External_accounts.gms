$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file : "%OutMngtDir%\OutMacroPrg\02-Trade_and_External_accounts.gms"
    purpose   : Calculate rade Balance and External accounts for out_Macroeconomic
    created by: Jean Chateau
    called by : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/02-Trade_and_External_accounts.gms $
   last changed revision: $Rev: 375 $
   last changed date    : $Date:: 2023-08-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    N.B.    CA = TB = - savf
--------------------------------------------------------------------------------
$OffText
$ONDOTL

out_Macroeconomic(abstype,"Trade","Current account","nominal",ra,%1)
    = - outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * pwsav.l(%1) * m_true1(savf,r,%1));

* special case for WORLD (otherwise sum is not zero because GDP conversion rates)

out_Macroeconomic(abstype,"Trade","Current account","nominal","WORLD",%1)
    = - outscale * sum(mapr("WORLD",r), pwsav.l(%1)*  m_true1(savf,r,%1)) ;

out_Macroeconomic("pct","Trade","Current account to GDP (pct)","nominal",ra,%1)
    $(out_Macroeconomic("abs","GDP","GDP","nominal",ra,%1) and NOT WLD(ra))
    = out_Macroeconomic("abs","Trade","Current account","nominal",ra,%1)
    / out_Macroeconomic("abs","GDP","GDP","nominal",ra,%1);

* Logically (checked):
*   out_Macroeconomic(abstype,"Trade Balance","nominal",ra,%1)
*   = -  out_Macroeconomic(abstype,"Current account","nominal",ra,%1)
out_Macroeconomic(abstype,"Trade","Trade Balance","nominal",ra,%1)
    = sum((r,i)$(mapr(ra,r) and mapi("ttot-c",i)), To%YearBaseMER%MER(r)
        * [ EXPT(r,i,%1) - IMPT(r,i,%1)
            + outscale * m_true2(pdt,r,i,%1) * m_true2(xtt,r,i,%1)]);

* special case for WORLD (otherwise sum is not zero because GDP conversion rates)

out_Macroeconomic(abstype,"Trade","Trade Balance","nominal","WORLD",%1)
    = outscale * sum(mapr("WORLD",r), pwsav.l(%1)* m_true1(savf,r,%1));

* Like real Current account

out_Macroeconomic(abstype,"Trade","Trade Balance","real",ra,%1)
    = sum((r,i)$(mapr(ra,r) and mapi("ttot-c",i)),
        To%YearBaseMER%MER(r) * [REXPT(r,i,%1) - RIMPT(r,i,%1)
        + outscale * sum(t0,m_true2(pdt,r,i,t0)) * m_true2(xtt,r,i,%1)]);

out_Macroeconomic("pct","Trade","Trade Balance to GDP (pct)",units,ra,%1)
    $(out_Macroeconomic("abs","GDP","GDP",units,ra,%1) and NOT WLD(ra))
    = out_Macroeconomic("abs","Trade","Trade Balance",units,ra,%1)
    / out_Macroeconomic("abs","GDP","GDP",units,ra,%1);

out_Macroeconomic(abstype,"Trade","Trade openness to GDP (pct)","nominal",ra,%1)
    $out_Macroeconomic("abs","GDP","GDP","nominal",ra,%1)
    = 0.5 * sum(r$(mapr(ra,r)), To%YearBaseMER%MER(r) * sum(i,EXPT(r,i,%1) + IMPT(r,i,%1)))
    / out_Macroeconomic("abs","GDP","GDP","nominal",ra,%1);

$OFFDOTL
