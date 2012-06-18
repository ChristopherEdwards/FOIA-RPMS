AGADDR1 ; IHS/ASDS/EFG - REGISTRATION MAILING LIST PRINT/EDIT (2 OF 2) ;  
 ;;7.1;PATIENT REGISTRATION;**4**;AUG 25,2005
NEWLST ;EP
 I '$D(^AGADLIST(AGLIST,1,0)) S ^(0)="^9009065.05P^"
 S AGV("P3")=+$P(^AGADLIST(AGLIST,1,0),U,3),AGV("P4")=+$P(^(0),U,4)
 W !,"Date Generated : " S Y=$P(^AGADLIST(AGLIST,0),U,2) D DD^%DT W Y,"  Last Updated : " S Y=$P(^AGADLIST(AGLIST,0),U,3) D DD^%DT W Y,"  # Names = ",AGV("P4"),!
 Q:AGV("P4")<1  W ?5,"Do you want to see a list of these names (Y/N) N// " D READ^AG
 Q:$D(DFOUT)!$D(DUOUT)!$D(DTOUT)!$D(DLOUT)!(Y?1"N".E)
NEWLST1 ;Display List of Patients on Screen.
 S R="",AGV("RR")=0,AGV("RX")="" W !!
NEWLST2 S R=$O(^AGADLIST(AGLIST,1,"C",R)) G NEWLSTX:R=""
NEWLST3 S AGV("RX")=$O(^AGADLIST(AGLIST,1,"C",R,AGV("RX"))) G NEWLST2:+AGV("RX")=0
 S AGV("RR")=AGV("RR")+1,AGV("ZR")=$P(^AGADLIST(AGLIST,1,AGV("RX"),0),U)
 I AGV("RR")#2=0 W ?40,$P(^DPT(AGV("ZR"),0),U),! G NEWLST4
 W $P(^DPT(AGV("ZR"),0),U)
NEWLST4 I AGV("RR")#40=0 W !,"Enter ""^"" to Stop List <RETURN> to Continue  " D READ^AG W ! I $D(DUOUT) G NEWLSTX
 G NEWLST3
NEWLSTX Q
VAROLD ;EP
 W !!,"Start with which patient? (RETURN = beginning) " K DIC S DIC("W")="D ^AGSCANP" D SET^AUPNLKZ,PTLK^AG,RESET^AUPNLKZ
 G ^AGADDR:$D(DUOUT),B:'$D(DFN) I '$D(^AGADLIST(AGLIST,1,"B",DFN)) W !!,"This patient is not on the list - try again." G VAROLD
A S AG("START")=$P(^DPT(DFN,0),U)
B W !!,"DO YOU WANT TO PRINT A TEST LABEL?  (Y/N) //Y " D READ^AG
 G ^AGADDR:$D(DTOUT)!$D(DFOUT)!$D(DUOUT),C:$D(DLOUT),QUES:$D(DQOUT),C:Y?1"Y".E,D:Y?1"N".E D YN^AG G B
C D ^%ZIS Q:POP  U IO F I=1:1:3 W AGV("LINE"),!
 W !!! D ^%ZISC
 G B
D W !!,"How many copies of each label? (1 - 5) 1// " D READ^AG S:$D(DLOUT) Y=1 G B:$D(DTOUT)!$D(DFOUT)!$D(DUOUT) I $D(DQOUT)!(+Y>5)!(+Y<1) W !!,"You may make from 1 to 5 copies of each label.",!! G D
 S AG("#")=+Y
DEV S %ZIS="OPQ" D ^%ZIS I POP S IOP=ION D ^%ZIS Q
 G:'$D(IO("Q")) START K IO("Q")
 I $D(IO("S"))!($E(IOST)'="P") W *7,!,"Please queue to system printers." D ^%ZISC G DEV
 X ^%ZOSF("UCI") S ZTRTN="START^AGADDR1",ZTUCI=Y,ZTDESC="Print Mailing List for "_$P(^AUTTLOC(DUZ(2),0),U,2)_"." S:$D(AG("START")) ZTSAVE("AG(""START"")")="" F G="AG(""#"")","AGLIST" S ZTSAVE(G)=""
 D ^%ZTLOAD G:'$D(ZTSK) DEV K AG,G,ZTDESC,ZTRTN,ZTSAVE,ZTSK,ZTUCI D ^%ZISC
 Q
START ;EP - From TaskMan.
 S AGV("RR")=0,AGV("STX")="" I $D(AG("START")) S AGV("STX")=AG("START"),AGV("LC")=$E(AGV("STX"),$L(AGV("STX")),$L(AGV("STX"))),AGV("STX")=$E(AGV("STX"),1,$L(AGV("STX"))-1)_$C($A(AGV("LC"))-1)
E U IO S AGV("STX")=$O(^AGADLIST(AGLIST,1,"C",AGV("STX"))) G END^AGADDR:AGV("STX")=""
E0 S AGV("RR")=$O(^AGADLIST(AGLIST,1,"C",AGV("STX"),AGV("RR"))) G E:AGV("RR")=""
 S DFN=$P(^AGADLIST(AGLIST,1,AGV("RR"),0),U)
 I '$D(^DPT(DFN,0)) G E0
 ;S (AGNAME,AGADRS1,AGADRS2)="",DA=DFN,DR=.01,DIC=2 D ^AGDICLK I $D(AG("LKPRINT")) S AGNAME=$P(AG("LKPRINT"),",",2)_" "_$P(AG("LKPRINT"),",",1)
 S (AGNAME,AGADRS1,AGADRS2)="",DA=DFN,DR=.01,DIC=2 D ^AGDICLK I $D(AG("LKPRINT")) S AGNAME=$P(AG("LKPRINT"),",",2)_" "_$P(AG("LKPRINT"),",",1)_" "_$P(AG("LKPRINT"),",",3)  ;AG*7.1*4
 S DR=.111 D ^AGDICLK I $D(AG("LKPRINT")) S AGADRS1=AG("LKPRINT")
 S DR=.114 D ^AGDICLK I $D(AG("LKPRINT")) S AGADRS2=AG("LKPRINT")
 S DR=.115 D ^AGDICLK I $D(AG("LKDATA")),AG("LKDATA")]"" S AGADRS2=AGADRS2_" "_$P(^DIC(5,AG("LKDATA"),0),U,2)
 S DR=.116 D ^AGDICLK I $D(AG("LKPRINT")) S AGADRS2=AGADRS2_"  "_AG("LKPRINT")
 F AG("I")=1:1:AG("#") W AGNAME,!,AGADRS1,!,AGADRS2,!!!!
 G E0
QUES W !!,"A sample label will be printed so that you",!,"may allign your labels on the printer." G B
