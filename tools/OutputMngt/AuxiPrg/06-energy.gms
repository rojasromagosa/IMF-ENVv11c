$OnText
--------------------------------------------------------------------------------
                    [OECD-ENV] Model V.1. - Reporting procedure
    GAMS file   : "%AuxPrgDir%\06-Energy.gms"
    purpose     : Fill Energy variables: out_Energy(typevar,nrglist,envunits,ra,agents,t)
    created date: 2021-03-18
    created by  : Jean Chateau
    called by   : %OutMngtDir%\OutAuxi.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/AuxiPrg/06-energy.gms $
   last changed revision: $Rev: 285 $
   last changed date    : $Date:: 2023-04-17 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*------------------------------------------------------------------------------*
*                     Electricity Information                                  *
*------------------------------------------------------------------------------*

*---    Electricity generation (TWh) : x(r,a,elya,t)

risworkT(r,a,t) = 0;
$IFi NOT %SimType%=="CompStat" risworkT(r,a,t) $ between3(t,"%YearStart%","%YearEndofSim%")
$IFi     %SimType%=="CompStat" risworkT(r,a,t)
    = sum(elyi,m_true3t(x,r,a,elyi,t));

LOOP(a $ powa(a),

    out_Energy(abstype,"Electricity Generation","TWh",ra,a,t)
        = sum(r $ mapr(ra,r), risworkT(r,a,t) / Powscale);

* Temp fix as pscale is not in output gdx file

    out_Energy(abstype,"Electricity Price","TWh",ra,a,t)
        $(sum(r$mapr(ra,r), risworkT(r,a,t) ))
        = sum((r,elyi)$(mapr(ra,r)), m_true3(p,r,a,elyi,t) * m_true3t(x,r,a,elyi,t))
        / sum((r,elyi)$(mapr(ra,r)), risworkT(r,a,t) );

);

*	Total Electricity generation

out_Energy(abstype,"Electricity Generation","TWh",ra,"TotEly",t)
    = sum(powa, out_Energy(abstype,"Electricity Generation","TWh",ra,powa,t));

out_Energy("pct","Electricity Generation","TWh",ra,powa,t)
    $ out_Energy("abs","Electricity Generation","TWh",ra,"TotEly",t)
    = out_Energy("abs","Electricity Generation","TWh",ra,powa,t)
    / out_Energy("abs","Electricity Generation","TWh",ra,"TotEly",t);

$IfThenI.target %cal_NRG%=="TBU"
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
    = sum(a$(s_otra(a) or HYDROa(a)), out_Energy("abs","Electricity Generation","TWh",ra,a,t))
    / out_Energy("abs","Electricity Generation","TWh",ra,"TotEly",t);

*------------------------------------------------------------------------------*
*                           Energy demands (Mtoe)                              *
*------------------------------------------------------------------------------*

* Final Demands

out_Energy(abstype,"Energy Demand: Electricity","Mtoe",ra,fd,t)
    = sum(mapr(ra,r), sum(elyi, nrj_mtoe(r,elyi,fd,t)));
out_Energy(abstype,"Energy Demand: Gas","Mtoe",ra,fd,t)
    = sum(mapr(ra,r), sum(GASi, nrj_mtoe(r,GASi,fd,t)));
out_Energy(abstype,"Energy Demand: Coal","Mtoe",ra,fd,t)
    = sum(mapr(ra,r), sum(COAi, nrj_mtoe(r,COAi,fd,t)));
out_Energy(abstype,"Energy Demand: Oil","Mtoe",ra,fd,t)
    = sum(mapr(ra,r), sum(OILi,nrj_mtoe(r,OILi,fd,t)));

* Intermediate Demands

out_Energy(abstype,"Energy Demand: Electricity","Mtoe",ra,aga,t)
    = sum((r,a)$(mapr(ra,r) * mapaga(aga,a)),sum(elyi, nrj_mtoe(r,elyi,a,t)));
out_Energy(abstype,"Energy Demand: Gas","Mtoe",ra,aga,t)
    = sum((r,a)$(mapr(ra,r) * mapaga(aga,a)),sum(GASi, nrj_mtoe(r,GASi,a,t)));
out_Energy(abstype,"Energy Demand: Coal","Mtoe",ra,aga,t)
    = sum((r,a)$(mapr(ra,r) * mapaga(aga,a)),sum(COAi, nrj_mtoe(r,COAi,a,t)));
out_Energy(abstype,"Energy Demand: Oil","Mtoe",ra,aga,t)
    = sum((r,a)$(mapr(ra,r) * mapaga(aga,a)),sum(OILi,nrj_mtoe(r,OILi,a,t)));

* Total across energy carriers

out_Energy(abstype,"Energy Demand: Total","Mtoe",ra,aa,t)
    = sum(nrglist,out_Energy(abstype,nrglist,"Mtoe",ra,aa,t));

* Electricity sector grouped (e.g. "TotEly")

out_Energy(abstype,nrglist,"Mtoe",ra,"TotEly",t)
    = sum(elya,out_Energy(abstype,nrglist,"Mtoe",ra,elya,t));

* TPED manque "TPED: Total"
$onText
riswork(r,e) = 0;

riswork(r,i) $ e(i)
    = sum(a $ (NOT (elya(a) or fa(a) or Tota(a))), nrj_mtoe(r,e,a,%1))
    + sum(fd,nrj_mtoe(r,e,fd,%1))
    + sum(a $ (ROILa(a) or gdta(a) or etda(a)), nrj_mtoe(r,e,a,%1))
    + sum(fossilea,nrj_mtoe(r,e,fossilea,%1))
    + sum((e,powa), nrj_mtoe(r,e,powa,%1)) $ Elyi(i)
    + sum(a $ (s_rena(a) and powa(a)), rworka(a) * raagtwork(ra,a,%1))

* Moins les Outputs Energies secondaires allant dans TFC (gdti ?)

      - sum(i $ (ROILi(i) or ELYi(i)),
            sum(a $ (NOT (elya(a) or fa(a) or Tota(a))) ,nrj_mtoe(r,i,a,%1))
          + sum(fd, nrj_mtoe(r,i,fd,%1))  )
;

out_Energy(abstype,"TPED (calc TFC): Coal","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED (calc TFC): Oil","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED (calc TFC): Gas","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED (calc TFC): Hydro","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED (calc TFC): Nuclear","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED (calc TFC): Bioenergy","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED (calc TFC): Other renewables","Mtoe",ra,aga,t)

out_Energy(abstype,"TPED: Coal","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED: Oil","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED: Gas","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED: Hydro","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED: Nuclear","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED: Bioenergy","Mtoe",ra,aga,t)
out_Energy(abstype,"TPED: Other renewables","Mtoe",ra,aga,t)
$Offtext


* Energy Intensity

* tonnes of oil equivalent (toe) per thousand %YearBaseMER%
* US dollars of GDP, calculated using MER

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

$ENDIF.OutFull

* Total Energy intensity

out_Energy(abstype,"Energy intensity: Total","Mtoe",ra,aga,t)
    $ out_Gross_output(abstype,"real",ra,aga,t)
    = out_Energy(abstype,"Energy Demand: Total","Mtoe",ra,aga,t)
    / [0.001 * out_Gross_output(abstype,"real",ra,aga,t)];

* Fossil-Energy intensity

out_Energy(abstype,"Energy intensity: Fossil","Mtoe",ra,aga,t)
    $ out_Gross_output(abstype,"real",ra,aga,t)
    = [   out_Energy(abstype,"Energy Demand: Gas","Mtoe",ra,aga,t)
        + out_Energy(abstype,"Energy Demand: Oil","Mtoe",ra,aga,t)
        + out_Energy(abstype,"Energy Demand: Coal","Mtoe",ra,aga,t) ]
    / [0.001 * out_Gross_output(abstype,"real",ra,aga,t)];

* If I want primary / secondary energy: Total across demands : Pas TPES ici
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

* Ratio to %YearRef% and annual growth rate

$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Energy" "nrglist,'Mtoe',ra,aa"

* Intermediary and Final energy demands composition

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

$OnText
Already dans out_macro
out_Ratios(abstype,"Energy intensity","volume",ra,"Total",t)
    $ out_GDP(abstype,"Market Prices","real",ra,t)
    = out_Energy(abstype,"Energy Demand: Total","Mtoe",ra,"Total",t)
    / out_GDP(abstype,"Market Prices","real",ra,t);
$OffText

