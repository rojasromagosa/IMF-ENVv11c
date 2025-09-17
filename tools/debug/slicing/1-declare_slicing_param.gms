* This file creates parameters to store the end values for slicing

$SETLOCAL item        %1
$SETLOCAL item_sets   %2
$SETLOCAL mode        %3 !! unused here
$SETLOCAL start_value %4 !! can be "tsim-1" for initialization at t-1, "start" for using a specific start varialbe or a specific value or expression
$SETLOCAL condition   %5
$SETLOCAL percentage  %6

$If NOT EXIST %item%_end       %item%_end(%item_sets%,t)
$Ifi "%start_value%"=="start" %item%_start(%item_sets%,t)
