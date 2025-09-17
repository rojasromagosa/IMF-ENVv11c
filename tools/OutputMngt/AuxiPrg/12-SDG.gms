$OnText
--------------------------------------------------------------------------------
   OECD ENV-Linkages project Version 4
   purpose: Reporting SDG indicators
--------------------------------------------------------------------------------
$OffText

$OnText
    Targets:    https://www.un.org/sustainabledevelopment/climate-change/
    Indicators: https://sustainabledevelopment.un.org/sdg11
$OffText

$OnText
WHO monitors three air pollution –related SDG indicators
    3.9.1 Air pollution-related mortality
    7.1.2 Access to clean energy in homes
    11.6.2 Air quality in cities
$OffText

* 1. SDG1 End poverty in all its forms everywhere
*       1.1 By 2030, eradicate extreme poverty for all people everywhere, currently measured as people living on less than $1.25 a day

out_SDG("1.1","1.1.A Real GDP per capita",ra,tt) =
    out_Macroeconomic("abs","GDP","GDP per capita (cst PPP)","real",ra,tt);

* =======================================================================

* 2. SDG2 End hunger, achieve food security and improved nutrition and promote sustainable agriculture
*       2.3 By 2030, double the agricultural productivity and incomes of small-scale food producers, in particular women,
*   indigenous peoples, family farmers, pastoralists and fishers, incl. through secure and equal access to land,
*   other productive resources and inputs, knowledge, financial services, markets and opportunities for value addition and non-farm employment

out_SDG("2.3","2.3.A Agricultural productivity",ra,t)
    $ sum((ag,l,abstype), out_Labour(abstype,"Employment","volume",ra,l,ag,t))
    = sum((ag,abstype), out_Value_Added(abstype,"Basic Prices","real",ra,ag,t))
    / sum((ag,l,abstype), out_Labour(abstype,"Employment","volume",ra,l,ag,t));


* =======================================================================

* 3. SDG3 Ensure healthy lives and promote well-being for all at all ages
*       3.9 By 2030, substantially reduce the number of deaths and illnesses from hazardous chemicals and air, water and soil pollution and contamination

out_SDG("3.9","3.9.1.1 Mortality rate attributed to outdoor air pollution",ra,t0) = -999; !! [TBU]

* =======================================================================

* 7. SDG7 Ensure access to affordable, reliable, sustainable and modern energy for all
*       7.2 By 2030, increase substantially the share of renewable energy in the global energy mix

out_SDG("7.2","7.2.1 Renewable energy share in the final energy consumption",ra,t0) = -999; !! [TBU]

out_SDG("7.2","7.2.1.a Renewable energy share in electricity",ra,t) =
    out_Energy("pct","Renewable Electricity share","TWh",ra,"TotEly",t);

*       7.3 By 2030, double the global rate of improvement in energy efficiency

out_SDG("7.3","7.3.1 Energy intensity (primary energy / GDP)",ra,t)
    $(out_Gross_output("abs","real",ra,"ttot-a",t))
    = out_Energy("abs","Energy Demand: Total","Mtoe",ra,"Total",t)
    / [0.001 * out_Gross_output("abs","real",ra,"ttot-a",t)]
    ;
    !! [TBU] [to be fixed] issue with energy demand calc

* =======================================================================

* 8. SDG8 Promote sustained, inclusive and sustainable economic growth, full and productive employment and decent work for all
*       8.1. targets 8.1 Sustain per capita economic growth in accordance with national circumstances and, in particular, at least 7 per cent gross domestic product growth per annum in the least developed countries

out_SDG("8.1","8.1.1 Annual growth rate of real GDP per capita",ra,t) =
    out_GDP("g_dev","PPP Per Capita","real",ra,t);

*       8.2 Achieve higher levels of economic productivity through diversification, technological upgrading and innovation, incl. through a focus on high-value added and labour-intensive sectors

out_SDG("8.2","8.2.1 Annual growth rate of real GDP per employed person",ra,t) =
    out_Labour("g_dev","Labour productivity","real",ra,"Labour","ttot-a",t);

*       8.4 Improve progressively, through 2030, global resource efficiency in consumption and production and endeavour to decouple economic growth from environmental degradation, in accordance with the 10-year framework of programmes on sustainable consumption and production, with developed countries taking the lead

* [TBU] material footprints for all countries

$ifThenI.mat %module_materials%==ON
    out_SDG("8.4","8.4.1.a Material footprint","World",t) =
        out_Materials("abs","Material use","All materials (Gt)","World","Primary",t);

    out_SDG("8.4","8.4.1.b Material footprint per capita",ra,t)
        $(sum(mapr(ra,r), m_true(POP(r,t)))) =
        out_SDG("8.4","8.4.1.a Material footprint",ra,t)
        / sum(mapr(ra,r), m_true(POP(r,t)))
        ;

    out_SDG("8.4","8.4.1.c Material footprint per GDP",ra,t)
        $(out_GDP("abs","PPP","real",ra,t)) =
        out_SDG("8.4","8.4.1.a Material footprint",ra,t)
        / out_GDP("abs","PPP","real",ra,t) !! [TBU] check with Jean: PPP vs. MER?
        ;

    out_SDG("8.4","8.4.2.a Domestic material consumption",ra,t) =
        out_Materials("abs","Material use","All materials (Gt)",ra,"Primary",t);

    out_SDG("8.4","8.4.2.b Domestic material consumption per capita",ra,t)
        $(sum(mapr(ra,r), m_true(POP(r,t)))) =
        out_Materials("abs","Material per capita","All materials (Gt)",ra,"Primary",t)
        / sum(mapr(ra,r), m_true(POP(r,t)))
        ;

    out_SDG("8.4","8.4.2.c Domestic material consumption per GDP",ra,t)
        $(out_GDP("abs","PPP","real",ra,t)) =
        out_SDG("8.4","8.4.2.a Domestic material consumption",ra,t)
        / out_GDP("abs","PPP","real",ra,t) !! [TBU] check with Jean: PPP vs. MER?
        ;
$endIf.mat

* =======================================================================

* 9. SDG 9 Build resilient infrastructure, promote inclusive and sustainable industrialization and foster innovation
*       9.4 By 2030, upgrade infrastructure and retrofit industries to make them sustainable, with increased resource-use efficiency and greater adoption of clean and environmentally sound technologies and industrial processes, with all countries taking action in accordance with their respective capabilities

out_SDG("9.4","9.4.1 CO2 emission per unit of value added",ra,t)
    $(out_GDP("abs","PPP","real",ra,t)) =
    out_Environment("abs","Emission all sources","CO2 (Mt CO2eq)",ra,"Total",t)
    / [0.001 * out_GDP("abs","PPP","real",ra,t)] !! [TBU] check with Jean: PPP vs. MER?
    ;

* =======================================================================

* 10. SDG 10 Reduce inequality within and among countries
*       10.1 By 2030, progressively achieve and sustain income growth of the bottom 40 per cent of the population at a rate higher than the national average

out_SDG("10.4","10.1.1.1 GR of household expenditure among the total population",ra,t) =
    out_Macroeconomic("g_dev","GDP Expenditures","Household Consumption per capita","real",ra,t);
* [TBU] issue with this value (only pct shows up but clearly abs)

out_SDG("10.4","10.1.1.2 GR of household expenditure among the bottom 40%",ra,t0) = -999; !! [TBU]

out_SDG("10.4","10.1.1.3 GR of income per capita among the total population",ra,t) =
    out_Macroeconomic("abs","GDP","Disposable income per capita (cst PPP)","real",ra,t);

out_SDG("10.4","10.1.1.4 GR of income per capita among the bottom 40%",ra,t0) = -999; !! [TBU]

*       10.4 Adopt policies, especially fiscal, wage and social protection policies, and progressively achieve greater equality
out_SDG("10.4","10.4.1 Labour share of GDP (wages and social protection)",ra,t) =
    out_Macroeconomic("abs","Remarkable Ratios","Labour Income Share","nominal",ra,t)
    ; !! [TBU] check exactly which one it is (social protection...)

* =======================================================================

* 11. SDG11 Make cities and human settlements inclusive, safe, resilient and sustainable
*       11.3 By 2030, enhance inclusive and sustainable urbanization and capacity for participatory, integrated and sustainable human settlement planning and management in all countries
out_SDG("11.3","11.3.1 Ratio of land consumption rate to population growth rate",ra,t0) = -999; !! [TBU]

* =======================================================================

* 12. SDG12 Ensure sustainable consumption and production patterns
*       12.2  By 2030, achieve the sustainable management and efficient use of natural resources
*           12.2.1 Material footprint, material footprint per capita, and material footprint per GDP

$ifThenI.mat %module_materials%==ON
    out_SDG("12.2","12.2.1.a Material footprint",ra,t) =
        out_SDG("8.4","8.4.1.a Material footprint",ra,t);

    out_SDG("12.2","12.2.1.b Material footprint per capita",ra,t) =
        out_SDG("8.4","8.4.1.b Material footprint per capita",ra,t);

    out_SDG("12.2","12.2.1.c Material footprint per GDP",ra,t) =
        out_SDG("8.4","8.4.1.c Material footprint per GDP",ra,t);

    out_SDG("12.2","12.2.2.a Domestic material consumption",ra,t) =
        out_SDG("8.4","8.4.2.a Domestic material consumption",ra,t);

    out_SDG("12.2","12.2.2.b Domestic material consumption per capita",ra,t) =
        out_SDG("8.4","8.4.2.b Domestic material consumption per capita",ra,t);

    out_SDG("12.2","12.2.2.c Domestic material consumption per GDP",ra,t) =
        out_SDG("8.4","8.4.2.c Domestic material consumption per GDP",ra,t);
$endIf.mat

* =======================================================================

* 17. SDG17 Strengthen the means of implementation and revitalize the global partnership for sustainable development
*       17.1 Strengthen domestic resource mobilization, incl. through international support to developing countries, to improve domestic capacity for tax and other revenue collection
out_SDG("17.1","17.1.1 Total government revenue as a proportion of GDP",ra,t) =
    out_Macroeconomic("pct","GDP Expenditures","Government Consumption to GDP (pct)","nominal",ra,t);

out_SDG("17.1","17.1.1.1 Government revenue over GDP, source: XXX",ra,t0) = -999; !! [TBU]

*       17.11 Significantly increase the exports of developing countries, in particular with a view to doubling the least developed countries’ share of global exports by 2020
out_SDG("17.11","17.11.1 Developing countries share of global exports",ra,t0) = -999; !! [TBU]
