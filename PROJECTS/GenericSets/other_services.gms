*---    Set of Services Activities (transportation excluded)

$IfTheni.SplitService %split_ser%=="ON"

    osc%1  "Other Financial services (including Dwellings, insurance,real estate)"
    trd%1   "Trade (including accomodation, wharehousing)" !! including repairs of motor vehicles and personal and household goods and hotels and restaurants

*---    Split more:

*    $$IfTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
*       afs%1   "Accomodation and food service activities"
*       whs%1   "Warehousing and support activities"
*    $$endif.gtap10

    obs%1   "Other Business Services nec. and communication" !! including R&D and internet

*---    Split more:

*    $$IfTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
*       ins%1   "Insurance"
*       rsa%1   "Real estate activities"
*    $$endif.gtap10

    $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
        edu%1   "Education"
        hht%1   "Human health and social work"
    $$endif.gtap10

$else.SplitService

    osc%1  "Other Business services" !! including R&D and internet

$Endif.SplitService

* In gtap 10 osg has been split in osg (Public administration and defense, compulsory social security)

osg%1  "Other collective services"

