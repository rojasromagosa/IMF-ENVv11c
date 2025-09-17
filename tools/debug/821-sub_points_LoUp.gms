$setargs VarName Indices time DotLU lvlborne condition

%VarName%.%DotLU%(%Indices%,%time%)
    $(%VarName%0(%Indices%)
      and not (%VarName%.lo(%Indices%,%time%) eq %VarName%.up(%Indices%,%time%))
      and %condition%)
    = %lvlborne% * %VarName%.l(%Indices%,%time%);
