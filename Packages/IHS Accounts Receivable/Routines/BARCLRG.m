BARCLRG ; IHS/SD/LSL - COLLECTION REGISTERS RPTS MAY 30,1996 ; 04/11/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,20**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 05/08/2002 - V1.6 Patch 2 - NOIS HQW-0302-100189
 ;     Modified code to use new header template for REPRINT.
 ;
 ; IHS/SD/LSL - 10/15/02 - V1.7 - HQW-0302-100169
 ;      Modified so that cannot reprint a batch that has not been finalized,
 ;      and that reprinting the batch won't automatically finalize.
 ;
 ; IHS/SD/AML - 12/09/10 - V1.8 P20
 ;      Modified to allow the batch Date Finalized (.25) and User
 ;      Finalized (.26) to be stored when batch is finalized.
 ; *********************************************************************
 ;
START ;**EP-Collections report using FM print
 ;
DT ;EP - DETAIL REPORT
 W $$EN^BARVDF("IOF")
 D ^BARBAN
 W !!
 S BARSEL="D"
 D D
 G:$D(BAREFLG) END
 D PRINT
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
EX ;EP - EXCEPTIONS
 S BARFINS="E"
 D E
 G:$D(BAREFLG) END
 D PRINT
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
FL ;EP - FINAL REPORT
 S BARREPRT=0
 S BARSEL="F"
 D F
 G:$D(BAREFLG) END
 D PRINT
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
REP ;EP - REPRINT FINAL REPORT
 S BARSEL="F"
 S BARREPRT=1
 D R
 G:$D(BAREFLG) END
 D PRINT
 D EOP^BARUTL(1)
 Q
 ; *********************************************************************
 ;
END Q
 ; *********************************************************************
 ;
LOOKUP ;
 ; **Collection Register name lookup
 K DUOUT,DTOUT,BAREFLG
 S DIC="90051.01"
 S DIC(0)="AEMQZ"
 D ^DIC
 K DIC
 S:Y<0 BAREFLG=1
 S:$D(DUOUT) BAREFLG=1
 S:$D(DTOUT) BAREFLG=1
 I $D(BAREFLG) Q
 I Y>0 D
 . S BARBATCH=+Y
 . S BARBEX=$P(Y(0),U)
 Q
 ; *********************************************************************
 ;
PRINT ;EP **Print
 ;
 S DIC="90051.01"
 S L=0
 I $D(BARBEX) D
 . S FR=BARBEX
 . S TO=BARBEX
 S FR=FR_",,"
 S TO=TO_",,"
 D EN1^DIP
 D ^%ZISC,HOME^%ZIS
 Q
 ; *********************************************************************
 ;
D ;**Detail
 S DIC("S")="I $$VAL^XBDIQ1(90051.01,+Y,3)'[""POST"""
 D LOOKUP
 Q:$D(BAREFLG)
D2 ;EP  ;IHS/SD/SDR bar*1.8*4 DD item 4.1.5.1  added line tag
 D DTEND
 S DHD="[BAR CRH DET]"
 S FLDS="[BAR CR DET]"
 S BY="[BAR CRS DT]"
 S DIOEND="I $E(IOST)=""C"" D DTEND^BARCLRG"
 Q
 ; *********************************************************************
 ;
F ;**Final
 I BARREPRT=0 S DIC("S")="I $$VAL^XBDIQ1(90051.01,+Y,3)'[""POST"""
 D LOOKUP
 Q:$D(BAREFLG)
 ;start new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.3
 ;get total of items
 S BARITDA=0,BARITTOT=0
 F  S BARITDA=$O(^BARCOL(DUZ(2),BARBATCH,1,BARITDA)) Q:+BARITDA=0  D
 .;no cancelled or rolled up items
 .Q:$P($G(^BARCOL(DUZ(2),BARBATCH,1,BARITDA,0)),U,17)="R"
 .Q:$P($G(^BARCOL(DUZ(2),BARBATCH,1,BARITDA,0)),U,17)="C"
 .S BARITTOT=+$G(BARITTOT)+$P($G(^BARCOL(DUZ(2),BARBATCH,1,BARITDA,1)),U)
 S BARATDN=$P($G(^BAR(90051.02,DUZ(2),$P($G(^BARCOL(DUZ(2),BARBATCH,0)),U,2),0)),U,22)
 I $G(BARATDN)=1,(+$P($G(^BARCOL(DUZ(2),BARBATCH,0)),U,29)'=(+BARITTOT)) D  Q
 .W !!,"The batch total of $",$FN($P($G(^BARCOL(DUZ(2),BARBATCH,0)),U,29),",",2)," doesn't equal the items total of $",$FN(BARITTOT,",",2),"."
 .W !,"Either add item(s) or edit the batch amount to balance.  Batch can not be"
 .W !,"finalized until these balance."
 .S BAREFLG=1
 .W ! K DIR S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 I $G(BARATDN)=1,(+$P($G(^BARCOL(DUZ(2),BARBATCH,0)),U,29)=(+BARITTOT)) W !!,"The batch total and the items total balance at $",$FN(BARITTOT,",",2)," for TDN ",$P($G(^BARCOL(DUZ(2),BARBATCH,0)),U,28),".",!
 ;end new code IHS/SD/SDR bar*1.8*4 DD item 4.1.5.3
 I BARREPRT=0 D
 .K DIR S DIR(0)="Y"
 .S DIR("A")="ARE YOU SURE YOU WANT TO FINALIZE THIS BATCH"
 .S DIR("B")="NO"
 .D ^DIR
 .K DIR
 .I Y="0" S BAREFLG=1 Q
 I $G(BAREFLG)=1 Q
 S DHD="[BAR CRH FIN]"
 S:BARREPRT=1 DHD="[BAR CRH RPRNT FIN]"
 S BY="[BAR CRS FIN]"
 S FLDS="[BAR CR FIN]"
 S DIOEND="D FLEND^BARCLRG"
 Q
 ; *********************************************************************
 ;
R ;**Reprint Final
 S DIC("S")="I $$VAL^XBDIQ1(90051.01,+Y,3)[""POST"""
 D LOOKUP
 Q:$D(BAREFLG)
 S DHD="[BAR CRH RPRNT FIN]"
 S BY="[BAR CRS FIN]"
 S FLDS="[BAR CR FIN]"
 S DIOEND="D FLEND^BARCLRG"
 Q
 ; *********************************************************************
 ;
E ;**Exceptions
 D LOOKUP
 Q:$D(BAREFLG)
 S DHD="[BAR CRH EXC]"
 S BY="[BAR CRS EXC]"
 S FLDS="[BAR CR EXC]"
 Q
 ; *********************************************************************
 ;
FLEND ;**End of Final Report -- Summary Page and Postable Batch Status
 D EOP^BARUTL(1)
 I $Y+20>IOSL W $$EN^BARVDF("IOF")
 W !!,"DATE:"
 I BARREPRT=1 W ?25,"COLLECTIONS REPORT -- FINAL (REPRINT)"
 E  W ?25,"COLLECTIONS REPORT -- FINAL"
 W ?70,"SUMMARY"
 W !,$$MDT2^BARDUTL(DT)
 W !!!,"Collections listed above for Batch: "
 W $$VAL^XBDIQ1(90051.01,BARBATCH,.01),!,"totaling: "
 W $J($FN($$GET1^DIQ(90051.01,BARBATCH,15),",",2),10)
 W "  are transmitted herewith for appropriate action."
 W !!,?50,$P(^VA(200,DUZ,0),U)
 W !,?50,$$VAL^XBDIQ1(200,DUZ,29)
 W !,?50,$P(^DIC(4,DUZ(2),0),U)
 W !!!,"RECEIPT FOR $ ________________ IS HEREBY ACKNOWLEDGED."
 W !!!,?55,"___________________",!,?55,"FINANCIAL MANAGEMENT"
 I BARREPRT=0 D
 . S DIE="90051.01"
 . S DA=BARBATCH
 . ;S DR="3///POSTABLE"  ;IHS/SD/AML 12/9/2010 bar*1.8*20 - Populates the Finalized Date & User
 . S DR="3///POSTABLE;25///NOW;26///^S X=DUZ"  ;IHS/SD/AML bar*1.8*20 - Populates the Finalized Date & User
 . S DIDEL=90050
 . D ^DIE
 . K DIDEL
 I BARREPRT=0 D EN^BARCBTR(BARBATCH)
 Q
 ; *********************************************************************
 ;
DTEND ;
 ;**Detail end -- ask if batch is to be made Postable
 S BARSTAT=$$VAL^XBDIQ1(90051.01,BARBATCH,3)
 I BARSTAT="POSTABLE" W !,"This Batch already in Postable Status!"
 I BARSTAT="REVIEW" W !,"This Batch already in Review Status!"
 I BARSTAT="OPEN" D STATUS
 Q
 ; *********************************************************************
 ;
STATUS ;
 K DIR
 S DIR(0)="Y"
 S DIR("A")="DO YOU WISH TO PUT THIS BATCH IN REVIEW STATUS"
 S DIR("B")="NO"
 D ^DIR
 K DIR
 I Y="1" D
 .S DIE="90051.01"
 .S DA=BARBATCH
 .S DR="3///REVIEW"
 .S DIDEL=90050
 .D ^DIE
 .K DIDEL
 Q
