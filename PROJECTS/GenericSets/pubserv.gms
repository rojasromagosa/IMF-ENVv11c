*---    Collective services

$IfTheni.SplitService %split_ser%=="ON"

    $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
        edu%1   "Education"
        hht%1   "Human health and social work"
    $$endif.gtap10

$Endif.SplitService

* In gtap 10 osg has been split in osg (Public administration and defense, compulsory social security)

osg%1  "Other collective services"

