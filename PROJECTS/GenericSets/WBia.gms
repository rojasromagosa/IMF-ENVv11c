* World Bank sectors for the set "ia" : Aggregate commodities for model output

$Setargs step suffix index map

*   Fill set "ia" and "aga" with the following WB commodities and sectors

$IfThen.step1 %step%=="define_Sector"

    tagr%suffix%   "Primary Sectors / Commodities"
    tman%suffix%   "Manufacturing"
    tsrv%suffix%   "Services"
    toth%suffix%   "Other industries" !! utilities, extraction, construction
    ttot%suffix%   "Total"

$Endif.step1

*   Mapping with World Bank commodities (%map%=mapia) and sectors (%map%=mapaga)

$IfThen.step2 %step%=="mapping"

    %map%("tagr%suffix%",cr%index%)             = YES ;
    %map%("tagr%suffix%",lv%index%)             = YES ;
    %map%("tagr%suffix%",forestry%index%)       = YES ;
    %map%("tagr%suffix%",Fishery%index%)        = YES ;

    %map%("toth%suffix%",e%index%)              = YES ;
    %map%("toth%suffix%",wtr%index%)            = YES ;
    %map%("toth%suffix%",mining%index%)         = YES ;
    %map%("toth%suffix%",construction%index%)   = YES ;

    %map%("tsrv%suffix%",pubserv%index%)        = YES ;
    %map%("tsrv%suffix%",privserv%index%)       = YES ;
    %map%("tsrv%suffix%",transport%index%)      = YES ;

    %map%("tman%suffix%",frt%index%)            = YES ;
    %map%("tman%suffix%",oman%index%)           = YES ;
    %map%("tman%suffix%",cement%index%)         = YES ;
    %map%("tman%suffix%",MTE%index%)            = YES ;
    %map%("tman%suffix%",PPP%index%)            = YES ;
    %map%("tman%suffix%",I_S%index%)            = YES ;
    %map%("tman%suffix%",ELE%index%)            = YES ;
    %map%("tman%suffix%",FMP%index%)            = YES ;
    %map%("tman%suffix%",wood%index%)           = YES ;
    %map%("tman%suffix%",NFM%index%)            = YES ;
    %map%("tman%suffix%",FDP%index%)            = YES ;
    %map%("tman%suffix%",TXT%index%)            = YES ;

$Endif.step2

$DropLocal step


