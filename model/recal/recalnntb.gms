$OnText

$batinclude "revalnnnt.gms" xpx nd1  pxp pnd1 and1 sigmap a tfp
                             1   2    3    4   5      6   7 8

Arguments
   1     CES aggregate volume
   2     Component volume (w/o vintage)
   3     CES aggregate price
   4     Component price
   5     Component share parameter
   6     Elasticity of substitution
   7     Sectors
   8     TFP
$OffText

$setargs tvol vol tprice price shrParm elast index tfp
*          1   2     3     4      5      6     7    8

loop((r,%index%),

   tvol = sum(v, %tvol%.l(r,%index%,v,tsim-1)) ;

   IF(tvol ne 0,

      tprice = sum(v, %tprice%.l(r,%index%,v,tsim-1) * %tvol%.l(r,%index%,v,tsim-1)) / tvol ;

      vol = %vol%.l(r,%index%,tsim-1) ;

      IF(vol ne 0,

         price = %price%.l(r,%index%,tsim-1) ;

         %shrParm%(r,%index%,vOld,tsim)
            = (vol/tvol)
            * ((%vol%0(r,%index%) / %tvol%0(r,%index%,tsim-1))
            * (%price%0(r,%index%)*price / [%tprice%0(r,%index%)*tprice])**(%elast%(r,%index%,vOld)))
            * (%tfp%.l(r,%index%,vOld,tsim-1))**(1-%elast%(r,%index%,vOld))
            ;
      ) ;
   ) ;
) ;
