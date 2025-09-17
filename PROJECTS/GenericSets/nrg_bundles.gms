NRG "Energy bundles used in model" /
    ELY   "Electricity"
    COA   "Coal"
    GAS   "Gas"
    OIL   "Oil"
/

* Subsets of Energy bundles

coa(NRG) "Composition of Coal bundle"        / coa "Coal product" /
oil(NRG) "Composition of Oil bundle "        / oil "Crude & Refined Oil products" /
gas(NRG) "Composition of Gas bundle "        / gas "Gas"  /
ely(NRG) "Composition of Electricity bundle" / ely "Electricity"  /

mape(NRG,ei) "Mapping of energy commodities to energy bundles" /
    COA.(coa%1)
    OIL.(oil%1, p_c%1)
    GAS.gas%1
    $$Ifi %split_gas%=="ON" 	  GAS.gdt%1
    $$IFi %IfElyGoodDesag%=="OFF" ELY.(ely%1)

* [TBC] if multiple electricity goods + not necessary to be declared in aggregation ?

    $$IFi %IfElyGoodDesag%=="ON" ALL power ici?
    /
