$setargs VarName Indices time DotLU lvlborne condition

%VarName%.%DotLU%(%Indices%,v,%time%)
    $(%VarName%0(%Indices%)
      and not (%VarName%.lo(%Indices%,v,%time%) eq %VarName%.up(%Indices%,v,%time%))
      and %condition%)
    = %lvlborne% * %VarName%.l(%Indices%,v,%time%);
