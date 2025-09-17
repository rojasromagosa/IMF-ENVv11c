$OnText
--------------------------------------------------------------------------------
			OECD-ENV Model version 1: Simulation Procedure
	file name   : %ModelDir%\25-IMF_Prm.gms
	purpose     : overwrite default values %ModelDir%\default_Prm.gms
				  for OECD-ENV Model
	created date: 2023-08-17
	created by  : Jean Chateau
	called by   : "%ModelDir%\2-CommonIns.gms"
--------------------------------------------------------------------------------
    $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/25-IMF_Prm.gms $
	last changed revision: $Rev: 354 $
	last changed date    : $Date:: 2023-07-18 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
	original source is
 https://svn.oecd.org/svn/ENV-Linkages/envlinkages-version3/trunk/INTERNAL/MODEL_calibration/prg/data.gms
--------------------------------------------------------------------------------
$OffText

*------------------------------------------------------------------------------*
*                   Some twist parameters scenarios                            *
*------------------------------------------------------------------------------*

* Should not be defined here ??

*tw1("China",i,aa,t)$(years(t) ge 2012) = 0.02 ;
*tw2("China",i,t)   $(years(t) ge 2012) = 0.02 ;
*rtwtgt("Australia","China") = yes ;
*rtwtgt("ROW"      ,"China") = yes ;
*tw1("EastAsia",i,aa,t)$(years(t) ge 2012) = 0.02 ;
*tw2("EastAsia",i,t)$(years(t) ge 2012)  = 0.02 ;
*rtwtgt("Oceania", "EastAsia") = yes ;
*rtwtgt("RestofWorld", "EastAsia") = yes ;

*------------------------------------------------------------------------------*
*                   Change Depreciation profile                                *
*------------------------------------------------------------------------------*

* Should not be defined here ??

*deprT(r,t) $ mapr("LIC",r) = 0.05$(years(t) le 2030) + 0.05$(years(t) gt 2030) ;
*deprT(r,t) $ mapr("MIC",r) = 0.05$(years(t) le 2030) + 0.05$(years(t) gt 2030) ;

*------------------------------------------------------------------------------*
*                   Override energy nesting choices                            *
*------------------------------------------------------------------------------*

* Memo:
* IfNrgNest eq 0: sigmae(r,a,v) is the elasticity between all fuel
* IfNrgNest gt 0: sigmae(r,a,v) is the elasticity between ely and non-ely fuel

IfNrgNest(r,a) $ (fa(a) or elya(a)) 				 = 0 ;
IfNrgNest(r,a) $ (transporta(a) and NOT LandTrpa(a)) = 0 ;
IfNrgNest(r,h) 										 = 0 ;

* Elasticity Between energy carriers in "fa" sectors when no NRG-Bundle

sigmae(r,fa,v) $ (NOT IfNrgNest(r,fa)) = 0.2 * sigmae(r,fa,v);

* Assumption: quasi-Leontieff for ely activities

sigmae(r,elya,v) $ (NOT IfNrgNest(r,elya)) = 0.05;

* As card(oil(nrg)) ne 1 on pourrait mettre une elasticite differente de sigmaolg

* If only one nest: so clean useless elasticities (Warning does not mean Leontieff)

sigmanely(r,a,v)    $ (NOT IfNrgNest(r,a)) = 0;
sigmaolg(r,a,v)     $ (NOT IfNrgNest(r,a)) = 0;
sigmaNRG(r,a,NRG,v) $ (NOT IfNrgNest(r,a)) = 0;

*------------------------------------------------------------------------------*
*               sigma_emi_prod : ES of CES(emissions)                          *
*------------------------------------------------------------------------------*

* MIT-EPPA values:
* substitution entre les gaz faible car representent des phenomenes different

sigmaemi(r,a,v)     = 0.05;
sigmaemi(r,frta,v)  = 0.1;

* as long as we always consider industrial gases with the same carbon price
* there is no reason to put sigmaemi ne 0, since the trade-off is between
* gases would become irrelevant :

* Assumption PFC-SF6

sigmaemi(r,NFMA,v)     = 0.0 ;
sigmaemi(r,frta,v)     = 0.0 ;
sigmaemi(r,fossilea,v) = 0.0 ;

sigmaemi(r,a,v) = 0 ;

*------------------------------------------------------------------------------*
*                   Power Bundle Elasticities                                  *
*------------------------------------------------------------------------------*

$IfTheni.PowerData %IfPower%=="ON"

*	This is for variant cases see below overrides when dynamic calibration

* Default for most configurations: etd is perfect complement to power

    sigmael(r,elyi) = 0;

*	Power bundle elasticities

    $$IfTheni.ElyBndNest %ElyBndNest%=="default"

        sigmapow(r,elyi)    = 1.2;
        sigmapb(r,pb,elyi) $ (NOT Allpb(pb)) = 1.5;

    $$ElseIfi.ElyBndNest %ElyBndNest%=="4Bundles"

        sigmapow(r,elyi)        = 5.0 ;
        sigmapb(r,"fosp",elyi)  = 4.0 ;
        sigmapb(r,"othp",elyi)  = 1.75;

* Better for variant with High Tax and actually Excepted othp all
* the other bundle are mostly BASELOAD and therefore substitutable

        sigmael(r,elyi)         = 0.00 ; !!#todo ajsutment BAU do not work if diff from Baseline

    $$ElseIfi.ElyBndNest %ElyBndNest%=="GIMF"

    $$ElseIfi.ElyBndNest  %ElyBndNest%=="ENV-LinkagesV3"

    $$ElseIfi.ElyBndNest  %ElyBndNest%=="1Bundle"

        sigmapow(r,elyi)    = 1.2 ;
        sigmapb(r,pb,elyi)  = 0 ;

    $$EndIf.ElyBndNest

* Default elasticities for Dynamic calibration (acting when %cal_NRG%=="OFF")

	IF(IfDyn and IfCal,

		sigmapb(r,pb,elyi) $ (NOT Allpb(pb)) = 1.2 ;
		sigmapow(r,elyi) = 1.1 ;

	) ;

$Else.PowerData

    sigmapow(r,elyi)   = 0 ;
    sigmapb(r,pb,elyi) = 0 ;
    sigmael(r,elyi)    = 0 ;

$ENDIF.PowerData

*------------------------------------------------------------------------------*
*   InvElas(r,i) : Elasticity cost of disinvestment of old capital         *
*------------------------------------------------------------------------------*

***HRR: hard coded: moved to AdjustSimOption of G20 agg
$ontext
invElas(OPEP,ELEa) = 2 ;

* Selected after identify issue in rrat for some year sectors

invElas(OLA,COAa) = 1.2 ;
$offtext
***endHRR

*------------------------------------------------------------------------------*
*           	Land CET-Bundle Elasticities                                   *
*------------------------------------------------------------------------------*

* Memo: with %UseIMPACT%=="ON", this is revised in calibration procedure:
* %CalDir%\2-0-dynamic_calibration_DefineTargets.gms

* Load values from external Scenario

$IF EXIST "%iGdxDir_ImportedScen%\%iFile_ImportedScen%.gdx" EXECUTE_LOADDC "%iGdxDir_ImportedScen%\%iFile_ImportedScen%.gdx", omegalb, omeganlb, etat, omegat;

* For variant Load pre-calibrated IMPACT land elasticities from BAU (if exist)

$IfTheni.ImpactElasticities %UseIMPACT%=="ON"

    $$IfThen.LandElasFile EXIST "%iDataDir%\IMPACT_Land_Elasticities.gdx"

        IF(NOT IfCal,
            omegalb(r,lb) = 0 ; omeganlb(r) = 0 ; omegat(r) = 0 ;
            EXECUTE_LOADDC "%iDataDir%\IMPACT_Land_Elasticities.gdx",
                omegalb, omeganlb, omegat ;
        ) ;

*	If we want to use IMPACT elasticities with Envisage calibration method

        $$IFtheni.ENVISAGE %DynCalMethod%=="ENVISAGE"
			IF(IfCal,
				omegalb(r,lb) = 0 ; omeganlb(r) = 0 ; omegat(r) = 0 ;
				EXECUTE_LOADDC "%iDataDir%\IMPACT_Land_Elasticities.gdx",
					omegalb, omeganlb, omegat ;
			) ;
        $$Endif.ENVISAGE

    $$Endif.LandElasFile

$Endif.ImpactElasticities

*   Memo: ENVISAGE values for CompStat model:

* V:\CLIMATE_MODELLING\archives\CGE_codes_ARC\model\etat_ENVISAGE.gms

