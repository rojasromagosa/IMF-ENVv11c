$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file : "%OutMngtDir%\OutMacroPrg\07-Prices_Index.gms"
    purpose   : Various Price Indexes
    created by: Jean Chateau
    called by : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/07-Prices_Index.gms $
   last changed revision: $Rev: 375 $
   last changed date    : $Date:: 2023-08-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
TBU with multiple HH
--------------------------------------------------------------------------------
$OffText
$ondotl

out_Macroeconomic(abstype,"Prices","CPI (Laspeyre)","nominal",ra,%1)
    $ sum((r,i,h,t0)$(mapr(ra,r)), m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t0))
    = sum((r,i,h,t0)$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,%1) * XAPT(r,i,h,t0))
    / sum((r,i,h,t0)$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t0));

out_Macroeconomic(abstype,"Prices","CPI (Paashe)","nominal",ra,%1)
    $ sum((r,i,h,t0)$(mapr(ra,r)), m_true3(pa,r,i,h,t0) * XAPT(r,i,h,%1))
    = sum((r,i,h,t0)$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,%1) * XAPT(r,i,h,%1))
    / sum((r,i,h,t0)$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,%1));

out_Macroeconomic(abstype,"Prices","Service prices to CPI (Laspeyre)","nominal",ra,%1)
    $ sum((r,srvi,h,t0)$(mapr(ra,r)), m_true3(pa,r,srvi,h,t0) * XAPT(r,srvi,h,t0))
    = sum((r,srvi,h,t0)$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3(pa,r,srvi,h,%1) * XAPT(r,srvi,h,t0))
    / sum((r,srvi,h,t0)$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3(pa,r,srvi,h,t0) * XAPT(r,srvi,h,t0));

out_Macroeconomic(abstype,"Prices","Service prices to CPI (Paashe)","nominal",ra,%1)
    $ sum((r,srvi,h,t0)$(mapr(ra,r)), m_true3(pa,r,srvi,h,t0) * XAPT(r,srvi,h,t0))
    = sum((r,srvi,h,t0)$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3(pa,r,srvi,h,%1) * XAPT(r,srvi,h,t0))
    / sum((r,srvi,h,t0)$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3(pa,r,srvi,h,t0) * XAPT(r,srvi,h,t0));

out_Macroeconomic(abstype,"Prices","Service prices to CPI (Laspeyre)","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"Prices","CPI (Laspeyre)","nominal",ra,%1)
    = out_Macroeconomic(abstype,"Prices","Service prices to CPI (Laspeyre)","nominal",ra,%1)
    / out_Macroeconomic(abstype,"Prices","CPI (Laspeyre)","nominal",ra,%1);

out_Macroeconomic(abstype,"Prices","Service prices to CPI (Paashe)","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"Prices","CPI (Paashe)","nominal",ra,%1)
    = out_Macroeconomic(abstype,"Prices","Service prices to CPI (Paashe)","nominal",ra,%1)
    / out_Macroeconomic(abstype,"Prices","CPI (Paashe)","nominal",ra,%1);

out_Macroeconomic(abstype,"Prices","Disposable income per capita","real",ra,%1)
    $ out_Macroeconomic(abstype,"Prices","CPI (Paashe)","nominal",ra,%1)
    = out_Macroeconomic(abstype,"Prices","Disposable income per capita","nominal",ra,%1)
    / out_Macroeconomic(abstype,"Prices","CPI (Paashe)","nominal",ra,%1);

out_Macroeconomic(abstype,"Prices","GDP Deflator","nominal",ra,%1)
    $ sum(r$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true1(rgdpmp,r,%1))
    = sum(r$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true1(pgdpmp,r,%1) * m_true1(rgdpmp,r,%1))
    / sum(r$(mapr(ra,r)), To%YearBaseMER%MER(r) * m_true1(rgdpmp,r,%1));

out_Macroeconomic(abstype,"Prices","API (Paashe)","nominal",ra,%1)
    $ sum((r,i,t0)$mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pat,r,i,t0) * m_true2t(xat,r,i,%1))
    = sum((r,i)   $mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pat,r,i,%1) * m_true2t(xat,r,i,%1))
    / sum((r,i,t0)$mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pat,r,i,t0) * m_true2t(xat,r,i,%1));

* "Production Price Index (Paashe)"

out_Macroeconomic(abstype,"Prices","PPI","nominal",ra,%1)
    $ sum((r,a,t0) $ (xpFlag(r,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * m_true2(px,r,a,t0) * m_true2t(xp,r,a,%1))
    = sum((r,a)    $ (xpFlag(r,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * m_true2(px,r,a,%1) * m_true2t(xp,r,a,%1))
    / sum((r,a,t0) $ (xpFlag(r,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * m_true2(px,r,a,t0) * m_true2t(xp,r,a,%1));

LOOP( (ra,r) $ sameas(ra,r),

    out_Macroeconomic(abstype,"Prices","Exchange rate (MER)","nominal",ra,%1)
        $ out_Macroeconomic(abstype,"Prices","API (Paashe)","nominal","USA",%1)
        = out_Macroeconomic(abstype,"Prices","API (Paashe)","nominal",ra,%1)
        / out_Macroeconomic(abstype,"Prices","API (Paashe)","nominal","USA",%1);

) ;

out_Macroeconomic(abstype,"Prices","Crude Oil price (Itl. CIF price of import)","nominal",WLD,%1)
    = sum(COILi,wldPm(COILi,t)) ;

out_Macroeconomic(abstype,"Prices","Natural Gas price (Itl. CIF price of import)","nominal",WLD,%1)
    = sum(NGASi,wldPm(NGASi,t)) ;

out_Macroeconomic(abstype,"Prices","Coal price (Itl. CIF price of import)","nominal",WLD,%1)
    = sum(COAi,wldPm(COAi,t)) ;


*---    PPP level in %YearBasePPP%
* [TBU]
*rwork(r) = ypc("cst_itl",r,"%YearBasePPP%") / ypc("cst_usd",r,"%YearBasePPP%");
*out_Macroeconomic(abstype,"Prices","Exchange rate (PPP)","nominal",ra,%1)
*    $(sum((rres,h),PI0_xc.l(rres,h,%1)))=
*    sum(r$mapr(ra,r),
*        [rwork(r) / sum(rres, rwork(rres))]
*        / [sum(h,PI0_xc.l(r,h,%1)) / sum((rres,h),PI0_xc.l(rres,h,%1))]
*        );
$offdotl
