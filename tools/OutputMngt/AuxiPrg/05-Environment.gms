$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
   Name of the File: "%AuxPrgDir%\05-Environment.gms"
   purpose: Fill the variable out_Environment(typevar,envlist,envunits,ra,agents,t)
            "Environmental variables" (incl. Emissions)
    created date: 2021-03-18
    created by  : Jean Chateau
    called by   : %OutMngtDir%\OutAuxi.gms

    Memo: Express GHGs emissions in Million tonnes of CO2 equivalent using GWP-100
          Express OAP  emissions in Thousands tonnes

    All variables are conditioned to existence of out_GDP("Market Prices")
    Limit this to working years between3(t,"%YearStart%","%YearEndofSim%")
    will reduce size of output to consistent numbers
--------------------------------------------------------------------------------
$OffText

out_Environment(abstype,"Emission LULUCF","CO2 (Mt CO2eq)",ra,"Total",t)
    =  sum((r,co2,a,emilulucf) $ mapr(ra,r), m_true4(emi,r,co2,emilulucf,a,t))
    / cscale;

* Firms GHGs Emissions from Combustion

out_Environment(abstype,"Emission from fossil fuel combustion",ghgunits,ra,aga,t)
    = sum((r,a,EmiComb,em)$(mapr(ra,r) and mapaga(aga,a) and map_emi(em,ghgunits)),
        m_true4(emi,r,em,EmiComb,a,t))
    / cscale;
out_Environment(abstype,"Emission from coal combustion",ghgunits,ra,aga,t)
    = sum((r,a,em)$(mapr(ra,r) and mapaga(aga,a) and map_emi(em,ghgunits)),m_true4(emi,r,em,"coalcomb",a,t))
    / cscale;
out_Environment(abstype,"Emission from oil combustion",ghgunits,ra,aga,t)
    = sum((r,a,em)$(mapr(ra,r) and mapaga(aga,a) and map_emi(em,ghgunits)),m_true4(emi,r,em,"coilcomb",a,t) + m_true4(emi,r,em,"roilcomb",a,t))
    / cscale;
out_Environment(abstype,"Emission from gas combustion",ghgunits,ra,aga,t)
    = sum((r,a,em)$(mapr(ra,r) and mapaga(aga,a) and map_emi(em,ghgunits)),m_true4(emi,r,em,"gascomb",a,t)+m_true4(emi,r,em,"gdtcomb",a,t))
    / cscale;
out_Environment(abstype,"Emission from biomass combustion",ghgunits,ra,aga,t)
    = sum((r,a,em)$(mapr(ra,r) and mapaga(aga,a) and map_emi(em,ghgunits)),m_true4(emi,r,em,"biofcomb",a,t))
    / cscale;

* Firms GHGs Emissions from activity
* process emission + factor-based emissions + emissions assocoiated to chemical use

out_Environment(abstype,"Emission from activity",ghgunits,ra,aga,t)
    = sum((r,a,em)$(mapr(ra,r) and mapaga(aga,a) and map_emi(em,ghgunits)),
          sum(EmiFp,  m_true4(emi,r,em,EmiFp,a,t))
        + sum(chemUse,m_true4(emi,r,em,chemUse,a,t))
        + sum(emiact, m_true4(emi,r,em,emiact,a,t))
         ) / cscale;

* GHG Emissions from Final Demands (fd)

out_Environment(abstype,"Emission from fossil fuel combustion",ghgunits,ra,fd,t)
    = sum((r,EmiComb,em)$(mapr(ra,r) and map_emi(em,ghgunits)),m_true4(emi,r,em,EmiComb,fd,t))/cscale;
out_Environment(abstype,"Emission from coal combustion",ghgunits,ra,fd,t)
    = sum((r,em)$(mapr(ra,r) and map_emi(em,ghgunits)),m_true4(emi,r,em,"coalcomb",fd,t))/cscale;
out_Environment(abstype,"Emission from oil combustion",ghgunits,ra,fd,t)
    = sum((r,em)$(mapr(ra,r) and map_emi(em,ghgunits)),m_true4(emi,r,em,"coilcomb",fd,t)+m_true4(emi,r,em,"roilcomb",fd,t))/cscale;
out_Environment(abstype,"Emission from gas combustion",ghgunits,ra,fd,t)
    = sum((r,em)$(mapr(ra,r) and map_emi(em,ghgunits)),m_true4(emi,r,em,"gascomb",fd,t)+m_true4(emi,r,em,"gdtcomb",fd,t))/cscale;
out_Environment(abstype,"Emission from biomass combustion",ghgunits,ra,fd,t)
    = sum((r,em)$(mapr(ra,r) and map_emi(em,ghgunits)),m_true4(emi,r,em,"biofcomb",fd,t))/cscale;

out_Environment(abstype,"Emission from activity",ghgunits,ra,fd,t)
    = sum((r,em)$(mapr(ra,r) and map_emi(em,ghgunits)),
          sum(EmiFp,  m_true4(emi,r,em,EmiFp,fd,t))
        + sum(chemUse,m_true4(emi,r,em,chemUse,fd,t))
        + sum(emiact, m_true4(emi,r,em,emiact,fd,t))
         ) / cscale;

*---    Total across Sources, by GHGs and by sector/agent (excl. LULUCF)

* Firms

out_Environment(abstype,"Emission all sources",ghgunits,ra,aga,t)
    = sum(ghglist,out_Environment(abstype,ghglist,ghgunits,ra,aga,t));

* Final Demands
out_Environment(abstype,"Emission all sources",ghgunits,ra,fd,t)
    = sum(ghglist,out_Environment(abstype,ghglist,ghgunits,ra,fd,t));

* Total across sector/agent (e.g. "Total"), by GHGs and by sources
out_Environment(abstype,ghgsource,ghgunits,ra,"Total",t)
    =  out_Environment(abstype,ghgsource,ghgunits,ra,"ttot-a",t)
    +  sum(fd,out_Environment(abstype,ghgsource,ghgunits,ra,fd,t));

*---    Total Emission incl. LULUCF

out_Environment(abstype,"Emission all sources (incl. CO2 LULUCF)","GHG (Mt CO2eq)",ra,"Total",t)
    =  sum(allghgs,out_Environment(abstype,"Emission all sources",allghgs,ra,"Total",t))
    +  out_Environment(abstype,"Emission LULUCF","CO2 (Mt CO2eq)",ra,"Total",t);

*---    Firms GHGs Emissions from other sources [details]

out_Environment(abstype,"Emission from enteric fermentation (4A)",ghgunits,ra,aga,t)
    = sum((r,lva,em)$(mapr(ra,r) and mapaga(aga,lva) and map_emi(em,ghgunits)),
          m_true4(emi,r,em,"Capital",lva,t)) / cscale;
out_Environment(abstype,"Emission from manure management (4B)",ghgunits,ra,aga,t)
    = sum((r,lva,em)$(mapr(ra,r) and mapaga(aga,lva) and map_emi(em,ghgunits)),
          sum(emiact,m_true4(emi,r,em,emiact,lva,t))) / cscale;
out_Environment(abstype,"Emission from nitrification (4D1)",ghgunits,ra,aga,t)
    = sum((r,cra,em,chemUse)$(mapr(ra,r) and mapaga(aga,cra) and map_emi(em,ghgunits)),
          m_true4(emi,r,em,chemUse,cra,t)) / cscale;

$IfThen.RiceIsolated SET PDR_name
    out_Environment(abstype,"Emission from rice cultivation (4C)",ghgunits,ra,aga,t)
        = sum((r,em)$(mapr(ra,r) and mapaga(aga,"%PDR_name%-a") and map_emi(em,ghgunits)),
            sum(emiact,m_true4(emi,r,em,emiact,"%PDR_name%-a",t))) / cscale;
$EndIf.RiceIsolated

out_Environment(abstype,"Emission from other crops practice",ghgunits,ra,aga,t)
    = sum((r,cra,em)$(mapr(ra,r) and mapaga(aga,cra) and map_emi(em,ghgunits)),
            sum(emiact,m_true4(emi,r,em,emiact,cra,t))) / cscale
    - out_Environment(abstype,"Emission from rice cultivation (4C)",ghgunits,ra,aga,t)
    + sum((r,cra,em)$(mapr(ra,r) and mapaga(aga,cra) and map_emi(em,ghgunits)),
           m_true4(emi,r,em,"Land",cra,t)) / cscale;

*---    gdt ???
out_Environment(abstype,"Fuel Combustion from Electricity and Heat Production (1A1a)",ghgunits,ra,aga,t)
    = sum((r,elya,em)$(mapr(ra,r) and mapaga(aga,elya) and map_emi(em,ghgunits)),
            sum(EmiComb,m_true4(emi,r,em,EmiComb,elya,t))) / cscale;
out_Environment(abstype,"Fuel Combustion from Other Energy Industries (1A1bc)",ghgunits,ra,aga,t)
    = sum((r,ROILa,em,EmiComb)$(mapr(ra,r) and mapaga(aga,ROILa) and map_emi(em,ghgunits)),
            m_true4(emi,r,em,EmiComb,ROILa,t)) / cscale;
*---    gdt ???
out_Environment(abstype,"Fugitive emissions from fossil fuel (1B)",ghgunits,ra,aga,t)
    = sum((r,fossilea,em)$(mapr(ra,r) and mapaga(aga,fossilea) and map_emi(em,ghgunits)),
            sum(emiact,m_true4(emi,r,em,emiact,fossilea,t))) / cscale;
out_Environment(abstype,"Nonmetallic minerals production (2A)",ghgunits,ra,aga,t)
    = sum((r,cementa,em,emiact)$(mapr(ra,r) and mapaga(aga,cementa) and map_emi(em,ghgunits)),
            m_true4(emi,r,em,emiact,cementa,t)) / cscale;

*------------------------------------------------------------------------------*
*           Emissions of air pollutants                                        *
*------------------------------------------------------------------------------*

* air pollutants from fossil fuel combustion

out_Environment(abstype,"Air pollutants from fossil fuel combustion",oapunits,ra,aga,t)
    = sum((r,a,EmiComb,oap)$(mapr(ra,r) and map_oap(oap,oapunits) and mapaga(aga,a) and not tota(a)),m_true4(emi,r,oap,EmiComb,a,t))/apscale;
out_Environment(abstype,"Air pollutants from coal combustion",oapunits,ra,aga,t)
    = sum((r,a,oap)$(mapr(ra,r) and map_oap(oap,oapunits) and mapaga(aga,a) and not tota(a)),m_true4(emi,r,oap,"coalcomb",a,t))/apscale;
out_Environment(abstype,"Air pollutants from oil combustion",oapunits,ra,aga,t)
    = sum((r,a,oap)$(mapr(ra,r) and map_oap(oap,oapunits) and mapaga(aga,a) and not tota(a)),m_true4(emi,r,oap,"coilcomb",a,t) * m_true4(emi,r,oap,"roilcomb",a,t))/apscale;
out_Environment(abstype,"Air pollutants from gas combustion",oapunits,ra,aga,t)
    = sum((r,a,oap)$(mapr(ra,r) and map_oap(oap,oapunits) and mapaga(aga,a) and not tota(a)),m_true4(emi,r,oap,"gascomb",a,t) * m_true4(emi,r,oap,"gdtcomb",a,t))/apscale;
out_Environment(abstype,"Air pollutants from biomass combustion",oapunits,ra,aga,t)
    = sum((r,a,oap)$(mapr(ra,r) and map_oap(oap,oapunits) and mapaga(aga,a) and not tota(a)),m_true4(emi,r,oap,"biofcomb",a,t))/apscale;

* air pollutants Firms from other sources than fossil-fuel combustion

out_Environment(abstype,"Air pollutants from activity",oapunits,ra,aga,t)
    = sum((r,a,oap)
        $(mapr(ra,r) and map_oap(oap,oapunits) and mapaga(aga,a) and not tota(a)),
          sum(EmiFp,   m_true4(emi,r,oap,EmiFp,a,t))
        + sum(chemUse, m_true4(emi,r,oap,chemUse,a,t))
        + sum(emiact,  m_true4(emi,r,oap,emiact,a,t))
         ) / apscale;

*---    from Final Demands (fd) (Combustion only [TBU] if other sources)

out_Environment(abstype,"Air pollutants from fossil fuel combustion",oapunits,ra,fd,t)
    = sum((r,EmiComb,oap)$(mapr(ra,r) and map_oap(oap,oapunits)),m_true4(emi,r,oap,EmiComb,fd,t))/apscale;
out_Environment(abstype,"Air pollutants from coal combustion",oapunits,ra,fd,t)
    = sum((r,oap)$(mapr(ra,r) and map_oap(oap,oapunits)),m_true4(emi,r,oap,"coalcomb",fd,t))/apscale;
out_Environment(abstype,"Air pollutants from oil combustion",oapunits,ra,fd,t)
    = sum((r,oap)$(mapr(ra,r) and map_oap(oap,oapunits)),m_true4(emi,r,oap,"coilcomb",fd,t)+m_true4(emi,r,oap,"roilcomb",fd,t))/apscale;
out_Environment(abstype,"Air pollutants from gas combustion",oapunits,ra,fd,t)
    = sum((r,oap)$(mapr(ra,r) and map_oap(oap,oapunits)),m_true4(emi,r,oap,"gascomb",fd,t) * m_true4(emi,r,oap,"gdtcomb",fd,t))/apscale;
out_Environment(abstype,"Air pollutants from biomass combustion",oapunits,ra,fd,t)
    = sum((r,oap)$(mapr(ra,r) and map_oap(oap,oapunits)),m_true4(emi,r,oap,"biofcomb",fd,t))/apscale;

out_Environment(abstype,"Air pollutants from activity",oapunits,ra,fd,t)
    = sum((r,oap)$(mapr(ra,r) and map_oap(oap,oapunits)),
          sum(EmiFp,   m_true4(emi,r,oap,EmiFp,fd,t))
        + sum(chemUse, m_true4(emi,r,oap,chemUse,fd,t))
        + sum(emiact,  m_true4(emi,r,oap,emiact,fd,t))
         ) / apscale;

out_Environment(abstype,"Air pollutants all sources",oapunits,ra,aga,t)
    = sum(oaplist,out_Environment(abstype,oaplist,oapunits,ra,aga,t));
out_Environment(abstype,"Air pollutants all sources",oapunits,ra,fd,t)
    = sum(oaplist,out_Environment(abstype,oaplist,oapunits,ra,fd,t));
out_Environment(abstype,oapsource,oapunits,ra,"Total",t)
    =  out_Environment(abstype,oapsource,oapunits,ra,"ttot-a",t)
    +  sum(fd,out_Environment(abstype,oapsource,oapunits,ra,fd,t));

*------------------------------------------------------------------------------*
*                           Ratios                                             *
*------------------------------------------------------------------------------*

*---    Total GHGs per capita (Kilograms per capita, Thousands), by source
* now multiply by 0,000001 --> tons per capita

out_Environment(abstype,ghglist,"(metric tons per capita)",ra,"Total",t)
    $ sum(r$mapr(ra,r), m_true1(POP,r,t))
    =  0.000001
    * sum(allghgs, out_Environment(abstype,ghglist,allghgs,ra,"Total",t))
    / sum(mapr(ra,r), m_true1(POP,r,t));

$IfThenI.OutFull %aux_outType%=="FULL"
    out_Environment(abstype,"Emission intensity: all sources",ghgunits,ra,aga,t)
        $ out_Gross_output(abstype,"real",ra,aga,t)
        = out_Environment(abstype,"Emission all sources",ghgunits,ra,aga,t)
        / [cscale * out_Gross_output(abstype,"real",ra,aga,t)];
$ENDIF.OutFull

*---    Total GHG per unit of GDP (Kilograms %YearBaseMER% USD of GDP, Thousands)
* Or Kilograms per 1 000 US dollars, Thousands

out_Environment(abstype,"Emission all sources","(kg per %YearBasePPP% PPP of GDP)",ra,"Total",t)
    $ out_GDP(abstype,"PPP","real",ra,t)
    = sum(allghgs,out_Environment(abstype,"Emission all sources",allghgs,ra,"Total",t)/cscale)
    / out_GDP(abstype,"PPP","real",ra,t);

out_Environment(abstype,"Emission all sources","(kg per %YearBaseMER% USD of GDP)",ra,"Total",t)
    $ out_GDP(abstype,"Market Prices","real",ra,t)
    = sum(allghgs,out_Environment(abstype,"Emission all sources",allghgs,ra,"Total",t)/cscale)
    / out_GDP(abstype,"Market Prices","real",ra,t);

*---    Ratio to %YearRef% and annual growth rate (for more info put "ghgsource")
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Environment" "ghglist,envunits,ra,'Total'"

*---    Sectoral and Final Demand composition
$IfThenI.OutFull %aux_outType%=="FULL"
    out_Environment("pct", ghgsource,ghgunits,ra,aa,t)
        $ out_Environment("abs",ghgsource,ghgunits,ra,"Total",t)
        = out_Environment("abs",ghgsource,ghgunits,ra,aa,t)
        / out_Environment("abs",ghgsource,ghgunits,ra,"Total",t);
$ENDIF.OutFull


* [TBU] with tax on other GHGs - plus aggregation does not work
* Here inactive emissions not taken into account

*--- Revoir
$OnText
out_Environment(abstype,"Carbon Tax","(%YearBaseMER% USD, per tCO2)",ra,aa,t)
    $ sum((r,EmiComb)$mapr(ra,r), part(r,"co2",EmiComb,aa,t) * m_true4(emi,r,"co2",EmiComb,aa,t))
    = (1/cscale)
    * sum((r,EmiComb)$mapr(ra,r), [part(r,"co2",EmiComb,aa,t) * emiTax.l(r,"co2",aa,t) + p_emissions(r,"co2",EmiComb,aa,t)] * m_true(emi(r,"co2",EmiComb,aa,t)))
    / sum((r,EmiComb)$mapr(ra,r), m_true4(emi,r,"co2",EmiComb,aa,t));

out_Environment(abstype,"Carbon Tax","(%YearBaseMER% USD, per tCO2)",ra,"Total",t)
    $ sum((r,EmiComb,aa)$mapr(ra,r), m_true4(emi,r,"co2",EmiComb,aa,t)))
    = (1/cscale)
    * sum((r,EmiComb,aa)$mapr(ra,r), [part(r,"co2",EmiComb,aa,t) * emiTax.l(r,"co2",aa,t) + p_emissions(r,"co2",EmiComb,aa,t)] * m_true(emi(r,"co2",EmiComb,aa,t)))
    / sum((r,EmiComb,aa)$mapr(ra,r), m_true4(emi,r,"co2",EmiComb,aa,t));
$OffText
