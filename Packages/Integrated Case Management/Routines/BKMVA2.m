BKMVA2 ;PRXM/HC/JGH - HMS PATIENT REGISTER; [ 1/19/2005 7:16 PM ] ; 20 Sep 2005  9:27 AM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
INIT ; EP - Review/Edit Patient Record
 N TEXT,DFN,BKMLOCAL,PNT,HRN,DFN,AGE,SEX,ADDRESS,HMPHONE,WKPHONE,DOB,RES
 N STAT,DGCT,INITHIV,INITAIDS,LASTVIST,NEXTVIST,RID,CLCL,OPIA,ALLERGY,BKMDOD
 N REM,ACRF,HIVCMGR,EDDT,PCPROV,HIVPROV,CRDT ;,CLDT
 S VALMCNT=0,VALMAR="^TMP(""BKMVA1"","_$J_")",VALM0=""
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT," ")
 ;
 S DFN=^TMP("BKMLKP",$J),BKMLOCAL=^TMP("BKMLKP",$J,DFN),PNT=$P(BKMLOCAL,U,1),HRN=$P(BKMLOCAL,U,2)
 S DOB=$$FMTE^XLFDT($P(BKMLOCAL,U,3),1)
 S AGE=$P($G(BKMLOCAL),U,5),SEX=$P($G(BKMLOCAL),U,4)
 ; The variable RCRDHDR is used in sub-screens as the header.
 S RCRDHDR=$$PAD^BKMIXX4("Patient: ",">"," ",16)_$$PAD^BKMIXX4(PNT,">"," ",34)_$$PAD^BKMIXX4("HRN: ",">"," ",16)_$$PAD^BKMIXX4(HRN,">"," ",34)
 ;
 D GETALL(DFN,0)
 S TEXT=$$PAD^BKMIXX4("HRN: ",">"," ",16)_$$PAD^BKMIXX4(HRN,">"," ",34)
 I $G(BKMDOD)'="" S TEXT=TEXT_$$PAD^BKMIXX4(" DOD: ",">"," ",7)_$$PAD^BKMIXX4($$FMTE^XLFDT($G(BKMDOD)\1),">"," ",23)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4("Patient: ",">"," ",16)_$$PAD^BKMIXX4(PNT,">"," ",34)_$$PAD^BKMIXX4(" Age: ",">"," ",7)_$$PAD^BKMIXX4(AGE,">"," ",7)_" Gender: "_$$PAD^BKMIXX4(SEX,">"," ",7)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4("Address: ",">"," ",16)_$$PAD^BKMIXX4(ADDRESS,">"," ",64)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4("Home Phone: ",">"," ",16)_$$PAD^BKMIXX4(HMPHONE,">"," ",34)_$$PAD^BKMIXX4(" DOB: ",">"," ",7)_$$PAD^BKMIXX4(DOB,">"," ",23)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4("Work Phone: ",">"," ",16)_$$PAD^BKMIXX4(WKPHONE,">"," ",34)_$$PAD^BKMIXX4(" Comm: ",">"," ",7)_$$PAD^BKMIXX4(RES,">"," ",23)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 ;
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT," ")
 ;
 S TEXT=$$PAD^BKMIXX4("Register Status: ",">"," ",17)_$$PAD^BKMIXX4(STAT,">"," ",18)  ;_$$PAD^BKMIXX4(" Register ID: ",">"," ",18)_$$PAD^BKMIXX4(RID,">"," ",27)
 ;Register ID Removed by client request 
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4("Current DX: ",">"," ",17)_$$PAD^BKMIXX4(DGCT,">"," ",18)_$$PAD^BKMIXX4(" Clinical Class: ",">"," ",18)_$$PAD^BKMIXX4(CLCL,">"," ",27)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4("Initial HIV DX: ",">"," ",17)_$$PAD^BKMIXX4(INITHIV,">"," ",18)_$$PAD^BKMIXX4(" Initial AIDS DX: ",">"," ",18)_$$PAD^BKMIXX4(INITAIDS,">"," ",27)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4("Last Visit: ",">"," ",17)_$$PAD^BKMIXX4(LASTVIST,">"," ",18)_$$PAD^BKMIXX4(" Next Visit: ",">"," ",18)_$$PAD^BKMIXX4(NEXTVIST,">"," ",27)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 ;
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT," ")
 ;
 ;PRXM/HC/DLS 9/20/2005 Removed 'Care' from 'HIV Care Provider'.
 S TEXT=$$PAD^BKMIXX4("HIV Provider: ",">"," ",19)_$$PAD^BKMIXX4(HIVPROV,">"," ",16)_$$PAD^BKMIXX4(" HIV Case Manager: ",">"," ",21)_$$PAD^BKMIXX4(HIVCMGR,">"," ",26)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4("Designated Primary Care Provider: ",">"," ",34)_$$PAD^BKMIXX4(PCPROV,">"," ",46)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4("Record Created: ",">"," ",19)_$$PAD^BKMIXX4(CRDT,">"," ",16)_$$PAD^BKMIXX4(" Record Last Edited: ",">"," ",21)_$$PAD^BKMIXX4(EDDT,">"," ",16)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 ;
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT," ")
 ;
 S TEXT=$$PAD^BKMIXX4(OPIA,">"," ",80)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT="Allergies: "_$$PAD^BKMIXX4($S(ALLERGY:"Known",1:"Unknown"),">"," ",80)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S REM=$G(^TMP("BKMVA2R",$J,DFN,"REM"))
 S TEXT=$$PAD^BKMIXX4(REM,">"," ",80)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 S TEXT=$$PAD^BKMIXX4(ACRF,">"," ",80)
 S VALMCNT=$$I^BKMIXX3($G(VALMCNT),) D SET^VALM10(VALMCNT,TEXT)
 Q
 ;
 ; ******************************************************************************
 ; The following are the "Add Patient Data" Screen labels.
ADDDATA(DFN) ;EP - Add Patient Data
 S HIVIEN=$$HIVIEN^BKMIXX3()
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 ;PRXM/HC/BHS - 12/29/2005 - Removed security check here - enforced within each option
 ;I '$$BKMPRIV^BKMIXX3(DUZ) D NOGO^BKMIXX3 Q
 N EXIT,ENTER,RCRDHDR,BKMDOD
 ; create scratch area record in file 90459
 D NSCRATCH
 D ^XBFMK
 S EXIT=0
 F  D  Q:EXIT
 . D CLEAR^VALM1
 . D FULL^VALM1
 . S RCRDHDR=$$PAD^BKMIXX4(" Patient: ",">"," ",10)_$$PAD^BKMIXX4($$GET1^DIQ(2,DFN,".01","E"),">"," ",30)_$$PAD^BKMIXX4(" HRN: ",">"," ",6)_$$PAD^BKMIXX4($$HRN^BKMVA1(DFN),">"," ",9)
 . S BKMDOD=$$GET1^DIQ(2,DFN,".351","I")
 . I BKMDOD'="" S RCRDHDR=RCRDHDR_$$PAD^BKMIXX4(" DOD: ",">"," ",6)_$$PAD^BKMIXX4($$FMTE^XLFDT(BKMDOD,1),">"," ",15)
 . W !,RCRDHDR
 . K DIR
 . ;PRXM/HC/BHS - 05/08/2006 - Removed 'Add ' from descriptions per IHS
 . S DIR(0)="SO^1:Exams;2:Health Factors;3:Immunizations;4:Lab Tests;5:Medications;6:Measurements;7:Patient Education;8:Procedures;9:Radiology;10:Skin Tests"
 . S DIR("A")="Select Action"
 . D ^DIR
 . I Y?1."^"!(Y?." ")!(Y'>0) S EXIT=1 Q
 . ;PRXM/HC/DLS 9/20/2005 Care option under 'Add Patient Data'
 . ; removed at the request of the client.
 . ;I Y=1 D FREVEDIT^BKMVA1("EN^BKMVD1","EN^BKMVD11",".16") Q  ; Elder Care
 . I Y=1 D FREVEDIT^BKMVA1("EN^BKMVD2","EN^BKMVD21",".17") Q  ; Exams
 . I Y=2 D FREVEDIT^BKMVA1("EN^BKMVD3","EN^BKMVD31",".18") Q  ; Health Factors
 . I Y=3 D FREVEDIT^BKMVA1("EN^BKMVD8","EN^BKMVD81",".23") Q  ; Immunizations
 . I Y=4 D FREVEDIT^BKMVA1("EN^BKMVA4","EN^BKMVA41",".13") Q  ; Lab Tests
 . I Y=5 D FREVEDIT^BKMVA1("EN^BKMVA5","EN^BKMVA51",".14") Q  ; Medications 
 . I Y=6 D FREVEDIT^BKMVA1("EN^BKMVD4","EN^BKMVD41",".19") Q  ; Measurements
 . I Y=7 D FREVEDIT^BKMVA1("EN^BKMVA6","EN^BKMVA61",".12") Q  ; Patient Education
 . I Y=8 D FREVEDIT^BKMVA1("EN^BKMVD5","EN^BKMVD51",".2") Q  ; Procedures 
 . I Y=9 D FREVEDIT^BKMVA1("EN^BKMVD6","EN^BKMVD61",".21") Q   ; Radiology
 . I Y=10 D FREVEDIT^BKMVA1("EN^BKMVD7","EN^BKMVD71",".22") Q   ; Skin Tests
 . W !,"Invalid Input" S EXIT=$$PAUSE^BKMIXX3
 D ^XBFMK
 ; delete scratch area record in file 90459
 D DSCRATCH
 K ^TMP("BKMVA1",$J)
 ; Set up listman display variables and build listman display array
 I '$$GETALL^BKMVA1(DFN) Q
 D INIT
 Q
NSCRATCH ;
 D ^XBFMK
 I $D(^BKM(90459,"B",$J)) D DSCRATCH
 K DINUM,DA N DIFILE
 S X=$J
 S DIC(0)="E",DIC("DR")=".02////"_DFN
 S (DIFILE,DIC)="^BKM(90459,",DLAYGO=90459
 D FILE^DICN
 D ^XBFMK
 Q
DSCRATCH ;
 D ^XBFMK
 S DA=$O(^BKM(90459,"B",$J,""))
 I DA="" Q
 S DIK="^BKM(90459,"
 D ^DIK
 D ^XBFMK
 Q
GETALL(DFN,CALCREM) ;EP
 ;
 ; The following routine gathers all of the data required by the label INIT.
 ; The variable DFN is the patients DFN in file 2 or 9000001.
 ; The variable CALCREM, isn't required, but indicates that the reminders should be
 ; recalculated.
 N HIVIEN,BKMIEN,BKMREG,ADD1,CITY,STATE,ZIP,LCSZ,BKMCLCL,SCHEDULE,LASTVSTI,NEXTVSTI
 N ICD9S,BKMIENS,EDIEN,DGCTI,RVSTDT
 ; PRX/DLS 3/30/06 -Removed NEW of REMLIST
 ; N REMLIST
 K ^TMP("BKMLKP",$J)
 D BASETMP^BKMIXX3(DFN)
 S CALCREM=$G(CALCREM)
 S BKMIEN=$$BKMIEN^BKMIXX3(DFN)
 Q:BKMIEN="" 0 ; There is no HIV register
 S HIVIEN=$$HIVIEN^BKMIXX3()
 Q:HIVIEN="" 0 ; There is no HMS register defined
 S BKMREG=$$BKMREG^BKMIXX3(BKMIEN)
 Q:BKMREG="" 0 ; This patient is not on the HIV register.
 S DA(1)=BKMIEN,DA=BKMREG
 S BKMIENS=$$IENS^DILF(.DA)
 I BKMIENS="" Q 0
 ;S RID=$$GET1^DIQ("90451",BKMIEN_",",".05","E") ;;COMMENTED OUT DUE TO CLIENT REQUEST FOR REMOVAL
 ; DAOU/BHS - 08/03/2005 - Reset HRN because existing HRN="" caused <SUBSCRIPT> error
 ;I '$D(^AUPNPAT("D",$G(HRN,0),DFN)) S HRN=$$HRN^BKMVA1(DFN) ; ^AUPNPAT("D",HRN,DFN,#)
 S HRN=$$HRN^BKMVA1(DFN)
 ; Date of death
 S BKMDOD=$$GET1^DIQ(2,DFN,".351","I")
 ; 
 S ADD1=$$ADDRESS^BKMVA1(DFN)
 S CITY=$P(ADD1,U,4)
 S STATE=$P(ADD1,U,5)
 S ZIP=$P(ADD1,U,6)
 S LCSZ=$L(CITY)+$L(STATE)+$L(ZIP)
 S ADDRESS=$S(LCSZ'<77:"",1:$E($P(ADD1,U,1),1,80-LCSZ))
 S ADDRESS=$E($P(ADD1,U,1),1,80-($L(CITY)+$L(STATE)+$L(ZIP)))_","_CITY_","_STATE_","_ZIP
 ; PRX/DLS 4/11/06 ; If there is no address info, suppress the commas. Otherwise, display them.
 I ADDRESS=",,," S ADDRESS=""
 S HMPHONE=$$PHONE^BKMVA1(DFN,1)
 S WKPHONE=$$PHONE^BKMVA1(DFN,2)
 ;
 S RES=$$RES^BKMVA1(DFN)
 ;
 ;S CRDT=$P($G(^BKM(90451,BKMIEN,1,BKMREG,0)),U,3)
 S CRDT=$$GET1^DIQ(90451.01,BKMIENS,".02","I")
 S CRDT=$S(CRDT="":"",1:$$FMTE^XLFDT(CRDT\1,1))
 S EDIEN=$O(^BKM(90451,BKMIEN,1,BKMREG,9,""),-1)
 S EDDT=$S(EDIEN="":"",1:$$GET1^DIQ(90451.05,EDIEN_","_BKMIENS,.01,"I"))
 S EDDT=$S(EDDT="":"",1:$$FMTE^XLFDT(EDDT\1,1))
 ;S BKMCLCL=$P($G(^BKM(90451,BKMIEN,1,BKMREG,2)),U,1)
 ;S CLCL=$S(BKMCLCL="":"",$E(BKMCLCL,1)?1A:BKMCLCL,1:$P($G(^BKMV(90451.7,BKMCLCL,0)),U,1))
 S CLCL=$$GET1^DIQ(90451.01,BKMIENS,"3","E")
 ;S DGCT=$P($G(^BKM(90451,BKMIEN,1,BKMREG,3)),U,7)
 S DGCTI=$$GET1^DIQ(90451.01,BKMIENS,"2.3","I")
 S DGCT=$S($$GET1^DIQ(90451.01,BKMIENS,"2.3","E")?1"AT RISK".E:"AT RISK-"_$S(DGCTI="EU":"UNK",DGCTI="EI":"IN",DGCTI="EO":"OCC",DGCTI="EN":"NON",1:""),1:$$GET1^DIQ(90451.01,BKMIENS,"2.3","E"))
 ;I $L(DGCT)=1 S DGCT=$S(DGCT="H":"HIV",DGCT="A":"AIDS",DGCT="R":"AT RISK",DGCT["E":"EXPOSED",1:"**")
 ;S CLDT=$$FMTE^XLFDT($$GET1^DIQ(90451.01,BKMIENS,3.5,"I"),5) ; Clinical Classification Date
 ;
 ; Check to see if the calculated next date is scheduled, if not check for other future scheduled date.
 S (LASTVIST,NEXTVIST,SCHEDULE,RVSTDT,LASTVSTI)=""
 ; Last visit prior to today
 ;PRXM/HC/BHS - 9/20/2005 - Replace with last visit rather than appt per client 9/9
 ;S LASTVSTI=$O(^DPT(DFN,"S",DT),-1)
 ;S RVSTDT=$O(^AUPNVSIT("AA",DFN,""))
 ;I RVSTDT'="" S LASTVSTI=$O(^AUPNVSIT("AA",DFN,RVSTDT,""))
 ;I LASTVSTI'="" S LASTVSTI=$$GET1^DIQ(9000010,LASTVSTI_",",".01","I")
 ;PRXM/HC/BHS - 12/01/2005 - Replace with function call based on new filter logic to find appropriate visit
 S LASTVSTI=$$LSTVST(DFN)
 ; Next scheduled visit after today
 S NEXTVSTI=$O(^DPT(DFN,"S",DT))
 I NEXTVSTI?7N.1".".N S SCHEDULE=1
 ; If no last visit and no next visit, next visit is 100 days from today
 I LASTVSTI'?7N.1".".N S LASTVSTI="" I NEXTVSTI'?7N.1".".N S NEXTVSTI=$$FMADD^XLFDT(DT,100)
 ; If last visit and no next visit, next visit is 100 days from the last visit
 I LASTVSTI?7N.1".".N,NEXTVSTI'?7N.1".".N S NEXTVSTI=$$FMADD^XLFDT(LASTVSTI,100)
 S:LASTVSTI?7N.1".".N LASTVIST=$$FMTE^XLFDT(+(LASTVSTI\1),1)
 S:LASTVIST="" LASTVIST="None Recorded"
 ; If patient is deceased, do not display next visit
 I $G(BKMDOD)'="" S NEXTVSTI=""
 S:NEXTVSTI?7N.1".".N NEXTVIST=$$FMTE^XLFDT(+(NEXTVSTI\1),1)
 I 'SCHEDULE,NEXTVIST'?." " S NEXTVIST=NEXTVIST_"*" I NEXTVSTI<DT S NEXTVIST=NEXTVIST_"*"
 ;S STAT=$P(^BKM(90451,BKMIEN,1,BKMREG,0),U,7)
 S STAT=$$GET1^DIQ(90451.01,BKMIENS,".5","E")
 ;S STAT=$S(STAT="A":"ACTIVE",STAT="I":"INACTIVE",STAT="D":"DECEASED",STAT="T":"TRANSIENT",STAT="R":"UNREVIEWED",STAT="N":"NOT ACCEPTED",1:"**")
 ;
 S REM=""
 I $G(CALCREM) D
 . W !,!,"Calculating Reminders.. This may take a moment.",! H 3
 . D REMIND^BKMVF3(DFN,DT,.REMLIST)
 . K CALCREM
 I $D(REMLIST)>1 S REM="Overdue Reminders for this Patient",^TMP("BKMVA2R",$J,DFN,"REM")=REM
 ;
 S OPIA=""
 D GETALL^BKMVC6(DFN)  ; Opportunistic infections or AIDS
 I $D(ICD9S)>1 S OPIA="Opportunistic Infection or AIDS Defining Illness Present"
 ;
 D UPDETI
 ;
 S ALLERGY=$O(^GMR(120.86,"B",DFN,""))
 I ALLERGY'="" S ALLERGY=$$GET1^DIQ(120.86,ALLERGY,1,"I")
 ;
 S INITHIV=$$FMTE^XLFDT($$GET1^DIQ(90451.01,BKMIENS,"5","I"),1)
 S INITAIDS=$$FMTE^XLFDT($$GET1^DIQ(90451.01,BKMIENS,"5.5","I"),1)
 ;
 S PCPROV=$$PRIMPROV^BKMVA1(DFN) ; Provider
 ; 
 S HIVPROV=$$GET1^DIQ(90451.01,BKMIENS,6,"E") ; HIV Provider
 S HIVCMGR=$$GET1^DIQ(90451.01,BKMIENS,6.5,"E") ; HIV Case Manager
 I '$F("AH",DGCTI) D  ;If at risk set clinical classn, HIV and AIDS dxs to N/A
 . S (CLCL,INITHIV,INITAIDS)="N/A"
 I DGCTI="H" S INITAIDS="N/A" ;If HIV set initial AIDS to N/A
 Q 1
UPDETI ;
 N ET
 S ET=$$GET1^DIQ(90451.01,BKMIENS,"7","E")
 S ACRF=""
 S:ET="" ACRF="Add CDC Etiology Category"
 Q
 ;
EXIT ;
 Q
HDR ;
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 Q
LSTVST(BKMDFN) ; Determine last visit
 N LSTVST,RVSTDT,LSTVSTI,BKMSVCAT
 S (LSTVST,RVSTDT,LSTVSTI)=""
 F  S RVSTDT=$O(^AUPNVSIT("AA",BKMDFN,RVSTDT)) Q:RVSTDT=""  D  Q:LSTVST'=""
 .S LSTVSTI=""
 .F  S LSTVSTI=$O(^AUPNVSIT("AA",BKMDFN,RVSTDT,LSTVSTI)) Q:LSTVSTI=""  D
 ..; Filter based on service category - exclude:
 ..; E (historical), C (chart review), T (telecomm), N (not found),
 ..; D (daily hosp), I (in hosp) and X (ancill pkg)
 ..S BKMSVCAT=$$GET1^DIQ(9000010,LSTVSTI_",",".07","I")
 ..I "^E^C^T^N^D^I^X^"[(U_BKMSVCAT_U) Q
 ..; Filter if visit does not have a POV
 ..I '$D(^AUPNVPOV("AD",LSTVSTI)) Q
 ..S LSTVST=$$GET1^DIQ(9000010,LSTVSTI_",",".01","I")
 Q LSTVST
 ;
 ;
