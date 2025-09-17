*------------------------------------------------------------------------------*
$OnText

   Envisage 10 / [OECD-ENV] project -- Data preparation modules

   GAMS file : LoadData.gms

   @purpose  : Loads the data for the filter routine

   @author   : Tom Rutherford, with modifications by Wolfgang Britz
               and adjustments for Env10 by Dominique van der Mensbrugghe
   @date     : 21.10.16
   @revision : Jean Chateau - April 2021: Air Pollutant for [OECD-ENV]
   @since    :
   @refDoc   :
   @seeAlso  :
   @calledBy : AggGTAP.cmd  / / %ProjectDir%/RunSim.gms for [OECD-ENV]
   @Options  :

[EditJean] Revision:
Instructions for GAMS-IDE
* In root folder:      -idir=Data       --BaseName=10x10   --model=ENV --ifCSV=0 --ifAggTrade=0
* In a project folder: -idir=..\..\Data --BaseName=CoordinationG20 --model=ENV --ifCSV=0 --ifAggTrade=0
                       --BaseName=2022_OECD_OEW --model=ENV --ifCSV=0 --ifAggTrade=0

--BaseName=2023_G20 --model=ENV --ifCSV=0 --ifAggTrade=0 --ifAlt=OFF --model=ENV --ifCSV=0  optDir=C:\MODELS\CGE\tools\SolverFiles

--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/Data/filter.gms $
   last changed revision: $Rev: 515 $
   last changed date    : $Date:: 2024-02-23 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------

$OffText

*$OffListing

*   [OECD-ENV]: Add Default Choices [True Choice are either in IDE adress bar or in a batch file

$IF NOT SET model      $SetGlobal model      "ENV"
$IF NOT SET ifCSV      $SetGlobal ifCSV      "0"
$IF NOT SET ifAggTrade $SetGlobal ifAggTrade "0"

*   [OECD-ENV]: add paths for finding files

$include "%system.fp%..\a_FolderPath.gms"

$IF NOT SET BaseName abort "The global variable BaseName should be defined" ;
$If     SET oDirCheck $SetGlobal DirCheck "%oDirCheck%\%BaseName%\agg"
$If NOT SET oDirCheck $SetGlobal DirCheck "%BaseName%\Check\agg"
$IF NOT DEXIST "%iDataDir%\Flt" $call "mkdir %iDataDir%\Flt"

$IF NOT SET DataDir $SetGlobal DataDir "."
$IF NOT SET Prefix  $SetGlobal Prefix ""

*   [OECD-ENV]: default values for Power & Water

$IFI NOT %GTAP_DBType%=="GTAP-Power" $SetGlobal IfPower "OFF"
$IFI     %GTAP_DBType%=="GTAP-Power" $SetGlobal IfPower "ON"
$IFI NOT %GTAP_DBType%=="GTAP-Water" $SetGlobal IfWater "OFF"
$IFI     %GTAP_DBType%=="GTAP-Water" $SetGlobal IfWater "ON"

scalars
	ifFirstPass / 1 /
	ifAggTrade  / %ifAggTrade% /
;

file logfile / %Prefix%flt.log / ;
file msglog  / msglog / ;

$oneolcom
$SHOW

*   Load Sets

$include "%SetsDir%\SetsGTAP.gms"
$include "%SetsDir%\setEmissions.gms"
$include "%SetsDir%\SetDatabaseVersion.gms"
$include "%SetsDir%\SetsIMPACTsectors.gms"
$IF NOT SET iMapDir $SetGlobal iMapDir "%iFilesDir%"
$include "%iMapDir%\%Prefix%Map.gms"

*   [EditJean]: I moved these instructions after set definitions

*  Read the user-defined options for this run

$setGlobal PGMName "FILTER"
$include "%iFilesDir%\%Prefix%flt.gms"

alias(r,s) ; alias(r,d) ; alias(r,rp) ; alias(i,img) ; alias(i,j) ;

*	Declare and read the GTAP data

Parameters
	evfa(fp,a,r)      "Primary factor purchases, at agents' prices"
	vfm(fp,a,r)       "Primary factor purchases, by firms, at market prices"
	evoa(fp,r)        "Factor income net of direct taxes"
	vdfa(i, a, r)     "Domestic purchases, by firms, at agents' prices"
	vdfm(i, a, r)     "Domestic purchases, by firms, at market prices"
	vifa(i, a, r)     "Import purchases, by firms, at agents' prices"
	vifm(i, a, r)     "Import purchases, by firms, at market prices"
	vdpa(i, r)        "Domestic purchases, by households, at agents' prices"
	vdpm(i, r)        "Domestic purchases, by households, at market prices"
	vipa(i, r)        "Import purchases, by households, at agents' prices"
	vipm(i, r)        "Import purchases, by households, at market prices"
	vdga(i, r)        "Domestic purchases, by government, at agents' prices"
	vdgm(i, r)        "Domestic purchases, by government, at market prices"
	viga(i, r)        "Import purchases, by government, at agents' prices"
	vigm(i, r)        "Import purchases, by government, at market prices"
	vst(i, r)         "Margin exports"
	vxmd(i, s, r)     "Non-margin exports, at market prices"
	vxwd(i, s, r)     "Non-margin exports, at world prices"
	viws(i, s, r)     "Imports, at world prices"
	vims(i, s, r)     "Imports, at market prices"
	vtwr(i, i, s, r)  "Margins by margin commodity"
	vkb(r)            "Capital stock"
	vdep(r)           "Depreciation allowance"
	save(r)           "Regional savings"
	pop(r)            "Regional population"

* [EditJean] 2024-02-23:
***HRR: defined here over "a", but later called using "i"
*	fbep(fp,a,r)  	  "Gross Factor-Based Subsidies"
*    ftrv(fp,a,r)  	  "Gross Factor-Based Tax revenue"
	fbep(fp,i,r)  	  "Gross Factor-Based Subsidies"
    ftrv(fp,i,r)  	  "Gross Factor-Based Tax revenue"
***endHRR


* CO2 Emissions

	mdf(i, a, r)      "CO2 emissions from intermediate demand for domestic goods"
	mIF(i, a, r)      "CO2 emissions from intermediate demand for imported good"
	mdp(i, r)         "CO2 emissions from private demand for domestic goods"
	mip(i, r)         "CO2 emissions from private demand for imported goods"
	mdg(i, r)         "CO2 emissions from public demand for domestic goods"
	mig(i, r)         "CO2 emissions from public demand for imported goods"

* Energy volumes

	edf(i, a, r)      "Usage of domestic products by firm"
	eIF(i, a, r)      "Usage of imported products by firm"
	edp(i, r)         "Private consumption of domestic goods"
	eip(i, r)         "Private consumption of imported goods"
	edg(i, r)         "Public consumption of domestic goods"
	eig(i, r)         "Public consumption of imported goods"
	exidag(i, s, r)   "Bilateral trade in energy"

* Non-CO2 emissions (OECD-ENV: updated for Air Pollution)

   NC_TRAD(AllEmissions,i,a,r)       "Non-CO2 emissions assoc. with input use.."
   NC_ENDW(AllEmissions,fp,a,r)      "Non-CO2 emissions assoc. with endowment .."
   NC_QO(AllEmissions,a,r)           "Non-CO2 emissions assoc. with output by industries-M. .."
   NC_HH(AllEmissions,i,r)           "Non-CO2 emissions assoc. with input use by households-.."
   NC_TRAD_CEQ(AllEmissions,i,a,r)   "Non-CO2 emissions assoc. with input use.."
   NC_ENDW_CEQ(AllEmissions,fp,a,r)  "Non-CO2 emissions assoc. with endowment .."
   NC_QO_CEQ(AllEmissions,a,r)       "Non-CO2 emissions assoc. with output by industries-M. .."
   NC_HH_CEQ(AllEmissions,i,r)       "Non-CO2 emissions assoc. with input use by households-.."

* [OECD-ENV]: add New Data for GTAP V10

    $$ifTheni.gtap10 NOT %GTAP_ver%=="92"
        LandUseEmi_CEQ(AllEmissions,EmiSource,a,r) "Lulucf & Forestry/Biomass burning emissions, mil tCO2-eq."
        LandUseEmi(AllEmissions,EmiSource,a,r)     "Lulucf & Forestry/Biomass burning emissions"
***HRR: em set gives problems
*        GWPARS(em,r,IPCC_REP)        "Global warming potentials by IPPC ARs for 20%YearGTAP%, CO2=1 [GWPS:NCGHG*r*IPCC_REP]"
		GWPARS(AllEmissions,r,IPCC_REP)        "Global warming potentials by IPPC ARs for 20%YearGTAP%, CO2=1 [GWPS:NCGHG*r*IPCC_REP]"
***endHRR
        TOTNC(AllEmissions,a,r)      "Aggregate emissions from Non-CO2 dataset (excluding land use), Gg "
        TOTNC_CEQ(AllEmissions,a,r)  "Aggregate emissions from Non-CO2 dataset (excluding land use), mil tCO2-eq."
    $$endif.gtap10
;

*   Load GTAP Data for model aggregation (built by the "AggGTAP.gms" procedure)

execute_loaddc "%iDataDir%\agg\%prefix%dat.gdx",
   evfa, vfm, evoa,
   vdfa, vdfm, vifa, vifm,
   vdpa, vdpm, vipa, vipm,
   vdga, vdgm, viga, vigm,
   vxmd, vxwd, viws, vims, vtwr, vst,
   fbep, ftrv,
   vkb,  save, vdep, pop
;

*------------------------------------------------------------------------------*
*              Delete tiny flows (Done by hand)                                *
*------------------------------------------------------------------------------*

* [EditJean]: moved [2022-11-29] from AggGTAP.gms

*$IF SET DebugDir $batinclude "%DebugDir%\Delete_TinyFlows.gms" ""

************************************************************************************************************************
***HRR: include here adjustment file
$ifi %BaseName%=="2024_NGFSv2" 	$$include '%iFilesDir%\BaseDataAdj.gms'
$ifi %GroupName%=="2024_MCD" 	$$include '%iFilesDir%\BaseDataAdj_MCD.gms'
***endHRR
************************************************************************************************************************


* Alternative: Run the filtering procedure

$include "%DataDir%\filter\filter.gms"

***HRR EXECUTE_UNLOAD "%DirCheck%\%GTAP_DBType%_%GTAP_ver%Y20%YearGTAP%_%system.fn%.gdx"

* [OECD-ENV]: store some informations about filtering operation in Txt file

$Batinclude "%ToolsDir%\StoreInTxtFileProjectDetails.gms" "filter"

