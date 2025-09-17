* [EditJean]: lb0 et maplb0 pour aggreger elasticite omegalnd...
* Est-ce necessaire de declarer lb, lb1... cf model\23-BundleOption.gms

*	Values in "%gtpSatDir%\EnvLinkElast.gdx"

* omegat0   	= 0.4
* omeganlb0 	= 0.6
* omegalb0(lb1) = 0.4
* omegalb0(lb2) = 0.6
* omegalb0(lb3) = 0.8

lb0 "Land bundles for Agg" / lb1 * lb3 /

$IfTheni.OneLandBndNest %LandBndNest%=="OneBundle"
    lb "Land bundles"           / TotalLand /
    lb1(lb) "First land bundle" / TotalLand /
    lb2(lb) "Second level land bundle"  /    /

*    $IF NOT SET oGdxDir_ExtScen maplb(lb,a)    "Mapping of activities to land bundles" /
*    $IF     SET oGdxDir_ExtScen maplb(lb,actf) "Mapping of activities to land bundles" /
    maplb(lb,actf)    "Mapping of activities to land bundles" /

        $$IfTheni.SplitCrops %split_acr%=="ON"
            TotalLand.(pdr%1,wht%1,gro%1,v_f%1,osd%1,c_b%1,pfb%1,ocr%1)
        $$ELSE.SplitCrops
                $$ifi %SectorAgg%=="Small"           TotalLand.cro%1
                $$ifi %SectorAgg%=="MCD"             TotalLand.agr%1
        $$EndIf.SplitCrops

        $$IfTheni.SplitLivestock %split_lvs%=="ON"
            TotalLand.(cow%1,nco%1)
        $$ELSE.SplitLivestock
                $$ifi %SectorAgg%=="Small"            TotalLand.lvs%1
        $$EndIf.SplitLivestock
    /

    maplb0(lb,lb0) / TotalLand.lb1  /
$EndIf.OneLandBndNest

$IfTheni.MAGNETLandBndNest %LandBndNest%=="MAGNET"
    lb "Land bundles" /
        NFCP "Non Field Crops and Pasture"
        COP  "Cereals Oilseeds and Protein crops"
        NCOP "Sugar Beet and Livestock"
        /
    lb1(lb) "First land bundle" / NFCP "Non Field Crops and Pasture" /
    lb2(lb) "Second level land bundle"  /
        COP  "Cereals Oilseeds and Protein crops"
        NCOP "Sugar Beet and Livestock"
        /
    maplb(lb,actf)    "Mapping of activities to land bundles" /
        NFCP.(v_f%1,pfb%1,ocr%1,pdr%1)
        COP.(wht%1,gro%1,osd%1)
        NCOP.c_b%1
        $$Ifi %split_lvs%=="ON"  NCOP.(cow%1,nco%1)
        $$Ifi %split_lvs%=="OFF" NCOP.lvs%1
        /
    maplb0(lb,lb0) /
        NFCP.lb1
        (COP,NCOP).lb2
    /
$EndIf.MAGNETLandBndNest



