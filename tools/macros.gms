$OnText
--------------------------------------------------------------------------------
                OECD Modellling Projects
   GAMS file    : "tools\macros.gms"
   purpose      : Define various time sets from a given definition of time
                  like %1 = {t,tt,...}
   Created by   : Jean Chateau
   Created date : 03 Novembre 2022
   called by    : Any programs that need these macros
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/macros.gms $
   last changed revision: $Rev: 441 $
   last changed date    : $Date:: 2023-10-05 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Warning for some macros load first "CommonDir\CommonTools\time_sets.gms"
--------------------------------------------------------------------------------
$OffText

* Calculate Growth Rate

$macro m_g(x,arg,t)      {[x(&&arg,t) / x(&&arg,t-1) - 1]${x(&&arg,t-1)} + 0}
$macro m_gr(x,arg,t1,t2) [ (x(&&arg,t2) / x(&&arg,t1))**(1/tCount("t1","t2")) - 1]${x(&&arg,t-1)} + 0}

* in percentage

$macro m_gpct(x,arg,t)   {100 * [x(&&arg,t) / x(&&arg,t-1) - 1]${x(&&arg,t-1)} + 0}

* Interpolation macros

* Memo: time period between t1 (not included) and t2 (included)

$macro m_InterpLinear(x,arg,t,t1,t2)                                          \
    x(&&arg,t) $ between2(t,"t1","t2") = x(&&arg,"t1")                        \
    + [x(&&arg,"t2") - x(&&arg,"t1")] * [(t.val - t1) / tCount("t1","t2")] ;  \

$macro m_InterpExpon(x,arg,t,t1,t2)                                           \
    x(&&arg,t) $ [between2(t,"t1","t2") and x(&&arg,"t1")] = x(&&arg,"t1")    \
    * [x(&&arg,"t2") / x(&&arg,"t1")] ** [(t.val - t1) / tCount("t1","t2")] ; \

$OnText
LOOP(t$(t.val gt 2040 and t.val le 2050),
    work = (t.val - 2040) / (2050 - 2040);
    Xvar("fra",a,t)
        = Xvar("fra",a,"2040") * (1 - work)
        + Xvar("fra",a,"2050") * work;
);
m_InterpLinear(Xvar,'"fra",a',t,2000,2040)

m_InterpLinear(PIB.l,'"AUS"',t,2014,2030) ;
    -->
PIB.l("AUS",t) $ between2(t,"2014","2030") = PIB.l("AUS","2014")
                  + [PIB.l("AUS","2030") - PIB.l("AUS","2014")] * [(t.val - 2014
      ) / tCount("2014","2030")] ;

m_lin_extr(damweights_LAP,'CHN,"He_Exp"',t,2010,2015)

$OffText
* copy explanatory text from complete set into new subset (avoids duplicating explanatory text writing)
$macro m_copyExplanatoryText(newSubset,completeSet) newSubset(completeSet) = completeSet(completeSet) * newSubset(completeSet);

$macro m_interruptExecution(message)  \
display "*-----------------------*" ; \
display "* INTERRUPTED EXECUTION *" ; \
display message                     ; \
display "*-----------------------*" ; \
execute_unload "%Folderoutputs%\%OUTFILENAME%_interrupted.gdx";\
abort "m_interruptExecution interrupted the execution in %system.incname%";

$macro m_mapAssign( old , new , map ) loop( map , new = old)
$macro m_mapAssign2( old , new , map1 , map2 ) loop( map2 , m_mapAssign( old , new , map1 ))

$macro m_putSetInCreateSet(currentSet)                                              \
    put 'set currentSet "', currentSet.ts,'" /' /;                                  \
    loop(currentSet,                                                                \
        put '    ', currentSet.tl:<MaxStrLen,'"', currentSet.te(currentSet), '"' /; \
    ); put '/ ;' / /;                                                               \

* Same macro but with precision about the parent set
* Plus more compact writing with singleton

*   For ENV-L

$macro m_putSet_withSubset(currentSet,parent_set) \
    IF(card(currentSet) gt 1, \
        put 'set currentSet(parent_set)  "', currentSet.ts,'" /' /; \
        loop(currentSet, \
            put '    ', currentSet.tl:<MaxStrLen,'"', currentSet.te(currentSet), '"' /; \
        ); \
        put '/;'  /; \
    );\
    ELSE                                                                               \
        put 'set currentSet(parent_set)  "', currentSet.ts,'" /' ;                     \
        loop(currentSet,                                                               \
            put '    ', currentSet.tl:<MaxStrLen,'"', currentSet.te(currentSet), '"' ; \
        );                                                                             \
        put '/;'  /;                                                                   \
    );\

* For OECD-ENV: macro to create sets with -a or -c after name of the element

$macro m_putSet_withSubseta(currentSet,ParentSet)               \
    put 'set currentSet(ParentSet)  "', currentSet.ts,'" /' ;   \
    IF(card(currentSet) gt 1, put /; );                         \
    LOOP(currentSet,                                            \
        strlen = card(currentSet.tl) ;                          \
        put '    ', currentSet.tl:<strlen, '-a', ' ':(MaxStrLen-(strlen+2)+5), '"', currentSet.te(currentSet), '"' ; \
        IF(card(currentSet) gt 1, put /; );                     \
    ); put ' / ;'  /;                                           \

$macro m_putSet_withSubseti(currentSet,ParentSet)               \
    put 'set currentSet(ParentSet)  "', currentSet.ts,'" /' ;   \
    IF(card(currentSet) gt 1, put /; );                         \
    LOOP(currentSet,                                            \
        strlen = card(currentSet.tl) ;                          \
        put '    ', currentSet.tl:<strlen, '-c', ' ':(MaxStrLen-(strlen+2)+5), '"', currentSet.te(currentSet), '"' ; \
        IF(card(currentSet) gt 1, put /; );                     \
    ); put ' / ;'  /;                                             \

$macro m_writeExcel2D(input,i1,i2,fileName)\
parameter temp1(i1,i2);\
variable  temp2(i1,i2);\
temp1(i1,i2) = input(i1,i2);\
temp1(i1,i2)$(not temp1(i1,i2)) = eps;\
Execute_Unload '%Foldertmp%\fileName.gdx',temp1;\
Execute 'GDXXRW.EXE %Foldertmp%\fileName.gdx EpsOut =0 par =temp1' ;




