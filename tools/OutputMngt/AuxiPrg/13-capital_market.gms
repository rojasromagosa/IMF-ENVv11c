$OnText
--------------------------------------------------------------------------------
   OECD ENV-Linkages project Version 4
   Name of the File: "modules\auxilliary_variables\13-capital_market.gms"
   purpose: Fill Capital Market variables
           out_Capital(typevar,CapitalList,units,ra,agents,t)
   created date: 2020-03-11
   created by: Jean Chateau
   called by: \modules\auxilliary_variables.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/AuxiPrg/13-capital_market.gms $
   last changed revision: $Rev: 306 $
   last changed date    : $Date:: 2023-04-27 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
 m_true(tkaps(r,t))
    = chiKaps0(r) * m_true(kstock(r,t)) / scale_tkaps(r,t);
    = sum((a,v), m_true(kv(r,a,v,t))) ;
$OffText

* Sectoral capital

s_capital("real",r,a,t)
    = sum((v,t0), m_true3v(pk,r,a,v,t0) * m_true3vt(kv,r,a,v,t)) ;
s_capital("nominal",r,a,t)
    = sum(v, m_true3v(pk,r,a,v,t)  * m_true3vt(kv,r,a,v,t)) ;

*   Adjustment Energy

*execute_unload "s_capital_ante.gdx", rworkT, s_capital ;

LOOP(units,

    rworkT(r,t) = sum(a, s_capital(units,r,a,t)) ;

    s_capital(units,r,NRGa,t) = 1.5 * s_capital(units,r,NRGa,t) ;

    rworkT(r,t) $ (rworkT(r,t) and sum(nnrga, s_capital(units,r,nNRGa,t)))
        = [rworkT(r,t) - sum(NRGa, s_capital(units,r,nrga,t))]
        / sum(nnrga, s_capital(units,r,nnrga,t)) ;

    s_capital(units,r,nNRGa,t) = s_capital(units,r,nNRGa,t) * rworkT(r,t) ;
) ;

*execute_unload "s_capital_post.gdx", rworkT, s_capital ;

out_Capital(abstype,"Capital stock","real",ra,aga,t)
    $ out_GDP(abstype,"Market Prices","real",ra,t)
    = sum((r,a) $ (mapr(ra,r) and mapaga(aga,a) and xpFlag(r,a)),
        [To%YearBaseMER%MER(r) / chiKaps0(r)] * s_capital("real",r,a,t));

out_Capital(abstype,"Capital stock","nominal",ra,aga,t)
    $ out_GDP(abstype,"Market Prices","nominal",ra,t)
    = sum((r,a) $ (mapr(ra,r) and mapaga(aga,a) and xpFlag(r,a)),
        [To%YearBaseMER%MER(r) / chiKaps0(r)] * s_capital("nominal",r,a,t));

out_Capital(abstype,"Efficient Capital","real",ra,aga,t)
    $ out_Capital(abstype,"Capital stock","real",ra,aga,t)
    = sum((r,a,v)$(mapr(ra,r) and mapaga(aga,a) and xpFlag(r,a)),
        To%YearBaseMER%MER(r) *  m_lambdak(r,a,v,t) * m_true3vt(kv,r,a,v,t) ) ; !! * pkp0(r,a)
* m_lambdak ou lambdak ?

$IfThenI.lab %aux_Labour_Output%=="ON"

    out_Capital(abstype,"Capital to labour","real",ra,aga,t)
        $ sum(l,out_Labour(abstype,"Employment","volume",ra,l,aga,t))
        = out_Capital(abstype,"Capital stock","real",ra,aga,t)
        / sum(l,out_Labour(abstype,"Employment","volume",ra,l,aga,t));

    out_Capital(abstype,"Capital to Efficient labour","real",ra,aga,t)
        $ sum(l,out_Labour(abstype,"Efficient Labor","real",ra,l,aga,t))
        = out_Capital(abstype,"Efficient Capital","real",ra,aga,t)
        / sum(l,out_Labour(abstype,"Efficient Labor","real",ra,l,aga,t)) ; !! = kaplab ?

$ENDIF.lab

out_Capital(abstype,"Capital to output","real",ra,aga,t)
    $ out_Gross_output(abstype,"real",ra,aga,t)
    = out_Capital(abstype,"Capital stock","real",ra,aga,t)
    / out_Gross_output(abstype,"real",ra,aga,t);

out_Capital(abstype,"Capital to output","nominal",ra,aga,t)
    $ out_Gross_output(abstype,"nominal",ra,aga,t)
    = out_Capital(abstype,"Capital stock","nominal",ra,aga,t)
    / out_Gross_output(abstype,"nominal",ra,aga,t);

out_Capital(abstype,"Capital to value added","real",ra,aga,t)
    $ out_Value_Added(abstype,"Basic Prices","real",ra,aga,t)
    = out_Capital(abstype,"Capital stock","real",ra,aga,t)
    / out_Value_Added(abstype,"Basic Prices","real",ra,aga,t);

out_Capital(abstype,"Capital to value added","nominal",ra,aga,t)
    $ out_Value_Added(abstype,"Basic Prices","nominal",ra,aga,t)
    = out_Capital(abstype,"Capital stock","nominal",ra,aga,t)
    / out_Value_Added(abstype,"Basic Prices","nominal",ra,aga,t);

* [TBC] Investissement nominal
*           = pk * k - pk(-1) * k(-1)
*        ou = pk * (k - k(-1))

out_Capital(abstype,"Net Investment",units,ra,aga,t)
    $ out_Capital(abstype,"Capital stock",units,ra,aga,t-1)
    = sum((r,a) $ (mapr(ra,r) and mapaga(aga,a) and not tota(a)),
      [To%YearBaseMER%MER(r) / chiKaps0(r)]
    * [s_capital(units,r,a,t) - s_capital(units,r,a,t-1)] )  ;

out_Capital(abstype,"Gross Investment",units,ra,aga,t)
    $ out_Capital(abstype,"Capital stock",units,ra,aga,t-1)
    = sum((r,a) $ (mapr(ra,r) and mapaga(aga,a) and not tota(a)),
      [To%YearBaseMER%MER(r) / chiKaps0(r)]
    * [s_capital(units,r,a,t) - s_capital(units,r,a,t-1) * (1 - depr(r,t))] ) ;

$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Capital" "CapitalList,units,ra,aga"

* Sectoral composition of Capital (pct): Nominal

IF(%aux_outType% ne AbsValueOnly,
    out_Capital("pct","Capital stock","nominal",ra,aga,t)
        $ (out_Capital("abs","Capital stock","nominal",ra,"ttot-a",t) and ReportYr(t))
        =  out_Capital("abs","Capital stock","nominal",ra,aga,t)
        /  out_Capital("abs","Capital stock","nominal",ra,"ttot-a",t);
);


