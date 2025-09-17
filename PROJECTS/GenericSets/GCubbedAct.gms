$setlocal step "%1"

* List of G-Cubed commodities

$IfTheni.step1 %step%=="Activity"
    "Electricity delivery"
    "Gas extraction and utilities"
    "Petroleum refining"
    "Coal mining"
    "Crude oil extraction"
    "Construction"
    "Other mining"
    "Agriculture and forestry"
    "Durable goods"
    "Nondurable goods"
    "Transportation"
    "Services"
$Endif.step1

* List of G-cubed Sectors

$IfTheni.step2 %step%=="Sector"
    "Electricity delivery"
    "Gas extraction and utilities"
    "Petroleum refining"
    "Coal mining"
    "Crude oil extraction"
    "Construction"
    "Other mining"
    "Agriculture and forestry"
    "Durable goods"
    "Nondurable goods"
    "Transportation"
    "Services"
    "Coal generation"
    "Natural gas generation"
    "Petroleum generation"
    "Nuclear generation"
    "Wind generation"
    "Solar generation"
    "Hydroelectric generation"
    "Other generation"
$Endif.step2

* mapping G-cubed activities

$IfTheni.step3 %step%=="mapia"

    $$IfTheni.SplitCrops %split_acr%=="ON"
        "Agriculture and forestry".(pdr,wht,gro,v_f,osd,c_b,pfb,ocr)
    $$Else.SplitCrops
        "Agriculture and forestry".cro
    $$EndIf.SplitCrops

    $$IfTheni.SplitLivestock %split_lvs%=="ON"
        "Agriculture and forestry".(cow,nco)
    $$Else.SplitLivestock
        "Agriculture and forestry".lvs
    $$EndIf.SplitLivestock

    "Agriculture and forestry".(frs,fsh)

    "Gas extraction and utilities".gas
    $$Ifi %split_gas%=="ON" "Gas extraction and utilities".gdt
    "Coal mining".coa
    "Crude oil extraction".oil
    "Petroleum refining".p_c
    "Construction".cns
    "Services".wts
    "Other mining".omn

    "Transportation".(atp,wtp,otp)
    $$Ifi %split_ser%=="ON" "Services".(trd,obs,edu,hht)
    "Services".(osc,osg)

    "Nondurable goods".(ppp,crp,fdp,txt)
    "Durable goods".(nmm,i_s,nfm,fmp,ele,mvh)
    $$IfTheni.SplitOma %split_oma%=="ON"
        "Durable goods".lum
        "Durable goods".otn
        "Durable goods".omf
        "Durable goods".ome
        "Durable goods".eeq
        "Nondurable goods".bph
        "Nondurable goods".rpp
    $$else.SplitOma
        "Durable goods".oma !! OMA include Durable & Non-Durables
    $$Endif.SplitOma

$Endif.step3


* mapping G-cubed sectors

$IfTheni.step4 %step%=="mapaga"

    $$IfTheni.power %IfPower%=="ON"
        "Coal generation".clp
        "Petroleum generation".olp
        "Natural gas generation".gsp
        "Nuclear generation"      .nuc
        "Hydroelectric generation".hyd
        "Wind generation".wnd
        "Solar generation".sol
        "Other generation".xel
        "Electricity delivery".etd
    $$ELSE.power
        "Electricity delivery".ely
    $$EndIf.power

$Endif.step4

*   Mapping with G-cubbed commodities and sectors

$IfThen.step4b %step%=="mapping"

    mapia("Electricity delivery",ely%2)          = YES ;

    mapia("Gas extraction and utilities",NGAS%2) = YES ;
    mapia("Gas extraction and utilities",GDT%2)  = YES ;

    mapia("Petroleum refining",ROIL%2)           = YES ;

    mapia("Coal mining",COA%2)                   = YES ;

    mapia("Crude oil extraction",COIL%2)         = YES ;

    mapia("Agriculture and forestry",cr%2)       = YES ;
    mapia("Agriculture and forestry",lv%2)       = YES ;
    mapia("Agriculture and forestry",forestry%2) = YES ;
    mapia("Agriculture and forestry",Fishery%2)  = YES ;

    mapia("Services",wtr%2)                      = YES ;
    mapia("Services",pubserv%2)                  = YES ;
    mapia("Services",privserv%2)                 = YES ;

    mapia("Other mining",mining%2)               = YES ;

    mapia("Construction",construction%2)         = YES ;

    mapia("Transportation",transport%2)          = YES ;

    mapia("Nondurable goods",frt%2)              = YES ;
    mapia("Nondurable goods",PPP%2)              = YES ;
    mapia("Nondurable goods",FDP%2)              = YES ;
    mapia("Nondurable goods",TXT%2)              = YES ;

    mapia("Durable goods",cement%2)              = YES ;
    mapia("Durable goods",MTE%2)                 = YES ;
    mapia("Durable goods",I_S%2)                 = YES ;
    mapia("Durable goods",ELE%2)                 = YES ;
    mapia("Durable goods",FMP%2)                 = YES ;
    mapia("Durable goods",wood%2)                = YES ;
    mapia("Durable goods",NFM%2)                 = YES ;
    mapia("Durable goods",oman%2)                = YES ;

$Endif.step4b

*   Mapping with G-cubbed commodities and sectors

$IfThen.step4c %step%=="mappinga"

    mapaga("Electricity delivery",etd%2)          = YES ;
    mapaga("Coal generation","clp")               = YES ;
    mapaga("Petroleum generation","olp")          = YES ;
    mapaga("Natural gas generation","gsp")        = YES ;
    mapaga("Nuclear generation","nuc")            = YES ;
    mapaga("Hydroelectric generation","hyd")      = YES ;
    mapaga("Wind generation","wnd")               = YES ;
    mapaga("Solar generation","sol")              = YES ;
    mapaga("Other generation","xel")              = YES ;

    mapaga("Gas extraction and utilities",NGAS%2) = YES ;
    mapaga("Gas extraction and utilities",GDT%2)  = YES ;

    mapaga("Petroleum refining",ROIL%2)           = YES ;

    mapaga("Coal mining",COA%2)                   = YES ;

    mapaga("Crude oil extraction",COIL%2)         = YES ;

    mapaga("Agriculture and forestry",cr%2)       = YES ;
    mapaga("Agriculture and forestry",lv%2)       = YES ;
    mapaga("Agriculture and forestry",forestry%2) = YES ;
    mapaga("Agriculture and forestry",Fishery%2)  = YES ;

    mapaga("Services",wtr%2)                      = YES ;
    mapaga("Services",pubserv%2)                  = YES ;
    mapaga("Services",privserv%2)                 = YES ;

    mapaga("Other mining",mining%2)               = YES ;
    mapaga("Construction",construction%2)         = YES ;

    mapaga("Transportation",transport)            = YES ;

    mapaga("Nondurable goods",frt%2)              = YES ;
    mapaga("Nondurable goods",PPP%2)              = YES ;
    mapaga("Nondurable goods",FDP%2)              = YES ;
    mapaga("Nondurable goods",TXT%2)              = YES ;

    mapaga("Durable goods",cement%2)              = YES ;
    mapaga("Durable goods",MTE%2)                 = YES ;
    mapaga("Durable goods",I_S%2)                 = YES ;
    mapaga("Durable goods",ELE%2)                 = YES ;
    mapaga("Durable goods",FMP%2)                 = YES ;
    mapaga("Durable goods",wood%2)                = YES ;
    mapaga("Durable goods",NFM%2)                 = YES ;
    mapaga("Durable goods",oman%2)                = YES ;

$Endif.step4c

$droplocal step