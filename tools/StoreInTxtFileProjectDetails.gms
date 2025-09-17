$OnText
--------------------------------------------------------------------------------
        OECD-ENV Model version 1.0 - Data preparation modules
	GAMS file   : "%ToolsDir%\StoreInTxtFileProjectDetails.gms"
    purpose     : Create a file "a_ProjectDetails.txt" that contains description
                  of the aggregation.
    Created by  : Jean Chateau
    created Date: 2020-10-27
    called by   : "%DataDir%\AggGTAP.gms"
                  "%DataDir%\altertax.gms"
                  "%DataDir%\filter.gms"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/StoreInTxtFileProjectDetails.gms $
	last changed revision: $Rev: 444 $
	last changed date    : $Date:: 2023-10-06 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    The option of the batinclude to call this file will precise where the file
    "a_ProjectDetails" is modified
--------------------------------------------------------------------------------
$OffText

$setargs InFile

$SetGlobal OutFile "%ProjectDir%\a_ProjectDetails.txt"

*------------------------------------------------------------------------------*
*           Instructions called by "%DataDir%\AggGTAP.gms"                 *
*------------------------------------------------------------------------------*
$IfTheni.CallbyAggGTAP %InFile%=="AggGTAP"

* Re-create the file "a_ProjectDetails.txt" each time "AggGTAP.gms" is run

    $$call DEL "%OutFile%"

    $$IfThen.aggfile NOT EXIST "%OutFile%"

$onecho > "%OutFile%"
*------------------------------------------------------------------------------*
*       Value for global variables from AggGTAP.gms procedure                  *
*               Date of creation: %dateout%                                    *
*------------------------------------------------------------------------------*

*	Name of the project:

$SetGlobal BaseName          "%BaseName%"

*	Model used:

$SetGlobal model             "%model%"

*	GTAP Database version:

$SetGlobal GTAP_DBType       "%GTAP_DBType%"
$SetGlobal GTAP_ver          "%GTAP_ver%"
$SetGlobal YearGTAP          "%YearGTAP%"
$SetGlobal ifPower           "%IfPower%"
$SetGlobal ifWater           "%ifWater%"

*	Model Options:

$SetGlobal DYN               "%DYN%"
$SetGlobal NCO2              "%NCO2%"
$SetGlobal ELAST             "%ELAST%"
$SetGlobal LAB               "%LAB%"
$SetGlobal BoP               "%BoP%"
$SetGlobal ifAirPol          "%ifAirPol%"
$SetGlobal OVRRIDEGTAPARM    "%OVRRIDEGTAPARM%"
$SetGlobal OVRRIDEGTAPINC    "%OVRRIDEGTAPINC%"

*	Miscellaneous Flags

$SetGlobal ifChecks          "%ifChecks%"
$SetGlobal ifCSV             "%ifCSV%"
$SetGlobal ifAggTrade        "%ifAggTrade%"

$offecho

    $$offOrder
    SCALARS MaxStrLenh, work_bis;

    file Aggregation / '%OutFile%' /;
    Aggregation.ap = 1 ;
    put Aggregation;
    put / /;

    put "*------------------------------------------------------------------------------*" /;
    put "*                                                                              *" /;
    put "*           Model Aggregation for project: %BaseName%                          *" /;
    put "*                                                                              *" /;
    put "*------------------------------------------------------------------------------*" / /;


    put "*------------------------------------------------------------------------------*" /;
    put "*                                Regions: r                                    *" /;
    put "*------------------------------------------------------------------------------*" /;
    MaxStrLenh = smax(r, card(r.tl))+2 ;
    work = 0;
    loop(mapRegSort(sortOrder,r),
        work = work + 1;
        put work:<3:0, ".) ", r.tl:<MaxStrLenh, " : ", r.te(r) /;
    );
    put /;

    put "*------------------------------------------------------------------------------*" /;
    put "*                                Activities: a(aa)                             *" /;
    put "*------------------------------------------------------------------------------*" /;
    MaxStrLenh = smax(actf, card(actf.tl))+2 ;
    LOOP(actf,
        strlen = card(actf.tl) ;
        put ord(actf):<3:0, ".) ", actf.tl:<strlen, "-a : ", actf.te(actf) /;
    ) ;
    put /;

    put "*------------------------------------------------------------------------------*" /;
    put "*                               Commodities i(is)                              *" /;
    put "*------------------------------------------------------------------------------*" /;
    MaxStrLenh = smax(commf, card(commf.tl))+2 ;
    LOOP(commf,
        strlen = card(commf.tl) ;
        put ord(commf):<3:0, ".) ", commf.tl:<strlen, "-c : ", commf.te(commf) /;
    ) ;
    put /;

    put "*------------------------------------------------------------------------------*" /;
    put "*                               Household commodity k                          *" /;
    put "*------------------------------------------------------------------------------*" /;
    MaxStrLenh = smax(k, card(k.tl))+2 ;
    LOOP(k,
        strlen = card(k.tl) ;
        put ord(k):<3:0, ".) ", k.tl:<strlen, "-k : ", k.te(k) /;
    ) ;
    put /;

    put "*------------------------------------------------------------------------------*" /;
    put "*               Mapping between model and GTAP region:  mapr(r0,r)             *" /;
    put "*------------------------------------------------------------------------------*" /;
    MaxStrLenh   = smax(r, card(r.tl))+2 ;
    work = 0;
    loop(r,
        work = work + 1;
        put work:<3:0, ".) ", r.tl:<MaxStrLenh, ": '", r.te(r), "'"/;
        work_bis = 0;
        LOOP(r0 $ mapr(r0,r),
            put "           . " r0.tl:3, ": '", r0.te(r0), "'"/;
        ) ;
    ) ;
    put /;

    put "*------------------------------------------------------------------------------*" /;
    put "*    Mapping between model and GTAP production sector:   mapa(a0,a)            *" /;
    put "*------------------------------------------------------------------------------*" /;

* Note: Exclude CGDS

    MaxStrLenh   = smax(a, card(a.tl))+2 ;
    work = 0;
    loop(a $ (sum(mapa(a0,a),1) and not cgds(a)),
        work = work + 1;
		strlen = card(a.tl) ;
        put work:<3:0, ".) ", a.tl:<strlen, "-a: '", a.te(a), "'"/;
        work_bis = 0;
        LOOP(a0 $ (mapa(a0,a) and not cgds0(a0)),
            put "           . " a0.tl:3, ": '", a0.te(a0), "'"/;
        ) ;
    ) ;
    put /;

    put "*------------------------------------------------------------------------------*" /;
    put "*   Mapping model commodities to households commodities:   mapk(commf,k)       *" /;
    put "*------------------------------------------------------------------------------*" /;
    MaxStrLenh   = smax(k, card(k.tl))+2 ;
    work = 0;
    loop(k,
        work = work + 1;
		strlen = card(k.tl) ;
        put work:<3:0, ".) ", k.tl:<strlen, "-k : '", k.te(k), "'"/;
        work_bis = 0;
        LOOP(commf $ mapk(commf,k),
            put "           . " commf.tl:<strlen, "-i: '", commf.te(commf), "'"/;
        ) ;
    ) ;
    put /;
    putclose Aggregation;

    $$onOrder
    $$Endif.aggfile
$Endif.CallbyAggGTAP

*------------------------------------------------------------------------------*
*           Instructions called by "%DataDir%\filter.gms"                      *
*------------------------------------------------------------------------------*

$IfTheni.CallbyFilter %InFile%=="filter"
    $$IfThen.aggfile EXIST "%OutFile%"
$onecho >> "%OutFile%"
*   Filtering [Optionnal]:
$SetGlobal ifFilter  "ON"
$offecho
    $$Endif.aggfile
$Endif.CallbyFilter

*------------------------------------------------------------------------------*
*           Instructions called by "%DataDir%\altertax.gms"                    *
*------------------------------------------------------------------------------*
$IfTheni.CallbyAltertax %InFile%=="altertax"
    $$IfThen.aggfile EXIST "%OutFile%"
$onecho >> "%OutFile%"
*   AlterTax [Optionnal]:

$SetGlobal ifAlt "ON"
$offecho
    $$Endif.aggfile
$Endif.CallbyAltertax

$droplocal InFile
