$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%PolicyPrgDir%\ElectricityMix.gms"
   purpose     :   Change Power Mix
   created date: 2021-12-10
   created by  : Jean Chateau
   called by   : %iFilesDir%\CTax.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/ElectricityMix.gms $
   last changed revision: $Rev: 188 $
   last changed date    : $Date:: 2023-01-16 #$
   last changed by      : $Author: Chateau_J $

--------------------------------------------------------------------------------
    For being used in save and restart Mode and let possibility of being
    overrided the file could not contains Declaration of var, eq. or macro
--------------------------------------------------------------------------------

    This Module should be called in two steps :
        1.) %1="StepDeclaration": declaration after "6-LoadBauForVariant.gms"
        2.) %1="7-iterloop": changes coefficient in time loop
        loaded after or inside "AdjustSimOption.gms"
$OffText

$SetLocal PolicyStep "%1"

$IfTheni.StepDeclaration %PolicyStep%=="StepDeclaration"

*---    1.) Load Targeted (Projected) power mix

    SET ieaScen / STEPS, SDS /
    PARAMETER
        Power_Generation_WEM_for_EL(r,a,ieaScen,tt)
        target_xpb(r,pb,elyi,t)  "Electricity Single bundles shares : targets"
        target_x_ely(r,a,elyi,t) "Electricity power shares : targets" ;

    $$SetGlobal IEAPowerSc "SDS"
    EXECUTE_LOAD "%iDataDir%\WEO2020_Power.gdx", Power_Generation_WEM_for_EL ;

*---    2.) Defining targets (target_xpb & target_x_ely)

*---    Before policy target = Bau

    Loop(t $ (t.val le %YearAntePolicy%),
        target_xpb(r,pb,elyi,t)     = xpb_bau(r,pb,elyi,t) * xpb0(r,pb,elyi);
        target_x_ely(r,powa,elyi,t) = x_bau(r,powa,elyi,t) * x0(r,powa,elyi) ;
    ) ;

    iF(0,

*---    Use true targets

        Loop(t $ (t.val ge %YearPolicyStart%),
            target_xpb(r,pb,elyi,t)
                = sum(mappow(pb,elya),Power_Generation_WEM_for_EL(r,elya,"%IEAPowerSc%",t)) ;
            target_x_ely(r,elya,elyi,t)
                = Power_Generation_WEM_for_EL(r,elya,"%IEAPowerSc%",t) ;
        ) ;

* Convergence to true Targets

        m_InterpLinear(target_xpb,'r,pb,elyi',t,%YearAntePolicy%,%YrPhase1%)
        m_InterpLinear(target_x_ely,'r,powa,elyi',t,%YearAntePolicy%,%YrPhase1%)

    ELSE

*---     Use adjusted (to model baseline) targets

        Loop(t $ (t.val ge %YearPolicyStart%),
            target_xpb(r,pb,elyi,t)
                $ sum(mappow(pb,elya),Power_Generation_WEM_for_EL(r,elya,"%IEAPowerSc%","%YearAntePolicy%"))
                = target_xpb(r,pb,elyi,"%YearAntePolicy%")
                * sum(mappow(pb,elya),Power_Generation_WEM_for_EL(r,elya,"%IEAPowerSc%",t))
                / sum(mappow(pb,elya),Power_Generation_WEM_for_EL(r,elya,"%IEAPowerSc%","%YearAntePolicy%")) ;
            target_x_ely(r,elya,elyi,t)
                $ Power_Generation_WEM_for_EL(r,elya,"%IEAPowerSc%","%YearAntePolicy%")
                = target_x_ely(r,elya,elyi,"%YearAntePolicy%")
                * Power_Generation_WEM_for_EL(r,elya,"%IEAPowerSc%",t)
                / Power_Generation_WEM_for_EL(r,elya,"%IEAPowerSc%","%YearAntePolicy%") ;
        ) ;

    ) ;

*---    3.) Bundle twist parameters: twtpb

* Power bundle twist growth rate (wrt "fosp")

    pb_ratio(r,pb,t) = 0 ;
    LOOP((pb,elyi),
        pb_ratio(r,pb,t) $ sum(pb.local,target_xpb(r,pb,elyi,t))
            = target_xpb(r,pb,elyi,t)
            / sum(pb.local,target_xpb(r,pb,elyi,t));
    );

    LOOP(t $ (t.val ge %YearPolicyStart%),
        LOOP((fospbnd,elyi),

* Twist relative to fosp

            twtpb(r,pb,t)
                $(target_xpb(r,pb,elyi,t-1) and target_xpb(r,fospbnd,elyi,t-1))
                = (pb_ratio(r,pb,t)   / pb_ratio(r,fospbnd,t))
                / (pb_ratio(r,pb,t-1) / pb_ratio(r,fospbnd,t-1))
                - 1 ;
            twtpb(r,pb,t) = twtpb(r,pb,t) * 0;

* If Twist active then no more change in apb

            apb(r,pb,elyi,t) $ twtpb(r,pb,t) = apb(r,pb,elyi,t-1) ;
            apb(r,fospbnd,elyi,t) $ sum(pb $ twtpb(r,pb,t), 1)
                = apb(r,fospbnd,elyi,t-1) ;
        ) ;

    );

*---    3.) Power twist parameters: twtely

*LOOP(t $ (t.val ge %YearPolicyStart%),
*    LOOP((elyi,a) $ mappow("othp",a),
*        twtely(r,a,t)
*            $(target_x_ely(r,a,elyi,t-1) and target_x_ely(r,"sol-a",elyi,t-1))
*            = (target_x_ely(r,a,elyi,t)  / target_x_ely(r,"sol-a",elyi,t))
*            / (target_x_ely(r,a,elyi,t-1)/ target_x_ely(r,"sol-a",elyi,t-1))
*            - 1 ;
*    ) ;
*);

    IF(1, EXECUTE_UNLOAD "Ely_targets.gdx", target_xpb, target_x_ely,twtely, twtpb, apb, as, pb_ratio ; ) ;

$Endif.StepDeclaration

*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*                                                                              *
*    INSTRUCTIONS IN THE TIME-LOOP (Before %ModelDir%\7-iterloop.gms)       *
*                                                                              *
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*

$IfTheni.Iterloop %PolicyStep%=="7-iterloop"

*---    1.) Set targets for power mix ratios

    IF(IfElyCES,

* ratio of relative costs

        pb_ratio(r,pb,tsim-1)
            = [m_true3(xpb,r,pb,elyi,tsim-1) * m_true3(ppb,r,pb,elyi,tsim-1)]
            / [m_true2(xpow,r,elyi,tsim-1)   * m_true2(ppow,r,elyi,tsim-1)] ;
    ELSE

* ratio of volume

        pb_ratio(r,pb,tsim-1) $ m_true2(xpow,r,elyi,tsim-1)
            =  m_true3(xpb,r,pb,elyi,tsim-1) / m_true2(xpow,r,elyi,tsim-1) ;
    ) ;

*---    2.) Compute efficiency of "Fossil power" bundle (i.e. fospbnd)

        LOOP(fospbnd,

* fossil power bundle efficiency factor of growth: rworkT

            rworkT(r,tsim)
                $ (sum(pb $ twtpb(r,pb,tsim), 1) and rwork(r))
                = (1 + work * m_g(apb,"r,fospbnd,elyi",tsim))
                * sum(pb $ apb(r,pb,elyi,tsim),
                    pb_ratio(r,pb,tsim-1) * (1 + twtpb(r,pb,tsim)) ) ;
            rworkT(r,tsim) = rworkT(r,tsim)**(1 / sigmapow(r,elyi)) ;

            lambdapow(r,fospbnd,elyi,tsim)
                $ rworkT(r,tsim)
                = lambdapow(r,fospbnd,elyi,tsim-1) * rworkT(r,tsim) ;
        ) ;

*---    3.) Efficiency of other power bundles

        LOOP(pb $ (NOT fospbnd(pb)),
            IF(IfElyCES,
*                lambdapow(r,pb,elyi,tsim) $ rworkT(r,tsim)
*                    = lambdapow(r,pb,elyi,tsim-1)
*                    * rworkT(r,tsim)
*                    / [(1 + twtpb(r,pb,tsim))]**(1 / sigmapow(r,elyi)) ;
        ELSE
            lambdapow(r,pb,elyi,tsim) $ rworkT(r,tsim)
                = lambdapow(r,pb,elyi,tsim-1)
                * rworkT(r,tsim)
                * [ (1 + work * m_g(apb,"r,pb,elyi",tsim))
                    / [(1 + twtpb(r,pb,tsim)) * (1 + work * m_g(apb,"r,'fosp',elyi",tsim))]
                ]**(1 / sigmapow(r,elyi)) ;

        );
    ) ;

$Endif.IterLoop

$DropLocal PolicyStep










