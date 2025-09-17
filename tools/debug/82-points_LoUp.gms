$ontext
--------------------------------------------------------------------------------
                        [OECD-ENV] Model - V.1
    GAMS file: "82-points_LoUp.gms"
    purpose: Refine bounds on price to ease solution
             I have added a condition on xpFlag(r,a) in case of cleaning between two years
             This overrides LowerBound defined in "%ModelDir%\26-model.gms"
             Do nothing if prices are fixed
    called by   : %ModelDir%\8-solve.gms
    created     : 17 Decembre 2018
    created by  : Jean Chateau
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/tools/debug/82-points_LoUp.gms $
   last changed revision: $Rev: 338 $
   last changed date    : $Date:: 2023-06-22 #$
   last changed by      : $Author: chateau_j $
--------------------------------------------------------------------------------
 [TBC] pourquoi on met les scales point0 et pas les Flags?
$offtext

pgdpmp.%2(r,tsim) $ pgdpmp0(r)  = %1 * pgdpmp.l(r,tsim-1);
ptmg.%2(img,tsim)   = %1 * ptmg.l(img,tsim-1);
PI0_xa.%2(r,tsim)   = %1 * PI0_xa.l(r,tsim-1);
PI0_xc.%2(r,h,tsim) = %1 * PI0_xc.l(r,h,tsim-1);

$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pp"    "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "px"    "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "uc"    "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pxv"   "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pxp"   "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pva"   "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pva1"  "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pva2"  "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pkef"  "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pkf"   "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pksw"  "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pks"   "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pk"    "r,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "plab1" "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "plab2" "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pnd1"  "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pnd2"  "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pwat"  "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "polg"  "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pnely" "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "pnrg"  "r,a"       "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "p"     "r,a,i"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "wage"  "r,l,a"     "tsim" "%2" "%1" "xpFlag(r,a)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pnrf"  "r,natra"   "tsim" "%2" "%1" "xpFlag(r,natra)"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pland" "r,agra"    "tsim" "%2" "%1" "xpFlag(r,agra)"
$batinclude "%DebugDir%\821-sub_points_LoUpv.gms" "paNRG" "r,a,NRG" "tsim" "%2" "%1" "xpFlag(r,a)"

$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "awagez"    "r,l,z"     "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "twage"     "r,l"       "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "ps"        "r,i"       "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pdt"       "r,i"       "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pat"       "r,i"       "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pe"        "r,i,rp"    "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pet"       "r,i"       "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pmt"       "r,i"       "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pfd"       "r,fd"      "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pc"        "r,k,h"     "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pcnnrg"    "r,k,h"     "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pcnrg"     "r,k,h"     "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "ppb"       "r,pb,elyi" "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "ppbndx"    "r,pb,elyi" "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "ppow"      "r,elyi"    "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "ppowndx"   "r,elyi"    "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "plb"       "r,lb"      "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pnlb"      "r"         "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "plbndx"    "r,lb"      "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "pnlbndx"   "r"         "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "ptland"    "r"         "tsim" "%2" "%1" "1"
$batinclude "%DebugDir%\821-sub_points_LoUp.gms" "ptlandndx" "r"         "tsim" "%2" "%1" "1"