$OnText
--------------------------------------------------------------------------------
                    [OECD-ENV] Model V.1. - Reporting procedure
    Name of the File: "%AuxPrgDir%\01-GDP.gms"
    purpose:    GDP calculations (various definitions)
                GDP(typevar,gdp_definition,units,ra,t)
                All put to scale with True GDP Numbers with To%YearBaseMER%MER
    created date: 2021-03-18
    created by  : Jean Chateau
    called by   : %OutMngtDir%\OutAuxi.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/AuxiPrg/01-GDP.gms $
   last changed revision: $Rev: 131 $
   last changed date    : $Date:: 2022-12-12 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Memo:   FC = Net-prices   = Market prices  = VFM
            Basic Price = Gross-Prices = Agents' prices = EVFA (WB)
    All variables are conditioned to existence of out_GDP("Market Prices")
    Limit this to working years between3(t,"%YearStart%","%YearEndofSim%")
    will reduce size of output to consistent numbers
--------------------------------------------------------------------------------
$OffText

$IFi NOT %SimType%=="CompStat" out_GDP(abstype,"Market Prices","real",ra,t) $ between3(t,"%YearStart%","%YearEndofSim%")
$IFi     %SimType%=="CompStat" out_GDP(abstype,"Market Prices","real",ra,t)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(rgdpmp,r,t));

out_GDP(abstype,"Market Prices","nominal",ra,t)
    $ out_GDP(abstype,"Market Prices","real",ra,t)
    = outscale * sum(mapr(ra,r), To%YearBaseMER%MER(r) * m_true1(gdpmp,r,t));

out_GDP(abstype,"PPP","real",ra,t)
    $ out_GDP(abstype,"Market Prices","real",ra,t)
    = outscale * sum(mapr(ra,r), To%YearBasePPP%PPP(r) * m_true1(rgdpmp,r,t));

*---     Factor Cost (VFM): remunerations nettes

* Avec : wage (VFM or NET or Market Prices) (e.g. ce que reçoivent ménages)
*  < wagep (EVFA or Brut or Agent's Prices) (e.g. ce que payent les entreprises)

out_GDP(abstype,"Factor Cost","nominal",ra,t)
    $ out_GDP(abstype,"Market Prices","real",ra,t)
    = sum((r,a) $ mapr(ra,r), To%YearBaseMER%MER(r) *
            [ sum(l $ labFlag(r,l,a), m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t))
            + sum(v, m_true3v(pk,r,a,v,t) * m_true3vt(kv,r,a,v,t) )$ kflag(r,a)       !! + kspec.l(r,i,v)
            + [m_true2(pland,r,a,t) * m_true2t(land,r,a,t)] $ landFlag(r,a)
            + [m_true2(pnrf,r,a,t)  * m_true2(xnrf,r,a,t)] $ nrfFlag(r,a)
            ]
         );

* Here Current efficiency: * [TBU] with --> * TFP_fp.l ?
out_GDP(abstype,"Factor Cost","real",ra,t)
    $ out_GDP(abstype,"Market Prices","real",ra,t)
    = sum(r$mapr(ra,r), To%YearBaseMER%MER(r) * sum((a,t0),
        [   sum(l $ labFlag(r,l,a), m_true3(wage,r,l,a,t0) * lambdal.l(r,l,a,t) * m_true3t(ld,r,l,a,t) / lambdal.l(r,l,a,t0))
            + sum(v, m_true3v(pk,r,a,v,t0) * lambdak.l(r,a,v,t) * m_true3vt(kv,r,a,v,t) / lambdak.l(r,a,v,t0)) $ kflag(r,a) !! + kspec.l(r,i,v)
            + [m_true2(pland,r,a,t0) * sum(vOld,  lambdat.l(r,a,vOld,t)/lambdat.l(r,a,vOld,t0))   * m_true2t(land,r,a,t) ] $ landFlag(r,a)
            + [ m_true2(pnrf,r,a,t0) * sum(vOld,lambdanrf.l(r,a,vOld,t)/lambdanrf.l(r,a,vOld,t0)) * m_true2(xnrf,r,a,t) ] $ nrfFlag(r,a)
        ]
         ));

* Re-scale in millions

out_GDP(abstype,gdp_definition,notvol,ra,t)
    = outscale * out_GDP(abstype,gdp_definition,notvol,ra,t);

*------------------------------------------------------------------------------*
*           Express in true values (not GTAP adjusted)                         *
*               at any chosen base year : %YearBaseMER%                        *
*------------------------------------------------------------------------------*
* GDP per capita (GDP per head, thousands of USD in constant %YearBaseMER% PPPs)

out_GDP(abstype,"Market Prices Per Capita",notvol,ra,t)
    $ sum(mapr(ra,r), m_true1(POP,r,t))
    = out_GDP(abstype,"Market Prices",notvol,ra,t) * 1000
    / sum(mapr(ra,r), m_true1(POP,r,t)) ;

out_GDP(abstype,"PPP Per Capita",notvol,ra,t)
    $ sum(mapr(ra,r), m_true1(POP,r,t))
    = out_GDP(abstype,"PPP",notvol,ra,t) * 1000
    / sum(mapr(ra,r), m_true1(POP,r,t)) ;

* Ratio to %YearRef% and growth rate

$batinclude "%AuxPrgDir%\calc_dev.gms" "out_GDP" "gdp_definition,notvol,ra"

*------------------------------------------------------------------------------*
*              Regional and sectoral aggregations for Value Added              *
*------------------------------------------------------------------------------*

out_Value_Added(abstype,gdp_definition,notvol,ra,aga,t)
    $(not mp_def(gdp_definition) and out_GDP(abstype,"Market Prices","real",ra,t))
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)),
        To%YearBaseMER%MER(r)
            * out_Value_Added(abstype,gdp_definition,notvol,r,a,t));

out_Value_Added(abstype,"PPP","real",ra,aga,t)
    $ out_GDP(abstype,"Market Prices","real",ra,t)
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)),
        To%YearBasePPP%PPP(r) * out_Value_Added(abstype,"PPP","real",r,a,t));

* Ratio to %YearRef% and growth rate

$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Value_Added" "gdp_definition,notvol,ra,aga"

* "Value added at Market Prices" (Pas interessant)

IF(0,
    out_Value_Added(abstype,mp_def,notvol,ra,ia,t)
        = sum((r,i)$(mapr(ra,r) and mapi(ia,i)),
            To%YearBaseMER%MER(r)*out_Value_Added(abstype,mp_def,notvol,r,i,t));

    $$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Value_Added" "mp_def,notvol,ra,ia"

ELSE
    out_Value_Added(abstype,mp_def,notvol,ra,ia,t) = 0;
);

* Sectoral composition of total value added (no sense for "Market Prices")

IF(%aux_outType% ne AbsValueOnly,
    out_Value_Added("pct",gdp_definition,notvol,ra,aga,t)
        $(out_Value_Added("abs",gdp_definition,notvol,ra,"ttot-a",t)
            and not mp_def(gdp_definition))
        = out_Value_Added("abs",gdp_definition,notvol,ra,aga,t)
        / out_Value_Added("abs",gdp_definition,notvol,ra,"ttot-a",t);
);

*------------------------------------------------------------------------------*
*              Regional and sectoral aggregations for Value Gross Output       *
*------------------------------------------------------------------------------*

out_Gross_output(abstype,notvol,ra,aga,t)
    $ out_GDP(abstype,"Market Prices","real",ra,t)
    = sum((r,a)$(mapr(ra,r) * mapaga(aga,a)),
        To%YearBaseMER%MER(r) * out_Gross_output(abstype,notvol,r,a,t));

* Ratio to %YearRef% and growth rate

$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Gross_output" "notvol,ra,aga"

* [TBU]
$IfTheni.target %cal_NRG%=="ONE"

* IEA USD value have been converted into ENV-L USD

        out_Gross_output("target","volume",ra,a,t)
            = sum(mapr(ra,r),Supply_WEM_for_EL(r,a,"%ActWeoSc%",t));
        out_Gross_output("target","volume",ra,"TotEly",t)
            = sum(mapr(ra,r),Supply_WEM_for_EL(r,"TotEly","%ActWeoSc%",t));

        out_Gross_output("target","real",ra,fossilea,t)
            = sum(mapr(ra,r), sum((t0,fossilei)$(tmat(fossilea,fossilei,r) ne 0), agent_Price_WEM_for_EL(r,fossilei,"%ActWeoSc%",t0)) * Supply_WEM_for_EL(r,fossilea,"%ActWeoSc%",t));
        out_Gross_output("target","real",ra,"TotEly",t)
            = sum(mapr(ra,r), sum(t0, agent_Price_WEM_for_EL(r,"ely-c","%ActWeoSc%",t0)) * Supply_WEM_for_EL(r,"TotEly","%ActWeoSc%",t));

        out_Gross_output("target","nominal",ra,fossilea,t)
            = sum(mapr(ra,r), sum(fossilei$(tmat(fossilea,fossilei,r) ne 0), agent_Price_WEM_for_EL(r,fossilei,"%ActWeoSc%",t)) * Supply_WEM_for_EL(r,fossilea,"%ActWeoSc%",t));
        out_Gross_output("target","nominal",ra,"TotEly",t)
            = sum(mapr(ra,r), agent_Price_WEM_for_EL(r,"ely-c","%ActWeoSc%",t) * Supply_WEM_for_EL(r,"TotEly","%ActWeoSc%",t));

* Calons les targets sur les variables du modele

       out_Gross_output("target",notvol,ra,a,t)
            $ out_Gross_output("target",notvol,ra,a,"%YearStart%")
            = out_Gross_output("target",notvol,ra,a,t)
            * sum(abstype,out_Gross_output(abstype,notvol,ra,a,"%YearStart%"))
            / out_Gross_output("target",notvol,ra,a,"%YearStart%");

$EndIf.target

* Sectoral composition of total value output

IF(%aux_outType% ne AbsValueOnly,
    LOOP(abstype,
        out_Gross_output("pct",notvol,ra,aga,t)
            $ out_Gross_output(abstype,notvol,ra,"ttot-a",t)
            = out_Gross_output(abstype,notvol,ra,aga,t)
            / out_Gross_output(abstype,notvol,ra,"ttot-a",t);
    ) ;
);
