z "Geographical Zones" /
   rur "Rural zone"
   urb "Urban zone"
/
rur(z) "Rural zone" / rur "Rural zone" /
urb(z) "Urban zone" / urb "Urban zone" /

mapz(z,a) "Mapping of activities to zones" /
    $$IfTheni.SplitCrops %split_acr%=="ON"
        rur.(pdr-a,wht-a,gro-a,v_f-a,osd-a,c_b-a,pfb-a,ocr-a)
    $$Else.SplitCrops
        rur.cro-a
    $$Endif.SplitCrops
    $$IfTheni.SplitLvs %split_lvs%=="ON"
        rur.(cow-a,nco-a)
    $$Else.SplitLvs
        rur.lvs-a
    $$Endif.SplitLvs
/
