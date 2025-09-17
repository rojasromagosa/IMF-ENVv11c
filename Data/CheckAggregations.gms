$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] Model :  Aggregation Procedure
    GAMS file : %DataDir%\CheckAggregations.gms"
    purpose   : Check the consistency of model aggregation with GTAP aggregation
    created by: Dominique van der Mensbrugghe for [ENVISAGE]
                modified by Jean Chateau for [OECD-ENV]
    called by : "%DataDir%\AggGTAP.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/CheckAggregations.gms $
   last changed revision: $Rev: 368 $
   last changed date    : $Date:: 2023-08-17 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText


parameters
   r0Flag(r0)
   rFlag(r)
   a0Flag(a0)
   aFlag(a)

   i0Flag(a0)
   iFlag(a)
*   a0Flag(a0)
*   aFlag(a)
*   i0Flag(i0)
*   iFlag(i)

   fpFlag(fp)
   fp0Flag(fp0)
   total

*   elyaFlag(elya)

   ifCheck        / 1 /
   ifFirst        / 1 /
;

r0Flag(r0) = sum(mapr(r0,r), 1);
loop(r0,
   IF(r0Flag(r0) ne 1,
      put screen;
      IF(ifFirst eq 1,
         ifFirst = 0;
         ifCheck = 0;
         put "The following GTAP region(s) have not been mapped:" /;
      );
      put r0.tl:<10, "     ", r0.te(r0) /;
   );
);

put screen; put /;

ifFirst = 1;
rFlag(r) = sum(mapr(r0,r), 1);
loop(r,
   IF(rFlag(r) eq 0,
      put screen;
      IF(ifFirst eq 1,
         ifFirst = 0;
         ifCheck = 0;
         put "The following MODEL region(s) have no GTAP regions mapped to them:" /;
      );
      put r.tl:<10, "     ", r.te(r) /;
   );
);


*ifCheck = 1;
ifFirst = 1;

*a0Flag(i0) = sum(mapa(i0,i), 1) ;
i0Flag(i0) = sum(mapa(i0,i), 1) ;

i0Flag("total")    = 1 ;
$$IFi %ifPower%=="ON" i0Flag("ELY") = 1 ;

$IfTheni.BuildScen %BuildScenarioInAgg%=="ONE"
    i0Flag("Hydrogen")    = 1 ;
    i0Flag("Heat")        = 1 ;
    i0Flag("Electricity") = 1 ;
    i0Flag("Biomass")     = 1 ;
    i0Flag("BioFuel")     = 1 ;
    i0Flag("Biogas")      = 1 ;
    i0Flag("Waste")       = 1 ;
$Endif.BuildScen

loop(i0,
   IF(i0Flag(i0) eq 0,
      put screen;
      IF(ifFirst eq 1,
         ifFirst = 0;
         ifCheck = 0;
         put "The following GTAP commodity(s) have not been mapped:" /;
      );
      put i0.tl:<10, "     ", i0.te(i0) /;
   );
);

put screen; put /;

ifFirst = 1;
iFlag(i) = sum(mapa(i0,i), 1) ;

*  Do not account "ely" which is not mapped with i0

iFlag(tmpely) = 1 ;

loop(i,
   IF(iFlag(i) eq 0,
      put screen;
      IF(ifFirst eq 1,
         ifFirst = 0;
         ifCheck = 0;
         put "The following Model commodity(s) have no GTAP sectors mapped to them:" /;
      );
      put i.tl:<10, "     ", i.te(i) /;
   );
);

$OnText
a0Flag(a0) = sum(mapa(a0,a), 1);
a0Flag("total")       = 1;
a0Flag("PetFeedStock")   = 1;
a0Flag("BlastCokeOvens") = 1;
a0Flag("TRANSFER")       = 1;

loop(a0 $ (not CGDS(a0) and not hh0(a0)),
   IF(a0Flag(a0) ne 1,
      put screen;
      IF(ifFirst eq 1,
         ifFirst = 0;
         ifCheck = 0;
         put "The following GTAP activity(ies) have not been mapped:" /;
      );
      put a0.tl:<10, "     ", a0.te(a0) /;
   );
);

put screen; put /;

ifFirst = 1;
aFlag(a) = sum(mapa(a0,a), 1);
loop(a,
   IF(aFlag(a) eq 0,
      put screen;
      IF(ifFirst eq 1,
         ifFirst = 0;
         ifCheck = 0;
         put "The following Model activity(ies) have no GTAP activities mapped to them:" /;
      );
      put a.tl:<10, "     ", a.te(a) /;
   );
);
$OffText

*   Factor mapping

fp0Flag(fp0) = sum(mapf(fp0,fp), 1) ;
loop(fp0,
   IF(fp0Flag(fp0) ne 1,
      put screen ;
      IF(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following GTAP factor(s) have not been mapped:" / ;
      ) ;
      put fp0.tl:<10, "     ", fp0.te(fp0) / ;
   ) ;
) ;

put screen ; put / ;

ifFirst = 1 ;
fpFlag(fp) = sum(mapf(fp0,fp), 1) ;
loop(fp,
   IF(fpFlag(fp) eq 0,
      put screen ;
      IF(ifFirst eq 1,
         ifFirst = 0 ;
         ifCheck = 0 ;
         put "The following aggregate factor(s) have no GTAP factors mapped to them:" / ;
      ) ;
      put fp.tl:<10, "     ", fp.te(fp) / ;
   ) ;
) ;

put screen ; put / ;


*  Check the energy mapping -- we can have empty energy bundles
* Not in Dominique
ifFirst = 1;

$OnText
Parameter eFlag(e);
eFlag(e) = sum(mape(NRG,e), 1);
loop(e,
   IF(eFlag(e) ne 1,
      put screen;
      IF(ifFirst eq 1,
         ifFirst = 0;
         ifCheck = 0;
         put "The following energy activity(ies) have not been mapped:" /;
      );
      put e.tl:<10, "     ", e.te(e) /;
   );
);
$OffText

put screen; put /;


*---     UN countries mapping [TBU]
$OnText
PARAMETER cFlag(c)    "UN country mapping"

cFlag(c) = sum(mapc(c,r0), 1);
loop(c,
   IF(cFlag(c) ne 1,
      put screen;
      IF(ifFirst eq 1,
         ifFirst = 0;
         ifCheck = 0;
         put "The following UN country(ies) have not been mapped:" /;
      );
      put c.tl:<10, "     ", c.te(c) /;
   );
);

put screen; put /;

ifFirst = 1;
r0Flag(r0) = sum(mapc(c,r0), 1);
loop(r0$(not xtw0(r0)),
   IF(r0Flag(r0) eq 0,
      put screen;
      IF(ifFirst eq 1,
         ifFirst = 0;
         ifCheck = 0;
         put "The following GTAP region(s) have no UN countries mapped to them:" /;
      );
      put r0.tl:<10, "     ", r0.te(r0) /;
   );
);
$OffText
abort$(ifCheck eq 0) "Invalid aggregation bridge";

put screen;
put "All mappings have passed standard checks..." / /;

putclose screen;



