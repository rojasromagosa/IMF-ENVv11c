
$OnText
--------------------------------------------------------------------------------
   OECD ENV-Linkages project Version 4
   Name of the File: "modules\auxilliary_variables\08-expenses_composition.gms"
   purpose: Decomposion Cost Structure and Demand Decomposition
   created date: 2016-11-17
   created by: Jean Chateau
   called by: \modules\auxilliary_variables.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/AuxiPrg/08-expenses_composition.gms $
   last changed revision: $Rev: 20 $
   last changed date    : $Date:: 2022-09-20 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

* Water ???  Add kspec.l(r,a,v)

*------------------------------------------------------------------------------*
*           Factor structure of Value-added  at Basic (Agent's) Price          *
*------------------------------------------------------------------------------*

* Value-added (at "Basic Prices") = remunerations brutes (EVFA)
* alors que pour Factor Cost on utilise les remunerations nettes (VFM)
* Exple: wagep (EVFA) et non pas wage (VFM)

* Output Tax is excluded (ptax : pp = [ px + pim/ pxscale] * (1 + ptax)]
* It is included in Value-added at "Production Prices"

*---    Nominal
rwork(r) = 0; rwork(r) = To%YearBaseMER%MER(r) * outscale;

*---    Decomposition Value Added by primary factor for each sector
out_ValueAdded_structure(abstype,"nominal",ra,l,aga,t)
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)), rwork(r) * m_wagep(r,l,a,t) * m_true3t(ld,r,l,a,t));
out_ValueAdded_structure(abstype,"nominal",ra,"Capital",aga,t)
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)), rwork(r) * sum(v, m_pkp(r,a,v,t) * m_true3vt(kv,r,a,v,t)));
out_ValueAdded_structure(abstype,"nominal",ra,"Land",aga,t)
    = sum((r,agra)$(mapr(ra,r) and mapaga(aga,agra)), rwork(r) * m_true2(plandp,r,agra,t) * m_true2t(land,r,agra,t));
out_ValueAdded_structure(abstype,"nominal",ra,"NatRes",aga,t)
    = sum((r,natra)$(mapr(ra,r) and mapaga(aga,natra)), rwork(r) * m_true2(pnrfp,r,natra,t) * m_true2(xnrf,r,natra,t));

*---    Real

out_ValueAdded_structure(abstype,"real",ra,l,aga,t)
    = sum((r,a,t0)$(mapr(ra,r) and mapaga(aga,a)), rwork(r) * m_wagep(r,l,a,t0) * lambdal.l(r,l,a,t) *  m_true3t(ld,r,l,a,t));
out_ValueAdded_structure(abstype,"real",ra,"Capital",aga,t)
    = sum((r,v,a,t0)$(mapr(ra,r) and mapaga(aga,a)), rwork(r) * m_pkp(r,a,v,t0) * lambdak.l(r,a,v,t) *  m_true3vt(kv,r,a,v,t));
out_ValueAdded_structure(abstype,"real",ra,"Land",aga,t)
    = sum((r,agra,t0)$(mapr(ra,r) and mapaga(aga,agra)), rwork(r) * m_true2(plandp,r,agra,t0) * lambdat.l(r,agra,"Old",t) * m_true2t(land,r,agra,t));
out_ValueAdded_structure(abstype,"real",ra,"NatRes",aga,t)
    = sum((r,natra,t0)$(mapr(ra,r) and mapaga(aga,natra)), rwork(r) * m_true2(pnrfp,r,natra,t0) * lambdanrf.l(r,natra,"Old",t) * m_true2(xnrf,r,natra,t));

*---    Total primary factor remunerations, by sector
* In real terms it does not match with out_Value_Added("Basic Prices")
* so here we recalculate the sum over factor remuneration instead
out_ValueAdded_structure(abstype,units,ra,"Total",aga,t)
    = sum(fp, out_ValueAdded_structure(abstype,units,ra,fp,aga,t));

*---    Cost share as percentage of total value added at "Basic Prices"
IF(%aux_outType% ne AbsValueOnly,
    out_ValueAdded_structure("pct",units,ra,fp,aga,ReportYr)
        $ out_ValueAdded_structure("abs",units,ra,"Total",aga,ReportYr)
        = out_ValueAdded_structure("abs",units,ra,fp,aga,ReportYr)
        / out_ValueAdded_structure("abs",units,ra,"Total",aga,ReportYr);
    out_ValueAdded_structure("pct",units,ra,"Total",aga,ReportYr) = 0;
);

*---    Ratio to %YearRef% and annual growth rate
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_ValueAdded_structure" "units,ra,fp,aga"

*------------------------------------------------------------------------------*
*                           Demands structure                                  *
*------------------------------------------------------------------------------*
* Total domestic expenditure = ECO Dpt NAME TDD (value) and TDDV (volume)

*------         Household and Other Final Demand
*---    at Agent's prices (all excise taxes included)
stepa(r,i,fd,t) = To%YearBaseMER%MER(r) * m_true3(pa,r,i,fd,t) * XAPT(r,i,fd,t);
out_Final_Demands(abstype,"nominal",ra,ia,fd,t)
    = sum((r,i)$(mapr(ra,r) and mapi(ia,i)), stepa(r,i,fd,t));
stepa(r,i,fd,t) = 0;
stepa(r,i,fd,t)
    = To%YearBaseMER%MER(r) * sum(t0,m_true3(pa,r,i,fd,t0)) * xapT(r,i,fd,t);
out_Final_Demands(abstype,"real",ra,ia,fd,t)
    = sum((r,i)$(mapr(ra,r) and mapi(ia,i)), stepa(r,i,fd,t));
*---    at Market's prices (Not all years)
stepa(r,i,fd,ReportYr)
    = To%YearBaseMER%MER(r) * m_true2(pat,r,i,ReportYr) * XAPT(r,i,fd,ReportYr);
out_expenses_composition_mp(abstype,fd_expenses,"nominal",ra,ia,fd,ReportYr)
    = sum((r,i)$(mapr(ra,r) and mapi(ia,i)), stepa(r,i,fd,ReportYr));
stepa(r,i,fd,ReportYr) = 0;
stepa(r,i,fd,ReportYr)
    = To%YearBaseMER%MER(r) * sum(t0,m_true2(pat,r,i,t0))*xapT(r,i,fd,ReportYr);
out_expenses_composition_mp(abstype,fd_expenses,"real",ra,ia,fd,ReportYr)
    = sum((r,i)$(mapr(ra,r) and mapi(ia,i)), stepa(r,i,fd,ReportYr));

*---    Total Final Consumption
out_Final_Demands(abstype,units,ra,ia,"Total",t)
    = sum(fd,out_Final_Demands(abstype,units,ra,ia,fd,t));
out_expenses_composition_mp(abstype,fd_expenses,units,ra,ia,"Total",ReportYr)
    = sum(fd,out_expenses_composition_mp(abstype,fd_expenses,units,ra,ia,fd,ReportYr));

*------         Intermediate Demands
*---    at Agent's prices (all excise taxes included)
step1(r,i,a,t) = To%YearBaseMER%MER(r) * m_true3(pa,r,i,a,t) * xapT(r,i,a,t);
out_Intermediary_Demands(abstype,"nominal",ra,ia,aga,t)
    = sum((r,a,i)$(mapr(ra,r) and mapaga(aga,a) and mapi(ia,i)), step1(r,i,a,t));
step1(r,i,a,t) = 0;
step1(r,i,a,t) = To%YearBaseMER%MER(r) * sum(t0,m_true3(pa,r,i,a,t0)) * xapT(r,i,a,t); !! this is correct previous run wrong
out_Intermediary_Demands(abstype,"real",ra,ia,aga,t)
    = sum((r,a,i)$(mapr(ra,r) and mapaga(aga,a) and mapi(ia,i)), step1(r,i,a,t));

*---    at Market's prices (Not all years)
step1(r,i,a,t) = 0;
step1(r,i,a,ReportYr)
    = To%YearBaseMER%MER(r) * m_true2(pat,r,i,ReportYr) * xapT(r,i,a,ReportYr);
out_expenses_composition_mp(abstype,id_expenses,"nominal",ra,ia,aga,ReportYr)
    = sum((r,a,i)$(mapr(ra,r) and mapaga(aga,a) and mapi(ia,i)), step1(r,i,a,ReportYr));
step1(r,i,a,t) = 0;
step1(r,i,a,ReportYr)
    = To%YearBaseMER%MER(r) * sum(t0,m_true2(pat,r,i,t0)) * xapT(r,i,a,ReportYr);
out_expenses_composition_mp(abstype,id_expenses,"real",ra,ia,aga,ReportYr)
    = sum((r,a,i)$(mapr(ra,r) and mapaga(aga,a) and mapi(ia,i)), step1(r,i,a,ReportYr));

*---    Total Intermediate Demands
out_Intermediary_Demands(abstype,units,ra,ia,"Total",t)
    = out_Intermediary_Demands(abstype,units,ra,ia,"ttot-a",t);
out_expenses_composition_mp(abstype,id_expenses,units,ra,ia,"Total",ReportYr)
    = out_expenses_composition_mp(abstype,id_expenses,units,ra,ia,"ttot-a",ReportYr);

out_Intermediary_Demands(abstype,units,ra,ia,"ttot-a",t)       = 0;
out_expenses_composition_mp(abstype,id_expenses,units,ra,ia,"ttot-a",ReportYr) = 0;

*---    Total (armington) Demand for each commodity
out_Total_Demands(abstype,units,ra,ia,"Total",t)
    = out_Intermediary_Demands(abstype,units,ra,ia,"Total",t)
    + out_Final_Demands(abstype,units,ra,ia,"Total",t);
out_expenses_composition_mp(abstype,tot_expenses,units,ra,ia,"Total",ReportYr)
    = sum(id_expenses,out_expenses_composition_mp(abstype,id_expenses,units,ra,ia,"Total",ReportYr))
    + sum(fd_expenses,out_expenses_composition_mp(abstype,fd_expenses,units,ra,ia,"Total",ReportYr));

*---    Ratio to %YearRef% and annual growth rate (only for Agent's prices)
*   (Not in the cas%aux_outType% ne AbsValueOnly )
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Intermediary_Demands" "units,ra,ia,aga"
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Final_Demands" "units,ra,ia,fd"
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Total_Demands" "units,ra,ia,'Total'"

*---    Calculate the COST/BUDGET Structure in percentage (only for agent's price)
IF(%aux_outType% ne AbsValueOnly,
*---    Good composition of total input cost of a sector a (in percentage of total intermediary demands)
*   by sector (e.g. I-O): only at Agent's prices
    out_Intermediary_Demands("pct",units,ra,ia,aga,ReportYr)
        $ sum(abstype,out_Intermediary_Demands(abstype,units,ra,"ttot-c",aga,ReportYr))
        = sum(abstype,out_Intermediary_Demands(abstype,units,ra,ia,aga,ReportYr))
        / sum(abstype,out_Intermediary_Demands(abstype,units,ra,"ttot-c",aga,ReportYr));

* Household (and Final Demand) budget/expenses structure
    out_Final_Demands("pct",units,ra,ia,fd,ReportYr)
        $ sum(abstype,out_Final_Demands(abstype,units,ra,"ttot-c",fd,ReportYr))
        = sum(abstype,out_Final_Demands(abstype,units,ra,ia,fd,ReportYr))
        / sum(abstype,out_Final_Demands(abstype,units,ra,"ttot-c",fd,ReportYr));

*---    groups all small categories together for composition of
    $$IfTheni.group %aux_GroupSmallCategory% == "ON"
        out_Final_Demands("pct",units,ra,"other-c",aa,ReportYr)
            = sum(ia$(not ia_noi(ia) and out_Final_Demands("pct",units,ra,ia,aa,ReportYr) lt 0.01), out_Final_Demands("pct",units,ra,ia,aa,ReportYr));
        out_Final_Demands("pct",units,ra,ia,aa,ReportYr)
            $(not ia_noi(ia) and out_Final_Demands("pct",units,ra,ia,aa,ReportYr) lt 0.01) = 0;
        out_Intermediary_Demands("pct",units,ra,"other-c",aga,ReportYr)
            = sum(ia$(not ia_noi(ia) and out_Intermediary_Demands("pct",units,ra,ia,aga,ReportYr) lt 0.01), out_Intermediary_Demands("pct",units,ra,ia,aga,ReportYr));
        out_Intermediary_Demands("pct",units,ra,ia,aga,ReportYr)
            $(not ia_noi(ia) and out_Intermediary_Demands("pct",units,ra,ia,aga,ReportYr) lt 0.01) = 0;
    $$EndIf.group

*---    Structure of total demand  for commodity ia (agents' price)
    out_Total_Demands("pct",units,ra,ia,aga,ReportYr)
        $ sum(abstype,out_Total_Demands(abstype,units,ra,ia,'Total',ReportYr))
        = sum(abstype,out_Intermediary_Demands(abstype,units,ra,ia,aga,ReportYr))
        / sum(abstype,out_Total_Demands(abstype,units,ra,ia,'Total',ReportYr));
    out_Total_Demands("pct",units,ra,ia,fd,ReportYr)
        $ sum(abstype,out_Total_Demands(abstype,units,ra,ia,'Total',ReportYr))
        = sum(abstype,out_Final_Demands(abstype,units,ra,ia,fd,ReportYr))
        / sum(abstype,out_Total_Demands(abstype,units,ra,ia,'Total',ReportYr));

*    $$IfTheni.group %aux_GroupSmallCategory% == "ON"
*        out_Total_Demands("pct",units,ra,ia,"other",ReportYr)
*            = sum(aga$(out_Total_Demands("pct",units,ra,ia,aga,ReportYr) lt 0.01), out_Total_Demands("pct",units,ra,ia,aga,ReportYr));
*        out_Total_Demands("pct",units,ra,ia,"other",ReportYr)
*            = out_Total_Demands("pct",units,ra,ia,"other",ReportYr)
*            + sum(fd$(out_Total_Demands("pct",units,ra,ia,fd,ReportYr) lt 0.01), out_Final_Demands("pct",units,ra,ia,fd,ReportYr))
*    $$EndIf.group

);
*------------------------------------------------------------------------------*
*  Decomposition of Gross Output cost stucture at Basic Prices by sector aga   *
*------------------------------------------------------------------------------*

*---    1.)     Gross Value added (Basic Prices / Agent's Prices)
out_GrossOutput_structure(abstype,units,ra,fp,aga,t)
    = out_ValueAdded_structure(abstype,units,ra,fp,aga,t);

*---    2.)     Intermediary inputs
out_GrossOutput_structure(abstype,units,ra,ia,aga,t)
    =  out_Intermediary_Demands(abstype,units,ra,ia,aga,t);

*---    Total primary factor remunerations + inputs  by sector
out_GrossOutput_structure(abstype,units,ra,"Total",aga,t)
    = out_ValueAdded_structure(abstype,units,ra,"Total",aga,t)
    + sum(ia$(not ia_noi(ia)),
        out_Intermediary_Demands(abstype,units,ra,ia,aga,t));

*---    Cost Structure of Sectors in percentages
IF(%aux_outType% ne AbsValueOnly,
*   Primary factors:
   out_GrossOutput_structure("pct",units,ra,fp,aga,ReportYr)
        $ sum(abstype,out_GrossOutput_structure(abstype,units,ra,"Total",aga,ReportYr))
        = sum(abstype,out_GrossOutput_structure(abstype,units,ra,fp,aga,ReportYr))
        / sum(abstype,out_GrossOutput_structure(abstype,units,ra,"Total",aga,ReportYr)); !! Gross Output = at Production Price
*   Intermediary demands:
    out_GrossOutput_structure("pct",units,ra,ia,aga,ReportYr)
        $ sum(abstype,out_GrossOutput_structure(abstype,units,ra,"Total",aga,ReportYr))
        = sum(abstype,out_GrossOutput_structure(abstype,units,ra,ia,aga,ReportYr))
        / sum(abstype,out_GrossOutput_structure(abstype,units,ra,"Total",aga,ReportYr));
);

*---    groups all small categories together (in "other-c") for composition
IF(%aux_outType% ne FULL,
    out_GrossOutput_structure(abstype,units,ra,"other-c",aga,t)
        = sum(ia$(not ia_noi(ia) and out_GrossOutput_structure("pct",units,ra,ia,aga,t) lt 0.01),
            out_GrossOutput_structure("pct",units,ra,ia,aga,t));
    out_GrossOutput_structure(abstype,units,ra,ia,aga,t)
        $(not ia_noi(ia) and out_GrossOutput_structure("pct",units,ra,ia,aga,t) lt 0.01)  = 0;
);

*---    Ratio to %YearRef% and annual growth rate (IF NOT %aux_outType%=="AbsValueOnly")
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_GrossOutput_structure" "units,ra,fp,aga"
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_GrossOutput_structure" "units,ra,ia,aga"
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_GrossOutput_structure" "units,ra,ia,'total'"

$droplocal subfolder

* !!! 100 fois plus lent si je fais
*    = sum((r,a,i), mapr(ra,r) * mapaga(aga,a) * mapi(ia,i) * out_expenses_composition(abstype,"Intermediate Demand",units,r,i,a,t));
