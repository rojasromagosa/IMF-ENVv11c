*   purpose: Making endogenous (or not) emiRegTax and emiTax

* Initialize Tax level:
*   InitTaxLvl  --> for year eq YearPolicyStart% (if positive)
*   TimeInitVal --> for year > YearPolicyStart%
*   initialize either on "tsim" or "tsim-1" (ie %TimeInitVal%)

$setargs InitTaxLvl TimeInitVal

* memo: IfEmCap > 0 --> emiRegTax.l
* memo: emFlag > 0  (and not eq 3) --> emiTax.l

* Activate multi-gas Caps/Tax : emiRegTax.l(rq,AllGHG,tsim)

IfEmCap(rq,AllGHG) $ sum(EmSingle $ (IfEmCap(rq,EmSingle) eq 3), 1) = 3 ;

* Endogenize Carbon price 'emiRegTax' by coalition and by GHGs

emiRegTax.lo(rq,em,tsim) $ (IfEmCap(rq,em) AND (NOT IfMcpCapEq) ) = -inf ;
emiRegTax.lo(rq,em,tsim) $ (IfEmCap(rq,em) AND IfMcpCapEq)        = 0 ;
emiRegTax.up(rq,em,tsim) $ IfEmCap(rq,em) 						  = +inf ;

* Endogenize Carbon price 'emiTax' by model region and by GHGs

emiTax.lo(r,em,tsim) $ emFlag(r,em) = -inf ;
emiTax.up(r,em,tsim) $ emFlag(r,em) = +inf ;

*   Initialize Carbon prices
IF((year eq %YearPolicyStart%) AND %InitTaxLvl%,

    emiRegTax.l(rq,em,tsim) $ IfEmCap(rq,em) = %InitTaxLvl% * cScale;
    emiTax.l(r,em,tsim) 	$ emFlag(r,em)
        = sum(mapr(rq,r), emiRegTax.l(rq,em,tsim) );

ELSE

    emiTax.l(r,em,tsim) $ emFlag(r,em)
		= {emiTax.l(r,em,%TimeInitVal%)} $ {emiTax.l(r,em,%TimeInitVal%) gt 0}
		+ {%InitTaxLvl% * cScale} 		 $ {emiTax.l(r,em,%TimeInitVal%) le 0} ;
    emiRegTax.l(rq,em,tsim) $ IfEmCap(rq,em)
        = sum(mapr(rq,r) $ emFlag(r,em), emiTax.l(r,em,%TimeInitVal%));

) ;

LOOP(CO2, rwork(r) = emiTax.l(r,CO2,tsim) / cScale ; ) ;
display "CO2 Tax Initialisation (%system.fn%.gms): ", year, rwork ;

* Fix Caps to zero if inactives (ie IfCap = 0 or IfEmCap = 0)

emiCap.fx(rq,em,tsim)  $ (NOT IfCap(rq))      = 0 ;
emiCapFull.fx(rq,tsim) $ (NOT IfCap(rq))      = 0 ;
emiCap.fx(rq,em,tsim)  $ (NOT IfEmCap(rq,em)) = 0 ;
emiCapFull.fx(rq,tsim) $ (NOT sum(AllGHG, IfEmCap(rq,AllGHG)) ) = 0 ;

*	Activating sectoral quotas (IfAllowance(r) > 0)

$OnDotL

LOOP(r $ IfAllowance(r),
	PP_permit.l(r,a,tsim)
		$ ( IfAllowance(r) and xpFlag(r,a) AND sum(em,PermitAllowancea(r,em,a,tsim)) )
		= sum(em,PermitAllowancea(r,em,a,tsim) * emiTax.l(r,em,tsim))
		*  m_true2t(xp,r,a,tsim-1) ;
	PP_permit.lo(r,a,tsim)
		$ (IfAllowance(r) and xpFlag(r,a) AND sum(em,PermitAllowancea(r,em,a,tsim)))
		= - inf ;
	PP_permit.up(r,a,tsim)
		$ (IfAllowance(r) and xpFlag(r,a) AND sum(em,PermitAllowancea(r,em,a,tsim)))
		= + inf ;
	PP_permit.fx(r,a,tsim)
		$ (IfAllowance(r) AND ((NOT xpFlag(r,a)) OR (NOT sum(em,PermitAllowancea(r,em,a,tsim)))))
		= 0 ;
) ;
LOOP(r $ (IfAllowance(r) gt 1),
	pEmiPermit.l(r,em,tsim)
		$ ( sum(a,PermitAllowancea(r,em,a,tsim)) AND emFlag(r,em) )
		= emiTax.l(r,em,tsim);
	pEmiPermit.lo(r,em,tsim)
		$ ( sum(a,PermitAllowancea(r,em,a,tsim)) AND emFlag(r,em) )
		= - inf ;
	pEmiPermit.up(r,em,tsim)
		$ ( sum(a,PermitAllowancea(r,em,a,tsim)) AND emFlag(r,em) )
		= + inf ;
	pEmiPermit.fx(r,em,tsim) $ (NOT sum(a,PermitAllowancea(r,em,a,tsim))) = 0 ;
) ;

*IF(year eq %YearPolicyStart%,
*	EXECUTE_UNLOAD "PP_permit", PP_permit, PermitAllowancea, IfAllowance(r) ;
*);

$OffDotL

