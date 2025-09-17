scalar
    todaydate    "Gregorian date and time of start of GAMS job"
    year         "Year of job"
    month        "Month of job"
    day          "Day of job";

todaydate = jstart;
year      = gyear(todaydate);
month     = gmonth(todaydate);
day       = gday(todaydate);

file dateout / '%RootDir%\date.txt' / ;
put dateout;

put "$SetGlobal dateout ", year:4:0;
IF(month lt 10,
    put '_0', month:1:0;
else
    put '_', month:2:0;
);
IF(day lt 10,
    put '_0', day:1:0 ;
else
    put '_', day:2:0 ;
);
putclose dateout;

