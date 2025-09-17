*   GTAP sectoral set:  Crops Activities

$IfTheni.wtrData %ifWater%=="OFF"

    pdr " Paddy Rice                                 "
    wht " Wheat (and meslin)                         "
    gro " Other Grains (maize, barley, rye, oats, other cereals) "
    v_f " Vegetables and fruits                      "
    osd " Oil Seeds                                  "
    c_b " Sugar cane and sugar beet                  "
    pfb " Plant Fibres (cotton, flax, hemp, sisal and other raw vegetable materials used in textiles) "
    ocr " Other Crops (flowers, forage, tobacoo,..)  "

$Else.wtrData

*   Set of RainFed crops activities

    pdrn  "Paddy rice--rainfed"
    whtn  "Wheat--rainfed"
    gron  "Cereal grains, n.e.s.--rainfed"
    v_fn  "Vegetables and fruits--rainfed"
    osdn  "Oil seeds--rainfed"
    c_bn  "Sugar cane and sugar beet--rainfed"
    pfbn  "Plant-based fibers--rainfed"
    ocrn  "Crops, n.e.s.--rainfed"

*   Set of IRrigated crops activities

    pdri  "Paddy rice--irrigated"
    whti  "Wheat--irrigated"
    groi  "Cereal grains, n.e.s.--irrigated"
    v_fi  "Vegetables and fruits--irrigated"
    osdi  "Oil seeds--irrigated"
    c_bi  "Sugar cane and sugar beet--irrigated"
    pfbi  "Plant-based fibers--irrigated"
    ocri  "Crops, n.e.s.--irrigated"

$EndIf.wtrData
