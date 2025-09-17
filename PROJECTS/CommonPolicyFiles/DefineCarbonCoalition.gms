*------------------------------------------------------------------------------*
*           Define carbon coalitions: rq & mapr(r,rq)                          *
*------------------------------------------------------------------------------*

* Add manually new elements to set "ra" --> for "rq" regions submitted
* to an emissions cap. Could eventually be added in the time-loop

$OnMulti
set ra / Coalition1, Coalition2, Coalition3  /;
$OffMulti

*   Activating some coalitions: define some rq (subset of ra)

* World Coalition

rq("WORLD") = YES ;

* Individual regions are activated at least temporarily to contruct regional caps

LOOP( ra $ (sum(mapr(ra,r),1) eq 1),
    rq(ra) = YES ;
) ;

* Be careful of aggregate region ra composed of only one individual region r --> rq("OEC") = NO;

rq("Coalition1") = YES ;  !! New element for set rq(ra)
rq("Coalition2") = YES ;  !! New element for set rq(ra)
rq("Coalition3") = YES ;  !! New element for set rq(ra)

display "Defined coalitions: (some could be inactive)", rq;

*---    Define regions participating to a given coalition: map(rq,r)

$OnText
   [17June2021]: OLA and IDN are in coalition 2

   [24June2021]: Simon Black - For the bigger G20 cases:
   $25 if an LIC: only India
   $50 if MIC: China, Argentina, Brazil, South Africa, Indonesia, Mexico,
               Russia, Turkey
   $75 if AE:  US, Australia, Canada, Japan, Saudi Arabia, Korea, UK,
               Germany, Italy, France, and rest of EU27.
$OffText

mapr("Coalition1",aus)      = YES ; !! "Australia"
mapr("Coalition1",jpn)      = YES ; !! "Japan"
mapr("Coalition1",usa)      = YES ; !! "United States of America"
mapr("Coalition1",can)      = YES ; !! "Canada"
mapr("Coalition1",kor)      = YES ; !! "South Korea"
mapr("Coalition1",sau)      = YES ; !! "Saudi Arabia"
mapr("Coalition1",fra)      = YES ; !! "France"
mapr("Coalition1",deu)      = YES ; !! "Germany"
mapr("Coalition1",gbr)      = YES ; !! "United Kingdom"
mapr("Coalition1",ita)      = YES ; !! "Italy"
mapr("Coalition1",RESTEU)   = YES ; !! "Rest of EU & Iceland"

* These countries are classified UMI by World Bank (Upper middle income)

mapr("Coalition2",arg)      = YES ; !! "Argentina"          --> UMI
mapr("Coalition2",bra)      = YES ; !! "Brazil"             --> UMI
mapr("Coalition2",chn)      = YES ; !! "China"              --> UMI
mapr("Coalition2",mex)      = YES ; !! "Mexico"             --> UMI
mapr("Coalition2",rus)      = YES ; !! "Russian Federation" --> UMI
mapr("Coalition2",zaf)      = YES ; !! "South Africa"       --> UMI
mapr("Coalition2",tur)      = YES ; !! "Turkey"             --> UMI
mapr("Coalition2",idn)      = YES ; !! "Indonesia"          --> UMI
mapr("Coalition2",OLA)      = YES ; !! "Other developing and emerging Latin America" --> UMI

* These countries are classified LCI by World Bank

mapr("Coalition3",RESTOPEC) = YES ; !! "Other Oil-Exporting countries"
mapr("Coalition3",ind)      = YES ; !! "India"
mapr("Coalition3",ODA)      = YES ; !! "Other developing and emerging East Asia & New Zealand"
mapr("Coalition3",OAF)      = YES ; !! "Other developing and emerging Africa"
mapr("Coalition3",OEURASIA) = YES ; !! "Other developing and emerging Eurasia"



