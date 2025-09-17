$OnText
--------------------------------------------------------------------------------
            [OECD-ENV] Model version 1.0 - Aggregation procedure
    GAMS file: "%DebugDir%\Delete_TinyFlows.gms"
    purpose: Delete small flows - In aggre
        --> NEED TO ADD TOLERANCE CODE TO GET RID OF SMALL FLOWS
    called by: "%folder_aggregation%\agg.gms"
--------------------------------------------------------------------------------
$OffText

scalar tol / 0.1 /;
Scalar work / 0 / ;
display mapxa, mapxh, mapxm;

* For procedure in AggGtap.gms %1=1

$SetLocal prefixfilt "%1"

* Clean tiny Trade flows (lt tol) : useless during filtering procedure

$IfTheni.AggGTAP %prefixfilt%=="1"
    vxwd%1(i,r,rp) $ (abs(vxwd%1(i,r,rp)) lt tol) = 0;
    vxmd%1(i,r,rp) $ (NOT vxwd%1(i,r,rp)) = 0;
    viws%1(i,r,rp) $ (NOT vxwd%1(i,r,rp)) = 0;
    vims%1(i,r,rp) $ (NOT vxwd%1(i,r,rp)) = 0;
$EndIf.AggGTAP

file xwcsv / xw.csv /;
IF(%ifCSV%,
    put xwcsv;
    put "Var,Commodity,Exporter,Importer,Share" /;
    xwcsv.pc=5;
    xwcsv.nd=9;
    loop((r,i),
        work = sum(rp, vxwd%1(i,r,rp));
        loop(rp,
            put "Exp",    i.tl, r.tl, rp.tl, (vxwd%1(i,r,rp)) /;
            put "ExpShr", i.tl, r.tl, rp.tl, (vxwd%1(i,r,rp)/work) /;
        );
    );

    loop((r,i),
        work = sum(rp, vxwd%1(i,rp,r));
        loop(rp,
            put "Imp",    i.tl, rp.tl, r.tl, (vxwd%1(i,rp,r)) /;
            put "ImpShr", i.tl, rp.tl, r.tl, (vxwd%1(i,rp,r)/work) /;
        );
    );
    abort$(1) "Temp";
) ;

*   Delete output for the following sectors: mapxa(r,a) defined in map.gms

evfa%1(fp,a,r)$ mapxa(r,a) = 0;
vfm%1(fp,a,r) $ mapxa(r,a) = 0;
$IFi %prefixfilt%=="1" FBEP%1(fp,a,r) $ mapxa(r,a) = 0;
$IFi %prefixfilt%=="1" FTRV%1(fp,a,r) $ mapxa(r,a) = 0;
vdfa%1(i,a,r) $ mapxa(r,a) = 0;
vdfm%1(i,a,r) $ mapxa(r,a) = 0;
vifa%1(i,a,r) $ mapxa(r,a) = 0;
vifm%1(i,a,r) $ mapxa(r,a) = 0;
$IFi %prefixfilt%=="1" vom%1(a,r) $ mapxa(r,a) = 0;
edf%1(i,a,r)  $ mapxa(r,a) = 0;
eif%1(i,a,r)  $ mapxa(r,a) = 0;

*tmat%1(a,i,r) $ mapxa(r,a) = 0;
*empl%1(l,a,r) $ mapxa(r,a) = 0;

*   Delete domestic demands related to sector cleaned

*PARAMETER xm%1(i,r) "imported demand";
*xm%1(i,r) = sum(a, vifm%1(i,a,r)) + vipm%1(i,r) + vigm%1(i,r);

vdpm%1(i,r)   $ mapxh(r,i)   = 0 ;
vdpa%1(i,r)   $ mapxh(r,i)   = 0 ;
vdpm%1(i,r)   $ mapxa(r,i)   = 0 ;
vdpa%1(i,r)   $ mapxa(r,i)   = 0 ;
vdgm%1(i,r)   $ mapxa(r,i)   = 0 ;
vdga%1(i,r)   $ mapxa(r,i)   = 0 ;
vst%1(img,r)  $ mapxa(r,img) = 0 ;

vxwd%1(i,r,rp) $ mapxa(r,i) = 0;
vxmd%1(i,r,rp) $ mapxa(r,i) = 0;
viws%1(i,r,rp) $ mapxa(r,i) = 0;
vims%1(i,r,rp) $ mapxa(r,i) = 0;

edf%1(i,a,r)  $ mapxa(r,i) = 0;
edp%1(i,r)    $ mapxh(r,i) = 0;
edp%1(i,r)    $ mapxa(r,i) = 0;
edg%1(i,r)    $ mapxa(r,i) = 0;

vifa%1(i,a,r) $ mapxm(r,i) = 0;
vifm%1(i,a,r) $ mapxm(r,i) = 0;
vipa%1(i,r)   $ (mapxm(r,i) or mapxh(r,i)) = 0;
vipm%1(i,r)   $ (mapxm(r,i) or mapxh(r,i)) = 0;
viga%1(i,r)   $ mapxm(r,i) = 0;
vigm%1(i,r)   $ mapxm(r,i) = 0;

vims%1(i,rp,r)$ mapxm(r,i) = 0;
viws%1(i,rp,r)$ mapxm(r,i) = 0;
vxmd%1(i,rp,r)$ mapxm(r,i) = 0;
vxwd%1(i,rp,r)$ mapxm(r,i) = 0;

eif%1(i,a,r)  $ mapxm(r,i) = 0;
eip%1(i,r)    $ (mapxm(r,i) or mapxh(r,i)) = 0;
eig%1(i,r)    $ mapxm(r,i) = 0;

* [EditJean]: peut etre fait plus proprement dans agg.gms

*---    Re-Create the consumer transition matrix
*alias(k,kp);
*cmat%1(i,k,r) = 0;
*loop((i,k) $ mapk(i,k),
*    cmat%1(i,k,r) = vdpa%1(i,r) + vipa%1(i,r);
*);
*

**---    Re-Calculate the income elasticities
*y(r)   = sum(i, vdpa%1(i,r) + vipa%1(i,r));
*s(k,r) = sum(i, cmat%1(i,k,r))/y(r);
*incElasG(k,r)
*    = (eh(k,r)*bh(k,r) - sum(kp, s(kp,r)*eh(kp,r)*bh(kp,r)))
*    / sum(kp, s(kp,r)*eh(kp,r))
*    - (bh(k,r)-1)
*    + sum(kp, bh(kp,r)*s(kp,r));

$DropLocal prefixfilt