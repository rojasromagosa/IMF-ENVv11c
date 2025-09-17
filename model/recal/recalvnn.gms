$OnText

$batinclude "revalvnn.gms" xpx va   pxp pva  ava  sigmap a
                            1   2    3    4   5      6   7

Arguments
   1     CES aggregate volume
   2     Component volume (w/ovintage)
   3     CES aggregate price
   4     Component price
   5     Component share parameter
   6     Elasticity of substitution
   7     Sectors

$OffText

$setargs tvol vol tprice price shrParm elast index condit
*          1   2     3     4      5      6     7    8

loop((r,%index%),

   tvol = sum(v, %tvol%.l(r,%index%,v,tsim-1)) ;

   IF(tvol ne 0,

      tprice = sum(v, %tprice%.l(r,%index%,v,tsim-1) * %tvol%.l(r,%index%,v,tsim-1)) / tvol ;

      vol = sum(v, %vol%.l(r,%index%,v,tsim-1)) ;

      IF(vol ne 0,

         price = sum(v, %price%.l(r,%index%,v,tsim-1) * %vol%.l(r,%index%,v,tsim-1)) / vol ;

         %shrParm%(r,%index%,vOld,tsim)
            = (vol/tvol)
            * ((%vol%0(r,%index%,tsim-1)/%tvol%0(r,%index%,tsim-1))
            * (%price%0(r,%index%)/%tprice%0(r,%index%))**(%elast%(r,%index%,vOld)))
            * (price/tprice)**%elast%(r,%index%,vOld) ;
      ) ;
   ) ;
) ;
