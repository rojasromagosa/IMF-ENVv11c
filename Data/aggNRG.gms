IF(%ifCSV%,
   put csv ;

*  Production

   loop((r,a)$(not cgds(a)),
      loop(i$(edf%2(i,a,r) + eif%2(i,a,r)),
         put "%1", "NRG", r.tl, i.tl, a.tl, (edf%2(i,a,r) + eif%2(i,a,r)) / ;
      ) ;
      loop(i$(mdf%2(i,a,r) + mif%2(i,a,r)),
         put "%1", "CO2", r.tl, i.tl, a.tl, (mdf%2(i,a,r) + mif%2(i,a,r)) / ;
      ) ;

      $$iftheni.nco2 "%NCO2%" == "ON"
         loop(nco2,
            loop(i$(NC_TRAD%2(NCO2, i, a, r)),
               put "%1", nco2.tl, r.tl, i.tl, a.tl, (NC_TRAD%2(NCO2, i, a, r)) / ;
            ) ;
            loop(fp$(NC_ENDW%2(NCO2, fp, a, r)),
               put "%1", nco2.tl, r.tl, fp.tl, a.tl, (NC_ENDW%2(NCO2, fp, a, r)) / ;
            ) ;
            put$(NC_QO%2(NCO2, a, r)) "%1", nco2.tl, r.tl, "qo", a.tl, (NC_QO%2(NCO2, a, r)) / ;

*           Output same in CO2eq

            loop(mapco2EQ(nco2,nco2eq),
               loop(i$(NC_TRAD%2(NCO2, i, a, r)),
                  put "%1", nco2eq.tl, r.tl, i.tl, a.tl, (NC_TRAD_Ceq%2(NCO2, i, a, r)) / ;
               ) ;
               loop(fp$(NC_ENDW%2(NCO2, fp, a, r)),
                  put "%1", nco2eq.tl, r.tl, fp.tl, a.tl, (NC_ENDW_Ceq%2(NCO2, fp, a, r)) / ;
               ) ;
               put$(NC_QO%2(NCO2, a, r)) "%1", nco2eq.tl, r.tl, "qo", a.tl, (NC_QO_Ceq%2(NCO2, a, r)) / ;
            ) ;
         ) ;
      $$endif.nco2
   ) ;

*  Final demand

   loop(r,
      loop(i$(edp%2(i,r) + eip%2(i,r)),
         put "%1", "NRG", r.tl, i.tl, "PRIV", (edp%2(i,r) + eip%2(i,r)) / ;
      ) ;
      loop(i$(mdp%2(i,r) + mip%2(i,r)),
         put "%1", "CO2", r.tl, i.tl, "PRIV", (mdp%2(i,r) + mip%2(i,r)) / ;
      ) ;

      $$iftheni.nco2 "%NCO2%" == "ON"
         loop(nco2,
            loop(i$NC_HH%2(NCO2, i, r),
               put "%1", nco2.tl, r.tl, i.tl, "PRIV", (NC_HH%2(NCO2, i, r)) / ;
            ) ;

*           Output same in CO2eq

            loop(mapco2EQ(nco2,nco2eq),
               loop(i$NC_HH%2(NCO2, i, r),
                  put "%1", nco2eq.tl, r.tl, i.tl, "PRIV", (NC_HH_Ceq%2(NCO2, i, r)) / ;
               ) ;
            ) ;
         ) ;
      $$endif.nco2

      loop(i$(edg%2(i,r) + eig%2(i,r)),
         put "%1", "NRG", r.tl, i.tl, "GOV", (edg%2(i,r) + eig%2(i,r)) / ;
      ) ;
      loop(i$(mdg%2(i,r) + mig%2(i,r)),
         put "%1", "CO2", r.tl, i.tl, "GOV", (mdg%2(i,r) + mig%2(i,r)) / ;
      ) ;
      loop(a$cgds(a),
         loop(i$(mdf%2(i,a,r) + mif%2(i,a,r)),
            put "%1", "CO2", r.tl, i.tl, "INV", (mdf%2(i,a,r) + mif%2(i,a,r)) / ;
         ) ;
      ) ;


      $$iftheni.nco2 "%NCO2%" == "ON"
         loop(a$cgds(a),
            loop(nco2,
               loop(i$NC_TRAD%2(NCO2, i, a, r),
                  put "%1", nco2.tl, r.tl, i.tl, "INV", (NC_TRAD%2(NCO2, i, a, r)) / ;
               ) ;

*---           Output same in CO2eq

               loop(mapco2EQ(nco2,nco2eq),
                  loop(i$NC_TRAD%2(NCO2, i, a, r),
                     put "%1", nco2eq.tl, r.tl, i.tl, "INV", (NC_TRAD_Ceq%2(NCO2, i, a, r)) / ;
                  ) ;
               ) ;
            ) ;
         ) ;
      $$endif.nco2
   ) ;

*  Exports

   IF(ifAggTrade,
      loop((r,i)$(sum(rp, EXIDAG%2(i,r,rp))),
         put "%1", "NRG", r.tl, i.tl, "BOP",  (sum(rp, EXIDAG%2(i,r,rp))) / ;
      ) ;
   else
      loop((r,i,rp)$(EXIDAG%2(i,r,rp)),
         put "%1", "NRG", r.tl, i.tl, rp.tl,  EXIDAG%2(i,r,rp) / ;
      ) ;
   ) ;
) ;
