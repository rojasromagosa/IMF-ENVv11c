$IfTheni.SplitLvs %split_lvs% =="ON"
    cow%1   "Livestock: Cattle and Raw Milk"
    nco%1   "Livestock: other animals"
$Else.SplitLvs
    $$ifi %SectorAgg%=="Small"   lvs%1   "Livestock"
$Endif.SplitLvs
