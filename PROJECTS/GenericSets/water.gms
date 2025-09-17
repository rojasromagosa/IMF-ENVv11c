$$iftheni %SectorAgg%=="Small"
    $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
        wts%1   "Water supply; sewerage; waste management and remediation activities"
    $$else.gtap10
        wts%1   "Water supply (collection, purification and distribution)"
    $$endif.gtap10
$$endif