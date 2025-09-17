
$OnText
--------------------------------------------------------------------------------
   OECD ENV-Linkages project
   GAMS file: Leakages_rate.gms
   purpose: Computation of leakages rate.
            Only for variant mode.
   created date: 20 Fevrier 2014
   created by: Jean Chateau
   called by:  postsim.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/OutputMngt/Leakages_Rate%5BTBU%5D.gms $
   last changed revision: $Rev: 299 $
   last changed date    : $Date:: 2023-04-21 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText


* [TBU]
* Updated 26/03/2012

$IfThenI %type_scenario% == 0

emi_nonpoolT(r,t) = 0; emi_poolT(r,t) = 0;

* Emission par pays/sources non membres du pool

emi_nonpoolT(r,t)$(emi_nonpool(simu,r,t)) =   rscale*(
         sum((GHGs,act_emission,i)$(Flag_emi_pi(r,GHGs,i)   eq 0), emissions.l(r,GHGs,act_emission,i) )
+        sum((GHGs,pdt_emi,i)$(Flag_emi_di(r,GHGs,i)        eq 0), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,i))  )
+        sum((GHGs,pdt_emi,h)$(Flag_emi_men(r,GHGs,pdt_emi) eq 0), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,h))  )
+        sum((GHGs,pdt_emi,f)$(Flag_emi_men(r,GHGs,pdt_emi) eq 0), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,f))  )
         )
*add allowed (but capped) leakage through droits
+        (1-Flag_cdm(r))*sum(i, rscale*permits(r,i) - emi_pool_s(simu,r,i,t))
* Emissions de ce pool dans le baseline
- emi_nonpool(simu,r,t);

* Emission par pays/sources membres du pool

emi_poolT(r,t)$(emi_pool(simu,r,t)) =  rscale*(
         sum((GHGs,act_emission,i) $ Flag_emi_pi(r,GHGs,i),   emissions.l(r,GHGs,act_emission,i) )
+        sum((GHGs,pdt_emi,i) $ Flag_emi_di(r,GHGs,i)       , sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,i)) )
+        sum((GHGs,pdt_emi,h) $ Flag_emi_men(r,GHGs,pdt_emi), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,h)) )
+        sum((GHGs,pdt_emi,f) $ Flag_emi_men(r,GHGs,pdt_emi), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,f)) )
*Correct for CDM: move reductions to AnnexI
*+        (Exports_cdmTP(r)/Taxe_carboneTP.l("CDMHosts"))$sum(rp,Flag_cdm(rp) ne 0)
         )
*remove allowed (but capped) leakage through droits
         - (1-Flag_cdm(r))*sum(i, rscale*permits(r,i) - emi_pool_s(simu,r,i,t))
* Emissions de ce pool dans le baseline
         - emi_pool(simu,r,t);

r_leakage_rate(r,t)     = 0; r_leakage_rate_s(r,i,t) = 0; poids_lr_s(i,t) = 0;

r_leakage_rate(r,t)
    $ (emi_nonpoolT(r,t) and sum(r$(emi_pool(simu,r,t)) , emi_poolT(r,t)))
    = - 100 * emi_nonpoolT(r,t)
    / sum(r $ emi_pool(simu,r,t), emi_poolT(r,t));
leakage_rate(t)   = sum(r, r_leakage_rate(r,t));

* By sector

* Emission par pays/sources non membres du pool

emi_nonpoolT_s(r,i,t) $ emi_nonpool_s(simu,r,i,t)
    =   rscale*(
            sum((GHGs,act_emission)$(Flag_emi_pi(r,GHGs,i) eq 0), emissions.l(r,GHGs,act_emission,i) )
        +   sum((GHGs,pdt_emi)     $(Flag_emi_di(r,GHGs,i) eq 0), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,i)) )
        )
*add allowed (but capped) leakage through droits
         + (1-Flag_cdm(r))*(rscale*permits(r,i) - emi_pool_s(simu,r,i,t))
* Emissions de ceci dans le baseline
         - emi_nonpool_s(simu,r,i,t);

* Emission par pays/sources membres du pool
emi_poolT_s(r,i,t)$(emi_pool_s(simu,r,i,t)) =  rscale*(
         sum((GHGs,act_emission)$(Flag_emi_pi(r,GHGs,i)  gt 0),   emissions.l(r,GHGs,act_emission,i) )
+        sum((GHGs,pdt_emi)$(Flag_emi_di(r,GHGs,i)       gt 0),   sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,i))      )
)

*do not move CDM to AnexI (as CDM imports cannot be atttributed) and total pool is not changed by CDM
*remove allowed (but capped) leakage through droits

         - (1-Flag_cdm(r))*(rscale*permits(r,i) - emi_pool_s(simu,r,i,t))
* Emissions de ce pool dans le baseline
         - emi_pool_s(simu,r,i,t);

*---    Calculate emissions from consumption as separate "sector"

emi_nonpoolT_s(r,"men",t) $ emi_nonpool_s(simu,r,"men",t) =   rscale*(
+        sum((GHGs,pdt_emi,h)$(Flag_emi_men(r,GHGs,pdt_emi) eq 0), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,h))  )
+        sum((GHGs,pdt_emi,f)$(Flag_emi_men(r,GHGs,pdt_emi) eq 0), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,f))      )
)
- emi_nonpool_s(simu,r,"men",t);

emi_poolT_s(r,"men",t)$(emi_pool_s(simu,r,"men",t)) =  rscale*(
+        sum((GHGs,pdt_emi,h) $ Flag_emi_men(r,GHGs,pdt_emi), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,h))  )
+        sum((GHGs,pdt_emi,f) $ Flag_emi_men(r,GHGs,pdt_emi), sum(type_emission_EL$(map_emi_fuel(type_emission_EL,pdt_emi)),emissions.l(r,GHGs,type_emission_EL,f))  )
)
- emi_pool_s(simu,r,"men",t);

leakage_rate_s(i,t) = 0;

IF(ord(simu) gt 1,
    leakage_rate_s(i,t)   =  sum(r$(emi_pool_s(simu,r,i,t)), emi_poolT_s(r,i,t));
    r_leakage_rate_s(r,i,t) $ leakage_rate_s(i,t)
        = - 100 * emi_nonpoolT_s(r,i,t) / leakage_rate_s(i,t);
    leakage_rate_s(i,t) = sum(r, r_leakage_rate_s(r,i,t));
    poids_lr_s(i,t) $ sum(r$(emi_pool(simu,r,t)) , emi_poolT(r,t))
        = sum(r $ emi_pool_s(simu,r,i,t) , emi_poolT_s(r,i,t))
        / sum(r $ emi_pool(simu,r,t),      emi_poolT(r,t));
);

rwork(r) = 0; work = 0;

$ENDIF

$OnText
* specific to BTA project
*emission_co2_rel(r) = 0.6;
IF(ord(simu) gt 1,
         LR_Co2comb(simu,r,t) = emission_pays_CO2fuelT(r,t) - sum(simu2$(ord(simu2) eq 1), LR_Co2comb(simu2,r,t));
         LR_allghgs(simu,r,t) = emission_paysT(r,t)         - sum(simu2$(ord(simu2) eq 1), LR_allghgs(simu2,r,t));

         LR_allghgs(simu,r,t)$(Taxe_carboneTP.l("CDMHosts") gt 0)
                         = LR_allghgs(simu,r,t)
* Add CDM emissions to non acting and remove them from acting ?
                         + Exports_cdmTPT(r,t) / Taxe_carboneTP.l("CDMHosts");
* on impute tous à CO2 (AR]
*         LR_Co2comb(simu,r,t)$(Taxe_carboneTP.l("CDMHosts") gt 0 and Flag_cdm(r) eq 0)
         LR_Co2comb(simu,r,t)$(Taxe_carboneTP.l("CDMHosts") gt 0)
                          = LR_Co2comb(simu,r,t)
                          + emission_co2_rel(r) * (Exports_cdmTPT(r,t) / Taxe_carboneTP.l("CDMHosts"))  ;

*         work$(Taxe_carboneTP.l("CDMHosts") gt 0)  = sum(r$(Flag_cdm(r) eq 0), emission_co2_rel(r) * (Exports_cdmTPT(r,t) / Taxe_carboneTP.l("CDMHosts")))  ;
*         rwork(r)$(Flag_cdm(r) eq 1 and work gt 0) = (Exports_cdmTPT(r,t) / sum(rp$(Flag_cdm(rp) eq 1), Exports_cdmTPT(rp,t) )) * work;
*         LR_Co2comb(simu,r,t)$(Taxe_carboneTP.l("CDMHosts") gt 0 and Flag_cdm(r) eq 1)
*                          = LR_Co2comb(simu,r,t) - rwork(r)*work  ;

* variation emissions dans acting
         work = 0; work = sum(r$(emi_pool(simu,r,t)), LR_Co2comb(simu,r,t) );

         LR_Co2comb(simu,r,t)$(emi_nonpool(simu,r,t)) =  -100 * LR_Co2comb(simu,r,t) / work;
         LR_Co2comb(simu,r,t)$(emi_pool(simu,r,t))    =  0;

         work = 0; work = sum(r$(emi_pool(simu,r,t)), LR_allghgs(simu,r,t));
         LR_allghgs(simu,r,t)$(emi_nonpool(simu,r,t))=  -100 * LR_allghgs(simu,r,t) / work;
         LR_allghgs(simu,r,t)$(emi_pool(simu,r,t))    =  0;

else
         LR_allghgs(simu,r,t) = emission_paysT(r,t)       ;
         LR_Co2comb(simu,r,t) = emission_pays_CO2fuelT(r,t);
);
$OffText
