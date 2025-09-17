
* calcul des emissions indirectes electriques

$OnDotL

SCALAR IfBCA_sources / 1 /;

PARAMETER
    Emissions_sectoriellea(r,a,t)
    Emi_DomEly(r,t)
    Emi_ShrEly(r,i,t)
    Emissions_directes(r,i,t)
    Emissions_indirectes(r,i,t)
    Emissions_totales(r,i,t)
;

LOOP(CO2,

*   Case: CO2 emissions from fuel combustion

    Emissions_sectorielleA(r,a,t) $ (IfBCA_sources eq 1)
        = sum(mapiEmi(i,EmiFosComb), m_true4(emi,r,CO2,EmiFosComb,a,t) ) ;

*   Case: all CO2 emissions

    Emissions_sectorielleA(r,a,t) $ (IfBCA_sources eq 2)
        = sum(mapiEmi(i,EmiUse), m_true4(emi,r,CO2,EmiUse,a,t) )
        + sum(EmiFp,  m_true4(emi,r,CO2,EmiFp,a,t)  )
        + sum(emiact, m_true4(emi,r,CO2,emiact,a,t) ) ;
) ;

* Electricity emissions

Emissions_sectoriellea(r,"TotEly",t)
    = sum(elya, Emissions_sectorielleA(r,elya,t));

* Assign sectoral emission to commodity

Emissions_directes(r,i,t)
    = sum(a $ gp(r,a,i), Emissions_sectorielleA(r,a,t)) / cScale ;

LOOP(elyi,

    Emi_DomEly(r,t)
        = m_true2(xdt,r,elyi,t) * pdt0(r,elyi)
        / (m_true2(xs,r,elyi,t) * ps0(r,elyi)) ;

    Emi_ShrEly(r,i,t)
        = sum(a $ gp(r,a,i), m_true3(xa,r,elyi,a,t) * pa0(r,elyi,a))
        / ( m_true2(xat,r,elyi,t) * pat0(r,elyi)) ;

);

Emissions_indirectes(r,i,t) $ (not elyi(i))
    = sum(elyi,Emissions_directes(r,elyi,t))
    * Emi_DomEly(r,t) * Emi_ShrEly(r,i,t) ;

Emissions_totales(r,i,t)    $ (not elyi(i))
    = Emissions_directes(r,i,t) + Emissions_indirectes(r,i,t) ;

parameter output(r,i,t) ;

output(r,i,t) = sum(a $ gp(r,a,i), out_Gross_output("abs","real",r,a,t) ) ;

Execute_unload "%cFile%_Decomposition_Emission.gdx",
    Emissions_directes, Emissions_totales, Emissions_indirectes, output ;







