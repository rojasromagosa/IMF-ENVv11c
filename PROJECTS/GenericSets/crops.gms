*   Model sectoral set:  Crops Activities

$IfTheni.SplitCrops %split_acr%=="ON"

    pdr%1   "Paddy Rice"
    wht%1   "Wheat and meslin"
    gro%1   "Other Grains"
    v_f%1   "Vegetables and fruits"
    osd%1   "Oil Seeds"
    c_b%1   "Sugar cane and sugar beet"
    pfb%1   "Plant Fibres"
    ocr%1   "Other Crops"

$Else.SplitCrops

    $$ifi %SectorAgg%=="Small"   cro%1   "All Crops"
    $$ifi %SectorAgg%=="MCD"     agr%1   "Agriculture"

$EndIf.SplitCrops
