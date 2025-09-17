$Setargs elasGTAP weigth elasMod

loop((r,actf),
	denom = 0 ;
	denom = sum((r0,a0,i) $ (mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and %weigth%(r0,a0)), %weigth%(r0,a0)) ;
	%elasMod%(r,actf,v) $ denom
		= sum((r0,a0,i) $ (mapr(r0,r) and mapa(a0,i) and mapaf(i,actf) and %weigth%(r0,a0)), %weigth%(r0,a0) * %elasGTAP%(r0,a0,v))
		/ denom ;
) ;
