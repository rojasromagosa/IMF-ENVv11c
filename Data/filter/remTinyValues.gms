*-------------------------------------------------------------------------------
$OnText

   CAPRI project

   GAMS file : REMTINYVALUES.GMS

   @purpose  : Remove values from transaction matrixes below absolute
               Threshold
   @author   : Dominique VDM
   @date     : 15.06.15
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : Data\filter\filter.gms

$OffText
*-------------------------------------------------------------------------------

$macro chkTol2(var,d1,d2)        var(d1,d2)$(abs(var(d1,d2)) lt absTol) = 0
$macro chkTol3(var,d1,d2,d3)     var(d1,d2,d3)$(abs(var(d1,d2,d3)) lt absTol) = 0
$macro chkTol4(var,d1,d2,d3,d4)  var(d1,d2,d3,d4)$(abs(var(d1,d2,d3,d4)) lt absTol) = 0

* The original had fp0, i0, r0 (but these have been aliased)

if (absTol ne 1.E-10,

   chktol3(evfa, fp, j, r) ;
   chktol3(vfm, fp, j, r) ;
   chktol2(evoa, fp, r) ;
   chktol3(ftrv, fp, j, r) ;
   chktol3(fbep, fp, j, r) ;
   chktol2(osep, j, r) ;
   chktol3(vdfa, i, j, r) ;
   chktol3(vdfm, i, j, r) ;
   chktol3(vifm, i, j, r) ;
   chktol3(vifa, i, j, r) ;
   chktol2(vdpa, i, r) ;
   chktol2(vdpm, i, r) ;
   chktol2(vipa, i, r) ;
   chktol2(vipm, i, r) ;
   chktol2(vdga, i, r) ;
   chktol2(vdgm, i, r) ;
   chktol2(viga, i, r) ;
   chktol2(vigm, i, r) ;
   chktol2(vdia, i, r) ;
   chktol2(vdim, i, r) ;
   chktol2(viia, i, r) ;
   chktol2(viim, i, r) ;
   chktol3(vxmd, i, r, d) ;
   chktol3(vxwd, i, r, d) ;
   chktol3(viws, i, r, d) ;
   chktol3(vims, i, r, d) ;
   chktol4(VTWR, i, j, r, d) ;

*  ???? Does not include vdim

);
