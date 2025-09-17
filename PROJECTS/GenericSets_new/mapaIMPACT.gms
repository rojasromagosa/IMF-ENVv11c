* Generic mapping of model activity 'a' with IMPACT sectors 'IMPACTa0'
* --> Set mapaIMPACT(a,IMPACTa0)

$IfTheni.SplitCrops %split_acr%=="ON"
   pdr.(pdri,pdrn)
   wht.(whti,whtn)
   gro.(groi,gron)
   v_f.(v_fi,v_fn)
   osd.(osdi,osdn)
   c_b.(c_bi,c_bn)
   pfb.(pfbi,pfbn)
   ocr.(ocri,ocrn)
$ELSE.SplitCrops
      $$ifi %SectorAgg%=="Small"      cro.(pdri,pdrn,whti,whtn,groi,gron,v_fi,v_fn)
      $$ifi %SectorAgg%=="Small"      cro.(osdi,osdn,c_bi,c_bn,pfbi,pfbn,ocri,ocrn)
      $$ifi %SectorAgg%=="MCD"        agr.(pdri,pdrn,whti,whtn,groi,gron,v_fi,v_fn)
      $$ifi %SectorAgg%=="MCD"        agr.(osdi,osdn,c_bi,c_bn,pfbi,pfbn,ocri,ocrn)
$EndIf.SplitCrops

$IfTheni.SplitLivestock %split_lvs%=="ON"
   cow.(ctl,rmk)
   nco.oap
$ELSE.SplitLivestock
      $$ifi %SectorAgg%=="MCD"      agr.(ctl,rmk,oap)
      $$ifi %SectorAgg%=="Small"    lvs.(ctl,rmk,oap)
$EndIf.SplitLivestock

$$ifi %SectorAgg%=="Small" fdp.(sgr,vol)
$$ifi %SectorAgg%=="MCD" oma.(sgr,vol)