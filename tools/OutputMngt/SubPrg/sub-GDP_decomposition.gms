* Sub program called by %ToolsDir%\OutputMngt\GDP_decomposition.gms

$Setargs simName simFile

Execute_loaddc "%simFile%.gdx",
    xfd=xfd.l,  pfd=pfd.l,  pwe=pwe.l,  pwm=pwm.l,  xw=xw.l,  pdt=pdt.l,
	xtt=xtt.l, lambdaw, xfd0, pfd0, pwe0, pwm0, xw0, pdt0, xtt0,
    yd=yd.l, yd0,
    supy=supy.l, muc=muc.l, mus=mus.l, theta=theta.l, xc=xc.l, pc=pc.l,
    pop=pop.l, savh=savh.l,
    supy0, muc0, theta0, xc0, pc0, pop0, savh0,
    xa=xa.l, xa0, pa=pa.l, pa0
;

xa(r,i,aa,t) = xa(r,i,aa,t) * xa0(r,i,aa,t) ;

*   1.) Build GDP_component

xfd(r,fd,t)  = xfd(r,fd,t)  * xfd0(r,fd)  ;
xw(rp,i,r,t) = xw(rp,i,r,t) * xw0(rp,i,r) ;
xtt(r,i,t)   = xtt(r,i,t)   * xtt0(r,i)   ;

GDP_component("%SIMName%","C","real",r,t) = xfd(r,"hhd",t) * pfd0(r,"hhd") ;
GDP_component("%SIMName%","C","nominal",r,t)
    = GDP_component("%SIMName%","C","real",r,t) * pfd(r,"hhd",t) ;

GDP_component("%SIMName%","G","real",r,t) = xfd(r,"gov",t) * pfd0(r,"gov") ;
GDP_component("%SIMName%","G","nominal",r,t)
    = GDP_component("%SIMName%","G","real",r,t) * pfd(r,"gov",t) ;

GDP_component("%SIMName%","I","real",r,t) = xfd(r,"inv",t) * pfd0(r,"inv") ;
GDP_component("%SIMName%","I","nominal",r,t)
    = GDP_component("%SIMName%","I","real",r,t) * pfd(r,"inv",t) ;

GDP_component("%SIMName%","IM","nominal",r,t)
    = sum((i,rp) $ xw0(rp,i,r),
           xw(rp,i,r,t) * pwm(rp,i,r,t) * pwm0(rp,i,r) * lambdaw(rp,i,r,t) );
GDP_component("%SIMName%","IM","real",r,t)
    = sum((i,rp) $ xw0(rp,i,r),
            xw(rp,i,r,t) * pwm0(rp,i,r)
          * lambdaw(rp,i,r,t) / lambdaw(rp,i,r,"2014") ) ;

GDP_component("%SIMName%","EX","nominal",r,t)
    = sum((i,rp) $ xw0(r,i,rp),
        xw(r,i,rp,t) * pwe(r,i,rp,t) * pwe0(r,i,rp) )
    + sum(i $ xtt0(r,i), pdt(r,i,t) * pdt0(r,i) * xtt(r,i,t)) ;
GDP_component("%SIMName%","EX","real",r,t)
    = sum((i,rp) $ xw0(r,i,rp), xw(r,i,rp,t) * pwe0(r,i,rp) )
    + sum(i $ xtt0(r,i), pdt0(r,i) * xtt(r,i,t)) ;

GDP_component("%SIMName%","GDP",unit,r,t)
    = GDP_component("%SIMName%","C",unit,r,t)
    + GDP_component("%SIMName%","I",unit,r,t)
    + GDP_component("%SIMName%","G",unit,r,t)
    + GDP_component("%SIMName%","EX",unit,r,t)
    - GDP_component("%SIMName%","IM",unit,r,t)
    ;

*   2.) Build Welfare component

pop(r,t)       = [pop(r,t) * pop0(r)]             ;
theta(r,k,h,t) = [theta(r,k,h,t) *  theta0(r,k,h)];
xc(r,k,h,t)    = [xc(r,k,h,t) * xc0(r,k,h)]       ;
muc(r,k,h,t)   = [muc(r,k,h,t) * muc0(r,k,h)]     ;
savh(r,h,t)    = [savh(r,h,t) * savh0(r,h)] ;

Welf_component("%SIMName%", "Household consumption (per capita)","real",r,t)
    = (outscale * popScale) * GDP_component("%SIMName%","C","real",r,t)
    / pop(r,t) ;
Welf_component("%SIMName%", "Household consumption (per capita)","nominal",r,t)
    = (outscale * popScale) * GDP_component("%SIMName%","C","nominal",r,t)
    / pop(r,t) ;

LOOP(h,

    Welf_component("%SIMName%","direct utility (per capita)","real",r,t)
        $ pop(r,t)
        =  prod(k $ xc(r,k,h,t),
             {  [xc(r,k,h,t) - theta(r,k,h,t) * pop(r,t) ]**muc(r,k,h,t) } $ { (xc(r,k,h,t) gt theta(r,k,h,t) * pop(r,t)) and (muc(r,k,h,t) gt 0)}
              + 1  $ { (xc(r,k,h,t) le theta(r,k,h,t) * pop(r,t)) or (muc(r,k,h,t) le 0)}
             )
        * [  { [savh(r,h,t) / [pfd(r,h,t) * pfd0(r,h)] ]**mus(r,h,t)
             } $ {(mus(r,h,t) gt 0) and (savh(r,h,t) gt 0)}
            + 1 $ {(mus(r,h,t) le 0) or (savh(r,h,t) le 0)}
        ] * (outscale * popScale) / pop(r,t) ;

    Welf_component("%SIMName%","subsistence bundle (per capita)","nominal",r,t)
        $ pop(r,t)
        = outscale * popScale * sum(k, pc(r,k,h,t)*pc0(r,k,h)*theta(r,k,h,t)) ;

    Welf_component("%SIMName%","utility price index","nominal",r,t) $ pop(r,t)
        = prod(k $ xc(r,k,h,t),
             {[ pc(r,k,h,t) * pc0(r,k,h) / muc(r,k,h,t)]**muc(r,k,h,t)
             } $ {muc(r,k,h,t) gt 0}
            + 1 $ {muc(r,k,h,t) le 0}
            )
        * [  { [ pfd(r,h,t) * pfd0(r,h) / mus(r,h,t) ]**mus(r,h,t)
             } $ {mus(r,h,t) gt 0}
            + 1 $ {mus(r,h,t) le 0}
        ] ;

    Welf_component("%SIMName%","Household savings (per capita)","real",r,t)
        $ pop(r,t)
        = outscale * popScale * savh(r,h,t) / [pfd(r,h,t) * pfd0(r,h)]
        / pop(r,t);
    Welf_component("%SIMName%","Household savings (per capita)","nominal",r,t)
        = outscale * popScale * savh(r,h,t) / pop(r,t) ;


) ;

* Disposable income = Expenditure function

*Welf_component("%SIMName%","Disposable income (per capita)","nominal",r,t) $ pop(r,t)
*    = (outscale * popScale) * yd(r,t) * yd0(r) / pop(r,t) ;

Welf_component("%SIMName%","Expenditure Function (per capita)","nominal",r,t)
    = Welf_component("%SIMName%","subsistence bundle (per capita)","nominal",r,t)
    + Welf_component("%SIMName%","direct utility (per capita)","real",r,t)
    * Welf_component("%SIMName%","utility price index","nominal",r,t)    ;

*   3.) Household demand

Demand_component("%SIMName%","Household demand",i,"nominal",r,t) $ pop(r,t)
    = xa(r,i,"hhd",t) * pa0(r,i,"hhd") * pa(r,i,"hhd",t) ;
Demand_component("%SIMName%","Household demand",i,"real",r,t) $ pop(r,t)
    = xa(r,i,"hhd",t) * pa0(r,i,"hhd") ;

*   4.) Calculate deviation from baseline for policy runs

$IfThen.NotBau NOT %simName%=="%BauName%"

* Decomposition GDP growth --> pct

    GDP_component(pct,var,unit,r,t)
        $ GDP_component("%BauName%",var,unit,r,t)
        = GDP_component("%SIMName%",var,unit,r,t)
        / GDP_component("%BauName%",var,unit,r,t) - 1 ;

    GDP_component(pct,FinDem,unit,r,t)
        $ (GDP_component("%BauName%","GDP",unit,r,t) and GDP_component(pct,FinDem,unit,r,t))
        = (   GDP_component("%BauName%",FinDem,unit,r,t)
            / GDP_component("%BauName%","GDP",unit,r,t) )
        * GDP_component(pct,FinDem,unit,r,t) ;

* Import contribution is negative

    GDP_component(pct,"IM",unit,r,t) = - GDP_component(pct,"IM",unit,r,t) ;

    GDP_component(pct,var,unit,r,t) = 100 * GDP_component(pct,var,unit,r,t) ;

    GDP_component(pct,"check",unit,r,t)
        = GDP_component(pct,"GDP",unit,r,t)
        - sum(FinDem,GDP_component(pct,FinDem,unit,r,t)) ;

* E(pbau,u) - E(pbau,ubau)

    Welf_component("%SIMName%","Equivalent variation in income (per capita)","nominal",r,t)
        = Welf_component("%BauName%","subsistence bundle (per capita)","nominal",r,t)
        + Welf_component("%SIMName%","direct utility (per capita)","real",r,t)
        * Welf_component("%BauName%","utility price index","nominal",r,t)
        - Welf_component("%BauName%","Expenditure Function (per capita)","nominal",r,t) ;

    Welf_component(pct,"Equivalent variation in income (per capita)","nominal",r,t)
        $ Welf_component("%BauName%","Expenditure Function (per capita)","nominal",r,t)
        = ( [  Welf_component("%BauName%","subsistence bundle (per capita)","nominal",r,t)
             + Welf_component("%SIMName%","direct utility (per capita)","real",r,t)
             * Welf_component("%BauName%","utility price index","nominal",r,t)
            ] / Welf_component("%BauName%","Expenditure Function (per capita)","nominal",r,t)
        - 1 ) * 100 ;

    Welf_component(pct,"Household consumption (per capita)",unit,r,t)
        $ Welf_component("%BauName%", "Household consumption (per capita)",unit,r,t)
        = (  Welf_component("%SIMName%", "Household consumption (per capita)",unit,r,t)
           / Welf_component("%BauName%", "Household consumption (per capita)",unit,r,t)
           - 1 ) * 100 ;

    Welf_component(pct,"Expenditure Function (per capita)","nominal",r,t)
        $ Welf_component("%BauName%","Expenditure Function (per capita)","nominal",r,t)
        = (  Welf_component("%SIMName%","Expenditure Function (per capita)","nominal",r,t)
           / Welf_component("%BauName%","Expenditure Function (per capita)","nominal",r,t)
           - 1 ) * 100 ;


$Endif.NotBau

