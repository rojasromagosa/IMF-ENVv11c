* %1 = file_in
* %2 = FoldOut

$SetLocal fileIn  "%1"
$SetLocal FoldOut "%2"
File OutFile;

*$Ifi %FoldOut%=="" $SetLocal FoldOut "%system.ifile%"
*display "CSV Files are stored in %FoldOut%";

$CALL 'gdxdump %fileIn%.gdx output=%FoldOut%\symbols.txt Symbols'
$CALL 'tail -n +2       %FoldOut%\symbols.txt  > %FoldOut%\csvFiles.txt'
$CALL 'awk "{print $2}" %FoldOut%\csvFiles.txt > %FoldOut%\tmp'
$CALL 'mv -f %FoldOut%\tmp %FoldOut%\csvFiles.txt'


SET ExportVar /
    $$include "%FoldOut%\csvFiles.txt"
 /;

LOOP(ExportVar,
    PUT_UTILITY OutFile 'exec' / 'gdxdump %fileIn%.gdx format=csv symb=' ExportVar.tl:0 ' output=%FoldOut%\' ExportVar.tl:0 '.csv';
);
EXECUTE 'DEL %FoldOut%\*.txt';

$DropLocal fileIn
$DropLocal FoldOut
