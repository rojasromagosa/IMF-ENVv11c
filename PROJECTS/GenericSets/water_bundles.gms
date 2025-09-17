wbnd             "Aggregate water markets" /   N_A "N_A" /
wbnd1(wbnd)      "Top level water markets"    / /
wbnd2(wbnd)      "Second level water markets" / /
wbndEx(wbnd)     "Exogenous water markets"   / /
mapw1(wbnd,wbnd) "Mapping of first level water bundles" / /

wbnda(wbnd)      "Water bundles mapped one-to-one to activities" / /
wbndi(wbnd)      "Water bundles mapped to aggregate output" / /

* I do not understand this anymore

*$IF NOT SET EnvLinkProject mapw2(wbnd,a)    "Mapping of second level water bundles" / /
*$IF     SET EnvLinkProject mapw2(wbnd,actf) "Mapping of second level water bundles" / /

mapw2(wbnd,actf)    "Mapping of second level water bundles" / /

*  Mapping of water bundles to GTAP sectors

mapw(wbnd0,wbnd2) "Aggregate water markets" /  /

*---    Mapping of water bundles
*set mapw(wbnd0,wbnd2) "Aggregate water markets"
*    crp.crp
*    lvs.lvs
*    ind.ind
*    mun.mun
*/;
