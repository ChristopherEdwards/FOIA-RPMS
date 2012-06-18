ABPAPCLG ;PRINT DAILY CHECK LOG; [ 07/10/91  1:31 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 W !!,"<<< NOT AN ACCESS POINT - JOB ABORTED >>>",!! Q
 ;--------------------------------------------------------------------
CLEAR ;PROCEDURE TO KILL TEMPORARY LOCAL VARIABLES
 K L,DIC,BY,FROM,TO,X,Y,DHD,%DT,ABPADT,ABPAPG,ABPA("IO"),FINAL,DIR,DA2
 K ZTSK,ZTRTN,ZTDESC,ZTSAVE,ABPA("INS")
 K ABPA("CNUM"),ABPA("CAMT"),ABPA("SUM"),ABPA("CNT")
 Q
 ;--------------------------------------------------------------------
HEAD ;PROCEDURE TO DRAW SCREEN HEADING
 S ABPAHD1="Print DAILY CHECK TRANSMITTAL" D HEADER^ABPAMAIN
 Q
 ;--------------------------------------------------------------------
ACCT ;PROCEDURE TO GET ACCOUNTING POINT
 K DIC S DIC="^ABPACHKS(",DIC(0)="AEQZ",NOACCT=0
 S DIC("A")="Select ACCOUNTING POINT: " W !! D ^DIC I +Y<1 S NOACCT=1
 E  S ACCTPT=$P(Y(0,0),"^"),DA2=+Y
 Q
 ;--------------------------------------------------------------------
DATE ;PROCEDURE TO GET LOG DATE TO USE
 K ABPADT S %DT="AEPX",%DT("A")="Select LOG DATE: "
 S Y=DT D DD^%DT S %DT("B")=Y W ! D ^%DT Q:+Y'>0  S ABPADT=+Y
 I $D(^ABPACHKS("TR",ABPADT,"N",DA2))'=10 D  G DATE
 .W *7,!?5,"<<< NO UNREPORTED CHECKS FOUND FOR THIS DATE >>>"
 Q
 ;--------------------------------------------------------------------
TYPE ;PROCEDURE TO GET TYPE OF RUN
 K DIR S DIR(0)="SB^D:DRAFT;F:FINAL",DIR("A")="TYPE OF RUN",FINAL=0
 S DIR("?",1)="Select either DRAFT or FINAL mode.  DRAFT mode will"
 S DIR("?",2)="allow you to further edit any check entries on the log."
 S DIR("?",3)="Once you print a FINAL copy, you will not be allowed to"
 S DIR("?")="change any of the information on this log."
 S DIR("B")="DRAFT" W ! D ^DIR I Y="F" S FINAL=1
 I FINAL D
 .K DIR S DIR(0)="Y",DIR("B")="NO"
 .S DIR("A")="** FINAL COPY ***  ARE YOU SURE"
 .W !,*7 D ^DIR I Y=0 S FINAL=0
 K DIR Q
 ;--------------------------------------------------------------------
DEVICE ;PROCEDURE TO SELECT PRINTER DEVICE
 K %IS,%ZIS S %IS="PQ",%ZIS("A")="Select DEVICE or [Q]ueue: "
 D ^%ZIS Q:POP  I $D(IO("Q"))=1&($D(IO("S"))=1) D  G DEVICE
 .W ?5,*7,"<<< QUEUING TO A SLAVE PRINTER NOT ALLOWED >>>"
 I $E(IOST)'="P" D  G DEVICE
 .W ?5,*7,"<<< MUST BE A PRINTER TYPE DEVICE >>>"
 I $D(IO("Q")) D  Q
 .S ZTRTN="PRINT^ABPAPCLG",ZTDESC="Print DAILY CHECK TRANSMITTAL"
 .S ZTIO=IO,ZTSAVE("ABPA(")="",ZTSAVE("ACCTPT")="",ZTSAVE("ABPADT")=""
 .S ZTSAVE("FINAL")="",ZTSAVE("DA2")="" D ^%ZTLOAD
 .I $D(ZTSK) D QUEUED^ABPAMAIN
 U IO(0) W ! D WAIT^DICD U IO
 ;--------------------------------------------------------------------
PRINT ;ENTRY POINT - CALLED BY TASKMAN
 ;PROCEDURE TO PRINT THE CURRENT CHECK RECORDS
 K ^TMP("ABPAPCLG",$J,DA2) S ABPA("DTIN")=ABPADT D DTCVT^ABPAMAIN
 S ABPA("SUM")=0,DA(1)=0 F  D  Q:+DA(1)=0
 .S DA(1)=$O(^ABPACHKS("TR",ABPADT,"N",DA2,DA(1))) Q:+DA(1)=0
 .S ABPA("INS")="UNKNOWN" I $D(^ABPACHKS(DA2,"I",DA(1),0))=1 D
 ..S IPTR=^ABPACHKS(DA2,"I",DA(1),0)
 .I $D(^AUTNINS(IPTR,0))=1 S ABPA("INS")=$P(^(0),"^")
 .S DA=0 F  D  Q:+DA=0
 ..S DA=$O(^ABPACHKS("TR",ABPADT,"N",DA2,DA(1),DA)) Q:+DA=0
 ..S ABPADATA=^ABPACHKS(DA2,"I",DA(1),"C",DA,0)
 ..S ABPA("CNUM")=$P(ABPADATA,"^"),ABPA("CAMT")=$P(ABPADATA,"^",4)
 ..S ABPA("SUM")=ABPA("SUM")+ABPA("CAMT")
 ..S ^TMP("ABPAPCLG",$J,DA2,ABPA("INS"),ABPA("CNUM"))=ABPA("CAMT")
 S ABPAPG=0 D ^ABPACLHD
 S ABPA("CNT")=0,ABPA("INS")=0 F  D  Q:ABPA("INS")=""
 .S ABPA("INS")=$O(^TMP("ABPAPCLG",$J,DA2,ABPA("INS")))
 .Q:ABPA("INS")=""  S ABPA("CNUM")=0 F  D  Q:ABPA("CNUM")=""
 ..S ABPA("CNUM")=$O(^TMP("ABPAPCLG",$J,DA2,ABPA("INS"),ABPA("CNUM")))
 ..Q:ABPA("CNUM")=""  S ABPA("CNT")=ABPA("CNT")+1
 ..S ABPA("CAMT")=^TMP("ABPAPCLG",$J,DA2,ABPA("INS"),ABPA("CNUM"))
 ..W !?5,$J(ABPA("DTOUT"),8),?($X+3),ABPA("CNUM"),?33,ABPA("INS"),?65
 ..W $J(ABPA("CAMT"),9,2) I $Y>54 D ^ABPACLHD
 W !?16,"---------------",?65,"---------",!,"TOTAL",?65
 W $J(ABPA("SUM"),9,2),!,"COUNT",?16,ABPA("CNT") D END^ABPACLHD
 U IO(0) X ^%ZIS("C") K ^TMP("ABPAPCLG",$J,DA2)
 Q
 ;--------------------------------------------------------------------
MAIN ;ENTRY POINT - ROUTINE DRIVER
 D CLEAR,HEAD,ACCT I NOACCT D CLEAR Q
 D DATE I $D(ABPADT)'=1 G MAIN
 D TYPE I FINAL I $D(^TMP("ABPACLG1"))=10 D
 .W !!,"Please note: A 'Check Log Corrections Memo' will also be "
 .W "printed  ",!!
 W ! D DEVICE,CLEAR S IOP=$I D ^%ZIS K IOP
 Q
