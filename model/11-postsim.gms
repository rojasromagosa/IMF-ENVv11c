$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%ModelDir%\11-postsim.gms"
   purpose     :  postsim calculation
   created date: -
   created by  : Dominique van der Mensbrugghe
   Modified by : Jean Chateau
                add %1 = {t,tsim} and simmplify with macro + MAC curves
   called by   : %ModelDir%\10-PostSimInstructions.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/11-postsim.gms $
   last changed revision: $Rev: 266 $
   last changed date    : $Date:: 2023-03-29#$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

* [EditJean]: pourquoi on relit la sam de nouveau qui est calcule a la fin des boucles
*$batinclude "%ModelDir%\9-sam.gms" "t"

$macro putv0(varName,  suffix, oScale)                   put sim.tl, "&VarName", r.tl, "", "", "", m_PUTYEAR, (oScale*(&varName.l(r,t))*(&varName&suffix(r))) / ;
$macro putv1(varName,  i__1  , suffix, oScale)           put sim.tl, "&VarName", r.tl, i__1.tl, "", "", m_PUTYEAR, (oScale*(&varName.l(r,i__1,t))*(&varName&suffix(r,i__1))) / ;
$macro putv2(varName,  i__1  , i__2  , suffix, oScale)   put sim.tl, "&VarName", r.tl, i__1.tl, i__2.tl, "", m_PUTYEAR, (oScale*(&varName.l(r,i__1,i__2,t))*(&varName&suffix(r,i__1,i__2))) / ;
$macro putv2v(varName, i__1  , i__2  , suffix, oScale)   put sim.tl, "&VarName", r.tl, i__1.tl, i__2.tl, "", m_PUTYEAR, (oScale*(&varName.l(r,i__1,i__2,t))*(&varName&suffix(r,i__1))) / ;
$macro putv3(varName,  i__1  , i__2  , i__3  , suffix, oScale) put sim.tl, "&VarName", r.tl, i__1.tl, i__2.tl, i__3.tl, m_PUTYEAR, (oScale*(&varName.l(r,i__1,i__2,i__3,t))*(&varName&suffix(r,i__1,i__2,i__3))) / ;

* Macro for unscaled variables
$macro putuns0(varName,oScale) put sim.tl, "&VarName", r.tl, "", "", "", m_PUTYEAR, (oScale*(&varName.l(r,t))) / ;

IF(ifSAM,

* Declare Sam Labels

    IF(ifSAMAppend,
        fsam.ap = 1 ;
        put fsam ;
    else
        fsam.ap = 0 ;
        put fsam ;
        put "Sim,Var,Region,rlab,clab,qual,Time,value" / ;
    ) ;
    fsam.pc=5 ;
    fsam.nd=9 ;

* store Sam

    loop((sim,t,r,is,js) $ sam(r,is,js,t),
        put sim.tl,"sam",r.tl,is.tl,js.tl,"",m_PUTYEAR,(outScale*sam(r,is,js,t)) / ;
    ) ;

* store remarkable outputs

    $$Ifi NOT %SimType%=="CompStat" loop((sim,t) $ between3(t,"%YearStart%","%EndTimeLoop%") ,
    $$Ifi     %SimType%=="CompStat" loop((sim,t) ,
        loop((r,a,v),

* mettre a jour avec new scale           putv1(xp,a,0,outScale)
            putv1(px,a,0,1)
            putv1(pp,a,0,1)
        ) ;
        loop((r,a,v),
* mettre a jour avec new scale            putv2v(xpv,a,v,0,outScale)
* mettre a jour avec new scale            putv2v(kv,a,v,0,outScale)
            putv2v(pxv,a,v,0,1)
            putv2v(kxRat,a,v,0,1)
            putv2v(pk,a,v,0,1)
        ) ;
        loop((r,i,aa),
            putv2(pa, i, aa, 0, 1)
* mettre a jour avec new scale                       putv2(xa, i, aa, 0, outscale)
            put sim.tl,"patax",   r.tl,i.tl,aa.tl,"",m_PUTYEAR,(patax.l(r,i,aa,t)) / ;
            put sim.tl,"gammaeda",r.tl,i.tl,aa.tl,"",m_PUTYEAR,(gammaeda(r,i,aa)) / ;
        ) ;
        loop((r,k,h),
            putv2(xc,k,h,0,outScale)
            putv2(pc,k,h,0,1)
            putv2(hshr,k,h,0,100)
            put sim.tl,"etah",r.tl,k.tl,"","",m_PUTYEAR,(etah.l(r,k,h,t)) / ;
            loop(kp, put sim.tl,"epsh",r.tl,k.tl,kp.tl,"",m_PUTYEAR,(epsh.l(r,k,kp,h,t)) / ; ) ;
            IF(%utility% eq ELES,
                put sim.tl,"muc",r.tl,k.tl,"","",m_PUTYEAR,(muc0(r,k,h)*muc.l(r,k,h,t)) / ;
                putv2(theta,k,h,0,outScale)
            ) ;
            IF(%utility% eq CDE,
                put sim.tl,"eh",r.tl,k.tl,"","",m_PUTYEAR,(eh.l(r,k,h,t)) / ;
                put sim.tl,"bh",r.tl,k.tl,"","",m_PUTYEAR,(bh.l(r,k,h,t)) / ;
                putv2(theta,k,h,0,1)
            ) ;
        ) ;
        loop((r,h),
            putv1(u,h,0,1)
            IF(%utility% eq ELES,
                putv1(supy,h,0,outScale)
                put sim.tl,"mus",r.tl,"sav","","",m_PUTYEAR,(mus.l(r,h,t)) / ;
            ) ;
        ) ;

        loop(r,
            putv0(pop,0,(1/popScale))
            putv0(gdpmp,0,outScale)
            putv0(rgdpmp,0,outScale)
            putv0(pgdpmp,0,1)
            putv0(rgdppc,0,(popScale/inScale))
            putv0(trent,0,1)
            putv0(tkaps,0,outScale)
            putv0(kstock,0,outScale)
            putv0(deprY,0,outScale)
            putv0(gdpmp,0,outScale)
            putv0(gdpmp,0,outScale)
* unscaled variables
            putuns0(savg,outScale)
            putuns0(savf,outScale)
            put sim.tl,"kstocke",r.tl,"","","",m_PUTYEAR,(outscale*kstocke.l(r,t)*kstock0(r)) / ;
            putv0(ror,0,1)
            putv0(rorc,0,1)
            putv0(rore,0,1)
            put sim.tl,"devRoR",r.tl,"","","",m_PUTYEAR,(devRoR.l(r,t)) / ;
            put sim.tl,"grK",r.tl,"","","",m_PUTYEAR,(grK.l(r,t)) / ;
            loop(h,
                putv1(savh,h,0,outScale)
                put sim.tl,"aps",r.tl,"","","",m_PUTYEAR,(aps.l(r,h,t)) / ;
            ) ;
            put sim.tl,"gl",r.tl,"","","",m_PUTYEAR,(gl.l(r,t)) / ;
            loop(fd,
                putv1(xfd,fd,0,outScale)
                putv1(yfd,fd,0,outScale)
                putv1(pfd,fd,0,1)
                put sim.tl, "rgdpshr", r.tl, fd.tl, "", "", m_PUTYEAR, (100*xfd.l(r,fd,t)/rgdpmp.l(r,t)) / ;
                put sim.tl, "gdpshr", r.tl, fd.tl,  "", "", m_PUTYEAR, (100*yfd.l(r,fd,t)/gdpmp.l(r,t)) / ;
            ) ;

            IF(1,

                loop((i,rp),
                putv2(pe,i,rp,0,1)
                putv2(pwe,i,rp,0,1)
                putv2(pwm,i,rp,0,1)
                putv2(pwmg,i,rp,0,1)
                putv2(pdm,i,rp,0,1)
                putv2(xw,i,rp,0,outScale)
                put sim.tl, "gammaew", r.tl, i.tl, rp.tl,"", m_PUTYEAR, (gammaew(r,i,rp))   / ;
                put sim.tl, "mtax",    r.tl, i.tl, rp.tl,"", m_PUTYEAR, (mtax.l(r,i,rp,t))  / ;
                put sim.tl, "etax",    r.tl, i.tl, rp.tl,"", m_PUTYEAR, (etax.l(r,i,rp,t))  / ;
                put sim.tl, "tmarg",   r.tl, i.tl, rp.tl,"", m_PUTYEAR, (tmarg.l(r,i,rp,t)) / ;
                put sim.tl, "xwFlag",  r.tl, i.tl, rp.tl,"", m_PUTYEAR, (xwFlag(r,i,rp))    / ;
                ) ;
                loop(i,
                    putv1(pet,i,0,1)
                    putv1(xet,i,0,outScale)
* mettre a jour avec new scale                     putv1(xat,i,0,outScale)
                    putv1(xs,i,0,outScale)
                    putv1(xdt,i,0,outScale)
                    putv1(xmt,i,0,outScale)
                    putv1(pdt,i,0,1)
                    putv1(pat,i,0,1)
                    putv1(ps,i,0,1)
                    putv1(pmt,i,0,1)
                    loop(a,
* mettre a jour avec new scale                        putv2(x,a,i,0,outScale)
                        putv2(p,a,i,0,outScale)
                    ) ;
                ) ;
                loop(e,
                    put sim.tl, "xatNRG",   r.tl, e.tl, "","", m_PUTYEAR, (xatNRG(r,e,t)*outScale) / ;
                    put sim.tl, "gammaesd", r.tl, e.tl, "","", m_PUTYEAR, (gammaesd(r,e)) / ;
                    put sim.tl, "gammaese", r.tl, e.tl, "","", m_PUTYEAR, (gammaese(r,e)) / ;
                ) ;

            ) ;

            $$IfTheni.DynCal %SimType%=="Baseline"
                put sim.tl,"grrgdppc", r.tl, "", "", "", m_PUTYEAR,(grrgdppc.l(r,t)) / ;
                loop(tranche,
                    put sim.tl, "popScen", r.tl, tranche.tl, "" ,"", m_PUTYEAR, (popScen("%POPSCEN%", r, tranche, t)) / ;
                ) ;
                loop(var,
                    put sim.tl, "gdpScen", r.tl, var.tl, "" ,"", m_PUTYEAR, (gdpScen("%SSPMOD%", "%SSPSCEN%", var, r, t)) / ;
                ) ;
            $$EndIf.DynCal

            put sim.tl, "exp",  r.tl, "", "" ,"", m_PUTYEAR, (outscale*sum((i,rp),    pwe0(r,i,rp)*xw0(r,i,rp)*pwe.l(r,i,rp,t)*xw.l(r,i,rp,t))) / ;
            put sim.tl, "rexp", r.tl, "", "" ,"", m_PUTYEAR, (outscale*sum((i,rp,t0), pwe0(r,i,rp)*xw0(r,i,rp)*pwe.l(r,i,rp,t0)*xw.l(r,i,rp,t))) / ;
            put sim.tl, "imp",  r.tl, "", "" ,"", m_PUTYEAR, (outscale*sum((i,rp),    pwm0(rp,i,r)*xw0(rp,i,r)*pwm.l(rp,i,r,t)*lambdaw(rp,i,r,t)*xw.l(rp,i,r,t))) / ;
            put sim.tl, "rimp", r.tl, "", "" ,"", m_PUTYEAR, (outscale*sum((i,rp,t0), pwm0(rp,i,r)*xw0(rp,i,r)*pwm.l(rp,i,r,t0)*lambdaw(rp,i,r,t)*xw.l(rp,i,r,t))) / ;
            put sim.tl, "itt",  r.tl, "", "" ,"", m_PUTYEAR, (outscale*sum((img),     pdt0(r,img)*xtt0(r,img)*pdt.l(r,img,t)*xtt.l(r,img,t))) / ;
            put sim.tl, "ritt", r.tl, "", "" ,"", m_PUTYEAR, (outscale*sum((img,t0),  pdt0(r,img)*xtt0(r,img)*pdt.l(r,img,t0)*xtt.l(r,img,t))) / ;

            putv0(tls,0,(1/lscale))
            putv0(tland,0,outScale)
            put sim.tl,"tnrf",  r.tl,"","","",m_PUTYEAR,(outscale*sum((a,t0), pnrf0(r,a)*xnrf0(r,a)*pnrf.l(r,a,t0)*xnrf.l(r,a,t))) / ;
            loop(l,
                putv1(ls,l,0,(1/lscale))
                putv1(twage,l,0,1)
                putv1(urbprem,l,0,1)
                putv1(migr,l,0,(1/lscale))
                put sim.tl,"skillprem",r.tl,"",l.tl,"",m_PUTYEAR,(skillprem.l(r,l,t)) / ;
                loop(z,
                    putv2(awagez,l,z,0,1)
                    putv2(ewagez,l,z,0,1)
                    putv2(resWage,l,z,0,1)
                    putv2(lsz,l,z,0,(1/lscale))
                    putv2(lsz,l,z,0,(1/lscale))
                    put sim.tl,"uez",     r.tl,"",l.tl,z.tl,m_PUTYEAR,(100*uez.l(r,l,z,t)) / ;
                    put sim.tl,"ueMinz",  r.tl,"",l.tl,z.tl,m_PUTYEAR,(100*ueMinz(r,l,z,t)) / ;
                ) ;
            ) ;

            loop(a,
                loop(l,
                    putv2(wage,l,a,0,1)
* mettre a jour avec new scale                        putv2(ld,l,a,0,1)
                ) ;
                loop(v, putv2v(pk,a,v,0,1) ) ;
                putv1(pland,a,0,1)
                putv1(pnrf,a,0,1)
            ) ;

            loop(a$h2o.l(r,a,t),
                putv1(h2o,a,0,1e6)
                putv1(ph2o,a,0,1)
                putv1(ph2op,a,0,1)
            ) ;

            putv0(th2o,0,1e6)
            putv0(th2om,0,1e6)
            putv0(pth2o,0,1)
            loop(wbnd,
                putv1(h2obnd,wbnd,0,1e6)
                putv1(ph2obnd,wbnd,0,1)
            ) ;
        ) ;

        put sim.tl,"rorg","GBL","","","",m_PUTYEAR,(rorg.l(t)*rorg0) / ;

        loop((r,AllEmissions,EmiSource,aa) $ emir(r,AllEmissions,EmiSource,aa,t),
            putv3(emi, AllEmissions, EmiSource, aa, 0, (1/cscale))
        ) ;

        loop((r,em) $ emiTot0(r,em),
            IF(ifCEQ,
                put sim.tl, "emiTot", r.tl, "CEQ",   "", em.tl, m_PUTYEAR, (emiTot0(r,em)*emiTot.l(r,em,t)/cscale) / ;
                put sim.tl, "emiTot", r.tl, "CO2EQ", "", em.tl, m_PUTYEAR, ((44/12)*emiTot0(r,em)*emiTot.l(r,em,t)/cscale) / ;
                put sim.tl, "emiTot", r.tl, "mt",    "", em.tl, m_PUTYEAR, ((44/12)*emiTot0(r,em)*emiTot.l(r,em,t)/(cscale*gwp(em))) / ;
            else
                put sim.tl, "emiTot", r.tl, "CO2EQ", "", em.tl, m_PUTYEAR, (emiTot0(r,em)*emiTot.l(r,em,t)/cscale) / ;
                put sim.tl, "emiTot", r.tl, "CEQ",   "", em.tl, m_PUTYEAR, ((12/44)*emiTot0(r,em)*emiTot.l(r,em,t)/cscale) / ;
                put sim.tl, "emiTot", r.tl, "mt",    "", em.tl, m_PUTYEAR, (emiTot0(r,em)*emiTot.l(r,em,t)/(cscale*gwp(em))) / ;
            ) ;
            IF(emiQuota.l(r,em,t),
                IF(ifCEQ,
                    put sim.tl, "emiQuota", r.tl, "CEQ",   "", em.tl, m_PUTYEAR, (emiQuota.l(r,em,t)/cscale) / ;
                    put sim.tl, "emiQuota", r.tl, "CO2EQ", "", em.tl, m_PUTYEAR, ((44/12)*emiQuota.l(r,em,t)/cscale) / ;
                    put sim.tl, "emiQuota", r.tl, "mt",    "", em.tl, m_PUTYEAR, ((44/12)*emiQuota.l(r,em,t)/(cscale*gwp(em))) / ;
                else
                    put sim.tl, "emiQuota", r.tl, "CO2EQ", "", em.tl, m_PUTYEAR, (emiQuota.l(r,em,t)/cscale) / ;
                    put sim.tl, "emiQuota", r.tl, "CEQ",   "", em.tl, m_PUTYEAR, ((12/44)*emiQuota.l(r,em,t)/cscale) / ;
                    put sim.tl, "emiQuota", r.tl, "mt",    "", em.tl, m_PUTYEAR, (emiQuota.l(r,em,t)/(cscale*gwp(em))) / ;
                ) ;
            ) ;
            IF(emiTax.l(r,em,t),
                IF(ifCEQ,
                    put sim.tl, "emiTax", r.tl, "USD/tCEQ", "",   em.tl, m_PUTYEAR,   (emitax.l(r,em,t)/escale) / ;
                    put sim.tl, "emiTax", r.tl, "USD/tCO2EQ", "", em.tl, m_PUTYEAR,   ((12/44)*emitax.l(r,em,t)/escale) / ;
                else
                    put sim.tl, "emiTax", r.tl, "USD/tCEQ", "", em.tl, m_PUTYEAR,   ((44/12)*emitax.l(r,em,t)/escale) / ;
                    put sim.tl, "emiTax", r.tl, "USD/tCO2EQ", "", em.tl, m_PUTYEAR, (emitax.l(r,em,t)/escale) / ;
                ) ;
            ) ;
        ) ;
        loop(em $ emiGbl0(em),
            IF(ifCEQ,
                put sim.tl, "emiTot", "GBL", "CEQ",   "", em.tl, m_PUTYEAR, (emiGbl0(em)*emiGbl.l(em,t)/cscale) / ;
                put sim.tl, "emiTot", "GBL", "CO2EQ", "", em.tl, m_PUTYEAR, ((44/12)*emiGbl0(em)*emiGbl.l(em,t)/cscale) / ;
                put sim.tl, "emiTot", "GBL", "mt",    "", em.tl, m_PUTYEAR, ((44/12)*emiGbl0(em)*emiGbl.l(em,t)/(cscale*gwp(em))) / ;
            else
                put sim.tl, "emiTot", "GBL", "CO2EQ", "", em.tl, m_PUTYEAR, (emiGbl0(em)*emiGbl.l(em,t)/cscale) / ;
                put sim.tl, "emiTot", "GBL", "CEQ",   "", em.tl, m_PUTYEAR, ((12/44)*emiGbl0(em)*emiGbl.l(em,t)/cscale) / ;
                put sim.tl, "emiTot", "GBL", "mt",    "", em.tl, m_PUTYEAR, (emiGbl0(em)*emiGbl.l(em,t)/(cscale*gwp(em))) / ;
            ) ;
        ) ;
        loop(img,
            put sim.tl, "ptmg", "GBL", img.tl, "", "", m_PUTYEAR, (ptmg0(img)*ptmg.l(img,t)) / ;
        ) ;

*   Save GTAP initial variables

        IF(1 and ord(t) eq 1,

            loop((r,e),
                put sim.tl, "edp",  r.tl, e.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,e), edp(i0,r))) / ;
                put sim.tl, "eip",  r.tl, e.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,e), eip(i0,r))) / ;
                put sim.tl, "edg",  r.tl, e.tl, "gov" ,"", m_PUTYEAR, (sum(mapi0(i0,e), edg(i0,r))) / ;
                put sim.tl, "eig",  r.tl, e.tl, "gov" ,"", m_PUTYEAR, (sum(mapi0(i0,e), eig(i0,r))) / ;
                put sim.tl, "edi",  r.tl, e.tl, "inv" ,"", m_PUTYEAR, (sum(mapi0(i0,e), edi(i0,r))) / ;
                put sim.tl, "eii",  r.tl, e.tl, "inv" ,"", m_PUTYEAR, (sum(mapi0(i0,e), eii(i0,r))) / ;
            ) ;

            loop((r,i),
                put sim.tl, "vdpa", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vdpa(i0,r))) / ;
                put sim.tl, "vdpm", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vdpm(i0,r))) / ;
                put sim.tl, "vipa", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vipa(i0,r))) / ;
                put sim.tl, "vipm", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vipm(i0,r))) / ;

                put sim.tl, "vdga", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vdga(i0,r))) / ;
                put sim.tl, "vdgm", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vdgm(i0,r))) / ;
                put sim.tl, "viga", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), viga(i0,r))) / ;
                put sim.tl, "vigm", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vigm(i0,r))) / ;

                loop(cgds0,
                    put sim.tl, "vdia", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vdfa(i0,cgds0,r))) / ;
                    put sim.tl, "vdim", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vdfm(i0,cgds0,r))) / ;
                    put sim.tl, "viia", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vifa(i0,cgds0,r))) / ;
                    put sim.tl, "viim", r.tl, i.tl, "hhd" ,"", m_PUTYEAR, (sum(mapi0(i0,i), vifm(i0,cgds0,r))) / ;
                ) ;
            ) ;

            loop((r,e,a),
                put sim.tl, "edf",  r.tl, e.tl, a.tl ,"", m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,e) and mapa0(a0,a)), edf(i0,a0,r))) / ;
                put sim.tl, "eif",  r.tl, e.tl, a.tl ,"", m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,e) and mapa0(a0,a)), eIF(i0,a0,r))) / ;
            ) ;
            loop((r,i,a),
                put sim.tl, "vdfa", r.tl, i.tl, a.tl ,"", m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,i) and mapa0(a0,a)), vdfa(i0,a0,r))) / ;
                put sim.tl, "vdfm", r.tl, i.tl, a.tl ,"", m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,i) and mapa0(a0,a)), vdfm(i0,a0,r))) / ;
                put sim.tl, "vifa", r.tl, i.tl, a.tl ,"", m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,i) and mapa0(a0,a)), vifa(i0,a0,r))) / ;
                put sim.tl, "vifm", r.tl, i.tl, a.tl ,"", m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,i) and mapa0(a0,a)), vifm(i0,a0,r))) / ;
            ) ;
            loop((r,i),
                loop(rp,
                    put sim.tl, "vims", r.tl, i.tl, rp.tl ,"", m_PUTYEAR, (sum(i0$mapi0(i0,i), vims(i0,r,rp))) / ;
                    put sim.tl, "viws", r.tl, i.tl, rp.tl ,"", m_PUTYEAR, (sum(i0$mapi0(i0,i), viws(i0,r,rp))) / ;
                    put sim.tl, "vxmd", r.tl, i.tl, rp.tl ,"", m_PUTYEAR, (sum(i0$mapi0(i0,i), vxmd(i0,r,rp))) / ;
                    put sim.tl, "vxwd", r.tl, i.tl, rp.tl ,"", m_PUTYEAR, (sum(i0$mapi0(i0,i), vxwd(i0,r,rp))) / ;
                ) ;
            ) ;
            loop((r,e),
                loop(rp,
                    put sim.tl, "exi",  r.tl, e.tl, rp.tl ,"", m_PUTYEAR, (sum(i0$mapi0(i0,e), exi(i0,r,rp))) / ;
                ) ;
            ) ;
            loop((r,fi),
                loop(a,
                    put sim.tl, "mdf", r.tl, fi.tl, a.tl ,"", m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,fi) and mapa0(a0,a)), mdf(i0,a0,r))) / ;
                    put sim.tl, "mif", r.tl, fi.tl, a.tl ,"", m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,fi) and mapa0(a0,a)), mIF(i0,a0,r))) / ;
                ) ;
                put sim.tl, "mdg", r.tl, fi.tl, "Gov" ,"", m_PUTYEAR, (sum(i0$mapi0(i0,fi), mdg(i0,r))) / ;
                put sim.tl, "mig", r.tl, fi.tl, "Gov" ,"", m_PUTYEAR, (sum(i0$mapi0(i0,fi), mig(i0,r))) / ;
                put sim.tl, "mdp", r.tl, fi.tl, "Hhd" ,"", m_PUTYEAR, (sum(i0$mapi0(i0,fi), mdp(i0,r))) / ;
                put sim.tl, "mip", r.tl, fi.tl, "Hhd" ,"", m_PUTYEAR, (sum(i0$mapi0(i0,fi), mip(i0,r))) / ;
                put sim.tl, "mdi", r.tl, fi.tl, "Inv" ,"", m_PUTYEAR, (sum(i0$mapi0(i0,fi), mdi(i0,r))) / ;
                put sim.tl, "mii", r.tl, fi.tl, "Inv" ,"", m_PUTYEAR, (sum(i0$mapi0(i0,fi), mii(i0,r))) / ;
            ) ;
            loop((r, emn),
                loop(a,
                    put sim.tl, "nc_qo_ceq", r.tl, "", a.tl, emn.tl, m_PUTYEAR, (sum(a0$mapa0(a0,a), nc_qo_cEQ(emn, a0, r))) / ;
                    put sim.tl, "nc_qo", r.tl, "", a.tl, emn.tl, m_PUTYEAR, (sum(a0$mapa0(a0,a), nc_qo(emn, a0, r))) / ;
                    loop(fp,
                        put sim.tl, "nc_endw_ceq", r.tl, fp.tl, a.tl, emn.tl, m_PUTYEAR, (sum(a0$mapa0(a0,a), nc_endw_cEQ(emn, fp, a0, r))) / ;
                        put sim.tl, "nc_endw", r.tl, fp.tl, a.tl, emn.tl, m_PUTYEAR, (sum(a0$mapa0(a0,a), nc_endw(emn, fp, a0, r))) / ;
                    ) ;
                    loop(i,
                        put sim.tl, "nc_trad_ceq", r.tl, i.tl, a.tl, emn.tl, m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,i) and mapa0(a0,a)), nc_trad_cEQ(emn, i0, a0, r))) / ;
                        put sim.tl, "nc_trad", r.tl, i.tl, a.tl, emn.tl, m_PUTYEAR, (sum((i0,a0)$(mapi0(i0,i) and mapa0(a0,a)), nc_trad(emn, i0, a0, r))) / ;
                    ) ;
                ) ;
                loop(i,
                    put sim.tl, "nc_hh_ceq", r.tl, i.tl, "hhd", emn.tl, m_PUTYEAR, (sum(i0$mapi0(i0,i), nc_hh_cEQ(emn, i0, r))) / ;
                    put sim.tl, "nc_hh", r.tl, i.tl, "hhd", emn.tl, m_PUTYEAR, (sum(i0$mapi0(i0,i), nc_hh(emn, i0, r))) / ;
                ) ;
            ) ;
        ) ; !! Close loop on GTAP initial variables

    ) ; !! Close loop on r

) ;

*------------------------------------------------------------------------------*
*                           [OECD-ENV]: MAC analysis                            *
*------------------------------------------------------------------------------*

* (TODO case ifCEQ) --> [TBD]: put this in CarbonTax.gms

$Ifi %PolicyFile%=="CarbonTax" ifCsvMAC = 1 ;

$IFTheni.CarbonPol SET AgentTax

$OnDotl

    IF(ifCsvMAC,

        IF(VarFlag,
            fmac.ap = 1 ; put fmac ;
        ELSE
            fmac.ap = 0 ; put fmac ;
            put "Carbon Tax,Variable,Region,rlab,Agent,Time,value" / ;
        ) ;

        fmac.pc=5 ;
        fmac.nd=9 ;

        loop(t $ between3(t,"%YearAntePolicy%","%EndTimeLoop%") ,

            LOOP(r $ %rPol%(r),
                rwork(r) = 0 ;
                loop(em $ %GhgTax%(em),
                    rwork(r) = emitax.l(r,em,t) * m_convCtax;
                    loop(a $ (xpFlagT(r,a,t) and %AgentTax%(a)),
                        IF(rwork(r),
                            put %cTaxLevel%, "Carbon Tax (USD/tCO2EQ)", r.tl, em.tl, a.tl, m_PUTYEAR, rwork(r) / ;
                        ) ;
                        put %cTaxLevel%, "emission (Mt CO2eq)", r.tl, em.tl, a.tl, m_PUTYEAR, (sum(EmiSource,m_true4(emi,r,em,EmiSource,a,t))/ cscale) / ;
                        put %cTaxLevel%, "real GDP", r.tl, 'real', 'tot', m_PUTYEAR, (outscale * m_true1(rgdpmp,r,t)) / ;
                    ) ;
                ) ;
                loop((abstype,a,notvol) $ (xpFlagT(r,a,t) and %AgentTax%(a)),
                        put %cTaxLevel%, "Value Added (BP)", r.tl, notvol.tl, a.tl, m_PUTYEAR, out_Value_Added(abstype,"Basic Prices",notvol,r,a,t) / ;
                        put %cTaxLevel%, "Gross output",     r.tl, notvol.tl, a.tl, m_PUTYEAR, out_Gross_output(abstype,notvol,r,a,t) / ;
                ) ;
            ) ;
        ) ;

        putclose fmac ;

    ) ;
$OffDotl

$EndIf.CarbonPol


**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************
**********************************************************************************************************************
***HRR: output variables for MainOutput.gdx that are used in Dashboard

******************************************************************************************************************
* ENERGY
*** Electricity generation/mix

    elygen(r,t) = sum(elya, (x.l(r,elya,"ely-c",t) * x0(r,elya,"ely-c",t)) ) / Powscale;
    elyMix(r,elyantd,t)$x0(r,elyantd,"ELY-c",t) =
          (x.l(r,elyantd,"ELY-c",t)*x0(r,elyantd,"ELY-c",t) )
        / sum(elyantd2, (x.l(r,elyantd2,"ELY-c",t) * x0(r,elyantd2,"ELY-c",t))) ;
    pely(r,t)   = pat.l(r,"ely-c",t) ;
    pely_pro(r,t) = sum((elya,elyi), p.l(r,elya,elyi,t) * p0(r,elya,elyi) * x.l(r,elya,elyi,t) * x0(r,elya,elyi,t)) / ( elygen(r,t) * Powscale) ;
    pely_hhd(r,t) = pa.l(r,"ely-c","hhd",t) ;

*** Energy
    NrgCons(r,t)      = (sum((e, aa), (xa.l(r,e,aa,t) * xa0(r,e,aa,t)) ) * outScale) ;
    NrgConsi(r,e,t)   = (sum((aa), (xa.l(r,e,aa,t) * xa0(r,e,aa,t)) ) * outScale) ;
    NrgConsih(r,e,t)  = ( (xa.l(r,e,"hhd",t) * xa0(r,e,"hhd",t) ) * outScale) ;

    lambdaw(r,i,rp,t) $ (lambdaw(r,i,rp,t) eq 0) = 1;
    Mbil(r,rp,t)    = sum(e, xw.l(rp,e,r,t) * xw0(rp,e,r) * (lambdaw(rp,e,r,t) / lambdaw(rp,e,r,t0))  ) * outScale;
    Mbili(r,e,rp,t) =      ( xw.l(rp,e,r,t) * xw0(rp,e,r) * (lambdaw(rp,e,r,t) / lambdaw(rp,e,r,t0))  ) * outScale ;

    Mshr(r,t)    $ NrgCons(r,t)      = sum(rp, Mbil(r,rp,t)) /  NrgCons(r,t);
    Mshri(r,e,t) $ NrgConsi(r,e,t)   = sum(rp, Mbili(r,e,rp,t)) /  NrgConsi(r,e,t) ;

*** EUR DP 2024 Energy Security indicators
    CJLindex(r,t)  = sum(rp, ((sum(e, (xw.l(rp,e,r,t) * xw0(rp,e,r) * (lambdaw(rp,e,r,t) / lambdaw(rp,e,r,t0))))* outScale) /  NrgCons(r,t) )**2 ) ;
    Hindex(r,t)     = sum(rp, ((sum(e, (xw.l(rp,e,r,t) * xw0(rp,e,r) * (lambdaw(rp,e,r,t) / lambdaw(rp,e,r,t0))))* outScale) / (sum(rp2, Mbil(r,rp2,t)))) **2 ) ;
    NrgExp_GDP(r,t)   = (sum((e, aa), (xa.l(r,e,aa,t) * xa0(r,e,aa,t) * pat.l(r,e,t) * pat0(r,e) ) ))  / (gdpmp.l(r,t) * gdpmp0(r) ) ;

*** Energy intensity
    workrat(r,aa,t) = sum( i , (xa.l(r,i,aa,t) * xa0(r,i,aa,t)) )  ;
    NrgIntC(r,aa,t) $ workrat(r,aa,t)    = sum(e, (xa.l(r,e,aa,t) * xa0(r,e,aa,t)) ) / workrat(r,aa,t) ;

    workrat(r,a,t) =  xp.l(r,a,t) * xp0(r,a,t) ;
    NrgIntA(r,a,t) $ workrat(r,a,t)    = sum(e, (xa.l(r,e,a,t) * xa0(r,e,a,t)) ) / workrat(r,a,t) ;

*** Energy accounting
   NrgAcc(r,e,t,"M") = sum (rp, (xw.l(rp,e,r,t) * xw0(rp,e,r) * (lambdaw(rp,e,r,t) / lambdaw(rp,e,r,t0)) )) * outScale ;
   NrgAcc(r,e,t,"X") = sum(rp,  (xw.l(r,e,rp,t) * xw0(r,e,rp)  )) * outScale ;
   NrgAcc(r,e,t,"Y") = ( (xs.l(r,e,t) * xs0(r,e)) ) * outScale ;
   NrgAcc(r,e,t,"C") =  (sum((aa), (xa.l(r,e,aa,t) * xa0(r,e,aa,t)) ) * outScale) ;
   NrgAcc(r,e,t,"Res") =   NrgAcc(r,e,t,"Y") +  NrgAcc(r,e,t,"M") -  NrgAcc(r,e,t,"C") -  NrgAcc(r,e,t,"X")  ;
********************************************************************************

******************************************************************************************************************
* REAL ECONOMY

*** Labour markets
    Lemp(r,t)   = sum(l, ls.l(r,l,t)*ls0(r,l) ) * outScale;
    Lempsec(r,a,t)  = sum(l, (ld.l(r,l,a,t) * ld0(r,l,a,t))) * outScale;

*    rwagerep(r,l,t)  = rwage.l(r,l,"nsg",t) ;
*   rwagerep(r,t)  = sum(l,awagez.l(r,l,"nsg",t) ) / 2;
    wage_nom(r,t)  = awagez.l(r,"Labour","nsg",t)  ;
    wage_real(r,t) =  wage_nom(r,t) / pgdpmp.l(r,t) ;


*** Kstock and investment
    Kstock_real(r,a,t)   = sum(v, (pk.l(r,a,v,t0) * pk0(r,a) * kv.l(r,a,v,t) * kv0(r,a,t)) ) / chiKaps0(r) ;
    Kstock_nom(r,a,t)    = sum(v, (pk.l(r,a,v,t)  * pk0(r,a) * kv.l(r,a,v,t) * kv0(r,a,t)) ) / chiKaps0(r) ;
    gInv_real(r,a,t)   = sum(v, (pk.l(r,a,v,t0) * pk0(r,a) * kv.l(r,a,v,t) * kv0(r,a,t)) ) ;
    gInv_nom(r,a,t)    = sum(v, (pk.l(r,a,v,t)  * pk0(r,a) * kv.l(r,a,v,t) * kv0(r,a,t)) ) ;
    ely_inv(r,t)    = sum((elya,v), (pk.l(r,elya,v,t)  * pk0(r,elya) * kv.l(r,elya,v,t) * kv0(r,elya,t)) ) ;

*** International trade
*** XPT, XAPT, REXP, EXP, RIMP and IMP are generated in 91-Common_Auxiliary.gms
    xp_real(r,a,t)      = px.l(r,a,t0) * px0(r,a) * XPT(r,a,t) ;
    xp_nom(r,a,t)       = px.l(r,a,t)  * px0(r,a) * XPT(r,a,t) ;
    intinp_real(r,a,t)  = sum(i, (pa.l(r,i,a,t0) * pa0(r,i,a) * XAPT(r,i,a,t))) ;
    intinp_nom(r,a,t)   = sum(i, (pa.l(r,i,a,t)  * pa0(r,i,a) * XAPT(r,i,a,t))) ;
    gva_real(r,a,t)     = xp_real(r,a,t) - intinp_real(r,a,t) ;
    gva_nom(r,a,t)      = xp_nom(r,a,t)  - intinp_nom(r,a,t)  ;





******************************************************************************************************************
* EMISSIONS

*** total emissions of ALL GHG

$onDotl
emiTotrep(ra,t)  = sum((r) $ (mapr(ra,r)), sum(EmSingle,        emiOth(r,EmSingle,t)
                             + sum((EmiSourceAct,aa) $ emir(r,EmSingle,EmiSourceAct,aa,t), m_true4(emi,r,EmSingle,EmiSourceAct,aa,t) ) ) ) / cscale ;
$offDotl

** emission by three main sources:
emitot_source(ra,"lulucf",t) = sum((em,aa,r) $ (mapr(ra,r)), emi.l(r,em, "lulucf" ,aa,t) *  
                                    emi0(r,em, "lulucf" ,aa)) / cscale ;
emitot_source(ra,"co2",t)    = (sum((CO2,r) $ (mapr(ra,r)), emitot.l(r,CO2,t) * emitot0(r,CO2)) / cscale)  
                                - emitot_source(ra,"lulucf",t)  ;
emitot_source(ra,"nonco2",t) = sum((nonco2,r) $ (mapr(ra,r)), emitot.l(r,nonco2,t) * emitot0(r,nonco2)) / cscale ;
*emitot_source(ra,"co2_lulucf",t)    = sum((em    ,r) $ (mapr(ra,r)), emitot.l(r,em    ,t) *  emitot0(r,em    )) / cscale ;

emitot_act(ra,aa,t)         = sum((em,emiSource,r) $ (mapr(ra,r)), emi.l(r,em,emiSource,aa,t) * emi0(r,em,emiSource,aa)) / cscale ;

$$iftheni %GroupName%=="NGFS"
    emitot_act(ra,"inv",t) $ CCUS_check2(ra,t)    = CCUS_check2(ra,t) / cscale ;
    emitot_act(ra,"frs-a",t)    = emitot_act(ra,"frs-a",t) - emitot_act(ra,"inv",t) ;
$$endif

*** Main emission sources:    agriculture, energy, transportation, industry, and other (waste, heating,etc.)

* Agriculture GHG emissions
    emitot_sou(ra,"agr",t)       =   sum((emSingle,EmiSource,agra,r) $ (mapr(ra,r)),  (emi.l(r,emSingle, EmiSource,agra,t) * emi0(r,emSingle,EmiSource,agra))) / cscale ;

*"Transport GHG emissions"
    emitot_sou(ra,"trp",t)        = ( sum((emSingle,EmiSource,transporta,r) $ (mapr(ra,r)), (emi.l(r,emSingle, EmiSource,transporta,t) * emi0(r,emSingle,EmiSource,transporta)))
                           + sum((emSingle,r) $ (mapr(ra,r)), (emi.l(r,emSingle,"roilcomb","hhd",t) * emi0(r,emSingle,"roilcomb","hhd"))) ) / cscale ;
*"Electricity GHG emissions"
    emi_elya(ra,t)      =   sum((emSingle,EmiSource,elya,r) $ (mapr(ra,r)),  (emi.l(r,emSingle, EmiSource,elya,t) * emi0(r,emSingle,EmiSource,elya))) / cscale ;

*"Energy GHG emissions"
    emitot_sou(ra,"nrg",t)       =  ( sum((emSingle,EmiSource,fossilea,r) $ (mapr(ra,r)),  (emi.l(r,emSingle, EmiSource,fossilea,t) * emi0(r,emSingle,EmiSource,fossilea)))
                        +  sum((emSingle,EmiSource,r)           $ (mapr(ra,r)),  (emi.l(r,emSingle, EmiSource,"p_c-a",t)  * emi0(r,emSingle,EmiSource,"p_c-a")))
                            ) / cscale  + emi_elya(ra,t) ;
*"Industry GHG emissions"
    emitot_sou(ra,"ind",t)       =  ( sum((emSingle,EmiSource,mana,r) $ (mapr(ra,r)),  (emi.l(r,emSingle, EmiSource,mana,t) * emi0(r,emSingle,EmiSource,mana))) ) / cscale   ;

$if %GroupName%=="2024_MCD"  emitot_sou(ra,"ind",t)  =  ( sum((emSingle,EmiSource,mana2,r) $ (mapr(ra,r)),  (emi.l(r,emSingle, EmiSource,mana2,t) * emi0(r,emSingle,EmiSource,mana2))) ) / cscale   ;

*"Oth GHG emissions"
    emitot_sou(ra,"oth",t)       =  emitotrep(ra,t) -  sum(es $(not sameas(es,"oth")), emitot_sou(ra,es,t) );



*** other emission calculations
*"Total methane emissions"
    emi_ch4(ra,t)       =   sum((EmiSource,aa,r) $ (mapr(ra,r)), ( emi.l(r,"ch4",EmiSource,aa,t) * emi0(r,"ch4",EmiSource,aa))) / cscale ;
** Fugitive  emissions
    emi_fugi(ra,t)      =  sum((emSingle,aa,r) $ (mapr(ra,r)),  (emi.l(r,emSingle,"fugitive",aa,t) * emi0(r,emSingle,"fugitive",aa)) ) / cscale ;
** Activity  emissions
    emi_act(ra,t)       =  sum((emSingle,aa,r) $ (mapr(ra,r)),  (emi.l(r,emSingle,"act",aa,t) * emi0(r,emSingle,"act",aa)) ) / cscale ;
*** Total sf6 emissions
    emi_sf6(ra,t)       =   sum((EmiSource,aa,r) $ (mapr(ra,r)), ( emi.l(r,"sf6",EmiSource,aa,t) * emi0(r,"sf6",EmiSource,aa))) / cscale ;
*** Total n2o emissions
    emi_n2o(ra,t)       =   sum((EmiSource,aa,r) $ (mapr(ra,r)), ( emi.l(r,"n2o",EmiSource,aa,t) * emi0(r,"n2o",EmiSource,aa))) / cscale ;
*** Total FGAS emissions
    emi_fgas(ra,t)       =   sum((EmiSource,aa,r) $ (mapr(ra,r)), ( emi.l(r,"fgas",EmiSource,aa,t) * emi0(r,"fgas",EmiSource,aa))) / cscale ;
*** Total HFC,Hydrofluorocarbons emissions
    emi_hfc(ra,t)       =   sum((EmiSource,aa,r) $ (mapr(ra,r)), ( emi.l(r,"hfc",EmiSource,aa,t) * emi0(r,"hfc",EmiSource,aa))) / cscale ;
*** Total emissions by gas
    emi_gas(ra,em,t) =   sum((EmiSource,aa,r) $ (mapr(ra,r)), ( emi.l(r,em,EmiSource,aa,t) * emi0(r,em,EmiSource,aa))) / cscale ;

$iftheni.mcd %GroupName%=="2024_MCD"
*"Mining GHG emissions"
    emi_min(ra,t)       =  sum((emSingle,EmiSource,mina,r) $ (mapr(ra,r)),  (emi.l(r,emSingle, EmiSource,mina,t) * emi0(r,emSingle,EmiSource,mina)) ) / cscale ;
*"Total methane emissions excluding methane emisison in transport, electricity and mining"
    emi_ch4excl(ra,t)   = emi_ch4(ra,t) - ((sum((EmiSource,ch4excl,r) $ (mapr(ra,r)), ( emi.l(r,"ch4",EmiSource,ch4excl,t) * emi0(r,"ch4",EmiSource,ch4excl)))
                            - sum((r) $ (mapr(ra,r)), (emi.l(r,"ch4","roilcomb","hhd",t) * emi0(r,"ch4","roilcomb","hhd"))) ) / cscale) ;
$endif.mcd
** Check on emitotrep
    emi_check(ra,t)     =  sum((emSingle,EmiSource,aa,r) $ (mapr(ra,r)),  (emi.l(r,emSingle,EmiSource,aa,t) * emi0(r,emSingle,EmiSource,aa)) ) / cscale ;
** "Diff between emitotrep and emitotALLGHG"
    emi_check2(ra,t)    =  (sum((r) $ (mapr(ra,r)),  emitotALLGHG(r,t)) / cscale) - emi_check(ra,t) ;




****************************************************************************************************************************
*HRR: code taken from GDP_decomposition.gms by Jean (which ran independently and defined all variables used)

GDP_component("C","real",r,t)
    = xfd.l(r,"hhd",t) * xfd0(r,"hhd") * pfd0(r,"hhd") ;
GDP_component("C","nominal",r,t)
    = GDP_component("C","real",r,t) * pfd.l(r,"hhd",t) ;

GDP_component("G","real",r,t)
    = xfd.l(r,"gov",t) * xfd0(r,"gov") * pfd0(r,"gov") ;
GDP_component("G","nominal",r,t)
    = GDP_component("G","real",r,t) * pfd.l(r,"gov",t) ;

GDP_component("I","real",r,t)
    = xfd.l(r,"inv",t) * xfd0(r,"inv") * pfd0(r,"inv") ;
GDP_component("I","nominal",r,t)
    = GDP_component("I","real",r,t) * pfd.l(r,"inv",t) ;

GDP_component("IM","nominal",r,t)
    = sum((i,rp) $ xw0(rp,i,r), xw.l(rp,i,r,t) * xw0(rp,i,r) * pwm.l(rp,i,r,t) * pwm0(rp,i,r)
                                               * (lambdaw(rp,i,r,t) / lambdaw(rp,i,r,t0)) );
GDP_component("IM","real",r,t)
    = sum((i,rp) $ xw0(rp,i,r), xw.l(rp,i,r,t) * xw0(rp,i,r) * pwm0(rp,i,r)
                                               *  lambdaw(rp,i,r,t) / lambdaw(rp,i,r,t0)  );

*** HRR: changed index I for img for trade margins xtt
GDP_component("EX","nominal",r,t)
    = sum((i,rp) $ xw0(r,i,rp), xw.l(r,i,rp,t) * xw0(r,i,rp) * pwe.l(r,i,rp,t) * pwe0(r,i,rp) )
    + sum(img $ xtt0(r,img), pdt.l(r,img,t) * pdt0(r,img) * xtt.l(r,img,t) * xtt0(r,img)) ;
GDP_component("EX","real",r,t)
    = sum((i,rp) $ xw0(r,i,rp), xw.l(r,i,rp,t) * xw0(r,i,rp) * pwe0(r,i,rp) )
    + sum(img $ xtt0(r,img), pdt0(r,img) * xtt.l(r,img,t) * xtt0(r,img)) ;

***added the 2 at the end of the variables (defined in 22-Additional_Sets.gms)
GDP_component("gdp",unit2,r,t)
    = GDP_component("C",unit2,r,t) + GDP_component("I",unit2,r,t)
    + GDP_component("G",unit2,r,t) + GDP_component("EX",unit2,r,t)
    - GDP_component("IM",unit2,r,t) ;

GDP_component("netX",unit2,r,t) = GDP_component("EX",unit2,r,t)  - GDP_component("IM",unit2,r,t) ;

GDPcomp(r,t,var2) = GDP_component(var2,"real",r,t) ;

*** Scaling to have US billion
GDP_component(var2,unit2,r,t) = GDP_component(var2,unit2,r,t) * 1000;

***********************************************************************************************************
*** Estimation of Imports and exports including iceberg trade costs
    impt_tot_real(r,t) = GDP_component("IM","real",r,t) ;
    impt_real(r,i,t)   = 1000 * sum((rp) $ xw0(rp,i,r), xw.l(rp,i,r,t) * xw0(rp,i,r) * pwm0(rp,i,r)
                                               *  lambdaw(rp,i,r,t) / lambdaw(rp,i,r,t0)  ) ;
    impt_tot_nom(r,t)  = GDP_component("IM","nominal",r,t) ;
    impt_nom(r,i,t)    = 1000 * sum((rp) $ xw0(rp,i,r), xw.l(rp,i,r,t) * xw0(rp,i,r) * pwm.l(rp,i,r,t) * pwm0(rp,i,r)
                                               * (lambdaw(rp,i,r,t) / lambdaw(rp,i,r,t0)) ) ;

    expt_tot_real(r,t) = GDP_component("EX","real",r,t) ;
    expt_real(r,i,t)   = 1000 * sum((rp) $ xw0(r,i,rp), xw.l(r,i,rp,t) * xw0(r,i,rp) * pwe0(r,i,rp) )
    + sum(img $ xtt0(r,img), pdt0(r,img) * xtt.l(r,img,t) * xtt0(r,img)) ;
    expt_tot_nom(r,t)  = GDP_component("EX","nominal",r,t) ;
    expt_nom(r,i,t)     = 1000 * sum((rp) $ xw0(r,i,rp), xw.l(r,i,rp,t) * xw0(r,i,rp) * pwe.l(r,i,rp,t) * pwe0(r,i,rp) )
    + sum(img $ xtt0(r,img), pdt.l(r,img,t) * pdt0(r,img) * xtt.l(r,img,t) * xtt0(r,img)) ;

    MktShr(r,i,t) $(expt_real(r,i,t))      = expt_real(r,i,t) / sum(rp,  expt_real(rp,i,t) ) ;

    MktShrDB(r,agcDBK2,t)$(sum(i, expt_real(r,i,t)))   = sum(i $ (mapagcDBK2(agcDBK2,i)),   (expt_real(r,i,t) /
                                sum((rp,i2) $ (mapagcDBK2(agcDBK2,i2)),  expt_real(rp,i2,t))) ) ;

    expt_bil(r,rp,t) =  1000 * sum(i, (xw.l(r,i,rp,t) * xw0(r,i,rp) * pwe.l(r,i,rp,t) * pwe0(r,i,rp) ) ) ;

    impt_bil(r,rp,t) =  1000 * sum(i, (xw.l(rp,i,r,t) * xw0(rp,i,r) * pwe.l(rp,i,r,t) * pwe0(rp,i,r) ) );

Pop_rep(ra,t) = sum((r) $ (mapr(ra,r)), (pop.l(r,t) / popScale) ) ;

    GDP_real(r,t)    = rgdpmp0(r) * rgdpmp.l(r,t) * outscale ;
    GDP_nom(r,t)     = gdpmp0(r)  *  gdpmp.l(r,t) * outscale ;
    CABsh(r,t)      = - savf.l(r,t) / (rgdpmp0(r) * rgdpmp.l(r,t)) ;
    GBalSh(r,t)     = savg.l(r,t) / (rgdpmp0(r) * rgdpmp.l(r,t)) ;

*** GVA for GDP supply decomposition (first adj. gva so sum(gva)=GDPreal)
    workrt(r,t) = GDP_real(r,t) - sum(a, gva_real(r,a,t)) ;
    gva_gdp(r,a,t) = gva_real(r,a,t) + workrt(r,t) * (gva_real(r,a,t) / sum(a2, gva_real(r,a2,t)))  ;

$iftheni not %SimType%=="Baseline"
    GDPdecSup(r,a,t) $ (gva_gdpbau(r,a,t)) =
                    (gva_gdp(r,a,t) / gva_gdpbau(r,a,t) - 1 ) * (gva_gdpbau(r,a,t) / GDP_realbau(r,t)) ;
$endif

    yd_rep(r,t)  = yh.l(r,t) * yh0(r) * outscale ;
    yh_rep(r,t)  = yd.l(r,t) * yd0(r) * outscale ;


************************
* Kaya decomposition: Emi = Pop * GDP/Pop * Nrg/GDP * Emi/Nrg
** Needs to be done only for CO2
*GDP per capita (GDP/Pop)
GDPpc(ra,t)     = sum((r) $ (mapr(ra,r)), GDP_real(r,t) / Pop_rep(ra,t) );
* Nrg/GDP  is the energy intensity of the GDP
NrgGDP(ra,t)    = sum((r) $ (mapr(ra,r)), (sum((e, aa), (xa.l(r,e,aa,t) * xa0(r,e,aa,t) )) * outScale)  / GDP_real(r,t)) ;
* Emi/Nrg  is the emission intensity of energy
**for CO2 only:
EmiNrg(ra,t)    = sum((r) $ (mapr(ra,r)), (emitot_source(ra,"co2",t)  / (sum((e, aa), (xa.l(r,e,aa,t) * xa0(r,e,aa,t) )) * outScale )) ) ;


*** Government accounts
*Gov. revenues by tax
ygov_rep(ra,gy,t)   = sum((r) $ (mapr(ra,r)), ygov.l(r,gy,t) * ygov0(r,gy) ) * outScale ;
*Gov. balance
savg_rep(ra,t)      = sum((r) $ (mapr(ra,r)),savg.l(r,t) * savg0(r) * outScale ) ;
*Gov. total expenditures
cgov_rep(ra,t)      = sum(gy, ygov_rep(ra,gy,t)) - savg_rep(ra,t) ;

***Carbon tax
**fix to make generic!
    ctax(r,t)         = (p_emissions(r,"co2","roilcomb","otp-a",t) + emiTax.l(r,"co2",t) )/ cscale;
*    EMITAXT(r,EmSingle,t) = emiTax.l(r,EmSingle,t) * m_convCtax ;
** Carbon tax revenue
    ctrev(r,t)      =  ygov0(r,"ctax") * ygov.l(r,"ctax",t)  * outScale;
    ctrev_gdp(r,t)  =   ctrev(r,t)  / GDP_nom(r,t) ;



*** Consumer prices
cprice(r,agcDBK,t) = sum(i $ (mapagcDBK(agcDBK,i)), pat.l(r,i,t) * xat.l(r,i,t) * xat0(r,i,t) ) /
                     sum(i $ (mapagcDBK(agcDBK,i)), xat.l(r,i,t) * xat0(r,i,t) )  ;

*** Consumer price index
CPI(r,t)  $ sum((i,h,t0), pa.l(r,i,h,t0) * pa0(r,i,h) * XAPT(r,i,h,t0))
    = sum((i,h,t0),  pa.l(r,i,h,t)  * pa0(r,i,h) * XAPT(r,i,h,t0))
    / sum((i,h,t0),  pa.l(r,i,h,t0) * pa0(r,i,h) * XAPT(r,i,h,t0));

*** International prices
pw_rep(a,t) = pw.l(a,t);

*** Producer prices
pp_rep(r,agaDB,t) $ (sum(a $ (mapagaDB1(agaDB,a)), xp.l(r,a,t) * xp0(r,a,t) ) )
                     =  sum(a $ (mapagaDB1(agaDB,a)), pp.l(r,a,t) * pp0(r,a) * xp.l(r,a,t) * xp0(r,a,t) ) /
                        sum(a $ (mapagaDB1(agaDB,a)), xp.l(r,a,t) * xp0(r,a,t) ) ;

*** Effective real exchange rate
    REER(r,t) = 100 *  CPI(r,t) / ((sum(rp $(not sameas(rp,r)), (CPI(rp,t) *
                                (expt_bil(r,rp,t) + impt_bil(r,rp,t) ) ) ) )
             / (expt_tot_nom(r,t) + impt_tot_nom(r,t) ))    ;


* make a global and set in a_ProjectOptions.gms
DBlastyear = 2023; !!  "Last (historical) year for Dashboad graphs"

********************************************************************************************************************************
    EXECUTE_UNLOAD "%oDir%\%simName%.gdx" ;

    EXECUTE_UNLOAD "%oDir%\MainOutput\MainOutput_%simName%.gdx",  mapaga, DBlastyear, mapagaDB1, mapagaDB2,
        mapagcDBK, mapagcDBK2,  cprice, pp_rep, MktShrDB,
        GDP_real, GDP_nom, GDPcomp, CABsh, GBalSh, xp_real, xp_nom, gva_real, gva_nom, intinp_real, intinp_nom,
        CJLindex, Hindex, NrgExp_GDP, Mbil, Mbili, Mshr, Mshri, NrgCons, NrgConsi, pely, CPI, TermsOfTradeT,
        Pop_rep, GDPpc, NrgGDP, EmiNrg, GDPdecSup,
        ygov_rep, cgov_rep, savg_rep, yd_rep, yh_rep,
        elymix, elygen, ely_inv, ctax, ctrev, ctrev_gdp, emiTotrep, emitot_act, emitot_sou,
        Lemp, Lempsec, wage_nom, wage_real, Kstock_real, Kstock_nom, gInv_real, gInv_nom,
        expt_tot_real, impt_tot_real, expt_real, impt_real, expt_tot_nom, impt_tot_nom, expt_nom, impt_nom, pw_rep,
        MktShr, TermsofTradeT, REER 
$ifi %SimName%=="Baseline"        , ely_GWh_agg, nrg_TJ_agg
        ;

********************************************************************************************************************************





