* ------------------------------------------------------------------------------
*
*  At a minimum, the user needs to assign the following:
*
*     utility     Utility specification: default is CDE, alternative is CD
*     rorFlag     Valid options are capFlex, capShrFix, capFix
*
* ------------------------------------------------------------------------------

* $setGlobal utility    CDE
$setGlobal utility  CD

acronym CDE, CD, capFlex, capshrFix, capFix ;

set rs(r) "Simulation regions" ;

alias(is,js) ; alias(r,rp) ; alias(i,j) ; alias(j,jp) ; alias(m,j) ;
alias(i0, m0) ; alias(i0, j0) ;

parameters
   gblScale          "Set a global scale for the model"
   gdpScale(r)       "Scale for regional GDP"
;

gblScale    = 1e-6 ;
gdpscale(r) = gblScale ;

*  Parameters from GTAP database

Parameters
   esubt(a0)         "Top level CES substitution elasticity"
   esubva(a0)        "VA nest CES substitution elasticity"
   esubd(i0)         "Top level Armington elasticity"
   esubm(i0)         "Second level Armington elasticity"
   etrae(fp)         "CET elasticity for factors"
   rorFlex0(r)       "Flexibility of foreign capital"
   incpar(i0,r)      "CDE expansion parameter"
   subpar(i0,r)      "CDE substitution parameter"
;

execute_loaddc "%iDataDir%\Agg\%Prefix%Par.gdx", esubt=esubt, esubva=esubva,
   esubd=esubd, esubm=esubm, etrae=etrae, rorFlex0=rorFlex,
   incpar=incpar, subpar=subpar ;

Parameters

*  Parameters normally sourced from GTAP

   sigmap(r,a)       "Top level CES production elasticity (ND/VA)"
   sigmand(r,a)      "CES elasticity across intermediate inputs"
   sigmav(r,a)       "CES elasticity across factors of production"
   sigmai(r)         "CES investment expenditure elasticity"
   sigmam(r,i,aa)    "Top level Armington elasticity"
   sigmaw(r,i)       "Second level Armington elasticity"
   omegaf(r,fp)      "CET mobility elasticity for mobile factors"
   rorFlex(r,t)      "Flexibility of foreign capital"
   eh0(r,i)          "CDE expansion parameter"
   bh0(r,i)          "CDE substitution parameter"

*  Parameters in addition to standard GTAP model

   sigmag(r)         "CES government expenditure elasticity"
   sigmamg(m)        "CES expenditure elasticity for margin services exports"

   omegax(r,i)       "Top level output CET elasticity"
   omegaw(r,i)       "Second level export CET elasticity"

   etaf(r,fm)        "Aggregate factor supply elasticity"
   etaff(r,fp,a)     "Sector specific supply elasticity for non-mobile factors"

   omegas(r,a)       "Commodity supply CET elasticity"
   sigmas(r,i)       "Commodity supply CES elasticity"

   mdtx0(r)          "Initial marginal tax rate"
   RoRFlag           "Capital account closure flag"
;

*  Overrides for GTAP-based parameters
*  If no overrides, parameters will be set in 'cal.gms'

sigmap(r,a)    = na ;
sigmand(r,a)   = na ;
sigmav(r,a)    = na ;
*  DvdM--13-Dec-2016
*  Since esubt now depends on 'a', which excludes 'cgds', set the elasticity to 0
*sigmai(r)      = esubt('cgds',r) ;
sigmai(r)      = 0 ;
sigmam(r,i,aa) = na ;
sigmaw(r,i)    = na ;
*  !!!! N.B. We are not following GTAP usage. Values are
*       entered directly by users in the aggregation
*       facility using the 'right' sign
omegaf(r,fm) =  etrae(fm) ;
rorFlex(r,t) = rorFlex0(r) ;
eh0(r,i)     = na ;
bh0(r,i)     = na ;

*  The other parameters default to GTAP implicit values (unless overridden)

sigmag(r)     = 1.01 ;
sigmamg(m)    = 1.01 ;

omegax(r,i)   = inf ;
omegaw(r,i)   = inf ;

etaf(r,fm)    = 0 ;
etaff(r,fp,a) = 0 ;

* Make matrix elasticities

omegas(r,a)   = 1.01 ;
sigmas(r,i)   = 1.01 ;

mdtx0(r)      = na ;

rorFlag       = capFix ;
