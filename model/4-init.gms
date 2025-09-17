$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Model Simulation
	GAMS file    : "%ModelDir%\4-init.gms"
	purpose      : Load initial SAMs and transform into model variables
	Created by   :  Dominique van der Mensbrugghe for ENVISAGE (file name init.gms)
				  + modified by Jean Chateau for OECD-ENV
	Created date :
	called by    : %ModelDir%\%SimType%.gms
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/4-init.gms $
	last changed revision: $Rev: 518 $
	last changed date    : $Date:: 2024-02-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$macro defaultInit 1
* $macro defaultInit (0.5+uniform(0,1)) ;

$macro Agg3(mat3,i,mapi,a,mapa)  sum((i0,a0)$(mapi0(i0,i) and mapa0(a0,a)), mat3(i0,a0,r))
$macro Agg2(mat2,i,mapi)         sum(mapi0(i0,i), mat2(i0,r))

* [EditJean]: Ongoing

PARAMETER ifCostCurve(r,a);
ifCostCurve(r,a) = 0;

* Calibration ELES = {static, dynamic} --> dynamic = ENV-Linkages

*$Ifi %DynCalMethod%=="ENVISAGE"
*$SetGlobal IfCalELES "static"
$If Not Set IfCalELES           $SetGlobal IfCalELES "dynamic"

*------------------------------------------------------------------------------*
*                                                                              *
*  Load the base SAM from GTAP : (i0,a0)                                       *
*                                                                              *
*------------------------------------------------------------------------------*

PARAMETERS

    evfa(fp,a0,r)       "Primary factor purchases, at agents' prices"
    vfm(fp,a0,r)        "Primary factor purchases, by firms, at market prices"
    evoa(fp,r)          "Primary factor sales, at agents' prices"
    vdfa(i0,a0,r)       "Domestic purchases, by firms, at agents' prices"
    vdfm(i0,a0,r)       "Domestic purchases, by firms, at market prices"
    vifa(i0,a0,r)       "Import purchases, by firms, at agents' prices"
    vifm(i0,a0,r)       "Import purchases, by firms, at market prices"
    vdpa(i0,r)          "Domestic purchases, by households, at agents' prices"
    vdpm(i0,r)          "Domestic purchases, by households, at market prices"
    vipa(i0,r)          "Import purchases, by households, at agents' prices"
    vipm(i0,r)          "Import purchases, by households, at market prices"
    vdga(i0,r)          "Domestic purchases, by government, at agents' prices"
    vdgm(i0,r)          "Domestic purchases, by government, at market prices"
    viga(i0,r)          "Import purchases, by government, at agents' prices"
    vigm(i0,r)          "Import purchases, by government, at market prices"
    vst(i0,r)           "Margin exports"
    vxmd(i0,r,rp)      	"Non-margin exports, at market prices"
    vxwd(i0,r,rp)      	"Non-margin exports, at world prices"
    viws(i0,r,rp)      	"Imports, at world prices"
    vims(i0,r,rp)      	"Imports, at market prices"
    VTWR(i0,i0,r,rp)   	"Margins by margin commodity"
    save(r)             "Net saving, by region"
    vdep(r)             "Capital depreciation"
    vkb(r)              "Capital stock"
    fbep(fp,a0,r)   	   "Gross Factor-Based Subsidies expenditures"
    ftrv(fp,a0,r)   	   "Gross Factor-Based Tax revenue"
    voa0(a0,r)          "Value of output"
    vom0(i0,r)          "Domestic supply"
    voa(a,r)            "Value of output"
    vom(a,r)            "Domestic output"
    osep0(a0,r)         "Initial value of output subsidy/tax"
    osep(a,r)           "Value of output subsidy/tax"

    remit00(l,r,rp)     "Initial remittances"
    yqtf0(r)            "Initial outflow of capital income"
    yqht0(r)            "Initial inflow of capital income"

    tmat0(a0,i0,r)      "Original make matrix"
    tmat(a,i,r)         "Make matrix"
    cmat(i,k,r)         "Consumer transition matrix"

    vdia(i0,r)			"Domestic purchases, by investment, at agents' prices"
    vdim(i0,r)			"Domestic purchases, by investment, at market prices"
    viia(i0,r)			"Import purchases, by investment, at agents' prices"
    viim(i0,r)			"Import purchases, by investment, at market prices"

    empl(l,a0,r)        "Employment levels"

*  Water data

    h2ocrp(a0,r)        "Water withdrawal in crop activities"
    h2oUse(wbnd,r)      "Water withdrawal by aggregate uses"

*  Energy matrices (Mtoe)

    edf(i0,a0,r)        "Usage of domestic products by firm, MTOE"
    eif(i0,a0,r)        "Usage of imported products by firm, MTOE"
    edp(i0,r)           "Private usage of domestic products, MTOE"
    eip(i0,r)           "Private usage of imported products, MTOE"
    edg(i0,r)           "Government usage of domestic products, MTOE"
    eig(i0,r)           "Government usage of imported products, MTOE"
    edi(i0,r)           "Investment usage of domestic products, MTOE"
    eii(i0,r)           "Investment usage of imported products, MTOE"
    exi(i0,r,rp)        "Bilateral trade in energy"

    nrgCumb(i0, a0, r)  "Energy combustion matrix"
    gwhr(a0,r)          "Electricity output in gwh"

*  Carbon emission matrices

    mdf(i0,a0,r)		"Emissions from domestic product in current production, .."
    mif(i0,a0,r)        "Emissions from imported product in current production, .."
    mdp(i0,r)           "Emissions from private cons. of domestic product, Mt CO2"
    mip(i0,r)           "Emissions from private cons. of imported product, Mt CO2"
    mdg(i0,r)           "Emissions from govt cons. of domestic product, Mt CO2"
    mig(i0,r)           "Emissions from govt cons. of imported product, Mt CO2"
    mdi(i0,r)           "Emissions from invt cons. of domestic product, Mt CO2"
    mii(i0,r)           "Emissions from invt cons. of imported product, Mt CO2"

*  NON-CO2 emission matrices

    nc_qo_cEQ(AllEmissions,a0,r)        "Non-CO2 emissions assoc. with output by industries-M. .."
    nc_endw_cEQ(AllEmissions,fp,a0,r)   "Non-CO2 emissions assoc. with endowment .."
    nc_trad_cEQ(AllEmissions,i0,a0,r)   "Non-CO2 emissions assoc. with input use.."
    nc_hh_cEQ(AllEmissions,i0,r)        "Non-CO2 emissions assoc. with input use by households-.."

*	OECD-ENV: add for Air Pollutant

   nc_qo(AllEmissions,a0,r)            "Non-CO2 emissions assoc. with output by industries-M. .."
   nc_endw(AllEmissions,fp,a0,r)       "Non-CO2 emissions assoc. with endowment .."
   nc_trad(AllEmissions,i0,a0,r)       "Non-CO2 emissions assoc. with input use.."
   nc_hh(AllEmissions,i0,r)            "Non-CO2 emissions assoc. with input use by households-.."

* [EditJean]: New data for GTAP10

    $$IfTheni.GTAP10 NOT %GTAP_ver%=="92"
        LandUseEmi_CEQ(AllEmissions,EmiSource,a0,r) "Lulucf & Forestry/Biomass burning emissions, mil tCO2-eq."
        LandUseEmi(AllEmissions,EmiSource,a0,r)     "Lulucf & Forestry/Biomass burning emissions"
***HRR: changed from em to AllEmissions
        GWPARS(AllEmissions,r,IPCC_REP)            "Global warming potentials by IPPC ARs for 20%YearGTAP%, CO2=1 [GWPS:NCGHG*r*IPCC_REP]"
        TOTNC(AllEmissions,a0,r)         "Aggregate Non-CO2 emissions in 20%YearGTAP% (excluding land use), Gg "
        TOTNC_CEQ(AllEmissions,a0,r)     "Aggregate Non-CO2 emissions in 20%YearGTAP% (excluding land use), mil tCO2-eq."
    $$Endif.GTAP10

;

*   Load Sam Data

* [EditJean]: choose the DataType (ie %DataType% = {agg,Alt,Flt})

execute_loaddc "%iDataDir%\%DataType%\%Prefix%Dat.gdx",
    evfa, vfm, evoa,
    vdfa, vdfm, vifa, vifm,
    vdpa, vdpm, vipa, vipm,
    vdga, vdgm, viga, vigm,
    vst, vxmd, vxwd, viws, vims, vtwr,
	fbep, ftrv,
	save, vdep, vkb
;

*  For Comp Stat Overlaypop should always be 0
*  For dynamics, popg = SSP_POP if Overlaypop = 1, else equals GTAP level

IF(%OVERLAYPOP% eq 0,
   execute_loaddc "%iDataDir%\%DataType%\%Prefix%Dat.gdx" , popg=pop ;
) ;

***HRR: gwhr is used to recalibrate x.l, as it is taken from the agg, it does NOT include the changes in BaseDataAdj.gms!!
$IFi %ifElyMixCal%=="OFF" execute_loaddc "%iDataDir%\agg\%Prefix%Sat.gdx", nrgCumb, gwhr, h2ocrp, h2oUse ;
$ifi not %GroupName%=="NGFS" $IFi %ifElyMixCal%=="ON"  execute_loaddc "%iDataDir%\agg\%Prefix%Sat.gdx", nrgCumb, gwhr, h2ocrp, h2oUse ;
$ifi %GroupName%=="NGFS" $IFi %ifElyMixCal%=="ON"  execute_loaddc "%iDataDir%\agg\%Prefix%Sat.gdx", nrgCumb,       h2ocrp, h2oUse ;
$ifi %GroupName%=="NGFS" $IFi %ifElyMixCal%=="ON"  execute_loaddc "%iDataDir%\GWHR_NGFS.gdx", gwhr;
$IFi %BaseName%=="2024_MCD" execute_loaddc "%iDataDir%\agg\%Prefix%Sat2.gdx",  gwhr;
$IFi %BaseName%=="2025_Oman" execute_loaddc "%iDataDir%\agg\%Prefix%Sat2.gdx",  gwhr;
***endHRR

execute_loaddc "%iDataDir%\%DataType%\%Prefix%vole.gdx"
   edf, eif, edp, eip, edg, eig, exi=exidag ;

execute_loaddc "%iDataDir%\%DataType%\%Prefix%emiss.gdx",
	mdf, mif, mdp,  mip, mdg, mig ;

$ifthen exist "%iDataDir%\%DataType%\%Prefix%nco2.gdx"

    execute_loaddc "%iDataDir%\%DataType%\%Prefix%nco2.gdx"
    $$ifi NOT %GTAP_ver%=="92" TOTNC,TOTNC_CEQ,GWPARS,LandUseEmi_CEQ,LandUseEmi,
        nc_qo_ceq, nc_endw_ceq, nc_trad_ceq, nc_hh_ceq, nc_qo, nc_endw,
        nc_trad, nc_hh ;

    ifNCO2 = 1 ;

$else

    nc_qo_cEQ(emn,a0,r)       = 0 ;
    nc_endw_cEQ(emn,fp,a0,r)  = 0 ;
    nc_trad_cEQ(emn,i0,a0,r)  = 0 ;
    nc_hh_cEQ(emn,i0,r)       = 0 ;
    nc_qo(emn,a0,r)           = 0 ;
    nc_endw(emn,fp,a0,r)      = 0 ;
    nc_trad(emn,i0,a0,r)      = 0 ;
    nc_hh(emn,i0,r)           = 0 ;

    ifNCO2 = 0 ;

$endif

$iftheni.RD "%ifRD_Module%" == "ON"

* --------------------------------------------------------------------------------------------------
*
*  Initialize R&D module
*
* --------------------------------------------------------------------------------------------------

   Parameter

*     Expenditure values

      VDRM(i0, r)          "R&D purchases of domestic goods at basic prices"
      VDRA(i0, r)          "R&D purchases of domestic goods at purchaser prices"
      VIRM(i0, r)          "R&D purchases of imported goods at basic prices"
      VIRA(i0, r)          "R&D purchases of domestic goods at purchaser prices"

*     Energy

      edr(i0,r)            "R&D usage of domestic products, MTOE"
      eir(i0,r)            "R&D usage of imported products, MTOE"

*     Carbon emission matrices

      mdr(i0, r)           "Emissions from R&D of domestic product, Mt CO2"
      mir(i0, r)           "Emissions from R&D of imported product, Mt CO2"

      rdShr0(r)            "Initial share of R&D in government expenditures"
   ;

*  Do we have data for R&D costs, if so we would assume that the 'DAT' file has been adjusted

   $$ifthen.ifFileR_D exist "%iDataDir%\%DataType%\%Prefix%R_D.gdx"

      execute_load "%BASENAME%R_D.gdx", VDRM, VDRA, VIRM, VIRA ;

   $$else.ifFileR_D

*     Assume same cost structure as for government expenditures

      gdpmp0(r) = sum(i0, VDPA(i0,r) + VIPA(i0,r)
                +         VDGA(i0,r) + VIGA(i0,r)
                +         VDFA(i0,'CGDS',r) + VIFA(i0,'CGDS',r)
                +         VST(i0,r)
                +  sum(d, VXWD(i0,r,d)) - sum(s, VIWS(i0,s,r))) ;

*     display gdpmp0 ;

      rdShr0(r) = 0.01*KnowledgeData0(r,"rd0")*gdpmp0(r)
                / sum(i0, VDGA(i0,r) + VIGA(i0,r)) ;

*     display rdShr0 ; abort "Temp" ;

      vdrm(i0,r) = rdshr0(r)*vdgm(i0,r) ;
      vdra(i0,r) = rdshr0(r)*vdga(i0,r) ;
      virm(i0,r) = rdshr0(r)*vigm(i0,r) ;
      vira(i0,r) = rdshr0(r)*viga(i0,r) ;

   $$endif.ifFileR_D

*  Subtract R&D from government expenditures

   vdgm(i0,r) = vdgm(i0,r) - vdrm(i0,r) ;
   vdga(i0,r) = vdga(i0,r) - vdra(i0,r) ;
   vigm(i0,r) = vigm(i0,r) - virm(i0,r) ;
   viga(i0,r) = viga(i0,r) - vira(i0,r) ;

*  Adjust energy/emissions tables

   edr(i0,r) = vdgm(i0,r) + vdrm(i0,r) ;
   edr(i0,r)$edr(i0,r) = edg(i0,r)*(vdrm(i0,r)/edr(i0,r)) ;
   edg(i0,r) = edg(i0,r) - edr(i0,r) ;

   eir(i0,r) = vigm(i0,r) + virm(i0,r) ;
   eir(i0,r)$eir(i0,r) = eig(i0,r)*(virm(i0,r)/eir(i0,r)) ;
   eig(i0,r) = eig(i0,r) - eir(i0,r) ;

   mdr(i0,r) = edg(i0,r) + edr(i0,r) ;
   mdr(i0,r)$mdr(i0,r) = mdg(i0,r)*(edr(i0,r)/mdr(i0,r)) ;
   mdg(i0,r) = mdg(i0,r) - mdr(i0,r) ;

   mir(i0,r) = eig(i0,r) + eir(i0,r) ;
   mir(i0,r)$mir(i0,r) = mig(i0,r)*(eir(i0,r)/mir(i0,r)) ;
   mig(i0,r) = mig(i0,r) - mir(i0,r) ;

$else.RD

*  RD_Module is off--zero out the input data

   Parameter

*     Expenditure values

      VDRM(i0, r)          "R&D purchases of domestic goods at basic prices"
      VDRA(i0, r)          "R&D purchases of domestic goods at purchaser prices"
      VIRM(i0, r)          "R&D purchases of imported goods at basic prices"
      VIRA(i0, r)          "R&D purchases of domestic goods at purchaser prices"

*     Energy

      edr(i0,r)            "R&D usage of domestic products, MTOE"
      eir(i0,r)            "R&D usage of imported products, MTOE"

*     Carbon emission matrices

      mdr(i0, r)           "Emissions from R&D of domestic product, Mt CO2"
      mir(i0, r)           "Emissions from R&D of imported product, Mt CO2"

   ;
   vdrm(i0,r) = 0 ;
   vdra(i0,r) = 0 ;
   virm(i0,r) = 0 ;
   vira(i0,r) = 0 ;
   edr(i0,r)  = 0 ;
   eir(i0,r)  = 0 ;
   mdr(i0,r)  = 0 ;
   mir(i0,r)  = 0 ;
   
$endif.RD

$ifthen.BOPData exist "%iDataDir%\agg\%Prefix%BoP.gdx"

    execute_loaddc "%iDataDir%\agg\%Prefix%BoP.gdx", remit00=remit,
        yqtf0=yqtf, yqht0=yqht ;

$else.BOPData

    remit00(l,r,rp) = 0 ;
    yqtf0(r)        = 0 ;
    yqht0(r)        = 0 ;

$endif.BOPData

*   Include Labor in volume

$ifthen.LabVol exist "%iDataDir%\agg\%Prefix%Wages.gdx"
    execute_loaddc "%iDataDir%\%Prefix%Wages.gdx", empl=q ;
$else.LabVol
    empl(l,a0,r) = na ;
$endif.LabVol

* OECD-ENV: Air Pollutant

$IfTheni.OAP %ifAirPol%=="OFF"

    nc_trad(OAP,i0,a0,r) = 0 ;
    nc_endw(OAP,fp,a0,r) = 0 ;
    nc_hh(OAP,i0,r)      = 0 ;
    nc_qo(OAP,a0,r)      = 0 ;

$Endif.OAP

file sam0csv / sam0.csv / ;
if(0,
   put sam0csv ;
   put "RLAB,CLAB,REGION,TIME" / ;
   sam0csv.pc = 5 ;
   sam0csv.nd = 10 ;
   loop((i0,a0,r)$(not sameas(a0,"cgds") and (vdfm(i0,a0,r)+vifm(i0,a0,r))),
      put i0.tl, a0.tl, r.tl, 0:4:0, (vdfm(i0,a0,r)+vifm(i0,a0,r)) / ;
   ) ;
   loop((i0,h,r)$(vdpm(i0,r)+vipm(i0,r)),
      put i0.tl, h.tl, r.tl, 0:4:0, (vdpm(i0,r)+vipm(i0,r)) / ;
   ) ;
   loop((i0,gov,r)$(vdgm(i0,r)+vigm(i0,r)),
      put i0.tl, gov.tl, r.tl, 0:4:0, (vdgm(i0,r)+vigm(i0,r)) / ;
   ) ;
   loop((i0,inv,r)$(vdfm(i0,'cgds',r)+vifm(i0,'cgds',r)),
      put i0.tl, inv.tl, r.tl, 0:4:0, (vdfm(i0,'cgds',r)+vifm(i0,'cgds',r)) / ;
   ) ;
   loop((i0,r_d,r)$(vdrm(i0,r)+virm(i0,r)),
      put i0.tl, r_d.tl, r.tl, 0:4:0, (vdrm(i0,r)+virm(i0,r)) / ;
   ) ;
   loop((a0,r)$(not sameas(a0,"cgds") and (sum(i0, vdfa(i0,a0,r)+vifa(i0,a0,r) - (vdfm(i0,a0,r)+vifm(i0,a0,r))))),
      put 'itax', a0.tl, r.tl, 0:4:0, (sum(i0, vdfa(i0,a0,r)+vifa(i0,a0,r) - (vdfm(i0,a0,r)+vifm(i0,a0,r)))) / ;
   ) ;
   loop((h,r)$(sum(i0, vdpa(i0,r)+vipa(i0,r) - (vdpm(i0,r)+vipm(i0,r)))),
      put 'itax', h.tl, r.tl, 0:4:0, (sum(i0, vdpa(i0,r)+vipa(i0,r) - (vdpm(i0,r)+vipm(i0,r)))) / ;
   ) ;
   loop((gov,r)$(sum(i0, vdga(i0,r)+viga(i0,r) - (vdgm(i0,r)+vigm(i0,r)))),
      put 'itax', gov.tl, r.tl, 0:4:0, (sum(i0, vdga(i0,r)+viga(i0,r) - (vdgm(i0,r)+vigm(i0,r)))) / ;
   ) ;
   loop((inv,r)$(sum(i0, vdfa(i0,'cgds',r)+vifa(i0,'cgds',r) - (vdfm(i0,'cgds',r)+vifm(i0,'cgds',r)))),
      put 'itax', inv.tl, r.tl, 0:4:0, (sum(i0, vdfa(i0,'cgds',r)+vifa(i0,'cgds',r) - (vdfm(i0,'cgds',r)+vifm(i0,'cgds',r)))) / ;
   ) ;
   loop((r_d,r)$(sum(i0, vdra(i0,r)+vira(i0,r) - (vdrm(i0,r)+virm(i0,r)))),
      put 'itax', r_d.tl, r.tl, 0:4:0, (sum(i0, vdra(i0,r)+vira(i0,r) - (vdrm(i0,r)+virm(i0,r)))) / ;
   ) ;

   voa0(a0,r) = sum(i0, vdfa(i0,a0,r)+vifa(i0,a0,r)) + sum(fp, evfa(fp,a0,r)) ;
   vom0(i0,r) = sum(a0, vdfm(i0,a0,r)) + vdpm(i0,r) + vdgm(i0,r) + vdrm(i0,r) + vst(i0,r) + sum(d, vxmd(i0,r,d)) ;
   loop((r,i0,a0)$sameas(i0,a0),
      put 'ptax', a0.tl, r.tl, 0:4:0, (vom0(i0,r) - voa0(a0,r)) / ;
   ) ;
   loop(r,
      put 'gov', 'ptax', r.tl, 0:4:0, (sum(sameas(a0,i0), vom0(i0,r) - voa0(a0,r))) / ;
   ) ;

   loop(r,
      put 'gov', 'itax', r.tl, 0:4:0, (sum((i0,a0)$(not sameas(a0,'cgds')), vdfa(i0,a0,r)+vifa(i0,a0,r) - (vdfm(i0,a0,r)+vifm(i0,a0,r)))
      + sum(i0, vdpa(i0,r)+vipa(i0,r) - (vdpm(i0,r)+vipm(i0,r))) + sum(i0, vdga(i0,r)+viga(i0,r) - (vdgm(i0,r)+vigm(i0,r)))
      + sum(i0, vdfa(i0,'cgds',r)+vifa(i0,'cgds',r) - (vdfm(i0,'cgds',r)+vifm(i0,'cgds',r)))
      + sum(i0, vdra(i0,r)+vira(i0,r) - (vdrm(i0,r)+virm(i0,r)))) / ;
   ) ;

   loop((fp,a0,r)$(not sameas(a0,"cgds") and (vfm(fp,a0,r))),
      put fp.tl, a0.tl, r.tl, 0:4:0, (vfm(fp,a0,r)) / ;
   ) ;
   loop((a0,r)$(not sameas(a0,"cgds") and (sum(fp, evfa(fp,a0,r) - vfm(fp,a0,r)))),
      put "vtax", a0.tl, r.tl, 0:4:0, (sum(fp, evfa(fp,a0,r) - vfm(fp,a0,r))) / ;
   ) ;
   loop(r,
      put 'gov', 'vtax', r.tl, 0:4:0, (sum((fp,a0), evfa(fp,a0,r) - vfm(fp,a0,r))) / ;
   ) ;
   loop((fp,h,cap,r)$(evoa(fp,r)),
      put h.tl, fp.tl, r.tl, 0:4:0, (evoa(fp,r) - vdep(r)$sameas(fp,cap)) / ;
   ) ;
   loop((fp,h,r)$(sum(a0, vfm(fp,a0,r)) - evoa(fp,r)),
      put 'dtax', fp.tl, r.tl, 0:4:0, (sum(a0, vfm(fp,a0,r)) - evoa(fp,r)) / ;
   ) ;

   loop((i0,s,d)$vxwd(i0,s,d),
      put s.tl, i0.tl, d.tl, 0:4:0, vxwd(i0,s,d) / ;
   ) ;
   loop((i0,d)$sum(s, viws(i0,s,d) - vxwd(i0,s,d)),
      put "TMG", i0.tl, d.tl, 0:4:0, (sum(s, viws(i0,s,d) - vxwd(i0,s,d))) / ;
   ) ;
   loop((i0,d)$sum(s, vims(i0,s,d) - viws(i0,s,d)),
      put "MTAX", i0.tl, d.tl, 0:4:0, (sum(s, vims(i0,s,d) - viws(i0,s,d))) / ;
   ) ;
   loop(d,
      put 'gov', 'mtax', d.tl, 0:4:0, (sum((i0,s), vims(i0,s,d) - viws(i0,s,d))) / ;
   ) ;


   loop((i0,s,d)$vxwd(i0,s,d),
      put i0.tl, d.tl, s.tl, 0:4:0, vxwd(i0,s,d) / ;
   ) ;
   loop((i0,s)$sum(d, vxwd(i0,s,d) - vxmd(i0,s,d)),
      put "ETAX", i0.tl, s.tl, 0:4:0, (sum(d, vxwd(i0,s,d) - vxmd(i0,s,d))) / ;
   ) ;

   loop(s,
      put 'gov', 'etax', s.tl, 0:4:0, (sum((i0,d), vxwd(i0,s,d) - vxmd(i0,s,d))) / ;
   ) ;

   loop((i0,s)$vst(i0,s),
      put i0.tl, "TMG", s.tl, 0:4:0, vst(i0,s) / ;
   ) ;

   loop(r,
      put "TMG", "BoP", r.tl, 0:4:0, (sum(i0, vst(i0,r)) - sum((i0,s), viws(i0,s,r) - vxwd(i0,s,r))) / ;
   ) ;

   loop(r,
      put "INV", "BoP", r.tl, 0:4:0, (sum((s,i0), viws(i0,s,r)) - sum((d,i0), vxwd(i0,r,d)) - sum(i0, vst(i0,r))) / ;
   ) ;
   loop((s,d),
      put d.tl, "BOP", s.tl, 0:4:0, (sum(i0, vxwd(i0,s,d))) / ;
   ) ;
   loop((s,d),
      put "BOP", s.tl, d.tl, 0:4:0, (sum(i0, vxwd(i0,s,d))) / ;
   ) ;

   loop((r,h),
      put "INV", h.tl, r.tl, 0:4:0, save(r) / ;
   ) ;

   loop((r,h),
      put "DTAX", h.tl, r.tl, 0:4:0, (sum(fp, evoa(fp,r)) - vdep(r) - sum(i0, vdpa(i0,r)+vipa(i0,r)) - save(r)) / ;
   ) ;

   loop(r,
      put "GOV", "DTAX", r.tl, 0:4:0, (sum(fp, sum(a0, vfm(fp,a0,r)) - evoa(fp,r))
         + (sum(fp, evoa(fp,r)) - vdep(r) - sum(i0, vdpa(i0,r)+vipa(i0,r)) - save(r))) / ;
   ) ;

   loop(r,
      put r_d.tl, "GOV", r.tl, 0:4:0, (sum(i0, vdra(i0,r) + vira(i0,r))) / ;
   ) ;

   loop(r,
      put 'inv', 'deprY', r.tl, 0:4:0, (vdep(r)) / ;
   ) ;

   loop((r,cap),
      put 'deprY', cap.tl, r.tl, 0:4:0, (vdep(r)) / ;
   ) ;

   abort "Temp" ;
)

*------------------------------------------------------------------------------*
*                                                                              *
*  							Initialize prices								   *
*                                                                              *
*------------------------------------------------------------------------------*

* #TODO: on definit tous les prix par default meme si le bien/Activite existe pas

loop((t0,vOld),

* OECD-ENV: define trent, ptland, pnr, pland, pxghx, pva, pva1, pva2 below to reduce the size

    pxp.l(r,a,vOld,t0)       $ (not tota(a))  = defaultInit ; pxp.l(r,a,v,t)       = pxp.l(r,a,vOld,t0) ;
    uc.l(r,a,vOld,t0)        $ (not tota(a))  = defaultInit ; uc.l(r,a,v,t)        = uc.l(r,a,vOld,t0) ;
    pnd1.l(r,a,t0)           $ (not tota(a))  = defaultInit ; pnd1.l(r,a,t)        = pnd1.l(r,a,t0) ;
    pnd2.l(r,a,t0)           $ (not tota(a))  = defaultInit ; pnd2.l(r,a,t)        = pnd2.l(r,a,t0) ;
    pwat.l(r,a,t0)           $ (not tota(a))  = defaultInit ; pwat.l(r,a,t)        = pwat.l(r,a,t0) ;
    pnrg.l(r,a,vOld,t0)      $ (not tota(a))  = defaultInit ; pnrg.l(r,a,v,t)      = pnrg.l(r,a,vOld,t0) ;
    paNRG.l(r,a,NRG,vOld,t0) $ (not tota(a))  = defaultInit ; paNRG.l(r,a,NRG,v,t) = paNRG.l(r,a,NRG,vOld,t0) ;
    pnely.l(r,a,vOld,t0)     $ (not tota(a))  = defaultInit ; pnely.l(r,a,v,t)     = pnely.l(r,a,vOld,t0) ;
    polg.l(r,a,vOld,t0)      $ (not tota(a))  = defaultInit ; polg.l(r,a,v,t)      = polg.l(r,a,vOld,t0) ;
    plab1.l(r,a,t0)          $ (not tota(a))  = defaultInit ; plab1.l(r,a,t)       = plab1.l(r,a,t0) ;
    plab2.l(r,a,t0)          $ (not tota(a))  = defaultInit ; plab2.l(r,a,t)       = plab2.l(r,a,t0) ;
    pks.l(r,a,vOld,t0)       $ (not tota(a))  = defaultInit ; pks.l(r,a,v,t)       = pks.l(r,a,vOld,t0) ;
    pksw.l(r,a,vOld,t0)      $ (not tota(a))  = defaultInit ; pksw.l(r,a,v,t)      = pksw.l(r,a,vOld,t0) ;
    pkf.l(r,a,vOld,t0)       $ (not tota(a))  = defaultInit ; pkf.l(r,a,v,t)       = pkf.l(r,a,vOld,t0) ;
    pkef.l(r,a,vOld,t0)      $ (not tota(a))  = defaultInit ; pkef.l(r,a,v,t)      = pkef.l(r,a,vOld,t0) ;

    pat.l(r,i,t0)     = defaultInit ; pat.l(r,i,t)     = pat.l(r,i,t0)     ;
    ps.l(r,i,t0)      = defaultInit ; ps.l(r,i,t)      = ps.l(r,i,t0)      ;
    pwmg.l(r,i,rp,t0) = defaultInit ; pwmg.l(r,i,rp,t) = pwmg.l(r,i,rp,t0) ;
    pmt.l(r,i,t0)     = defaultInit ; pmt.l(r,i,t)     = pmt.l(r,i,t0)     ;
    ptmg.l(img,t0)    = defaultInit ; ptmg.l(img,t)    = ptmg.l(img,t0)    ;

) ;

*------------------------------------------------------------------------------*
*                                                                              *
*				Price/volume splits for energy demands						   *
*   		IfNrgVol = 1 : Use Energy volume in the Model                      *
*                                                                              *
*------------------------------------------------------------------------------*

PARAMETERS
   xatNRG00(r,e)    "Total energy absorption in MTOE"
   xaNRG00(r,e,aa)  "Total energy absorption in MTOE by agent"
   patNRG00(r,e)    "Average price of energy in $/MTOE"
   paNRG00(r,e,aa)	"Agents' price in $/MTOE"
   xpNrg0(i0,r)		"Domestic output = domestic sales + exports, in MTOE"

* trade dimension of energy volumes

   xwNRG0(r,e,rp) 	"Volume of bilateral trade in MTOE"
   peNRG0(r,e,rp) 	"Price of bilateral trade at producer prices"
   petNRG0(r,e)   	"Average price of exports"
   xetNRG0(r,e)   	"Total exports in MTOE"
   xmtNRG0(r,e)   	"Total imports in MTOE"
   pmtNRG0(r,e)   	"Price of aggregate imports"
   xdNRG0(r,e)    	"Domestic absorption of domestic output"
   xsNRG0(r,e)    	"Domestic supply"
;

*  Initialize investment vector (GTAP sectoral aggregation)

loop(cgds0,
    vdia(i0,r) = vdfa(i0,cgds0,r) ;
    vdim(i0,r) = vdfm(i0,cgds0,r) ;
    viia(i0,r) = vifa(i0,cgds0,r) ;
    viim(i0,r) = vifm(i0,cgds0,r) ;
    edi(i0, r) =  edf(i0,cgds0,r) ; edf(i0,cgds0,r) = 0 ;
    eii(i0, r) =  eif(i0,cgds0,r) ; eif(i0,cgds0,r) = 0 ;
    mdi(i0, r) =  mdf(i0,cgds0,r) ; mdf(i0,cgds0,r) = 0 ;
    mii(i0, r) =  mif(i0,cgds0,r) ; mif(i0,cgds0,r) = 0 ;
) ;

*  Initialize Domestic output

xpNrg0(i0,r) = sum(a0, edf(i0,a0,r))
			 + edp(i0,r) + edg(i0,r) + edi(i0,r)
			 + sum(rp, exi(i0,r,rp)) ;

* OECD-ENV: these 3 new variables replace gammaex(r,i,aa)

gammaeda(r,i,aa) $ (not tota(aa))= 1 ;
gammaedd(r,i,aa) $ (not tota(aa))= 1 ;
gammaedm(r,i,aa) $ (not tota(aa))= 1 ;

gammaew(r,i,rp) = 1 ;
gammaesd(r,i)   = 1 ;
gammaese(r,i)   = 1 ;

file CheckNrg / "%cBaseFile%_%system.fn%_NRG.txt" /;

IF(IfNrgVol,

*  Initialize initial volumes:

	xaNRG00(r,e,a)
	= sum((i0,a0) $ (mapi0(i0,e) and mapa0(a0,a)), edf(i0,a0,r) + eif(i0,a0,r));
	xaNRG00(r,e,h)   = sum(mapi0(i0,e), edp(i0,r) + eip(i0,r)) ;
	xaNRG00(r,e,gov) = sum(mapi0(i0,e), edg(i0,r) + eig(i0,r)) ;
	xaNRG00(r,e,inv) = sum(mapi0(i0,e), edi(i0,r) + eii(i0,r)) ;
   $$iftheni "%ifRD_MODULE%" == "ON"
      xaNRG00(r,e,r_d) = sum(i0$mapi0(i0,e), edr(i0,r) + eir(i0,r)) ;
   $$endif

* escale=1e-3 --> Express into billions of TOE

	xaNRG00(r,e,aa)  = eScale * xaNRG00(r,e,aa) ;
	xatNRG00(r,e)    = sum(aa, xaNRG00(r,e,aa)) ;

*  Initialize cumbustion ratio

	phiNRG(r,fi,aa)   = 1 ;
	phiNRG(r,fi,a)
		= eScale * sum((i0,a0) $ (mapi0(i0,fi) and mapa0(a0,a)), nrgCumb(i0,a0,r)) ;
	phiNRG(r,fi,a)  $ xaNRG00(r,fi,a) = phiNRG(r,fi,a) / xaNRG00(r,fi,a) ;
	phiNRG(r,fi,aa) $ (phiNRG(r,fi,aa) gt 1) = 1 ;

*  Initialize values excl sales taxes (using price matrices temporarily)

	paNRG00(r,e,a)   = Agg3(vdfm,e,mapi,a,mapa) + Agg3(vifm,e,mapi,a,mapa) ;
	paNRG00(r,e,h)   = Agg2(vdpm,e,mapi) + Agg2(vipm,e,mapi) ;
	paNRG00(r,e,gov) = Agg2(vdgm,e,mapi) + Agg2(vigm,e,mapi) ;
	paNRG00(r,e,inv) = Agg2(vdim,e,mapi) + Agg2(viim,e,mapi) ;
$iftheni "%ifRD_MODULE%" == "ON"
   paNRG00(r,e,r_d)  = Agg2(vdrm,e,mapi) + Agg2(virm,e,mapi) ;
$endif
	paNRG00(r,e,aa)  = inscale * paNRG00(r,e,aa) ;

*  Check for consistency -- xaNrg contains energy volumes, paNrg contains SAM values

	IF(IfDebug and IfCal,

		put CheckNrg ;
		CheckNrg.nd = 9 ;
		put / ;
		work = 0 ;
		loop((r,e,aa),
			IF(xaNRG00(r,e,aa) le 0 and paNRG00(r,e,aa) ne 0,
				put "WARNING: NRG=0, SAM<>0 --> ", r.tl, e.tl, aa.tl, (xaNRG00(r,e,aa)/escale):15:8, (paNRG00(r,e,aa)/inscale):15:8 / ;
				work = work + 1 ;
			ELSEIF(xaNRG00(r,e,aa) ne 0 and paNRG00(r,e,aa) le 0),
				put "WARNING: NRG<>0, SAM=0 --> ", r.tl, e.tl, aa.tl, (xaNRG00(r,e,aa)/escale):15:8, (paNRG00(r,e,aa)/inscale):15:8 / ;
				work = work + 1 ;
			) ;
		) ;
		IF(work > 0, Abort "Inconsistent energy statistics" ; ) ;
		putclose CheckNrg;
	) ;

*  Calculate average price by energy carrier

	patNRG00(r,e)
		= { sum(aa $ xaNRG00(r,e,aa), paNRG00(r,e,aa))
			/ xatNRG00(r,e)} $ {xatNRG00(r,e)}
		+ {1} 				 $ {NOT xatNRG00(r,e)} ;

*  Calculate end-user (market) price

	paNRG00(r,e,aa)
		= {paNRG00(r,e,aa)/xaNRG00(r,e,aa)} $ {xaNRG00(r,e,aa)}
		+ {1} 								$ {NOT xaNRG00(r,e,aa)} ;

*  Calculate price adjustment factor

   gammaeda(r,e,aa) $ (xatNRG00(r,e) and xaNRG00(r,e,aa))
        = paNRG00(r,e,aa) / patNRG00(r,e) ;

* overwrite pat.l

   pat.l(r,e,t)  $ xatNRG00(r,e) = patNRG00(r,e) ;
   xatNRG(r,e,t) $ xatNRG00(r,e) = xatNRG00(r,e) ;

*------------------------------------------------------------------------------*
*			  Incorporate trade dimension of energy volumes					   *
*------------------------------------------------------------------------------*

*  Initialize volumes and values, using pe to hold values

   xwNRG0(r,e,rp) = eScale  * sum(mapi0(i0,e), exi(i0,r,rp) ) ;
   peNRG0(r,e,rp) = inscale * sum(mapi0(i0,e), vxmd(i0,r,rp)) ;

*  Check consistency of flows

   put screen ; put / ;
   loop((r,e,rp)$((xwNRG0(r,e,rp) eq 0 and peNRG0(r,e,rp)) or
                  (xwNRG0(r,e,rp) and peNRG0(r,e,rp) eq 0)),
      put "Inconsistent energy data: ", r.tl, e.tl, rp.tl, "xw = ", (xwNRG0(r,e,rp)/escale):15:6,
         "  SAM = ", (peNRG0(r,e,rp)/inscale) / ;
   ) ;
   putclose screen ;

*  Calculate total exports and average export price

   xetNRG0(r,e) = sum(rp, xwNRG0(r,e,rp)) ;
   petNRG0(r,e) = (sum(rp, peNRG0(r,e,rp))/xetNRG0(r,e))$xetNRG0(r,e)
                + 1$(xetNRG0(r,e) eq 0) ;

*  Calculate bilateral export price

   peNRG0(r,e,rp) = (peNRG0(r,e,rp)/xwNRG0(r,e,rp))$xwNRG0(r,e,rp)
                  + (1)$(not xwNRG0(r,e,rp)) ;

*  Calculate price adjustment factors

   gammaew(r,e,rp) $ (xwNRG0(r,e,rp) and xetNRG0(r,e))
        = peNRG0(r,e,rp) / petNRG0(r,e) ;

* overwrite pet.l, pdt.l

   pet.l(r,e,t) $ xetNRG0(r,e) = petNRG0(r,e) ;

*  Calculate aggregate import price

   xmtNRG0(r,e) = sum(rp, xwNRG0(rp,e,r)) ;
   pmtNRG0(r,e) = inscale*(sum(mapi0(i0,e),sum(rp,vims(i0, rp, r)))) ;
   pmtNRG0(r,e) = (pmtNRG0(r,e)/xmtNRG0(r,e))$(xmtNRG0(r,e))
                + (1)$(xmtNRG0(r,e) eq 0) ;

   xdNRG0(r,e)  = xatNRG00(r,e) - xmtNRG0(r,e) ;
   pdt.l(r,e,t) = ((patNRG00(r,e)*xatNRG00(r,e) - pmtNRG0(r,e)*xmtNRG0(r,e))/xdNRG0(r,e))
                $(xdNRG0(r,e) gt 0)
                + 1$(xdnrg0(r,e) le 0) ;

*  !!!! 03-Mar-2017 (DvdM)
*  Have a tolerance level for pd
*  We should review the energy consistencies--it gets messy with the 'make' system
    IF(1,
        pdt.l(r,e,t)$(pdt.l(r,e,t) lt 0 or abs(pdt.l(r,e,t)) le 1e-5) = 0 ;
        loop(t0, xdNRG0(r,e)$(pdt.l(r,e,t0) eq 0) = 0 ; ) ;
        pdt.l(r,e,t)$(pdt.l(r,e,t) = 0) = 1 ;
    ) ;

    xsNRG0(r,e)  = xdNRG0(r,e) + xetNRG0(r,e) ; !! see also xpNrg
    ps.l(r,e,t)
		= { (pdt.l(r,e,t) * xdNRG0(r,e) + pet.l(r,e,t) * xetNRG0(r,e) )
		   / xsNRG0(r,e)} $ {xsNRG0(r,e) gt 0}
        + 1 $ {xsNRG0(r,e) eq 0} ;
    loop(t0,
        gammaesd(r,e) $ ps.l(r,e,t0) = pdt.l(r,e,t0) / ps.l(r,e,t0) ;
        gammaese(r,e) $ ps.l(r,e,t0) = pet.l(r,e,t0) / ps.l(r,e,t0) ;
    ) ;

) ;

*------------------------------------------------------------------------------*
*                                                                              *
*				Initialize the make matrix									   *
*                                                                              *
*------------------------------------------------------------------------------*

* OECD-ENV: additional conditions

pdt.l(r,i,t) = gammaesd(r,i) * ps.l(r,i,t) ;
pet.l(r,i,t) $ sum((rp,i0) $ mapi0(i0,i), vxmd(i0,r,rp))
    = gammaese(r,i) * ps.l(r,i,t) ;
pe.l(r,i,rp,t) $ sum(mapi0(i0,i), vxmd(i0,r,rp))
    = gammaew(r,i,rp) * pet.l(r,i,t) ;

* [EditJEan]: memo done in "agg.gms" in ENV version

*   Gross output at agent prices (tax included) --> supply prices ?

voa0(a0,r) = sum(i0, vdfa(i0,a0,r) + vifa(i0,a0,r)) + sum(fp, evfa(fp, a0, r)) ;

*   Domestic Supply at market prices

vom0(i0,r)  = sum(a0, vdfm(i0,a0,r))
			  + vdpm(i0,r) + vdgm(i0,r) + vdrm(i0,r)
            + vst(i0,r) + sum(rp, vxmd(i0,r,rp)) ;

osep0(i0,r)    = voa0(i0,r) - vom0(i0,r) ;
tmat0(i0,i0,r) = vom0(i0,r) ; !! Diagonal Matrix
tmat(a,i,r)    = sum((a0,i0)$(mapa0(a0,a) and mapi0(i0,i)), tmat0(a0,i0,r)) ; !! Not a Diagonal Matrix
vom(a,r)       = sum(i, tmat(a,i,r)) ;

*	Initialize the Consumption Matrix

loop((i,k) $ mapk(i,k),
   cmat(i,k,r) = Agg2(vdpa,i,mapi) + Agg2(vipa,i,mapi) ;
) ;

IF(IfDebug and IfCal,
	EXECUTE_UNLOAD "%cBaseFile%_%system.fn%_TransitionMatrices.gdx", tmat, cmat;
) ;

*  Initialize Armington elasticities

*  !!!! NEEDS REVIEW -- SIGMAM ALSO READ IN !!!!
$OnText
sigmam0(r,i) = sum(i0$mapi0(i0,i), sum(s, sum(a0, vdfa(i0,a0,s) + vifa(i0,a0,s))
          +                                       vdpa(i0,s) + vipa(i0,s)
          +                                       vdga(i0,s) + viga(i0,s))) ;
sigmam0(r,i)$sigmam0(r,i)
          = sum(i0$mapi0(i0,i), ESUBD(i0)*(sum(s, sum(a0, vdfa(i0,a0,s) + vifa(i0,a0,s))
          +                                               vdpa(i0,s) + vipa(i0,s)
          +                                               vdga(i0,s) + viga(i0,s))))
          / sigmam0(r,i) ;

sigmaw0(r,i) = sum(i0$mapi0(i0,i), sum(s, sum(a0, vifa(i0,a0,s))
          +                                       vipa(i0,s)
          +                                       viga(i0,s))) ;
sigmaw0(r,i)$sigmaw0(r,i)
          = sum(i0$mapi0(i0,i), ESUBM(i0)*(sum(s, sum(a0, vifa(i0,a0,s))
          +                                               vipa(i0,s)
          +                                               viga(i0,s))))
          / sigmaw0(r,i) ;

sigmam(r,i) = sigmam0(r,i) ;
sigmaw(r,i) = sigmaw0(r,i) ;
$OffText

*  Initialize household utility parameters

eh0(k,r) = sum(i$mapk(i,k), sum(i0$mapi0(i0,i), vdpa(i0,r) + vipa(i0,r))) ;
bh0(k,r) = eh0(k,r) ;
eh0(k,r)$eh0(k,r)
          = sum(i$mapk(i,k), sum(i0$mapi0(i0,i), INCPAR(i0,r)*(vdpa(i0,r) + vipa(i0,r))))
          / eh0(k,r) ;
bh0(k,r)$bh0(k,r)
          = sum(i$mapk(i,k), sum(i0$mapi0(i0,i), SUBPAR(i0,r)*(vdpa(i0,r) + vipa(i0,r))))
          / bh0(k,r) ;

*------------------------------------------------------------------------------*
*                                                                              *
*				Initialize primary factor markets							   *
*                                                                              *
*------------------------------------------------------------------------------*

*  Kinked supply elasticities

etanrfx(r,natra,lh)
    $ sum((nrs,a0) $ mapa0(a0,natra), vfm(nrs,a0,r))
    = sum((nrs,a0) $ mapa0(a0,natra), etanrfx0(r,a0,lh) * vfm(nrs,a0,r))
    / sum((nrs,a0) $ mapa0(a0,natra), vfm(nrs,a0,r)) ;

*  Initialize labor market assumptions

loop((r,l),

	IF(ifLSeg(r,l) eq 1,

*     Segmented labor markets

		lsFlag(r,l,rur)   = yes ;
		lsFlag(r,l,urb)   = yes ;
		lsFlag(r,l,nsg)   = no ;
		migr0(r,l)        = 0.01 * labHyp(r,l,"migr0") ;
		uez0(r,l,rur)     = 0.01 * labHyp(r,l,"uezRur0") ;
		uez0(r,l,urb)     = 0.01 * labHyp(r,l,"uezUrb0") ;
		ueMinz0(r,l,rur)  = 0.01 * labHyp(r,l,"ueMinzRur0") ;
		ueMinz0(r,l,urb)  = 0.01 * labHyp(r,l,"ueMinzUrb0") ;
		resWage0(r,l,rur) = labHyp(r,l,"resWageRur0") ;
		resWage0(r,l,urb) = labHyp(r,l,"resWageUrb0") ;

else

*     Integrated labor markets

		lsFlag(r,l,rur)  = no ;
		lsFlag(r,l,urb)  = no ;
		lsFlag(r,l,nsg)  = yes ;
		migr0(r,l)       = 0 ;
		uez0(r,l,nsg)    = 0.01*labHyp(r,l,"uezUrb0") ;
		ueMinz0(r,l,nsg) = 0.01*labHyp(r,l,"ueMinzUrb0") ;
		resWage0(r,l,nsg) = labHyp(r,l,"resWageUrb0") ;
	) ;

	omegarwg(r,l,z)  = labHyp(r,l,"omegarwg") ;
	omegarwue(r,l,z) = labHyp(r,l,"omegarwue") ;
	omegarwp(r,l,z)  = labHyp(r,l,"omegarwp") ;
) ;

ueFlag(r,l,z) = no ;

*  Checks

put screen ; put / ;
work = 0 ;
loop(lsFlag(r,l,z),
    IF(uez0(r,l,z) lt ueMinz0(r,l,z),
        put "Initial unemployment is less than minimum UE: ", r.tl, l.tl, z.tl / ;
        work = work + 1 ;
    ) ;
    IF(resWage0(r,l,z) ne na,
        ueFlag(r,l,z) = yes ;
        IF(resWage0(r,l,z) gt 1,
            put "Initial reservation wage is greater than actual wage: ", r.tl, l.tl, z.tl / ;
            work = work + 1 ;
        ) ;
    ) ;
) ;

IF(work > 0,
    put "Invalid UE initialization..." / ;
    abort "Check parameter file..." ;
) ;

*------------------------------------------------------------------------------*
*                                                                              *
*				Initialize Armington demand									   *
*                                                                              *
*------------------------------------------------------------------------------*

*  Value of agent specific Armington tax

paTax.l(r,i,a,t)    = inscale*(Agg3(vdfa,i,mapi,a,mapa) + Agg3(vifa,i,mapi,a,mapa)) ;
paTax.l(r,i,h,t)    = inscale*(Agg2(vdpa,i,mapi) + Agg2(vipa,i,mapi)) ;
paTax.l(r,i,gov,t)  = inscale*(Agg2(vdga,i,mapi) + Agg2(viga,i,mapi)) ;
paTax.l(r,i,inv,t)  = inscale*(Agg2(vdia,i,mapi) + Agg2(viia,i,mapi)) ;
$iftheni "%ifRD_MODULE%" == "ON"
   paTax.l(r,i,r_d,t) = inscale*(Agg2(vdra,i,mapi) + Agg2(vira,i,mapi)) ;
$endif

pdTax.l(r,i,a,t)    = inscale*Agg3(vdfa,i,mapi,a,mapa) ;
pdTax.l(r,i,h,t)    = inscale*Agg2(vdpa,i,mapi) ;
pdTax.l(r,i,gov,t)  = inscale*Agg2(vdga,i,mapi) ;
pdTax.l(r,i,inv,t)  = inscale*Agg2(vdia,i,mapi) ;
$iftheni "%ifRD_MODULE%" == "ON"
   pdTax.l(r,i,r_d,t) = inscale*Agg2(vdra,i,mapi) ;
$endif

pmTax.l(r,i,a,t)    = inscale*Agg3(vifa,i,mapi,a,mapa) ;
pmTax.l(r,i,h,t)    = inscale*Agg2(vipa,i,mapi) ;
pmTax.l(r,i,gov,t)  = inscale*Agg2(viga,i,mapi) ;
pmTax.l(r,i,inv,t)  = inscale*Agg2(viia,i,mapi) ;
$iftheni "%ifRD_MODULE%" == "ON"
   pmTax.l(r,i,r_d,t) = inscale*Agg2(vira,i,mapi) ;
$endif

paTax.l(r,i,aa,t)  = pdTax.l(r,i,aa,t) + pmTax.l(r,i,aa,t) ;

*  Value of agent specific Armington consumption at market price

xd.l(r,i,a,t)    = inscale*Agg3(vdfm,i,mapi,a,mapa) ;
xd.l(r,i,h,t)    = inscale*Agg2(vdpm,i,mapi) ;
xd.l(r,i,gov,t)  = inscale*Agg2(vdgm,i,mapi) ;
xd.l(r,i,inv,t)  = inscale*Agg2(vdim,i,mapi) ;
$iftheni "%ifRD_MODULE%" == "ON"
   xd.l(r,i,r_d,t)  = inscale*Agg2(vdrm,i,mapi)  ;
$endif

xm.l(r,i,a,t)    = inscale*Agg3(vifm,i,mapi,a,mapa) ;
xm.l(r,i,h,t)    = inscale*Agg2(vipm,i,mapi) ;
xm.l(r,i,gov,t)  = inscale*Agg2(vigm,i,mapi) ;
xm.l(r,i,inv,t)  = inscale*Agg2(viim,i,mapi) ;
$iftheni "%ifRD_MODULE%" == "ON"
   xm.l(r,i,r_d,t)  = inscale*Agg2(virm,i,mapi)  ;
$endif

xa.l(r,i,aa,t)   = xd.l(r,i,aa,t) + xm.l(r,i,aa,t) ;

* Initialize production flags

loop(t0,
    xaFlag(r,i,aa) $ xa.l(r,i,aa,t0) = 1 ;
    xdFlag(r,i,aa) $ xd.l(r,i,aa,t0) = 1 ;
    xmFlag(r,i,aa) $ xm.l(r,i,aa,t0) = 1 ;
) ;

*  Agent specific tax rate

paTax.l(r,i,aa,t)$(xa.l(r,i,aa,t) and paTax.l(r,i,aa,t))
    = paTax.l(r,i,aa,t) / xa.l(r,i,aa,t) - 1 ;
pdTax.l(r,i,aa,t)$(xd.l(r,i,aa,t) and pdTax.l(r,i,aa,t))
    = pdTax.l(r,i,aa,t) / xd.l(r,i,aa,t) - 1 ;
pmTax.l(r,i,aa,t)$(xm.l(r,i,aa,t) and pmTax.l(r,i,aa,t))
    = pmTax.l(r,i,aa,t) / xm.l(r,i,aa,t) - 1 ;

*  Impose price/volume split
* this implies pa(i,tmg), pm(i,tmg) and pd(i,tmg) = 0 but with no csqs

xa.l(r,i,aa,t) $ xa.l(r,i,aa,t)
	= xa.l(r,i,aa,t) / (gammaeda(r,i,aa) * pat.l(r,i,t)) ;
xd.l(r,i,aa,t) $ xd.l(r,i,aa,t)
	= xd.l(r,i,aa,t) / (gammaedd(r,i,aa) * pdt.l(r,i,t)) ;
xm.l(r,i,aa,t) $ xm.l(r,i,aa,t)
	= xm.l(r,i,aa,t) / (gammaedm(r,i,aa) * pmt.l(r,i,t)) ;

*  Determine agent' specific Armington price, i.e. tax inclusive Armington price

pa.l(r,i,aa,t) = gammaeda(r,i,aa) * pat.l(r,i,t) * (1 + paTax.l(r,i,aa,t)) ;
pd.l(r,i,aa,t) = gammaedd(r,i,aa) * pdt.l(r,i,t) * (1 + pdTax.l(r,i,aa,t)) ;
pm.l(r,i,aa,t) = gammaedm(r,i,aa) * pmt.l(r,i,t) * (1 + pmTax.l(r,i,aa,t)) ;

*  Initialize aggregate final demand

yfd.l(r,fd,t) = sum(i, pa.l(r,i,fd,t) * xa.l(r,i,fd,t)) ;
pfd.l(r,fd,t) $ yfd.l(r,fd,t) = defaultInit ;
xfd.l(r,fd,t) $ pfd.l(r,fd,t) = yfd.l(r,fd,t) / pfd.l(r,fd,t) ;

* [OECD-ENV] sector specific investment (Ongoing)

pfda.fx(r,a,t) = 0 ; pfda0(r,a) = 0 ;
yfda.fx(r,a,t) = 0 ; yfda0(r,a) = 0 ;
xfda.fx(r,a,t) = 0 ; xfda0(r,a) = 0 ;

$IfTheni.PubInv %TestPubInV%=="ON"

* Test
    set unitp / val, vol / ;
    parameter Test(r,unitp);
    LOOP(t0,
        Test(r,"val") = sum(fd, yfd.l(r,fd,t0));
        Test(r,"vol") = sum(fd, xfd.l(r,fd,t0));
    ) ;

    Execute_unload "%cBaseFile%_%system.fn%_InvGtap.gdx", test ;

    Parameter PubInvShr0(r) "Share public investment in total investment" ;
    PubInvShr0(r) = 0.15 ;

    LOOP(inv,
        xa.l(r,i,pub,t) = PubInvShr0(r) * xa.l(r,i,inv,t) ;
        xd.l(r,i,pub,t) = PubInvShr0(r) * xd.l(r,i,inv,t) ;
        xm.l(r,i,pub,t) = PubInvShr0(r) * xm.l(r,i,inv,t) ;

        xa.l(r,i,inv,t) = (1 - PubInvShr0(r)) * xa.l(r,i,inv,t) ;
        xd.l(r,i,inv,t) = (1 - PubInvShr0(r)) * xd.l(r,i,inv,t) ;
        xm.l(r,i,inv,t) = (1 - PubInvShr0(r)) * xm.l(r,i,inv,t) ;

        paTax.l(r,i,pub,t) = paTax.l(r,i,inv,t) ;
        pdTax.l(r,i,pub,t) = pdTax.l(r,i,inv,t) ;
        pmTax.l(r,i,pub,t) = pmTax.l(r,i,inv,t) ;

        pa.l(r,i,aa,t) = gammaeda(r,i,aa) * pat.l(r,i,t) * (1 + paTax.l(r,i,aa,t)) ;
        pd.l(r,i,aa,t) = gammaedd(r,i,aa) * pdt.l(r,i,t) * (1 + pdTax.l(r,i,aa,t)) ;
        pm.l(r,i,aa,t) = gammaedm(r,i,aa) * pmt.l(r,i,t) * (1 + pmTax.l(r,i,aa,t)) ;
    ) ;

    yfd.l(r,fd,t) = sum(i, pa.l(r,i,fd,t) * xa.l(r,i,fd,t)) ;
    pfd.l(r,fd,t) $ yfd.l(r,fd,t) = defaultInit ;
    xfd.l(r,fd,t) $ pfd.l(r,fd,t) = yfd.l(r,fd,t) / pfd.l(r,fd,t) ;

    LOOP(t0,
        Test(r,"val") = sum(fd, yfd.l(r,fd,t0));
        Test(r,"vol") = sum(fd, xfd.l(r,fd,t0));
    ) ;

    Execute_unload "%cBaseFile%_%system.fn%_InvAdusted.gdx", test ;

$EnDif.PubInv

*------------------------------------------------------------------------------*
*                                                                              *
*				Initialize the production variables							   *
*     				 Primary factor purchases (paid by firms)                  *
*                                                                              *
*------------------------------------------------------------------------------*
$OnDotl

* Tax/Social contribution rate on primary factor, by sector, by factor

Taxfp.l(r,a,fp,t) $ sum(mapa0(a0,a), vfm(fp,a0,r) )
	= sum(mapa0(a0,a), ftrv(fp,a0,r)) / sum(mapa0(a0,a), vfm(fp,a0,r) ) ;

* Support rate on primary factors (received by firms), by sector, by factor

Subfp.l(r,a,fp,t) $ sum(mapa0(a0,a), vfm(fp,a0,r) )
	= sum(mapa0(a0,a),fbep(fp,a0,r)) / sum(mapa0(a0,a), vfm(fp,a0,r) ) ;

* Alternative: producer support calculated as residual (give same thing)

Subfp.l(r,a,fp,t) $ sum(mapa0(a0,a), vfm(fp,a0,r) )
	= sum(mapa0(a0,a), vfm(fp,a0,r) - evfa(fp,a0,r) + ftrv(fp,a0,r))
	/ sum(mapa0(a0,a), vfm(fp,a0,r) ) ;

Subfp.l(r,a,fp,t) $ ( ABS(Subfp.l(r,a,fp,t)) lt lScale) = 0 ;

IF(IfMergeTaxAndSubfp,
	Taxfp.l(r,a,fp,t) = m_netTaxfp(r,a,fp,t) ;
	Subfp.l(r,a,fp,t) = 0 ;
) ;

*------------------------------------------------------------------------------*
*   	Labor demand: ld, wage, wagep					    			       *
*------------------------------------------------------------------------------*

ld.l(r,l,a,t)
    = {inscale * sum(mapa0(a0,a),vfm(l,a0,r)) } $ {sum(mapa0(a0,a),empl(l,a0,r)) eq na}
    + { lscale * sum(mapa0(a0,a),empl(l,a0,r))} $ {sum(mapa0(a0,a),empl(l,a0,r)) ne na}
    ;

wage.l(r,l,a,t) $ ld.l(r,l,a,t)
    = {inscale * sum(mapa0(a0,a), vfm(l,a0,r)) / ld.l(r,l,a,t)
	  } $ {sum(t0,ld.l(r,l,a,t0))}
    + {1} $ {sum(t0,ld.l(r,l,a,t0)) eq 0} ;

* Labor purchasers' price of factors

wagep.l(r,l,a,t) = wage.l(r,l,a,t) * (1 + m_netTaxfp(r,a,l,t)) ;

*------------------------------------------------------------------------------*
*   	Capital demand: trent, ktax, kv, pk, pkp		    			       *
*------------------------------------------------------------------------------*.

adjKTaxfp(r,cap,a,v) = 1;
adjKSubfp(r,cap,a,v) = 1;

trent.l(r,t) = defaultInit ;

loop((cap,vOld),

    kv.l(r,a,vOld,t) = inscale * sum(mapa0(a0,a), vfm(cap,a0,r) ) ;
    pk.l(r,a,v,t) $ kv.l(r,a,vOld,t) = trent.l(r,t) ;

*  Capital/price split

	kv.l(r,a,vOld,t) $ pk.l(r,a,vOld,t) = kv.l(r,a,vOld,t) / pk.l(r,a,vOld,t) ;

* Capital purchasers' price of factors

    pkp.l(r,a,v,t) = pk.l(r,a,v,t)  * (1 + m_netTaxfp(r,a,cap,t)) ;

) ;

arent.l(r,t) $ trent.l(r,t) = 1;

* OECD-ENV: Capital to efficient labour ratio (Not in the model)

kaplab.fx(r,t)
    $ sum((a,l,t0)   $ ld.l(r,l,a,t0),    wagep.l(r,l,a,t0)  * ld.l(r,l,a,t))
    = sum((a,vOld,t0)$ kv.l(r,a,vOld,t0), pkp.l(r,a,vOld,t0) * kv.l(r,a,vOld,t))
    / sum((a,l,t0)   $ ld.l(r,l,a,t0),    wagep.l(r,l,a,t0)  * ld.l(r,l,a,t)) ;


*------------------------------------------------------------------------------*
*  Land demand: ptland, land, pland, plandp									   *
*------------------------------------------------------------------------------*

ptland.l(r,t) = defaultInit ;

loop(lnd,

    land.l(r,a,t) = inscale * sum(mapa0(a0,a), vfm(lnd,a0,r) ) ;
    pland.l(r,a,t) $ land.l(r,a,t) = ptland.l(r,t) ;

* Land/price split

    land.l(r,a,t) $ pland.l(r,a,t) = land.l(r,a,t) / pland.l(r,a,t) ;

*  Factor tax and subsidy rates and purchasers' price of factors

	plandp.l(r,a,t)  = pland.l(r,a,t) * (1 + m_netTaxfp(r,a,lnd,t)) ;

) ;

*------------------------------------------------------------------------------*
*    Natural resource demand: xnrf, pnrf, pnrfp								   *
*------------------------------------------------------------------------------*

* [EditJean]: only natra to reduce size of variable --> add nrfFlag(r,a) in pkfeq

loop((nrs,a) $ natra(a),

    xnrf.l(r,a,t) = inscale * sum(mapa0(a0,a), vfm(nrs,a0,r) );
	pnrf.l(r,a,t) $ xnrf.l(r,a,t) = defaultInit ;

* Natural resource/price split

    xnrf.l(r,a,t) $ pnrf.l(r,a,t) = xnrf.l(r,a,t) / pnrf.l(r,a,t) ;

* Natural resource purchasers' price of factors

    pnrfp.l(r,a,t) = pnrf.l(r,a,t) * (1 + m_netTaxfp(r,a,nrs,t)) ;

) ;

*------------------------------------------------------------------------------*
*    Water demand demand: h2o, ph2o, ph2op		  							   *
*------------------------------------------------------------------------------*

ph2o.l(r,a,t) = defaultInit ;

loop(wat $ IfWater,
	h2o.l(r,a,t)  = watScale * sum(mapa0(a0,a), h2oCrp(a0,r)) ;
    ph2o.l(r,a,t) $ h2o.l(r,a,t)
        = inscale * sum(mapa0(a0,a), vfm(wat,a0,r)) / h2o.l(r,a,t) ;
    ph2op.l(r,a,t) = ph2o.l(r,a,t) * (1 + m_netTaxfp(r,a,wat,t)) ;
) ;

$OffDotl

*   Initialize production flags

loop((t0,vOld),
    labFlag(r,l,a) $ ld.l(r,l,a,t0)    = 1 ;
    kFlag(r,a)     $ kv.l(r,a,vOld,t0) = 1 ;
    landFlag(r,a)  $ land.l(r,a,t0)    = 1 ;
    nrfFlag(r,a)   $ xnrf.l(r,a,t0)    = 1 ;
    xwatfFlag(r,a) $ h2o.l(r,a,t0)     = 1 ;
) ;

*------------------------------------------------------------------------------*
*   	Construct the intermediate demand bundles: nd1,nd2, xat			       *
*------------------------------------------------------------------------------*

nd1.l(r,a,t) $ pnd1.l(r,a,t)
    = sum(mapi1(i,a), pa.l(r,i,a,t) * xa.l(r,i,a,t)) / pnd1.l(r,a,t) ;
nd2.l(r,a,t) $ pnd2.l(r,a,t)
    = sum(mapi2(i,a), pa.l(r,i,a,t) * xa.l(r,i,a,t)) / pnd2.l(r,a,t) ;

xwat.l(r,a,t)$ pwat.l(r,a,t)
    = (sum(i $ iw(i), pa.l(r,i,a,t) * xa.l(r,i,a,t)) + ph2op.l(r,a,t)*h2o.l(r,a,t))
    / pwat.l(r,a,t) ;

loop(t0,
    nd1Flag(r,a)  $ nd1.l(r,a,t0)  = 1 ;
    nd2Flag(r,a)  $ nd2.l(r,a,t0)  = 1 ;
    watFlag(r,a)  $ xwat.l(r,a,t0) = 1 ;
) ;

*------------------------------------------------------------------------------*
*   				Construct the Energy demand bundles						   *
*------------------------------------------------------------------------------*

* memo: in OECD-ENV IfNrgNest is now agent specific

LOOP((r,a) $ IfNrgNest(r,a),

*    paNRG.l(r,a,NRG,v,t) $ sum(e$mape(NRG,e), pa.l(r,e,a,t) * xa.l(r,e,a,t)) = defaultInit;
    xaNRG.l(r,a,NRG,vOld,t) $ paNRG.l(r,a,NRG,vOld,t)
        = sum(e$mape(NRG,e), pa.l(r,e,a,t) * xa.l(r,e,a,t))
        / paNRG.l(r,a,NRG,vOld,t);

*    polg.l(r,a,v,t) $ sum(vOld,sum(GAS,paNRG.l(r,a,GAS,vOld,t)*xaNRG.l(r,a,GAS,vOld,t)) + sum(OIL,paNRG.l(r,a,OIL,vOld,t)*xaNRG.l(r,a,OIL,vOld,t))) = defaultInit;
     xolg.l(r,a,vOld,t) $ polg.l(r,a,vOld,t)
        = [sum(GAS,paNRG.l(r,a,GAS,vOld,t)*xaNRG.l(r,a,GAS,vOld,t))
        +  sum(OIL,paNRG.l(r,a,OIL,vOld,t)*xaNRG.l(r,a,OIL,vOld,t))]
        / polg.l(r,a,vOld,t);

*    pnely.l(r,a,v,t) $ sum(vOld,sum(COA,paNRG.l(r,a,COA,vOld,t)*xaNRG.l(r,a,COA,vOld,t) +  polg.l(r,a,vOld,t)*xolg.l(r,a,vOld,t))) = defaultInit;
    xnely.l(r,a,vOld,t) $ pnely.l(r,a,vOld,t)
        = [sum(COA,paNRG.l(r,a,COA,vOld,t)*xaNRG.l(r,a,COA,vOld,t)
        +  polg.l(r,a,vOld,t)*xolg.l(r,a,vOld,t))]  / pnely.l(r,a,vOld,t);
*    pnrg.l(r,a,v,t)  $ sum(vOld,sum(ELY,paNRG.l(r,a,ELY,vOld,t)*xaNRG.l(r,a,ELY,vOld,t)) +  pnely.l(r,a,vOld,t)*xnely.l(r,a,vOld,t)) = defaultInit;

) ;

* pnrg.l(r,a,v,t) $ {not IfNrgNest(r,a) and sum(e, pa.l(r,e,a,t) * xa.l(r,e,a,t))}  = defaultInit;

xnrg.l(r,a,vOld,t) $ pnrg.l(r,a,vOld,t)
    = [{sum(ELY, paNRG.l(r,a,ELY,vOld,t) * xaNRG.l(r,a,ELY,vOld,t))
        +  pnely.l(r,a,vOld,t)*xnely.l(r,a,vOld,t) } $ IfNrgNest(r,a)
    + {sum(e, pa.l(r,e,a,t) * xa.l(r,e,a,t))       } $ {not IfNrgNest(r,a)}
      ] / pnrg.l(r,a,vOld,t)   ;

loop((t0,vOld),
    xaNRGFlag(r,a,NRG) $ xaNRG.l(r,a,NRG,vOld,t0) = 1 ;
    xnrgFlag(r,a)      $ xnrg.l(r,a,vOld,t0)      = 1 ;
    xnelyFlag(r,a)     $ xnely.l(r,a,vOld,t0)     = 1 ;
    xolgFlag(r,a)      $ xolg.l(r,a,vOld,t0)      = 1 ;
) ;

*  Construct the labor demand bundles

lab1.l(r,a,t) $ plab1.l(r,a,t)
    = sum(ul, wagep.l(r,ul,a,t) * ld.l(r,ul,a,t)) / plab1.l(r,a,t) ;
lab2.l(r,a,t) $ plab2.l(r,a,t)
    = sum(sl, wagep.l(r,sl,a,t) * ld.l(r,sl,a,t)) / plab2.l(r,a,t) ;

loop(t0,
    lab1Flag(r,a) $ lab1.l(r,a,t0) = 1 ;
    lab2Flag(r,a) $ lab2.l(r,a,t0) = 1 ;
) ;

*  Construct the KF/KEF bundles

ks.l(r,a,vOld,t)  $ pks.l(r,a,vOld,t)
    = (pkp.l(r,a,vOld,t) * kv.l(r,a,vOld,t) + lab2.l(r,a,t) * plab2.l(r,a,t))
    / pks.l(r,a,vOld,t) ;

ksw.l(r,a,vOld,t) $ pksw.l(r,a,vOld,t)
    = (pks.l(r,a,vOld,t) * ks.l(r,a,vOld,t) + xwat.l(r,a,t) * pwat.l(r,a,t))
    / pksw.l(r,a,vOld,t) ;

kf.l(r,a,vOld,t)  $ pkf.l(r,a,vOld,t)
    = (pksw.l(r,a,vOld,t) * ksw.l(r,a,vOld,t) + pnrfp.l(r,a,t) * xnrf.l(r,a,t))
    / pkf.l(r,a,vOld,t) ;

kef.l(r,a,vOld,t) $ pkef.l(r,a,vOld,t)
    = (pkf.l(r,a,vOld,t) * kf.l(r,a,vOld,t) + pnrg.l(r,a,vOld,t) * xnrg.l(r,a,vOld,t))
    / pkef.l(r,a,vOld,t) ;

*------------------------------------------------------------------------------*
*                       Construct the VA bundles                               *
*------------------------------------------------------------------------------*

pva2.l(r,a,v,t)
    $ sum(vOld,
        {plandp.l(r,a,t)*land.l(r,a,t) + pkef.l(r,a,vOld,t)*kef.l(r,a,vOld,t)}$cra(a)
      + {plandp.l(r,a,t)*land.l(r,a,t) + pnd2.l(r,a,t)*nd2.l(r,a,t)}$lva(a) )
    = defaultInit;

va2.l(r,a,vOld,t) $ pva2.l(r,a,vOld,t)
    = ((plandp.l(r,a,t)*land.l(r,a,t) + pkef.l(r,a,vOld,t)*kef.l(r,a,vOld,t))
    / pva2.l(r,a,vOld,t))$cra(a)
    + ((plandp.l(r,a,t)*land.l(r,a,t) + pnd2.l(r,a,t)*nd2.l(r,a,t))
    / pva2.l(r,a,vOld,t))$lva(a) ;

pva1.l(r,a,v,t)
    $ sum(vOld,
        {pnd2.l(r,a,t)*nd2.l(r,a,t) + pva2.l(r,a,vOld,t)*va2.l(r,a,vOld,t)  }$cra(a)
      + {lab1.l(r,a,t)*plab1.l(r,a,t) + pkef.l(r,a,vOld,t)*kef.l(r,a,vOld,t)}$lva(a)
      + {[plandp.l(r,a,t)*land.l(r,a,t) + pkef.l(r,a,vOld,t)*kef.l(r,a,vOld,t)] } $ axa(a))
    = defaultInit;

va1.l(r,a,vOld,t) $ pva1.l(r,a,vOld,t)
    = ((pnd2.l(r,a,t)*nd2.l(r,a,t) + pva2.l(r,a,vOld,t)*va2.l(r,a,vOld,t))
    / pva1.l(r,a,vOld,t))$cra(a)
    + ((lab1.l(r,a,t)*plab1.l(r,a,t) + pkef.l(r,a,vOld,t)*kef.l(r,a,vOld,t))
    / pva1.l(r,a,vOld,t))$lva(a)
    + ((plandp.l(r,a,t)*land.l(r,a,t) + pkef.l(r,a,vOld,t)*kef.l(r,a,vOld,t))
    / pva1.l(r,a,vOld,t)) $ axa(a)   ;

pva.l(r,a,v,t)
    $ sum(vOld,{lab1.l(r,a,t)*plab1.l(r,a,t) + pva1.l(r,a,vOld,t)*va1.l(r,a,vOld,t)}$(NOT lva(a))
    + {pva2.l(r,a,vOld,t)*va2.l(r,a,vOld,t) + pva1.l(r,a,vOld,t)*va1.l(r,a,vOld,t)}$lva(a))
    = defaultInit;

va.l(r,a,vOld,t) $ pva.l(r,a,vOld,t)
    = {(lab1.l(r,a,t)*plab1.l(r,a,t) + pva1.l(r,a,vOld,t)*va1.l(r,a,vOld,t))
    / pva.l(r,a,vOld,t)} $ {NOT lva(a)}
    + {(pva2.l(r,a,vOld,t)*va2.l(r,a,vOld,t) + pva1.l(r,a,vOld,t)*va1.l(r,a,vOld,t))
    / pva.l(r,a,vOld,t)} $ lva(a) ;


* [OECD-ENV]: 2 April 2022 move emissions before the Construction of the XPX and XGHG bundles

*------------------------------------------------------------------------------*
*                   Construct the XPX bundle                                   *
*------------------------------------------------------------------------------*

xpx.l(r,a,vOld,t) $ pxp.l(r,a,vOld,t)
    = (pnd1.l(r,a,t) * nd1.l(r,a,t) + pva.l(r,a,vOld,t) * va.l(r,a,vOld,t))
    / pxp.l(r,a,vOld,t) ;

* OECD-ENV: gross output

LOOP((vOld,t0), xp0(r,a,t) =  xpx.l(r,a,vOld,t0) ; ) ;

*------------------------------------------------------------------------------*
*                                                                              *
*                   Initialization of emissions module                         *
*                                                                              *
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
*   Initialization of emissions: emi.l(r,AllEmissions,EmiSource,aa,t)          *
*------------------------------------------------------------------------------*

*  The 'm' variables are in millions of tons of CO2

*- HD: declaring those conditionally saves  400MB in model size 

*- HD: no need to loop over a Singleton Set
*loop(t0,

*   1.) Assign CO2 emissions from fossil fuel combustion (fi)

* 1.1) intermediate demands

	emird(r,CO2,EmiUse,a,t0)$sum(mapiEmi(fi,EmiUse),
                    sum((i0,a0)$(mapi0(i0,fi) and mapa0(a0,a)), mdf(i0,a0,r)))
        = sum(mapiEmi(fi,EmiUse),
                    sum((i0,a0)$(mapi0(i0,fi) and mapa0(a0,a)), mdf(i0,a0,r))) ;
    emirm(r,CO2,EmiUse,a,t0)$sum(mapiEmi(fi,EmiUse),
                    sum((i0,a0)$(mapi0(i0,fi) and mapa0(a0,a)), mif(i0,a0,r)))
        = sum(mapiEmi(fi,EmiUse),
                    sum((i0,a0)$(mapi0(i0,fi) and mapa0(a0,a)), mif(i0,a0,r))) ;

* 1.2) Household final demands

    emird(r,CO2,EmiUse,h,t0)$sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mdp(i0,r)))
        = sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mdp(i0,r))) ;
    emirm(r,CO2,EmiUse,h,t0)$sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mip(i0,r)))
        = sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mip(i0,r))) ;

* 1.3) Government final demands

    emird(r,CO2,EmiUse,gov,t0)$sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mdg(i0,r))) 
        = sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mdg(i0,r))) ;
    emirm(r,CO2,EmiUse,gov,t0)$sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mig(i0,r)))
        = sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mig(i0,r))) ;

* 1.4) Investment final demands

    emird(r,CO2,EmiUse,inv,t0)$sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mdi(i0,r)))
        = sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mdi(i0,r))) ;
    emirm(r,CO2,EmiUse,inv,t0)$sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mii(i0,r)))
        = sum(mapiEmi(fi,EmiUse),sum(mapi0(i0,fi), mii(i0,r))) ;

* 1.5) Average coefficients

    emir(r,CO2,EmiUse,aa,t0)$(emird(r,CO2,EmiUse,aa,t0) + emirm(r,CO2,EmiUse,aa,t0))
        = emird(r,CO2,EmiUse,aa,t0) + emirm(r,CO2,EmiUse,aa,t0) ;

* [EditJean]: no need to keep emission coefficient by origin if not used

    IF(NOT IfArmFlag,
        emird(r,CO2,EmiUse,aa,t) = 0 ;
        emirm(r,CO2,EmiUse,aa,t) = 0 ;
    ) ;

* [OECD-ENV]: Correction
*    emir(OPEP,CO2,EmiUse,omana,t0) = emir(OPEP,CO2,EmiUse,omana,t0) * 0.5 ;
*    emir(OPEP,CO2,chemUse,MTEa,t0) = 2.5;

*   2.) Assign NON-CO2 from fuel combustion(come in both physical units and CEQ)

* 2.1) non-fossil inputs use

* intermediate demand

    emir(r,em,EmiUse,a,t0) $ (NOT emir(r,em,EmiUse,a,t0))
        = sum(mapiEmi(i,EmiUse),
            sum((i0,a0) $ (mapi0(i0,i) and mapa0(a0,a)),nc_trad_cEQ(em,i0,a0,r))
            ) ;

* household demand

    emir(r,em,EmiUse,h,t0) $ (NOT emir(r,em,EmiUse,h,t0))
        = sum(mapiEmi(i,EmiUse), sum(mapi0(i0,i), nc_hh_cEQ(em,i0,r))) ;

* 2.1) primary factor use

    emir(r,nco2,EmiFp,a,t0)
        = sum(mapFpEmi(fp,EmiFp), sum(mapa0(a0,a), nc_endw_cEQ(nco2,fp,a0,r))) ;

* 2.1) process emissions

    emir(r,em,"act",a,t0) = sum(mapa0(a0,a), nc_qo_cEQ(em,a0,r)) ;
    emir(r,em,"act",wtra,t0) = 0 ;
    emir(r,em,"wastesld",wtra,t0) = sum(mapa0(a0,wtra), nc_qo_cEQ(em,a0,r)) ;

    emir(r,em,"act",fa,t0) = 0 ;
    emir(r,em,"fugitive",fa,t0) = sum(mapa0(a0,fa), nc_qo_cEQ(em,a0,r)) ;

*   Scale coefficients [Option]

    emir(r,em,EmiSource,aa,t0) = m_ConvGHG * emir(r,em,EmiSource,aa,t0) ;
    emird(r,CO2,EmiUse,aa,t0)  = m_ConvGHG * emird(r,CO2,EmiUse,aa,t0)  ;
    emirm(r,CO2,EmiUse,aa,t0)  = m_ConvGHG * emirm(r,CO2,EmiUse,aa,t0)  ;

* OECD-ENV: Add Air Pollutant gases in billions of tons (physical units)

    emir(r,OAP,EmiUse,a,t0)
        = apscale * sum(mapiEmi(i,EmiUse),
            sum((i0,a0) $ (mapi0(i0,i) and mapa0(a0,a)),nc_trad(OAP,i0,a0,r))) ;
    emir(r,OAP,EmiUse,h,t0)
        = apscale * sum(mapiEmi(i,EmiUse),sum(mapi0(i0,i),nc_hh(OAP,i0,r))) ;
    emir(r,OAP,EmiFp,a,t0)
        = apscale * sum(mapFpEmi(fp,EmiFp),
            sum(mapa0(a0,a),nc_endw(OAP,fp,a0,r))) ;
    emir(r,OAP,emiact,a,t0) = apscale * sum(mapa0(a0,a),nc_qo(OAP,a0,r)) ;

* OECD-ENV: GTAP92 Air Pollutant NMVB and NMVF --> NMVOC (same physical unit?)

    $$IfTheni.GTAP9 %gtap_ver%=="92"
        emir(r,"NMVOC",EmiSource,aa,t0)
            = emir(r,"NMVB",EmiSource,aa,t0) + emir(r,"NMVF",EmiSource,aa,t0);
        emir(r,"NMVB",EmiSource,aa,t0) = 0;
        emir(r,"NMVF",EmiSource,aa,t0) = 0;
    $$Endif.GTAP9

* OECD-ENV: Add "Forestry/Biomass burning emissions and CO2 Lulucf emissions
* (Lulucf do not fit with FAO data)

    $$IfTheni.GTAP10 NOT %GTAP_ver%=="92"

* mil tCO2-eq. for GHGs

        emir(r,em,"AgrBurn",a,t0)
            = m_ConvGHG * sum(mapa0(a0,a), LandUseEmi_CEQ(em,"AgrBurn",a0,r)) ;

* Gg for OAP

        emir(r,oap,"AgrBurn",a,t0)
            =  apscale * sum(mapa0(a0,a), LandUseEmi(oap,"AgrBurn",a0,r)) ;

* only type of emission in process emissions --> merge AgrBurn with act

        emir(r,AllEmissions,"act",a,t0)
            $ (     emir(r,AllEmissions,"act",a,t0)
                and emir(r,AllEmissions,"AgrBurn",a,t0) )
            = emir(r,AllEmissions,"act",a,t0)
            + emir(r,AllEmissions,"AgrBurn",a,t0) ;
        emir(r,AllEmissions,"AgrBurn",a,t0)
            $ (     emir(r,AllEmissions,"act",a,t0)
                and emir(r,AllEmissions,"AgrBurn",a,t0) )
            = 0 ;

        emir(r,CO2,EmiLulucf,a,t0)
            = m_ConvGHG * sum(mapa0(a0,a), LandUseEmi_CEQ(CO2,emilulucf,a0,r)) ;

    $$Endif.GTAP10

*   Initialize the full emission trajectory

    emi.l(r,EmSingle,EmiSource,aa,t) = emir(r,EmSingle,EmiSource,aa,t0);
    emi.l(r,OAP,EmiSource,aa,t) 	 = emir(r,OAP,EmiSource,aa,t0);
    emir(r,CO2,EmiLulucf,a,t0) = 0 ; !! no coefficient for lulucf
*) ;

*------------------------------------------------------------------------------*
*       Emission calibration procedure: override default (i.e. GTAP data)      *
*------------------------------------------------------------------------------*

$IfTheni.GhgCal %cal_GHG%=="ON"

*   Fill "Emissions_data('GTAP')" for all the trajectory

    LOOP(t0,
        Emissions_data("GTAP",r,EmSingle,EmiSource,aa,t)
            = emi.l(r,EmSingle,EmiSource,aa,t0) / m_ConvGHG ;
        Emissions_data("GTAP",r,oap,EmiSource,aa,t)
            = emi.l(r,oap,EmiSource,aa,t0) / apscale ;
    ) ;

*   Save "Emissions_data" (Option)

    $$IfThen NOT EXIST "%CheckCalFile%_%system.fn%_Emissions_data.gdx"
        IF(IfDebug,
            Execute_unload "%CheckCalFile%_%system.fn%_Emissions_data.gdx",
                Emissions_data, aa, a0 ;
            EXECUTE 'gdxdump %CheckCalFile%_%system.fn%_Emissions_data.gdx format=CSV output=%CheckCalFile%_%system.fn%_Emissions_data.csv symb=Emissions_data'
        ) ;
    $$EndIf

*   Replace emissions by selected dataset

* 1.) For security clean all emission variables (excluded EmiLulucf)

    emir(r,AllEmissions,EmiSource,aa,t)   = 0 ;
    emird(r,AllEmissions,EmiUse,aa,t)     = 0 ;
    emirm(r,AllEmissions,EmiUse,aa,t)     = 0 ;
    emi.l(r,EmSingle,EmiSource,aa,t) $ (NOT EmiLulucf(EmiSource)) = 0 ;
    emi.l(r,OAP,EmiSource,aa,t)      $ (NOT EmiLulucf(EmiSource)) = 0 ;

* 2.) For security clean irrelevant emiassociation

    LOOP(t0,
        emiassociation(r,AllEmissions,EmiSource,aa,SetEmiDB)
            $ (Emissions_data(SetEmiDB,r,AllEmissions,EmiSource,aa,t0) eq 0)
            =  0 ;
    ) ;

* 3.) Associate emission "emi" to selected "Emissions_data"

* #todo simplify scaling via macro

    LOOP(SetEmiDB,
        emi.l(r,EmSingle,EmiSource,aa,t)
            $ emiassociation(r,EmSingle,EmiSource,aa,SetEmiDB)
        = m_ConvGHG * Emissions_data(SetEmiDB,r,EmSingle,EmiSource,aa,t) ;
        emi.l(r,oap,EmiSource,aa,t)
            $ emiassociation(r,oap,EmiSource,aa,SetEmiDB)
        = apscale * Emissions_data(SetEmiDB,r,oap,EmiSource,aa,t) ;
    ) ;

	PARAMETER emi2005(r,AllEmissions,EmiSource,aa);
    LOOP(SetEmiDB,
        emi2005(r,EmSingle,EmiSource,aa)
            $ emiassociation(r,EmSingle,EmiSource,aa,SetEmiDB)
        = m_ConvGHG * Emissions_data(SetEmiDB,r,EmSingle,EmiSource,aa,"2005") ;
        emi2005(r,oap,EmiSource,aa)
            $ emiassociation(r,oap,EmiSource,aa,SetEmiDB)
        = apscale * Emissions_data(SetEmiDB,r,oap,EmiSource,aa,"2005") ;
    ) ;

	EXECUTE_UNLOAD "%iDataDir%\emi2005.gdx", emi2005 ;

    LOOP(t0,
        emiassociation(r,AllEmissions,EmiSource,aa,SetEmiDB)
            $ (emi.l(r,AllEmissions,EmiSource,aa,t0) eq 0) = 0 ;
    ) ;

    IF(IfDebug,
        EXECUTE_UNLOAD "%CheckCalFile%_%system.fn%_emi.gdx",
            emiassociation, emi.l ;
    ) ;

*   4.) Extend initialization over the horizon

    LOOP( t $ m_horizonSim(t),
        emi.l(r,AllEmissions,EmiSource,aa,t)
            $(      emi.l(r,AllEmissions,EmiSource,aa,t)   eq 0
                and emi.l(r,AllEmissions,EmiSource,aa,t-1) ne 0)
            = emi.l(r,AllEmissions,EmiSource,aa,t-1) ;
    ) ;

$Endif.GhgCal

*   [OECD-ENV]:

$OnText
* Initialisation Emission Flag - By default Non CO2 are like Dominique
* But one could change the logic GHGs are implemented, for example
* to put all sources in upper nest like in the ENV-Linkage v3 we can do:
loop(t0,
    emi.l(r,em,"act",a,t)
        = sum(emiact,emi.l(r,em,emiact,a,t0))
        + sum(EmiSource $ (EmiUse(EmiSource) and not EmiComb(EmiSource)) ,
            emi.l(r,em,EmiSource,a,t0))
        + sum(EmiFp, emi.l(r,em,EmiFp,a,t0));
    emi.l(r,em,EmiSource,a,t)
        $ (EmiUse(EmiSource) and not  EmiComb(EmiSource)) = 0 ;
    emi.l(r,em,fp,a,t)            = 0;
);
$OffText

*------------------------------------------------------------------------------*
*              Initialize emissions coefficients: emir      		           *
*------------------------------------------------------------------------------*

* OECD-ENV: updated for OAP (and for calibration)

*- HD no need to loop over a Singleton Set
*loop(t0,

*- HD: add xaFlag to emission calibration calculations to make assignment cost less 

* Emission to intermediate demand in value

    emir(r,AllEmissions,EmiUse,aa,t)$sum(mapiEmi(i,EmiUse),xaFlag(r,i,aa))
*and sum(mapiEmi(i,EmiUse), xa.l(r,i,aa,t0)))
        = emi.l(r,AllEmissions,EmiUse,aa,t0)
        / sum(mapiEmi(i,EmiUse), xa.l(r,i,aa,t0)) ;

* Domestic to imported (GTAP only)

    IF(IfArmFlag,
        emird(r,CO2,EmiUse,aa,t) $sum(mapiEmi(i,EmiUse),xdflag(r,i,aa))
*sum(mapiEmi(i,EmiUse), xd.l(r,i,aa,t0))
            = emird(r,CO2,EmiUse,aa,t0)
            / sum(mapiEmi(i,EmiUse), xd.l(r,i,aa,t0));
        emirm(r,CO2,EmiUse,aa,t) $ sum(mapiEmi(i,EmiUse), xm.l(r,i,aa,t0))
            = emirm(r,CO2,EmiUse,aa,t0)
            / sum(mapiEmi(i,EmiUse), xm.l(r,i,aa,t0));
    ) ;

* Emission to factor demand in value

    emir(r,AllEmissions,"Capital",a,t)$(sum(vOld,kv.l(r,a,vOld,t0)) and emi.l(r,AllEmissions,"Capital",a,t0))
        = emi.l(r,AllEmissions,"Capital",a,t0) / sum(vOld,kv.l(r,a,vOld,t0)) ;
    emir(r,AllEmissions,"Land",a,t)$ (land.l(r,a,t0) and emi.l(r,AllEmissions,"Land",a,t0))
        = emi.l(r,AllEmissions,"Land",a,t0) / land.l(r,a,t0) ;

***HRR: Correction so that renewables do not have any activiy emissions
$iftheni.notMCD not %GroupName%=="2024_MCD"

    emi.l(r,"co2","act","crp-a",t0)  = emi.l(r,"co2","act","crp-a",t0) + 
                                     emi.l(r,"co2","act","sol-a",t0) + emi.l(r,"co2","act","wnd-a",t0) ; 
    emi.l(r,"co2","act",solwinda,t0)  = 0 ; 
    emi.l(r,"ch4","act","crp-a",t0)  = emi.l(r,"ch4","act","crp-a",t0) + 
                                     emi.l(r,"ch4","act","sol-a",t0) + emi.l(r,"ch4","act","wnd-a",t0) ; 
    emi.l(r,"ch4","act",solwinda,t0)  = 0 ; 
$endif.notMCD 
***endHRR


* Emission to gross output in value

    emir(r,AllEmissions,emiact,a,t)$ (xp0(r,a,t) and emi.l(r,AllEmissions,emiact,a,t0))
        = emi.l(r,AllEmissions,emiact,a,t0) / xp0(r,a,t);

* [OECD-ENV]: Hypothesis same coefficient for emird and emirm --> TBU

    IF(IfArmFlag,
        emird(r,NCO2,EmiUse,aa,t)$(sum(mapiEmi(i,EmiUse),xdflag(r,i,aa)) and sum(mapiEmi(i,EmiUse),xmflag(r,i,aa)))
*            $ sum(mapiEmi(i,EmiUse),xd.l(r,i,aa,t0) + xm.l(r,i,aa,t0))
            = emi.l(r,NCO2,EmiUse,aa,t0)
            / sum(mapiEmi(i,EmiUse),xd.l(r,i,aa,t0) + xm.l(r,i,aa,t0)) ;

        emird(r,OAP,EmiUse,aa,t)$(sum(mapiEmi(i,EmiUse),xdflag(r,i,aa)) and sum(mapiEmi(i,EmiUse),xmflag(r,i,aa)))
*            $ sum(mapiEmi(i,EmiUse),xd.l(r,i,aa,t0) + xm.l(r,i,aa,t0))
            = emi.l(r,OAP,EmiUse,aa,t0)
            / sum(mapiEmi(i,EmiUse),xd.l(r,i,aa,t0) + xm.l(r,i,aa,t0)) ;

        emirm(r,NCO2,EmiUse,aa,t) = emird(r,NCO2,EmiUse,aa,t) ;
        emirm(r,OAP,EmiUse,aa,t)  = emird(r,OAP,EmiUse,aa,t)  ;
    ) ;

*) ;

*	Variant case: Read Baseline emission

$ifTheni.ifDyn NOT %simType%=="CompStat"
   $$ifTheni.ReadEmiBauValue %cal_GHG%=="LOAD"

      execute_load "%EMIBauFile%.gdx", emir, emird, emirm, emi0 ;
      execute_loadpoint "%EMIBauFile%.gdx", emi ;

      LOOP(t0,
         emi.l(r,AllEmissions,EmiSource,aa,t)
            =  emi0(r,AllEmissions,EmiSource,aa)
            * emi.l(r,AllEmissions,EmiSource,aa,t0) ;
) ;

   $$Endif.ReadEmiBauValue
$endif.ifDyn

* [2023-04-24] #Rev289 Remove Replace Emission database for old projects

*------------------------------------------------------------------------------*
*           Initializing Lulucf emissions in Baseline                          *
*------------------------------------------------------------------------------*

$$IfTheni.GhgCal %cal_GHG%=="ON"

*   Default Lulucf associate to forestry from Climate Watch (absolute level)
* Lulucf emissions, by default from UNFCCC but use CAIT if no data from UNFCCC

    $$IfThen.CW EXIST "%iDataDir%\%CWData%.gdx"
        emi.l(r,CO2,emilulucf,forestrya,t)
            $ (    Emissions_data("UNFCCC",r,CO2,emilulucf,forestrya,t)
				OR Emissions_data("CAIT",r,CO2,emilulucf,forestrya,t))
            = [  Emissions_data("UNFCCC",r,CO2,emilulucf,forestrya,t) $ Emissions_data("UNFCCC",r,CO2,emilulucf,forestrya,t)
               + Emissions_data("CAIT",r,CO2,emilulucf,forestrya,t)   $ {NOT Emissions_data("UNFCCC",r,CO2,emilulucf,forestrya,t)}
            ] * m_ConvGHG ;
    $$EndIf.CW

$Endif.GhgCal

*------------------------------------------------------------------------------*
*           		Grouping F-gas	[Option]                                   *
*------------------------------------------------------------------------------*

*   If no details on HighGWP by default group FGAS

ifGroupFGas
    $ (NOT sum((t0,em,r,EmiSource,aa) $ (HighGWP(em) and not FGAS(em)), emi.l(r,em,EmiSource,aa,t0)))
    = 1 ;

IF(ifGroupFGas,

* We group only if not exist: like when default is EDGAR

    emi.l(r,Fgas,EmiSource,aa,t) $ (NOT emi.l(r,Fgas,EmiSource,aa,t))
        = sum(em $(HighGWP(em) and not Fgas(em)), emi.l(r,em,EmiSource,aa,t)) ;
    emi.l(r,em,EmiSource,aa,t) $ (HighGWP(em) and (not Fgas(em)) ) = 0 ;
    emir(r,em,EmiSource,aa,t)  $ (HighGWP(em) and (not Fgas(em)) ) = 0 ;

ELSE

    emir(r,Fgas,EmiSource,aa,t)  = 0 ;
    emi.l(r,Fgas,EmiSource,aa,t) = 0 ;

) ;

*   Safety conditions

emi.l(r,AllEmissions,EmiSourceAct,aa,t)
    $ (emi.l(r,AllEmissions,EmiSourceAct,aa,t) lt 0) = 0;
emir(r,AllEmissions,EmiSourceAct,aa,t)
    $(emir(r,AllEmissions,EmiSourceAct,aa,t) lt 0)   = 0;

*------------------------------------------------------------------------------*
*           Initializing Other Emission related variables                      *
*------------------------------------------------------------------------------*

emiOth.l(r,AllEmissions,t)
    = sum((EmiSourceIna,aa), emi.l(r,AllEmissions,EmiSourceIna,aa,t));
emiOthGbl.l(AllEmissions,t) = 0 ;

*   OECD-ENV: Default extend values of latest year with data

$iftheni.dynamic NOT "%SimType%" == "CompStat"
   IF(IfDyn,
      LOOP(t $ m_horizonSim(t),
         emiOth.l(r,AllEmissions,t)  $ (NOT emiOth.l(r,AllEmissions,t) )
            = emiOth.l(r,AllEmissions,t-1) ;
         emiOthGbl.l(AllEmissions,t) $ (NOT emiOthGbl.l(AllEmissions,t))
            = emiOthGbl.l(AllEmissions,t-1) ;
      ) ;
   ) ;
$endif.dynamic

emiTot.l(r,AllEmissions,t)
    = emiOth.l(r,AllEmissions,t)
    + sum((EmiSourceAct,aa), emi.l(r,AllEmissions,EmiSourceAct,aa,t)) ;

emiGbl.l(AllEmissions,t)
    = emiOthGbl.l(AllEmissions,t) + sum(r, emiTot.l(r,AllEmissions,t)) ;

*	Intialize tax regime components

part(r,AllEmissions,EmiSource,aa,t) = 0 ;
IfCap(ra)                           = 0 ;
ifEmiQuota(r)                       = 0 ;
emiTax.l(r,AllEmissions,t)          = 0 ; emiTax_ref(r,AllEmissions,t) = 0 ;
emiCap.l(ra,AllEmissions,t)         = 0 ;
emiCapFull.l(ra,t)                  = 0 ;
emiQuota.fx(r,AllEmissions,t)       = 0 ;
emiQuotaY.fx(r,AllEmissions,t)      = 0 ;
emiCapQuota.l(ra,AllEmissions,t)	= 0 ;
emiCapQuotaFull.l(ra,t)				= 0 ;
emiRegTax.l(ra,AllEmissions,t)      = 0 ;
chiCap.fx(AllEmissions,t)           = 1 ;
chiCapFull.fx(t)                    = 1 ;
emFlag(r,AllEmissions)              = 0 ;

*------------------------------------------------------------------------------*
*   						OECD-ENV: add-ons								   *
*------------------------------------------------------------------------------*

emiTotNonCO2(r,t) = sum(em $ (EmSingle(em) and not CO2(em)), emiTot.l(r,em,t)) ;
emiTotAllGHG(r,t) = sum(EmSingle, emiTot.l(r,EmSingle,t)) ;

*	Calibration variables

chiTotEmi.fx(r,t)           = 0 ;
***HRR changed both AllEmissions to emSingle
chiEmi.fx(r,AllEmissions,t) = 0 ;
*- HD: fixing this creates a huge assigment; initializing with level saves almost 3GB in model size 
chiEmiDet.l(r,AllEmissions,EmiSource,aa,t) = 0 ;
***new HRR
Ifemir(r,AllEmissions,emiSource,aa) = 0 ;

*	Policy variables

FospCShadowPrice.fx(r,t)            = 0 ;
pkpShadowPrice.fx(r,a,v,t)          = 0 ;
overAcc.fx(r,a,v,t)                 = 0 ;
emiaShadowPrice.fx(r,aa,em,t) 		= 0 ;
Renew.fx(r,t)                       = 0 ;
chiVAT.fx(r,t)                      = 0 ;
chiPtax.fx(r,t)                     = 0 ;
acTax.fx(r,aa,t)                    = 0 ;

* Emission permits under ETS with no auctioning

PP_permit.fx(r,a,t) 			= 0 ;
pEmiPermit.fx(r,AllEmissions,t) = 0 ;

profitTax(r,is,t)                   = 0 ;
kv_tgt(r,a,v,t)                     = 0 ;

*	[OECD-ENV] : Activation Flags for policy

IfEmCap(ra,AllEmissions)              = 0 ;
EmiRInt(r,AllEmissions,t)             = 0 ;
EmiRCap(r,AllEmissions,tt)            = 0 ;
EmiRCap0(r,AllEmissions)              = 1 ;
IfCalEmi(r,AllEmissions,EmiSource,aa) = 0 ;
ifExtraInva(r,a)                      = 0 ;
ifExokv(r,a,v)                        = 0 ;
ifPowFeebates(r,em,EmiSourceAct)      = 0 ;
IfAllowance(r)						  = 0 ;

* Emission permits under ETS with no auctioning

PermitAllocationRule(r,AllEmissions,aa) = 0 ;
PermitAllowancea(r,AllEmissions,aa,t)	= 0 ;

* Set AdjTaxCov to 1 for multiplicative shock, and then initialize chiVAT.l = 1
* Set AdjTaxCov to 2 for additive shock, and then initialize chiVAT.l = 0

AdjTaxCov(r,is,aa) = 0;

*------------------------------------------------------------------------------*
*   Calculate the global warming potential (for CO2eq) : OPTIONAL PROCEDURE	   *
*------------------------------------------------------------------------------*

* Memo: Emi (in ton) * gwp = Emi (in CO2eq)

gwp(em) = 1 ;

* [EditJEan]: TBU with HighGWP(em):

IF(ifNCO2,
    gwp(emn) $ (NOT HighGWP(emn))
        = 1000*sum(r, sum((i,a), sum((i0,a0)$(mapi0(i0,i) and mapa0(a0,a)),nc_trad_cEQ(emn,i0,a0,r)))
        +             sum((fp,a), sum(a0$mapa0(a0,a), nc_endw_cEQ(emn,fp,a0,r)))
        +             sum(a, sum(mapa0(a0,a), nc_qo_cEQ(emn,a0,r)))
        +             sum(i, sum(mapi0(i0,i), nc_hh_cEQ(emn,i0,r))))
        / sum(r, sum((i,a), sum((i0,a0)$(mapi0(i0,i) and mapa0(a0,a)), nc_trad(emn,i0,a0,r)))
        +                   sum((fp,a),sum(a0$mapa0(a0,a), nc_endw(emn,fp,a0,r)))
        +                   sum(a, sum(mapa0(a0,a), nc_qo(emn,a0,r)))
        +                   sum(i, sum(mapi0(i0,i), nc_hh(emn,i0,r)))) ;
) ;

* [EditJEan]: Alternative computation:

*gwp(emn) $ sum((r,a0),TOTNC(NCO2,a0,r))
*    = sum((r,a0),TOTNC(NCO2,a0,r) * GWPARS(emn,r,"AR5")
*    / sum((r,a0),TOTNC(NCO2,a0,r)) ;

IF(0,
	display "%system.fn%.gms : " ;
	display nc_qo_ceq, nc_qo ;
	display gwp ;
	work = 1000 * sum(r, sum(a, sum(a0$mapa0(a0,a), nc_qo_cEQ("fgas", a0, r)))) ;
	display "nc_qo_cEQ(fgas) = ", work ;
	work = sum(r, sum(a, sum(a0$mapa0(a0,a), nc_qo("fgas", a0, r)))) ;
	display "nc_qo(fgas) = ", work ;
) ;

*------------------------------------------------------------------------------*
*         OECD-ENV: Initialize the process emissions bundles: xghg & xoap      *
*------------------------------------------------------------------------------*

*	Emissions and emission bundle prices

p_emissions(r,AllEmissions,EmiSource,aa,t) = 0;
*pxoap.l(r,a,v,t) = 0 ;
ghgFlag(r,a)     = 0 ;
OAPFlag(r,a)     = 0 ;

IF(ifEndoMAC,

    riswork(r,a) = 0 ;

    LOOP((vOld,emiact,t0),

* calibrate p_emissions to target cost of GHG = 0.01 pct of xp0

        p_emissions(r,EmSingle,emiact,a,t) = 0 ;
        riswork(r,a) = sum(EmSingle,emi.l(r,EmSingle,emiact,a,t0)) ;
        p_emissions(r,EmSingle,emiact,a,t)
            $ (emi.l(r,EmSingle,emiact,a,t0) and riswork(r,a))
            =  0.0001 * xp0(r,a,t) / riswork(r,a) ;

* activate the flag if emissions are active

        ghgFlag(r,a) $ sum(EmSingle, emi.l(r,EmSingle,emiact,a,t0)) = 1 ;
        pxghg.l(r,a,v,t) $ ghgFlag(r,a) = defaultInit ;

* no MAC not for OAP --> To be activated

        OAPFlag(r,a) $ sum(OAP, emi.l(r,OAP,emiact,a,t0))       = 0 ;
        p_emissions(r,oap,emiact,a,t) $ emi.l(r,oap,emiact,a,t) = 0 ;
        pxoap.l(r,a,v,t) $ OAPFlag(r,a)                         = 0 ;
***HRR Adj. for ROP, which has very high calibrated values
$ifi %GroupName%=="NGFS" p_emissions(r,EmSingle,emiact,a,t) $ ((ROP(r)) and (emi.l(r,EmSingle,emiact,a,t0)) and riswork(r,a)) = 0.0001;
***endHRR
    ) ;

    LOOP((t0,EmSingle),
        riswork3(r,a) = 0 ; work = 0 ;
        riswork3(r,a) = sum(emiact $ emi.l(r,EmSingle,emiact,a,t0), 1) ;
        riswork3(r,a) $ (riswork3(r,a) le 1) = 0 ;
        work = sum((r,a), riswork3(r,a));
        abort $ (work gt 0) " 2 different emiact cannot be in the emission process bundle", riswork3;
    ) ;
) ;

*   Initialize process emissions bundle: xghg, xoap

xghg.l(r,a,vOld,t) $ (ghgFlag(r,a) and pxghg.l(r,a,vOld,t))
    = sum((em,emiact) $ emi.l(r,em,emiact,a,t),
        p_emissions(r,em,emiact,a,t) * emi.l(r,em,emiact,a,t))
    / pxghg.l(r,a,vOld,t) ;

xoap.l(r,a,vOld,t) $ (OAPFlag(r,a) and pxoap.l(r,a,vOld,t))
    = sum((oap,emiact) $ emi.l(r,oap,emiact,a,t),
        p_emissions(r,oap,emiact,a,t) * emi.l(r,oap,emiact,a,t))
    / pxoap.l(r,a,vOld,t) ;

xghg.l(r,a,v,t) $ (NOT ghgFlag(r,a)) = 0;
xoap.l(r,a,v,t) $ (NOT OAPFlag(r,a)) = 0;

riswork2(r,is) = 0 ;
riswork2(r,a) $ ( ifEndoMAC and sum(t0,xp0(r,a,t0)) )
    = 100 * sum((t0,vOld), xghg.l(r,a,vOld,t0) * pxghg.l(r,a,vOld,t0))
    / sum(t0, xp0(r,a,t0)) ;


IF((ifDyn and ifCal) and IfDebug,
    Execute_unload "%cBaseFile%_%system.fn%_Emission_Variables.gdx", emiOth,
        ifGroupFGas, emiOthGbl, emiTot, emiTotNonCO2, emi, emir, emird, emirm,
        EmiSourceIna, EmiSourceAct ;
    IF(ifEndoMAC,
        Execute_unload "%cBaseFile%_%system.fn%_Emission_Process.gdx",
		xghg, xp0, p_emissions, pxghg, riswork=TotSectGHG, xoap,
		riswork2=XghgShrtoXp ;
    ) ;
) ;

* [OECD-ENV]: add sectorial emissions: "emia.l" a working/policy variable

emia.l(r,a,AllEmissions,t)
    = sum(EmiSourceAct $ emir(r,AllEmissions,EmiSourceAct,a,t),
            emi.l(r,AllEmissions,EmiSourceAct,a,t) ) ;

sigmaxp(r,a,v)  $ (NOT ghgFlag(r,a)) = 0 ;
sigmaemi(r,a,v) $ (sum((em,emiact,t0) $ emi.l(r,em,emiact,a,t0), 1) le 1) = 0 ;

*------------------------------------------------------------------------------*
*                                                                              *
*                   Initialize the xpv bundle					               *
*                                                                              *
*------------------------------------------------------------------------------*

* uc = Unit marginal cost of production

uctax.l(r,a,v,t) = 0 ;
pim.l(r,a,t)     = 0 ;

xpv.l(r,a,vOld,t) $ uc.l(r,a,vOld,t)
    = [     pxp.l(r,a,vOld,t) * xpx.l(r,a,vOld,t)
        + pxghg.l(r,a,vOld,t) * xghg.l(r,a,vOld,t)
        + pxoap.l(r,a,vOld,t) * xoap.l(r,a,vOld,t)]
    / uc.l(r,a,vOld,t);

pxv.l(r,a,v,t) $ uc.l(r,a,v,t) = uc.l(r,a,v,t) * (1 + uctax.l(r,a,v,t)) ;

*  Calculate cost of production pre-tax in value terms

xp.l(r,a,t) = sum(vOld, pxv.l(r,a,vOld,t) * xpv.l(r,a,vOld,t)) ;

* OECD-ENV: safety condition

xpv.l(r,a,vOld,t) $ (sum(t0,xp.l(r,a,t0)) eq 0) = 0;

*  Calculate prodution tax
*---    Calculate prodution tax (vom = gross output tax included)
* osep(a,r) = - [vom(a,r) - voa(a,r)];
*   with voa = vdfa(i,a,r)  + vifa(i,a,r) + sum(fp,evfa(fp,a,r))

ptax.l(r,a,t) $ xp.l(r,a,t) = (inscale * vom(a,r)) - xp.l(r,a,t) ;
ptax.l(r,a,t) $ xp.l(r,a,t) = ptax.l(r,a,t) / xp.l(r,a,t) ;

* OECD-ENV: simplification

ptax.l(r,a,t) $ (abs(ptax.l(r,a,t)) lt 0.00001) = 0;

px.l(r,a,t) = sum(vOld,pxv.l(r,a,vOld,t));
xp.l(r,a,t) $ px.l(r,a,t) = xp.l(r,a,t) / px.l(r,a,t);
pp.l(r,a,t) = px.l(r,a,t) * (1 + ptax.l(r,a,t)) ;

*------------------------------------------------------------------------------*
*                                                                              *
*		Initialize the technology/efficiency parameters 		               *
*                                                                              *
*------------------------------------------------------------------------------*

chiglab.fx(r,l,t)        = 0 ;

* [OECD-ENV]: Make sum of CES coefficient equals to 1 for IfCoeffCes = 1

lambdaxp.l(r,a,v,t)   $ (not tota(a)) = pxp.l(r,a,v,t)   * m_CESadj ;
lambdaghg.l(r,a,v,t)  $ (not tota(a)) = pxghg.l(r,a,v,t) * m_CESadj ;
lambdaoap.l(r,a,v,t)  $ (not tota(a)) = pxoap.l(r,a,v,t) * m_CESadj ;
lambdanrf.l(r,a,v,t)  $ (not tota(a)) = pnrfp.l(r,a,t)   * m_CESadj ;
lambdah2o.l(r,a,t)    $ (not tota(a)) = ph2op.l(r,a,t)   * m_CESadj ;
lambdak.l(r,a,v,t)    $ (not tota(a)) = pkp.l(r,a,v,t)   * m_CESadj ;
lambdal.l(r,l,a,t)    $ (not tota(a)) = wagep.l(r,l,a,t) * m_CESadj ;
***HRRlambdat.l(r,a,v,t)    $ (not tota(a)) = plandp.l(r,a,t)  * m_CESadj ;
lambdat.l(r,a,v,t)    $ (not tota(a)) = 1 ; 
***endHRR
lambdaio.l(r,i,a,t)   $ (not e(i) and not tota(a)) = pa.l(r,i,a,t) * m_CESadj;
lambdae.l(r,e,a,v,t)  $ (not tota(a)) = pa.l(r,e,a,t) * m_CESadj;
lambdace.l(r,e,k,h,t) $ cmat(e,k,r) = pa.l(r,e,h,t) * m_CESadj;
lambdah2obnd.l(r,wbnd,t) = 1 ;

* [OECD-ENV]: add efficiency for endogenous MAC-curves

LOOP((t0,emiact),
    lambdaemi(r,AllEmissions,a,v,t) $ p_emissions(r,AllEmissions,emiact,a,t)
        =  p_emissions(r,AllEmissions,emiact,a,t) * m_CESadj;
) ;

* [EditJean]: rather useless since pdt.l and pmt.l are eq to 1

lambdaxd(r,i,t) = pdt.l(r,i,t) * m_CESadj;
lambdaxm(r,i,t) = pmt.l(r,i,t) * m_CESadj;

* OECD-ENV: Add lambdaxd, lambdaxm lambdafd, TFP_xpv, TFP_fp, TFP_xxpx, TFP_xs

TFP_xpv.l(r,a,v,t) $ pxv.l(r,a,v,t)  = 1 ;
TFP_fp.l(r,a,t)    $ px.l(r,a,t)     = 1 ;
TFP_xpx.l(r,a,v,t) $ pxp.l(r,a,v,t)  = 1 ;
TFP_xs.l(r,i,t)    $ ps.l(r,i,t)     = 1 ;
lambdafd.l(r,i,fdc,t) $ xa.l(r,i,fdc,t) = pa.l(r,i,fdc,t) * m_CESadj;

*------------------------------------------------------------------------------*
*                    Initialize the 'make/use' module                          *
*------------------------------------------------------------------------------*

*  !!!! Need to insure that when running the model with perfect transformation and perfect
*       substitution that the prices align (one way is to have fixed price adjusters)
p.l(r,a,i,t) $ (not tota(a)) = ps.l(r,i,t) ;
x.l(r,a,i,t) $ p.l(r,a,i,t) = inscale * tmat(a,i,r) / p.l(r,a,i,t) ;
xs.l(r,i,t)  $ ps.l(r,i,t) = sum(a, p.l(r,a,i,t) * x.l(r,a,i,t)) / ps.l(r,i,t) ;

*------------------------------------------------------------------------------*
*                   Initialize production flags                                *
*------------------------------------------------------------------------------*

* [OECD-ENV]: move some flags where the corresponding variable is defined: xaFlag

loop((t, vOld)$(ord(t) eq 1),

    xpFlag(r,a)   $ xp.l(r,a,t)         = 1 ;
    ghgFlag(r,a)  $ xghg.l(r,a,vOld,t)  = 1 ;
    xsFlag(r,i)   $ xs.l(r,i,t)         = 1 ;

    va1Flag(r,a)  $ va1.l(r,a,vOld,t)   = 1 ;
    va2Flag(r,a)  $ va2.l(r,a,vOld,t)   = 1 ;
    kefFlag(r,a)  $ kef.l(r,a,vOld,t)   = 1 ;
    kfFlag(r,a)   $ kf.l(r,a,vOld,t)    = 1 ;

) ;

*------------------------------------------------------------------------------*
*                                                                              *
*       Initialize household demand module                                     *
*                                                                              *
*------------------------------------------------------------------------------*

*   Top level demand

cmat(i,k,r)   = inscale * cmat(i,k,r) ;
pc.l(r,k,h,t) $  sum(i, cmat(i,k,r))  = 1 ;
xc.l(r,k,h,t) $ pc.l(r,k,h,t)  = sum(i, cmat(i,k,r)) / pc.l(r,k,h,t) ;
hshr.l(r,k,h,t) = pc.l(r,k,h,t) * xc.l(r,k,h,t) / yfd.l(r,h,t) ;

xcFlag(r,k,h) $ sum(t0,xc.l(r,k,h,t0)) = 1 ;
u.l(r,h,t) = 1;

*  Initialize income elasticity for ELES calibration
*  !!!! TAKEN FROM CDE FUNCTION
loop((h,t0),
    incElas(k,r)
        = ((eh0(k,r)*bh0(k,r)
        - sum(kp$xcFlag(r,kp,h), hshr.l(r,kp,h,t0)*eh0(kp,r)*bh0(kp,r)))
        / sum(kp$xcFlag(r,kp,h), hshr.l(r,kp,h,t0)*eh0(kp,r)) - (bh0(k,r)-1)
        + sum(kp$xcFlag(r,kp,h), hshr.l(r,kp,h,t0)*bh0(kp,r))) ;
) ;

kron(k,k) = 1 ;

*   Non-energy demand   : OECD-ENV add conditions

pcnnrg.l(r,k,h,t) $ sum(i$(not e(i)), cmat(i,k,r)) = 1 ;
xcnnrg.l(r,k,h,t) $ pcnnrg.l(r,k,h,t)
    = sum(i $ (not e(i)), cmat(i,k,r)) / pcnnrg.l(r,k,h,t) ;

pcnrg.l(r,k,h,t) $ sum(e, cmat(e,k,r)) = 1 ;
xcnrg.l(r,k,h,t) $ pcnrg.l(r,k,h,t) = sum(e, cmat(e,k,r)) / pcnrg.l(r,k,h,t) ;

*   Energy demand bundles : OECD-ENV remove hard-coded

LOOP((r,h) $ IfNrgNest(r,h),
    pacNRG.l(r,k,h,NRG,t) = 1 ;
    xacNRG.l(r,k,h,NRG,t)
		= sum(mape(NRG,e), cmat(e,k,r)) / pacNRG.l(r,k,h,NRG,t) ;
    pcolg.l(r,k,h,t) = 1 ;
    xcolg.l(r,k,h,t) $ pcolg.l(r,k,h,t)
        = [ sum(GAS,pacNRG.l(r,k,h,GAS,t)*xacNRG.l(r,k,h,GAS,t))
           +sum(OIL,pacNRG.l(r,k,h,OIL,t)*xacNRG.l(r,k,h,OIL,t))]
        / pcolg.l(r,k,h,t) ;
    pcnely.l(r,k,h,t) = 1 ;
    xcnely.l(r,k,h,t) $ pcnely.l(r,k,h,t)
        = [ sum(COA,pacNRG.l(r,k,h,COA,t)*xacNRG.l(r,k,h,COA,t))
           + pcolg.l(r,k,h,t)*xcolg.l(r,k,h,t) ]
		/ pcnely.l(r,k,h,t) ;
);

*   Flags

loop(t0,
    xcnnrgFlag(r,k,h)     $ xcnnrg.l(r,k,h,t0)     = 1 ;
    xcnrgFlag(r,k,h)      $ xcnrg.l(r,k,h,t0)      = 1 ;
    xcnelyFlag(r,k,h)     $ xcnely.l(r,k,h,t0)     = 1 ;
    xcolgFlag(r,k,h)      $ xcolg.l(r,k,h,t0)      = 1 ;
    xacNRGFlag(r,k,h,NRG) $ xacNRG.l(r,k,h,NRG,t0) = 1 ;
) ;

*------------------------------------------------------------------------------*
*                                                                              *
*           	Initialize bilateral trade                                     *
*                                                                              *
*------------------------------------------------------------------------------*

*  Set producer price of exports to aggregate producer price

xw.l(r,i,rp,t) $ pe.l(r,i,rp,t)
    = inscale * sum(mapi0(i0,i),vxmd(i0, r, rp)) / pe.l(r,i,rp,t) ;

* Flags

LOOP(t0, xwFlag(r,i,rp) $ xw.l(r,i,rp,t0) = 1 ; ) ;

etax.l(r,i,rp,t) $ xwFlag(r,i,rp)
    = inscale * [  sum(i0$mapi0(i0,i),vxwd(i0, r, rp))
                 - sum(i0$mapi0(i0,i),vxmd(i0, r, rp))] ;
etax.l(r,i,rp,t) $ xwFlag(r,i,rp)
    = etax.l(r,i,rp,t) / (pe.l(r,i,rp,t)*xw.l(r,i,rp,t)) ;

* [EditJean]: add
LOOP(t0, etax0(r,i,rp) = etax.l(r,i,rp,t0) ; ) ;

*  FOB price equals producer price plus export tax/subsidy

pwe.l(r,i,rp,t) = (1 + etax.l(r,i,rp,t)) * pe.l(r,i,rp,t) ;

*  CIF/FOB margins

tmarg.l(r,i,rp,t) $ xwFlag(r,i,rp)
    = inscale * [ sum(i0$mapi0(i0,i),viws(i0, r, rp))
                - sum(i0$mapi0(i0,i),vxwd(i0, r, rp))] ;
tmarg.l(r,i,rp,t) $ xwFlag(r,i,rp)
    = tmarg.l(r,i,rp,t) / (pwmg.l(r,i,rp,t)*xw.l(r,i,rp,t)) ;

*  CIF price equals FOB price plus margin

pwm.l(r,i,rp,t) $ xwFlag(r,i,rp)
    = pwe.l(r,i,rp,t) + pwmg.l(r,i,rp,t)*tmarg.l(r,i,rp,t) ;

*  Import tariff

mtax.l(r,i,rp,t) $ xwFlag(r,i,rp)
    = inscale*(sum(i0$mapi0(i0,i),vims(i0, r, rp))
             - sum(i0$mapi0(i0,i),viws(i0, r, rp))) ;
mtax.l(r,i,rp,t) $ xwFlag(r,i,rp)
    = mtax.l(r,i,rp,t) / (pwm.l(r,i,rp,t)*xw.l(r,i,rp,t)) ;

*  End-user price of imports

pdm.l(r,i,rp,t) = (1 + mtax.l(r,i,rp,t))*pwm.l(r,i,rp,t) ;

* [EditJean]: add
pwm.l(r,i,rp,t) $ (pwm.l(r,i,rp,t) lt 0.000001) = 0;
LOOP(t0, mtax0(r,i,rp) = mtax.l(r,i,rp,t0) ; ) ;
pdm.l(r,i,rp,t) $ (pdm.l(r,i,rp,t) lt 0.000001) = 0 ;

*------------------------------------------------------------------------------*
*  Initialize domestic supply of international trade and transport services
*------------------------------------------------------------------------------*

xtt.l(r,i,t) $ pdt.l(r,i,t)
    = inscale * sum(mapi0(i0,i), vst(i0,r)) / pdt.l(r,i,t) ;

*------------------------------------------------------------------------------*
*                                                                              *
*  				Initialize domestic closure                                    *
*                                                                              *
*------------------------------------------------------------------------------*

deprY.l(r,t)      = inscale * vdep(r) ;
remit.l(r,l,rp,t) = inscale * remit00(l,r,rp) ;
yqtf.l(r,t)       = inscale * yqtf0(r) ;
yqht.l(r,t)       = inscale * yqht0(r) ;
trustY.l(t)       = sum(r, yqtf.l(r,t)) ;

pnum.l(t)  = 1 ;
pwsav.l(t) = pnum.l(t) ;
pmuv.l(t)  = pnum.l(t) ;
pwgdp.l(t) = pnum.l(t) ;

savf.l(r,t)  = 	[sum((i,rp), pwm.l(rp,i,r,t) * xw.l(rp,i,r,t))
                 -  sum((i,rp), pwe.l(r,i,rp,t) * xw.l(r,i,rp,t))
                 -  sum(img, pdt.l(r,img,t)*xtt.l(r,img,t))
                 -  sum((l,rp), remit.l(r,l,rp,t) - remit.l(rp,l,r,t))
                 -  (yqht.l(r,t) - yqtf.l(r,t))
				] / pwsav.l(t) ;

pgdpmp.l(r,t) = 1 ;

gdpmp.l(r,t) = sum(fd, yfd.l(r,fd,t))
             + sum((i,rp), pwe.l(r,i,rp,t) * xw.l(r,i,rp,t))
             - sum((i,rp), pwm.l(rp,i,r,t) * xw.l(rp,i,r,t))
             + sum(img, pdt.l(r,img,t)*xtt.l(r,img,t)) ;

$if %ifWEOsavcal%=="OFF"    savg.l(r,t) = 0 ;

* Calibrate "savg" using historical data

$IFi %SimType%=="baseline" $IFi %DynCalMethod%=="OECD-ENV" savg.l(r,t) = MacroTarget("rsg",r,t) * inscale ;

IF(ifDyn and NOT IfCal, execute_loaddc "%BauFile%.gdx", savg.l ; ) ;

rsg.l(r,t)  = savg.l(r,t) / pgdpmp.l(r,t) ;

*  Override of capital stock data and depreciation rates

loop((r,t0),
    IF(cap_out_Ratio0(r),
        kstock.l(r,t) = cap_out_Ratio0(r) * gdpmp.l(r,t0) ;
    else
        kstock.l(r,t) = inscale * vkb(r) ;
    ) ;
) ;

* memo: deprT(r,t) = 0.04 is GTAP value

* [2022-12-07]: actually there is a problem with ELES if initially savh<0
* to guarantee positive savings for ELES --> depr(r,t) = 0;
deprT(r,t) = 0;

depr(r,t)
    = deprT(r,t) $ {deprT(r,t) ne 0}
    + {deprY.l(r,t) / sum(inv, pfd.l(r,inv,t) * kstock.l(r,t))} $ {deprT(r,t) eq 0}
    ;

*  !!!! Would not put these types of assumptions embedded in standard code--should be part of an input File
$iftheni.dynamic NOT "%SimType%" == "CompStat"
   depr(r,"2018") = 0.04 ;
   m_InterpLinear(depr,'r',t,%YearStart%,2018)
   depr(r,t) $ after(t,"2018") = depr(r,"2018");
$endif.dynamic

fdepr(r,t)   = depr(r,t) ;
deprY.l(r,t) = sum(inv, fdepr(r,t) * pfd.l(r,inv,t) * kstock.l(r,t)) ;

loop(h,
    savh.l(r,h,t)
        = sum(inv,yfd.l(r,inv,t))
        - deprY.l(r,t) - pwsav.l(t) * savf.l(r,t) - savg.l(r,t) ;
);

*   Check saving

IF(1,
    LOOP((h,t0),
        rwork(r) = outscale * savh.l(r,h,t0) ; Display "Savh:", rwork ;
        rwork(r) = outscale * savf.l(r,t0)   ; Display "Savf:", rwork ;
        rwork(r) = depr(r,t0)                ; Display "depr:", rwork ;
    ) ;
) ;

*------------------------------------------------------------------------------*
*																			   *
*  					Initialize income variables							       *
*																			   *
*------------------------------------------------------------------------------*

*  Factor income taxes

kappal.fx(r,l,t) $ evoa(l,r)
    = 1 - inscale * evoa(l,r) / sum(a,wage.l(r,l,a,t)*ld.l(r,l,a,t)) ;

loop(cap,
   kappak.fx(r,t) $ evoa(cap,r)
    = (sum((a,v), [pk.l(r,a,v,t)+overAcc.l(r,a,v,t)] * kv.l(r,a,v,t)) - inscale*evoa(cap,r))
    / (sum((a,v), [pk.l(r,a,v,t)+overAcc.l(r,a,v,t)] * kv.l(r,a,v,t)) - deprY.l(r,t)) ;
) ;

loop(lnd,
    kappat.fx(r,t) $ evoa(lnd,r)
        = 1 - inscale * evoa(lnd,r) / sum(a, pland.l(r,a,t)*land.l(r,a,t)) ;
) ;
loop(nrs,
    kappan.fx(r,t) $ evoa(nrs,r)
        = 1 - inscale * evoa(nrs,r) / sum(a, pnrf.l(r,a,t)*xnrf.l(r,a,t)) ;
) ;
loop(wat,
    kappaw.fx(r,t) $ evoa(wat,r)
        = 1 - inscale * evoa(wat,r) /sum(a, ph2o.l(r,a,t)*h2o.l(r,a,t)) ;
) ;

*   Household income

yh.l(r,t)
    = sum((l,a), (1-kappal.l(r,l,t)) * wage.l(r,l,a,t)*ld.l(r,l,a,t))
    +  (1 - kappak.l(r,t))
        * [  sum((a,v), pk.l(r,a,v,t)*kv.l(r,a,v,t))
           + sum(a, pim.l(r,a,t) * xp.l(r,a,t)) - deprY.l(r,t)]
    +  (1 - kappat.l(r,t))*sum(a$landFlag(r,a), pland.l(r,a,t)*land.l(r,a,t))
    +  (1 - kappan.l(r,t))*sum(a$nrfFlag(r,a), pnrf.l(r,a,t)*xnrf.l(r,a,t))
    +  (1 - kappaw.l(r,t))*sum(a$xwatfFlag(r,a), ph2o.l(r,a,t)*h2o.l(r,a,t))
    +  sum((l,rp), remit.l(r,l,rp,t) - remit.l(rp,l,r,t))
    + yqht.l(r,t) - yqtf.l(r,t)  ;

trg.l(r,t)    = 0;
chiaps.l(r,t) = 1 ;

* #todo kappah.l(r,t) should be function of h
loop(h,

    kappah.l(r,t) = (yh.l(r,t) - savh.l(r,h,t) - yfd.l(r,h,t)) / yh.l(r,t) ;

    yd.l(r,t) = [1 - kappah.l(r,t)] * yh.l(r,t) + trg.l(r,t);

    aps.l(r,h,t)  = savh.l(r,h,t) / (chiaps.l(r,t) * yd.l(r,t)) ;

*    aps.l(r,h,t) $ yh.l(r,t) = savh.l(r,h,t) / yh.l(r,t); !! ENV-L --> wrong?

) ;

*   Government revenues

$OnDotl

*- HD: add missing flags 

ygov.l(r,gy,t)
    = {sum(a$xpFlag(r,a), ptax.l(r,a,t)*(px.l(r,a,t) + pim.l(r,a,t))*xp.l(r,a,t)
    +   sum(v, uc.l(r,a,v,t)*uctax.l(r,a,v,t)*xpv.l(r,a,v,t)))} $ ptx(gy)

* Factor use tax (including social security contributions)

   +  {  sum((a,l)     $ labFlag(r,l,a), Taxfp.l(r,a,l,t) * wage.l(r,l,a,t) * ld.l(r,l,a,t) )
       + sum((a,v,cap) $ kFlag(r,a)    , adjKTaxfp(r,cap,a,v) * Taxfp.l(r,a,cap,t) * pk.l(r,a,v,t) * kv.l(r,a,v,t) )
       + sum((a,lnd)   $ landFlag(r,a) , Taxfp.l(r,a,lnd,t) * pland.l(r,a,t) * land.l(r,a,t) )
       + sum((a,nrs)   $ nrfFlag(r,a)  , Taxfp.l(r,a,nrs,t) * pnrf.l(r,a,t) * xnrf.l(r,a,t) )
       + sum((a,wat)   $ xwatfFlag(r,a), Taxfp.l(r,a,wat,t) * ph2o.l(r,a,t) * h2o.l(r,a,t)  )
      } $ vtx(gy)

* Factor use Support (Subfp is positive so put minus above expression below)

   -  {  sum((a,l)     $ labFlag(r,l,a), Subfp.l(r,a,l,t) * wage.l(r,l,a,t) * ld.l(r,l,a,t) )
       + sum((a,v,cap) $ kFlag(r,a)    , adjKSubfp(r,cap,a,v) * Subfp.l(r,a,cap,t) * pk.l(r,a,v,t) * kv.l(r,a,v,t) )
       + sum((a,lnd)   $ landFlag(r,a) , Subfp.l(r,a,lnd,t) * pland.l(r,a,t) * land.l(r,a,t) )
       + sum((a,nrs)   $ nrfFlag(r,a)  , Subfp.l(r,a,nrs,t) * pnrf.l(r,a,t) * xnrf.l(r,a,t)  )
       + sum((a,wat)   $ xwatfFlag(r,a), Subfp.l(r,a,wat,t) * ph2o.l(r,a,t) * h2o.l(r,a,t)   )
      } $ {vsub(gy) AND NOT IfMergeTaxAndSubfp}

    +  (sum((i,aa)$xaFlag(r,i,aa),
       paTax.l(r,i,aa,t)*gammaeda(r,i,aa)*pat.l(r,i,t)*xa.l(r,i,aa,t))) $ itx(gy)

    +  (sum((i,rp)$xwFlag(rp,i,r),
             mtax.l(rp,i,r,t)*pwm.l(rp,i,r,t)*xw.l(rp,i,r,t)))$mtx(gy)
    +  (sum((i,rp)$xwFlag(r,i,rp),
             etax.l(r,i,rp,t)*pe.l(r,i,rp,t)*xw.l(r,i,rp,t)))$etx(gy)

*- HD: nested sum costs more 
    +  {sum((a,l)$labFlag(r,l,a), kappal.l(r,l,t)*wage.l(r,l,a,t)*ld.l(r,l,a,t))
    +   kappak.l(r,t)*(sum((a,v)$kFlag(r,a), pk.l(r,a,v,t)*kv.l(r,a,v,t))
    +                sum(a$kFlag(r,a), pim.l(r,a,t)*xp.l(r,a,t)) - deprY.l(r,t))
    +   kappat.l(r,t)*sum(a$landFlag(r,a), pland.l(r,a,t)*land.l(r,a,t))
    +   kappan.l(r,t)*sum(a$nrfFlag(r,a),   pnrf.l(r,a,t)*xnrf.l(r,a,t))
    +   kappaw.l(r,t)*sum(a$xwatfFlag(r,a), ph2o.l(r,a,t)*h2o.l(r,a,t))
    +   kappah.l(r,t) * yh.l(r,t) - trg.l(r,t) }$dtx(gy)

    + {  sum((i,aa)$xaFlag(r,i,aa),  m_Permis(r,i,aa,t)  * xa.l(r,i,aa,t)) $ {NOT IfArmFlag}
        + sum((i,aa)$xdFlag(r,i,aa), m_Permisd(r,i,aa,t) * xd.l(r,i,aa,t)) $ {IfArmFlag}
        + sum((i,aa)$xmFlag(r,i,aa), m_Permism(r,i,aa,t) * xm.l(r,i,aa,t)) $ {IfArmFlag}

		+ sum(a $ xpFlag(r,a),
			  sum((cap,v) $ kFlag(r,a), m_Permisfp(r,cap,a,t) * kv.l(r,a,v,t) )
			+ sum(lnd $ landFlag(r,a),  m_Permisfp(r,lnd,a,t) * land.l(r,a,t))
			+ {m_Permisact(r,a,t) * m_true2t(xp,r,a,t)}  $ { NOT ghgFlag(r,a) }
			+ { sum((emiact,em),
				m_EmiPrice(r,em,emiact,a,t) * emi.l(r,em,emiact,a,t) )
			  } $ { ghgFlag(r,a) }
		  )
	  } $ ctx(gy)
    ;
$OffDotl

***HRR: adj. for RUS not to have negative paTax initial values that makes ygov(itax) explode
*** same for TUR(ptax)
*** We use baseline values when no WEO (rsg>0) calibration
$iftheni.ngfsTax %GroupName%=="NGFS"
    ygov.l(r,"itax",t) $ RUS(r) = 0.0015 ;
    ygov.l(r,"ptax",t) $ TUR(r) = 0.0037 ;
$endif.ngfsTax
$iftheni.MCD %GroupName%=="2024_MCD"
    ygov.l(r,"dtax",t) $ KAZ(r) = 0.015 ;
$endif.MCD

***endHRR

IF(IfDebug and IfCal and IfDyn,
    LOOP(t0,
        rwork(r) = [  savg.l(r,t0) + sum(gov, yfd.l(r,gov,t0))
                    - sum(gy, ygov.l(r,gy,t0))  ] * outscale ;
    ) ;
    Execute_unload "%cBaseFile%_%system.fn%_Gov_BudgetConstraint.gdx",
		rwork=GovBC ;
);

*------------------------------------------------------------------------------*
*																			   *
*  					Initialize trade block								       *
*																			   *
*------------------------------------------------------------------------------*

*  Top level Armington

xat.l(r,i,t) = sum(aa, gammaeda(r,i,aa)*xa.l(r,i,aa,t)) ;
xet.l(r,i,t) $ pet.l(r,i,t)
    = sum(rp, pe.l(r,i,rp,t)*xw.l(r,i,rp,t)) / pet.l(r,i,t) ;
xdt.l(r,i,t) $ pdt.l(r,i,t)
    = [ps.l(r,i,t) * xs.l(r,i,t) - pet.l(r,i,t) * xet.l(r,i,t)] / pdt.l(r,i,t) ;
xdt.l(r,i,t) $ (xdt.l(r,i,t) lt 0) = 0 ;
xmt.l(r,i,t) = sum(rp, pdm.l(rp,i,r,t) * xw.l(rp,i,r,t)) / pmt.l(r,i,t) ;

*	Flags

loop(t0,
   xatFlag(r,i)$xat.l(r,i,t0) = 1 ;
   xddFlag(r,i)$((xdt.l(r,i,t0) - xtt.l(r,i,t0)) gt 0) = 1 ;
   xmtFlag(r,i) $   xmt.l(r,i,t0) = 1 ;
   xdtFlag(r,i) $   xdt.l(r,i,t0) = 1 ;
   xetFlag(r,i) $   xet.l(r,i,t0) = 1 ;

) ;

*------------------------------------------------------------------------------*
*																			   *
*  					Initialize trade margins block						       *
*																			   *
*------------------------------------------------------------------------------*

alias(i0,j0) ;

xtmg.l(img,t) = sum(r, pdt.l(r,img,t)*xtt.l(r,img,t)) / ptmg.l(img,t) ;
xmgm.l(img,r,i,rp,t)
    = inscale * sum((j0,i0)$(mapi0(j0,img) and mapi0(i0,i)), VTWR(j0,i0,r,rp))
    / ptmg.l(img,t) ;

* Demand of transportation service for shipping i from r to rp
xwmg.l(r,i,rp,t) $ xwFlag(r,i,rp) = tmarg.l(r,i,rp,t) * xw.l(r,i,rp,t) ;

lambdamg(img,r,i,rp,t) $ xmgm.l(img,r,i,rp,t) = 1;

* Flags

loop(t0,
   xttFlag(r,img) $xtt.l(r,img,t0)   = 1 ;
   tmgFlag(r,i,rp)$xwmg.l(r,i,rp,t0) = 1 ;
) ;

*------------------------------------------------------------------------------*
*                                                                              *
*  				Initialize factor supply block								   *
*                                                                              *
*------------------------------------------------------------------------------*

lsFlag(r,l,z)$(lsFlag(r,l,z) and sum((a,t0)$mapz(z,a), ld.l(r,l,a,t0)) = 0) = no ;
ueFlag(r,l,z)$(ueFlag(r,l,z) and not lsFlag(r,l,z)) = no ;
awagez.l(r,l,z,t) = sum(a$mapz(z,a), ld.l(r,l,a,t)) ;
awagez.l(r,l,z,t) $ awagez.l(r,l,z,t)
    = sum(a$mapz(z,a), wage.l(r,l,a,t)*ld.l(r,l,a,t))
    / awagez.l(r,l,z,t) ;
twage.l(r,l,t) = sum(a, wage.l(r,l,a,t)*ld.l(r,l,a,t))/sum(a, ld.l(r,l,a,t)) ;

uez.l(r,l,z,t)$ueFlag(r,l,z) = uez0(r,l,z) ;
urbPrem.l(r,l,t) = sum(rur, (1-uez.l(r,l,rur,t))*awagez.l(r,l,rur,t)) ;
urbPrem.l(r,l,t) $ urbPrem.l(r,l,t)
    = sum(urb, (1-uez.l(r,l,urb,t))*awagez.l(r,l,urb,t))
    / urbPrem.l(r,l,t) ;

ldz.l(r,l,z,t)$lsFlag(r,l,z) = sum(a$mapz(z,a), ld.l(r,l,a,t)) ;
lsz.l(r,l,z,t)$lsFlag(r,l,z) = ldz.l(r,l,z,t)/(1 - uez.l(r,l,z,t)) ;
ls.l(r,l,t)    = sum(z$lsFlag(r,l,z), lsz.l(r,l,z,t)) ;
tls.l(r,t)     = sum(l, ls.l(r,l,t)) ;
loop(t0, tlabFlag(r,l)$ls.l(r,l,t0) = 1 ;) ;

migrFlag(r,l) = no ;
loop(t0,
   migrFlag(r,l)$(omegam(r,l) ne inf) = yes ;
) ;

loop(rur,
   migr.l(r,l,t) $ migrFlag(r,l) = migr0(r,l) * lsz.l(r,l,rur,t) ;
) ;
migrmult.l(r,l,z,t) = 1 ;

*  Check migration assumptions

work = 0 ;
loop((r,l)$(omegam(r,l) ne inf),
   IF(ifLSeg(r,l) eq 0,
      IF(work eq 0,
         put screen ;
         put / ;
         put 'Invalid assumption(s) for labor market segmentation: ' / ;
         work = 1 ;
      ) ;
      put '   ', r.tl:<12, 'omegam = ', omegam(r,l):10:2, ' but no labor market segmentation.' / ;
   ) ;
) ;
IF(work, Abort$(1) "Check labor market assumptions" ; ) ;

ewagez.l(r,l,z,t)$lsFlag(r,l,z) = awagez.l(r,l,z,t) ;

loop(mapz(z,a),
   wPrem.l(r,l,a,t)$lsFlag(r,l,z) = wage.l(r,l,a,t)/ewagez.l(r,l,z,t) ;
) ;

resWage.l(r,l,z,t) = 0.001 ;
resWage.l(r,l,z,t)$ueFlag(r,l,z) = resWage0(r,l,z)*ewagez.l(r,l,z,t) ;
loop(t0,
   chirw.fx(r,l,z,t)$ueFlag(r,l,z) = resWage.l(r,l,z,t0)
                                   *  ((1+0)**omegarwg(r,l,z))
                                   *  ((1)**omegarwue(r,l,z))
                                   *  (1**omegarwp(r,l,z))
                                   ;
) ;

ueMinz(r,l,z,t) $ ueFlag(r,l,z) = ueMinz0(r,l,z)  ;
uez.lo(r,l,z,t) $ ueFlag(r,l,z) = ueMinz(r,l,z,t) ;

glab.l(r,l,t)    = 0.0 ;
glabz.l(r,l,z,t) = 0.0 ;

skillprem.l(r,l,t) $ ls.l(r,l,t)
    = sum(lr, twage.l(r,lr,t) * ls.l(r,lr,t)) / sum(lr, ls.l(r,lr,t))
    / twage.l(r,l,t) - 1 ;

tkaps.l(r,t) = sum((a,v), pk.l(r,a,v,t)*kv.l(r,a,v,t)) / trent.l(r,t) ;

loop(t0,
   chiKaps0(r)  = tkaps.l(r,t0) / kstock.l(r,t0) ;
) ;

k0.l(r,a,t)     = sum(v, kv.l(r,a,v,t)) ;
rrat.l(r,a,t)   = 1 ;
loop(vOld,
   kxRat.l(r,a,v,t) $ xpFlag(r,a) = kv.l(r,a,vOld,t) / xpv.l(r,a,vOld,t) ;
) ;
invGFact.l(r,t) = 20 ;

*------------------------------------------------------------------------------*
*				Land supply module											   *
*------------------------------------------------------------------------------*

*  !!!! NEEDS to be reviewed if we have the right price/volume split
*       NEED to add wedges if we allow for infinite transformation

tland.l(r,t) = sum(a, pland.l(r,a,t) * land.l(r,a,t)) / ptland.l(r,t) ;
tlandFlag(r) $ sum(t0,tland.l(r,t0)) = 1 ;

xlb.l(r,lb,t) = sum(maplb(lb,a), land.l(r,a,t)) ;
plb.l(r,lb,t) $ xlb.l(r,lb,t)
	= sum(maplb(lb,a), pland.l(r,a,t) * land.l(r,a,t)) / xlb.l(r,lb,t) ;
plbndx.l(r,lb,t) = plb.l(r,lb,t) ;

xnlb.l(r,t) = sum(lb $ (not lb1(lb)), xlb.l(r,lb,t)) ;
pnlb.l(r,t) $ xnlb.l(r,t)
	= sum(lb $ (not lb1(lb)), plb.l(r,lb,t) * xlb.l(r,lb,t)) / xnlb.l(r,t) ;
pnlb.l(r,t) $ (NOT xnlb.l(r,t)) = 1 ;
pnlbndx.l(r,t) = pnlb.l(r,t) ;

tland.l(r,t) = sum(lb1, xlb.l(r,lb1,t)) + xnlb.l(r,t) ;
ptland.l(r,t) $ tland.l(r,t)
	= (sum(lb1, plb.l(r,lb1,t) * xlb.l(r,lb1,t)) + pnlb.l(r,t) * xnlb.l(r,t))
	/ tland.l(r,t) ;
ptlandndx.l(r,t) = ptland.l(r,t) ;

* [EditJean]: 2024-02-07 LandMax0(r) here is useless, only need LandMax00(r)

LandMax.fx(r,t) = LandMax00(r) * tland.l(r,t) ;

*------------------------------------------------------------------------------*
*  				Water supply module											   *
*------------------------------------------------------------------------------*

h2obnd.l(r,wbnd,t) = watScale * h2oUse(wbnd, r) $ IFWATER ;

*  !!!! FOR THE MOMENT, assume water price is uniform across broad aggregates

ph2obnd.l(r,wbnd,t)$sum(cra, h2o.l(r,cra,t))
    = sum(cra, ph2o.l(r,cra,t)*h2o.l(r,cra,t))
      / sum(cra, h2o.l(r,cra,t)) ;
ph2obndndx.l(r,wbnd,t) = ph2obnd.l(r,wbnd,t) ;

*  Build the nested bundles

h2obnd.l(r,wbnd1,t) = sum(wbnd2$mapw1(wbnd1, wbnd2), h2obnd.l(r,wbnd2,t)) ;
ph2obnd.l(r,wbnd1,t) $ h2obnd.l(r,wbnd1,t)
	= sum(mapw1(wbnd1, wbnd2), ph2obnd.l(r,wbnd2,t) * h2obnd.l(r,wbnd2,t))
	/ h2obnd.l(r,wbnd1,t) ;

th2om.l(r,t) = sum(wbnd1, h2obnd.l(r,wbnd1,t)) ;
pth2o.l(r,t) $ th2om.l(r,t)
	=   sum(wbnd1, ph2obnd.l(r,wbnd1,t) * h2obnd.l(r,wbnd1,t)) / th2om.l(r,t) ;
th2o.l(r,t) = th2om.l(r,t) + sum(wbnd $ wbndEx(wbnd), h2obnd.l(r,wbnd,t)) ;
pth2ondx.l(r,t) = pth2o.l(r,t) ;

h2oMax.fx(r,t) = h2oMax0(r)*th2o.l(r,t) ;

loop(t0,
   th2oFlag(r)$th2o.l(r,t0) = 1 ;
   h2obndFlag(r,wbnd)$h2obnd.l(r,wbnd,t0) = 1 ;
   h2obndFlag(r,wbndEx) = 0 ;
) ;

* [EditJean]: remove instructions about Incorporation of energy data in volume
* des-activated because same calculus than before

*------------------------------------------------------------------------------*
*           Change la normalization pp = 1 et px ne 1                          *
*------------------------------------------------------------------------------*

*  !!!! This might need revision if the matrix is not diagonal
*       or if we have an independent source for production volumes

* [EditJean]:  est-ce normal de faire ceci apres Grev? Quid for PowerVol

IF(1,
    pp.l(r,a,t) = xp.l(r,a,t) * pp.l(r,a,t) ;
    xp.l(r,a,t) = sum(i, x.l(r,a,i,t))      ;
    pp.l(r,a,t) $ xp.l(r,a,t) = pp.l(r,a,t) / xp.l(r,a,t) ;
    pp.l(r,a,t) $ (NOT xp.l(r,a,t)) = 0 ;

    px.l(r,a,t)    = pp.l(r,a,t) / (1 + ptax.l(r,a,t) $ ptax.l(r,a,t)) ;
    pxv.l(r,a,v,t) = px.l(r,a,t) ;
    uc.l(r,a,v,t)  = pxv.l(r,a,v,t) / (1 + uctax.l(r,a,v,t)) ;

    xpv.l(r,a,vOld,t) = xp.l(r,a,t) ;
    xpx.l(r,a,vOld,t) $ pxp.l(r,a,vOld,t)
        = (  xpv.l(r,a,vOld,t) * uc.l(r,a,vOld,t)
            - pxghg.l(r,a,vOld,t) * xghg.l(r,a,vOld,t))
        /  pxp.l(r,a,vOld,t) ;

* [EditJean]: adj. coeff. for "emiact" in case xp.l normalization is changed

    emir(r,AllEmissions,emiact,a,t) $ sum(t0,xp.l(r,a,t0))
        = emi.l(r,AllEmissions,emiact,a,t) / sum(t0,xp.l(r,a,t0)) ;

) ;

loop(vOld,
    kxRat.l(r,a,v,t) $ xpFlag(r,a) = kv.l(r,a,vOld,t) / xpv.l(r,a,vOld,t) ;
) ;

*  !!!! NEED TO RESOLVE

$OnText
put screen ;
put / ;
loop((r,a,vOld,t0)$(xp.l(r,a,t0) < 0),
   put r.tl / ;
   put uc.l(r,a,vOld,t0), px.l(r,a,t0), pp.l(r,a,t0), xpFlag(r,a), xp.l(r,a,t0):15:8 / ;
) ;
loop((r,i,t0)$(xs.l(r,i,t0) < 0),
   put r.tl / ;
   put xsFlag(r,i), xs.l(r,i,t0):15:8 / ;
) ;
abort "Temp" ;

$OffText

*------------------------------------------------------------------------------*
*               Initialization of power nesting (in value terms)               *
*------------------------------------------------------------------------------*

* Memo: in ENV-Linkages lambdapb = lambdapow  and lambdaas = lambdapb

$$IF NOT DECLARED ELOUTPUT0 PARAMETER ELOUTPUT0(r,a0,tt) ;

* Fix temporary data inconsistency between GTAP and EEB

Adjpa(r,a) = 1 ;

PARAMETER pWhTgt(a)  "Average pMWh0 (at model scale)";

IF(NOT IfPower,

    IF(card(pb) gt 1,
        lambdapow(r,pb,elyi,t) $ (NOT Allpb(pb)) = 1 ;
    ELSE
        lambdapow(r,Allpb,elyi,t) = 1 ;
    );
    lambdapb(r,elya,elyi,t) = 1 ;

ELSE

   loop((elyi,t0),
        xpb.l(r,pb,elyi,t) $ (NOT Allpb(pb))
			= sum(mappow(pb,powa), x.l(r,powa,elyi,t)) ;
        ppb.l(r,pb,elyi,t) $ xpb.l(r,pb,elyi,t)
            = 0 $ {NOT xpb.l(r,pb,elyi,t)}
            + { sum(mappow(pb,powa), p.l(r,powa,elyi,t) * x.l(r,powa,elyi,t))
				/ xpb.l(r,pb,elyi,t)
			  } $ {xpb.l(r,pb,elyi,t)};
        ppbndx.l(r,pb,elyi,t) $ ppb.l(r,pb,elyi,t) = ppb.l(r,pb,elyi,t) ;
        xpow.l(r,elyi,t) = sum(pb, xpb.l(r,pb,elyi,t)) ;
        ppow.l(r,elyi,t)
			= 0 $ { NOT xpow.l(r,elyi,t)}
            + {  sum(pb, ppb.l(r,pb,elyi,t) * xpb.l(r,pb,elyi,t))
                / xpow.l(r,elyi,t)
			  } $ { xpow.l(r,elyi,t) } ;
        ppowndx.l(r,elyi,t) $ ppow.l(r,elyi,t) = ppow.l(r,elyi,t) ;

*   Re-price etd services

        rwork(r) = sum(etda, p.l(r,etda,elyi,t0) * x.l(r,etda,elyi,t0));
        x.l(r,etda,elyi,t) = x.l(r,etda,elyi,t0) ;
        p.l(r,etda,elyi,t) = { 1 } $ {NOT x.l(r,etda,elyi,t0)}
                           + { rwork(r) / x.l(r,etda,elyi,t0)
							 } $ {x.l(r,etda,elyi,t0)} ;

* OECD-ENV: Add IfCoeffCes

	lambdapow(r,pb,elyi,t) $ ppb.l(r,pb,elyi,t)
		= [  {ppb.l(r,pb,elyi,t) / ppow.l(r,elyi,t)} $ IfElyCES
		+ {1 / ppb.l(r,pb,elyi,t)} $ {NOT IfElyCES}
		] * m_CESadj ;

	lambdapb(r,powa,elyi,t)
		$ (p.l(r,powa,elyi,t) AND sum(mappow(pb,powa), ppb.l(r,pb,elyi,t)))
		= [  { p.l(r,powa,elyi,t) / sum(mappow(pb,powa), ppb.l(r,pb,elyi,t)) } $ IfElyCES
		+ {1 / p.l(r,powa,elyi,t)} $ {NOT IfElyCES}
		] * m_CESadj ;
    ) ;

* OECD-ENV: Add some check

    IF(0,
        rwork(r) = 0;
        rwork(r) = sum((elyi,etda,t) $ t0(t),
                ps.l(r,elyi,t) * xs.l(r,elyi,t)
                -  p.l(r,etda,elyi,t) * x.l(r,etda,elyi,t)
                - xpow.l(r,elyi,t) * ppow.l(r,elyi,t) );
        display "Check ely balance (value):", rwork;
    ) ;
	IF(ifCal AND IfDebug,
		Execute_unload "%cBaseFile%_%system.fn%_PowerValue.gdx",
			xp0_TWh, pMwh0, lambdapow, lambdapb, gp,
			x, p, xpow, ppow, xpb, ppb, ppowndx ;
	) ;
) ;

*------------------------------------------------------------------------------*
*                  Initialize power nesting in volume : TWh                    *
*               xp0_TWh : power Mix in volume (TWh) in %YearGTAP%              *
*------------------------------------------------------------------------------*

***HRR: changes to use gwhr when using  BaseDataAdj.gms changes
$$ifi %ifElyMixCal%=="OFF" Scalar PowVolType / 1 / ;    
$$ifi %ifElyMixCal%=="ON"  Scalar PowVolType / 0 / ;
***endHRR


* PowVolType = 0 : Use GTAP caculated with gwhr
* PowVolType = 1 : Use GTAP caculated with xpNrg0
* PowVolType = 2 : Use EEB

$If NOT EXIST "%iDataDir%\IEA_Energy_Balance.gdx" abort $ {PowVolType eq 2} "There is no IEA_Energy_Balance data" ;

IF(IfPower AND IfPowerVol,

*   Default: use GTAP value for gwhr (and convert to TWh)
    xp0_TWh(r,powa) = 0.001 * sum(mapa0(a0,powa), (gwhr(a0,r) * PowScale) ) ;

* USD per KwH
	pMwh0(r,powa) $ xp0_TWh(r,powa)
		= outscale * sum((t0,elyi), x.l(r,powa,elyi,t0))
		/ (1000 * xp0_TWh(r,powa)) ;

* [2024-02-15]: Obtain xp0_TWh using xpNrg0 (i.e. Energy supply in Mtoe)

	IF(PowVolType,

* Override gwhr(a0,r)
		gwhr(a0,r) = 0 ; xp0_TWh(r,powa) = 0 ; pMwh0(r,powa) = 0 ;

* Convert from Mtoe to Twh (= 1000 GWh) --> work
		work = 11.6309304;
		loop((i0,a0) $ sameas(i0,a0), gwhr(a0,r) = work * xpNrg0(i0,r) ; ) ;
		xp0_TWh(r,powa) = sum(mapa0(a0,powa), gwhr(a0,r)) ;
		pMwh0(r,powa) $ xp0_TWh(r,powa)
			= outscale * sum((t0,elyi), x.l(r,powa,elyi,t0))
			/ (1000 * xp0_TWh(r,powa)) ;

*	Model Scale
		xp0_TWh(r,powa) = sum(mapa0(a0,powa), gwhr(a0,r)) * Powscale ;
		pMwh0(r,powa) $ xp0_TWh(r,powa)
			= sum((t0,elyi), x.l(r,powa,elyi,t0)) / xp0_TWh(r,powa) ;
	) ;

* average over region
		pWhTgt(powa)
			= sum(r,xp0_TWh(r,powa) * pMwh0(r,powa)) / sum(r,xp0_TWh(r,powa)) ;

*	Save GTAP Power price (USD / kWh)
		IF(0,
			Adjpa(r,powa) = pMwh0(r,powa) ;
		) ;

*	OECD-ENV: xp0_TWh from IEA EEB (Override GTAP data)

    $$IfThen.EEBData EXIST "%iDataDir%\IEA_Energy_Balance.gdx"

	IF(PowVolType eq 2,

    $$OnText
        some values are initally so low that projection of huge increase
        imply some troubles, since in calibration process we ease convergence to
        IEA levels in first phase so we arbitrary scale up their values initially

        Memo: IEA, Power Generation USA.CLPa.2014 = 1713 TWh

    $$OffText

		EXECUTE_LOAD "%iDataDir%\IEA_Energy_Balance.gdx", ELOUTPUT0 = ELOUTPUT ;

* Power calibration procedure: Override gtap xp0_TWh with IEA EEB

		loop(t0,

* variant: read baseline value

			IF(NOT IfCal,

				xp0_TWh(r,elya) = 0 ;
				EXECUTE_LOADDC "%BauFile%.gdx", xp0_TWh, pMwh0 ;

			ELSE

				xp0_TWh(r,powa)	$ sum(mapa0(a0,powa), ELOUTPUT0(r,a0,t0))
					= sum(mapa0(a0,powa), ELOUTPUT0(r,a0,t0)) * Powscale / 1000;
				pMwh0(r,powa) $ xp0_TWh(r,powa)
					= sum(elyi, x.l(r,powa,elyi,t0)) / xp0_TWh(r,powa) ;

				IF(0,
					Execute_unload "EEB_ModelScale.gdx", xp0_TWh, pMwh0 ;
					pMwh0(r,powa)   = 0.1 * pMwh0(r,powa) ;
					xp0_TWh(r,powa) = xp0_TWh(r,powa) / Powscale ;
					Display "GTAP (EEB) Electricity Wholesale price USD / kWh (%system.fn%.gms):", pMwh0;
					Display "GTAP (EEB) Electricity Generation Twh (%system.fn%.gms):", xp0_TWh ;
					Execute_unload "EEB.gdx", xp0_TWh, pMwh0 ;
					xp0_TWh(r,powa)	= xp0_TWh(r,powa) * Powscale ;
					pMwh0(r,powa)   = 10 * pMwh0(r,powa) ;
				) ;

			) ;

		) ;
	) ;

    $$EndIf.EEBData

	Loop(t0,
*   Re-define price for power generation activities
* -->  production costs in USD per kilowatt hour (in 2014)

		p.l(r,powa,elyi,t) $ (xp0_TWh(r,powa) and x.l(r,powa,elyi,t0))
			= [p.l(r,powa,elyi,t0) * x.l(r,powa,elyi,t0)]
			/ xp0_TWh(r,powa)  ;

*   Re-define volume of power generation --> 10000 * x.l gives TWh
		x.l(r,a,elyi,t) $(powa(a) and xp0_TWh(r,a) and x.l(r,a,elyi,t0))
			= xp0_TWh(r,a)						  $ {    xp0_TWh(r,a) }
			+ [x.l(r,a,elyi,t) / p.l(r,a,elyi,t)] $ {NOT xp0_TWh(r,a) } ;
	) ;



*   Built power bundles in Twh
	xpb.l(r,pb,elyi,t) = 0 ;
	xpb.l(r,pb,elyi,t) = sum(elya $ mappow(pb,elya), x.l(r,elya,elyi,t)) ;
	ppb.l(r,pb,elyi,t) $ xpb.l(r,pb,elyi,t)
		= 0 $ {NOT xpb.l(r,pb,elyi,t)}
		+ {sum(mappow(pb,elya), p.l(r,elya,elyi,t) * x.l(r,elya,elyi,t))
			/ xpb.l(r,pb,elyi,t)
		  } $ {xpb.l(r,pb,elyi,t)} ;

*   Actually one degree of freedom if IfElyCES = 0 so can fix ppbndx to what we want:
	ppbndx.l(r,pb,elyi,t) $ ppb.l(r,pb,elyi,t)
		= 1 $ {NOT IfElyCES}  + ppb.l(r,pb,elyi,t) $ {IfElyCES};
	xpow.l(r,elyi,t) = sum(pb, xpb.l(r,pb,elyi,t));
	ppow.l(r,elyi,t) $ xpow.l(r,elyi,t)
		=  0 $ { NOT xpow.l(r,elyi,t) }
		+ {  sum(pb, ppb.l(r,pb,elyi,t)*xpb.l(r,pb,elyi,t))
			/ xpow.l(r,elyi,t)
		} $ { xpow.l(r,elyi,t) } ;

*   Actually one degree of freedom if IfElyCES = 0 so can fix ppowndx to what we want:
	ppowndx.l(r,elyi,t) $ ppow.l(r,elyi,t)
		= 1 $ {NOT IfElyCES} + ppow.l(r,elyi,t) $ {IfElyCES} ;
	ps.l(r,elyi,t) $ sum(elya, p.l(r,elya,elyi,t) * x.l(r,elya,elyi,t)) = 1;
	xs.l(r,elyi,t) $ ps.l(r,elyi,t)
		= sum(elya, p.l(r,elya,elyi,t) * x.l(r,elya,elyi,t)) / ps.l(r,elyi,t);

*	The Expressions below holds for both CES (IfElyCES=1) and Additive CES cases

* In the CES case: since ppb and ppow not equal to 1, the standard formula
* for IfCoeffCes = 1 is adjusted

	lambdapow(r,pb,elyi,t) $ ppb.l(r,pb,elyi,t)
		= [  {ppb.l(r,pb,elyi,t) / ppow.l(r,elyi,t)} $ IfElyCES
		+ {1 / ppb.l(r,pb,elyi,t)} $ {NOT IfElyCES}
		] * m_CESadj ;

	lambdapb(r,powa,elyi,t)
		$ (p.l(r,powa,elyi,t) AND sum(mappow(pb,powa), ppb.l(r,pb,elyi,t)))
		= [  { p.l(r,powa,elyi,t) / sum(mappow(pb,powa), ppb.l(r,pb,elyi,t)) } $ IfElyCES
		+ {1 / p.l(r,powa,elyi,t)} $ {NOT IfElyCES}
		] * m_CESadj ;

	IF(ifCal AND IfDebug,
		rwork(r) = 0;
		rwork(r)
			= sum((elyi,etda,t0),
					ps.l(r,elyi,t0) * xs.l(r,elyi,t0)
					-  p.l(r,etda,elyi,t0) * x.l(r,etda,elyi,t0)
					- xpow.l(r,elyi,t0) * ppow.l(r,elyi,t0)) ;
		display "Check (upper nest) electricity balance in volume (%system.fn%.gms):",
				rwork ;

		Execute_unload "%cBaseFile%_%system.fn%_PowerVolume.gdx",
			xp0_TWh, pMwh0, lambdapow, lambdapb, x.l, p.l, xpow, x, xpb, ppow,
			gp, ppb, lambdapb, lambdapow, ppowndx ;
	) ;

) ; !! End condition on IfPower

*------------------------------------------------------------------------------*
*                                                                              *
*  				Initialization of capital account module					   *
*                                                                              *
*------------------------------------------------------------------------------*

kstocke.l(r,t) = (1 - depr(r,t)) * kstock.l(r,t) + sum(inv, xfd.l(r,inv,t)) ;

ror.l(r,t) = chiKaps0(r) * trent.l(r,t) * (1 - kappak.l(r,t)) ;

rorc.l(r,t) = ror.l(r,t) / sum(inv, pfd.l(r,inv,t)) - depr(r,t) ;

rore.l(r,t) = rorc.l(r,t) * ( kstocke.l(r,t) / kstock.l(r,t))**(-epsRor(r,t) ) ;

rorg.l(t) = (sum(r, rore.l(r,t)*sum(inv, pfd.l(r,inv,t)*(xfd.l(r,inv,t) - depr(r,t)*kstock.l(r,t))))
          / sum((rp,inv), pfd.l(rp,inv,t)*(xfd.l(rp,inv,t) - depr(rp,t)*kstock.l(rp,t))))$(%savfFlag% ne capFlexUSAGE) ;

riskPrem(r,t) = rorg.l(t) / rore.l(r,t) ;

savfBar(r,t)  = savf.l(r,t) ;
xpBar(r,a,t)  = 0;

IF(0,
   display kstock.l, kstocke.l, ror.l, rorc.l, rore.l, rorg.l, riskPrem ;

   abort "Temp" ;
) ;

*  Direct initialization

loop((inv,t0),
   grK.l(r,t)    = xfd.l(r,inv,t0)/kstock.l(r,t0) - depr(r,t0) ;
   IF(%savfFlag% eq capFlexUSAGE,
      devRoR.l(r,t) = log(((grKMax(r,t0) - grKTrend(r,t0))/(grKTrend(r,t0) - grKMin(r,t0)))
                    * (grK.l(r,t0) - grKMin(r,t0))/(grKMax(r,t0) - grK.l(r,t0)))
                    / chigrK(r,t) ;
      rore.l(r,t)   = (ror.l(r,t0)/pfd.l(r,inv,t0) + (1-depr(r,t0)))/1.05 - 1 ;
      rorg.l(t)     = 0 ;
      rord.l(r,t)   = rore.l(r,t) - rorn(r,t) - rorg.l(t) - devRor.l(r,t) ;
   ) ;
) ;

IF(0,
   option decimals=6 ;
   display grk.l, devRoR.l, rore.l, rorg.l, rord.l,
   grkMin, grkMax, grkTrend, chigrK, rorn ;

   abort "Temp" ;
) ;

*------------------------------------------------------------------------------*
*																			   *
*				Macro and World Variable initializations     				   *
*																			   *
*------------------------------------------------------------------------------*

gdpmp.l(r,t)
    = sum(fd, yfd.l(r,fd,t))
    + sum((i,rp),pwe.l(r,i,rp,t)*xw.l(r,i,rp,t)-pwm.l(rp,i,r,t)*xw.l(rp,i,r,t))
    + sum(img, pdt.l(r,img,t)*xtt.l(r,img,t)) ;
rgdpmp.l(r,t) = gdpmp.l(r,t) ;
rgovshr.l(r,t) $ rgdpmp.l(r,t) = sum(gov,xfd.l(r,gov,t)) / rgdpmp.l(r,t) ;
govshr.l(r,t)  $ gdpmp.l(r,t)  = sum(gov,yfd.l(r,gov,t)) /  gdpmp.l(r,t) ;
rinvshr.l(r,t) $ rgdpmp.l(r,t) = sum(inv,xfd.l(r,inv,t)) / rgdpmp.l(r,t) ;
invshr.l(r,t)  $ gdpmp.l(r,t)  = sum(inv,yfd.l(r,inv,t)) /  gdpmp.l(r,t) ;

rfdshr.l(r,fdc,t) $ rgdpmp.l(r,t) = xfd.l(r,fdc,t) / rgdpmp.l(r,t) ;
nfdshr.l(r,fdc,t)  $ gdpmp.l(r,t) = yfd.l(r,fdc,t) /  gdpmp.l(r,t) ;

* Variant case

IF(IfDyn and (NOT Ifcal),
    EXECUTE_LOADDC "%BauFile%.gdx", popT, pop0, pop, popWA.l, popWA0 ;
    pop.l(r,t)       = pop.l(r,t) * pop0(r);
    popWA.l(r,l,z,t) = popWA.l(r,l,z,t) * popWA0(r,l,z) ;
) ;

*  Initialization for comparative static model (use GTAP population)
* [TBU] with true values for rural share, pop15 and lfpr

IF(NOT ifDyn,
    pop.fx(r,t) = popScale * popg(r) ;

    popWA.fx(r,l,rur,t) = 0.5 * [ 0.8 * pop.l(r,t)];
    popWA.fx(r,l,urb,t) = [ 0.8 * pop.l(r,t)] - sum(rur,popWA.l(r,l,rur,t));
    UNR.l(r,l,z,t)     = 0 ;
    LFPR.l(r,l,z,t)    = 0.75 ;
    popWA.fx(r,l,nsg,t) $ (NOT ifLSeg(r,l)) = sum(z,popWA.l(r,l,z,t));
    popWA.fx(r,l,z,t)   $ (NOT ifLSeg(r,l) and NOT nsg(z)) = 0 ;
    ETPT(r,l,z,t) $ popWA.l(r,l,z,t)
        = LFPR.l(r,l,z,t) * [1 - 0.01 * UNR.l(r,l,z,t)] * popWA.l(r,l,z,t);
) ;

rgdppc.l(r,t) $ pop.l(r,t)  = rgdpmp.l(r,t) / pop.l(r,t) ;
grrgdppc.l(r,t) = 0 ;
gl.l(r,t)       = 0 ;

pw0(a) $ (not tota(a)) = 1  ;
pw.l(a,t) $ pw0(a) = pw0(a) ;

pwtrend(a,tt) = na ;
pwshock(a,tt) = na ;

*  !!!! Why is this conditioned? shouldn't walras always be initialized to 0?
* walras.l(t) $ m_horizonSim(t) = 0.0 ;
walras.l(t) = 0.0 ;

* OECD-ENV: additional variables

PI0_xa.l(r,t)   = 1;
PI0_xc.l(r,h,t) = 1;

* wldPm.l(i,t) $ m_horizonSim(t) =  1 ;
wldPm.l(i,t) =  1 ;
phipwi(i,t) $ sum((r,rp), xwFlag(r,i,rp)) =  1 ;
***HRR: hard-coded to 2014
*phipwi(COILi,"2014") =  106.82  * ConvertCurToModelUSD("2020") ;
*phipwi(COILi,t) $ after(t,"2014") =  55.2578 * ConvertCurToModelUSD("2020") ;
***endHRR
wldPm.l(i,t) $ phipwi(i,t) =  phipwi(i,t) ;

* Labour & natRes share

IF(IfDebug,
    riswork(r,a) $ sum((fp,a0),mapa0(a0,a) * vfm(fp,a0,r))
        = 100 * sum((l,a0),mapa0(a0,a) * vfm(l,a0,r))
        / sum((fp,a0), mapa0(a0,a) * vfm(fp,a0,r)) ;
    Execute_unload "%cBaseFile%_%system.fn%_LabShare.gdx",
            riswork=LabShr ;
    riswork(r,a) = 0 ;
    riswork(r,a) $ sum((fp,a0),mapa0(a0,a) * vfm(fp,a0,r))
        = 100 * sum((nrs,a0),mapa0(a0,a) * vfm(nrs,a0,r))
        / sum((fp,a0), mapa0(a0,a) * vfm(fp,a0,r)) ;
    Execute_unload "%cBaseFile%_%system.fn%_NatResShare.gdx",
            riswork=NrsShr ;
) ;

* --------------------------------------------------------------------------------------------------
*
*  Initialization of knowledge module
*
* --------------------------------------------------------------------------------------------------

$iftheni.RD "%ifRD_MODULE%" == "ON"
   alias(ky, kky) ;
   valk(ky) = ord(ky) - 1 ;

   loop(r,
      if(KnowledgeData0(r,"delta") <> na,

         gamPrm(r,"delta")  = KnowledgeData0(r,"delta") ;
         gamPrm(r,"lambda") = KnowledgeData0(r,"lambda") ;
         gamPrm(r,"N")      = KnowledgeData0(r,"N") ;
         kdepr(r,t)         = 0.01*KnowledgeData0(r,"depr") ;

         gamCoef(r,ky)$(valk(ky) le gamPrm(r,"N"))
                  = ((valk(ky) + 1)**(gamPrm(r,"delta")/(1-gamPrm(r,"delta"))))
                  *   gamPrm(r,"lambda")**valk(ky) ;
         gamCoef(r,ky) = gamCoef(r,ky) / sum(kky, gamCoef(r,kky)) ;

         knowFlag(r) = yes ;

      else

         knowFlag(r) = no ;

      ) ;
   ) ;

   if(not ifDyn,
      knowFlag(r) = no ;
   ) ;

   loop(r,
      if(knowFlag(r),

*        Initialize the knowledge stock given initial R&D expenditures--assume steady-state

         kn0(r) = ((1 + 0.01*KnowledgeData0(r,"g0"))
                /  (0.01*KnowledgeData0(r,"g0") + 0.01*KnowledgeData0(r,"depr")))
                * (sum(ky$(valk(ky) le gamPrm(r,"N")), gamCoef(r,ky)/power(1 + 0.01*KnowledgeData0(r,"g0"), valk(ky)))) ;

         kn0(r) = xfd.l(r,r_d,t0)*kn0(r) ;

*        Initialize R&D

         rd0(r) = xfd.l(r,r_d,t0) ;
         rd.l(r,t) = rd0(r) ;
*        This code is doing nothing as rd.l = rd0 for all t
         loop(t,
            rd.l(r,tt)$(years(tt) gt t0.val and years(tt) gt years(t-1) and years(tt) lt years(t))
               = rd.l(r,t) * (rd.l(r,t) / rd.l(r,t-1))**((years(tt) - years(t))/gap(t)) ;
         ) ;

*        Back cast R&D

         rd.l(r,tt)$(years(tt) < years(t0)) = rd.l(r,t0)*(1 + 0.01*KnowledgeData0(r,"g0"))**(years(tt) - years(t0)) ;

*        Initialize the endogenous part of labor productivity

         gammar(r,l,a,t) = KnowledgeData0(r,"gammar") ;
         epsr(r,l,a,t)   = KnowledgeData0(r,"epsr") ;
         pik.l(r,l,a,t)  = gammar(r,l,a,t)*epsr(r,l,a,t)*0.01*KnowledgeData0(r,"g0") ;

      else
         pik.fx(r,l,a,t) = 0 ;
      )
   ) ;

$else.RD

   knowFlag(r) = no ;
   pik.fx(r,l,a,t) = 0 ;

$endif.RD

