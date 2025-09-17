$OnDotl

emiCap.l(rq,em,t) $ emiCap0(rq,em) = m_true2(emiCap,rq,em,t) / cscale;
emiTot.l(r,em,t)  $ emiTot0(r,em)  = m_true2(emiTot,r,em,t)  / cscale ;
emiTax.l(r,em,t)  = emiTax.l(r,em,t) * m_convCtax ;
emiCapFull.l(rq,t) $ emiCapFull0(rq) = m_true1(emiCapFull,rq,t) / cscale ;

EXECUTE_UNLOAD "%cFile%_%1.gdx",
    emFlag, IfCap, IfEmCap, p_emissions,
    EmiRCap, emiCap, emiCapFull, emiCap0, emiCapFull0,
*    EmiTimeProfile,
    emiTot, rq, emiOth, emiTax,
    EmiRInt, EmiRInt_bau, part, stringency ;

emiCap.l(rq,em,t)  $ emiCap0(rq,em) = cscale * emiCap.l(rq,em,t) / emiCap0(rq,em) ;
emiTot.l(r,em,t)   $ emiTot0(r,em)  = cscale * emiTot.l(r,em,t)  / emiTot0(r,em) ;
emiTax.l(r,em,t)   = emiTax.l(r,em,t) / m_convCtax ;
emiCapFull.l(rq,t) $ emiCapFull0(rq) = cscale * emiCapFull.l(rq,t) / emiCapFull0(rq) ;

$OffDotl

