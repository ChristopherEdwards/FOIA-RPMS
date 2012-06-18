DGENRPD2 ;ALB/CJM -Veteran with Future Appts and no Enrollment App Report - Continued; May 18,1999
 ;;5.3;Registration;**147,232**;Aug 13,1993
 ;
PRINT ;
 N CRT,QUIT,PAGE,SUBSCRPT
 K ^TMP($J)
 S QUIT=0
 S PAGE=0
 S CRT=$S($E(IOST,1,2)="C-":1,1:0)
 ;
 D GETPAT
 U IO
 I CRT,PAGE=0 W @IOF
 S PAGE=1
 D HEADER
 F SUBSCRPT="STEP2","NOENREC" D
 .D PATIENTS(SUBSCRPT)
 I CRT,'QUIT D PAUSE
 I $D(ZTQUEUED) S ZTREQ="@"
 D ^%ZISC
 ;
 K ^TMP($J)
 Q
LINE(LINE) ;
 ;Description: prints a line. First prints header if at end of page.
 ;
 I CRT,($Y>(IOSL-4)) D
 .D PAUSE
 .Q:QUIT
 .W @IOF
 .D HEADER
 .W LINE
 ;
 E  I ('CRT),($Y>(IOSL-2)) D
 .W @IOF
 .D HEADER
 .W LINE
 ;
 E  W !,LINE
 Q
 ;
GETPAT ;
 ;Description: Gets patients to include in the report
 N DIVISION,CLINIC,APPT,DFN,TIME,STATUS,CATEGORY
 ;
 ;STEP 1 - make list in format ^TMP($J,"STEP1",<DFN>,<APPT IEN>,<DIVISIONIEN>,<CLINIC IEN>)
 I DGENRP("ALL") D
 .S CLINIC=0
 .F  S CLINIC=$O(^SC(CLINIC)) Q:'CLINIC  D
 ..I $P($G(^SC(CLINIC,0)),"^",3)="C" D APPT(CLINIC,DGENRP("BEGIN"),DGENRP("END"))
 I $O(DGENRP("DIVISION",0)) D
 .S CLINIC=0
 .F  S CLINIC=$O(^SC(CLINIC)) Q:'CLINIC  D
 ..S NODE=$G(^SC(CLINIC,0))
 ..S DIVISION=$P(NODE,"^",15)
 ..Q:'DIVISION
 ..I $P(NODE,"^",3)="C",$D(DGENRP("DIVISION",DIVISION)) D APPT(CLINIC,DGENRP("BEGIN"),DGENRP("END"))
 I $O(DGENRP("CLINIC",0)) D
 .S CLINIC=0
 .F  S CLINIC=$O(DGENRP("CLINIC",CLINIC)) Q:'CLINIC  D
 ..D APPT(CLINIC,DGENRP("BEGIN"),DGENRP("END"))
 ;
 ;
 ;STEP 2 - make list in following formats
 ;^TMP($J,"STEP2",DIVISION NAME,CLINIC NAME,CATEGORY,APPT DT/TM,DFN)
 ;
 ;for patients without enrollment records
 ;^TMP($J,"NOENREC",DIVISION NAME,CLINIC NAME,CATEGORY,APPT DT/TM,DFN)
 ;
 S DFN=0
 F  S DFN=$O(^TMP($J,"STEP1",DFN)) Q:'DFN  D
 .S STATUS=$$STATUS^DGENA(DFN)
 .S CATEGORY=$$CATEGORY^DGENA4(DFN)
 .;
 .;don't include enrolled veterans or ones that have pending apps!
 .I (CATEGORY="E")!(CATEGORY="P") Q
 .;
 .;exclude if not an eligible veteran (can not enroll)
 .Q:'$$VET^DGENPTA(DFN)
 .;
 .S TIME=0
 .F  S TIME=$O(^TMP($J,"STEP1",DFN,TIME)) Q:'TIME  D  Q:DGENRP("JUSTONCE")
 ..S DIVISION=""
 ..F  S DIVISION=$O(^TMP($J,"STEP1",DFN,TIME,DIVISION)) Q:(DIVISION="")  D
 ...S CLINIC=0
 ...F  S CLINIC=$O(^TMP($J,"STEP1",DFN,TIME,DIVISION,CLINIC)) Q:'CLINIC  D
 ....N DIVNAME,CLNAME
 ....S DIVNAME=$S(DIVISION:$P($$SITE^VASITE(TIME\1,DIVISION),"^",2),1:" ")
 ....S CLNAME=$P($G(^SC(CLINIC,0)),"^")
 ....S:CLNAME="" CLNAME=" "
 ....I $$FINDCUR^DGENA(DFN)="" D  Q
 ..... S ^TMP($J,"NOENREC",DIVNAME,CLNAME,CATEGORY,TIME,DFN)=""
 ....S ^TMP($J,"STEP2",DIVNAME,CLNAME,CATEGORY,TIME,DFN)=STATUS_"^"_$P($G(^TMP($J,"STEP1",DFN,TIME,DIVISION,CLINIC)),"^",16)
 Q
 ;
APPT(CLINIC,BEGIN,END) ;
 ;Description: Lists all the appointments for given clinic with date range
 ;
 N TIME,APPT,DFN,LOCNODE,PATNODE,DIVISION
 S END=END+.1
 S TIME=BEGIN-.1
 S DIVISION=$P($G(^SC(CLINIC,0)),"^",15)
 F  S TIME=$O(^SC(CLINIC,"S",TIME)) Q:(('TIME)!(TIME>END))  D
 .S APPT=0
 .F  S APPT=$O(^SC(CLINIC,"S",TIME,1,APPT)) Q:'APPT  D
 ..S LOCNODE=$G(^SC(CLINIC,"S",TIME,1,APPT,0))
 ..S DFN=$P(LOCNODE,"^")
 ..Q:'DFN
 ..S PATNODE=$G(^DPT(DFN,"S",TIME,0))
 ..;
 ..;clinic from the Patient file appointment multiple should match
 ..Q:((+PATNODE)'=CLINIC)
 ..;
 ..;exclude certain appointment statuses
 ..Q:"^N^NA^C^CA^PC^PCA^"[("^"_$P(PATNODE,"^",2)_"^")
 ..;
 ..S:'DIVISION DIVISION=$O(^DG(40.8,0))
 ..S ^TMP($J,"STEP1",+DFN,+TIME,+DIVISION,+CLINIC)=PATNODE
 Q
 ;
HEADER ;
 ;Description: Prints the report header.
 ;
 N LINE
 I $Y>1 W @IOF
 W !,"Appointments for Veterans with no Enrollment Application"
 W:DGENRP("BEGIN") ?70,"Date Range: "_$$FMTE^XLFDT(DGENRP("BEGIN"))_" to "_$$FMTE^XLFDT($G(DGENRP("END")))
 W ?120,"Page ",PAGE
 S PAGE=PAGE+1
 W !
 W ?70," Run Date: "_$$FMTE^XLFDT(DT)
 W !
 ;
 W !,"Name",?39,"PatientID",?57,"DOB",?70,"Appt Dt/Tm",?90,"EnrollStatus",?121,"Enroll Cat"
 S $P(LINE,"-",132)="-"
 W !,LINE,!
 Q
 ;
PAUSE ;
 ;Description: Screen pause.  Sets QUIT=1 if user decides to quit.
 ;
 N DIR,X,Y
 F  Q:$Y>(IOSL-3)  W !
 S DIR(0)="E"
 D ^DIR
 I ('(+Y))!$D(DIRUT) S QUIT=1
 Q
 ;
PATIENTS(SUBSCRPT) ;
 ;Description: Prints list of patients
 ;
 N NODE,DIVISION,CLINIC,TIME,PATIENT,DGPAT,APPTYPE,ENRSTAT,CATEGORY
 ;
 ;
 S DIVISION=""
 F  S DIVISION=$O(^TMP($J,SUBSCRPT,DIVISION)) Q:DIVISION=""  D  Q:QUIT
 .D LINE("  ") Q:QUIT
 .D LINE($$LJ(" ",40)_"DIVISION: "_DIVISION) Q:QUIT
 .D LINE("  ") Q:QUIT
 .S CLINIC=""
 .F  S CLINIC=$O(^TMP($J,SUBSCRPT,DIVISION,CLINIC)) Q:CLINIC=""  D  Q:QUIT
 ..D LINE("  ") Q:QUIT
 ..D LINE("CLINIC: "_$$LJ(CLINIC,40)_$$LJ(" ",40)_"DIVISION: "_DIVISION)
 ..Q:QUIT
 ..S CATEGORY=""
 ..F  S CATEGORY=$O(^TMP($J,SUBSCRPT,DIVISION,CLINIC,CATEGORY)) Q:CATEGORY=""  D  Q:QUIT
 ...D LINE(" ") Q:QUIT
 ...S TIME=0
 ...F  S TIME=$O(^TMP($J,SUBSCRPT,DIVISION,CLINIC,CATEGORY,TIME)) Q:'TIME  D  Q:QUIT
 ....S DFN=0
 ....F  S DFN=$O(^TMP($J,SUBSCRPT,DIVISION,CLINIC,CATEGORY,TIME,DFN)) Q:'DFN  D  Q:QUIT
 .....S NODE=$G(^TMP($J,SUBSCRPT,DIVISION,CLINIC,CATEGORY,TIME,DFN))
 .....S ENRSTAT=$P(NODE,"^")
 .....S APPTYPE=$P(NODE,"^",2)
 .....Q:'$$GET^DGENPTA(DFN,.DGPAT)
 .....S LINE=$$LJ(DGPAT("NAME"),37)_" "_$$LJ(DGPAT("PID"),15)_" "
 .....S LINE=LINE_$$LJ($$DATE(DGPAT("DOB")),12)_"  "
 .....S LINE=LINE_$$LJ($$DATE(TIME),20)
 .....S LINE=LINE_"  "_$$LJ($S(ENRSTAT="":"NO ENROLLMENT RECORD",1:$$EXT^DGENU("STATUS",ENRSTAT)),28)
 .....S LINE=LINE_$$LJ(" ",2)_$$EXTCAT^DGENA4(CATEGORY)
 .....D LINE(LINE)
 .....Q:QUIT
 Q
 ;
DATE(DATE) ;
 Q $$FMTE^XLFDT(DATE,"1")
 ;
LJ(STRING,LENGTH) ;
 Q $$LJ^XLFSTR($E(STRING,1,LENGTH),LENGTH)
