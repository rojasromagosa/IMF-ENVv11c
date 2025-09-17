$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1: Simulation Procedure
   file name   : "%ModelDir%\24-default_Prm.gms"
   purpose     : Standard parameter declaration
                ENVISAGE: default parameter values
                OECD-ENV: compile parameter declaration here for any %SimType%
   created date: 2021-02-19
   created by  : Jean Chateau from ENVISAGE
   called by   : "%ModelDir%\2-CommonIns.gms"
--------------------------------------------------------------------------------
      $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/24-default_Prm.gms $
   last changed revision: $Rev: 518 $
   last changed date    : $Date:: 2024-02-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

set v0 "orginel vintages" / Old, New / ;

*------------------------------------------------------------------------------*
*                  OECD-ENV assumptions / section                              *
*------------------------------------------------------------------------------*

PARAMETERS

* --> IfNrgNest is now agent specific and declared here

    IfNrgNest(r,aa) "Set 1 to split Energy Bundle vs Set 0 for an unique bundle"
    IfSavfEQ(r)     "Set 1 to activate Savfeq and make savf endogenous"
    Ifksav(r,k,h)   "Set to 1 if corresponding mpc(k) is adjusted to match savings (calibration mode)"

;

IfNrgNest(r,aa) $ (Not tota(aa)) = 1; !! IfNrgNest(r,aa) for ENVISAGE ?

* the following assumptions are useless because NRG bundle for these activities are not modelled

IfNrgNest(r,gov)   = 0;
IfNrgNest(r,inv)   = 0;
IfNrgNest(r,"tmg") = 0;

* Flag to make or not Savf endogenous

IF(IfDyn,
    ifSavfEQ(r) = 0 ;
ELSE
    ifSavfEQ(r) = 1 ;
) ;

ifksav(r,k,h) = 1 ;

PARAMETERS

	emiTax_ref(r,AllEmissions,t)
	AdjDepr(r,a)

*	Memo these targets also act as activation flags for equations

	RenewTgt(r,tt)          "Electricity Power: Renewable target"
    emia_IntTgt(r,aa,AllEmissions,tt) "Target on sectoral emissions or sectoral intensity"

;

AdjDepr(r,a) = 1 ;
RenewTgt(r,tt) 					  = 0 ;
emia_IntTgt(r,aa,AllEmissions,tt) = 0 ;

SCALAR IfMcpCapEq "Set to 1 to use MCP equation for endogenous CT" / 0 / ;


PARAMETERS
    xp0_TWh(r,a)            "Electricity Generation in %YearStart%  (TWh)" !! j'ai verifie on a bien comme dans EEB
    pMwh0(r,a)              "Marginal Cost of Power-generation (%YearStart% USD per MWh)"
    ConvertCurToModelUSD(t) "Factor to convert t-USD to %YearBaseMER%-USD (ie model base year)"
    etawl(r,l)              "Labour supply elasticity, by skill (for variant cases)"
    GovBalance(r)           "Choose Endogenous variable to insure government budget balance"
    CurBalance(r)           "Choose semi-endogenous Exchange rate vs CA"
    CrowdingOut(r,aa)       "Set from 0 (e.g. full crowding out) to 1"
    WageIndexRule(r)        "Rule of Wage indexation"
    xpFlagT(r,a,t)  	    "Flag avant simulations"
    implicit_frisch(r,h,t)
;

ConvertCurToModelUSD(t) = 1 ;

*   Labor supply elasticity

etawl(r,l) = 0 ;

IF(Not ifCal,

* Endogenous LFPR in variant Mode

***HRR: region hard coded, these sets are defined in /inputFiles/specific_sets.gms
$ontext
	etawl(OECD,l)    = 0.15;
	etawl(NOTOECD,l) = 0.20;


	etawl(OAF,l) 	 = 0.10;
	etawl(IDN,l) 	 = 0.10;
$offtext
***HRR: values used in previous CGE papers was 0.2; check latest literature
etawl(r,l) = 0.2;
***endHRR

* BATCH Mode

    $$IF SET elastLab etawl(r,l) = %elastLab%;

) ;

*    "Wage rule: Indexation type" --> det Labour supply

$OnText
       .   WageIndexRule = 0: aggregate net-wage
       (including personal and corporate taxation) / base case
       .   WageIndexRule = 1: aggregate net-wage income minus kappah
       .   WageIndexRule = 2: average income (eg. unemployment taken into account)
       .   WageIndexRule = 3: aggregate wage not including personal taxation (paid by firm)
       .   WageIndexRule =-1: aggregate gross-wage
$OffText

WageIndexRule(r) = 0;

*   Change closure rule to insure that government budget is balanced

$OnText
   closure rule flag is "GovBalance(r)"
   Variable adusted according to the value chosen for GovBalance(r)
   .  = 0 -->  Households income tax rate is endogenous: kappah(r,t)
   .           DEFAULT closure rule for baseline in calibration mode
   .  = 1 -->  real government savings is endogenous: rsg(r,t)
   .  = 2 -->  Households lump-sum transfer is endogenous: trg(r,t)
   .           DEFAULT closure rule in variant mode
   .  = 3 -->  Households labour income tax rate is endogenous: kappafp(r,l,t)
   .  = 4 -->  Another variable is endogenous: chiVAT.l
$OffText

GovBalance(r) = 0;

*	Default full crowding-out [Inactive]

CrowdingOut(r,aa) = 0 ;


* [TBC]	By default activate semi-endogenous Exchange rate vs CA in variant

CurBalance(r) = 0 ;
***Hrr: hard coded, check how important these values are?
$ontext
IF(0 AND ifDyn and (not ifCal),
    CurBalance(OECD)    = 0.1  ;
    CurBalance(NOTOECD) = 0.15 ;
    CurBalance(OAF)     = 0.1  ;
    CurBalance(OPEP)    = 0.015;
    CurBalance(TransE)  = 0.015;
) ;
$offtext
***endHRR

*------------------------------------------------------------------------------*
*   If no specific file need to put some Dvm's assumptions about labHyp [TBU]  *
*------------------------------------------------------------------------------*

*$IF NOT EXIST "%ProjectDir%\project_instructions.gms" $include "%subFoldername%\02-DvM_specific_parameters.gms"

*------------------------------------------------------------------------------*
*						[ENVISAGE] section			                           *
*------------------------------------------------------------------------------*

Scalars
    year                 "Current year"
    work                 "Working scalar"
    tvol                 "Total volume working scalar"
    tprice               "Total price working scalar"
    vol                  "Volume working scalar"
    price                "Price working scalar"
;

parameters

*    working vectors

    rwork(r)             "Regional working vector"
    rwork_bis(r)
    rawork(ra)
    raworkT(ra,t)
    rworkT(r,tt)
    raagtwork(ra,aa,t)
    risjswork(r,is,js)
    riswork(r,is)
    riswork2(r,is)
    riswork3(r,is)
    risworkT(r,is,tt)
    risjsworkt(r,is,js,t)
    riskwork(r,is,k)
    rworka(is)
    rTot(t)

    TgtVar(r)       "Target variable (GDP)"

    popg(r)             "Regional population (GTAP)"

*  Production elasticities

   sigmaxp0(r,a,v0)       "Substitution elasticity between production and non-CO2 GHG bundle"
   sigmap0(r,a,v0)         "CES between ND1 and VA"
   sigmav0(r,a,v0)         "CES between LAB1 and VA1 in crops and other, VA1 and VA2 in livestock"
   sigmav10(r,a,v0)        "CES between ND2 (fert) and VA2 in crops, LAB1 and KEF in livestock and land and KEF in other"
   sigmav20(r,a,v0)        "CES between land and KEF in crops, land and ND2 (feed) in livestock. Not used in other"
   sigmakef0(r,a,v0)       "CES between KF and NRG"
   sigmakf0(r,a,v0)        "CES between KSW and NRF"
   sigmakw0(r,a,v0)        "CES between KS and XWAT"
   sigmak0(r,a,v0)         "CES between LAB2 and K"
   sigmaul0(r,a)           "CES across unskilled labor"
   sigmasl0(r,a)           "CES across skilled labor"
   sigman10(r,a)           "CES across intermediate demand in ND1 bundle"
   sigman20(r,a)           "CES across intermediate demand in ND2 bundle"
   sigmawat0(r,a)          "CES across intermediate demand in WAT bundle"
   sigmae0(r,a,v0)         "CES between ELY and NELY in energy bundle"
   sigmanely0(r,a,v0)      "CES between COA and OLG in energy bundle"
   sigmaolg0(r,a,v0)       "CES between OIL and GAS in energy bundle"
   sigmaNRG0(r,a,NRG,v0)   "CES within each of the NRG bundles"

*  Make matrix elasticities (incl. power)

   omegas0(r,a)            "Make matrix transformation elasticities: one activity --> many commodities"
   sigmas0(r,i)            "Make matrix substitution elasticities: one commodity produced by many activities"
   sigmael0(r,elyi)        "Substitution between power and distribution and transmission"
   sigmapow0(r,elyi)       "Substitution across power bundles"
   sigmapb0(r,pb,elyi)     "Substitution across power activities within power bundles"

*  Final demand elasticities

   incElas0(k,r)           "Income elasticities"
   eh0(k,r)                "CDE expansion parameter"
   bh0(k,r)                "CDE substitution parameter"
   nu0(r,k,h)              "Elasticity of subsitution between energy and non-energy bundles in HH consumption"
   nunnrg0(r,k,h)          "Substitution elasticity across non-energy commodities in the non-energy bundle"
   nue0(r,k,h)             "Substitution elasticity between ELY and NELY bundle"
   nunely0(r,k,h)          "Substitution elasticity beteen COL and OLG bundle"
   nuolg0(r,k,h)           "Substitution elasticity between OIL and GAS bundle"
   nuNRG0(r,k,h,NRG)       "Substitution elasticity within NRG bundles"
   sigmafd0(r,fd)          "CES expenditure elasticity for other final demand"

*  Trade elasticities

   sigmamt0(r,i)           "Top level Armington elasticity"
   sigmaw0(r,i)            "Second level Armington elasticity"
   omegax0(r,i)            "Top level CET export elasticity"
   omegaw0(r,i)            "Second level CET export elasticity"
   sigmamg0(img)           "CES 'Make' elasticity for intl. trade and transport services"

*  Factor supply elasticities

* [EditJean]: 2024-02-07 LandMax0(r) here is useless, only need LandMax00(r)

   omegak0(r)              "CET capital mobility elasticity in comp. stat. model"
   etat0(r)                "Aggregate land supply elasticity"
   landMax00(r)            "Initial ratio of land maximum wrt to land use"
   omegat0(r)              "Land elasticity between intermed. land bundle and first land bundle"
   omeganlb0(r)            "Land elasticity across intermediate land bundles"
   omegalb0(r,lb)          "Land elasticity within land bundles"

   etanrf0(r,a)            "Base Natural resource supply elasticity"

   etaw0(r)                "Supply elasticity of aggregate water"
   H2OMax00(r)             "Maximum water supply"
   omegaw10(r)             "Top level water CET elasticity"
   omegaw20(r,wbnd)        "Second/third level water CET elasticities"
   epsh2obnd0(r,wbnd)      "Price elasticity of demand for water bundles"
   epsh2obnd0(r,wbnd)      "Price elasticity of demand for water bundles"
   etah2obnd0(r,wbnd)      "Water bundle demand scale elasticity"

   invElas0(r,a)           "Dis-investment elasticity"

   epsRor0(r,t)            "Elasticity of expected rate-of-return"

   omegam0(r,l)            "Elasticity of migration"

   esubd(i0)
   esubm(i0)
   incpar(i0,r)
   subpar(i0,r)
   etanrfx0(r,a0,lh)

   cap_out_Ratio0(r) "ENVISAGE calibration: Initial Capital stock to GDP ratio"
   invTarget0(r,tt)  "ENVISAGE calibration"
;

*   Load the GTAP model parameter file for household preference calibration

execute_loaddc "%iDataDir%\agg\%Prefix%PAR.gdx",  esubd, esubm, incpar, subpar ;

*  Read in the base elasticities (useless for PostProcedure)

execute_loaddc "%iDataDir%\agg\%Prefix%Prm.gdx"
	sigmaxp0,  sigmap0, sigman10, sigman20, sigmawat0,
	sigmav0,   sigmav10, sigmav20,
	sigmakef0, sigmakf0, sigmakw0, sigmak0,
	sigmaul0,  sigmasl0,
	sigmae0,   sigmanely0, sigmaolg0, sigmaNRG0,
	omegas0,   sigmas0, sigmafd0,
	sigmael0,  sigmapow0, sigmapb0,
	incElas0,  eh0, bh0, nu0, nunnrg0,
	nue0, nunely0, nuolg0, nuNRG0,
	sigmamt0=sigmam0, sigmaw0, omegax0, omegaw0, sigmamg0
	omegak0, invElas0, etat0, landMax00,
	omegat0, omeganlb0, omegalb0,
  	etanrf0, omegam0
;


IF(NOT IfENVLPrm,

*------------------------------------------------------------------------------*
*  Overrides ENV-Linkages values with ENVISAGE values (ie for IfENVLPrm = 0)   *
*------------------------------------------------------------------------------*

	LOOP(a $ (not tota(a)),
		sigmaxp0(r,a,v0) = 0 ;
		sigmap0(r,a,v0)  = 0 ;
		sigmav0(r,a,"Old")       = 0.12 $ (not ea(a)) + 0 $ ea(a) ;
		sigmav0(r,a,"New")       = 1.01 $ (not ea(a)) + 0 $ ea(a) ;
		sigmav10(r,a,"Old")      = 0.12 $ (not ea(a)) + 0 $ ea(a) ;
		sigmav10(r,a,"New")      = 1.01 $ (not ea(a)) + 0 $ ea(a) ;
		sigmav20(r,a,"Old")      = 0.12 $ (not ea(a)) + 0 $ ea(a) ;
		sigmav20(r,a,"New")      = 1.01 $ (not ea(a)) + 0 $ ea(a) ;
		sigmakef0(r,a,"Old")     = 0    $ (not ea(a)) + 0 $ ea(a) ;
		sigmakef0(r,a,"New")     = 0.80 $ (not ea(a)) + 0 $ ea(a) ;
		sigmakf0(r,a,"Old")      = 0.25 $ (not ea(a)) + 0.25 $ ea(a) ;
		sigmakf0(r,a,"New")      = 0.25 $ (not ea(a)) + 0.25 $ ea(a) ;
		sigmakw0(r,a,"Old")      = 0.10 $ (not ea(a)) + 0 $ ea(a) ;
		sigmakw0(r,a,"New")      = 0.10 $ (not ea(a)) + 0 $ ea(a) ;
		sigmak0(r,a,"Old")       = 0.12 $ (not ea(a)) + 0 $ ea(a) ;
		sigmak0(r,a,"New")       = 1.01 $ (not ea(a)) + 0 $ ea(a) ;
		sigmaul0(r,a)            = 0.5 ;
		sigmasl0(r,a)            = 0.5 ;
		sigman10(r,a)            = 0.0 ;
		sigman20(r,a)            = 0.5 ;
		sigmawat0(r,a)           = 0.0 ;
		sigmae0(r,a,"Old")       = 0.25 $ (not ea(a)) + 0 $ ea(a) ;
		sigmae0(r,a,"New")       = 2.00 $ (not ea(a)) + 0 $ ea(a) ;
		sigmanely0(r,a,"Old")    = 0.25 $ (not ea(a)) + 0 $ ea(a) ;
		sigmanely0(r,a,"New")    = 2.00 $ (not ea(a)) + 0 $ ea(a) ;
		sigmaolg0(r,a,"Old")     = 0.25 $ (not ea(a)) + 0 $ ea(a) ;
		sigmaolg0(r,a,"New")     = 2.00 $ (not ea(a)) + 0 $ ea(a) ;
		sigmaNRG0(r,a,NRG,"Old") = 0.25 $ (not ea(a)) + 0 $ ea(a) ;
		sigmaNRG0(r,a,NRG,"New") = 2.00 $ (not ea(a)) + 0 $ ea(a) ;
	) ;

	sigmael0(r,elyi)    = 0 ;
	sigmapow0(r,elyi)   = 3.5 ;
	sigmapb0(r,pb,elyi) $ (NOT Allpb(pb)) = 3.5 ;

* [EditJean] Default elasticities for Dynamic calibration

	IF(IfDyn and IfCal,

		sigmapb0(r,pb,elyi) $ (NOT Allpb(pb)) = 1.2 ;
		sigmapow0(r,elyi) = 1.1 ;

	) ;

*	sigmal10(r,a)   = sigmaul0(r,a) ;
*	sigmal20(r,a)   = sigmasl0(r,a) ;
*	sigmal0(r,wb,a) = sigmaul0(r,a) ;

* #TODO logically eq 1 for ENVISAGE but does not work
	IfNrgNest(r,h) = 0 ;

	nue0(r,k,h)       = 1.2 ;
	nunely0(r,k,h)    = nue0(r,k,h) ;
	nuolg0(r,k,h)     = nue0(r,k,h) ;
	nuNRG0(r,k,h,NRG) = nue0(r,k,h) ;

	IF(0,

* In dominique's program --> pb

		etanrfx0(r,a0,"lo") = 2 ;
		etanrfx0(r,a0,"hi") = 1 ;

	ELSE

* this is working

		etanrfx0(r,a0,lh) = sum(mapa0(a0,a), etanrf0(r,a));

	) ;

*	Not for standard model

	IF(0,
		omegax0(r,i) = 3 ;
		omegaw0(r,i) = 6 ;
		LOOP(COAi,
			omegax0(r,ELYi)  = omegax0(r,COAi) ;
			omegaw0(r,ELYi)  = omegaw0(r,COAi) ;
		) ;
	ELSE
		omegax0(r,i) = inf ;
		omegaw0(r,i) = inf ;
	) ;

	sigmamt0(r,ELYi) = 2.0 ;
	sigmaw0(r,ELYi)  = 2.0 ;

ELSE

*------------------------------------------------------------------------------*
*  		Overrides ENV-Linkages values with OECD-ENV (IfENVLPrm > 0)			   *
*------------------------------------------------------------------------------*

*	etanrfx0: Fixed bounds Endogenous supply elasticities of natural resource

*[TBU]: Logiquement revoir ca mais comme matrice a/a0 est diagnonale pour NatRes
* pour le moment ne pose pas de problemes

	etanrfx0(r,a0,lh) = sum(mapa0(a0,a), etanrf0(r,a));

*   Activate endogenous etanrf.l

	IF(IfEndoEtanrf,
		etanrfx0(r,a0,"lo") = (4 / 3) * etanrfx0(r,a0,"lo");
		etanrfx0(r,a0,"hi") = (2 / 3) * etanrfx0(r,a0,"hi");
	) ;

) ;


*  !!!! NEW WATER PARAMETERS NEED TO BE INCLUDED IN AGGREGATION

etaw0(r)            = 1 ;
H2OMax00(r)         = 2 ;
omegaw10(r)         = 1 ;
omegaw20(r,wbnd)    = 2 ;
epsh2obnd0(r,wbnd)  = 1 ;
etah2obnd0(r,wbnd)  = 1 ;

epsRor0(r,t) = 10 ;

*------------------------------------------------------------------------------*
*		Declare parameters for Model aggregation and assign values      	   *
*------------------------------------------------------------------------------*

parameters

*  Production elasticities

   sigmaxp(r,a,v)          "CES between GHG and XP"
   sigmap(r,a,v)           "CES between ND1 and VA"
   sigmav(r,a,v)           "CES between LAB1 and VA1 in crops and other, VA1 and VA2 in livestock"
   sigmav1(r,a,v)          "CES between ND2 (fert) and VA2 in crops, LAB1 and KEF in livestock and land and KEF in other"
   sigmav2(r,a,v)          "CES between land and KEF in crops, land and ND2 (feed) in livestock. Not used in other"
   sigmakef(r,a,v)         "CES between KF and NRG"
   sigmakf(r,a,v)          "CES between KSW and NRF"
   sigmakw(r,a,v)          "CES between KS and XWAT"
   sigmak(r,a,v)           "CES between LAB2 and K"
   sigmaul(r,a)            "CES across unskilled labor"
   sigmasl(r,a)            "CES across skilled labor"
   sigman1(r,a)            "CES across intermediate demand in ND1 bundle"
   sigman2(r,a)            "CES across intermediate demand in ND2 bundle"
   sigmawat(r,a)           "CES across intermediate demand in XWAT bundle"
   sigmae(r,a,v)           "CES between ELY and NELY in energy bundle"
   sigmanely(r,a,v)        "CES between COA and OLG in energy bundle"
   sigmaolg(r,a,v)         "CES between OIL and GAS in energy bundle"
   sigmaNRG(r,a,NRG,v)     "CES within each of the NRG bundles"
   sigmaemi(r,a,v)         "CES across GHG"

*  Make matrix elasticities (incl. power)

   omegas(r,a)             "Make matrix transformation elasticities: one activity --> many commodities"
   sigmas(r,i)             "Make matrix substitution elasticities: one commodity produced by many activities"
   sigmael(r,elyi)         "Substitution between power and distribution and transmission"
   sigmapow(r,elyi)        "Substitution across power bundles"
   sigmapb(r,pb,elyi)      "Substitution across power activities within power bundles"

*  Final demand elasticities

   incElas(k,r)            "Income elasticities"
   nu(r,k,h)               "Elasticity of subsitution between energy and non-energy bundles in HH consumption"
   nunnrg(r,k,h)           "Substitution elasticity across non-energy commodities in the non-energy bundle"
   nue(r,k,h)              "Substitution elasticity between ELY and NELY bundle"
   nunely(r,k,h)           "Substitution elasticity beteen COL and OLG bundle"
   nuolg(r,k,h)            "Substitution elasticity between OIL and GAS bundle"
   nuNRG(r,k,h,NRG)        "Substitution elasticity within NRG bundles"
   sigmafd(r,fd)           "CES expenditure elasticity for other final demand"

*  Trade elasticities

   sigmamt(r,i)            "Top level Armington elasticity"
   sigmam(r,i,aa)          "Top level Armington elasticity by agent"
   sigmaw(r,i)             "Second level Armington elasticity"
   omegax(r,i)             "Top level CET export elasticity"
   omegaw(r,i)             "Second level CET export elasticity"
   sigmamg(img)            "CES 'Make' elasticity for intl. trade and transport services"

*  Factor supply elasticities

   omegak(r)               "CET capital mobility elasticity in comp. stat. model"
   etat(r)                 "Aggregate land supply elasticity"
   omegat(r)               "Land elasticity between intermed. land bundle and first land bundle"
   omeganlb(r)             "Land elasticity across intermediate land bundles"
   omegalb(r,lb)           "Land elasticity within land bundles"

   etaw(r)                 "Supply elasticity of aggregate water"
   H2OMax0(r)              "Maximum water supply"
   omegaw1(r)              "Top level water CET elasticity"
   omegaw2(r,wbnd)         "Second/third level water CET elasticities"
   epsh2obnd(r,wbnd)       "Price elasticity of demand for water bundles"
   etah2obnd(r,wbnd)       "Water bundle demand scale elasticity"

   invElas(r,a)            "Dis-investment elasticity"

   epsRor(r,t)             "Elasticity of expected rate of return"

   omegam(r,l)             "Elasticity of migration"
;

*	User set parameters

PARAMETER

    wgt(v,v0)       "Weight matrix"
    deprT(r,t)      "GTAP depreciation rate"

*  Introduce twist assumptions

    twt1(r,i,t)     "Twist parameter for top level national sourcing"
    tw1(r,i,aa,t)   "Twist parameter for top level agent sourcing"
    tw2(r,i,t)      "Twist parameter for second level sourcing wrt to targetted countries"

    twtpb(r,pb,t)   "Twist parameter for top level agent sourcing"
    twtely(r,a,t)    "Twist parameter for Power"

    pb_ratio(r,pb,t)

    grKMax(r,t)
    grKMin(r,t)
    chigrK(r,t)
    grKTrend(r,t)

    ifLSeg(r,l)      "Labor market segmentation flag"
    uez0(r,l,z)      "Initial level of unemployment by zone"
    migr0(r,l)       "Ratio of rural to urban migration as a share of base year rural labor supply"

    labHyp(r,l,*)

    growth_vint(r,is,a) "Proportionality of growth rate of new to old vintage"

;

growth_vint(r,is,a)    = 1 ;
growth_vint(r,"tot",a) = 1 ;

twtpb(r,pb,t) = 0;

IF(ifvint,

* 1 0
* 0 1

    wgt(v,v0) $ (ord(v) eq ord(v0)) = 1 ;

ELSE

*  For comp stat model, weigh the 'Old' and 'New' elasticities

    wgt("Old","Old") = 0.8 ;
    wgt("Old","New") = 0.2 ;

) ;

* GTAP depreciation rate

deprT(r,t) = 0.04 ;

*$IfTheni.STD NOT SET IfPostProcedure

sigmaxp(r,a,v)       = sum(v0, wgt(v,v0)*sigmaxp0(r,a,v0)) ;
sigmap(r,a,v)        = sum(v0, wgt(v,v0)*sigmap0(r,a,v0)) ;
sigmav(r,a,v)        = sum(v0, wgt(v,v0)*sigmav0(r,a,v0)) ;
sigmav1(r,a,v)       = sum(v0, wgt(v,v0)*sigmav10(r,a,v0)) ;
sigmav2(r,a,v)       = sum(v0, wgt(v,v0)*sigmav20(r,a,v0)) ;
sigmakef(r,a,v)      = sum(v0, wgt(v,v0)*sigmakef0(r,a,v0)) ;
sigmakf(r,a,v)       = sum(v0, wgt(v,v0)*sigmakf0(r,a,v0)) ;
sigmakw(r,a,v)       = sum(v0, wgt(v,v0)*sigmakw0(r,a,v0)) ;
sigmak(r,a,v)        = sum(v0, wgt(v,v0)*sigmak0(r,a,v0)) ;

sigmaul(r,a)         = sigmaul0(r,a) ;
sigmasl(r,a)         = sigmasl0(r,a) ;
sigman1(r,a)         = sigman10(r,a) ;
sigman2(r,a)         = sigman20(r,a) ;
sigmawat(r,a)        = sigmawat0(r,a) ;
sigmae(r,a,v)        = sum(v0, wgt(v,v0)*sigmae0(r,a,v0)) ;
sigmanely(r,a,v)     = sum(v0, wgt(v,v0)*sigmanely0(r,a,v0)) ;
sigmaolg(r,a,v)      = sum(v0, wgt(v,v0)*sigmaolg0(r,a,v0)) ;
sigmaNRG(r,a,NRG,v)  = sum(v0, wgt(v,v0)*sigmaNRG0(r,a,NRG,v0)) ;

omegas(r,a)          = omegas0(r,a) ;
sigmas(r,i)          = sigmas0(r,i) ;
sigmael(r,elyi)      = sigmael0(r,elyi) ;
sigmapow(r,elyi)     = sigmapow0(r,elyi) ;
sigmapb(r,pb,elyi)   = sigmapb0(r,pb,elyi) ;

incElas(k,r)         = incElas0(k,r)  ;
nu(r,k,h)            = nu0(r,k,h) 	  ;
nunnrg(r,k,h)        = nunnrg0(r,k,h) ;
nue(r,k,h)           = nue0(r,k,h)    ;
nunely(r,k,h)        = nunely0(r,k,h) ;
nuolg(r,k,h)         = nuolg0(r,k,h)  ;
nuNRG(r,k,h,NRG)     = nuNRG0(r,k,h,NRG) ;
sigmafd(r,fd)        = sigmafd0(r,fd) ;

* Trade elasticities

sigmamt(r,i)         = sigmamt0(r,i) ;
sigmam(r,i,aa)       = sigmamt0(r,i) ;
sigmaw(r,i)          = sigmaw0(r,i) ;
omegax(r,i)          = omegax0(r,i) ;
omegaw(r,i)          = omegaw0(r,i) ;
sigmamg(img)         = sigmamg0(img) ;

omegak(r)            = omegak0(r) ;
etat(r)              = etat0(r) ;
*landMax0(r)          = landMax00(r) ;
omegat(r)            = omegat0(r) ;
omeganlb(r)          = omeganlb0(r) ;

omegalb(r,lb)        = omegalb0(r,lb) ;

etaw(r)              = etaw0(r) ;
H2OMax0(r)           = H2OMax00(r) ;
omegaw1(r)           = omegaw10(r) ;
omegaw2(r,wbnd)      = omegaw20(r,wbnd) ;
epsh2obnd(r,wbnd)    = epsh2obnd0(r,wbnd) ;
etah2obnd(r,wbnd)    = etah2obnd0(r,wbnd) ;

invElas(r,a)         = invElas0(r,a) ;
omegam(r,l)          = omegam0(r,l) ;

epsRor(r,t)          = epsRor0(r,t) ;

*	Labor segmentation assumptions

$OnText

   omegam:        Migration elasticity (infinity <==> no segmentation)
   migr0:         Level of migration (percent of rural labor force)
   uezRur0:       Initial level of unemployment (rural-percent, ignored if no segmentation)
   ueMinzRur0:    Natural rate of unemployment (rural-percent, ignored if no segmentation)
   uezUrb0:       Initial level of unemployment (urban-percent)
   ueMinzUrb0:    Natural rate of unemployment (urban-percent)
   resWageRur0:   Reservation wage (wrt to initial wage, rural, ignored if no segmentation)
   resWageRur0:   Reservation wage (wrt to initial wage, urban)
   omegarwg:      Elasticity of reservation wage wrt to growth
   omegarwue:     Elasticity of reservation wage wrt to unemployment rate (normally negative)
                  Model is framed in terms of 1-UE (to avoid divide by zero problem)
                  Thus the input elasticity should be with respect to 1-UE
                  eta = -omegarwue*(1-UE)/UE
   omegarwp:      Elasticity of reservation wage wrt to CPI
$OffText

labHyp(r,l,"omegam")      = inf ;
labHyp(r,l,"migr0")       = 0 ;
labHyp(r,l,"uezRur0")     = 0 ;
labHyp(r,l,"uezUrb0")     = 0 ;
labHyp(r,l,"ueMinzRur0")  = 0 ;
labHyp(r,l,"ueMinzUrb0")  = 0 ;
labHyp(r,l,"resWageRur0") = na ;
labHyp(r,l,"resWageUrb0") = na ;
labHyp(r,l,"omegarwg")    = 0 ;
labHyp(r,l,"omegarwue")   = 0 ;
labHyp(r,l,"omegarwp")    = 0 ;

* Default case:  omegam = inf --> ifLSeg(r,l) = 0

* [EditJEan]: actually ifLSeg(r,l) is useless could be replaced by $ {omegam(r,l) ne inf}

omegam(r,l) = labHyp(r,l,"omegam") ;
ifLSeg(r,l) = 0 ;
ifLSeg(r,l) $ (omegam(r,l) ne inf) = 1 ;

* ENVISAGE variables (cap_out_Ratio0 & invTarget0)
***HRR: hard coded
$ontext
cap_out_Ratio0(r) $(AUS(r) or OCE(r))     = 3.5 ;
cap_out_Ratio0(r) $(JPK(r) or CHN(r))     = 3.0 ;
cap_out_Ratio0(r) $(IDN(r) or ODA(r))     = 2.4 ;
cap_out_Ratio0(IND)                       = 2.4 ;
cap_out_Ratio0(OECD_AME)                  = 3.1 ;
cap_out_Ratio0(LATIN)                     = 3.4 ;
cap_out_Ratio0(WEU)                       = 3.6 ;
cap_out_Ratio0(r) $(OPEP(r) or tur(r))    = 2.8 ;
cap_out_Ratio0(r) $(OAF(r) or ZAF(r))     = 2.1 ;
cap_out_Ratio0(TransE)                    = 3.3 ;
$offtext
***HRR: adding single value, see where this is calibrated from??
cap_out_Ratio0(r) = 3 ;
***endHRR

$iftheni.dynamic NOT "%SimType%" == "CompStat"
*  !!!! Best not to use hard constants in these formulas, e.g., 2030--replace by a pre-defined singleton year
   IF(ifDyn,

      invTarget0(r,"2030")        = 25;
***HRR: hard coded
$ontext
      invTarget0(OLD_OECD,"2030") = 20;
      invTarget0(r,"2030") $(OAF(r) or ZAF(r)) = 28 ;
$offtext
***endHRR
   ELSE

      invTarget0(r,t) = 0 ;

   ) ;
$endif.dynamic

twt1(r,i,t)   = 0 ;
tw1(r,i,aa,t) = 0 ;
tw2(r,i,t)    = 0 ;

SET rtwtgt(rp,r)  "Targets for twist exporters (rp) for region r" ;
rtwtgt(rp,r) = no ;

grKMax(r,t)     = 0;
grKMin(r,t)     = 0;
chigrK(r,t)     = 0;
grKTrend(r,t)   = 0;

PARAMETER intRate, rorn(r,t) ;

intRate = 0.04;
rorn(r,t) = 0;

* For PostProcedure no need to load "25-IMF_Prm.gms": see "2-CommonIns.gms"

$IFi %DynCalMethod%=="OECD-ENV" cap_out_Ratio0(r) = 0 ; invTarget0(r,t) = 0 ;

