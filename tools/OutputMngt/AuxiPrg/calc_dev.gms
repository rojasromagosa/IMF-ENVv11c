$OnText
Calculation rate of growth and ratio from starting year
%1 name var,  exemple "gross_output"
%2 arguments, exemple "units,r,a" or "units,'USA',rice"

Exemple:
Gross_output("g_dev",units,r,a,t)
      $Gross_output("abs",units,r,a,t-1)
    = Gross_output("abs",units,r,a,t) / Gross_output("abs",units,r,a,t-1) - 1;
Gross_output("ratio_to_%YearRef%",units,r,a,t)
      $Gross_output("abs",units,r,a,"%YearStart%")
    = Gross_output("abs",units,r,a,t) / Gross_output("abs",units,r,a,"%YearStart%");

$OffText

IF(%aux_outType% ne AbsValueOnly,

    LOOP(abstype,

* Annual Growth Rate

        %1("g_dev",%2,t) $ [%1(abstype,%2,t-1) and %1(abstype,%2,t)]
            = %1(abstype,%2,t) / %1(abstype,%2,t-1) - 1 ;

* Ratio from %YearRef% only for ReportYr

        %1("ratio_to_%YearRef%",%2,ReportYr) $ %1(abstype,%2,"%YearRef%")
            = %1(abstype,%2,ReportYr) / %1(abstype,%2,"%YearRef%") ;
    ) ;
) ;
