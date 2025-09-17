*------------------------------------------------------------------------------*
*       Additional sector and commodity Sets for [OECD-ENV]                       *
*------------------------------------------------------------------------------*

$IFi %IfAddTotalSets%=="ON" put 'SET tota(is) / tot, TotEly /;' / / ;

put '*------------------------------------------------------------------------------*' / ;
put '*              Additional sector and commodity Sets for OECD-ENV               *' / ;
put '*------------------------------------------------------------------------------*' / / ;


put '*-----------------------    Activities    -------------------------------------*' / / ;

m_putSet_withSubseta(forestrya,a)
m_putSet_withSubseta(fisherya,a)

put / '*    Energy Intensive Industries: ' / / ;
m_putSet_withSubseta(frta,a)
m_putSet_withSubseta(cementa,a)
m_putSet_withSubseta(PPPa,a)
m_putSet_withSubseta(I_Sa,a)

put / '*    Other Manufacturing: ' / /;
m_putSet_withSubseta(ELEa,a)
m_putSet_withSubseta(FMPa,a)
m_putSet_withSubseta(wooda,a)
m_putSet_withSubseta(MTEa,a)
m_putSet_withSubseta(NFMa,a)
m_putSet_withSubseta(omana,a)
m_putSet_withSubseta(FDPa,a)
m_putSet_withSubseta(TXTa,a)

put / '*    Other Industries non-manufacturing: ' / /;
m_putSet_withSubseta(COAa,a)
m_putSet_withSubseta(COILa,a)
m_putSet_withSubseta(ROILa,a)
m_putSet_withSubseta(NGASa,a)
m_putSet_withSubseta(GDTa,a)
m_putSet_withSubseta(mininga,a)
m_putSet_withSubseta(constructiona,a)

put put / '*    Services: ' / /;
m_putSet_withSubseta(pubserva,a)
m_putSet_withSubseta(privserva,a)
m_putSet_withSubseta(transporta,a)
put / ;

put '*---------------------      Commodities      ----------------------------------*' / / ;

m_putSet_withSubseti(cri,i)
m_putSet_withSubseti(lvi,i)
m_putSet_withSubseti(forestryi,i)
m_putSet_withSubseti(fisheryi,i)

put / '*    Energy Intensive Goods: ' / /;
m_putSet_withSubseti(PPPi,i)
*m_putSet_withSubseti(frti,i)   --> defined as "frt" in "makesetEnv.gms"
m_putSet_withSubseti(cementi,i)
m_putSet_withSubseti(I_Si,i)

put / '*    Other Manufacturing Goods: ' / /;
m_putSet_withSubseti(ELEi,i)
m_putSet_withSubseti(FDPi,i)
m_putSet_withSubseti(TXTi,i)
m_putSet_withSubseti(NFMi,i)
m_putSet_withSubseti(FMPi,i)
m_putSet_withSubseti(MTEi,i)
m_putSet_withSubseti(woodi,i)
m_putSet_withSubseti(omani,i)

put / '*    Other Industries non-manufacturing Goods: ' / /;
m_putSet_withSubseti(COAi,i)
m_putSet_withSubseti(COILi,i)
m_putSet_withSubseti(ROILi,i)
m_putSet_withSubseti(NGASi,i)
m_putSet_withSubseti(GDTi,i)
m_putSet_withSubseti(miningi,i)
m_putSet_withSubseti(constructioni,i)
m_putSet_withSubseti(wtri,i)

put / '*    Services: ' / /;
m_putSet_withSubseti(pubservi,i)
m_putSet_withSubseti(privservi,i)
* m_putSet_withSubseti(transporti,i) --> defined as "img" in "makesetEnv.gms"

