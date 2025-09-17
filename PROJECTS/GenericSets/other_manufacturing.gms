
$IfTheni.SplitOma %split_oma%=="ON"
    fmp%1   "Fabricated metal products"
    ele%1   "Electronics"
    nfm%1   "Non-ferrous metals"
    lum%1   "Wood products"
    otn%1   "Other transport equipment"
    omf%1   "Other manufacturing (includes recycling)"
    ome%1   "Machinery and equipment n.e.s."

    $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
        eeq%1   "Electrical equipment"        !! from old ome
        bph%1   "Basic pharmaceuticals"       !! from old crp sector
        rpp%1   "Rubber and plastic products" !! from old crp sector
    $$endif.gtap10

    mvh%1   "Motor vehicles"

$Else.SplitOma

    $$ifi %SectorAgg%=="MCD" oma%1   "Other manufacturing (includes recycling)"

$Endif.SplitOma

