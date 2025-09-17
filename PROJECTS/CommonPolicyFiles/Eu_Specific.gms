$Setargs GhgGas Label Sectors

$IFi %GhgGas%=="CO2" 	  $SetLocal EmL "%GhgGas%"
$IFi %GhgGas%=="GHG" 	  $SetLocal EmL "EmSingle"
$IFi %GhgGas%=="EUETSGAS" $SetLocal EmL "EUETSGAS"

* Aggregate regions

* EU-ETS (ie WEU)

EmiOutput("%SimAff%","%GhgGas%: ETS wrt %EmiYrRef%","EU-ETS","%Label%",tsim)
	$  sum((WEU,EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,WEU,%emL%,EmiSourceAct,%Sectors%,"%EmiYrRef%"))
	= (sum((WEU,EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,WEU,%emL%,EmiSourceAct,%Sectors%,tsim))
	 / sum((WEU,EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,WEU,%emL%,EmiSourceAct,%Sectors%,"%EmiYrRef%"))
	- 1 ) * 100 ;
EmiOutput("%SimAff%","%GhgGas%: ETS wrt 2005","EU-ETS","%Label%",tsim)
	$  sum((WEU,EmiSourceAct,%Sectors%,%EmL%),emi2005(WEU,%emL%,EmiSourceAct,%Sectors%))
	= (sum((WEU,EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,WEU,%emL%,EmiSourceAct,%Sectors%,tsim))
	 / sum((WEU,EmiSourceAct,%Sectors%,%EmL%),emi2005(WEU,%emL%,EmiSourceAct,%Sectors%))
	- 1 ) * 100 ;

* EU only (ie EU)
EmiOutput("%SimAff%","%GhgGas%: ETS wrt %EmiYrRef%","EU","%Label%",tsim)
	$  sum((EU,EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,EU,%emL%,EmiSourceAct,%Sectors%,"%EmiYrRef%"))
	= (sum((EU,EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,EU,%emL%,EmiSourceAct,%Sectors%,tsim))
	/  sum((EU,EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,EU,%emL%,EmiSourceAct,%Sectors%,"%EmiYrRef%"))
	- 1 ) * 100 ;

EmiOutput("%SimAff%","%GhgGas%: ETS wrt 2005","EU","%Label%",tsim)
	$  sum((EU,EmiSourceAct,%Sectors%,%EmL%), emi2005(EU,%emL%,EmiSourceAct,%Sectors%))
	= (sum((EU,EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,EU,%emL%,EmiSourceAct,%Sectors%,tsim))
	/  sum((EU,EmiSourceAct,%Sectors%,%EmL%), emi2005(EU,%emL%,EmiSourceAct,%Sectors%))
	- 1 ) * 100 ;

*	Individual countries: WEU

EmiOutput("%SimAff%","%GhgGas%: ETS wrt %EmiYrRef%",WEU,"%Label%",tsim)
	$  sum((EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,WEU,%emL%,EmiSourceAct,%Sectors%,"%EmiYrRef%"))
	= (sum((EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,WEU,%emL%,EmiSourceAct,%Sectors%,tsim))
	 / sum((EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,WEU,%emL%,EmiSourceAct,%Sectors%,"%EmiYrRef%"))
	- 1 ) * 100 ;

EmiOutput("%SimAff%","%GhgGas%: ETS wrt 2005",WEU,"%Label%",tsim)
	$  sum((EmiSourceAct,%Sectors%,%EmL%), emi2005(WEU,%emL%,EmiSourceAct,%Sectors%))
	= (sum((EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,WEU,%emL%,EmiSourceAct,%Sectors%,tsim))
	/  sum((EmiSourceAct,%Sectors%,%EmL%), emi2005(WEU,%emL%,EmiSourceAct,%Sectors%))
	- 1 ) * 100 ;

$IFTheni.TEST %GhgGas%=="EUETSGAS"

EmiOutput("%SimAff%","%GhgGas%: ETS wrt 2005","EU","%Label%",tsim)
	$  sum(EU, EMIETS2005(EU))
	= (sum((EU,EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,EU,%emL%,EmiSourceAct,%Sectors%,tsim))
		/  sum(EU, EMIETS2005(EU))	- 1 ) * 100 ;

EmiOutput("%SimAff%","%GhgGas%: ETS wrt 2005",WEU,"%Label%",tsim)
	$  EMIETS2005(WEU)
	= ( sum((EmiSourceAct,%Sectors%,%EmL%), m_true4(emi,WEU,%emL%,EmiSourceAct,%Sectors%,tsim))
		/ EMIETS2005(WEU) - 1 ) * 100 ;

$ENDIF.TEST

$DropLocal EmL