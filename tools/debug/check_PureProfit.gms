* The variable PureProfit(BundleLevel,r,a,t)

$SetLocal PolicyStep "%1"

* INSTRUCTIONS BEFORE THE TIME-LOOP (after 6-LoadBauForVariant.gms)

$IfTheni.StepDecl %PolicyStep%=="StepDeclaration"

SETS
    BundleLevel / ghg, xpv, xpx, coa, oil, gas, tot,
                  profitghg, profitnrg, profittop, walras /
    profitpart(BundleLevel) / profitghg, profitnrg, profittop /
;
PARAMETERS PureProfit(BundleLevel,r,a,t) ;
PureProfit(BundleLevel,r,a,t) = 0;

$Endif.StepDecl

*  INSTRUCTIONS in "8-solve.gms":  Solve again the model

$IfTheni.StepSolve %PolicyStep%=="8-solve"

    IF(year ge %YearPolicyStart%,

    LOOP(r $ CtyCovered(r),
        LOOP(a $ EITEa(a),

            PureProfit("xpv",r,a,tsim)
                = sum(v,  m_true3v(uc,r,a,v,tsim)   * m_true3vt(xpv,r,a,v,tsim)
                        - m_true3v(pxp,r,a,v,tsim)  * m_true3vt(xpx,r,a,v,tsim)
                        - m_true3v(xghg,r,a,v,tsim) * m_true3vt(pxghg,r,a,v,tsim)
                    ) ;
            PureProfit("xpx",r,a,tsim)
                = sum(v,  m_true3v(pxp,r,a,v,tsim) * m_true3vt(xpx,r,a,v,tsim)
                        - m_true3vt(va,r,a,v,tsim)  * m_true3v(pva,r,a,v,tsim) )
                - m_true2t(nd1,r,a,tsim) * m_true2(pnd1,r,a,tsim)
                ;
            PureProfit("ghg",r,a,tsim)
                = sum(v, m_true3v(xghg,r,a,v,tsim) * m_true3vt(pxghg,r,a,v,tsim))
                - sum((em,emiact), m_pemi(r,em,emiact,a,tsim)
                                * m_true4(emi,r,em,emiact,a,tsim) ) ;
            PureProfit("coa",r,a,tsim)
                = sum(v, m_true4vt(xaNRG,r,a,"coa",v,tsim) * paNRG0(r,a,"coa") * paNRG(r,a,"coa",v,tsim) )
                - sum(coai, m_true3t(xa,r,coai,a,tsim) * pa0(r,coai,a) * PA_SUB(r,coai,a,tsim)) ;
            PureProfit("gas",r,a,tsim)
                = sum(v, m_true4vt(xaNRG,r,a,"gas",v,tsim) * paNRG0(r,a,"gas") * paNRG(r,a,"gas",v,tsim) )
                - sum(gasi, m_true3t(xa,r,gasi,a,tsim) * pa0(r,gasi,a) * PA_SUB(r,gasi,a,tsim)) ;
            PureProfit("oil",r,a,tsim)
                = sum(v,m_true4vt(xaNRG,r,a,"oil",v,tsim) * paNRG0(r,a,"oil")* paNRG(r,a,"oil",v,tsim) )
                - sum(oili, m_true3t(xa,r,oili,a,tsim) * pa0(r,oili,a) * PA_SUB(r,oili,a,tsim)) ;

            PureProfit("tot",r,a,tsim)
                = sum(BundleLevel, PureProfit(BundleLevel,r,a,tsim));
            PureProfit("profittop",r,a,tsim)
                = sum(em $ emia_IntTgt(r,a,em,tsim),
                    emiaShadowPrice(r,a,em,tsim) * m_true3(emia,r,a,em,tsim)) ;

            PureProfit("profitnrg",r,a,tsim)
                = sum(i, m_ShadowPermis(r,i,a,tsim) * m_true3t(xa,r,i,a,tsim)) ;

            PureProfit("profitghg",r,a,tsim)
                = sum(em $ emia_IntTgt(r,a,em,tsim),
                    m_true2t(xp,r,a,tsim) * emia_IntTgt(r,a,em,tsim)
                    * emiaShadowPrice(r,a,em,tsim)) ;
        ) ;
    ) ;

    PureProfit("xpv",r,"tot",tsim) = sum(a, PureProfit("xpv",r,a,tsim) );
    PureProfit("tot",r,"tot",tsim) = sum(a, PureProfit("tot",r,a,tsim) );
    PureProfit(profitpart,r,"tot",tsim)
        = sum(a $ (NOT tota(a)), PureProfit(profitpart,r,a,tsim)   );

    PureProfit("walras",r,"tot",tsim) $ PureProfit("tot",r,"tot",tsim)
        = walras.l;

    PureProfit(BundleLevel,r,a,tsim)
        = outscale * PureProfit(BundleLevel,r,a,tsim) ;

    execute_unload "pureprofit.gdx", PureProfit;

    ) ;


$Endif.StepSolve

$DropLocal PolicyStep
