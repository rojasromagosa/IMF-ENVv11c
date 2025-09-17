
$OnText
--------------------------------------------------------------------------------
    OECD ENV-Linkages project V4
    Name of the File: "modules\auxilliary_variables\09-Growth_Accounting"
    purpose: Growth accounting or Solow GDP decomposition
    created date: 2016-11-17
    created by: Jean Chateau
    called by: \modules\auxilliary_variables.gms
--------------------------------------------------------------------------------
$OffText

* Water ???
* Add kspec.l(r,a,v)


* [TBU]: TFP_xpx
* All shares (below) will be divided by Total Value Added at basic price
* (e.g. remuneration brutes) make more sense since it is equal to total production

out_Solow_decomposition("Factor Shares",ra,fp,aga,t)
    $ out_ValueAdded_structure("abs","real",ra,"Total",aga,t)
    = out_ValueAdded_structure("abs","real",ra,fp,aga,t)
    / out_ValueAdded_structure("abs","real",ra,"Total",aga,t);

* For the attribution we need factor shares as share of economy-wide VA:
tmp_Solow_decomposition("Factor Shares",ra,fp,aga,t)
    $ out_ValueAdded_structure("abs","real",ra,"Total","ttot-a",t)
    = out_ValueAdded_structure("abs","real",ra,fp,aga,t)
    / out_ValueAdded_structure("abs","real",ra,"Total","ttot-a",t);

* Je ne suis pas bien certain que l on puisse additionner si simplement
tmp_Solow_decomposition("Factor Growth",ra,l,aga,t)
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)),m_true(ld(r,l,a,t)));
tmp_Solow_decomposition("Factor Growth",ra,cap,aga,t)
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)),sum(v, m_true(kv(r,a,v,t))));
tmp_Solow_decomposition("Factor Growth",ra,lnd,aga,t)
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)),m_true(land(r,a,t)));
tmp_Solow_decomposition("Factor Growth",ra,nrs,aga,t)
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)),m_true(xnrf(r,a,t)));

* N.B. tfp_fp is already factored into lambda_fp so should not be added here
tmp_Solow_decomposition("Factor Efficiency",ra,l,aga,t)
    $ tmp_Solow_decomposition("Factor Growth",ra,l,aga,t)
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)), lambdal.l(r,l,a,t) * m_true(ld(r,l,a,t)))
    / tmp_Solow_decomposition("Factor Growth",ra,l,aga,t);

tmp_Solow_decomposition("Factor Efficiency",ra,cap,aga,t)
    $ tmp_Solow_decomposition("Factor Growth",ra,cap,aga,t)
    = sum((r,a,v)$(mapr(ra,r) and mapaga(aga,a)), lambdak.l(r,a,v,t) * m_true(kv(r,a,v,t)))
    / tmp_Solow_decomposition("Factor Growth",ra,cap,aga,t);

tmp_Solow_decomposition("Factor Efficiency",ra,lnd,aga,t)
    $ tmp_Solow_decomposition("Factor Growth",ra,lnd,aga,t)
    = sum((r,agr)$(mapr(ra,r) and mapaga(aga,agr)), lambdat.l(r,agr,"old",t)*m_true(land(r,agr,t)))
    / tmp_Solow_decomposition("Factor Growth",ra,lnd,aga,t);

tmp_Solow_decomposition("Factor Efficiency",ra,nrs,aga,t)
    $ tmp_Solow_decomposition("Factor Growth",ra,nrs,aga,t)
    = sum((r,a)$(mapr(ra,r) and mapaga(aga,a)), lambdanrf.l(r,a,"old",t)*m_true(xnrf(r,a,t)))
    / tmp_Solow_decomposition("Factor Growth",ra,nrs,aga,t);

*---    "Total" factor efficiency reflects TFP_xpx.
* In principle, this should NOT be included to decompose the growth in (real) value added
* [TBC] with vintage fo TFP_xpx
tmp_Solow_decomposition("Factor Efficiency",ra,"Total",aga,t)
    $  out_ValueAdded_structure("abs","real",ra,"Total",aga,t)
    = sum((r,a,v)$(mapr(ra,r) and mapaga(aga,a)), TFP_xpx.l(r,a,v,t)*[sum((ra.local,aga.local)$(sameas(r,ra) and sameas(a,aga)), out_ValueAdded_structure("abs","nominal",ra,"Total",aga,t))])
    /  out_ValueAdded_structure("abs","real",ra,"Total",aga,t);

loop((t,t0)$(years(t) gt years(t0)),

*---    Growth rate of total Value Added for each sector
    out_Solow_decomposition("VA Growth nominal",ra,"Total",aga,t)
        $ out_ValueAdded_structure("abs","nominal",ra,"Total",aga,t-1)
        = out_ValueAdded_structure("abs","nominal",ra,"Total",aga,t)
        / out_ValueAdded_structure("abs","nominal",ra,"Total",aga,t-1) -1;
    out_Solow_decomposition("VA Growth real",ra,"Total",aga,t)
        $ out_ValueAdded_structure("abs","real",ra,"Total",aga,t-1)
        = out_ValueAdded_structure("abs","real",ra,"Total",aga,t)
        / out_ValueAdded_structure("abs","real",ra,"Total",aga,t-1) -1;

*---    Aggregate (e.g. "ttot-a")
    tmp_fp(regions,fp) = 0;
    tmp_fp(r,fp)
        $ tmp_Solow_decomposition("Factor Growth",r,fp,"ttot-a",t-1)
        = tmp_Solow_decomposition("Factor Growth",r,fp,"ttot-a",t)
        / tmp_Solow_decomposition("Factor Growth",r,fp,"ttot-a",t-1) -1;
    tmp_fp(ra,fp)
        $ tmp_Solow_decomposition("Factor Growth",ra,fp,"ttot-a",t-1)
        = tmp_Solow_decomposition("Factor Growth",ra,fp,"ttot-a",t)
        / tmp_Solow_decomposition("Factor Growth",ra,fp,"ttot-a",t-1) -1;

    out_Solow_decomposition("Factor Growth",ra,fp,"ttot-a",t) $ tmp_fp(ra,fp)
        = tmp_Solow_decomposition("Factor Shares",ra,fp,"ttot-a",t-1) * tmp_fp(ra,fp);

    out_Solow_decomposition("Factor Reallocation",ra,fp,"ttot-a",t)
        $ tmp_fp(ra,fp)
        = sum(a$(tmp_Solow_decomposition("Factor Growth",ra,fp,a,t-1) and not sameas(a,"ttot-a")),
                 tmp_Solow_decomposition("Factor Shares",ra,fp,a,t-1)
               * {[tmp_Solow_decomposition("Factor Growth",ra,fp,a,t) / tmp_Solow_decomposition("Factor Growth",ra,fp,a,t-1)-1] - tmp_fp(ra,fp)}
             );

    out_Solow_decomposition("Factor Efficiency",ra,fp,"ttot-a",t)
        = sum(a$(tmp_Solow_decomposition("Factor Efficiency",ra,fp,a,t-1) and not sameas(a,"ttot-a")),
                tmp_Solow_decomposition("Factor Shares",ra,fp,a,t-1)
                * [tmp_Solow_decomposition("Factor Efficiency",ra,fp,a,t) / tmp_Solow_decomposition("Factor Efficiency",ra,fp,a,t-1)-1]);

*---    Sectoral
    out_Solow_decomposition("Factor Growth",ra,fp,aga,t)
        $ (tmp_Solow_decomposition("Factor Growth",ra,fp,aga,t-1) and not sameas(aga,"ttot-a"))
        = tmp_Solow_decomposition("Factor Shares",ra,fp,aga,t-1)
        * [tmp_Solow_decomposition("Factor Growth",ra,fp,aga,t)/tmp_Solow_decomposition("Factor Growth",ra,fp,aga,t-1)-1];
    out_Solow_decomposition("Factor Efficiency",ra,fp,aga,t)
        $ (tmp_Solow_decomposition("Factor Efficiency",ra,fp,aga,t-1) and not sameas(aga,"ttot-a"))
        = tmp_Solow_decomposition("Factor Shares",ra,fp,aga,t-1)
        * [tmp_Solow_decomposition("Factor Efficiency",ra,fp,aga,t)/tmp_Solow_decomposition("Factor Efficiency",ra,fp,aga,t-1)-1];
);

option kill=tmp_Solow_decomposition;


