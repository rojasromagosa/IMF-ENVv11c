*------------------------------------------------------------------------------*
*                                                                              *
*               Normalize variables                                            *
*                                                                              *
*------------------------------------------------------------------------------*

$OnDotL
resNegative1(xdt,  i)
resNegative1(u,  h)

resNegative1(xs,   i)
resNegative1(xet,  i)
resNegative1(xtt,  i)
resNegative1(pdt,  i)
resNegative1(ps,   i)
resNegative1(pet,  i)
resNegative2(xw,   i, rp)
resNegative2(pe,   i, rp)
resNegative2(pwe,  i, rp)
resNegative2(pwm,  i, rp)
resNegative2(pdm,  i, rp)
resNegative2(xwmg, i, rp)
resNegative2(pwmg, i, rp)
resNegative1(xmt,  i)
resNegative1(pmt,  i)
resNegative1t(xat, i)
resNegative1(pat,  i)
resNegative2t(xa,  i, aa)
resNegative2( xd,  i, aa)
resNegative2( xm,  i, aa)
resNegative1t(nd1, a)
resNegative1t(nd2, a)
resNegative1(pnd1, a)
resNegative1(pnd2, a)

resNegative1(px, a)
resNegative1(pp, a)
resNegative2(p, a, i)

* Dynamic scaling

resNegative1t(xp, a)
resNegative2t(x, a, i)
*resNegative1vt(xpv, a)

*resNegative1vp(kxRat, a)
resNegative1vp(pxv, a)
resNegative1vp(uc, a)
*resNegative1vt(xpx, a)
resNegative1vp(pxp, a)
*resNegative1vt(va, a)
resNegative1vp(pva, a)
*resNegative1vt(va1, a)
*resNegative1vp(pva1, a)
*resNegative1vt(va2, a)
resNegative1vp(pva2, a)
*resNegative1vt(kef, a)
resNegative1vp(pkef, a)
*resNegative1vt(kf, a)
resNegative1vp(pkf, a)
*resNegative1vt(ksw, a)
resNegative1vp(pksw, a)
*resNegative1vt(ks, a)
resNegative1vp(pks, a)

*resNegative1vt(kv, a)
resNegative1vp(pk, a)
resNegative1vp(pkp, a)
*resNegative1vt(xnrg, a)
resNegative1vp(pnrg, a)
*resNegative1vt(xnely, a)
resNegative1vp(pnely, a)
*resNegative1vt(xolg, a)
resNegative1vp(polg, a)
resNegative2vt(xaNRG, a, NRG)
resNegative2vp(paNRG, a, NRG)

resNegative1t(lab1, a)

resNegative1(lab2, a)
resNegative1(plab1, a)
resNegative1(plab2, a)
resNegative1t(land, a)
resNegative1(pland, a)
resNegative1(plandp, a)
resNegative1(xnrf, a)
resNegative1(pnrf, a)
resNegative1(pnrfp, a)
resNegative1(xwat, a)
resNegative1(pwat, a)
resNegative1(h2o, a)
resNegative1(ph2o, a)
resNegative1(ph2op, a)
resNegative2(pa, i, aa)
resNegative2(pd, i, aa)
resNegative2(pm, i, aa)

resNegative2t(ld, l, a)
resNegative2(wagep, l, a)
resNegative1t(xpow, elyi)
resNegative1(ppow, elyi)
resNegative1(ppowndx, elyi)
resNegative2t(xpb, pb, elyi)
resNegative2(ppb, pb, elyi)
resNegative2(ppbndx, pb, elyi)
resNegative1(xfd, fd)
resNegative1(yfd, fd)
resNegative1(pfd, fd)
resNegative0(kstock)
resNegative0(deprY)
resNegative0(yqtf)
resNegative0(yqht)
*resNegativeg0(trustY)
resNegative2(remit, l, rp)
resNegative0(yh)
resNegative0(yd)
resNegative1(ygov, gy)
resNegative2(xc, k, h)
resNegative2(pc, k, h)
resNegative2(xcnnrg, k, h)
resNegative2(pcnnrg, k, h)
resNegative2(xcnrg, k, h)
resNegative2(pcnrg, k, h)
resNegative2(xcnely, k, h)
resNegative2(pcnely, k, h)
resNegative2(xcolg, k, h)
resNegative2(pcolg, k, h)
resNegative3(xacNRG, k, h, NRG)
resNegative3(pacNRG, k, h, NRG)
resNegative1(u, h)
resNegative1(savh, h)
resNegative1(supy, h)
resNegative1(aps, h)
*resNegativeg1(xtmg, img)
*resNegativeg1(ptmg, img)
resNegativeg4(xmgm, img, r, i, rp)
resNegative2(reswage, l, z)
resNegative2(ewagez, l, z)
resNegative2(lsz, l, z)
resNegative2(ldz, l, z)
resNegative2(awagez, l, z)
resNegative2(wage, l, a)
resNegative1(twage, l)
resNegative1(ls, l)
resNegative1(migr, l)
resNegative1(urbprem, l)
resNegative0(tls)
resNegative0(tkaps)
resNegative0(trent)
resNegative1t(k0, a)
resNegative0(tland)
resNegative0(ptland)
resNegative0(pgdpmp)
resNegative1(xlb, lb)
resNegative1(plb, lb)
resNegative1(plbndx, lb)
resNegative0(ptlandndx)
resNegative0(xnlb)
resNegative0(pnlb)
resNegative0(pnlbndx)
resNegative0(th2o)
resNegative0(th2om)
resNegative0(pth2o)
resNegative0(pth2ondx)
resNegative1(h2obnd, wbnd)
resNegative1(ph2obnd, wbnd)
resNegative1(ph2obndndx, wbnd)
resNegative0(gdpmp)
resNegative0(rgdpmp)
resNegative0(rgdppc)

resNegative0(chiLand)

resNegative2(emia,a,AllEmissions)
resNegative1(emiTot, em)
resNegativeg1(emiGbl, em)

resNegative1v(xoap,a)
resNegative1vp(pxoap,a)
resNegative1v(xghg,a)

* [OECD-ENV]: scale for pxghg is time-dependent

LOOP(vOld,
    pxghg0(r,a,t) $ (pxghg0(r,a,t)<0) = pxghg.l(r,a,vOld,t-1)*0.5 ;
) ;

*   Utility

resNegative0(ror)
resNegative0(rorc)
resNegative0(rore)
*resNegativeg0(rorg)

* [OECD-ENV]: normalization new variables (after dynamic calibration changes)

*  !!!!! Exceptional

kstocke.l(r,t)$(kstocke.l(r,t)<0) = kstocke.l(r,t-1)*0.5;
;

*   2023-10-12: Move here bound from 27-model.gms to take into account Flags

pmt.lo(r,i,t) $ xmtFlag(r,i) = LowerBound ;

pland.lo(r,a,t)  $ (not tota(a) and landFlag(r,a)) = LowerBound ;
plandp.lo(r,a,t) $ (not tota(a) and landFlag(r,a)) = LowerBound ;


