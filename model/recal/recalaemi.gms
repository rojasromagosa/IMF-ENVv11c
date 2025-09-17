$OnText

$batinclude "recalaemi.gms" xghg  emi  pxghg m_EmiPrice aemi  sigmaemi em a lambdaemi
                             1     2    3       4      5       6     7  8   9

Arguments
   1 = tvol   : CES aggregate volume            --> xghg
   2 = vol    : Component volume (w/o vintage)  --> emi
   3 = tprice : CES aggregate price             --> pxghg
   4 = price  : Component price                 --> m_EmiPrice
   5 = shrParm: Component share parameter       --> aemi
   6 = elast  : Elasticity of substitution      --> sigmaemi
   7 = em     : Emission set                    --> em
   8 = a      : Activity set                    --> a
   9 = tfp    : Efficiency Paramter             --> lambdaemi
$OffText

$setargs tvol vol tprice price shrParm elast em index tfp
*          1   2     3     4      5      6   7  8     9

$onDotL

loop((r,%index%,%em%,emiact),

* xghg(r,a,v,t-1):

    tvol = sum(v, %tvol%.l(r,%index%,v,tsim-1)) ;

    IF(tvol ne 0,

* pxghg(r,a,v,t):

        tprice
            = sum(v, %tprice%.l(r,%index%,v,tsim-1) * %tvol%.l(r,%index%,v,tsim-1))
            / tvol ;

* emi(r,AllEmissions,emiact,a,t):

        vol = %vol%.l(r,%em%,emiact,%index%,tsim-1) ;

        IF(vol,

* m_EmiPrice(r,em,emiact,a,t):

            price = %price%(r,%em%,emiact,%index%,tsim-1) ;

* aemi(r,AllEmissions,a,v,t):

            %shrParm%(r,%em%,%index%,vOld,tsim) $ %vol%0(r,%em%,emiact,%index%)
                = (vol / tvol)
                * [(%vol%0(r,%em%,emiact,%index%) / %tvol%0(r,%index%))
                    * (1 / %tprice%0(r,%index%,tsim-1))**(%elast%(r,%index%,vOld))]
                * [(price / tprice)**%elast%(r,%index%,vOld)]
                * [ %tfp%(r,%em%,%index%,vOld,tsim-1)**(1 - %elast%(r,%index%,vOld))]
                ;
        ) ;
    ) ;

) ;
$OffDotL

