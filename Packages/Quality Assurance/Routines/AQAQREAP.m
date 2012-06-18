AQAQREAP ;IHS/ANMC/LJF - PENDING REAPPOINTMENTS; [ 01/07/94  10:57 AM ]
 ;;2.2;STAFF CREDENTIALS;**5**;01 OCT 1992
 ;
 ;****> prints summary for all pending reappointment applications
 W @IOF,!!?20,"PENDING REAPPOINTMENT APPLICATIONS",!!
 W ?5,"This report will print summaries on each provider whose"
 W !,"reappointment application is due, not completed or overdue."
 W !,"The summaries will print in alphabetical order.",!!
 ;
 K DIR S DIR(0)="N0:1:12",DIR("B")=1
 S DIR("A")="Print Reappointments to come due how many months from now?"
 S DIR("?",1)="Enter 0 (zero) to see only those due NOW;"
 S DIR("?",2)="Enter 1 to see those due in the coming month;"
 S DIR("?",3)="Enter 2 to see those due in the next 2 months;"
 S DIR("?",4)="And so on up to 12 months."
 S DIR("?")="All reports include those currently OVERDUE"
 D ^DIR G END:$D(DIRUT)
 S X1=DT,X2=Y*30 D C^%DTC
 S X1=X,X2=-730 D C^%DTC S AQAQDUE=X
 ;
 ;***> select type of report
TYPE K DIR S DIR("A",1)="Select Sorting Order for Report:"
 S DIR("A",2)="     1.  ALPHABETICALLY (By Provider Name)"
 S DIR("A",3)="     2.  By PROVIDER CLASS"
 S DIR("A",4)="     3.  By STAFF CATEGORY"
SELECT S DIR("A")="Select (1, 2, or 3):  ",DIR(0)="NAO^1:3" D ^DIR
 G END:$D(DTOUT),END:X="",END:$D(DUOUT),TYPE:Y=-1 S AQAQTYP=Y
 I AQAQTYP=1 S AQAQSRT="" G DEV
 ;
ALL ;***> choose one or all classes or categories
 K DIR S DIR(0)="Y"
 S DIR("A")=$S(AQAQTYP=2:"Print for All Classes",1:"Print for All Categories")
 S DIR("B")="NO" D ^DIR I Y=1 S AQAQSRT="ALL" G DEV ;all wards or serv
 I $D(DIRUT) G END ;check for timeout,"^", or null
 ;
ONE ;***> choose which class or category to print
 I AQAQTYP=2 D  G END:'$D(AQAQSRT) G DEV
 .K DIR,AQAQSRT S DIR(0)="PO^7:EMQZ" D ^DIR
 .Q:$D(DTOUT)  Q:X=""  Q:$D(DUOUT)  Q:Y=-1
 .I $D(^DIC(42,+Y,"I")),$P(^("I"),U)="I" W ?40,"** INACTIVE WARD **" Q
 .S AQAQSRT=Y
 E  D  G END:'$D(AQAQSRT)
 .K DIR,AQAQSRT S DIR(0)="9002165,.02" D ^DIR
 .Q:$D(DTOUT)  Q:X=""  Q:$D(DUOUT)  Q:Y=-1
 .S AQAQSRT=Y
 ;
DEV S %ZIS="NPQ" D ^%ZIS G END:POP I '$D(IO("Q")) G REAP1
 K IO("Q") S ZTRTN="REAP1^AQAQREAP",ZTDESC="PENDING REAPPOINTMENTS"
 F AQAQI="AQAQDUE","AQAQTYP","AQAQSRT" S ZTSAVE(AQAQI)=""
 D ^%ZTLOAD K ZTSK,AQAQDUE,AQAQTYP,AQAQSRT D ^%ZISC Q
 ;
REAP1 ;**> set variables then call FileMan print
 S L=0,DIC=9002165,FLDS="[AQAQINQUIRE]",IOP=ION
 S BY="@NAME",(TO,FR)="" ;alphabetical list
 I AQAQTYP=2 S BY="@NAME:CLASS,@NAME" I +AQAQSRT S (TO,FR)=$P(AQAQSRT,U,2)
 I AQAQTYP=3 S BY="@STAFF CATEGORY,@NAME" I AQAQSRT'="ALL" S TO=Y(0)_"Z",FR=Y(0) ;IHS/OKCRDC/BJH 10/5/93 PATCH 5
 S DIS(0)="D ^AQAQDUE I AQAQLAST<AQAQDUE"
 D EN1^DIP
 I '$D(ZTQUEUED) K DIR S DIR(0)="E",DIR("A")="RETURN to continue" D ^DIR W @IOF
END W @IOF D ^%ZISC D KILL^AQAQUTIL Q
