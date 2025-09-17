$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
    GAMS file    : "%OutMngtDir%\OutMacroPrg\10-Gov_Revenues.gms"
    purpose      :  Decompose Government budget
	created date: 2021-03-10
    created by   :  Jean Chateau
    called by    : "%OutMngtDir%\OutMacro.gms"
--------------------------------------------------------------------------------
	$URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/OutMacroPrg/10-Gov_Revenues.gms $
	last changed revision: $Rev: 375 $
	last changed date    : $Date:: 2023-08-29 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

$$ONDOTL

out_Macroeconomic(abstype,"Government budget","Production taxes","nominal",ra,%1)
    = sum(mapr(ra,r),To%YearBaseMER%MER(r) * m_true2(ygov,r,"ptax",%1)) ;

out_Macroeconomic(abstype,"Government budget","Factor taxes","nominal",ra,%1)
    = sum(mapr(ra,r),To%YearBaseMER%MER(r) * m_true2(ygov,r,"vtax",%1)) ;

out_Macroeconomic(abstype,"Government budget","Indirect taxes","nominal",ra,%1)
    = sum(mapr(ra,r),To%YearBaseMER%MER(r) * m_true2(ygov,r,"itax",%1)) ;

out_Macroeconomic(abstype,"Government budget","Import taxes","nominal",ra,%1)
    = sum(mapr(ra,r),To%YearBaseMER%MER(r) * m_true2(ygov,r,"mtax",%1)) ;

out_Macroeconomic(abstype,"Government budget","Export taxes","nominal",ra,%1)
    = sum(mapr(ra,r),To%YearBaseMER%MER(r) * m_true2(ygov,r,"etax",%1)) ;

* including "trg" & "kappah"

out_Macroeconomic(abstype,"Government budget","Direct taxes","nominal",ra,%1)
    = sum(mapr(ra,r),To%YearBaseMER%MER(r) * m_true2(ygov,r,"dtax",%1)) ;

out_Macroeconomic(abstype,"Government budget","Carbon taxes","nominal",ra,%1)
    = sum(mapr(ra,r),To%YearBaseMER%MER(r) * m_true2(ygov,r,"ctax",%1)) ;

* Converting in millions of USD

out_Macroeconomic(abstype,"Government budget",macrolist,"nominal",ra,%1)
    = outscale
	* out_Macroeconomic(abstype,"Government budget",macrolist,"nominal",ra,%1) ;

* Expenditure / closure

out_Macroeconomic(abstype,"Government budget","Government Consumption",units,ra,%1)
    = out_Macroeconomic(abstype,"GDP Expenditures","Government Consumption",units,ra,%1) ;

out_Macroeconomic(abstype,"Government budget","Government Saving",units,ra,%1)
    = out_Macroeconomic(abstype,"Credit Market","Government Saving",units,ra,%1) ;

* [EditJean]: TBU
$OnText
out_Macroeconomic(abstype,"Government budget","Total Taxes","nominal",ra,%1)
    = sum((r,gytax) $ mapr(ra,r), m_true2(ygov,r,gytax,%1));

* subsidy categories are negative --> put minus beside
out_Macroeconomic(abstype,"Government budget","Consumption subsidies","nominal",ra,%1)
    = - sum(r$mapr(ra,r),m_true2(ygov,r,"isub",%1));
out_Macroeconomic(abstype,"Government budget","Production subsidies","nominal",ra,%1)
    = - sum(r$mapr(ra,r),m_true2(ygov,r,"psub",%1));
out_Macroeconomic(abstype,"Government budget","Factor subsidies","nominal",ra,%1)
    = - sum(r$mapr(ra,r),m_true2(ygov,r,"vsub",%1));
out_Macroeconomic(abstype,"Government budget","Import subsidies","nominal",ra,%1)
    = - sum(r$mapr(ra,r),m_true2(ygov,r,"msub",%1));
out_Macroeconomic(abstype,"Government budget","Export subsidies","nominal",ra,%1)
    = - sum(r$mapr(ra,r),m_true2(ygov,r,"esub",%1));
out_Macroeconomic(abstype,"Government budget","Income subsidies","nominal",ra,%1)
    = - sum(r$mapr(ra,r),m_true2(ygov,r,"dsub",%1));
out_Macroeconomic(abstype,"Government budget","Total Subsidies","nominal",ra,%1)
    = - sum((r,gysub) $ mapr(ra,r), m_true2(ygov,r,gysub,%1));
$OffText
$$OFFDOTL



