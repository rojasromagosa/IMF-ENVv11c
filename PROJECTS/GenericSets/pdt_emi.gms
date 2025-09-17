coa%1 "Coal extraction"
oil%1 "Crude Oil extraction"
p_c%1 "Petroleum and coal products"

*---    Gdt:
*   In gtap 9: it also contents steam and hot water supply
*   in GTAP10: "steam and air conditioning supply" are with "ely"

$Ifi %split_gas%=="OFF" gas%1 "Nat. gas: extraction plus manufacture & distribution"
$Ifi %split_gas%=="ON"  gas%1 "Nat. gas: extraction"
$Ifi %split_gas%=="ON"  gdt%1 "Nat. gas: manufacture & distribution"

