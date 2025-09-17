$OnText
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
   file name   : %ModelDir%\BundleOption.gms
   purpose     : Standard choices for CET/CES bundle nesting for land allocation
                 and power mix
   created date: 2021-02-19
   created by  : Jean Chateau
   called by   : "%ModelDir%\2-CommonIns.gms"
--------------------------------------------------------------------------------
      $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/23-BundleOption.gms $
   last changed revision: $Rev: 518 $
   last changed date    : $Date:: 2024-02-29 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

*------------------------------------------------------------------------------*
*                   Bundles Nesting for Intermediary Demand                    *
*------------------------------------------------------------------------------*

$IfThenI.BundleChoice SET BundleChoiceInModel

    set mapi1(i,a) "Mapping of commodities to ND1 bundle" ;

    IF(0,

* [ENVISAGE] choices

        abort $ (card(iw) eq 0) "!!! iw must content water commodity";
        mapi1(i,axa) $ ((NOT ei(i)) and (NOT iw(i))) = YES;
        mapi1(i,cra) $ ((NOT frti(i))  and (NOT ei(i)) and (NOT iw(i)) ) = YES ;
        mapi1(i,lva) $ ((NOT feedi(i)) and (NOT ei(i)) and (NOT iw(i)) ) = YES ;

    ELSE

* [OECD-ENV] New water set 'wtr' with other be sure that iw(i) is empty

        abort$(card(iw) gt 0) "!!! iw must be empty for this to work";
        mapi1(i,axa) $ ( NOT ei(i)) = YES;
        mapi1(i,cra) $ ((NOT frti(i))  and (NOT ei(i)) ) = YES ;
        mapi1(i,lva) $ ((NOT feedi(i)) and (NOT ei(i)) ) = YES ;
    ) ;


    set mapi2(i,a) "Mapping of commodities to ND2 bundle" ;
    mapi2(frti,cra)  = YES ;
    mapi2(feedi,lva) = YES ;

$Endif.BundleChoice

*------------------------------------------------------------------------------*
*                   Land CET Bundle Nestings                                   *
*------------------------------------------------------------------------------*
$OnEmpty

* #TODO: il faut qu'on puisse dans cas multi crops passer a un seul bundle hors aggreg.

$IfTheni.OneLandBndNest %LandBndNest%=="OneBundle"

$OnText

                 TLAND = xlb("TotalLand")
                  / \
                omegat(r)
                /     \
               /       \
         XLB("NFCP")   XNLB = CET(XLB("COP"), XLB("NCOP")) = FCP bundle
       [gamlb("NFCP"]  [gamnlb]
                        / \
                     omeganlb(r)
                      /     \
                     /       \
              XLB("COP")   XLB("NCOP")
             [gamlb(COP)] [gamlb(NCOP)]
$OffText

    SETS
        lb  "Land bundles"          / "TotalLand" /
        lb1(lb) "First land bundle" / "TotalLand" /
        lb2(lb) "Second level land bundle"  /    /
        maplb(lb,a) "Mapping of activities to land bundles"
    ;
    maplb(lb,cra) = YES ;
    maplb(lb,lva) = YES ;


$EndIf.OneLandBndNest

$IfTheni.MAGNETLandBndNest %LandBndNest%=="MAGNET"

$ontext

                 TLAND = CET(XLB("NFCP"),XNLB=FCP bundle)
                  / \
                omegat(r)
                /     \
               /       \
         XLB("NFCP")   XNLB = CET(XLB("COP"), XLB("NCOP")) = FCP bundle
       [gamlb("NFCP"]  [gamnlb]
                        / \
                     omeganlb(r)
                      /     \
                     /       \
              XLB("COP")   XLB("NCOP")
             [gamlb(COP)] [gamlb(NCOP)]

	with bottom nests:

						XLB("NFCP")
						/|\
					omegalb("NFCP")
					  /  |  \
					 /   |   \
land("pfb-a") land("v_f-a") land("pdr-a") land("ocr-a")
[gammat("pfb-a") gammat("v_f-a") gammat("pdr-a") gammat("ocr-a")]

						XLB("NCOP")
						/|\
					omegalb("NCOP")
			   		  /  |  \
					 /   |   \
		land("c_b-a") land(lva_1)..land(lva_n)
	[gammat("c_b-a")  gammat(lva_1)..gammat(lva_n)]

						XLB("COP")
						/|\
					omegalb("COP")
					  /  |  \
					 /   |   \
		land("wht-a") land("gro-a") land("osd-a")
    [gammat("wht-a") gammat("gro-a") gammat("osd-a")]

$offtext

    SETS
        lb "Land bundles" /
            NFCP "Non Field Crops and Pasture"
            COP  "Cereals Oilseeds and Protein crops"
            NCOP "Sugar Beet and Livestock"
            /
        lb1(lb) "First land bundle" / NFCP "Non Field Crops and Pasture" /
        lb2(lb) "Second level land bundle (xnlb)"  /
            COP  "Cereals Oilseeds and Protein crops"
            NCOP "Sugar Beet and Livestock"
        /
        maplb(lb,a) "Mapping of activities to land bundles" /
            NFCP.(v_f-a,pfb-a,ocr-a,pdr-a)
            COP .(wht-a,gro-a,osd-a)
            NCOP.c_b-a
        /
    ;
    maplb("NCOP",lva) = YES ;

$EndIf.MAGNETLandBndNest

*------------------------------------------------------------------------------*
*               Predefined Power Bundle Nestings                               *
*------------------------------------------------------------------------------*

$IfTheni.PowerData %IfPower%=="ON"
    SETS
        $$IfTheni.ElyBndNest %ElyBndNest%=="default"

            pb "Power bundles in power aggregation" /
                Allp    "All power bundle"
                GasP    "Gas power"
                OilP    "Oil power"
                coap    "Coal power"
                nucp    "Nuclear power"
                othp    "Other power"
            /
            mappow(pb,a) "Mapping of power activities to power bundles" /
                coap.clp-a
                gasp.gsp-a
                oilp.olp-a
                nucp.nuc-a
                othp.(hyd-a,wnd-a,sol-a,xel-a)
            /
            fospbnd(pb) / GasP, OilP, OilP /
            Nukebnd(pb) / nucp /

        $$ElseIfi.ElyBndNest %ElyBndNest%=="4Bundles"

            pb "Power bundles" /
                Allp    "All power bundle"
                fosp    "Fossil fuel power bundle"
                nucp    "Nuclear power bundle"
                othp    "Other power bundle"
                hydp    "Hydro power bundle"
            /
            mappow(pb,a) "Mapping of power activities to power bundles" /
                fosp.(clp-a,gsp-a,olp-a)
                nucp.nuc-a
                hydp.hyd-a
                othp.(wnd-a,sol-a,xel-a)
            /
            fospbnd(pb) / fosp /
            Nukebnd(pb) / nucp /

        $$ElseIfi.ElyBndNest %ElyBndNest%=="GIMF"

            pb "Power bundles" /
                Allp    "All power bundle"
                ocop    "Oil and COAL power bundle"
                nucp    "Nuclear power bundle"
                gswp    "Gas-Solar-Wind-OtherRen power bundle"
                hydp    "Hydro power bundle"
            /
            mappow(pb,a) "Mapping of power activities to power bundles" /
                ocop.(clp-a,olp-a)
                nucp.nuc-a
                hydp.hyd-a
                gswp.(wnd-a,sol-a,xel-a,gsp-a)
            /

        $$ElseIfi.ElyBndNest  %ElyBndNest%=="ENV-LinkagesV3"

            pb "Power bundles" /
                Allp       "All power bundle"
                ELFOSS     "Fossil fuel power bundle"
                NUCLEAR    "Nuclear power bundle"
                SOLWIND    "Solar and Wind power"
                HYDRO      "Hydro power bundle" "Other power bundle"
                COMRENEW   "Other power bundle"
            /
            mappow(pb,a) "Mapping of power activities to power bundles" /
                ELFOSS  .(clp-a,gsp-a,olp-a)
                NUCLEAR .nuc-a
                HYDRO   .hyd-a
                SOLWIND .(wnd-a,sol-a)
                COMRENEW.xel-a
            /
            fospbnd(pb) / ELFOSS /
            Nukebnd(pb) / NUCLEAR /

        $$ElseIfi.ElyBndNest %ElyBndNest%=="1Bundle"

            pb "Power bundles" /
                Allp       "All power bundle"
            /
            mappow(pb,a) "Mapping of power activities to power bundles" /
                Allp.(clp-a,gsp-a,olp-a,nuc-a,hyd-a,wnd-a,sol-a,xel-a)
            /

        $$EndIf.ElyBndNest
    ;

*	Additional Sets on Power

    SETS
        OLPa(a)  "Oil Power Generation" / olp-a /
        GSPa(a)  "Gas Power Generation" / gsp-a /
        CLPa(a)  "CLP Power Generation" / clp-a /
        HYDROa(a)    / hyd-a /
        COMRENEWa(a) / xel-a /
        NUKEa(a)     / nuc-a /
		SOLARa(a)   "Solar power" / sol-a /
		WINDa(a)    "Wind power"  / wnd-a /
        SOLWINDa(a) "Solar and Wind power" / sol-a, wnd-a /
    ;

$ELSE.PowerData

*---    No Power sectors in the model

    SETS
        pb              / Allp        "All power bundle" /
        mappow(pb,a)    / Allp.ELY-a /
        nspb(pb)        /  /
        OLPa(a)         /  /
        GSPa(a)         /  /
        CLPa(a)         /  /
        HYDROa(a)       /  /
        COMRENEWa(a)    /  /
        NUKEa(a)        /  /
        SOLWINDa(a)     /  /
        fospbnd(pb)     /  /
        Nukebnd(pb)     /  /
    ;

    IfPower = 0;

$ENDIF.PowerData

SETS
    Allpb(pb) / Allp /
    s_otra(a)    "Renewables Power excluding Hydro and Nuke Power"
    s_rena(a)    "Non Fossil-Fuel Power activities (including ETD)"
    powa(a)      "Power Sectors"
    nspb(pb)     "non-singleton power-bundles"
;

* [EditJean] : if I defined set like this cannot put xbndEQ(r,powa,elyi,t)

s_otra(a) = COMRENEWa(a) + SOLWINDa(a);
s_rena(a) = s_otra(a) + HYDROa(a) + NUKEa(a) + ETDa(a);
powa(a) = elya(a) - etda(a);

LOOP(pb $ ( sum(mappow(pb,elya),1) gt 1),
    nspb(pb) = YES;
) ;

$OffEmpty
