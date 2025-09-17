*   Generic sectoral aggregation for [OECD-ENV] Model
* Created 21 Janvier 2022

$setlocal step "%1"

*------------------------------------------------------------------------------*
*   1. Set "a" of Original Activities and Commodities                          *
*------------------------------------------------------------------------------*

$IfTheni.step1 %step%=="define_act"

cro	    "All Crops"
lvs	    "Livestock"
frs	    "Forestry"
fsh	    "Fisheries"

coa	    "Coal extraction"
oil	    "Crude Oil extraction"
gas	    "Nat. gas: extraction plus manufacture & distribution"
OMN	    "Other extraction"

fdp	    "Food Products"
txt	    "Textiles"
ppp	    "Paper & Paper Products"
p_c	    "Petroleum and coal products"
crp	    "Chemical products"
nmm	    "Non-metallic minerals"
i_s	    "Iron and Steel"
nfm	    "Non-ferrous metals"
fmp	    "Fabricated metal products"
ele	    "Electronics"
mvh	    "Transport Equipment"
oma	    "Other manufacturing (includes recycling)"

clp	    "Coal powered electricity"
olp	    "Oil powered electricity"
gsp	    "Gas Powered electricity"
nuc	    "Nuclear power"
hyd	    "Hydro power"
wnd	    "Wind power"
sol	    "Solar power"
xel	    "Other power"
etd	    "Electricity transmission and distribution"

wts     "Water supply; sewerage; waste management and remediation activities"
cns     "Construction"
wtp     "Water Transport"
atp     "Air Transport"
otp     "Transport n.e.s.: Land transport and transport via pipelines"
osc     "Other Business services"
osg     "Other collective services"

$Endif.step1



$IfTheni.step1b %step%=="define_comm"

cro	    "All Crops"
lvs	    "Livestock"
frs	    "Forestry"
fsh	    "Fisheries"

coa	    "Coal extraction"
oil	    "Crude Oil extraction"
gas	    "Nat. gas: extraction plus manufacture & distribution"
OMN	    "Other extraction"

fdp	    "Food Products"
txt	    "Textiles"
ppp	    "Paper & Paper Products"
p_c	    "Petroleum and coal products"
crp	    "Chemical products"
nmm	    "Non-metallic minerals"
i_s	    "Iron and Steel"
nfm	    "Non-ferrous metals"
fmp	    "Fabricated metal products"
ele	    "Electronics"
mvh	    "Transport Equipment"
oma	    "Other manufacturing (includes recycling)"

ely	    "Electricity"

wts     "Water supply; sewerage; waste management and remediation activities"
cns     "Construction"
wtp     "Water Transport"
atp     "Air Transport"
otp     "Transport n.e.s.: Land transport and transport via pipelines"
osc     "Other Business services"
osg     "Other collective services"

$Endif.step1b


*------------------------------------------------------------------------------*
*   2. Define set mapa(a0,a) "Mapping of GTAP sectors to model activities a"   *
*------------------------------------------------------------------------------*

$IfTheni.step2 %step%=="define_mapa"

* Agriculture
    (pdr,wht,gro,v_f,osd,c_b,pfb,ocr).cro
    (ctl,oap,rmk,wol).lvs
    frs.frs
    fsh.fsh

* Extraction
    coa.coa
    oil.oil
    gas.gas
    oxt.omn

* Manufacturing
    (cmt,omt,vol,mil,pcr,sgr,ofd,b_t).fdp
    (tex,wap,lea).txt
    ppp.ppp
    p_c.p_c
    chm.crp
    nmm.nmm
    i_s.i_s
    nfm.nfm
    fmp.fmp 
    ele.ele
    (mvh,otn).mvh
    (lum,bph,rpp,eeq,ome,omf).oma

*Services
    $$IfTheni.power %IfPower%=="ON"
        TnD                  . etd
        (NuclearBL,advnuc)   . nuc
        (CoalBL,colccs)      . clp
        (GasBL,GasP,gasccs)  . gsp
        WindBL               . wnd
        (HydroBL,HydroP)     . hyd
        (OilBL,OilP)         . olp
        OtherBL              . xel
        solarP               . sol
    $$ELSE.power
        ely.ely
    $$EndIf.power

    gdt.gas
    wtr.wts
    cns.cns
    otp.otp
    wtp.wtp
    atp.atp
   (trd,afs,whs,cmn,ofi,ins,rsa,obs,ros,dwe).osc
   (osg,edu,hht).osg



$Endif.step2

*------------------------------------------------------------------------------*
*   3. Define set mapaf(i,actf) "Mapping from original to modeled activities"  *
*------------------------------------------------------------------------------*

$IfTheni.step3 %step%=="define_mapaf"

* Agriculture
    cro.cro
    lvs.lvs
    frs.frs
    fsh.fsh

* Extraction
    coa.coa
    oil.oil
    gas.gas
    omn.omn

* Manufacturing
    fdp.fdp
    txt.txt
    ppp.ppp
    p_c.p_c
    crp.crp
    nmm.nmm
    i_s.i_s
    nfm.nfm
    fmp.fmp
    ele.ele
    mvh.mvh
    oma.oma

* Services

    $$IfTheni.power %IfPower%=="ON"
        clp.clp
        olp.olp
        gsp.gsp
        nuc.nuc
        hyd.hyd
        wnd.wnd
        sol.sol
        xel.xel
        etd.etd
    $$ELSE.power
        ely.ely
    $$EndIf.power

    wts.wts
    cns.cns
    atp.atp
    otp.otp
    wtp.wtp
    osg.osg
    osc.osc
 
$Endif.step3

*------------------------------------------------------------------------------*
*  4. Define set mapIF(i,commf) "Mapping from original to modeled commodities" *
*------------------------------------------------------------------------------*

$IfTheni.step4 %step%=="define_mapif"

* Agriculture
    cro.cro
    lvs.lvs
    frs.frs
    fsh.fsh

* Extraction
    coa.coa
    oil.oil
    gas.gas
    omn.omn

* Manufacturing
    fdp.fdp
    txt.txt
    ppp.ppp
    p_c.p_c
    crp.crp
    nmm.nmm
    i_s.i_s
    nfm.nfm
    fmp.fmp
    ele.ele
    mvh.mvh
    oma.oma

* Services
 
    $$IfTheni.power %IfPower%=="ON"
        clp.ely
        olp.ely
        gsp.ely
        nuc.ely
        hyd.ely
        wnd.ely
        sol.ely
        xel.ely
        etd.ely
    $$ELSE.power
        ely.ely
    $$EndIf.power

    wts.wts
    cns.cns
    atp.atp
    otp.otp
    wtp.wtp
    osc.osc
    osg.osg

$Endif.step4

*------------------------------------------------------------------------------*
*     5a. Save sectoral sort mapping: mapActSort(sortOrder,actf)               *
*------------------------------------------------------------------------------*

$IfTheni.step5a %step%=="define_mapActSort"

    sort1   .cro
    sort2   .lvs
    sort3   .frs
    sort4   .fsh
    sort5   .coa
    sort6   .oil
    sort7   .gas
    sort8   .omn
    sort9   .fdp
    sort10  .txt
    sort11  .ppp
    sort12  .p_c
    sort13  .crp
    sort14  .nmm
    sort15  .i_s
    sort16  .nfm
    sort17  .fmp
    sort18  .ele
    sort19  .mvh
    sort20  .oma

    $$IfTheni.power %IfPower%=="ON"
        sort21.clp
        sort22.olp
        sort23.gsp
        sort24.nuc
        sort25.hyd
        sort26.wnd
        sort27.sol
        sort28.xel
        sort29.etd
    $$ELSE.power
        sort29.ely
    $$EndIf.power

    sort30.wts
    sort31.cns
    sort32.otp
    sort33.wtp
    sort34.atp
    sort35.osc
    sort36.osg

$Endif.step5a

*------------------------------------------------------------------------------*
*     5b. Save commodity sort mapping: mapCommSort(sortOrder,commf)            *
*------------------------------------------------------------------------------*

$IfTheni.step5b %step%=="define_mapCommSort"


    sort1   .cro
    sort2   .lvs
    sort3   .frs
    sort4   .fsh
    sort5   .coa
    sort6   .oil
    sort7   .gas
    sort8   .omn
    sort9   .fdp
    sort10  .txt
    sort11  .ppp
    sort12  .p_c
    sort13  .crp
    sort14  .nmm
    sort15  .i_s
    sort16  .nfm
    sort17  .fmp
    sort18  .ele
    sort19  .mvh
    sort20  .oma
    sort21  .ely
    sort22  .wts
    sort23  .cns
    sort24  .otp
    sort25  .wtp
    sort26  .atp
    sort27  .osc
    sort28  .osg

$Endif.step5b

*------------------------------------------------------------------------------*
* 6.a mapia(ia,commf) "mapping of individual commodity to aggregate commodity" *
*------------------------------------------------------------------------------*
* useless can be done with set definition in "map.gms"

$IfTheni.step6a %step%=="define_mapia"

    tagr-c.(cro,lvs,frs,fsh)
    tman-c.(omn,fdp,txt,ppp,crp,nmm,i_s,nfm,fmp,ele,mvh,oma)
    toth-c.(coa,oil,p_c,gas,ely)
    tsrv-c.(wts,cns,atp,wtp,otp,osc,osg)

$Endif.step6a

*------------------------------------------------------------------------------*
* 6.b mapaga(aga,actf) "mapping of individual sector to aggregate sector"      *
*------------------------------------------------------------------------------*
* useless can be done with set definition in "map.gms"

$IfTheni.step6b %step%=="define_mapaga"

    tagr-a.(cro,lvs,frs,fsh)
    tman-a.(omn,fdp,txt,ppp,crp,nmm,i_s,nfm,fmp,ele,mvh,oma)
    toth-a.(coa,oil,p_c,gas)
    $$IfTheni.power %IfPower%=="ON"
        toth-a.(clp,olp,gsp,nuc,hyd,wnd,sol,xel,etd)
    $$ELSE.power
        toth-a.ely
    $$EndIf.power
    tsrv-a.(wts,cns,atp,wtp,otp,osc,osg)

$Endif.step6b

$droplocal step


