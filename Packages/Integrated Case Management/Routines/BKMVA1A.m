BKMVA1A ;PRXM/HC/BHS - HMS PATIENT REGISTER CONT; [ 7/14/2005 8:56 AM ] ; 14 Jul 2005  8:57 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 ; Prompts and functions related to BKMVA1
 Q
 ; The following functions are for the "Add Patient Data" screen. 
GETPAT() ;EP
 ; This routine extracts some information on patient
 ; Output variables set:
 ; PNT (Patient Name), DOB, AGE, SEX, DFN, BKMRIEN
 ; AUPNDOB, AUPNDOD, AUPNPAT, AUPNSEX
 K DIC,DFN
 D RLK^BKMPLKP("") I $G(DFN)="" Q 0
 K DIC,DA,DD,DR,DINUM,D,DLAYGO,DIADD
 S PNT=PTNAME
 Q 1
EXISTRP(DFN) ;
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) I DA(1)="" Q 0
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,""))
 S GETSIENS=$$IENS^DILF(.DA)
 I $$GET1^DIQ("90451.01",GETSIENS,"6","E")?." " D ^XBFMK Q 0
 D ^XBFMK
 Q 1
GETRP(DFN) ;
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,""))
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,""))
 S DIE="^BKM(90451,"_DA(1)_",1,"
 ;PRXM/HC/DLS 9/20/2005 Added new text requested for provider prompt.
 S DR="6HIV PROVIDER"
 D ^DIE
 Q
EXISTCM(DFN) ;
 N DA1,DA0,GETSIENS
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) I DA(1)="" Q 0
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,""))
 S GETSIENS=$$IENS^DILF(.DA)
 I $$GET1^DIQ("90451.01",GETSIENS,"6.5","E")?." " D ^XBFMK Q 0
 D ^XBFMK
 Q 1
GETCM(DFN) ;
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,""))
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,""))
 S DIE="^BKM(90451,"_DA(1)_",1,"
 ;PRXM/HC/DLS 9/20/2005 Added new text requested for case manager prompt.
 S DR="6.5HIV CASE MANAGER"
 D ^DIE
 Q
EXISTPN(DFN) ;
 N DA1,DA0,GETSIENS
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,""))
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,""))
 S GETSIENS=$$IENS^DILF(.DA)
 I $$GET1^DIQ("90451.01",GETSIENS,"15","E")?." " D ^XBFMK Q 0
 D ^XBFMK
 Q 1
EXISTSN(DFN) ; State Reporting Status
 N DA0,DA1,DA2,SIENS,NSTATUS,HIENS
 D ^XBFMK
 S DA2=$O(^BKM(90451,"B",DFN,""))
 S DA1=$O(^BKM(90451,DA2,1,"B",HIVIEN,""))
 S DA(1)=DA2,DA=DA1
 S HIENS=$$IENS^DILF(.DA)
 ;PRXM/HC/ALA Modified State reporting info 9/22/2005
 ; If State HIV Report required - check State HIV reporting status
 I $$GET1^DIQ(90450,HIVIEN,12.5,"I")=1 D  I NSTATUS="R" Q 0
 . S NSTATUS=$$GET1^DIQ(90451.01,HIENS,"4.3","I")
 . I NSTATUS="" D ^XBFMK Q
 ; If HMS Dx Cat = "AIDS" - check State AIDS reporting status
 I $$GET1^DIQ(90451.01,HIENS,2.3,"I")="A" D  I NSTATUS="R" Q 0
 . S NSTATUS=$$GET1^DIQ(90451.01,HIENS,"4.53","I")
 . I NSTATUS="" D ^XBFMK Q
 ; If State HIV Report required - check State HIV confirmation status
 I $$GET1^DIQ(90450,HIVIEN,12.5,"I")=1 D  I NSTATUS="R" Q 0
 . S NSTATUS=$$GET1^DIQ(90451.01,HIENS,"4.3","I")
 . I NSTATUS="" D ^XBFMK Q
 . S NSTATUS=$$GET1^DIQ(90451.01,HIENS,"4.1","I")
 . D ^XBFMK
 ; If HMS Dx Cat = "AIDS" - check State AIDS confirmation status
 I $$GET1^DIQ(90451.01,HIENS,2.3,"I")="A" D  I NSTATUS="R" Q 0
 . S NSTATUS=$$GET1^DIQ(90451.01,HIENS,"4.53","I")
 . I NSTATUS="" D ^XBFMK Q
 . S NSTATUS=$$GET1^DIQ(90451.01,HIENS,"4.51","I")
 . D ^XBFMK
 Q 1
EXISTNOT(DFN) ;EP
 I '$$EXISTPN(DFN) Q 0
 I '$$EXISTSN(DFN) Q 0
 Q 1
GETNOT(DFN) ;EP - Get notification data.
 D EXEN^BKMVA9
 Q
EXISTETI(DFN) ;
 N BKMIEN,BKMREG,HIVIEN,REGETI
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" Q 0
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" Q 0
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" Q 0
 S REGETI=$$GET1^DIQ(90451.01,BKMREG_","_BKMIEN_",",7,"I")
 I 'REGETI Q 0
 Q 1
GETETI(DFN) ;
 N BKMIEN,BKMREG,HIVIEN,REGETI,BKMV
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" Q
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" Q
 ; Capture Etiology (7)
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 S BKMV("PRE",7)=$$GET1^DIQ(90451.01,BKMIENS,7,"I")
 S DR="7;7.5;"  ;,DA(1)=BKMIEN,DA=BKMREG
 S DIE="^BKM(90451,"_DA(1)_",1,"
 D ^DIE
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 ; Capture Etiology (7)
 S BKMV("POST",7)=$$GET1^DIQ(90451.01,BKMIENS,7,"I")
 ; Compare pre vs. post
 I BKMV("PRE",7)'=BKMV("POST",7) D
 . ; Update Etiology Last Updated (7.51)
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR="7.51////"_$$NOW^XLFDT()_";"
 . D ^DIE
 Q
EXISTRST(DFN,HIVIEN) ; Check for register status
 N DA1,DA0,GETSIENS
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) I DA(1)="" Q 0
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,"")) I DA="" Q 0
 S GETSIENS=$$IENS^DILF(.DA)
 I $$GET1^DIQ("90451.01",GETSIENS,".5","E")?." " D ^XBFMK Q 0
 D ^XBFMK
 Q 1
GETRSTAT(DFN) ;
 N BKMV,BKMIEN,BKMREG,HIVIEN
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" Q
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" Q
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 ; Capture Status (.5)
 S BKMV("PRE",.5)=$$GET1^DIQ(90451.01,BKMIENS,.5,"I")
 S DR=".5Enter patient's REGISTER STATUS~;"
 S DIE="^BKM(90451,"_DA(1)_",1,"
 D ^DIE
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 ; Capture Status (.5)
 S BKMV("POST",.5)=$$GET1^DIQ(90451.01,BKMIENS,.5,"I")
 ; Compare pre vs. post
 I BKMV("PRE",.5)'=BKMV("POST",.5) D
 . ; Update Prior Status (.55)
 . S DIE="^BKM(90451,"_DA(1)_",1,"
 . S DR=".55////"_BKMV("PRE",.5)_";"
 . D ^DIE
 Q
EXISTRSC(DFN,HIVIEN) ; Check for register status comments
 N DA1,DA0,GETSIENS
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) I DA(1)="" Q 0
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,"")) I DA="" Q 0
 S GETSIENS=$$IENS^DILF(.DA)
 ;No longer a W/P field. Replaced with check below.
 ;I $O(^BKM(90451,DA(1),1,DA,1,0))="" D ^XBFMK Q 0
 I $$GET1^DIQ("90451.01",GETSIENS,1,"E")?." " D ^XBFMK Q 0
 D ^XBFMK
 Q 1
GETRSCOM(DFN) ;
 N BKMIEN,BKMREG,HIVIEN
 D ^XBFMK
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" Q
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" Q
 S DR="1;",DA(1)=BKMIEN,DA=BKMREG
 S DIE="^BKM(90451,"_DA(1)_",1,"
 D ^DIE
 D ^XBFMK
 Q
EXISTHDC(DFN,HIVIEN) ; EP - Check for HMS diagnosis category
 N DA1,DA0,GETSIENS
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) I DA(1)="" Q 0
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,"")) I DA="" Q 0
 S GETSIENS=$$IENS^DILF(.DA)
 I $$GET1^DIQ("90451.01",GETSIENS,"2.3","E")?." " D ^XBFMK Q 0
 D ^XBFMK
 Q 1
EXISTIHD(DFN,HIVIEN) ; EP - Check for initial HIV dx date
 N DA1,DA0,GETSIENS,BKMDX
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) I DA(1)="" Q 0
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,"")) I DA="" Q 0
 S GETSIENS=$$IENS^DILF(.DA)
 S BKMDX=$$GET1^DIQ("90451.01",GETSIENS,"2.3","I")
 ; Do not prompt unless HMS Dx Cat is 'HIV' or 'AIDS'
 I BKMDX="H"!(BKMDX="A"),$$GET1^DIQ("90451.01",GETSIENS,"5","E")?." " D ^XBFMK Q 0
 D ^XBFMK
 Q 1
GETIHDDT(DFN) ;
 N BKMIEN,BKMREG,HIVIEN
 D ^XBFMK
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" Q
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" Q
 S DR="5;",DA(1)=BKMIEN,DA=BKMREG
 S DIE="^BKM(90451,"_DA(1)_",1,"
 D ^DIE
 D ^XBFMK
 Q
EXISTIAD(DFN,HIVIEN) ; EP - Check for initial AIDS dx date
 N DA1,DA0,GETSIENS,BKMDX
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) I DA(1)="" Q 0
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,"")) I DA="" Q 0
 S GETSIENS=$$IENS^DILF(.DA)
 S BKMDX=$$GET1^DIQ("90451.01",GETSIENS,"2.3","I")
 ; Do not prompt unless HMS Dx Cat is 'AIDS'
 I BKMDX="A",$$GET1^DIQ("90451.01",GETSIENS,"5.5","E")?." " D ^XBFMK Q 0
 D ^XBFMK
 Q 1
GETIADDT(DFN) ;
 N BKMIEN,BKMREG,HIVIEN
 D ^XBFMK
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" Q
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" Q
 S DR="5.5;",DA(1)=BKMIEN,DA=BKMREG
 S DIE="^BKM(90451,"_DA(1)_",1,"
 D ^DIE
 D ^XBFMK
 Q
EXISTFOL(DFN,HIVIEN) ; Check for where followed
 N DA1,DA0,GETSIENS
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) I DA(1)="" Q 0
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,"")) I DA="" Q 0
 S GETSIENS=$$IENS^DILF(.DA)
 I $$GET1^DIQ("90451.01",GETSIENS,".015","E")?." " D ^XBFMK Q 0
 D ^XBFMK
 Q 1
GETFOL(DFN) ;
 N BKMIEN,BKMREG,HIVIEN,BKMDFLT
 D ^XBFMK
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 S HIVIEN=$$HIVIEN^BKMIXX3()
 I HIVIEN="" Q
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 I BKMIEN="" Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" Q
 ; Get default location based on DUZ(2)
 S BKMDFLT=$$GET1^DIQ(4,DUZ(2),".01","E")
 S DR=".015//"_BKMDFLT_";",DA(1)=BKMIEN,DA=BKMREG
 S DIE="^BKM(90451,"_DA(1)_",1,"
 D ^DIE
 D ^XBFMK
 Q
 ;
EXISTHAP(DFN,HIVIEN) ; EP - Check for HAART Appropriate multiples
 N DA1,DA0,GETSIENS
 D ^XBFMK
 S DA(1)=$O(^BKM(90451,"B",DFN,"")) I DA(1)="" Q 0
 S DA=$O(^BKM(90451,DA(1),1,"B",HIVIEN,"")) I DA="" Q 0
 S GETSIENS=$$IENS^DILF(.DA)
 I $O(^BKM(90451,DA(1),1,DA,40,0))="" D ^XBFMK Q 0
 D ^XBFMK
 Q 1
GETHAP(DFN) ;EP - Get HAART data.
 D EN^BKMVB0
 Q
MSNGDATA(DFN,HIVIEN) ; EP - Check for missing registry data
 I '$$EXISTRST(DFN,HIVIEN) Q 1
 I '$$EXISTHDC(DFN,HIVIEN) Q 1
 I '$$EXISTIHD(DFN,HIVIEN) Q 1
 I '$$EXISTIAD(DFN,HIVIEN) Q 1
 I '$$EXISTFOL(DFN,HIVIEN) Q 1
 I '$$EXISTRP(DFN) Q 1
 I '$$EXISTCM(DFN) Q 1
 I '$$EXISTETI(DFN) Q 1
 I '$$EXISTNOT(DFN) Q 1
 I '$$EXISTHAP(DFN,HIVIEN) Q 1
 Q 0
 ;
TESTEDIT ; Edit patient record via [BKMV PATIENT RECORD]
 ; DO NOT REMOVE
 ; This is not a testing option despite what the tag name indicates.
 ; It is part of the system
 N HIVIEN,BKMIEN,BKMREG,BKMV,BKMIENS,BKMDIAG,OBKMDIAG,BKMCC
 N DIAGCAT,IAIDSDT,HAIDSDT,FOLL
 D ^XBFMK
 ;Prevent jumping to prompt to address clinical classification/diagnosis category dependency
 S DIE("NO^")="OUTOK"
 S BKMDIAG=-1
 D BASETMP^BKMIXX3(DFN)
 S HIVIEN=$$HIVIEN^BKMIXX3()
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 ; Builds BKMV("PRE") array
 ;  Status (.5), Clinical Classification (3), HMS Dx Cat (2.3), etc.
 D GETVALS^BKMVA1B(BKMIENS,"PRE")
 ; If any of the values are not populated, get recommended values for
 ; diagnosis and initial diagnosis dates
 I BKMV("PRE",2.3,"I")=""!(BKMV("PRE",5,"I")="")!(BKMV("PRE",5.5,"I")="") D
 . D LDREC^BKMVA1B(DFN)
 D FULL^VALM1
 K DA
 S DA=BKMIEN,DIE="^BKM(90451,",DR="[BKMV PATIENT RECORD]"
 I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 L +^BKM(90451,BKMIEN):0 I '$T D EN^DDIOL("Another user is editing this entry.") H 2 G TESTEDIX
 D ^DIE
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 K DA
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 ; Builds BKMV("POST") array for select fields:
 ;  Status (.5), Clinical Classification (3), HMS Dx Cat (2.3), etc.
 D GETVALS^BKMVA1B(BKMIENS,"POST")
 ; Populate triggered fields based on changes - includes
 ;  deleting clinical classification and initial dxs if at risk dx category, etc.
 D COMPVALS^BKMVA1B(BKMIENS,"PRE","POST")
 L -^BKM(90451,BKMIEN)
TESTEDIX ; TESTEDIT exit point
 D ^XBFMK
 K ^TMP("BKMVA1",$J)
 I '$$GETALL^BKMVA1(DFN,0) Q
 D INIT^BKMVA2
 Q
 ;
SAVEVF(DFN,VFIEN) ; EP - Save HMS PCC Buffer subfile data
 N DA1
 S DA1=$O(^BKM(90459,"B",$J,""))
 Q:DA1=""
 ; PRXM/BHS - 04/05/2006 - Set CALCREM only if data was actually saved
 I VFIEN=".13",$O(^BKM(90459,DA1,13,"B",""))'="" D  Q
 . ; Save lab
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D LAB^BKMVIST5(DFN,"","PCC") S CALCREM=1
 . D DELLAB^BKMVIST5 ; Delete Lab data
 I VFIEN=".14",$O(^BKM(90459,DA1,14,"B",""))'="" D  Q
 . ; Save meds
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D MED^BKMVIST5(DFN,"","PCC") S CALCREM=1
 . D DELMED^BKMVIST5 ; Delete Med data
 I VFIEN=".12",$O(^BKM(90459,DA1,12,"B",""))'="" D  Q
 . ; Save edu
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D EDUC^BKMVIST4(DFN,"","PCC") S CALCREM=1
 . D DELEDUC^BKMVIST4 ; Delete Edu data
 I VFIEN=".16",$O(^BKM(90459,DA1,16,"B",""))'="" D  Q
 . ; Save elder data
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D ELDER^BKMVIST3(DFN,"","PCC") S CALCREM=1
 . D DELELDER^BKMVIST3 ; Delete Elder data
 I VFIEN=".17",$O(^BKM(90459,DA1,17,"B",""))'="" D  Q
 . ; Save exams
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D XAM^BKMVIST5(DFN,"","PCC") S CALCREM=1
 . D DELXAM^BKMVIST5 ; Delete Exam data
 I VFIEN=".18",$O(^BKM(90459,DA1,18,"B",""))'="" D  Q
 . ; Save health factors
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D HF^BKMVIST4(DFN,"","PCC") S CALCREM=1
 . D DELHF^BKMVIST4 ; Delete HF data
 I VFIEN=".19",$O(^BKM(90459,DA1,19,"B",""))'="" D  Q
 . ; Save measurements
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D MSR^BKMVIST5(DFN,"","PCC") S CALCREM=1
 . D DELMSR^BKMVIST5 ; Delete Measurement data
 I VFIEN=".2",$O(^BKM(90459,DA1,20,"B",""))'="" D  Q
 . ; Save procs
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D PRC^BKMVIST3(DFN,"","PCC") S CALCREM=1
 . D DELPRC^BKMVIST3  ; Delete Procedure data
 I VFIEN=".21",$O(^BKM(90459,DA1,21,"B",""))'="" D  Q
 . ; Save rad
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D RAD^BKMVIST3(DFN,"","PCC") S CALCREM=1
 . D DELRAD^BKMVIST3 ; Delete Radiology data
 I VFIEN=".22",$O(^BKM(90459,DA1,22,"B",""))'="" D  Q
 . ; Save skin tests
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D SKIN^BKMVIST3(DFN,"","PCC") S CALCREM=1
 . D DELSKIN^BKMVIST3 ; Delete Skin Test data
 I VFIEN=".23",$O(^BKM(90459,DA1,23,"B",""))'="" D  Q
 . ; Save immunizations
 . I $$YNP^BKMVA1B("Are you sure you want to permanently SAVE the added entries to PCC","YES") D IMMUN^BKMVIST5(DFN,"","PCC") S CALCREM=1
 . D DELIMMUN^BKMVIST5 ; Delete Immunization data
 Q
 ;
 ;
