$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file : "%OutMngtDir%\OutMacroPrg\03-Income.gms"
    purpose   : Calculate GDP per capita (incl. capital ratio)
    created by: Jean Chateau
    called by : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/03-Income.gms $
	last changed revision: $Rev: 375 $
	last changed date    : $Date:: 2023-08-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$ONDOTL
*---    GDP per capita
work = 1;
* GDP Per head, constant prices, various units,
* reference year %YearBaseMER%, USD

out_Macroeconomic(abstype,"Remarkable Ratios","Capital to GDP ratio","real",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = outscale * sum(mapr(ra,r), m_true1(kstock,r,%1))
    / out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1);

out_Macroeconomic(abstype,"Remarkable Ratios","Capital to GDP ratio","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","nominal",ra,%1)
    = outscale * sum(mapr(ra,r), sum(inv,m_true2(pfd,r,inv,%1)) * m_true1(kstock,r,%1))
    / out_Macroeconomic(abstype,"GDP","GDP","nominal",ra,%1);

out_Macroeconomic(abstype,"Remarkable Ratios","Capital to Efficient labour ratio","real",ra,%1)
    $ sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * chiKaps0(r) * sum((a,l) $ labFlag(r,l,a), lambdal.l(r,l,a,%1) * [m_CESadj * sum(t0,m_wagep(r,l,a,t0) / lambdal.l(r,l,a,t0))] * m_true3t(ld,r,l,a,%1) ))
    = sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * sum((a,v) $ kflag(r,a), lambdak.l(r,a,v,%1) * [m_CESadj * sum(t0,m_pkp(r,a,v,t0)   / lambdak.l(r,a,v,t0))] * m_true3vt(kv,r,a,v,%1) ))
    / sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * chiKaps0(r) * sum((a,l) $ labFlag(r,l,a), lambdal.l(r,l,a,%1) * [m_CESadj * sum(t0,m_wagep(r,l,a,t0) / lambdal.l(r,l,a,t0))] * m_true3t(ld,r,l,a,%1) )) ;

*---    The corresponding "Capital to Efficient labour ratio" in nominal terms
* has a different interpretation since it nothing else than the relative share
* of capital to Labour costs to Labour cost --> Then do not divide it by
* chiKaps0(r)
out_Macroeconomic(abstype,"Remarkable Ratios","Capital to Efficient labour ratio","nominal",ra,%1)
    $ sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * sum((a,l) $ labFlag(r,l,a), m_wagep(r,l,a,%1) * m_true3t(ld,r,l,a,%1)  ))
    = sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * sum((a,v) $ kflag(r,a)    , m_pkp(r,a,v,%1)   * m_true3vt(kv,r,a,v,%1) ))
    / sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * sum((a,l) $ labFlag(r,l,a), m_wagep(r,l,a,%1) * m_true3t(ld,r,l,a,%1)  )) ;

out_Macroeconomic(abstype,"GDP","GDP per capita",units,ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Population","volume",ra,%1)
    = out_Macroeconomic(abstype,"GDP","GDP",units,ra,%1)
    / out_Macroeconomic(abstype,"Demographic","Population","volume",ra,%1);

out_Macroeconomic(abstype,"GDP","GDP per capita (cst PPP)","real",ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Population","volume",ra,%1)
    = out_Macroeconomic(abstype,"GDP","GDP (cst PPP)","real",ra,%1)
    / out_Macroeconomic(abstype,"Demographic","Population","volume",ra,%1);

* this in current USD: [TBU]: add in real terms

out_Macroeconomic(abstype,"GDP","Disposable income per capita","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Population","volume",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(yd,r,%1) )
    / out_Macroeconomic(abstype,"Demographic","Population","volume",ra,%1);

out_Macroeconomic(abstype,"GDP","Disposable income per capita (cst PPP)","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Population","volume",ra,%1)
    = outscale * sum(mapr(ra,r), To%YearBasePPP%PPP(r) * m_true1(yd,r,%1) )
    / out_Macroeconomic(abstype,"Demographic","Population","volume",ra,%1);

$OFFDOTL


