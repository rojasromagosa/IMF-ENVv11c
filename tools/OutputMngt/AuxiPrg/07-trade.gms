$OnText
--------------------------------------------------------------------------------
                    [OECD-ENV] Model V.1. - Reporting procedure
   Name of the File: "%AuxPrgDir%\07-Trade.gms"
   purpose: Calculation of "Trade" variables
   and "External" accounts variable "out_External"
    created date: 2021-03-18
    created by  : Jean Chateau
    called by   : %OutMngtDir%\OutAuxi.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/AuxiPrg/07-trade.gms $
   last changed revision: $Rev: 62 $
   last changed date    : $Date:: 2022-10-21 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

out_External(abstype,"Trade balance (accounting)","nominal",ra,ia,t)
    = sum((r,i)$(mapr(ra,r) and mapi(ia,i)),
         To%YearBaseMER%MER(r)
          * [expt(r,i,t) - impt(r,i,t)
                + outscale * m_true2(pdt,r,i,t) * m_true2(xtt,r,i,t)]
         );

out_External(abstype,"Trade balance (FOB)","nominal",ra,ia,t)
    = outscale * sum((r,i)$(mapr(ra,r) and mapi(ia,i)),
        sum(rp, m_true3(pwe,r,i,rp,t) * m_true3(xw,r,i,rp,t)
              - m_true3(pwe,rp,i,r,t) * m_true3(xw,rp,i,r,t)
           ));

out_External(abstype,"Trade balance (FOB)",realunit,ra,ia,t)
    = outscale * sum((r,i)$(mapr(ra,r) and mapi(ia,i)),
        sum((rp,t0), m_true3(pwe,r,i,rp,t0) * m_true3(xw,r,i,rp,t)
                   - m_true3(pwe,rp,i,r,t0) * m_true3(xw,rp,i,r,t)
           ));

out_External(abstype,"Domestic demand to output","nominal",ra,ia,t)
    $ sum((r,i)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(xs,r,i,t)  * m_true2(ps,r,i,t))
    = sum((r,i)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(xdt,r,i,t) * m_true2(pdt,r,i,t))
    / sum((r,i)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(xs,r,i,t)  * m_true2(ps,r,i,t));

out_External(abstype,"Domestic demand to output",realunit,ra,ia,t)
    $ sum((r,i,t0)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(xs,r,i,t)  * m_true2(ps,r,i,t0))
    = sum((r,i,t0)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(xdt,r,i,t) * m_true2(pdt,r,i,t0))
    / sum((r,i,t0)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(xs,r,i,t)  * m_true2(ps,r,i,t0));

* [TBU] quid pdt . xtt

out_External(abstype,"Domestic demand to total demand","nominal",ra,ia,t)
    $ sum((r,i)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2t(xat,r,i,t) * m_true2(pat,r,i,t))
    = sum((r,i)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(xdt,r,i,t) * m_true2(pdt,r,i,t))
    / sum((r,i)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2t(xat,r,i,t) * m_true2(pat,r,i,t));

out_External(abstype,"Domestic demand to total demand",realunit,ra,ia,t)
    $ sum((r,i,t0)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2t(xat,r,i,t) * m_true2(pat,r,i,t0))
    = sum((r,i,t0)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(xdt,r,i,t) * m_true2(pdt,r,i,t0))
    / sum((r,i,t0)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2t(xat,r,i,t) * m_true2(pat,r,i,t0));

LOOP(t0,

    out_External(abstype,"Gross exports (FOB)",realunit,ra,ia,t)
        = outscale * sum((r,i,rp) $ (mapr(ra,r) and mapi(ia,i)),
            To%YearBaseMER%MER(r) * m_true3(pwe,r,i,rp,t0) * m_true3(xw,r,i,rp,t)
            );
    out_External(abstype,"Gross imports (CIF)",realunit,ra,ia,t)
        = outscale * sum((r,i,rp) $ (mapr(ra,r) and mapi(ia,i)),
            To%YearBaseMER%MER(r) * m_true3(pwm,rp,i,r,t0)
              * lambdaw(rp,i,r,t) * m_true3(xw,rp,i,r,t)
            );
) ;

out_External(abstype,"Gross exports (FOB)","nominal",ra,ia,t)
        = outscale * sum((r,i,rp) $ (mapr(ra,r) and mapi(ia,i)),
                  To%YearBaseMER%MER(r) * m_true3(pwe,r,i,rp,t)
                * m_true3(xw,r,i,rp,t) ) ;
out_External(abstype,"Gross imports (CIF)","nominal",ra,ia,t)
        = outscale * sum((r,i,rp) $ (mapr(ra,r) and mapi(ia,i)),
                To%YearBaseMER%MER(r) * m_true3(pwm,rp,i,r,t)
                  * lambdaw(rp,i,r,t) * m_true3(xw,rp,i,r,t) ) ;

*------------------------------------------------------------------------------*
*               Trade structure for a given country                            *
*------------------------------------------------------------------------------*
* Divided by 1000 to translate in billions of %YearGTAP% USD
* [TBC] Not weighted by To%YearBaseMER%MER(r)

out_Trade(abstype,"Trade Flows (FOB)","nominal",origin,destination,ia,t)
    = outscale * sum((r,rp,i)$(mapr(origin,rp) and mapr(destination,r) and mapi(ia,i)),
        m_true3(pwe,rp,i,r,t) * m_true3(xw,rp,i,r,t)) / 1000;

out_Trade(abstype,"Trade Flows (FOB)",realunit,origin,destination,ia,t)
    = outscale * sum((r,rp,i,t0)$(mapr(origin,rp) and mapr(destination,r) and mapi(ia,i)),
        m_true3(pwe,rp,i,r,t0) * m_true3(xw,rp,i,r,t)) / 1000;

IF(%aux_outType% ne AbsValueOnly, !! Calculate Shares

*---    Share of imports of good ia in total imports (for a region)

* Total imports:

    ratwork(ra,ReportYr) = 0;
    ratwork(ra,ReportYr)
        = sum((r,rp,j)$mapr(ra,r), m_true3(pwe,rp,j,r,ReportYr) * m_true3(xw,rp,j,r,ReportYr));

    out_External("pct","Trade Structure: import","nominal",ra,ia,ReportYr)
        $ ratwork(ra,ReportYr)
        = sum((r,i)$(mapr(ra,r) and mapi(ia,i)),
                    sum(rp, m_true3(pwe,rp,i,r,ReportYr) * m_true3(xw,rp,i,r,ReportYr)))
        / ratwork(ra,ReportYr);

    ratwork(ra,ReportYr) = 0;
    ratwork(ra,ReportYr)
        = sum((r,rp,j,t0)$mapr(ra,r), m_true3(pwe,rp,j,r,t0) * m_true3(xw,rp,j,r,ReportYr));

    out_External("pct","Trade Structure: import","real",ra,ia,ReportYr)
        $   ratwork(ra,ReportYr)
        = sum((r,i)$(mapr(ra,r) and mapi(ia,i)),
                    sum((rp,t0),m_true3(pwe,rp,i,r,t0) * m_true3(xw,rp,i,r,ReportYr)))
        / ratwork(ra,ReportYr);

*---    Share of Export of good i in total export (for a region)

* Total exports:

    ratwork(ra,ReportYr) = 0;
    ratwork(ra,ReportYr)
        = sum((r,rp,j) $ mapr(ra,r), m_true3(pwe,r,j,rp,ReportYr) * m_true3(xw,r,j,rp,ReportYr));

    out_External("pct","Trade Structure: export","nominal",ra,ia,ReportYr)
        $ ratwork(ra,ReportYr)
        = sum((r,i)$(mapr(ra,r) and mapi(ia,i)),
                    sum(rp,  m_true3(pwe,r,i,rp,ReportYr) * m_true3(xw,r,i,rp,ReportYr)))
        / ratwork(ra,ReportYr);

    ratwork(ra,ReportYr)
        = sum((r,rp,j,t0) $ mapr(ra,r), m_true3(pwe,r,j,rp,t0) * m_true3(xw,r,j,rp,ReportYr));

    out_External("pct","Trade Structure: export","real",ra,ia,ReportYr)
        $ ratwork(ra,ReportYr)
        = sum((r,i)$(mapr(ra,r) and mapi(ia,i)),
                    sum((rp,t0),m_true3(pwe,r,i,rp,t0) * m_true3(xw,r,i,rp,ReportYr)))
        / ratwork(ra,ReportYr);

*------------------------------------------------------------------------------*
*                           Market Shares                                      *
*------------------------------------------------------------------------------*

* Share of import of good ia by country ra in world (total) import of good i

    out_External("pct","Market Shares: import",units,ra,ia,ReportYr)
        $ out_Trade("abs","Trade Flows (FOB)",units,"WORLD","WORLD",ia,ReportYr)
        = out_Trade("abs","Trade Flows (FOB)",units,"WORLD",ra,ia,ReportYr)
        / out_Trade("abs","Trade Flows (FOB)",units,"WORLD","WORLD",ia,ReportYr);

* Share of export of good i by country ra in world (total) export of good i

    out_External("pct","Market Shares: export",units,ra,ia,ReportYr)
        $ out_Trade("abs","Trade Flows (FOB)",units,"WORLD","WORLD",ia,ReportYr)
        = out_Trade("abs","Trade Flows (FOB)",units,ra,"WORLD",ia,ReportYr)
        / out_Trade("abs","Trade Flows (FOB)",units,"WORLD","WORLD",ia,ReportYr);


*---    For a given country:

* share of import from country "origin" in total import of the country

    out_Trade("pct","Market Shares: import",units,origin,destination ,ia,ReportYr)
        $ out_Trade("abs","Trade Flows (FOB)",units,"WORLD",destination,ia,ReportYr)
        = out_Trade("abs","Trade Flows (FOB)",units,origin,destination,ia,ReportYr)
        / out_Trade("abs","Trade Flows (FOB)",units,"WORLD",destination,ia,ReportYr);

* share of export toward country "destination" in total export of the country

    out_Trade("pct","Market Shares: export",units,origin,destination,ia,ReportYr)
        $ out_Trade("abs","Trade Flows (FOB)",units,origin,"WORLD",ia,ReportYr)
        = out_Trade("abs","Trade Flows (FOB)",units,origin,destination,ia,ReportYr)
        / out_Trade("abs","Trade Flows (FOB)",units,origin,"WORLD",ia,ReportYr);
);

*------------------------------------------------------------------------------*
*                           out_Ratios                                          *
*------------------------------------------------------------------------------*
* Re-divide by converter to express in same units

out_Ratios(abstype,"Trade Balance to GDP","nominal",ra,"Total",t)
    $ out_GDP("abs","Market Prices","nominal",ra,t)
    = out_External("abs","Trade balance (accounting)","nominal",ra,"ttot-c",t)
    / out_GDP("abs","Market Prices","nominal",ra,t);

* Trade Margins not taken into account here ( + outscale * m_true(pd(r,i,t)) * xtt.l(r,i,t))
step1(r,i,"tot",t) = 0;
step1(r,i,"tot",t) = To%YearBaseMER%MER(r)*[expt(r,i,t) + impt(r,i,t)];
out_Ratios(abstype,"Trade openness","nominal",ra,ia,t)
    $ out_Value_Added("abs","Basic Prices","nominal",ra,ia,t)
    = 0.5 * sum((r,i)$(mapr(ra,r) and mapi(ia,i)), step1(r,i,"tot",t))
    / out_Value_Added("abs","Basic Prices","nominal",ra,ia,t);

step1(r,i,"tot",t) = 0;
step1(r,"tot","tot",t) = To%YearBaseMER%MER(r) * sum(i,expt(r,i,t) + impt(r,i,t));
out_Ratios(abstype,"Trade openness","nominal",ra,"tot",t)
    $ out_GDP("abs","Market Prices","nominal",ra,t)
    =  0.5 * sum(r$(mapr(ra,r)), step1(r,"tot","tot",t))
    / out_GDP("abs","Market Prices","nominal",ra,t);

* Just Keep The structure not absolute trade flows
*   out_Trade(abstype,"Trade Flows (FOB)",units,origin,destination,ia,t) = 0;

* Je pense que pour RCA il faut mettre en valeur

out_External(abstype,"RCA",units,ra,ia,t)
    $ out_External("abs","Gross exports (FOB)",units,ra,ia,t)
    =  [ out_External("abs","Gross exports (FOB)",units,ra,ia,t)
            / out_External("abs","Gross exports (FOB)",units,ra,"ttot-c",t)]
      /[ out_External("abs","Gross exports (FOB)",units,"WORLD",ia,t)
        / out_External("abs","Gross exports (FOB)",units,"WORLD","ttot-c",t)];

* Limit RCA calculations to only those regions that have at least 1% of global exports of that commodity

out_External(abstype,"RCA main",units,ra,ia,t)
    $(out_External("abs","Gross exports (FOB)",units,ra,ia,t)
        AND out_External("pct","Market Shares: export",units,ra,ia,t)>0.01)
    =  [out_External("abs","Gross exports (FOB)",units,ra,ia,t)
            /out_External("abs","Gross exports (FOB)",units,ra,"ttot-c",t)]
      /[out_External("abs","Gross exports (FOB)",units,"WORLD",ia,t)
            /out_External("abs","Gross exports (FOB)",units,"WORLD","ttot-c",t)];


