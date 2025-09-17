*---    recalculation pop

tHist("Population","volume",ra,tt)
    = sum(mapr(ra,r), POPvar("Total",r,tt));
tHist("Active population","volume",ra,tt)
    = sum((r,l,z)$(mapr(ra,r) and UNRT(r,tt) and ERT(r,tt)),
        [ERT(r,tt) * POPvar("15plus",r,tt)] / [1-UNRT(r,tt)]  );
tHist("Employment","volume",ra,tt)
    = sum(mapr(ra,r), ERT(r,tt) * POPvar("15plus",r,tt));
tHist("Unemployment rate","volume",ra,tt)
    $ tHist("Active population","volume",ra,tt)
    = 1 - tHist("Employment","volume",ra,tt)
        / tHist("Active population","volume",ra,tt);
tHist("Children population","volume",ra,tt)
    = sum(mapr(ra,r), POPvar("Total",r,tt)-POPvar("15Plus",r,tt));
tHist("Senior population","volume",ra,tt)
    = sum(mapr(ra,r), POPvar("75plus",r,tt));
tHist("Working-age population","volume",ra,tt)
    = tHist("Population","volume",ra,tt)
    - tHist("Children population","volume",ra,tt);

tHist("Dependency Ratio: old","volume",ra,tt)
    $ [sum(mapr(ra,r), POPvar("15plus",r,tt))-sum(mapr(ra,r), POPvar("65plus",r,tt))]
    =  sum(mapr(ra,r), POPvar("65plus",r,tt))
    / [sum(mapr(ra,r), POPvar("15plus",r,tt))-sum(mapr(ra,r), POPvar("65plus",r,tt))];

tHist("Dependency Ratio: young","volume",ra,tt)
    $ [sum(mapr(ra,r), POPvar("15plus",r,tt))-sum(mapr(ra,r), POPvar("65plus",r,tt))]
    = tHist("Children population","volume",ra,tt)
    / [sum(mapr(ra,r), POPvar("15plus",r,tt))-sum(mapr(ra,r), POPvar("65plus",r,tt))];

tHist("GDP","real",ra,tt)  = sum(mapr(ra,r), ENVGrowth_GDP("cst_usd",r,tt)) ;
tHist("GDP per capita","real",ra,tt)   = sum(mapr(ra,r), ypc("cst_usd",r,tt)) ;
tHist("GDP per capita","nominal",ra,tt)= sum(mapr(ra,r), ypc("cur_usd",r,tt)) ;
tHist("GDP (cst PPP)","real",ra,tt)
    = sum(mapr(ra,r), ENVGrowth_GDP("cst_itl",r,tt));
tHist("GDP per capita (cst PPP)","real",ra,tt)
    = sum(mapr(ra,r), ypc("cst_itl",r,tt));

tHist("Agriculture share (BP)","real",ra,tt)
    $ sum(mapr(ra,r), ENVGrowth_GDP("cst_usd",r,tt))
    = sum(mapr(ra,r), VA_share("cst_usd","Agriculture",r,tt) * ENVGrowth_GDP("cst_usd",r,tt))
    / sum(mapr(ra,r), ENVGrowth_GDP("cst_usd",r,tt));
tHist("Agriculture share (BP)","nominal",ra,tt)
    $ sum(mapr(ra,r), ENVGrowth_GDP("cur_usd",r,tt))
    = sum(mapr(ra,r), VA_share("cur_usd","Agriculture",r,tt) * ENVGrowth_GDP("cur_usd",r,tt))
    / sum(mapr(ra,r), ENVGrowth_GDP("cur_usd",r,tt));
tHist("Service share (BP)","real",ra,tt)
    $ sum(mapr(ra,r), ENVGrowth_GDP("cst_usd",r,tt))
    = sum(mapr(ra,r), VA_share("cst_usd","Services",r,tt) * ENVGrowth_GDP("cst_usd",r,tt))
    / sum(mapr(ra,r), ENVGrowth_GDP("cst_usd",r,tt));
tHist("Service share (BP)","nominal",ra,tt)
    $ sum(mapr(ra,r), ENVGrowth_GDP("cur_usd",r,tt))
    = sum(mapr(ra,r), VA_share("cur_usd","Services",r,tt) * ENVGrowth_GDP("cur_usd",r,tt))
    / sum(mapr(ra,r), ENVGrowth_GDP("cur_usd",r,tt));

work = %YearStart%-1;
while(work ge %YearHist%,
    out_Macroeconomic(abstype,macrocat,macrolist,units,ra,tt)
        $(years(tt) eq work and tHist(macrolist,units,ra,tt+1) and tHist(macrolist,units,ra,tt))
        = out_Macroeconomic(abstype,macrocat,macrolist,units,ra,tt+1)
        * tHist(macrolist,units,ra,tt)
        / tHist(macrolist,units,ra,tt+1);
    work = work - 1;
);

out_Macroeconomic(abstype,"Remarkable Ratios","Industry share (BP)",notvol,ra,tt)
    $ out_Macroeconomic(abstype,"Remarkable Ratios","Service share (BP)",notvol,ra,tt)
    = 1 - out_Macroeconomic(abstype,"Remarkable Ratios","Service share (BP)",notvol,ra,tt)
        - out_Macroeconomic(abstype,"Remarkable Ratios","Agriculture share (BP)",notvol,ra,tt);


