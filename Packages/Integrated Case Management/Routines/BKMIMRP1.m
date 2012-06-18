BKMIMRP1 ;PRXM/HC/BWF - BKMV UTILITY PROGRAM; [ 1/19/2005  7:16 PM ]
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;MISCELLANEOUS REPORTS ROUTINE
 Q
 ; ^TMP("BKMIMRP1",$J,"DTFLTR",VSNUM) is used to store all visits that are
 ; within the date range selected by the user.
 ; 
 ; ^TMP("BKMIMRP1",$J,"PTFLTR",DFN,VSIT) uses ^TMP("BKMIMRP1",$J,"DTFLTR",VSNUM)
 ; to build a list of patients by DFN and visit. This sorts all visits under the
 ; appropriate DFN for additional filtering.
 ; 
CSEL ;EP 
 ; Criteria Selection
 ;
 W !!
 ; initialize some variables
 S TODAY=$$DT^XLFDT,(PRINT,QUITALL,TAGERR)=0
 S EXTDT=$$FMTE^XLFDT(TODAY)
 K X,Y
 ; get beginning date
 S BDATE=$$DTRNG^BKMIMRP()
 I BDATE="E" D XIT^BKMIMRP Q
 I BDATE=0 K X,Y G CSEL
 K X,Y
 ; get ending date
 S EDATE=$$DTRNG2^BKMIMRP(EXTDT,BDATE)
 I EDATE="E" D XIT^BKMIMRP Q
 I EDATE=0 S EDATE=TODAY
 ; set register to the HIV register.
 S REG=1
 ; filter data based on dates
 D DTFLTR(BDATE,EDATE)
 K DIC,DA,Y
 D FLTRMSG
 D RGPTFLTR(REG)
 S CS1RES=""
 F  D  Q:CS1RES=1
 .S CS1RES=$$CS1(REG)
 I QUITALL!($G(QUITTAG)) D XIT^BKMIMRP Q
 K X,Y
 S Y=$$AA^BKMIMRP(1)
 I Y="^" D XIT^BKMIMRP Q
 I Y=0 K X,Y D DISPINFO^BKMIMRP,SRTBY,XIT^BKMIMRP Q
 S CS2RES="",QUITALL=0
 F  D  Q:CS2RES=1
 .S CS2RES=$$CS2(REG)
 D DISPINFO^BKMIMRP,SRTBY
 D XIT^BKMIMRP
 Q
CS1(REG) ;Criteria Selection #1
 S CS1RES=0
 K X,Y
 S OPT1=$$CSEL2(1,1)
 I OPT1["^"!(OPT1="") S QUITALL=1 Q 1
 S OPT1TXT=$S(OPT1'="":Y(0),1:""),OPT1TXT=OPT1TXT_"="
 D FLTRMSG
 K ^TMP("BKMIMRP1",$J,"SEL")
 D TAG(OPT1) I TAGERR S QUITALL=1 Q 1
 S ITEM=0
 F  S ITEM=$O(^TMP("BKMIMRP1",$J,"SEL",ITEM)) Q:ITEM=""  D
 .S OPT1TXT=OPT1TXT_ITEM_";"
 Q 1
CS2(REG) ;Criteria selection #2
 S CS2STOP=0
 S OPT2=$$CSEL2(2,1) ;SELECTION FOR SECOND CRITERIA (IF INDICATED)
 I OPT1=OPT2 D  Q 0
 .W !!,"This value is already selected!",!
 .W "Please make another Selection.",! K X,Y,OPT2
 I OPT2="^" S QUITALL=1 Q 1
 S OPT2TXT=$S(OPT2'="":Y(0),1:"")
 D FLTRMSG
 I OPT2'="" D TAG(OPT2) I TAGERR S QUITALL=1 Q 1
 Q 1
CSEL2(SELNUM,TYPE) ;
 ; Input - SELNUM - Selection number. This will be either the first selection
 ;or the second selection the user can make
 ;
 ;- TYPE - TYPE=1: Means that the selection is being used for a search
 ;  TYPE=2: Means that the selection is being used for a sort
 ;
 K DIR,X,Y
 I (SELNUM=1)&(TYPE=1) S DIR("A")="Select a search parameter"
 I (SELNUM=2)&(TYPE=1) S DIR("A")="Select Another search parameter"
 I (SELNUM=1)&(TYPE=2) S DIR("A")="Select a sort criteria",DIR("B")="P"
 I (SELNUM=2)&(TYPE=2) S DIR("A")="Select Another sort criteria"
 ;PRXM/HC/DLS 9/20/2005 Added 'HIV' to 'PROVIDER'.
 S DIR(0)="SO^P:Patient Name;PR:HIV Provider;R:Register Status;RDX:Register Diagnosis;G:Gender;CL:Clinic Code"
 D ^DIR
 ;PRXM/HC/BHS 10/31/2005 - Added logic to treat timeout as '^'
 I $D(DTOUT)!$D(DUOUT) Q "^"
 Q Y
DTFLTR(BDATE,EDATE) ;filters data based on user supplied date
 N VSNUM,BDT,EDT,ENDT,CONVDT,VSDFN
 S BDT=BDATE,EDT=EDATE
 S VSDFN="" F  S VSDFN=$O(^AUPNVSIT("AA",VSDFN)) Q:VSDFN=""  D
 .S REGIEN=$O(^BKM(90451,"B",VSDFN,0)) Q:$G(REGIEN)=""
 .Q:'$D(^BKM(90451,"D",REG,REGIEN))
 .S CHKDT=9999999-BDATE,ENDT=9999999-EDATE
 .F  S CHKDT=$O(^AUPNVSIT("AA",VSDFN,CHKDT),-1) Q:CHKDT=""!(CHKDT\1<ENDT)  D
 ..S VSNUM=$O(^AUPNVSIT("AA",VSDFN,CHKDT,0))
 ..S ^TMP("BKMIMRP1",$J,"DTFLTR",VSNUM)=""
 Q
RGPTFLTR(REG) ;
 ; Filter out all visits where the patient is not found in the register
 N VSNUM,DFN
 S VSNUM=0
 F  S VSNUM=$O(^TMP("BKMIMRP1",$J,"DTFLTR",VSNUM)) Q:VSNUM=""  D
 .S DFN=$$GET1^DIQ(9000010,VSNUM_",",.05,"I","","")
 .I '$D(DFN) K ^TMP("BKMIMRP1",$J,"DTFLTR",VSNUM) Q
 .I DFN="" K ^TMP("BKMIMRP1",$J,"DTFLTR",VSNUM) Q
 .; If the patient is not in the B x-ref, they are not on a register
 .I '$D(^BKM(90451,"B",DFN)) K ^TMP("BKMIMRP1",$J,"DTFLTR",VSNUM)
 .; If the patient is in the "B" x-ref, and not associated with the 
 .; selected register in the "D" x-ref, kill the ^TMP entry
 .I $D(^BKM(90451,"B",DFN)) D
 ..S REGIEN=$O(^BKM(90451,"B",DFN,0))
 ..I '$D(^BKM(90451,"D",REG,REGIEN)) D
 ...K ^TMP("BKMIMRP1",$J,"DTFLTR",VSNUM)
 Q
TAG(OPT,OPTDAT) ;to execute appropriate tag
 S ENTRY=$S(OPT="P":"PTS",OPT="PR":"PRV",OPT="R":"REGSTAT",OPT="RDX":"RDX",OPT="G":"GEN",OPT="CL":"CLIN",1:"EXIT")
 S XECUTE=ENTRY_"^BKMIMRP1(REG)"
 D @XECUTE
 Q
PTS(REG) ;
 ; Patient Visit gathering module
 ; Prompt for patient(s) first. Store them in an array.
 ; Patients can only come from the register selected.
 ; 
 N STOP,DFN K PTS
 S STOP=0,QUITTAG=0
 I REG=0 D  ; This if for future use, and should not be used until iCare deployment
 .F  D  Q:STOP
 ..D PLK^BKMPLKP("")
 ..I $G(DFN)="" S STOP=1 Q
 ..S PTS(DFN)=""
 ..S ^TMP("BKMIMRP1",$J,"SEL",PTNAME)=""
 ;This section is for specific registers
 I REG'=0,(REG>0) D
 .F  D  Q:STOP
 ..S DIC("S")="I $D(^BKM(90451,""D"",REG,+Y))"
 ..D RLK^BKMPLKP("")
 ..I $G(DFN)="" S STOP=1 Q
 ..I $G(BKMRIEN)="" S STOP=1 Q
 ..S PTS(DFN)=""
 ..S ^TMP("BKMIMRP1",$J,"SEL",PTNAME)=""
 I '$D(PTS) S QUITTAG=1 Q
 D PTFLTR
 Q
PTFLTR ;
 ; Filter out entries that do not belong to the patient listing.
 ; Array PTS must be populated
 N VISIT
 S VSIT=0
 F  S VSIT=$O(^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)) Q:VSIT=""  D
 .S DFN=$$GET1^DIQ(9000010,VSIT_",",.05,"I","","")
 .I '$D(PTS(DFN)) K ^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)
 Q
PRV(REG) ;Provider selection prompt
 N STOP,PRVNM,EPROV
 S STOP=0,QUITTAG=0
 S DIC("S")="I $D(^XUSEC(""PROVIDER"",+Y))"
 S DIC="^VA(200,",DIC("A")="Select Provider: ",DIC(0)="AEMQ"
 F  D  Q:STOP
 .D ^DIC
 .S DA=+Y I DA<0 S STOP=1 Q
 .S PRV=DA
 .S PROV(PRV)=""
 .S EPROV=$P(Y,U,2)
 .S ^TMP("BKMIMRP1",$J,"SEL",EPROV)=""
 I '$D(PROV) S QUITTAG=1
 D PRVFLTR
 Q
PRVFLTR ;Filter providers
 ; PRVPAT array is assumed to be existent.
 N VSIT,VPRVIEN,VSPROV,FLAG
 S VSIT=0
 F  S VSIT=$O(^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)) Q:VSIT=""  D
 .I '$D(^AUPNVPRV("AD",VSIT)) K ^TMP("BKMIMRP1",$J,"DTFLTR",VSIT) Q
 .S VPRVIEN=0
 .S FLAG=0
 .F  S VPRVIEN=$O(^AUPNVPRV("AD",VSIT,VPRVIEN)) Q:VPRVIEN=""  D
 .S VSPROV=$$GET1^DIQ(9000010.06,VPRVIEN,.01,"I")
 .I VSPROV="" Q
 .I $D(PROV(VSPROV)) S FLAG=1
 .I '$D(PROV(VSPROV)),'FLAG K ^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)
 Q
REGSTAT(REG) ;Register Status Selection
 N REGSTAT
 S QUITTAG=0
 K DIR
 S DIR("A")="Select register status"
 S DIR("B")="A"
 S DIR(0)="SO^A:Active;I:Inactive;D:Deceased;T:Transient"
 D ^DIR
 I Y="^"!(Y="") S QUITTAG=1 Q
 S REGSTAT=Y,^TMP("BKMIMRP1",$J,"SEL",Y(0))=""
 D REGFLTR(REG,REGSTAT)
 Q
REGFLTR(REG,REGSTAT) ;Register filter. Removes any register status that has not been selected.
 N REGPAT,REGIEN
 I REG=0 Q  ;If there is no register, then we can not get register status.
 S REGIEN=0
 F  S REGIEN=$O(^BKM(90451,"D",REG,REGIEN)) Q:REGIEN=""  D
 .S REGLOC=$O(^BKM(90451,"D",REG,REGIEN,0))
 .S STAT=$$GET1^DIQ(90451.01,REGLOC_","_REGIEN_",",.5,"I","","")
 .I STAT'=REGSTAT Q
 .S DFN=$$GET1^DIQ(90451,REGIEN_",",.01,"I","","")
 .S REGPAT(DFN)=""
 I $D(REGPAT) D
 .S VSIT=0
 .F  S VSIT=$O(^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)) Q:VSIT=""  D
 ..S DFN=$$GET1^DIQ(9000010,VSIT_",",.05,"I","","")
 ..I '$D(REGPAT(DFN)) K ^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)
 Q
RDX(REG) ; Register diagnosis prompt.
 S QUITTAG=0
 N RDX S RDX=""
 ;PRXM/HC/BHS - 9/24/2005 - Replaced with uniform lookup per Tucson meeting 9/9
 ;K X,Y
 ;K DIR
 ;S DIR("A")="Select Register Diagnosis"
 ;S DIR(0)="SO^R:At Risk;H:HIV;A:AIDS;EI:Infant Exposed;EO:Occupational Exposure;EN:Non-Occupational Exposure;EU:Exposed/Source Unknown"
 ;D ^DIR
 ;I Y="^" S QUITTAG=1 Q
 ;I Y="" S QUITTAG=1 Q
 ;S RDX=Y,^TMP("BKMIMRP1",$J,"SEL",Y(0))=""
 S RESULT=$$DX^BKMIXX4()
 I RESULT="^" S QUITTAG=1 Q
 S RDX=$P($P(RESULT,U,1),",",2)
 I $P(RESULT,U,2)'="" S ^TMP("BKMIMRP1",$J,"SEL",$P(RESULT,U,2))=""
 D BLDPTLST
 D RDXFLTR(REG,RDX)
 Q
RDXFLTR(REG,RDX) ; Register Diagnosis Filter
 S DFN=0
 F  S DFN=$O(^TMP("BKMIMRP1",$J,"PTFLTR",DFN)) Q:DFN=""  D
 .S VSIT=0
 .F  S VSIT=$O(^TMP("BKMIMRP1",$J,"PTFLTR",DFN,VSIT)) Q:VSIT=""  D
 ..S REGIEN=$O(^BKM(90451,"B",DFN,0))
 ..S REGLOC=$O(^BKM(90451,"D",REG,REGIEN,0))
 ..S REGDX=$$GET1^DIQ(90451.01,REGLOC_","_REGIEN_",",2.3,"I","","")
 ..I REGDX'=RDX K ^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)
 Q
GEN(REG) ;Gender Prompt
 ;Gender
 N GENDER
 S QUITTAG=0
 K DIR
 S DIR("A")="Select Gender"
 S DIR(0)="SO^M:Male;F:Female"
 D ^DIR
 ;PRXM/HC/BHS - 10/31/2005 - Added logic to set QUITTAG on '^'
 I Y="^" S QUITTAG=1 Q
 I Y="" S QUITTAG=1 Q
 S GENDER=Y,^TMP("BKMIMRP1",$J,"SEL",Y(0))=""
 D BLDPTLST
 D GENFLTR^BKMIMRP(GENDER)
 Q
CLIN(REG) ;
 ; Allows the user to select the clinic they would like to view 
 ; visits for.
 S QUITTAG=0
 S DIC="^DIC(40.7,",DIC(0)="AEQM",DIC("A")="Select Clinic: " D ^DIC
 ;PRXM/HC/BHS - 10/31/2005 - Added logic to set QUITTAG on '^'
 S DA=+Y S QUITTAG=1 I DA'>0 Q
 I DA="" S QUITTAG=1 Q
 N ECLIN
 S CLINIC=DA
 S ECLIN=$P(Y,U,2),^TMP("BKMIMRP1",$J,"SEL",ECLIN)=""
 D CLINFLTR^BKMIMRP(CLINIC)
 Q
SRTBY ; Sort by selections.
 Q:$G(PRINT)
 N SRT1,SRT2,STOP
 K X,Y
 S STOP=0,QT=""
 S SRT1=$$CSEL2(1,2)
 I SRT1="^"!(SRT1="") D  Q:STOP
 .S QT=$$FORGETIT^BKMIMRP()
 .I QT=1!(QT="^") S STOP=1 Q
 .I 'QT K X,Y,QT S STOP="N" Q
 I STOP="N" G SRTBY
 I STOP D XIT^BKMIMRP Q
 S SRT1TXT=Y(0)
 K X,Y
 S Y=$$AA^BKMIMRP(2)
 I Y="^" D XIT^BKMIMRP Q
 I Y=0 S SRT2="" D  Q
 .D SORT(SRT1,SRT2)
 .D PRINT^BKMIMRP(SRT1,SRT2) Q:QUITALL
 K X,Y
ST2 S SRT2=$$CSEL2(2,2)
 I Y<0!(Y="^") D XIT^BKMIMRP Q
 I SRT2=SRT1 W !!,"This value has already been selected. Please choose another sort critera." K X,Y G ST2
 I Y="" D  Q
 .D SORT(SRT1,SRT2)
 .D PRINT^BKMIMRP(SRT1,SRT2)
 S SRT2TXT=Y(0)
 D SORT(SRT1,SRT2)
 D PRINT^BKMIMRP(SRT1,SRT2)
 D XIT^BKMIMRP
 Q
SORT(SRT1,SRT2) ; Sort the data
 N DFN,VSIT,PIECE1,NODEDAT,NODE1,PIECE2,NODE2
 S DFN=0
 F  S DFN=$O(^TMP("BKMIMRP1",$J,"DATA",DFN)) Q:DFN=""  D
 .S VSIT=0
 .F  S VSIT=$O(^TMP("BKMIMRP1",$J,"DATA",DFN,VSIT)) Q:VSIT=""  D
 ..S PIECE1=$S(SRT1="CL":3,SRT1="PR":2,SRT1="P":1,SRT1="R":4,SRT1="IDX":5,SRT1="RDX":6,SRT1="CC":7,SRT1="V":8,SRT1="G":9,1:0)
 ..S NODEDAT=$G(^TMP("BKMIMRP1",$J,"DATA",DFN,VSIT))
 ..S PTNM=$P(NODEDAT,U)
 ..S NODE1=$P(NODEDAT,U,PIECE1)
 ..I NODE1="" S NODE1="N/A"
 ..I SRT2="",SRT1="P" S ^TMP("BKMIMRP1",$J,"PRINT",NODE1,"PH",DFN,VSIT)=NODEDAT Q
 ..I SRT2="",SRT1'="P" S ^TMP("BKMIMRP1",$J,"PRINT",NODE1,PTNM,DFN,VSIT)=NODEDAT Q
 ..S PIECE2=$S(SRT2="CL":3,SRT2="PR":2,SRT2="P":1,SRT2="R":4,SRT2="IDX":5,SRT2="RDX":6,SRT2="CC":7,SRT2="V":8,SRT2="G":9,1:0)
 ..S NODE2=$P(NODEDAT,U,PIECE2)
 ..I NODE2'="" D
 ...I SRT1="P"!SRT2="P" S ^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN,VSIT)=NODEDAT Q
 ...I SRT1'="P",SRT2'="P" S ^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,PTNM,DFN,VSIT)=NODEDAT Q
 ...S ^TMP("BKMIMRP1",$J,"PRINT",NODE1,NODE2,"PH",DFN,VSIT)=NODEDAT
 K ^TMP("BKMIMRP1",$J,"DTFLTR")
 K ^TMP("BKMIMRP1",$J,"DATA")
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
BLDPTLST ; EP - Builds list of patients based on the ^TMP global filtered by date
 N VSIT,DFN
 K ^TMP("BKMIMRP1",$J,"PTFLTR")
 S VSIT=0
 F  S VSIT=$O(^TMP("BKMIMRP1",$J,"DTFLTR",VSIT)) Q:VSIT=""  D
 .S DFN=$$GET1^DIQ(9000010,VSIT_",",.05,"I","","")
 .S ^TMP("BKMIMRP1",$J,"PTFLTR",DFN,VSIT)=""
 Q
FLTRMSG ; EP - Data Filter
 D EN^DDIOL(" ")
 D EN^DDIOL("Filtering Data... This may take a moment.....")
 Q
AGE(DFN) ;EP - PATIENT AGE
 ; Extrinsic Age function
 ; Input = DFN - IEN of patient
 N DOB,DATE,AGE,TDATE
 S DOB=$$GET1^DIQ(2,DFN_",",.03,"I","","")
 ;PRXM/HC/DLS 9/21/2005 Added TDATE variable for configuring age
 ; based on today (if still living) or DOD (Date of Death), if applicable.
 S TDATE=$$GET1^DIQ(2,DFN,".351","I")
 I 'TDATE S TDATE=DT
 S DATE=$E(TDATE,1,3)
 S AGE=DATE-$E(DOB,1,3)
 S:$E(TDATE,4,7)<$E(DOB,4,7) AGE=AGE-1
 I AGE<3 D
 .S DAYS=$$FMDIFF^XLFDT(TDATE,DOB,1)
 .I DAYS<7 S AGE=DAYS_"d" Q
 .I DAYS<30 S AGE=DAYS\7_"w" Q
 .S AGE=DAYS\30_"m"
 Q AGE
HDR(HEADER,PAGE) ; EP - Print page number and center data.
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
HDR3 ; EP - Print a dashed line.
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
