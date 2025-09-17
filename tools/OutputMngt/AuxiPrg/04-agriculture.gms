$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
   Name of the File: "%AuxPrgDir%\04-agriculture.gms"
    purpose     : Fill the variable "out_Agriculture"
                  out_Agriculture(typevar,aglist,units,ra,agents,t)
   created date : 2021-10-28
   created by   : Jean Chateau
    called by   : %OutMngtDir\OutAuxi.gms
--------------------------------------------------------------------------------
$OffText

* land_haT(r,a,t)  "Land Use (1000 ha): Harvest_Area" change to envlist("abs","Area harvested","(1000 ha)",r,is,t)
* Est-ce pas plutot x?
out_Agriculture(abstype,"Land yields","real",ra,agr,t)
    $ sum(r$mapr(ra,r),m_true2(land,r,agr,t))
    = sum(r$mapr(ra,r),XPT(r,agr,t)) / sum(r$mapr(ra,r),m_true2(land,r,agr,t)) ;

* Ratio to %YearRef% and annual growth rate

    $$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Agriculture" "'Land yields',units,ra,a"

$IfThen.exoyield %UseIMPACT%=="ON"

* [ruben] this does NOT work with expost - issue : IMPACT%YearGTAP% is not defined
* [TBU]
    $$IfTheni.CalMode %cal_AGR%=="ON"

* Surface (1000 ha)

        out_Agriculture(abstype,"Area harvested",volume,ra,agr,t)
            $ sum(r $ sameas(ra,r),sum(t0,m_true2(land,r,agr,t0)))
            = sum(r $ sameas(ra,r),IMPACT%YearGTAP%("AREA",agr,r))
            * sum(r $ sameas(ra,r),m_true2(land,r,agr,t))
            / sum(r $ sameas(ra,r),sum(t0,m_true2(land,r,agr,t0))));

* [TBC]: je ne comprends pas ce qu'on fait -->
        out_Agriculture(abstype,"Area harvested",volume,ra,agr,t)
            = sum(mapr(ra,r), sum(ra.local$sameas(ra,r), out_Agriculture(abstype,"Area harvested",volume,ra,agr,t)));

* Output in volume (000 mt)

        out_Agriculture(abstype,"Gross output",volume,ra,a,t)
            $ sum((r,t0)$mapr(ra,r),xpT(r,a,t0))
            = sum(r$mapr(ra,r),IMPACT%YearGTAP%("PRODUCTION",a,r) * xpT(r,a,t))
            / sum((r,t0)$mapr(ra,r),xpT(r,a,t0));

    $$ENDIF.CalMode

* metric tonnes per hectare

    out_Agriculture(abstype,"Land yields",volume,ra,agr,t)
        $ out_Agriculture(abstype,"Area harvested",volume,ra,agr,t)
        = out_Gross_output(abstype,volume,ra,ag,t)
        / out_Agriculture(abstype,"Area harvested",volume,ra,agr,t);

* Ratio to %YearRef% and annual growth rate

    $$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Agriculture" "'Area harvested','volume',ra,agr"

    $$IfTheni.CalMode %cal_AGR%=="ON"

        out_Agriculture("target","Gross output",volume,ra,ag,t)
            $ sum(r$mapr(ra,r),IMPACT%YearGTAP%("PRODUCTION",ag,r))
            = sum(r$mapr(ra,r),IMPACT("PRODUCTION","%bau_impact%",ag,r,t));

        out_Agriculture("target","Area harvested",volume,ra,ag,t)
            = sum(r$mapr(ra,r),IMPACT("AREA","%bau_impact%",ag,r,t));

        out_Agriculture("target","Land yields",volume,ra,ag,t)
            $ out_Agriculture("target","Area harvested",volume,ra,ag,t)
            = out_Gross_output("target",volume,ra,ag,t)
            / out_Agriculture("target","Area harvested",volume,ra,ag,t);

*   $$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Ratios" "'IMPACT_yields',units,r,a"

* Warning not for c_b because sgr
- By convenience calculate this as % of first year

        out_Prices("target","World (CIF)","World",agi,"Total",t)
            $ sum((t0,ag,rres)$ tmat(ag,agi,rres), IMPACT_World_Prices("%bau_impact%",ag,t0))
            = sum((ag,rres)   $ tmat(ag,agi,rres), IMPACT_World_Prices("%bau_impact%",ag,t))
            / sum((t0,ag,rres)$ tmat(ag,agi,rres), IMPACT_World_Prices("%bau_impact%",ag,t0));


    $$ENDIF.CalMode

$ENDIF.exoyield
