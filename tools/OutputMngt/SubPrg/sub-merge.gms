* Sub program for "%RootDir%\OutputMngt\SubPrg\MainMerge.gms"

* "%1" is a Flag for the number of the scenario
* "%2" is the location of scenario if not in default folder

*	Define Folder where simulations are stored

* Simulations are in any case in same Project folder
*   + files are in sub-folders %iGdx% \auxi or \outMacro
* and files are preceeded with %iGdx%_

$IF SET scenario%1Dir      $SetGlobal scenario%1Dir "%iDir%\%2\%iGdx%\%iGdx%_"

*... but if no location are precised default location is %SimDir%

$IF NOT SET scenario%1Dir  $SetGlobal scenario%1Dir "%SimDir%\%iGdx%\%iGdx%_"






