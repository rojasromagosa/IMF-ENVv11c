*---    Check Policies: save policy tools in a gdx file
PARAMETER Affiche_Policy(sim,*,r,i,aa,t);

$ondotl

Affiche_Policy(sim,"plasttax",r,plastI,a,t)
    $ m_true(xa(r,plastI,a,tsim))
    = sum(plastics_polymerTypes $ plastic_use_coeff(r,plastics_polymerTypes,plastI,plastA,t),
        plastic_use_coeff(r,plastics_polymerTypes,plastI,plastA,t),
        * plastTax(r,plastics_polymerTypes,t)
        * plastCov(r,plastI,plastA,t)
        * m_true(xa(r,plastI,plastA,tsim))
    ) / m_true(xa(r,plastI,plastA,tsim));

Affiche_Policy(sim,"mattax",r,mati,matTaxa,t) $ m_true(xa(r,mati,matTaxa,tsim))
    = sum(CCC_name $ mat_use_coeff(r,CCC_name,mati,matTaxa,t),  mat_use_coeff(r,CCC_name,mati,matTaxa,t) * matTax(r,CCC_name,t) * mat_cov(r,mati,matTaxa,t) * m_true(xa(r,mati,matTaxa,tsim)))
    / m_true(xa(r,mati,matTaxa,tsim));

* Implied tax rate:
Affiche_Policy(sim,"Total",r,mati,matTaxa,t) $ m_Pmat(r,mati,matTaxa,t)
    = m_Pmat(r,mati,matTaxa,t)
    / ((1+m_paTax(r,mati,matTaxa,t))*gammaex(r,mati,matTaxa)*m_true(pat(r,mati,t)) + m_Permis(r,mati,matTaxa,t));

Affiche_Policy(sim,"Patax-equivalent",r,i,aa,t) $ m_Pmat(r,i,aa,t)
* Implied tax rate: use pa(r,i,aa,t)= (1+paTax(r,i,aa,t) + m_Pmat(r,i,aa,t))*gammaex(r,i,aa)*pat(r,i,t) + m_Permis(r,i,aa,t) / scale_pat(r,i,t);
    = m_Pmat(r,i,aa,t)
    / [gammaex(r,i,aa)*m_true(pat(r,i,t))];
* Ad valorem equivalent "on existing" output tax rate (i.e. as (1+_pTax+mattaxadvalorem))
Affiche_Policy(sim,"Ptax-equivalent",r,i,a,t)
    $ (m_Pmat(r,i,a,t) and m_true(px(r,a,t)) * xp(r,a,t))
    = [m_Pmat(r,i,a,t) / [gammaex(r,i,aa)*m_true(pat(r,i,t))]]
    * [{(1+m_paTax(r,i,a,t))*gammaex(r,i,a)*m_true(pat(r,i,t))*m_true(xa(r,i,a,t))} / {m_true(px(r,a,t)) * m_true(xp(r,a,t))}] ;

Affiche_Policy(sim,"ptax",r,"Total",SecondaryMetal,t) = m_ptax(r,SecondaryMetal,t);
Affiche_Policy(sim,"ptax",r,"Total",primarymetal,t) = m_ptax(r,primarymetal,t);
Affiche_Policy(sim,"dtax",r,recyclingi,aa,t)   = m_paTax(r,recyclingi,aa,t);
Affiche_Policy(sim,"dtax",r,miningi,matTaxa,t) = m_paTax(r,miningi,matTaxa,t);
Affiche_Policy(sim,"dtax",r,frti,acr,t) = m_paTax(r,frti,acr,t);

Affiche_Policy(sim,"ctax",r,"Total",aa,t)
    $ sum((em,EmiUse), part(r,em,EmiUse,aa,t))
    = sum((em,EmiUse), part(r,em,EmiUse,aa,t) * emiTax.l(r,em,aa,t)/cscale)
    / sum((em,EmiUse), part(r,em,EmiUse,aa,t));

Affiche_Policy(sim,"Total",r,"Total",a,t) $ delta_tfp(r,a,t)
    = delta_tfp(r,a,t);
Affiche_Policy(sim,"Total",r,i,a,t) $ delta_lambdaio(r,i,a,t)
    = delta_lambdaio(r,i,a,t);
Affiche_Policy(sim,"Total",r,privservi,a,t) $ delta_aio(r,privservi,a,t)
    = delta_aio(r,privservi,a,t);
Affiche_Policy(sim,"Total",r,i,gov,t) $ extra_xa(r,i,gov,t)
    = extra_xa(r,i,gov,t);

$offdotl

Affiche_Policy(sim,is,r,i,aa,t) $ after(t,"%YearEndofSim%") = 0;
PUT_UTILITY failed 'gdxout' / 'tmp\' sim.tl:0 '_Policy.gdx';
EXECUTE_UNLOAD Affiche_Policy;
