* Sub program for "%MergePrgDir%\MainMerge.gms"

* "%1" : Original scenario name
* "%2" : Location of the scenario
* "%3" : New name for the scenario [if precised]
* "%4" : Scenario number

$IfThen.NEwSim SET NewName%4

    $$Call 'copy "%2%1.gdx"   "%TmpDir%\%PrefixName%%3.gdx"'
    $$SetGlobal scenario%4    "%3"
    $$SetGlobal scenario%4Dir "%TmpDir%\%PrefixName%"

$ELSE.NEwSim

* Keep Old Name but remove the prefix

    $$IfThen.NoPrefix NOT PrefixName=="%iGdx%_"

        $$Call 'copy "%2%1.gdx"   "%TmpDir%\%1.gdx"'
        $$SetGlobal scenario%4    "%1"
        $$SetGlobal scenario%4Dir "%TmpDir%\"

    $$ENDIF.NoPrefix


$ENDIF.NEwSim


