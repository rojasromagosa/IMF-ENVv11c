*   Model sectoral set:  Power Activities

* 	Memo: value for DesAggEly = {"ON,"OFF}
* By default for Activity sets : %DesAggEly% == %IfPower% 		 == "ON"
* By default for Sommodity sets: %DesAggEly% == %IfElyGoodDesag% == "OFF"

$Setargs suffix DesAggEly

$IfTheni.Power %ifPower%=="%DesAggEly%"

    clp%suffix%  "Coal powered electricity"
    olp%suffix%  "Oil powered electricity"
    gsp%suffix%  "Gas Powered electricity"
    nuc%suffix%  "Nuclear power"
    hyd%suffix%  "Hydro power"
    wnd%suffix%  "Wind power"
    sol%suffix%  "Solar power"
    xel%suffix%  "Other power"
    etd%suffix%  "Electricity transmission and distribution"

$Else.Power

    ely%suffix%   "Electricity: Generation, transmission and distribution"

$Endif.Power
