$OnText
--------------------------------------------------------------------------------
   OECD ENV-Linkages project Version 4
   purpose: Compute energy variables
--------------------------------------------------------------------------------
$OffText

*------------------------------------------------------------------------------*
*                     Electricity Information                                  *
*------------------------------------------------------------------------------*

*---    Electricity generation (TWh)
rsworkT(r,a,t) = 0;
rsworkT(r,a,t) $ m_Sim_Horizon(t) = sum(elyi,m_true(x(r,a,elyi,t)));

LOOP(a$powa(a),

    out_Energy(abstype,"Electricity Generation","TWh",ra,a,t)
        = sum(r$mapr(ra,r), rsworkT(r,a,t) / Powscale);

* Temp fix as pscale is not in output gdx file

    out_Energy(abstype,"Electricity Price","TWh",ra,a,t)
        $(sum(r$mapr(ra,r), rsworkT(r,a,t) ))
        = sum((r,elyi)$(mapr(ra,r)), m_true(p(r,a,elyi,t)) * m_true(x(r,a,elyi,t)))
        / sum((r,elyi)$(mapr(ra,r)), rsworkT(r,a,t) );
);

*---    Total Electricity generation
out_Energy(abstype,"Electricity Generation","TWh",ra,"TotEly",t)
    $ m_Sim_Horizon(t)
    = sum(a $ powa(a), out_Energy(abstype,"Electricity Generation","TWh",ra,a,t));

LOOP(a$(elya(a) and not etd(a)),
    out_Energy("pct","Electricity Generation","TWh",ra,a,t)
        $ out_Energy("abs","Electricity Generation","TWh",ra,"TotEly",t)
        = out_Energy("abs","Electricity Generation","TWh",ra,a,t)
        / out_Energy("abs","Electricity Generation","TWh",ra,"TotEly",t);
);

$IfThenI.target %cal_NRG%=="ON"
    out_Energy("target","Electricity Generation","TWh",ra,"TotEly",t)
        = sum(r$mapr(ra,r), Supply_WEM_for_EL(r,"TotEly","%ActWeoSc%",t));
    rworkT(r,t)
        = sum(a$(elya(a) and not etd(a)), Power_Generation_WEM_for_EL(r,a,"%ActWeoSc%",t));
    out_Energy("target","Electricity Generation","TWh",ra,a,t)
        $ (elya(a) and not etd(a) and sum(r$mapr(ra,r),rworkT(r,t)))
        = sum(r$mapr(ra,r),Power_Generation_WEM_for_EL(r,a,"%ActWeoSc%",t))
        * out_Energy("target","Electricity Generation","TWh",ra,"TotEly",t)
        / sum(r$mapr(ra,r),rworkT(r,t));
$ENDIF.target

out_Energy("pct","Renewable Electricity share","TWh",ra,"TotEly",t)
    $ out_Energy("abs","Electricity Generation","TWh",ra,"TotEly",t)
    = sum(a$(s_otr(a) or HYDRO(a)),out_Energy("abs","Electricity Generation","TWh",ra,a,t))
    / out_Energy("abs","Electricity Generation","TWh",ra,"TotEly",t);

*------------------------------------------------------------------------------*
*                           Energy demands (Mtoe)                              *
*------------------------------------------------------------------------------*

*---    Final Demands
out_Energy(abstype,"Energy Demand: Electricity","Mtoe",ra,fd,t)
    = sum(r$mapr(ra,r),sum(elyi, nrj_mtoe(r,elyi,fd,t)));
out_Energy(abstype,"Energy Demand: Gas","Mtoe",ra,fd,t)
    = sum(r$mapr(ra,r),sum(GASi, nrj_mtoe(r,GASi,fd,t))); !! 2 secteurs
out_Energy(abstype,"Energy Demand: Coal","Mtoe",ra,fd,t)
    = sum(r$mapr(ra,r),sum(COAi, nrj_mtoe(r,COAi,fd,t)));
out_Energy(abstype,"Energy Demand: Oil","Mtoe",ra,fd,t)
    = sum(r$mapr(ra,r),sum(OILi,nrj_mtoe(r,OILi,fd,t)));  !! 2 secteurs
*out_Energy(abstype,"Refined Oil Demand","Mtoe",ra,aa,t)
*    = sum(r$mapr(ra,r),sum(ROILi,nrj_mtoe(r,ROILi,aa,t)));
*out_Energy(abstype,"Energy Demand: Crude Oil","Mtoe",ra,aa,t)
*    = sum(r$mapr(ra,r),sum(COILi,nrj_mtoe(r,COILi,aa,t)));

out_Energy(abstype,"Energy Demand: Electricity","Mtoe",ra,aga,t)
    = sum((r,a)$(mapr(ra,r) * mapaga(aga,a)),sum(elyi, nrj_mtoe(r,elyi,a,t)));
out_Energy(abstype,"Energy Demand: Gas","Mtoe",ra,aga,t)
    = sum((r,a)$(mapr(ra,r) * mapaga(aga,a)),sum(GASi, nrj_mtoe(r,GASi,a,t))); !! 2 secteurs
out_Energy(abstype,"Energy Demand: Coal","Mtoe",ra,aga,t)
    = sum((r,a)$(mapr(ra,r) * mapaga(aga,a)),sum(COAi, nrj_mtoe(r,COAi,a,t)));
out_Energy(abstype,"Energy Demand: Oil","Mtoe",ra,aga,t)
    = sum((r,a)$(mapr(ra,r) * mapaga(aga,a)),sum(OILi,nrj_mtoe(r,OILi,a,t)));  !! 2 secteurs

*---    Total across energy carriers
out_Energy(abstype,"Energy Demand: Total","Mtoe",ra,aa,t)
    = sum(nrglist,out_Energy(abstype,nrglist,"Mtoe",ra,aa,t));
*---    Electricity sector grouped (e.g. "TotEly")
out_Energy(abstype,nrglist,"Mtoe",ra,"TotEly",t)
    = sum(elya,out_Energy(abstype,nrglist,"Mtoe",ra,elya,t));

* Energy Intensity tonnes of oil equivalent (toe) per thousand %YearBaseMER% US
* dollars of GDP, calculated using MER
$IfThenI.OutFull %aux_outType%=="FULL"
    out_Energy(abstype,"Energy intensity: Electricity","Mtoe",ra,aga,t)
        $ out_Gross_output(abstype,"real",ra,aga,t)
        = out_Energy(abstype,"Energy Demand: Electricity","Mtoe",ra,aga,t)
        / [0.001 * out_Gross_output(abstype,"real",ra,aga,t)];

    out_Energy(abstype,"Energy intensity: Gas","Mtoe",ra,aga,t)
        $ out_Gross_output(abstype,"real",ra,aga,t)
        = out_Energy(abstype,"Energy Demand: Gas","Mtoe",ra,aga,t)
        / [0.001 * out_Gross_output(abstype,"real",ra,aga,t)];

    out_Energy(abstype,"Energy intensity: Coal","Mtoe",ra,aga,t)
        $ out_Gross_output(abstype,"real",ra,aga,t)
        = out_Energy(abstype,"Energy Demand: Coal","Mtoe",ra,aga,t)
        / [0.001 * out_Gross_output(abstype,"real",ra,aga,t)];

    out_Energy(abstype,"Energy intensity: Oil","Mtoe",ra,aga,t)
        $ out_Gross_output(abstype,"real",ra,aga,t)
        = out_Energy(abstype,"Energy Demand: Oil","Mtoe",ra,aga,t)
        / [0.001 * out_Gross_output(abstype,"real",ra,aga,t)];

    out_Energy(abstype,"Energy intensity: Total","Mtoe",ra,aga,t)
        $ out_Gross_output(abstype,"real",ra,aga,t)
        = out_Energy(abstype,"Energy Demand: Total","Mtoe",ra,aga,t)
        / [0.001 * out_Gross_output(abstype,"real",ra,aga,t)];
$ENDIF.OutFull

* If I want primary / secondary energy:
*--- Total across demands : Pas TPES ici
out_Energy(abstype,nrglist,"Mtoe",ra,"Total",t)
    = sum(aa,out_Energy(abstype,nrglist,"Mtoe",ra,aa,t))
    - out_Energy(abstype,nrglist,"Mtoe",ra,"TotEly",t); !! Do not double accounting ely aggregate

*---    Final Energy Consumption/Demand
$OnText
out_Energy(abstype,"TFC: coal","Mtoe",ra,"Total",t)
    = out_Energy(abstype,"Coal Demand","Mtoe",ra,"Total",t)
    - sum(pdt_emi,out_Energy(abstype,"Coal Demand","Mtoe",ra,pdt_emi,t))
    - sum(elya,out_Energy(abstype,"Coal Demand","Mtoe",ra,elya,t));

out_Energy(abstype,"TFC: natural gas","Mtoe",ra,"Total",t)
    = out_Energy(abstype,"Gas Demand","Mtoe",ra,"Total",t)
    - sum(pdt_emi,out_Energy(abstype,"Gas Demand","Mtoe",ra,pdt_emi,t))
    - sum(elya,out_Energy(abstype,"Gas Demand","Mtoe",ra,elya,t));

out_Energy(abstype,"TFC: liquid fuels","Mtoe",ra,"Total",t)
    = out_Energy(abstype,"Refined Oil Demand","Mtoe",ra,"Total",t)
    + out_Energy(abstype,"Crude Oil Demand","Mtoe",ra,"Total",t)
    - sum(pdt_emi,out_Energy(abstype,"Refined Oil Demand","Mtoe",ra,pdt_emi,t))
    - sum(elya,out_Energy(abstype,"Refined Oil Demand","Mtoe",ra,elya,t))
    - sum(pdt_emi,out_Energy(abstype,"Crude Oil Demand","Mtoe",ra,pdt_emi,t))
    - sum(elya,out_Energy(abstype,"Crude Oil Demand","Mtoe",ra,elya,t));

out_Energy(abstype,"TFC: electricity","Mtoe",ra,"Total",t)
    = out_Energy(abstype,"Electricity Demand","Mtoe",ra,"Total",t)
    - sum(pdt_emi,out_Energy(abstype,"Electricity Demand","Mtoe",ra,pdt_emi,t))
    - sum(elya,out_Energy(abstype,"Electricity Demand","Mtoe",ra,elya,t));

out_Energy(abstype,"TFC: Total","Mtoe",ra,"Total",t)
    = out_Energy(abstype,"TFC: electricity","Mtoe",ra,"Total",t)
    + out_Energy(abstype,"TFC: liquid fuels","Mtoe",ra,"Total",t)
    + out_Energy(abstype,"TFC: natural gas","Mtoe",ra,"Total",t)
    + out_Energy(abstype,"TFC: coal","Mtoe",ra,"Total",t);
$OffText

*---    Ratio to %YearRef% and annual growth rate
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Energy" "nrglist,'Mtoe',ra,aa"

*---    Sectoral and Final Demand composition
$IfThenI.OutFull %aux_outType%=="FULL"
    out_Energy("pct","Energy Demand: Total","Mtoe",ra,aa,t)
        $ out_Energy("abs","Energy Demand: Total","Mtoe",ra,"Total",t)
        = out_Energy("abs","Energy Demand: Total","Mtoe",ra,aa,t)
        / out_Energy("abs","Energy Demand: Total","Mtoe",ra,"Total",t);
    out_Energy("pct","Energy Demand: Electricity","Mtoe",ra,aa,t)
        $ out_Energy("abs","Energy Demand: Electricity","Mtoe",ra,"Total",t)
        = out_Energy("abs","Energy Demand: Electricity","Mtoe",ra,aa,t)
        / out_Energy("abs","Energy Demand: Electricity","Mtoe",ra,"Total",t);
    out_Energy("pct","Energy intensity: Oil","Mtoe",ra,aa,t)
        $ out_Energy("abs","Energy intensity: Oil","Mtoe",ra,"Total",t)
        = out_Energy("abs","Energy intensity: Oil","Mtoe",ra,aa,t)
        / out_Energy("abs","Energy intensity: Oil","Mtoe",ra,"Total",t);
    out_Energy("pct","Energy intensity: Gas","Mtoe",ra,aa,t)
        $ out_Energy("abs","Energy intensity: Gas","Mtoe",ra,"Total",t)
        = out_Energy("abs","Energy intensity: Gas","Mtoe",ra,aa,t)
        / out_Energy("abs","Energy intensity: Gas","Mtoe",ra,"Total",t);
$ENDIF.OutFull

*---    Already dans out_macro
*out_Ratios(abstype,"Energy intensity","volume",ra,"Total",t)
*    $ out_GDP(abstype,"Market Prices","real",ra,t)
*    = out_Energy(abstype,"Energy Demand: Total","Mtoe",ra,"Total",t)
*    / out_GDP(abstype,"Market Prices","real",ra,t);

out_NewEnergy(abstype,"Primary energy","Coal","Supply",ra,t0) = -999;

out_NewEnergy(abstype,"Final energy","Electricity","Supply",ra,t) =
    out_Energy(abstype,"Energy Demand: Electricity","Mtoe",ra,"Total",t)
    - sum(pdt_emi,out_Energy(abstype,"Energy Demand: Electricity","Mtoe",ra,pdt_emi,t))
    - sum(elya   ,out_Energy(abstype,"Energy Demand: Electricity","Mtoe",ra,elya   ,t));
