$IfTheni.SplitCrops %split_acr%=="ON"
    pdr-%1.pdr
    wht-%1.wht
    gro-%1.gro
    v_f-%1.v_f
    osd-%1.osd
    c_b-%1.c_b
    pfb-%1.pfb
    ocr-%1.ocr
$ELSE.SplitCrops
    cro-%1.(pdr,wht,gro,v_f,osd,c_b,pfb,ocr)
$EndIf.SplitCrops
$IfTheni.SplitLivestock %split_lvs%=="ON"
    cow-%1.lvs
    nco-%1.lvs
$ELSE.SplitLivestock
    lvs-%1.lvs
$EndIf.SplitLivestock
frs-%1.frs
fsh-%1.fsh

coa-%1.coa
oil-%1.oil
gas-%1.gas
$Ifi %split_gas%=="ON" gdt-%1.gas
p_c-%1.p_c

fdp-%1.fdp
txt-%1.txt
ppp-%1.ppp
omn-%1.omn
crp-%1.crp
nmm-%1.nmm
fmp-%1.fmp
ele-%1.ele
i_s-%1.i_s
nfm-%1.nfm
mvh-%1.mvh

$IfTheni.SplitOma %split_oma%=="ON"
    lum-%1.oma
    otn-%1.oma
    omf-%1.oma
    ome-%1.oma
    $$IfTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
        eeq-%1.oma
        bph-%1.oma
        rpp-%1.oma
    $$endif.gtap10
$else.SplitOma
    oma-%1.oma
$Endif.SplitOma

wts-%1.wtr
cns-%1.cns
otp-%1.otp
wtp-%1.wtp
atp-%1.atp

osg-%1.osg
$IfTheni.SplitService %split_ser%=="ON"
    $$ifE %GTAP_ver%>99 (edu-%1,hht-%1).osg
$Endif.SplitService

$IfTheni.SplitService %split_ser%=="ON"
    trd-%1.osc
    osc-%1.osc
    obs-%1.osc
$else.SplitService
    osc-%1.osc
$Endif.SplitService

