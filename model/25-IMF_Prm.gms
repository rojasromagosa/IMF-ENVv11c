$OnText
--------------------------------------------------------------------------------
			OECD-ENV Model version 1: Simulation Procedure
	file name   : %ModelDir%\25-IMF_Prm.gms
	purpose     : overwrite default values %ModelDir%\default_Prm.gms
				for IMF-ENV Model
	created date: 2021-02-19
	created by  : Jean Chateau
	called by   : "%ModelDir%\2-CommonIns.gms"
--------------------------------------------------------------------------------
    $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/25-IMF_Prm.gms $
	last changed revision: $Rev: 493 $
	last changed date    : $Date:: 2024-02-02 #$
	last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

***HRR: Some of these adj's are hard coded, we take them all away and stick with GTAP elas
$ontext
*------------------------------------------------------------------------------*
*       Adjustment in First Level Armington Elasticity (e.g. sigmamt)          *
*------------------------------------------------------------------------------*

* [TBU] pb aggregation GTAP10

$IF SET EEQ_name sigmamt(r,"%EEQ_name%-c")   = 4.4 ;
$IF SET BPH_name sigmamt(r,"%BPH_name%-c")   = 3.3 ;
$IF SET RPP_name sigmamt(r,"%RPP_name%-c")   = 3.3 ;
$IF SET OCR_name sigmamt(ROW,"%OCR_name%-c") = 3.25 ;
$IF SET PFB_name sigmamt(ROW,"%PFB_name%-c") = 2.50 ;

*$IF SET MVH_name sigmamt(ROW,"%MVH_name%-c") =  2.80 ;

* [TBU] end pb aggregation GTAP10

sigmamt(r,NGASi)        = 6;
sigmamt(OLD_OECD,NGASi) = 10;
sigmamt(OCE,NGASi)      = 17;
sigmamt(RAN,NGASi) $ (card(TransE) gt 1) = 4.5;
sigmamt(mex,NGASi)      = 4.5;
sigmamt(zaf,NGASi)      = 1.5;
sigmamt(chl,NGASi)      = 1.5;
sigmamt(JPK,NGASi)      = 2.5;
sigmamt(r,NGASi) $ (sigmamt(r,NGASi) gt 5) = 5;

sigmamt(r,GDTi)      = 2.8;

sigmamt(r,ROILi)      = 2.1;
sigmamt(OPEP,ROILi)   = 1.6;
sigmamt(RAN,ROILi)    = 1.9;

sigmamt(r,COILi)        = 5.2 ;
sigmamt(JPK,COILi)      = 2.5 ;
sigmamt(IDN,COILi)      = 4.68;

sigmamt(r,COAi)         = 4.93; !! GTAP = 3
sigmamt(ODA,COAi)       = 4;
sigmamt(bra,COAi)       = 2.5;

sigmamt(r,miningi)      = 0.9;

sigmamt(r,wtri)         = 2.80 ;

sigmamt(r,frti)         = 3; !! GTAP = 3.3
sigmamt(TransE,frti)$(card(TransE) eq 1) = 2;
sigmamt(rus,frti)   $(card(TransE) gt 1) = 2;
sigmamt(OLA,frti)       = 2.5;
sigmamt(ind,frti)       = 3.3;
sigmamt(kor,frti)       = 2;

sigmamt(r,FDPi) = 2.49;

sigmamt(r,ELEi) = 4.4;

sigmamt(r,Fisheryi) = 1.25;

sigmamt(r,Forestryi) = 2.25;

sigmamt(r,constructioni) = 1.9;

sigmamt(r,woodi) = 3.4;

sigmamt(r,PPPi) = 2.95;

sigmamt(r,FMPi) =  3.75 ;

sigmamt(r,I_Si)   = 2.95;
sigmamt(WEU,I_Si) = 2.25;
sigmamt(RAN,I_Si) $ (card(TransE) gt 1) = 2 ;

sigmamt(r,cementi) = 1.5;   !! GTAP = 2.9

sigmamt(r,elyi)    = 1.1;   !! GTAP = 2.8
sigmamt(WEU,elyi)  = 1.15;

sigmamt(r,NFMi)     = 2.0; !! GTAP = 4.2
sigmamt(mex,NFMi)   = 1.5;
sigmamt(RRES,NFMi)  = 1.5;
sigmamt(LATIN,NFMi) = 1.5;

sigmamt(r,TXTi) = 3; !! GTAP = 3.78

sigmamt(r,srvi)     = 1.9;
sigmamt(r,img)      = 1.9;
sigmamt(r,pubservi) = 1.1;

sigmamt(r,lvi) =   1.668; !! GTAP = 2.25

* More protectionist areas

$IF SET OCR_name sigmamt(mex,"%OCR_name%-c") = 1.5; !! GTAP = 3.3

*------------------------------------------------------------------------------*
*       Adjustment in Second Level Armington Elasticity (e.g. sigmaw)          *
*------------------------------------------------------------------------------*

sigmaw(r,i) $ (Not NGASi(i)) = 2.0 * sigmamt(r,i);
sigmaw(r,NGASi)            = 1.5 * sigmamt(r,NGASi);
sigmaw(r,elyi)             = sigmamt(r,elyi);
sigmaw(r,pubservi)         = sigmamt(r,pubservi);
sigmaw(r,wtri)             = sigmamt(r,wtri);

$offtext
***endHRR

*------------------------------------------------------------------------------*
*                   Export elasticities                                        *
*------------------------------------------------------------------------------*

*   Top level CET export elasticity

omegax(r,i) = +inf;

*   Second level CET export elasticity

omegaw(r,i) = +inf;

*	ENVISAGE values (if active)

IF(0,
	omegax(r,i) = 2 ;
	omegaw(r,i) = 4 ;
) ;

*------------------------------------------------------------------------------*
*            sigmap(r,a,v0) Substitution Elasticity between                    *
*         Intermediate Demand Bundle (nd1) and Value-Added Bundle (va)         *
*------------------------------------------------------------------------------*

sigmap(r,a,vNew) $ (not tota(a)) = 0.6;

sigmap(r,cra,vNew)       = 0.2;
sigmap(r,lva,vNew)       = 0.2;
sigmap(r,forestrya,vNew) = 0.998;
sigmap(r,fisherya,vNew)  = 0.998;

sigmap(r,elya,vNew)      = 0.418;
sigmap(r,a,vNew) $ (elya(a) and not s_rena(a)) = 0.1;
sigmap(r,a,vNew) $ (OtherInda(a) or NFMa(a)) = 1.025;
sigmap(r,wtra,vNew)      = 1.025;

*   Energy Intensive Industries

sigmap(r,PPPa,vNew)     = 0.831;
sigmap(r,frta,vNew)     = 0.808;
sigmap(r,ROILa,vNew)    = 0.808;
sigmap(r,cementa,vNew)  = 0.987;
sigmap(r,I_Sa,vNew)     = 1.050;

$$ifi not %regionalAgg%=="MCD"  $$IF SET ome_NAME sigmap(MEX,"%OME_name%-a",vNew) = 0.9;

sigmap(r,FDPa,vNew)       = 0.4;
sigmap(r,fossilea,vNew)   = 0.349;
sigmap(r,mininga,vNew)    = 0.349;
sigmap(r,servcnsa,vNew)   = 0.8;
sigmap(r,etda,vNew)       = 0.8;
sigmap(r,GDTa,vNew)       = 0.8;
sigmap(r,transporta,vNew) = 1.045;

sigmap(r,a,vOld) = 0.0;

*------------------------------------------------------------------------------*
* sigmav(v) : SE between Capital(-Nat. Ress.)-energy bundle and Labour bundle  *
*------------------------------------------------------------------------------*

sigmav(r,a,vNew) $ (not tota(a)) = 1.01;


sigmav(r,cra,v)       = 0.5; 
***HRR: hard coded sigmav(JPN,cra,v) = 0.4;
sigmav(r,lva,v)       = 0.5;
sigmav(r,forestrya,v) = 1.39;
sigmav(r,fisherya,v)  = 1.39;
sigmav(r,fossilea,v)  = 0.87;
sigmav(r,mininga,v)   = 0.87;

sigmav(r,GDTa,v)  = 1.075;
sigmav(r,NGASa,v) = 0.87;
sigmav(r,GASa,v) $ (card(GASa) eq 1)  = 1.075;
sigmav(r,elya,v)  = 0.25;

sigmav(r,a,v) $(OtherInda(a) or NFMa(a)) = 0.787;
sigmav(r,wtra,v)     = 0.90 ;

***HRR: hard coded $IF SET OME_name sigmav(MEX,"%OME_name%-a",v) = 0.5;
sigmav(r,PPPa,v)     = 0.41 ;
sigmav(r,frta,v)     = 0.88 ;
sigmav(r,ROILa,v)    = 0.88 ;
sigmav(r,cementa,v)  = 0.53 ;
sigmav(r,I_Sa,v)     = 1.02 ;

sigmav(r,servcnsa,v)   = 1.28;
sigmav(r,transporta,v) = 1.2;
sigmav(r,etda,v)       = 1.075;

*	Apply standard GREEN ratio NEW vs OLD

LOOP(vNew,
	sigmav(r,a,vOld) = 0.12 * sigmav(r,a,vNew);
) ;

*------------------------------------------------------------------------------*
*                   Agriculture specific bundles                               *
*------------------------------------------------------------------------------*

sigmav2(r,a,v)   = 0 ;

*   livestock sectors: Elasticity between lab1 and KEF

sigmav1(r,a,v)      = 0 ;
sigmav1(r,lva,vNew) = 0.5 ;

LOOP(vNew,
	sigmav1(r,lva,vOld)  = 0.12 * sigmav1(r,lva,vNew) ;
) ;

*   livestock sectors: Elasticity between Land and Feed

sigmav2(r,lva,v) = 0.5 ;

*   livestock sectors: Elasticity across feed

sigman2(r,a) $ (not tota(a)) = 0 ;
sigman2(r,lva) = 0.5 ;

*   livestock sectors: Elasticity between TFD and KTEL

sigmav(r,lva,v) = 0 ;

*   crop sectors: Elasticity between lab1 and VA1 (e.g. KTE-Fer)

sigmav(r,cra,vNew)  = 0.5 ;

LOOP(vNew,
	sigmav(r,cra,vOld)  = 0.12 * sigmav(r,cra,vNew) ;
) ;

*   crop sectors: Elasticity between KTE and Fert

sigmav1(r,cra,v) = 0.5 ;

*   crop sectors: Elasticity between Land and KEF (crop sectors)

sigmav2(r,cra,vNew) = 0.1 ;
sigmav2(r,cra,vOld) = 0 ;

*   crop sectors: Elasticity across fertilizers

sigman2(r,cra)    = 0.5 ;

*------------------------------------------------------------------------------*
*          sigmakef: ES between xnrg and KF  (ex sigma_e)                      *
*------------------------------------------------------------------------------*

sigmakef(r,a,vNew) $ (not tota(a)) = 0.8;

sigmakef(r,agra,vNew)      	   = 0.10  ;
sigmakef(r,agra,vNew)      	   = 0.10  ;
sigmakef(r,forestrya,vNew) 	   = 0.10  ;
sigmakef(r,fisherya,vNew)  	   = 0.20  ;
sigmakef(r,fossilea,vNew)  	   = 0.535 ;
sigmakef(r,mana,vNew)      	   = 0.20  ; !! 0.102;
sigmakef(r,mininga,vNew)   	   = 0.535 ;
sigmakef(r,ROILa,vNew)     	   = 0.10  ;
sigmakef(r,GDTa,vNew)      	   = 0.10  ;
sigmakef(r,PPPa,vNew)      	   = 0.372 ;
sigmakef(r,frta,vNew)      	   = 0.10  ; !! 0.038;
sigmakef(r,cementa,vNew)   	   = 0.35  ;
sigmakef(r,I_Sa,vNew)      	   = 0.290 ;
sigmakef(r,wooda,vNew)     	   = 0.052 ;
sigmakef(r,TrueServa,vNew)     = 0.40  ;
sigmakef(r,transporta,vNew)    = 0.45  ;  !! 0.95;
sigmakef(r,constructiona,vNew) = 0.40  ;  !! 0.105;
sigmakef(r,wtra,vNew)          = 0.20  ;
sigmakef(r,elya,vNew)      	   = 0.396 ;
sigmakef(r,etda,vNew)      	   = 0.535 ;
sigmakef(r,a,v) $ (s_rena(a) and not etda(a)) = 0;

sigmakef(r,a,vOld) = 0.0;

*------------------------------------------------------------------------------*
*   sigmakf: ES between ksw and xnrf: kf(a,v) = CES(ksw(a,v) ; xnrf(a))        *
*------------------------------------------------------------------------------*

sigmakf(r,a,v)            = 0.0 ;
sigmakf(r,lva,vNew)       = 0.1 ;
sigmakf(r,cra,vNew)       = 0.1 ;
sigmakf(r,forestrya,vNew) = 0.2 ;
sigmakf(r,fisherya,vNew)  = 0.2 ;
sigmakf(r,mininga,vNew)   = 0.2 ;

* All sectors: Elasticity between kv and lab2

sigmak(r,a,v) = 0 ;

* All sectors: Elasticity between between KS and XWAT

sigmakw(r,a,v) = 0 ; !! ENVISAGE = 0.1

*------------------------------------------------------------------------------*
*                   Override energy nesting choices                            *
*------------------------------------------------------------------------------*

* Memo:
* IfNrgNest eq 0: sigmae(r,a,v) is the elasticity between all fuel
* IfNrgNest gt 0: sigmae(r,a,v) is the elasticity between ely and non-ely fuel

IfNrgNest(r,a) $ (fa(a) or elya(a)) 				 = 0 ;
IfNrgNest(r,a) $ (transporta(a) and NOT LandTrpa(a)) = 0 ;
IfNrgNest(r,h) 										 = 0 ;

*   Fuel-Mix Nest 1.) : Elasticity between ELY and NELY in energy bundle

sigmae(r,a,vNew) $ (not tota(a)) = 1.1;
sigmae(r,a,vOld) $ (not tota(a)) = 0.125;

* Elasticity Between energy carriers in "fa" sectors when no NRG-Bundle

sigmae(r,fa,v) $ (NOT IfNrgNest(r,fa)) = 0.2 * sigmae(r,fa,v);

* Assumption: quasi-Leontieff for ely activities

sigmae(r,elya,v) $ (NOT IfNrgNest(r,elya)) = 0.05;

*   Fuel-Mix Nest 2.) : Elasticity between COA and NCOA in NELY bundle

sigmanely(r,a,v) = 0.5 * sigmae(r,a,v);

*   Fuel-Mix nest 3.) : Elasticity across non-solid fuel in NCOA bundle

sigmaolg(r,a,v) = sigmae(r,a,v) ;

* NRG Bundle with the same elasticity that corresponding bundle

sigmaNRG(r,a,nrg,v) $ ely(nrg) = sigmae(r,a,v);
sigmaNRG(r,a,nrg,v) $ coa(nrg) = sigmanely(r,a,v);
sigmaNRG(r,a,nrg,v) $ (gas(nrg) or oil(nrg)) = sigmaolg(r,a,v);

* As card(oil(nrg)) ne 1 on pourrait mettre une elasticite differente de sigmaolg

* If only one nest: so clean useless elasticities (Warning does not mean Leontieff)

sigmanely(r,a,v)    $ (NOT IfNrgNest(r,a)) = 0;
sigmaolg(r,a,v)     $ (NOT IfNrgNest(r,a)) = 0;
sigmaNRG(r,a,NRG,v) $ (NOT IfNrgNest(r,a)) = 0;

*------------------------------------------------------------------------------*
*        sigman1(r,a) : SE accross Intermediary demands in ND1 bundle          *
*------------------------------------------------------------------------------*

sigman1(r,a) = 0;
sigman1(r,a)  $ (OtherInda(a) or NFMa(a) or wtra(a))  = 0.4;
sigman1(r,mininga)  = 0.2;
sigman1(r,fossilea) = 0.2;
sigman1(r,a) $ (forestrya(a) or fisherya(a))  = 0.2;

sigman1(r,frta)    = 0.082;
sigman1(r,ROILa)   = 0.082;
sigman1(r,GDTa)    = 0.082;
sigman1(r,I_Sa)    = 0.253;
sigman1(r,PPPa)    = 0.15;
sigman1(r,cementa) = 0.191;

sigman1(r,servcnsa)   = 0.4 ;
sigman1(r,transporta) = 0.331 ;
sigman1(r,elya)   = 0.2 ;
sigman1(r,s_otra) = 0.4 ;
sigman1(r,etda)   = 0.4 ;

*------------------------------------------------------------------------------*
*        etanrf0(r,a,t): Supply elasticities of natural resource               *
*------------------------------------------------------------------------------*

*[EditJean]: etanrf.l(r,a,t) est indicée par le temps et est endogene
* etanrf.l est fonction des valeurs low et hi de etanrfx(r,a,lh)

etanrf0(r,forestrya)   = 0.5;

etanrf0(r,fisherya)    = 0.25;

***HRR: hard coded 
$iftheni.G20agg %BaseName%=="2024_RD"
etanrf0(IND,forestrya) = 0.1;
etanrf0(OAF,forestrya) = 0.3;
etanrf0(CHN,fisherya)  = 0.125;
etanrf0(OAF,fisherya)  = 0.125;
$endif.G20agg

$iftheni.MCDagg %BaseName%=="2024_MCD"
*etanrf0(allMCD,forestrya) = 0.1;

$endif.MCDagg
***endHRR



etanrf0(r,mininga)     = 2.00;

*   hand manipulation to fit with IEA prices projections

etanrf0(r,COILa)      = 0.90;
***HRR: hard coded

$iftheni.G20agg %BaseName%=="2024_RD"

etanrf0(RRES,COILa)   = 0.33 * etanrf0(RRES,COILa);
etanrf0(CAN,COILa)    = 0.44 * etanrf0(CAN,COILa);
etanrf0(MEX,COILa)    = 0.36 * etanrf0(MEX,COILa);
etanrf0(OCE,COILa)    = 0.59 * etanrf0(OCE,COILa);
etanrf0(WEU,COILa)    = 0.15 * etanrf0(WEU,COILa);
etanrf0(TransE,COILa) = 0.42 * etanrf0(TransE,COILa);
etanrf0(RAN,COILa) $ (card(TransE) gt 1)
    = 0.64 * etanrf0(RAN,COILa);
etanrf0(r,COILa) $(TAN(r) or OEA(r)) = 0.49 * etanrf0(r,COILa);
etanrf0(CHN,COILa)    = 0.36 * etanrf0(CHN,COILa);
etanrf0(IND,COILa)    = 0.48 * etanrf0(IND,COILa);
etanrf0(AS9,COILa)    = 0.35 * etanrf0(AS9,COILa) ;

* Difference with ENV-Linkages where below is activated
*etanrf0(IDN,COILa)  = 0.35 * etanrf0(IDN,COILa) ;

etanrf0(OPEP,COILa)   = 0.64 * etanrf0(OPEP,COILa);
etanrf0(NAF,COILa)    = 0.45 * etanrf0(NAF,COILa);
* Quasi inelastique
etanrf0(JPK,COILa)    = 0.1;
etanrf0(ZAF,COILa)    = 0.1;

etanrf0(r,COAa)      =  3    ;
etanrf0(usa,COAa)    =  4.85 ;
etanrf0(WEU,COAa)    =  8.52 ;
etanrf0(CHN,COAa)    =  4.84 ;
etanrf0(TransE,COAa) =  4.07 ;
etanrf0(OPEP,COAa)   =  5.25 ;
etanrf0(can,COAa)    =  0.74 ;
etanrf0(ind,COAa)    =  9.64 ;
etanrf0(mex,COAa)    =  6.63 ;
etanrf0(OCE,COAa)    = 10.39 ;
etanrf0(zaf,COAa)    =  9.63 ;
etanrf0(SEA,COAa)    =  7.02 ;
etanrf0(ind,COAa)    =  9.64 ;
etanrf0(chn,COAa)    =  4.84 ;
etanrf0(idn,COAa)    = 12.00 ;
etanrf0(OAF,COAa)    =  7.02 ;
etanrf0(LATIN,COAa)  =  7.02 ;
etanrf0(bra,COAa)    =  0.75 ; !!2.00
etanrf0(chl,COAa)    =  1.00 ;
etanrf0(naf,COAa)    =  6.00 ;
etanrf0(chl,COAa)    =  0.75 ;
etanrf0(OPEP,COAa)   =  0.75 ;
etanrf0(NAF,COAa)    =  0.75 ;
etanrf0(OAF,COAa)    =  1.00 ;
etanrf0(JPK,COAa)    =  0.75 ;
etanrf0(fra,COAa)    =  0.75 ;
etanrf0(Ita,COAa)    =  0.75 ;
etanrf0(sau,COAa)    =  0.75 ;
etanrf0(arg,COAa)    =  0.75 ;

etanrf0(r,NGASa)     = 1.00 ;
etanrf0(RRES,NGASa)  = 0.37 * etanrf0(RRES,NGASa) / 0.7 ;
etanrf0(CAN,NGASa)   = 0.10 * etanrf0(CAN,NGASa)  / 0.7 ;
etanrf0(MEX,NGASa)   = 0.90 * etanrf0(MEX,NGASa)  / 0.7 ;
etanrf0(RUS,NGASa)   = 1.20 * etanrf0(RUS,NGASa)  / 0.7 ;
etanrf0(IND,NGASa)   = 0.74 * etanrf0(IND,NGASa)  / 0.7 ;
etanrf0(OPEP,NGASa)  = 0.89 * etanrf0(OPEP,NGASa) / 0.7 ;
etanrf0(NAF,NGASa)   = 0.80 * etanrf0(NAF,NGASa)  / 0.7 ;
etanrf0(BRA,NGASa)   = 1.20 * etanrf0(BRA,NGASa) ;
etanrf0(TAN,NGASa)   = 0.25 * etanrf0(TAN,NGASa) ;
etanrf0(RAN,NGASa)   = 0.80 * etanrf0(RAN,NGASa) ;
etanrf0(CHN,NGASa)   = 1.00 * etanrf0(CHN,NGASa) ;
etanrf0(JPK,NGASa)   = 0.10 * etanrf0(JPK,NGASa) ;
etanrf0(fra,NGASa)   = 0.20 * etanrf0(fra,NGASa) ;
etanrf0(tur,NGASa)   = 0.20 * etanrf0(tur,NGASa) ;
etanrf0(tun,NGASa)   = 0.20 * etanrf0(tun,NGASa) ;

$endif.G20agg
***endHRR

*[TBU]: Logiquement revoir ca mais comme matrice a/a0 est diagnonale pour NatRes
* pour le moment ne pose pas de problemes

etanrfx0(r,a0,lh) = sum(mapa0(a0,a), etanrf0(r,a));

*   Activate endogenous etanrf.l

IF(IfEndoEtanrf,
    etanrfx0(r,a0,"lo") = (2 / 3) * etanrfx0(r,a0,"lo");
    etanrfx0(r,a0,"hi") = (4 / 3) * etanrfx0(r,a0,"hi");
);

*------------------------------------------------------------------------------*
*   InvElas(r,i) : Elasticite cout de des-investissement vieux capital         *
*------------------------------------------------------------------------------*

invElas(r,a)    = 0.92;
invElas(r,I_Sa) = 0.55;
invElas(r,agra) = 4.00;


***HRR: added for Mcd
$iftheni.MCDagg %BaseName%=="2024_MCD"
*invElas(allMCD,agra)  = 2 ; 
*invElas0(allMCD,agra) = 2 ; 
*etat(allMCD)          = 0 ; 
$endif.MCDagg
***endHRR

* Fossil Power (and etd)

invElas(r,a) $ (elya(a) and not s_rena(a)) = 1.4;

***HRR: hard coded
$iftheni.G20agg %BaseName%=="2024_RD"
* Numerical issue
invElas(JPK,COAa) = 2.5 ;
invElas(bra,COAa) = 2.5 ;
invElas(bra,CLPa) = 2.5 ;
invElas(fra,CLPa) = 2.5 ;
$endif.G20agg
***endHRR

invElas(r,a) $ tota(a) = 0 ;

IF(card(l) le 1,
	sigmasl(r,a) = 0 ;
	sigmaul(r,a) = 0 ;
) ;

*------------------------------------------------------------------------------*
*           sigmaxp(r,a,v): CES between GHG and XP" [ongoing]                  *
*------------------------------------------------------------------------------*

* [TBC]: activities where sigmaxp is zero:
*	{omn-a, p_c-a, etd-a, ppp-a, ele-a, fdp-a, txt-a, fmp-a}

* memo: here are elasticities from ENV-Linkages version 3

sigmaxp(r,omana,v) = 0.25;
sigmaxp(r,cra,v)   = 0.05;
sigmaxp(r,NFMa,v)  = 0.3;

* [TBU] with mutiple lva

sigmaxp(r,lva,v)      = 0.05;
sigmaxp(r,COAa,vOld)  = 0.2; sigmaxp(r,COAa,vNew)  = 0.3;
sigmaxp(r,COILa,vOld) = 0.1; sigmaxp(r,COILa,vNew) = 0.15;

* [TBU] to be revised with mutiple gas

sigmaxp(r,GASa,vOld) = 0.1; sigmaxp(r,GASa,vNew) = 0.15;
sigmaxp(r,cementa,v) = 0.15;
sigmaxp(r,I_Sa,vOld) = 0.25; sigmaxp(r,I_Sa,vNew) = 0.25;

* AR (plus complique)

sigmaxp(r,frta,vOld) = 0.28; sigmaxp(r,frta,vNew) = 0.28;
sigmaxp(r,MTEa,v)       = 0.05;
sigmaxp(r,transporta,v) = 0.05;

* Sewerage and waste management

sigmaxp(r,wtra,v)  = 0.3;

sigmaxp(r,frta,vOld) = 0.5 * sigmaxp(r,frta,vOld) ;
sigmaxp(r,wtra,vOld) = 0.5 * sigmaxp(r,wtra,vOld)   ;
sigmaxp(r,COAa,vOld) = 0.5 * sigmaxp(r,COAa,vOld) ;


*------------------------------------------------------------------------------*
*               sigma_emi_prod : ES of CES(emissions) [TBU]                    *
*------------------------------------------------------------------------------*

sigmaemi(r,a,v) = 0 ;

*------------------------------------------------------------------------------*
*                   Power Bundle Elasticities                                  *
*------------------------------------------------------------------------------*

$IfTheni.PowerData %IfPower%=="ON"

* Default for most configurations: etd is perfect complement to power

    sigmael(r,elyi)     = 0;

*	Power bundle elasticities

    $$IfTheni.ElyBndNest %ElyBndNest%=="default"

        sigmapow(r,elyi)    = 1.2;
        sigmapb(r,pb,elyi) $ (NOT Allpb(pb)) = 1.5;

    $$ElseIfi.ElyBndNest %ElyBndNest%=="4Bundles"

*	This is for variant cases see below

        sigmapow(r,elyi)        = 5.0 ;
        sigmapb(r,"fosp",elyi)  = 4.0 ;
        sigmapb(r,"othp",elyi)  = 1.75;

* Better for variant with High Tax and actually Excepted othp all
* the other bundle are mostly BASELOAD and therefore substitutable

        sigmael(r,elyi)         = 0.05 ;

    $$ElseIfi.ElyBndNest %ElyBndNest%=="GIMF"

    $$ElseIfi.ElyBndNest  %ElyBndNest%=="ENV-LinkagesV3"

    $$ElseIfi.ElyBndNest  %ElyBndNest%=="1Bundle"

        sigmapow(r,elyi)    = 1.2 ;
        sigmapb(r,pb,elyi)  = 0 ;

    $$EndIf.ElyBndNest

* Default "starting" elasticities for Dynamic calibration

	IF(IfDyn and IfCal,

		sigmapb(r,pb,elyi) = 1.2 ;
		sigmapow(r,elyi)   = 1.1 ;

	) ;

$Else.PowerData

    sigmapow(r,elyi)   = 0 ;
    sigmapb(r,pb,elyi) = 0 ;
    sigmael(r,elyi)    = 0 ;

$ENDIF.PowerData

*------------------------------------------------------------------------------*
*           	Land CET-Bundle Elasticities                                   *
*------------------------------------------------------------------------------*

**HRR: new parameters taken from previous versions
***omegat(r)      = 0.4 ;
***omeganlb(r)    = 0.6 ;
***omegalb(r,lb)  = 0.4 ;


***new to 
*    omegat(r)   = + inf ;
*    omeganlb(r) = + inf ;
*    omegalb(r,lb)  = + inf ;


***HRR: hard coded
$iftheni.G20agg %BaseName%=="2024_RD"

etat(rus)  = 0.10 ;
etat(OPEP) = 0.05 ;
etat(ita)  = 0.05 ;


* Memo: with %UseIMPACT%=="ON", this is revised in calibration procedure:
* %CalDir%\2-0-dynamic_calibration_DefineTargets.gms

***HRR: hard coded
$IfTheni.MAGNETLandBndNestndl %LandBndNest%=="MAGNET"

    omegat(AUS)     =  0.482 ;
    omegat(CHN)     =  0.362 ;
    omegat(JPN)     =  0.348 ;
    omegat(IND)     =  0.368 ;
    omegat(USA)     =  0.519 ;
    omegat(TransE)  =  0.474 ;
    omegat(WEU)     =  0.539 ;
    omegat(OPEP)    =  0.419 ;
    omegat(CAN)     =  0.558 ;
    omegat(ROW)     =  0.437 ;

    omeganlb(AUS)    = 0.472 ;
    omeganlb(CHN)    = 0.378 ;
    omeganlb(JPN)    = 0.355 ;
    omeganlb(IND)    = 0.356 ;
    omeganlb(USA)    = 0.527 ;
    omeganlb(TransE) = 0.472 ;
    omeganlb(WEU)    = 0.534 ;
    omeganlb(OPEP)   = 0.413 ;
    omeganlb(CAN)    = 0.548 ;
    omeganlb(ROW)    = 0.439 ;

$EndIf.MAGNETLandBndNestndl

$Endif.G20agg
***endHRR

* Load values from external Scenario

**HRR: Switched this off, see if we want/can use IMPACT elasticities
$ontext
$IF EXIST "%iGdxDir_ImportedScen%\%iFile_ImportedScen%.gdx" EXECUTE_LOADDC "%iGdxDir_ImportedScen%\%iFile_ImportedScen%.gdx", omegalb, omeganlb, etat, omegat;

* For variant Load pre-calibrated IMPACT land elasticities : if exist

$IfTheni.ImpactElasticities %UseIMPACT%=="ON"
    $$IfThen.exist EXIST "%iDataDir%\IMPACT_Land_Elasticities.gdx"
        $$Iftheni.variant %SimType%=="variant"
            omegalb(r,lb) = 0 ; omeganlb(r) = 0 ; omegat(r) = 0 ;
            EXECUTE_LOADDC "%iDataDir%\IMPACT_Land_Elasticities.gdx",
                omegalb, omeganlb, omegat ;
        $$Endif.variant
    $$Endif.exist
$Endif.ImpactElasticities
$offtext


