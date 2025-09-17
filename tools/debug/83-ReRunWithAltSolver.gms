* For Baseline mainly re-run a successful simulation with the alternative solver
* and save corresponding solution year

$setlocal ModelTmp "%1"

work = ifMCP;

IF(work eq 1,
    ifMCP = 2 ;
    $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelTmp%
    PUT_UTILITY SaveCurrentYear 'Exec' / 'cp %ModelTmp%_p.gdx %iDataDir%\cns_%ModelTmp%_' tsim.tl:4:0 '.gdx';
) ;

IF(work eq 2,
    ifMCP = 1 ;
    $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelTmp%
    PUT_UTILITY SaveCurrentYear 'Exec' / 'cp %ModelTmp%_p.gdx %iDataDir%\mcp_%ModelTmp%_' tsim.tl:4:0 '.gdx';
) ;

ifMCP = work ;
$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelTmp%

$droplocal ModelTmp