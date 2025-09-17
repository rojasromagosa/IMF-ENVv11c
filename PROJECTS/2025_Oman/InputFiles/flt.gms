*---    This file load Default options for filtering data of the project "2023_G20" 
$SetGlobal excCombined  1 
SCALARS 
   ifKeepIntermediateConsumption / 1 / 
   ifKeepPrivateconsumption      / 1 / 
   ifKeepGovernmentconsumption   / 1 / 
   ifKeepInvestments             / 1 / 
   ifGDPKeep                     / 1 / 
   ifKeepFactorincomeplusbop     / 1 / 
   ifAdjDepr                     / 1 / 
   abstol                        / 1e-10 / 
   relTol                        / 0.005 / 
   relTolRed                     / 1e-6  / 
   nsteps                        / 5 /     
   minNumTransactions            / 50000 / 
; 
*---    Excluding electric power generation from the filtering procedure 
$Ifi %IfPower%=="ON" $setglobal excSecs "clp, olp, gsp, nuc, hyd, wnd, sol, xel, etd" 
file log / flt.log /; put log; 
