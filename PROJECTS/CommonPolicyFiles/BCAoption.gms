$OnText
--------------------------------------------------------------------------------
                [OECD-ENV] Model version 1 - Policy
   name        : "CommonPolicyFiles\BCAoption.gms"
   purpose     :  Options for BCA runs for IMF projects
   created date: 2021-05-06
   created by  : Jean Chateau
   called by   : "2022_CountryStudies\InputFiles\CTax.gms"
                 "2023_G20\InputFiles\Policy_ICPF.gms"
                 "CoordinationG20\InputFiles\CTax.gms"
				 ...
--------------------------------------------------------------------------------
   $URL: file:///C:/Users/chateau_j/OneDrive%20-%20OECD/MODELS/SVNDepots/CGE/trunk/PROJECTS/CommonPolicyFiles/BCAoption.gms $
   last changed revision: $Rev: 313 $
   last changed date    : $Date:: 2023-05-15 #$
   last changed by      : $Author: Chateau_J $
--------------------------------------------------------------------------------
$OffText

* Default BCA country coverage

$batinclude "%PolicyPrgDir%\BCA.gms" "DeclareBCA"

*	For Coordination Project Redefinition of Acting vs Non acting

* Case CPF_NotGr3: Acting countries are in group Coalition1 and Coalition2
*   --> Coalition1 do not put BCA on Coalition2

$IfTheni.Main %Acting% == "NotGr3"
   where_tariff(rp,r,i)
       $ (mapr("Coalition1",r) and mapr("Coalition2",rp)) = 0;
   where_export(r,rp,i)
       $ (mapr("Coalition1",r) and mapr("Coalition2",rp)) = 0;
$Endif.Main

* Case CPF_Gr1 or CPF_EU : Acting countries are in group Coalition 1 or EU
*   --> Coalition2 do not put any BCA on Coalition3

$IfTheni.Onlygr1 NOT %Acting% == "NotGr3"
   where_tariff(rp,r,i)
       $ (mapr("Coalition2",r) and mapr("Coalition3",rp)) = 0;
   where_export(r,rp,i)
       $ (mapr("Coalition2",r) and mapr("Coalition3",rp)) = 0;
$Endif.Onlygr1

* Saudi do not apply or being subsject to BCA

IF(1,
    where_tariff(Saudi,r,i) = 0 ; where_tariff(rp,Saudi,i) = 0 ;
    where_export(r,Saudi,i) = 0 ; where_export(Saudi,rp,i) = 0 ;
) ;

* Case CPF_EU: Only EU countries are Acting
*   --> Non-EU countries do not put any BCA anywhere
*   --> EU countries put BCA on non-acting HIC

$IfTheni.OnlyEU %Acting%=="EU"
   IF(IfBCA_type eq 1 or IfBCA_type eq 2,
       where_tariff(GR1NOTEU,EU,i) = 1 ;
       where_tariff(rp,GR1NOTEU,i) = 0 ;
   ) ;
   IF(IfBCA_type eq 2 or IfBCA_type eq 3,
       where_export(EU,GR1NOTEU,i) = 1 ;
       where_export(GR1NOTEU,rp,i) = 0 ;
   ) ;
$Endif.OnlyEU
