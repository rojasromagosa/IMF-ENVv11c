$OnText
--------------------------------------------------------------------------------
   Envisage 10 / OECD-ENV project  -- Data preparation modules
	GAMS file   : "%DataDir%\makeset.gms"
    purpose     : Create 'dimension' file for all models
    created by  : Dominique van der Mensbrugghe
    created date: 21.10.16
    called by   : "%DataDir%\AggGTAP.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/makeset.gms $
   last changed revision: $Rev: 394 $
   last changed date    : $Date:: 2023-09-11 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
*  The code herein is valid for Altertax, GTAP, Envisage and OECD-ENV
* ----------------------------------------------------------------------------------------
$OffText

$setlocal CallingFile "%1"

put '$onempty' / / ;

SCALARS strlen, MaxStrLen, maxcol1 ;

MaxStrLen = smax(a, card(a.tl))+2 ;
MaxStrLen = max(MaxStrLen, smax(i, card(i.tl))+2) ;
MaxStrLen = max(MaxStrLen, smax(fp, card(fp.tl))) ;
MaxStrLen = max(MaxStrLen, smax(r, card(r.tl))) ;
MaxStrLen = max(MaxStrLen, smax(stdlab, card(stdlab.tl))) ;

put 'set a0 "Original activities (included cgds)" /' / ;

* [OECD-ENV]: do not report tmpely(a) because "ely" is a working set element

loop(a $ (not tmpely(a)) ,
    put '   ', a.tl:<MaxStrLen, '     "', a.te(a), '"' / ;
) ;
put '/ ;' / / ;

loop(a $ cgds(a),
    put 'set cgds0(a0) "CGDS activity" / ', a.tl:<card(a.tl), ' / ;' / / ;
) ;

put 'set i0(a0) "Original commodities" /' / ;
loop(i $ (not tmpely(i)),
    put '   ', i.tl:<MaxStrLen, '     "', i.te(i), '"' / ;
) ;
put '/ ;' / / ;

put '* --------------------------------------------------------------------' / ;
put '*' / ;
put '*   USER CAN MODIFY ACTIVITY/COMMODITY AGGREGATION' / ;
put '*   USER MUST FILL IN SUBSETS WHERE NEEDED' / ;
put '*' / ;
put '* --------------------------------------------------------------------' / /;


put / '* >>>> PLACE TO CHANGE ACTIVITIES, i.e. model activities' / / ;

put 'set act "Modeled activities" /' / ;

$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
*  AlterTax assumes diagonality
   loop(a$(not cgds(a)),
      strlen = card(a.tl) ;
      put '   ', a.tl:<strlen, '-a', '':(MaxStrLen-strlen-2), '     "', a.te(a), '"' / ;
   ) ;
$Else.CaseAlterTax
    MaxStrLen = max(MaxStrLen, smax(actf, card(actf.tl))+2);
    MaxStrLen = max(MaxStrLen, smax(commf, card(commf.tl))+2);
*  Use the model aggregation
    loop(mapActSort(sortOrder,actf),
        strlen = card(actf.tl) ;
        put '   ', actf.tl:<strlen, '-a', '':(MaxStrLen-strlen-2), '     "', actf.te(actf), '"' / ;
    );
$EndiF.CaseAlterTax

put '/ ;' / / ;

put '* >>>> PLACE TO CHANGE COMMODITIES, i.e. model commodities' / / ;

put 'set comm "Modeled commodities" /' / ;
$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
*  AlterTax assumes diagonality
    loop(i,
        strlen = card(i.tl) ;
        put '   ', i.tl:<strlen, '-c', '':(MaxStrLen-strlen-2), '     "', i.te(i), '"' / ;
    ) ;
$Else.CaseAlterTax
*  Use the model aggregation
    loop(mapCommSort(sortOrder,commf),
        strlen = card(commf.tl) ;
        put '   ', commf.tl:<strlen, '-c', '':(MaxStrLen-strlen-2), '     "', commf.te(commf), '"' / ;
    ) ;
$EndiF.CaseAlterTax
put '/ ;' / / ;

put 'set endw "Modeled production factors" /' / ;
loop(fp$((ifWater=OFF and not Wat(fp)) or ifWater=ON),
   put '   ', fp.tl:<MaxStrLen, '     "', fp.te(fp), '"' / ;
) ;
put '/ ;' / / ;

*---    These sets have been defined in "SetsGTAP.gms"
put 'set stdlab "Standard SAM labels" /' / ;
loop(stdlab,
   put '   ', stdlab.tl:<MaxStrLen, '     "', stdlab.te(stdlab), '"' / ;
) ;
put '/ ;' / / ;

put 'set findem(stdlab) "Final demand accounts" /' / ;
loop(stdlab$fd(stdlab),
   put '   ', stdlab.tl:<MaxStrLen, '     "', stdlab.te(stdlab), '"' / ;
) ;
put '/ ;' / / ;

put 'set reg "Modeled regions" /' / ;
loop(mapRegSort(sortOrder,r),
   put '   ', r.tl:<MaxStrLen, '     "', r.te(r), '"' / ;
) ;
put '/ ;' / / ;

put 'set is "SAM accounts for aggregated SAM" /' / /;
put '*  User-defined activities' / /;
put '   set.act' / /;
put '*  User-defined commodities' / /;
put '   set.comm' /  /;
put '*  User-defined factors' / /;
put '   set.endw' / /;
put '*  Standard SAM accounts' / /;
put '   set.stdlab' / / ;
put '*  User-defined regions'  / /;
put '   set.reg' /  ;
put '/ ;' / / ;

put 'alias(is, js) ;' / / ;

*   [EditJean]: add total categories: "TotEly"

put 'set aa(is) "Armington agents" /' / ;
put '   set.act'  / ;
put '   set.findem'  / ;
$IFi %IfAddTotalSets%=="ON" put '   TotEly' /  ;
$IFi %IfAddTotalSets%=="ON" put '   tot' /  ;
put '/ ;' / / ;

put 'set a(aa) "Activities"  /' / ;
put '   set.act'  / ;
$IFi %IfAddTotalSets%=="ON" put '   TotEly' /  ;
$IFi %IfAddTotalSets%=="ON" put '   tot' /  ;
put '/ ;' / / ;

put 'set i(is) "Commodities" / set.comm /;'            / / ;
put 'set fp(is) "Factors of production" / set.endw /;' / / ;
put 'alias(i, j) ;'                                    / / ;

put 'set l(fp) "Labor factors" /'  /;
loop(fp$l(fp),
   put '   ', fp.tl:<MaxStrLen, '     "', fp.te(fp), '"' / ;
) ;
put '/ ;' / / ;

put 'set ul(l) "Unskilled labor" /'  /;
loop(l$ul(l),
   put '   ', l.tl:<MaxStrLen, '     "', l.te(l), '"' / ;
) ;
put '/ ;' / / ;

put 'set sl(l) "Skilled labor" /' / ;
loop(l $ (not ul(l)),
    put '   ', l.tl:<MaxStrLen, '     "', l.te(l), '"' / ;
) ;
put '/ ;' / / ;

put 'set lr(l) "Reference labor for skill premium" /' / ;
loop(l $ lr(l),
    put '   ', l.tl:<MaxStrLen, '     "', l.te(l), '"' / ;
) ;
put '/ ;' / / ;

put 'set cap(fp) "Capital" /' / ;
loop(fp $ cap(fp),
    put '   ', fp.tl:<MaxStrLen, '     "', fp.te(fp), '"' / ;
) ;
put '/ ;' / / ;

put 'set lnd(fp) "Land endowment" /' / ;
loop(fp $ lnd(fp),
    put '   ', fp.tl:<MaxStrLen, '     "', fp.te(fp), '"' / ;
) ;
put '/ ;' / / ;

put 'set nrs(fp) "Natural resource" /' /;
loop(fp $ nrs(fp),
   put '   ', fp.tl:<MaxStrLen, '     "', fp.te(fp), '"' / ;
) ;
put '/ ;' / / ;

$IfTheni.CaseENVModel %CallingFile%=="ENV"
    put 'set wat(fp) "Water resource" /' / /;
    loop(fp$wat(fp),
        put '   ', fp.tl:<MaxStrLen, '     "', fp.te(fp), '"' / ;
    ) ;
    put '/ ;' / / ;
$EndIf.CaseENVModel

put '* >>>> CAN MODIFY MOBILE VS. NON-MOBILE FACTORS' / / ;

put 'set fm(fp) "Mobile factors" /' / / ;

loop(fp,
   put '   ', fp.tl:<MaxStrLen, '     "', fp.te(fp), '"' / ;
) ;
put '/ ;' / / ;

put 'set fnm(fp) "Non-mobile factors" /' / / ;

put '/ ;' / / ;

put 'set fd(aa) "Domestic final demand agents" /' /  ;
$IfTheni.CaseENVModel %CallingFile%=="ENV"
   loop(fd $ (not tmg(fd)),
      put '   ', fd.tl:<MaxStrLen, '     "', fd.te(fd), '"' / ;
   ) ;
$Else.CaseENVModel
   put '   set.findem' / / ;
$EndIf.CaseENVModel
put '/ ;' / / ;

put 'set h(fd) "Households" /' / ;
loop(fd$h(fd),
   put '   ', fd.tl:<MaxStrLen, '     "', fd.te(fd), '"' / ;
) ;
put '/ ;' / / ;

put 'set gov(fd) "Government" /' / ;
loop(fd $ gov(fd),
   put '   ', fd.tl:<MaxStrLen, '     "', fd.te(fd), '"' / ;
) ;
put '/ ;' / / ;

put 'set inv(fd) "Investment" /' / ;
loop(fd $ inv(fd),
   put '   ', fd.tl:<MaxStrLen, '     "', fd.te(fd), '"' / ;
) ;
put '/ ;' / / ;

put 'singleton set r_d(fd) "R & D expenditures" /' / ;
loop(fd $ r_d(fd),
   put '   ', fd.tl:<MaxStrLen, '     "', fd.te(fd), '"' / ;
) ;
put '/ ;' / / ;

put 'set fdc(fd) "Final demand accounts with CES expenditure function" /' / ;
loop(fd $ (gov(fd) or inv(fd) or r_d(fd)),
   put '   ', fd.tl:<MaxStrLen, '     "', fd.te(fd), '"' / ;
) ;
put '/ ;' / / ;

$IfTheni.CaseOtherModel NOT %CallingFile%=="ENV"
    put 'set tmg(fd) "Domestic supply of trade margins services" /' / ;
    loop(fd$tmg(fd),
        put '   ', fd.tl:<MaxStrLen, '     "', fd.te(fd), '"' / ;
    ) ;
    put '/ ;' / / ;
$EndIf.CaseOtherModel

put 'set r(is) "Regions" / set.reg / ; ' / /;

put 'alias(r,rp) ; alias(r,s) ; alias(r,d) ;' / / ;

put '* >>>> MUST INSERT RESIDUAL REGION (ONLY ONE)' / / ;

put 'set rres(r) "Residual region" /' / ;
loop(r$rres(r),
   put '   ', r.tl:<MaxStrLen, '     "', r.te(r), '"' / ;
) ;
put '/ ;' / / ;

put '* >>>> MUST INSERT MUV REGIONS (ONE OR MORE)' / / ;

put 'set rmuv(r) "MUV regions" /' / ;
loop(r$rmuv(r),
   put '   ', r.tl:<MaxStrLen, '     "', r.te(r), '"' / ;
) ;
put '/ ;' / / ;

put '* >>>> MUST INSERT MUV COMMODITIES (ONE OR MORE)' / / ;

put 'set imuv(i) "MUV commodities" /' / ;
$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
*  Make all commodities MUV
   put '   set.comm' / / ;
$Else.CaseAlterTax
   loop(commf$imuvf(commf),
      strlen = card(commf.tl) ;
      put '   ', commf.tl:<strlen, '-c' / ;
   ) ;
$EndiF.CaseAlterTax
put '/ ;' / / ;

*  Emission sets for AlterTax: [TBU]
$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
    put 'set em "Emissions" /' / ;
    loop(em,
        put '   ', em.tl:<MaxStrLen, '     "', em.te(em), '"' / ;
    ) ;
    put '/ ;' / / ;

    put 'set emn(em) "Non-CO2 emissions" /' / ;
    loop(em$emn(em),
        put '   ', em.tl:<MaxStrLen, '     "', em.te(em), '"' / ;
    ) ;
    put '/ ;' / / ;

    put 'alias(emn, nco2) ;' / / ;
$EndiF.CaseAlterTax

*  Aggregation sets

* [EditJean]: ia and ra sets could be with space characters
* [EditJean]: add other-c and other-a for aggregation in auxi files

put 'set ia "Aggregate commodities for model output" /' / ;
$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"

    strlen = 5 ;
    put '   ', 'Total':<strlen, ' ':(MaxStrLen-(strlen)+5), '"Aggregation of all commodities"' / ;

$Else.CaseAlterTax

    parameter LengthStringia(ia);
    LengthStringia(ia) = card(ia.tl);
    loop(commf,
        strlen = card(commf.tl) ;
        put '   ', commf.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+5), '"', commf.te(commf), '"' / ;
    ) ;
    put / ;

    put '*   Aggregate Commodities' / ;

    loop(ia,
        strlen = card(ia.tl) ;
        put '   "', ia.tl:<LengthStringia(ia), '"   ', '"', ia.te(ia), '"' / ;
    ) ;
    put '   "other-c"  "Other goods"' /;

$EndiF.CaseAlterTax
put '/ ;' / / ;

$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"

    put 'set mapi(ia,i) "Mapping for aggregate commodities" ;' / ;
    put 'mapi("Total",i) = yes ; mapi("Total","other-c")=NO;' / / ;

$Else.CaseAlterTax

    put 'set mapi(ia,i) "Mapping for aggregate commodities" /' / ;
    loop(commf,
        strlen = card(commf.tl) ;
        put '   ', commf.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+1), '.', commf.tl:card(commf.tl), '-c' / ;
    );
    put / ;
    loop(mapia(ia,commf),
        strlen = card(ia.tl) ;
        put '   "', ia.tl:<LengthStringia(ia), '".', commf.tl:card(commf.tl), '-c' / ;
    );
    put '/ ;' / / ;

$EndiF.CaseAlterTax

$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
*   strlen = 5 ;
*   put '   ', 'Total':<strlen, ' ':(MaxStrLen-(strlen)+5), '"Aggregation of all activities"' / ;
$Else.CaseAlterTax
    put 'set aga "Aggregate activities for model output" /' / ;
    parameter LengthStringaga(aga);
    LengthStringaga(aga) = card(aga.tl);
    loop(actf,
        strlen = card(actf.tl) ;
        put '   ', actf.tl:<strlen, '-a', ' ':(MaxStrLen-(strlen+2)+5), '"', actf.te(actf), '"' / ;
    ) ;
    put / /;

    put '*   Aggregate Sectors' / ;

    loop(aga,
        strlen = card(aga.tl) ;
        put '   "', aga.tl:<LengthStringaga(aga), '"    ', '"', aga.te(aga), '"' / ;
    ) ;
    put '    other-a    "Other sectors"' /;
    put '/ ;' / / ;
$EndiF.CaseAlterTax

$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"

*    put 'set mapaga(aga,a) "Mapping for aggregate activities" ;' / ;
*    put 'mapaga("Total",a) = yes ;' / / ;

$Else.CaseAlterTax

    put 'set mapaga(aga,a) "Mapping for aggregate activities" /' / ;
    loop(actf,
        strlen = card(actf.tl) ;
        put '   ', actf.tl:<strlen, '-a', ' ':(MaxStrLen-(strlen+2)+1), '.', actf.tl:card(actf.tl), '-a' / ;
    ) ;
    put / ;
    loop(mapaga(aga,actf),
        strlen = card(aga.tl) ;
        put '   "', aga.tl:<LengthStringaga(aga), '".', actf.tl:card(actf.tl), '-a' / ;
    ) ;
    put '/ ;' / / ;

    put 'set ra "Aggregate regions for emission regimes and model output" /' / ;
    loop(r,
        strlen = card(r.tl) ;
        put '   ', r.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', r.te(r), '"' / ;
    ) ;
    put / ;
    loop(ra,
        strlen = card(ra.tl) ;
        put '   ', ra.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', ra.te(ra), '"' / ;
    ) ;
    put '/ ;' / / ;

    put 'set mapr(ra,r) "Mapping for aggregate regions" /' / ;
    loop(r,
        strlen = card(r.tl) ;
        put '   ', r.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', r.tl:card(r.tl) / ;
    ) ;
    put / ;
    loop(mapra(ra,r),
        strlen = card(ra.tl) ;
        put '   ', ra.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', r.tl:card(r.tl) / ;
    ) ;
    put '/ ;' / / ;

    put 'set lagg "Aggregate labor for output" /' / ;
    loop(l,
        strlen = card(l.tl) ;
        put '   ', l.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', l.te(l), '"' / ;
    ) ;
    put / ;
    loop(lagg,
        strlen = card(lagg.tl) ;
        put '   ', lagg.tl:<strlen, ' ':(MaxStrLen-(strlen)+5), '"', lagg.te(lagg), '"' / ;
    ) ;
    put '/ ;' / / ;

    put 'set mapl(lagg,l) "Mapping for aggregate regions" /' / ;
    loop(l,
        strlen = card(l.tl) ;
        put '   ', l.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', l.tl:card(l.tl) / ;
    ) ;
    put / ;
    loop(maplagg(lagg,l),
        strlen = card(lagg.tl) ;
        put '   ', lagg.tl:<strlen, ' ':(MaxStrLen-(strlen)+1), '.', l.tl:card(l.tl) / ;
    ) ;
    put '/ ;' / / ;
$EndiF.CaseAlterTax
put '* >>>> CAN CHANGE ACTIVITY MAPPING' / / ;

*  !!!! FOR ALTERTAX -- ONE-TO-ONE MAPPING

put 'set mapa0(a0, a) "Mapping from original activities to new activities" /' / ;
$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
    loop(a$(not cgds(a)),
        strlen = card(a.tl) ;
        put '   ', a.tl:<MaxStrLen, '.', a.tl:<strlen, '-a' / ;
    ) ;
$Else.CaseAlterTax
    loop(mapaf(i,actf),
        strlen = card(i.tl) ;
        put '   ', i.tl:<MaxStrLen, '.', actf.tl:<card(actf.tl), '-a' / ;
    ) ;
$EndiF.CaseAlterTax
put '/ ;' / / ;

put '* >>>> CAN CHANGE COMMODITY MAPPING' / / ;

*  !!!! FOR ALTERTAX -- ONE-TO-ONE MAPPING

put 'set mapi0(i0, i) "Mapping from original commodities to new commodities" /' / ;
$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
    loop(i,
        strlen = card(i.tl) ;
        put '   ', i.tl:<MaxStrLen, '.', i.tl:<strlen, '-c' / ;
    ) ;
$Else.CaseAlterTax
    loop(mapif(i,commf) $ (not tmpely(i)) ,
        strlen = card(i.tl) ;
        put '   ', i.tl:<MaxStrLen, '.', commf.tl:<card(commf.tl), '-c' / ;
    ) ;
$EndiF.CaseAlterTax
put '/ ;' / / ;

*  Create sort for SAM and other purposes

$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
   order = card(a)-1 + card(a)-1 + card(fp) + card(stdlab) + card(r) ;
$Else.CaseAlterTax
   order = card(actf) + card(commf) + card(fp) + card(stdlab) + card(r) ;
$EndiF.CaseAlterTax

put 'set sortOrder / sort1*sort', order:0:0, ' / ;' / / ;
put 'set mapOrder(sortOrder,is) / ' / ;
order = 0 ;

$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
*  AlterTax assumes diagonality and we'll forego putting a sort order for this
   loop(a$(not cgds(a)),
      order = order + 1 ;
      put 'sort', order:0:0, '.', a.tl:card(a.tl), '-a' / ;
   ) ;
$Else.CaseAlterTax
*  Use the model aggregation
   loop(mapActSort(sortOrder,actf),
      order = order + 1 ;
      put 'sort', order:0:0, '.', actf.tl:card(actf.tl), '-a' / ;
   ) ;
$EndiF.CaseAlterTax

$IfTheni.CaseAlterTax %CallingFile%=="AlterTax"
*  AlterTax assumes diagonality and we'll forego putting a sort order for this
   loop(a$(not cgds(a)),
      order = order + 1 ;
      put 'sort', order:0:0, '.', a.tl:card(a.tl), '-c' / ;
   ) ;
$Else.CaseAlterTax
*  Use the model aggregation
   loop(mapCommSort(sortOrder,commf),
      order = order + 1 ;
      put 'sort', order:0:0, '.', commf.tl:card(commf.tl), '-c' / ;
   ) ;
$EndiF.CaseAlterTax

loop(fp,
   order = order + 1 ;
   put 'sort', order:0:0, '.', fp.tl:card(fp.tl) / ;
) ;

loop(stdlab,
   order = order + 1 ;
   put 'sort', order:0:0, '.', stdlab.tl:card(stdlab.tl) / ;
) ;

loop(mapRegSort(sortOrder,r),
   order = order + 1 ;
   put 'sort', order:0:0, '.', r.tl:card(r.tl) / ;
) ;

put '/ ;' / / ;

$droplocal CallingFile
