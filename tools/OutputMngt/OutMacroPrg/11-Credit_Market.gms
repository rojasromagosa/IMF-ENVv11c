$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
	GAMS file 	: "%ModelDir%\12-macroeconomics\11-Credit_Market.gms"
    purpose   	: Savings and Credit market
    created by  :  Jean Chateau
    called by   : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/11-Credit_Market.gms $
	last changed revision: $Rev: 375 $
	last changed date    : $Date:: 2023-08-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText
$ONDOTL

*---
$OnText
I = S equilibrium

Or
Gross Investement:
   yfd(r,inv,t)
    = [sum(h, savh(r,h,t)) + savg(r,t) + pwsav(t)*savf(r,t)]  +  deprY(r,t)
                    Net Investment                              Depreciation

out_Macroeconomic(abstype,"Net Investment","nominal",ra,%1)
    = out_Macroeconomic(abstype,"Household Saving","nominal",ra,%1)
    + out_Macroeconomic(abstype,"Current account","nominal",ra,%1)
    + out_Macroeconomic(abstype,"Government Saving","nominal",ra,%1)

$OffText

*---    Net Investment nominal --> k - k(-1) = fdvol - delta * k(-1)
out_Macroeconomic(abstype,"Credit Market","Net Investment","nominal",ra,%1)
    = outscale * sum((r,inv) $ mapr(ra,r), To%YearBaseMER%MER(r)
    * m_true2(pfd,r,inv,%1) * [m_true2(xfd,r,inv,%1) - fdepr(r,%1) * m_true1(kstock,r,%1)]);
$IfThenI.ExtraInv SET module_SectInv
    out_Macroeconomic(abstype,"Credit Market","Net Investment","nominal",ra,%1)
        = out_Macroeconomic(abstype,"Credit Market","Net Investment","nominal",ra,%1)
        + outscale * sum(r$mapr(ra,r),sum((a,inv)$(ExtraInvFlag(r,a) eq 2), m_true(pfd(r,inv,%1)) * m_true(xfda(r,a,%1))))
        + outscale * sum(r$mapr(ra,r),sum(a$(ExtraInvFlag(r,a) eq 1), m_true(pfda(r,a,%1)) * m_true(xfda(r,a,%1))));
$ENDIF.ExtraInv

*   Net Investment real

out_Macroeconomic(abstype,"Credit Market","Net Investment","real",ra,%1)
    = outscale * sum((r,inv,t0) $ mapr(ra,r), To%YearBaseMER%MER(r)
    * m_true2(pfd,r,inv,t0) * [m_true2(xfd,r,inv,%1) - fdepr(r,%1) * m_true1(kstock,r,%1)]);

$IfThenI.ExtraInv SET module_SectInv
    out_Macroeconomic(abstype,"Credit Market","Net Investment","real",ra,%1)
        = out_Macroeconomic(abstype,"Credit Market","Net Investment","real",ra,%1)
        + outscale * sum(mapr(ra,r),sum((a,inv,t0) $ ExtraInvFlag(r,a), m_true(pfd(r,inv,t0)) * m_true(xfda(r,a,%1))));
$ENDIF.ExtraInv

out_Macroeconomic(abstype,"Credit Market","Net Investment to GDP (pct)",units,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP",units,ra,%1)
    = out_Macroeconomic(abstype,"GDP Expenditures","Net Investment",units,ra,%1)
    / out_Macroeconomic(abstype,"GDP","GDP",units,ra,%1);

*   Savings

out_Macroeconomic(abstype,"Credit Market","Saving rate (Household)","nominal",ra,%1)
    $ sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(yd,r,%1))
    = sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * sum(h,m_true2(savh,r,h,%1)))
    / sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(yd,r,%1));

out_Macroeconomic(abstype,"Credit Market","Household Saving","nominal",ra,%1)
    = outscale * sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * sum(h,m_true2(savh,r,h,%1)));

out_Macroeconomic(abstype,"Credit Market","Household Saving to GDP","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","nominal",ra,%1)
    = out_Macroeconomic(abstype,"Credit Market","Household Saving","nominal",ra,%1)
    / out_Macroeconomic(abstype,"GDP","GDP","nominal",ra,%1);

out_Macroeconomic(abstype,"Credit Market","Government Saving","nominal",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(savg,r,%1));
out_Macroeconomic(abstype,"Credit Market","Government Saving","real",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(rsg,r,%1));

out_Macroeconomic(abstype,"Credit Market","Depreciation","nominal",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(deprY,r,%1));

out_Macroeconomic(abstype,"Credit Market","Foreign Saving","nominal",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * pwsav.l(%1)* m_true1(savf,r,%1));

out_Macroeconomic(abstype,"Credit Market","Government Saving to GDP",units,ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP",units,ra,%1)
    = out_Macroeconomic(abstype,"Credit Market","Government Saving",units,ra,%1)
    / out_Macroeconomic(abstype,"GDP","GDP",units,ra,%1);

$OFFDOTL
