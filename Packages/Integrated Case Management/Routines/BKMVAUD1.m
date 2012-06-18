BKMVAUD1 ;PRXM/HC/CLT - AUDIT CAPTURE CONTINUED ; 11 Mar 2005  12:23 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
EN ; EP - FOR PRE DATA CAPTURE called by EN^BKMVAUD - save pre-edit data from 90451 file to temp global
 ; Input variables:
 ;  BKMIEN - IEN from File 90451 HMS Registry
 ;  BKMREG - IEN from File 90450
 ; Output variables:
 ;  ^TMP("BKMVAUD",$J,N) = Node saved based on ^BKM(90451,BKMIEN,1,BKMREG,N)
 ; Initialize variables
 N BKMI
 ;; Save node 8 - State Reporting Category from File 90451 entry based on BKMIEN and BKMREG
 ;S BKMI=0
 ;F  S BKMI=$O(^BKM(90451,BKMIEN,1,BKMREG,8,BKMI)) Q:'BKMI  S ^TMP("BKMVAUD",$J,8,BKMI)=$G(^BKM(90451,BKMIEN,1,BKMREG,8,BKMI,0))
 ; Save node 50 - HAART Compliance multiple from File 90451 entry based on BKMIEN and BKMREG
 S BKMI=0
 F  S BKMI=$O(^BKM(90451,BKMIEN,1,BKMREG,50,BKMI)) Q:'BKMI  S ^TMP("BKMVAUD",$J,50,BKMI)=$G(^BKM(90451,BKMIEN,1,BKMREG,50,BKMI,0))
 Q
 ;
POST() ; EP - FOR POST DATA CAPTURE called by POST^BKMVAUD - compare post-edit data with pre-edit data
 ;      to determine if audit records should be created
 ; Input variables:
 ;  BKMIEN - IEN from File 90451 HMS Registry
 ;  BKMREG - IEN from File 90450
 ;  DUZ    - IEN from File 200
 ; Output variables:
 ;  Extrinsic function returns - 'E' Edit, 'D' Delete or 'V' View
 ; PRXM/BHS - 04/04/2006 - Replace references to node 8 (removed) with node 50 (added)
 ; Initialize variables
 N BKMV,BKMI,BKMJ,BKMRTN
 S BKMRTN="V"
 ; Retrieve pre-edit data node multiples
 S BKMI=0
 F  S BKMI=$O(^TMP("BKMVAUD",$J,50,BKMI)) Q:'BKMI  S BKMV("PRE",50,BKMI)=$G(^TMP("BKMVAUD",$J,50,BKMI))
 ; Retrieve post-edit data node multiples
 S BKMI=0
 F  S BKMI=$O(^BKM(90451,BKMIEN,1,BKMREG,50,BKMI)) Q:'BKMI  S BKMV("POST",50,BKMI)=$G(^BKM(90451,BKMIEN,1,BKMREG,50,BKMI,0))
 ; If no post-edit nodes exist, consider it a delete and quit
 I $D(BKMV("PRE",50)),'$D(BKMV("POST",50)) Q "D"
 ; If pre-edit and post-edit node 50 pieces differ, consider it a Change
 S BKMI=0
 F  S BKMI=$O(BKMV("PRE",50,BKMI)) Q:'BKMI  I BKMV("PRE",50,BKMI)'=$G(BKMV("POST",50,BKMI)) D
 .; Update return value
 .S BKMRTN="E"
 .; Set the data via FileMan API
 .F BKMJ=1:1:3 I $P(BKMV("PRE",50,BKMI),U,BKMJ)'=$P($G(BKMV("POST",50,BKMI)),U,BKMJ) D
 ..K FDA
 ..;S %DT="ST",X="N" D ^%DT
 ..;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 ..S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 ..S FDA(90455,"+1,",1)="C"     ; EVENT TYPE - Change
 ..S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 ..S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 ..S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 ..S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 ..S FDA(90455,"+1,",3)=$S(BKMJ=1:"50.01",BKMJ=2:"50.1",BKMJ=3:"50.2",1:"") ; EVENT FIELD
 ..S FDA(90455,"+1,",4)=$P(BKMV("PRE",50,BKMI),U,BKMJ)                     ; OLD VALUE
 ..S FDA(90455,"+1,",4.5)=$P($G(BKMV("POST",50,BKMI)),U,BKMJ)                    ; NEW VALUE
 ..D UPDATE^DIE("","FDA","")
 .K FDA
 ;
 ; If post-edit node 50 items exist and pre-edit node 50 items do not, consider it a Change
 S BKMI=0
 F  S BKMI=$O(BKMV("POST",50,BKMI)) Q:'BKMI  I BKMV("POST",50,BKMI)'="",$G(BKMV("PRE",50,BKMI))="" D
 .; Update return value
 .S BKMRTN="E"
 .; Set the data via FileMan API
 .F BKMJ=1:1:3 I $P($G(BKMV("PRE",50,BKMI)),U,BKMJ)'=$P(BKMV("POST",50,BKMI),U,BKMJ) D
 ..K FDA
 ..;S %DT="ST",X="N" D ^%DT
 ..;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 ..S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 ..S FDA(90455,"+1,",1)="C"     ; EVENT TYPE - Change
 ..S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 ..S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 ..S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 ..S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 ..S FDA(90455,"+1,",3)=$S(BKMJ=1:"50.01",BKMJ=2:"50.1",BKMJ=3:"50.2",1:"") ; EVENT FIELD
 ..S FDA(90455,"+1,",4)=$P($G(BKMV("PRE",50,BKMI)),U,BKMJ)                     ; OLD VALUE
 ..S FDA(90455,"+1,",4.5)=$P(BKMV("POST",50,BKMI),U,BKMJ)                    ; NEW VALUE
 ..D UPDATE^DIE("","FDA","")
 .K FDA
 ; Return value
 Q BKMRTN
 ;
 ;
