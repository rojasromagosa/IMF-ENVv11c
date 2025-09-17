*	Set of Transportation Services

wtp   "Sea transport"
atp   "Air transport"

$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
    otp   "Transport n.e.s.: Land transport and transport via pipelines"
$else.gtap10
    otp   "Transport n.e.s."
$endif.gtap10
