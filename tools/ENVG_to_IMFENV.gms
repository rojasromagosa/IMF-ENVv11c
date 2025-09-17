* Load ENV Growth

PARAMETERS
    $$batinclude "%CalDir%\ENV-Growth_parameters_declaration.gms" r tt
;

EXECUTE_LOAD "%iGdxDir_GrowthScen%\%Prefix%%iFile_GrowthScen%.gdx",
    cg_to_gdpT, SSC_to_gdpT, SSP_to_gdpT, ERT, NLGQ, TB_to_gdpT, HCAP,
    INC_to_gdpT, Tax_to_gdpT, Inv_to_gdpT, MGSQ, UNRT, deltaT, CBGDPR,
    VA_share, POPvar, OIL_prod, GAS_prod, ENVGrowth_GDP, ENVGrowth_popT,
    ENVGrowth_pop15T=pop15T, ypc,
    part_extraction, Pub_Health_to_gdpT, Pri_Health_to_gdpT,
    Pub_Health_to_CG, rur_pop_shrT, SAVTGQ ;

* clean NA values

ENVGrowth_GDP(gdp_unit,r,tt)  $ (ENVGrowth_GDP(gdp_unit,r,tt) eq NA) = 0;
part_extraction(r,tt)         $ (part_extraction(r,tt)        eq NA) = 0;
CBGDPR(r,tt)                  $ (CBGDPR(r,tt)                 eq NA) = 0;
MGSQ(r,tt)                    $ (MGSQ(r,tt)                   eq NA) = 0;
Inv_to_gdpT(r,tt)             $ (Inv_to_gdpT(r,tt)            eq NA) = 0;
Tax_to_gdpT(r,tt)             $ (Tax_to_gdpT(r,tt)            eq NA) = 0;
CG_to_gdpT(r,tt)              $ (CG_to_gdpT(r,tt)             eq NA) = 0;
SSC_to_gdpT(r,tt)             $ (SSC_to_gdpT(r,tt)            eq NA) = 0;
SSP_to_gdpT(r,tt)             $ (SSP_to_gdpT(r,tt)            eq NA) = 0;
TB_to_gdpT(r,tt)              $ (TB_to_gdpT(r,tt)             eq NA) = 0;
INC_to_gdpT(r,tt)             $ (INC_to_gdpT(r,tt)            eq NA) = 0;
deltaT(r,tt)                  $ (deltaT(r,tt)                 eq NA) = 0;
ERT(r,tt)                     $ (ERT(r,tt)                    eq NA) = 0;
UNRT(r,tt)                    $ (UNRT(r,tt)                   eq NA) = 0;
NLGQ(r,tt)                    $ (NLGQ(r,tt)                   eq NA) = 0;
OIL_prod(r,tt)                $ (OIL_prod(r,tt)               eq NA) = 0;
GAS_prod(r,tt)                $ (GAS_prod(r,tt)               eq NA) = 0;
ENVGrowth_pop15T(r,tt)        $ (ENVGrowth_pop15T(r,tt)       eq NA) = 0;
rur_pop_shrT(r,tt)            $ (rur_pop_shrT(r,tt)           eq NA) = 0;
Pub_Health_to_gdpT(r,tt)      $ (Pub_Health_to_gdpT(r,tt)     eq NA) = 0;
Pri_Health_to_gdpT(r,tt)      $ (Pri_Health_to_gdpT(r,tt)     eq NA) = 0;
Pub_Health_to_CG(r,tt)        $ (Pub_Health_to_CG(r,tt)       eq NA) = 0;
ENVGrowth_popT(r,tt)          $ (ENVGrowth_popT(r,tt)         eq NA) = 0;

*SAVTGQ(r,tt)                  $ (SAVTGQ(r,tt)                 eq NA) = 0;
*HCAP(r,tt)                    $ (HCAP(r,tt)                   eq NA) = 0;
*TFP_HICKS(r,tt)               $ (TFP_HICKS(r,tt)              eq NA) = 0;


*   ENV-Growth Model: Governement Final Consumption ratio (GDP percentage)

MacroENVG("rgovshr",r,t) = CG_to_gdpT(r,t);

*   ENV-Growth Model: Social Security Contribution ratio (GDP percentage)

MacroENVG("SSC_to_gdpT",r,t) = SSC_to_gdpT(r,t);

*   ENV-Growth Model: Social Security Prestations ratio (GDP percentage)

MacroENVG("SSP_to_gdpT",r,t) = SSC_to_gdpT(r,t);

*   ENV-Growth Model: Current account balance ratio (GDP percentage)

MacroENVG("CBGDPR",r,tt) = CBGDPR(r,tt);

*   ENV-Growth Model: Imports ratio (GDP percentage)

MacroENVG("MGSQ",r,t) = MGSQ(r,t);

*   ENV-Growth Model: Investment (GFCF) ratio (GDP percentage)

MacroENVG("rinvshr",r,t) = Inv_to_gdpT(r,t);

*   ENV-Growth Model: Tax (exluded Social Security Contribution) ratio (GDP percentage)

MacroENVG("Tax_to_gdpT",r,t) = Tax_to_gdpT(r,t);

*   ENV-Growth Model: Trade balance to GDP (GDP percentage)

MacroENVG("TB_to_gdpT",r,t) = TB_to_gdpT(r,t);

*   ENV-Growth Model: Income balance to GDP GDP percentage)

MacroENVG("INC_to_gdpT",r,t) = INC_to_gdpT(r,t);

*   Physical Depreciation rate

MacroENVG("deltaT",r,t) = deltaT(r,t);

*   Aggregate Employment rate (nb of prs employed to population older than 14 yrs. old)

MacroENVG("ERT",r,t) = ERT(r,t);

*   Aggregate Unemployement rate (nb of unemployed to total Active population)

MacroENVG("UNR",r,t) = UNRT(r,t);

* Total population age 15 and older (Millions of persons) : Working-age population

MacroENVG("pop15",r,t) = ENVGrowth_pop15T(r,t) ;

*   Total population (Millions of persons)

MacroENVG("pop",r,t) = ENVGrowth_popT(r,t) ;

* Rural population ratio (total population percentage)

MacroENVG("RurPopShr",r,t) = rur_pop_shrT(r,t);

*   Government savings to GDP (percentages)

MacroENVG("rsg",r,t) = NLGQ(r,t);

*   Gross total saving (GDP percentage)

MacroENVG("SAVTGQ",r,t) = SAVTGQ(r,t);

*   Share of public health expenditures (GDP percentage)

MacroENVG("Pub_Health_to_gdpT",r,t) = Pub_Health_to_gdpT(r,t);
MacroENVG("Pub_Health_to_CG",r,t)   = Pub_Health_to_CG(r,t);

*   Share of private health expenditures (GDP percentage)

MacroENVG("Pri_Health_to_gdpT",r,t) = Pri_Health_to_gdpT(r,t);

*   Average Human Capital

MacroENVG("HCAP",r,t)     = HCAP(r,t);
MacroENVG("OIL_prod",r,t) = OIL_prod(r,t);
MacroENVG("GAS_prod",r,t) = GAS_prod(r,t);

EXECUTE_UNLOAD "%oGdxDir_ExtScen%\OECD-ENVGrowth.gdx",  MacroENVG,
    ENVGrowth_GDP, VA_share, POPvar, ypc;