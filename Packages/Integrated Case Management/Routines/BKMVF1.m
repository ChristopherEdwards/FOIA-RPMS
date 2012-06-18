BKMVF1 ;PRXM/HC/JGH - Manually Add Patient To Register ; 17 Jul 2005  1:31 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 QUIT
PROMPT ;Prompt user for Patient
 NEW DFN,ADD,REGISTER,PATIENT,STATUS,OPTPAR,OPTS,OPTA,YN
 S REGISTER=$$HIVIEN^BKMIXX3()
 I REGISTER="" D EN^DDIOL("There is no HMS register defined.") H 2 Q
 ;
 ; The following line no longer applies
 ;I '$D(^BKM(90450,REGISTER,11,"B",DUZ)) D EN^DDIOL("You are not a valid HMS user.") H 2 Q
 ;
 F  Q:'$$GETPAT(.DFN)  D
 . S ENTRY=$O(^BKM(90451,"B",DFN,""))
 . I ENTRY'="",$D(^BKM(90451,"D",REGISTER,ENTRY)) W !!,PNT,": is already in the register.",!! Q
 . S STATUS="R"
 . I $$GETOCCUP(DUZ)="M" S STATUS=$$STATUS  ; Only File Managers are able to change the status.
 . I STATUS="^"!(STATUS="") W !!,"The patient wasn't added to the register." Q
 . S DIAGCAT=$$DIAG^BKMIXX3() I DIAGCAT=-1 S DIAGCAT="^"
 . I DIAGCAT="^"!(DIAGCAT="") W !!,"The patient wasn't added to the register." Q
 . S DIAGSTAT=""
 . I DIAGCAT="H"!(DIAGCAT="A") S DIAGSTAT=$$CLINCLAS I DIAGSTAT="^"!(DIAGSTAT="") W !!,"The patient wasn't added to the register." Q
 . S OPTA="Add the selected patient to the HMS register",OPTS=""
 . S OPTPAR="Y"
 . S YN=$$PROMPT2^BKMIXX4(OPTPAR,.OPTS,OPTA) I YN<1!(YN["^") W !!,"The patient wasn't added to the register." Q
 . D ADD(DFN,STATUS)
 . I $$BASETMP^BKMIXX3(DFN) D EN^VALM("BKMV R/E PATIENT RECORD",)
 . W @IOF,"The patient has been added to the register.",!! H 2
 K DIAGCAT,DIAGSTAT
 QUIT
ADD(DFN,STATUS) ; add the patient to the register with status of "R" (unreviewed)
 NEW BKMIEN,BKMREG
 D ^XBFMK ; Kills off a lot of Fileman variables
 S BKMIEN=$O(^BKM(90451,"B",DFN,""))  ; BKMIEN and BKMREG are used by the routine BKMVAUD
 I BKMIEN="" D ADDENT(DFN) S BKMIEN=$O(^BKM(90451,"B",DFN,""))  ; Create entry in ICare registry for patient.
 I BKMIEN="" W !,"Error, An entry for "_ADD(DFN)_" wasn't created in HMS." Q   ; end audit log
 S BKMREG=$O(^BKM(90451,BKMIEN,1,"B",REGISTER,""))
 I BKMREG="" D ADDTOREG(REGISTER,BKMIEN) S BKMREG=$O(^BKM(90451,BKMIEN,1,"B",REGISTER,""))
 I BKMREG="" W !,"Error, An entry for "_ADD(DFN)_" wasn't created in HMS." Q   ; end audit log
 ;
 ; Enter audit entry for the NEW record
 D NEW^BKMVAUDN(BKMIEN,BKMREG,DUZ)
 ;
 D EN^BKMVAUD ; Start audit log
 D ADDCRBY(REGISTER,BKMIEN,DUZ),ADDCRDT(REGISTER,BKMIEN,DT)
 D ADDSTAT(REGISTER,BKMIEN,STATUS),ADDSTDT(REGISTER,BKMIEN,DT)
 I $G(DIAGCAT)'="" D ADDCAT(REGISTER,BKMIEN,DIAGCAT)
 I $G(DIAGSTAT)'="" D ADDCLASS(REGISTER,BKMIEN,DIAGSTAT),ADDCLADT(REGISTER,BKMIEN,DT)
 D POST^BKMVAUD   ; End audit log
 ;
 I $G(BKMIEN)=""!($G(BKMREG)="") W !,"Error, A patient ID for "_ADD(DFN)_" wasn't created in HMS." Q
 ;PRXM/HC/BHS - Removed 8/31/2005 per client request Bug #971
 ;S DA=BKMIEN
 ;D ID^BKMILK   ; Create patient ID and assign to patient.
 ; I ($P(Y,U,1)'?1.N)!'$P(Y,U,3) W !,Patient ",DFN," not added."
 D ^XBFMK ; Kills off a lot of Fileman variables
 QUIT
ADDENT(X) ; add the entry
 S DIC(0)="L",DIC("DR")=".01////"
 S DIC="^BKM(90451,",DLAYGO=90451
 D FILE^DICN
 K DIFILE,DIC,DLAYGO
 QUIT
 ;
 ; Add the new patient entry to the HIV register.
ADDTOREG(REGISTER,ENTRY) ;
 NEW DIC,X,DA,DLAYGO
 S DIC("DR")=".01////",X=REGISTER,DIC(0)="L"
 S DA(1)=ENTRY,DIC="^BKM(90451,"_ENTRY_",1,"
 S DLAYGO=90451.1
 D FILE^DICN
 QUIT
ADDCRBY(REGISTER,ENTRY,CRBYUSER) ;
 NEW DIC,DR,DIE,DA
 S DA=$O(^BKM(90451,ENTRY,1,"B",REGISTER,""))
 Q:DA=""
 S DR=".025////"_CRBYUSER
 S DA(1)=ENTRY
 S DIE="^BKM(90451,"_ENTRY_",1,"
 D ^DIE
 QUIT
ADDCRDT(REGISTER,ENTRY,DT) ;
 NEW DIC,DR,DIE,DA
 S DA(1)=ENTRY
 S DA=$O(^BKM(90451,ENTRY,1,"B",REGISTER,""))
 Q:DA=""
 S DR=".02////"_DT
 S DA(1)=ENTRY
 S DIE="^BKM(90451,"_ENTRY_",1,"
 D ^DIE
 QUIT
ADDSTAT(REGISTER,ENTRY,STAT) ;
 NEW DIC,DR,DIE,DA
 S DA=$O(^BKM(90451,ENTRY,1,"B",REGISTER,""))
 Q:DA=""
 S DR=".5////"_STAT
 S DA(1)=ENTRY
 S DIE="^BKM(90451,"_ENTRY_",1,"
 D ^DIE
 QUIT
ADDSTDT(REGISTER,ENTRY,DT) ;
 NEW DIC,DR,DIE,DLAYGO,DA
 S DA=$O(^BKM(90451,ENTRY,1,"B",REGISTER,""))
 Q:DA=""
 S DR=".75////"_DT
 S DA(1)=ENTRY
 S DIE="^BKM(90451,"_ENTRY_",1,"
 D ^DIE
 QUIT
GETPAT(DFN) ;
 K DIC,DTOUT,DUOUT,X,Y,DOB,AGE,PNT,IEN
 S DIC=9000001    ; S DIC=90451
 S DIC(0)="AEMQZ"
 K DTOUT,DUOUT
 D ^DIC
 I $D(DTOUT)!$D(DUOUT)!$G(Y)<1 Q 0
 K DIC,DA,DD,DR,DINUM,D,DLAYGO,DIADD
 S DFN=$P(Y,"^",2),IEN=+Y,PNT=$G(Y(0,0))
 I DFN="" Q 0
 S BKMIEN=$O(^BKM(90451,"B",DFN,""))
 S BKMREG="" S:BKMIEN'="" BKMREG=$O(^BKM(90451,BKMIEN,1,"B",1,""))
 QUIT 1
STATUS() ;STATUS
 S DIR(0)="S^"_$P($G(^DD(90451.01,.5,0)),U,3)
 S DIR("A")=$P($G(^DD(90451.01,.5,0)),U,1)
 D ^DIR
 K DIR
 QUIT $G(Y)
GETOCCUP(DUZ) ;GETOCCUP
 N OCCUP,IENS
 Q:$G(DUZ)="" ""
 S DA(1)=REGISTER
 S DA=$O(^BKM(90450,REGISTER,11,"B",DUZ,""))
 Q:DA="" ""
 S IENS=$$IENS^DILF(.DA)
 S OCCUP=$$GET1^DIQ(90450.011,IENS,.5,"I")
 K DA
 QUIT OCCUP
DIAGCAT() ;^DD(90451.01,2.3,0)=
 ;         MHS DIAGNOSIS CATEGORY^S^R:AT RISK;H:HIV;A:AIDS;EK:
 ;         EXPOSED SOURCE KNOWN;EI:INFANT EXPOSED;EO:OCCUPATIONAL EXPOSURE;EN:
 ;         NONOCCUPATIONAL EXPOSURE;EU:EXPOSED SOURCE UNKNOWN;^3;7^Q
 ;         3)=Enter one of the 8 diagnosis categories for this patient
 S DIR(0)="S^"_$P($G(^DD(90451.01,2.3,0)),U,3)
 S DIR("A")=$P($G(^DD(90451.01,2.3,0)),U,1)
 D ^DIR
 K DIR
 QUIT $G(Y)
CLINCLAS()  ; Clinical Classification
 K DIC,DTOUT,DUOUT,X,Y
 S DIC=90451.7   ; S DIC=90451
 S DIC(0)="AEMQZ"
 D ^DIC
 I $D(DTOUT)!$D(DUOUT)!$G(Y)<1 Q ""
 K DIC
 QUIT $G(Y)
ADDCAT(REGISTER,ENTRY,CAT) ;
 NEW DIC,DR,DIE,DLAYGO,DA
 S DA=$O(^BKM(90451,ENTRY,1,"B",REGISTER,""))
 Q:DA=""
 S DR="2.3////"_CAT
 S DA(1)=ENTRY
 S DIE="^BKM(90451,"_ENTRY_",1,"
 D ^DIE
 QUIT
ADDCLASS(REGISTER,ENTRY,CLASS) ;
 NEW DIC,DR,DIE,DLAYGO,DA
 S DA=$O(^BKM(90451,ENTRY,1,"B",REGISTER,""))
 Q:DA=""
 S DR="3////"_CLASS
 S DA(1)=ENTRY
 S DIE="^BKM(90451,"_ENTRY_",1,"
 D ^DIE
 QUIT
ADDCLADT(REGISTER,ENTRY,CDATE) ;
 NEW DIC,DR,DIE,DLAYGO,DA
 S DA=$O(^BKM(90451,ENTRY,1,"B",REGISTER,""))
 Q:DA=""
 S DR="3.5////"_CDATE
 S DA(1)=ENTRY
 S DIE="^BKM(90451,"_ENTRY_",1,"
 D ^DIE
 QUIT
