$OnText
--------------------------------------------------------------------------------
        [OECD-ENV] Model :  Aggregation Procedure
    GAMS file   : "%SetsDir%\map_EDGAR_GTAP_emissions.gms"
    purpose     : Mapping EDGAR emission (IPCC codes) to GTAP aggregation (ISIC)
                    --> map_EDGAR(ipcc_Codes,EmiSource,a0)
    Created by  : Jean Chateau
    created Date: Updated 2023-03-08
    called by   : "%SatDataDir%\GHG\Export_EDGAR_to_GTAP.gms"
--------------------------------------------------------------------------------
   file:///C:/Dropbox/SVNDepot/ENV10/trunk/PROJECTS/CoordinationG20/InputFiles/ResumeOutput.gms
   last changed revision: $Rev: 520 $
   last changed date    : $Date: 2022-02-24 #$
   last changed by      : $Author: Chateau_J $
*------------------------------------------------------------------------------*
 https://www.ipcc-nggip.iges.or.jp/public/gp/bgp/3_5_SF6_Electrical_Equipment_Other_Uses.pdf

#TODO keep disticntion between transport source -- > for EEB & BIGCO2 too
    "1A3c"  . (roilcomb,biofcomb)   . RAIL     "Rail transportation"
    "1A3e"  . (roilcomb,biofcomb)   . TRNUNSP  "Other transportation"

Memo:   # ipcc sources that are not reported in EDGAR
        * ipcc source that should be split / downscale in GTAP aggregation
*------------------------------------------------------------------------------*
$OffText

$IF NOT SET IPCCvers $SetGlobal IPCCvers "IPCC1996"

$Ifi NOT %GTAP_ver%=="92" $SetGlobal eeq "eeq"
$Ifi     %GTAP_ver%=="92" $SetGlobal eeq "ome"

$Ifi NOT %GTAP_ver%=="92" $SetGlobal wtr "wtr"
$Ifi     %GTAP_ver%=="92" $SetGlobal wtr "osg"

*------------------------------------------------------------------------------*
*                   Emissions from Combustion: Cat.1                           *
*------------------------------------------------------------------------------*

* Memo: "Electricity" and "total" are temporary elements of a0

"1A1a"  . (coalcomb,biomcomb)   . Electricity "Public electricity and heat production*"
"1A1bc" . (roilcomb,biofcomb)   . p_c         "Other Energy Industries*"
"1A2"   . (roilcomb,biofcomb)   . total       "Manufacturing Industries and Construction*"
"1A3a"  . (roilcomb,biofcomb)   . atp         "Domestic aviation"
"1A3b"  . (roilcomb,biofcomb)   . otp         "Road transportation*"
"1A3c"  . (roilcomb,biofcomb)   . otp         "Rail transportation*"
"1A3d"  . (roilcomb,biofcomb)   . wtp         "Inland navigation"
"1A3e"  . (roilcomb,biofcomb)   . otp         "Other transportation*"
"1A4"   . (roilcomb,biofcomb)   . hh          "Residential and other sectors*"
"1A5"   . (roilcomb,biofcomb)   . osg         "Non-Specified"

*   Fugitive Emissions

"1B1"   . fugitive. coa       "Fugitive emissions from solid fuels"
"1B2"   . fugitive. oil       "Fugitive emissions from oil and gas liquid fuels*"
"1B2"   . fugitive. BioFuel   "Fugitive emissions from oil and gas liquid fuels"

* Bunker

"1C1"	. (roilcomb,biofcomb) . avbunk  "International aviation*"
"1C2"	. (roilcomb,biofcomb) . marbunk "International navigation*"

*------------------------------------------------------------------------------*
*                   Process Emissions: Cat.2                                   *
*------------------------------------------------------------------------------*

("2A","2A1","2A2","2A3","2A4","2A5","2A6","2A7").act.nmm "Nonmetallic minerals production"

"2B"                . act    . %chm% "Production of chemicals"

"2C"                . act    . total "Production of metals*"
"2C3"               . act    . nfm   "Process emissions of primary aluminium production#"
("2C4_AL","2C4a")   . act    . nfm   "Process emissions of SF6 used in aluminium production#"
("2C4_MG","2C4b")   . act    . nfm   "Process emissions of SF6 used in magnesium foundries#"

$IF %IPCCvers%=="IPCC1996" "2D"                . act    . ppp   "Production of pulp-paper & food-drink*"

$OnText
Memo:
"ele"	Manufacture of computer, electronic and optical products, communication eqpt
"eeq"	Manufacture of electrical equipment: electric motors,
        batteries and accumulators (battery chargers),
        wire, lighting equipment, domestic appliances (refrigerators)
"ome"	Manufacture of machinery and equipment n.e.c. (Manufacture of ovens)
        Manufacture of commercial and industrial refrigerators and freezers,
        room air-conditioners, fans, commercial-type cooking equipment...
$OffText

"2E"   . act . ele  "Electronic Industry: Byproduct emissions of production of halocarbons and sulphur hexafluoride:Electronics Industry*"
"2E1"  . act . ele  "Byproduct emissions of production of halocarbons and sulphur hexafluoride#"

* These are Product Uses as Substitutes for HFC (and PFC)
* [TBC] 2F3-F6 maybe "chemUse" instead

"2F1"  . act . %eeq%  "Refrigeration and air conditioning (HFC and PFC)#"
"2F1a" . act . %eeq%  "Consumption of halocarbons and sulphur hexafluoride: refrigerator and air conditioning"
"2F1b" . act . %eeq%  "Domestic refrigeration"
"2F1c" . act . %eeq%  "Industrial refrigeration"
"2F1d" . act . %eeq%  "Transport refrigeration"
"2F1e" . act . %eeq%  "Mobile Air Conditioning"
"2F1f" . act . %eeq%  "Stationary Air Conditioning"
"2F2"  . act . %chm%  "Consumption of halocarbons and sulphur hexafluoride: foam blowing#"
"2F2a" . act . %chm%  "Closed cell foam"
"2F2b" . act . %chm%  "Open cell foam"
"2F3"  . act . %chm%  "Consumption of halocarbons and sulphur hexafluoride: fire extinguishers"
"2F4"  . act . %chm%  "Consumption of halocarbons and sulphur hexafluoride: aerosols"
"2F5"  . act . %chm%  "Consumption of halocarbons and sulphur hexafluoride: solvents"
"2F6"  . act . %chm%  "Other ODS"
"2F7"   .act  .ele    "Consumption of halocarbons: Semiconductor electronics manufacture, Including FPDs and PV cells"
"2F7A" . act . ele    "Consumption of halocarbons: semiconductors manufacturing#"
"2F7B" . act . ele    "Consumption of halocarbons: flat panel display production#"
"2F7C" . act . ele    "Consumption of halocarbons: photovoltaic cells manufacturing#"
"2F8"  . act . %eeq%  "Consumption of halocarbons: electrical equipment"

$IFi %ifPower%=="ON"  "2F8b" . act . TnD  "Consumption of halocarbons: electrical equipment use#"
$IFi %ifPower%=="OFF" "2F8b" . act . ELY  "Consumption of halocarbons: electrical equipment use#"

* [TBC] 2F9 maybe "eeq" instead / "chemUse" instead

"2F9"  . chemUse . Total  "Other F-gas use and SF6*"

* Memo: Inactive -->
"2F9a" . chemUse . tex   "Other F-gas use and SF6: adiabatic prop: shoes and others#"
"2F9b" . chemUse . tex   "Other F-gas use and SF6: adiabatic prop: tyres#"
"2F9c" . chemUse . nmm   "Other F-gas use and SF6: sound proof windows#"
"2F9d" . chemUse . osg   "Other F-gas use and SF6: accelerators#"
"2F9e" . chemUse . osg   "Other F-gas use and SF6: awacs, other military, misc.#"
"2F9f" . chemUse . %chm% "Other F-gas use and SF6: unknown SF6 use #"

* use of oil product for Lubricant, wax,... or emissions from asphalt production
* bref super difficile car aussi chemuse

$IF %IPCCvers%=="IPCC1996" "2G".NonAllocated . p_c  "Non-energy use of lubricants/waxes (CO2)"

*------------------------------------------------------------------------------*
*              Solvent and other product use: Cat.3                            *
*------------------------------------------------------------------------------*

* May be 3A, 3B & 3D should be allocated in different sectors

"3A". chemUse .  mvh    "Solvent and other product use: paint*"
"3B". chemUse .  trd    "Solvent and other product use: degrease*"
"3C". chemUse .  %chm%  "Solvent and other product use: chemicals*"

$IFtheni.IPCC1996 %IPCCvers%=="IPCC1996"

"3D". chemUse .  hh     "Solvent and other product use: other*"

$Else.IPCC1996

"2G". chemUse .  hh     "Other Product Manufacture and Use*"
"2D". chemUse .  %chm%	"Non-Energy Products from Fuels and Solvent Use"

$EndIf.IPCC1996

*------------------------------------------------------------------------------*
*                   Agriculture Emissions: Cat.4                               *
*------------------------------------------------------------------------------*

*   All this should be realloacted excluded: "4C".Land.pdr

$IFtheni.IPCC1996 %IPCCvers%=="IPCC1996"

"4A"  . Capital   .  ctl    "Enteric fermentation*"
"4B"  . Land      .  ctl    "Manure management*"
"4D2" . Land      .  ctl    "Manure in pasture/range/paddock*"

"4C"  . Land      .  pdr    "Rice cultivation"
"4D"  . chemUse   .  wht    "Direct agricultural soil emissions (fertilizers, manure, crop residues)#"
"4D1" . chemUse   .  wht    "Direct soil emissions*"
"4D3" . act       .  v_f    "Indirect N2O from agriculture*"
"4D4" . Land      .  wht    "Other direct soil emissions*"

"4E"  . AgrBurn   .  wht    "Savannah burning#"
"4F"  . AgrBurn   .  wht    "Agricultural waste burning*"

$Else.IPCC1996

"3A1"  . Capital   .  ctl   "Enteric fermentation*"
"3A2"  . Land      .  ctl   "Manure management*"
"3C7"  . Land      .  pdr   "Rice cultivation"
"3C4"  . chemUse   .  wht   "Direct soil emissions*"
"3C5"  . act       .  v_f   "Indirect N2O from agriculture*"
"3C6"  . Land      .  ctl   "Indirect N2O Emissions from manure management"
"3C1"  . AgrBurn   .  wht   "Agricultural waste burning*"
"3C2"  . chemUse   .  wht   "Liming"
"3C3"  . chemUse   .  wht   "Urea application"

$EndIf.IPCC1996

* 5. Land Use Change and Forestry --> vide

*------------------------------------------------------------------------------*
*                   Waste emisisons: Cat.6                                     *
*------------------------------------------------------------------------------*
$IFtheni.IPCC1996 %IPCCvers%=="IPCC1996"

"6A"  . wastesld  .  Waste   "Solid waste disposal on land"
"6B"  . wastewtr  .  Waste   "Wastewater handling"
"6C"  . wasteinc  .  Waste   "Waste incineration#"
"6D"  . wastesld  .  Waste   "Other waste handling"

$Else.IPCC1996

"4A"  . wastesld  .  Waste   "Solid waste disposal on land"
"4B"  . wastesld  .  Waste   "Biological Treatment of Solid Waste"
"4C"  . wasteinc  .  Waste   "Incineration and Open Burning of Waste"
"4D"  . wastewtr  .  Waste   "Wastewater Treatment and Discharge"

$EndIf.IPCC1996


*------------------------------------------------------------------------------*
*                    No idea where to allocate Cat.7                           *
*------------------------------------------------------------------------------*
* but memo : 7B & 7C Indirect N2O emissions from energy
* also for International bunkers so these sources
* --> associated with refined oil combustion
* "7A" Coal fires / Oil

"7A"  . NonAllocated . Total     "Fossil fuel fires"
"7B"  . NonAllocated . Total     "Indirect N2O from non-agricultural NOx"
"7C"  . NonAllocated . Total     "Indirect N2O from non-agricultural NH3"

"5A"  . AgrBurn . frs	 "Forest fires, including peat fires"

* IPPC2006

$IFi %IPCCvers%=="IPCC2006" "5B"  . NonAllocated . Total	 "Fossil fuel fires"
