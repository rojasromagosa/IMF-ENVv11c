*---    ENV-Linkages subsets for final demands agents

fd(aa) "Agents: Final Demand" /
    $$include "%SetsDir%\Final_demands.gms"
/
h(fd)   "Households" /  hhd   "Households" /
gov(fd) "Government" /  gov   "Government" /
inv(fd) "Investment" /
    inv   "Investment"
    $$IfThenI.MultiCapital %MultiCapital%=="ON"
        inv_build "Investment in Housing and Buildings"
        inv_machi "Investment in Machinery and Equipment"
        inv_RnD   "Investment in Research and Development"
        inv_spec  "Investment sector-specific"
    $$ENDIF.MultiCapital
    /
r_d(fd)  "R & D expenditures" /  r_d "R & D expenditures" /
fdc(fd) "Agents: Other Final Demand" /
    gov   "Government"
    inv   "Investment"
    r_d   "R & D expenditures"
    $$IfThenI.MultiCapital %MultiCapital%=="ON"
        inv_build "Investment in Housing and Buildings"
        inv_machi "Investment in Machinery and Equipment"
        inv_RnD   "Investment in Research and Development"
        inv_spec  "Investment sector-specific"
    $$ENDIF.MultiCapital
/
