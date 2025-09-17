$ontext
--------------------------------------------------------------------------------
   OECD ENV-Linkages version 4
   GAMS file    : slicing.gms
   purpose      : Slice the shocks between one year and the other
   created date: 2021-06-10
   created by  : Jean Fouré
   called by   : core program
--------------------------------------------------------------------------------
      $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/debug/slicing.gms $
--------------------------------------------------------------------------------
The basic idea of the slicing module is to cut the different shocks on items
( parameters and fixed variables) between years to ease model solving. Each
sliced item will start from a "_start" value and converge towards an "_end" value.

This module proceeds the following way:
  - it will first start not to slice the shock
  (implement 100% of shocks) with the default solver (determined by the %Solver% global
  variable, or, if present, by the value of SlicingStartSolver(tsim)).
  - If the solve fails and if the global variable slicingIfMCPSwitch is set to
  "ON", then it will try with the other solver.
  - If the model still fails or if slicingIfMCPSwitch="OFF", it will attemps to cut
  the shock by half and solve the model twice (50% of shock, then 100% of shock) using
  the default solver, and if it fails try the other one.
  - If it still fails, it will cut again the shock by half, and so on and so on
  - In the end, once the maximum of slices is reached, if the model has not found a
  solution, then the process is aborted and an output GDX is produced in the "output" folder.

There are two options to choose the model starting point:
  - SlicingStartSolver determines whether the first try is done with MCP (1) or CNS (2)
  - SlicingStartStep determines the number of slices to start with (which will be 2^slicingStartStep)
--------------------------------------------------------------------------------
    ECO version adjustement of ENV procedure :
        - replace global variable step_module --> ReadingFile
        - Do not need the global variable: module_slicing
            only Global IfSlicing is needed
--------------------------------------------------------------------------------
$offtext

$SetGlobal folder_slicing "%DebugDir%\slicing"

* Main File reading the instructions:

$SetLocal ReadingFile "%1"

*------------------------------------------------------------------------------*
*   Instruction read in "2-CommonIns.gms" = Additional parameters declaration  *
*------------------------------------------------------------------------------*

$IfTheni.paramdecl %ReadingFile%=="2-CommonIns"

    $$OnText
    Debugging Mode:
    Set ifDebugSlicing to 1 to enable some debugging procedure
    and debugging output.
    The debugging procedure consists in starting with 0% of the slice
    before starting to implement the actual shock.
    There should be close to zero infeasibility in that case
    (not 0 infeasilibity because of the capital accumulation equations
    that cannot be fully sliced).
    --> Set debugSlicingYear to the year where you want the procedure to happen.

    Question:	Je ne comprend pas trop à quoi sert slicingStartStep(t)
    Reponse:   C’est pour aller plus vite : si tu sais que tu as besoin
    de 4 slices pour une année, tu mets slicingStartStep(t) = 2
    et ça t’évite de devoir tester en 1 slice et en 2 slices avant de passer à 4.

    $$OffText

    $$IF NOT SET ifDebugSlicing   $SetGlobal ifDebugSlicing   0      !! Set is to 1 to
    $$IF NOT SET debugSlicingYear $SetGlobal debugSlicingYear "2015"   !! Set to a year

    SCALARS
        slicingStep        "Number of slicing steps"
        nbSolverTested     "Current nomber of solver tested (0, 1 or 2)"
        maxSlicingStep     "Maximum number of slicing steps" / 4 /
        slices             "Number of slices (power of 2)" / 0 /
        slicePercentage    "Percentage of shocks"
        slicingModelStatus "Model status during slicing"
    ;

    PARAMETERS
        SlicingStartStep(t)     "Initial number of slicing steps"
        SlicingStartSolver(t)   "Initial solver to try (1 of MCP, 2 for CNS)"
    ;

    SlicingStartStep(t)   = 1 ;
    SlicingStartSolver(t) = ifMCP ;

*   Declaration of the "start" and "end" parameters used to slice the shocks

    PARAMETERS
        $$BATINCLUDE "%folder_slicing%\0-sliced_list.gms" "%folder_slicing%\1-declare_slicing_param.gms"
    ;

$EndIf.paramdecl

*------------------------------------------------------------------------------*
*   Instruction read in "8-solve.gms" = Changes in solve procedure             *
*------------------------------------------------------------------------------*

$IfTheni.solvestep %ReadingFile%=="8-solve"

*   #TODO move this is "AdjustSimOption.gms"

*   items initialized on "_start" parameters need them to have their value set here

$ONDOTL
*    emiCap_start(emkt,tsim)
*        = sum((r,em,EmiSource,aa) $ mapemi_mkt(emkt,r,em,EmiSource,aa,tsim),
*            m_true(emi(r,em,EmiSource,aa,tsim-1))) $ {ifEmiCap(emkt,tsim-1) eq 0}
*        + {emiCap.l(emkt,tsim-1) } $ {ifEmiCap(emkt,tsim-1)}
*        ;
*
    emiCap_start(rq,em,tsim)  = emiCap.l(rq,em,tsim-1)  $ {IfEmCap(rq,em)} ;
    emiCapFull_start(rq,tsim) = emiCapFull.l(rq,tsim-1) $ {IfCap(rq)}      ;

*   Initialization of end values

    $$BatInclude "%folder_slicing%\0-sliced_list.gms" "%folder_slicing%\2-end_param_value.gms"

$OFFDOTL

*   Actual slicing: slice the shocks by smaller and smaller shocks until success
* starting with 100% of shock except if otherwise specified in slicingStartStep

* Re-initialize

    slicingModelStatus = 0;
    nbSolverTested     = 0;
    slicingStep        = slicingStartStep(tsim) - 1 ; !! --> 0 by default
    ifMCP              = SlicingStartSolver(tsim) ;

*------------------------------------------------------------------------------*
* Loop over the slices: we slice by more slices until the last slice if fine   *
*------------------------------------------------------------------------------*

    WHILE(slicingModelStatus ne 1,

        $$IfTheni.ifMCPSwitch "%slicingIfMCPSwitch%"=="ON"
            IF(nbSolverTested ne 1,

* Case 1: If 0 or 2 solvers have been tried (nbSolverTested eq 1) --> slice more

                ifMCP = SlicingStartSolver(tsim);
                slicingStep = slicingStep + 1; !! --> goto next slice
                nbSolverTested = 0;            !! --> skip the next condition

            ELSE

* Case 2: If one solver has been tested (nbSolverTested eq 1)
*           --> switch to the other solver (without slicing more)
                slicingStep = slicingStep ;   !! --> keep same slice
                IfMCP = 2 $ {IfMCP eq 1} + 1 $ {IfMCP eq 2} ;

            ) ;
        $$Else.ifMCPSwitch

* Case no Solver Switching ("%slicingIfMCPSwitch%"=="OFF") --> we only go to next slice

            ifMCP           = SlicingStartSolver(tsim);
            slicingStep     = slicingStep + 1; !! --> goto next slice
            nbSolverTested  = 0;               !! --> useless?

        $$EndIf.ifMCPSwitch

*   While the full shock is not passed, the shock is sliced more

        slices = power(2,slicingStep-1); !!--> gives 0 for 1st round

        IF(%ifDebugSlicing%
            AND (year eq %debugSlicingYear%) AND (slices eq 1),
            slicePercentage = -1 / slices; !! -1 / slices to start without shock
        ELSE
            slicePercentage = 0 ;
        ) ;

*   Initialize again variables before the first slice (taken from iterloop)

* [EditJean]: for Eco version instructions below replace "01-initialize_variables.gms"

        IF((year gt FirstYear) and IfInitVar and (NOT IfLoadYr),
            IfInitVar = 2 ;
            $$include "%ModelDir%\71-InitVar.gms"
        ) ;

        WHILE(slicePercentage lt 1,

            slicePercentage = min(slicePercentage + 1/slices,1);
            work = slicePercentage * 100; !!sliceDisplayPercentage --> for display
            put screen / / "Slice : ", work:5:0, "% of shock, slicing in ", slices:3:0, " slice(s)" / /;
            putclose screen;
            display "Slice : ", work, "% of shock, slicing in ", slices, " slice(s)";

*   Slice the shocks

            $$batinclude "%folder_slicing%\0-sliced_list.gms" "%folder_slicing%\3-sliced_value.gms" "slicePercentage"

            LOOP((CO2,USA), tvol = emiTax.l(USA,CO2,tsim) / cScale ; ) ;
            Display "Taxe",  tvol ;

*   Debug (option) --> %ifDebugSlicing% == 1

            IF(%ifDebugSlicing%,
                IF(slicePercentage eq 0 AND year eq %debugSlicingYear%,
                    EXECUTE_UNLOAD "%cFile%_slice0.gdx"
                ) ;
                IF((year eq %debugSlicingYear%)
                    !! AND (slicePercentage eq 0)
                              AND (slices eq 1),
                    option iterlim=0;   option limrow=50;
                ELSE
                    option iterlim=500; option limrow=0;
                ) ;
                IF(slices eq 1,
                    EXECUTE_UNLOAD "%cFile%_beforeFirstSlice.gdx";
                ) ;
            ) ;

*   Actual solve statement happens here

            $$batinclude "%ModelDir%\81-solving_instructions.gms" %ModelName%

            Display "modelstat : " %ModelName%.modelstat;
            Display "solvestat : " %ModelName%.solvestat;


* [EditJean]: for Eco version instructions below replace "02-model_status.gms"

*   slicingModelStatus = 0 : if no solution found
*   slicingModelStatus = 1 : if solution found and Walras law OK
*   slicingModelStatus = 2 : if solution found but Walras law not satisfied

            slicingModelStatus = 0 ;
            work = walras.l * outscale;

* Sucessful run

            IF((%ModelName%.solvestat eq 1) AND (ABS(work) lt 1),
                slicingModelStatus$(%ModelName%.MODELSTAT eq 16 and ifMcp eq 2) = 1;
                slicingModelStatus$(%ModelName%.MODELSTAT eq 1  and ifMcp eq 1) = 1;
            );

* Pb with Walras law

            IF((%ModelName%.solvestat eq 1) AND (ABS(work) ge 1),
                slicingModelStatus$(%ModelName%.MODELSTAT eq 16 and ifMcp eq 2) = 2;
                slicingModelStatus$(%ModelName%.MODELSTAT eq 1  and ifMcp eq 1) = 2;
            );

            put screen;
            put / / "Walras (from slicing): ", work:8:8 /;
            putclose screen;

*   Save resulting simulation for current year [Option]

            IF(IfSaveYr and (slicePercentage eq 0) and (year gt %YearStart%),
                PUT_UTILITY SaveCurrentYear 'EXEC' / 'cp %ModelName%_p.gdx %iDataDir%\slice0_' tsim.tl:4:0 '.gdx';
            ) ;

*   Checks for every slice : does the model fails ?
* If one slice failed to solve, directly switch to next slice

            IF(slicingModelStatus ne 1,
                slicePercentage = 2;
            ) ;

            Display "END de Loop: WHILE(slicePercentage lt 1 --> slices:", slices, slicingStep, slicePercentage, slicingModelStatus ;

        ) ; !! End of Loop: WHILE(slicePercentage lt 1

*   Here, we have finished the last slice, so we can say the solver
* has been tried and check whether it was a success

        nbSolverTested = nbSolverTested + 1;

        IF(slicingModelStatus ne 1,

            put screen;
            $$IfTheni.ifMCPSwitch "%slicingIfMCPSwitch%"=="ON"
                IF(nbSolverTested eq 1,
                    put //  "Solve failed, trying another solver" /;
                    display "Solve failed, trying another solver"  ;
                ) ;
                IF(nbSolverTested eq 2,
                    put //  "Solve failed, slicing more" /;
                    display "Solve failed, slicing more"  ;
                ) ;
            $$Else.ifMCPSwitch
                put //  "Solve failed, slicing more" /;
                display "Solve failed, slicing more";
            $$EndIf.ifMCPSwitch
            putclose screen;

*   If no success for the last slice of max number of slices (4), then abort

            IF(slicingStep ge maxSlicingStep,
                $$include "%folder_slicing%\4-abort.gms"
            ) ;

        ) ;

        Display "End loop slicingModelStatus:", slices, slicingStep, slicingModelStatus ;

    ) ; !! End loop slicingModelStatus <> 1 line 126

$EndIf.solvestep

$droplocal ReadingFile
