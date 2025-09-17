$setlocal ModName "%1"

* [OECD-ENV]: Save simulation for the current year (always for the 1st year)

IF(ord(tsim) eq 2 or (ord(tsim) gt 2 and IfSaveYr), option savepoint=1 ; ) ;

* [OECD-ENV]: Load a given simulation for the current year: IfLoadYr > 0

IF(IfLoadYr eq 1,
	Display "Reading an existing solution for this year:", year;

    IF(IfMCP eq 1,
        PUT_UTILITY loadsolution 'gdxin' / '%iDataDir%\mcp_%ModName%_' tsim.tl:4:0 '.gdx' ;
    ELSE
        PUT_UTILITY loadsolution 'gdxin' / '%iDataDir%\cns_%ModName%_' tsim.tl:4:0 '.gdx' ;
    );
	EXECUTE_LOADPOINT ;
) ;
IF(IfLoadYr eq 2,
	Display "Reading an existing solution for this year:", year;

    IF(IfMCP eq 1,
        PUT_UTILITY loadsolution 'gdxin' / '%SimDir%\mcp_%ModName%_' tsim.tl:4:0 '.gdx' ;
    ELSE
        PUT_UTILITY loadsolution 'gdxin' / '%SimDir%\cns_%ModName%_' tsim.tl:4:0 '.gdx' ;
    ) ;
	EXECUTE_LOADPOINT ;
) ;

*	Optional specific initialisation

$IF EXIST "%iFilesDir%\initialisation.txt" $include "%iFilesDir%\initialisation.txt"

*	Solve the model

IF(ifMCP eq 1,

*	MCP mode

* but this fix should be removed when the capital allocation
* between old and new is thought through
* (issue was xpv(vold, wnd,OAF)=0 giving negative rrat)
    rrat.lo(r,a,tsim)$(not tota(a)) = 1e-6;
*    $$IFI %module_SectInv% =="ON" rrat.lo(r,a,tsim)$(not tota(a) and ExtraCapFlag(r,a) eq 1) = 1;
    rrat.up(r,a,tsim)$(not tota(a)) = 1;
*    %ModName%.optfile = 1;
    put screen "Using MCP/PATH ", years(tsim):4:0 /; putclose screen;
    solve %ModName% using mcp;

ELSEIF(ifMCP eq 2),

*	CNS mode

    rrat.up(r,a,tsim)$(not tota(a))  = inf;
*    $$IFI %module_SectInv% =="ON" rrat.lo(r,a,tsim)$(not tota(a) and ExtraCapFlag(r,a) eq 1) = 1;
*    $$IFI %module_SectInv% =="ON" rrat.up(r,a,tsim)$(not tota(a) and ExtraCapFlag(r,a) eq 1) = 1;
*    %ModName%.optfile    = 1; !! put in command line: optDir=C:\MODELS\CGE\tools\SolverFiles
*	 %ModName%.holdfixed = 1;
*	 %ModName%.workspace = 1000;
    put screen "Using CNS/Conopt ", years(tsim):4:0 /; putclose screen;
    solve %ModName% using cns;

ELSEIF(ifMCP eq 3),

    put screen "Using DNLP/CONOPT ", years(tsim):4:0 /; putclose screen;
    %ModName%.optfile = 1;
* AR avant walras avait pas de dim, maintenant t
*    solve %ModName% using dnlp minimizing walras(tsim);

) ;


$OnText
$OnDotl
walras.l
    = sum(r$rs(r),
            sum((i,rp) $ xwFlag(r,i,rp), pwe0(r,i,rp)*PWE_SUB(r,i,rp,t)*xw0(r,i,rp)*xw.l(r,i,rp,t))
          - sum((i,rp) $ xwFlag(rp,i,r), pwm0(rp,i,r)*PWM_SUB(rp,i,r,t)*lambdaw(rp,i,r,t)*xw0(rp,i,r)*xw.l(rp,i,r,t))
          + sum(img $ xttFlag(r,img), (pdt0(r,img)*pdt(r,img,t))*xtt.l(r,img,t)*xtt0(r,img))
          + pwsav(t)*savf.l(r,t)
          + yqht0(r)*yqht.l(r,t) - yqtf0(r)*yqtf.l(r,t)
          + sum((rp,l),remit0(r,l,rp)*remit.l(r,l,rp,t)-remit0(rp,l,r)*remit.l(rp,l,r,t))
      );
$OffDotl
$OffText

$droplocal ModName
