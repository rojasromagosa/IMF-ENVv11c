$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Model Simulation
	GAMS file    : "%ModelDir%\8-solve.gms"
	purpose      : instructions to solve the model
	Created by   : Dominique van der Mensbrugghe (file name solve.gms)
					+ modification by Jean Chateau for OECD-ENV (including CNS)
	Created date :
	called by    : %ModelDir%\%SimType%.gms
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/8-solve.gms $
	last changed revision: $Rev: 518 $
	last changed date    : $Date:: 2024-02-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$IF NOT SET ModelName $SetGlobal ModelName "%1"

option savepoint = 0 ;
***HRR: standard option 
*options limrow=0, limcol=0, solprint=off, threads = 32, solvelink = 5;
***HRR: option to run parselst
options limrow=0, limcol=0, solprint=off, threads = 32, solvelink = 5;



%ModelName%.tolinfrep = 1e-5;
* options iterlim=100000, reslim=100000;
%ModelName%.scaleopt = 1;

* OECD-ENV: Government closure rules

$include "%PolicyPrgDir%\Gov_Closure_Rules.gms"

*------------------------------------------------------------------------------*
*																			   *
*                       Regional-Models Resolution                             *
*																			   *
*------------------------------------------------------------------------------*

* [OECD-ENV]: add
rwork_bis(r) = savf.l(r,tsim);

rs(rr) = no ;
ifGbl  = 0 ;

*   Memo: default case nriter = 0 --> loop over countries is inactive

for(riter=1 to nriter by 1,

*  Loop over region, solved one by one

    loop(rr,

        rs(r)  = no  ;
        rs(rr) = yes ;

*   1.) Fix variables: PE prices, Trade flows and margins for all countries

* Fix PE prices (at previous values see "71-InitVar.gms")

        pe.fx(r,i,rp,tsim) $ xwFlag(r,i,rp)  = pe.l(r,i,rp,tsim) ;

* Fix all global flows

        xw.fx(r,i,rp,tsim) $ xwFlag(r,i,rp) = xw.l(r,i,rp,tsim) ;
        xtt.fx(r,img,tsim) $ xttFlag(r,img) = xtt.l(r,img,tsim) ;
        pdt.fx(r,img,tsim) $ xdtFlag(r,img) = pdt.l(r,img,tsim) ;

* Exogenize global trust (and remove corresponding equation)

        trustY.fx(tsim) = trustY.l(tsim) ;

* Exogenize remittance inflows

        remit.fx(r,l,rp,tsim) $ (not rs(rp)) = remit.l(r,l,rp,tsim) ;

*   2. Endogenize variables for the "acting" region 'rs'

* Endogenize 'rs' imports

        xw.lo(rp,i,r,tsim) $ (xwFlag(rp,i,r) and rs(r)) = -inf ;
        xw.up(rp,i,r,tsim) $ (xwFlag(rp,i,r) and rs(r)) = +inf ;

* Endogenize 'rs' export [not for Base Case where omegaw(r,i) eq inf)]

        xw.lo(r,i,rp,tsim) $ (xwFlag(r,i,rp) and rs(r) and omegaw(r,i) ne inf)
			= -inf ;
        xw.up(r,i,rp,tsim) $ (xwFlag(r,i,rp) and rs(r) and omegaw(r,i) ne inf)
			= +inf ;

* Endogenize pdt and xtt(img)

        pdt.lo(r,i,tsim)   $ (rs(r) and xdtFlag(r,i))   = -inf ;
        pdt.up(r,i,tsim)   $ (rs(r) and xdtFlag(r,i))   = +inf ;
        xtt.lo(r,img,tsim) $ (rs(r) and xttFlag(r,img)) = -inf ;
        xtt.up(r,img,tsim) $ (rs(r) and xttFlag(r,img)) = +inf ;

*   4.  Single-country Mode

       IF(IfENVLPrm,

* OECD-ENV: small open economy - endogenous current account walras is satisfied

            savf.lo(r,tsim) $ rs(r) = -inf;
            savf.up(r,tsim) $ rs(r) =  inf;
            walras.fx(t) = 0.0;

		ELSE

* [ENVISAGE]: Walras is not satisfied

			savf.fx(r,tsim) = rwork_bis(r) ;
*			rorg.fx(tsim)  = rorg.l(tsim-1);
		) ;

*   5.  solve single-country model

        $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%

		$$IF SET DebugDir $BatInclude "%DebugDir%\sub-RegionalWalras.gms" "Regional Model"

*   6. show country result on screen/txt

        work = outscale * walras.l(tsim);
        IF(%ModelName%.solvestat eq 1,
            put screen;
            put // "Solved iteration ", riter:<2:0, " out of ", nriter:2:0,
			" iteration(s) for region ", rr.tl:0, " in year: ", years(tsim):4:0,
			" -Regional Walras: ",  work // ;
            putclose screen;
            put declin;
            put // "Solved iteration ", riter:<2:0, " out of ", nriter:2:0,
			" iteration(s) for region ", rr.tl:0, " in year: ", years(tsim):4:0,
			" -Regional Walras: ",  work // ;
            putclose declin;
        else
*			PUT_UTILITY failedRegSim 'gdxout' / '%oDir%\' sim.tl:0 '_failed.gdx';
***HRR            PUT_UTILITY failedRegSim 'gdxout' / '%cFile%_failed.gdx';
***HRR			EXECUTE_UNLOAD ;
            put screen;
            put // "Failed to solve for iteration ", riter:<2:0,
			" out of ", nriter:2:0, " iteration(s) for region " rr.tl:0,
			" in year: ", years(tsim):4:0 // ;
            putclose screen;
            Abort$(1) "Solution failure line 145" ;
        ) ;

*   Option: Save country result

		IF(1 AND (ord(tsim) eq 2) OR (ord(tsim) gt 2 and (IfSaveYr eq 1)),
		    IF(ifMCP eq 1, PUT_UTILITY SaveCurrentYear 'Exec' / 'cp %ModelName%_p.gdx "%cFile%_mcp_%ModelName%_' tsim.tl:4:0 '_' rr.tl:0 '.gdx' ; ) ;
			IF(ifMCP eq 2, PUT_UTILITY SaveCurrentYear 'Exec' / 'cp %ModelName%_p.gdx "%cFile%_cns_%ModelName%_' tsim.tl:4:0 '_' rr.tl:0 '.gdx' ; ) ;
		) ;

    ) ;

) ;

*------------------------------------------------------------------------------*
*																			   *
*                       Solve the multi-country model                          *
*																			   *
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*                   include all regions again                                  *
*------------------------------------------------------------------------------*

rs(r) = yes ;
ifGbl = 1 ;

*   release bounds on variables fixed in individual solves
* and introduce original lower bounds

pe.lo(r,i,rp,tsim)    $ xwFlag(r,i,rp) = 0.001 * pe.l(r,i,rp,tsim) ;
pe.up(r,i,rp,tsim)    $ xwFlag(r,i,rp) = +inf ;
xw.lo(r,i,rp,tsim)    $ xwFlag(r,i,rp) = -inf ;
xw.up(r,i,rp,tsim)    $ xwFlag(r,i,rp) = +inf ;
pdt.lo(r,i,tsim)      $ xdtFlag(r,i)   = -inf ;
pdt.up(r,i,tsim)      $ xdtFlag(r,i)   = +inf ;
xtt.lo(r,img,tsim)    $ xttFlag(r,img) = -inf ;
xtt.up(r,img,tsim)    $ xttFlag(r,img) = +inf ;
trustY.lo(tsim)       $ trustY0 	   = -inf ;
trustY.up(tsim)       $ trustY0 	   = +inf ;
remit.lo(r,l,rp,tsim) $ remit0(r,l,rp) = -inf ;
remit.up(r,l,rp,tsim) $ remit0(r,l,rp) = +inf ;

* OECD-ENV: add-ons

pwgdp.lo(t) = -inf;
pwgdp.up(t) = inf;

IF(nriter,
    savf.fx(r,tsim) = rwork_bis(r) ;
    walras.up(tsim) =  inf;
    walras.lo(tsim) = -inf;
);

* OECD-ENV: Refining prices bounds [Option / By default OFF]

$Ifi IfDotLoUp=="ON" $batinclude "%DebugDir%\82-points_LoUp.gms" 0.001 "lo"
$Ifi IfDotLoUp=="ON" $batinclude "%DebugDir%\82-points_LoUp.gms" 1000  "up"

* [EditJean]: there is a bug I did not find so we need to re-write this

pdt.fx(r,i,tsim)   $ (not xdtFlag(r,i))         = 0;
alphadt(r,i,tsim)  $ (alphadt(r,i,tsim-1) eq 0) = 0;

*	Save data before a run (Debug option)

IF(IfUnLoadBeforeSim,
	$$Ifi %MultiRun%=="ON"  PUT_UTILITY savesim 'gdxout' / '%DirCheck%\' sim.tl:0 '_before_' tsim.tl:4:0 '.gdx';
	$$Ifi %MultiRun%=="OFF" PUT_UTILITY savesim 'gdxout' / '%DirCheck%\%SimName%_before_'    tsim.tl:4:0 '.gdx';
	EXECUTE_UNLOAD ;
) ;

IF(NOT IfSlicing,

*------------------------------------------------------------------------------*
*                   Base Case: No slicing procedure                            *
*------------------------------------------------------------------------------*

* OECD-ENV: add a procedure to cut shock in part (this only works for carbon)
* #TODO put this in step "Solve" of the program

    IF(IfCutInpart,
        $$batinclude "%PolicyPrgDir%\CutCarbonPolicyInpart.gms" %ModelName%
    ) ;

* Solve the Global model

*	PUT_UTILITY savesim 'gdxout' / 'CaseNoSlicing_' tsim.tl:4:0 '.gdx'; EXECUTE_UNLOAD xpv, xp, kv ;

    $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%

* OECD-ENV: read policy instructions and solve again Exple: BCA runs [Option]

    $$IF EXIST "%iFilesDir%\%PolicyFile%.gms"    $batinclude "%iFilesDir%\%PolicyFile%.gms"    "8-solve"
***HRR     $$IF EXIST "%PolicyPrgDir%\%PolicyFile%.gms" $batinclude "%PolicyPrgDir%\%PolicyFile%.gms" "8-solve"

*	OECD-ENV: dynamic calibration: adjust emissions to data (IfCalEmi) + re-run

    $$IfTheni.DynCalENV %DynCalMethod%=="OECD-ENV"
        $$IfTheni.DynCal NOT %SimType%=="Variant"

			IF(IfDynCalIn2Steps,

                $$include "%CalDir%\5-0-DYNAMIC_CALIBRATION_Solve.gms"

                $$If EXIST "%iFilesDir%\NumericalTricks.gms" $include "%iFilesDir%\NumericalTricks.gms"

*   Solve the Global model again

				$$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%
			) ;

        $$Endif.DynCal
    $$Endif.DynCalENV

*	OECD-ENV: Abort/Re-run if simulation fails

* Memo: the success condition is different according to the solver used

    work = 0;
    IF(%ModelName%.solvestat eq 1,
        work $ (%ModelName%.MODELSTAT eq 16 and ifMcp eq 2) = 1;
        work $ (%ModelName%.MODELSTAT < 5 and ifMcp eq 2 and optRec(tsim) gt 0) = 1;
        work $ (%ModelName%.MODELSTAT eq 1  and ifMcp eq 1) = 1;
        work $ (%ModelName%.MODELSTAT < 5  and ifMcp eq 3) = 1;
    )

    IF(NOT work,
***hrr        $$Ifi %MultiRun%=="ON"  PUT_UTILITY failedSim 'gdxout' / '%DirCheck%\' sim.tl:0 '_failed.gdx';
***hrr        $$Ifi %MultiRun%=="OFF" PUT_UTILITY failedSim 'gdxout' / '%cFile%_failed.gdx';
        EXECUTE_UNLOAD;
        put screen // "Failed to solve global model in year: ", years(tsim):4:0 //; putclose screen;
        IF(1,
            Abort$(1) "Solution failure line 277";
        ELSE
            IF(ifMcp eq 1,
                ifMCP = 2; rrat.up(r,a,tsim) = inf;
                put screen // "Re-simulate with CONOPT/CNS" //; putclose screen;
                $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%
            ) ;
            IF(ifMcp eq 2,
                ifMCP = 1; rrat.lo(r,a,tsim) = 1e-6; rrat.up(r,a,tsim) = 1;
                put screen // "Re-simulate with MCP" //; putclose screen;
                $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%
            ) ;
            work = outscale * walras.l(tsim);
        ) ;
    ) ;
) ;

*------------------------------------------------------------------------------*
* Slicing Case: slice the shocks by smaller and smaller shocks until success   *
*------------------------------------------------------------------------------*

IF(IfSlicing,

* memo: Slicing has to come before GHG calibration

* starting with 100% of shock

	Display "Slicing Procedure is active";

    $$IFi %IfSlicing%=="ON" $$BatInclude "%DebugDir%\slicing.gms" "8-solve"

*	OECD-ENV: read policy instructions and solve again Exple: BCA runs [Option]

    $$IF EXIST "%iFilesDir%\%PolicyFile%.gms"    $batinclude "%iFilesDir%\%PolicyFile%.gms"    "8-solve"
***HRR    $$IF EXIST "%PolicyPrgDir%\%PolicyFile%.gms" $batinclude "%PolicyPrgDir%\%PolicyFile%.gms" "8-solve"

    $$IfTheni.DynCalENV %DynCalMethod%=="OECD-ENV"
        $$IfTheni.BAU NOT %SimType%=="Variant"

		IF(IfDynCalIn2Steps,
			IfSlicing = 0;
            $$batinclude "%CalDir%\5-0-dynamic_calibration_Solve.gms"
*    		 $BatInclude "%DebugDir%\slicing.gms" "8-solve" ;
            $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%
		) ;

        $$Endif.BAU
    $$Endif.DynCalENV

) ;


*------------------------------------------------------------------------------------------------------*
*       [IMF-ENV]: Emission calibration and re-run model in Baseline           *
*------------------------------------------------------------------------------------------------------*

**************************************************************************************************************
*** Total GHG emission projection calibration 

$iftheni.new not %GroupName%=="2024_MCD"
$iftheni.emitot %ifEmiTotcal%=="ON"


* Default -> no calibration of total emissions
    IfCalEmi(r,em,EmiSource,aa) = 0;

    $$iftheni.bau %SimType%=="Baseline"
*$ontext
*Set IfCalEmi to one if historical data or zero if projections available
        IfCalEmi(r,CO2,"allsourceinc",tot)$ (PROJ_CO2(r,tsim)) = 1 ;
        IfCalEmi(r,AllGHG,"allsourceinc",tot)$ (PROJ_GHG(r,tsim)) = 1 ;
***HRR: this requires to have either LULUCF or GHG projections separated! So I switch it off for now
*        emi.fx(r,CO2,"lulucf",lulucfa,tsim)$Proj_GHG_LULUCF(r,tsim) = cScale* (Proj_GHG_LULUCF(r,tsim)-Proj_GHG(r,tsim))/sum(lulucfa0,emi0(r,CO2,"lulucf",lulucfa0));

$ondotl
* Option 1: Calibrating  CO2 emissions
    IF(sum((r,CO2) $ ifCalEmi(r,CO2,"allsourceinc","tot"), 1),
        chiEmi.lo(r,CO2,tsim) $ (PROJ_CO2(r,tsim)) = - inf ;
        chiEmi.up(r,CO2,tsim) $ (PROJ_CO2(r,tsim)) = + inf ;
        emiTot.fx(r,CO2,tsim) $ PROJ_CO2(r,tsim)
            = [cScale * PROJ_CO2(r,tsim)
*          + sum((emilulucf,lulucfa), m_true4(emi,r,CO2,emilulucf,lulucfa,tsim))
              ]/ emiTot0(r,CO2) ;

        emiTot.lo(r,CO2,tsim) $ (NOT PROJ_CO2(r,tsim)) = - inf;
        emiTot.up(r,CO2,tsim) $ (NOT PROJ_CO2(r,tsim)) = + inf ;

        IfCalEmi(r,CO2,emiSourceAct,aa) =1;
$offdotl
);
**End CO2 emissions loop

* Option 2: Calibration all GHGs together
    IfCalEmi(r,AllGHG,"allsourceinc",tot)$ (PROJ_GHG_LULUCF(r,tsim)) = 1 ;

        LOOP((r,AllGHG) $ IfCalEmi(r,AllGHG,"allsourceinc","tot"),

                IfCalEmi(r,em,emiSourceAct,aa) $ (PROJ_GHG(r,tsim) AND EmSingle(em) and not CO2(em)) = 2 ;

                chiTotEmi.lo(r,tsim) $ (PROJ_GHG(r,tsim)) = -inf ;
                chiTotEmi.up(r,tsim) $ (PROJ_GHG(r,tsim)) = inf ;

                emiTotAllGHG(r,t)$ PROJ_GHG_LULUCF(r,tsim)   = [cScale * PROJ_GHG_lulucf(r,tsim)]  ;
                emiTotNonCO2(r,tsim)$ PROJ_GHG(r,tsim) = 0;

** To calibrate each GHG separately define emitotnonCO2 and set emitotallghg to 0
** <Check if next line should be PROJ_GHG_LULUCF or just PROJ_GHG>
*               emiTotNonCO2(r,tsim)$ PROJ_GHG(r,tsim)   = [cScale * (PROJ_GHG(r,tsim)-PROJ_CO2(r,tsim))]  ;
*               emiTotNonCO2(r,t)$ PROJ_GHG(r,tsim)      = [cScale * PROJ_GHG_lulucf(r,tsim)]  ;
*               emiTotAllGHG(r,tsim)$ PROJ_GHG(r,tsim) = 0;
        ) ;
*$offtext


***HRR: Running the EmiTotCal procedure from here, as it does not provide exact fits when run from BauShk.gms
*        $$if exist "%iFilesDir%\EmiTotCal.gms" $include "%iFilesDir%\EmiTotCal.gms"

* Solve again the model
        $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%

    $$Endif.bau



$endif.emitot
$endif.new

*------------------------------------------------------------------------------*
*  		Save model solution for the current year, optionally re-run 		   *
*------------------------------------------------------------------------------*

IF(0 AND year eq 2015,
	PUT_UTILITY savesim 'gdxout' / '%cFile%_AfterSolve_' tsim.tl:4:0 '.gdx';
	EXECUTE_UNLOAD ;
) ;

*	1a.) Save solution for the current year in folder "%iDataDir%"

* Memo the first year is always saved

IF((ord(tsim) eq 2) or (ord(tsim) gt 2 and (IfSaveYr eq 1)),
    IF(ifMCP eq 1, PUT_UTILITY SaveCurrentYear 'Exec' / 'cp %ModelName%_p.gdx "%iDataDir%\mcp_%ModelName%_' tsim.tl:4:0 '.gdx"'; );
    IF(ifMCP eq 2, PUT_UTILITY SaveCurrentYear 'Exec' / 'cp %ModelName%_p.gdx "%iDataDir%\cns_%ModelName%_' tsim.tl:4:0 '.gdx"'; );
) ;

*	1b.) Save solution for the current year in folder "%SimDir%"

IF((ord(tsim) gt 2) AND (IfSaveYr eq 2),
    IF(ifMCP eq 1, PUT_UTILITY SaveCurrentYear 'Exec' / 'cp %ModelName%_p.gdx "%SimDir%\mcp_%ModelName%_' tsim.tl:4:0 '.gdx"'; );
    IF(ifMCP eq 2, PUT_UTILITY SaveCurrentYear 'Exec' / 'cp %ModelName%_p.gdx "%SimDir%\cns_%ModelName%_' tsim.tl:4:0 '.gdx"'; );
);

*	2.) Re_run with alternative Solver and save corresponding solution year

IF(IfReRun,
    $$IF SET DebugDir $BatInclude "%DebugDir%\83-ReRunWithAltSolver.gms" "%ModelName%"
) ;

*	3.)  save some information model runs

$IF SET DebugDir $BatInclude "%DebugDir%\84-etat_statut.gms" "%ModelName%"

work = outscale * walras.l(tsim);
IF(NOT IfSlicing, display "Year & Walras: (no slicing case)", year, work ; ) ;

*------------------------------------------------------------------------------*
*                   Update some variables                                      *
*------------------------------------------------------------------------------*
$onDotL

*   Update normalized prices  (default: IfSub=1)

IF(IfSub,

    pp.l(r,a,tsim)     $ xpFlag(r,a)    = PP_SUB(r,a,tsim) ;
    pa.l(r,i,aa,tsim)  $ xaFlag(r,i,aa) = PA_SUB(r,i,aa,tsim) ;
    pd.l(r,i,aa,tsim)  $ xdFlag(r,i,aa) = PD_SUB(r,i,aa,tsim) ;
    pm.l(r,i,aa,tsim)  $ xmFlag(r,i,aa) = PM_SUB(r,i,aa,tsim) ;
    pwe.l(r,i,rp,tsim) $ xwFlag(r,i,rp) = PWE_SUB(r,i,rp,tsim) ;
    pwm.l(r,i,rp,tsim) $ xwFlag(r,i,rp) = PWM_SUB(r,i,rp,tsim) ;
    pdm.l(r,i,rp,tsim) $ xwFlag(r,i,rp) = PDM_SUB(r,i,rp,tsim) ;
* [EditJean]:pwmg no scale in OECD-ENV
    pwmg.l(r,i,rp,tsim) $ tmgFlag(r,i,rp) = PWMG_SUB(r,i,rp,tsim) ;
    xwmg.l(r,i,rp,tsim) $ tmgFlag(r,i,rp) = XWMG_SUB(r,i,rp,tsim) ;
    xmgm.l(img,r,i,rp,tsim) $ amgm(img,r,i,rp) = XMGM_SUB(img,r,i,rp,tsim) ;
    wagep.l(r,l,a,tsim) $ labFlag(r,l,a) = WAGEP_SUB(r,l,a,tsim) ;
) ;

*   Re adjust emission coefficient (after optional calibration)

If(ifCal,

    emir(r,AllEmissions,EmiSource,aa,tsim)
		= m_emir(r,AllEmissions,EmiSource,aa,tsim) ;
    LOOP(emiact,
        aemi(r,AllEmissions,a,v,tsim) $ ifEndoMAC
		= m_chiEmi(r,AllEmissions,emiact,a,tsim) * aemi(r,AllEmissions,a,v,tsim) ;
    ) ;
);
***HRR
if(ifCal eq 0, 
*     aemi(r,AllEmissions,a,v,tsim) $ ifEndoMAC  = aemi_bau(r,AllEmissions,a,v,tsim) ; 
) ;
****endHRR

*   [OECD-ENV]: update primary factor efficiency

$OnText
   Note: Warning TFP_fp is defined as equal to 1 and only shocked relative
   to previous year, so need to re-scale fp efficiency parameters
$OffText
***HRR: For some reason TFP_fp is zero (last defined in 7-interloop )
*     TFP_fp.l(r,a,tsim) $ xpFlag(r,a) = 1; 

IF(year gt FirstYear,

    lambdak.fx(r,a,v,tsim)   $ kFlag(r,a)     = m_lambdak(r,a,v,tsim)   ;
    lambdat.fx(r,a,v,tsim)   $ landFlag(r,a)  = m_lambdat(r,a,v,tsim)   ;
    lambdanrf.fx(r,a,v,tsim) $ nrfFlag(r,a)   = m_lambdanrf(r,a,v,tsim) ;
    lambdal.fx(r,l,a,tsim)   $ labFlag(r,l,a) = m_lambdal(r,l,a,tsim)   ;

*   OECD-ENV: update marginal propensity to consume

* adjust muc's to savings-adjustment parameter (betac's)

*     muc.fx(r,k,h,tsim) $ ( IfCalMacro(r,invshr) eq 1)
*         = m_beta(r,h,k,tsim) * muc.l(r,k,h,tsim) ;
*
*     mus.fx(r,h,tsim)
*         $ ( m_true(supy(r,h,tsim)) * m_true(pop(r,tsim)) )
*         =   m_true(savh(r,h,tsim))
*         / ( m_true(supy(r,h,tsim)) * m_true(pop(r,tsim))) ;

) ;

*   OECD-ENV: update total "controlled" sectoral emission

IF(NOT Ifemiaeq,
    emia.l(r,a,AllEmissions,tsim) $ emia0(r,a,AllEmissions)
        = sum( EmiSourceAct $ emi0(r,AllEmissions,EmiSourceAct,a),
               part(r,AllEmissions,EmiSourceAct,a,tsim) *
               m_true4(emi,r,AllEmissions,EmiSourceAct,a,tsim)
              ) /  emia0(r,a,AllEmissions) ;
) ;

* [OECD-ENV]: update Ratio Efficient Capital to efficient Labour

$OnText
*    (not normalized e.g. not divided by chiKaps0(r))
    kaplab.fx(r,tsim)
        = sum((a,v) $ kFlag(r,a), lambdak.l(r,a,v,tsim)
        * [m_CESadj * sum(t0,m_pkp(r,a,v,t0) / lambdak.l(r,a,v,t0))]
        * m_true3vt(kv,r,a,v,tsim))
        / sum((a,l) $ labFlag(r,l,a), lambdal.l(r,l,a,tsim)
        * [m_CESadj * sum(t0,wagep.l(r,l,a,t0) / lambdal.l(r,l,a,t0))]
        * m_trueld(r,l,a,tsim))) ;
    put screen ; put // ; loop((r,l,a)$(NOT wagep0(r,l,a)), put r.tl, l.tl, a.tl / ; ) ;
$OffText

*   Update income and price elasticities

* OECD-ENV: included adjusted beta if saving/investment is calibrated via beta

omegaad.fx(r,h)
      = {sum(k $ xcFlag(r,k,h),  [betaad.l(r,k,h,tsim)-alphaad.l(r,k,h,tsim)]
            * log( m_true3(xc,r,k,h,tsim) / m_true1(pop,r,tsim) - m_true3(theta,r,k,h,tsim)) )
        - power( 1 + exp(m_true2(u,r,h,tsim)),2) * exp( -m_true2(u,r,h,tsim))
        } $ { %utility% eq AIDADS }

      + 1 $ { %utility% ne AIDADS }
      ;

omegaad.fx(r,h) = 1 / omegaad.l(r,h) ;

etah.l(r,k,h,tsim) $ xcFlag(r,k,h)

   = {m_beta(r,h,k,tsim) * m_true3(muc,r,k,h,tsim) * m_true1(yd,r,tsim)
        / [m_true3(xc,r,k,h,tsim) * m_true3(pc,r,k,h,tsim)]
     } $ { %utility% eq ELES }

   + { [m_true3(muc,r,k,h,tsim) - [betaad.l(r,k,h,tsim)-alphaad.l(r,k,h,tsim)] * omegaad.l(r,h)]
       / m_true3(hshr,r,k,h,tsim)
     } $ { %utility% eq AIDADS or %utility% eq LES }

   + {[eh.l(r,k,h,tsim)*bh.l(r,k,h,tsim)
        - sum(kp $ xcFlag(r,kp,h), m_true3(hshr,r,kp,h,tsim) * eh.l(r,kp,h,tsim) * bh.l(r,kp,h,tsim))]
      / sum(kp $ xcFlag(r,kp,h), m_true3(hshr,r,kp,h,tsim) * eh.l(r,kp,h,tsim) )
      - [ bh.l(r,k,h,tsim) - 1 ]
      + sum(kp $ xcFlag(r,kp,h), m_true3(hshr,r,kp,h,tsim) * bh.l(r,kp,h,tsim) )
    } $ { %utility% eq CDE }
   ;

epsh.l(r,k,kp,h,tsim) $ (xcFlag(r,k,h) and xcFlag(r,kp,h))

   = {- m_beta(r,h,k,tsim) * m_true3(muc,r,k,h,tsim) * m_true3(pc,r,kp,h,tsim)
        * m_true1(pop,r,tsim) * m_true3(theta,r,kp,h,tsim)
        / [m_true3(xc,r,k,h,tsim) * m_true3(pc,r,k,h,tsim)]
      - kron(k,kp) * [1 - m_true3(theta,r,k,h,tsim) * m_true1(pop,r,tsim) / m_true3(xc,r,k,h,tsim)]
     } $ {%utility% eq ELES}

   + {[m_true3(muc,r,kp,h,tsim)-kron(k,kp)]
        *  [m_true3(muc,r,k,h,tsim) * m_true2(supy,r,h,tsim)]
        /  [m_true3(hshr,r,k,h,tsim) * [ m_true1(yd,r,tsim)- m_true2(savh,r,h,tsim)] / m_true1(pop,r,tsim) ]
        - m_true3(hshr,r,kp,h,tsim) * etah.l(r,k,h,tsim)
     } $ { %utility% eq AIDADS or %utility% eq LES}

   + {m_true3(hshr,r,kp,h,tsim)
        * [ - bh.l(r,kp,h,tsim)
            - [eh.l(r,k,h,tsim) * bh.l(r,k,h,tsim)
                - sum(k1 $ xcFlag(r,k1,h), m_true3(hshr,r,k1,h,tsim)*eh.l(r,k1,h,tsim)*bh.l(r,k1,h,tsim))
              ] / sum(k1 $ xcFlag(r,k1,h), m_true3(hshr,r,k1,h,tsim)*eh.l(r,k1,h,tsim))
          ]
      + kron(k,kp) * [bh.l(r,k,h,tsim)-1]
      } ${%utility% eq CDE}
   ;

$OffDotL

$droplocal ModelName


