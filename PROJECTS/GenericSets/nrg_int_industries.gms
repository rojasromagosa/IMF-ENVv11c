    $$IfTheni.Spliteim not %SectorAgg%=="MCD"
        ppp%1   "Paper & Paper Products"
        nmm%1   "Non-metallic minerals"
        i_s%1   "Iron and Steel"
        $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
            crp%1   "Chemical products" !! from old crp sector
        $$else.gtap10
            crp%1   "Chemicals, rubber, plastic products and pharmaceutical"
        $$endif.gtap10
    $$else.Spliteim
            $$ifi %SectorAgg%=="MCD"         eim%1     "Energy intensive manufacturing industries"
    $$endif.Spliteim