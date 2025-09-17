$OnText
--------------------------------------------------------------------------------
                OECD [OECD-ENV] - Preparation of Data
   GAMS file    : "00-Export_GTAP_DB_fromHartoGdx.gms"
   purpose      : Load GTAP databases and transform into gdx files
   created date : 2020-10-20
   created by   : Jean Chateau
   called by    : "..\00-step-LoadGtapData.bat" or stand-alone file
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/00-Export_GTAP_DB_fromHartoGdx.gms $
   last changed revision: $Rev: 497 $
   last changed date    : $Date:: 2024-02-02 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*   Path where GTAP original files are stored (plus default)

$SetGlobal FolderRawGTAP "\\main.oecd.org\ASgenECO\Data\Raw_DataBases\GTAP_Databases"
$SetGlobal FolderRawGTAP "V:\CLIMATE_MODELLING\Data\Raw_DataBases\GTAP_Databases"

$IF NOT EXIST ..\a_FolderPath.gms $CALL '00a-getPath.bat'
$include "..\a_FolderPath.gms"

$OnText

    memo :
        %DataBaseName% = {GTAP,GTAP-Power,GTAP-E,GDyn, GTAP-APT}


GTAP V92 Database versions:
   •   GTAP_92_DataBase_(January2017)
   •   GTAP-Power_92_DataBase_(August2017)
   •   GTAP-E_92_DataBase_(August2017)
   •   GDyn_92_DataBase_2011_(August2017)
GTAP V10a Database versions:
   •   GDYN_10a_DataBase_2014_(January2020)
   •   GMIG_10a_DataBase_2014_(January2020)
   •   GTAP_10a_DataBase_(February2020)
   •   GTAP-APT_10a_DataBase_2014_(Sept2020)
   •   GTAP-E_10a_DataBase_(January2020)
   •   GTAP-MRIO_10a_DataBase_2014_(June2020)
   •   GTAP-Power_10a_DataBase_(January2020)

$OffText

*   Default GTAP database version

$IF NOT SET GTAPBASE	$SetGlobal GTAPBASE	   "GSD"
$IF NOT SET GTAP_DBType $SetGlobal GTAP_DBType "GTAP"
$IF NOT SET GTAP_ver    $SetGlobal GTAP_ver    "92"
$IF NOT SET YearGTAP    $SetGlobal YearGTAP    "11"

* Stand-alone procedure (override default)

*$SetGlobal GTAPBASE	"GSDF"
*$SetGlobal GTAP_DBType "GTAP-Power"
*$SetGlobal GTAP_ver    "11b"
*$SetGlobal YearGTAP    "14"

*	Write details in a txt file
*file data_details / 'GTAP_databases_details.txt' /;
*data_details.ap = 1;

$SHOW

$IfThenI.gtap9 %GTAP_ver%=="92"
    $$IfThenI.DBGTAP %GTAP_DBType%=="GTAP"
        $$SetGlobal DBDate "_(January2017)"
        $$SetGlobal DBFile "flexagg%GTAP_ver%pY%YearGTAP%"
    $$ELSEIFI.DBGTAP %GTAP_DBType%=="GTAP-Power"
        $$SetGlobal DBDate "_(August2017)"
        $$SetGlobal DBFile "flexagg%GTAP_ver%Y%YearGTAP%_%GTAP_DBType%"
    $$ELSEIFI.DBGTAP %GTAP_DBType%=="GTAP-E"
        $$SetGlobal DBDate "_(August2017)"
        $$SetGlobal DBFile "flexagg%GTAP_ver%E%YearGTAP%"
    $$ELSEIFI.DBGTAP %GTAP_DBType%=="GDyn"
        $$SetGlobal DBDate "20%YearGTAP%_(August2017)"
        $$SetGlobal DBFile "%GTAP_DBType%Flexagg%GTAP_ver%_20%YearGTAP%"
    $$ENDIF.DBGTAP
$ENDIF.gtap9

$IfThenI.gtap10a %GTAP_ver%=="10a"
    $$IfThenI.DBGTAP %GTAP_DBType%=="GTAP"
        $$SetGlobal DBDate "_(February2020)"
        $$SetGlobal DBFile "flexagg%GTAP_ver%Y%YearGTAP%"
    $$ELSEIFI.DBGTAP %GTAP_DBType%=="GTAP-Power"
* C:\Dropbox\NotSVN_modelling\Raw_Databases\GTAP_Databases\V10a\GTAP-Power_10a_DataBase_(January2020)\flexagg10aPower14
        $$SetGlobal DBDate "_(January2020)"
        $$SetGlobal DBFile "flexagg%GTAP_ver%Power%YearGTAP%"
    $$ELSEIFI.DBGTAP %GTAP_DBType%=="GTAP-E"
        $$SetGlobal DBDate "_(January2020)"
        $$SetGlobal DBFile "flexagg%GTAP_ver%E%YearGTAP%"
    $$ELSEIFI.DBGTAP %GTAP_DBType%=="GDyn"
* C:\Dropbox\NotSVN_modelling\Raw_Databases\GTAP_Databases\V10a\GDYN_10a_DataBase_2014_(January2020)
        $$SetGlobal DBDate ""
        $$SetGlobal DBFile ""
    $$ELSEIFI.DBGTAP %GTAP_DBType%=="GTAP-MRIO"
        $$SetGlobal DBDate ""
        $$SetGlobal DBFile ""
* C:\Dropbox\NotSVN_modelling\Raw_Databases\GTAP_Databases\V10a\GTAP-MRIO_10a_2014_(June2020)\flexagg10aMRIO14
    $$ELSEIFI.DBGTAP %GTAP_DBType%=="GTAP-APT"
        $$SetGlobal DBDate "20%YearGTAP%_(Sept2020)"
        $$SetGlobal DBFile "flexagg%GTAP_ver%APT%YearGTAP%"
    $$ENDIF.DBGTAP
$ENDIF.gtap10a

$IfThenI.gtap101 %GTAP_ver%=="10.1"
    $$IfThenI.DBGTAP %GTAP_DBType%=="GTAP"
        $$SetGlobal DBDate "AY11929"
        $$SetGlobal DBFile "flexagg%GTAP_ver%Y%YearGTAP%"
    $$ELSEIFI.DBGTAP %GTAP_DBType%=="GTAP-Power"
        $$SetGlobal DBDate "AY11929"
        $$SetGlobal DBFile "flexagg%GTAP_ver%Power%YearGTAP%"
    $$ENDIF.DBGTAP
$ENDIF.gtap101

$Ifi %GTAP_ver%=="11b" $SetGlobal DBFile "20%YearGTAP%"

*put data_details;
*put "%GTAP_DBType%_V%GTAP_ver%_20%YearGTAP% : on GTAP site %DBDate% - Source File: %iDir_RawData%" /;
*putclose data_details;

$Ifi NOT %GTAP_ver%=="11b" $SetGlobal iDir_RawData "%FolderRawGTAP%\V%GTAP_ver%\%GTAP_DBType%_%GTAP_ver%_DataBase%DBDate%\%DBFile%"
$Ifi 	 %GTAP_ver%=="11b" $SetGlobal iDir_RawData "%FolderRawGTAP%\V%GTAP_ver%\%GTAP_DBType%\%DBFile%"

*   Architecture 1: toutes les bases dans le meme repertoire: \GTAP_Data

$SetGlobal oDir_Data "%ExtDir%\GTAP_Data\%GTAP_DBType%_V%GTAP_ver%_20%YearGTAP%"

*   Architecture 2: GTAP_Data\V%GTAP_ver%\20%YearGTAP%

$SetGlobal oDir_Data "%ExtDir%\GTAP_Data\V%GTAP_ver%\20%YearGTAP%\%GTAP_DBType%"

$IFI NOT DEXIST "%oDir_Data%" $call "mkdir %oDir_Data%"

$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "%GTAPBASE%dat"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "%GTAPBASE%emiss"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "%GTAPBASE%par"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "%GTAPBASE%set"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "%GTAPBASE%vole"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "metadata"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "%GTAPBASE%tax"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "%GTAPBASE%view"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "%GTAPBASE%airp"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "%GTAPBASE%nco2"
*$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "gepar"
*$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "gmap"

*    useless same file as "gsdview"

*$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "gtapview"

*   Gdyn

$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "gddat"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "gdpar"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "gdpextra"
$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "gdset"

*------------------------------------------------------------------------------*
*             Satellites Accounts: NCO2 & AP                                   *
*------------------------------------------------------------------------------*

* Not done:

*$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "gsdtrade"

*   Architecture 1: toutes les bases dans le meme repertoire: \GTAP_Data

$SetGlobal oDir_Data "%ExtDir%\GTAP_Data\SatAcc_V%GTAP_ver%_20%YearGTAP%"

*   Architecture 2: GTAP_Data\V%GTAP_ver%\20%YearGTAP%

$SetGlobal oDir_Data "%ExtDir%\GTAP_Data\V%GTAP_ver%\20%YearGTAP%\SatAcc"

$IFI NOT DEXIST "%oDir_Data%" $call "mkdir %oDir_Data%"

$IfThenI.gtap9 %GTAP_ver%=="92"
    $$SetGlobal iDir_RawData  "%FolderRawGTAP%\V%GTAP_ver%\SatAcc\GTAP_%GTAP_ver%_AirPollution_DataBase_(May2018)\Airpolut_%GTAP_ver%"
    $$IF NOT EXIST "%oDir_Data%\airpolut.gdx" $batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "airpolut"

    $$SetGlobal iDir_RawData  "%FolderRawGTAP%\V%GTAP_ver%\SatAcc\GTAP_%GTAP_ver%_Non-CO2_Emissions_DataBase_(February2016)"
    $$IF NOT EXIST "%oDir_Data%\NCO2.gdx" $batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "CONSLD_20%YearGTAP%"
    EXECUTE 'REN "%oDir_Data%\CONSLD_20%YearGTAP%.gdx" "NCO2.gdx"'

    $$SetGlobal iDir_RawData  "%FolderRawGTAP%\V%GTAP_ver%\SatAcc\GTAP_%GTAP_ver%_LandUseandLandCover_DataBase_(August2017)\GTAPLULCv9p2\20%YearGTAP%"
    $$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "GTAPAEZ18v9p2"
$ENDIF.gtap9

$IfThenI.gtap10a %GTAP_ver%=="10a"
    $$SetGlobal iDir_RawData  "%FolderRawGTAP%\V%GTAP_ver%\SatAcc\GTAP_%GTAP_ver%_AirPollution_DataBase_(June2020)"
    $$IF NOT EXIST "%oDir_Data%\airpolut.gdx" $batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "airpolut_%YearGTAP%"
    EXECUTE 'REN "%oDir_Data%\airpolut_%YearGTAP%.gdx" "airpolut.gdx"'

    $$SetGlobal iDir_RawData  "%FolderRawGTAP%\V%GTAP_ver%\SatAcc\GTAP_%GTAP_ver%_Non-CO2_Emissions_DataBase_(March2020)"
    $$IF NOT EXIST "%oDir_Data%\NCO2.gdx" $batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "NCO2_%YearGTAP%"
    EXECUTE 'REN "%oDir_Data%\NCO2_%YearGTAP%.gdx"     "NCO2.gdx"'
*---    Not updated
*   $$SetGlobal iDir_RawData  "%FolderRawGTAP%\V%GTAP_ver%\SatAcc\GTAP_%GTAP_ver%_LandUseandLandCover_DataBase_(August2017)\GTAPLULCv9p2\20%YearGTAP%"
*   $$batinclude "00-sub-HarToGdx.gms" "%iDir_RawData%" "%oDir_Data%" "GTAPAEZ18v[]"
$ENDIF.gtap10a

*put "%GTAP_DBType%_V%GTAP_ver%_20%YearGTAP% : on GTAP site %DBDate% - Source File: %iDir_RawData%" /;
*putclose data_details;
*EXECUTE "copy GTAP_Data\GTAP_databases_details.txt GTAP_Data\GTAP_databases_details.txt";

$SHOW