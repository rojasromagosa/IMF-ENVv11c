fp  "Factors of production"  /
    Land    "Land"
    Capital "Capital"
    NatRes  "Natural Resources"
    Labour  "Total Labour Force"
    $$IF %ifWaterSup%=="ON" wat
/

l(fp)   "Categories of workers"  / Labour    "Total Labour Force" /
ul(l)   "Unskilled labor (substitute to capital)" / Labour  "Total Labour Force" /
lr(l)   "Labor used to define reference wage for skill premium" / Labour "Total Labour Force" /
cap(fp) "Physical Capital" / Capital /
nrs(fp) "Natural resource" / NatRes /
lnd(fp) "Land endowment"   / Land /
$IF %ifWaterSup%=="ON" wat(fp) /  wat /
