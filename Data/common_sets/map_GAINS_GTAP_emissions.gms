*       GAINS Sources                       | ENV_Linkages Source | GTAP agent

*------------------------------------------------------------------------------*
*                         Process Emissions                                    *
*------------------------------------------------------------------------------*

$OnText
Zig Answer (2019-06-26)
but “Other industries” and linked with the ENV_Linkages sector
“Other industry” and represent in GAINS all “Other_pollutantX” sector

The sector “Other manufacturing” is associated with ENV_L sector “omx-a” and includes rather
small sources like PM and CO emissions from industrial processes that are not individually
recognized in the model, fugitive PM emissions from storage and distribution of industrial
‘ bulk’  products, and VOC emissions from some not specifically
identified industrial sectors like asphalt paving for example.
$OffText

"Other manufacturing" . act . omf

"Aluminium - primary"                            . act        .  nfm
"Aluminium - secondary"                          . act        .  nfm
"Non-ferrous metals, process"                    . act        .  nfm
"Iron and steel, process"                        . act        .  i_s

$OnText
?   “Feed stocks”: of “refineries” or “chemicals”?
These will be chemical industry feedstocks and there shall not be any emissions
of air pollutants but there will be CO2 and also methane
that is from storage and distribution of gas used as feedstock
so in fact for methane it belongs to the storage and distribution
..but we did not do a pollutant specific sector allocation and so it ended up in feedstocks
$OffText

* [TBC] Alternative ? "Feed stocks".gdtcomb.crp

"Feed stocks".act.%chm%

$OnText
    ?   These are NMVOC emissions from storage of liquid products
    (gasoline and diesel) at the refinery,
    distribution depots and gasoline stations including transport
    of these products from refinery to depots and form depots to gasoline stations
    - and they are linked to the ‘ p_c-a’ sector and not ‘oil-a’
    which includes upstream losses from production, flaring, transport.
    I think originally i had it all as “oil_a”  but the nit was changed
$OffText
* [TBC] Alternative ?? "Distribution - liquid fuels".otp.p_c
"Distribution - liquid fuels"                         .act        .  p_c
"Chemicals, processes"                               . act        .  %chm%

"Coal mining"                                        . act        .  coa
"Construction"                                       . act        .  cns
"Pulp and paper, process"                            . act        .  ppp
"Wood products"                                      . act        .  lum
*---    [To be reallocated] between food sectors en fait non très faible et ne concerne que EU
"Food products"                                      . act        .  ofd
*---    [To be reallocated] between other industries (see 08-AirPollution.gms)
"Other industries"                                   . act        .  ele

$OnText
    Zig Answer (2019-06-26)
    Emissions from “conversion combustion”: are these linked to energy
    / fuel transformation (e.g. liquifying coal)?
    Yes, ….BUT looking at it I found an error in allocation i think.
    We have now part of the conversion sector alocated
    with power sector and part with this ‘conversion’ sector which is associated
    with ENV-L category p_c-a.
    I guess we shall fix it and all shall be ‘p_c-a – energy transformation’?
$OffText

"Briquette production"                               . act        .  p_c
"Gas distribution"                                   . act        .  gdt
"Gas production - fugitive and flaring"              . act        .  gas
"Non-metallic minerals"                              . act        .  nmm
"Oil production - fugitive and flaring"              . act        .  oil
"Refineries"                                         . act        .  p_c
"Other mining"                                       . act        .  %oxt%


*------------------------------------------------------------------------------*
*                   Agriculture Emissions                                      *
*------------------------------------------------------------------------------*

$OnText
Zig Answer (2019-06-26)
Difference between diary cattle and livestock dairy cattle? There are CH4 emissions in both.
o   No difference, this shoudl have been all reported as “livestock dairy cattle”.
We have forgotten to change the name associatd with one specific GIANS sector.
In the revision the “livestock dairy cattle” will have totals.
And it is not only for CH4, also NH3 has these.
$OffText

"Livestock beef cattle"                              . Capital    .  ctl
"Livestock dairy cattle"                             . Capital    .  rmk
"Livestock other"                                    . Capital    .  oap
*   Obsolete after august 2019: "Dairy cattle".Capital.rmk

"Rice"                                               . Land       .  pdr

*---    [To be reallocated] between crops (see 08-AirPollution.gms)
"Agr_waste burning"                                  . biofcomb   .  wht
"Crops"                                              . chemUse    .  wht

*------------------------------------------------------------------------------*
*                   Emissions from Combustion                                  *
*------------------------------------------------------------------------------*

*---    Transportation sectors:
"Air transport"                                      . roilcomb   .  atp

"Land transport, other - gas"                        . gascomb    .  otp
"Land transport, other - oil"                        . roilcomb   .  otp
"Land transport, other - coal"                       . coalcomb   .  otp

"Water transport - gas"                              . gascomb    .  wtp
"Water transport - oil"                              . roilcomb   .  wtp

* Allocate between households, transportation and services (logically all sectors)
*---    Assumptions Rail and collective are by definition otp, for example
* Osg by a lot of otp --> Public Transportation ?
"Land transport, rail - oil"                         . roilcomb   .  otp
"Land transport, road collective - gas"              . gascomb    .  otp
"Land transport, road collective - oil"              . roilcomb   .  otp
* [TBC]-->
"Land transport, road collective - hydrogen"         . hydcomb    .  total

"Land transport, road privates - gas"                . gascomb    .  total
"Land transport, road privates - oil"                . roilcomb   .  total
* [TBC]-->
"Land transport, road privates - hydrogen"           . hydcomb    .  total

*---    Heat for households and residential
*---> [To be reallocated] between households and Services (Heat combustion)
* for sake of simplicity we allocate them to one sector of services
* since road will only be for households
* (see 08-AirPollution.gms)
"Residential - biofuels"                             . biofcomb   .  hh
"Residential - coal"                                 . coalcomb   .  obs
"Residential - liquid fuels"                         . roilcomb   .  obs
"Residential - natural gas"                          . gascomb    .  obs

$OnText
Zig Answer (2019-06-26)
The “Residential -fuelX” sector refer to stationary combustion
in residential-commercial sector.
“Households” inlcude some other categories like barbeques, cigarette smoking, fireworks,
whicl “Households-oil” is specifically referring to emissions from lawnmowers…but also saws, snow scooters,
small recreational boats….so it is a bit of mix of things but we have eventually decided to put this as housholds
– in GAINS these are non-road two stroke engines
$OffText

* For the moment put this in act emissions even if not effective for households
"Households"                                         . act        .  hh
"Households - oil"                                   . roilcomb   .  hh

*---    Energy sectors:
$IfTheni.power %ifPower%=="ON"
    "Power plants - biofuels, waste"   . biofcomb   .  OtherBL
    "Power plants - coal"              . coalcomb   .  CoalBL
    "Power plants - liquid fuels"      . roilcomb   .  OilBL
    "Power plants - natural gas"       . gascomb    .  GasBL
$ELSE.power
    "Power plants - biofuels, waste"   . biofcomb   .  ELY
    "Power plants - coal"              . coalcomb   .  ELY
    "Power plants - liquid fuels"      . roilcomb   .  ELY
    "Power plants - natural gas"       . gascomb    .  ELY
$ENDIF.power

"Conversion, combustion - biofuels, waste"           . biofcomb   .  p_c
"Conversion, combustion - coal"                      . coalcomb   .  p_c
"Conversion, combustion - gas"                       . gascomb    .  p_c
"Conversion, combustion - oil"                       . roilcomb   .  p_c

*---    Industry sectors
"Pulp and paper, combustion - biofuels, waste"       . biofcomb   .  ppp
"Pulp and paper, combustion - coal"                  . coalcomb   .  ppp
"Pulp and paper, combustion - gas"                   . gascomb    .  ppp
"Pulp and paper, combustion - oil"                   . roilcomb   .  ppp

* [TBC] : what is the composition of Chemicals for GAINS
*   Option 1: chm + bph + rpp --> then should allocate below for this 3 cat.
*   Option 2: Only chm --> then should allocate bph + rpp in OtherInd

$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
    "Chemicals, combustion - biofuels, waste"            . biofcomb   .  chm
    "Chemicals, combustion - coal"                       . coalcomb   .  chm
    "Chemicals, combustion - gas"                        . gascomb    .  chm
    "Chemicals, combustion - oil"                        . roilcomb   .  chm
$else.gtap10
    "Chemicals, combustion - biofuels, waste"            . biofcomb   .  crp
    "Chemicals, combustion - coal"                       . coalcomb   .  crp
    "Chemicals, combustion - gas"                        . gascomb    .  crp
    "Chemicals, combustion - oil"                        . roilcomb   .  crp
$endif.gtap10

"Non-ferrous metals, combustion - biofuels, waste"   . biofcomb   .  nfm
"Non-ferrous metals, combustion - coal"              . coalcomb   .  nfm
"Non-ferrous metals, combustion - gas"               . gascomb    .  nfm
"Non-ferrous metals, combustion - oil"               . roilcomb   .  nfm

"Iron and steel, combustion - biofuels, waste"       . biofcomb   .  i_s
"Iron and steel, combustion - coal"                  . coalcomb   .  i_s
"Iron and steel, combustion - gas"                   . gascomb    .  i_s
"Iron and steel, combustion - oil"                   . roilcomb   .  i_s

*---> New: "Non-ferrous metals, combustion"


*---    [To be reallocated] between other industries --> Warning the EL source should be distinct
"Other industry, combustion - biofuels, waste"       . biofcomb   .  ele
"Other industry, combustion - coal"                  . coalcomb   .  ele
"Other industry, combustion - gas"                   . gascomb    .  ele
"Other industry, combustion - oil"                   . roilcomb   .  ele

*------------------------------------------------------------------------------*
*                       Miscelleanous Emissions                                *
*------------------------------------------------------------------------------*
$OnText
Zig Answer (2019-06-26)
Emissions from « chemical use »: use of chemicals by which sectors?
there is different level of detail (in GAINS) for Europe and the rest of the world
when it comes to this sector for VOC

but in principle it includes emissions from paint application (both household as well as industry),
dry cleaning, wood preservation, leather tanning, degreasing, coil coating,
wire coating, glue application,
domestic/household solvent use.

For NH3, you see also these emissions, it includes emissions
from mineral fertilizer use (application on land).
$OffText

* [TBC]
"Chemical use". chemUse.  hh

$OnText
We had some discussion about it and allocated it to ‘osc-a’
; it includes VOC emissions from refinishing of vehicles
(painting after accident/repair) and also underbody treatment and dewaxing.
ONLY FOR EUROPE
$OffText
* [TBC]
"Services - vehicles". chemUse.trd

$OnText
Again, talked about and decided to associate with ‘pop-a’ in ENV_L;
it inlcudes printing sector (packaging, publishing, offset, screen printing)
and so only NMVOC emissions
$OffText
* [TBC]
"Services - printing".chemUse.ppp

*------------------------------------------------------------------------------*
*                   Waste emisisons: How To allocate these [TBR]               *
*------------------------------------------------------------------------------*

$OnText
"Solid waste - industrial - paper"                   . wastesld   .  ppp
"Solid waste - industrial - wood"                    . wastesld   .  lum
"Solid waste - municipal"                            . wastesld   .  osg

*---    To be reallocated between correspondings GTAP sectors
"Solid waste - industrial - textile"                 . wastesld   .  tex
"Solid waste - industrial - food"                    . wastesld   .  ofd

"Waste water - industrial - paper"                   . wastewtr   .  ppp
"Waste water - municipal"                            . wastewtr   .  osg
"Residential - waste water"                          . wastewtr   .  hh

*---    To be reallocated between correspondings GTAP sectors
"Waste water - industrial - food"                    . wastewtr   .  ofd
"Waste water - industrial - other"                   . wastewtr   .  ele
$OffText

$ifTheni.gtap10 NOT %GTAP_ver%=="92" !! GTAP version 10 and above
    "Solid waste - industrial - paper"                   . act   .  wtr
    "Solid waste - industrial - wood"                    . act   .  wtr
    "Solid waste - municipal"                            . act   .  wtr

*---    To be reallocated between correspondings GTAP sectors
    "Solid waste - industrial - textile"                 . act   .  wtr
    "Solid waste - industrial - food"                    . act   .  wtr

    "Waste water - industrial - paper"                   . act   .  wtr
    "Waste water - municipal"                            . act   .  wtr
    "Residential - waste water"                          . act   .  wtr

*---    To be reallocated between correspondings GTAP sectors
    "Waste water - industrial - food"                    . act   .  wtr
    "Waste water - industrial - other"                   . act   .  wtr
$else.gtap10
    "Solid waste - industrial - paper"                   . act   .  osg
    "Solid waste - industrial - wood"                    . act   .  osg
    "Solid waste - municipal"                            . act   .  osg

*---    To be reallocated between correspondings GTAP sectors
    "Solid waste - industrial - textile"                 . act   .  osg
    "Solid waste - industrial - food"                    . act   .  osg

    "Waste water - industrial - paper"                   . act   .  osg
    "Waste water - municipal"                            . act   .  osg
    "Residential - waste water"                          . act   .  osg

*---    To be reallocated between correspondings GTAP sectors
    "Waste water - industrial - food"                    . act   .  osg
    "Waste water - industrial - other"                   . act   .  osg
$endif.gtap10
