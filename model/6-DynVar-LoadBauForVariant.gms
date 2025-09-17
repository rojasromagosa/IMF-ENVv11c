$OnText
--------------------------------------------------------------------------------
            OECD-ENV Model version 1.0 - Core program
	GAMS file   : "%ModelDir%\6-DynVar-LoadBauForVariant.gms"
	purpose     : Load bau values : variables & calibrated parameters
				  for variant mode simulations
	Created by  : Dominique Van Der Mensbrugghe for ENVISAGE part
				  Jean Chateau for OECD-ENV part
	Created date: winter 2021
	called by   : %ModelDir%\Variant.gms
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/6-DynVar-LoadBauForVariant.gms $
	last changed revision: $Rev: 518 $
	last changed date    : $Date:: 2024-02-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
	execute_loadpoint "%BauFile%.gdx": on lit les valeurs du baseline *.l
	mais pas *.lo et *.up, si on veut les bornes  il faut execute_loaddc
	ne faudrait it pas relire "closure.gms"
	#todo : faudrait pouvoir lire fichiers d'autres folders
	[2022-12-08]: #Rev114 remove instructions relative to %BaseName%=="2021USA"
--------------------------------------------------------------------------------
$OffText

$OnDotL

*-------------          [ENVISAGE] PART            ----------------------------*

* These instructions were in ENVISAGE in the file "%ProjectDir\%BaseName%Opt.gms"

*   Load values from the baseline (if it exists)

* PUT EXECUTE_LOAD and not EXECUTE_LOADDC in case we change YearEndofSim relative to baseline

$ifThen.ReadBauValue exist "%BauFile%.gdx"

* Load "*.l" variables

    execute_loadpoint "%BauFile%.gdx" ;

* Load pre-calibrated parameters or Fixed variables (with bound)

    execute_load "%BauFile%.gdx",
        alphadt, alphamt, alphad, alpham, alphaw, alphafd, apb, as,
        lambdaw, lambdamg, lambdaxd, lambdaxm, lambdamg,
        popWA, LFPR_bau=LFPR.l, UNR_bau=UNR.l,
        $$Ifi %cal_IOs%=="LOAD" aio,
        rgdppcT, theta, muc, mus, rsg,
        savfBar=savf.l, savf_bau=savf.l, 
        $$Ifi %ifElyMixCal%=="ON" ElyMixCal,  !!***what is the purpose of this?       tfp_xpv_bau=tfp_xpv.l,
        tfp_xpv, 
        $$Ifi %ifEmiTotCal%=="ON" EmiTotCal, chiTotEmi_bau=chiTotEmi.l, aemi_bau=aemi,
*        $$Ifi %ifWEOsavcal%=="ON" savg_bau=savg.l,
        ygov_bau=ygov.l, gva_gdpbau=gva_gdp,  GDP_realbau= GDP_real,
        TermsOfTradeT_bau=TermsOfTradeT,
		gamlb,
        lambdaw_bau=lambdaw,
* Not used in variant mode but since declared need to provide some values

        tteff, gtLab.l, glabT, glAddShft, glMltShft,

        g_nrf, g_natr, chiEmi, chiTotEmi,

* Taxes (generally fixed in baseline, excepted kappah / trg)

        kappah, kappal, kappak, kappat, kappan, kappaw, trg,
        Taxfp, Subfp, ptax, uctax,
        etax, mtax, paTax, pdtax,
        p_emissions, emiTax, phipwi,
        $$Ifi %BaseName%=="2024_MCD_MAR" chiVat, chiPtax,

* For calibrated saving rates

		ifksav,

* Growth rates for efficiency parameters

        g_kt, g_fp, g_io, g_xpx, g_xs,

* parameter to convert USD in year t to USD of the model (%YearBaseMER%)
* This Equivalent to pgdp("%YearBaseMER%") / pgdp(t)

    ConvertCurToModelUSD, ypc

    ;

* Fix variables endogenous in Baseline (for most variables this is done in "7-iterloop.gms")

*** changed AllEmissions for emSingle to avoid creating a 32m obs variable
    chiEmi.fx(r,emSingle,t) = 0 ;
***HRR: needs to be equated to baseline when ifEmiTotCal==ON
*** fix emission intensities to match baseline

$$iftheni %ifEmiTotCal%=="ON" 
*    IfCalEmi(r,em,EmiSourceAct,aa) $ MAR(r) = 2 ;
    chiTotEmi.fx(r,t) = chiTotEmi_bau(r,t) ;
$$endif

***HRR added conditional to not populate this variable if not necessary
    chiEmiDet.fx(r,emSingle,EmiSource,aa,t) $ (IfCalEmi(r,emSingle,EmiSource,aa) eq 3 )= 0 ;

*-------------          OECD-ENV ADDS              ----------------------------*

* Calculate bau variables

    xp_bau(r,a,t)    $ xp0(r,a,t)   =  xp.l(r,a,t)  ;
    nd1_bau(r,a,t)   $ nd10(r,a,t)  = nd1.l(r,a,t)  ;
    nd2_bau(r,a,t)   $ nd20(r,a,t)  = nd2.l(r,a,t)  ;
    lab1_bau(r,a,t)  $ lab10(r,a,t) = lab1.l(r,a,t) ;
    lab2_bau(r,a,t)  $ lab20(r,a)   = lab2.l(r,a,t) ;
    xat_bau(r,i,t)   $ xat0(r,i,t)  = xat.l(r,i,t)  ;
    xa_bau(r,i,aa,t) $ xa0(r,i,aa,t)= xa.l(r,i,aa,t);
    ps_bau(r,i,t)    $ ps0(r,i)     = ps.l(r,i,t)   ;
    xs_bau(r,i,t)    $ xs0(r,i)     = xs.l(r,i,t)   ;
    kv_bau(r,a,v,t)  $ kv0(r,a,t)   = kv.l(r,a,v,t) ;
    xfd_bau(r,fd,t)  $ xfd0(r,fd)   = xfd.l(r,fd,t) ;

	rgdpmp_bau(r,t)  = rgdpmp.l(r,t)  ;
	gdpmp_bau(r,t)	 = gdpmp.l(r,t)   ;

    rsg_bau(r,t)    = rsg.l(r,t) ;

* Baseline: Real average wage (indexed by CPI)

    rwage_bau(r,l,z,t) = 0;
    rwage_bau(r,l,z,t) = m_netwage(r,l,z,t) / sum(h,PI0_xc.l(r,h,t));

* Fixed in Variant

    UNR.fx(r,l,z,tsim)   = UNR_bau(r,l,z,tsim);
    popWA.fx(r,l,z,tsim) = popWA.l(r,l,z,tsim);

*   Load time-dependent scales

    IF(ifDyn and (IfDynScaling eq 3),
        EXECUTE_LOAD "%BauFile%.gdx", x0, xp0, nd10, va0, va10, xpx0,
        lab10, ld0, kef0, kf0, ks0, kv0, ksw0, va20, nd20, xa0, xnrg0, xnely0,
        xolg0, xaNRG0, land0, k00, xpv0, xpb0, xpow0, xat0, pxghg0 ;
    ) ;

$Else.ReadBauValue

    Abort "Baseline is undefined" ;

$Endif.ReadBauValue

*------------------------------------------------------------------------------*
* 			OECD-ENV model: Load climate policy from %EMIBauFile%			   *
*------------------------------------------------------------------------------*

*	Baseline emission variable

$ifTheni.ReadEmiBauValue %cal_GHG%=="LOAD"

	execute_load "%EMIBauFile%.gdx",
		emi_bau=emi.l, emitot_bau=emitot.l, p_emissions_bau=p_emissions
		emi_ref=emi.l, emitot_ref=emitot.l, p_emissions_ref=p_emissions,
		emiTax_ref=emitax.l, part,
		emiTax, part, p_emissions,
		emir, emird, emirm ;
	execute_loadpoint "%EMIBauFile%.gdx", emi ;

    IF(ifEndoMAC,
		execute_load      "%EMIBauFile%.gdx", aemi, aoap, aghg ;
        execute_loadpoint "%EMIBauFile%.gdx", xghg, pxghg, xoap, pxoap ;
    ) ;

* Does not work --> [TBU]

$OnText
    aghg(r,a,v,t) $ (xpFlag(r,a) and ghgFlag(r,a) and ifEndoMAC
                        and not t0(t) and m_true3v(xghg,r,a,v,t))
        = [m_true3v(xghg,r,a,v,t) / m_true3vt(xpv,r,a,v,t)]
        * [TFP_xpv.l(r,a,v,t) * lambdaghg.l(r,a,v,t)]**(1-sigmaxp(r,a,v))
        * [m_true3v(pxghg,r,a,v,t) / m_true3v(uc,r,a,v,t)]**sigmaxp(r,a,v)
        ;

    aghg(r,a,v,t) $(aghg(r,a,v,t) lt 0) = 0 ;

    LOOP(emiact ,

        aemi(r,em,a,v,t)
            $ (xpFlag(r,a) and ghgFlag(r,a) and pxghg.l(r,a,v,t) and ifEndoMAC
                    and not t0(t) and aghg(r,a,v,t))
            = [emi_ref(r,em,emiact,a,t) * emi0(r,em,emiact,a) / m_true3v(xghg,r,a,v,t)]
            * [lambdaemi(r,em,a,v,t)**(1-sigmaemi(r,a,v))]
            * [{part(r,em,emiact,a,t) * emiTax_ref(r,em,t) + p_emissions_bau(r,em,emiact,a,t)}
                / m_true3v(pxghg,r,a,v,t)]**sigmaemi(r,a,v)
            ;

        aemi(r,em,a,v,t) $ (aemi(r,em,a,v,t) lt 0) = 0 ;
        aemi(r,oap,a,v,t)
            $ (xpFlag(r,a) and OAPFlag(r,a) and pxoap.l(r,a,v,t) and ifEndoMAC and not t0(t) and m_true3v(xoap,r,a,v,t))
            = (m_true4(emi,r,oap,emiact,a,t) / m_true3v(xoap,r,a,v,t))
            * [lambdaemi(r,oap,a,v,t)**(1-sigmaemi(r,a,v))]
            * [m_EmiPrice(r,oap,emiact,a,t)
                / m_true3v(pxoap,r,a,v,t)]**sigmaemi(r,a,v) ;
    ) ;
$OffText

$Endif.ReadEmiBauValue

*------------------------------------------------------------------------------*
*       OECD-ENV. NDC Targets for countries with target wrt BAU emissions      *
*------------------------------------------------------------------------------*

$IfTheni.NDCtgt NOT %BaseYearCW%=="OFF"

	PARAMETERS
		NDCCW(TypeNDC,r)
		NDC2030(r,Tgt)
		HIST_GHG(CW_DB,r,Tgt,tt)
	;

	execute_loaddc "%EMIBauFile%.gdx", NDCCW, NDC2030, HIST_GHG;

	LOOP(r $ NDCCW("redBauUnCond",r),
		NDC2030(r,"GHG_Lulucf")
			= (1 -  NDCCW("redBauUnCond",r) * 0.01)
			* sum(EmSingle,m_true2b(emiTot,bau,r,EmSingle,"2030")) / cScale;

		rwork(r) = 0 ;
		rwork(r)	=	{  HIST_GHG("UNFCCC",r,"GHG_Lulucf","%BaseYearCW%")
						 - HIST_GHG("UNFCCC",r,"GHG","%BaseYearCW%")
						} $ { HIST_GHG("UNFCCC",r,"GHG","%BaseYearCW%")}
					+ 	{  HIST_GHG("CAIT",r,"GHG_Lulucf","%BaseYearCW%")
						 - HIST_GHG("CAIT",r,"GHG","%BaseYearCW%")
						} $ {NOT HIST_GHG("UNFCCC",r,"GHG","%BaseYearCW%")}	;

		NDC2030(r,"GHG") $ (NDC2030(r,"GHG_Lulucf") and rwork(r))
			= NDC2030(r,"GHG_Lulucf") - rwork(r) ;

		NDC2030(r,"CO2")
			= (1 -  NDCCW("redBauUnCond",r) * 0.01)
			* sum(CO2,m_true2b(emiTot,bau,r,CO2,"2030")) / cScale;
		rwork(r) = 0 ;
		rwork(r) =	{  HIST_GHG("UNFCCC",r,"CO2","%BaseYearCW%")
					 / HIST_GHG("UNFCCC",r,"GHG","%BaseYearCW%")
					} $ { HIST_GHG("UNFCCC",r,"GHG","%BaseYearCW%")}
				+ 	{   HIST_GHG("CAIT",r,"CO2","%BaseYearCW%")
					 / HIST_GHG("CAIT",r,"GHG","%BaseYearCW%")
					} $ { NOT HIST_GHG("UNFCCC",r,"GHG","%BaseYearCW%")
						  AND HIST_GHG("CAIT",r,"GHG","%BaseYearCW%")}	;

		NDC2030(r,"CO2") $ 	(NDC2030(r,"GHG") AND rwork(r))
			= NDC2030(r,"CO2") * rwork(r);
	) ;

* Special case for Saudi

	NDC2030(r,Tgt) $ sau(r)
		= sum(EmSingle,m_true2b(emiTot,bau,r,EmSingle,"2030")) / cScale
		- NDC2030(r,Tgt);

$Endif.NDCtgt

*------------------------------------------------------------------------------*
*                       OECD-ENV: Recalibrate Energy                           *
*------------------------------------------------------------------------------*

$ifTheni.ReadNRGBauValue %cal_NRG%=="LOAD"

*   Load Energy baseline

    execute_load "%NrgBauFile%.gdx",
        aeei, aeeic, lambdae, lambdace,
        lambdapow_bau=lambdapow, lambdapb_bau=lambdapb,
        x_bau=x.l, ppb_bau=ppb.l, p_bau=p.l, ppbndx_bau=ppbndx.l,
		xpow_bau=xpow.l, ppow_bau=ppow.l, xpb_bau=xpb.l, ppowndx_bau=ppowndx.l,
*        TFP_xpx_fossile_bau=TFP_xpx.l, g_natr,
        TFP_xs_bau=TFP_xs.l,
        lambdae_bau = lambdae.l, lambdace_bau = lambdace.l,
        muc_nrg_bau=muc.l, theta_nrg_bau=theta.l
    ;

*	lambdapow(r,pb,elyi,t)   = lambdapow_bau(r,pb,elyi,t)  ;
*	lambdapb(r,elya,elyi,t)  = lambdapb_bau(r,elya,elyi,t) ;

*   Re-calibrate Power system from Baseline Values

$OnText

	The structure of Power system may differ between baseline (IfElyCES = 0)
	and variant (IfElyCES = 1), so the recalibration maybe tricky.

	In the case IfPowerVol=1 then p.l(r,powa,elyi,t) and ppb.l(r,pb,elyi,t)
	are not	equal to 1.
	If in addition we have IfCoeffCes = 1 then the calibration of lambdapow
	and lambdapb is not the same for different values of IfElyCES.

	So here we should not read lambdapow & lambdapb from the baseline but keep
	the calculation from "4-init.gms", actually as long as we do not change
	these efficiency parameters in the baseline this is not a problem. If we
	change it we need to review this re-calibration procedure.

	Warning re-calibration for CES case (IfElyCES = 1) imply that sum of
	coefficients no more equal to one.

$Offtext

    IF(IfPower and IfRecal,

        as(r,etda,elyi,t) $ m_true2b(xs,bau,r,elyi,t)
            = [m_true3bt(x,bau,r,etda,elyi,t) / m_true2b(xs,bau,r,elyi,t)]
            * TFP_xs_bau(r,elyi,t)**(1 - sigmael(r,elyi))
            * [m_true3b(p,bau,r,etda,elyi,t) / m_true2b(ps,bau,r,elyi,t)]**sigmael(r,elyi)
            ;

        apow(r,elyi,t)  $ m_true2b(xs,bau,r,elyi,t)
            = [ m_true2bt(xpow,bau,r,elyi,t) / m_true2b(xs,bau,r,elyi,t)]
            * TFP_xs_bau(r,elyi,t)**(1 - sigmael(r,elyi))
            * [m_true2b(ppow,bau,r,elyi,t) / m_true2b(ps,bau,r,elyi,t)]**sigmael(r,elyi)
			;

        IF(IfElyCES,

* CES case:

            apb(r,pb,elyi,t) $ (xpb0(r,pb,elyi,t) and xpow_bau(r,elyi,t))
                = [m_true3bt(xpb,bau,r,pb,elyi,t) / m_true2bt(xpow,bau,r,elyi,t)]
                * [ m_true3b(ppb,bau,r,pb,elyi,t) / m_true2b(ppow,bau,r,elyi,t) ]**sigmapow(r,elyi)
                * [lambdapow(r,pb,elyi,t)**(1 - sigmapow(r,elyi))]
				;

            LOOP((r,powa,pb,elyi) $ mappow(pb,powa) ,
                as(r,powa,elyi,t) $ (x0(r,powa,elyi,t) AND xpb_bau(r,pb,elyi,t))
                    = [ m_true3bt(x,bau,r,powa,elyi,t) / m_true3bt(xpb,bau,r,pb,elyi,t) ]
                    * [ m_true3b(p,bau,r,powa,elyi,t)  / m_true3b(ppb,bau,r,pb,elyi,t) ]**sigmapb(r,pb,elyi)
                    * [lambdapb(r,powa,elyi,t)**(1 - sigmapb(r,pb,elyi))]
					;
            ) ;

        ELSE

* Additive-CES case:

			apb(r,pb,elyi,t) $ (xpb0(r,pb,elyi,t) and xpow_bau(r,elyi,t))
				= [m_true3bt(xpb,bau,r,pb,elyi,t) / m_true2bt(xpow,bau,r,elyi,t)]
				* [ m_true3b(ppb,bau,r,pb,elyi,t) / m_true2b(ppowndx,bau,r,elyi,t)]**sigmapow(r,elyi)
				* lambdapow(r,pb,elyi,t)**sigmapow(r,elyi)
				;

            LOOP((r,powa,pb,elyi) $ mappow(pb,powa) ,
                as(r,powa,elyi,t) $ (xpb_bau(r,pb,elyi,t) and x0(r,powa,elyi,t))
                    = [m_true3bt(x,bau,r,powa,elyi,t) / m_true3bt(xpb,bau,r,pb,elyi,t)]
                    * [  m_true3b(p,bau,r,powa,elyi,t) * lambdapb(r,powa,elyi,t)
                       / m_true3b(ppbndx,bau,r,pb,elyi,t)]**sigmapb(r,pb,elyi)
					;
            ) ;

        ) ;

    ) ;

    IF(ifCal,

* Semi-Exo Bau

        g_xpx(r,fossilea,v,t) $ between2(t,"%YearStart%","%YearEnd%")
            = m_g(TFP_xpx_bau,'r,fossilea,v',t) ;
        g_xs(r,elyi,t) $ between2(t,"%YearStart%","%YearEnd%")
            = m_g(TFP_xs_bau,'r,elyi',t) ;
    ELSE

* Variants

        TFP_xs.fx(r,elyi,t) = TFP_xs_bau(r,elyi,t);
    ) ;

$Endif.ReadNRGBauValue

*------------------------------------------------------------------------------*
*					OECD-ENV: Recalibrate Agriculture                          *
*------------------------------------------------------------------------------*

$IfThen.ReadAGRBauValue %cal_AGR%=="LOAD"

    EXECUTE_LOAD "%AgrBauFile%.gdx",

*   Agriculture TFP

        TFP_xpx_AGR_bau=TFP_xpx.l,

* land efficiency and short-run pland

        lambdat, yexo, gamlb

* To recalibrate Land Supply

        pgdpmp.l, ptland.l, tland.l

        ;

*	Recalibrate Land Supply (after changes in etat(r))

* Curvature parameter in land supply function

	gammatl(r,t) $ (tlandFlag(r) and IfRecal)
		= {0} $ {(%TASS% eq KELAS) OR (%TASS% eq INFTY)}
		+ {	 etat(r) * [m_true1(pgdpmp,r,t) /  m_true1(ptland,r,t)]
		    * [ landmax.l(r,t) / (landmax.l(r,t) - m_true1(tland,r,t)) ]
		  } $ {%TASS% eq LOGIST}
		+ {  etat(r) * m_true1(tland,r,t)
			/ [landmax.l(r,t) - m_true1(tland,r,t)]
		  } $ {%TASS% eq HYPERB}
		;

* Shift parameter in land supply function

    chiLand.fx(r,t) $ (tlandFlag(r) and IfRecal)
        = [	{   m_true1(tland,r,t)
              * [m_true1(pgdpmp,r,t) / m_true1(ptland,r,t)]**etat(r)
            } $ {%TASS% eq KELAS}
		  + {   exp( gammatl(r,t) * m_true1(ptland,r,t) / m_true1(pgdpmp,r,t) )
			  * [landmax.l(r,t) - m_true1(tland,r,t)] / m_true1(tland,r,t)
		    } $ (%TASS% eq LOGIST)
		  ] / chiLand0(r) ;

$Endif.ReadAGRBauValue

$OffDotL
