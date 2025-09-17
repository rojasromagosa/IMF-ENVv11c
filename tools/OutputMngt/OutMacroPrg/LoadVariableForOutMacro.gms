$OnText
--------------------------------------------------------------------------------
                OECD-ENV Model version 1 - Reporting procedure
   Name of the File: "%OutMngtDir%\OutMacroPrg\LoadVariableForOutMacro.gms"
   purpose: Load variables and parameters necessary to recalculate
            the output "out_Macroeconomic" with the stand-alone
            "PostProcedure.gms" procedure
   created date : 2021-10-27
   created by   : Jean Chateau
   called by    : "PostProcedure.gms"
--------------------------------------------------------------------------------
$OffText


EXECUTE_LOAD rgdpmp, gdpmp, pgdpmp, ypc,
    wage, pk, kv, ld, wagep,
    pkp, plandp, pnrfp, pland, land, pnrf, xnrf,
    amgm, ptmg, pwmg, tmarg, pwm, xtt, wldPm, PI0_xc, PI0_xa,
    px, pp, ps, xs, p, x, xp, depr,
    pat, xat, pa, xdt, xa, xw, pe, pdt, pwe,
    tmat, tland, twage,
    LFPR, popWA, UNR, POP,
    ConvertCurToModelUSD, nrj_mtoe,

* Final Demands

    xc, pc, yd, xfd, yfd, pfd,

* Credit market

    rsg, savh, savg, pwsav, savf, deprY, kstock,

* Income taxation rates

    kappal, kappak, kappat, kappan, kappaw, kappah,

* Other fiscal variable

    paTax, chiVAT, ygov, etax, ptax,

* miscellaneous

    pim,

* Efficiency parameters

    lambdal, lambdak, lambdat, lambdanrf, TFP_xpx, TFP_fp, lambdamg, lambdaw,

* Preferences (for utility calculation)

    theta, muc, mus, u,

* Emissions

    chiEmi, emir, p_emissions, emi, part, emiTax
;


