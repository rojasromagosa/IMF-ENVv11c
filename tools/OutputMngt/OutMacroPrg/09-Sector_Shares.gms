$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file : "%OutMngtDir%\OutMacroPrg\09-Sector_Shares.gms"
    purpose   :  Calculate Aggregate sector VA shares according to WB cat.
    created by: Jean Chateau
    called by : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/09-Sector_Shares.gms $
   last changed revision: $Rev: 388 $
   last changed date    : $Date:: 2023-09-01 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

out_Macroeconomic(abstype,"Remarkable Ratios","Service share (BP)",notvol,ra,%1)
    $ sum((r,a) $ (mapr(ra,r) AND NOT tota(a)), To%YearBaseMER%MER(r) * out_Value_Added(abstype,"Basic Prices",notvol,r,a,%1))
    = sum((r,srva) $ mapr(ra,r), To%YearBaseMER%MER(r) * out_Value_Added(abstype,"Basic Prices",notvol,r,srva,%1))
    / sum((r,a) $ (mapr(ra,r) AND NOT tota(a)), To%YearBaseMER%MER(r) * out_Value_Added(abstype,"Basic Prices",notvol,r,a,%1)) ;

* Actually Agriculture share also contains forestry and fishery --> prima

out_Macroeconomic(abstype,"Remarkable Ratios","Agriculture share (BP)",notvol,ra,%1)
    $ sum((r,a) $ (mapr(ra,r) AND NOT tota(a)), To%YearBaseMER%MER(r) * out_Value_Added(abstype,"Basic Prices",notvol,r,a,%1))
    = sum((r,prima) $ mapr(ra,r), To%YearBaseMER%MER(r) * out_Value_Added(abstype,"Basic Prices",notvol,r,prima,%1))
    / sum((r,a) $ (mapr(ra,r) AND NOT tota(a)), To%YearBaseMER%MER(r) * out_Value_Added(abstype,"Basic Prices",notvol,r,a,%1));

out_Macroeconomic(abstype,"Remarkable Ratios","Industry share (BP)",notvol,ra,%1)
    $ out_Macroeconomic(abstype,"Remarkable Ratios","Service share (BP)",notvol,ra,%1)
    = 1 - out_Macroeconomic(abstype,"Remarkable Ratios","Service share (BP)",notvol,ra,%1)
        - out_Macroeconomic(abstype,"Remarkable Ratios","Agriculture share (BP)",notvol,ra,%1);
