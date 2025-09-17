$OnText
--------------------------------------------------------------------------------
             OECD-ENV project V.1. - Aggregation procedure
    GAMS file   : "%SetsDir%\SetDatabaseVersion.gms"
    purpose     : define emission (and energy) database set and version
	Created by  : Jean Chateau
    created Date: 2024-12-01
    called by   : "%DataDir%\AggGTAP.gms"
                  "%DataDir%\filter.gms"
                  "%SatDataDir%\Build_Scenario.gms"
                  "Energy\Export_IEA-WEO_to_GTAP\1-preamble.gms"
				  "%SatDataDir%\preamble.gms"
                  "%ModelDir%\22-Additional_Sets.gms"
--------------------------------------------------------------------------------
	file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
	last changed revision: $Rev: 459 $
	last changed date    : $Date: 2022-02-24 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
	Formerly part of %SetsDir%\setEmissions.gms
--------------------------------------------------------------------------------
$OffText

*   Load Latest OECD ENV Data = {%AIR_EMISSIONS_date%,%AIR_GHG_date%,DateENVDotstat}

* these two files are automatically generated (or filled)

$IF EXIST "%SatDataDir%\GHG\OECD\OECD_Datasets.gms"   $include "%SatDataDir%\GHG\OECD\OECD_Datasets.gms"
$IF EXIST "%SatDataDir%\GHG\EDGAR\EDGAR_Datasets.gms" $include "%SatDataDir%\GHG\EDGAR\EDGAR_Datasets.gms"

*   Load Latest IEA Data = {WBIG_date, NONCO2_date, BIGCO2_date, WBES_date, IPCC2006_date}

$IF EXIST "%SatDataDir%\Energy\IEA\IEA_Datasets.gms" $include "%SatDataDir%\Energy\IEA\IEA_Datasets.gms"

*   Default versions for each database

$IF NOT SET AIR_EMISSIONS_date $SetGlobal AIR_EMISSIONS_date "20230207"
$IF NOT SET AIR_GHG_date       $SetGlobal AIR_GHG_date       "20230207"
$IF NOT SET DateENVDotstat     $SetGlobal DateENVDotstat     "2023_02_07"
$IF NOT SET WBIG_date          $SetGlobal WBIG_date          "20230213"
$IF NOT SET NONCO2_date        $SetGlobal NONCO2_date        "20230215"
$IF NOT SET BIGCO2_date        $SetGlobal BIGCO2_date        "20230207"
$IF NOT SET WBES_date          $SetGlobal WBES_date          "20230209"
$IF NOT SET IPCC2006_date      $SetGlobal IPCC2006_date      "20230207"
$IF NOT SET IIASAGAINS_date    $SetGlobal IIASAGAINS_date    "16mar20"
$IF NOT SET EDGAR_Ver          $SetGlobal EDGAR_Ver          "v8.0_20231026"

SETS

    SetEmiDB "Various Databases on GHG and AIR emissions used as input to calibrate ENV-Linkages" /

        AIR_GHG       "OECD:Environment Directorate AIR_GHG dataset (UNFCCC) - Greenhouse gas emissions (tCO2eq) - Extracted from DotStat - Last compiled: %AIR_GHG_date%"
        AIR_EMISSIONS "OECD:Environment Directorate AIR_EMISSIONS dataset - Emissions of air pollutants (Tonnes, Thousands) - Extracted from DotStat - Last compiled: %AIR_EMISSIONS_date%"
        NONCO2        "IEA: NONCO2 dataset (Extracted from DotStat %NONCO2_date%)"
        BIGCO2        "IEA: BIGCO2 dataset - CO2 Emissions from Fuel Combustion (extracted from DotStat %BIGCO2_date%)"
        GAINS_MFR     "IIASA-GAINS: All emissions dataset - MFR scenario - Received %IIASAGAINS_date%"
        GAINS_CLE     "IIASA-GAINS: All emissions dataset - CLE scenario - Received %IIASAGAINS_date% (ECLIPSE_V6b_CLE_base)"
        GAINS_SDS_MFR "IIASA-GAINS: All emissions dataset - MFR+SDS scenario - Received %IIASAGAINS_date% (ECLIPSE_V6b_CLE_base)"
        EDGAR         "JRC-EDGAR: All emissions dataset - Version %EDGAR_Ver%"
        GTAP          "GTAP Database V%GTAP_ver%Y%YearGTAP%: Emissions"
        ELv3          "Emissions from ENV-Linkages Version 3 - Extracted from %ENV_LinkagesV3_sim_file%.gdx - Last compiled:%EDGAR_date%"
        IPCC2006      "IEA: IPCC Fuel Combustion Emissions (2006 Guidelines)- Extracted from DotStat - Last compiled: %IPCC2006_date%"

*   Climate Watch Databases

		"Climate Watch"
		"PIK"
		"GCP"
		"UNFCCC_AI"
		"US"
		"UNFCCC_NAI"
		"UNFCCC"
		"CAIT"

*        USEPA         "non CO2 Emissions from US-EPA 2012 Edition"
    /
    GAINS_scenario "Air Pollutant Damages: Scenarios from GAINS: Evaluating the Climate and Air Quality Impacts of Short-Lived Pollutants (ECLIPSE) V6b Project)"/
        BAU                 "Temporary Data"
        CLE                 "IIASA ECLIPSE CLE_BASE V6b, Current Legislation Emissions: all countries"
        MFR                 "IIASA ECLIPSE MFR_BASE V6b, Maximum Feasible Reduction: all countries"
        CLE_MFR_AC          "IIASA ECLIPSE CLE_BASE V6b and MFR_BASE: Arctic Council Members"
        CLE_MFR_AC_AOC      "IIASA ECLIPSE CLE_BASE V6b and MFR_BASE: Arctic Council Members + Active Observer countries (+France, Germany, India, Italy, Japan, Poland, South Korea, Spain, United Kingdom) "
        CLE_MFR_AC_AOC_OOC  "IIASA ECLIPSE CLE_BASE V6b and MFR_BASE: Arctic Council Members + Active Observer countries + Other observer countries (+China, the Netherlands)"
        OLD_DATA
        SDS_MFR
    /
    CW_DB(SetEmiDB) "Set of databases include in climate watch" /
		"Climate Watch"
		"PIK"				" PIK (e.g. Postdam Institute for Climate Impact Research) PRIMAP-hist "
		"GCP"				" GLobal Carbon Project"
		"US"
		"CAIT"
		"UNFCCC"
		"UNFCCC_AI"
		"UNFCCC_NAI"
	/
    SetEmiDBdet(SetEmiDB) "Detailled Databases" /
        BIGCO2
        GAINS_MFR
        GAINS_CLE
        GAINS_SDS_MFR
        EDGAR
        GTAP
        ELv3
    /
    mapGAINS_Scenario(SetEmiDB,GAINS_scenario) /
        GAINS_MFR.MFR
        GAINS_CLE.CLE
        GAINS_SDS_MFR.SDS_MFR
    /
    SetEmiDGtap(SetEmiDB)  / GTAP /
    SetEmiGAINS(SetEmiDB)  / GAINS_MFR, GAINS_SDS_MFR, GAINS_CLE /
;



