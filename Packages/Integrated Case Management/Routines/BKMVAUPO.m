BKMVAUPO ;PRXM/HC/CLT - AUDIT PRINT ROUTINE ; 14 Jun 2005  6:20 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 QUIT
 ;
ENO(BKMX) ;ENTRY POINT - PRINTING OPTION ACCESS(Called from OPTC1^BKMVAUC).
 ; Input variables:
 ;  BKMX - IEN for File 90455
 ; Output variables:
 ;  n/a
 N BKMVDT,BKMVREG,BKMVOPT,BKMVU
 ;
 D
 .; Date/time
 .;S Y=$$GET1^DIQ(90455,BKMX_",",.01,"I")
 .;D DD^%DT
 .;S BKMVDT=Y
 .S BKMVDT=$$FMTE^XLFDT($$GET1^DIQ(90455,BKMX_",",.01,"I"),1)
 .; Register
 .S BKMVREG=$$GET1^DIQ(90455,BKMX_",",6,"I")
 .I BKMVREG'="" S BKMVREG=$$GET1^DIQ(90450,BKMVREG_",",.01,"E")
 .; Accessed Option
 .S BKMVOPT=$$GET1^DIQ(90455,BKMX_",",7,"E")
 .; User
 .S BKMVU=$$GET1^DIQ(90455,BKMX_",",5,"E")
 .; Print audit entry
 .D PRT(BKMVDT,BKMVREG,BKMVOPT,BKMVU)
 .K X,Y
 Q
 ;
PRT(BKMVDT,BKMVREG,BKMVOPT,BKMVU) ; PRINT AN AUDIT ENTY
 ; Input variables:
 ;  BKMVDT  - Audit date/time
 ;  BKMVREG - Register
 ;  BKMVOPT - Accessed Option
 ;  BKMVU   - User
 ; Output variables:
 ;  n/a
 W !,?1,BKMVDT,?39," Register: ",BKMVREG
 W !,?2,"Option: ",BKMVOPT,?39," User: ",?50,BKMVU
 W !
 Q
 ;
 ;
