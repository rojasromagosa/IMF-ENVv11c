***HRR: copy-pasted from 3-0-dynamic_calibration_AssignTargets.gms


* sub folder in %CalDir% where are stored sub program (read with $batinclude)
    $$SetGlobal SubPrgCalDir "%CalDir%\SubPrg"


*------------------------------------------------------------------------------*
*                                                                              *
*        III.9.)        Preference Calibration: ELES case                                                          *
*                                                                              *
*------------------------------------------------------------------------------*

$onText
        Replaced theta's solution of the model "ELES_calibration"
        (in "%folder_model%\05-cal.gms) by calculations of theta's
        using a scenario for frisch parameter: frisch_target
        Add adjustment of etah's and muc's to be sure
        that the implicit Frisch is consistent with the frisch_target
$offText


    PARAMETERS
        etah_oecd(k,h,t)  "OECD Average Income Elasticities"
        yd_pop_rel(r,h,t) "Relative disposal household income per capita to OECD average"
        oecd_av(k)
        prefconv(r,t)
        frisch_target(r,h,t)
        Min_ConvSpeed_etah(r)
   ;

* Adjust theta's and etah's to scenarios

    IF(%utility% = ELES,

*               ENVISAGE assumption

        rworkT(r,t) = rgdppcT(r,t) ;

*               OECD-ENV assumption

        rworkT(r,t) = ypc("cst_itl",r,t) ;

        frisch_target(r,h,t)
            = -1 / [1 - 0.770304 * exp{-0.053423 * rworkT(r,t) / 1000} ];
        LOOP(t0,
            $$batinclude "%SubPrgCalDir%\sub_adj_preferences_param.gms" "t0" "1"
        );
    ) ;

* Average etah for OECD:

    $$OnDotl
    etah_oecd(k,h,t0)
        $ sum(OLD_OECD, m_true3(pc,OLD_OECD,k,h,t0) *  m_true3(xc,OLD_OECD,k,h,t0))
        = sum(OLD_OECD, etah.l(OLD_OECD,k,h,t0) * m_true3(pc,OLD_OECD,k,h,t0) * m_true3(xc,OLD_OECD,k,h,t0))
        / sum(OLD_OECD, m_true3(pc,OLD_OECD,k,h,t0) *  m_true3(xc,OLD_OECD,k,h,t0));

* Check that xc - theta > 0

    LOOP(t0,
        riskwork(r,h,k) $ xcFlag(r,k,h)
            = m_true3(xc,r,k,h,t0) - m_true3(theta,r,k,h,t0)
    ) ;
    riskwork(r,h,k) $ (riskwork(r,h,k) gt 0) = 0;
    IF(IfDebug,
        EXECUTE_UNLOAD "%CheckCalFile%_%system.fn%_Preferences.gdx",
            etah, muc, theta, betac, supy, riskwork, yd, pc, xc, mus, savh ;
    ) ;
    $$OffDotl


