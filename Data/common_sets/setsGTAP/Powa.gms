*   Set of GTAP-Power

$IfTheni.power %IfPower%=="ON"

    NuclearBL   "Nuclear power"
    CoalBL      "Coal power baseload"
    GasBL       "Gas power baseload"
    WindBL      "Wind power"
    HydroBL     "Hydro power baseload"
    OilBL       "Oil power baseload"
    OtherBL     "Other baseload includes biofuels, waste, geothermal, and tidal technologies"
    GasP        "Gas power peakload"
    HydroP      "Hydro power peakload"
    OilP        "Oil power peakload"
    SolarP      "Solar power"

    colccs      "Coal-based CCS"
    gasccs      "Gas-based CCS"
    advnuc      "Advanced nuclear"

$ELSE.power

    ely   "Electricity Power and Distribution"

$ENDIF.power
