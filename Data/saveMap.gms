*---    [EditJean]: change dir where this is stored
$iftheni "%SAVEMAP%" == "TXT"
file mapfile / %DirCheck%\%Prefix%Sets.txt / ;
$elseifi   "%SAVEMAP%" == "LATEX"
file mapfile / %DirCheck%\%Prefix%Sets.tex / ;
$endif

put mapfile ;
mapfile.pw=10000 ;

*  Output the regional dimensions

$iftheni  "%SAVEMAP%" == "LATEX"

*  Latex preamble

put "\begin{table}[ht]" / ;
put "\caption{Regional concordance}" / ;
put "\label{tab:RegConcord}" / ;
put "\begin{center}" / ;
put "\footnotesize" / ;
put "\begin{tabular}{p{0.5cm} p{4.0cm} p{10.0cm}}" / ;

$endif

order = 0 ;
loop(mapRegsort(sortOrder,r),
   order = order + 1 ;
   ifFirst = 1 ;
   $$iftheni "%SAVEMAP%" == "TXT"
      put order:0:0, ',"', r.te(r):card(r.te), ' (', r.tl:card(r.tl),')",' ;
   $$elseifi "%SAVEMAP%" == "LATEX"
      put order:0:0, ' & ', r.te(r):card(r.te), ' (', r.tl:card(r.tl),') & ' ;
   $$endif
   loop(mapr(r0,r),
      IF(ifFirst,
         $$iftheni "%SAVEMAP%" == "TXT"
            put '"', r0.te(r0):card(r0.te), ' (', r0.tl:card(r0.tl), ')' ;
            ifFirst = 0 ;
         $$elseifi "%SAVEMAP%" == "LATEX"
            put r0.te(r0):card(r0.te), ' (', r0.tl:card(r0.tl), ')' ;
            ifFirst = 0 ;
         $$endif
      else
         put ', ', r0.te(r0):card(r0.te), ' (', r0.tl:card(r0.tl), ')' ;
      ) ;
   ) ;
   $$iftheni "%SAVEMAP%" == "TXT"
      put '"' / ;
   $$elseifi "%SAVEMAP%" == "LATEX"
      put ' \\' / ;
   $$endif
) ;

$iftheni  "%SAVEMAP%" == "LATEX"

*  Latex closure

put "\end{tabular}" / ;
put "\end{center}" / ;
put "\end{table}" / ;

$endif

put / ;

*  Output the concordance for activities

$iftheni  "%SAVEMAP%" == "LATEX"

*  Latex preamble

put "\begin{table}[ht]" / ;
put "\caption{Concordance for activities}" / ;
put "\label{tab:ActConcord}" / ;
put "\begin{center}" / ;
put "\footnotesize" / ;
put "\begin{tabular}{p{0.5cm} p{4.0cm} p{10.0cm}}" / ;

$endif

order = 0 ;

scalar order ; order = 0 ;
loop(mapActsort(sortOrder,actf),
   order = order + 1 ;
   ifFirst = 1 ;
   $$iftheni "%SAVEMAP%" == "TXT"
      put order:0:0, ',"', actf.te(actf):card(actf.te), ' (', actf.tl:card(actf.tl),')",' ;
   $$elseifi "%SAVEMAP%" == "LATEX"
      put order:0:0, ' & ', actf.te(actf):card(actf.te), ' (', actf.tl:card(actf.tl),') & ' ;
   $$endif
   loop(mapaf(i,actf),
      loop(mapa(i0,i),
         IF(ifFirst,
            $$iftheni "%SAVEMAP%" == "TXT"
               put '"', i0.te(i0):card(i0.te), ' (', i0.tl:card(i0.tl), ')' ;
               ifFirst = 0 ;
            $$elseifi "%SAVEMAP%" == "LATEX"
               put i0.te(i0):card(i0.te), ' (', i0.tl:card(i0.tl), ')' ;
               ifFirst = 0 ;
            $$endif
         else
            put ', ', i0.te(i0):card(i0.te), ' (', i0.tl:card(i0.tl), ')' ;
         ) ;
      ) ;
   ) ;
   $$iftheni "%SAVEMAP%" == "TXT"
      put '"' / ;
   $$elseifi "%SAVEMAP%" == "LATEX"
      put ' \\' / ;
   $$endif
) ;

$iftheni  "%SAVEMAP%" == "LATEX"

*  Latex closure

put "\end{tabular}" / ;
put "\end{center}" / ;
put "\end{table}" / ;

$endif

put / ;

*  Output the concordance for commodities

$iftheni  "%SAVEMAP%" == "LATEX"

*  Latex preamble

put "\begin{table}[ht]" / ;
put "\caption{Concordance for commodities}" / ;
put "\label{tab:CommConcord}" / ;
put "\begin{center}" / ;
put "\footnotesize" / ;
put "\begin{tabular}{p{0.5cm} p{4.0cm} p{10.0cm}}" / ;

$endif

order = 0 ;

scalar order ; order = 0 ;
loop(mapCommsort(sortOrder,commf),
   order = order + 1 ;
   ifFirst = 1 ;
   $$iftheni "%SAVEMAP%" == "TXT"
      put order:0:0, ',"', commf.te(commf):card(commf.te), ' (', commf.tl:card(commf.tl),')",' ;
   $$elseifi "%SAVEMAP%" == "LATEX"
      put order:0:0, ' & ', commf.te(commf):card(commf.te), ' (', commf.tl:card(commf.tl),') & ' ;
   $$endif
   loop(mapIF(i,commf),
      loop(mapa(i0,i),
         IF(ifFirst,
            $$iftheni "%SAVEMAP%" == "TXT"
               put '"', i0.te(i0):card(i0.te), ' (', i0.tl:card(i0.tl), ')' ;
               ifFirst = 0 ;
            $$elseifi "%SAVEMAP%" == "LATEX"
               put i0.te(i0):card(i0.te), ' (', i0.tl:card(i0.tl), ')' ;
               ifFirst = 0 ;
            $$endif
         else
            put ', ', i0.te(i0):card(i0.te), ' (', i0.tl:card(i0.tl), ')' ;
         ) ;
      ) ;
   ) ;
   $$iftheni "%SAVEMAP%" == "TXT"
      put '"' / ;
   $$elseifi "%SAVEMAP%" == "LATEX"
      put ' \\' / ;
   $$endif
) ;

$iftheni  "%SAVEMAP%" == "LATEX"

*  Latex closure

put "\end{tabular}" / ;
put "\end{center}" / ;
put "\end{table}" / ;

$endif
