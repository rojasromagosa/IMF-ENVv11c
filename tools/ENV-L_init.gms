
* These almost never change and are frequently used so we put them here
$IF NOT SET GTAP_ver          $SetGlobal GTAP_ver "92"
$IF NOT SET YearGTAP          $SetGlobal YearGTAP "2011"
$IF NOT SET YearEndENVGrowth  $SetGlobal YearEndENVGrowth "2060"
$IF NOT SET YearMax           $SetGlobal YearMax "2100"

$IFI %ERASEPATH%=="ON"

$iftheni.FolderMainDecl DEXIST "projects"
    $$SetGlobal Foldermain "%gams.workdir%"
$elseifi.FolderMainDecl DEXIST "..\projects"
    $$IFI %ERASEPATH%=="ON"  $call "rm    ..\Foldermain.gms"
    $$IF NOT EXIST ..\Foldermain.gms $call "..\getPath.bat"
    $$include ..\Foldermain.gms
$else.FolderMainDecl
    $$IFI %ERASEPATH%=="ON"  $call "rm ..\..\Foldermain.gms"
    $$IF NOT EXIST                     ..\..\Foldermain.gms $call ..\..\getPath.bat
    $$include ..\..\Foldermain.gms
$endif.FolderMainDecl

* Date for characterizing output
$IF  NOT EXIST "%Foldermain%\date.txt" $CALL 'gams %Foldermain%\tools\dateout.gms --outputFolder=%Foldermain%'
$IFI NOT SET dateout $include "%Foldermain%\date.txt"

$IF NOT EXIST "%Foldermain%\model_choice.gms" $CALL 'cp %Foldermain%\tools\model_choice_default.gms %Foldermain%\model_choice.gms'
$IF NOT EXIST "%Foldermain%\myname.txt"       $CALL 'cp %Foldermain%\tools\myname_default.txt       %Foldermain%\myname.txt'

$IF NOT SET project $include    "%Foldermain%\model_choice.gms"
$IF NOT SET myname  $batinclude "%Foldermain%\myname.txt"

$include "%Foldermain%\tools\dir.gms"

$batinclude "%ToolsDir%\header.gms" "%system.incname%"

$include "%ToolsDir%\flags.gms"

$include "%ToolsDir%\macros.gms"

$IFI NOT DEXIST "%DataDir%\gtap_data" $abort "Data absent, you at least need %DataDir%\gtap_data. Run %Foldermain%\getData.bat to get it!"
* $call "%ProjectDir%\getData.bat" is not functional in IDE, so warning!

$batinclude "%ToolsDir%\footer.gms" "%system.incname%"
