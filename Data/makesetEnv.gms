$OnText
--------------------------------------------------------------------------------
   Envisage 10 / OECD-ENV project -- Data preparation modules
	GAMS file   : "%DataDir%\makesetEnv.gms"
    purpose     : Put in additional dimensions for Envisage & OECD-ENV
    created by  : Dominique van der Mensbrugghe
    created date: 21.10.16
	revision 	: Jean Chateau - 20.03.2021 / 21.09.2022 for OECD-ENV
    called by   : "%DataDir%\AggGTAP.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/makesetEnv.gms $
   last changed revision: $Rev: 516 $
   last changed date    : $Date:: 2024-02-23 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
	[EditJean]: create sets in more compact form using Macros
	#Rev 514 - 23 Feb. 2024 Remove printing gy's sets
--------------------------------------------------------------------------------
$OffText

put 'set tot(aa) "Total" / tot   "Total for row/column sums"/ ;' / ;

* [OECD-ENV]: for compact instructions with macro the corresponding Sets should have been defined in "map.gms"

m_putSet_withSubseta(cra,a)
m_putSet_withSubseta(lva,a)

* moved in "22-Additional_Sets.gms"
* put 'set agra(a) "Agricultural activities"; agra(a) = cra(a) + lva(a);  ' / /;
* put 'set axa(a) "All other activities" ; ' / ;
* put 'LOOP(a $ (NOT agra(a)), axa(a) = YES; ) ; '/ /;

m_putSet_withSubseta(ea,a)
m_putSet_withSubseta(fa,a)
m_putSet_withSubseta(wtra,a)
m_putSet_withSubseta(elya,a)
m_putSet_withSubseta(etda,a)
m_putSet_withSubseta(primElya,a)

put 'set z "Labor market zones" /' / ;
loop(z,
   strlen = card(z.tl) ;
   put '   ', z.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', z.te(z), '"' / ;
) ;
put '/ ;' / / ;

put 'set rur(z) "Rural zone" /' / ;
loop(z$rur(z),
   strlen = card(z.tl) ;
   put '   ', z.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', z.te(z), '"' / ;
) ;
put '/ ;' / / ;

put 'set urb(z) "Urban zone" /' / ;
loop(z$urb(z),
   strlen = card(z.tl) ;
   put '   ', z.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', z.te(z), '"' / ;
) ;
put '/ ;' / / ;

put 'set nsg(z) "Both zones" /' / ;
loop(z$nsg(z),
   strlen = card(z.tl) ;
   put '   ', z.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', z.te(z), '"' / ;
) ;
put '/ ;' / / ;

maxcol1 = smax(z, card(z.tl)) ;
put 'set mapz(z,a) "Mapping of activities to zones" /' / ;
loop(mapzf(z,actf)$(not nsg(z)),
    strlen = card(actf.tl) ;
    put '   ', z.tl:<maxcol1, '.', actf.tl:<strlen, '-a' / ;
) ;
put '/ ;' / / ;

put 'mapz("nsg", a) = yes ;' / / ;

*  >>>>> Commodity sets and subsets

* [OECD-ENV]: simplify these instructions using macro: m_putSet_withSubseti
m_putSet_withSubseti(frti,i)
m_putSet_withSubseti(feedi,i)
m_putSet_withSubseti(iw,i)
m_putSet_withSubseti(ei,i)
m_putSet_withSubseti(elyi,i)
m_putSet_withSubseti(fi,ei)

set imga(commf) ;
loop(mapa(img0,i), imga(commf) $ mapIF(i,commf) = yes ;) ;

put 'set img(i) "Margin commodities" /' / ;
loop(commf$imga(commf),
    strlen = card(commf.tl) ;
    put '   ', commf.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+5), '"', commf.te(commf), '"' / ;
) ;
put '/ ;' / / ;

*  >>>>> Household sets and subsets

* #TODO mettre k et cie dans modele

put 'set k "Household commodities" /' / ;
loop(k,
   strlen = card(k.tl) ;
   put '   ', k.tl:<strlen, '-k', ' ':(MaxStrLen-(strlen+2)+5), '"', k.te(k), '"' / ;
) ;
put '/ ;' / / ;

put 'set mapk(i,k) "Mapping from i to k" /' / ;
loop(mapk(commf,k),
   strlen = card(commf.tl) ;
   put '   ', commf.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+1), '.', k.tl:card(k.tl), '-k' / ;
) ;
put '/ ;' / / ;

* [TBU]: because of ConvertLabel.gms need to keep this then pb in sets.gms after
$IfThenI.WriteNDBundles NOT SET BundleChoiceInModel
    put 'set pb "Power bundles in power aggregation" /' / ;
    loop(pb,
        strlen = card(pb.tl) ;
        put '   ', pb.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', pb.te(pb), '"' / ;
    ) ;
    put '/ ;' / / ;

    put 'set lb "Land bundles" /' / ;
    loop(lb,
        strlen = card(lb.tl) ;
        put '   ', lb.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', lb.te(lb), '"' / ;
    ) ;
    put '/ ;' / / ;

    put 'set mappow(pb,elya) "Mapping of power activities to power bundles" /' / ;
    loop(mappow(pb,elya),
        strlen = card(pb.tl) ;
        put '   ', pb.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', elya.tl:card(elya.tl), '-a' / ;
    ) ;
    put '/ ;' / / ;

    put 'set lb1(lb) "First land bundle" /' / ;
    loop(lb$lb1(lb),
        strlen = card(lb.tl) ;
        put '   ', lb.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', lb.te(lb), '"' / ;
    ) ;
    put '/ ;' / / ;

    put 'set maplb(lb,a) "Mapping of activities to land bundles" /' / ;
    loop(maplb(lb,actf),
        strlen = card(lb.tl) ;
        put '   ', lb.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', actf.tl:card(actf.tl), '-a' / ;
    ) ;
    put '/ ;' / / ;
$Endif.WriteNDBundles

put 'set lh "Market condition flags" /' / ;
put '   lo    "Market downswing"' / ;
put '   hi    "Market upswing"' / ;
put '/ ;' / / ;

put 'set wbnd "Aggregate water markets" /' / ;
loop(wbnd,
   strlen = card(wbnd.tl) ;
   put '   ', wbnd.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', wbnd.te(wbnd), '"' / ;
) ;
put '/ ;' / / ;

put 'set wbnd1(wbnd) "Top level water markets" /' / ;
loop(wbnd$wbnd1(wbnd),
   strlen = card(wbnd.tl) ;
   put '   ', wbnd.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', wbnd.te(wbnd), '"' / ;
) ;
put '/ ;' / / ;

put 'set wbnd2(wbnd) "Second level water markets" /' / ;
loop(wbnd $ wbnd2(wbnd),
   strlen = card(wbnd.tl) ;
   put '   ', wbnd.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', wbnd.te(wbnd), '"' / ;
) ;
put '/ ;' / / ;

put 'set wbndex(wbnd) "Second level water markets" /' / ;
loop(wbnd$wbndex(wbnd),
   strlen = card(wbnd.tl) ;
   put '   ', wbnd.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', wbnd.te(wbnd), '"' / ;
) ;
put '/ ;' / / ;

put 'set mapw1(wbnd,wbnd) "Mapping of first level water bundles" /' / ;
loop(mapw1(wbnd1,wbnd2),
   strlen = card(wbnd1.tl) ;
   put '   ', wbnd1.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', wbnd2.tl / ;
) ;
put '/ ;' / / ;

put 'set mapw2(wbnd,a) "Mapping of second level water bundle" /' / ;
loop(mapw2(wbnd2,actf),
   strlen = card(wbnd2.tl) ;
   put '   ', wbnd2.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', actf.tl:card(actf.tl), '-a' / ;
) ;
put '/ ;' / / ;

put 'set wbnda(wbnd) "Water bundles mapped one-to-one to activities" /' / ;
loop(wbnd$wbnda(wbnd),
   strlen = card(wbnd.tl) ;
   put '   ', wbnd.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', wbnd.te(wbnd), '"' / ;
) ;
put '/ ;' / / ;

put 'set wbndi(wbnd) "Water bundles mapped to aggregate output" /' / ;
loop(wbnd$wbndi(wbnd),
   strlen = card(wbnd.tl) ;
   put '   ', wbnd.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', wbnd.te(wbnd), '"' / ;
) ;
put '/ ;' / / ;

*------------------------------------------------------------------------------*
*               Energy bundles used in model                                   *
*------------------------------------------------------------------------------*

put 'set NRG "Energy bundles used in model" /' / ;
loop(NRG,
   strlen = card(nrg.tl) ;
   put '   ', NRG.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', NRG.te(NRG), '"' / ;
) ;
put '/ ;' / / ;

put 'set coa(NRG) "Coal bundle used in model" /' / ;
loop(nrg $ coa(NRG),
   strlen = card(nrg.tl) ;
   put '   ', NRG.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', NRG.te(NRG), '"' / ;
) ;
put '/ ;' / / ;

put 'set oil(NRG) "Oil bundle used in model" /' / ;
loop(nrg $ oil(NRG),
   strlen = card(nrg.tl) ;
   put '   ', NRG.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', NRG.te(NRG), '"' / ;
) ;
put '/ ;' / / ;

put 'set gas(NRG) "Gas bundle used in model" /' / ;
loop(nrg $ gas(NRG),
   strlen = card(nrg.tl) ;
   put '   ', NRG.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', NRG.te(NRG), '"' / ;
) ;
put '/ ;' / / ;

put 'set ely(NRG) "Electricity bundle used in model" /' / ;
loop(nrg $ ely(NRG),
   strlen = card(nrg.tl) ;
   put '   ', NRG.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', NRG.te(NRG), '"' / ;
) ;
put '/ ;' / / ;

put 'set mape(NRG,ei) "Mapping of energy commodities to energy bundles" /' / ;
loop(mape(nrg,ei),
   strlen = card(nrg.tl) ;
   put '   ', nrg.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', ei.tl:card(ei.tl), '-c' / ;
) ;
put '/ ;' / / ;


*------------------------------------------------------------------------------*

* [EditJean]: IF SET BundleChoiceInModel then  mapi1 & mapi2 are not defined
* [EditJean]: in "set.gms" and are precised in the model, we do same thing for emissions Sets

$IfThenI.WriteNDBundles NOT SET BundleChoiceInModel
put 'set em "Emission types" /' / ;
loop(em,
   strlen = card(em.tl) ;
   put '   ', em.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', em.te(em), '"' / ;
) ;
put '/ ;' / / ;

put 'set emn(em) "Non-CO2 emission types" /' / ;
loop(em$emn(em),
   strlen = card(em.tl) ;
   put '   ', em.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', em.te(em), '"' / ;
) ;
put '/ ;' / / ;

put 'set emq "Emission quantities" /' / ;
put '   gt          "Gigatons"' / ;
put '   ceq         "Carbon equivalent"' / ;
put '   co2eq       "CO2 equivalent"' / ;
put '/ ;' / / ;

*------------------------------------------------------------------------------*

put 'set mapi1(i,a) "Mapping of commodities to ND1 bundle" /' / ;
loop(actf$acr(actf),
   loop(commf$(not frt(commf) and not e(commf) and not iw(commf)),
      strlen = card(commf.tl) ;
      put '   ', commf.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+1), '.', actf.tl:card(actf.tl), '-a' / ;
   ) ;
) ;
loop(actf$alv(actf),
   loop(commf$(not feed(commf) and not e(commf) and not iw(commf)),
      strlen = card(commf.tl) ;
      put '   ', commf.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+1), '.', actf.tl:card(actf.tl), '-a' / ;
   ) ;
) ;
loop(actf$(not acr(actf) and not alv(actf)),
   loop(commf$(not e(commf) and not iw(commf)),
      strlen = card(commf.tl) ;
      put '   ', commf.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+1), '.', actf.tl:card(actf.tl), '-a' / ;
   ) ;
) ;
put '/ ;' / / ;

put 'set mapi2(i,a) "Mapping of commodities to ND2 bundle" /' / ;
loop(actf$acr(actf),
   loop(commf$frt(commf),
      strlen = card(commf.tl) ;
      put '   ', commf.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+1), '.', actf.tl:card(actf.tl), '-a' / ;
   ) ;
) ;
loop(actf$alv(actf),
   loop(commf$feed(commf),
      strlen = card(commf.tl) ;
      put '   ', commf.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+1), '.', actf.tl:card(actf.tl), '-a' / ;
   ) ;
) ;
put '/ ;' / / ;
$EndiF.WriteNDBundles

***HRR: adjust to avoid error with "|"
put 'set var "GDP variables" /' / ;
loop(var,
   strlen = card(var.tl) ;
*   put '   ', var.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', var.te(var), '"' / ;
   put '   ' '"', var.te(var), '"' / ;
) ;
put '/ ;' / / ;

put 'set scen "Scenarios" /' / ;
loop(scen,
   strlen = card(scen.tl) ;
   put '   ', scen.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', scen.te(scen), '"' / ;
) ;
put '/ ;' / / ;

put 'set ssp(scen) "SSP Scenarios" /' / ;
loop(scen$ssp(scen),
   strlen = card(scen.tl) ;
   put '   ', scen.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', scen.te(scen), '"' / ;
) ;
put '/ ;' / / ;

put 'set mod "Models" /' / ;
loop(mod,
   strlen = card(mod.tl) ;
   put '   ', mod.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', mod.te(mod), '"' / ;
) ;
put '/ ;' / / ;

put 'set tranche "Population cohorts" /' / ;
loop(tranche,
   strlen = card(tranche.tl) ;
   put '   ', tranche.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', tranche.te(tranche), '"' / ;
) ;
put '/ ;' / / ;

put 'set trs(tranche) "Population cohorts" /' / ;
loop(tranche$trs(tranche),
   strlen = card(tranche.tl) ;
   put '   ', tranche.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', tranche.te(tranche), '"' / ;
) ;
put '/ ;' / / ;

***HRR: need to change to be consistent with new SSP file (subs "sex" with "gender")
put 'set gender   "Gender categories" /' / ;
loop(gender,
   strlen = card(gender.tl) ;
   put '   ', gender.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', gender.te(gender), '"' / ;
) ;
put '/ ;' / / ;

put 'set sex(gender) "Gender categories excl total" /' / ;
loop(gender$sex(gender),
   strlen = card(gender.tl) ;
   put '   ', gender.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', gender.te(gender), '"' / ;
) ;
put '/ ;' / / ;
***endHRR

put 'set ed "Combined SSP/GIDD education levels" /' / ;
loop(edj,
   strlen = card(edj.tl) ;
   put '   ', edj.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', edj.te(edj), '"' / ;
) ;
put '/ ;' / / ;

put 'set edx(ed) "Education levels excluding totals" /' / ;
loop(edj$(not sameas("elevt", edj)),
   strlen = card(edj.tl) ;
   put '   ', edj.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', edj.te(edj), '"' / ;
) ;
put '/ ;' / / ;

*  Initialize carbon coalitions

put 'set rq(ra) "Regions submitted to an emissions cap" ;' / ;
put 'rq(ra) = no ;' / / ;

*  Labor growth assumptions

put 'set nsk(l) "Unskilled types for labor growth assumptions" /' / /;
loop(l$(not skl(l)),
   put '   ', l.tl:<MaxStrLen, '     "', l.te(l), '"' / ;
) ;
put '/ ;' / / ;

put 'set skl(l)  "Skill types for labor growth assumptions" /' / /;
loop(l$skl(l),
   put '   ', l.tl:<MaxStrLen, '     "', l.te(l), '"' / ;
) ;
put '/ ;' / / ;

put 'set educMap(r,l,edx) "Mapping of skills to education levels" /' / ;
loop(educMap(r,l,elev),
   strlen = card(r.tl) ;
   put '   ', r.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', l.tl:<MaxStrLen, '.', elev.tl / ;
) ;
put '/ ;' / / ;
