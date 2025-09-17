IF(year gt FirstYear,
*    rgdppcT(r,tsim)          = rgdppcT(r,tsim-1)          ;
    rgdppcT(r,tsim) = rgdppcT(r,tsim-1) * 0.5 + rgdppcT(r,tsim) * 0.5 ;

*    popT(r,tranche,tsim)     = popT(r,tranche,tsim-1)     ;

    lambdafd.l(r,i,fdc,tsim) = lambdafd.l(r,i,fdc,tsim-1) ;
    lambdaio.l(r,i,a,tsim)   = lambdaio.l(r,i,a,tsim-1)   ;
    LFPR.l(r,l,z,tsim)       = LFPR.l(r,l,z,tsim-1)       ;

    tteff(r,i,rp,tsim)   = 0 ;
    g_nrf(r,a,v,tsim)    = 0 ;

*    gtLab.l(r,tsim)      = 0 ;
*    glabT(r,skl,tsim)    = 0 ;

    aeei(r,e,a,v,tsim)   = 0 ;
    aeeic(r,e,k,h,tsim)  = 0 ;
    yexo(r,a,v,tsim)     = 0 ;
    g_kt(r,a,v,tsim)     = 0 ;
    g_natr(r,a,tsim)     = 0 ;
    g_xpx(r,a,tsim)       = 0 ;
    g_xs(r,i,tsim)       = 0 ;
    g_fp(r,a,tsim)       = 0 ;

*    display rgdppcT, popT ;

) ;

IF(year eq FirstYear,
    EXECUTE_UNLOAD "ENVISAGE_Baseline.gdx",
        invTargetT, rgdppcT, popT, gtLab, LFPR, glabT ;
) ;
