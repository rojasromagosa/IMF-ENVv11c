* For Policy Files, check EmiCap / EmiCapFull
*	during %PolicyStep%=="StepDeclaration"

$SetArgs FileLocation

emiCapFull.fx(rq,t) = emiCapFull.l(rq,t) / cScale ;
emiCapFull0(rq)     = emiCapFull0(rq)    / cScale ;
emiCap.l(rq,em,t) 	= emiCap.l(rq,em,t)  / cScale ;
emiCap0(rq,em)    	= emiCap0(rq,em)     / cScale ;

EXECUTE_UNLOAD "%FileLocation%.gdx", raworkT, emiCapFull, emFlag, IfCap,
	emiCapFull0, rworkT, part, emiTot_ref, emiTot0, mapr,
	emiCap, emiCap0 ;

emiCapFull.fx(rq,t) = emiCapFull.l(rq,t) * cScale ;
emiCapFull0(rq)     = emiCapFull0(rq)    * cScale ;
emiCap.l(rq,em,t) 	= emiCap.l(rq,em,t)  * cScale ;
emiCap0(rq,em)    	= emiCap0(rq,em)     * cScale ;
