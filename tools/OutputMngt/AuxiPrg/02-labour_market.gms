$OnText
--------------------------------------------------------------------------------
                    [OECD-ENV] Model V.1. - Reporting procedure
    GAMS file   : "%AuxPrgDir%\02-Labour_market.gms"
    purpose     : Fill out_Labour Market variable
                  out_Labour(typevar,labourlist,units,ra,skills,agents,t)
    created date: 2021-03-18
    created by  : Jean Chateau
    called by   : %OutMngtDir\OutAuxi.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/AuxiPrg/02-labour_market.gms $
   last changed revision: $Rev: 326 $
   last changed date    : $Date:: 2023-06-12 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$setlocal step_Labmodule "%1"

$IfThenI.Base %step_Labmodule%=="base"

    out_Labour(abstype,"Employment",volume,ra,l,"ttot-a",t)
        = sum((r,z) $ mapr(ra,r),  m_ETPT(r,l,z,t)) / popScale ;

    out_Labour(abstype,"Employment","real",ra,l,aga,t)
        $ out_Gross_output(abstype,"real",ra,aga,t)
        = OutScale * sum((r,a) $ (mapr(ra,r) and mapaga(aga,a)),
            To%YearBaseMER%MER(r) * m_true3t(ld,r,l,a,t));

    LOOP(l,

* Coefficient for employment from real to volume

		rworkT(r,t) = 0 ;
		rworkT(r,t) $ sum(a, m_true3t(ld,r,l,a,t))
			= sum(z, m_ETPT(r,l,z,t) / popScale )
			/ sum(a, To%YearBaseMER%MER(r) * m_true3t(ld,r,l,a,t)) ;

		out_Labour(abstype,"Employment",volume,ra,l,aga,t)
			$ out_Gross_output(abstype,"real",ra,aga,t)
			= sum((r,a) $ (mapr(ra,r) and mapaga(aga,a)),
				rworkT(r,t) * To%YearBaseMER%MER(r) * m_true3t(ld,r,l,a,t)) ;
	) ;

*	Job markets flows [TBC]

    out_Labour(abstype,"Job creations",volume,ra,l,aga,t)
        $(   out_Labour(abstype,"Employment",volume,ra,l,aga,t)
          gt out_Labour(abstype,"Employment",volume,ra,l,aga,t-1)
            AND out_Labour(abstype,"Employment","real",ra,l,aga,t) )
        = out_Labour(abstype,"Employment",volume,ra,l,aga,t)
        - out_Labour(abstype,"Employment",volume,ra,l,aga,t-1);

    out_Labour(abstype,"Job destructions",volume,ra,l,aga,t)
        $(out_Labour(abstype,"Employment",volume,ra,l,aga,t)
            le out_Labour(abstype,"Employment",volume,ra,l,aga,t-1)
            and out_Labour(abstype,"Employment","real",ra,l,aga,t))
        = ABS(out_Labour(abstype,"Employment",volume,ra,l,aga,t)
        - out_Labour(abstype,"Employment",volume,ra,l,aga,t-1));

    out_Labour(abstype,"Total job reallocation",volume,ra,l,aga,t)
        $ out_Labour(abstype,"Employment","real",ra,l,aga,t)
        = out_Labour(abstype,"Job creations",volume,ra,l,aga,t)
        + out_Labour(abstype,"Job destructions",volume,ra,l,aga,t);
    out_Labour(abstype,"Net employment growth",volume,ra,l,aga,t)
        $ out_Labour(abstype,"Employment","real",ra,l,aga,t)
        = out_Labour(abstype,"Job creations",volume,ra,l,aga,t)
        - out_Labour(abstype,"Job destructions",volume,ra,l,aga,t);

*	Aggregation : weights on out_Labour basis

    out_Labour(abstype,"Gross wage","nominal",ra,l,aga,t)
        $ out_Labour(abstype,"Employment","real",ra,l,aga,t)
        = sum((r,a) $ (mapr(ra,r) and mapaga(aga,a)),
            To%YearBaseMER%MER(r) * m_wagep(r,l,a,t) * m_true3t(ld,r,l,a,t))
        / out_Labour(abstype,"Employment","real",ra,l,aga,t);

* This is roughly equal to Labour efficiency

    out_Labour(abstype,"Gross wage","real",ra,l,aga,t)
        $ out_Labour(abstype,"Employment","real",ra,l,aga,t)
        = sum((r,a) $ (mapr(ra,r) and mapaga(aga,a)), To%YearBaseMER%MER(r)
            * sum(t0, m_wagep(r,l,a,t0)) * m_lambdal(r,l,a,t) * m_true3t(ld,r,l,a,t))
        / out_Labour(abstype,"Employment","real",ra,l,aga,t);

* m_lambdal ou lambdal ?

    out_Labour(abstype,"Gross wage (w / pp)","real",ra,l,aga,t)
        $ (sum((r,a,t0)$(mapr(ra,r) and xpFlag(r,a) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true2(pp,r,a,t0) * xpT(r,a,t0)) and out_Labour(abstype,"Employment","real",ra,l,aga,t))
        = sum((r,a,t0) $(mapr(ra,r) and xpFlag(r,a) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true2(pp,r,a,t)  * xpT(r,a,t0))
        / sum((r,a,t0) $(mapr(ra,r) and xpFlag(r,a) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true2(pp,r,a,t0) * xpT(r,a,t0));

     out_Labour(abstype,"Gross wage (w / pp)","real",ra,l,aga,t)
         $ (out_Labour(abstype,"Gross wage (w / pp)","real",ra,l,aga,t) and out_Labour(abstype,"Employment","real",ra,l,aga,t))
         = out_Labour(abstype,"Gross wage","nominal",ra,l,aga,t)
         / out_Labour(abstype,"Gross wage (w / pp)","real",ra,l,aga,t);

* m_lambdal ou lambdal ?

    out_Labour(abstype,"Efficient Labor","real",ra,l,aga,t)
        $ out_Labour(abstype,"Employment","real",ra,l,aga,t)
        = sum((r,a) $ (mapr(ra,r) and mapaga(aga,a) and xpFlag(r,a)),
            To%YearBaseMER%MER(r) * m_lambdal(r,l,a,t) * m_true3t(ld,r,l,a,t)) ; !! * wagep0(r,l,a) ??
* this is equal to labd ?

*	Consumer side:

    out_Labour(abstype,"net-of-tax wage rate","nominal",ra,l,aga,t)
        $ (sum((r,a) $ (labFlag(r,l,a) and mapr(ra,r) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true3t(ld,r,l,a,t)) and out_Labour(abstype,"Employment","real",ra,l,aga,t))
        = sum((r,a)  $ (labFlag(r,l,a) and mapr(ra,r) and mapaga(aga,a)), To%YearBaseMER%MER(r) * (1 - kappah.l(r,t)) * m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t))
* [TBU] * (1 - kappafp.l(r,l,t)) * m_true3(wage,r,l,a,t) * m_true3t(ld,r,l,a,t))
        / sum((r,a) $ (labFlag(r,l,a) and mapr(ra,r) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true3t(ld,r,l,a,t));

* Here it is consumer price Paashe Index not price of the good

    out_Labour(abstype,"net-of-tax wage rate","real",ra,l,aga,t)
        $ (sum((r,i,t0,h) $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t)) and out_Labour(abstype,"Employment","real",ra,l,aga,t))
        = sum((r,i,h)     $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t)  * XAPT(r,i,h,t))
        / sum((r,i,t0,h)  $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t));

* Divide nominal by Price index

    out_Labour(abstype,"net-of-tax wage rate","real",ra,l,aga,t)
        $ (out_Labour(abstype,"net-of-tax wage rate","real",ra,l,aga,t)
            and out_Labour(abstype,"net-of-tax wage rate","nominal",ra,l,aga,t))
        = out_Labour(abstype,"net-of-tax wage rate","nominal",ra,l,aga,t)
        / out_Labour(abstype,"net-of-tax wage rate","real",ra,l,aga,t);

$OnText
OECD-STAT: OECD Compendium of Productivity Indicators 2017
At the industry level, labour productivity is measured as gross value added at basic
prices per hour worked and growth rates are determined using constant price estimates of
gross value added. Comparable measures are also derived per person employed.

At the total economy level, labour productivity is measured as Gross domestic product
(GDP) at market prices per hour worked, per person employed.
$OffText

    out_Labour(abstype,"Labour productivity","real",ra,l,aga,t)
        $ out_Labour(abstype,"Employment","volume",ra,l,aga,t)
        = out_Value_Added(abstype,"Basic Prices","real",ra,aga,t)
        / out_Labour(abstype,"Employment","volume",ra,l,aga,t);

* Ratio to %YearRef% and growth rate

$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Labour" "Labourlist,units,ra,l,aga"

* Sectoral composition of employment (pct)

    IF(%aux_outType% ne AbsValueOnly,
        out_Labour("pct","Employment","real",ra,l,aga,t)
            $ (out_Labour("abs","Employment","real",ra,l,"ttot-a",t) and ReportYr(t))
            = out_Labour("abs","Employment","real",ra,l,aga,t)
            / out_Labour("abs","Employment","real",ra,l,"ttot-a",t);
    );

*---    Job markets flows --> rates as pct of average of employment

    IF(0, !! trop de sortie
        out_Labour("pct","Job creations",volume,ra,l,aga,t)
            $ out_Labour("abs","Employment",volume,ra,l,"ttot-a",t-1)
            = out_Labour("abs","Job creations",volume,ra,l,aga,t)
            / (  out_Labour("abs","Employment",volume,ra,l,"ttot-a",t) * 0.5
            + out_Labour("abs","Employment",volume,ra,l,"ttot-a",t-1)  * 0.5) ;
        out_Labour("pct","Job destructions",volume,ra,l,aga,t)
            $ out_Labour("abs","Employment",volume,ra,l,"ttot-a",t-1)
            = out_Labour("abs","Job destructions",volume,ra,l,aga,t)
            / (  out_Labour("abs","Employment",volume,ra,l,"ttot-a",t) * 0.5
            + out_Labour("abs","Employment",volume,ra,l,"ttot-a",t-1)  * 0.5) ;
        out_Labour("pct","Total job reallocation",volume,ra,l,aga,t)
            $ out_Labour("abs","Employment",volume,ra,l,"ttot-a",t-1)
            = out_Labour("abs","Total job reallocation",volume,ra,l,aga,t)
            / (  out_Labour("abs","Employment",volume,ra,l,"ttot-a",t) * 0.5
            + out_Labour("abs","Employment",volume,ra,l,"ttot-a",t-1)  * 0.5) ;
        out_Labour("pct","Net employment growth",volume,ra,l,aga,t)
            $ out_Labour("abs","Employment",volume,ra,l,"ttot-a",t-1)
            = out_Labour("abs","Net employment growth",volume,ra,l,aga,t)
            / (  out_Labour("abs","Employment",volume,ra,l,"ttot-a",t) * 0.5
            + out_Labour("abs","Employment",volume,ra,l,"ttot-a",t-1)  * 0.5) ;
    );

$ENDIF.Base

*------------------------------------------------------------------------------*
*                             Deviation from BAU                               *
*------------------------------------------------------------------------------*

$IfThenI.deviation %step_Labmodule%=="deviation"

    LOOP(abstype,
        out_Labour("devtoBau","Employment",volume,ra,l,aga,t)
            $ bau_Labour(abstype,"Employment",volume,ra,l,aga,t)
            = [  out_Labour(abstype,"Employment",volume,ra,l,aga,t)
            / bau_Labour(abstype,"Employment",volume,ra,l,aga,t) - 1];

        out_Labour("devtoBau","Job creations",volume,ra,l,aga,t)
            $(out_Labour(abstype,"Employment",volume,ra,l,aga,t)
                - bau_Labour(abstype,"Employment",volume,ra,l,aga,t) gt 0)
            = out_Labour(abstype,"Employment",volume,ra,l,aga,t)
            - bau_Labour(abstype,"Employment",volume,ra,l,aga,t);

        out_Labour("devtoBau","Job destructions",volume,ra,l,aga,t)
            $(out_Labour(abstype,"Employment",volume,ra,l,aga,t)
                - bau_Labour(abstype,"Employment",volume,ra,l,aga,t) le 0)
            = ABS(out_Labour(abstype,"Employment",volume,ra,l,aga,t)
                - bau_Labour(abstype,"Employment",volume,ra,l,aga,t));
    ) ;

    out_Labour("devtoBau","Total job reallocation",volume,ra,l,aga,t)
        = out_Labour("devtoBau","Job creations",volume,ra,l,aga,t)
        + out_Labour("devtoBau","Job destructions",volume,ra,l,aga,t);

    out_Labour("devtoBau","Net employment growth",volume,ra,l,aga,t)
        = out_Labour("devtoBau","Job creations",volume,ra,l,aga,t)
        - out_Labour("devtoBau","Job destructions",volume,ra,l,aga,t);

* Here in variant Mode the ratio is in pct of BAU levels (or average ?)

    IF(0,   !! trop de sortie
        LOOP(abstype,
        out_Labour("pct","Job creations",volume,ra,l,aga,ReportYr)
            $ bau_Labour(abstype,"Employment",volume,ra,l,"ttot-a",ReportYr)
            = out_Labour("devtoBau","Job creations",volume,ra,l,aga,ReportYr)
            / bau_Labour(abstype,"Employment",volume,ra,l,"ttot-a",ReportYr);
        out_Labour("pct","Job destructions",volume,ra,l,aga,ReportYr)
            $ bau_Labour(abstype,"Employment",volume,ra,l,"ttot-a",ReportYr)
            = out_Labour("devtoBau","Job destructions",volume,ra,l,aga,ReportYr)
            / bau_Labour(abstype,"Employment",volume,ra,l,"ttot-a",ReportYr);
        out_Labour("pct","Total job reallocation",volume,ra,l,aga,ReportYr)
            $ bau_Labour(abstype,"Employment",volume,ra,l,"ttot-a",ReportYr)
            = out_Labour("devtoBau","Total job reallocation",volume,ra,l,aga,ReportYr)
            / bau_Labour(abstype,"Employment",volume,ra,l,"ttot-a",ReportYr);
        out_Labour("pct","Net employment growth",volume,ra,l,aga,ReportYr)
            $ bau_Labour(abstype,"Employment",volume,ra,l,"ttot-a",ReportYr)
            = out_Labour("devtoBau","Net employment growth",volume,ra,l,aga,ReportYr)
            / bau_Labour(abstype,"Employment",volume,ra,l,"ttot-a",ReportYr) ;
        ) ;
    ) ;

OPTION clear=bau_Labour;

$ENDIF.deviation

$droplocal step_Labmodule


