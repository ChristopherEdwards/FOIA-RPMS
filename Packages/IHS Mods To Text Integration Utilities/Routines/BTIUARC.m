BTIUARC ; IHS/ITSC/LJF - ARCHIVE UPLOADED FILE ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
MAIN ;-- main program driver    
 D DT,ARC,CLOSE
 Q
 ;
DT ;-- create the file date/time for archiving
 S (FDT,FTM,FNM)=0
 D NOW^%DTC
 S FDT=$P(%,".",1),FTM=$E($P(%,".",2),1,4)
 S FNM="tiu"_FDT_"."_FTM
 Q
 ;
ARC ;-- move the file from upload directory to archive directory
 NEW SITE,DIR,FILE
 S SITE=$O(^TIU(8925.99,"B",DUZ(2),0))
 S FROM=$$GET1^DIQ(8925.99,SITE,9999999.01)
 S TODIR=$$GET1^DIQ(8925.99,SITE,9999999.02)
 S FILE=$$GET1^DIQ(8925.99,SITE,9999999.03)
 S Y=$$MV^%ZISH(FROM,FILE,TODIR,FNM)
 Q
 ;
CLOSE ;-- kill the variables and quit
 K FDT,FTM,FNM
 Q
