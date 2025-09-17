$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1
   name        : "%PolicyPrgDir%\Gov_Closure_Rules.gms"
   purpose     : Government closure rules
   created date: 2022-July-1
   created by  : Jean Chateau
   called by   : %ModelDir%\8-solve.gms
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/model/PolicyPrg/Gov_Closure_Rules.gms $
   last changed revision: $Rev: 20 $
   last changed date    : $Date: 2022-09-20 16:03:19 +0200 (Tue, 20 Sep 2022) $
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
    Memo: This file is read after the policy shocks
          kappah endogenous is the default closure rule
--------------------------------------------------------------------------------
$OffText

* default closure rule: kappah is endogenous

kappah.lo(r,tsim)     $ (GovBalance(r) eq 0) = -inf;
kappah.up(r,tsim)     $ (GovBalance(r) eq 0) =  inf;
kappah.fx(r,tsim)     $ (GovBalance(r) ne 0) = kappah.l(r,tsim);

* alternative closure rules (By default all these are fixed in BAU)

rsg.lo(r,tsim)      $ (GovBalance(r) eq 1) = -inf;
rsg.up(r,tsim)      $ (GovBalance(r) eq 1) =  inf;
rsg.fx(r,tsim)      $ (GovBalance(r) ne 1) = rsg.l(r,tsim);

trg.lo(r,tsim)      $ (GovBalance(r) eq 2) = -inf;
trg.up(r,tsim)      $ (GovBalance(r) eq 2) =  inf;
trg.fx(r,tsim)      $ (GovBalance(r) ne 2) = trg.l(r,tsim);

kappal.lo(r,l,tsim) $ (GovBalance(r) eq 3) = -inf;
kappal.up(r,l,tsim) $ (GovBalance(r) eq 3) =  inf;
kappal.fx(r,l,tsim) $ (GovBalance(r) ne 3) = kappal.l(r,l,tsim);

* For adjustment with VAT AdjTaxCov should be equal to 1 for a multiplicative
* shock or 2 for an additive shock

chiVAT.lo(r,tsim)   $ (GovBalance(r) eq 4) = -inf;
chiVAT.up(r,tsim)   $ (GovBalance(r) eq 4) =  inf;
chiVAT.fx(r,tsim)   $ (GovBalance(r) ne 4 and chiVAT.lo(r,tsim) ne -inf)
    = chiVAT.lo(r,tsim) ;