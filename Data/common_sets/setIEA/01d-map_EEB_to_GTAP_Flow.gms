$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] Model :  Aggregation Procedure
    GAMS file   : 01b-sets_EEB_Flow.gms
    purpose     : Define set map_a0_EEBFlow(a0,EEB_Flow)
                  to map GTAP activity to EEB Flows
    created date: 6 Juin 2017
    created by  : Jean Chateau
    called by   : "%SetsDir%\setIEA\setIEA.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/common_sets/setIEA/01d-map_EEB_to_GTAP_Flow.gms $
   last changed revision: $Rev: 385 $
   last changed date    : $Date: 2023-09-01 14:06:22 +0200 (Fri, 01 Sep 2023) $
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
 From GTAP10 Documentation Chapter 11 - An Energy Data Base for GTAP
    by Robert McDougall and Maksym Chepeliev
--------------------------------------------------------------------------------
$OffText

set map_a0_EEBFlow(a0,EEB_Flow) "map GTAP activity to EEB Flows" /

* Associate only one type of same Power
*        colccs, gasccs, advnuc

* Remember that we simplified categories
*        MAINELEC = MAINELEC + AUTOELEC + MAINCHP + AUTOCHP
*   and  ELOUTPUT = ELAUTOC  + ELAUTOE  + ELMAINC + ELMAINE

    $$IfTheni.power %ifPower%=="ON"
        (NuclearBL,CoalBL,GasP,OilP,OtherBL,WindBL,HydroBL,SolarP,Electricity,Heat).(MAINELEC,ELOUTPUT,HEATOUT,MAINHEAT)
        (NuclearBL,CoalBL,GasP,OilP,OtherBL,WindBL,HydroBL,SolarP,Electricity,Heat).EPOWERPLT  "energy used in electricity, CHP and heat plants"
    $$ELSE.power
        (ELY,Heat,Electricty).(MAINELEC,ELOUTPUT,HEATOUT,MAINHEAT,EPOWERPLT)
    $$ENDIF.power

*   "Losses in energy distribution, transmission and transport"

    DISTLOSS.DISTLOSS

*------------------------------------------------------------------------------*
*       Total Final Consumption including non-energy use                       *
*------------------------------------------------------------------------------*

*   "TFC: Total Industry"

    $$iftheni.splitGtap %ifSplitGtap%=="ON"
        (isp,iss)                 . (IRONSTL,NEIRONSTL)
        (alp,als,cpp,cps,nfp,nfs) . NONFERR
        omx                       . (INONSPEC,NEINONSPEC)
        (wtr,rec)                 . COMMPUB
        $$iftheni.technoMat %ifTechnoMat%=="OFF"
            isc.(IRONSTL,NEIRONSTL)
            nfc.(NONFERR,NENONFERR)
        $$endif.technoMat
    $$else.splitGtap
        nfm.(NONFERR,NENONFERR)
        i_s.(IRONSTL,NEIRONSTL)
        omf.(INONSPEC,NEINONSPEC)
        wtr. COMMPUB
    $$endif.splitGtap

    $$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above: rpp is not in CHEMICAL but with INONSPEC
        bph.CHEMICAL
        rpp.(INONSPEC,NEINONSPEC)
    $$endif.gtap10
	 %chm%.CHEMICAL

    nmm.(NONMET,NENONMET)
    (mvh,otn).(TRANSEQ,NETRANSEQ)
    (fmp,ele,ome).(MACHINE,NEMACHINE)
	%oxt%.(MINING,NEMINING)
    $$ifi NOT %GTAP_ver%=="92" eeq.(MACHINE,NEMACHINE) !! GTAP version 10 and above
    (cmt,omt,vol,mil,pcr,sgr,ofd,b_t).(FOODPRO,NEFOODPRO)
    ppp.(PAPERPRO,NEPAPERPRO)
    lum.(WOODPRO,NEWOODPRO)
    cns.(CONSTRUC,NECONSTRUC)
    (tex,wap,lea).(TEXTILES,NETEXTILES)

*   "TFC: Other" = {residential,services,agriculture,forestry,fishing,other}

    fsh.FISHING
    hh.(RESIDENT,NEOTHER)
    osg.ONONSPEC
    $$ifi NOT %GTAP_ver%=="92" (whs,afs,rsa,edu,hht).COMMPUB !! GTAP version 10 and above
	(%ins%,trd,obs,osg).COMMPUB
    (cmn,ofi,ros,dwe).COMMPUB
    (pdr,wht,gro,v_f,osd,c_b,pfb,ocr,ctl,oap,rmk,wol,frs).AGRICULT

*   "TFC: Total Transport"  --> Transport expenditure across agent is not done

    otp.(ROAD,RAIL,PIPELINE,TRNONSPE,NETRANS)
    wtp.DOMESNAV
    atp.DOMESAIR

* Logiquement dans TFC ce qui pose donc probleme donc je mets
* dans une categorie specifique

    PetFeedStock.(NEINTREN,NECHEM)

*------------------------------------------------------------------------------*
*   "Energy industry own use" (negative) + "Energy Transformation" (negative)  *
*------------------------------------------------------------------------------*

* Dans ISIC biofuels

    coa.EMINES                "Energy used directly within the coal industry"
    p_c.ENUC                  "Energy Used in Nuclear industry"
    (oil,gas).EOILGASEX       "Energy used for oil and gas extraction"
    gdt.(EGASWKS,TGASWKS)     "Energy industry own use and Transformation: Gas works"
    Biogas.EBIOGAS            "Own consumption of biogas for Gasification plants for biogases"
    p_c.(EPATFUEL,TPATFUEL)   "Energy industry own use and Transformation: Patent fuel plants"
    p_c.(EBKB,TBKB)           "Energy industry own use and Transformation: BKB plants"
    p_c.(EREFINER,TREFINER)   "Energy industry own use and Transformation: Oil refineries"
    p_c.(ECOALLIQ,TCOALLIQ)   "Energy industry own use and Transformation: Coal liquefaction plants"
    p_c.ELNG                  "Energy used in Liquefaction (LNG) - regasification plants"
    p_c.(EGTL,TGTL)           "Energy industry own use and Transformation: Gas-to-liquids (GTL) plants"
    p_c.(ECHARCOAL,TCHARCOAL) "Energy industry own use and Transformation: Charcoal production plants  "
    p_c.(ENONSPEC,TNONSPEC)   "Energy industry own use and Transformation: Non-specified (energy)"
    p_c.TPETCHEM              "Petrochemical plants   "
    p_c.TBLENDGAS             "For blended natural gas"

    (HEAT,Electricity).TELE             "heat from chemical processes that is used to generate electricity"
    (HEAT,Electricity).TBOILER          "electric boilers used to produce heat"
    (HEAT,Electricity).(THEAT,EPUMPST)  "Non-energy use Heat pumps & Energy used in Pumped storage plants"

* Logiquement joint product de Iron and Steel industry --> si on met dans i_s
* alors pb car negatif, arbitrairement a BlastCokeOvens
* Memo: "Coke ovens"  & "Blast furnaces" are with with "p_c" for GTAP energy

    BlastCokeOvens.(EBLASTFUR,TBLASTFUR) "Energy industry own use and Transformation: Blast furnaces"
    BlastCokeOvens.(ECOKEOVS,TCOKEOVS)   "Energy industry own use and Transformation: Coke ovens"

*------------------------------------------------------------------------------*
*                       Supply categories                                      *
*------------------------------------------------------------------------------*

    AVBUNK   . AVBUNK  "International aviation bunkers (Kerosene Jet)"
    MARBUNK  . MARBUNK "International marine bunkers (Fuel oil)      "
    Exports  . Exports
    Imports  . Imports
    INDPROD  . INDPROD
    STATDIFF . STATDIFF
    STOCKCHA . STOCKCHA
    TES      . TES
    TRANSFER . TRANSFER   " interproduct transfers, products transferred & recycled products"

*   For BIGCO2 data

    (p_c,oil,gas,coa).OTHEN    "Other energy industry own use"

/;
