$OnText
--------------------------------------------------------------------------------
                    [OECD-ENV] Model V.1. - Debug procedure
   Name of the File : "%DebugDir%\Fill_Verification_files.gms"
   purpose          : Write declining and problematic sectors
                      in the file "%cFile%_declining_sectors.txt"
   created date     : 2021-03-10
   created by       : Jean Chateau
   called by        : "%ModelDir%\9-sam.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/debug/Fill_Verification_files.gms $
   last changed revision: $Rev: 462 $
   last changed date    : $Date:: 2023-10-27 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$OnDotl

work =  outscale * walras.l(tsim) ;
MaxStrLen = smax(r, card(r.tl)) + 1 ;

put declin / / ;

put declin "*------------------------------------------------------------------------------*" /;
$iftheni "%simtype%" == "COMPSTAT"
   put declin "*           Year: ", tsim.tl, " and Global Walras:", work                   /;
$else
   put declin "*           Year: ", tsim.val:<4:0, " and Global Walras:", work                   /;
$endif
put declin "*------------------------------------------------------------------------------*" /;

m_clearWork
work = smin((r,a),rrat.l(r,a,tsim));
IF(work lt 1,
    put declin / ;
    put declin "*               Declining sectors: " /;
    LOOP((r,a) $ (rrat.l(r,a,tsim) lt 0.98 and xpFlag(r,a)),
        riswork(r,a)  = rrat.l(r,a,tsim);
        riswork2(r,a) = xpT(r,a,tsim);
        put declin r.tl:<MaxStrLen, " . ", a.tl:0, ": - Gross Output: ", riswork2(r,a), " - rrat: ", riswork(r,a):4:2 /;
    );
);

m_clearWork
riswork2(r,a) $ (xpT(r,a,tsim) lt 30) = xpT(r,a,tsim);
work = sum((r,a),riswork2(r,a));
IF(work,
    put declin / ;
    put declin "*               Production lower than 30 millions: " /;
    LOOP((r,a) $ (xpT(r,a,tsim) lt 30 and (not tota(a)) and xpFlag(r,a)),
        riswork(r,a)  =  m_true2(px,r,a,tsim) ;
        riswork2(r,a) = xpT(r,a,tsim);
        put declin r.tl:<MaxStrLen, " . ", a.tl:0, ": - Gross Output: ", riswork2(r,a), " Production price: ", riswork(r,a):4:2 /;
    );
);

m_clearWork
work = smax((r,em), emiTax.l(r,em,tsim));
IF(work,
    put declin / ;
    put declin "*               Carbon Tax (emiTax): " /;
    LOOP((r,CO2) $ emiTax.l(r,CO2,tsim),
        rwork(r) = emiTax.l(r,CO2,tsim) / cScale ;
        IF(rwork(r), put declin r.tl:<MaxStrLen, ": - Model emiTax", rwork(r)  /; ) ;
    );
);

m_clearWork
risjswork(r,i,aa) $(xaFlag(r,i,aa) and xapT(r,i,aa,tsim)) =  xapT(r,i,aa,tsim) ;
work = sum((r,i,aa)$(risjswork(r,i,aa) lt 0), risjswork(r,i,aa));
IF(work,
    put declin / ;
    put declin "*               Negative Demand: " /;
    LOOP((r,aa,i) $ (xaFlag(r,i,aa) and risjswork(r,i,aa) lt 0 and not tota(aa)),
        put declin r.tl:<MaxStrLen, " . ", aa.tl:0, ".", i.tl:0, ": - xa: ", risjswork(r,i,aa) / ;
    );
);

m_clearWork
risjswork(r,i,a) $ xaFlag(r,i,a) =  aio(r,i,a,tsim);
work = sum((r,i,a)$(risjswork(r,i,a) lt 0), risjswork(r,i,a));
IF(work,
    put declin / ;
    put declin "*               Negative aio(r,i,a,t): " /;
    LOOP((r,a,i) $ (xaFlag(r,i,a) and risjswork(r,i,a) lt 0 and not tota(a)),
        put declin r.tl:<MaxStrLen, " . ", a.tl:0, " . ", i.tl:0, ": - aio: ", risjswork(r,i,a):4:2 / ;
    );
);

m_clearWork
riskwork(r,h,k) $ xcFlag(r,k,h)
    = m_true3(xc,r,k,h,tsim) - m_true3(theta,r,k,h,tsim) * m_true1(pop,r,tsim) ;
work = sum((r,h,k) $ (riskwork(r,h,k) lt 0), 1) ;
riskwork(r,h,k) = outscale * riskwork(r,h,k);
IF(work,
    put declin / ;
    put declin "*               theta(k) > xc(k): " /;
    LOOP((r,h,k) $ (xcFlag(r,k,h) and riskwork(r,h,k) lt 0),
        put declin r.tl:<MaxStrLen, " . ", h.tl:0, ".", k.tl:0, ": - theta minus xc: ", riskwork(r,h,k):4:2 / ;
    );
);

m_clearWork
riswork(r,a) $ (xpT(r,a,tsim) eq 0 and xpT(r,a,tsim-1)) = xpT(r,a,tsim-1) ;
work = sum((r,a) $ riswork(r,a), 1) ;
IF(work gt 0,
    put declin / ;
    put declin "*!!!!!!!!!!!!!!!!!!!!!!    Erased sectors     !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*" /;
    LOOP((r,a) $ riswork(r,a),
        put declin r.tl:<MaxStrLen, " . ", a.tl:0, " Gross Output phased out in ", tsim.val:<4:0    /;
    );
    put declin "*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*" /;
);

$OffDotl

putclose declin;
