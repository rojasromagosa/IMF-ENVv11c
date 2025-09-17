* %1 is a level for initializing first year Tax

*---    Define Emission Quotas allocation among coalition members
* [EditJean] Do this on the basis of total emission or controlled ???

* emiCap.fx(rq,em,tsim) * emiCap0(rq,em)

sum(mapr(rq,r) $ IfCap(rq), emFlag(r,em)

LOOP(rq $ IfCap(rq),

PermitAllowance.fx(r,AllEmissions,t) $ mapr(rq,r)

PermitAllowance.fx(r,AllEmissions,t)
    $ (emFlag(r,AllEmissions) and sum(mapr(rq,r), IfCap(rq)))
    = m_true1(pop,r,t)] /

PermitAllowanceYEQ(r,AllEmissions,t)
    $(ts(t) and ifGbl and sum(mapr(rq,r), IfCap(rq))
        and emFlag(r,AllEmissions) and ifPermitAllowance(r))..
   PermitAllowanceY(r,AllEmissions,t) =e=  emiTax(r,AllEmissions,t)
    * [ PermitAllowance(r,AllEmissions,t) - emiTot(r,AllEmissions,t) * emiTot0(r,AllEmissions)] ;
