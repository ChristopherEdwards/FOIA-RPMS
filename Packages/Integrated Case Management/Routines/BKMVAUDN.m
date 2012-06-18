BKMVAUDN ;PRXM/HC/CLT - NEW REGISTER ENTRY CREATED ; 11 Mar 2005  12:24 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
NEW(BKMIEN,BKMREG,BKMDUZ) ; EP - Create entry in File 90455 to track new registry entry
 ; Input variables:
 ;  BKMIEN - IEN from File 90451 HMS Registry
 ;  BKMREG - IEN from File 90450
 ; Output variables:
 ;  Record added to File 90455
 K FDA
 ;S %DT="ST",X="N" D ^%DT
 ;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 S FDA(90455,"+1,",1)="N"     ; EVENT TYPE - New
 S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 S FDA(90455,"+1,",5)=BKMDUZ  ; EVENT USER (File 200)
 S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 D UPDATE^DIE("","FDA","")
 K FDA
 Q
 ;
DEL(BKMIEN,BKMREG,BKMDFN,BKMDUZ) ; EP - Create entry in File 90455 to track deleting the registry entry
 ; Input variables:
 ;  BKMIEN - IEN from File 90451 HMS Registry
 ;  BKMREG - IEN from File 90450
 ; Output variables:
 ;  Record added to File 90455
 K FDA
 ;S %DT="ST",X="N" D ^%DT
 ;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 S FDA(90455,"+1,",1)="D"     ; EVENT TYPE - New
 S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 S FDA(90455,"+1,",5)=BKMDUZ  ; EVENT USER (File 200)
 S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 S FDA(90455,"+1,",8)=BKMDFN  ; PATIENT
 D UPDATE^DIE("","FDA","")
 K FDA
 Q
 ;
 ;
