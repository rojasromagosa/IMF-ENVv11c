*-------------------------------------------------------------------------------
$OnText

   CAPRI project

   GAMS file : ITRLOG.GMS

   @purpose  : Track changes during filtering
   @author   : Tom Rutherford
   @date     : 16.06.15
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : build\filter.gms

$OffText
*-------------------------------------------------------------------------------

$iftheni %1==before

   trace("vom",r,"before")  = sum(i, vom(i,r));
   trace("vdm",r,"before")  = sum(i, vdm(i,r));
   trace("vfm",r,"before")  = sum((fp,j), vfm(fp,j,r));
   trace("vifm",r,"before") = sum((i,j), vifm(i,j,r));
   trace("vdfm",r,"before") = sum((i,j), vdfm(i,j,r));
   trace("vdpm",r,"before") = sum(i, vdpm(i,r));
   trace("vipm",r,"before") = sum(i, vipm(i,r));
   trace("vdgm",r,"before") = sum(i, vdgm(i,r));
   trace("vigm",r,"before") = sum(i, vigm(i,r));
   trace("vdim",r,"before") = sum(i, vdim(i,r));
   trace("viim",r,"before") = sum(i, viim(i,r));
   trace("vxmd",r,"before") = sum((i,s), vxmd(i,r,s));
   trace("vtwr",r,"before") = sum((j,i,s), vtwr(j,i,r,s));
   trace("gdp",r,"before")  = trace("vdpm",r,"before") + trace("vipm",r,"before")
                            + trace("vdgm",r,"before") + trace("vigm",r,"before")
                            + trace("vdim",r,"before") + trace("viim",r,"before")
                            ;

$elseif %1==count

   nz("vom","count")  = card(vom);
   nz("vfm","count")  = card(vfm);
   nz("vxmd","count") = card(vxmd);
   nz("vtwr","count") = card(vtwr);
   nz("vifm","count") = card(vifm);
   nz("vdfm","count") = card(vdfm);
   nz("vdpm","count") = card(vdpm);
   nz("vdgm","count") = card(vdgm);
   nz("vdim","count") = card(vdim);
   nz("vipm","count") = card(vipm);
   nz("vigm","count") = card(vigm);
   nz("viim","count") = card(viim);

   nz(r,"count") = sum(i $ vom(i,r),1)
                 + sum(i $ vdm(i,r),1)
                 + sum(i $ vdpm(i,r),1)
                 + sum(i $ vdgm(i,r),1)
                 + sum(i $ vdim(i,r),1)
                 + sum(i $ vipm(i,r),1)
                 + sum(i $ vigm(i,r),1)
                 + sum(i $ viim(i,r),1)
                 + sum((fp,j) $ vfm(fp,j,r),1)
                 + sum((i,s)  $ vxmd(i,r,s),1)
                 + sum((i,s)  $ vxmd(i,s,r),1)
                 + sum((i,j)  $ vifm(i,j,r),1)
                 + sum((i,j)  $ vdfm(i,j,r),1)
*  ???? WHY TWICE
*                + sum((j,i,s) $ vtwr(j,i,r,s),1)
                 + sum((j,i,s) $ vtwr(j,i,s,r),1) ;

   nz(i,"count") = sum(r $ vom(i,r),1)
                 + sum(r $ vdm(i,r),1)
                 + sum(r $ vdpm(i,r),1)
                 + sum(r $ vdgm(i,r),1)
                 + sum(r $ vdim(i,r),1)
                 + sum(r $ vipm(i,r),1)
                 + sum(r $ vigm(i,r),1)
                 + sum(r $ viim(i,r),1)
                 + sum((fp,r) $ vfm(fp,i,r),1)
                 + sum((r,s)  $ vxmd(i,r,s),1)
                 + sum((j,r)  $ vifm(i,j,r),1)
                 + sum((j,r)  $ vdfm(i,j,r),1)
                 + sum((j,r,s) $ vtwr(j,i,r,s),1) ;

$else

   trace("vom",r,"after")  = sum(j, vom(j,r));
   trace("vdm",r,"after")  = sum(j, vdm(j,r));
   trace("vfm",r,"after")  = sum((fp,j), vfm(fp,j,r));
   trace("vifm",r,"after") = sum((i,j), vifm(i,j,r));
   trace("vdfm",r,"after") = sum((i,j), vdfm(i,j,r));
   trace("vdpm",r,"after") = sum(i, vdpm(i,r));
   trace("vdgm",r,"after") = sum(i, vdgm(i,r));
   trace("vdim",r,"after") = sum(i, vdim(i,r));
   trace("vipm",r,"after") = sum(i, vipm(i,r));
   trace("vigm",r,"after") = sum(i, vigm(i,r));
   trace("viim",r,"after") = sum(i, viim(i,r));
   trace("vxmd",r,"after") = sum((i,s), vxmd(i,r,s));
   trace("vtwr",r,"after") = sum((j,i,s), vtwr(j,i,r,s));
   trace("gdp",r,"after")  = trace("vdpm",r,"after") + trace("vipm",r,"after")
                           + trace("vdgm",r,"after") + trace("vigm",r,"after")
                           + trace("vdim",r,"after") + trace("viim",r,"after")
                           ;

   nz("vom","change")  = card(vom)  - nz("vom","count");
   nz("vfm","change")  = card(vfm)  - nz("vfm","count");
   nz("vxmd","change") = card(vxmd) - nz("vxmd","count");
   nz("vtwr","change") = card(vtwr) - nz("vtwr","count");
   nz("vifm","change") = card(vifm) - nz("vifm","count");
   nz("vdfm","change") = card(vdfm) - nz("vdfm","count");
   nz("vdpm","change") = card(vdpm) - nz("vdpm","count");
   nz("vdgm","change") = card(vdgm) - nz("vdgm","count");
   nz("vdim","change") = card(vdim) - nz("vdim","count");
   nz("vipm","change") = card(vipm) - nz("vipm","count");
   nz("vigm","change") = card(vigm) - nz("vigm","count");
   nz("viim","change") = card(viim) - nz("viim","count");

$endif
