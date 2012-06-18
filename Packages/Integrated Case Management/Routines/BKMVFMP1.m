BKMVFMP1 ;PRXM/HC/ALA - Manually populate registry ; 19 Aug 2005  12:47 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 Q
EN ;EP - Prompt user for Patient
 NEW DIR,DFN,ADD,REGISTER,DEC,PATIENT,STATUS,OPTPAR,OPTS,OPTA,YN,STOP
 S REGISTER=$$HIVIEN^BKMIXX3()
 I REGISTER="" D EN^DDIOL("There is no HMS register defined.") H 2 Q
 ;
 ; The following line no longer applies
 ;I '$D(^BKM(90450,REGISTER,11,"B",DUZ)) D EN^DDIOL("You are not a valid HMS user.") H 2 Q
 ;
DEC ; Include deceased patients?
 S DIR(0)="Y"
 S DIR("A")="Do you want to include deceased patients"
 D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT) Q
 S DEC=Y
 D EN^DDIOL(" ")
 ;
 ;Initialize the diagnosis category taxonomies
 D ITAX^BKMVA1U
 ;
PAT ; Get patient
 S MADD=0
 D PLK^BKMPLKP
 I $G(DFN)=-1!($G(DFN)="") G EXIT
 I $G(AUPNDOD)'="",'DEC D EN^DDIOL("Patient is deceased and won't be added to the registry") H 2 Q
 S ENTRY=$$HIVIEN^BKMIXX3()
 ; PRX/DLS 4/3/2006 If patient is already in the registry, return to 'Select Patient' prompt
 ;                  instead of returning to previous menu.
 I $$BKMIEN^BKMIXX3(DFN)'="" D EN^DDIOL(PTNAME_": is already in the register.") H 2 W # G PAT Q
 ;
ACT ; Take action on selected patient
 K DIR
 S DIR(0)="SO^A:Add to Register;R:Review Health Summary"_$S($O(^BKM(90451.2,"B",DFN,""))'="":";C:Review Candidate Entry and Add to Register",1:"")
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!(Y="") G PAT
 ;
 I Y="R" D RHS G ACT
 ;
 I Y="C" D CFL G ACT:STOP
 ;
BEG ;  Begin the prompts
 S BKMHIV=$$HIVIEN^BKMIXX3(),BKMOK=0
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN) S:BKMIEN'="" BKMOK=1
 I BKMIEN="" S BKMOK=$$ACC^BKMVCD(DFN,"A")
 I 'BKMOK D EN^DDIOL("Patient not added to the registry.") G PAT
 ;PRXM/HC/BHS - 12/02/2005 - Moved remove candidate logic up in case user does not choose to add register data
 ; If added without going through Accept Candidate option, remove from
 ; Candidate file
 I $O(^BKM(90451.2,"B",DFN,""))'="" D
 . S DA=$O(^BKM(90451.2,"B",DFN,"")),DIK="^BKM(90451.2,"
 . D ^DIK
 . K DA,DIK
 ;  MADD will equal 1 if user answered "no" in BKMVCD program
 I MADD G PAT
 D EN^DDIOL(" ")
 S DIR(0)="Y"
 S DIR("A")="Continue to enter registry data",DIR("B")="YES"
 D ^DIR K DIR
 ; PRX/DLS 3/30/06 Added line indicating that patient has been added to Registry
 ; as 'Active' when answering 'no' to 'Continue' prompt.
 I $D(DTOUT)!$D(DUOUT)!'Y D  G PAT
 . W !!,"Patient has been added to the register with 'Active' Register Status.",!
 I BKMOK S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" D EN^DDIOL("There is no HMS registry entry for this patient.") H 1 Q
 ;
 ; Pre-edit audit capture
 D EN^BKMVAUD
 ;
 D EN^DDIOL("Please wait, calculating default diagnosis category and initial dates.")
 ; PRX/DLS 4/17/06 Replacing call to AIDS^BKMVFAP1 with REGDC^BKMVA1C
 ;D AIDS^BKMVFAP1(DFN)
 D REGDC^BKMVA1C(DFN)
 D PROMPTS^BKMVA1B(DFN)
 ;
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 ;PRXM/HC/BHS - 12/02/2005 - Removed IF condition since IF condition on BKMREG should suffice
 ;I BKMIEN="" I BKMIEN="" W !!,"The patient has been added to the register." H 2 Q
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 I BKMREG="" W !,"There is no HMS registry entry for this patient." H 1 Q
 ; Post-edit audit capture
 D POST^BKMVAUD
 ;PRXM/HC/BHS - 12/02/2005 - Moved remove candidate logic up in case user does not choose to add register data
 ; If added without going through Accept Candidate option, remove from
 ; Candidate file
 ;I $O(^BKM(90451.2,"B",DFN,""))'="" D
 ;. S DA=$O(^BKM(90451.2,"B",DFN,"")),DIK="^BKM(90451.2,"
 ;. D ^DIK
 ;. K DA,DIK
 W !,"The patient has been added to the register.",! H 2 W @IOF
 ;I $$BASETMP^BKMIXX3(DFN) D EN^VALM("BKMV R/E PATIENT RECORD",)
 G PAT
 ;
EXIT ;  Exit point
 K DIAGCAT,DIAGSTAT,RIEN,DOB,SEX,AUPNDAYS,AUPNDOB,AUPNSSN,AUPNDOD
 K PTNAME,SSN,AGE,STOP,MADD
 K ^TMP("BKMAIDS",$J),^TMP("BKMHIV",$J),^TMP("BKMCD4",$J),^TMP("BKMTST",$J)
 Q
 ;
RHS ;  Call review Health summary code
 D HS^BKMIHSM(DFN)
 Q
 ;
CFL ;  Call the Review Candidate code
 S STOP=0
 S BKMCIEN=+$$FIND1^DIC(90451.2,"","Q",DFN,"B","","ERROR")
 I 'BKMCIEN Q
 D EN^BKMVCD(BKMCIEN)
 S BKMCIEN=+$$FIND1^DIC(90451.2,"","Q",DFN,"B","","ERROR")
 I BKMCIEN S STOP=1
 K BKMCIEN,ERROR
 Q
