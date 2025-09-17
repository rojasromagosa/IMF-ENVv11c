*************************************************************************************************************************************************************

SETS

EUR(r) "EU+EFTA+UK region" / DEU, FRA, ITA, GBR, REU, BCR, BNL, CSH, NOR, POL /
EUgas(r) "Non-Russian EU gas suppliers" / USA, BNL, NOR, GBR, REU, OAF, ROP, OEA/
rNrg     "Regional agg for energy imports" / NOR_nrg, EU_nrg, OPEC_nrg, USA_nrg, RUS_nrg, AFR_nrg, RoW_nrg , CAN_nrg, AUS_nrg/
map_Mbil(r,rNrg) "Maping for energy import agg" /
AUS . AUS_nrg
CHN . RoW_nrg
JPK . RoW_nrg
IND . RoW_nrg
CAN . CAN_nrg
USA . USA_nrg
FRA . EU_nrg
DEU . EU_nrg
ITA . EU_nrg
BCR . EU_nrg
BNL . EU_nrg
CSH . EU_nrg
POL . EU_nrg
REU . EU_nrg
GBR . EU_nrg
NOR . NOR_nrg
TUR . RoW_nrg
RUS . RUS_nrg
SAU . OPEC_nrg
ROP . OPEC_nrg
ODA . RoW_nrg
OAF . AFR_nrg
OEA . RoW_nrg
OLA . RoW_nrg
/

rembargo(r)    "Countries imposing sanctions to Russia"  / AUS, JPK, CAN, USA, FRA, DEU, CSH, BNL, GBR, NOR, BCR, ITA, POL, REU /


rembargo2(r)    "Countries imposing sanctions to Russia" / AUS, JPK, CAN, USA, FRA, DEU,      BNL, GBR, NOR,      ITA, POL, REU /

gasX(r)         "Alternative gas exporters" / AUS, CAN, USA, OAF /

iemb_rus(i) "Sectors with Russian import bans into countries imposing sanctions"
/frs-c, cns-c, omn-c, wts-c, coa-c, ppp-c, nmm-c, i_s-c, nfm-c, ele-c, txt-c, mvh-c, fmp-c, oma-c, wtp-c, atp-c, otp-c, osg-c, osc-c, ely-c /

iemb_EU(i) "EU sectors included in export ban to Russia"
/i_s-c, nmm-c, fsh-c  /

croil(i) " Crude and refined oil" / oil-c, p_c-c /
elyre(a) "Renewable generation: solar and wind" / wnd-a, sol-a /
;

alias(t,t2);

set
   aets "Agent specific ETS definitions" /
      All      "ALL agents"
      ETS      "ETS activities"
      nonETS   "non-ETS activities"
   /
   mapets(aets,aa) / "ETS".("cns-a", "omn-a", "coa-a", "oil-a", "p_c-a", "gas-a", "clp-a", "olp-a", "gsp-a", "nuc-a",
                                "hyd-a", "wnd-a", "sol-a", "xel-a", "ppp-a", "nmm-a", "i_s-a", "crp-a", "nfm-a", "ele-a",
                                "fdp-a", "txt-a", "mvh-a", "fmp-a", "oma-a", "atp-a") /

;
mapets("nonETS",aa)$(not mapets("ETS",aa)) = yes ;
mapets("ALL",aa) = yes;


