* Called by %DebugDir%\84-etat_statut.gms

$Setargs ModType

$OnDotl

check_walras("Based on I-S market (%ModType%)",r,tsim) $ rs(r)
    = outscale * [ sum(inv,m_true2(yfd,r,inv,tsim))
                    - (   sum(h, m_true2(savh,r,h,tsim))
                        + m_true1(savg,r,tsim)
                        + savf.l(r,tsim) * pwsav(tsim)
                        + m_true1(deprY,r,tsim) ) ] ;

check_walras("Based External accounts (%ModType%)",r,tsim) $ rs(r)
    = outscale * [
        sum((i,rp) $ xwFlag(r,i,rp), pwe0(r,i,rp) * PWE_SUB(r,i,rp,tsim) * m_true3(xw,r,i,rp,tsim))
      - sum((i,rp) $ xwFlag(rp,i,r), pwm0(rp,i,r) * PWM_SUB(rp,i,r,tsim) * lambdaw(rp,i,r,tsim) * m_true3(xw,rp,i,r,tsim))
      + sum(img $ xttFlag(r,img), m_true2(pdt,r,img,tsim) * m_true2(xtt,r,img,tsim))
      + pwsav.l(tsim) * savf.l(r,tsim)
      + m_true1(yqht,r,tsim) - m_true1(yqtf,r,tsim)
      + sum((rp,l), m_true3(remit,r,l,rp,tsim) - m_true3(remit,rp,l,r,tsim)) ] ;

check_walras("Based on I-S market (%ModType%)",r,tsim)
	$ ( ABS(check_walras("Based on I-S market (%ModType%)",r,tsim)) lt 0.0001)
	= 0 ;
check_walras("Based External accounts (%ModType%)",r,tsim)
	$ ( ABS(check_walras("Based External accounts (%ModType%)",r,tsim)) lt 0.0001)
	= 0 ;

$OffDotl

