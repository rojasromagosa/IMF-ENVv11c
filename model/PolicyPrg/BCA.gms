$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy
   name        : "%PolicyPrgDir%\BCA.gms"
   purpose     :  Implementation of Border Carbon Adjustement (BCA) Policies
   created date: 2021-06-21
   created by  : Jean Chateau
   called by   : - %ProjectDir%\%PolicyFile%.gms for %BCAStep%=="DeclareBCA"
                 - %ModelDir%\8-solve.gms        for %BCAStep%=="Solve"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/BCA.gms $
   last changed revision: $Rev: 326 $
   last changed date    : $Date:: 2023-06-12 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    WARNING: #TODO the case %BCA_revenue% == "Exporter" is not operational
             [TBU] no scalar or parameters should be declared for the "Save and Restart Mode"
    [2023-01-20] I removed some instructions relative to
        - Remove agriculture for coordination WP (%BaseName%=="CoordinationG20")
        - Remove cement for Mexico for %oDir%=="%DateSim%_Mexico"
--------------------------------------------------------------------------------
$offText

$Setargs BCAStep

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*               INSTRUCTIONS BEFORE THE TIME-LOOP                              *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.DeclareBCA %BCAStep%=="DeclareBCA"

*------------------------------------------------------------------------------*
*               BCA design: Declaration of Global Variable                     *
*------------------------------------------------------------------------------*
    $$OnText

        0.) BCA_policy = {ON,OFF(default)}

        1.) BCA_type: Type de la politique ajustement aux frontieres (4 choix)

            %BCA_type% = = {"NO"(default),"TARIFFS","FULLBCA","EXPORT"}

            - "NO"      : No BCA measures [DEFAULT]
            - "TARIFFS" : Tariff adjustments:
            - "EXPORT"  : Export subsidies  :
            - "FULLBCA" : Droits de Douanes & Taxe exportation:

        2.) BCA_sources: Sur quelles emissions/gas portent les BTA ?

            %BCA_sources% = {"CO2f"(default),"All","CO2"}

            - "CO2f": Co2 emissions from fossil fuel combustion [DEFAULT]
            - "CO2" : Co2 emissions
            - "All" : GHG emissions

        3.) BCA_EmiCoverage: Emission Coverage of BCA:

            %BCA_EmiCoverage% = {"DIRECT","INDIRECT"(default)}

            - "DIRECT"  : only direct emissions
            - "INDIRECT": include indirect emissions from Power [DEFAULT]

        4.) BCA_CarbonContent: Carbon content used to calculate BCA

            %BCA_CarbonContent% = {"Exporter","Domestic"(default)}

        - "Domestic": BC Tariffs implemented by a country r are calculated
        on the basis of domestic carbon content [DEFAULT]
        - "Exporter": BC Tariffs implemented by a country r are calculated
        on the basis of carbon content of the export countries rp

        5.) BCA_revenue: country receiving the fiscal revenues from Tariffs

            %BCA_revenue% = {"Exporter","Domestic"(default)}

        6.) BCA_Good : commodities on which BCA are implemented
            Value for the global variable BCA_Good should be a subset of "i"

            %BCA_Good% = {"EITEi"(default),"i","sBCAi",[any subset of i]}

        7.) BCA_cst : Carbon contents are fixed as from %YearPolicyStart%

            BCA_cst = {"YES","NO"(default)}

    $$OffText

    $$IF NOT SET BCA_type          $SetGlobal BCA_type          "NO"

* Default BCA design when activated :

    $$IF NOT SET BCA_sources       $SetGlobal BCA_sources       "CO2f"
    $$IF NOT SET BCA_EmiCoverage   $SetGlobal BCA_EmiCoverage   "INDIRECT"
    $$IF NOT SET BCA_revenue       $SetGlobal BCA_revenue       "Domestic"
    $$IF NOT SET BCA_CarbonContent $SetGlobal BCA_CarbonContent "Domestic"
    $$IF NOT SET BCA_Good          $SetGlobal BCA_Good          "EITEi"
    $$IF NOT SET BCA_cst           $SetGlobal BCA_cst           "NO"

	$$IF NOT SET NbCoalition       $SetGlobal NbCoalition       "3"

* Global variables just to check

    $$SetGlobal CheckBCA    "ON"

*------------------------------------------------------------------------------*
*       Assign values to BCA Flags according to the value of Global Variable   *
*------------------------------------------------------------------------------*

    SCALARS
        IfBCA_type 			"Set to 1 for tarrifs, 2 for full bca, 3 for export" 				     / 0 /
        IfBCA_sources 		"Set to 1 for CO2 fuel, 2 for CO2, 3 for All GHG"    				     / 1 /
        IfBCA_revenue 		"Set to 0 (1) to rebate carbon revenues to domestic (exporter)" 		 / 0 /
        IfBCA_EmiCoverage   "Set to 0 (1) for direct BCA (to include electricity)" 					 / 0 /
        IfBCA_CarbonContent "Set to 1 (0) for BCA based on domestic (exporter) carbon content" 		 / 1 /
        IfBCA_nonneg  		"Set to 0 (1) to (not) consider negative carbon tariff/Export Subsidies" / 1 /
        IfBCA_taxdiff 		"Set to 1 (0) for applying BCA on differential (absolute) Carbon Tax"    / 1 /
        IfBCA_cst 			"Set to 1 (0) for constant carbon content (%YearPolicyStart% levels)"    / 0 /
    ;

    $$IFi %BCA_type%=="NO"      IfBCA_type = 0 ;
    $$IFi %BCA_type%=="TARIFFS" IfBCA_type = 1 ;
    $$IFi %BCA_type%=="FULLBCA" IfBCA_type = 2 ;
    $$IFi %BCA_type%=="EXPORT"  IfBCA_type = 3 ;

    $$IFi %BCA_sources%=="CO2f" IfBCA_sources = 1 ;
    $$IFi %BCA_sources%=="CO2"  IfBCA_sources = 2 ;
    $$IFi %BCA_sources%=="All"  IfBCA_sources = 3 ;

    $$IFi %BCA_EmiCoverage%=="INDIRECT" IfBCA_EmiCoverage = 1 ;
    $$IFi %BCA_EmiCoverage%=="DIRECT"   IfBCA_EmiCoverage = 0 ;

    $$IFi %BCA_revenue%=="Exporter" IfBCA_revenue = 1;
    $$IFi %BCA_revenue%=="Domestic" IfBCA_revenue = 0;

    $$IFi %BCA_CarbonContent%=="Domestic" IfBCA_CarbonContent = 1 ;
    $$IFi %BCA_CarbonContent%=="Exporter" IfBCA_CarbonContent = 0 ;

    $$IFi %BCA_cst%=="YES" IfBCA_cst = 1 ;
    $$IFi %BCA_cst%=="NO"  IfBCA_cst = 0 ;

*------------------------------------------------------------------------------*
*                       BCA parameters (and options)                           *
*------------------------------------------------------------------------------*

    PARAMETERS
        BCAFlag(r,i)         "Flag to asses if a country will implement some BCA + precise the design"
        where_tariff(rp,r,i) "Matrix to define if Import by an acting country r from a non-acting country from origin rp includes a BCA on good i"
        where_export(r,rp,i) "Matrix to define if Export of a country of origin r to country to destination rp includes a BCA on good i"
        CTwedge(r,rp)        "Wedge between domestic and foreign Carbon Tax"

        $$IfTheni.CheckBCA %CheckBCA%=="ON"
            Tariff_diffBau(rp,r,i,t)  	"Changes in Tariffs (difference to BAU)"
            ExportSub_diffBau(r,rp,i,t) "Changes in Export Taxes (difference to BAU)"
            Emi_ante(r,i), Emi_post(r,i)
            Emi_DomEly(r), Emi_ShrEly(r,i), Emi_indEly(r,i)
        $$EndIf.CheckBCA

    ;

* Initialize to Zero BCA Policies

    where_tariff(rp,r,i) = 0 ;
    where_export(r,rp,i) = 0 ;

*------------------------------------------------------------------------------*
*            BCA Coverage (Default): function of IfBCA_type                    *
*------------------------------------------------------------------------------*

*   1.) Carbon-based Tariffs

    IF(IfBCA_type eq 1 or IfBCA_type eq 2,

$IfTheni.Coalition3 %NbCoalition%=="3"

* countries of Coalition 1 impose carbon tariffs on countries of Coalition 2

			LOOP( (r,rp) $ (mapr("Coalition1",r) and mapr("Coalition2",rp)),
				where_tariff(rp,r,i) = 1;
			) ;

* countries of Coalition 1 impose carbon tariffs on countries of Coalition 3

			LOOP( (r,rp) $ (mapr("Coalition1",r) and mapr("Coalition3",rp)),
				where_tariff(rp,r,i) = 1;
			) ;

* countries of Coalition 2 impose carbon tariffs on countries of Coalition 3

			LOOP( (r,rp) $ (mapr("Coalition2",r) and mapr("Coalition3",rp)),
				where_tariff(rp,r,i) = 1;
			) ;

$EndIf.Coalition3

		$$IfTheni.Coalition1 %NbCoalition%=="1"

*	Case Only One Coalition

			LOOP(rq $ (card(rq) eq 1),
				LOOP( r $ mapr(rq,r),
					LOOP(rp $ (NOT mapr(rq,rp)),
						where_tariff(rp,r,i) = 1;
					) ;
				) ;
			) ;

		$$EndIf.Coalition1

    ) ;

*   2.) Carbon-based export subsidies

    IF(IfBCA_type eq 2 or IfBCA_type eq 3,

$IfTheni.Coalition3 %NbCoalition%=="3"

* countries of Coalition 1 impose carbon subsidies on their export towards countries of Coalition 2

			LOOP( (r,rp) $ (mapr("Coalition1",r) and mapr("Coalition2",rp)),
			where_export(r,rp,i)  = 1;
			) ;

* countries of Coalition 1 impose carbon subsidies on their export towards countries of Coalition 3

			LOOP( (r,rp) $ (mapr("Coalition1",r) and mapr("Coalition3",rp)),
				where_export(r,rp,i)  = 1;
			) ;

* countries of group 2 impose carbon subsidies on their export towards countries of group 3

			LOOP( (r,rp) $ (mapr("Coalition2",r) and mapr("Coalition3",rp)),
				where_export(r,rp,i)  = 1;
			) ;
$EndIf.Coalition3

		$$IfTheni.Coalition1 %NbCoalition%=="1"

*	Case Only One Coalition

			LOOP(rq $ (card(rq) eq 1),
				LOOP( r $ mapr(rq,r),
					LOOP(rp $ (NOT mapr(rq,rp)),
						where_export(r,rp,i) = 1;
					) ;
				) ;
			) ;

		$$EndIf.Coalition1

    ) ;

*   Define here default BCA policies[IF ANY]

* These instruction below could be overwritte in the policy file before or
* in the Time-Loop actually this is useless

    LOOP(CO2,
        riswork2(r,a)
            = sum(e,
                sum(mapiEmi(e,EmiFosComb),
                    part(r,CO2,EmiFosComb,a,"%YearPolicyStart%")) );
    ) ;
    riswork2(r,a) $ riswork2(r,a) = 1 ;
    BCAFlag(r,%BCA_Good%) = sum( a $  gp(r,a,%BCA_Good%), riswork2(r,a) ) ;

$EndIf.DeclareBCA

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*    INSTRUCTIONS IN THE TIME-LOOP: read in %ModelDir%\8-solve.gms             *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.RunBCA %BCAStep%=="8-solve"

    $$OnDotl
    m_clearWork

*   Flag Activation if producer is taxed --> BCA on its produced goods

    riswork2(r,a) = sum( (em,EmiSourceAct), part(r,em,EmiSourceAct,a,tsim)) ;
    riswork2(r,a) $ riswork2(r,a) = 1;
    BCAFlag(r,%BCA_Good%) = sum(a $ (gp(r,a,%BCA_Good%) and riswork2(r,a)), 1) ;
    BCAFlag(r,%BCA_Good%)
        $ (     sum(rp,where_tariff(rp,r,%BCA_Good%)) eq 0
            and sum(rp,where_export(r,rp,%BCA_Good%)) eq 0) = 0 ;

*    DISPLAY "BCAFlag",  BCAFlag ;
*    DISPLAY "BCA_Good: %BCA_Good%" ;

*   Compute sectoral emissions (--> riswork)

* [TBC] doit-on (ou pas) considerer part() devant ces expressions ?

    LOOP(CO2,

*   Case: CO2 emissions from fuel combustion

        riswork(r,a) $ (xpFlag(r,a) and IfBCA_sources eq 1)
            = { sum(mapiEmi(i,EmiFosComb), m_true4(emi,r,CO2,EmiFosComb,a,tsim)) }$ {IfBCA_cst eq 0}
            + { sum(mapiEmi(i,EmiFosComb), m_true4(emi,r,CO2,EmiFosComb,a,"%YearPolicyStart%")) }$ {IfBCA_cst eq 1}
            ;

*   Case: all CO2 emissions

        riswork(r,a) $ (xpFlag(r,a) and IfBCA_sources eq 2)
* CO2: sources of emissions from input uses
            = sum(mapiEmi(i,EmiUse), m_true4(emi,r,CO2,EmiUse,a,tsim) ) $ {IfBCA_cst eq 0}
            + sum(mapiEmi(i,EmiUse), m_true4(emi,r,CO2,EmiUse,a,"%YearPolicyStart%") ) $ {IfBCA_cst eq 1}
* CO2: adding sources of emissions from factor uses
            + sum(EmiFp,  m_true4(emi,r,CO2,EmiFp,a,tsim)  ) $ {IfBCA_cst eq 0}
            + sum(EmiFp,  m_true4(emi,r,CO2,EmiFp,a,"%YearPolicyStart%")  ) $ {IfBCA_cst eq 1}
* CO2: adding sources of emissions from process emissions
            + sum(emiact, m_true4(emi,r,CO2,emiact,a,tsim) ) $ {IfBCA_cst eq 0}
            + sum(emiact, m_true4(emi,r,CO2,emiact,a,"%YearPolicyStart%") ) $ {IfBCA_cst eq 1}
            ;
    ) ;

*   Case: all GHGs emissions

    riswork(r,a) $ (xpFlag(r,a) and IfBCA_sources eq 3)
* GHG: sources of emissions from input uses
        = sum((em,i,EmiUse),mapiEmi(i,EmiUse)*m_true4(emi,r,em,EmiUse,a,tsim)) $ {IfBCA_cst eq 0}
        + sum((em,i,EmiUse),mapiEmi(i,EmiUse)*m_true4(emi,r,em,EmiUse,a,"%YearPolicyStart%")) $ {IfBCA_cst eq 1}
* GHG: adding sources of emissions from factor uses
        + sum((em,EmiFp),  m_true4(emi,r,em,EmiFp,a,tsim)) $ {IfBCA_cst eq 0}
        + sum((em,EmiFp),  m_true4(emi,r,em,EmiFp,a,"%YearPolicyStart%")) $ {IfBCA_cst eq 1}
* GHG: adding sources of emissions from process emissions
        + sum((em,emiact), m_true4(emi,r,em,emiact,a,tsim)) $ {IfBCA_cst eq 0}
        + sum((em,emiact), m_true4(emi,r,em,emiact,a,"%YearPolicyStart%")) $ {IfBCA_cst eq 1}
        ;

* Electricity emissions

    riswork(r,"TotEly") = sum(elya, riswork(r,elya));

* Assign sectoral emission to commodity

    riswork(r,i) = sum(a $ gp(r,a,i), riswork(r,a)) ;
    riswork(r,a) = 0 ;

* Case where BCA are only for some "%BCA_Good%" commodities

    $$IFTheni.NotAllGood NOT %BCA_Good%=="i"

        BCAFlag(r,i)         $ (not %BCA_Good%(i)) = 0 ;
        where_tariff(rp,r,i) $ (not %BCA_Good%(i)) = 0 ;
        where_export(r,rp,i) $ (not %BCA_Good%(i)) = 0 ;

    $$Endif.NotAllGood

* When no BTA then do nothing

    IF(IfBCA_type eq 0, BCAFlag(r,i) = 0 ; ) ;

*   Add Indirect Emissions from Electricity (IfBCA_EmiCoverage eq 1)

* [TBU]: only case $ {NOT IfArmFlag}

    IF(IfBCA_EmiCoverage,

        $$Ifi %CheckBCA%=="ON" Emi_ante(r,i) $ BCAFlag(r,i) = riswork(r,i) / cScale;

        LOOP(elyi,
            riswork(r,i) $ (riswork(r,i) and not elyi(i))
                = riswork(r,i)

* Electricity emissions

                + riswork(r,elyi)

* share of domestic consumption of electricity in total domestic production
* [TBU] : add imported electricity ?

                * [m_true2(xdt,r,elyi,tsim) * pdt0(r,elyi)
                        / (m_true2(xs,r,elyi,tsim) * ps0(r,elyi) )]

* share of demand for electricity by sector i in total demand

                * [sum(a $ gp(r,a,i), m_true3t(xa,r,elyi,a,tsim) * pa0(r,elyi,a))
                      / ( m_true2t(xat,r,elyi,tsim) * pat0(r,elyi) ) ]
                ;

* Check [option]

            $$IfTheni.CheckBCA %CheckBCA%=="ON"
                Emi_DomEly(r)
                    = m_true2(xdt,r,elyi,tsim) * pdt0(r,elyi)
                    / (m_true2(xs,r,elyi,tsim) * ps0(r,elyi)) ;
                Emi_ShrEly(r,i)
                    = sum(a$gp(r,a,i), m_true3t(xa,r,elyi,a,tsim) * pa0(r,elyi,a))
                    / ( m_true2t(xat,r,elyi,tsim) * pat0(r,elyi)) ;
                Emi_indEly(r,i)
                    = riswork(r,elyi) * Emi_DomEly(r) * Emi_ShrEly(r,i) ;
            $$EndIf.CheckBCA

        ) ;

* Check [option]

        $$IfTheni.CheckBCA %CheckBCA%=="ON"
            Emi_post(r,i) $ BCAFlag(r,i) = riswork(r,i) / cScale ;
            EXECUTE_UNLOAD "%cfile%_Check_SectoralEmi_ForBCA.gdx",
                Emi_ante, Emi_post, Emi_DomEly, Emi_ShrEly, Emi_indEly;
        $$EndIf.CheckBCA

    ) ;

* Emission intensities used for BCA computations

    riswork(r,i) $ (riswork(r,i) and xsFlag(r,i))
        = riswork(r,i) / m_true2(xs,r,i,tsim);

* Wedge in carbon tax across countries (default: IfBCA_taxdiff eq 1)
*   or alternative only domestic Carbon tax (IfBCA_taxdiff eq 0)
* #TODO here only CO2

    LOOP(CO2,
        CTwedge(r,rp)
            = emiTax.l(r,CO2,tsim) - emiTax.l(rp,CO2,tsim) * IfBCA_taxdiff ;
    ) ;

* Do not consider negative/subsidies tariff IfBCA_nonneg

    CTwedge(r,rp) $(IfBCA_nonneg and CTwedge(r,rp) lt 0) = 0;

* Safety instruction

    CTwedge(r,rp) $ (year lt %YearPolicyStart%) = 0 ;

*   Apply Carbon-based export subsidies for country r (based on domestic carbon content)

    etax.fx(r,i,rp,tsim)
        $ (    where_export(r,rp,i) and BCAFlag(r,i)
           and (IfBCA_type eq 2 or IfBCA_type eq 3) )
        = etax0(r,i,rp)  - riswork(r,i) * CTwedge(r,rp)   ;

*   Apply Border Carbon Tariffs on source defined in where_tariff(r,rp,pi)

    $$OnText
        For cases where BCA calculated on the basis of non-acting carbon
        content (IfBCA_CarbonContent eq  0):
        put non-acting carbon content only if higher than domestic,
        else put the domestic carbon content
    $$OffText

* Remove electricity in the all good cases where indirect emission from ely
* already accounted

    $$IFi %BCA_Good%=="i" IF(IfBCA_EmiCoverage, BCAFlag(r,elyi) = 0 ; );

***HRR added cbamSh
    mtax.fx(rp,i,r,tsim)
        $ (    where_tariff(rp,r,i) and BCAFlag(r,i)
           and (IfBCA_type eq 1 or IfBCA_type eq 2) )
        = cbamSh(rp,i,r) * ( mtax0(rp,i,r)
        + [  Max( riswork(rp,i),
                  riswork(r,i)) * (1 - IfBCA_CarbonContent)
                + riswork(r,i)  * IfBCA_CarbonContent
          ] * CTwedge(r,rp) ) ;

*   Check the policy [Option]

    $$IfTheni.CheckBCA %CheckBCA%=="ON"
        Tariff_diffBau(rp,r,i,tsim) $ (BCAFlag(r,i) and IfBCA_type ne 3)
            = mtax.l(rp,i,r,tsim) - mtax0(rp,i,r) ;
        ExportSub_diffBau(r,rp,i,tsim) $ (BCAFlag(r,i) and IfBCA_type gt 1)
            = etax.l(r,i,rp,tsim) - etax0(r,i,rp) ;
    $$EndIf.CheckBCA

    $$Offdotl

*   Run Model again

    IF(IfBCA_type and years(tsim) ge %YearPolicyStart%,
        put screen // "Re-run with BCA: ", years(tsim):4:0 //; putclose screen;
        $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%
    ) ;

*   Check BCA policy implemented [Option]

    IF(1 and year eq %YearPolicyStart%,
        Execute_unload "%cfile%_BCA_Design_%YearPolicyStart%.gdx",
            IfBCA_type, IfBCA_nonneg, IfBCA_EmiCoverage, riswork,
            IfBCA_CarbonContent, IfBCA_taxdiff,
            $$Ifi %CheckBCA%=="ON" Tariff_diffBau, ExportSub_diffBau,
            BCAFlag, where_tariff, where_export, CTwedge ;
    ) ;

    IF(1 and year eq %EndTimeLoop%,
        Execute_unload "%cfile%_BCA_Design_%EndTimeLoop%.gdx",
            IfBCA_type, IfBCA_nonneg, IfBCA_EmiCoverage, riswork,
            IfBCA_CarbonContent, IfBCA_taxdiff,
            $$Ifi %CheckBCA%=="ON" Tariff_diffBau, ExportSub_diffBau,
            BCAFlag, where_tariff, where_export, CTwedge ;
    ) ;

$Endif.RunBCA

