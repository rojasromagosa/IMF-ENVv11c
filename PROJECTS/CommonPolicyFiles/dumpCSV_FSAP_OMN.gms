***HRR: dumping output to individual csv files

*** Using outAuxi files from Jean (there were some issues with some of the variables, so moved to MainOutput)
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=gva_real                  format=csv cDim=y output=%oDir%\csv\%simName%_gva_real.csv                
*   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=gva_nominal               format=csv cDim=y output=%oDir%\csv\%simName%_gva_nominal.csv             
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=gross_output_real         format=csv cDim=y output=%oDir%\csv\%simName%_gross_output_real.csv       
*   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=gross_output_nominal      format=csv cDim=y output=%oDir%\csv\%simName%_gross_output_nominal.csv    
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=exports_real              format=csv cDim=y output=%oDir%\csv\%simName%_exports_real.csv            
*   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=exports_nominal           format=csv cDim=y output=%oDir%\csv\%simName%_exports_nominal.csv         
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=gross_investment_real     format=csv cDim=y output=%oDir%\csv\%simName%_gross_investment_real.csv   
*   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=gross_investment_nominal  format=csv cDim=y output=%oDir%\csv\%simName%_gross_investment_nominal.csv
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=gross_wage                format=csv cDim=y output=%oDir%\csv\%simName%_gross_wage.csv              
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=employment                format=csv cDim=y output=%oDir%\csv\%simName%_employment.csv              
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=emi_tot                   format=csv cDim=y output=%oDir%\csv\%simName%_emi_tot.csv               
*   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=emi_source                format=csv cDim=y output=%oDir%\csv\%simName%_emi_source.csv               
**   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=ely_generation            format=csv cDim=y output=%oDir%\csv\%simName%_ely_generation.csv          
*   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=ely_price_source          format=csv cDim=y output=%oDir%\csv\%simName%_ely_price_source.csv        
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=ely_price_consumer        format=csv cDim=y output=%oDir%\csv\%simName%_ely_price_consumer.csv      
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=carbon_tax                format=csv cDim=y output=%oDir%\csv\%simName%_carbon_tax.csv              
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=GDP_real                  format=csv cDim=y output=%oDir%\csv\%simName%_GDP_real.csv                
*   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=GDP_nominal               format=csv cDim=y output=%oDir%\csv\%simName%_GDP_nominal.csv             
***   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=Kstock_real               format=csv cDim=y output=%oDir%\csv\%simName%_Kstock_real.csv   
*   $$call   gdxdump %oDir%\MainOutput\%simName%_outAuxi.gdx symb=Kstock_nominal            format=csv cDim=y output=%oDir%\csv\%simName%_Kstock_nominal.csv

*** Using MainOutput gdx (output tailored for Dashboard)   
*$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=Pop_rep       format=csv cDim=y output=%oDir%\csv\%simName%_Population.csv
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=GDP_real      format=csv cDim=y output=%oDir%\csv\%simName%_GDP_real.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=GDP_nom       format=csv cDim=y output=%oDir%\csv\%simName%_GDP_nom.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=xp_real       format=csv cDim=y output=%oDir%\csv\%simName%_gross_output_real.csv
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=xp_nom        format=csv cDim=y output=%oDir%\csv\%simName%_gross_output_nom.csv
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=gva_real      format=csv cDim=y output=%oDir%\csv\%simName%_gva_real.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=gva_nom       format=csv cDim=y output=%oDir%\csv\%simName%_gva_nom.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=intinp_real   format=csv cDim=y output=%oDir%\csv\%simName%_InterInputs_real.csv
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=intinp_nom    format=csv cDim=y output=%oDir%\csv\%simName%_InterInputs_nom.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=expt_real     format=csv cDim=y output=%oDir%\csv\%simName%_exports_real.csv 
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=expt_nom      format=csv cDim=y output=%oDir%\csv\%simName%_exports_nom.csv 
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=impt_real     format=csv cDim=y output=%oDir%\csv\%simName%_imports_real.csv 
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=impt_nom      format=csv cDim=y output=%oDir%\csv\%simName%_imports_nom.csv 
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=ctax          format=csv cDim=y output=%oDir%\csv\%simName%_carbon_tax.csv 
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=emitotrep     format=csv cDim=y output=%oDir%\csv\%simName%_emi_tot.csv
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=emitot_act    format=csv cDim=y output=%oDir%\csv\%simName%_emi_act.csv
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=wage_real     format=csv cDim=y output=%oDir%\csv\%simName%_wage_real.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=wage_nom      format=csv cDim=y output=%oDir%\csv\%simName%_wage_nom.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=Lempsec       format=csv cDim=y output=%oDir%\csv\%simName%_employment.csv                                     
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=elygen        format=csv cDim=y output=%oDir%\csv\%simName%_ely_generation.csv          
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=Kstock_real   format=csv cDim=y output=%oDir%\csv\%simName%_Kstock_real.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=Kstock_nom    format=csv cDim=y output=%oDir%\csv\%simName%_Kstock_nom.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=gInv_real     format=csv cDim=y output=%oDir%\csv\%simName%_gross_investment_real.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=gInv_nom      format=csv cDim=y output=%oDir%\csv\%simName%_gross_investment_nom.csv  
$$call  gdxdump %oDir%\MainOutput\MainOutput_%simName%.gdx symb=pely          format=csv cDim=y output=%oDir%\csv\%simName%_ely_price_consumer.csv         