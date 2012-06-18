BKMVDOD ;PRXM/HC/BHS - DUE/OVERDUE REPORT ; 14 Aug 2005  11:16 AM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;
 Q
 ;
EN ; EP - Primary entry point
 N DFN
 D EN1
 Q
 ;
ONE(DFN) ; EP - Entry point from within a patient record - DFN is passed
 D EN1
 Q
 ;
EN1 ; EP - Entry point called by ONE to use existing DFN
 N BKMCT,BKMHDR,BKMPGHD,BKMALL,BKMSEL,BKMBDT,BKMPCAT,BKMI,BKMADD,BKMACRIT
 N BKMSRT,BKMTMP,BKMSUB,BKMRTN,BKMOTH,BKMPTR,BKMTXT
 ;
 K ^TMP("BKMVDOD",$J)
 ;
 ; Check taxonomies - added per bugzilla #1497
 NEW DFLAG
 S DFLAG=1 D EN^BKMVC1
 ; Select patients to review
 S BKMCT=1
 S BKMHDR(BKMCT)="*** HMS DUE/OVERDUE REPORT ***"
 D PGHDR(.BKMHDR)
 S BKMPGHD="Select Patient(s)"
 W !,?IOM-$L(BKMPGHD)\2,BKMPGHD,!
 S BKMALL=$$YNP("Review all ACTIVE register patients",$S($D(DFN):"NO",1:"YES"))
 I BKMALL="^" G XIT1
 I BKMALL S BKMSEL("PAT")="ALL"
 ;I 'BKMALL D:'$G(DFN) PLK^BKMPLKP G:$G(DFN)=""!($G(DFN)=-1) XIT1 H 1 S BKMSEL("PAT")=DFN
 I 'BKMALL D:'$G(DFN) RLK^BKMPLKP() G:$G(DFN)=""!($G(DFN)=-1) XIT1 H 1 S BKMSEL("PAT")=DFN
 ; Select baseline date
 S BKMCT=BKMCT+1
 S BKMHDR(BKMCT)=$S(BKMALL:"All ACTIVE HMS Register Patients",$G(DFN)'="":"Patient = "_$$GET1^DIQ(2,DFN,".01","E"),1:"")
 D PGHDR(.BKMHDR)
 S BKMPGHD="Select Baseline Date"
 W !,?IOM-$L(BKMPGHD)\2,BKMPGHD,!
 S BKMBDT=$$DTSEL()
 I BKMBDT="^"!(+BKMBDT=0) G XIT1
 S BKMSEL("BLDATE")=BKMBDT
 ; Select primary category
 S BKMHDR(1)="*** HMS DUE/OVERDUE REPORT, as of "_$$FMTE^XLFDT(BKMBDT,1)_" ***"
 D PGHDR(.BKMHDR)
 S BKMPGHD="Select Clinical Reminder(s)"
 W !,?IOM-$L(BKMPGHD)\2,BKMPGHD,!
 S BKMPCAT=$$PCAT()
 I BKMPCAT="^" G XIT1
 ; Process BKMPCAT here
 S BKMSEL("REM")=BKMPCAT
 S BKMTXT=$S(BKMPCAT="A":"All",BKMPCAT="E":"Exam",BKMPCAT="IZ":"Immunization",BKMPCAT="T":"Test",BKMPCAT="P":"Patient Education",1:"")_" Clinical Reminders"
 I $L(BKMHDR(BKMCT))+$L(BKMTXT)>76 D
 .S BKMCT=BKMCT+1
 .S BKMHDR(BKMCT)=BKMTXT
 E  S BKMHDR(BKMCT)=BKMHDR(BKMCT)_", "_BKMTXT
ADCR ; Additional criteria
 I BKMALL D  G XIT1:BKMADD="^" G ADCR:BKMACRIT="^"
 .D PGHDR(.BKMHDR)
 .S BKMPGHD="Select Additional Criteria"
 .W !,?IOM-$L(BKMPGHD)\2,BKMPGHD,!
 .S BKMADD=$$YNP("Do you have additional selection criteria (Y/N)","NO")
 .; Select additional criteria
 .S BKMACRIT=""
 .; Removed the following from next executed line after="^" :
 .;        !(BKMACRIT="")!('$D(BKMSEL("OTHER")))
 .; to allow the user to bypass the entry of a secondary selection criteria
 .I BKMADD D  I BKMACRIT="^" Q
 ..S BKMACRIT=$$ACRIT()
 ..I BKMACRIT="^"!(BKMACRIT="") Q
 ..S BKMSUB=BKMACRIT_"^BKMVDOD1" D @BKMSUB
 ..I $D(BKMSEL("OTHER")) S (BKMSRT,BKMSEL("SORT"))=$P(BKMSEL("OTHER"),U,2)
 ; Select sort
 I '$D(BKMSEL("OTHER")) D  I BKMSRT="^"!(BKMSRT="") G XIT1
 .I BKMALL D
 ..D PGHDR(.BKMHDR)
 ..S BKMPGHD="Select Sort"
 ..W !,?IOM-$L(BKMPGHD)\2,BKMPGHD,!
 ..S BKMSRT=$$SORT() Q:BKMSRT="^"!(BKMSRT="")  S BKMSEL("SORT")=BKMSRT
 .I 'BKMALL S BKMSRT="P",BKMSEL("SORT")="P"
 ;
 I $D(BKMSEL("OTHER")) D
 .S BKMOTH=$P(BKMSEL("OTHER"),U,2),BKMPTR=$P(BKMSEL("OTHER"),U,1)
 .S BKMTXT=$S(BKMOTH="PR":"HIV Provider = ",BKMOTH="DP":"DPC Provider = ",BKMOTH="CM":"HIV Case Manager = ",1:"")_$$GET1^DIQ(200,BKMPTR,".01","E")
 .I $L(BKMHDR(BKMCT))+$L(BKMTXT)>76 D
 ..S BKMCT=BKMCT+1
 ..S BKMHDR(BKMCT)=BKMTXT
 .E  S BKMHDR(BKMCT)=BKMHDR(BKMCT)_", "_BKMTXT
 S BKMCT=BKMCT+1
 S BKMHDR(BKMCT)="Sorted by "_$S(BKMSRT="PR":"HIV Provider, Patient",BKMSRT="DP":"DPC Provider, Patient",BKMSRT="CM":"HIV Case Manager, Patient",1:"Patient")
 D PGHDR(.BKMHDR)
 ;
QUE ; Queue report for print/display
 N POP,ZTRTN,ZTDESC,ZTSAVE,%ZIS
 S %ZIS="MQ" D ^%ZIS G:POP XIT1
 I $D(IO("Q")) D  G XIT1
 .S ZTRTN="DQUE^BKMVDOD",ZTSAVE("BKMHDR*")="",ZTSAVE("BKMSEL*")=""
 .S ZTDESC="HMS DUE/OVERDUE REPORT"
 .K IO("Q")
 .D ^%ZTLOAD
 .W !,"REQUEST QUEUED"
 ;
DQUE ; EP - Entry point from queue
 W !,"Compiling report, this may take a moment...",! H 1
 ; Build report data
 D EN^BKMVDOD4(.BKMSEL)
 ; Print report data
 D EN^BKMVDOD8(.BKMSEL,.BKMHDR)
 ;
XIT ; Kill variables and exit
 I IOST["C-",$G(BKMRTN)'="^" D END^BKMVDOD8
 I IOST'["C-" W @IOF
 D ^%ZISC
 ;
XIT1 ; Kill variables
 K ^TMP("BKMVDOD",$J)
 Q
 ;
YNP(PROMPT,DFLT) ; Yes/No question
 N DIR,DTOUT,DUOUT,X,Y
 S DFLT=$G(DFLT)
 S DIR(0)="Y"
 S DIR("A")=PROMPT
 I DFLT="YES"!(DFLT="NO") S DIR("B")=DFLT
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q "^"
 W " (",Y(0),")"
 H 1
 Q $S(+$G(Y)=0:0,1:1)
 ;
DTSEL() ; Prompt for baseline date
 ; Returns Date or '^' for quit flag
 N DIR,DTOUT,DUOUT,X,Y
 S DIR("A")="Enter baseline date"
 ;PRXM/HC/BHS - 11/01/2005 - Modify default external date format to Mon DD, CCYY
 ;S DIR("B")=$$FMTE^XLFDT($$DT^XLFDT(),"5Z")
 S DIR("B")=$$FMTE^XLFDT($$DT^XLFDT(),1)
 S DIR(0)="D"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q "^"
 W " (",$$FMTE^XLFDT(Y,1),")"
 H 1
 Q +$G(Y)
 ;
PCAT() ; Prompt for primary category
 ; Returns Category Code or '^' for quit flag
 N DIR,DTOUT,DUOUT,X,Y
 S DIR(0)="S^A:All;T:Tests;IZ:Immunizations;E:Exams;P:Patient Education"
 S DIR("A")="Enter the letter of your selection "
 S DIR("B")="All"
 S DIR("?")="Enter the letter designation for the category you wish to review"
 S DIR("?",1)="Only one selection can be made at this time"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q "^"
 H 1
 Q $G(Y)
 ;
ACRIT() ; Prompt for additional criteria
 ; Returns criteria code or '^' for quit flag
 N DIR,DTOUT,DUOUT,X,Y
 S DIR(0)="SO^DP:DPC Provider;PR:HIV Provider;CM:HIV Case Manager"
 S DIR("A")="Enter one selection from above list "
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q "^"
 H 1
 Q $G(Y)
 ;
SORT() ; Prompt for sort
 ; Returns Sort or '^' for quit flag
 N DIR,DTOUT,DUOUT,X,Y
 S DIR(0)="S^P:Patient Name;DP:DPC Provider;PR:HIV Provider;CM:HIV Case Manager"
 S DIR("A")="Select sort option"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q "^"
 H 1
 Q $G(Y)
 ;
PGHDR(BKMARR) ; Display selection page header
 N BKMI
 S BKMI=0
 F  S BKMI=$O(BKMARR(BKMI)) Q:'BKMI  D
 .I BKMI=1 W @IOF
 .W !?IOM-$L(BKMARR(BKMI))\2,BKMARR(BKMI)
 .I BKMI=1!($O(BKMARR(BKMI))="") W !
 Q
 ;
