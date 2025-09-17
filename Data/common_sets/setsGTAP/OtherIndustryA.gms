*   Set of Other Industries (excluding NatRes sectors)

p_c   "Manufacture of coke and refined petroleum products"

$OnText
GTAP 9 and before:
    "gdt" includes Gas Distribution: distribution
    of gaseous fuels through mains; steam and hot water supply
    "ely" Electricity: production, collection and distribution
GTAP 10:
    "gdt" includes Gas manufacture, distribution
    "ely" includes Electricity plus "steam and air conditioning supply"

Steam and air conditioning supply:

This class includes:
    •   production, collection and distribution of steam and hot water
    for heating, power and other purposes
    •   production and distribution of cooled air
    •   production and distribution of chilled water for cooling purposes
    •   production of ice, including ice for food and non-food (e.g. cooling) purposes

$OffText
gdt   "Gas manufacture, distribution"

$OnText
* GTAP 9 and before: "wtr" includes Water: collection, purification and distribution
* GTAP 10 "wtr" includes Water supply; sewerage, waste management and remediation activities
* In details:
    •   ISIC Division 36: Collection, purification and distribution of water,
        water collection, treatment and supply
    •   ISIC Division 37: Sewerage
    •   ISIC Division 38: Waste collection, treatment and disposal activities;
        materials recovery
    •   ISIC Division 39: Remediation activities
        and other waste management services
$OffText

wtr   "Water supply; sewerage, waste management"

cns   "Construction" !! Construction: building houses factories offices and roads

$$IFi %IfPower%=="ON" TnD "Electricity transmission and distribution"