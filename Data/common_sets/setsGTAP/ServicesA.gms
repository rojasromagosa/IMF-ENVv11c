
*---    Set of Services Activities (transportation excluded)

cmn   	"Communication"   !! Communications: post and telecommunications
ofi   	"Financial services n.e.s."
%ins%	"Insurance"
ros   	"Recreation and other services"
dwe   	"Dwellings"

$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above

    trd   "Trade" !! including repairs of motor vehicles and personal and household goods and hotels and restaurants
    afs   "Accomodation and food service activities"
    whs   "Warehousing and support activities" !! split from otp

    osg   "Public administration and defense"
    edu   "Education"
    hht   "Human health and social work"

    obs   "Business services n.e.s." !! including R&D and internet
    rsa   "Real estate activities"

$else.gtap10

    trd   "Trade" !! including repairs of motor vehicles and personal and household goods and hotels and restaurants
    osg   "Public administration and defense, education, health services"
    obs   "Business services n.e.s. including Real estate activities"

$endif.gtap10
