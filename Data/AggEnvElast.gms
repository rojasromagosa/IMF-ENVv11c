$OnText
--------------------------------------------------------------------------------
		Envisage 10 / OECD-ENV Model version 1.0 - Data preparation module
    GAMS file : %DataDir%\AggEnvElast.gms"
    purpose   : Aggregate (and define) model parameters for the Model Aggregation
				Generate the file "%iDataDir%\Agg\%Prefix%Prm.gdx"
    created by: Dominique van der Mensbrugghe for [ENVISAGE]
                modified by Jean Chateau for [OECD-ENV]
    called by : "%DataDir%\AggGTAP.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/AggEnvElast.gms $
   last changed revision: $Rev: 518 $
   last changed date    : $Date:: 2024-02-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
	On a pas mis a jour incElas(r0,i0) je ne sais plus trop d'ou elles sortaient
	pour ENV-Linkages V3.
--------------------------------------------------------------------------------
$OffText

set   v     "Vintages"     / Old, New / ;

*  To override GTAP parameters set following two flags to 1

scalars
   OVRRIDEGTAPARM  "Pour remplacer valeur armington GTAP (inactif)"             / %1 /
   OVRRIDEGTAPINC  "Pour remplacer valeur household elasticite GTAP (inactif)"  / %2 /
;

parameters

*  Constant Elasticities of Substituion (CES) in production

   sigmaxp(r0,a0,v)        "CES between GHG and XP"
   sigmap(r0,a0,v)         "CES between ND1 and VA"
   sigmav(r0,a0,v)         "CES between LAB1 and VA1 in non-livestock sectors, VA1 and VA2 in livestock sectors"
   sigmav1(r0,a0,v)        "CES between ND2 (fert) and VA2 in crops, LAB1 and KEF in livestock and land and KEF in other"
   sigmav2(r0,a0,v)        "CES between land and either KEF for crops or ND2 (i.e. feed) for livestock"
   sigmakef(r0,a0,v)       "CES between KF and NRG"
   sigmakf(r0,a0,v)        "CES between KSW and NRF"
   sigmakw(r0,a0,v)        "CES between KS and XWAT"
   sigmak(r0,a0,v)         "CES between LAB2 and K"
   sigmaul(r0,a0)          "CES across unskilled labor"
   sigmasl(r0,a0)          "CES across skilled labor"
   sigman1(r0,a0)          "CES across intermediate demand in ND1 bundle"
   sigman2(r0,a0)          "CES across intermediate demand in ND2 bundle"
   sigmawat(r0,a0)         "CES across intermediate demand in WAT bundle"
   sigmae(r0,a0,v)         "CES between ELY and NELY in energy bundle"
   sigmanely(r0,a0,v)      "CES between COA and OLG in energy bundle"
   sigmaolg(r0,a0,v)       "CES between OIL and GAS in energy bundle"
   sigmaNRG(r0,a0,NRG,v)   "CES within each of the NRG bundles"

*  Make matrix elasticities (incl. power)

   omegas(r0,a0)           "Make matrix transformation elasticities: one activity --> many commodities"
   sigmas(r0,i0)           "Make matrix substitution elasticities: one commodity produced by many activities"
   sigmael(r0)             "Substitution between power and distribution and transmission"
   sigmapow(r0)            "Substitution across power bundles"
   sigmapb(r0)             "Substitution across power activities within power bundles"

*  Final demand elasticities

   incElas(r0,i0)          "Income elasticities"
   nu(r0)                  "Elasticity of subsitution between energy and non-energy bundles in HH consumption"
   nunnrg(r0)              "Substitution elasticity across non-energy commodities in the non-energy bundle"
   nue(r0)                 "Substitution elasticity between ELY and NELY bundle"
   nunely(r0)              "Substitution elasticity beteen COL and OLG bundle"
   nuolg(r0)               "Substitution elasticity between OIL and GAS bundle"
   nuNRG(r0,NRG)           "Substitution elasticity within NRG bundles"
   sigma_gov(r0)           "CES expenditure elasticity for government"
   sigma_inv(r0)           "CES expenditure elasticity for investment"

*  Trade elasticities

   sigmam(r0,i0)           "Top level Armington elasticity"
   sigmaw(r0,i0)           "Second level Armington elasticity"
   omegax(r0,i0)           "Top level CET export elasticity"
   omegaw(r0,i0)           "Second level CET export elasticity"
   sigmamg(i0)             "CES 'Make' elasticity for intl. trade and transport services"

*  Factor supply elasticities

   omegak(r0)              "CET capital mobility elasticity in comp. stat. model"
   etat(r0)                "Aggregate land supply elasticity"
   landMax(r0)             "Initial ratio of land maximum wrt to land use"
   omegat(r0)              "Land elasticity between intermed. land bundle and first land bundle"
   omeganlb(r0)            "Land elasticity across intermediate land bundles"
   omegalb(r0,lb0)         "Land elasticity within land bundles"
   etanrf(r0,a0)           "Natural resource supply elasticity"
   invElas(r0,a0)          "Dis-investment elasticity"

   omegam(r0)              "Elasticity of migration"
;

*  OLD PROCEDURE Load the disaggregated elasticities from ENV-Linkages V.3.
* See also ENV-SmallDev\Jean\2016_Translation_between_EL_v3_and_v4\EnvParm.gms

IF(0,
	EXECUTE_LOAD "%EnvElastOld%"
	sigmaxp=sigmaxp0, sigmap=sigmap0, sigman1=sigman10, sigman2=sigman20, sigmawat=sigmawat0,
	sigmav=sigmav0, sigmav1=sigmav10, sigmav2=sigmav20,
	sigmakef=sigmakef0, sigmakf=sigmakf0, sigmakw=sigmakw0, sigmak=sigmak0,
	sigmaul=sigmaul0, sigmasl=sigmasl0,
	sigmae=sigmae0, sigmanely=sigmanely0, sigmaolg=sigmaolg0, sigmaNRG=sigmaNRG0
	omegas=omegas0, sigmas=sigmas0,
	sigmael=sigmael0, sigmapow=sigmapow0, sigmapb=sigmapb0,
	incElas=incElas0,
	nu=nu0, nunnrg=nunnrg0,nue=nue0, nunely=nunely0, nuolg=nuolg0, nuNRG=nuNRG0
	sigma_gov=sigma_gov0, sigma_inv=sigma_inv0
	sigmam=sigmam0, sigmaw=sigmaw0, omegax=omegax0, omegaw=omegaw0, sigmamg=sigmamg0
	omegak=omegak0, invElas=invElas0, etat=etat0, landMax=landMax0,
*   omegat=omegat0, omeganlb=omeganlb0, omegalb=omegalb0,
	etanrf=etanrf0, omegam=omegam0
	;
ELSE
	incElas(r0,i0) = 0 ;
) ;


* NEW PROCEDURE (2023-08) load/define disaggregated elasticities for ENV-Linkages V.4.

*$CALL DEL "%EnvElastNew%"

$IfTheni.EnvElast NOT EXIST "%EnvElastNew%"

*------------------------------------------------------------------------------*
*		Load parameters defined in the Excel File			     			   *
*------------------------------------------------------------------------------*

	$$SetGlobal XlsEnvLElas "%SatDataDir%\ENV-Linkages_elasticities.xlsx"

	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\sigmam.gdx"   par=sigmam  	rng=sigmam!A1:CP200 Rdim=1 Cdim=1' ;
	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\sigmaw.gdx"   par=sigmaw  	rng=sigmaw!A1:CP200 Rdim=1 Cdim=1' ;
	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\etanrf.gdx"   par=etanrf  	rng=etanrf!A1:CP200 Rdim=1 Cdim=1' ;
	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\etat.gdx"     par=etat 	 	rng=etat!A1:B200 Rdim=1';
	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\LandMax.gdx"  par=LandMax 	rng=LandMax!A1:B200 Rdim=1';
	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\sigmapow.gdx" par=sigmapow 	rng=sigmapow!A1:B200 Rdim=1';
	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\sigman1.gdx"  par=sigman1 	rng=sigman1!A1:CP200 Rdim=1 Cdim=1' ;
	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\sigmav.gdx"   par=sigmavNew   rng=sigmav!A1:CP200 Rdim=1 Cdim=1'  ;
	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\sigmap.gdx"   par=sigmapNew   rng=sigmap!A1:CP200 Rdim=1 Cdim=1'  ;
	EXECUTE 'GDXXRW input="%XlsEnvLElas%" output="%oDirCheck%\sigmakef.gdx" par=sigmakefNew rng=sigmakef!A1:CP200 Rdim=1 Cdim=1';

	PARAMETERS sigmavNew(r0,a0), sigmapNew(r0,a0), sigmakefNew(r0,a0) ;

	EXECUTE_LOAD "%oDirCheck%\sigmam.gdx"  , sigmam      ;
	EXECUTE_LOAD "%oDirCheck%\sigmaw.gdx"  , sigmaw      ;
	EXECUTE_LOAD "%oDirCheck%\etanrf.gdx"  , etanrf      ;
	EXECUTE_LOAD "%oDirCheck%\etat.gdx"    , etat        ;
	EXECUTE_LOAD "%oDirCheck%\LandMax.gdx" , LandMax     ;
	EXECUTE_LOAD "%oDirCheck%\sigmapow.gdx", sigmapow    ;
	EXECUTE_LOAD "%oDirCheck%\sigman1.gdx" , sigman1     ;
	EXECUTE_LOAD "%oDirCheck%\sigmav.gdx"  , sigmavNew   ;
	EXECUTE_LOAD "%oDirCheck%\sigmap.gdx"  , sigmapNew   ;
	EXECUTE_LOAD "%oDirCheck%\sigmakef.gdx", sigmakefNew ;

	sigmav(r0,a0,"New") = sigmavNew(r0,a0) ;

* Apply standard GREEN ratio NEW vs OLD

	sigmav(r0,a0,"Old") = 0.12 * sigmav(r0,a0,"New") ;

	sigmap(r0,a0,"New") = sigmapNew(r0,a0);
	sigmap(r0,a0,"Old") = 0 ;

	sigmakef(r0,a0,"New") = sigmakefNew(r0,a0);
	sigmakef(r0,a0,"Old") = 0 ;

	OPTION KILL=sigmavNew, KILL=sigmapNew, KILL=sigmakefNew ;

*------------------------------------------------------------------------------*
*		Parameters defined out of the Excel File							   *
*------------------------------------------------------------------------------*

	IF(0,

* [EditJean]: Wrong ENV-Linkages values for Land CET

		omegat(r0)      = 0.2;
		omeganlb(r0)    = 0.4;
		omegalb(r0,lb0) = 0.6;

	ELSE

* value in %EnvElastOld%

		omegat(r0)   	  = 0.4;
		omeganlb(r0) 	  = 0.6;
		omegalb(r0,"lb1") = 0.4;
		omegalb(r0,"lb2") = 0.6;
		omegalb(r0,"lb3") = 0.8;
	) ;

*	Substitution elasticity between GHG and XP

	sigmaxp(r0,a0,v)    = 0    ;
	sigmaxp(r0,alv0,v)  = 0.05 ;
	sigmaxp(r0,acr0,v)  = 0.05 ;
	sigmaxp(r0,"nfm",v) = 0.3  ;

	sigmaxp(r0,"mvh",v) = 0.05 ;
	sigmaxp(r0,"otn",v) = 0.05 ;
	sigmaxp(r0,img0,v)  = 0.05 ;

	sigmaxp(r0,"omf",v) = 0.25 ;
	sigmaxp(r0,"ome",v) = 0.25 ;
	sigmaxp(r0,"eeq",v) = 0.25 ;
	sigmaxp(r0,"bph",v) = 0.25 ;
	sigmaxp(r0,"rpp",v) = 0.25 ;


* 2022-2023 revision ENV-Linkages by Jean Foure
* --> https://svn.oecd.org/svn/ENV-Linkages/envlinkages-version4/trunk/aggregation/Agg/02-Parameters_Aggregation.gms

	sigmaxp(r0,"nmm","Old")    = 0.05 ; sigmaxp(r0,"nmm","New")    = 0.10 ;
	sigmaxp(r0,"i_s","Old")    = 0.05 ; sigmaxp(r0,"i_s","New")    = 0.10 ;
	sigmaxp(r0,"%chm%","Old")  = 0.10 ; sigmaxp(r0,"%chm%","New")  = 0.15 ;
	sigmaxp(r0,"p_c",v) = 0.0 ;
	sigmaxp(r0,"coa",v) = 0.8 ;
	sigmaxp(r0,"oil",v) = 0.8 ;
	sigmaxp(r0,"gas",v) = 0.8 ;
	sigmaxp(r0,"gdt",v) = 0.8 ;
	sigmaxp(r0,"wtr",v) = 0.8 ;

*	Substitution elasticity between KSW and NRF

	sigmakf(r0,a0,v)           	= 0.0 ;
	sigmakf(r0,alv0,"New")     	= 0.1 ;
	sigmakf(r0,acr0,"New")     	= 0.1 ;
	sigmakf(r0,"frs","New")		= 0.2 ;
	sigmakf(r0,"fsh","New")  	= 0.2 ;
	sigmakf(r0,"%oxt%","New")	= 0.2 ;

	sigmak(r0,a0,v)  = 0 ;
	sigmakw(r0,a0,v) = 0 ;

*	Dis-investment elasticity

	invElas(r0,a0)    	 = 0.92;
	invElas(r0,"i_s") 	 = 0.55;
	invElas(r0,alv0)  	 = 4;
	invElas(r0,acr0)  	 = 4;
	invElas("jpn","coa") = 2.5 ;
	invElas("kor","coa") = 2.5 ;
	invElas("bra","coa") = 2.5 ;

    $$IfTheni.Power %IfPower%=="ON"
		invElas(r0,"CoalBL") = 1.4;
		invElas(r0,"GasBL")  = 1.4;
		invElas(r0,"GasP")   = 1.4;
		invElas(r0,"OilBL")  = 1.4;
		invElas(r0,"OilP")   = 1.4;
		invElas("bra","CoalBL") = 2.5 ; InvElas("fra","CoalBL") = 2.5 ;
    $$Endif.Power

*	Substitution elasticities for agriculture productions

	sigmav1(r0,a0,v) = 0 ;

	sigmav1(r0,alv0,"New") = 0.5 ; !! Elasticity between lab1 and KEF
	sigmav1(r0,alv0,"Old") = 0.12 * sigmav1(r0,alv0,"New") ;
	sigmav2(r0,alv0,v)     = 0.5 ; !! Elasticity between Land and Feed
	sigman2(r0,alv0) 	   = 0.5 ; !! Elasticity across feed

	sigmav1(r0,acr0,v)     = 0.5 ; !! Elasticity between KTE and Fertilizer
	sigmav2(r0,acr0,"New") = 0.1 ; !! Elasticity between Land and KEF
	sigman2(r0,acr0)       = 0.5 ; !! Elasticity across fertilizers

*	Energy Elasticities

	sigmae(r0,a0,"New")  = 1.10  ;
	sigmae(r0,a0,"Old")  = 0.125 ;

	sigmanely(r0,a0,v)   = 0.5 * sigmae(r0,a0,v) ;
	sigmaolg(r0,a0,v)    = sigmae(r0,a0,v) ;

*   CES within each of the NRG bundles same elasticity than corresponding bundle

	sigmaNRG(r0,a0,"ELY",v) = sigmae(r0,a0,v)   ;
	sigmaNRG(r0,a0,"COA",v) = sigmanely(r0,a0,v);
	sigmaNRG(r0,a0,"OIL",v) = sigmaolg(r0,a0,v) ;
	sigmaNRG(r0,a0,"GAS",v) = sigmaolg(r0,a0,v) ;

*	Households nrg Elasticities

	nu(r0)           = 1.1 ;
	nunnrg(r0)       = 1.1 ;
	nue(r0)          = 1.2 ;
	nunely(r0)       = 1.2 ;
	nuolg(r0)        = 1.2 ;
	nuNRG(r0,NRG)	 = 1.2 ;

*	Export elasticities

* Top level CET export elasticity

	omegax(r0,i0) = +inf ;

* Second level CET export elasticity

	omegaw(r0,i0) = +inf ;

* Power

   sigmael(r0) 	= 0.05 ;
   sigmapb(r0)  = sigmapow(r0) ;

* Miscellaneous

	sigmawat(r0,a0) = 1.1   ;
	sigmamg(img0)   = 1.05  ;
	omegak(r0)	    = + inf ;
	omegam(r0)	    = 2     ;
	sigma_gov(r0)   = 0.8   ;
	sigma_inv(r0)   = 0.8   ;
	omegas(r0,a0) 	= 2 ;
	sigmas(r0,i0) 	= 2 ;
	sigmaul(r0,a0) 	= 0 ;
	sigmasl(r0,a0) 	= 0 ;

*	Save once for all the production parameter values for GTAP aggregation

	EXECUTE_UNLOAD "%EnvElastNew%",
		sigmam, sigmaw,  etanrf, etat, sigman1,
		sigmav, sigmap, sigmakef,
		omegat, omeganlb, omegalb,
		sigmaxp, sigmakf, sigmak, sigmakw, InvElas,
		sigmav1, sigmav2, sigman2,
		sigmae, sigmanely, sigmaolg, sigmaNRG,
		nu, nunnrg, nue, nunely, nuolg, nuNRG,
		omegax, omegaw, landMax, sigmaul, sigmasl,
		sigmael, sigmapow, sigmapb,
		sigmawat, sigmamg, omegak, omegam, sigma_gov, sigma_inv, omegas, sigmas
	;

$ELSE.EnvElast

	EXECUTE_LOAD "%EnvElastNew%",
		sigmam, sigmaw,  etanrf, etat, sigman1,
		sigmav, sigmap, sigmakef,
		omegat, omeganlb, omegalb,
		sigmaxp, sigmakf, sigmak, sigmakw, InvElas,
		sigmav1, sigmav2, sigman2,
		sigmae, sigmanely, sigmaolg, sigmaNRG,
		nu, nunnrg, nue, nunely, nuolg, nuNRG,
		omegax, omegaw, landMax, sigmaul, sigmasl,
		sigmael, sigmapow, sigmapb,
		sigmawat, sigmamg, omegak, omegam, sigma_gov, sigma_inv, omegas, sigmas
		;

$EndIf.EnvElast

IF(m_CheckFile,
    execute_unload "%DirCheck%\check_sigmaNRG_%system.fn%.gdx", sigmaNRG;
);

*------------------------------------------------------------------------------*
*		Define and Compute the parameters for the model aggregation			   *
*------------------------------------------------------------------------------*

parameters

*  Production elasticities

   sigmaxp0(r,actf,v)      "CES between GHG and XP"
   sigmap0(r,actf,v)       "CES between ND1 and VA"
   sigmav0(r,actf,v)       "CES between LAB1 and VA1 in crops and other, VA1 and VA2 in livestock"
   sigmav10(r,actf,v)      "CES between ND2 (fert) and VA2 in crops, LAB1 and KEF in livestock and land and KEF in other"
   sigmav20(r,actf,v)      "CES between land and KEF in crops, land and ND2 (feed) in livestock. Not used in other"
   sigmakef0(r,actf,v)     "CES between KF and NRG"
   sigmakf0(r,actf,v)      "CES between KSW and NRF"
   sigmakw0(r,actf,v)      "CES between KS and XWAT"
   sigmak0(r,actf,v)       "CES between LAB2 and K"
   sigmaul0(r,actf)        "CES across unskilled labor"
   sigmasl0(r,actf)        "CES across skilled labor"
   sigman10(r,actf)        "CES across intermediate demand in ND1 bundle"
   sigman20(r,actf)        "CES across intermediate demand in ND2 bundle"
   sigmawat0(r,actf)       "CES across intermediate demand in XWAT bundle"
   sigmae0(r,actf,v)       "CES between ELY and NELY in energy bundle"
   sigmanely0(r,actf,v)    "CES between COA and OLG in energy bundle"
   sigmaolg0(r,actf,v)     "CES between OIL and GAS in energy bundle"
   sigmaNRG0(r,actf,NRG,v) "CES within each of the NRG bundles"

*  Make matrix elasticities (incl. power)

   omegas0(r,actf)         "Make matrix transformation elasticities: one activity --> many commodities"
   sigmas0(r,commf)        "Make matrix substitution elasticities: one commodity produced by many activities"
   sigmael0(r,elyi)        "Substitution between power and distribution and transmission"
   sigmapow0(r,elyi)       "Substitution across power bundles"
   sigmapb0(r,pb,elyi)     "Substitution across power activities within power bundles"

*  Final demand elasticities

   incElas0(k,r)           "Income elasticities"
   nu0(r,k,h)              "Elasticity of subsitution between energy and non-energy bundles in HH consumption"
   nunnrg0(r,k,h)          "Substitution elasticity across non-energy commodities in the non-energy bundle"
   nue0(r,k,h)             "Substitution elasticity between ELY and NELY bundle"
   nunely0(r,k,h)          "Substitution elasticity beteen COL and OLG bundle"
   nuolg0(r,k,h)           "Substitution elasticity between OIL and GAS bundle"
   nuNRG0(r,k,h,NRG)       "Substitution elasticity within NRG bundles"
   sigmafd0(r,fd)          "CES expenditure elasticity for other final demand"

*  Trade elasticities

   sigmam0(r,commf)        "Top level Armington elasticity"
   sigmaw0(r,commf)        "Second level Armington elasticity"
   omegax0(r,commf)        "Top level CET export elasticity"
   omegaw0(r,commf)        "Second level CET export elasticity"
   sigmamg0(commf)         "CES 'Make' elasticity for intl. trade and transport services"

*  Factor supply elasticities

   omegak0(r)              "CET capital mobility elasticity in comp. stat. model"
   etat0(r)                "Aggregate land supply elasticity"
   landMax00(r)            "Initial ratio of land maximum wrt to land use"
   omegat0(r)              "Land elasticity between intermed. land bundle and first land bundle"
   omeganlb0(r)            "Land elasticity across intermediate land bundles"
   omegalb0(r,lb)          "Land elasticity within land bundles"
   etanrf0(r,actf)         "Natural resource supply elasticity"
   invElas0(r,actf)        "Dis-investment elasticity"

   omegam0(r,l)            "Elasticity of migration"
;

*  Calculate weights
*  !!!! NEED TO REVIEW AGGREGATION AND WEIGHTS

Parameters
   xp0(r0,a0)        "Production weights"
   xpp0(r0,elya0)    "Power production weights"
   va0(r0,a0)        "VA weights"
   kap0(r0,a0)       "K weights"
   lab0(r0,a0)       "Total labor weights"
   nd0(r0,a0)        "Intermediate weights"
   nrg0(r0,a0)       "Energy weights"
   denom             "Working scalar"
   poids(r0,a0)		 "Working weights"
;

xp0(r0,a0)  = voa(a0,r0) ;
va0(r0,a0)  = sum(endw_comm, evfa(endw_comm, a0, r0)) ;
lab0(r0,a0) = sum(l0, evfa(l0,a0,r0)) ;
kap0(r0,a0) = sum(cap0, evfa(cap0, a0, r0)) ;
nrg0(r0,a0) = sum((e0,i,ei) $ (mapa(e0,i) and mapif(i,ei)), vdfa(e0,a0,r0) + vifa(e0,a0,r0)) ;

*  Production elasticities

$batinclude "%DataDir%\aggrav.gms" sigmaxp  xp0  sigmaxp0
$batinclude "%DataDir%\aggrav.gms" sigmap   xp0  sigmap0
$batinclude "%DataDir%\aggrav.gms" sigmav   va0  sigmav0
$batinclude "%DataDir%\aggrav.gms" sigmav1  va0  sigmav10
$batinclude "%DataDir%\aggrav.gms" sigmav2  va0  sigmav20

* Mque water (in the 3 following bundles)

poids(r0,a0) = kap0(r0,a0) + nrg0(r0,a0) + sum(nrf0,evfa(nrf0,a0,r0));
$batinclude "%DataDir%\aggrav.gms" sigmakef poids sigmakef0

poids(r0,a0) = 0; poids(r0,a0) = kap0(r0,a0) + sum(nrf0,evfa(nrf0,a0,r0));
$batinclude "%DataDir%\aggrav.gms" sigmakf  poids sigmakf0

poids(r0,a0) = 0; poids(r0,a0) = kap0(r0,a0) ;
$batinclude "%DataDir%\aggrav.gms" sigmakw  poids sigmakw0

$batinclude "%DataDir%\aggrav.gms" sigmak  kap0 sigmak0
$batinclude "%DataDir%\aggra.gms"  sigmaul lab0 sigmaul0
$batinclude "%DataDir%\aggra.gms"  sigmasl lab0 sigmasl0

*	CES elasticities for Intermediary bundles

* ND1 bundle

nd0(r0,a0)
    = sum((i0,i,commf)$(mapa(i0,i) and mapIF(i, commf) and not frti(commf)  and not ei(commf)), vdfa(i0,a0,r0) + vifa(i0,a0,r0))$acr0(a0)
    + sum((i0,i,commf)$(mapa(i0,i) and mapIF(i, commf) and not feedi(commf) and not ei(commf)), vdfa(i0,a0,r0) + vifa(i0,a0,r0))$alv0(a0)
    + sum((i0,i,commf)$(mapa(i0,i) and mapIF(i, commf) and not ei(commf)), vdfa(i0,a0,r0) + vifa(i0,a0,r0))$(not acr0(a0) and not alv0(a0))
    ;
$batinclude "%DataDir%\aggra.gms" sigman1 nd0 sigman10

* ND2 bundle

nd0(r0,a0) = 0;
nd0(r0,a0) = sum((i0,i,commf)$(mapa(i0,i) and mapIF(i, commf) and frti(commf)), vdfa(i0,a0,r0) + vifa(i0,a0,r0))$acr0(a0)
           + sum((i0,i,commf)$(mapa(i0,i) and mapIF(i, commf) and feedi(commf)), vdfa(i0,a0,r0) + vifa(i0,a0,r0))$alv0(a0)
           + 0 $(not acr0(a0) and not alv0(a0))
           ;
$batinclude "%DataDir%\aggra.gms" sigman2 nd0 sigman20

* Wat bundle

nd0(r0,a0) = sum((i0,i,commf)$(mapa(i0,i) and mapIF(i, commf) and iw(commf)), vdfa(i0,a0,r0) + vifa(i0,a0,r0)) ;
$batinclude "%DataDir%\aggra.gms" sigmawat nd0 sigmawat0

* NRG bundle

$batinclude "%DataDir%\aggrav.gms" sigmae nrg0 sigmae0

* NELY bundle (Memo mape(NRG,ei))

Execute_unload "CheckSet.gdx" mape, mapa, mapif ;

nrg0(r0,a0) = 0 ; nrg0(r0,a0) = sum((e0,i,ei) $ (mapa(e0,i) and mapif(i,ei) and (not mape("ely",ei))), vdfa(e0,a0,r0) + vifa(e0,a0,r0)) ;
$batinclude "%DataDir%\aggrav.gms" sigmanely nrg0 sigmanely0

* OLG bundle

nrg0(r0,a0) = 0 ; nrg0(r0,a0) = sum((e0,i,ei) $ (mapa(e0,i) and mapif(i,ei) and (mape("oil",ei) or mape("gas",ei))), vdfa(e0,a0,r0) + vifa(e0,a0,r0)) ;
$batinclude "%DataDir%\aggrav.gms" sigmaolg nrg0 sigmaolg0

* NRGs

loop(nrg,
    nrg0(r0,a0) = sum((e0,i,ei)$(mapa(e0,i) and mapif(i,ei) and mape(nrg,ei)), vdfa(e0,a0,r0) + vifa(e0,a0,r0)) ;
    $$batinclude "%DataDir%\aggrave.gms" sigmaNRG nrg0 sigmaNRG0
) ;

*  Make matrix elasticities including power

* !!!! There are no standard elasticities for 'make' matrix for the moment

omegas0(r,actf)  = 2 ;
sigmas0(r,commf) = 2 ;

*  !!!! There are no standard elasticities for 'power' bundle

xpp0(r0,elya0) = sum(fp0, evfa(fp0, elya0, r0))
               + sum(i0, vdfa(i0, elya0, r0) + vifa(i0, elya0, r0))
               - osep(elya0, r0) ;

*  Calculate poids for power across regions [TBC] use pow_acta0 instead of elya0

loop((r,elyi),
    denom = sum((r0,elya0) $ mapr(r0,r), xpp0(r0,elya0)) ;
    sigmael0(r,elyi)   $ denom
        = sum((r0,elya0) $ mapr(r0,r), xpp0(r0,elya0)*sigmael(r0))  / denom ;
    sigmapow0(r,elyi)  $ denom
        = sum((r0,elya0) $ mapr(r0,r), xpp0(r0,elya0)*sigmapow(r0)) / denom ;
    sigmapb0(r,pb,elyi)$ denom
        = sum((r0,elya0) $ mapr(r0,r), xpp0(r0,elya0)*sigmapb(r0))  / denom ;
) ;

*	Final demand elasticities

* Calculate the GTAP-based income elasticities

Parameters
   b_c(k,r)       "Substitution parameter for final disaggregation"
   e_c(k,r)       "Expansion parameter for final disaggregation"
   s_c(k,r)       "Share parameter for final disaggregation"
   incElasG(k,r)  "GTAP income elasticity"
;

alias(k,kp) ;

s_c(k,r) = sum((i0,i,commf,r0)$(mapa(i0,i) and mapIF(i,commf) and mapk(commf,k) and mapr(r0,r)), vdpa(i0,r0) + vipa(i0,r0)) ;
e_c(k,r) $ s_c(k,r)
          = sum((i0,i,commf,r0)$(mapa(i0,i) and mapIF(i,commf) and mapk(commf,k) and mapr(r0,r)), incPar(i0,r0) * (vdpa(i0,r0) + vipa(i0,r0)))
          / s_c(k,r) ;
b_c(k,r) $ s_c(k,r)
          = sum((i0,i,commf,r0)$(mapa(i0,i) and mapIF(i,commf) and mapk(commf,k) and mapr(r0,r)), subPar(i0,r0)*(vdpa(i0,r0) + vipa(i0,r0)))
          / s_c(k,r) ;

s_c(k,r) = s_c(k,r) / sum((i0,r0)$mapr(r0,r), vdpa(i0,r0) + vipa(i0,r0)) ;

incElasG(k,r) = (e_c(k,r)*b_c(k,r) - sum(kp, s_c(kp,r)*e_c(kp,r)*b_c(kp,r)))
              / sum(kp, s_c(kp,r)*e_c(kp,r))
              - (b_c(k,r)-1) + sum(kp, s_c(kp,r)*b_c(kp,r)) ;

*  Aggregate the income elasticity in the default ENV parameter file

incElas0(k,r)
	= sum((i0,i,commf,r0)$(mapa(i0,i) and mapIF(i, commf) and mapk(commf,k) and mapr(r0,r)), vdpa(i0, r0) + vipa(i0, r0)) ;
incElas0(k,r) $ incElas0(k,r)
	= sum((i0,i,commf,r0)$(mapa(i0,i) and mapIF(i, commf) and mapk(commf,k) and mapr(r0,r)),
		incElas(r0,i0)*(vdpa(i0, r0) + vipa(i0, r0)))
	/ incElas0(k,r) ;

* display b_c, e_c, s_c, incElasG, incElas0 ;

IF(OVRRIDEGTAPINC,
   incElasG(k,r) = incElas0(k,r) ;
ELSE
   incElas0(k,r) = incElasG(k,r) ;
) ;

loop(r,
   denom = sum((r0,i0)$(mapr(r0,r)), vdpa(i0,r0) + vipa(i0,r0)) ;
   nu0(r,k,h)$denom = sum((r0,i0)$(mapr(r0,r)), (vdpa(i0,r0) + vipa(i0,r0))*nu(r0))/denom ;
   denom = sum((r0,i0)$(mapr(r0,r) and not e0(i0)), vdpa(i0,r0) + vipa(i0,r0)) ;
   nunnrg0(r,k,h)$denom = sum((r0,i0)$(mapr(r0,r) and not e0(i0)), (vdpa(i0,r0) + vipa(i0,r0))*nunnrg(r0))/denom ;
   denom = sum((r0,e0)$(mapr(r0,r)), vdpa(e0,r0) + vipa(e0,r0)) ;
   nue0(r,k,h)$denom = sum((r0,e0)$(mapr(r0,r)), (vdpa(e0,r0) + vipa(e0,r0))*nue(r0))/denom ;
   denom = sum((r0,e0,ei)$(mapr(r0,r) and not mape("ely",ei)), vdpa(e0,r0) + vipa(e0,r0)) ;
   nunely0(r,k,h)$denom = sum((r0,e0,ei)$(mapr(r0,r) and not mape("ely",ei)), (vdpa(e0,r0) + vipa(e0,r0))*nunely(r0))/denom ;
   denom = sum((r0,e0,ei)$(mapr(r0,r) and (mape("oil",ei) or mape("gas",ei))), vdpa(e0,r0) + vipa(e0,r0)) ;
   nuolg0(r,k,h)$denom = sum((r0,e0,ei)$(mapr(r0,r) and (mape("oil",ei) or mape("gas",ei))), (vdpa(e0,r0) + vipa(e0,r0))*nuolg(r0))/denom ;
   loop(NRG,
      denom = sum((r0,e0,ei)$(mapr(r0,r) and mape(nrg,ei)), vdpa(e0,r0) + vipa(e0,r0)) ;
      nuNRG0(r,k,h,NRG)$denom = sum((r0,e0,ei)$(mapr(r0,r) and mape(nrg,ei)), (vdpa(e0,r0) + vipa(e0,r0))*nuNRG(r0,NRG))/denom ;
   ) ;
) ;

loop(r,

*	Government

	denom = 0 ;
	denom = sum((r0,i0)$(mapr(r0,r)), vdga(i0,r0) + viga(i0,r0)) ;
	sigmafd0(r,gov) $ denom
		= sum((r0,i0)$(mapr(r0,r)), (vdga(i0,r0) + viga(i0,r0))*sigma_gov(r0))
		/ denom ;

*	Investment

	denom = 0 ;
	denom = sum((r0,i0)$(mapr(r0,r)), vdfa(i0,'cgds',r0) + vifa(i0,'cgds',r0)) ;
	sigmafd0(r,inv) $ denom
		= sum((r0,i0)$(mapr(r0,r)), (vdfa(i0,'cgds',r0) + vifa(i0,'cgds',r0))*sigma_inv(r0))
		/ denom ;

) ;

*	Trade elasticities

* Top level Armington -- poids is domestic and import demand at agents' price

*  !!!! NEED TO DEAL WITH NON-DIAGONAL MAKE MATRIX FOR EXAMPLE ELY-C

sigmam0(r,commf) = sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)),
   sum(a0, (vdfa(i0,a0,r0)+ vifa(i0,a0,r0))) + (vdpa(i0,r0) + vipa(i0,r0)) + (vdga(i0, r0) + viga(i0, r0))) ;

sigmam0(r,commf)$sigmam0(r,commf) = sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)), sigmam(r0,i0)*
   (sum(a0, (vdfa(i0,a0,r0)+ vifa(i0,a0,r0))) + (vdpa(i0,r0) + vipa(i0,r0)) + (vdga(i0, r0) + viga(i0, r0))))/sigmam0(r,commf) ;

* Second level Armington -- poids is import demand at agents' price

sigmaw0(r,commf) = sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)), sum(a0, vifa(i0,a0,r0)) + vipa(i0,r0) + viga(i0, r0)) ;
sigmaw0(r,commf) $ sigmaw0(r,commf) =
   sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)), sigmaw(r0,i0)*(sum(a0, vifa(i0,a0,r0)) + vipa(i0,r0) + viga(i0, r0)))/sigmaw0(r,commf) ;

*  !!!! LETS REVIEW -- We probably don't want to override here...

$OnText
IF(OVRRIDEGTAPARM,
   esubd1(commf,r) = sigmam0(r,commf) ;
   esubm1(commf,r) = sigmaw0(r,commf) ;
else
   sigmam0(r,commf) = esubd1(commf,r) ;
   sigmaw0(r,commf) = esubm1(commf,r) ;
) ;
$OffText

*display omegax ;
loop((r,commf),

*  Top level CET -- poids is domestic demand at market price + exports at market price + exports of TT services

   denom = sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)),
               sum(a0, vdfm(i0,a0,r0)) + vdpm(i0,r0) + vdgm(i0, r0) + sum(reg, vxmd(i0,r0,reg)))
         + sum((r0,marg_comm,i)$(mapa(marg_comm,i) and mapIF(i,commf) and mapr(r0,r)), vst(marg_comm,r0)) ;
   IF(denom,
      omegax0(r,commf) = sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)),
         (omegax(r0,i0)$(omegax(r0,i0) ne inf))*(sum(a0, vdfm(i0,a0,r0)) + vdpm(i0,r0) + vdgm(i0, r0) + sum(reg, vxmd(i0,r0,reg)))
         +  inf$(omegax(r0,i0) eq inf))
         + sum((r0,marg_comm,i)$(mapa(marg_comm,i) and mapIF(i,commf) and mapr(r0,r)), omegax(r0,marg_comm)*vst(marg_comm,r0)
         + inf$(omegax(r0,marg_comm) eq inf)) ;
      IF(omegax0(r,commf) ne inf,
         omegax0(r,commf) = omegax0(r,commf)/denom ;
      ) ;
   ) ;

*  Second level CET -- poids is exports at market price

   denom = sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)), sum(reg, vxmd(i0,r0,reg))) ;
   IF(denom,
      omegaw0(r,commf) = sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)), (omegaw(r0,i0)$(omegaw(r0,i0) ne inf))*sum(reg, vxmd(i0,r0,reg))
                   +    inf$(omegaw(r0,i0) eq inf)) ;
      IF(omegaw0(r,commf) ne inf,
         omegaw0(r,commf) = omegaw0(r,commf)/denom ;
      ) ;
   ) ;
) ;
*display omegax0 ;

*  Intl. trade margins 'make' elasticity -- poids is aggregate TT services

sigmamg0(commf) = sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf)), vst(i0,r0)) ;
sigmamg0(commf)$sigmamg0(commf) = sum((r0,i0,i)$(mapa(i0,i) and mapIF(i,commf)),
   sigmamg(i0)*vst(i0,r0))/sigmamg0(commf) ;

*  Factor supply elasticities

*  Capital mobility for comp. stat. model -- poids is capital remuneration

loop(r,
   denom = sum((r0,a0)$(mapr(r0,r)), kap0(r0,a0)) ;
   IF(denom,
      omegak0(r) = sum((r0,a0)$(mapr(r0,r)), (omegak(r0)*kap0(r0,a0))$(omegak(r0) ne inf) + (inf)$(omegak(r0) eq inf)) ;
      IF(omegak0(r) ne inf,
         omegak0(r) = omegak0(r)/denom ;
      ) ;
   ) ;
) ;

*  Land elasticity -- poids is total land remuneration

etat0(r)
	= sum((r0,a0,lnd0)$(mapr(r0,r) and evfa(lnd0,a0,r0)), evfa(lnd0,a0,r0)) ;
etat0(r) $ etat0(r)
	= sum((r0,a0,lnd0)$(mapr(r0,r) and evfa(lnd0,a0,r0)), etat(r0)*evfa(lnd0,a0,r0))
	/ etat0(r) ;

*  Land potential -- poids is total land remuneration

landMax00(r) = sum((r0,a0,lnd0)$(mapr(r0,r)), evfa(lnd0,a0,r0)) ;
landMax00(r)$landMax00(r) = sum((r0,a0,lnd0)$(mapr(r0,r)), landMax(r0)*evfa(lnd0,a0,r0))/landMax00(r) ;

*  Top level land allocation elasticity -- poids is total land remuneration

loop(r,
   denom = sum((r0,a0,lnd0)$(mapr(r0,r)), evfa(lnd0,a0,r0)) ;
   IF(denom,
      omegat0(r) = sum((r0,a0,lnd0)$(mapr(r0,r)), (omegat(r0)*evfa(lnd0,a0,r0))$(omegat(r0) ne inf) + (inf)$(omegat(r0) eq inf)) ;
      IF(omegat0(r) ne inf,
         omegat0(r) = omegat0(r)/denom ;
      ) ;
   ) ;
) ;

* Intermediate land bundle -- poids is total land remuneration for land not in bundle 1

loop(r,
   denom = sum((r0,a0,lnd0,i,actf,lb1)$(mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and not maplb(lb1,actf)), evfa(lnd0,a0,r0)) ;
   IF(denom,
      omeganlb0(r) = sum((r0,a0,lnd0,i,actf,lb1)$(mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and not maplb(lb1,actf)), omeganlb(r0)*evfa(lnd0,a0,r0)) ;
      IF(omeganlb0(r) ne inf,
         omeganlb0(r) = omeganlb0(r)/denom ;
      ) ;
   ) ;
) ;

*  Bottom level land bundles -- poids is total land remuneration of the bundles

*display omegalb ;

loop((r,lb),
   denom = sum((r0,a0,lnd0,i,actf)$(mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and maplb(lb,actf)), evfa(lnd0,a0,r0)) ;
   IF(denom,
      omegalb0(r,lb) = sum((r0,a0,lnd0,i,actf,lb0)$(mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and maplb(lb,actf) and maplb0(lb,lb0)), omegalb(r0,lb0)*evfa(lnd0,a0,r0)) ;
      IF(omegalb0(r,lb) ne inf,
         omegalb0(r,lb) = omegalb0(r,lb)/denom ;
      ) ;
   ) ;
) ;

*  Elasticity of supply of natural resources -- poids is total natl. res. remuneration

loop((r,actf),
	denom = 0 ;
	denom = sum((r0,a0,nrf0,i)$(mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and evfa(nrf0,a0,r0)), evfa(nrf0,a0,r0)) ;
	etanrf0(r,actf) $ denom
		= sum((r0,a0,nrf0,i)$(mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and evfa(nrf0,a0,r0)), etanrf(r0,a0) * evfa(nrf0,a0,r0)) / denom ;
) ;

*  Dis-investment elasticity -- poids is capital remuneration

invElas0(r,actf) = 0 ;
loop((r,actf),
	denom = 0 ;
	denom = sum((r0,a0,i)$(mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and kap0(r0,a0) ), kap0(r0,a0) ) ;
	invElas0(r,actf) $ denom = sum((r0,a0,i)$(mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and kap0(r0,a0) ), invElas(r0,a0)*kap0(r0,a0) )/denom ;
$OnText
   IF(0 and sameas("nuc", actf),
      put screen ;
      loop((r0,a0,i)$(mapr(r0,r) and mapa(a0,i) and mapaf(i,actf)),
         loop(cap0,
            put r.tl, actf.tl, r0.tl, a0.tl, evfa(cap0, a0, r0):15:9, denom:15:4, InvElas(r0,a0):10:4, invElas0(r,actf):10:4 / ;
         ) ;
      ) ;
   ) ;
$OffText
) ;

*  Migration elasticity -- poids is labor remuneration in rural activities

omegam0(r,l)
    $ sum((r0,l0,a0,i,actf,rur) $ (mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and mapzf(rur,actf) and mapf(l0,l)), vfm(l0,a0,r0))
    = sum((r0,l0,a0,i,actf,rur) $ (mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and mapzf(rur,actf) and mapf(l0,l)), omegam(r0) * vfm(l0,a0,r0))
    / sum((r0,l0,a0,i,actf,rur) $ (mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and mapzf(rur,actf) and mapf(l0,l)), vfm(l0,a0,r0)) ;

* Warning finally there is two parameters file "par.gdx" et "Prm.gdx"

execute_unload "%iDataDir%\Agg\%Prefix%Prm.gdx"
   sigmaxp0, sigmap0, sigman10, sigman20, sigmawat0,
   sigmav0, sigmav10, sigmav20,
   sigmakef0, sigmakf0, sigmakw0, sigmak0,
   sigmaul0, sigmasl0,
   sigmae0, sigmanely0, sigmaolg0, sigmaNRG0,
   omegas0, sigmas0,
   sigmael0, sigmapow0, sigmapb0,
   incElas0, e_c=eh0, b_c=bh0, nu0, nunnrg0, nue0, nunely0, nuolg0, nuNRG0, sigmafd0
   sigmam0, sigmaw0, omegax0, omegaw0, sigmamg0
   omegak0, invElas0, etat0, landMax00,
   omegat0, omeganlb0, omegalb0,
   etanrf0, omegam0
;
IF(m_CheckFile,
    execute_unload "%DirCheck%\Check_sigmaNRG0_%system.fn%.gdx.gdx", sigmaNRG0 ;
);
