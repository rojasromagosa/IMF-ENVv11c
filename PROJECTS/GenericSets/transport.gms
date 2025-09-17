
$$iftheni.mcd not %SectorAgg%=="MCD" 
atp%1   "Air Transport"
wtp%1   "Water Transport"
$$endif.mcd

$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
    $$ifi %SectorAgg%=="Small"    otp%1    "Transport n.e.s.: Land transport and transport via pipelines"
    $$ifi %SectorAgg%=="MCD"    otp%1      "Transport"
$else.gtap10
    otp%1    "Transport n.e.s."
$endif.gtap10

