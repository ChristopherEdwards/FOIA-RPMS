ADECD49 ;  IHS/SET/HMW - ADA CODE TABLE UPDATE (CDT4) ;
 ;;6.0;ADE;**12**;MAR 25, 1999
 ;
CDT4REM ;EP - Reminder that ADA Codes for dental extractions were changed by CDT-4
 ;
 N ADEPDAT,Y
 S ADEPDAT=$$PDATE^ADECD49("IHS DENTAL","6.0",12)
 I +ADEPDAT S Y=ADEPDAT X ^DD("DD") S ADEPDAT=Y
 E  S ADEPDAT=""
 W !!,"***Reminder:  Codes from the American Dental Association CDT-4"
 I ADEPDAT]"" W !,"were installed on this system on ",ADEPDAT,"."
 E  W !,"have been installed on this system."
 W !,"If you are searching for extractions (CDT-4 Code 7140),"
 W !,"you must also search for codes 7110, 7120 and 7130"
 W !,"if the beginning date of your search is prior to ",ADEPDAT,".",!
 ;
 Q
 ;
PDATE(ADEPKG,ADEVER,ADEPATCH) ;Returns FM date patch # ADEPATCH was applied to version ADEVER of
 ;package ADEPKG on current system
 ;Returns 0 if unable to find patch install date.
 ;
 N ADEPDATE
 S ADEPDATE=0
 S ADEPKG=+$O(^DIC(9.4,"B",ADEPKG,0)) ;Package
 Q:'ADEPKG ADEPDATE
 S ADEVER=+$O(^DIC(9.4,ADEPKG,22,"B",ADEVER,0)) ;Version
 Q:'ADEVER ADEPDATE
 S ADEPATCH=+$O(^DIC(9.4,ADEPKG,22,ADEVER,"PAH","B",ADEPATCH,0)) ;Patch
 Q:'ADEVER ADEPDATE
 S ADEPDATE=+$P($G(^DIC(9.4,ADEPKG,22,ADEVER,"PAH",ADEPATCH,0)),"^",2)
 Q ADEPDATE
 ;;TEST CODE
 ;;W $$PDATE^ADECD49("IHS DENTAL","6.0",10)
