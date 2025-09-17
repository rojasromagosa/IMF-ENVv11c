*$setargs item item_sets

$SETLOCAL item          %1
$SETLOCAL item_sets     %2
$SETLOCAL mode          %3 !! unused here
$SETLOCAL start_value   %4 !! unused here
$SETLOCAL condition     %5 !! unused here
$SETLOCAL percentage    %6 !! unused here

%item%_end(%item_sets%,tsim) = %item%(%item_sets%,tsim) ;

