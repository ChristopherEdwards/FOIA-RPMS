ACHSDSTR ;IHS/OIT/FCJ-DOCUMENT STATUS REPORT BY FY; [ 09/06/2000  2:56 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**26**;JUN 11, 2001;Build 37
 ;3.1*26  IHS/OIT/FCJ NEW RTN
 ;
 ;ACHSRTYP VAR IS SET IN THE MENU OPTION AND WILL PREVENT A THE FILE PROMPT AND DIFFERENT FIELDS
 ;
A ;
 W !!,$$C^XBFUNC("***   DOCUMENT STATUS REPORT  ***",80)
 W !!,$$C^XBFUNC("for  "_$P(^DIC(4,DUZ(2),0),"^"),80)
 S ACHSIO=IO
 D ^ACHSVAR,LINES^ACHSFU,BM^ACHS
A2 ;
 W !!,"Enter the BEGINNING ISSUE DATE for this report: " D READ^ACHSFU Q:$D(DUOUT)!$D(DFOUT)!$D(DTOUT)!$D(DLOUT)  S:$D(DQOUT) Y="?" S X=Y,%DT="XEP" D ^%DT G A2:Y<1 S BDATE=Y I Y>DT W !!,*7,"Do not use future dates." G A2
A3 ;
 W !!,"Enter the ENDING ISSUE DATE for this report: " D READ^ACHSFU Q:$D(DFOUT)!$D(DTOUT)!$D(DLOUT)  G A2:$D(DUOUT) S:$D(DQOUT) Y="?" S X=Y,%DT="XEP" D ^%DT G A3:Y<1 S EDATE=Y I Y>DT W !!,*7,"Do not use future dates." G A3
 G B:BDATE'>EDATE W !!,*7,"INVALID ENTRY - The END is before the BEGINNING." G A2
B ;
 W !!,"Which type of report?",!!,"  1.  OPEN DOCUMENTS only",!,"  2.  CLOSED DOCUMENTS only",!,"  3.  COMBINED list",!!,"  ENTER OPTION (1-3) 3//" D READ^ACHSFU I $D(DLOUT)!(Y="") S Y=3
 G ENDQ:$D(DTOUT)!$D(DFOUT),QUES:$D(DQOUT),A:$D(DUOUT) I "123"[Y&(Y>0)&(Y<4) S TYPE=Y G C
 W !!,*7,"  Enter only a 1, 2, or 3" G B
QUES ;
 W !!,"Choice 1 - only open documents will be listed.",!,"Choice 2 - only documents which have been paid or cancelled will be listed.",!,"Choice 3 - open and closed documents will be listed together." G B
C ;
 W !!,"TYPE OF DATA ON REPORT: ",!!,"  1. TOTALS ONLY",!,"  2. DETAILED DOCUMENTS & TOTALS",!!,"  ENTER 1 or 2:  1//" D READ^ACHSFU I $D(DLOUT)!(Y="") S Y=1
 G ENDQ:$D(DTOUT)!$D(DFOUT),B:$D(DUOUT) I "12"[Y&(Y>0)&(Y<3) S TOTONLY=Y
 I (TOTONLY'=1)&(TOTONLY'=2) W *7,"  ??" H 2 G C
D ;
 W !!,"Enter Fiscal Year (e.g. 2016): " D READ^ACHSFU
 G ENDQ:$D(DTOUT)!$D(DFOUT),C:$D(DUOUT)!$D(DLOUT)
 I Y'?4N W *7,"  ??" H 2 G D
 I '$D(^ACHS(9,DUZ(2),"FY",Y)) U 0 W !!,*7,"NO DATA ON FILE FOR FY!!" H 2 G D
 S TOTFYN=$E(Y,4) S TOTFY=$E(Y,3,4)
FILE ;CREATE A FILE
 I ACHSRTYP=2 S ACHSFIL=0 G DEVICE
 S %=$$DIR^XBDIR("Y","Create a file","N","","","^D HELP^ACHS(""H2"",""ACHSVUR2"")",2)
 G D:$D(DUOUT),ENDQ:$D(DTOUT)
 S ACHSFIL=%
DEVICE ;
 W ! K IOP,%ZIS("B") S %ZIS="PQ" D ^%ZIS K %ZIS I IO="" W !,*7,"No device specified." S IOP=$I D ^%ZIS Q
 I $D(IO("Q"))#2,$E(IOST)'="P" W *7,!,"Please queue to printers only." K IO("Q") G DEVICE
 I $D(IO("Q")) K IO("Q") S ZTRTN="^ACHSDSTR1",ZTDESC="CHS Document Status, Type "_TYPE_", "_$E(BDATE,2,7)_" to "_$E(EDATE,2,7) F G="DUZ(2)","BDATE","EDATE","TYPE","TOTFY","TOTFYN","TOTONLY" S ZTSAVE(G)=""
 I  D ^%ZTLOAD G ENDQ
 I IO=$I G ^ACHSDSTR1
 S IOP=IO D ^%ZIS I 'POP G ^ACHSDSTR1
 W !,*7,"Device ",IO," busy." G DEVICE
ENDQ ;
 K ACHSIO,BDATE,DTOUT,DQOUT,DLOUT,DUOUT,DFOUT,EDATE,X,Y
 Q
