*   Generic sectoral aggregation for [OECD-ENV] Model
* Created 21 Janvier 2022

$setlocal step "%1"

*------------------------------------------------------------------------------*
*   1. Set "a" of Original Activities and Commodities                          *
*------------------------------------------------------------------------------*

$IfTheni.step1 %step%=="define_act"

    $$batinclude "%sDir%\crops.gms"
    $$batinclude "%sDir%\livestock.gms"
    $$batinclude "%sDir%\pdt_emi.gms"
    $$batinclude "%sDir%\transport.gms"
    $$batinclude "%sDir%\pubserv.gms"
    $$batinclude "%sDir%\privserv.gms"
    $$batinclude "%sDir%\construction.gms"
    $$batinclude "%sDir%\nrg_int_industries.gms"
    $$batinclude "%sDir%\other_manufacturing.gms"
    $$batinclude "%sDir%\water.gms"
    $$batinclude "%sDir%\food.gms"
    $$batinclude "%sDir%\textiles.gms"
    $$batinclude "%sDir%\other_nat_res.gms"
    $$batinclude "%sDir%\mining.gms"

* %2 = Flag on Power, for commf could be "OFF" --> one electricity good

    $$batinclude "%sDir%\power.gms" "" "%2"

$Endif.step1


*------------------------------------------------------------------------------*
*   2. Define set mapa(a0,a) "Mapping of GTAP sectors to model activities a"   *
*------------------------------------------------------------------------------*

$IfTheni.step2 %step%=="define_mapa"

*    Primary sectors

* [TBU] if needed

*    $$ifTheni.wtr %ifWater%=="ON"
*        (pdri,whti,groi,v_fi,osdi,c_bi,pfbi,ocri).GrainsCrops
*        (pdrn,whtn,gron,v_fn,osdn,c_bn,pfbn,ocrn).GrainsCrops
*    $$ELSE.wtr
*        (pdr,wht,gro,v_f,osd,c_b,pfb,ocr).GrainsCrops
*    $$endif.wtr

    $$IfTheni.SplitCrops %split_acr%=="ON"
        pdr.pdr
        wht.wht
        gro.gro
        v_f.v_f
        osd.osd
        c_b.c_b
        pfb.pfb
        ocr.ocr
    $$ELSE.SplitCrops
        (pdr,wht,gro,v_f,osd,c_b,pfb,ocr).agr
    $$EndIf.SplitCrops

    $$IfTheni.SplitLivestock %split_lvs%=="ON"
        (ctl,rmk).cow
        (oap,wol).nco
    $$ELSE.SplitLivestock
        (ctl,oap,rmk,wol).agr
    $$EndIf.SplitLivestock
    frs.frs
    fsh.agr

*   Utilities and other non-manufacturing industries

    wtr.oma
    %oxt%.oma

    cns.cns

* ...of which Fossil fuels

    coa.coa
    oil.oil
    p_c.p_c
    gas.gas
    $$Ifi %split_gas%=="ON"  gdt.gdt
    $$Ifi %split_gas%=="OFF" gdt.gas

* ...of which Power

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

*   Manufacturing

* ...of which energy intensive industries

    $$IfTheni.SplitEim %split_eim%=="ON"
    ppp.ppp
    nmm.nmm
    i_s.i_s
    %chm%.crp
    $$else.SplitEim
    ppp.eim
    nmm.eim
    i_s.eim
    %chm%.eim
    $$endif.SplitEim
* ...of which other manufacturing

    ele.oma
    (cmt,omt,vol,mil,pcr,sgr,ofd,b_t).oma
    (tex,wap,lea).oma
    fmp.oma

    $$IfTheni.SplitOma %split_oma%=="ON"
        nfm.nfm        
        mvh.mvh
        lum.lum
        otn.otn
        omf.omf
        ome.ome
        $$IfTheni.gtap10 Not %GTAP_ver%=="92" !! GTAP version 10 and above
            eeq.eeq
            bph.bph
            rpp.rpp
        $$endif.gtap10
    $$else.SplitOma
        nfm.oma
        (mvh,otn).oma
        (lum,omf,ome).oma
        $$Ifi Not %GTAP_ver%=="92" (eeq,bph,rpp).oma
    $$Endif.SplitOma

*   Services

*...of which transportation services

    atp.otp
    otp.otp
    wtp.otp

*...of which collective services

    osg.osg

    $$IfTheni.SplitService %split_ser%=="ON"
        $$Ifi Not %GTAP_ver%=="92" edu.edu
        $$Ifi Not %GTAP_ver%=="92" hht.hht
    $$else.SplitService
        $$Ifi Not %GTAP_ver%=="92" (edu,hht).osg
    $$Endif.SplitService

*...of which business services

    $$IfTheni.SplitService %split_ser%=="ON"
        trd.trd
        $$Ifi Not %GTAP_ver%=="92" (whs,afs).trd
        (ofi,ros,dwe).osc
        $$Ifi Not %GTAP_ver%=="92" rsa.osc
        %ins%.osc
        (obs,cmn).obs
    $$else.SplitService
        (trd,cmn,ofi,obs,ros,dwe)               .osc
        $$Ifi Not %GTAP_ver%=="92" (afs,whs,rsa).osc
        %ins%                                   .osc
    $$Endif.SplitService

$Endif.step2

*------------------------------------------------------------------------------*
*   3. Define set mapaf(i,actf) "Mapping from original to modeled activities"  *
*------------------------------------------------------------------------------*

* [EditJean]: Ici la matrice est diagonnale car on ne regroupe pas des
* biens/secteurs differents dans un seul secteur
* pas besoin de lire cette etape - Je la garde pour un cas moins g�n�rique

$IfTheni.step3 %step%=="define_mapaf"

*---    Primary sectors

    $$IfTheni.SplitCrops %split_acr%=="ON"
        pdr.pdr
        wht.wht
        gro.gro
        v_f.v_f
        osd.osd
        c_b.c_b
        pfb.pfb
        ocr.ocr
    $$ELSE.SplitCrops
        agr.agr
    $$EndIf.SplitCrops
    $$IfTheni.SplitLivestock %split_lvs%=="ON"
        cow.cow
        nco.nco
    $$ELSE.SplitLivestock
    frs.frs

*   Utilities and other non-manufacturing industries

    cns.cns

* ...of which Fossil fuels

    coa.coa
    oil.oil
    p_c.p_c
    gas.gas
    $$Ifi %split_gas%=="ON" gdt.gdt

* ...of which Power sectors

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

*---   Manufacturing activities

* ...of which energy intensive industries
    $$IfTheni.SplitEim %split_oma%=="ON"
    ppp.ppp
    nmm.nmm
    i_s.i_s
    nfm.nfm
    %chm%.crp
    $$else.SplitEim
    eim.eim
    $$endif.SplitEim


* ...of which other manufacturing

    $$IfTheni.SplitOma %split_oma%=="ON"
        lum.lum
        otn.otn
        omf.omf
        ome.ome
        $$IfTheni.gtap10 Not %GTAP_ver%=="92" !! GTAP version 10 and above
            eeq.eeq
            bph.bph
            rpp.rpp
        $$endif.gtap10
    $$else.SplitOma
        oma.oma
    $$Endif.SplitOma

*---   Services

* ...of which transportation services

    otp.otp

*...of which collective services

    $$IfTheni.SplitService %split_ser%=="ON"
        $$Ifi Not %GTAP_ver%=="92" edu.edu
        $$Ifi Not %GTAP_ver%=="92" hht.hht
    $$Endif.SplitService

*...of which business services

    osc.osc
    $$IfTheni.SplitService %split_ser%=="ON"
        obs.obs
        trd.trd
    $$Endif.SplitService

$Endif.step3

*------------------------------------------------------------------------------*
*  4. Define set mapIF(i,commf) "Mapping from original to modeled commodities" *
*------------------------------------------------------------------------------*

$IfTheni.step4 %step%=="define_mapif"

*---    Primary sectors

    $$IfTheni.SplitCrops %split_acr%=="ON"
        pdr.pdr
        wht.wht
        gro.gro
        v_f.v_f
        osd.osd
        c_b.c_b
        pfb.pfb
        ocr.ocr
    $$ELSE.SplitCrops
        agr.agr
    $$EndIf.SplitCrops
    $$IfTheni.SplitLivestock %split_lvs%=="ON"
        cow.cow
        nco.nco
    $$EndIf.SplitLivestock
    frs.frs

*---    Utilities and other non-manufacturing industries

    cns.cns
    wts.wts

* ...of which Fossil fuels

    coa.coa
    oil.oil
    p_c.p_c
    gas.gas
    $$Ifi %split_gas%=="ON" gdt.gdt

* ...of which Electricity

    $$IfTheni.power %IfPower%=="ON"
        $$IfTheni.DesAggEly %IfElyGoodDesag%=="ON"
            clp.clp
            olp.olp
            gsp.gsp
            nuc.nuc
            hyd.hyd
            wnd.wnd
            sol.sol
            xel.xel
            etd.etd
        $$Else.DesAggEly
            clp.ely
            olp.ely
            gsp.ely
            nuc.ely
            hyd.ely
            wnd.ely
            sol.ely
            xel.ely
            etd.ely
        $$EndIf.DesAggEly
    $$ELSE.power
        ely.ely
    $$EndIf.power

*---   Manufacturing goods

* ...of which energy intensive industries

    $$IfTheni.SplitEim %split_oma%=="ON"
    ppp.ppp
    nmm.nmm
    i_s.i_s
    nfm.nfm
    %chm%.crp
    $$else.SplitEim
    eim.eim
    $$endif.SplitEim

* ...of which other manufacturing

    $$IfTheni.SplitOma %split_oma%=="ON"
        lum.lum
        otn.otn
        omf.omf
        ome.ome
        $$IfTheni.gtap10 Not %GTAP_ver%=="92" !! GTAP version 10 and above
            eeq.eeq
            bph.bph
            rpp.rpp
        $$endif.gtap10
    $$else.SplitOma
        oma.oma
    $$Endif.SplitOma

*---   Services

* ...of which transportation services

    otp.otp

*...of which collective services

    $$IfTheni.SplitService %split_ser%=="ON"
        $$Ifi Not %GTAP_ver%=="92" edu.edu
        $$Ifi Not %GTAP_ver%=="92" hht.hht
    $$Endif.SplitService

*...of which business services

    osc.osc
    $$IfTheni.SplitService %split_ser%=="ON"
        trd.trd
        obs.obs
    $$Endif.SplitService

$Endif.step4

*------------------------------------------------------------------------------*
*     5a. Save sectoral sort mapping: mapActSort(sortOrder,actf)               *
*------------------------------------------------------------------------------*

$IfTheni.step5a %step%=="define_mapActSort"

    $$IfTheni.SplitCrops %split_acr%=="ON"
        sort1.pdr
        sort2.wht
        sort3.gro
        sort4.v_f
        sort5.osd
        sort6.c_b
        sort7.pfb
        sort8.ocr
    $$ELSE.SplitCrops
        sort1.agr
    $$EndIf.SplitCrops

    $$IfTheni.SplitLivestock %split_lvs%=="ON"
        sort9 .cow
        sort10.nco
    $$EndIf.SplitLivestock
    sort11.frs

    sort21.coa
    sort22.oil
    sort23.gas

    $$Ifi %split_gas%=="ON" sort24.gdt
    $$IfTheni.power %IfPower%=="ON"
        sort31.clp
        sort32.olp
        sort33.gsp
        sort34.nuc
        sort35.hyd
        sort36.wnd
        sort37.sol
        sort38.xel
        sort39.etd
    $$ELSE.power
        sort30.ely
    $$EndIf.power

        sort40.p_c
    $$IfTheni.SplitEim %split_eim%=="ON"
        sort41.ppp
        sort42.nmm
        sort43.i_s
        sort44.crp
    $$else.SplitEim
        sort41.eim
    $$endif.SplitEim

    $$IfTheni.SplitOma %split_oma%=="ON"
        sort50.lum
        sort51.otn
        sort52.nfm
        sort53.omf
        sort54.ome
        sort55.eeq
        sort56.bph
        sort57.rpp
    $$else.SplitOma
        sort50.oma
    $$Endif.SplitOma

    sort60.cns
    sort61.otp
    sort62.osc
    $$IfTheni.SplitService %split_ser%=="ON"
        sort63.edu
        sort64.hht
        sort65.obs
        sort666.trd
    $$Endif.SplitService
    sort63.osg
$Endif.step5a

*------------------------------------------------------------------------------*
*     5b. Save commodity sort mapping: mapCommSort(sortOrder,commf)            *
*------------------------------------------------------------------------------*

$IfTheni.step5b %step%=="define_mapCommSort"

    $$IfTheni.SplitCrops %split_acr%=="ON"
        sort1.pdr
        sort2.wht
        sort3.gro
        sort4.v_f
        sort5.osd
        sort6.c_b
        sort7.pfb
        sort8.ocr
    $$ELSE.SplitCrops
        sort1.agr
    $$EndIf.SplitCrops

    $$IfTheni.SplitLivestock %split_lvs%=="ON"
        sort9 .cow
        sort10.nco
    $$EndIf.SplitLivestock

    sort11.frs

    sort12.coa
    sort13.oil
    sort14.gas
    $$Ifi %split_gas%=="ON" sort20.gdt
    $$IFi %IfElyGoodDesag%=="OFF" sort29.ely

    sort30.p_c

    $$IfTheni.Spliteim %split_eim%=="ON"
        sort31.ppp
        sort32.nmm
        sort33.i_s
        sort34.crp
    $$else.Spliteim
        sort31.eim
    $$endif.Spliteim

    $$IfTheni.SplitOma %split_oma%=="ON"
        sort40.lum
        sort41.otn
        sort42.omf
        sort43.ome
        sort44.eeq
        sort45.bph
        sort46.rpp
    $$else.SplitOma
        sort47.oma
    $$Endif.SplitOma
    
    sort49.otp
    sort50.cns

    $$IfTheni.SplitService %split_ser%=="ON"
        sort52.edu
        sort53.hht
        sort54.obs
        sort55.trd
    $$else.SplitService
        sort50.osc
        sort51.osg
    $$Endif.SplitService
    $$IfTheni.SplitEly %IfElyGoodDesag%=="ON"
        sort56.etd
        sort57.nuc
        sort58.clp
        sort59.gsp
        sort60.wnd
        sort61.hyd
        sort62.olp
        sort63.xel
        sort64.sol
    $$Endif.SplitEly

$Endif.step5b

*------------------------------------------------------------------------------*
* 6.a mapia(ia,commf) "mapping of individual commodity to aggregate commodity" *
*------------------------------------------------------------------------------*
* useless can be done with set definition in "map.gms"

$IfTheni.step6a %step%=="define_mapia"

    $$IfTheni.SplitCrops %split_acr%=="ON"
        tagr-c.(pdr,wht,gro,v_f,osd,c_b,pfb,ocr)
    $$Else.SplitCrops
        tagr-c.agr
    $$EndIf.SplitCrops

    $$IfTheni.SplitLivestock %split_lvs%=="ON"
        tagr-c.(cow,nco)
    $$EndIf.SplitLivestock
    tagr-c.(frs,fsh)

    toth-c.(cns,wts,omn)
    toth-c.gas
    $$Ifi %split_gas%=="ON" toth-c.gdt
    toth-c.(coa,oil,p_c)
    $$IFi %IfElyGoodDesag%=="OFF" toth-c.ely
    $$IFi %IfElyGoodDesag%=="ON"  toth-c.(clp,olp,gsp,nuc,hyd,wnd,sol,xel,etd)

    tsrv-c.(atp,wtp,otp)
    $$Ifi %split_ser%=="ON" tsrv-c.(trd,obs,edu,hht)
    tsrv-c.(osc,osg)

    tman-c.(ppp,crp,fdp,txt)
    tman-c.(nmm,i_s,nfm,fmp,ele,mvh)
    $$IfTheni.SplitOma %split_oma%=="ON"
        tman-c.(lum,otn,omf,ome,eeq,bph,rpp)
    $$else.SplitOma
        tman-c.oma
    $$Endif.SplitOma

* mapping G-cubed activities

    $$IFi %GcubbedIa%=="ON" $$batinclude "%sDir%\GCubbedAct.gms" "mapia"
    $$IFi %GcubbedIa%=="ON" "Electricity delivery".ely

$Endif.step6a

*------------------------------------------------------------------------------*
* 6.b mapaga(aga,actf) "mapping of individual sector to aggregate sector"      *
*------------------------------------------------------------------------------*
* useless can be done with set definition in "map.gms"

$IfTheni.step6b %step%=="define_mapaga"

    $$IfTheni.SplitCrops %split_acr%=="ON"
        tagr-a.(pdr,wht,gro,v_f,osd,c_b,pfb,ocr)
    $$Else.SplitCrops
        tagr-a.agr
    $$EndIf.SplitCrops
    $$IfTheni.SplitLivestock %split_lvs%=="ON"
        tagr-a.(cow,nco)
    $$Else.SplitLivestock
    tagr-a.(frs,fsh)

    toth-a.gas
    $$Ifi %split_gas%=="ON" toth-a.gdt
    toth-a.(coa,oil,p_c)
    toth-a.(cns,wts,omn)

    $$IfTheni.power %IfPower%=="ON"
        toth-a.(clp,olp,gsp,nuc,hyd,wnd,sol,xel,etd)
    $$ELSE.power
        toth-a.ely
    $$EndIf.power

    tsrv-a.(atp,wtp,otp)
    $$Ifi %split_ser%=="ON" tsrv-a.(trd,obs,edu,hht)
    tsrv-a.(osc,osg)

    tman-a.(ppp,crp,fdp,txt)
    tman-a.(nmm,i_s,nfm,fmp,ele,mvh)
    $$IfTheni.SplitOma %split_oma%=="ON"
        tman-a.(lum,otn,omf,ome,eeq,bph,rpp)
    $$else.SplitOma
        tman-a.oma
    $$Endif.SplitOma

* mapping G-cubed sector (for non power same as activities)

    $$IFi %GcubbedIa%=="ON" $$batinclude "%sDir%\GCubbedAct.gms" "mapia"
    $$IFi %GcubbedIa%=="ON" $$batinclude "%sDir%\GCubbedAct.gms" "mapaga"

$Endif.step6b


*------------------------------------------------------------------------------*
* 6.b mapaga(aga,actf) "mapping of individual sector to aggregate sector" *
*------------------------------------------------------------------------------*
* useless can be done with set definition in "map.gms"

$IfTheni.step6b %step%=="define_mapCommSort"

$Endif.step6b
$droplocal step
