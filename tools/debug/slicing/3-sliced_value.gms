
$SETLOCAL item        %1
$SETLOCAL item_sets   %2
$SETLOCAL mode        %3 !! "param" for parameter (no suffix), "var" for variable (.fx suffix)
$SETLOCAL start_value %4 !! can be "tsim-1" for initialization at t-1, "start" for using a specific start varialbe or a specific value or expression
$SETLOCAL condition   %5
$SETLOCAL percentage  %6

$IF "%condition%"=="" $SETLOCAL condition 1

$IF "%mode%"=="var"   $SETLOCAL valsuffix ".l"
$IF "%mode%"=="var"   $SETLOCAL setsuffix ".fx"
$IF "%mode%"=="param" $SETLOCAL valsuffix ""
$IF "%mode%"=="param" $SETLOCAL setsuffix ""

$ondotl

%item%%setsuffix%(%item_sets%,tsim)
    $((
      !! if variable, first check that the variable is a .fx
      $$IF "%mode%"=="var" %item%.lo(%item_sets%,tsim) eq %item%.up(%item_sets%,tsim)
      $$IF "%mode%"=="param" 1
      !! then check if the condition arguments is also true
      ) AND %condition%)
      
    = %percentage% * %item%_end(%item_sets%,tsim)

      $$IfTheni.lag "%start_value%"=="tsim-1"

        + (1 - %percentage%) * %item%%valsuffix%(%item_sets%,tsim-1)

      $$Else.lag

        $$IfTheni.start "%start_value%"=="start"

            + (1 - %percentage%) * %item%_start(%item_sets%,tsim)

        $$Else.start

            + (1- %percentage%) * %start_value%

        $$EndIf.start

      $$EndIf.lag
      ;

$offdotl
