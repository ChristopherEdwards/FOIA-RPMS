BKMVAUD ;PRXM/HC/CLT - AUDIT FILE BUILD ROUTINE ; 14 Jun 2005  5:26 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
 ;
EN ; EP - Pre-edit capture from 90451 file to temp global
 ; Input variables:
 ;  BKMIEN - IEN from File 90451 HMS Registry
 ;  BKMREG - IEN from File 90450
 ; Output variables:
 ;  ^TMP("BKMVAUD",$J,N) = Node saved based on ^BKM(90451,BKMIEN,1,BKMREG,N)
 ; Initialize variables
 N BKMI
 K ^TMP("BKMVAUD",$J)
 ; Save nodes 0,2,3,5,6 from File 90451 entry based on BKMIEN and BKMREG
 ; PRXM/BHS - 04/04/2006 - Added capture of node 5
 F BKMI=0,2,3,5,6 S ^TMP("BKMVAUD",$J,BKMI)=$G(^BKM(90451,BKMIEN,1,BKMREG,BKMI))
 ; Save nodes 40 and 50 - multiples
 D EN^BKMVAUD1,EN^BKMVAUD2
 Q
 ;
ENO ; EP - OPTION ACCESSED AUDITING - create entry in File 90455 to track accessed option
 ; Input variables:
 ;  DUZ - User IEN from File 200
 ;  XQY - IEN from File 19
 ; Output variables:
 ;  Record added to File 90455
 N HIVIEN
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" Q
 K FDA
 ;S %DT="ST",X="N" D ^%DT
 ;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 S FDA(90455,"+1,",1)="A"     ; EVENT TYPE - Access
 S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 S FDA(90455,"+1,",6)=HIVIEN  ; REGISTER
 S FDA(90455,"+1,",7)=XQY     ; OPTION ACCESSED (File 19)
 D UPDATE^DIE("","FDA","")
 K FDA
 Q
 ;
POST ; EP - POST EDIT ACTIONS - compare post-edit data with pre-edit data
 ;      to determine if audit records should be created
 ; Input variables:
 ;  BKMIEN - IEN from File 90451 HMS Registry
 ;  BKMREG - IEN from File 90450
 ;  DUZ - User IEN from File 200
 ; Output variables:
 ;  Record(s) added to File 90455
 ; Initialize variables
 N BKMV,BKMI,BKMJ,BKMED,BKMDEL,BKMTST40,BKMTST50
 S BKMED="",BKMDEL=""
 ; Retrieve pre-edit data nodes 0, 2, 3, 5 and 6
 F BKMI=0,2,3,5,6 S BKMV("PRE",BKMI)=$G(^TMP("BKMVAUD",$J,BKMI))
 ; Retrieve post-edit data nodes 0, 2, 3, 5 and 6
 F BKMI=0,2,3,5,6 S BKMV("POST",BKMI)=$G(^BKM(90451,BKMIEN,1,BKMREG,BKMI))
 ; Continuation of POST EDIT ACTIONS
 ; PRXM/BHS - 04/04/2006 - BKMVAUD1 now refers to node 50 rather than node 8 (which was removed)
 ;S BKMTST8=$$POST^BKMVAUD1()
 ;I BKMTST8="E" S BKMED=1
 S BKMTST40=$$POST^BKMVAUD2()
 I BKMTST40="E" S BKMED=1
 S BKMTST50=$$POST^BKMVAUD1()
 I BKMTST50="E" S BKMED=1
 ;
 ; If pre-edit and post-edit nodes 0, 2, 3, 5 and 6 are identical, consider it a View
 I BKMV("PRE",0)=BKMV("POST",0),(BKMV("PRE",2)=BKMV("POST",2)),(BKMV("PRE",3)=BKMV("POST",3)),(BKMV("PRE",5)=BKMV("POST",5)),(BKMV("PRE",6)=BKMV("POST",6)),BKMTST40="V",BKMTST50="V" D  G XIT
 .; Set the data via FileMan API
 .K FDA
 .;S %DT="ST",X="N" D ^%DT
 .;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 .S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 .S FDA(90455,"+1,",1)="V"     ; EVENT TYPE - View
 .S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 .S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 .S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 .S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 .D UPDATE^DIE("","FDA","")
 .K FDA
 ;
 ; If post-edit nodes 0, 2, 3, 5 and 6 are NULL, consider it a Delete
 I BKMV("POST",0)="",(BKMV("POST",2)=""),(BKMV("POST",3)=""),(BKMV("POST",5)=""),(BKMV("POST",6)=""),BKMTST50="D",BKMTST40="D" D  G XIT
 .; Set the data via FileMan API
 .K FDA
 .;S %DT="ST",X="N" D ^%DT
 .;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 .S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 .S FDA(90455,"+1,",1)="D"     ; EVENT TYPE - Delete
 .S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 .S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 .S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 .S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 .D UPDATE^DIE("","FDA","")
 .K FDA
 ;
 ; If pre-edit and post-edit node 0 differ, consider it a Change
 I BKMV("PRE",0)'=BKMV("POST",0) D
 .; Set the data via FileMan API
 .S BKMED=1
 .F BKMI=1:1:12 I $P(BKMV("PRE",0),U,BKMI)'=$P(BKMV("POST",0),U,BKMI) D
 ..K FDA
 ..;S %DT="ST",X="N" D ^%DT
 ..;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 ..S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 ..S FDA(90455,"+1,",1)="C"     ; EVENT TYPE - Change
 ..S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 ..S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 ..S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 ..S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 ..S FDA(90455,"+1,",3)=$S(BKMI=1:".01",BKMI=2:".015",BKMI=3:".02",BKMI=4:".025",BKMI=5:".03",BKMI=6:".035",BKMI=7:".5",BKMI=8:".55",BKMI=9:".75",BKMI=10:".8",BKMI=11:"2",BKMI=12:"2.5",1:"") ; EVENT FIELD
 ..S FDA(90455,"+1,",4)=$P(BKMV("PRE",0),U,BKMI)    ; OLD VALUE
 ..S FDA(90455,"+1,",4.5)=$P(BKMV("POST",0),U,BKMI) ; NEW VALUE
 ..D UPDATE^DIE("","FDA","","BKMERR")
 .K FDA
 ;
 ; If pre-edit and post-edit node 2 differ, consider it a Change
 I BKMV("PRE",2)'=BKMV("POST",2) D
 .; Set the data via FileMan API
 .S BKMED=1
 .; PRXM/BHS - 04/04/2006 - Added check of pieces 12 - 17
 .F BKMI=1:1:17 I $P(BKMV("PRE",2),U,BKMI)'=$P(BKMV("POST",2),U,BKMI) D
 ..K FDA
 ..;S %DT="ST",X="N" D ^%DT
 ..;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 ..S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 ..S FDA(90455,"+1,",1)="C"     ; EVENT TYPE - Change
 ..S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 ..S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 ..S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 ..S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 ..I BKMI<11 S FDA(90455,"+1,",3)=$S(BKMI=1:"3",BKMI=2:"3.5",BKMI=3:"3.55",BKMI=4:"4",BKMI=5:"4.2",BKMI=6:"4.3",BKMI=7:"5",BKMI=8:"5.5",BKMI=9:"4.5",BKMI=10:"4.52",1:"") ; EVENT FIELD
 ..I BKMI>10 S FDA(90455,"+1,",3)=$S(BKMI=11:"4.53",BKMI=12:"4.1",BKMI=13:"4.51",BKMI=14:"4.4",BKMI=15:"4.41",BKMI=16:"4.54",BKMI=17:"4.541",1:"") ; EVENT FIELD
 ..S FDA(90455,"+1,",4)=$P(BKMV("PRE",2),U,BKMI)    ; OLD VALUE
 ..S FDA(90455,"+1,",4.5)=$P(BKMV("POST",2),U,BKMI) ; NEW VALUE
 ..D UPDATE^DIE("","FDA","")
 .K FDA
 ;
 ; If pre-edit and post-edit node 3 differ, consider it a Change
 I BKMV("PRE",3)'=BKMV("POST",3) D
 .; Update edited flag to 1
 .S BKMED=1
 .; Set the data via FileMan API
 .F BKMI=1:1:5,7 I $P(BKMV("PRE",3),U,BKMI)'=$P(BKMV("POST",3),U,BKMI) D
 ..K FDA
 ..;S %DT="ST",X="N" D ^%DT
 ..;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 ..S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 ..S FDA(90455,"+1,",1)="C"     ; EVENT TYPE - Change
 ..S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 ..S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 ..S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 ..S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 ..S FDA(90455,"+1,",3)=$S(BKMI=1:"6",BKMI=2:"6.5",BKMI=3:"7",BKMI=4:"7.51",BKMI=5:"11",BKMI=7:"2.3",1:"") ; EVENT FIELD
 ..S FDA(90455,"+1,",4)=$P(BKMV("PRE",3),U,BKMI)    ; OLD VALUE
 ..S FDA(90455,"+1,",4.5)=$P(BKMV("POST",3),U,BKMI) ; NEW VALUE
 ..D UPDATE^DIE("","FDA","")
 .K FDA
 ;
 ; PRXM/BHS - 04/04/2006 - Added for new node
 ; If pre-edit and post-edit node 5 differ, consider it a Change
 I BKMV("PRE",5)'=BKMV("POST",5) D
 .; Update edited flag to 1
 .S BKMED=1
 .; Set the data via FileMan API
 .F BKMI=1:1:4 I $P(BKMV("PRE",5),U,BKMI)'=$P(BKMV("POST",5),U,BKMI) D
 ..K FDA
 ..;S %DT="ST",X="N" D ^%DT
 ..;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 ..S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 ..S FDA(90455,"+1,",1)="C"     ; EVENT TYPE - Change
 ..S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 ..S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 ..S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 ..S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 ..S FDA(90455,"+1,",3)=$S(BKMI=1:"35",BKMI=2:"7.5",BKMI=3:"2.7",BKMI=4:"1",1:"") ; EVENT FIELD
 ..S FDA(90455,"+1,",4)=$P(BKMV("PRE",5),U,BKMI)                   ; OLD VALUE
 ..S FDA(90455,"+1,",4.5)=$P(BKMV("POST",5),U,BKMI)                  ; NEW VALUE
 ..D UPDATE^DIE("","FDA","")
 .K FDA
 ;
 ; If pre-edit and post-edit node 6 differ, consider it a Change
 I BKMV("PRE",6)'=BKMV("POST",6) D
 .; Update edited flag to 1
 .S BKMED=1
 .; Set the data via FileMan API
 .F BKMI=3:1:5 I $P(BKMV("PRE",6),U,BKMI)'=$P(BKMV("POST",6),U,BKMI) D
 ..K FDA
 ..;S %DT="ST",X="N" D ^%DT
 ..;S FDA(90455,"+1,",.01)=Y     ; DATE/TIME
 ..S FDA(90455,"+1,",.01)=$$NOW^XLFDT()     ; DATE/TIME
 ..S FDA(90455,"+1,",1)="C"     ; EVENT TYPE - Change
 ..S FDA(90455,"+1,",2)=BKMIEN  ; EVENT IEN (File 90451)
 ..S FDA(90455,"+1,",5)=DUZ     ; EVENT USER (File 200)
 ..S FDA(90455,"+1,",6)=BKMREG  ; REGISTER
 ..S FDA(90455,"+1,",8)=$$GET1^DIQ(90451,BKMIEN_",",.01,"I") ; PATIENT
 ..S FDA(90455,"+1,",3)=$S(BKMI=3:"15",BKMI=4:"16",BKMI=5:"17",1:"") ; EVENT FIELD
 ..S FDA(90455,"+1,",4)=$P(BKMV("PRE",6),U,BKMI)                   ; OLD VALUE
 ..S FDA(90455,"+1,",4.5)=$P(BKMV("POST",6),U,BKMI)                  ; NEW VALUE
 ..D UPDATE^DIE("","FDA","")
 .K FDA
 ;
 ;
XIT ; KILL LOCALS AND EXIT
 ; Need to determine if/when to update 90451 date/time last edit
 D:$G(BKMED)=1 EN^BKMED
 Q
 ;
 ;
