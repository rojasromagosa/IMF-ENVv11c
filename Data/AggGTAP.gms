$OnText
--------------------------------------------------------------------------------
		Envisage 10 / OECD-ENV Model version 1.0 - Data preparation module
   GAMS file : "%DataDir%\AggGTAP.gms"
   @purpose  : Aggregate standard GTAP database--emulation the GTAPAgg GEMPACK program.
   @author   : Dominique van der Mensbrugghe for ENVISAGE
   @date     : 21.10.16
   @revision : Jean Chateau - 20.03.2021 / 21.09.2022 for OECD-ENV
   @since    :
   @refDoc   :
   @seeAlso  :ifAlt
   @calledBy : - makedata.cmd for ENVISAGE
			   - %ProjectDir%/RunSim/RunBaseline.gms for OECD-ENV
   @Options  : ifCSV 		(default=0)
               ifAggTrade   (default=1)
               ifWater      (default=OFF)
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/AggGTAP.gms $
   last changed revision: $Rev: 515 $
   last changed date    : $Date:: 2024-02-23 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
[EditJean] Revision:
Instructions for GAMS-IDE (en fait idir n'est plus necessaire et ifAlt non plus)
In root folder:
    --idir=Data --BaseName=10x10 --model=ENV --ifCSV=0 --ifAggTrade=0 --BuildScenarioInAgg=ON
In a project folder:
    --BaseName=2023_G20 --model=ENV --ifCSV=0 --ifAggTrade=0 --BuildScenarioInAgg=ON

    Memo : location of this file "AggGTAP.gms" = %system.fp% = \Data
--------------------------------------------------------------------------------
$OffText

$OffListing
$OnListing
$OnGlobal
$OnEolCom

*   OECD-ENV Section

* Add Default Choices

$IF NOT SET  model     $SetGlobal model      "ENV"
$IF NOT SET ifCSV      $SetGlobal ifCSV      "0"
$IF NOT SET ifAggTrade $SetGlobal ifAggTrade "0"

* [TBC]: Options %ifAlt% and %ifFilter% are no more precised here because useless

* read paths to main directories and read the option file "a_ProjectOptions.gms"

***HRR $IF NOT EXIST "%system.fp%..\a_FolderPath.gms" $CALL "%system.fp%..\00a-getPath.bat"
$Include "%system.fp%..\a_FolderPath.gms"

$IF NOT SET BaseName abort "$SetGlobal BaseName should be defined" ;

* define path for data included in FolderPath.gms, for ENVISAGE codes put "."

$IF NOT SET DataDir $SetGlobal DataDir "."

* Default values for Global Variables
* Memo: ifPower & ifWater are function of GTAP_DBType

$IF NOT SET BuildScenarioInAgg $SetGlobal BuildScenarioInAgg "OFF"
$IFI NOT %GTAP_DBType%=="GTAP-Power" $SetGlobal ifPower  "OFF"
$IFI     %GTAP_DBType%=="GTAP-Power" $SetGlobal ifPower  "ON"
$IFI NOT %GTAP_DBType%=="GTAP-Water" $SetGlobal ifWater  "OFF"
$IFI     %GTAP_DBType%=="GTAP-Water" $SetGlobal ifWater  "ON"
$IF NOT SET ifAirPol                 $SetGlobal ifAirPol "OFF"
$IF NOT %GTAP_ver%=="10.1" $IF NOT %GTAP_ver%=="11c" $IF NOT exist "%FolderGTAP%\SatAcc\nco2.gdx"     $SetGlobal NCO2     "OFF"
$IF NOT %GTAP_ver%=="10.1" $IF NOT %GTAP_ver%=="11c" $IF NOT exist "%FolderGTAP%\SatAcc\airpolut.gdx" $SetGlobal ifAirPol "OFF"

* To recover exact ENVISAGE codes: $SetGlobal Prefix "%BaseName%"
* or put this declaration manually in "%ProjectDir%\a_ProjectOptions.gms"

$IF NOT SET Prefix $SetGlobal Prefix ""

* Define %DirCheck%: the folder where are stored intermediate results / checks
* for a specific project aggregation

$If     SET oDirCheck $SetGlobal DirCheck "%oDirCheck%\%BaseName%\agg"
$If NOT SET oDirCheck $SetGlobal DirCheck "%ProjectDir%\Check\agg"
$If NOT DEXIST "%DirCheck%" $call "mkdir %DirCheck%"

* Checks active when m_CheckFile = 1

$macro m_CheckFile 1

* Folder %oDirGTAP% to store some intermediate calculation for GTAP aggregation

***HRR $If exist "%DataDir%\oDirGTAP.gms" $include "%DataDir%\oDirGTAP.gms"

$Include "%ToolsDir%\macros.gms"

*------------------------------------------------------------------------------*
*                                                                              *
*   GAMS program to aggregate a GTAP database: ENVISAGE section                *
*                                                                              *
*------------------------------------------------------------------------------*

*  Define the aggregation macros

$macro AGG1(v0,v,x0,x,mapx)  v(x) = sum(x0 $ mapx(x0,x), v0(x0))
$macro AGG2(v0,v,x0,x,mapx,y0,y,mapy)                                  	  \
   v(x,y)  = sum((x0,y0) $ (mapx(x0,x) and mapy(y0,y)), v0(x0,y0))     	  \
$macro AGG3(v0,v,x0,x,mapx,y0,y,mapy,z0,z,mapz)                        	  \
    v(x,y,z)                                                           	  \
        = sum((x0,y0,z0) $ (mapx(x0,x) and mapy(y0,y) and mapz(z0,z)), 	  \
        v0(x0,y0,z0))                                                  	  \
$macro AGG4(v0,v,x0,x,mapx,y0,y,mapy,z0,z,mapz,w0,w,mapw)                 \
    v(x,y,z,w)                                                            \
        = sum((x0,y0,z0,w0)                                               \
            $ (mapx(x0,x) and mapy(y0,y) and mapz(z0,z) and mapw(w0,w)),  \
            v0(x0,y0,z0,w0))                                              \

acronyms off, on, noLab, agLab, allLab, giddLab, alterTax, GTAP, Env ;

*  Include common sets

* [OECD-ENV]: all GTAP sets are now compiled in one file

$include "%SetsDir%\SetsGTAP.gms"

* [OECD-ENV]: Update GHGs and OAP procedure starting by redefining sets

$include "%SetsDir%\setEmissions.gms"

* define the versions of external satelite database for GHG (and energy) used

$include "%SetsDir%\SetDatabaseVersion.gms"

* [OECD-ENV]: Update agriculture calibration: Load set IMPACTa0 & IMPACTi0

$include "%SetsDir%\SetsIMPACTsectors.gms"

*  Include the aggregation mappings for the model and project-specific choices

$IF NOT SET iMapDir $SetGlobal iMapDir "%iFilesDir%"

$include "%iMapDir%\%Prefix%Map.gms"

file screen / %ProjectDir%\Check_Aggregation.txt /;
*file screen / con / ;
put screen ;
put / ;

* Default Flag
$if not setglobal ifCSV $setglobal ifCSV
$if "%ifCSV%" == ""     $setglobal ifCSV 0

$if not setglobal ifAggTrade $setglobal ifAggTrade
$if "%ifAggTrade%" == ""     $setglobal ifAggTrade 1

SCALARS
    work    "working scalar"
    ifWater    / %ifWater% /
    ifPower    / %IfPower% /
    ifCSV      / %ifCSV% /
    ifAggTrade / %ifAggTrade% /
    order      / 0 /
;

$SHOW

*   Validate the aggregation mappings set in map.gms

$IFi %BuildScenarioInAgg%=="OFF" $include "%DataDir%\CheckAggregations.gms"

* [OECD-ENV]: move instructions "Save the aggregation mappings" to the end

*------------------------------------------------------------------------------*
*                                                                              *
*                      Aggregate the GTAP data                                 *
*                                                                              *
*------------------------------------------------------------------------------*

* memo: market prices = basic prices
*		purchasers' prices = agents' prices

parameters

    work

*  From the standard database

    VDFM(TRAD_COMM,PROD_COMM,REG)       "Domestic purchases, by firms, at market prices"   !! VDFB
    VDFA(TRAD_COMM,PROD_COMM,REG)       "Domestic purchases, by firms, at agents' prices"  !! VDFP
    VIFM(TRAD_COMM,PROD_COMM,REG)       "Import purchases, by firms, at market prices"	   !! VMFB
    VIFA(TRAD_COMM,PROD_COMM,REG)       "Import purchases, by firms, at agents' prices"    !! VMFP
    VDPM(TRAD_COMM,REG)                 "Domestic purchases, by households, at market prices"  !! VDPB
    VDPA(TRAD_COMM,REG)                 "Domestic purchases, by households, at agents' prices" !! VDPP
    VIPM(TRAD_COMM,REG)                 "Import purchases, by households, at market prices"    !! VMPB
    VIPA(TRAD_COMM,REG)                 "Import purchases, by households, at agents' prices"   !! VMPP
    VDGM(TRAD_COMM,REG)                 "Domestic purchases, by government, at market prices"  !! VDGB
    VDGA(TRAD_COMM,REG)                 "Domestic purchases, by government, at agents' prices" !! VDGP
    VIGM(TRAD_COMM,REG)                 "Import purchases, by government, at market prices"    !! VMGB
    VIGA(TRAD_COMM,REG)                 "Import purchases, by government, at agents' prices"   !! VMGP

    $$IfTheni.GTAP %GTAPBASE%=="GSDF"
		VDIB(TRAD_COMM,REG)  "Domestic purchases, by investment, at basic prices"
		VDIP(TRAD_COMM,REG)  "Domestic purchases, by investment, at purchasers' prices"
		VMIB(TRAD_COMM,REG)  "Import purchases,   by investment, at basic prices"
		VMIP(TRAD_COMM,REG)  "Import purchases,   by investment, at purchasers' prices"
    $$EndIf.GTAP

    VFM(ENDW_COMM, PROD_COMM,REG)       "Primary factor purchases, by firms, at market prices" !! EVFB "Primary factor purchases at basic prices"
    EVFA(ENDW_COMM,PROD_COMM,REG)       "Primary factor purchases, at agents' prices"		   !! EVFP
***HRR: EVOS (which is used to populate EVOA, has now 3 dimensions: ENDW,ACTS,REG)
* create an intermediate variable 
    EVOA_int(ENDW_COMM,ACTS,REG)
***endHRR
    EVOA(ENDW_COMM,REG)                 "Primary factor sales, at agents' prices / Factor remuneration after income tax" !! EVOS

    VXMD(TRAD_COMM, REG, REG)           "Non-margin exports, at market prices" 		!! VXSB
    VXWD(TRAD_COMM, REG, REG)           "Non-margin exports, at world (FOB) prices" !! VFOB
    VIWS(TRAD_COMM, REG, REG)           "Imports, at world (CIF) prices"			!! VCIF
    VIMS(TRAD_COMM, REG, REG)           "Imports, at market prices" 				!! VMSB

    VST(TRAD_COMM, REG)                 "Exports of trade and transport services"
    VTWR(MARG_COMM,TRAD_COMM,REG, REG)  "Margins by margin commodity"

    SAVE(REG)                           "Net saving, by region"
    VDEP(REG)                           "Capital depreciation"
    VKB(REG)                            "Capital stock"
    POP(REG)                            "Population"

* [EditJean]: var added (move this info here)

    $$IFI %IfPower% == "ON" gwhr(a0,reg) "Power output in Gwh"
    $$IFI %IfPower% == "ON" elyscale(a0) "scale factor for CCS"

*  Auxiliary variables

    voa(prod_comm,reg)                  "Value of output before output tax/subsidy"
    vom(prod_comm,reg)                  "Value of output after output tax/subsidy"  !! producer prices
    osep(prod_comm,reg)                 "Value of production tax/subsidy"

* OECD-ENV: add FBEP & FTRV for calculating Taxfp(r,a,fp,t) & Subfp(r,a,fp,t)

    FBEP(ENDW_COMM,PROD_COMM,REG)   "Gross Factor-Based Subsidies expenditures"
    FTRV(ENDW_COMM,PROD_COMM,REG)   "Gross Factor-Based Tax revenue"
;

*  Load the GTAP data base

EXECUTE_LOADDC "%iGdxDir_GtapDB%\%GTAPBASE%DAT.gdx",

	$$IfTheni.GTAP %GTAPBASE%=="GSD"

		VDFM, VDFA, VIFM, VIFA, VFM, EVFA, EVOA,
		VDPM, VDPA, VIPM, VIPA,
		VDGM, VDGA, VIGM, VIGA,
		VXMD, VXWD, VIWS, VIMS,

* [EditJean]: variable with a different name in GTAP-Power database

		$$IFI %IfPower%=="OFF" VTWR,
		$$IFI %IfPower%=="ON"  VTWR=VTMFSD,

    $$ElseIf.GTAP %GTAPBASE%=="GSDF"

		VDFM=VDFB, VDFA=VDFP, VIFM=VMFB, VIFA=VMFP,
***HRR:changed to EVOA_int
		VFM=EVFB, EVFA=EVFP, EVOA_int=EVOS,
		VDPM=VDPB, VDPA=VDPP, VIPM=VMPB, VIPA=VMPP,
		VDGM=VDGB, VDGA=VDGP, VIGM=VMGB, VIGA=VMGP,
		VXMD=VXSB, VXWD=VFOB, VIWS=VCIF, VIMS=VMSB,

		VDIB, VDIP, VMIB, VMIP

		VTWR

    $$Else.GTAP

		check

    $$EndIf.GTAP

* OECD-ENV: add FBEP & FTRV

	FBEP, FTRV,

	VST, SAVE, VDEP, VKB, POP
;

$IfTheni.GTAP %GTAPBASE%=="GSDF"
    VDFM(TRAD_COMM,CGDS0,REG) = VDIB(TRAD_COMM,REG) ;
    VDFA(TRAD_COMM,CGDS0,REG) = VDIP(TRAD_COMM,REG) ;
    VIFM(TRAD_COMM,CGDS0,REG) = VMIB(TRAD_COMM,REG) ;
    VIFA(TRAD_COMM,CGDS0,REG) = VMIP(TRAD_COMM,REG) ;
    
***HRR: equate EVOA_int to EVOA
        EVOA(ENDW_COMM,REG)  = sum(ACTS, EVOA_int(ENDW_COMM,ACTS,REG) ); 
***endHRR

$EndIf.GTAP


*  Scale output -- takes care of advanced technologies: advTech

parameter scaleXP(a0) ;
scaleXP(a0) = (1)$(not advTech(a0)) + (1e-9)$(advTech(a0)) ;

$OnText
    Before aggregating: check in the bridge file

    scale the advanced electricity data
    The cost data is scaled to equal elyscale in values
    The price can be gleaned from dividing elyscale by gwhr
    Therefore, to get the value of output
    equal to 0.01 for example (i.e. $10,000)
    take the value and multiply by  0.01 / elyscale(a0) --> 0.00001
    To remove, simply set AdvElyscale to 0

elyscale(advTech) = 1000;

vdfm(i0,a0,r0) $ advTech(a0)
    = [vdfm(i0,a0,r0) * AdvElyscale/elyscale(a0)] $ elyscale(a0) + 0;
vdfa(i0,a0,r0) $ advTech(a0)
    = [vdfa(i0,a0,r0) * AdvElyscale/elyscale(a0)]$elyscale(a0) + 0;
vifm(i0,a0,r0) $ advTech(a0)
    = [vifm(i0,a0,r0) * AdvElyscale/elyscale(a0)]$elyscale(a0) + 0;
vifa(i0,a0,r0) $ advTech(a0)
    = [vifa(i0,a0,r0) * AdvElyscale/elyscale(a0)]$elyscale(a0) + 0;
vfm(fp0,a0,r0) $ advTech(a0)
    = [vfm(fp0,a0,r0)  * AdvElyscale/elyscale(a0)]$elyscale(a0) + 0;
evfa(fp0,a0,r0)$ advTech(a0)
    = [evfa(fp0,a0,r0) * AdvElyscale/elyscale(a0)]$elyscale(a0) + 0;
osep(a0,r0)    $ advTech(a0)
    = [osep(a0,r0) * AdvElyscale/elyscale(a0)]$elyscale(a0) + 0;

$OffText

vdfm(trad_comm,prod_comm,r0) = scaleXP(prod_comm)*vdfm(trad_comm,prod_comm,r0) ;
vdfa(trad_comm,prod_comm,r0) = scaleXP(prod_comm)*vdfa(trad_comm,prod_comm,r0) ;
vifm(trad_comm,prod_comm,r0) = scaleXP(prod_comm)*vifm(trad_comm,prod_comm,r0) ;
vifa(trad_comm,prod_comm,r0) = scaleXP(prod_comm)*vifa(trad_comm,prod_comm,r0) ;
vfm(ENDW_COMM,prod_comm,r0)  = scaleXP(prod_comm)*vfm(ENDW_COMM,prod_comm,r0)  ;
evfa(ENDW_COMM,prod_comm,r0) = scaleXP(prod_comm)*evfa(ENDW_COMM,prod_comm,r0) ;

IF(m_CheckFile,
    execute_unload "%DirCheck%\check_scaleXP_%system.fn%.gdx", scaleXP, advTech;
) ;

*$GOTO EOF

*  Calculate the auxiliary variables

*   xp0: Gross output at agent prices (tax included) !! supply prices

voa(prod_comm,reg)
    = sum(i0,  vdfa(i0,prod_comm,reg) + vifa(i0,prod_comm,reg))
    + sum(fp0, evfa(fp0,prod_comm,reg)) ;

vom(trad_comm,reg)
    = sum(a0, vdfm(trad_comm,a0,reg))
	+ vdpm(trad_comm,reg) + vdgm(trad_comm,reg)
	+ sum(r0, vxmd(trad_comm,reg,r0)) ;

*   For margin commodities add the trade margins

vom(marg_comm,reg)   = vom(marg_comm,reg) + vst(marg_comm,reg) ;

osep(trad_comm,reg)  = voa(trad_comm,reg) - vom(trad_comm,reg) ;

* [OECD-ENV]: 2020-12-23 rationnalize power database

$IfTheni.power %IfPower%=="ON"

    vdfa("gas","GasBL",r0) $ voa("GasBL",r0)
        = vdfa("gas","CoalBL",r0) + vdfa("gas","GasBL",r0)
        + vdfa("gas","OilBL",r0)+ vdfa("gas","OilP",r0);
    vdfa("gdt","GasBL",r0) $ voa("GasBL",r0)
        = vdfa("gdt","CoalBL",r0) + vdfa("gdt","GasBL",r0)
        + vdfa("gdt","OilBL",r0)+ vdfa("gdt","OilP",r0);
    vifa("gas","GasBL",r0) $ voa("GasBL",r0)
        = vifa("gas","CoalBL",r0) + vifa("gas","GasBL",r0)
        + vifa("gas","OilBL",r0)+ vifa("gas","OilP",r0);
    vifa("gdt","GasBL",r0) $ voa("GasBL",r0)
        = vifa("gdt","CoalBL",r0) + vifa("gdt","GasBL",r0)
        + vifa("gdt","OilBL",r0)+ vifa("gdt","OilP",r0);

    vdfa("gas","CoalBL",r0) $ voa("CoalBL",r0) = 0 ;
    vdfa("gdt","CoalBL",r0) $ voa("CoalBL",r0) = 0 ;
    vifa("gas","CoalBL",r0) $ voa("CoalBL",r0) = 0 ;
    vifa("gdt","CoalBL",r0) $ voa("CoalBL",r0) = 0 ;

    vdfa("gas","OilBL",r0) $ voa("OilBL",r0) = 0 ;
    vdfa("gdt","OilBL",r0) $ voa("OilBL",r0) = 0 ;
    vifa("gas","OilBL",r0) $ voa("OilBL",r0) = 0 ;
    vifa("gdt","OilBL",r0) $ voa("OilBL",r0) = 0 ;
    vdfa("gas","OilP",r0)  $ voa("OilP",r0)  = 0 ;
    vdfa("gdt","OilP",r0)  $ voa("OilP",r0)  = 0 ;
    vifa("gas","OilP",r0)  $ voa("OilP",r0)  = 0 ;
    vifa("gdt","OilP",r0)  $ voa("OilP",r0)  = 0 ;

    vdfa("coa","CoalBL",r0) $ voa("CoalBL",r0)
        = vdfa("coa","CoalBL",r0)+vdfa("coa","GasBL",r0)+vdfa("coa","GasP",r0) ;
    vifa("coa","CoalBL",r0) $ voa("CoalBL",r0)
        = vifa("coa","CoalBL",r0)+vifa("coa","GasBL",r0)+vifa("coa","GasP",r0) ;

    vdfa("coa","GasP",r0)  $ voa("GasP",r0)  = 0;
    vifa("coa","GasP",r0)  $ voa("GasP",r0)  = 0;
    vdfa("coa","GasBL",r0) $ voa("GasBL",r0) = 0;
    vifa("coa","GasBL",r0) $ voa("GasBL",r0) = 0;

$EndIf.power

*------------------------------------------------------------------------------*
*                                                                              *
*   Declare the aggregated parameters                                          *
*       for a & i (original activities and commodities)                        *
*                                                                              *
*------------------------------------------------------------------------------*

alias(r,rp) ; alias(r,s) ; alias(r,d) ; alias(img,i) ;

parameters
   VDFM1(i, a, r)       "Domestic purchases, by firms, at market prices"
   VDFA1(i, a, r)       "Domestic purchases, by firms, at agents' prices"
   VIFM1(i, a, r)       "Import purchases, by firms, at market prices"
   VIFA1(i, a, r)       "Import purchases, by firms, at agents' prices"
   VFM1(fp, a, r)       "Primary factor purchases, by firms, at market prices"
   EVFA1(fp, a, r)      "Primary factor purchases, at agents' prices"
   EVOA1(fp, r)         "Primary factor sales, at agents' prices"
   VDPM1(i,r)           "Domestic purchases, by households, at market prices"
   VDPA1(i,r)           "Domestic purchases, by households, at agents' prices"
   VIPM1(i,r)           "Import purchases, by households, at market prices"
   VIPA1(i,r)           "Import purchases, by households, at agents' prices"
   VDGM1(i,r)           "Domestic purchases, by government, at market prices"
   VIGA1(i,r)           "Import purchases, by government, at agents' prices"
   VIGM1(i,r)           "Import purchases, by government, at market prices"
   VDGA1(i,r)           "Domestic purchases, by government, at agents' prices"
   VST1(i, r)           "Margin exports"
   VXMD1(i, s, d)       "Non-margin exports, at market prices"
   VXWD1(i, s, d)       "Non-margin exports, at world prices"
   VIWS1(i, s, d)       "Imports, at world prices"
   VIMS1(i, s, d)       "Imports, at market prices"
   VTWR1(img,i,s,d)     "Margins by margin commodity"
   SAVE1(r)             "Net saving, by region"
   VDEP1(r)             "Capital depreciation"
   VKB1(r)              "Capital stock"
   POP1(r)              "Population"

* OECD-ENV: add FBEP & FTRV

    FBEP1(fp,a,r)  "Gross Factor-Based Subsidies"
    FTRV1(fp,a,r)  "Gross Factor-Based Tax revenue"

*  Auxiliary variables

   voa1(a,r)               "Value of output pre-production tax"
   vom1(a,r)               "Value of output post-production tax"
   osep1(a, r)             "Value of production tax"
;

*  Aggregate the GTAP matrices

Agg3(vdfm,vdfm1,i0,i,mapa,a0,a,mapa,r0,r,mapr) ;
Agg3(vdfa,vdfa1,i0,i,mapa,a0,a,mapa,r0,r,mapr) ;
Agg3(vifm,vifm1,i0,i,mapa,a0,a,mapa,r0,r,mapr) ;
Agg3(vifa,vifa1,i0,i,mapa,a0,a,mapa,r0,r,mapr) ;
Agg3(vfm,vfm1,fp0,fp,mapf,i0,i,mapa,r0,r,mapr) ;
Agg3(evfa,evfa1,fp0,fp,mapf,i0,i,mapa,r0,r,mapr) ;
Agg2(evoa,evoa1,fp0,fp,mapf,r0,r,mapr) ;

Agg2(VDPM,VDPM1,i0,i,mapa,r0,r,mapr) ;
Agg2(VDPA,VDPA1,i0,i,mapa,r0,r,mapr) ;
Agg2(VIPM,VIPM1,i0,i,mapa,r0,r,mapr) ;
Agg2(VIPA,VIPA1,i0,i,mapa,r0,r,mapr) ;
Agg2(VDGM,VDGM1,i0,i,mapa,r0,r,mapr) ;
Agg2(VDGA,VDGA1,i0,i,mapa,r0,r,mapr) ;
Agg2(VIGM,VIGM1,i0,i,mapa,r0,r,mapr) ;
Agg2(VIGA,VIGA1,i0,i,mapa,r0,r,mapr) ;

Agg2(VST,VST1,i0,i,mapa,r0,r,mapr) ;
Agg3(VXMD,VXMD1,i0,i,mapa,r0,r,mapr,REG,rp,mapr) ;
Agg3(VXWD,VXWD1,i0,i,mapa,r0,r,mapr,REG,rp,mapr) ;
Agg3(VIWS,VIWS1,i0,i,mapa,r0,r,mapr,REG,rp,mapr) ;
Agg3(VIMS,VIMS1,i0,i,mapa,r0,r,mapr,REG,rp,mapr) ;

Agg4(VTWR,VTWR1,img0,img,mapa,i0,i,mapa,r0,r,mapr,REG,rp,mapr) ;

Agg1(SAVE,SAVE1,r0,r,mapr) ;
Agg1(VDEP,VDEP1,r0,r,mapr) ;
Agg1(VKB,VKB1,r0,r,mapr)   ;
Agg1(POP,POP1,r0,r,mapr)   ;

* [OECD-ENV]: add FBEP & FTRV

Agg3(FBEP,FBEP1,fp0,fp,mapf,a0,a,mapa,r0,r,mapr) ;
Agg3(FTRV,FTRV1,fp0,fp,mapf,a0,a,mapa,r0,r,mapr) ;

*------------------------------------------------------------------------------*

*  Move land to capital (ie merge land and capital payments) for example
*   if Food and crops/Livestock are together

PARAMETERS
   tvfm1(fp,r)
   kappa(fp,r) ;

tvfm1(fp,r) = sum(a, vfm1(fp,a,r)) ;
kappa(fp,r) $ tvfm1(fp,r) = 1 - evoa1(fp,r) / tvfm1(fp,r) ;

loop((cap,lnd,a)$mapt(a),

    evfa1(cap,a,r) = evfa1(cap,a,r) + evfa1(lnd,a,r) ;
    evfa1(lnd,a,r) = 0 ;
    vfm1(cap,a,r)  = vfm1(cap,a,r) + vfm1(lnd,a,r) ;

* Adjust income tax

    evoa1(cap,r)   = evoa1(cap,r) + (1-kappa(lnd,r))*vfm1(lnd,a,r) ;
    evoa1(lnd,r)   = evoa1(lnd,r) - (1-kappa(lnd,r))*vfm1(lnd,a,r) ;
    vfm1(lnd,a,r)  = 0 ;

) ;


*   Move natural resource to capital (ie merge NatRes and capital payments)
*   for example if Food and Fishing are together

loop((cap,nrs,a)$mapn(a),

    evfa1(cap,a,r) = evfa1(cap,a,r) + evfa1(nrs,a,r) ;
    evfa1(nrs,a,r) = 0 ;
    vfm1(cap,a,r)  = vfm1(cap,a,r) + vfm1(nrs,a,r) ;

* Adjust income tax

    evoa1(cap,r)   = evoa1(cap,r) + (1-kappa(nrs,r))*vfm1(nrs,a,r) ;
    evoa1(nrs,r)   = evoa1(nrs,r) - (1-kappa(nrs,r))*vfm1(nrs,a,r) ;
    vfm1(nrs,a,r)  = 0 ;

) ;

evoa1(fp,r) $ (abs(evoa1(fp,r)) lt 0.001) = 0 ;

voa1(a,r) = sum(i, vdfa1(i,a,r) + vifa1(i,a,r)) + sum(fp, evfa1(fp,a,r)) ;
vom1(i,r) = sum(a,vdfm1(i,a,r))+vdpm1(i,r)+vdgm1(i,r) + sum(rp,vxmd1(i,r,rp)) ;
vom1(img,r) = vom1(img,r) + vst1(img,r) ;
osep1(i,r)  = voa1(i,r) - vom1(i,r) ;

*  Save the data in a temporary \agg folder

$IF NOT DEXIST "%iDataDir%\agg" $call "mkdir %iDataDir%\agg"

*  Save the NIPA accounts for dis-aggregated and aggregated database
*  Save energy subsidies as well

$include "%DataDir%\nipa.gms"

*  Save the SAM if requested

file csv / "%DirCheck%\%Prefix%Agg.csv" / ;

SCALAR  ifFirstPass    / 1 / ;

$batinclude "%DataDir%\aggsam.gms" AggGTAP 1

*------------------------------------------------------------------------------*
*                                                                              *
*                      Aggregate GTAP parameters	                           *
*                                                                              *
*------------------------------------------------------------------------------*

* [OECD-ENV]: move here definition of etrae1 from map.gms file
* La valeur etrae1 est ensuite assigne etrae dans "%iDataDir%\agg\%Prefix%par.gdx"
* et donc ne tient pas compte de valeur dans base GTAP

parameter etrae1(fp) "CET transformation elasticities for factor allocation GTAP model" /
   $$Ifi %split_skill%=="2" UnSkLab   inf
   $$Ifi %split_skill%=="2" SkLab     inf
   $$Ifi %split_skill%=="1" Labour    inf
   Capital   inf
* [EditJean]: New Data by DvM: 1 for land and 0.001 for NatRes
    $$iftheni.ifLU "%LU%" == "ON"
        AEZ1 1
        AEZ2 1
        AEZ3 1
        AEZ4 1
        AEZ5 1
        AEZ6 1
    $$else.ifLU
        Land 1
    $$endif.ifLU
   NatRes   0.001
/ ;

parameters
   ESUBT(PROD_COMM)        "GTAP: Top level production elasticity"
   ESUBVA(PROD_COMM)       "GTAP: Inter-factor substitution elasticity"
   ESUBD(TRAD_COMM)        "GTAP: Top level Armington elasticity"
   ESUBM(TRAD_COMM)        "GTAP: Second level Armington elasticity"
   INCPAR(TRAD_COMM, REG)  "GTAP: CDE expansion parameter"
   SUBPAR(TRAD_COMM, REG)  "GTAP: CDE substitution parameter"
   ETRAE(ENDW_COMM)        "GTAP: CET transformation elasticities for factors"
   RORFLEX(REG)            "GTAP: Flexibility of expected net ROR wrt investment"
;

***HRR: esub have regional dimension in GTAPv11c, so I added these intermediate parameters
$$IfTheni.esub %GTAPBASE%=="GSDF"
parameters
   ESUBT_int (PROD_COMM,REG)        "GTAP: Top level production elasticity"
   ESUBVA_int(PROD_COMM,REG)       "GTAP: Inter-factor substitution elasticity"
   ESUBD_int (TRAD_COMM,REG)        "GTAP: Top level Armington elasticity"
   ESUBM_int (TRAD_COMM,REG)        "GTAP: Second level Armington elasticity"
   ETRAE_int (ENDW_COMM,REG)        "GTAP: CET transformation elasticities for factors"
;
$$EndIf.esub
***endHRR



*  Load the GTAP parameters

***HRR: loading new esub variables
$IfTheni.esub2 %GTAPBASE%=="GSDF"

execute_loaddc "%iGdxDir_GtapDB%\%GTAPBASE%par.gdx",
   ESUBT_int=ESUBT, ESUBVA_int=ESUBVA, ESUBD_int=ESUBD, ESUBM_int=ESUBM, INCPAR, SUBPAR, ETRAE_int=ETRAE, RORFLEX ;

$Else.esub2

*  Load the GTAP parameters


execute_loaddc "%iGdxDir_GtapDB%\%GTAPBASE%par.gdx",
   ESUBT, ESUBVA, ESUBD, ESUBM, INCPAR, SUBPAR, ETRAE, RORFLEX ;
$EndIf.esub2

*** Link new to old esub (using AUS values: equal for all countries, so doesn't matter)
   ESUBT(PROD_COMM )  =   ESUBT_int (PROD_COMM,"aus") ;
   ESUBVA(PROD_COMM)  =   ESUBVA_int(PROD_COMM,"aus") ;
   ESUBD(TRAD_COMM )  =   ESUBD_int (TRAD_COMM,"aus") ;
   ESUBM(TRAD_COMM )  =   ESUBM_int (TRAD_COMM,"aus") ;
   ETRAE(ENDW_COMM )  =   ETRAE_int (ENDW_COMM,"aus") ;
***endHRR

*  Aggregate to intermediate levels

parameters
   ESUBT1(a)            "Model: Top level production elasticity"
   ESUBVA1(a)           "Model: Inter-factor substitution elasticity"
   ESUBD1(i)            "Model: Top level Armington elasticity"
   ESUBM1(i)            "Model: Second level Armington elasticity"
   INCPAR1(i,r)         "Model: CDE expansion parameter"
   SUBPAR1(i,r)         "Model: CDE substitution parameter"
   ETRAE1(fp)           "Model: CET transformation elasticities for factors"
   RORFLEX1(r)          "Model: Flexibility of expected net ROR wrt investment"
   RDLT1                "Model: Binary switch mechanism of allocating investment funds"
;

*  Aggregate the data

*  ESUBT -- use world output as weight

esubt1(a) = sum(mapa(a0,a), sum(reg, voa(a0, reg))) ;
esubt1(a)$esubt1(a) = sum(a0$mapa(a0,a),
      ESUBT(a0)*sum(reg, voa(a0, reg))) / esubt1(a) ;

*  ESUBVA -- use world value added at agents prices as weight

esubva1(a) = sum(a0$mapa(a0,a), sum((reg,fp0), evfa(fp0, a0, reg))) ;
esubva1(a)$esubva1(a) = sum(a0$mapa(a0,a),
   ESUBVA(a0)*sum((reg,fp0), evfa(fp0, a0, reg))) / esubva1(a) ;

*  ESUBD -- Use global aggregate Armington demand

esubd1(i) = sum(mapa(i0,i), sum(reg, sum(a0, vdfa(i0,a0,reg) + vifa(i0,a0,reg))
          +                                     vdpa(i0,reg) + vipa(i0,reg)
          +                                     vdga(i0,reg) + viga(i0,reg))) ;
esubd1(i) $ esubd1(i)
          =sum(mapa(i0,i),
            ESUBD(i0)*(sum(reg, sum(a0, vdfa(i0,a0,reg )+ vifa(i0,a0,reg))
          +                                     vdpa(i0,reg) + vipa(i0,reg)
          +                                     vdga(i0,reg) + viga(i0,reg))) )
          / esubd1(i) ;

*  ESUBM -- Use global aggregate import demand

esubm1(i) = sum(mapa(i0,i), sum(reg, sum(a0, vifa(i0,a0,reg))
          +                                     vipa(i0,reg)
          +                                     viga(i0,reg))) ;
esubm1(i) $ esubm1(i)
          = sum(mapa(i0,i), ESUBM(i0)*(sum(reg, sum(a0, vifa(i0,a0,reg))
          +                                     vipa(i0,reg)
          +                                     viga(i0,reg))) )
          / esubm1(i) ;

*  INCPAR, SUBPAR -- Use regional private demand at agents' prices

incpar1(i,r) = sum((i0,r0)$(mapa(i0,i) and mapr(r0,r)), vdpa(i0,r0) + vipa(i0,r0)) ;
subpar1(i,r) = incpar1(i,r) ;
incpar1(i,r)$incpar1(i,r)
          = sum((i0,r0)$(mapa(i0,i) and mapr(r0,r)), INCPAR(i0,r0)*(vdpa(i0,r0) + vipa(i0,r0)))
          / incpar1(i,r) ;
subpar1(i,r)$subpar1(i,r)
          = sum((i0,r0)$(mapa(i0,i) and mapr(r0,r)), SUBPAR(i0,r0)*(vdpa(i0,r0) + vipa(i0,r0)))
          / subpar1(i,r) ;

*  Aggregate to final level (with regional subscripts)

$OnText
*  Aggregate the data

*  ESUBT -- use world output as weight

esubt1(actf) = sum((a0,i)$(mapa(a0,i) and mapaf(i,actf)), sum(reg, voa(a0, reg))) ;
esubt1(actf)$esubt1(actf,r) = sum((a0,i)$(mapa(a0,i) and mapaf(i,actf)),
      ESUBT(a0)*sum(reg, voa(a0, reg))) / esubt1(actf) ;

*  ESUBVA -- use world value added at agents' prices as weight

esubva1(actf,r) = sum((a0,i)$(mapa(a0,i) and mapaf(i,actf)), sum((reg,fp0), evfa(fp0, a0, reg))) ;
esubva1(actf,r)$esubva1(actf,r) = sum((a0,i)$(mapa(a0,i) and mapaf(i,actf)),
   ESUBVA(a0)*sum((reg,fp0), evfa(fp0, a0, reg))) / esubva1(actf,r) ;

*  ESUBD -- Use global aggregate Armington demand

esubd1(commf,r) = sum((i0,i)$(mapa(i0,i) and mapIF(i,commf)), sum(reg, sum(a0, vdfa(i0,a0,reg) + vifa(i0,a0,reg))
          +                                     vdpa(i0,reg) + vipa(i0,reg)
          +                                     vdga(i0,reg) + viga(i0,reg))) ;
esubd1(commf,r)$esubd1(commf,r)
          = sum((i0,i)$(mapa(i0,i) and mapIF(i,commf)), ESUBD(i0)*(sum(reg, sum(a0, vdfa(i0,a0,reg )+ vifa(i0,a0,reg))
          +                                     vdpa(i0,reg) + vipa(i0,reg)
          +                                     vdga(i0,reg) + viga(i0,reg))))
          / esubd1(commf,r) ;

*  ESUBM -- Use global aggregate import demand

esubm1(commf,r) = sum((i0,i)$(mapa(i0,i) and mapIF(i,commf)), sum(reg, sum(a0, vifa(i0,a0,reg))
          +                                     vipa(i0,reg)
          +                                     viga(i0,reg))) ;
esubm1(commf,r)$esubm1(commf,r)
          = sum((i0,i)$(mapa(i0,i) and mapIF(i,commf)), ESUBM(i0)*(sum(reg, sum(a0, vifa(i0,a0,reg))
          +                                     vipa(i0,reg)
          +                                     viga(i0,reg))))
          / esubm1(commf,r) ;

*  INCPAR, SUBPAR -- Use regional private demand at agents' prices

incpar1(commf,r) = sum((i0,i,r0)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)), vdpa(i0,r0) + vipa(i0,r0)) ;
subpar1(commf,r) = incpar1(commf,r) ;
incpar1(commf,r)$incpar1(commf,r)
          = sum((i0,i,r0)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)), INCPAR(i0,r0)*(vdpa(i0,r0) + vipa(i0,r0)))
          / incpar1(commf,r) ;
subpar1(commf,r)$subpar1(commf,r)
          = sum((i0,i,r0)$(mapa(i0,i) and mapIF(i,commf) and mapr(r0,r)), SUBPAR(i0,r0)*(vdpa(i0,r0) + vipa(i0,r0)))
          / subpar1(commf,r) ;
$OffText

*  RORFLEX -- Use regional level of capital stock

RORFLEX1(r) = sum(r0$mapr(r0,r), vkb(r0)) ;
RORFLEX1(r)$RORFLEX1(r) =sum(r0$mapr(r0,r), RORFLEX(r0)*vkb(r0)) / RORFLEX1(r) ;

*------------------------------------------------------------------------------*
*                                                                              *
*               Aggregate energy data (in volume)                              *
*                                                                              *
*------------------------------------------------------------------------------*

***HRR
alias(ERG_COMM,ERG);

PARAMETERS

*   GTAP database

    EDF(ERG_COMM,PROD_COMM,REG) "GTAP: Usage of domestic products by firm"
    EIF(ERG_COMM,PROD_COMM,REG) "GTAP: Usage of imported products by firm"	!! EMF
    EDP(ERG_COMM,REG)           "GTAP: Private consumption of domestic goods"
    EIP(ERG_COMM,REG)           "GTAP: Private consumption of imported goods" !! EMP
    EDG(ERG_COMM,REG)           "GTAP: Public consumption of domestic goods"
    EIG(ERG_COMM,REG)           "GTAP: Public consumption of imported goods" !! EDI
    EXIDAG(ERG_COMM,REG,REG)    "GTAP: Bilateral trade in energy" !! EXI

    $$IfTheni.GTAP %GTAPBASE%=="GSDF"
		EDI(ERG,REG)            "Investment consumption of domestic goods"
		EMI(ERG,REG)            "Investment consumption of imported goods"
    $$EndIf.GTAP

*   Model database

    EDF1(i,a,r)     "Model: Usage of domestic products by firm"
    EIF1(i,a,r)     "Model: Usage of imported products by firm"
    EDP1(i,r)       "Model: Private consumption of domestic goods"
    EIP1(i,r)       "Model: Private consumption of imported goods"
    EDG1(i,r)       "Model: Public consumption of domestic goods"
    EIG1(i,r)       "Model: Public consumption of imported goods"
    EXIDAG1(i,r,rp) "Model: Bilateral trade in energy"

;

execute_loaddc "%iGdxDir_GtapDB%\%GTAPBASE%vole.gdx",
	EXIDAG=EXI, EDF, EDG, EDP,
    $$IfTheni.GTAP %GTAPBASE%=="GSD"
		EIF, EIP, EIG
    $$ElseIf.GTAP %GTAPBASE%=="GSDF"
		EIF=EMF, EIP=EMP, EIG=EMG,
		EDI, EMI
    $$Else.GTAP
		check
    $$EndIf.GTAP
	 ;

$IfTheni.GTAP %GTAPBASE%=="GSDF"
***HRR: added _comm in the second expression
***not accurate	EDF(ERG_COMM,CGDS0,REG) = EDI(ERG_COMM,REG) ;
***not accurate	EIF(ERG_COMM,CGDS0,REG) = EMI(ERG_COMM,REG) ;
$EndIf.GTAP

Agg3(edf,edf1,erg_comm,i,mapa,a0,a,mapa,r0,r,mapr) ;
Agg3(eif,eif1,erg_comm,i,mapa,a0,a,mapa,r0,r,mapr) ;
Agg2(edp,edp1,erg_comm,i,mapa,r0,r,mapr) ;
Agg2(eip,eip1,erg_comm,i,mapa,r0,r,mapr) ;
Agg2(edg,edg1,erg_comm,i,mapa,r0,r,mapr) ;
Agg2(eig,eig1,erg_comm,i,mapa,r0,r,mapr) ;
Agg3(exidag,exidag1,erg_comm,i,mapa,r0,r,mapr,REG,rp,mapr) ;


edf1(i,a,r)     $ (vom1(i,r) = 0) = 0 ;
edp1(i,r)       $ (vom1(i,r) = 0) = 0 ;
edg1(i,r)       $ (vom1(i,r) = 0) = 0 ;
exidag1(i,r,rp) $ (vom1(i,r) = 0) = 0 ;

* ------------------------------------------------------------------------------
*
*  Aggregate CO2 Emissions from Fuel Combustion
*
* ------------------------------------------------------------------------------

*  CO2 Emission matrices

***HRR
alias(FUEL_COMM,FUEL);

PARAMETERS

*   GTAP database

    MDF(FUEL_COMM, PROD_COMM, r0) "GTAP: Emissions from domestic product in current production, .."
    MIF(FUEL_COMM, PROD_COMM, r0) "GTAP: Emissions from imported product in current production, .."
    MDP(FUEL_COMM,r0)             "GTAP: Emissions from private consumption of domestic product, Mt CO2"
    MIP(FUEL_COMM,r0)             "GTAP: Emissions from private consumption of imported product, Mt CO2"
    MDG(FUEL_COMM,r0)             "GTAP: Emissions from govt consumption of domestic product, Mt CO2"
    MIG(FUEL_COMM,r0)             "GTAP: Emissions from govt consumption of imported product, Mt CO2"

    $$IfTheni.GTAP %GTAPBASE%=="GSDF"
***HRR: changes ERG for FUEL
		MDI(FUEL,REG)  	"GTAP: Emissions from Investment of domestic product, Mt CO2"
		MMI(FUEL,REG) 	"GTAP: Emissions from Investment of imported product, Mt CO2"
    $$EndIf.GTAP

*   Model database

    MDF1(i,a,r) "Model: Emissions from domestic product in current production, .."
    MIF1(i,a,r) "Model: Emissions from imported product in current production, .."
    MDP1(i,r)   "Model: Emissions from private consumption of domestic product, Mt CO2"
    MIP1(i,r)   "Model: Emissions from private consumption of imported product, Mt CO2"
    MDG1(i,r)   "Model: Emissions from govt consumption of domestic product, Mt CO2"
    MIG1(i,r)   "Model: Emissions from govt consumption of imported product, Mt CO2"
;

*	Load Emissions from Fuel Combustion data

execute_loaddc "%iGdxDir_GtapDB%\%GTAPBASE%emiss.gdx",
	MDF, MDG, MDP
    $$IfTheni.GTAP %GTAPBASE%=="GSD"
		MIF, MIP, MIG
    $$ELSEIF.GTAP %GTAPBASE%=="GSDF"
		MIF=MMF, MIP=MMP, MIG=MMG,
		MDI, MMI
    $$ELSE.GTAP
		check
    $$EndIf.GTAP
	 ;

$IfTheni.GTAP %GTAPBASE%=="GSDF"
*hrr:	MDF(FUEL_COMM,CGDS0,REG) = MDI(ERG,REG) ;
*hrr:	MIF(FUEL_COMM,CGDS0,REG) = MMI(ERG,REG) ;
MDF(FUEL_COMM,CGDS0,REG) = MDI(FUEL_COMM,REG) ;
MIF(FUEL_COMM,CGDS0,REG) = MMI(FUEL_COMM,REG) ;

$EndIf.GTAP

Agg3(mdf,mdf1,fuel_comm,i,mapa,a0,a,mapa,r0,r,mapr) ;
Agg3(mif,mif1,fuel_comm,i,mapa,a0,a,mapa,r0,r,mapr) ;
Agg2(mdp,mdp1,fuel_comm,i,mapa,r0,r,mapr) ;
Agg2(mip,mip1,fuel_comm,i,mapa,r0,r,mapr) ;
Agg2(mdg,mdg1,fuel_comm,i,mapa,r0,r,mapr) ;
Agg2(mig,mig1,fuel_comm,i,mapa,r0,r,mapr) ;

* [OECD-ENV]:  Extract full database for verification

$IF SET DebugDir $include "%DebugDir%\Extract_Main_GTAP.gms"

*------------------------------------------------------------------------------*
*       Calculate the energy content of fossil fuel consumption                *
*------------------------------------------------------------------------------*

*  THIS IS A QUICK FIX AND NEEDS REVIEW

set etr(f0) "Which fuels"      / coa, oil, gas, p_c, gdt / ;

set itr(a0) "Which activities" / oil, p_c, %chm% / ;

parameters
   eaf(i0,i0,r0)     "Armington energy consumption by firms"
   phiNRG(f0,i0,r0)  "Rate of burning of fossil fuels"
   nrgCUMB(f0,i0,r0) "Energy cumbusted"
   nrgCUMB1(i,a,r)   "Aggregated cumbusted energy"
;

parameters co2_mtoe(f0) "Standard emissions coefficients" /
    coa   3.881135
    oil   3.03961
    gas   2.22606
    p_c   2.89167
    gdt   2.22606
/ ;

*  Convert to c_mtoe

co2_mtoe(f0) = co2_mtoe(f0)*12/44 ;

*  Total energy

eaf(e0,i0,r0) = edf(e0,i0,r0) + eIF(e0,i0,r0) ;

*  Calculate cumbustion based on the standard emissions coefficient

nrgCUMB(f0,i0,r0)
    = ((mdf(f0,i0,r0)+mIF(f0,i0,r0))/co2_mtoe(f0))$(etr(f0) and itr(i0))
    +  eaf(f0,i0,r0)$(not (etr(f0) and itr(i0))) ;

*  Cap combustion to actual energy consumption
nrgCUMB(f0,i0,r0) = eaf(f0,i0,r0)$(nrgCUMB(f0,i0,r0) > eaf(f0,i0,r0))
                  + nrgCUMB(f0,i0,r0)$(nrgCUMB(f0,i0,r0) <= eaf(f0,i0,r0))
                  ;

*  Aggregate
nrgCUMB1(i,a,r)
    = sum((r0,f0,i0) $ (mapr(r0,r) and mapa(f0,i) and mapa(i0,a)),
            nrgCUMB(f0,i0,r0)) ;

$OnText
file xcsv / nrgCumb.csv / ;
put xcsv ;
put "Var,Region,Input,Activity,Value" / ;
xcsv.pc=5 ;
xcsv.nd=9 ;

loop((f0,i0,r0),
   put "MDF",r0.tl,f0.tl,i0.tl,mdf(f0,i0,r0) / ;
   put "MIF",r0.tl,f0.tl,i0.tl,mIF(f0,i0,r0) / ;
   put "EDF",r0.tl,f0.tl,i0.tl,edf(f0,i0,r0) / ;
   put "EIF",r0.tl,f0.tl,i0.tl,eIF(f0,i0,r0) / ;
   put "EAF",r0.tl,f0.tl,i0.tl,eaf(f0,i0,r0) / ;
   put "nrgCumb",r0.tl,f0.tl,i0.tl,nrgCumb(f0,i0,r0) / ;
) ;
loop((i,a,r),
   put "MDF1",r.tl,i.tl,a.tl,mdf1(i,a,r) / ;
   put "MIF1",r.tl,i.tl,a.tl,mif1(i,a,r) / ;
   put "EDF1",r.tl,i.tl,a.tl,edf1(i,a,r) / ;
   put "EIF1",r.tl,i.tl,a.tl,eif1(i,a,r) / ;
) ;
loop((i,a,r),
   put "nrgCumb1",r.tl,i.tl,a.tl,nrgCumb1(i,a,r) / ;
) ;

putclose xcsv ;
$OffText


*	!!!!	  Load and aggregate GTAP satellite accounts if requested

Scalars
	EmiOAP / 0 /
	EmiGHG / 0 /
;

$IfTheni.nco2DB "%NCO2%"=="ON"

*------------------------------------------------------------------------------*
*                                                                              *
* Non-CO2 and OAP emissions data + Merged (or not) with OAP in same variable   *
*                                                                              *
*------------------------------------------------------------------------------*

*------------------------------------------------------------------------------*
* 		 A.) 	Non-CO2 emission from fuel combustion matrices	    		   *
*------------------------------------------------------------------------------*

	EmiGHG = 1 ;


* Memo: _CEQ : in Million tonne of CO2 eq. / alternative Gg
* NC_TRAD: emissions of "CO2" & "N2O" related to use of "p_c", "bph" and "chm"

    PARAMETERS

*   GTAP database

        NC_QO_CEQ(AllEmissions,PROD_COMM,REG)             "Non-CO2 emissions assoc. with output by industries-M. .."
        NC_ENDW_CEQ(AllEmissions,ENDW_COMM,PROD_COMM,REG) "Non-CO2 emissions assoc. with endowment .."
        NC_TRAD_CEQ(AllEmissions,TRAD_COMM,PROD_COMM,REG) "CO2 and N2O emiss. assoc. with non-fossil input use by firm (expressed in CO2eq.)"
        NC_HH_CEQ(AllEmissions,TRAD_COMM,REG)             "CO2 and N2O emiss. assoc. with non-fossil input use by Household (expressed in CO2eq.)"
        NC_QO(AllEmissions,PROD_COMM,REG)                 "Non-CO2 emissions assoc. with output by industries-M. .."
        NC_ENDW(AllEmissions,ENDW_COMM,PROD_COMM,REG)     "Non-CO2 emissions assoc. with endowment .."
        NC_TRAD(AllEmissions,TRAD_COMM,PROD_COMM,REG)     "CO2 and N2O emiss. assoc. with non-fossil input use by firm"
        NC_HH(AllEmissions,TRAD_COMM,REG)                 "CO2 and N2O emiss. assoc. with non-fossil input use by Household"

        $$IFi %GTAP_ver%=="10.1" NC_TRAD_CEQ_bis(AllEmissions,TRAD_COMM,PROD_COMM,REG) "CH4 and N2O emiss. assoc. with fossil input use by firm (expressed in CO2eq.)"
        $$IFi %GTAP_ver%=="10.1" NC_TRAD_bis(AllEmissions,TRAD_COMM,PROD_COMM,REG)	   "CH4 and N2O emiss. assoc. with fossil input use by firm"

*HRR: added
        $$IFi %GTAP_ver%=="11c" NC_TRAD_CEQ_bis(AllEmissions,TRAD_COMM,PROD_COMM,REG) "CH4 and N2O emiss. assoc. with fossil input use by firm (expressed in CO2eq.)"
        $$IFi %GTAP_ver%=="11c" NC_TRAD_bis(AllEmissions,TRAD_COMM,PROD_COMM,REG)	   "CH4 and N2O emiss. assoc. with fossil input use by firm"



        $$ifTheni.gtap10 NOT %GTAP_ver%=="92"
            GWPARS(AllEmissions,r0,IPCC_REP)             "Global warming potentials by IPPC ARs for 20%YearGTAP%, CO2=1 [GWPS:NCGHG*REG*IPCC_REP]"
            GHGLU_CEQ(AllEmissions,LU_CAT,LU_SUBCAT,REG) "Land use emissions in 20%YearGTAP%, mil tCO2-eq. [NCLU:LUGHG*LU_CAT*LU_SUBCAT*REG]"
            GHGLU(AllEmissions,LU_CAT,LU_SUBCAT,REG)     "Land use emissions in 20%YearGTAP%, Gg [NCLU:LUGHG*LU_CAT*LU_SUBCAT*REG]"
            TOTNC(em,TRAD_COMM,REG)                      "Aggregate Non-CO2 emissions in 20%YearGTAP% (excluding land use), Gg "
            TOTNC_CEQ(em,TRAD_COMM,REG)                  "Aggregate Non-CO2 emissions in 20%YearGTAP% (excluding land use), mil tCO2-eq."
        $$endif.gtap10

*   Model database

        NC_QO_CEQ1(AllEmissions,a,r)      "Non-CO2 emissions assoc. with output by industries-M. .."
        NC_ENDW_CEQ1(AllEmissions,fp,a,r) "Non-CO2 emissions assoc. with endowment .."
        NC_TRAD_CEQ1(AllEmissions,i,a,r)  "Non-CO2 emissions assoc. with input use.."
        NC_HH_CEQ1(AllEmissions,i,r)      "Non-CO2 emissions assoc. with input use by households-.."
        NC_QO1(AllEmissions,a,r)          "Non-CO2 emissions assoc. with output by industries-M. .."
        NC_ENDW1(AllEmissions,fp,a,r)     "Non-CO2 emissions assoc. with endowment .."
        NC_TRAD1(AllEmissions,i,a,r)      "Non-CO2 emissions assoc. with input use.."
        NC_HH1(AllEmissions,i,r)          "Non-CO2 emissions assoc. with input use by households-.."

        $$ifTheni.gtap10 NOT %GTAP_ver%=="92"
            GWPARS1(AllEmissions,r,IPCC_REP) "Global warming potentials by IPPC ARs for 20%YearGTAP%, CO2=1 [GWPS:NCGHG*r*IPCC_REP]"
            TOTNC1(em,a,r)                   "Aggregate emissions in 20%YearGTAP% (excluding land use), Gg "
            TOTNC_CEQ1(em,a,r)               "Aggregate emissions in 20%YearGTAP% (excluding land use), mil tCO2-eq."
            LandUseEmi(AllEmissions,EmiSource,a0,r0)     "Lulucf & Forestry/Biomass burning emissions, Gg"
            LandUseEmi_CEQ(AllEmissions,EmiSource,a0,r0) "Lulucf & Forestry/Biomass burning emissions, mil tCO2-eq."
            LandUseEmi1(AllEmissions,EmiSource,a,r)             "Lulucf & Forestry/Biomass burning emissions, Gg"
            LandUseEmi_CEQ1(AllEmissions,EmiSource,a,r)         "Lulucf & Forestry/Biomass burning emissions, mil tCO2-eq."
        $$endif.gtap10
    ;

*	Load different data and do different manipulations across GTAP versions

    $$IfTheni.gtap92 %GTAP_ver%=="92"

*	Load Non-CO2 emissions for GTAP9: from gdx file "SatAcc\nco2.dx"

        execute_loaddc "%FolderGTAP%\SatAcc\nco2.gdx",
            NC_TRAD, NC_ENDW, NC_QO, NC_HH, NC_TRAD_CEQ,
            NC_ENDW_CEQ, NC_QO_CEQ, NC_HH_CEQ ;

    $$EndIf.gtap92

	$$IfTheni.gtapNew NOT %GTAP_ver%=="92"

        $$IfTheni.GTAP11 %GTAP_ver%=="11c"

*	Load Non-CO2 & Air Pollutant emissions for GTAP11

* for GTAP11 NC_TRAD_bis also include biomass +  units are now mmt and not Gg

			execute_loaddc "%iGdxDir_GtapDB%\%GTAPBASE%nco2.gdx",
				NC_ENDW=EMI_ENDW, NC_HH=EMI_HH, NC_TRAD_bis=EMI_IO,
				NC_TRAD=EMI_IOP,  GHGLU=EMI_LU, NC_QO=EMI_QO, GWPARS=GWP ;

			NC_ENDW(AllEmissions,fp0,a0,r0)
				= 1000 * NC_ENDW(AllEmissions,fp0,a0,r0) ;
			NC_HH(AllEmissions,i0,r0)
				= 1000 * NC_HH(AllEmissions,i0,r0) ;
			NC_TRAD_bis(AllEmissions,i0,a0,r0)
				= 1000 * NC_TRAD_bis(AllEmissions,i0,a0,r0) ;
			NC_TRAD(AllEmissions,i0,a0,r0)
				= 1000 * NC_TRAD(AllEmissions,i0,a0,r0) ;
			GHGLU(AllEmissions,LU_CAT,LU_SUBCAT,r0)
				= 1000 * GHGLU(AllEmissions,LU_CAT,LU_SUBCAT,r0) ;
			NC_QO(AllEmissions,a0,r0)
				= 1000 * NC_QO(AllEmissions,a0,r0) ;

        $$EndIf.GTAP11

        $$IfTheni.GTAP10 NOT %GTAP_ver%=="11c"

* Load emissions from non-CO2 from fuel combustion for GTAP10

        $$IFi %GTAP_ver%=="10a"  execute_loaddc "%FolderGTAP%\SatAcc\nco2.gdx",
        $$IFi %GTAP_ver%=="10.1" execute_loaddc "%FolderGTAP%\GTAP\%GTAPBASE%nco2.gdx",
            NC_HH       = NC_QP_%YearGTAP%
            NC_HH_CEQ   = NC_QP_CEQ_%YearGTAP%
            NC_QO       = NC_QO_%YearGTAP%
            NC_QO_CEQ   = NC_QO_CEQ_%YearGTAP%
            NC_ENDW     = NC_QE_%YearGTAP%
            NC_ENDW_CEQ = NC_QE_CEQ_%YearGTAP%

            $$IFi %GTAP_ver%=="10a" NC_TRAD          = NC_QF_%YearGTAP%
            $$IFi %GTAP_ver%=="10a" NC_TRAD_CEQ      = NC_QF_CEQ_%YearGTAP%

            $$IFi %GTAP_ver%=="10.1" NC_TRAD         = NC_QFX_%YearGTAP%
            $$IFi %GTAP_ver%=="10.1" NC_TRAD_CEQ     = NC_QFX_CE_%YearGTAP%
            $$IFi %GTAP_ver%=="10.1" NC_TRAD_bis     = NC_QFF_%YearGTAP%
            $$IFi %GTAP_ver%=="10.1" NC_TRAD_CEQ_bis = NC_QFF_CE_%YearGTAP%

*	2023 summer

            GWPARS 	  = GWPARS_%YearGTAP%
			GHGLU_CEQ = GHGLU_CEQ_%YearGTAP%
			GHGLU 	  = GHGLU_%YearGTAP%
            TOTNC 	  = TOTNC_%YearGTAP%
			TOTNC_CEQ = TOTNC_CEQ_%YearGTAP%
        ;

        $$EndIf.GTAP10

*	[OECD-ENV]:	Data manipulations

* 1.)	merge emission use of fossil burning (NC_TRAD_bis)
* with emission associated with other input uses (NC_TRAD)
* This imply a loss of information for "p_c", "bph" and "chm"

        $$IfTheni.GTAP101 %GTAP_ver%=="10.1"
            NC_TRAD(em,i0,a0,r0)
                = NC_TRAD(em,i0,a0,r0) + NC_TRAD_bis(em,i0,a0,r0) ;
            NC_TRAD_CEQ(em,i0,a0,r0)
                = NC_TRAD_CEQ(em,i0,a0,r0) + NC_TRAD_CEQ_bis(em,i0,a0,r0) ;
        $$Endif.GTAP101

		$$IfTheni.GTAP11 %GTAP_ver%=="11c"
			NC_TRAD(em,i0,a0,r0)
				= NC_TRAD(em,i0,a0,r0) + NC_TRAD_bis(em,i0,a0,r0) ;
        $$Endif.GTAP11

* 2.)	Crop/Forest Burning & Lulucf emissions

        LandUseEmi(em,"lulucf","frs",r0)
            = GHGLU(em,"FrsLand","FrsLand",r0)
            + GHGLU(em,"FrsLand","FrsConv",r0) ; !! CO2 only

* All below no more in GTAP V11c: why?

        LandUseEmi(em,"lulucf",acr0,r0) $ sum(acr0.local,EVFA("Land",acr0,r0))
            = GHGLU(em,"CrpLand","CrpSoil",r0)
            * EVFA("Land",acr0,r0)
            / sum(acr0.local,EVFA("Land",acr0,r0)) ;
        LandUseEmi(em,"lulucf",alv0,r0)
            $ sum(alv0.local,EVFA("Land",alv0,r0))
            = GHGLU(em,"GrsLand","GrsSoil",r0)
            * EVFA("Land",alv0,r0)
            / sum(alv0.local,EVFA("Land",alv0,r0)) ;

        LandUseEmi_CEQ(em,"lulucf",a0,r0) $ LandUseEmi(em,"lulucf",a0,r0)
            = LandUseEmi(em,"lulucf",a0,r0) / 1000;

* 3.)	allocate GTAP Crop Burning soruces to "AgrBurn"

        LandUseEmi(em,"AgrBurn",acr0,r0) $ sum(acr0.local,EVFA("Land",acr0,r0))
            = GHGLU(em,"BrnBiom","OrgSoil",r0)
            * EVFA("Land",acr0,r0)
            / sum(acr0.local,EVFA("Land",acr0,r0)) ;
        LandUseEmi(em,"AgrBurn","frs",r0)
            = GHGLU(em,"BrnBiom","TropFrs",r0)
            + GHGLU(em,"BrnBiom","OthrFrs",r0);
            
***HRR: there is no GHGLU_CEQ in v11


        $$IfThen.GTAP11_01 NOT %GTAP_ver%=="11c"           
            LandUseEmi_CEQ(em,"AgrBurn",acr0,r0) $ sum(acr0.local,EVFA("Land",acr0,r0))
                = GHGLU_CEQ(em,"BrnBiom","OrgSoil",r0)
                * EVFA("Land",acr0,r0)
                / sum(acr0.local,EVFA("Land",acr0,r0)) ;
            LandUseEmi_CEQ(em,"AgrBurn","frs",r0)
                = GHGLU_CEQ(em,"BrnBiom","TropFrs",r0)
                + GHGLU_CEQ(em,"BrnBiom","OthrFrs",r0);
        $$EndIf.GTAP11_01
        $$IfThen.GTAP11_02 %GTAP_ver%=="11c"
            LandUseEmi_CEQ(em,"AgrBurn",acr0,r0) $ sum(acr0.local,EVFA("Land",acr0,r0))
                = GHGLU(em,"BrnBiom","OrgSoil",r0)
                * EVFA("Land",acr0,r0)
                / sum(acr0.local,EVFA("Land",acr0,r0)) ;
            LandUseEmi_CEQ(em,"AgrBurn","frs",r0)
                = GHGLU(em,"BrnBiom","TropFrs",r0)
                + GHGLU(em,"BrnBiom","OthrFrs",r0);
        $$EndIf.GTAP11_02
***endHRR

	$$EndIf.gtapNew

* 4.)	Allocate Non-CO2 emissions to Power sectors

* Before #rev452 (2023-10-09) there was a mistake in NC_TRAD and NC_TRAD_EQ

* Memo: now done for GTAP V11, so useless

    $$IfTheni.power %ifPower%=="ON"

        $$IfTheni.OldGtap1 NOT %GTAP_ver%=="11c"

* weight used: CO2 emissions from fuel combustion in power sectors

			NC_TRAD(emn,f0,elya0,r0)
				$ sum(elya0.local,MDF(f0,elya0,r0)+MIF(f0,elya0,r0))
				= NC_TRAD(emn,f0,"ely",r0)
				* [MDF(f0,elya0,r0) + MIF(f0,elya0,r0)]
				/ sum(elya0.local,MDF(f0,elya0,r0)+MIF(f0,elya0,r0)) ;

			NC_TRAD_CEQ(emn,f0,elya0,r0)
				$ sum(elya0.local,MDF(f0,elya0,r0)+MIF(f0,elya0,r0))
				= NC_TRAD_CEQ(emn,f0,"ely",r0)
				* [MDF(f0,elya0,r0) + MIF(f0,elya0,r0)]
				/ sum(elya0.local,MDF(f0,elya0,r0)+MIF(f0,elya0,r0)) ;

* Aggregate ely emission (weight used: output): [EditJean] why do we need that ?

			TOTNC(em,powi0,r0) $ sum(powi0.local,voa(powi0,r0))
				= TOTNC(em,"ely",r0)
				* voa(powi0,r0) / sum(powi0.local,voa(powi0,r0)) ;

			TOTNC_CEQ(em,powi0,r0) $ sum(powi0.local,voa(powi0,r0))
				= TOTNC_CEQ(em,"ely",r0)
				* voa(powi0,r0) / sum(powi0.local,voa(powi0,r0)) ;

			NC_TRAD(em,f0,"ely",r0)     = 0 ;
			NC_TRAD_CEQ(em,f0,"ely",r0) = 0 ;
			TOTNC(em,"ely",r0)      	= 0 ;
			TOTNC_CEQ(em,"ely",r0)		= 0 ;

        $$EndIf.OldGtap1

    $$ENDIF.power

$Endif.nco2DB


$IfTheni.GTAPAirPol %ifAirPol%=="ON"

	EmiOAP = 1 ;

*------------------------------------------------------------------------------*
* 		 B.) 			Air Pollutant emissions								   *
*------------------------------------------------------------------------------*
* Only for GTAP < 11

	$$IfTheni.OldGtap2 NOT %GTAP_ver%=="11c"

    SET YRS / X2004, X2007, X2011, X2014 /;

    PARAMETERS

*   GTAP database

        APQE(YRS,OAP,ENDW_COMM,PROD_COMM,REG) "Air Pollution assoc. with endowment, Gg"
        APQF(YRS,OAP,TRAD_COMM,PROD_COMM,REG) "Air Pollution assoc. with input use, Gg"
        APQO(YRS,OAP,PROD_COMM,REG)           "Air Pollution assoc. with output by industries-M, Gg"
        APQP(YRS,OAP,TRAD_COMM,REG)           "Air Pollution assoc. input use by households, Gg"

* Nouvelles donnees pour GTAP 10

        $$IfTheni.Gtap10 NOT %gtap_ver%=="92"
            LUAPQ_%YearGTAP%(OAP,LU_SUBCAT,REG)  "Forestry-Biomass burning emissions (Gg)"
            APQE_%YearGTAP%(OAP,ENDW_COMM,*,REG) "Air Pollution assoc. with endowment (Gg)"
            APQF_%YearGTAP%(OAP,TRAD_COMM,*,REG) "Air Pollution assoc. with input use (Gg)"
            APQO_%YearGTAP%(OAP,*,REG)           "Air Pollution assoc. with output by industries-M (Gg)"
            APQP_%YearGTAP%(OAP,TRAD_COMM,REG)   "Air Pollution assoc. input use by households (Gg)"
        $$EndIf.Gtap10
        ;

*   Load GTAP9 Air Pollution emissions

		$$IfTheni.Gtap9 %gtap_ver%=="92"

			execute_loaddc "%FolderGTAP%\SatAcc\airpolut.gdx",
				APQE, APQF, APQO, APQP;

* Merge Air Pollutant with non-Co2 GHGs emissions (GTAP9)

			NC_ENDW(OAP,ENDW_COMM,a0,r0) = APQE("X20%YearGTAP%",OAP,fp0,a0,r0);
			NC_TRAD(OAP,i0,a0,r0)        = APQF("X20%YearGTAP%",OAP,i0,a0,r0);
			NC_QO(OAP,a0,r0)             = APQO("X20%YearGTAP%",OAP,a0,r0);
			NC_HH(OAP,i0,r0)             = APQP("X20%YearGTAP%",OAP,i0,r0);

		$$EndIf.Gtap9

*   Load GTAP10 Air Pollution emissions

		$$IfTheni.Gtap10 NOT %gtap_ver%=="92"

* Caution: this file was created by filling split sectors with original value (ie total is now greater, needs to be adapted)
*        execute_loaddc "%foldeREG_default%\SatAcct\20200224-airpolut-forGtap10.gdx", APQE, APQF, APQO, APQP;

* [EditJean]: 2020-12-07 --> Nouvelle donnees pour GTAP 10

			$$IFi %GTAP_ver%=="10a"  execute_loaddc "%FolderGTAP%\SatAcc\airpolut.gdx",
			$$IFi %GTAP_ver%=="10.1" execute_loaddc "%FolderGTAP%\GTAP\%GTAPBASE%airp.gdx",
				LUAPQ_%YearGTAP%, APQE_%YearGTAP%, APQF_%YearGTAP%,
				APQO_%YearGTAP%, APQP_%YearGTAP%;

* Merge Air Pollutant with non-Co2 GHGs emissions (GTAP10)

			NC_ENDW(OAP,ENDW_COMM,a0,r0) = APQE_%YearGTAP%(OAP,ENDW_COMM,a0,r0);
			NC_TRAD(OAP,i0,a0,r0)        = APQF_%YearGTAP%(OAP,i0,a0,r0);
			NC_QO(OAP,a0,r0)             = APQO_%YearGTAP%(OAP,a0,r0);
			NC_HH(OAP,i0,r0)             = APQP_%YearGTAP%(OAP,i0,r0);

		$$EndIf.Gtap10

	$$EndIf.OldGtap2

*	[OECD-ENV]:	OAP Data manipulations

* 1.)	Allocate OAP emissions from fuel combustion to Power sectors

* use all GHG emissions (in MtCO2 eq.) from fuel combustion as weights

    $$IfTheni.NCO2 %NCO2%=="ON"

        $$IfTheni.power %ifPower%=="ON"
            NC_TRAD(OAP,f0,elya0,r0)
                $ sum((em,elya0.local),NC_TRAD_CEQ(em,f0,elya0,r0))
                $$Ifi     %gtap_ver%=="92" = APQF("X%YearGTAP%",OAP,f0,"ELY",r0)
                $$Ifi NOT %gtap_ver%=="92" = APQF_%YearGTAP%(OAP,f0,"ELY",r0)
                * sum(em, NC_TRAD_CEQ(em,f0,elya0,r0))
                / sum((em,elya0.local), NC_TRAD_CEQ(em,f0,elya0,r0)) ;
        $$ENDIF.power

    $$Endif.NCO2

* 2.)	New variable for airpolut.gdx Crop/Forest Burning

    $$IfTheni.Gtap10 NOT %gtap_ver%=="92"

        LandUseEmi(OAP,"AgrBurn",acr0,r0) $ sum(acr0.local,EVFA("Land",acr0,r0))
            = LUAPQ_%YearGTAP%(oap,"OrgSoil",r0)
            * EVFA("Land",acr0,r0) / sum(acr0.local,EVFA("Land",acr0,r0)) ;
        LandUseEmi(OAP,"AgrBurn","frs",r0)
            = LUAPQ_%YearGTAP%(oap,"TropFrs",r0)
            + LUAPQ_%YearGTAP%(oap,"OthrFrs",r0);

    $$Endif.Gtap10

***hrr: NOT NEEDED	$$EndIf.OldGtap3

* 3.)	Harmonize PM25 name

    NC_ENDW("PM25",fp0,a0,r0) = NC_ENDW("PM2_5",fp0,a0,r0);
    NC_TRAD("PM25",i0,a0,r0)  = NC_TRAD("PM2_5",i0,a0,r0);
    NC_QO("PM25",a0,r0)       = NC_QO("PM2_5",a0,r0);
    NC_HH("PM25",i0,r0)       = NC_HH("PM2_5",i0,r0);

    NC_ENDW("PM2_5",fp0,a0,r0) = 0;
    NC_TRAD("PM2_5",i0,a0,r0)  = 0;
    NC_QO("PM2_5",a0,r0) 	   = 0;
    NC_HH("PM2_5",i0,r0) 	   = 0;

* 4.)	emissions from crop activities/production in Land because for me
* it makes sense that the more Land you have the more you burn
* Correction done by sake of symmetry with non-Co2

    NC_ENDW(OAP,lnd0,acr0,r0)
        = NC_ENDW(OAP,lnd0,acr0,r0) + NC_QO(OAP,acr0,r0);
    NC_QO(OAP,acr0,r0) = 0;

* 5.)	we do not distinguish Manure management (assoc with capital)
* from Manure in pasture/Manure in pasture/range/paddock (Land)

    NC_ENDW(OAP,cap0,alv0,r0)
        = NC_ENDW(OAP,cap0,alv0,r0) + sum(lnd0,NC_ENDW(OAP,lnd0,alv0,r0)) ;
    NC_ENDW(OAP,lnd0,alv0,r0) = 0;

$ENDIF.GTAPAirPol

*------------------------------------------------------------------------------*
*	C.) Built an unified database for Air Poll. & Non-CO2 emissions for model  *
*------------------------------------------------------------------------------*

* New for GTAP 11 calculate CO2 equivalent

* Using GWP-100 from AR4: To be consistent with Database NONCO2 and AIR_GHG

$SetGlobal IPCCSel "AR4"

$IfTheni.Gtap11 %GTAP_ver%=="11c"

***HRR: commented out *** because no declarations inside if-statement
***	IF(0,
***	Use GWP from IPCCC
***		$$include "%SatDataDir%\GWP.gms"
***	ELSE

*	Use GWP from GTAP (logically they are the same)

		PARAMETER GWP(AllEmissions,IPCC_REP) ;
		GWP(AllEmissions,IPCC_REP) = GWPARS(AllEmissions,"usa",IPCC_REP) ;

***	) ;
***endHRR

* GWP(AllEmissions,"AR4") * 0.001

* calculate for GTAP11: NC_ENDW_CEQ

    NC_ENDW_CEQ(AllEmissions,fp0,a0,r0) $ GWP(AllEmissions,"%IPCCSel%")
		= GWP(AllEmissions,"%IPCCSel%") * 0.001 * NC_ENDW(AllEmissions,fp0,a0,r0);
    NC_TRAD_CEQ(AllEmissions,i0,a0,r0)  $ GWP(AllEmissions,"%IPCCSel%")
		= GWP(AllEmissions,"%IPCCSel%") * 0.001 * NC_TRAD(AllEmissions,i0,a0,r0) ;
    NC_QO_CEQ(AllEmissions,a0,r0) 	    $ GWP(AllEmissions,"%IPCCSel%")
		= GWP(AllEmissions,"%IPCCSel%") * 0.001 * NC_QO(AllEmissions,a0,r0) 	 ;
    NC_HH_CEQ(AllEmissions,i0,r0) 	    $ GWP(AllEmissions,"%IPCCSel%")
		= GWP(AllEmissions,"%IPCCSel%") * 0.001 * NC_HH(AllEmissions,i0,r0) 	 ;
	LandUseEmi_CEQ(AllEmissions,EmiSource,a0,r0) $ GWP(AllEmissions,"%IPCCSel%")
		= GWP(AllEmissions,"%IPCCSel%") * 0.001 * LandUseEmi(AllEmissions,EmiSource,a0,r0) ;

*   Merge PFCs and HFCs

***HRR corrected the sets being summed:
	NC_QO_CEQ("PFC",a0,r0) = sum(PFCs,NC_QO_CEQ(PFCs,a0,r0)) ;
	NC_QO_CEQ("HFC",a0,r0) = sum(HFCs,NC_QO_CEQ(HFCs,a0,r0)) ;
***endHRR

$Else.Gtap11

	PARAMETER GWP(AllEmissions,IPCC_REP) ;
	GWP(AllEmissions,IPCC_REP) = GWPARS(AllEmissions,"usa",IPCC_REP) ;

$Endif.Gtap11

*   Calculate CO2 equivalent for model aggregation

$IfTheni.NCO2 %NCO2%=="ON"

*   CO2 eq. data (only for GHGs) for model aggregation

    NC_QO_CEQ1(AllEmissions,a,r) $ GWP(AllEmissions,"%IPCCSel%")
        = sum((a0,r0) $ (mapa(a0,a) and mapr(r0,r)), NC_QO_CEQ(AllEmissions,a0,r0));
    NC_ENDW_CEQ1(AllEmissions,fp,a,r) $ GWP(AllEmissions,"%IPCCSel%")
        = sum((fp0,a0,r0) $(mapf(fp0,fp) and mapa(a0,a) and mapr(r0,r)),
            NC_ENDW_CEQ(AllEmissions,fp0,a0,r0));
    NC_TRAD_CEQ1(AllEmissions,i,a,r) $ GWP(AllEmissions,"%IPCCSel%")
        = sum((i0,a0,r0)$(mapa(i0,i) and mapa(a0,a) and mapr(r0,r)),
            NC_TRAD_CEQ(AllEmissions,i0,a0,r0));
    NC_HH_CEQ1(AllEmissions,i,r) $ GWP(AllEmissions,"%IPCCSel%")
        = sum((i0,r0)$(mapa(i0,i) and mapr(r0,r)), NC_HH_CEQ(AllEmissions,i0,r0));

* [EditJean]: 2020-12-07 --> New variables LandUseEmi Crop/Forest Burning & Lulucf emissions

    $$IfTheni.GtapNew NOT %gtap_ver%=="92"

* "Lulucf & Forestry/Biomass burning emissions, Gg"

        LandUseEmi1(AllEmissions,EmiSource,a,r)
            = sum((a0,r0) $ (mapa(a0,a) and mapr(r0,r)),
                LandUseEmi(AllEmissions,EmiSource,a0,r0) ) ;

* "Lulucf & Forestry/Biomass burning emissions, mil tCO2-eq."

        LandUseEmi_CEQ1(AllEmissions,EmiSource,a,r)
            = sum((a0,r0)$(mapa(a0,a) and mapr(r0,r)),
                LandUseEmi_CEQ(AllEmissions,EmiSource,a0,r0));

*	GWP for model aggregation

        $$IfTheni.Gtap10 NOT %GTAP_ver%=="11c"

* [EditJean]: no data for households here

			TOTNC1(em,i,r)
				= sum((i0,r0) $ (mapa(i0,i) and mapr(r0,r)), TOTNC(em,i0,r0) ) ;
			TOTNC_CEQ1(em,i,r)
				= sum((i0,r0) $ (mapa(i0,i) and mapr(r0,r)),
					TOTNC_CEQ(em,i0,r0) ) ;

			GWPARS1(em,r,IPCC_REP)
				$ sum(mapr(r0,r),sum(i0,TOTNC(em,i0,r0)))
				= sum(mapr(r0,r),sum(i0,TOTNC(em,i0,r0)) * GWPARS(em,r0,IPCC_REP))
				/ sum(mapr(r0,r),sum(i0,TOTNC(em,i0,r0))) ;

        $$Endif.Gtap10

        $$IfTheni.Gtap11 %GTAP_ver%=="11c"

*  !!!! Should we add LU emissions? Do TOTNC1 by symetry

			GWPARS1(AllEmissions,r,IPCC_REP)  $ GWP(AllEmissions,IPCC_REP)
			= sum(mapr(r0,R),
				sum((i0,a0) , NC_TRAD(AllEmissions,i0,a0,r0))
			  + sum((fp0,a0), NC_ENDW(AllEmissions,fp0,a0,r0))
			  + sum(a0, 	  NC_QO(AllEmissions,a0,r0))
			  + sum(i0, 	  NC_HH(AllEmissions,i0,r0))) ;

			GWPARS1(AllEmissions,r,IPCC_REP) $ GWP(AllEmissions,IPCC_REP)
				= {  sum(mapr(r0,r),GWP(AllEmissions,IPCC_REP)
						* [   sum((i0,a0), NC_TRAD(AllEmissions,i0,a0,r0))
							+ sum((fp0,a0),NC_ENDW(AllEmissions,fp0,a0,r0))
							+ sum(a0,      NC_QO(AllEmissions,a0,r0))
							+ sum(i0,      NC_HH(AllEmissions,i0,r0)) ]
					  ) / GWPARS1(AllEmissions,r,IPCC_REP)
				  }	$ GWPARS1(AllEmissions,r,IPCC_REP)

*  If there are no emissions

***HRR: changed GWP for GWPARS1
				 + {  sum(mapr(r0,r), GWPARS1(AllEmissions,r,IPCC_REP))
					/ sum(mapr(r0,r), 1)
					} $ { GWPARS1(AllEmissions,r,IPCC_REP) eq 0 }
				;

        $$Endif.Gtap11

    $$Endif.GtapNew

$Endif.NCO2

*	Emission for model aggregation in gas volume

IF(EmiOAP or EmiGHG,

*    Agg4(NC_TRAD,NC_TRAD1,nco2,em,mapnco2,i0,i,mapa,a0,a,mapa,r0,r,mapr) ;
*    Agg4(NC_ENDW,NC_ENDW1,nco2,em,mapnco2,fp0,fp,mapf,a0,a,mapa,r0,r,mapr) ;
*    Agg3(NC_QO,NC_QO1,nco2,em,mapnco2,a0,a,mapa,r0,r,mapr) ;
*    Agg3(NC_HH,NC_HH1,nco2,em,mapnco2,i0,i,mapa,r0,r,mapr) ;

* Air Pollution & Non-CO2 associated with output by industries-M, Gg"

    NC_QO1(AllEmissions,a,r)
        = sum((a0,r0) $ (mapa(a0,a) and mapr(r0,r)), NC_QO(AllEmissions,a0,r0));

* Air Pollution & Non-CO2 associated with endowment, Gg"

    NC_ENDW1(AllEmissions,fp,a,r)
        = sum((fp0,a0,r0) $(mapf(fp0,fp) and mapa(a0,a) and mapr(r0,r)),
            NC_ENDW(AllEmissions,fp0,a0,r0));

* Air Pollution & Non-CO2 associated with input use, Gg"

    NC_TRAD1(AllEmissions,i,a,r)
        = sum((i0,a0,r0) $(mapa(i0,i) and mapa(a0,a) and mapr(r0,r)),
            NC_TRAD(AllEmissions,i0,a0,r0));

* Air Pollution & Non-CO2 associated with input use by households, Gg"
    NC_HH1(AllEmissions,i,r) = 0 ;
    NC_HH1(AllEmissions,i,r)
        = sum((i0,r0) $ (mapa(i0,i) and mapr(r0,r)), NC_HH(AllEmissions,i0,r0));

) ;

*   Save the energy and emissions data in the CSV file if requested

$Ifi %NCO2%=="ON" $batinclude "%DataDir%\aggNRG.gms" AggGTAP 1

*------------------------------------------------------------------------------*
*                                                                              *
*  			Additional BoP accounts -- from GMiG and GDyn					   *
*                                                                              *
*------------------------------------------------------------------------------*

$iftheni.BoP "%BoP%" == "ON"

    parameters
        remit(lab_comm,reg,reg)          "Initial remittances"
        yqtf(reg)                        "Initial outflow of capital income"
        yqht(reg)                        "Initial inflow of capital income"
    ;

    parameters
        remit1(l,s,d)                    "Initial remittances"
        yqtf1(r)                         "Initial outflow of capital income"
        yqht1(r)                         "Initial inflow of capital income"
    ;

*  Remittances and flow of profits

    $$ifthen.BOPData exist "%iGdxDir_GtapDB%\\%GTAPBASE%BOP.gdx"

        execute_load "%iGdxDir_GtapDB%\\%GTAPBASE%BOP.gdx", remit, yqtf, yqht ;

        Agg3(remit,remit1,lab_comm,l,mapf,r0,s,mapr,rp0,d,mapr) ;
        Agg1(yqtf,yqtf1,r0,r,mapr) ;
        Agg1(yqht,yqht1,r0,r,mapr) ;

    $$else.BOPData

        remit1(l,s,d) = 0 ;
        yqtf1(r)      = 0 ;
        yqht1(r)      = 0 ;

    $$endif.BOPData

    execute_unload "%iDataDir%\agg\%Prefix%BoP.gdx",
    REMIT1=REMIT, YQTF1=YQTF, YQHT1=YQHT ;

$endif.BoP

*  ELAST ={ON,OFF}, if ON we aggregate

$iftheni.elast "%ELAST%"=="ON"

    parameters
        etat0(reg)              "GTAP: Aggregate land elasticities"
        landmax0(reg)           "GTAP: Land maximum"
        etanrf0(reg,prod_comm)  "GTAP: Natural resource elasticities"
        etat1(r)                "Model: Aggregate land elasticities"
        landmax1(r)             "Model: Land maximum"
        etanrf1(r,a)            "Model: Natural resource elasticities"
    ;

*  Land & Natural resources parameters

    $$ifthen.LandNatRes exist "%iGdxDir_GtapDB%\\%GTAPBASE%ELAST.gdx"

        execute_loaddc "%iGdxDir_GtapDB%\\%GTAPBASE%ELAST.gdx", etat0, landmax0, etanrf0 ;

        loop(LAND_COMM,
            etat1(r)     = sum(r0$mapr(r0,r), sum(a0, vfm(LAND_COMM, a0, r0))) ;
            landMax1(r)  = etat1(r) ;
            etat1(r)$etat1(r) = sum(r0$mapr(r0,r), etat0(r0)*sum(a0, vfm(LAND_COMM, a0, r0)))/etat1(r) ;
            landMax1(r)$landMax1(r) = sum(r0$mapr(r0,r), landMax0(r0)*sum(a0, vfm(LAND_COMM, a0, r0)))/landMax1(r) ;
        ) ;

        loop(NTRS_COMM,
            etanrf1(r,a) = sum(r0$mapr(r0,r), sum(a0$mapa(a0,a), vfm(NTRS_COMM, a0, r0))) ;
            etanrf1(r,a)$etanrf1(r,a) = sum(r0$mapr(r0,r), sum(a0$mapa(a0,a), etanrf0(r0,a0)*vfm(NTRS_COMM, a0, r0)))/etanrf1(r,a) ;
        ) ;
            IF(0, execute_unload "check_etanrf1.gdx", etanrf1 ;);

    $else

        etat1(r)     = 0 ;
        landmax1(r)  = 1 ;
        etanrf1(r,a) = 1 ;

    $endif.LandNatRes

    execute_unload "%iDataDir%\agg\%Prefix%ELAST.gdx",
    ETAT1=ETAT, LANDMAX1=LANDMAX, ETANRF1=ETANRF ;

$endif.elast

*	Labor Split

$iftheni.lab "%LAB%"=="ON"

    parameters

*  Input data from ILO

        labvol(lab_comm,prod_comm,reg)   "Labor volumes in millions"
        wage(lab_comm, prod_comm, reg)   "Wages imputed from ILO"

*  Labor/VA (from GIDD)

        emplg(lg, prod_comm, reg)        "Labor volumes emanating from GIDD"
        vfmg(lg, prod_comm, reg)         "Labor value added emanating from GIDD"
        evfag(lg, prod_comm, reg)        "Labor value added emanating from GIDD"

*  Output vectors

        empl1(l, a, r)                   "Employment data in person years"
        wage1(l, a, r)                   "Imputed wages"
        emplz(l,z,r)                     "Total employment by zone"
    ;

    IF(IFLABOR = noLab,

* Just set wages to 1 and employment to vfm1

        empl1(l,a,r) = vfm1(l,a,r) ;

    elseif(IFLABOR = agLab),

* Read the labor volumes and do a two-sector aggregation

        execute_load "%iGdxDir_GtapDB%\\%GTAPBASE%Wages.gdx" labvol=q ;

*   Employment equals remuneration divided by average wage by zone

        loop(z,

* Total employment in zone z

            emplz(l,z,r) = sum(a$mapz(z,a), sum((lab_comm, a0, r0)$(mapf(lab_comm,l) and mapa(a0,a) and mapr(r0,r)), labvol(lab_comm,a0,r0))) ;

* Average wage in zone z (Total remuneration in z divided by total employment in z)

            emplz(l,z,r)$emplz(l,z,r) = sum(a$mapz(z,a), vfm1(l,a,r)) /  emplz(l,z,r) ;

* And thus employment by activity

            empl1(l,a,r)$(mapz(z,a) and emplz(l,z,r)) = vfm1(l,a,r)/emplz(l,z,r) ;
        ) ;

    elseIF(IFLABOR = allLab),

* Read the labor volumes and make wages fully sector-specific

        execute_load "%iGdxDir_GtapDB%\%GTAPBASE%Wages.gdx" labvol=q ;

        Agg3(labvol,empl1,lab_comm,l,mapf,a0,a,mapa,r0,r,mapr) ;

    elseIF(IFLABOR = giddLab),

* Read the GIDD data

* !!!! THIS SECTION NEEDS WORK -- FOR EXAMPLE IF USING ALL 5 LABOR SKILLS IN GTAP, re-balancing, etc.

        execute_load "%giddLab%"  vfmg, evfag, emplg=empl ;

* !!!! ASSUME NO NEED TO REBALANCE VFM AND EMPL

        Agg3(vfmg,vfm1,lg,l,mapl,a0,a,mapa,r0,r,mapr) ;
        Agg3(evfag,evfa1,lg,l,mapl,a0,a,mapa,r0,r,mapr) ;
        Agg3(emplg,empl1,lg,l,mapl,a0,a,mapa,r0,r,mapr) ;

* Re-scale labor

        empl1(l,a,r) = 1e6*empl1(l,a,r) ;

    ) ;

    wage1(l,a,r)$empl1(l,a,r) = vfm1(l,a,r) / empl1(l,a,r) ;
    empl1(l,a,r) = 1e6*empl1(l,a,r) ;

    execute_unload "%iDataDir%\agg\%Prefix%Wages.gdx", EMPL1=q, wage1=wage ;

$endif.lab

* ------------------------------------------------------------------------------
*
*  Deal with the Power and water volumes
*
* ------------------------------------------------------------------------------

Parameter

*  Power data

    gwhr1(a,r) "Power output in Gwh"

*  Water data

    h2ocrp(reg, i0)            "Water withdrawal for activities"
    h2oUse(wbnd0, reg)         "Water withdrawal for aggregate uses"
    h2ocrp1(a, r)              "Water withdrawal for activities"
    h2oUse1(wbnd0, r)          "Water withdrawal for aggregate uses"
;

$IFI NOT %GTAP_DBType% == "GTAP-Power" $setGlobal ifPower "OFF"


$iftheni.POW %IfPower% == "ON"

* [EditJean]: the name in GTAP-Power is gwh and is not in %GTAPBASE%DAT

***HRR: there is no GWH parameter in v11c
*   execute_load "%iGdxDir_GtapDB%\%GTAPBASE%VOLE.gdx", gwhr=gwh ;

***HRR: all new from here onwards
* GWh is the sum of domestic energy use and exports (in Mtoe) :
alias(reg,reg2) ;
gwhr(ERG,reg) = sum(PROD_COMM, EDF(ERG,PROD_COMM,reg))  + EDP(ERG,reg) + EDI(ERG,reg) + EDG(ERG,reg) + 
                sum(REG2, EXIDAG(ERG,reg,REG2) ) ;

**HRR: taken from ENVISAGE AggGTAP.gms 
set eunits Energy units /
   toe      Tons of oil equivalent
   mtoe     Millions of tons of oil equivalent
   tj       Terajoules
   ej       Exajoules
   cal      Calories
   gCal     Giga calories
   kwh      Kilowatt hour
   mWh      Megawatt hour
   gWh      Gigawatt hour
   mBTU     Million BTU
   mbd      Million barrels of oil equivalent per day
   mb       Million barrels of oil equivalent
   bcm      Billion cubic meters
   mt       Million tons of coal equivalent
/
alias(eunits, eunitsp) ;
Table emat(eunits, eunitsp) Energy conversion matrix
*         TO:
                    TOE           MTOE             TJ              EJ            CAL            kWh            mWh            gWh          mBTU            gCal           mbd            mb              bcm             mt
*  FROM:    multiply by:
   TOE   1.00000000E+00 1.00000000E-06 4.18680000E-02  4.18680000E-08 1.00000000E+10 1.16309304E+04 1.16309304E+01 1.16309304E-02 3.96815468E+01 1.00000000E+01 2.09000000E-08 7.62850000E-06  1.21170000E-06 1.98140000E-06
   MTOE  1.00000000E+06 1.00000000E+00 4.18680000E+04  4.18680000E-02 1.00000000E+16 1.16309304E+10 1.16309304E+07 1.16309304E+04 3.96815468E+07 1.00000000E+07 2.09000000E-02 7.62850000E+00  1.21170000E+00 1.98140000E+00
   TJ    2.38845897E+01 2.38845897E-05 1.00000000E+00  1.00000000E-06 2.38845897E+11 2.77800000E+05 2.77800000E+02 2.77800000E-01 9.47777462E+02 2.38845897E+02 4.99187924E-07 1.82203592E-04  2.89409573E-05 4.73249260E-05
   EJ    2.38845897E+07 2.38845897E+01 1.00000000E+06  1.00000000E+00 2.38845897E+17 2.77800000E+11 2.77800000E+08 2.77800000E+05 9.47777462E+08 2.38845897E+08 4.99187924E-01 1.82203592E+02  2.89409573E+01 4.73249260E+01
   CAL   1.00000000E-10 1.00000000E-16 4.18680000E-12  4.18680000E-18 1.00000000E+00 1.16309304E-06 1.16309304E-09 1.16309304E-12 3.96815468E-09 1.00000000E-09 2.09000000E-18 7.62850000E-16  1.21170000E-16 1.98140000E-16
   kWh   8.59776446E-05 8.59776446E-11 3.59971202E-06  3.59971202E-12 8.59776446E+05 1.00000000E+00 1.00000000E-03 1.00000000E-06 3.41172592E-03 8.59776446E-04 1.79693277E-12 6.55880461E-10  1.04179112E-10 1.70356105E-10
   mWh   8.59776446E-02 8.59776446E-08 3.59971202E-03  3.59971202E-09 8.59776446E+08 1.00000000E+03 1.00000000E+00 1.00000000E-03 3.41172592E+00 8.59776446E-01 1.79693277E-09 6.55880461E-07  1.04179112E-07 1.70356105E-07
   gWh   8.59776446E+01 8.59776446E-05 3.59971202E+00  3.59971202E-06 8.59776446E+11 1.00000000E+06 1.00000000E+03 1.00000000E+00 3.41172592E+03 8.59776446E+02 1.79693277E-06 6.55880461E-04  1.04179112E-04 1.70356105E-04
   mBTU  2.52006306E-02 2.52006306E-08 1.05510000E-03  1.05510000E-09 2.52006306E+08 2.93106780E+02 2.93106780E-01 2.93106780E-04 1.00000000E+00 2.52006306E-01 5.26693179E-10 1.92243010E-07  3.05356040E-08 4.99325294E-08
   Gcal  1.00000000E-01 1.00000000E-07 4.18680000E-03  4.18680000E-09 1.00000000E+09 1.16309304E+03 1.16309304E+00 1.16309304E-03 3.96815468E+00 1.00000000E+00 2.09000000E-09 7.62850000E-07  1.21170000E-07 1.98140000E-07
   mbd   4.78468900E+07 4.78468900E+01 2.00325359E+06  2.00325359E+00 4.78468900E+17 5.56503847E+11 5.56503847E+08 5.56503847E+05 1.89863860E+09 4.78468900E+08 1.00000000E+00 3.65000000E+02  5.79760766E+01 9.48038278E+01
   mb    1.31087370E+05 1.31087370E-01 5.48836600E+03  5.48836600E-03 1.31087370E+15 1.52466807E+09 1.52466807E+06 1.52466807E+03 5.20174959E+06 1.31087370E+06 2.73972603E-03 1.00000000E+00  1.58838566E-01 2.59736515E-01
   bcm   8.25286787E+05 8.25286787E-01 3.45531072E+04  3.45531072E-02 8.25286787E+15 9.59885318E+09 9.59885318E+06 9.59885318E+03 3.27486562E+07 8.25286787E+06 1.72484939E-02 6.29570027E+00  1.00000000E+00 1.63522324E+00
   mt    5.04693651E+05 5.04693651E-01 2.11305138E+04  2.11305138E-02 5.04693651E+15 5.87005673E+09 5.87005673E+06 5.87005673E+03 2.00270247E+07 5.04693651E+06 1.05480973E-02 3.85005551E+00  6.11537297E-01 1.00000000E+00
;

***HRR: convert from Mtoe to GWh
gwhr(ERG,reg) = gwhr(ERG,reg) * emat("mtoe","gwh");

***endHRR

* Power aggregation

    gwhr1(a,r) = sum((i0,r0)$(mapa(i0,a) and mapr(r0,r)), gwhr(i0, r0)) ;

$else.POW

    gwhr1(a,r) = 0 ;

$endif.POW

$iftheni.WAT %IfWater% == "ON"

    execute_load "%iGdxDir_GtapDB%\%GTAPBASE%DAT.gdx", h2oCrp, h2oUse ;

*  Water aggregation

    h2ocrp1(a,r)     = sum((i0, r0)$(mapa(i0,a) and mapr(r0,r)), h2ocrp(r0,i0)) ;
    h2oUse1(wbnd0,r) = sum(r0$mapr(r0,r), h2oUse(wbnd0, r0)) ;

    IF(1,

*  Check to see if value added and volume of water are consistent

        put screen ;  put / ;
        loop((r,wat,a)$((h2ocrp1(a,r) eq 0 and evfa1(wat, a, r) ne 0) or (h2ocrp1(a,r) ne 0 and evfa1(wat, a, r) eq 0)),
            put "Water warning: ", r.tl:<10, a.tl:<10, "h2o(cu.m.) = ", (1e-6*h2ocrp1(a,r)):15:4, " Cost($mn) = ", evfa1(wat,a,r):14:4 / ;
        ) ;
        putclose screen ;
    ) ;

$else.WAT

    h2oCrp1(a,r)      = 0 ;
    h2oUse1(wbnd0, r) = 0 ;

$endif.WAT

IF(0,
    display gwhr1, h2ocrp1, h2ouse1 ;
    Abort "Temp"
) ;

execute_unload "%iDataDir%\agg\%Prefix%Sat.gdx"
   nrgCumb1=nrgCumb, gwhr1=gwhr, h2ocrp1=h2ocrp, h2ouse1=h2ouse ;

*------------------------------------------------------------------------------*
*              Delete tiny flows (Done by hand)                                *
*------------------------------------------------------------------------------*
* [EditJean]:  moved to filtering procedure

* $IF SET DebugDir $include "%DebugDir%\Delete_TinyFlows.gms" "1"

*------------------------------------------------------------------------------*
*                                                                              *
*           Save the data in %iDataDir%\agg\*.gdx files                        *
*                                                                              *
*------------------------------------------------------------------------------*

*   Save SAM (names without the postfix '1')

execute_unload "%iDataDir%\agg\%Prefix%dat.gdx",
    VDFM1=VDFM, VDFA1=VDFA, VIFM1=VIFM, VIFA1=VIFA, VFM1=VFM, EVFA1=EVFA,
    EVOA1=EVOA, VDPM1=VDPM, VDPA1=VDPA, VIPM1=VIPM, VIPA1=VIPA,
    VDGM1=VDGM, VDGA1=VDGA, VIGM1=VIGM, VIGA1=VIGA,
    VST1=VST, VXMD1=VXMD, VXWD1=VXWD, VIWS1=VIWS, VIMS1=VIMS, VTWR1=VTWR,
    SAVE1=SAVE, VDEP1=VDEP, VKB1=VKB, POP1=POP,
    VOA1=VOA, VOM1=VOM, OSEP1=OSEP,

* OECD-ENV: add FBEP & FTRV

    FBEP1=fbep, FTRV1=ftrv

;

*   Save parameters

* Note that we assign to ETRAE the value of ETRAE1 different from GTAP value

execute_unload "%iDataDir%\agg\%Prefix%par.gdx",
   ESUBT1=ESUBT, ESUBVA1=ESUBVA, ESUBD1=ESUBD, ESUBM1=ESUBM,
   INCPAR1=INCPAR, SUBPAR1=SUBPAR, ETRAE1=ETRAE, RORFLEX1=RORFLEX;

*   Save energy in volume

execute_unload  "%iDataDir%\agg\%Prefix%vole.gdx",
   EDF1=EDF, EIF1=EIF, EDP1=EDP, EIP1=EIP, EDG1=EDG, EIG1=EIG,
   EDF1=EDF, EXIDAG1=EXIDAG;

*   Save CO2 from fuel combustion

execute_unload  "%iDataDir%\agg\%Prefix%emiss.gdx",
   MDF1=MDF, MIF1=MIF, MDP1=MDP, MIP1=MIP, MDG1=MDG, MIG1=MIG, MDF1=MDF;

*   Save Non-CO2/Air Pollution emissions data

IF(EmiOAP or EmiGHG,
    execute_unload "%iDataDir%\agg\%Prefix%nco2.gdx",
        $$Ifi NOT %gtap_ver%=="92" LandUseEmi1=LandUseEmi,
        $$Ifi NOT %gtap_ver%=="92" LandUseEmi_CEQ1=LandUseEmi_CEQ,
        $$Ifi NOT %gtap_ver%=="92" TOTNC1=TOTNC, TOTNC_CEQ1=TOTNC_CEQ, GWPARS1=GWPARS,
        NC_TRAD1=NC_TRAD, NC_ENDW1=NC_ENDW, NC_QO1=NC_QO, NC_HH1=NC_HH,
        NC_TRAD_CEQ1=NC_TRAD_CEQ, NC_ENDW_CEQ1=NC_ENDW_CEQ, NC_QO_CEQ1=NC_QO_CEQ,
        NC_HH_CEQ1=NC_HH_CEQ
        ;
);

*------------------------------------------------------------------------------*
*                                                                              *
*           Aggregate the dynamic scenarios for ENVISAGE                       *
*                                                                              *
*------------------------------------------------------------------------------*

$iftheni.DYN "%DYN%"=="ON"

***HRR: At the end we need popScen and gdpScen by regional mapping!

***HRR: changed this file to accomodate for new SSP file
    $$include "%SetsDir%\SSPSets.gms"
***HRR: new SSP file uses GTAPV11 set instead of r
alias(r0,GTAPv11) ;
***HRR: we have th as the full 1950-2100 time set, so alias with t in new SSP file
alias(th,t) ;


    Parameters
***HRR: 
*Parameter for old SSP file         tPop(scen, c, tranche, tt)
*Parameter for old SSP file         popScen(scen, c, sex, tranche, ed, tt)
*Parameter in new SSP file
        tPop(scen,GTAPV11,gender,tranche,t)

*Parameter for old SSP file         gdpScen(mod, ssp, var, c, tt)
*Parameter in new SSP file
        OECD_GDP(scen,GTAPV11,t,var)

***old
$ontext    
        popHist(c, tranche, th)
        tpop1(scen, r, tranche, tt)
        gdpScen1(mod, ssp, var, r, tt)
        popHist1(r, tranche, th)
$OffText
        popScen1(scen, r, tranche, edj, tt)
***new
        tpop1(scen,r,tranche,tt)
        gdpScen1(mod,ssp,var,r,tt)
        gdpScen1a(mod,ssp,var,r,tt)
    ;

*  Load the SSP database

***old    execute_load "%SSPFile%", tPop=pop, popScen, gdpScen, popHist ;
    execute_load "%SSPFile%", tPop=pop, OECD_GDP ;

*  Aggregate population (ignore gender)

***old
$ontext
    tpop1(scen, r, tranche, tt)
        = sum((r0,c)$(mapr(r0,r) and mapc(c,r0)), tpop(scen, c, tranche, tt)) ;

    popScen1(scen, r, tranche, edj, tt)
        = sum((r0,c)$(mapr(r0,r) and mapc(c,r0)),
                sum((sexx,ed)$mape1(edj,ed), popScen(scen, c, sexx, tranche, ed, tt))) ;
    popHist1(r, tranche, th)
        = sum((r0,c)$(mapr(r0,r) and mapc(c,r0)), popHist(c, tranche, th)) ;
$OffText
***new
    tpop1(scen,r,tranche,tt)
        = sum(r0$(mapr(r0,r)), tPop(scen,r0,"BOTH",tranche,tt)) ;

*  Aggregate GDP
***old
$ontext
    gdpScen1(mod, ssp, "gdp", r, tt)
        = sum((r0,c)$(mapr(r0,r) and mapc(c,r0)), gdpScen(mod, ssp, "gdp", c, tt)) ;
    gdpScen1(mod, ssp, "gdpppp05", r, tt)
        = sum((r0,c)$(mapr(r0,r) and mapc(c,r0)), gdpScen(mod, ssp, "gdpppp05", c, tt)) ;
    gdpScen1(mod, ssp, "gdppc", r, tt) $ tpop1(ssp,r,"PTOTL",tt)
        = (1e6)*gdpScen1(mod, ssp, "gdp", r, tt) / tpop1(ssp, r, "PTOTL", tt) ;
$offtext

***HRR: new correcting previous mistake with GDP per capita for regional aggregates
*   gdpScen(mod,ssp,var,r,tt)
    gdpScen1("OECD",ssp,var,r,tt)
        = sum(r0$(mapr(r0,r)), OECD_GDP(ssp,r0,tt,var)) ;
    gdpScen1("OECD",ssp,"GDP_per_capita|PPP",r,tt)
        = sum(r0$(mapr(r0,r)), OECD_GDP(ssp,r0,tt,"GDP|PPP") / tpop1(ssp,r,"PTOTL",tt)) ;        


*------------------------------------------------------------------------------*
*       Aggregate the GIDD population/education scenarios                      *
*------------------------------------------------------------------------------*

    parameters
        GIDDPopProj(r0, edw, tranche, tt)
        GIDDPopProj1(r, edw, tranche, tt)
    ;

    execute_load "%giddProj%", GIDDPopProj ;

*  Load the GIDD scenario

    popScen1("GIDD", r, tranche, edj, tt)
        = sum(r0$mapr(r0,r), sum(edw$mape2(edj, edw), GiDDPopProj(r0, edw, tranche, tt))) ;

    popScen1(scen,r,trs,"elevt",tt)
        = sum(edj$(not sameas(edj,"elevt")), popScen1(scen,r,trs,edj,tt)) ;

    popScen1(scen,r,"ptotl",edj,tt)
        = sum(trs, popScen1(scen,r,trs,edj,tt)) ;

    tpop1("GIDD",r,tranche,tt) = popScen1("GIDD",r,tranche,"elevt",tt) ;

    execute_unload "%iDataDir%\agg\%Prefix%Scn.gdx"
***old    tpop1=popscen, gdpscen1=gdpscen, popHist1=popHist, popScen1=educScen ;
    tpop1=popscen , gdpscen1=gdpscen, popScen1=educScen ;

$endif.DYN
***endHRR

* ------------------------------------------------------------------------------
*
*  Save the aggregation mappings in some txt Files
*
* ------------------------------------------------------------------------------
* [EditJean]: a deplacer ailleurs quand on aura ote ce qui est relatif au modele
*$onText

$iftheni.saveMap "%SAVEMAP%" == "TXT"

    $$include "%DataDir%\saveMap.gms"

$elseifi.saveMap "%SAVEMAP%" == "LATEX"

    $$include "%DataDir%\saveMap.gms"

$else.saveMap

    $$show
    DISPLAY "*** -- Invalid option for SAVEMAP (%SAVEMAP%)" ;
    DISPLAY "*** -- Valid options are 'TXT' and 'LATEX'" ;
*   Abort "Invalid option" ;

$endif.saveMap
*$OffText

*------------------------------------------------------------------------------*
*                                                                              *
* Create file with set definitions models --> "%iDataDir%\%Prefix%Sets.gms"    *
*                                                                              *
*------------------------------------------------------------------------------*

$IF NOT DEXIST "%iDataDir%\Fnl" $call "mkdir %iDataDir%\Fnl"
$IF NOT DEXIST "%iDataDir%\Alt" $call "mkdir %iDataDir%\Alt"

*   Create the 'sets' file for AlterTax: [OECD-ENV]: Always create this set

file fsetAlt / %iDataDir%\Alt\%Prefix%Sets.gms / ;
put fsetAlt ;
$batinclude "%DataDir%\makeset.gms" "AlterTax"
putclose fsetAlt ;

*   Create the 'final sets' file for the requested model --> in folder %iDataDir%

file fsetMod / %iDataDir%\%Prefix%Sets.gms / ;
put fsetMod ;

*   Regular countries and sectors sets

$batinclude "%DataDir%\makeset.gms" "%Model%"

*   Add sets for ENVISAGE and [OECD-ENV] Models

$IFI %Model%=="ENV" $batinclude "%DataDir%\makesetEnv.gms"

* [OECD-ENV]: Add new sets

$IFI %Model%=="ENV" $batinclude "%DataDir%\MakeSetOECD.gms"

putclose fsetMod;


*------------------------------------------------------------------------------*
*                                                                              *
*  Aggregate the elasticities for ENVISAGE and OECD-ENV models                 *
*                                                                              *
*------------------------------------------------------------------------------*

$iftheni.ifEnv %Model%=="ENV"

*  Set 1st to 1 to override GTAP argminton elasticities with ENV-Linkages values
*  Set 2nd to 1 to override GTAP income elasticities with ENV-Linkages values

   $$batinclude "%DataDir%\aggEnvElast.gms" %OVRRIDEGTAPARM% %OVRRIDEGTAPINC%

*   Prepare a temporary file "tmpSets.gms" containing set to convert labels
* in GDX file to final labels

   $$batinclude "%DataDir%\makeAggSets.gms"


$OnText
   file fx ;
   scalar jh, status ;
*  Following need to be invoked at the end to do the conversion
   execute.ASync 'gams convertLabel --BaseName=%BaseName% -pw=150 -ps=9999' ;
   jh = JobHandle ; status = 1 ;
*  put_utility fx 'log' / '>>> JobHandle :' jh;
   while(status = 1,
      status = JobStatus(jh);
*     put_utility fx 'log' / '>>> Status    :' status;
   );
   abort$(status <> 2) '*** Execute.ASync gams... failed: wrong status';
   abort$errorlevel    '*** Execute.ASync gams... failed: wrong errorlevel';
$OffText

*   convert aggregation elasticities sigma0(actf) to model elasticities sigma(a)
*   and save in "%OutFolder%\Agg\%Prefix%Prm.gdx" with suffix0

    execute 'gams convertLabel --BaseName=%BaseName% -pw=150 -ps=9999 -idir="%DataDir%" --OutFolder="%iDataDir%" --Prefix=%Prefix%' ;
    abort$errorlevel    '*** Execute gams... failed: wrong errorlevel';

*   Delete temporary labels

    execute 'del tmpSets.gms'

$endif.ifEnv

*------------------------------------------------------------------------------*
*                                                                              *
*           Aggregate the dynamic scenarios for OECD-ENV                       *
*                                                                              *
*------------------------------------------------------------------------------*

$Ifi %BuildScenarioInAgg%=="ON" $include "%SatDataDir%\Build_Scenario.gms"

* For NDCs

$IFI %Model%=="ENV" execute_unload "%iDataDir%\agg_summary.gdx", r0, r, mapr;

$SHOW



*------------------------------------------------------------------------------*
*   OECD-ENV: Fill details about the aggregation in "a_ProjectDetails.txt"     *
*------------------------------------------------------------------------------*

$If DEXIST "%ToolsDir%" $batinclude "%ToolsDir%\StoreInTxtFileProjectDetails.gms" "AggGTAP"

IF(m_CheckFile,

***HRR    EXECUTE_UNLOAD "%DirCheck%\%GTAP_DBType%_%GTAP_ver%Y20%YearGTAP%_%system.fn%.gdx";

    $$IfTheni.nco2DB %NCO2%=="ON"

*  Calculate and display the global warming potential

        nc_trad1(NCO2,i,a,r)  $ nc_trad1(NCO2,i,a,r)
            = NC_TRAD_CEQ1(NCO2,i,a,r) / nc_trad1(NCO2,i,a,r) ;
        NC_ENDW1(NCO2,fp,a,r) $ NC_ENDW1(NCO2,fp,a,r)
            = NC_ENDW_CEQ1(NCO2,fp,a,r) / NC_ENDW1(NCO2,fp,a,r) ;
        NC_QO1(NCO2,a,r) $ NC_QO1(NCO2,a,r)
            = NC_QO_CEQ1(NCO2,a,r) / NC_QO1(NCO2,a,r) ;
        NC_HH1(NCO2,i,r) $ NC_HH1(NCO2,i,r)
            = NC_HH_CEQ1(NCO2,i,r) / NC_HH1(NCO2,i,r) ;

        execute_unload "%DirCheck%\Check_GWP_%system.fn%.gdx",
            nc_trad1, NC_ENDW1, NC_QO1, NC_HH1 ;

    $$endif.nco2DB

) ;
*------------------------------------------------------------------------------*
*   IMF-WEO data: new HRR     
*------------------------------------------------------------------------------*

$If NOT SET WEODir $SetGlobal WEODir "%SatDataDir%\WEO"

set weovar "Variables from WEO" /
bca_bp6
bca_gdp_bp6
gcxcnl_gdp
gcxcnld
le
llf
lp
lur
nfb_r_gdp
ngdp_r_ppp
ni_r_gdp
/;

parameter
WEO_data(c,weovar,t)    "WEO data"
WEO_cab(r,t)            "CAB from WEO"
WEO_gbal(r,t)           "Government budget balance from WEO"
WEO_rgdp(r,t)           "GDP, constant prices (PPP international dollars) from WEO"
WEO_cabSh(r,t)          "CAB share of real GDP from WEO"
WEO_gbalSh(r,t)         "Government budget balance share of real GDP from WEO"   
WEO_cab_res(t)          "Sum (residual) of region-specific CAB"  
;

*Original file compiled by Jaden Kim: WEOJan2024Pub_modified.csv
* converted to gdx using: convert2gdx_weo.gms (has to be ran outside server) 
    EXECUTE_LOAD "%WEODir%\WEO_data_Jan2024.gdx", WEO_data;

WEO_cab(r,t) = sum(r0 $ mapr(r0,r), (sum(c $ mapc(c,r0), WEO_data(c,"bca_bp6",t)))) ; 
WEO_gbal(r,t) = sum(r0 $ mapr(r0,r), (sum(c $ mapc(c,r0), WEO_data(c,"gcxcnld",t)))) ; 
WEO_rgdp(r,t) = sum(r0 $ mapr(r0,r), (sum(c $ mapc(c,r0), WEO_data(c,"ngdp_r_ppp",t)))) ; 
WEO_cabSh(r,t)  $ WEO_rgdp(r,t) = WEO_cab(r,t) /WEO_rgdp(r,t) ;
WEO_gbalSh(r,t) $ WEO_rgdp(r,t) = WEO_gbal(r,t)/WEO_rgdp(r,t) ;
WEO_cab_res(t) = sum(r, WEO_cab(r,t)) ;

    EXECUTE_UNLOAD "%iDataDir%\WEO_data.gdx", WEO_data, WEO_cab, WEO_gbal, WEO_rgdp, WEO_cabSh, WEO_gbalSh, WEO_cab_res ;
*------------------------------------------------------------------------------*
* Energy consumption values to convert units: compiled by Jaden using IEA data
*------------------------------------------------------------------------------*
$ontext
He scraped the IEA excel files and produced this excel: IEA_elec_out_tfc.xlsx
I then moved the values to IEA_nrg_values.gdx
$offtext

Parameter
ely_GWh(r0)     "IEA: Total electricity output in GWh for 2020"
nrg_TJ(r0)      "IEA: Total final consumption of heat in TJ for 2020"
ely_GWh_agg(r)  "IEA: Total electricity output in GWh for 2020 for model aggregation"
nrg_TJ_agg(r)   "IEA: Total final consumption of heat in TJ for 2020 for model aggregation"

;

*** Upload and aggregate data
    EXECUTE_LOAD '%SatDataDir%/IEA_nrg_values/IEA_nrg_values.gdx', ely_GWh, nrg_TJ ;

ely_GWh_agg(r)  = sum(r0 $ mapr(r0,r), ely_GWh(r0)) ;  
nrg_TJ_agg(r)   = sum(r0 $ mapr(r0,r), nrg_TJ(r0)) ; 

   EXECUTE_UNLOAD "%iDataDir%\IEA_nrg_values.gdx", ely_GWh_agg, nrg_TJ_agg ;



$label eof

