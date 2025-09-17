$OnText
--------------------------------------------------------------------------------
                    [OECD-ENV] Model V.1. - Reporting procedure
   Name of the File : "SubPrg\MainMerge.gms"
   purpose          : merge different simulations
   created date     : 2021-03-10
   created by       : Jean Chateau
   called by        : %ToolsDir%\OutputMngt\merge.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/SubPrg/MainMerge.gms $
   last changed revision: $Rev: 312 $
   last changed date    : $Date:: 2023-05-12 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Ce fichier doit marcher pour tous les projets
    Il faut que les fichiers soient dans \OutMacro et \auxi
--------------------------------------------------------------------------------
$OffText

$Offlisting

$IF NOT SET RootDir $SetGlobal RootDir "V:\CLIMATE_MODELLING\MODELS\CGE"

* Select the project name / Folder

$IF NOT SET BaseName $SetGlobal BaseName "CoordinationG20"

* ECO CLIMATE_MODELLING Project folder:

$IF NOT SET ProjectDir $SetGlobal ProjectDir "%RootDir%\PROJECTS\%BaseName%"

*	Folder where simulations are stored: iDir

* default folder containing policy simulations

$IF NOT SET SimRuns $SetGlobal SimRuns "output"

$SetGlobal iDir "%ProjectDir%\%SimRuns%"

*	Output folder: oDir (default %iDir%) :

* On Server

$IFi     %RootDir%=="V:\CLIMATE_MODELLING\MODELS\CGE" $IF NOT SET oDir $SetGlobal oDir "V:\CLIMATE_MODELLING\results\CGE\PROJECTS\%BaseName%\%SimRuns%"

* On PC

$IFi NOT %RootDir%=="V:\CLIMATE_MODELLING\MODELS\CGE" $IF NOT SET oDir $SetGlobal oDir "%iDir%"

* Create output folder (if not exist)

$IF NOT DEXIST "%oDir%" $call "mkdir %oDir%"

*	Location of the baseline in variant mode (Default "%iDir%")

$IF NOT SET BAUvarDir $SetGlobal BAUvarDir "%iDir%"

* Name of the baseline in variant Mode (Default "Bau")

$IF NOT SET Baseline $SetGlobal Baseline "Bau"

*	Default action --> generate "OutMacro" variable

$IF NOT SET iGdx $SetGlobal iGdx "outMacro"

* Name of the merged output '*.gdx' (Default %iGdx%= {outMacro, auxi})

$IF NOT SET OutGdx $SetGlobal OutGdx "%oDir%\%iGdx%"

$IF NOT SET StartDate $SetGlobal StartDate "20%YearGTAP%"
$IF NOT SET EndDate   $SetGlobal EndDate   "2050"

* If we want to put a prefix of the variable before scenario name - Default None

$IF NOT SET PrefixName $SetGlobal PrefixName ""

*	Temporary folder to save simulation if we change name

$IFi 	 DEXIST "V:\CLIMATE_MODELLING" $SetGlobal TmpDir "V:\CLIMATE_MODELLING\sandbox\tmpFolder\MergeTmpFiles"
$IFi NOT DEXIST "V:\CLIMATE_MODELLING" $SetGlobal TmpDir "C:\MODELS\TmpDir\MergeTmpFiles"

$IF NOT DEXIST "%TmpDir%" $call "mkdir %TmpDir%"

* clean old gdx file stored in the temporary folder

$CALL DEL "%TmpDir%\*.gdx"

*	By default load simulation in folder %iDir%

* but could also read each simulation from its own folder: "scenario[Number]Dir"
*   + files are in sub-folders %iGdx% "\auxi" or "\outMacro"
*   + and files are preceeded with "%iGdx%_"


*	Default auxi variables (do not change the order / default)
* #todo out_Ratios "out_Total_Demands"

*$IF NOT SET auxiVar1  $SetGlobal auxiVar1  "out_Labour"
*$IF NOT SET auxiVar2  $SetGlobal auxiVar2  "out_Value_Added"
$IF NOT SET auxiVar3  $SetGlobal auxiVar3  "out_Gross_output"
*$IF NOT SET auxiVar4  $SetGlobal auxiVar4  "out_Energy"
*$IF NOT SET auxiVar5  $SetGlobal auxiVar5  "out_Prices"
$IF NOT SET auxiVar6  $SetGlobal auxiVar6  "out_Environment"
*$IF NOT SET auxiVar7  $SetGlobal auxiVar7  "out_Capital"
*$IF NOT SET auxiVar8  $SetGlobal auxiVar8  "out_Final_Demands"
*$IF NOT SET auxiVar9  $SetGlobal auxiVar9  "out_External"
*$IF NOT SET auxiVar10 $SetGlobal auxiVar10 "out_Trade"

*	Create & Modify global variables : %scenario[Number]Dir%

$IF NOT SET scenario2Dir $IF SET scenario2 $Setglobal scenario2Dir "%iDir%"
$IF 	SET scenario2 	$Setglobal scenario2Dir "%scenario2Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario3Dir $IF SET scenario3 $Setglobal scenario3Dir "%iDir%"
$IF 	SET scenario3 $Setglobal scenario3Dir "%scenario3Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario4Dir $IF SET scenario4 $Setglobal scenario4Dir "%iDir%"
$IF 	SET scenario4 $Setglobal scenario4Dir "%scenario4Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario5Dir $IF SET scenario5 $Setglobal scenario5Dir "%iDir%"
$IF 	SET scenario5 $Setglobal scenario5Dir "%scenario5Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario6Dir $IF SET scenario6 $Setglobal scenario6Dir "%iDir%"
$IF 	SET scenario6 $Setglobal scenario6Dir "%scenario6Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario7Dir $IF SET scenario7 $Setglobal scenario7Dir "%iDir%"
$IF 	SET scenario7 $Setglobal scenario7Dir "%scenario7Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario8Dir $IF SET scenario8 $Setglobal scenario8Dir "%iDir%"
$IF 	SET scenario8 $Setglobal scenario8Dir "%scenario8Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario9Dir $IF SET scenario9 $Setglobal scenario9Dir "%iDir%"
$IF 	SET scenario9 $Setglobal scenario9Dir "%scenario9Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario10Dir $IF SET scenario10 $Setglobal scenario10Dir "%iDir%"
$IF 	SET scenario10 $Setglobal scenario10Dir "%scenario10Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario11Dir $IF SET scenario11 $Setglobal scenario11Dir "%iDir%"
$IF 	SET scenario11 $Setglobal scenario11Dir "%scenario11Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario12Dir $IF SET scenario12 $Setglobal scenario12Dir "%iDir%"
$IF 	SET scenario12 $Setglobal scenario12Dir "%scenario12Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario13Dir $IF SET scenario13 $Setglobal scenario13Dir "%iDir%"
$IF 	SET scenario13 $Setglobal scenario13Dir "%scenario13Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario14Dir $IF SET scenario14 $Setglobal scenario14Dir "%iDir%"
$IF 	SET scenario14 $Setglobal scenario14Dir "%scenario14Dir%\%iGdx%\%iGdx%_"
$IF NOT SET scenario15Dir $IF SET scenario15 $Setglobal scenario15Dir "%iDir%"
$IF 	SET scenario15 $Setglobal scenario15Dir "%scenario15Dir%\%iGdx%\%iGdx%_"

*	Change File Name and move in tmp folder

$IF SET scenario2  $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario2%"  "%scenario2Dir%"  "%NewName2%"  "2"
$IF SET scenario3  $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario3%"  "%scenario3Dir%"  "%NewName3%"  "3"
$IF SET scenario4  $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario4%"  "%scenario4Dir%"  "%NewName4%"  "4"
$IF SET scenario5  $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario5%"  "%scenario5Dir%"  "%NewName5%"  "5"
$IF SET scenario6  $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario6%"  "%scenario6Dir%"  "%NewName6%"  "6"
$IF SET scenario7  $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario7%"  "%scenario7Dir%"  "%NewName7%"  "7"
$IF SET scenario8  $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario8%"  "%scenario8Dir%"  "%NewName8%"  "8"
$IF SET scenario9  $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario9%"  "%scenario9Dir%"  "%NewName9%"  "9"
$IF SET scenario10 $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario10%" "%scenario10Dir%" "%NewName10%" "10"
$IF SET scenario11 $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario11%" "%scenario11Dir%" "%NewName11%" "11"
$IF SET scenario12 $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario12%" "%scenario12Dir%" "%NewName12%" "12"
$IF SET scenario13 $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario13%" "%scenario13Dir%" "%NewName13%" "13"
$IF SET scenario14 $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario14%" "%scenario14Dir%" "%NewName14%" "14"
$IF SET scenario15 $batinclude "%MergePrgDir%\sub-merge2.gms" "%scenario15%" "%scenario15Dir%" "%NewName15%" "15"

* Copy also Bau in the temporary folder (only if NOT %PrefixName% ???)

$IfThen.NoPrefix NOT %PrefixName%=="%iGdx%_"

   $$Call 'copy "%BAUvarDir%\%iGdx%\%iGdx%_%Baseline%.gdx" "%TmpDir%\%Baseline%.gdx"'

$EnDif.NoPrefix

*------------------------------------------------------------------------------*
*              Define the list of scenarios we want to compare                 *
*------------------------------------------------------------------------------*

set simulations /

    $$IF set Baseline   "%Baseline%"
    $$IF set scenario2  "%scenario2%"
    $$IF set scenario3  "%scenario3%"
    $$IF set scenario4  "%scenario4%"
    $$IF set scenario5  "%scenario5%"
    $$IF set scenario6  "%scenario6%"
    $$IF set scenario7  "%scenario7%"
    $$IF set scenario8  "%scenario8%"
    $$IF set scenario9  "%scenario9%"
    $$IF set scenario10 "%scenario10%"
    $$IF set scenario11 "%scenario11%"
    $$IF set scenario12 "%scenario12%"
    $$IF set scenario13 "%scenario13%"
    $$IF set scenario14 "%scenario14%"
    $$IF set scenario15 "%scenario15%"

/;

*------------------------------------------------------------------------------*
*        STEP 1:  Create %OutGdx%.gdx of the selected scenarios                *
*------------------------------------------------------------------------------*

$CALL DEL "%OutGdx%.gdx"

*	Create "gdxmerge.txt" that contents options for GDXmerge

$set fmerge "gdxmerge.txt"

* First always save baseline in variant mode

$IF 	SET Baseline $echo '"%TmpDir%\%Baseline%.gdx"' > %fmerge%
$IF NOT SET Baseline $echo '* No Baseline' > %fmerge%

$IF set scenario2   $echo '"%scenario2Dir%%scenario2%.gdx"' >> %fmerge%
$IF set scenario3   $echo '"%scenario3Dir%%scenario3%.gdx"' >> %fmerge%
$IF set scenario4   $echo '"%scenario4Dir%%scenario4%.gdx"' >> %fmerge%
$IF set scenario5   $echo '"%scenario5Dir%%scenario5%.gdx"' >> %fmerge%
$IF set scenario6   $echo '"%scenario6Dir%%scenario6%.gdx"' >> %fmerge%
$IF set scenario7   $echo '"%scenario7Dir%%scenario7%.gdx"' >> %fmerge%
$IF set scenario8   $echo '"%scenario8Dir%%scenario8%.gdx"' >> %fmerge%
$IF set scenario9   $echo '"%scenario9Dir%%scenario9%.gdx"' >> %fmerge%
$IF set scenario10  $echo '"%scenario10Dir%%scenario10%.gdx"' >> %fmerge%
$IF set scenario11  $echo '"%scenario11Dir%%scenario11%.gdx"' >> %fmerge%
$IF set scenario12  $echo '"%scenario12Dir%%scenario12%.gdx"' >> %fmerge%
$IF set scenario13  $echo '"%scenario13Dir%%scenario13%.gdx"' >> %fmerge%
$IF set scenario14  $echo '"%scenario14Dir%%scenario14%.gdx"' >> %fmerge%
$IF set scenario15  $echo '"%scenario15Dir%%scenario15%.gdx"' >> %fmerge%

$Ifi %iGdx%=="outMacro" $echo ID=out_Macroeconomic >> %fmerge%

* Selected auxi Variables

$IfTheni.AuxiFile %iGdx%=="auxi"
    $$If set auxiVar1  $echo ID=%auxiVar1% >> %fmerge%
    $$If set auxiVar2  $echo ID=%auxiVar2% >> %fmerge%
    $$If set auxiVar3  $echo ID=%auxiVar3% >> %fmerge%
    $$If set auxiVar4  $echo ID=%auxiVar4% >> %fmerge%
    $$If set auxiVar5  $echo ID=%auxiVar5% >> %fmerge%
    $$If set auxiVar6  $echo ID=%auxiVar6% >> %fmerge%
    $$If set auxiVar7  $echo ID=%auxiVar7% >> %fmerge%
    $$If set auxiVar8  $echo ID=%auxiVar8% >> %fmerge%
    $$If set auxiVar9  $echo ID=%auxiVar9% >> %fmerge%
    $$If set auxiVar10 $echo ID=%auxiVar10% >> %fmerge%
    $$If set auxiVar11 $echo ID=%auxiVar11% >> %fmerge%
    $$If set auxiVar12 $echo ID=%auxiVar11% >> %fmerge%
$Endif.AuxiFile
$echo output = "%OutGdx%.gdx" >> %fmerge%

*	Pour plusieurs instructions:

$OnText
$onecho >> %fmerge%
ID=out_Macroeconomic
output="%OutGdx%.gdx"
$offecho
$Offtext

*	Generating the merging file

$call gdxmerge @%fmerge%

* $call del %fmerge%

*------------------------------------------------------------------------------*
*                   STEP 2:  Extract csv files                                 *
*------------------------------------------------------------------------------*

set ScenariosName /
    $$IF set Baseline   "%PrefixName%%Baseline%"
    $$IF set scenario2  "%PrefixName%%scenario2%"
    $$IF set scenario3  "%PrefixName%%scenario3%"
    $$IF set scenario4  "%PrefixName%%scenario4%"
    $$IF set scenario5  "%PrefixName%%scenario5%"
    $$IF set scenario6  "%PrefixName%%scenario6%"
    $$IF set scenario7  "%PrefixName%%scenario7%"
    $$IF set scenario8  "%PrefixName%%scenario8%"
    $$IF set scenario9  "%PrefixName%%scenario9%"
    $$IF set scenario10 "%PrefixName%%scenario10%"
    $$IF set scenario11 "%PrefixName%%scenario11%"
    $$IF set scenario12 "%PrefixName%%scenario12%"
    $$IF set scenario13 "%PrefixName%%scenario13%"
    $$IF set scenario14 "%PrefixName%%scenario14%"
    $$IF set scenario15 "%PrefixName%%scenario15%"
/;

Display ScenariosName;

*	Define/load sets

$IF SET Baseline set Baseline(ScenariosName) / "%PrefixName%%Baseline%" / ;

SETS
    typevar, macrocat, gdp_definition, regions, macrolist,
    origin,destination, ia,
    $$IFi %iGdx%=="auxi"  nrglist, Pricelist, envlist, labourlist, tradelist, CapitalList,
    skills, commodities, agents, items, units, envunits, ra, tt, t, aga ;

$gdxin "%BAUvarDir%\%Baseline%.gdx"

$loaddc typevar, macrocat, macrolist,  units, ra, tt,  t, aga, ia
$IFi %iGdx%=="auxi" $loaddc labourlist, gdp_definition, commodities, agents, items, envunits, skills, nrglist, envlist
$IFi %iGdx%=="auxi" $loaddc tradelist, CapitalList, Pricelist, regions, origin, destination
$gdxin

SET  abstype(typevar) / abs / ;

*	create outMacro.csv

$IfTheni.MacroVAr %iGdx%=="outMacro"

    PARAMETER out_Macroeconomic(ScenariosName,typevar,macrocat,macrolist,units,ra,tt);
    EXECUTE_LOAD "%OutGdx%.gdx", out_Macroeconomic;

* Nettoyage 1: on ne garde que var "abs"

    out_Macroeconomic(ScenariosName,typevar,macrocat,macrolist,units,ra,tt)
        $ (Not abstype(typevar)) = 0;

* Nettoyage 2: on ne garde que %StartDate%-%EndDate%

    Loop(tt$(tt.val lt %StartDate% or tt.val gt %EndDate%),
        out_Macroeconomic(ScenariosName,typevar,macrocat,macrolist,units,ra,tt)
        $ (NOT Baseline(ScenariosName)) = 0;
    );

    EXECUTE_UNLOAD "%OutGdx%.gdx", out_Macroeconomic, ScenariosName ;

* Extract the Csv file

* Rappel on peut aussi Ecrire contenu dans un fichier: gdxdump trnsport.gdx > GDXContents.gms

    EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%OutGdx%.csv symb=out_Macroeconomic'

$Else.MacroVAr

*	create out_auxi.csv s

    PARAMETER
        $$If set auxiVar1    %auxiVar1%(ScenariosName,typevar,labourlist,units,ra,skills,agents,t)     "Labour market variable, by region by skill, by sector by year"
        $$If set auxiVar2    %auxiVar2%(ScenariosName,typevar,gdp_definition,units,ra,aga,t)           "Value Added at different units, by unit, by region by sector or commmodity by year"
        $$If set auxiVar3    %auxiVar3%(ScenariosName,typevar,units,ra,aga,t)                          "Gross Output (at Basic Prices) by region and by sector"
        $$If set auxiVar4    %auxiVar4%(ScenariosName,typevar,nrglist,envunits,ra,agents,t)            "Energy variables"
        $$If set auxiVar5    %auxiVar5%(ScenariosName,typevar,Pricelist,regions,commodities,agents,t)  "Prices variables for good i or total"
        $$If set auxiVar6    %auxiVar6%(ScenariosName,typevar,envlist,envunits,ra,agents,t)            "Environmental variables"
        $$If set auxiVar7    %auxiVar7%(ScenariosName,typevar,CapitalList,units,ra,agents,t)           "Capital market variable, by region, by sector by year"
        $$If set auxiVar8    %auxiVar8%(ScenariosName,typevar,units,ra,ia,agents,t)                    "Final Demand"
        $$If set auxiVar9    %auxiVar9%(ScenariosName,typevar,tradelist,units,ra,ia,t)                 "External accounts variables"
        $$If set auxiVar10  %auxiVar10%(ScenariosName,typevar,tradelist,units,origin,destination,ia,t) "Trade Flows variables"
    ;
    EXECUTE_LOAD "%OutGdx%.gdx",
        $$If set auxiVar1  %auxiVar1%
        $$If set auxiVar2  %auxiVar2%
        $$If set auxiVar3  %auxiVar3%
        $$If set auxiVar4  %auxiVar4%
        $$If set auxiVar5  %auxiVar5%
        $$If set auxiVar6  %auxiVar6%
        $$If set auxiVar7  %auxiVar7%
        $$If set auxiVar8  %auxiVar8%
        $$If set auxiVar9  %auxiVar9%
        $$If set auxiVar10 %auxiVar10%
   ;

* Nettoyage 1: on ne garde que var "abs"

    $$If set auxiVar1   %auxiVar1%(ScenariosName,typevar,labourlist,units,ra,skills,agents,t)     $ (Not abstype(typevar)) = 0;
    $$If set auxiVar2   %auxiVar2%(ScenariosName,typevar,gdp_definition,units,ra,aga,t)           $ (Not abstype(typevar)) = 0;
    $$If set auxiVar3   %auxiVar3%(ScenariosName,typevar,units,ra,aga,t)                          $ (Not abstype(typevar)) = 0;
    $$If set auxiVar4   %auxiVar4%(ScenariosName,typevar,nrglist,envunits,ra,agents,t)            $ (Not abstype(typevar)) = 0;
    $$If set auxiVar5   %auxiVar5%(ScenariosName,typevar,Pricelist,regions,commodities,agents,t)  $ (Not abstype(typevar)) = 0;
    $$If set auxiVar6   %auxiVar6%(ScenariosName,typevar,envlist,envunits,ra,agents,t)            $ (Not abstype(typevar)) = 0;
    $$If set auxiVar7   %auxiVar7%(ScenariosName,typevar,CapitalList,units,ra,agents,t)           $ (Not abstype(typevar)) = 0;
    $$If set auxiVar8   %auxiVar8%(ScenariosName,typevar,units,ra,ia,agents,t)                    $ (Not abstype(typevar)) = 0;

* Not for these 2 if we want Market Shares

*    $$If set auxiVar9   %auxiVar9%(ScenariosName,typevar,tradelist,units,ra,ia,t)                 $ (Not abstype(typevar)) = 0;
*    $$If set auxiVar10 %auxiVar10%(ScenariosName,typevar,tradelist,units,origin,destination,ia,t) $ (Not abstype(typevar)) = 0;

* Nettoyage 2: on ne garde que %StartDate%<=t<=%EndDate%

    Loop((t,ScenariosName)$(t.val lt %StartDate% or t.val gt %EndDate% and NOT Baseline(ScenariosName)),
        $$If set auxiVar1   %auxiVar1%(ScenariosName,typevar,labourlist,units,ra,skills,agents,t)     = 0;
        $$If set auxiVar2   %auxiVar2%(ScenariosName,typevar,gdp_definition,units,ra,aga,t)           = 0;
        $$If set auxiVar3   %auxiVar3%(ScenariosName,typevar,units,ra,aga,t)                          = 0;
        $$If set auxiVar4   %auxiVar4%(ScenariosName,typevar,nrglist,envunits,ra,agents,t)            = 0;
        $$If set auxiVar5   %auxiVar5%(ScenariosName,typevar,Pricelist,regions,commodities,agents,t)  = 0;
        $$If set auxiVar6   %auxiVar6%(ScenariosName,typevar,envlist,envunits,ra,agents,t)            = 0;
        $$If set auxiVar7   %auxiVar7%(ScenariosName,typevar,CapitalList,units,ra,agents,t)           = 0;
        $$If set auxiVar8   %auxiVar8%(ScenariosName,typevar,units,ra,ia,agents,t)                    = 0;
        $$If set auxiVar9   %auxiVar9%(ScenariosName,typevar,tradelist,units,ra,ia,t)                 = 0;
        $$If set auxiVar10 %auxiVar10%(ScenariosName,typevar,tradelist,units,origin,destination,ia,t) = 0;
    );

    EXECUTE_UNLOAD "%OutGdx%.gdx", ScenariosName,
        $$If set auxiVar1  %auxiVar1%
        $$If set auxiVar2  %auxiVar2%
        $$If set auxiVar3  %auxiVar3%
        $$If set auxiVar4  %auxiVar4%
        $$If set auxiVar5  %auxiVar5%
        $$If set auxiVar6  %auxiVar6%
        $$If set auxiVar7  %auxiVar7%
        $$If set auxiVar8  %auxiVar8%
        $$If set auxiVar9  %auxiVar9%
        $$If set auxiVar10 %auxiVar10%
    ;

* Put in Csv files

     $$If set auxiVar1  EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar1%.csv symb=%auxiVar1%'
     $$If set auxiVar2  EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar2%.csv symb=%auxiVar2%'
     $$If set auxiVar3  EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar3%.csv symb=%auxiVar3%'
     $$If set auxiVar4  EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar4%.csv symb=%auxiVar4%'
     $$If set auxiVar5  EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar5%.csv symb=%auxiVar5%'
     $$If set auxiVar6  EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar6%.csv symb=%auxiVar6%'
     $$If set auxiVar7  EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar7%.csv symb=%auxiVar7%'
     $$If set auxiVar8  EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar8%.csv symb=%auxiVar8%'
     $$If set auxiVar9  EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar9%.csv symb=%auxiVar9%'
     $$If set auxiVar10 EXECUTE 'gdxdump %OutGdx%.gdx format=CSV output=%oDir%\%auxiVar10%.csv symb=%auxiVar10%'

$Endif.MacroVAr

$LABEL DONE
