BKMIMRP2 ;PRXM/HC/BWF - Patient Visit Report ; 20 Sep 2005 6:39 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;MISCELLANEOUS REPORTS ROUTINE
 Q
 ; ^TMP("BKMIMRP2",$J,"DTFLTR",VSNUM) is used to store all visits that are
 ; within the date range selected by the user.
 ; 
 ; ^TMP("BKMIMRP2",$J,"PTFLTR",DFN,VSIT) uses ^TMP("BKMIMRP2",$J,"DTFLTR",VSNUM)
 ; to build a list of patients by DFN and visit. This sorts all visits under the
 ; appropriate DFN for additional filtering.
 ; 
CSEL ;EP - Criteria Selection
 K ^TMP("BKMVRPT",$J),^TMP("BKMIMRP2",$J),^TMP("BKMVISIT",$J)
 W !!
 ; initialize some variables
 S TODAY=$$DT^XLFDT,(PRINT,QUITALL,TAGERR)=0
 S EXTDT=$$FMTE^XLFDT(TODAY)
 K X,Y
 ; get beginning date
 S BDATE=$$DTRNG^BKMIMRP()
 I BDATE="E"!(BDATE=0) D XIT^BKMIMRP3 Q
 K X,Y
 ; get ending date
 S EDATE=$$DTRNG2^BKMIMRP(EXTDT,BDATE)
 I EDATE="E" D XIT^BKMIMRP3 Q
 I EDATE=0 S EDATE=TODAY
 ; set register to the HIV register.
 S REG=$$HIVIEN^BKMIXX3()
 ;
 ; Set patients
 S BKDFN=""
 F  S BKDFN=$O(^BKM(90451,"B",BKDFN)) Q:'BKDFN  D
 . S BKIEN=$O(^BKM(90451,"B",BKDFN,"")) Q:BKIEN=""
 . Q:'$D(^BKM(90451,"D",REG,BKIEN))
 . S ^TMP("BKMVISIT",$J,"PAT",BKDFN)=""
 ;
 K DIC,DA,Y
 S CS1RES=0
 F  D  Q:CS1RES=1
 .S CS1RES=$$CS1(REG)
 .I $G(OPT1)'="" S SEL(1)=OPT1_"^"_$G(POS)_"^"_$G(GLREF)_"^"_$G(VALUE)
 .I $G(OPT1)="G" D PAT Q
 .I $G(OPT1)="R"!($G(OPT1)="RDX")!($G(OPT1)="CC") D RGFLTR Q
 I QUITALL!($G(QUITTAG)) D XIT^BKMIMRP3 Q
 K X,Y,VALUE,POS,GLREF
 S Y=$$AA^BKMIMRP(1)
 I Y="^" D XIT^BKMIMRP3 Q
 I Y=0 K X,Y G FND
 S CS2RES="",QUITALL=0
 F  D  Q:CS2RES=1
 .S CS2RES=$$CS2(REG)
 .I $G(OPT2)'="" S SEL(2)=OPT2_"^"_$G(POS)_"^"_$G(GLREF)_"^"_$G(VALUE)
 .I $G(OPT2)="G" D PAT Q
 .I $G(OPT2)="R"!($G(OPT2)="RDX")!($G(OPT2)="CC") D RGFLTR Q
 ;
 K X,Y,VALUE,POS,GLREF
FND D SRTBY
 D XIT^BKMIMRP3
 Q
CS1(REG) ;Criteria Selection #1
 S CS1RES=0
 K X,Y
 S OPT1=$$CSEL2(1,1)
 I OPT1["^"!(OPT1="") S QUITALL=1 Q 1
 S OPT1TXT=$S(OPT1'="":Y(0),1:""),OPT1TXT=OPT1TXT_"="
 K ^TMP("BKMIMRP2",$J,"SEL")
 D TAG(OPT1) I TAGERR S QUITALL=1 Q 1
 S OPT1TXT=OPT1TXT_$G(VTXT)
 Q 1
CS2(REG) ;Criteria selection #2
 S CS2STOP=0
 S OPT2=$$CSEL2(2,1) ;SELECTION FOR SECOND CRITERIA (IF INDICATED)
 I OPT1=OPT2 D  Q 0
 .W !!,"This value is already selected!",!
 .W "Please make another Selection.",! K X,Y,OPT2
 I OPT2="^" S QUITALL=1 Q 1
 S OPT2TXT=$S(OPT2'="":Y(0),1:""),OPT2TXT=OPT2TXT_"="
 I OPT2'="" D TAG(OPT2) I TAGERR S QUITALL=1 Q 1
 S OPT2TXT=OPT2TXT_$G(VTXT)
 Q 1
CSEL2(SELNUM,TYPE) ;
 ; Input
 ;   SELNUM - Selection number. This will be either the first selection
 ;            or the second selection the user can make
 ;   TYPE - TYPE=1: Means that the selection is being used for a search
 ;          TYPE=2: Means that the selection is being used for a sort
 ;
 K DIR,X,Y
 I (SELNUM=1)&(TYPE=1) S DIR("A")="Select a Search Parameter <Enter> to quit"
 I (SELNUM=2)&(TYPE=1) S DIR("A")="Select Another Search Parameter <Enter> to bypass ""^"" to Quit"
 I (SELNUM=1)&(TYPE=2) S DIR("A")="Select a Sort Criteria <Enter> to quit",DIR("B")="P"
 I (SELNUM=2)&(TYPE=2) S DIR("A")="Select Another Sort Criteria <Enter> to bypass, ""^"" to Quit"
 ;
 S DIR(0)="SO^P:PATIENT NAME;PR:PROVIDER;R:REGISTER STATUS;RDX:REGISTER DIAGNOSIS;G:GENDER;CL:CLINIC CODE;CC:CLINICAL CLASSIFICATION"
 D ^DIR K DIR
 Q Y
 ;
DTFLTR ; Find visits
 NEW VSNUM,BDT,EDT,CONVDT,VSDFN,POS,VALUE,NOD,PEC
 S BDT=BDATE,EDT=EDATE
 F I=1,2 I $P($G(SEL(I)),U,1)="CL" D
 . S POS=$P(SEL(I),U,2),VALUE=$P(SEL(I),U,5)
 S BKDFN=""
 F  S BKDFN=$O(^TMP("BKMVISIT",$J,"PAT",BKDFN)) Q:BKDFN=""  D
 .S CHKDT=9999999-BDATE,ENDT=9999999-EDATE
 .F  S CHKDT=$O(^AUPNVSIT("AA",BKDFN,CHKDT),-1) Q:CHKDT=""!(CHKDT\1<ENDT)  D
 ..S VSNUM="" F  S VSNUM=$O(^AUPNVSIT("AA",BKDFN,CHKDT,VSNUM)) Q:'VSNUM  D
 ...I $G(POS)'="" S NOD=$P(POS,";",1),PEC=$P(POS,";",2)
 ...I $G(POS)'="",$P(^AUPNVSIT(VSNUM,NOD),U,PEC)'=VALUE Q
 ...S ^TMP("BKMIMRP2",$J,"VISIT",VSNUM)=""
 Q
 ;
RGFLTR ; Filter by register
 NEW DFN,IEN,BKIEN,NOD,PEC
 S DFN="",NOD=$P(POS,";",1),PEC=$P(POS,";",2)
 F  S DFN=$O(^TMP("BKMVISIT",$J,"PAT",DFN)) Q:DFN=""  D
 . S IEN=$O(^BKM(90451,"B",DFN,""))
 . S BKIEN=$O(^BKM(90451,"D",REG,IEN,"")) Q:BKIEN=""
 . I $P($G(@GLREF@(IEN,1,BKIEN,NOD)),U,PEC)=$G(VALUE) Q
 . K ^TMP("BKMVISIT",$J,"PAT",DFN)
 Q
 ;
TAG(OPT,OPTDAT) ;to execute appropriate tag
 S ENTRY=$S(OPT="P":"PTS",OPT="PR":"PRV",OPT="R":"REGSTAT",OPT="RDX":"RDX",OPT="G":"GEN",OPT="CL":"CLIN",OPT="CC":"CLAS",1:"EXIT")
 S XECUTE=ENTRY_"(REG)"
 D @XECUTE
 Q
 ;
PAT ; filter by gender
 NEW DFN,NOD,PEC
 S DFN="" Q:$G(VALUE)=""
 S NOD=$P(POS,";",1),PEC=$P(POS,";",2)
 F  S DFN=$O(^TMP("BKMVISIT",$J,"PAT",DFN)) Q:DFN=""  D
 . I $P(@GLREF@(DFN,NOD),U,PEC)=VALUE Q
 . K ^TMP("BKMVISIT",$J,"PAT",DFN)
 Q
 ;
PTS(REG) ;
 ; Patient Visit gathering module
 ; Prompt for patient(s) first. Store them in an array.
 ; Patients can only come from the register selected.
 ; 
 N STOP,DFN K PTS,^TMP("BKMVISIT",$J,"PAT")
 S STOP=0,QUITTAG=0
 I REG=0 D  ; This if for future use, and should not be used until iCare deployment
 .F  D  Q:STOP
 ..D PLK^BKMPLKP("")
 ..I $G(DFN)="" S STOP=1 Q
 ..S PTS(DFN)=""
 ..S ^TMP("BKMVISIT",$J,"PAT",DFN)=""
 ;This section is for specific registers
 I REG'=0,(REG>0) D
 .F  D  Q:STOP
 ..S DIC("S")="I $D(^BKM(90451,""D"",REG,+Y))"
 ..D RLK^BKMPLKP("")
 ..I $G(DFN)="" S STOP=1 Q
 ..I $G(BKMRIEN)="" S STOP=1 Q
 ..S PTS(DFN)=""
 ..S ^TMP("BKMVISIT",$J,"PAT",DFN)=PTNAME
 ..S VTXT=PTNAME
 I '$D(PTS) S QUITTAG=1 Q
 K PTS
 Q
 ;
PRV(REG) ;Provider selection prompt
 N STOP,PRVNM,EPROV,DIC
 S STOP=0,QUITTAG=0
 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y))"
 S DIC="^VA(200,",DIC("A")="Select Provider: ",DIC(0)="AEMQ"
 F  D  Q:STOP
 .D ^DIC
 .S DA=+Y I DA<0 S STOP=1 Q
 .S PRV=DA,EPROV=$P(Y,U,2),PROV(PRV)=""
 .S ^TMP("BKMIMRP2",$J,"PROV",PRV)=EPROV
 .S VTXT=EPROV
 I '$D(PROV) S QUITTAG=1
 Q
 ;
CLAS(REG) ;  Clinical Classification selection prompt
 NEW DIC,DA
 S DIC="^BKMV(90451.7,",DIC(0)="AEMQ"
 D ^DIC
 S CLASS=+Y,VALUE=CLASS,VTXT=$P(Y,U,2),POS="2;1",GLREF="^BKM(90451)"
 Q
 ;
PRVFLTR ;Filter providers
 ; PRVPAT array is assumed to be existent.
 N VSIT,VPRVIEN,VSPROV,FLAG
 S VSIT=0
 F  S VSIT=$O(^TMP("BKMIMRP2",$J,"VISIT",VSIT)) Q:VSIT=""  D
 .I '$D(^AUPNVPRV("AD",VSIT)) K ^TMP("BKMIMRP2",$J,"VISIT",VSIT) Q
 .S VPRVIEN=0
 .F  S VPRVIEN=$O(^AUPNVPRV("AD",VSIT,VPRVIEN)) Q:VPRVIEN=""  D
 ..S VSPROV=$$GET1^DIQ(9000010.06,VPRVIEN,.01,"I")
 ..I $D(PROV(VSPROV)) Q
 ..K ^TMP("BKMIMRP2",$J,"VISIT",VSIT)
 Q
 ;
PVDR ; Get primary provider name
 S VPRVIEN=""
 F  S VPRVIEN=$O(^AUPNVPRV("AD",VISIT,VPRVIEN)) Q:VPRVIEN=""  D
 .I $$GET1^DIQ(9000010.06,VPRVIEN,.04,"I")'="P" Q
 .S VSPROV=$$GET1^DIQ(9000010.06,VPRVIEN,.01,"E")
 Q
 ;
REGSTAT(REG) ;Register Status Selection
 S REGSTAT="",QUITTAG=0
 N DIR
 S DIR("A")="Select Register Status"
 S DIR("B")="A"
 S DIR(0)="SO^A:Active;I:Inactive;D:Deceased;T:Transient"
 D ^DIR
 I Y="^"!(Y="") S QUITTAG=1 Q
 S REGSTAT=Y,VALUE=REGSTAT,POS="0;7",GLREF="^BKM(90451)",VTXT=$$STC^BKMVUTL(90451.01,.5,REGSTAT)
 Q
RDX(REG) ; Register diagnosis prompt.
 S QUITTAG=0
 S RDX=$$DIAG^BKMIXX3()
 I Y="^" S QUITTAG=1 Q
 I Y="" S QUITTAG=1 Q
 S VALUE=RDX,POS="3;7",GLREF="^BKM(90451)",VTXT=$$STC^BKMVUTL(90451.01,2.3,RDX)
 Q
GEN(REG) ;Gender Prompt
 ;Gender
 S GENDER="",QUITTAG=0
 K DIR
 S DIR("A")="Select Gender"
 S DIR(0)="SO^M:Male;F:Female"
 D ^DIR K DIR
 I Y="^" Q
 I Y="" S QUITTAG=1 Q
 S GENDER=Y
 S GLREF="^DPT",POS="0;2",VALUE=GENDER,VTXT=$$STC^BKMVUTL(2,.02,GENDER)
 Q
 ;
CLIN(REG) ;
 ; Allows the user to select the clinic they would like to view 
 ; visits for.
 NEW DIC,Y,DA
 S QUITTAG=0
 S DIC="^DIC(40.7,",DIC(0)="AEQMZ",DIC("A")="Select Clinic: " D ^DIC
 S DA=+Y Q:DA<0
 I DA="" S QUITTAG=1 Q
 S CLINIC=DA,ECLIN=$P(Y,U,2)
 S GLREF="^AUPNVSIT(",POS="0;8",VALUE=CLINIC,VTXT=$P(Y,U,2)
 Q
 ;
SRTBY ; Sort by selections.
 Q:$G(PRINT)
 D DTFLTR
 F I=1,2 I $P($G(SEL(I)),U,1)="PR" D PRVFLTR
 N SRT1,SRT2,STOP
 K X,Y
 S STOP=0,QT=""
 S SRT1=$$CSEL2(1,2)
 I SRT1="^"!(SRT1="") D  Q:STOP
 .S QT=$$FORGETIT^BKMIMRP()
 .I QT S STOP=1 Q
 .I 'QT K X,Y,QT S STOP="N" Q
 I STOP="N" G SRTBY
 I STOP D XIT^BKMIMRP3 Q
 S SRT1TXT=Y(0)
 K X,Y
 S Y=$$AA^BKMIMRP(2)
 I Y="^" D XIT^BKMIMRP3 Q
 I Y=0 S SRT2="" D  Q
 .D SORT(SRT1,SRT2)
 .D PRINT^BKMIMRP3(SRT1,SRT2) Q:QUITALL
 K X,Y
ST2 S SRT2=$$CSEL2(2,2)
 I Y<0!(Y="^") D XIT^BKMIMRP3 Q
 I SRT2=SRT1 W !!,"This value has already been selected. Please choose another sort critera." K X,Y G ST2
 I Y="" D  Q
 .D SORT(SRT1,SRT2)
 .D PRINT^BKMIMRP3(SRT1,SRT2)
 S SRT2TXT=Y(0)
 D SORT(SRT1,SRT2)
 D PRINT^BKMIMRP3(SRT1,SRT2)
 D XIT^BKMIMRP3
 Q
SORT(SRT1,SRT2) ; Sort the data
 D EN^DDIOL("Searching for visits","","!!")
 NEW DFN,VISIT,PIECE1,NODEDAT,NODE1,PIECE2,NODE2
 S VISIT=""
 F  S VISIT=$O(^TMP("BKMIMRP2",$J,"VISIT",VISIT)) Q:VISIT=""  D
 .S DFN=$$GET1^DIQ(9000010,VISIT_",",.05,"I")
 .S PTNM=$$GET1^DIQ(9000010,VISIT_",",.05,"E")
 .S DOB=$$GET1^DIQ(2,DFN_",",.03,"E")
 .S HRN=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 .I $P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,3)'="" S HRN=HRN_"(*)"
 .S GENDER=$$GET1^DIQ(2,DFN_",",.02,"I")
 .S CLINIC=$$GET1^DIQ(9000010,VISIT_",",.08,"E")
 .S IEN=$O(^BKM(90451,"B",DFN,"")) Q:IEN=""
 .S BKIEN=$O(^BKM(90451,"D",REG,IEN,""))
 .NEW DA
 .S DA(1)=IEN,DA=BKIEN,IENS=$$IENS^DILF(.DA)
 .S RGSTAT=$$GET1^DIQ(90451.01,IENS,.5,"I")
 .S RDX=$$GET1^DIQ(90451.01,IENS,2.3,"E")
 .S CLASS=$$GET1^DIQ(90451.01,IENS,3,"E")
 .S VSDTM=$$GET1^DIQ(9000010,VISIT_",",.01,"I")\1
 .S VSDATE=$$FMTE^XLFDT(VSDTM,"5Z")
 .D PVDR
 .S NODEDAT=PTNM_"^"_HRN_"^"_DOB_"^"_VSDATE_"^"_CLINIC_"^"_$G(VSPROV)
 .;
 .S NODE1=$S(SRT1="G":GENDER,SRT1="CC":CLASS,SRT1="CL":CLINIC,SRT1="PR":VSPROV,SRT1="R":RGSTAT,SRT1="RDX":RDX,1:PTNM)
 .I NODE1="" S NODE1="~"
 .I SRT2="" D
 ..S ^TMP("BKMIMRP2",$J,"PRINT",NODE1,DFN,VISIT)=NODEDAT Q
 .;
 .I SRT2'="" D
 ..S NODE2=$S(SRT2="G":GENDER,SRT2="CC":CLASS,SRT2="CL":CLINIC,SRT2="PR":VSPROV,SRT2="R":RGSTAT,SRT2="RDX":RDX,1:PTNM)
 ..I NODE2="" S NODE2="~"
 ..S ^TMP("BKMIMRP2",$J,"PRINT",NODE1,NODE2,DFN,VISIT)=NODEDAT
 K ^TMP("BKMIMRP2",$J,"DTFLTR")
 K ^TMP("BKMIMRP2",$J,"DATA")
 Q
HDRINFO(PAGE) ; EP - Header page
 N NOW,SITE,DA,IENS
 S BKMRTN=""
 S NOW=$$FMTE^XLFDT(DT,1)
 W:PAGE>1 @IOF
 S DA=$G(DUZ(2)),IENS=$$IENS^DILF(.DA),SITE=$$GET1^DIQ(4,IENS,.01,"E")
 W !?1,$$GET1^DIQ(200,DUZ,"1","E")
 W ?80-$L(NOW)\2,NOW,?70,"Page: ",PAGE
 W !?80-$L(SITE)\2,SITE,!
 D HDR("Patient Visit Report","")
 I $D(OPT2TXT) D HDR("Search Parameters: "_OPT1TXT_","_OPT2TXT)
 I '$D(OPT2TXT) D HDR("Search Parameters: "_OPT1TXT)
 I SRT2'="" D HDR("Sorted By: "_SRT1TXT_","_SRT2TXT)
 I SRT2="" D HDR("Sorted By: "_SRT1TXT)
 W ?18,"*** CONFIDENTIAL PATIENT INFORMATION ***",!
 W !?1,"NAME",?21,"HRN",?28,"DOB",?39,"Visit Date",?50,"Clinic",?63,"Provider",!
 D HDR3
 Q
AGE(DFN) ;PATIENT AGE
 ; Extrinsic Age function
 ; Input = DFN - IEN of patient
 N DOB,DATE,AGE
 S DOB=$$GET1^DIQ(2,DFN_",",.03,"I","","")
 S DATE=$E(DT,1,3)
 S AGE=DATE-$E(DOB,1,3)
 S:$E(DT,4,7)<$E(DOB,4,7) AGE=AGE-1
 I AGE<3 D
 .S DAYS=$$FMDIFF^XLFDT(DT,DOB,1)
 .I DAYS<7 S AGE=DAYS_"d" Q
 .I DAYS<30 S AGE=DAYS\7_"w" Q
 .S AGE=DAYS\30_"m"
 Q AGE
HDR(HEADER,PAGE) ;
 ; Input - HEADER: Header text (required)
 ;- PAGE (optional)
 ; This will print a page number on the header line.
 ; This utility will look at the screen width chosen by the user, and
 ; center the data on the screen.
 ; Note: you must first call ^%ZIS to get the parameters.
 I '$D(PAGE) S PAGE=""
 S LEN=$L(HEADER)
 S CENTER=LEN/2,CLINE=IOM/2
 S START=$P(CLINE-CENTER,".",1)
 I (PAGE'="") W ?START,HEADER,?68,"Page: ",PAGE,! Q
 I PAGE="" W ?START,HEADER,!
 Q
HDR3 ;EP - Write a dashed line.
 ; This utility will write a screen-width wide line of dashes (stored in IOM).
 ; Note: you must first call ^%ZIS to get the parameters.
 W ?1 F I=1:1:(IOM-2) W "-"
 W !?1
 Q
EXIT ;
 W !,"Recording that an error has occured."
 W !,OPT_" is not a valid line tag."
 W !,"Please send this error to your system administrator." H 2
 S TAGERR=1
 Q
