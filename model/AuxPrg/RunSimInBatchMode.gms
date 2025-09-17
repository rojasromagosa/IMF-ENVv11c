$OnEolCom
$OffListing

$include "..\..\a_FolderPath.gms"

* Global variable to select run mode %RunMode%={std,preamble,Historic,Projection}

$IF NOT SET RunMode $SetGlobal RunMode "std"

* Standard Mode

$IfTheni.SdtMode %RunMode%=="std"

    $$batinclude "%ModelDir%\%SimType%.gms" "%VarFlag%"

* Save and Restart Mode

$ElseIfi.SdtMode  %RunMode%=="preamble"

    $$batinclude "%ModelDir%\%SimType%.gms" "%VarFlag%" "%RunMode%"

$ElseIfi.SdtMode  %RunMode%=="Historic"

    $$batinclude "%ModelDir%\%SimType%.gms" "%VarFlag%" "%RunMode%" "2020"

$ElseIfi.SdtMode  %RunMode%=="Projection"

    $$batinclude "%ModelDir%\%SimType%.gms" "%VarFlag%" "%RunMode%" "2021" "%YearEndofSim%"

$EndIf.SdtMode

$Show
