$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model V.1. - Reporting procedure
   name        : "CommonPolicyFiles\ResumeOutput.gms"
   purpose     :  Generate Specific short outputs to quickly compare runs
					--> "ResumeOutput.gdx"
					--> "NrgSecurity_Bau.gdx" optional
   created date: 2021-05-06
   created by  : Jean Chateau
   called by   : "%ModelDir%\2-CommonIns.gms"
                 "%ModelDir%\9-sam"
                 "%ModelDir%\10-PostSimInstructions"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/CommonPolicyFiles/ResumeOutput.gms $
   last changed revision: $Rev: 510 $
   last changed date    : $Date:: 2024-02-15 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$setargs ResOutStep

$IfTheni.DeclareResOut %ResOutStep%=="2-CommonIns"

*------------------------------------------------------------------------------*
*    Declaration instructions : read in %ModelDir%\2-CommonIns.gms             *
*------------------------------------------------------------------------------*

    $$SetGlobal EmiYrRef "2020"

    SETS
        ResumeVar /
            "Power Share (Twh)"	"(pct of total generation)"
            "Power Share (val)"	"(pct of total generation)"
            "Electricity Supply: xs(elyi)"
            "Electricity Price: ps(elyi)"
            "Electricity Price: pa(elyi,h)"
            "Power Price: p(elya)"
            "Power Unit Cost (px)"
            "Feed in tariffs"
            "Feebates"
            "Power production Tax/Subsidies: ptax"
            "Power (Twh)"
            "CO2 Emission from Power Sector"

            "Renewable share"
            "Renewable share (constraint)"
            "Non-Fossil share"
            "Non-Fossil share (constraint)"
            "Fossil share"
            "Fossil share (constraint)"

            "Capital cost"

            "emiTax (%YearUSDCT% USD)"
			"emiTot"
			"emiTot wrt %EmiYrRef%"
			"emiTot wrt 2005"
			"emiTot wrt 1990"
			"emiTot (excl. lulucf)"
            "emiTot (excl. lulucf) wrt %EmiYrRef%"
            "emiTot (excl. lulucf) wrt 2005"
            "emiTot (excl. lulucf) wrt 2005 (bis)"
            "emiTot (excl. lulucf) wrt 1990"
            "emiTot to 2030 NDC"
            "emiTot (excl. Lulucf) to 2030 NDC"
            "Lulucf"
			"Fugitive"
            "EmiOth"
            "EmiSourceAct"
            "CO2 Emission intensity"
            "CO2 Emission intensity (controlled)"

$IfTheni.EUProj %BaseName%=="2023_EU_Desk"
			"CO2: ETS wrt 2005"
			"CO2: ETS wrt %EmiYrRef%"
			"GHG: ETS wrt 2005"
			"GHG: ETS wrt %EmiYrRef%"
			"EUETSGAS: ETS wrt 2005"
			"EUETSGAS: ETS wrt %EmiYrRef%"
			"Carbon Price (%YearUSDCT% USD / tonne of Co2)"
$EndIf.EUProj

            "Real GDP"
            "Employment"
            "GDP Deflator"
            "CPI"
            "Household Consumption"
            "Household income (real)"
            "Investment (real)"    "gross investment"
            "Investment (nominal)" "gross investment"
            "Capital stock (real)"
            "Real wage" "wage rate (relative to CPI)"

            "Gross output of EITE industries"
            "Production cost EITE industries"
            "Market shares of EITE industries"
            "CO2 emissions EITE industries"
            "CO2 emissions (excl. lulucf)"
            "GHG emissions EITE industries"
            "CO2 emissions EITE industries (process)"
            "GHG emissions EITE industries (process)"
			"CO2 emissions Energy related"

            "trg"
            "kappah"
            "kappal"
            "chiVAT"
            "chiPtax"
            "Shadow price of renewable constraint"

* Energy security

            "OLG: imports (Mtoe)"
            "OLG: domestic (Mtoe)"
            "Coal: imports (Mtoe)"
            "Coal: domestic (Mtoe)"
            "Electricity: imports (Mtoe)"
            "Electricity: domestic (Mtoe)"

* Fossil markets

            "Supply"
            "CIF price"
			"Supply Price"

* Energy Demands

            "Energy Demand"
            "Energy Agent Price"

* Kaya decomposition

            "GDP per capita"
            "Energy Intensity"  "(TPED to GDP)"
            "Emission per capita"
            "Emission per Energy"

* Energy Security

			"Export"
			"Import"
			"Absorption"

        /
        AffEm /
            "EmiCap"
            "emiTot"
            "EmiSourceAct"
            "emiTot-EmiCap"
            "emiRegTax"
        /
    ;

    PARAMETERS
        AffCapTg(*,AffEm,AllEmissions,t)
        MacroOutput(*,ResumeVar,r,t)
        ElyOutput(*,ResumeVar,*,*,t)
        EmiOutput(*,ResumeVar,*,*,t)
        CarbonLeakages(r,is,t)
        NrgSecurity(*,ResumeVar,units,ei,r,rp,t)
        FossilMarket(*,ResumeVar,is,ra,t)
        EnergyDemand(*,ResumeVar,*,i,aa,t)
    ;

    SCALAR IfOutNrgSecurity / 0 / ;

    file checkCondition / "checkCondition.txt" / ;

* Store ResumeOutput unfo in a specific folder

    $$If NOT DEXIST "%oDir%\ResumeOutput" $call "mkdir %oDir%\ResumeOutput"

* To compare with GDX diff. --> put always same name for first field

    $$SetGlobal SimAff "%SimName%"
*   $$SetGlobal SimAff "Baseline"

$EndIf.DeclareResOut

*------------------------------------------------------------------------------*
*           sam instructions : read in %ModelDir%\9-sam.gms                    *
*------------------------------------------------------------------------------*

$IfTheni.SamResOut %ResOutStep%=="9-sam"

*   Fill the variable AffCapTg

*   tsim = {t,tsim}

    $$batinclude "%PolicyPrgDir%\AverageCarbonPrice.gms" "tsim"

    $$Ondotl

*   Global emissions / targets

    AffCapTg("%SimAff%","EmiSourceAct",EmSingle,tsim)
        =sum((r,EmiSourceAct,aa) $ emi0(r,EmSingle,EmiSourceAct,aa),
            m_EffEmi(r,EmSingle,EmiSourceAct,aa,tsim)) ;
    AffCapTg("%SimAff%","Emitot",EmSingle,tsim)
        = sum(r, m_true2(emiTot,r,EmSingle,tsim));
    AffCapTg("%SimAff%","EmiCap",EmSingle,tsim)
        = sum(rq $ IfCap(rq), chiCap.l(EmSingle,tsim)
		                     * m_true2(emiCap,rq,EmSingle,tsim));
    AffCapTg("%SimAff%","emiTot-EmiCap",EmSingle,tsim)
        $ sum(mapr("WORLD",r), emFlag(r,EmSingle))
        = AffCapTg("%SimAff%","Emitot",EmSingle,tsim)
        - AffCapTg("%SimAff%","EmiCap",EmSingle,tsim) ;
    AffCapTg("%SimAff%",AffEm,AllGHG,tsim)
		= sum(EmSingle, AffCapTg("%SimAff%",AffEm,EmSingle,tsim)) ;
    AffCapTg("%SimAff%",AffEm,em,tsim)
		= AffCapTg("%SimAff%",AffEm,em,tsim) / cScale ;

    AffCapTg("%SimAff%","emiRegTax",em,tsim)
        $ (sum(r,emFlag(r,em)) and sum(rq $ IfCap(rq), emiCap(rq,em,tsim)))
        = sum(rq $ IfCap(rq), (emiRegTax.l(rq,em,tsim)/cScale) * emiCap(rq,em,tsim))
        $$IFi NOT %SimType%=="CompStat" * ConvertCurToModelUSD("%YearUSDCT%")
        / sum(rq $ IfCap(rq), emiCap(rq,em,tsim)) ;


* rworkT --> to convert into Labor units

    rworkT(r,tsim) = 0;
    LOOP(l,
        rworkT(r,tsim) $ sum(a, m_true3t(ld,r,l,a,tsim))
            = sum(z,  LFPR.l(r,l,z,tsim) * m_true3(popWA,r,l,z,tsim)
                    * [ 1 - UNR.l(r,l,z,tsim)])
            / sum(a, m_true3t(ld,r,l,a,tsim)) ;
    ) ;

*------------------------------------------------------------------------------*
*					   Filling "ElyOutput"									   *
*------------------------------------------------------------------------------*

    LOOP((elyi,r),

        ElyOutput("%SimAff%","Electricity Supply: xs(elyi)",r,elyi,tsim)
            = outscale * m_true2(xs,r,elyi,tsim) ;
        ElyOutput("%SimAff%","Electricity Price: ps(elyi)",r,elyi,tsim)
            = m_true2(ps,r,elyi,tsim) ;
        ElyOutput("%SimAff%","Power Share (Twh)",r,powa,tsim) $ xpFlag(r,powa)
            = 100 * m_true3t(x,r,powa,elyi,tsim)
            / sum(powa.local, m_true3t(x,r,powa,elyi,tsim));
        ElyOutput("%SimAff%","Capital cost",r,elya,tsim) $ xpFlag(r,elya)
            = sum((v,t0), m_true3v(pkp,r,elya,v,t0) * m_true3vt(kv,r,elya,v,tsim)) ;
        ElyOutput("%SimAff%","Employment",r,elya,tsim) $ xpFlag(r,elya)
            = sum(l, rworkT(r,tsim) * m_true3t(ld,r,l,elya,tsim) );
        ElyOutput("%SimAff%","Electricity Price: pa(elyi,h)",r,elyi,tsim)
            = sum(h,m_true3(pa,r,elyi,h,tsim));
        ElyOutput("%SimAff%","Power (Twh)",r,powa,tsim) $ xpFlag(r,powa)
            = m_true3t(x,r,powa,elyi,tsim) / Powscale;
        ElyOutput("%SimAff%","Power Price: p(elya)",r,elya,tsim) $ xpFlag(r,elya)
            = m_true3(p,r,elya,elyi,tsim) ;
        ElyOutput("%SimAff%","Power Unit Cost (px)",r,powa,tsim)$ xpFlag(r,powa)
            = m_true2(px,r,powa,tsim);

* policies

        ElyOutput("%SimAff%","Feed in tariffs",r,powa,tsim)
            $ (xpFlag(r,powa) and sum(tot,AdjTaxCov(r,tot,powa)))
            = m_pTax(r,powa,tsim) ;
        ElyOutput("%SimAff%","Feebates",r,powa,tsim) $ xpFlag(r,powa)
            = sum((em,EmiSourceAct) $ ifPowFeebates(r,em,EmiSourceAct),
                m_feebate(r,em,EmiSourceAct,powa,tsim)) ;
        ElyOutput("%SimAff%","Power production Tax/Subsidies: ptax",r,elya,tsim)
            $ xpFlag(r,elya)
            = 100 * m_pTax(r,elya,tsim) ;

        LOOP(CO2,
            ElyOutput("%SimAff%","CO2 Emission from Power Sector",r,elyi,tsim)
                = sum((powa,EmiComb), m_true4(emi,r,CO2,EmiComb,powa,tsim))
                / cscale ;
            ElyOutput("%SimAff%","emiTax (%YearUSDCT% USD)",r,elyi,tsim)
                = EMITAXT(r,CO2,tsim) ;
        ) ;

* Renewable/Fossil power shares

        ElyOutput("%SimAff%","Renewable share",r,elyi,tsim)
            = 100 * sum(a $ (s_otra(a) or HYDROa(a)), m_true3t(x,r,a,elyi,tsim))
            / sum(powa, m_true3t(x,r,powa,elyi,tsim)) ;

* This is what we compare

        ElyOutput("%SimAff%","Non-Fossil share",r,elyi,tsim)
            = 100 * sum(a $ (s_otra(a) or HYDROa(a) or Nukea(a)), m_true3t(x,r,a,elyi,tsim))
            / sum(powa, m_true3t(x,r,powa,elyi,tsim)) ;

        ElyOutput("%SimAff%","Fossil share",r,elyi,tsim)
            = 100 * sum((elya,fospbnd) $ mappow(fospbnd,elya), m_true3t(x,r,elya,elyi,tsim))
            / sum(powa, m_true3t(x,r,powa,elyi,tsim)) ;

* This is what is matched by the constraint

        ElyOutput("%SimAff%","Fossil share (constraint)",r,elyi,tsim)
            = 100 * sum(fospbnd,m_true3t(xpb,r,fospbnd,elyi,tsim))
            / m_true2t(xpow,r,elyi,tsim) ;

        IF(IfProjectFlag,
            ElyOutput("%SimAff%","Non-Fossil share (constraint)",r,elyi,tsim)
                = 100 * sum(pb $(not fospbnd(pb)), m_true3t(xpb,r,pb,elyi,tsim))
                / m_true2t(xpow,r,elyi,tsim) ;
        ELSE
            ElyOutput("%SimAff%","Renewable share (constraint)",r,elyi,tsim)
                = [  sum(pb $ (not fospbnd(pb)), m_true3t(xpb,r,pb,elyi,tsim))
                   - sum(Nukebnd,m_true3t(xpb,r,Nukebnd,elyi,tsim)) ]
                * 100 / m_true2t(xpow,r,elyi,tsim) ;
        ) ;

* Exogenous targets

        IF(year eq %YearAntePolicy%,
            IF(IfProjectFlag,
                ElyOutput("Target","Non-Fossil share",r,elyi,tsim)
                    $ RenewTgt(r,tsim)
                    = 100 * RenewTgt(r,tsim) ;
            ELSE
                ElyOutput("Target","Renewable share",r,elyi,tsim)
                    $ RenewTgt(r,tsim)  = 100 * RenewTgt(r,tsim) ;
            ) ;
            ElyOutput("Target","Fossil share",r,elyi,tsim)
                $ RenewTgt(r,tsim)
                = 100 * ( 1 - RenewTgt(r,tsim)) ;
        ) ;

*   Calibration [If activated]

$IfTheni.CalNrg %cal_NRG%=="ON"
		LOOP(tot,
			ElyOutput("Target","Power (Twh)",r,powa,tsim)
				$ xpFlag(r,powa)
				= SectoralTarget("xp",r,tot,powa,tsim) / Powscale ;
			ElyOutput("Target","Power Share (Twh)",r,powa,tsim)
				$ (	xpFlag(r,powa)
					AND sum(powa.local, SectoralTarget("xp",r,tot,powa,tsim)))
				= 100 * SectoralTarget("xp",r,tot,powa,tsim)
				/ sum(powa.local, SectoralTarget("xp",r,tot,powa,tsim)) ;
			ElyOutput("Target","Electricity Supply: xs(elyi)",r,elyi,tsim)
				= outscale * SectoralTarget("xs",r,elyi,"tot",tsim) ;
			ElyOutput("Target","Electricity Price: ps(elyi)",r,elyi,tsim)
				= SectoralTarget("market price",r,elyi,tot,tsim) ;
		) ;
$EndIf.CalNrg

    ) ; !! End loop on ely

*------------------------------------------------------------------------------*
*					   Filling "FossilMarket"								   *
*------------------------------------------------------------------------------*

    LOOP(r,
        FossilMarket("%SimAff%","Supply",ei,ra,tsim) $ sameas(ra,r)
            = outscale * m_true2(xs,r,ei,tsim) ;

		FossilMarket("%SimAff%","Supply Price",ei,ra,tsim) $ sameas(ra,r)
			= m_true2(ps,r,ei,tsim) ;
   ) ;

    FossilMarket("%SimAff%","Supply",ei,WLD,tsim)
        = outscale * sum(r,m_true2(xs,r,ei,tsim)) ;

    FossilMarket("%SimAff%","Supply Price",COILi,WLD,tsim)
        = sum(COILa, pw(COILa,tsim)) ;
    FossilMarket("%SimAff%","Supply Price",COAi,WLD,tsim)
        = sum(COAa, pw(COAa,tsim))  ;
    FossilMarket("%SimAff%","Supply Price",NGASi,WLD,tsim)
        = sum(NGASa,pw(NGASa,tsim)) ;

    FossilMarket("%SimAff%","CIF price",ei,WLD,tsim) = wldPm(ei,tsim);

$IfTheni.CalNrg %cal_NRG%=="ON"

        LOOP((tot,r),
            FossilMarket("Target","Supply",COILi,ra,tsim)  $ sameas(ra,r)
                = sum(COILa, SectoralTarget("xp",r,tot,COILa,tsim)) ;
            FossilMarket("Target","Supply",COAi,ra,tsim) $ sameas(ra,r)
                = sum(COAa, SectoralTarget("xp",r,tot,COAa,tsim) ) ;
            FossilMarket("Target","Supply",NGASi,ra,tsim)  $ sameas(ra,r)
                = sum(NGASa, SectoralTarget("xp",r,tot,NGASa,tsim)) ;

			FossilMarket("Target","Supply Price",ei,ra,tsim) $ sameas(ra,r)
				= SectoralTarget("market price",r,ei,tot,tsim) ;
		) ;

		FossilMarket("Target","Supply",COILi,WLD,tsim)
			= sum((r,tot,COILa), SectoralTarget("xp",r,tot,COILa,tsim)) ;
		FossilMarket("Target","Supply",COAi,WLD,tsim)
			= sum((r,tot,COAa) , SectoralTarget("xp",r,tot,COAa,tsim) ) ;
		FossilMarket("Target","Supply",NGASi,WLD,tsim)
			= sum((r,tot,NGASa), SectoralTarget("xp",r,tot,NGASa,tsim)) ;

		FossilMarket("Target","Supply Price",COILi,WLD,tsim)
			= sum(COILa,WorldTarget("pw",COILa,tsim)) ;

		FossilMarket("Target","CIF price",ei,WLD,tsim)
			= sum(rres,Market_Price_WEM(rres,ei,"%ActWeoSc%",tsim));

$EndIf.CalNrg

*------------------------------------------------------------------------------*
*					   Filling EnergyDemand(*,ResumeVar,a,tsim)				   *
*------------------------------------------------------------------------------*

    work = 1 ; !! vol
    work = 0 ; !! real

	EnergyDemand("%SimAff%","Energy Demand",r,e,aa,tsim)
		= work * nrj_mtoe(r,e,aa,tsim) + (1 - work) * XAPT(r,e,aa,tsim) ;

	EnergyDemand("%SimAff%","Energy Demand",r,i,tot,tsim)
		= sum(aa, EnergyDemand("%SimAff%","Energy Demand",r,i,aa,tsim) ) ;

	EnergyDemand("%SimAff%","Energy Demand","EU",i,aa,tsim)
		= sum(EU, EnergyDemand("%SimAff%","Energy Demand",EU,i,aa,tsim)) ;

	EnergyDemand("%SimAff%","Energy Agent Price",r,i,h,tsim)
		$ (ROILi(i) or NGASi(i) or ELYi(i))	= m_true3(pa,r,i,h,tsim) ;
	EnergyDemand("%SimAff%","Energy Agent Price",r,i,LandTrpa,tsim)
		$ (ROILi(i) or NGASi(i) or ELYi(i))	= m_true3(pa,r,i,LandTrpa,tsim) ;
	EnergyDemand("%SimAff%","Energy Agent Price",r,i,I_Sa,tsim)
		$ (ROILi(i) or NGASi(i) or ELYi(i))	= m_true3(pa,r,i,I_Sa,tsim) ;

$IfTheni.CalibNrg %cal_NRG%=="ON"

		EnergyDemand("Target","Energy Demand",r,i,aa,tsim)
			$ EnergyDemand("%SimAff%","Energy Demand",r,i,aa,tsim)
			= SectoralTarget("xa",r,i,aa,tsim) ;

		EnergyDemand("Target","Energy Demand",r,i,tot,tsim)
			= sum(aa, EnergyDemand("Target","Energy Demand",r,i,aa,tsim)) ;

		EnergyDemand("Target","Energy Demand","EU",i,aa,tsim)
			= sum(EU, EnergyDemand("Target","Energy Demand",EU,i,aa,tsim)) ;

		EnergyDemand("Target","Energy Agent Price",r,i,aa,tsim)
			$ ( ROILi(i) or NGASi(i) or ELYi(i)
			    AND EnergyDemand("%SimAff%","Energy Agent Price",r,i,aa,tsim))
			= Agent_Price_WEM(r,i,aa,"%ActWeoSc%",tsim) ;

$EndIf.CalibNrg

*------------------------------------------------------------------------------*
*					   Filling "EmiOutput"				    				   *
*------------------------------------------------------------------------------*

* Single gas

    EmiOutput("%SimAff%","emiTax (%YearUSDCT% USD)",r,EmSingle,tsim)
        = EMITAXT(r,EmSingle,tsim) ;

    EmiOutput("%SimAff%","emiTot",r,EmSingle,tsim)
        = m_true2(emiTot,r,EmSingle,tsim) / cScale;
    EmiOutput("%SimAff%","EmiSourceAct",r,EmSingle,tsim)
        = [   m_true2(emiTot,r,EmSingle,tsim)
			- emiOth.l(r,EmSingle,tsim)] / cScale ;
    EmiOutput("%SimAff%","emiOth",r,EmSingle,tsim)
        = emiOth.l(r,EmSingle,tsim) / cScale;
    EmiOutput("%SimAff%","Lulucf",r,CO2,tsim)
        = sum((emilulucf,prima), m_true4(emi,r,CO2,emilulucf,prima,tsim))
        / cScale ;

* Sum over GHG

    EmiOutput("%SimAff%","emiTot",r,AllGHG,tsim)
        = sum(EmSingle,EmiOutput("%SimAff%","emiTot",r,EmSingle,tsim)) ;

    EmiOutput("%SimAff%","EmiSourceAct",r,AllGHG,tsim)
        = sum(EmSingle,EmiOutput("%SimAff%","EmiSourceAct",r,EmSingle,tsim)) ;

* excl. lulucf

    EmiOutput("%SimAff%","emiTot (excl. lulucf)",r,CO2,tsim)
        = EmiOutput("%SimAff%","emiTot",r,CO2,tsim)
        - EmiOutput("%SimAff%","Lulucf",r,CO2,tsim) ;

    EmiOutput("%SimAff%","emiTot (excl. lulucf)",r,AllGHG,tsim)
        = EmiOutput("%SimAff%","emiTot",r,AllGHG,tsim)
        - EmiOutput("%SimAff%","Lulucf",r,"CO2",tsim) ;

* World Aggregate

    EmiOutput("%SimAff%","emiTot",WLD,em,tsim)
        = sum(r,EmiOutput("%SimAff%","emiTot",r,em,tsim)) ;
    EmiOutput("%SimAff%","emiTot",WLD,AllGHG,tsim)
        = sum(r,EmiOutput("%SimAff%","emiTot",r,AllGHG,tsim)) ;
    EmiOutput("%SimAff%","emiTot (excl. lulucf)",WLD,CO2,tsim)
        = sum(r,EmiOutput("%SimAff%","emiTot (excl. lulucf)",r,CO2,tsim)) ;
    EmiOutput("%SimAff%","emiTot (excl. lulucf)",WLD,AllGHG,tsim)
        = sum(r,EmiOutput("%SimAff%","emiTot (excl. lulucf)",r,AllGHG,tsim)) ;

    EmiOutput("%SimAff%","EmiSourceAct",WLD,em,tsim)
        = sum(r,EmiOutput("%SimAff%","EmiSourceAct",r,em,tsim)) ;

*	EU aggreagte

$IfTheni.EUProj %BaseName%=="2023_EU_Desk"
	EmiOutput("%SimAff%","emiTot","EU",em,tsim)
		= sum(EU,EmiOutput("%SimAff%","emiTot",EU,em,tsim)) ;
	EmiOutput("%SimAff%","emiTot","EU",AllGHG,tsim)
		= sum(EU,EmiOutput("%SimAff%","emiTot",EU,AllGHG,tsim)) ;
	EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",CO2,tsim)
		= sum(EU,EmiOutput("%SimAff%","emiTot (excl. lulucf)",EU,CO2,tsim)) ;
	EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",AllGHG,tsim)
		= sum(EU,EmiOutput("%SimAff%","emiTot (excl. lulucf)",EU,AllGHG,tsim)) ;
	EmiOutput("%SimAff%","EmiSourceAct","EU",em,tsim)
		= sum(EU,EmiOutput("%SimAff%","EmiSourceAct",EU,em,tsim)) ;

	IF(YEAR EQ 2030,
		EmiOutput("Target Fitfor55","emiTot wrt 1990","EU",AllGHG,tsim)
			= - 55 ;
		EmiOutput("Target Ref2020","emiTot (excl. lulucf) wrt 1990","EU",AllGHG,tsim)
			= - 40 ;
	) ;
$EndIF.EUProj


* Fugitive emissions

    EmiOutput("%SimAff%","Fugitive",r,EmSingle,tsim)
		= sum(a, m_true4(emi,r,EmSingle,"fugitive",a,tsim)) / cScale ;
	EmiOutput("%SimAff%","Fugitive",r,AllGHG,tsim)
		= sum(EmSingle, EmiOutput("%SimAff%","Fugitive",r,EmSingle,tsim)) ;


* EITE industries: details

$ontext
    EmiOutput("%SimAff%","emiTax (%YearUSDCT% USD)",r,EITEa,tsim)
        $ sum((EmSingle,EmiSourceAct) $ part(r,EmSingle,EmiSourceAct,EITEa,tsim),
            m_true4(emi,r,EmSingle,EmiSourceAct,EITEa,tsim))
        =  (1 / ConvertCurToModelUSD("%YearUSDCT%"))
        * sum((EmSingle,EmiSourceAct) $ part(r,EmSingle,EmiSourceAct,EITEa,tsim),
            m_true4(emi,r,EmSingle,EmiSourceAct,EITEa,tsim) * [m_EmiPrice(r,EmSingle,EmiSourceAct,EITEa,tsim) - p_emissions(r,EmSingle,EmiSourceAct,EITEa,tsim)])
        / sum((EmSingle,EmiSourceAct) $ part(r,EmSingle,EmiSourceAct,EITEa,tsim),
            cScale * m_true4(emi,r,EmSingle,EmiSourceAct,EITEa,tsim))
        ;
$offtext

$IfTheni.EUProj %BaseName%=="2023_EU_Desk"

		$$batinclude "%FolderPROJECTS%\CommonPolicyFiles\Eu_Specific.gms" "CO2" "EU-ETS sectors"  "EUEETSTruea"
		$$batinclude "%FolderPROJECTS%\CommonPolicyFiles\Eu_Specific.gms" "CO2" "EU-ESR sectors"  "EUESRTruea"
		$$batinclude "%FolderPROJECTS%\CommonPolicyFiles\Eu_Specific.gms" "CO2" "EU-ETS2 sectors" "EUETS2a"

*	All GHG together

		$$batinclude "%FolderPROJECTS%\CommonPolicyFiles\Eu_Specific.gms" "GHG" "EU-ETS sectors"  "EUEETSTruea"
		$$batinclude "%FolderPROJECTS%\CommonPolicyFiles\Eu_Specific.gms" "GHG" "EU-ESR sectors"  "EUESRTruea"
		$$batinclude "%FolderPROJECTS%\CommonPolicyFiles\Eu_Specific.gms" "GHG" "EU-ETS2 sectors" "EUETS2a"

		$$batinclude "%FolderPROJECTS%\CommonPolicyFiles\Eu_Specific.gms" "EUETSGAS" "EU-ETS sectors" "EUEETSTruea"

		IF(YEAR EQ 2030,

			EmiOutput("Target Fitfor55","EUETSGAS: ETS wrt 2005","EU","EU-ETS sectors",tsim)  = - 62 ;
			EmiOutput("Target Ref2020","EUETSGAS: ETS wrt 2005","EU","EU-ETS sectors",tsim)	  = - 43 ;

			EmiOutput("Target Fitfor55","GHG: ETS wrt 2005","EU","EU-ETS2 sectors",tsim)= - 42 ;

			EmiOutput("Target Fitfor55","GHG: ETS wrt 2005",FRA,"EU-ESR sectors",tsim)	= - 47.5 ;
			EmiOutput("Target Ref2020","GHG: ETS wrt 2005",FRA,"EU-ESR sectors",tsim)	= - 37 ;
			EmiOutput("Target Fitfor55","GHG: ETS wrt 2005",DEU,"EU-ESR sectors",tsim)	= - 50 ;
			EmiOutput("Target Ref2020","GHG: ETS wrt 2005",DEU,"EU-ESR sectors",tsim)	= - 38 ;
			EmiOutput("Target Fitfor55","GHG: ETS wrt 2005",ITA,"EU-ESR sectors",tsim)	= - 43.7 ;
			EmiOutput("Target Ref2020","GHG: ETS wrt 2005",ITA,"EU-ESR sectors",tsim)	= - 33 ;
			EmiOutput("Target Fitfor55","GHG: ETS wrt 2005",POL,"EU-ESR sectors",tsim)	= - 17.7 ;
			EmiOutput("Target Ref2020","GHG: ETS wrt 2005",POL,"EU-ESR sectors",tsim)	= - 7 ;
			EmiOutput("Target Fitfor55","GHG: ETS wrt 2005",ESP,"EU-ESR sectors",tsim)	= - 37.7 ;
			EmiOutput("Target Ref2020","GHG: ETS wrt 2005",ESP,"EU-ESR sectors",tsim)	= - 26 ;
			EmiOutput("Target Fitfor55","GHG: ETS wrt 2005","EU","EU-ESR sectors",tsim)	= - 40 ;
			EmiOutput("Target Ref2020","GHG: ETS wrt 2005","EU","EU-ESR sectors",tsim)	= - 29 ;
			EmiOutput("Target Ref2020","GHG: ETS wrt 2005",REU,"EU-ESR sectors",tsim)	= -23.65 ;

		) ;

		LOOP(CO2,
			LOOP(LandTrpa,
				EmiOutput("%SimAff%","Carbon Price (%YearUSDCT% USD / tonne of Co2)",WEU,"EU-ETS2 sectors",tsim)
					= p_emissions(WEU,CO2,"roilcomb",LandTrpa,tsim) * m_convCtax ;
			) ;
			IF(NOT VarFlag,
				LOOP((CLPa,DEU),
					EmiOutput("%SimAff%","Carbon Price (%YearUSDCT% USD / tonne of Co2)",WEU,"EU-ETS sectors",tsim)
						= p_emissions(DEU,CO2,"coalcomb",CLPa,tsim) * m_convCtax ;
				) ;
			ELSE
				EmiOutput("%SimAff%","Carbon Price (%YearUSDCT% USD / tonne of Co2)",WEU,"EU-ETS sectors",tsim)
					= EMITAXT(WEU,CO2,tsim) ;
			) ;
		) ;

		EmiOutput("%SimAff%","Fugitive","EU",GHG,tsim)
			= sum(EU,EmiOutput("%SimAff%","Fugitive",EU,GHG,tsim)) ;
		EmiOutput("%SimAff%","Fugitive","EU-ETS",GHG,tsim)
			= sum(WEU,EmiOutput("%SimAff%","Fugitive",WEU,GHG,tsim)) ;

$EndIf.EUProj

*	CO2 & GHG for EITE industries

* details

    EmiOutput("%SimAff%","CO2 emissions EITE industries",r,EITEa,tsim)
        = sum((CO2,EmiSourceAct), m_true4(emi,r,CO2,EmiSourceAct,EITEa,tsim))
        / cscale ;

    EmiOutput("%SimAff%","GHG emissions EITE industries",r,"EITE",tsim)
        = sum((EITEa,EmSingle,EmiSourceAct), m_true4(emi,r,EmSingle,EmiSourceAct,EITEa,tsim))
        / cscale ;

    EmiOutput("%SimAff%","CO2 emissions EITE industries (process)",r,EITEa,tsim)
        = sum((CO2,emiAct), m_true4(emi,r,CO2,emiAct,EITEa,tsim)) / cscale ;

    EmiOutput("%SimAff%","GHG emissions EITE industries (process)",r,"EITE",tsim)
        = sum((EITEa,emSingle,emiAct), m_true4(emi,r,EmSingle,emiAct,EITEa,tsim))
        / cscale ;

* aggregate

    EmiOutput("%SimAff%","CO2 emissions EITE industries",r,"EITE",tsim)
        = sum(EITEa,EmiOutput("%SimAff%","CO2 emissions EITE industries",r,EITEa,tsim)) ;

    EmiOutput("%SimAff%","CO2 emissions EITE industries (process)",r,"EITE",tsim)
        = sum(EITEa,EmiOutput("%SimAff%","CO2 emissions EITE industries (process)",r,EITEa,tsim)) ;

    EmiOutput("%SimAff%","CO2 emissions Energy related",r,CO2,tsim)
        = [  sum((aa,EmiFosComb), m_true4(emi,r,CO2,EmiFosComb,aa,tsim))
*		   + sum(fossilea, m_true4(emi,r,CO2,"fugitive",fossilea,tsim))
		  ]	/ cscale ;

* Emission intensity: kilograms of CO2 per $2014

    LOOP(CO2,

        EmiOutput("%SimAff%","CO2 Emission intensity",r,EITEa,tsim)
            = EmIntensity(r,EITEa,CO2,tsim) ;

        EmiOutput("%SimAff%","CO2 Emission intensity",r,"EITE",tsim)
            $ sum(EITEa,XPT(r,EITEa,tsim))
            = sum(EITEa,XPT(r,EITEa,tsim)* EmIntensity(r,EITEa,CO2,tsim))
            / sum(EITEa,XPT(r,EITEa,tsim)) ;

        EmiOutput("%SimAff%","CO2 Emission intensity",r,"POWER",tsim)
            $ sum(elya,XPT(r,elya,tsim))
            = sum(elya,XPT(r,elya,tsim) * EmIntensity(r,elya,CO2,tsim))
            / sum(elya,XPT(r,elya,tsim))   ;

        EmiOutput("%SimAff%","CO2 Emission intensity (controlled)",r,EITEa,tsim)
           $ (XPT(r,EITEa,tsim) and emia_IntTgt(r,EITEa,CO2,tsim))
           = 100000 * [m_true3(emia,r,EITEa,CO2,tsim) / cScale]
           / XPT(r,EITEa,tsim) ;
        EmiOutput("%SimAff%","CO2 Emission intensity (controlled)",r,"EITE",tsim)
           $ sum(EITEa,XPT(r,EITEa,tsim))
           = 100000 * [sum(EITEa,m_true3(emia,r,EITEa,CO2,tsim)) / cScale]
           / sum(eitea,XPT(r,EITEa,tsim)) ;

        EmiOutput("Target","CO2 Emission intensity",r,EITEa,tsim)
            = emia_IntTgt(r,EITEa,CO2,tsim) * 100;
        EmiOutput("Target","CO2 Emission intensity",r,"EITE",tsim)
            $ sum(eitea,XPT(r,EITEa,tsim))
            = 100 * sum(eitea, emia_IntTgt(r,EITEa,CO2,tsim)* XPT(r,EITEa,tsim))
            / sum(eitea,XPT(r,EITEa,tsim)) ;

    ) ;

* Skip this step in compStat
$iftheni not "%simtype%" == "COMPSTAT"
    IF(ifDyn,

        $$IfTheni.DynCalENV %DynCalMethod%=="OECD-ENV"
            $$IfThen.NDCtgt NOT %BaseYearCW%=="OFF"
            IF(year ge %BaseYearCW%,
                EmiOutput("%SimAff%","emiTot (excl. Lulucf) to 2030 NDC",r,CO2,tsim)
                    $ NDC2030(r,"CO2")
                    = 100 * sum((aa,EmiSource) $ (not tota(aa) and not emiagg(EmiSource) and not emilulucf(EmiSource)),
                            m_true4(emi,r,CO2,EmiSource,aa,tsim)  / cScale)
                    / NDC2030(r,"CO2");
                EmiOutput("%SimAff%","emiTot (excl. Lulucf) to 2030 NDC",r,"GHG",tsim)
                    $ NDC2030(r,"GHG")
                    = 100 * sum((aa,EmiSource,emSingle) $ (not tota(aa) and not emiagg(EmiSource) and not emilulucf(EmiSource)),
                            m_true4(emi,r,emSingle,EmiSource,aa,tsim)  / cScale)
                    / NDC2030(r,"GHG");
                EmiOutput("%SimAff%","emiTot to 2030 NDC",r,"GHG",tsim)
                    $ NDC2030(r,"GHG_Lulucf")
                    = 100 * EmiOutput("%SimAff%","emiTot",r,"GHG",tsim)
                    / NDC2030(r,"GHG_Lulucf");
            ) ;
            $$Endif.NDCtgt
        $$Endif.DynCalENV

        EmiOutput("%SimAff%","emiTot wrt %EmiYrRef%",r,CO2,tsim)
            $ EmiOutput("%SimAff%","emiTot",r,CO2,"%EmiYrRef%")
            =  (  EmiOutput("%SimAff%","emiTot",r,CO2,tsim)
				/ EmiOutput("%SimAff%","emiTot",r,CO2,"%EmiYrRef%")
			   -1 ) * 100 ;

        EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt %EmiYrRef%",r,CO2,tsim)
            $ EmiOutput("%SimAff%","emiTot",r,CO2,"%EmiYrRef%")
            =  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)",r,CO2,tsim)
				/ EmiOutput("%SimAff%","emiTot (excl. lulucf)",r,CO2,"%EmiYrRef%")
			   -1 ) * 100 ;

        EmiOutput("%SimAff%","emiTot wrt %EmiYrRef%",r,AllGHG,tsim)
            $ EmiOutput("%SimAff%","emiTot",r,AllGHG,"%EmiYrRef%")
            =  (  EmiOutput("%SimAff%","emiTot",r,AllGHG,tsim)
				/ EmiOutput("%SimAff%","emiTot",r,AllGHG,"%EmiYrRef%")
			   -1 ) * 100 ;

        EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt %EmiYrRef%",r,AllGHG,tsim)
            $ EmiOutput("%SimAff%","emiTot",r,AllGHG,"%EmiYrRef%")
            =  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)",r,AllGHG,tsim)
				/ EmiOutput("%SimAff%","emiTot (excl. lulucf)",r,AllGHG,"%EmiYrRef%")
			   -1 ) * 100 ;

$IfTheni.EUProj %BaseName%=="2023_EU_Desk"

*	EU aggregate emissions

*	Emissions wrt %EmiYrRef%: All GHG

* emitot

			EmiOutput("%SimAff%","emiTot wrt %EmiYrRef%","EU",AllGHG,tsim)
				$ EmiOutput("%SimAff%","emiTot","EU",AllGHG,"%EmiYrRef%")
				=  (  EmiOutput("%SimAff%","emiTot","EU",AllGHG,tsim)
					/ EmiOutput("%SimAff%","emiTot","EU",AllGHG,"%EmiYrRef%")
				-1 ) * 100 ;

* emiTot (excl. lulucf)

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt %EmiYrRef%","EU",AllGHG,tsim)
				$ EmiOutput("%SimAff%","emiTot","EU",AllGHG,"%EmiYrRef%")
				=  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",AllGHG,tsim)
					/ EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",AllGHG,"%EmiYrRef%")
				-1 ) * 100 ;

*	Emissions wrt %EmiYrRef%: CO2 only

* emitot

			EmiOutput("%SimAff%","emiTot wrt %EmiYrRef%","EU",CO2,tsim)
				$ EmiOutput("%SimAff%","emiTot","EU",CO2,"%EmiYrRef%")
				=  (  EmiOutput("%SimAff%","emiTot","EU",CO2,tsim)
					/ EmiOutput("%SimAff%","emiTot","EU",CO2,"%EmiYrRef%")
				-1 ) * 100 ;

* emiTot (excl. lulucf)

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt %EmiYrRef%","EU",CO2,tsim)
				$ EmiOutput("%SimAff%","emiTot","EU",CO2,"%EmiYrRef%")
				=  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",CO2,tsim)
					/ EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",CO2,"%EmiYrRef%")
				-1 ) * 100 ;

*	Emissions wrt 1990: WEU countries and EU aggregate

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 1990",WEU,AllGHG,tsim)
				$ HIST_GHG("UNFCCC",WEU,"GHG","1990")
				=  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)",WEU,AllGHG,tsim)
					/ HIST_GHG("UNFCCC",WEU,"GHG","1990")
				-1 ) * 100 ;

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 1990","EU",AllGHG,tsim)
				$ sum(EU,HIST_GHG("UNFCCC",EU,"GHG","1990"))
				=  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",AllGHG,tsim)
					/ sum(EU,HIST_GHG("UNFCCC",EU,"GHG","1990"))
				-1 ) * 100 ;

			EmiOutput("%SimAff%","emiTot wrt 1990",WEU,AllGHG,tsim)
				$ HIST_GHG("UNFCCC",WEU,"GHG","1990")
				=  (  EmiOutput("%SimAff%","emiTot",WEU,AllGHG,tsim)
					/ HIST_GHG("UNFCCC",WEU,"GHG_Lulucf","1990")
				-1 ) * 100 ;

			EmiOutput("%SimAff%","emiTot wrt 1990","EU",AllGHG,tsim)
				$ sum(EU,HIST_GHG("UNFCCC",EU,"GHG","1990"))
				=  (  EmiOutput("%SimAff%","emiTot","EU",AllGHG,tsim)
					/ sum(EU,HIST_GHG("UNFCCC",EU,"GHG_Lulucf","1990"))
				-1 ) * 100 ;

* CO2 only

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 1990",WEU,CO2,tsim)
				$ HIST_GHG("UNFCCC",WEU,"CO2","1990")
				=  [  EmiOutput("%SimAff%","emiTot (excl. lulucf)",WEU,CO2,tsim)
					/ HIST_GHG("UNFCCC",WEU,"CO2","1990") -1 ] * 100 ;

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 1990","EU",CO2,tsim)
				$ sum(EU,HIST_GHG("UNFCCC",EU,"GHG","1990"))
				=  [  EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",CO2,tsim)
					/ sum(EU,HIST_GHG("UNFCCC",EU,"CO2","1990")) -1 ] * 100 ;

* All GHG

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 2005",WEU,AllGHG,tsim)
				$ HIST_GHG("UNFCCC",WEU,"GHG","2005")
				=  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)",WEU,AllGHG,tsim)
					/ HIST_GHG("UNFCCC",WEU,"GHG","2005")
				-1 ) * 100 ;

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 2005","EU",AllGHG,tsim)
				$ sum(EU,HIST_GHG("UNFCCC",EU,"GHG","2005"))
				=  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",AllGHG,tsim)
					/ sum(EU,HIST_GHG("UNFCCC",EU,"GHG","2005"))
				-1 ) * 100 ;

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 2005 (bis)",WEU,AllGHG,tsim)
				$ sum((EmSingle,EmiSource,aa),emi2005(WEU,EmSingle,EmiSource,aa) / cScale)
				=  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)",WEU,AllGHG,tsim)
					/ sum((EmSingle,EmiSource,aa),emi2005(WEU,EmSingle,EmiSource,aa) / cScale)
				-1 ) * 100 ;

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 2005 (bis)","EU",AllGHG,tsim)
				$ sum(EU,HIST_GHG("UNFCCC",EU,"GHG","2005"))
				=  (  EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",AllGHG,tsim)
					/ sum((EU,EmSingle,EmiSource,aa),emi2005(EU,EmSingle,EmiSource,aa) / cScale)
				-1 ) * 100 ;

			EmiOutput("%SimAff%","emiTot wrt 2005",WEU,AllGHG,tsim)
				$ HIST_GHG("UNFCCC",WEU,"GHG","2005")
				=  (  EmiOutput("%SimAff%","emiTot",WEU,AllGHG,tsim)
					/ HIST_GHG("UNFCCC",WEU,"GHG_Lulucf","2005")
				-1 ) * 100 ;

			EmiOutput("%SimAff%","emiTot wrt 2005","EU",AllGHG,tsim)
				$ sum(EU,HIST_GHG("UNFCCC",EU,"GHG","2005"))
				=  (  EmiOutput("%SimAff%","emiTot","EU",AllGHG,tsim)
					/ sum(EU,HIST_GHG("UNFCCC",EU,"GHG_Lulucf","2005"))
				-1 ) * 100 ;

* CO2 only

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 2005",WEU,CO2,tsim)
				$ HIST_GHG("UNFCCC",WEU,"CO2","2005")
				=  [  EmiOutput("%SimAff%","emiTot (excl. lulucf)",WEU,CO2,tsim)
					/ HIST_GHG("UNFCCC",WEU,"CO2","2005") -1 ] * 100 ;

			EmiOutput("%SimAff%","emiTot (excl. lulucf) wrt 2005","EU",CO2,tsim)
				$ sum(EU,HIST_GHG("UNFCCC",EU,"GHG","2005"))
				=  [  EmiOutput("%SimAff%","emiTot (excl. lulucf)","EU",CO2,tsim)
					/ sum(EU,HIST_GHG("UNFCCC",EU,"CO2","2005")) -1 ] * 100 ;

* Target Ref2020

			EmiOutput("Target Ref2020","emiTot (excl. lulucf) wrt 2005",EU,AllGHG,tsim)
				$ GHGExclLulucfRef2020(EU,"2005")
				=  (  GHGExclLulucfRef2020(EU,tsim)
					/ GHGExclLulucfRef2020(EU,"2005")
				- 1 ) * 100 ;

			EmiOutput("Target Ref2020","emiTot (excl. lulucf) wrt 2005","EU",AllGHG,tsim)
				$ sum(EU,GHGExclLulucfRef2020(EU,"2005"))
				=  (  sum(EU,GHGExclLulucfRef2020(EU,tsim))
					/ sum(EU,GHGExclLulucfRef2020(EU,"2005"))
				- 1 ) * 100 ;

*			EmiOutput("Target","emiTot wrt 2005",EU,AllGHG,tsim)
*				$ GHGExclLulucfRef2020(EU,"2005")
*				=  (  [GHGExclLulucfRef2020(EU,tsim)   + sum(prima,LULUCF_PRIMES(EU,prima,tsim))  ]
*					/ [GHGExclLulucfRef2020(EU,"2005") + sum(prima,LULUCF_PRIMES(EU,prima,"2005"))]
*				- 1 ) * 100 ;
*
*			EmiOutput("Target","emiTot wrt 2005","EU",AllGHG,tsim)
*				$ sum(EU,GHGExclLulucfRef2020(EU,"2005"))
*				=  (  sum(EU,GHGExclLulucfRef2020(EU,tsim)+sum(prima,LULUCF_PRIMES(EU,prima,tsim)))
*					/ sum(EU,GHGExclLulucfRef2020(EU,"2005")+sum(prima,LULUCF_PRIMES(EU,prima,"2005")))
*				- 1 ) * 100 ;

$EndIF.EUProj

    ) ;
$endif

*------------------------------------------------------------------------------*
*					   Filling "MacroOutput"			    				   *
*------------------------------------------------------------------------------*

* macro informations

    MacroOutput("%SimAff%","Real GDP",r,tsim) =  m_true1(rgdpmp,r,tsim) ;
    MacroOutput("%SimAff%","Household Consumption",r,tsim)
        = m_true2(xfd,r,"hhd",tsim) ;
    MacroOutput("%SimAff%","Investment (real)",r,tsim)
        = m_true2(xfd,r,"inv",tsim) * sum(t0, m_true2(pfd,r,"inv",t0));
    MacroOutput("%SimAff%","Investment (nominal)",r,tsim)
        = m_true2(yfd,r,"inv",tsim) ;
    MacroOutput("%SimAff%","Capital stock (real)",r,tsim) = m_true1(kstock,r,tsim) ;

    MacroOutput("%SimAff%",ResumeVar,r,tsim)
        = outscale * MacroOutput("%SimAff%",ResumeVar,r,tsim) ;

    MacroOutput("%SimAff%","Employment",r,tsim) = sum((l,z), m_ETPT(r,l,z,tsim)) ;
    MacroOutput("%SimAff%","GDP per capita",r,tsim) $ m_true1(POP,r,tsim)
        = MacroOutput("%SimAff%","Real GDP",r,tsim)
        / [m_true1(POP,r,tsim)/popScale] ;

* EITE informations

    MacroOutput("%SimAff%","Gross output of EITE industries",r,tsim)
        = sum(EITEa,out_Gross_output("abs","real",r,EITEa,tsim));
    MacroOutput("%SimAff%","Production cost EITE industries",r,tsim)
        $ sum(EITEa,out_Gross_output("abs","real",r,EITEa,tsim))
        = sum(EITEa,out_Gross_output("abs","nominal",r,EITEa,tsim))
        / sum(EITEa,out_Gross_output("abs","real",r,EITEa,tsim))  ;
    MacroOutput("%SimAff%","CO2 emissions EITE industries",r,tsim)
        = EmiOutput("%SimAff%","CO2 emissions EITE industries",r,"EITE",tsim);
    MacroOutput("%SimAff%","Shadow price of renewable constraint",r,tsim)
        = FospCShadowPrice.l(r,tsim) / sum(elyi,m_true2(ppow,r,elyi,tsim));
    MacroOutput("%SimAff%","Market shares of EITE industries",rp,tsim)
        $ sum((EITEi,r,rp.local), m_true3(pwe,rp,EITEi,r,tsim) * m_true3(xw,rp,EITEi,r,tsim))
        = sum((EITEi,r), m_true3(pwe,rp,EITEi,r,tsim) * m_true3(xw,rp,EITEi,r,tsim))
        / sum((EITEi,r,rp.local), m_true3(pwe,rp,EITEi,r,tsim) * m_true3(xw,rp,EITEi,r,tsim)) ;

*   Energy Security

    MacroOutput("%SimAff%","OLG: imports (Mtoe)",r,tsim)
        = [  sum((GASi,aa), nrj_mtoe_m(r,GASi,aa,tsim))
           + sum((OILi,aa), nrj_mtoe_m(r,OILi,aa,tsim))] / escale ;
    MacroOutput("%SimAff%","OLG: domestic (Mtoe)",r,tsim)
        = [  sum((GASi,aa), nrj_mtoe_d(r,GASi,aa,tsim))
           + sum((OILi,aa), nrj_mtoe_d(r,OILi,aa,tsim))] / escale ;
    MacroOutput("%SimAff%","Coal: imports (Mtoe)",r,tsim)
        = sum((COAi,aa), nrj_mtoe_m(r,COAi,aa,tsim)) / escale ;
    MacroOutput("%SimAff%","Coal: domestic (Mtoe)",r,tsim)
        = sum((COAi,aa), nrj_mtoe_d(r,COAi,aa,tsim)) / escale ;
    MacroOutput("%SimAff%","Electricity: imports (Mtoe)",r,tsim)
        = sum((ELYi,aa), nrj_mtoe_m(r,ELYi,aa,tsim)) / escale ;
    MacroOutput("%SimAff%","Electricity: domestic (Mtoe)",r,tsim)
        = sum((ELYi,aa), nrj_mtoe_d(r,ELYi,aa,tsim)) / escale ;

* Prices index

    LOOP(h,
        MacroOutput("%SimAff%","CPI",r,tsim) = PI0_xc.l(r,h,tsim) ;
        MacroOutput("%SimAff%","Household income (real)",r,tsim)
            = m_true1(yd,r,tsim) / PI0_xc.l(r,h,tsim) ;
    ) ;

    MacroOutput("%SimAff%","GDP Deflator",r,tsim) = m_true1(pgdpmp,r,tsim) ;

    MacroOutput("%SimAff%","Emission per capita",r,tsim) $ m_true1(POP,r,tsim)
        = sum(AllGHG,EmiOutput("%SimAff%","emiTot",r,AllGHG,tsim))
        / [m_true1(POP,r,tsim)/popScale] ;

    LOOP(CO2,
        MacroOutput("%SimAff%","CO2 Emission intensity",r,tsim)
            $ MacroOutput("%SimAff%","Real GDP",r,tsim)
            = EmiOutput("%SimAff%","emiTot",r,CO2,tsim)
            / MacroOutput("%SimAff%","Real GDP",r,tsim) ;

        MacroOutput("%SimAff%","CO2 emissions (excl. lulucf)",r,tsim)
            = EmiOutput("%SimAff%","emiTot (excl. lulucf)",r,CO2,tsim) ;
    ) ;

* Policy outcomes

    MacroOutput("%SimAff%","trg",r,tsim)     = outscale * trg.l(r,tsim) ;
    MacroOutput("%SimAff%","kappah",r,tsim)  = kappah.l(r,tsim) ;
    MacroOutput("%SimAff%","kappal",r,tsim)  = sum(l,kappal.l(r,l,tsim)) ;
    MacroOutput("%SimAff%","chiVAT",r,tsim)  = chiVAT.l(r,tsim)  ;
    MacroOutput("%SimAff%","chiPtax",r,tsim) = chiPtax.l(r,tsim) ;

*------------------------------------------------------------------------------*
*					   Filling Energy Security indicators    				   *
*------------------------------------------------------------------------------*

* memo
*   Export FOB
*   Imports CIF
*   Absorption agent price

* memo: gdp: import CIF -- et xa(r,i,fdc,t) with PA_SUB (ie agent price)
* pa.l(r,i,aa,tsim) donc XAPT(r,i,aa,%1) m_true3(pa,i,aa,tsim)

* Memo here trade flows, Export means at export price and Import at import Prices

    IF(IfOutNrgSecurity,

        LOOP(t0,

            NrgSecurity("%SimAff%","Export","real",e,r,rp,tsim)
                = outscale * m_true3(pwe,r,e,rp,t0)
                * m_true3(xw,r,e,rp,tsim) ;
            NrgSecurity("%SimAff%","Import","real",e,r,rp,tsim)
                = outscale * m_true3(pwm,r,e,rp,t0) * lambdaw(r,e,rp,tsim)
                * m_true3(xw,r,e,rp,tsim) ;
            NrgSecurity("%SimAff%","Absorption","real",e,r,r,tsim)
                = sum(aa,XAPT(r,e,aa,tsim) * m_true3(pa,r,e,aa,t0) ) ;
            NrgSecurity("%SimAff%","Supply","real",e,r,r,tsim)
                = outscale * m_true2(xs,r,e,tsim) * m_true2(ps,r,e,t0);
        ) ;

        NrgSecurity("%SimAff%","Export","nominal",e,r,rp,tsim)
            = outscale * m_true3(pwe,r,e,rp,tsim)
            * m_true3(xw,r,e,rp,tsim) ;
        NrgSecurity("%SimAff%","Import","nominal",e,r,rp,tsim)
            = outscale * m_true3(pwm,r,e,rp,tsim) * lambdaw(r,e,rp,tsim)
            * m_true3(xw,r,e,rp,tsim) ;
        NrgSecurity("%SimAff%","Absorption","nominal",e,r,r,tsim)
            = sum(aa, XAPT(r,e,aa,tsim) * m_true3(pa,r,e,aa,tsim)) ;

        NrgSecurity("%SimAff%","CIF price","nominal",e,r,rp,tsim)
            = m_true3(pwm,r,e,rp,tsim) ;

        NrgSecurity("%SimAff%","Export","volume",e,r,rp,tsim)
            = nrj_mtoe_xw(r,e,rp,tsim) / eScale ;
        NrgSecurity("%SimAff%","Absorption","volume",e,r,r,tsim)
            = sum(aa, nrj_mtoe(r,e,aa,tsim)) / eScale ;
        NrgSecurity("%SimAff%","Supply","nominal",e,r,r,tsim)
            = outscale * m_true2(xs,r,e,tsim) * m_true2(ps,r,e,tsim);

    ) ;

*   Check the carbon Policy in Final year --> all t

    IF(1 and year eq finalYear,

        emiCap.fx(rq,EmSingle,t) $ emiCap0(rq,EmSingle)
            = m_true2(emiCap,rq,EmSingle,t) / cscale;
        emiTot.fx(r,em,t) $ emiTot0(r,em)  = m_true2(emiTot,r,em,t) / cscale ;
        emiCapFull.fx(rq,t)    = m_true1(emiCapFull,rq,t) / cscale ;
        emiTot.fx(r,AllGHG,t)  = sum(EmSingle, emiTot.l(r,EmSingle,t))  ;
        emiCap.fx(rq,AllGHG,t) = sum(EmSingle, emiCap.l(rq,EmSingle,t)) ;

        EXECUTE_UNLOAD "%cFile%_CarbonPolicy_Final.gdx",
            part, rq, IfCap, emFlag, IfAllowance, stringency,
            emiCap.l, emiCapFull.l, emitot.l, AffCapTg,
            EMITAXT, EffectiveCarbonPrice, AverageCarbonPrice ;

        emiCap.fx(rq,em,t) $ emiCap0(rq,em)
            = cscale * emiCap.l(rq,em,t) / emiCap0(rq,em);
        emiTot.fx(r,em,t)  $ emiTot0(r,em)
            = cscale * emiTot.l(r,em,t) / emiTot0(r,em);
        emiCapFull.fx(rq,t) $ emiCapFull0(rq)
            = emiCapFull.l(rq,t) * cscale  / emiCapFull0(rq);
    ) ;

    $$Offdotl

$EndIf.SamResOut

*------------------------------------------------------------------------------*
*   Unload instructions : read in "%ModelDir%\10-PostSimInstructions.gms"      *
*------------------------------------------------------------------------------*

$IfTheni.postsimResOut %ResOutStep%=="10-PostSimInstructions"

    $$IfTheni.CalNrg %cal_NRG%=="ON"

* Normalize to compare (do not work in the loop: WHY?)

    LOOP(t0,

        EnergyDemand("Target","Energy Demand",r,i,aa,t)
            $ EnergyDemand("Target","Energy Demand",r,i,aa,t0)
            = EnergyDemand("Target","Energy Demand",r,i,aa,t)
            * EnergyDemand("%SimAff%","Energy Demand",r,i,aa,t0)
            / EnergyDemand("Target","Energy Demand",r,i,aa,t0) ;

        EnergyDemand("Target","Energy Demand","EU",i,aa,t)
            $ EnergyDemand("Target","Energy Demand","EU",i,aa,t0)
            = EnergyDemand("Target","Energy Demand","EU",i,aa,t)
            * EnergyDemand("%SimAff%","Energy Demand","EU",i,aa,t0)
            / EnergyDemand("Target","Energy Demand","EU",i,aa,t0) ;

		FossilMarket("Target","Supply",i,ra,t)
			$ FossilMarket("Target","Supply",i,ra,t0)
			= FossilMarket("Target","Supply",i,ra,t)
			* FossilMarket("%SimAff%","Supply",i,ra,t0)
			/ FossilMarket("Target","Supply",i,ra,t0);

		ElyOutput("Target","Electricity Supply: xs(elyi)",r,elyi,t)
			$ ElyOutput("Target","Electricity Supply: xs(elyi)",r,elyi,t0)
			= ElyOutput("Target","Electricity Supply: xs(elyi)",r,elyi,t)
			* ElyOutput("%SimAff%","Electricity Supply: xs(elyi)",r,elyi,t0)
			/ ElyOutput("Target","Electricity Supply: xs(elyi)",r,elyi,t0) ;

*	Calibration price start in 2016

        EnergyDemand("Target","Energy Agent Price",ra,i,h,t)
            $ EnergyDemand("Target","Energy Agent Price",ra,i,h,"2015")
            = EnergyDemand("Target","Energy Agent Price",ra,i,h,t)
            * EnergyDemand("%SimAff%","Energy Agent Price",ra,i,h,"2015")
            / EnergyDemand("Target","Energy Agent Price",ra,i,h,"2015") ;

        FossilMarket("Target","Supply Price",ei,ra,t)
            $ FossilMarket("Target","Supply Price",ei,ra,"2015")
            = FossilMarket("Target","Supply Price",ei,ra,t)
            * FossilMarket("%SimAff%","Supply Price",ei,ra,"2015")
            / FossilMarket("Target","Supply Price",ei,ra,"2015") ;

		FossilMarket("Target","CIF price",ei,WLD,t)
			$ FossilMarket("Target","CIF price",ei,WLD,"2015")
			= FossilMarket("Target","CIF price",ei,WLD,t)
			* FossilMarket("%SimAff%","CIF price",ei,WLD,"2015")
			/ FossilMarket("Target","CIF price",ei,WLD,"2015") ;

		FossilMarket("Target","Supply Price",ei,WLD,t)
			$ FossilMarket("Target","Supply Price",ei,WLD,"2015")
			= FossilMarket("Target","Supply Price",ei,WLD,t)
			* FossilMarket("%SimAff%","Supply Price",ei,WLD,"2015")
			/ FossilMarket("Target","Supply Price",ei,WLD,"2015") ;

    ) ;
    $$EndIf.CalNrg

    $$IfTheni.checkInv %PolicyFile%=="PubInv"
        CheckExtraInv("kTax",r,a,v,t)
            $ (ifExokv(r,a,v) eq 1) = kTax.l(r,a,v,t) ;
        CheckExtraInv("ShadowPrice",r,a,v,t)
            $ (ifExokv(r,a,v) eq 2) = pkpShadowPrice.l(r,a,v,t)  ;
        CheckExtraInv("bau",r,a,v,t)  $ (NOT ifExokv(r,a,v)) = 0 ;
        CheckExtraInv("icpf",r,a,v,t) $ (NOT ifExokv(r,a,v)) = 0 ;
        CheckExtraInv("pol",r,a,v,t) $ ifExokv(r,a,v)
            = outscale * kv.l(r,a,v,t) * kv0(r,a);
    $$EndIf.checkInv

    $$If NOT DEXIST "%oDir%\ResumeOutput" EXECUTE_UNLOAD "%oDir%\ResumeOutput_%SimName%.gdx",
    $$If     DEXIST "%oDir%\ResumeOutput" EXECUTE_UNLOAD "%oDir%\ResumeOutput\ResumeOutput_%SimName%.gdx",
        EnergyDemand, FossilMarket, MacroOutput,
        $$Ifi %PolicyFile%=="PubInv" CheckExtraInv,
        EmiOutput, ElyOutput, AffCapTg ;

    IF(IfOutNrgSecurity,
        $$If NOT DEXIST "%oDir%\ResumeOutput" EXECUTE_UNLOAD "%oDir%\NrgSecurity_%SimName%.gdx",
        $$If     DEXIST "%oDir%\ResumeOutput" EXECUTE_UNLOAD "%oDir%\ResumeOutput\NrgSecurity_%SimName%.gdx",
            NrgSecurity ;
    ) ;

    $$IFTheni.BCAon %BCA_policy%=="ON"
        LOOP(t0,
            AGG_tariffs(r,i,t) = AGG_tariffs(r,i,t)   - AGG_tariffs(r,i,t0) ;
            AGG_exportsub(r,i,t)
                = AGG_exportsub(r,i,t) - AGG_exportsub(r,i,t0) ;
            AGG_tariffs(r,i,t)   $ (NOT BCAFlag(r,i)) = 0 ;
            AGG_exportsub(r,i,t) $ (NOT BCAFlag(r,i)) = 0 ;
        ) ;
        EXECUTE_UNLOAD "%cFile%_BCAlevel_%EndTimeLoop%.gdx",  mtax0,
            AGG_tariffs, AGG_exportsub ;
    $$Endif.BCAon

*	Do not keep the output generated by this File in the main unloaded file

	OPTION kill=AffCapTg, kill=ElyOutput, kill=FossilMarket, kill=NrgSecurity ;
	OPTION kill=EnergyDemand, kill = EmiOutput, kill = MacroOutput ;

$EndIf.postsimResOut
