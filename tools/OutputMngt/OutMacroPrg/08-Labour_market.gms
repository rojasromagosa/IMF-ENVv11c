$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file   : "%OutMngtDir%\OutMacroPrg\08-Labour_market.gms"
    purpose     :  Calculate Labour Market variables (incl. Labour Income Share)
    created date: 2021-03-10
    created by  : Jean Chateau
    called by   : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/08-Labour_market.gms $
   last changed revision: $Rev: 375 $
   last changed date    : $Date:: 2023-08-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
Remplace  m_true(popWA(r,l,z,%1)) with popWA.l(r,l,z,%1)
[EditJean]: dans le baseline m_true1(tls,r,t)) et sum((l,z),m_ETPT(r,l,z,t)) on le meme taux de croissance
--------------------------------------------------------------------------------
$OffText

$ONDOTL

out_Macroeconomic(abstype,"Demographic","Active population",volume,ra,%1)
    =  sum((r,l,z) $ (mapr(ra,r) and lsFlag(r,l,z)),
        LFPR.l(r,l,z,%1) * m_true3(popWA,r,l,z,%1) ) / popScale ;

out_Macroeconomic(abstype,"Labor Market","Employment",volume,ra,%1)
    =  sum((r,l,z) $ mapr(ra,r), m_ETPT(r,l,z,%1)) / popScale;

* removed as already in labor market (leads to double counting if one is not careful to filter for macrocat as well)
* out_Macroeconomic(abstype,"Demographic","Employment",volume,ra,%1)
*     = out_Macroeconomic(abstype,"Labor Market","Employment",volume,ra,%1);

out_Macroeconomic(abstype,"Labor Market","Participation rate",volume,ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Working-age population",volume,ra,%1)
    = 100 * out_Macroeconomic(abstype,"Demographic","Active population",volume,ra,%1)
    / out_Macroeconomic(abstype,"Demographic","Working-age population",volume,ra,%1) ;

* memo UNR is already in pct

out_Macroeconomic(abstype,"Labor Market","Unemployment rate",volume,ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Active population",volume,ra,%1)
    = sum((r,l,z) $ (mapr(ra,r) and lsFlag(r,l,z)),
		LFPR.l(r,l,z,%1) * m_true3(popWA,r,l,z,%1) * UNR.l(r,l,z,%1) / popScale)
    / out_Macroeconomic(abstype,"Demographic","Active population",volume,ra,%1) ;

out_Macroeconomic(abstype,"Labor Market","Labour productivity",volume,ra,%1)
    $ out_Macroeconomic(abstype,"Demographic","Employment",volume,ra,%1)
    = out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    / out_Macroeconomic(abstype,"Demographic","Employment",volume,ra,%1);

* average wage rate received by household before taxation

out_Macroeconomic(abstype,"Labor Market","wage rate","nominal",ra,%1)
    $ sum((r,l,z) $ (mapr(ra,r) and lsFlag(r,l,z)), m_ETPT(r,l,z,%1))
    = sum((r,l,z) $ (mapr(ra,r) and lsFlag(r,l,z)), To%YearBaseMER%MER(r) * m_true2(twage,r,l,%1) * m_ETPT(r,l,z,%1) )
    / sum((r,l,z) $ (mapr(ra,r) and lsFlag(r,l,z)), m_ETPT(r,l,z,%1));

out_Macroeconomic(abstype,"Labor Market","wage rate (relative to CPI)","real",ra,%1)
    $ out_Macroeconomic(abstype,"Prices","CPI (Paashe)","nominal",ra,%1)
    = out_Macroeconomic(abstype,"Labor Market","wage rate","nominal",ra,%1)
    / out_Macroeconomic(abstype,"Prices","CPI (Paashe)","nominal",ra,%1);

* "Net-of-income tax wage rate received by households"

out_Macroeconomic(abstype,"Labor Market","net-of-tax wage rate","nominal",ra,%1)
    $ sum((r,l,a) $ (labFlag(r,l,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3t(ld,r,l,a,%1))
    = sum((r,l,a) $ (labFlag(r,l,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * (1 - kappah.l(r,%1)) * m_true3(wage,r,l,a,%1) * m_true3t(ld,r,l,a,%1))
* [EditJean] to be update with kappafp.l(r,l,%1)
*    = sum((r,l,a) $ (labFlag(r,l,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * (1 - kappah.l(r,%1)) * (1 - kappafp.l(r,l,%1)) * m_true3(wage,r,l,a,%1) * m_true3t(ld,r,l,a,%1))
    / sum((r,l,a) $ (labFlag(r,l,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3t(ld,r,l,a,%1));

out_Macroeconomic(abstype,"Labor Market","net-of-tax wage rate","real",ra,%1)
    $ out_Macroeconomic(abstype,"Prices","CPI (Paashe)","nominal",ra,%1)
    = out_Macroeconomic(abstype,"Labor Market","net-of-tax wage rate","nominal",ra,%1)
    / out_Macroeconomic(abstype,"Prices","CPI (Paashe)","nominal",ra,%1);

*	"Gross-of-social contribution wage rate paid by firms"

out_Macroeconomic(abstype,"Labor Market","gross wage rate","nominal",ra,%1)
    $ sum((r,l,a) $ (labFlag(r,l,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3t(ld,r,l,a,%1))
    = sum((r,l,a) $ (labFlag(r,l,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * m_wagep(r,l,a,%1) * m_true3t(ld,r,l,a,%1))
    / sum((r,l,a) $ (labFlag(r,l,a) and mapr(ra,r)), To%YearBaseMER%MER(r) * m_true3t(ld,r,l,a,%1));

out_Macroeconomic(abstype,"Labor Market","gross wage rate","real",ra,%1)
    $ out_Macroeconomic(abstype,"Prices","PPI","nominal",ra,%1)
    = out_Macroeconomic(abstype,"Labor Market","gross wage rate" ,"nominal",ra,%1)
    / out_Macroeconomic(abstype,"Prices","PPI","nominal",ra,%1);

* sectoral and regional employment

risworkT(r,a,%1-1) = 0;
rworkT(r,t)  = 0;
rworkT(r,%1-1) = sum((l,a), m_true3t(ld,r,l,a,%1-1));
rworkT(r,%1)   = sum((l,a), m_true3t(ld,r,l,a,%1));

risworkT(r,a,%1-1)
    $ rworkT(r,%1-1)
    = sum(l, m_true3t(ld,r,l,a,%1-1)) * sum((l,z), m_ETPT(r,l,z,%1-1))
    / rworkT(r,%1-1);
risworkT(r,a,%1)
    $ rworkT(r,%1)
    = sum(l, m_true3t(ld,r,l,a,%1)) * sum((l,z), m_ETPT(r,l,z,%1))
    / rworkT(r,%1);

out_Macroeconomic(abstype,"Labor Market","Job creations",volume,ra,%1)
    $ out_Macroeconomic(abstype,"Labor Market","Employment",volume,ra,%1)
    =   sum(r$mapr(ra,r),sum(a$(risworkT(r,a,%1) - risworkT(r,a,%1-1) gt 0), risworkT(r,a,%1) - risworkT(r,a,%1-1)));
out_Macroeconomic(abstype,"Labor Market","Job destructions",volume,ra,%1)
    $ out_Macroeconomic(abstype,"Labor Market","Employment",volume,ra,%1)
    = - sum(r$mapr(ra,r),sum(a$(risworkT(r,a,%1) - risworkT(r,a,%1-1) le 0), risworkT(r,a,%1) - risworkT(r,a,%1-1)));
out_Macroeconomic(abstype,"Labor Market","Total job reallocation",volume,ra,%1)
    = out_Macroeconomic(abstype,"Labor Market","Job creations",volume,ra,%1)
    + out_Macroeconomic(abstype,"Labor Market","Job destructions",volume,ra,%1);
out_Macroeconomic(abstype,"Labor Market","Net employment growth",volume,ra,%1)
    = out_Macroeconomic(abstype,"Labor Market","Job creations",volume,ra,%1)
    - out_Macroeconomic(abstype,"Labor Market","Job destructions",volume,ra,%1);

* Il y a un truc qui cloche

out_Macroeconomic(abstype,"Labor Market","Excess worker reallocation",volume,ra,%1)
    = out_Macroeconomic(abstype,"Labor Market","Total job reallocation",volume,ra,%1)
    - ABS(out_Macroeconomic(abstype,"Labor Market","Net employment growth",volume,ra,%1));

raworkt(ra,%1)
    $ out_Macroeconomic("abs","Labor Market","Employment","volume",ra,%1-1)
    = 0.5 * out_Macroeconomic("abs","Labor Market","Employment","volume",ra,%1)
    + 0.5 * out_Macroeconomic("abs","Labor Market","Employment","volume",ra,%1-1);

out_Macroeconomic("pct","Labor Market","Job creations",volume,ra,%1)
    $ raworkt(ra,%1)
    = out_Macroeconomic("abs","Labor Market","Job creations",volume,ra,%1)
    / raworkt(ra,%1);
out_Macroeconomic("pct","Labor Market","Job destructions",volume,ra,%1)
    $ raworkt(ra,%1)
    = out_Macroeconomic("abs","Labor Market","Job destructions",volume,ra,%1)
    / raworkt(ra,%1);
out_Macroeconomic("pct","Labor Market","Total job reallocation",volume,ra,%1)
    $ raworkt(ra,%1)
    = out_Macroeconomic("abs","Labor Market","Total job reallocation",volume,ra,%1)
    / raworkt(ra,%1);
out_Macroeconomic("pct","Labor Market","Net employment growth",volume,ra,%1)
    $ raworkt(ra,%1)
    = out_Macroeconomic("abs","Labor Market","Net employment growth",volume,ra,%1)
    / raworkt(ra,%1);
out_Macroeconomic("pct","Labor Market","Excess worker reallocation",volume,ra,%1)
    $ raworkt(ra,%1)
    = out_Macroeconomic("abs","Labor Market","Excess worker reallocation",volume,ra,%1)
    / raworkt(ra,%1);

* Salaire brut sur ToTal GDP at market prices

risworkT(r,a,%1) = 0;
* IfCoeffCes = 1 --> lambdal.l(r,l,a,t0)) = m_wagep(r,l,a,t0)
risworkT(r,a,%1)
    $ sum((t0,l),lambdal.l(r,l,a,t0))
    = To%YearBaseMER%MER(r) * outscale
    * sum(l, lambdal.l(r,l,a,%1)
        * [m_CESadj * sum(t0,m_wagep(r,l,a,t0) / lambdal.l(r,l,a,t0))]
        * m_true3t(ld,r,l,a,%1) );

out_Macroeconomic(abstype,"Remarkable Ratios","Labour Income Share","real",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1)
    = sum((r,a)$mapr(ra,r), risworkT(r,a,%1))
    / out_Macroeconomic(abstype,"GDP","GDP","real",ra,%1);

risworkT(r,a,%1) = 0;
risworkT(r,a,%1) = To%YearBaseMER%MER(r) * outscale * sum(l, m_wagep(r,l,a,%1) * m_true3t(ld,r,l,a,%1) );
$OFFDOTL

out_Macroeconomic(abstype,"Remarkable Ratios","Labour Income Share","nominal",ra,%1)
    $ out_Macroeconomic(abstype,"GDP","GDP","nominal",ra,%1)
    = sum((r,a)$mapr(ra,r), risworkT(r,a,%1))
    / out_Macroeconomic(abstype,"GDP","GDP","nominal",ra,%1);
