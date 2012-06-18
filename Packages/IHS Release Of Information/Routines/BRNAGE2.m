BRNAGE2 ; IHS/OIT/LJF - ROI AGING REPORT (BY STAFF ASSIGNMENT) ; 
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 10/11/2007 PATCH 1  Added this routine - new report & driver
 ;
DRIVER ;EP; entry point from new option
 ; driver calls all 3 aging reports
 NEW DIR,Y,RPT
 W !,"ROI AGING REPORTS"
 S DIR(0)="S^1:By Request STATUS;2:By AGING Range;3:By STAFF Assignment;4:By PURPOSE",DIR("A")="Select a Report"
 K DA D ^DIR K DIR
 Q:$D(DIRUT)  Q:Y<1
 S RPT=$S(Y=1:"ASK1^BRNAGE",Y=2:"ASK^BRNAGE1",Y=3:"ASK^BRNAGE2",1:"ASK2^BRNAGE2") D @RPT
 Q
 ;
ASK ;EP - Restrict a Certain Staff Assignment
 S BRNSTBD="",BRNSTED=""
 W ! S DIR(0)="Y0",DIR("A")="Would you like to run this report for ONLY a particular staff member",DIR("B")="NO"
 S DIR("?")="To RESTRICT to a particular STAFF ASSIGNMENT  - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) END
 I 'Y G PRINT
 ;
STAFF ;ROI Staff Assignment
 S DIR(0)="90264,.11",DIR("A")="Select STAFF ASSIGNED"
 K DA D ^DIR K DIR
 G:$D(DIRUT) ASK
 S BRNSTBD=+Y,BRNSTED=+Y
 ;
 ;
PRINT ;PRINT Report by staff assignment
 ;
 ;select facility
 NEW BRNFAC D ASKFAC^BRNU(.BRNFAC) I BRNFAC="" D END Q
 ;
 ;set up print
 S FLDS="[BRN GS AGING RPT]",BY(0)="^BRNREC(""AH"",",DIC="^BRNREC(",L=0,L(0)=2
 S FR(0,1)=BRNSTBD,TO(0,1)=BRNSTED
 I BRNFAC>0 S DIS(0)="I $P(^BRNREC(D0,0),U,22)=BRNFAC"
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
END ;
 K BRNSTBD,BRNSTED,DD0,B,X,BRNPURB,BRNPURE
 Q
 ;
ASK2 ;EP - Restrict to a certain PURPOSE
 S BRNPURB="",BRNPURE=""
 W ! S DIR(0)="Y0",DIR("A")="Would you like to run this report for ONLY one PURPOSE",DIR("B")="NO"
 S DIR("?")="To RESTRICT to a particular PURPOSE  - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) END
 I 'Y G PRINT2
 ;
PURPOSE ;ROI Staff Assignment
 S DIR(0)="90264,.07",DIR("A")="Select PURPOSE"
 K DA D ^DIR K DIR
 G:$D(DIRUT) ASK2
 S BRNPURB=$P(Y,U),BRNPURE=$P(Y,U)
 ;
 ;
PRINT2 ;PRINT report by purpose
 ;
 ;select facility
 NEW BRNFAC,BRNFACN D ASKFAC^BRNU(.BRNFAC) I BRNFAC="" D END Q
 I BRNFAC>0 S BRNFACN=$$GET1^DIQ(90264.2,BRNFAC,.01)
 ;
 ;set up print
 S FLDS="[BRN GS AGING RPT]",BY="FACILITY;S1,.07",DIC="^BRNREC(",L=0
 I BRNFAC=0 S FR="@,"_BRNPURB,TO="ZZZ,"_BRNPURE
 E  S FR=BRNFACN_","_BRNPURB,TO=BRNFACN_","_BRNPURE
 K DHIT,DIOEND,DIOBEG
 D EN1^DIP
 G END
