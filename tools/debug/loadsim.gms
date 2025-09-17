$Setargs Flag Curyear Solver

IF(%Solver% EQ 1
	$$IF EXIST "%iDataDir%\mcp_coreBau_%Curyear%.gdx" IF(%Flag% and year eq %Curyear%, IfLoadYr = 1 ; ) ;
ELSE
	$$IF EXIST "%iDataDir%\cns_coreBau_%Curyear%.gdx" IF(%Flag% and year eq %Curyear%, IfLoadYr = 1 ; ) ;
) ;
