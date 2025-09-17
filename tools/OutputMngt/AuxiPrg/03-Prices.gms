$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
    GAMS file   : "%AuxPrgDir%\03-Prices.gms"
    purpose     : Prices variables output
    created date: 2021-03-18
    created by  : Jean Chateau
    called by   : %RootDir%\OutputMngt\OutAuxi.gms
--------------------------------------------------------------------------------
$OffText

$Ontext
[TBC]: all these are aggregated and should be only in out_macro
    API & CPI,
    PPP (Laspeyres), PPP (Paashe - US weights), PPP (Paashe)

Changer "Consumer" en "Household"

out_Prices(abstype,"Armington (market)",r,i,"Total",t) and out_Prices(abstype,"Supply",ra,ia,"Total",t)
    are very  similar

"Armington (market)" and "Armington (agents)"
    --> No rate
$OffText

*---    Aggregate Price Indexes

IF(%aux_PriceIndex% = Paashe,

    out_Prices(abstype,"CPI",ra,"Total",h,t)
        $ sum((r,i,t0) $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t))
        = sum((r,i)    $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t)  * XAPT(r,i,h,t))
        / sum((r,i,t0) $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t));

    out_Prices(abstype,"API",ra,"Total","Total",t)
        $ sum((r,i,t0) $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pat,r,i,t0) * m_true2t(xat,r,i,t))
        = sum((r,i)    $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pat,r,i,t)  * m_true2t(xat,r,i,t))
        / sum((r,i,t0) $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pat,r,i,t0) * m_true2t(xat,r,i,t));

    out_Prices(abstype,"Producer",ra,"Total",aga,t)
        $ sum((r,a,t0) $(mapr(ra,r) and xpFlag(r,a) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true2(pp,r,a,t0) * XPT(r,a,t))
        = sum((r,a)    $(mapr(ra,r) and xpFlag(r,a) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true2(pp,r,a,t)  * XPT(r,a,t))
        / sum((r,a,t0) $(mapr(ra,r) and xpFlag(r,a) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true2(pp,r,a,t0) * XPT(r,a,t));

    out_Prices(abstype,"Consumer",ra,ia,h,t)
        $ sum((r,i,t0) $(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t))
        = sum((r,i)    $(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t)  * XAPT(r,i,h,t))
        / sum((r,i,t0) $(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t));

    out_Prices(abstype,"Supply",ra,ia,"Total",t)
        $ sum((r,i,t0) $(mapr(ra,r) and xsFlag(r,i) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(ps,r,i,t0) * m_true2(xs,r,i,t))
        = sum((r,i)    $(mapr(ra,r) and xsFlag(r,i) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(ps,r,i,t)  * m_true2(xs,r,i,t))
        / sum((r,i,t0) $(mapr(ra,r) and xsFlag(r,i) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(ps,r,i,t0) * m_true2(xs,r,i,t));

) ;

IF(%aux_PriceIndex% = Laspeyres,
    out_Prices(abstype,"CPI",ra,"Total",h,t)
        $ sum((r,i,t0)$ mapr(ra,r),To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t0))
        = sum((r,i,t0) $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t)  * XAPT(r,i,h,t0))
        / sum((r,i,t0) $ mapr(ra,r), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t0));

    out_Prices(abstype,"API",ra,"Total","Total",t)
        $ sum((r,i,t0)$mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pat,r,i,t0) * m_true2t(xat,r,i,t0))
        = sum((r,i,t0)$mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pat,r,i,t)  * m_true2t(xat,r,i,t0))
        / sum((r,i,t0)$mapr(ra,r), To%YearBaseMER%MER(r) * m_true2(pat,r,i,t0) * m_true2t(xat,r,i,t0));

    out_Prices(abstype,"Producer",ra,"Total",aga,t)
        $ sum((r,a,t0)$(mapr(ra,r) and xpFlag(r,a) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true2(pp,r,a,t0) * XPT(r,a,t0))
        = sum((r,a,t0)$(mapr(ra,r) and xpFlag(r,a) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true2(pp,r,a,t)  * XPT(r,a,t0))
        / sum((r,a,t0)$(mapr(ra,r) and xpFlag(r,a) and mapaga(aga,a)), To%YearBaseMER%MER(r) * m_true2(pp,r,a,t0) * XPT(r,a,t0));

    out_Prices(abstype,"Consumer",ra,ia,h,t)
        $ sum((r,i,t0)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t0))
        = sum((r,i,t0)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t)  * XAPT(r,i,h,t0))
        / sum((r,i,t0)$(mapr(ra,r) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true3(pa,r,i,h,t0) * XAPT(r,i,h,t0));

    out_Prices(abstype,"Supply",ra,ia,"Total",t)
        $(sum((r,i,t0)$(mapr(ra,r) and xsFlag(r,i) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(ps,r,i,t0) * m_true2(xs,r,i,t0)))
        = sum((r,i,t0)$(mapr(ra,r) and xsFlag(r,i) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(ps,r,i,t)  * m_true2(xs,r,i,t0))
        / sum((r,i,t0)$(mapr(ra,r) and xsFlag(r,i) and mapi(ia,i)), To%YearBaseMER%MER(r) * m_true2(ps,r,i,t0) * m_true2(xs,r,i,t0));
);

* [TBU]
out_Prices(abstype,"World (CIF)","World",i,"Total",t) = wldPm.l(i,t);

* "Armington (market) --> not agent specific (ie "Total")

out_Prices(abstype,"Armington (market)",r,i,"Total",t)
    = To%YearBaseMER%MER(r) * m_true2(pat,r,i,t);

out_Prices(abstype,"Armington (agents)",r,i,aa,t)
    = To%YearBaseMER%MER(r) * m_true3(pa,r,i,aa,t);

* [TBU]
$$IfThen.target %cal_NRG%=="ONE"

* Convert IEA USD data to ENV-L

    rwork(r)=0;
    rwork(r) $ [ypc("cur_usd",r,"%weoUSD%") * m_true1(POP,r,"%weoUSD%"))]
             =  ypc("cur_usd",r,"%YearBaseMER%") * m_true1(POP,r,"%YearBaseMER%"))
             / [ypc("cst_usd",r,"%weoUSD%") * m_true1(POP,r,"%weoUSD%"))];

    out_Prices("target","World (CIF)","World",fossilei,"Total",t)
        $ sum((r,rp,t0)$scale_xw(rp,fossilei,r,t0), rwork(r) * agent_Price_WEM_for_EL(r,fossilei,"%ActWeoSc%",t0) * lambdaw(rp,fossilei,r,t0) * m_true3(xw,rp,fossilei,r,t0))
        = sum((r,rp,t0)$scale_xw(rp,fossilei,r,t),  rwork(r) * agent_Price_WEM_for_EL(r,fossilei,"%ActWeoSc%",t)  * lambdaw(rp,fossilei,r,t)  * m_true3(xw,rp,fossilei,r,t0))
        / sum((r,rp,t0)$scale_xw(rp,fossilei,r,t0), rwork(r) * agent_Price_WEM_for_EL(r,fossilei,"%ActWeoSc%",t0) * lambdaw(rp,fossilei,r,t0) * m_true3(xw,rp,fossilei,r,t0));

$$ENDIF.target

* [TBU] aggregate

*---    PPP level in %YearBasePPP%

***HRR: we don't have cst_usd in new SSP files
***$IFi NOT %SimType%=="CompStat" rwork(r) = ypc("cst_itl",r,"%YearBasePPP%") / ypc("cst_usd",r,"%YearBasePPP%");
$IFi NOT %SimType%=="CompStat" rwork(r) = 1 ;
***endHRR
$IFi     %SimType%=="CompStat" rwork(r) = 1 ;

out_Prices(abstype,"PPP (Laspeyres)",r,"Total","Total",t)
    $ sum(h,       rwork(r)    * PI0_xc.l(r,h,t))
    = sum((rres,h),rwork(rres) * PI0_xc.l(rres,h,t))
    / sum(h,       rwork(r)    * PI0_xc.l(r,h,t)); !! Inverse de CPI in PPP relatif

out_Prices(abstype,"PPP (Paashe)",r,"Total","Total",t)
    $ sum((h,i)     $(not tota(i)), rwork(r)    * m_true3(pa,r,i,h,t)    * XAPT(r,i,h,t))
    = sum((rres,i,h)$(not tota(i)), rwork(rres) * m_true3(pa,rres,i,h,t) * XAPT(rres,i,h,t))
    / sum((h,i)     $(not tota(i)), rwork(r)    * m_true3(pa,r,i,h,t)    * XAPT(r,i,h,t));

out_Prices(abstype,"PPP (Paashe - US weights)",r,"Total","Total",t)
    $ sum((rres,i,h)$(not tota(i)), rwork(r)    * m_true3(pa,r,i,h,t)    * XAPT(rres,i,h,t))
    = sum((rres,i,h)$(not tota(i)), rwork(rres) * m_true3(pa,rres,i,h,t) * XAPT(rres,i,h,t))
    / sum((rres,i,h)$(not tota(i)), rwork(r)    * m_true3(pa,r,i,h,t)    * XAPT(rres,i,h,t));

*---    Ratio to %YearRef% and annual growth rate
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Prices" "Pricelist,ra,ia,aga"
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Prices" "Pricelist,ra,ia,aa"
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Prices" "Pricelist,ra,'Total',aga"
$batinclude "%AuxPrgDir%\calc_dev.gms" "out_Prices" "Pricelist,ra,'Total',aa"

out_Prices("ratio_to_%YearRef%","World (CIF)","World",i,"Total",t) = 0; !! useless because same as "abs"


