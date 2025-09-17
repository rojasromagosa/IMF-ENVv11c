etat_statut(sim,tsim,"MCP") $(ifMCP eq 1) = YES;
etat_statut(sim,tsim,"CNS") $(ifMCP eq 2) = YES;
etat_statut(sim,tsim,"solvestat") = %ModelName%.solvestat;
etat_statut(sim,tsim,"modelstat") = %ModelName%.MODELSTAT;
etat_statut(sim,tsim,"infes")     = %ModelName%.numinfes;
etat_statut(sim,tsim,"nb_eqs")    = %ModelName%.numequ;
etat_statut(sim,tsim,"nb_vars")   = %ModelName%.numvar;
etat_statut(sim,tsim,"walras")    = outscale * walras.l;
etat_statut(sim,tsim,"nb_slices") = slices;

* Save failed solution for checking

$$Ifi %MultiRun%=="ON"  PUT_UTILITY failedSim 'gdxout' / '%DirCheck%\' sim.tl:0 '_'  tsim.val:4:0 '_slicing_failed.gdx' ;
$$Ifi %MultiRun%=="OFF" PUT_UTILITY failedSim 'gdxout' / '%cFile%_'                  tsim.val:4:0 '_slicing_failed.gdx' ;
EXECUTE_UNLOAD;

ABORT 'Maximum number of slices reached';
