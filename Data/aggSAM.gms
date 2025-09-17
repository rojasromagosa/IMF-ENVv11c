*---     Flags:
* 1% =  AggGTAP
* 2% =   1

IF(%ifCSV%,
   put csv ;
   IF(ifFirstPass,
      put "SAMLabel,Var,Region,RowLabel,ColLabel,Value" / ;
      csv.pc=5 ;
      csv.nd=9 ;
      ifFirstPass = 0 ;
   ) ;

*  Production accounts

   loop((r,a)$(not cgds(a)),
      loop(i,
         put "%1", "SAM", r.tl, i.tl, a.tl, (vdfm%2(i,a,r)+vifm%2(i,a,r)) / ;
      ) ;
      put "%1", "SAM", r.tl, "itax", a.tl, (sum(i,vdfa%2(i,a,r)+vifa%2(i,a,r)-vdfm%2(i,a,r)-vifm%2(i,a,r))) / ;

      loop(fp,
         put "%1", "SAM", r.tl, fp.tl, a.tl,(vfm%2(fp,a,r)) / ;
      ) ;
      put "%1", "SAM", r.tl, "vtax", a.tl, (sum(fp,evfa%2(fp,a,r) - vfm%2(fp,a,r))) / ;
      put "%1", "SAM", r.tl, "ptax", a.tl, (-osep%2(a,r)) / ;
   ) ;

*  Commodity supply

   loop((r,i),
*     put "%1", "SAM", r.tl, i.tl, i.tl, (vom%2(i,r)) / ;
      put "%1", "SAM", r.tl, "etax", i.tl, (sum(d, vxwd%2(i,r,d) - vxmd%2(i,r,d))) / ;
      put "%1", "SAM", r.tl, "mtax", i.tl, (sum(s, vims%2(i,s,r) - viws%2(i,s,r))) / ;
   ) ;

   loop(r,
      IF(ifAggTrade,
         loop(i,
            put "%1", "SAM", r.tl, "BoP",  i.tl, (sum(s, viws%2(i,s,r))) / ;
         ) ;
      else
         loop(s,
            loop(i,
               put "%1", "SAM", r.tl, s.tl,  i.tl, viws%2(i,s,r) / ;
            ) ;
            put "%1", "SAM", r.tl, "BoP",  s.tl, (sum(i, viws%2(i,s,r))) / ;
         ) ;
      ) ;
   ) ;

*  Income distribution

   loop((r,fp),
      put "%1", "SAM", r.tl, "dtax", fp.tl, (sum(a$(not cgds(a)), vfm%2(fp,a,r)) - evoa%2(fp,r) - VDEP%2(r)$cap(fp)) / ;
      put "%1", "SAM", r.tl, "REGY",   fp.tl, (evoa%2(fp,r)) / ;
      IF(cap(fp), put "%1", "SAM", r.tl, "DEPR", fp.tl, (vdep%2(r)) / ; ) ;
   ) ;

   loop(r,
      put "%1", "SAM", r.tl, "REGY", "itax", (
*        Production
         sum((i,a), vdfa%2(i,a,r)+vifa%2(i,a,r)-vdfm%2(i,a,r)-vifm%2(i,a,r))
*        Private consumption
         + sum(i, vdpa%2(i,r)+vipa%2(i,r)-vdpm%2(i,r)-vipm%2(i,r))
*        Public consumption
         + sum(i, vdga%2(i,r)+viga%2(i,r)-vdgm%2(i,r)-vigm%2(i,r))
      ) / ;
      put "%1", "SAM", r.tl, "REGY", "vtax", (sum((fp,a), evfa%2(fp,a,r) - vfm%2(fp,a,r))) / ;
      put "%1", "SAM", r.tl, "REGY", "ptax", (sum(a$(not cgds(a)), -osep%2(a,r))) / ;
      put "%1", "SAM", r.tl, "REGY", "etax", (sum((i,d), vxwd%2(i,r,d) - vxmd%2(i,r,d))) / ;
      put "%1", "SAM", r.tl, "REGY", "mtax", (sum((i,s), vims%2(i,s,r) - viws%2(i,s,r))) / ;
      put "%1", "SAM", r.tl, "REGY", "dtax", (sum(fp, sum(a$(not cgds(a)), vfm%2(fp,a,r)) - evoa%2(fp,r) - VDEP%2(r)$cap(fp))) / ;

      put "%1", "SAM", r.tl, "PRIV", "REGY", (sum(i, vdpa%2(i,r)+vipa%2(i,r))) / ;
      put "%1", "SAM", r.tl, "GOV",  "REGY", (sum(i, vdga%2(i,r)+viga%2(i,r))) / ;
      put "%1", "SAM", r.tl, "INV",  "REGY", (save%2(r)) / ;
   ) ;

*  Domestic absorption

   loop((r,i),
      put "%1", "SAM", r.tl, i.tl, "PRIV", (vdpm%2(i,r)+vipm%2(i,r)) / ;
      put "%1", "SAM", r.tl, i.tl, "GOV",  (vdgm%2(i,r)+vigm%2(i,r)) / ;
      loop(a$cgds(a),
         put "%1", "SAM", r.tl, i.tl, "INV",  (vdfm%2(i,a,r)+vifm%2(i,a,r)) / ;
      ) ;
   ) ;
   loop(r,
      put "%1", "SAM", r.tl, "itax", "PRIV", (sum(i, vdpa%2(i,r)+vipa%2(i,r)-vdpm%2(i,r)-vipm%2(i,r))) / ;
      put "%1", "SAM", r.tl, "itax", "GOV",  (sum(i, vdga%2(i,r)+viga%2(i,r)-vdgm%2(i,r)-vigm%2(i,r))) / ;
      put "%1", "SAM", r.tl, "itax", "INV",  (sum((i,a)$cgds(a), vdfa%2(i,a,r)+vifa%2(i,a,r)-vdfm%2(i,a,r)-vifm%2(i,a,r))) / ;
   ) ;

*  Exports

   loop((r,img),
      put "%1", "SAM", r.tl, img.tl, "ITT",  (vst%2(img,r)) / ;
   ) ;
   IF(ifAggTrade,
      loop((r,i),
         put "%1", "SAM", r.tl, i.tl, "BOP",  (sum(d, vxwd%2(i,r,d))) / ;
      ) ;
   else
      loop((r,i,d),
         put "%1", "SAM", r.tl, i.tl, d.tl,  vxwd%2(i,r,d) / ;
      ) ;
      loop((r,d),
         put "%1", "SAM", r.tl, d.tl, "BOP",  (sum(i, vxwd%2(i,r,d))) / ;
      ) ;
   ) ;

*  Closure

   loop(r,
      put "%1", "SAM", r.tl, "INV", "DEPR",  (vdep%2(r)) / ;
      put "%1", "SAM", r.tl, "ITT", "BOP", (sum(img, vst%2(img,r))) / ;
      put "%1", "SAM", r.tl, "INV", "BOP", (sum((i,s), viws%2(i,s,r) - vxwd%2(i,r,s)) - sum(img, vst%2(img,r))) / ;
   ) ;

*  Miscellaneous

   loop(r,
      put "%1", "MACRO", r.tl, "VKB", "", (VKB%2(r)) / ;
      put "%1", "MACRO", r.tl, "POP", "", (POP%2(r)) / ;
   ) ;
) ;
