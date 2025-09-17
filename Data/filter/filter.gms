*-----------------------------------------------------------------------------------------
$OnText

   Envisage 10 project -- Data preparation modules

   GAMS file : Filter.gms

   @purpose  : Filter out small values from SAMS and trade matrices and
               rebalance database

   @author   : Tom Rutherford, with modifications by Wolfgang Britz
               and adjustments for Env10 by Dominique van der Mensbrugghe
   @date     : 21.10.16
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : Data\filter.gms
   @Options  :

$OffText
*-----------------------------------------------------------------------------------------

*  At this point, we should have read in the aggregated database, so initialize filtering

*  Save the SAM if requested

file csv / %DirCheck%\%Prefix%flt_SAM.csv / ;

*  !!!! check/implement

* %system.nlp% = Conopt

* [EditJean]: change to conopt4
OPTION NLP = CONOPT4;

option LP=%system.nlp% ;


Parameters

*  Auxiliary matrices

***HRR: these are redifined in ..data/filter.gms as using a-dim not i-dim
   ftrv(fp, i, r)    "Taxes on factor use"
   fbep(fp, i, r)    "Subsidies on factor use"
***endHRR
   osep(a,r)         "Output tax"
   vdm(i,r)          "Aggregate demand for domestic output",
   vom(i,r)          "Total supply at market prices",
   voa(i,r)          "Output at producer prices"
   vim(i,r)          "Aggregate imports"
   vdim(i,r)         "Investment demand for domestic goods at market prices"
   viim(i,r)         "Investment demand for imported goods at market prices"
   vdia(i,r)         "Investment demand for domestic goods at agents' prices"
   viia0(i,r)        "Investment demand for imported goods at agents' prices"
   vdia0(i,r)        "Investment demand for domestic goods at agents' prices"
   viia(i,r)         "Investment demand for imported goods at agents' prices"
   tvpm(r)           "Aggregate private demand"
   tvpmi(r)          "Aggregate private demand for imports"
   tvgm(r)           "Aggregate gov demand"
   tvgmi(r)          "Aggregate gov demand for imports"
   tvim(r)           "Aggregate inv demand"
   tvimi(r)          "Aggregate inv demand for imports"
   vxt(i)            "Total world trade scaling factor"

   rto(i,r)          "Output (or income) subsidy rates"
   rtf(fp,i,r)       "Primary factor and commodity rates taxes"
   rtpd(i,r)         "Private domestic consumption taxes"
   rtpi(i,r)         "Private import consumption tax rates"
   rtgd(i,r)         "Government domestic rates"
   rtgi(i,r)         "Government import tax rates"
   rtid(i,r)         "Investment domestic rates"
   rtii(i,r)         "Investment import tax rates"
   rtfd(i,j,r)       "Firms domestic tax rates"
   rtfi(i,j,r)       "Firms import tax rates"
   rtxs(i,r,s)       "Export subsidy rates"
   rtms(i,r,s)       "Import taxes rates"
   rtva(fp,r)        "Direct tax rate on factor income"
;

*  Initialize the auxiliary matrices

vdim(i,r)    = vdfm(i,"cgds",r) ;
viim(i,r)    = vifm(i,"cgds",r) ;
vdia(i,r)    = vdfa(i,"cgds",r) ;
viia(i,r)    = vifa(i,"cgds",r) ;
vdia0(i,r)   = vdia(i,r) ;
viia0(i,r)   = viia(i,r) ;

vdm(i,r)     = sum(j, vdfm(i,j,r)) + vdpm(i,r) + vdgm(i,r) + vdim(i,r) ;
vom(i,r)     = vdm(i,r) + sum(s, vxmd(i,r,s)) + vst(i,r) ;
voa(j,r)     = sum(fp, evfa(fp,j,r)) + sum(i, vdfa(i,j,r) + vifa(i,j,r)) ;
vim(i,r)     = sum(j, vifm(i,j,r)) + vipm(i,r) + vigm(i,r) + viim(i,r) ;
*  21-Oct-2016 DvdM  Change from original code -- initialize vdim with investment expenditures
osep(j,r)    = voa(j,r) - vom(j,r) ;

***HRR: took out as, both variables are not defined over j(aliased with i)
ftrv(fp,j,r) = evfa(fp,j,r) - vfm(fp,j,r) ;
fbep(fp,j,r) = 0 ;
***endHRR

*   Check the SAM before filtering procedure (%ifCSV% == "1")

$batinclude "%DataDir%\aggsam.gms" "BEFORE"

put msglog ;

*
* --- calculate tax rates in starting point
*

rto(i,r)    $ vom(i,r)    = 1 - voa(i,r)/vom(i,r) ;
rtf(fp,i,r) $ vfm(fp,i,r) = evfa(fp,i,r)/vfm(fp,i,r) - 1 ;
rtpd(i,r)   $ vdpm(i,r)   = vdpa(i,r)/vdpm(i,r) - 1;
rtpi(i,r)   $ vipm(i,r)   = vipa(i,r)/vipm(i,r) - 1;
rtgd(i,r)   $ vdgm(i,r)   = vdga(i,r)/vdgm(i,r) - 1;
rtgi(i,r)   $ vigm(i,r)   = viga(i,r)/vigm(i,r) - 1;
rtid(i,r)   $ vdim(i,r)   = vdia(i,r)/vdim(i,r) - 1;
rtii(i,r)   $ viim(i,r)   = viia(i,r)/viim(i,r) - 1;
rtfd(i,j,r) $ vdfm(i,j,r) = vdfa(i,j,r)/vdfm(i,j,r) - 1;
rtfi(i,j,r) $ vifm(i,j,r) = vifa(i,j,r)/vifm(i,j,r) - 1;
rtxs(i,r,s) $ vxwd(i,r,s) = 1-vxwd(i,r,s)/vxmd(i,r,s);
rtms(i,r,s) $ viws(i,r,s) = vims(i,r,s)/viws(i,r,s) - 1;

*  14-May-2016: DvM

rtva(fp,r)$(sum(a, vfm(fp,a,r))) = (sum(a, vfm(fp,a,r)) - vdep(r)$cap(fp) - evoa(fp,r))
                                 / (sum(a, vfm(fp,a,r)) - vdep(r)$cap(fp)) ;

tvpm(r)  = sum(i, vdpm(i,r)*(1+rtpd(i,r))  + vipm(i,r)*(1+rtpi(i,r)));
tvpmi(r) = sum(i, vipm(i,r)*(1+rtpi(i,r))) + eps ;

tvgm(r)  = sum(i, vdgm(i,r)*(1+rtgd(i,r))  + vigm(i,r)*(1+rtgi(i,r)));
tvgmi(r) = sum(i, vigm(i,r)*(1+rtgi(i,r))) + eps ;

tvim(r)  = sum(i, vdim(i,r)*(1+rtid(i,r))  + viim(i,r)*(1+rtii(i,r)));
tvimi(r) = sum(i, viim(i,r)*(1+rtii(i,r))) + eps ;

vxt(i)  = sum((r,s), vxmd(i,r,s)) ;

$offListing

*  Declare mirror matrices

parameters
   vfm0(fp, j, r)    "Primary factor purchases, by firms, at market prices"
   vdfm0(i, j, r)    "Domestic purchases, by firms, at market prices"
   vifm0(i, j, r)    "Import purchases, by firms, at market prices"
   vdpm0(i, r)       "Domestic purchases, by households, at market prices"
   vipm0(i, r)       "Import purchases, by households, at market prices"
   vdgm0(i, r)       "Domestic purchases, by government, at market prices"
   vigm0(i, r)       "Import purchases, by government, at market prices"
   vdim0(i, r)       "Domestic purchases, by investment, at market prices"
   viim0(i, r)       "Import purchases, by investment, at market prices"
   vst0(i, r)        "Margin exports"
   vxmd0(i, r, d)    "Non-margin exports, at market prices"
   vxwd0(i, r, d)    "Non-margin exports at border (FOB) prices"

   vdm0(i,r)         "Aggregate demand for domestic output"
   vom0(i,r)         "Aggregate output at market prices"
   vim0(i,r)         "Aggregate imports"
   vdim0(i,r)        "Aggregate investment demand"
   vxm0(i,r)         "Total exports"
   vxt0(i)           "Total world trade scaling factor"
   vfmTot0(fp,r)     "Aggregate factor remuneration"
   rtms0(r)          "Aggregate tariff revenue"
   Total
;

vim0(i,r) = sum(j, vifm(i,j,r)) + vipm(i,r) + vigm(i,r) + viim(i,r) ;
vxm0(i,r) = sum(s, vxmd(i,r,s)) + vst(i,r) ;
vxt0(i)   = sum((r,s), vxmd(i,r,s));
vom0(i,r) = vom(i,r) ;

*
* --- calculate tax income in starting point
*

rtms0(r) = sum((i,s), vims(i,s,r) - viws(i,s,r)) ;

vst0(i,r)      = vst(i,r);
vdm0(i,r)      = vdm(i,r);
vdpm0(i,r)     = vdpm(i,r);
vipm0(i,r)     = vipm(i,r);
vdgm0(i,r)     = vdgm(i,r);
vigm0(i,r)     = vigm(i,r);
vdim0(i,r)     = vdim(i,r);
viim0(i,r)     = viim(i,r);
vfm0(fp,i,r)   = vfm(fp,i,r);
vfmTot0(fp,r)  = sum(i,vfm(fp,i,r));
vifm0(i,j,r)   = vifm(i,j,r);
vdfm0(i,j,r)   = vdfm(i,j,r);
vxmd0(i,r,s)   = vxmd(i,r,s);
vxwd0(i,r,s)   = vxwd(i,r,s);

parameter
   dirTax(r)   "Tax revenues"
   bop0(r)     "Balance of payments"
   factY(r)    "Factor remuneration net of taxes"
   gdp(r)      "GDP"
   gdpTot      "World GDP"
;

dirTax(r) =

*  Government expenditures

    sum(i, vdgm(i,r)*(1+rtgd(i,r)) + vigm(i,r) * (1+rtgi(i,r)))

*  Government revenues

   - sum(i, sum(fp, ftrv(fp,i,r) - fbep(fp,i,r)) - osep(i,r)
   +         vdpm(i,r) * rtpd(i,r) + vipm(i,r) * rtpi(i,r)
   +         vdgm(i,r) * rtgd(i,r) + vigm(i,r) * rtgi(i,r)
   +         vdim(i,r) * rtid(i,r) + viim(i,r) * rtii(i,r)
   +  sum(j, vdfm(i,j,r) * rtfd(i,j,r) + vifm(i,j,r) * rtfi(i,j,r))
   +  sum((s)$vxmd0(i,s,r), vims(i,s,r) - viws(i,s,r))
   +  sum((s), vxwd(i,r,s) - vxmd(i,r,s)) )
   -  sum((fp,i), vfm(fp,i,r)) + sum(fp, evoa(fp,r)) ;

* !!!! What about VST ????
bop0(r)  = -sum((i,s), vxwd(i,r,s)) + sum((i,s), viws(i,s,r)) ;
factY(r) = sum((fp,a), vfm(fp,a,r)) ;

*
* --- total gdp
*

* !!!! NO NET TRADE ????

gdp(r) = sum(i,  vdpm(i,r) + vipm(i,r) + vdgm(i,r) + vigm(i,r)
               + vdim(i,r) + viim(i,r) ) ;
gdpTot = sum(r, gdp(r)) ;

parameter
   vxm(a,r)    "Export volume"
   nz          "Count of non-zeros"
   trace       "Submatrix totals"
   ndropped    "Number of nonzeros dropped"
;

ndropped("prod")    = 0 ;
ndropped("imports") = 0 ;

set
   dropexports(i,r)  "Logical flag for set vxm(td,r)  to zero"
   dropimports(i,r)  "Logical flag for set vim(td,r)  to zero"
   dropprod(i,r)     "Logical flag for set vom(td,r)  to zero"
   droptrade(i,r,s)  "Logical flag for set vxmd(td,r) to zero"
   rb(r)             "Region to be balanced"
;

dropexports(i,r) = no ;
dropimports(i,r) = no ;
dropprod(i,r)    = no ;
droptrade(i,r,s) = no ;

alias (r,rrr);

set keepItem / factyBop, vfm, set.fp, GDP, yg, yp, yi, int / ;

variables
   obj                  "Objective function"
   vz                   "Value of desired zero values"
   keepCor(keepItem,r)  "Difference between factor income plus BOP before and after"
;

positive variables
   vdm_(i,r)      "Calibrated value of vdm"
   vdfm_(i,j,r)   "Calibrated value of vdfm"
   vifm_(i,j,r)   "Calibrated value of vifm"
   vdpm_(i,r)     "Calibrated value of vdpm"
   vipm_(i,r)     "Calibrated value of vipm"
   vdgm_(i,r)     "Calibrated value of vdgm"
   vigm_(i,r)     "Calibrated value of vigm"
   vdim_(i,r)     "Calibrated value of vdim"
   viim_(i,r)     "Calibrated value of viim"
   vfm_(fp,a,r)   "Calibrated value of vfm"
;

scalar
   lsqr     / 1 /
   entropy  / 0 /
   bigM     / 1000 /
   penalty  / 1000 /
   tiny     / 1e-8 /
;

equations
   objbaleq
   vzdefeq
   profiteq
   vaeq
   ndeq
   dommkteq
   impmkteq
   vfmkeepeq
   vfmTotKeepeq
   factinceq
   gdpKeepeq
   ypeq
   ygeq
   yieq
   intKeepeq
;

objbaleq..
   obj =e= sum((r,i)$rb(r), (1/gdp(r))
        * ((sqr(vdpm_(i,r)-vdpm0(i,r))/(vdpm0(i,r)+tiny))$(vdpm(i,r) ne 0)
        +  (sqr(vipm_(i,r)-vipm0(i,r))/(vipm0(i,r)+tiny))$(vipm(i,r) ne 0)
        +  (sqr(vdgm_(i,r)-vdgm0(i,r))/(vdgm0(i,r)+tiny))$(vdgm(i,r) ne 0)
        +  (sqr(vigm_(i,r)-vigm0(i,r))/(vigm0(i,r)+tiny))$(vigm(i,r) ne 0)
        +  (sqr(vdim_(i,r)-vdim0(i,r))/(vdim0(i,r)+tiny))$(vdim(i,r) ne 0)
        +  (sqr(viim_(i,r)-viim0(i,r))/(viim0(i,r)+tiny))$(viim(i,r) ne 0)
        +   sum(fp$(vfm(fp,i,r) ne 0), sqr(vfm_(fp,i,r)-vfm0(fp,i,r))/(vfm0(fp,i,r)+tiny))
        +   sum(j$(vifm(i,j,r) ne 0), sqr(vifm_(i,j,r)-vifm0(i,j,r))/(vifm0(i,j,r)+tiny))
        +   sum(j$(vdfm(i,j,r) ne 0), sqr(vdfm_(i,j,r)-vdfm0(i,j,r))/(vdfm0(i,j,r)+tiny))))
        + penalty * vz
        + sum((rb,keepItem), sqr(KeepCor(keepItem,rb)/(10 - 9 $ sameas(keepItem,"GDP"))))
        ;

*  Use linear penalty term to impose sparsity:
*     (sum of items which are desired to be zero)

vzdefeq..
   vz =e= sum((r,i)$rb(r), 1/gdp(r)
       *  [vdpm_(i,r)$((vdpm(i,r) eq 0)$vdpm0(i,r))
       +   vipm_(i,r)$((vipm(i,r) eq 0)$vipm0(i,r))
       +   vdgm_(i,r)$((vdgm(i,r) eq 0)$vdgm0(i,r))
       +   vigm_(i,r)$((vigm(i,r) eq 0)$vigm0(i,r))
       +   vdim_(i,r)$((vdim(i,r) eq 0)$vdim0(i,r))
       +   viim_(i,r)$((viim(i,r) eq 0)$viim0(i,r))
       +  sum(fp$vfm0(fp,i,r), vfm_(fp,i,r)$(vfm(fp,i,r) eq 0))
       +  sum(j, vifm_(i,j,r)$((vifm(i,j,r) eq 0)$vifm0(i,j,r))
       +         vdfm_(i,j,r)$((vdfm(i,j,r) eq 0)$vdfm0(i,j,r)))
          ]) ;

*
*  --- revenue exhaustion (output value = value of inputs)
*
profitEQ(j,r)$(rb(r) and (vom(j,r) ne 0))..
   (vdm_(j,r) + vxm(j,r)) * (1-rto(j,r))
      =e= sum(i, vifm_(i,j,r)*(1+rtfi(i,j,r))$vifm0(i,j,r)
       +         vdfm_(i,j,r)*(1+rtfd(i,j,r))$vdfm0(i,j,r))
       +  sum(fp, vfm_(fp,j,r)*(1+rtf(fp,j,r))$vfm0(fp,j,r)) ;

*
*  --- "BigM" equations for factor use and intermediate input use
*      (i.e. if production -> va,nd )
*
vaEQ(j,fp,r)$(rb(r) and (vfm0(fp,j,r)*bigM*100) > vom(j,r) and (vom(j,r) ne 0)  and bigM)..
   (vdm_(j,r) + vxm(j,r)) * (1-rto(j,r)) =L= vfm_(fp,j,r)*(1+rtf(fp,j,r)) * bigM ;

ndEQ(j,r)$(rb(r) and (sum(i, vifm0(i,j,r) + vdfm0(i,j,r))*bigm*100 > vom(j,r)) and (vom(j,r) ne 0) and bigM)..
   (vdm_(j,r) + vxm(j,r)) * (1-rto(j,r))
      =L=  sum(i,vifm_(i,j,r)*(1+rtfi(i,j,r))$vifm0(i,j,r)
       +         vdfm_(i,j,r)*(1+rtfd(i,j,r))$vdfm0(i,j,r)) * bigM ;
*
* --- domestic market
*

*  ???? DvdM I think there are errors here and double counting...

dommktEQ(i,r)$(rb(r) and (vdm(i,r) ne 0))..
   vdm_(i,r) =e= vdpm_(i,r)$vdpm0(i,r)
              +  vdgm_(i,r)$vdgm0(i,r)
              +  vdim_(i,r)$vdim0(i,r)
              +  sum(j$vdfm0(i,j,r), vdfm_(i,j,r)) ;
*
* --- import market
*
impmktEQ(i,r)$(rb(r) and (vim(i,r) ne 0))..
   vim(i,r) =e= vipm_(i,r)$vipm0(i,r)
             +  vigm_(i,r)$vigm0(i,r)
             +  viim_(i,r)$viim0(i,r)
             +  sum(j$vifm0(i,j,r), vifm_(i,j,r)) ;
*
* --- try to maintain benchmark intermediate consumption
*
intKeepEQ(r)$(rb(r) and ifKeepIntermediateConsumption)..
   sum((i,j)$vom(j,r), vifm_(i,j,r)$vifm0(i,j,r) + vdfm_(i,j,r)$vdfm0(i,j,r))
      =E= sum((i,j), vifm0(i,j,r) + vdfm0(i,j,r)) * (1 + keepCor("int",r)/100) ;

*
* --- try to maintain at least benchmark gpd
*
gdpKeepEQ(r)$(rb(r) and ifGDPKeep)..
   gdp(r)*(1 + keepCor("gdp",r)/100)
      =E= sum(i, vdpm_(i,r) $ vdpm0(i,r)
       +         vdgm_(i,r) $ vdgm0(i,r)
       +         vdim_(i,r) $ vdim0(i,r)
       +         vipm_(i,r) $ vipm0(i,r)
       +         vigm_(i,r) $ vigm0(i,r)
       +         viim_(i,r) $ viim0(i,r)
         ) ;
*
* --- try to maintain  benchmark factor income plus BOP
*
factincEQ(r)$(rb(r) and ifKeepFactorincomeplusbop)..
   (facty(r) + bop0(r) - sum(i,vst0(i,r))) * (1 +  keepCor("factyBop",r)/100)
      =E= sum((fp,i)$vfm0(fp,i,r), vfm_(fp,i,r))
       -  sum((i,s)$vxmd0(i,r,s), vxmd(i,r,s)*(1-rtxs(i,r,s)))
       +  sum((i,s)$vxmd0(i,s,r), viws(i,s,r) * vxmd(i,s,r)/vxmd0(i,s,r))
       -  sum(i, vst(i,r)) ;
*
* --- try to maintain  benchmark factor income plus BOP
*
vfmKeepEQ(fp,r)$(rb(r) and ifKeepFactorincomeplusbop)..
   sum(j, vfm0(fp,j,r)*(1+rtf(fp,j,r))) * (1 + sum(sameas(keepItem,fp), keepCor(keepItem,r)/100))
      =E= sum(j$vfm0(fp,j,r), vfm_(fp,j,r) * (1+rtf(fp,j,r))) ;

vfmTotKeepEQ(r)$(rb(r) and ifKeepFactorincomeplusbop)..
   sum((fp,j), vfm0(fp,j,r)*(1+rtf(fp,j,r))) * (1 + keepCor("vfm",r)/100)
      =E= sum((fp,j)$vfm0(fp,j,r), vfm_(fp,j,r) * (1+rtf(fp,j,r))) ;

*
* --- try to maintain benchmark private consumption total
*
*  !!!! WHY SUM OVER FP ????

ypEQ(r)$(rb(r) and ifKeepPrivateconsumption)..
   sum(i, vdpm_(i,r)*(1+rtpd(i,r))$vdpm0(i,r) + vipm_(i,r)*(1+rtpi(i,r))$vipm0(i,r))
      =E= sum(i, vdpm0(i,r)*(1+rtpd(i,r)) + vipm0(i,r)*(1+rtpi(i,r))) * (1 + keepCor("yp",r)/100) ;
*
* --- try to maintain benchmark gov consumption total
*
*  !!!! WHY SUM OVER FP ????
ygEQ(r)$(rb(r) and ifKeepGovernmentconsumption) ..
   sum(i, vdgm_(i,r)*(1+rtgd(i,r))$vdgm0(i,r) + vigm_(i,r)*(1+rtgi(i,r))$vigm0(i,r))
      =E= sum(i, vdgm0(i,r)*(1+rtgd(i,r)) + vigm0(i,r)*(1+rtgi(i,r))) * (1 + keepCor("yg",r)/100) ;

*
* --- try to maintain benchmark investments -- due it at agents' price as in the others????
*
yiEQ(r)$(rb(r)and ifKeepInvestments)..
   sum(i, vdim_(i,r)*(1+rtid(i,r))$vdim0(i,r) + viim_(i,r)*(1+rtii(i,r))$viim0(i,r))
      =E= sum(i, vdim0(i,r)*(1+rtid(i,r)) + viim0(i,r)*(1+rtii(i,r))) * (1 + keepCor("yi",r)/100) ;

*
* --- linear version, only sparsity in objective
*

model lpfeas / impmkteq, dommkteq, profiteq, vaeq, ndeq, vzdefeq,
               gdpKeepeq, factInceq, vfmKeepeq, vfmTotKeepeq, ypeq, ygeq, yieq, intKeepeq / ;

*
* --- full calibration model
*

model calib / lpfeas + objbaleq / ;

calib.holdfixed = yes ;
calib.solvelink = 5 ;
calib.optfile   = 1 ;
calib.domlim    = 1000 ;
calib.reslim    = 120 ;

lpfeas.holdfixed = 2 ;
lpfeas.solvelink = 5 ;
lpfeas.optfile   = 1 ;
lpfeas.domlim    = 1000 ;
lpfeas.reslim    = 120 ;

$eval maxiter nsteps + 10

set
   dummy
      / start , absFilt /
   itr      "Calibration steps"
      / itr1*itr%maxiter% /
   dsitem   "Data set items to be balanced"
      / vom, vfm, vxmd, vtwr, vdfm, vifm, vdpm, vipm, vdgm, vigm, vdim, viim, gdp, total/
;

parameter
   itrlog            "Iteration log"
   nzcountStart      "Non-zero count"        / 0 /
   nzcountEnd        "Non-zero count"        / 0 /
   nzcountRep        "Non-zero count"        / 0 /
   solvefeas         "Solve the feasibility" / 0 /
   bilatTradeScale
;

*
* --- remove tiny values before further rebalancing work
*
$batinclude '%DataDir%\filter\itrlog.gms' before
$batinclude '%DataDir%\filter\itrlog.gms' count

itrlog("nonzeros","start",dsitem) = nz(dsitem,"count");
itrlog("nonzeros","start",r)      = nz(r,"count");
itrlog("nonzeros","start",i)      = nz(i,"count");

$include '%DataDir%\filter\remTinyValues.gms'

$batinclude '%DataDir%\filter\itrlog.gms' after

itrlog("nonzeros","absFilt",dsitem) = nz(dsitem,"count");
itrlog("change","absFilt",dsitem)   = nz(dsitem,"change");
itrlog("trace","absFilt",dsitem)    = sum(r,trace(dsitem,r,"before"));
itrlog("trace","start",dsitem)      = sum(r,trace(dsitem,r,"before"));
itrlog(r,"absFilt",dsitem)          = trace(dsitem,r,"before");
itrlog(r,"start",dsitem)            = trace(dsitem,r,"before");

*
* --- start with 10% of the desired final tolerance,
*     will be stepwise increased
*
parameters
   curRelTol(a,r)
   curAbsTol
   startRelTol(i,r)
;
curRelTol(i,r) = relTol;
curAbsTol = absTol / nSteps ;

$onempty

$if not setglobal excRegs $setglobal excRegs
set excRegs(r) / %excRegs%/;
$if not setglobal excSecs $setglobal excSecs
set excSecs(i) / %excSecs%/;

$offempty

*  !!!! NEED TO DISCUSS HOW THESE FLAGS ARE USED AND WHAT ARE REASONABLE TOLERANCE LEVELS

$iftheni.excCombined "%excCombined%"=="on"

   curRelTol(excSecs,excRegs) = relTolRed ;

$else.excCombined

   curRelTol(excSecs,r) = relTolRed ;
   curRelTol(a,excRegs) = relTolRed ;

$endif.excCombined

startRelTol(i,r) = curRelTol(i,r) ;
curRelTol(i,r)   = curRelTol(i,r) / nSteps ;

*
* --- ensure some minimum for the totals to be kept
*
keepCor.lo(keepItem,r)    = -50;
keepCor.lo(keepItem,r) $ sum(sameas(keepItem,fp),1)  = -100;
keepCor.lo(KeepItem,r) $ sum(sameas(keepItem,cap),1) = -50;
*
* --- small corridor around factor income. GDP works not well as
*     some countries such a XNA have an enormous trade deficit
*     which might be strongly affected by filtering out small trade flows
*
keepCor.lo("vfm",r)    = -2;
keepCor.up("vfm",r)    = +2;
option kill=vdm_;

Parameter
   rcount   "Keep count of treated regions"
;

loop(itr$(
*
*  --- continue with iteration as long as:
*
*  if there is a change in total non-zero transaction > 0.1%
      ((abs(nzcountStart-nzCountEnd)>0.001*nzcountStart)
*  or not yet the final tolerance reached
         or(smax((i,r), curRelTol(i,r)) < relTol))
*
*      --- and the desired minium number of transaction is not undercut
*
         and ((nzCountEnd > minNumTransactions) or (not nzCountEnd)) ),

*
*  count non zeros
*
   nzcountStart = card(vxmd) + card(vtwr) + card(vifm) + card(vdfm)
                + card(vdpm) + card(vdgm) + card(vdim) + card(vipm) + card(vigm) + card(viim) + card(vfm) ;

*  Aggregate value of imports:

   vim(i,r) = sum(s,(vxmd(i,s,r)*(1-rtxs(i,s,r))+sum(j,vtwr(j,i,s,r)))*(1+rtms(i,s,r))) ;

*  Rescale transport demand:

   vst(i,r) $ sum(s, vst(i,s)) = vst(i,r) * sum((j,s,rrr), vtwr(i,j,s,rrr)) / sum(s, vst(i,s)) ;

*  Value of exports:

   vxm(i,r) =  sum(s, vxmd(i,r,s)) + vst(i,r) ;

*  Production for the domestic market:

*  !!!! IS THERE DOUBLE COUNTING AS VDFM STILL HAS INVESTMENT????

   vdm(i,r) = vdpm(i,r) + vdgm(i,r) + sum(j, vdfm(i,j,r)) + vdim(i,r) ;

*  Aggregate production:

   vom(i,r) = vdm(i,r) + vxm(i,r) ;

*  Record nonzero counts:

   $$batinclude '%DataDir%\filter\itrlog.gms' count

*
*  --- delete very small trade margins / trade flows
*      (absolute tolerance)
*
   IF(abstol ne 1.E-10,
      vtwr(j,i,r,s) $ (vtwr(j,i,r,s) le curAbsTol) = 0;
      vxmd(i,r,s)   $ (vxmd(i,r,s)   le curAbsTol) = 0;

      vtwr(j,i,r,s) $ (not vxmd(i,r,s)) = 0;
      rtxs(i,r,s)   $ (not vxmd(i,r,s)) = 0;
      rtms(i,r,s)   $ (not vxmd(i,r,s)) = 0;
   ) ;

*  Filter small values here, commodity specific demand on total

*
*  --- aggregate total import and domestic demand per product
*
   vim(i,r) = sum(j,vifm(i,j,r)) + vipm(i,r) + vigm(i,r) + viim(i,r) ;
   vdm(i,r) = sum(j,vdfm(i,j,r)) + vdpm(i,r) + vdgm(i,r) + vdim(i,r) ;
*
   IF(relTol > 1.E-10,
*
*     --- delete intermediate demands if cost share (approx) is
*         below tolerance times total output values
*
      vifm(i,j,r) $ ((vifm(i,j,r) < min(curRelTol(i,r),curRelTol(i,r))/100 * (vom(j,r)-sum(fp,vfm(fp,j,r)))) $ vifm(i,j,r)) = 0 ;
      vdfm(i,j,r) $ ((vdfm(i,j,r) < min(curRelTol(i,r),curRelTol(i,r))/100 * (vom(j,r)-sum(fp,vfm(fp,j,r)))) $ vdfm(i,j,r)) = 0 ;
*
*     --- delete import and domestic private demand for products
*         if below tolerance times total private demand
*
      vipm(i,r)   $ ((vipm(i,r) < curRelTol(i,r)/100 * tvpm(r)  *  tvpmi(r)/tvpm(r)   ) $ vipm(i,r)) = 0;
      vdpm(i,r)   $ ((vdpm(i,r) < curRelTol(i,r)/100 * tvpm(r)  * (1-tvpmi(r)/tvpm(r))) $ vdpm(i,r)) = 0;
*
*     --- delete import and domestic gov demand for products
*         if below tolerance times total gov demand
*
      vigm(i,r)   $ ((vigm(i,r) < curRelTol(i,r)/100 * tvgm(r) *  tvgmi(r)/tvgm(r)   ) $ vigm(i,r))   = 0;
      vdgm(i,r)   $ ((vdgm(i,r) < curRelTol(i,r)/100 * tvgm(r) * (1-tvgmi(r)/tvgm(r))) $ vdgm(i,r))   = 0;
*
*     --- delete import and domestic inv demand for products
*         if below tolerance times total inv demand
*
      viim(i,r)   $ ((viim(i,r) < curRelTol(i,r)/100 * tvim(r) *  tvimi(r)/tvim(r)   ) $ viim(i,r))   = 0;
      vdim(i,r)   $ ((vdim(i,r) < curRelTol(i,r)/100 * tvim(r) * (1-tvimi(r)/tvim(r))) $ vdim(i,r))   = 0;
   );

*  Decide whether to drop trade and production:

*
*  --- aggregate total import and domestic demand per product
*
*  !!!! CHECK FOR VDIM AGAIN ????

   vim(i,r) = sum(j,vifm(i,j,r)) + vipm(i,r) + vigm(i,r) + viim(i,r) ;
   vdm(i,r) = sum(j,vdfm(i,j,r)) + vdpm(i,r) + vdgm(i,r) + vdim(i,r) ;

*
*  --- drop export of product if share on total exports and
*      max. import share on total import demand of product at destination is below threshold
*
   if (relTol > 1.E-10,
      dropexports(i,r)$(vxm(i,r) < curRelTol(i,r)/100*sum(j,vxm(j,r)) and
                (sum(s $
                   (  ( ((vxmd(i,r,s)*(1-rtxs(i,r,s))+sum(j,vtwr(j,i,r,s)))*(1+rtms(i,r,s)) /
                             vim(i,s)) < curRelTol(i,s)/100) $ vim(i,s)),1) eq sum(s $ vim(i,s),1)) and vxm(i,r)) = YES;
   ) ;

   vxmd(i,r,s)     $ dropexports(i,r) = 0 ;
   vtwr(j,i,r,s)   $ dropexports(i,r) = 0 ;
   rtxs(i,r,s)     $ dropexports(i,r) = 0 ;
   rtms(i,r,s)     $ dropexports(i,r) = 0 ;

*
*        --- drop import of product if share on total imports and
*            max. export share on output at destination is below threshold
*
   if (relTol > 1.E-10,
      dropimports(i,r)$((vim(i,r) < curRelTol(i,r)/100*sum(j,vim(j,r))) and
                   (sum(s$(( (vxmd(i,s,r)/vom(i,s)) < curRelTol(i,s)/100) $ vom(i,s)),1) eq sum(s $ vom(i,s),1)) and vim(i,r)) = yes;
   ) ;
*
*  --- drop imports if no import demand
*
   dropimports(i,r) $ (vipm(i,r)+vigm(i,r)+viim(i,r)+sum(j,vifm(i,j,r)) eq 0) = yes;
   dropimports(i,r) $ (not vdm_.range(i,r))= no;

   vim(i,r) $ dropimports(i,r) = 0;
*
*  --- drop production if share of output net of own intermediate consumption
*      is below threshold on total output net of own intermediate consumption
*      and share on total factor use is below threshold
*
   if (relTol > 1.E-10,
      dropprod(i,r) $ ((vom(i,r)-vdfm(i,i,r)<curRelTol(i,r)/100*sum(j,vom(j,r)-vdfm(j,j,r)))
                            $ vom(i,r))= yes;
   );
*
*  --- drop producion if no domestic and export demand
*
   dropprod(i,r) $ (vxm(i,r)+vdpm(i,r)+vdgm(i,r)+vdim(i,r)
                     + sum(j$(not sameas(i,j)),vdfm(i,j,r)) eq 0) = yes;

   while((ndropped("prod")    <> card(dropprod)) and
         (ndropped("imports") <> card(dropimports)),

      ndropped("prod")    = card(dropprod);
      ndropped("imports") = card(dropimports);

      vdm(i,r)        $ dropprod(i,r) = 0;
      vdpm(i,r)       $ dropprod(i,r) = 0;
      vdgm(i,r)       $ dropprod(i,r) = 0;
      vdim(i,r)       $ dropprod(i,r) = 0;
      vxmd(i,r,s)     $ dropprod(i,r) = 0;
      vtwr(j,i,r,s)   $ dropprod(i,r) = 0;
      rtxs(i,r,s)     $ dropprod(i,r) = 0;
      rtms(i,r,s)     $ dropprod(i,r) = 0;
      vst(i,r)        $ dropprod(i,r) = 0;
      vfm(fp,i,r)     $ dropprod(i,r) = 0;
      vdfm(j,i,r)     $ dropprod(i,r) = 0;
      vifm(j,i,r)     $ dropprod(i,r) = 0;
      vdfm(i,j,r)     $ dropprod(i,r) = 0;
*
*     --- drop total imports if no use of import good
*
      dropimports(i,r) $ (not dropimports(i,r))
                     = yes $ (vipm(i,r)+vigm(i,r)+viim(i,r)+sum(j,vifm(i,j,r)) eq 0);

      vxm(i,r) = sum(s, vxmd(i,r,s)) + vst(i,r);
      vxmd(i,s,r)      $ dropimports(i,r) = 0;
      vtwr(j,i,s,r)    $ dropimports(i,r) = 0;
      rtxs(i,s,r)      $ dropimports(i,r) = 0;
      rtms(i,s,r)      $ dropimports(i,r) = 0;
      vipm(i,r)        $ dropimports(i,r) = 0;
      vigm(i,r)        $ dropimports(i,r) = 0;
      viim(i,r)        $ dropimports(i,r) = 0;
      vifm(i,a,r)      $ dropimports(i,r) = 0;
*
*     --- drop production if no use of domestically produced good and no exports
*
      dropprod(i,r) $ (not dropprod(i,r))
               = yes $ (vxm(i,r)+vdgm(i,r)+vdpm(i,r)+vdim(i,r)
                        +sum(j $ (not sameas(j,i)),vdfm(i,j,r)) eq 0);
   );

   IF(calib.solprint eq 1, display ndropped ; ) ;

*
*  --- aggregate exports, domestic use and imports (including trade magrins)
*
*  !!!! WHAT ABOUT VDIM????

   vxm(i,r) = sum(s, vxmd(i,r,s)) + vst(i,r) ;
   vdm(i,r) = vdpm(i,r) + vdgm(i,r) + vdim(i,r) + sum(j,vdfm(i,j,r)) ;
   vim(i,r) = sum(s,(vxmd(i,s,r)*(1-rtxs(i,s,r))+sum(j,vtwr(j,i,s,r)))*(1+rtms(i,s,r))) ;
*
*  --- drop bilateral trade flow if value net of trade margins and taxes is below
*         thresholds both of exports and imports

   if (relTol > 1.E-10,
      droptrade(i,r,s) $ vxmd(i,r,s) = yes $ (vxmd(i,r,s)<min(curRelTol(i,s),curRelTol(i,r))/100 * min( vxm(i,r), vim(i,s)));
   ) ;

*
*  --- if dropped, also delete related trade margin and export/import taxes
*
   vxmd(i,r,s)     $ droptrade(i,r,s) = 0;
   vtwr(j,i,r,s)   $ droptrade(i,r,s) = 0;
   rtxs(i,r,s)     $ droptrade(i,r,s) = 0;
   rtms(i,r,s)     $ droptrade(i,r,s) = 0;
*
*  --- aggregate value of imports and exports after dropping trade
*
   vxm(i,r) = sum(s, vxmd(i,r,s)) + vst(i,r);
   vim(i,r) = sum(s,(vxmd(i,s,r)*(1-rtxs(i,s,r))+sum(j,vtwr(j,i,s,r)))*(1+rtms(i,s,r)));
*
*  --- rescale vxmd to match approx. old exports of exporter and imports of importer
*
   bilatTradeScale(r,s) = (sum(j,vxm0(j,r))/sum(j,vxm(j,r))
                        +  sum(j,vim0(j,s))/sum(j,vim(j,s)))/2;
   vxmd(i,r,s)   $ vxmd(i,r,s)   = vxmd(i,r,s)     * bilatTradeScale(r,s);
   vtwr(j,i,r,s) $ vtwr(j,i,r,s) = vtwr(j,i,r,s) * bilatTradeScale(r,s);
*
*  --- rescale global trade (up to 20%)
*
   vxt(i)        = sum((r,s), vxmd(i,r,s));
   vxt(i)$vxt(i) = min(1.2,vxt0(i)/vxt(i));
   vxmd(i,r,s) $ vxmd(i,r,s) = vxmd(i,r,s) * vxt(i);
*
*  --- apply same scalar to trade margins
*
   vtwr(j,i,r,s) $ vtwr(j,i,r,s) = vtwr(j,i,r,s) * vxt(i);
*
*  --- rescale import and tax revenuves
*
   total(r,"new") = sum((i,s), (vxmd(i,s,r)*(1-rtxs(i,s,r))+sum(j,vtwr(j,i,s,r)))*(rtms(i,s,r)));
   rtms(i,s,r) $ rtms(i,s,r) = rtms(i,s,r) * rtms0(r) / total(r,"new");

   vim(i,r) = sum(s,(vxmd(i,s,r)*(1-rtxs(i,s,r))+sum(j,vtwr(j,i,s,r)))*(1+rtms(i,s,r)));
   vim(i,r) $ (sum(s,vxmd(i,s,r)) eq 0) = 0;
   vipm(i,r)     $ (vim(i,r) eq 0) = 0;
   vigm(i,r)     $ (vim(i,r) eq 0) = 0;
   viim(i,r)     $ (vim(i,r) eq 0) = 0;
   vifm(i,j,r)   $ (vim(i,r) eq 0) = 0;

*  Rescale transport demand:

   vst(i,r) $ vst(i,r) = vst(i,r) * sum((j,s,rrr), vtwr(i,j,s,rrr)) / sum(s, vst(i,s));
   vxm(i,r) =  sum(s, vxmd(i,r,s)) + vst(i,r);

*  Aggregate production:

   vom(j,r) = vdm(j,r) + vxm(j,r);

*  Record current value of aggregate transactions
   $$batinclude '%DataDir%\filter\itrlog.gms' before

   vdm_.l(i,r)      = vdm(i,r);
   vfm_.l(fp,i,r)   = vfm(fp,i,r);
   vdfm_.l(i,j,r)   = vdfm(i,j,r);
   vifm_.l(i,j,r)   = vifm(i,j,r);
   vdpm_.l(i,r)     = vdpm(i,r);
   vdgm_.l(i,r)     = vdgm(i,r);
   vdim_.l(i,r)     = vdim(i,r);
   vipm_.l(i,r)     = vipm(i,r);
   vigm_.l(i,r)     = vigm(i,r);
   viim_.l(i,r)     = viim(i,r);

*  Set some bounds to avoid numerical problems (Arne keeps us on a short leash):

   vdm_.lo(i,r)      $ vdm_.range(i,r)      = 0;      vdm_.up(i,r)      $ vdm_.range(i,r)      = gdp(r);
   vfm_.lo(fp,i,r)   $ vfm_.range(fp,i,r)   = 0;      vfm_.up(fp,i,r)   $ vfm_.range(fp,i,r)   = gdp(r);
   vdfm_.lo(i,j,r)   $ vdfm_.range(i,j,r)   = 0;      vdfm_.up(i,j,r)   $ vdfm_.range(i,j,r)   = gdp(r);
   vifm_.lo(i,j,r)   $ vifm_.range(i,j,r)   = 0;      vifm_.up(i,j,r)   $ vifm_.range(i,j,r)   = gdp(r);
   vdpm_.lo(i,r)     $ vdpm_.range(i,r)     = 0;      vdpm_.up(i,r)     $ vdpm_.range(i,r)     = gdp(r);
   vdgm_.lo(i,r)     $ vdgm_.range(i,r)     = 0;      vdgm_.up(i,r)     $ vdgm_.range(i,r)     = gdp(r);
   vdim_.lo(i,r)     $ vdim_.range(i,r)     = 0;      vdim_.up(i,r)     $ vdim_.range(i,r)     = gdp(r);
   vipm_.lo(i,r)     $ vipm_.range(i,r)     = 0;      vipm_.up(i,r)     $ vipm_.range(i,r)     = gdp(r);
   vigm_.lo(i,r)     $ vigm_.range(i,r)     = 0;      vigm_.up(i,r)     $ vigm_.range(i,r)     = gdp(r);
   viim_.lo(i,r)     $ viim_.range(i,r)     = 0;      viim_.up(i,r)     $ viim_.range(i,r)     = gdp(r);

*  Fix to zero any flows associated with omitted markets:

   vdm_.fx(i,r)      $ (vdm(i,r)  eq 0) = 0;
   vdfm_.fx(i,j,r)   $ (vdm(i,r)  eq 0) = 0;
   vdpm_.fx(i,r)     $ (vdm(i,r)  eq 0) = 0;
   vdgm_.fx(i,r)     $ (vdm(i,r)  eq 0) = 0;
   vdim_.fx(i,r)     $ (vdm(i,r)  eq 0) = 0;

   vdm_.fx(i,r)      $ (vom(i,r)  eq 0) = 0;
   vfm_.fx(fp,i,r)   $ (vom(i,r)  eq 0) = 0;
   vdfm_.fx(i,j,r)   $ (vom(j,r)  eq 0) = 0;
   vifm_.fx(i,j,r)   $ (vom(j,r)  eq 0) = 0;
   vdfm_.fx(i,j,r)   $ (vom(i,r)  eq 0) = 0;

   vifm_.fx(i,j,r)   $ (vim(i,r)  eq 0) = 0;
   vipm_.fx(i,r)     $ (vim(i,r)  eq 0) = 0;
   vigm_.fx(i,r)     $ (vim(i,r)  eq 0) = 0;
   viim_.fx(i,r)     $ (vim(i,r)  eq 0) = 0;

   rcount = 0 ;
   loop(rrr,

      rb(rrr) = yes;
      rcount  = rcount + 1 ;

*     Update the title bar with the status prior to the solve:
      nzcountRep = card(vxmd) + card(vtwr) + card(vdfm) + card(vifm)
                 + card(vdpm) + card(vdgm) + card(vdim) + card(vipm) + card(vigm) + card(viim) + card(vfm) ;

      $$batinclude "%DataDir%\filter\title.gms" "'Filtering iteration : '" itr.pos:0:0 "' ('" card(itr):0:0 "'), region '" rrr.tl:0 "' ('" (round(100*(rcount-1)/card(rrr))):0:0 "' % of regions), # of non-zeros: '" nzCountRep:0:0  "', cur rel. tolerance % '" smax((a,r),curRelTol(a,r)):0 "' %'"

*     If necessary, we can begin at a feasible point:

      bigM = 1000;

      options limcol=300,limrow=300, solprint=on ;

* [EditJean]: reduce listing
      options limrow=0, limcol=0;

      solve lpfeas using lp minimizing vz;
      execerror = 0 ;
      while (((lpfeas.solvestat<>1) or (lpfeas.modelstat>2)) and (bigM < 1.E+5),
         bigM = bigM * 10;
         solve lpfeas using lp minimizing vz;
         execerror = 0 ;
      ) ;
      IF((lpfeas.solvestat<>1) or
         (lpfeas.modelstat>2),
         lpfeas.solprint = 1;
         solve lpfeas using lp minimizing vz;
         put_utility 'log' / "Feasibility model fails for region: ",rrr.tl," you might have used to aggressive thresholds";
         abort "Feasibility model fails:", rb, bigM, facty, bop0, gdp ;
      );
      solve calib using nlp minimizing obj ;
      IF((calib.suminfes ne 0) or (calib.numinfes > 0),
         calib.solprint = 1;
         solve calib using nlp minimizing obj;
         put_utility 'log' / "Calibration model fails for region: ",rrr.tl," you might have used to aggressive thresholds";
         abort "Calibration model fails:", rb, facty, bop0, gdp ;
      ) ;
      IF((calib.solvestat <> 1) or (calib.modelstat > 2),
         solve calib using nlp minimizing obj ;
         execerror = 0 ;
      );

      vdm(i,rb)      = vdpm_.l(i,rb) + vdgm_.l(i,rb) + vdim_.l(i,rb) + sum(j,vdfm_.l(i,j,rb)) ;
      vfm(fp,i,rb)   = vfm_.l(fp,i,rb);
      vifm(i,j,rb)   = vifm_.l(i,j,rb);
      vdfm(i,j,rb)   = vdfm_.l(i,j,rb);
      vdpm(i,rb)     = vdpm_.l(i,rb);
      vdgm(i,rb)     = vdgm_.l(i,rb);
      vdim(i,rb)     = vdim_.l(i,rb);
      vipm(i,rb)     = vipm_.l(i,rb);
      vigm(i,rb)     = vigm_.l(i,rb);
      viim(i,rb)     = viim_.l(i,rb);
      vom(i,rb)      = vdm(i,rb) + sum(s, vxmd(i,rb,s)) + vst(i,rb);
      vxm(i,rb)      = sum(s, vxmd(i,rb,s)) + vst(i,rb);

      IF(sum((fp,i,rb), vfm(fp,i,rb)) eq 0,
         calib.solprint = 1;
         solve calib using nlp minimizing obj ;
         abort "No factor income left" ;
      );

      rb(rrr) = no;
   );

*  Record resulting value of aggregate transactions and change in non-zeros
   $$batinclude '%DataDir%\filter\itrlog.gms' after

   option nz:0;
   if (calib.solprint eq 1, display nz) ;

   option trace:3:1:1;
   IF(calib.solprint eq 1, display trace ; ) ;

   itrlog("nonzeros",itr,dsitem)       = nz(dsitem,"count");
   itrlog("nonzeros",itr,r)            = nz(r,"count");
   itrlog("nonzeros",itr,i)            = nz(i,"count");
   itrlog("nonzeros",itr,"curRelTol")  = smax((i,r), curRelTol(i,r));
   itrlog("nonzeros",itr,"curAbsTol")  = curAbsTol;
   itrlog("change",itr,dsitem)         = nz(dsitem,"change");
   itrlog("change",itr,"curRelTol")    = smax((i,r),curRelTol(i,r));
   itrlog("change",itr,"curAbsTol")    = curAbsTol;
   itrlog("trace",itr,dsitem)          = sum(r,trace(dsitem,r,"before"));
   itrlog("trace",itr,"curRelTol")     = smax((i,r),curRelTol(i,r));
   itrlog("trace",itr,"curAbsTol")     = curAbsTol;
   itrlog(r,itr,dsitem)                = trace(dsitem,r,"before");

   if (curAbsTol < absTol*0.999, curAbsTol = curAbsTol + absTol/nSteps);
   if (smax((i,r), curRelTol(i,r)) < relTol*0.999, curRelTol(i,r) = curRelTol(i,r) + startRelTol(i,r)/nSteps) ;

   curRelTol(i,r) = round(curRelTol(i,r),8);

   if (relTol eq 1.E-10, curRelTol(i,r) = 1.E-10);

   nzcountEnd = card(vxmd) + card(vtwr) + card(vifm) + card(vdfm)
              + card(vdpm) + card(vdgm) + card(vdim) + card(vipm) + card(vigm) + card(viim) + card(vfm) ;
*  End of iteration (itr)
);

itrlog(r,"done",dsitem)          = trace(dsitem,r,"after");
itrlog("trace","done",dsitem)    = sum(r,trace(dsitem,r,"after"));
$batinclude '%DataDir%\filter\itrlog.gms' count
itrlog("nonZeros","done",dsitem) = nz(dsitem,"count");
itrlog("nonZeros","done",r)      = nz(r,"count");
itrlog("nonZeros","done",i)      = nz(i,"count");

set aggItr / set.itr, start, absFilt, done / ;
itrLog("nonZeros",aggItr,"total") = sum(dsItem, itrLog("nonZeros",aggItr,dsItem)) ;

dsItem(r) = YES;
dsItem(i) = YES;
itrLog("nonZeros","delta",dsItem) = itrlog("nonZeros","done",dsitem) - itrlog("nonzeros","start",dsitem);
itrLog("nonZeros","delta (%)",dsItem) $ itrlog("nonZeros","Start",dsitem)
     = itrLog("nonZeros","delta",dsItem) / itrlog("nonZeros","start",dsitem) * 100;
dsItem(r) = no ;
dsItem(i) = no ;

itrLog("trace","delta",dsItem) = itrlog("trace","done",dsitem) - itrlog("trace","start",dsitem);
itrLog("trace","delta (%)",dsItem) $ itrlog("trace","start",dsitem)
   = itrLog("trace","delta",dsItem) / itrlog("trace","start",dsitem) * 100;

itrLog(r,"delta",dsItem) = itrlog(r,"done",dsitem) - itrlog(r,"start",dsitem);
itrLog(r,"delta (%)",dsItem) $ itrlog(r,"start",dsitem)
    = itrLog(r,"delta",dsItem) / itrlog(r,"start",dsitem) * 100;

put logfile ; put / ;
put  " " / ;
put  "* --- value of transactions " / ;
put  " " / ;
put  "item":25,"start":10,"end":10,"abs diff ":10,"rel diff":10 / ;
loop(dsitem $ itrLog("trace","start",dsitem),
   put  dsItem.tl:20,
      itrLog("trace","start",dsitem):10:0," ",
      itrLog("trace","done",dsitem):10:0," ",
      itrLog("trace","delta",dsitem):10:0," ",
      itrLog("trace","delta (%)",dsitem):10," %" / ;
);
put  " " / ;
put  "* --- non-zero items " / ;
put  " " / ;
dsItem(r) = YES ;
dsItem(i) = YES ;
put  "item":25,"start":10,"end":10,"abs diff ":10,"rel diff":10 / ;
loop(dsitem $ itrLog("nonZeros","start",dsitem),
   put  dsItem.tl:20,
      itrLog("nonZeros","start",dsitem):10:0," ",
      itrLog("nonZeros","done",dsitem):10:0," ",
      itrLog("nonZeros","delta",dsitem):10:0," ",
      itrLog("nonZeros","delta (%)",dsitem):10," %" / ;
);
dsItem(r) = NO;
dsItem(i) = NO;
put  " " / ;

parameter
   checkDim
   check
;
checkDim(r,"vdim","before")  = sum(i, vdim(i,r))  ;
checkDim(r,"viim","before")  = sum(i, viim(i,r))  ;
checkDim(r,"vdep","before")  = vdep(r);
checkDim(r,"vkb","before")   = vkb(r);
checkDim(r,"fdepr","before") = vdep(r)/vkb(r);
checkDim(r,"save","before")  = save(r);
checkDim(r,"fsav","before")  = -sum((i,s), vxwd(i,r,s)) + sum( (i,s),  viws(i,s,r)) - sum(i, vst(i,r));
checkDim(r,"xft","before")   = sum((cap,i), vfm0(cap,i,r));

*
* ---- update vims and viws
*
viws(i,r,s) $ viws(i,r,s) = viws(i,r,s) * vxmd(i,r,s)/vxmd0(i,r,s);
vims(i,r,s) $ vims(i,r,s) = viws(i,r,s) * (1+rtms(i,r,s)) ;
vxwd(i,r,s) $ vxwd(i,r,s) = vxmd(i,r,s) * (1-rtxs(i,r,s));

check(r,"evfa","before") = sum((fp,a), evfa(fp,a,r)) ;

*
* --- update transaction at agent prices, using tax rates
*

evfa(fp,j,r) = vfm(fp,j,r)  * (1+rtf(fp,j,r));
check(r,"evfa","after")  = sum((fp,j), evfa(fp,j,r));
check(r,"ftrv","before") = sum((fp,j), ftrv(fp,j,r));
ftrv(fp,j,r) $ vfm0(fp,j,r) = ftrv(fp,j,r) * vfm(fp,j,r)/vfm0(fp,j,r);
ftrv(fp,j,r) $ (not vfm0(fp,j,r)) = 0;
check(r,"ftrv","after") = sum((fp,j), ftrv(fp,j,r));

*
* --- update tax income flows
*
check(r,"fbep","before") = sum((fp,j), fbep(fp,j,r));
fbep(fp,j,r) $ vfm0(fp,j,r) = -evfa(fp,j,r) + vfm(fp,j,r) + ftrv(fp,j,r) ;
fbep(fp,j,r) $ (not vfm0(fp,j,r)) = 0;
check(r,"fbep","after")  = sum((fp,j), fbep(fp,j,r));

check(r,"osep","before") = sum(j, osep(j,r));
osep(j,r) = -rto(j,r) * (vdm(j,r)  + vxm(j,r) ) $ vom(j,r);
check(r,"osep","after") = sum(j, osep(j,r));

vdpa(i,r)     = vdpm(i,r)   * (1+rtpd(i,r));
vipa(i,r)     = vipm(i,r)   * (1+rtpi(i,r));
vdga(i,r)     = vdgm(i,r)   * (1+rtgd(i,r));
viga(i,r)     = vigm(i,r)   * (1+rtgi(i,r));
vdia(i,r)     = vdim(i,r)   * (1+rtid(i,r));
viia(i,r)     = viim(i,r)   * (1+rtii(i,r));
vdfa(i,j,r)   = vdfm(i,j,r) * (1+rtfd(i,j,r));
vifa(i,j,r)   = vifm(i,j,r) * (1+rtfi(i,j,r));
vdfa(i,'cgds',r) = vdia(i,r) ;
vifa(i,'cgds',r) = viia(i,r) ;
vdfm(i,'cgds',r) = vdim(i,r) ;
vifm(i,'cgds',r) = viim(i,r) ;
*
* --- update depreciation and initial capital stock
*     (not necessary for consistency, but might keep depreciation rates etc.
*      in more plausbile ranges)
*
*  14-May-2016: DvdM--I don't believe this adjustment belongs here as it changes the macro SAM and
*                     is not part of the filtering process.
*
parameter scaleCap(r) ;

*  Agents' prices????
IF(ifAdjDepr,
   scaleCap(r) = sqrt(sum((fp,cap,j) $ sameas(fp,cap), vfm(fp,j,r))/sum((fp,cap,j) $ sameas(fp,cap), vfm0(fp,j,r))
               *      sum(i, vdia(i,r)+viia(i,r))/sum(i, vdia0(i,r)+viia0(i,r))) ;

   vdep(r) =  vdep(r) * scaleCap(r);
   vkb(r)  =  vkb(r)  * scaleCap(r);

*
*  --- calculate saving residually -- should be at agents' prices
*
   SAVE(r) = sum(i, vdia(i,r)+viia(i,r))
           - [-sum((i,s), vxwd(i,r,s)) + sum((i,s), viws(i,s,r)) - sum(i, vst(i,r))]
           - vdep(r) ;

*
*  ---- increase capital stock (to dampen effect of changes in foreign saving on return to capital)
*         if share of savings on investment expenditures < 50%
*
*  vkb(r) $ (  (save(r) / sum(i, vdia(i,r)+vdia(i,r))) < 0.2)
*     = vkb(r) * 1/max(0.2,save(r) / sum(i, vdim(i,r)+vdia(i,r)));
*
*  ---- ensure at least 20% savings on total investment expenditures
*
   SAVE(r)$((save(r)/sum(i, vdia(i,r)+viia(i,r))) < 0.20) = 0.20 * sum(i, vdia(i,r)+viia(i,r)) ;
*
*  --- calculate depreciation residually (only necessary if 20% threshold kicked in)
*        but maintain 50% of original level
*
   vdep(r) = max(0.5 * vdep(r),
               sum(i, vdia(i,r)+viia(i,r))
           -  [-sum((i,s), vxwd(i,r,s)) + sum((i,s), viws(i,s,r)) - sum(i, vst(i,r))]
           -  save(r)) ;
*
*  --- recalculate savings
*
   SAVE(r) = sum(i, vdia(i,r)+viia(i,r))
           -   [-sum((i,s), vxwd(i,r,s)) + sum((i,s), viws(i,s,r)) - sum(i, vst(i,r))]
           -   vdep(r) ;

   IF(sum(r $ (vdep(r) < 0),1),

      put logfile ;
      put   "Implied changes so large that depreciation became negative after corrections, please reduce thresholds" / ;
      abort "Implied changes so large that depreciation became negative after corrections, please reduce thresholds", vdep ;
   ) ;
) ;

alias(fp,fp1);

checkDim(r,"vdim","after")   = sum(i, vdim(i,r)) ;
checkDim(r,"viim","after")   = sum(i, viim(i,r)) ;
checkDim(r,"vdep","after")  = vdep(r) ;
checkDim(r,"vkb","after")   = vkb(r) ;
checkDim(r,"fdepr","after") = vdep(r)/vkb(r) ;
checkDim(r,"save","after")  = save(r) ;
checkDim(r,"fsav","after")  = -sum((i,s), vxwd(i,r,s)) + sum((i,s), viws(i,s,r)) - sum(i, vst(i,r)) ;
checkDim(r,"xft","after")   = sum((fp,cap,a) $ sameas(fp,cap), vfm(fp,a,r)) ;

set dimCheck / vdim, viim, vdep, save, fsav, xft, vkb, fdepr / ;
checkDim(r,dimCheck,"delta") = checkDim(r,dimCheck,"after") - checkDim(r,dimCheck,"before");
checkDim(r,dimCheck,"% delta") $ checkDim(r,dimCheck,"before") = checkDim(r,dimCheck,"delta")/checkDim(r,dimCheck,"before")*100;
display checkDim;

*
* --- update direct taxes on factors
*
parameter
   evoaNew(r)
;

check(r,"evoa","before") = sum(fp, evoa(fp,r));

*  14-May-2016: DvdM

* $OnText
evoaNew(r) = dirtax(r)
           - [sum(i, vdgm(i,r)*(1+rtgd(i,r)) + vigm(i,r)*(1+rtgi(i,r)))
           -  sum(j, sum(fp, ftrv(fp,j,r) - fbep(fp,j,r)) -  osep(j,r))
           -  sum(i,
           +   vdpm(i,r) * rtpd(i,r) + vipm(i,r) * rtpi(i,r)
           +   vdgm(i,r) * rtgd(i,r) + vigm(i,r) * rtgi(i,r)
           +   vdim(i,r) * rtid(i,r) + viim(i,r) * rtii(i,r)
           +   sum(j, vdfm(i,j,r) * rtfd(i,j,r) + vifm(i,j,r) * rtfi(i,j,r))
           +   sum(s, vims(i,s,r) - viws(i,s,r))
           +   sum(s, vxwd(i,r,s) - vxmd(i,r,s)))
           -   sum ((fp,cap,j) $ sameas(fp,cap), vfm(fp,j,r)) ] ;

check(r,"evoa","after") = sum(fp, evoa(fp,r)) ;

evoa(fp,r) $ evoa(fp,r) = evoa(fp,r) * evoaNew(r) / sum(fp1, evoa(fp1,r)) ;
*$OffText

evoa(fp,r) = (1 - rtva(fp,r))*(sum(j, vfm(fp,j,r)) - vdep(r)$(cap(fp))) ;
check(r,"evoa","after") = sum(fp, evoa(fp,r)) ;
set checkItems / evoa, fbep, osep, evfa, ftrv / ;
check(r,checkItems,"delta") = check(r,checkItems,"after")  - check(r,checkItems,"before") ;
check(r,checkItems,"%") $  check(r,checkItems,"before")
   = check(r,checkItems,"delta")/check(r,checkItems,"before") * 100;

display check, keepCor.l;

$batinclude "%DataDir%\aggsam.gms"  "AFTER"

execute_unload "%iDataDir%\Flt\%Prefix%dat.gdx",
   evfa, vfm, evoa,
   vdfa, vdfm, vifa, vifm,
   vdpa, vdpm, vipa, vipm,
   vdga, vdgm, viga, vigm,
   vxmd, vxwd, viws, vims, vtwr, vst,
   vkb,  save, vdep, pop
***HRR: added 
   , fbep , ftrv
***endHRR

;

scalar emiCount / 0 / ;

$ifthen exist "%iDataDir%\Agg\%Prefix%emiss.gdx"
   execute_loaddc "%iDataDir%\Agg\%Prefix%emiss.gdx",
      mdf, mif, mdp, mip, mdg, mig ;

   emiCount = emiCount + 1 ;
$endif

$ifthen exist "%iDataDir%\Agg\%Prefix%vole.gdx"
    execute_loaddc  "%iDataDir%\Agg\%Prefix%vole.gdx",
    EDF, EIF, EDP, EIP, EDG, EIG, EDF, EXIDAG ;
    emiCount = emiCount + 1 ;
$endif

$iftheni.nco2 "%NCO2%" == "ON"

    $$ifthen exist "%iDataDir%\Agg\%Prefix%nco2.gdx"
        execute_loaddc "%iDataDir%\Agg\%Prefix%nco2.gdx",
            $$Ifi NOT %gtap_ver%=="92" LandUseEmi, LandUseEmi_CEQ,
            $$Ifi NOT %gtap_ver%=="92" TOTNC, TOTNC_CEQ, GWPARS,
            NC_TRAD, NC_ENDW, NC_QO, NC_HH, NC_TRAD_CEQ, NC_ENDW_CEQ,
            NC_QO_CEQ, NC_HH_CEQ ;
        emiCount = emiCount + 1 ;
    $$else

        $$setGlobal NCO2 OFF
    $$endif

$endif.nco2

IF(emiCount ge 2,
$batinclude "%DataDir%\aggNRG.gms" BEFORE
) ;

$ifthen exist "%iDataDir%\Agg\%Prefix%emiss.gdx"

Parameters
   mdp0(i,r), mip0(i,r), mdg0(i,r), mig0(i,r), mdf0(i,a,r), mif0(i,a,r) ;
   mdp0(i,r) = mdp(i,r) ;
   mip0(i,r) = mip(i,r) ;
   mdg0(i,r) = mdg(i,r) ;
   mig0(i,r) = mig(i,r) ;
   mdf0(i,a,r) = mdf(i,a,r) ;
   mif0(i,a,r) = mIF(i,a,r) ;

*
* --- scale emissions commodity specific emissions to recover totals
*

   IF(1,

*     Scale individual cells first

      mdp(i,r)$vdpm0(i,r) = (mdp0(i,r)/vdpm0(i,r))*vdpm(i,r) ;
      mip(i,r)$vipm0(i,r) = (mip0(i,r)/vipm0(i,r))*vipm(i,r) ;
      mdg(i,r)$vdgm0(i,r) = (mdg0(i,r)/vdgm0(i,r))*vdgm(i,r) ;
      mig(i,r)$vigm0(i,r) = (mig0(i,r)/vigm0(i,r))*vigm(i,r) ;
      mdf(i,'cgds',r)$vdim0(i,r) = (mdf0(i,'cgds',r)/vdim0(i,r))*vdim(i,r) ;
      mIF(i,'cgds',r)$viim0(i,r) = (mif0(i,'cgds',r)/viim0(i,r))*viim(i,r) ;
      mdf(i,j,r)$vdfm0(i,j,r) = (mdf0(i,j,r)/vdfm0(i,j,r))*vdfm(i,j,r) ;
      mIF(i,j,r)$vifm0(i,j,r) = (mif0(i,j,r)/vifm0(i,j,r))*vifm(i,j,r) ;

   ) ;

   IF(1,
      total("old",r) = sum(i, mdp0(i,r)) ;
      total("new",r) = sum(i $ vdpm(i,r), mdp(i,r)) ;
      mdp(i,r) $ total("new",r) = (mdp(i,r) * total("old",r)/total("new",r)) $ vdpm(i,r);

      total("old",r) = sum(i, mip0(i,r));
      total("new",r) = sum(i $ vipm(i,r), mip(i,r));
      mip(i,r) $ total("new",r) = (mip(i,r) * total("old",r)/total("new",r)) $ vipm(i,r);

      total("old",r) = sum(i, mdg0(i,r));
      total("new",r) = sum(i $ vdgm(i,r), mdg(i,r));
      mdg(i,r) $ total("new",r) = (mdg(i,r) * total("old",r)/total("new",r)) $ vdgm(i,r);

      total("old",r) = sum(i, mig0(i,r));
      total("new",r) = sum(i $ vigm(i,r), mig(i,r));
      mig(i,r) $ total("new",r) = (mig(i,r) * total("old",r)/total("new",r)) $ vigm(i,r);

      total("old",r) = sum((i,a), mdf0(i,a,r));
      total("new",r) = sum((i,a) $ vdfm(i,a,r), mdf(i,a,r));
      mdf(i,a,r)$ total("new",r) = (mdf(i,a,r) * total("old",r)/total("new",r)) $ vdfm(i,a,r);

      total("old",r) = sum((i,a), mif0(i,a,r));
      total("new",r) = sum((i,a) $ vifm(i,a,r), mIF(i,a,r) );
      mIF(i,a,r) $ total("new",r) = (mIF(i,a,r) * total("old",r)/total("new",r)) $ vifm(i,a,r);
   ) ;

   execute_unload "%iDataDir%\Flt\%Prefix%emiss.gdx",
      mdf, mif, mdp, mip, mdg, mig ;

$endif

$ifthen exist "%iDataDir%\Agg\%Prefix%vole.gdx"

Parameters
   edp0(i,r), eip0(i,r), edg0(i,r), eig0(i,r), edf0(i,a,r), eif0(i,a,r), exidag0(i,r,d) ;
   edp0(i,r) = edp(i,r) ;
   eip0(i,r) = eip(i,r) ;
   edg0(i,r) = edg(i,r) ;
   eig0(i,r) = eig(i,r) ;
   edf0(i,a,r) = edf(i,a,r) ;
   eif0(i,a,r) = eIF(i,a,r) ;
   exidag0(i,r,d) = exidag(i,r,d) ;

   IF(1,

*     Scale individual cells first

      edp(i,r)$vdpm0(i,r) = (edp0(i,r)/vdpm0(i,r))*vdpm(i,r) ;
      eip(i,r)$vipm0(i,r) = (eip0(i,r)/vipm0(i,r))*vipm(i,r) ;
      edg(i,r)$vdgm0(i,r) = (edg0(i,r)/vdgm0(i,r))*vdgm(i,r) ;
      eig(i,r)$vigm0(i,r) = (eig0(i,r)/vigm0(i,r))*vigm(i,r) ;
      edf(i,'cgds',r)$vdim0(i,r) = (edf0(i,'cgds',r)/vdim0(i,r))*vdim(i,r) ;
      eIF(i,'cgds',r)$viim0(i,r) = (eif0(i,'cgds',r)/viim0(i,r))*viim(i,r) ;
      edf(i,j,r)$vdfm0(i,j,r) = (edf0(i,j,r)/vdfm0(i,j,r))*vdfm(i,j,r) ;
      eIF(i,j,r)$vifm0(i,j,r) = (eif0(i,j,r)/vifm0(i,j,r))*vifm(i,j,r) ;
      exidag(i,r,d)$vxwd0(i,r,d) = (exidag0(i,r,d)/vxwd0(i,r,d))*vxwd(i,r,d) ;
   ) ;

*
* --- scale energy volumes to recover totals
*
   total("old",r) = sum(i, edp0(i,r)) ;
   total("new",r) = sum(i $ vdpm(i,r), edp(i,r)) ;
   edp(i,r) $ total("new",r) = (edp(i,r) * total("old",r)/total("new",r)) $ vdpm(i,r);

   total("old",r) = sum(i, eip0(i,r));
   total("new",r) = sum(i $ vipm(i,r), eip(i,r));
   eip(i,r) $ total("new",r) = (eip(i,r) * total("old",r)/total("new",r)) $ vipm(i,r);

   total("old",r) = sum(i, edg0(i,r));
   total("new",r) = sum(i $ vdgm(i,r), edg(i,r));
   edg(i,r) $ total("new",r) = (edg(i,r) * total("old",r)/total("new",r)) $ vdgm(i,r);

   total("old",r) = sum(i, eig0(i,r));
   total("new",r) = sum(i $ vigm(i,r), eig(i,r));
   eig(i,r) $ total("new",r) = (eig(i,r) *total("old",r)/total("new",r)) $ vigm(i,r);

   total("old",r) = sum((i,a), edf0(i,a,r));
   total("new",r) = sum((i,a) $ vdfm(i,a,r), edf(i,a,r));
   edf(i,a,r)$ total("new",r) = (edf(i,a,r) * total("old",r)/total("new",r)) $ vdfm(i,a,r);

   total("old",r) = sum((i,a), eif0(i,a,r));
   total("new",r) = sum((i,a) $ vifm(i,a,r), eIF(i,a,r));
   eIF(i,a,r) $ total("new",r) = (eIF(i,a,r) * total("old",r)/total("new",r)) $ vifm(i,a,r);

   loop(i,
      total("old",r) = sum(rp, exidag0(i,r,rp));
      total("new",r) = sum(rp $ vxwd(i,r,rp), exidag(i,r,rp));
      exidag(i,r,rp) $ total("new",r) = (exidag(i,r,rp) * total("old",r)/total("new",r)) $ vxwd(i,r,rp) ;
   ) ;

   execute_unload "%iDataDir%\Flt\%Prefix%vole.gdx",
      EDF, EIF, EDP, EIP, EDG, EIG, EDF, EXIDAG ;

$endif

$$iftheni.nco2 "%NCO2%" == "ON"

   $$ifthen exist "%iDataDir%\Agg\%Prefix%nco2.gdx"

        Parameters
        NC_HH0(AllEmissions,i,r),
        NC_HH_CEQ0(AllEmissions,i,r),
        NC_TRAD0(AllEmissions,i,a,r),
        NC_TRAD_CEQ0(AllEmissions,i,a,r),
        NC_ENDW0(AllEmissions,fp,a,r),
        NC_ENDW_CEQ0(AllEmissions,fp,a,r),
        NC_QO0(AllEmissions,j,r),
        NC_QO_CEQ0(AllEmissions,j,r) ;

        NC_HH0(AllEmissions,i,r)          = NC_HH(AllEmissions,i,r) ;
        NC_HH_CEQ0(AllEmissions,i,r)      = NC_HH_CEQ(AllEmissions,i,r) ;
        NC_TRAD0(AllEmissions,i,a,r)      = NC_TRAD(AllEmissions,i,a,r) ;
        NC_TRAD_CEQ0(AllEmissions,i,a,r)  = NC_TRAD_CEQ(AllEmissions,i,a,r) ;
        NC_ENDW0(AllEmissions,fp,j,r)     = NC_ENDW(AllEmissions,fp,j,r) ;
        NC_ENDW_CEQ0(AllEmissions,fp,j,r) = NC_ENDW_CEQ(AllEmissions,fp,j,r) ;
        NC_QO0(AllEmissions,j,r)          = NC_QO(AllEmissions,j,r) ;
        NC_QO_CEQ0(AllEmissions,j,r)      = NC_QO_CEQ(AllEmissions,j,r) ;

        IF(1,
*        Scale individual cells first

            NC_HH(AllEmissions,i,r) $ (vdpm0(i,r) + vipm0(i,r))
                = (NC_HH0(AllEmissions,i,r)
                / (vdpm0(i,r) + vipm0(i,r)))*(vdpm(i,r) + vipm(i,r)) ;
            NC_HH_CEQ(AllEmissions,i,r) $(vdpm0(i,r) + vipm0(i,r))
                = (NC_HH_CEQ0(AllEmissions,i,r)
                / (vdpm0(i,r) + vipm0(i,r)))*(vdpm(i,r) + vipm(i,r)) ;

            NC_TRAD(AllEmissions,i,'cgds',r) $ (vdim0(i,r) + viim0(i,r))
                = (NC_TRAD0(AllEmissions,i,'cgds',r)
                /(vdim0(i,r) + viim0(i,r)))*(vdim(i,r) + viim(i,r)) ;
            NC_TRAD_CEQ(AllEmissions,i,'cgds',r) $ (vdim0(i,r) + viim0(i,r))
                = (NC_TRAD_CEQ0(AllEmissions,i,'cgds',r)
                / (vdim0(i,r) + viim0(i,r)))*(vdim(i,r) + viim(i,r)) ;

            NC_TRAD(AllEmissions,i,j,r) $ (vdfm0(i,j,r) + vifm0(i,j,r))
                = (NC_TRAD0(AllEmissions,i,j,r)
                / (vdfm0(i,j,r) + vifm0(i,j,r)))*(vdfm(i,j,r) + vifm(i,j,r)) ;
            NC_TRAD_CEQ(AllEmissions,i,j,r) $ (vdfm0(i,j,r) + vifm0(i,j,r))
                = (NC_TRAD_CEQ0(AllEmissions,i,j,r)
                / (vdfm0(i,j,r) + vifm0(i,j,r)))*(vdfm(i,j,r) + vifm(i,j,r)) ;

            NC_ENDW(AllEmissions,fp,j,r) $ vfm0(fp,j,r)
                = (NC_ENDW0(AllEmissions,fp,j,r) / vfm0(fp,j,r))*vfm(fp,j,r) ;
            NC_ENDW_CEQ(AllEmissions,fp,j,r) $ vfm0(fp,j,r)
                = (NC_ENDW_CEQ0(AllEmissions,fp,j,r) / vfm0(fp,j,r))*vfm(fp,j,r) ;

            NC_QO(AllEmissions,j,r) $ vom0(j,r)
                = (NC_QO0(AllEmissions,j,r)/vom0(j,r))*vom(j,r) ;
            NC_QO_CEQ(AllEmissions,j,r) $ vom0(j,r)
                = (NC_QO_CEQ0(AllEmissions,j,r)/vom0(j,r))*vom(j,r) ;
        ) ;

*
* --- scale nco2 levels to recover totals

        loop(AllEmissions,

*       Households

            total("old",r) = sum(i, NC_HH0(AllEmissions,i,r)) ;
            total("new",r) = sum(i $ (vdpm(i,r) + vipm(i,r)), NC_HH(AllEmissions,i,r)) ;
            NC_HH(AllEmissions,i,r) $ total("new",r)
                = (NC_HH(AllEmissions,i,r) * total("old",r) / total("new",r)) $ (vdpm(i,r) + vipm(i,r)) ;

            total("old",r) = sum(i, NC_HH_CEQ0(AllEmissions,i,r)) ;
            total("new",r) = sum(i $ (vdpm(i,r) + vipm(i,r)), NC_HH_CEQ(AllEmissions,i,r)) ;
            NC_HH_CEQ(AllEmissions,i,r) $ total("new",r)
                = (NC_HH_CEQ(AllEmissions,i,r) * total("old",r) / total("new",r)) $ (vdpm(i,r) + vipm(i,r)) ;

*        Firms

            total("old",r) = sum((i,a), NC_TRAD0(AllEmissions,i,a,r));
            total("new",r) = sum((i,a)$(vdfm(i,a,r) + vifm(i,a,r)), NC_TRAD(AllEmissions,i,a,r));
            NC_TRAD(AllEmissions,i,a,r) $ total("new",r)
                = (NC_TRAD(AllEmissions,i,a,r) * total("old",r) / total("new",r)) $ (vdfm(i,a,r) + vifm(i,a,r)) ;

            total("old",r) = sum((i,a), NC_TRAD_CEQ0(AllEmissions,i,a,r));
            total("new",r) = sum((i,a) $ (vdfm(i,a,r) + vifm(i,a,r)), NC_TRAD_CEQ(AllEmissions,i,a,r));
            NC_TRAD_CEQ(AllEmissions,i,a,r)$ total("new",r)
                = (NC_TRAD_CEQ(AllEmissions,i,a,r) * total("old",r) / total("new",r)) $ (vdfm(i,a,r) + vifm(i,a,r)) ;

*        Endowments

            total("old",r) = sum((fp,a), NC_ENDW0(AllEmissions,fp,a,r));
            total("new",r) = sum((fp,a) $ (vfm(fp,a,r)), NC_ENDW(AllEmissions,fp,a,r));
            NC_ENDW(AllEmissions,fp,a,r) $ total("new",r)
                = (NC_ENDW(AllEmissions,fp,a,r) * total("old",r) / total("new",r)) $ (vfm(fp,a,r)) ;

            total("old",r) = sum((fp,a), NC_ENDW_CEQ0(AllEmissions,fp,a,r));
            total("new",r) = sum((fp,a) $ (vfm(fp,a,r)), NC_ENDW_CEQ(AllEmissions,fp,a,r));
            NC_ENDW_CEQ(AllEmissions,fp,a,r) $ total("new",r)
                = (NC_ENDW_CEQ(AllEmissions,fp,a,r) * total("old",r) / total("new",r)) $ (vfm(fp,a,r)) ;

*        Output

            total("old",r) = sum(j, NC_QO0(AllEmissions,j,r)) ;
            total("new",r) = sum(j $ vom(j,r), NC_QO(AllEmissions,j,r)) ;
            NC_QO(AllEmissions,j,r) $ total("new",r)
                = (NC_QO(AllEmissions,j,r) * total("old",r) / total("new",r)) $ vom(j,r) ;

            total("old",r) = sum(j, NC_QO_CEQ0(AllEmissions,j,r)) ;
            total("new",r) = sum(j $ vom(j,r), NC_QO_CEQ(AllEmissions,j,r)) ;
            NC_QO_CEQ(AllEmissions,j,r) $ total("new",r)
                = (NC_QO_CEQ(AllEmissions,j,r) * total("old",r) / total("new",r)) $ vom(j,r) ;
      ) ;

*   Save Non-CO2/Air Pollution emissions data

        execute_unload "%iDataDir%\Flt\%Prefix%nco2.gdx",
            $$Ifi NOT %gtap_ver%=="92" LandUseEmi, LandUseEmi_CEQ,
            $$Ifi NOT %gtap_ver%=="92" TOTNC, TOTNC_CEQ, GWPARS,
            NC_TRAD, NC_ENDW, NC_QO, NC_HH, NC_TRAD_CEQ, NC_ENDW_CEQ,
            NC_QO_CEQ, NC_HH_CEQ ;

   $$endif

$endif.nco2

*   Re-scale labor volumes

$ifthen exist "%iDataDir%Agg\%Prefix%Wages.gdx"

    Parameters
        q(l,a,r)       "Initial labor volumes"
        wage(l,a,r)    "Initial wage"
        q0(l,a,r)      "Adjusted labor volume"
        wage0(l,a,r)   "Adusted wage"
    ;

    execute_loaddc "%iDataDir%\Agg\%Prefix%Wages.gdx", q, wage ;

    q0(l,a,r)    = q(l,a,r) ;
    wage0(l,a,r) = wage(l,a,r) ;

* scale labor volume--keeping wage the same

    IF(1,
        q(l,a,r) $ wage(l,a,r) = vfm(l,a,r) / wage(l,a,r) ;
    ) ;

   execute_unload "%iDataDir%\Flt\%Prefix%Wages.gdx", q, wage ;

$endif

$show

IF(emiCount eq 3,
    $$batinclude "%DataDir%\aggNRG.gms" AFTER
) ;
