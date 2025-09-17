$OnText
--------------------------------------------------------------------------------
            OECD-ENV Model version 1.0 - Baseline Generation
	GAMS file   : "%ToolsDir%\StoreInTxtFileScenarioDetails.gms"
	purpose     : Create a file "a_ProjectDetails.txt" that contains description
				data used in %SatDataDir%\Build_Scenario.gms
	Created by  : Jean Chateau
	created Date: 2023-02-06
	called by   : "%SatDataDir%\Build_Scenario.gms
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/StoreInTxtFileScenarioDetails.gms $
	last changed revision: $Rev: 520 $
	last changed date    : $Date:: 2024-03-01 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$SetGlobal OutScFile "%ProjectDir%\a_ScenarioDetails.txt"

$onecho > "%OutScFile%"
Created Date                            : %dateout%
Project Name                            : %BaseName%
Created by                              : %MyName% %MyAffiliation%
GTAP Database		   				 : Version %GTAP_ver%x20%YearGTAP%  (%GTAP_DBType%)
IEA World Energy Outlook projections    : %IeaWeoVer%
OECD Long Term Model Scenario           : %oGdxFile_GrowthScen%
Loaded file for ENV Dir GHG data        :"%SatDataDir%\GHG\OECD\%DateENVDotstat%_OECD_ENV_Emissions_GTAP_%GTAP_ver%.gdx"


Source          |	      Database Name                               | DotStat / Version     | Date of Extraction
--------------------------------------------------------------------------------------------------------------
IEA             | Extended world energy balances in ktoe            | WBIG                  | %WBIG_date%
IEA             | World energy statistics                           | WBES                  | %WBES_date%
JRC             | EDGAR Greenhouse Gases Emissions                  | V.%EDGARverGHG%       | %EDGAR_date%
JRC             | EDGAR Air Pollutant Emissions                     | V.%EDGARverAP%        | %EDGAR_date%
OECD (ENV Dir)  | Greenhouse gas emissions by source in tCO2eq.     | AIR_GHG               | %AIR_GHG_date%
OECD (ENV Dir)  | Emissions of air pollutants Thousands Tonnes      | AIR_EMISSIONS         | %AIR_EMISSIONS_date%
IEA             | Emissions of CO2, CH4, N2O, HFCs, PFCs and SF6    | NONCO2                | %NONCO2_date%
IEA             | IPCC Fuel Combustion Emissions (2006 Guidelines)  | IPCC2006              | %IPCC2006_date%

Memo: EDGAR = Emission Database for Global Atmospheric Research
Memo: OECD (ENV Dir) AIR_GHG database is based on UNFCCC

$offecho

