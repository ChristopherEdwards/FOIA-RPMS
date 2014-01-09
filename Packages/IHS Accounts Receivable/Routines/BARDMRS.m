BARDMRS ;IHS/OIT/FCJ - DEBT MANAGEMENT STATUS REPORT
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**22**;OCT 26, 2005;Build 38
 ;New routine 5-12-2011 for Debt Letter Management
 ;
 ;PRINT status of Debt Management Bill
 ;
ST ;
 W !,"Print comments for Bill which status was changed by someone"
 D SEL
 G:+Y<1 XIT
 D PRT
 Q
XIT ;
 K DIC,DIE,DR,DA
 ;K L,L1,L2,L3  ;bar*1.8*22 SDR
 K BARL,BARL1,BARL2,BARL3  ;bar*1.8*22 SDR
 Q
 ;
SEL ;SELECT and EDIT DM BILL
 S BARREQ=0
 S (DIE,DIC)="^BARDM("_DUZ(2)_","
 S DIC("A")="Enter the Debt Management Bill: "
 S DIC(0)="AEQ"
 D ^DIC
 Q:+Y<1
 S BARDM=+Y
 Q
PRT ;
 S BARBILN=$$VAL^XBDIQ1(90053.05,BARDM,.01)
 S BARST=$$VAL^XBDIQ1(90053.05,BARDM,.02)
 W @IOF,! F I=1:1:80 W "*"
 W !,"Bill Number: ",BARBILN,?40,"Current Bill Status: ",BARST,!
 F I=1:1:80 W "*"
 ;start old code bar*1.8*22 SDR
 ;S L=0
 ;F  S L=$O(^BARDM(DUZ(2),BARDM,50,L)) Q:L'?1N.N  D  Q:$G(BARDLQ)
 ;.S Y=$P(^BARDM(DUZ(2),BARDM,50,L,0),U) D DD^%DT S BARDT=Y
 ;.S BARUSR=$$VAL^XBDIQ1(200,$P(^BARDM(DUZ(2),BARDM,50,L,0),U,2),.01)
 ;.S BARST1=$P(^BARDM(DUZ(2),BARDM,50,L,0),U,3)
 ;.I $Y>(IOSL-6) D RTRN^BARDMU Q:$G(BARDLQ)  W @IOF
 ;.W !,"Comment Date: ",BARDT,?30,"Status: ",BARST1,?45,"Changed by: ",BARUSR
 ;.W !,"Comments:"
 ;.K ^UTILITY($J,"W") S DIWL=3,DIWR=75
 ;.S L1=0 F  S L1=$O(^BARDM(DUZ(2),BARDM,50,L,L1)) Q:L1'?1N.N  D
 ;..S L2=0 F  S L2=$O(^BARDM(DUZ(2),BARDM,50,L,L1,L2)) Q:L2'?1N.N  D
 ;...S X=^BARDM(DUZ(2),BARDM,50,L,L1,L2,0) D ^DIWP
 ;.S X="" D ^DIWP,^DIWW
 ;end old code start new code
 S BARL=0
 F  S BARL=$O(^BARDM(DUZ(2),BARDM,50,BARL)) Q:BARL'?1N.N  D  Q:$G(BARDLQ)
 .S Y=$P(^BARDM(DUZ(2),BARDM,50,BARL,0),U) D DD^%DT S BARDT=Y
 .S BARUSR=$$VAL^XBDIQ1(200,$P(^BARDM(DUZ(2),BARDM,50,BARL,0),U,2),.01)
 .S BARST1=$P(^BARDM(DUZ(2),BARDM,50,BARL,0),U,3)
 .I $Y>(IOSL-6) D RTRN^BARDMU Q:$G(BARDLQ)  W @IOF
 .W !,"Comment DT/TM: ",BARDT,?38,"Status: ",BARST1,?49,"Changed by: ",BARUSR  ;bar*1.8*22 SDR
 .W !,"Comments:"
 .K ^UTILITY($J,"W") S DIWL=3,DIWR=75
 .S BARL1=0 F  S BARL1=$O(^BARDM(DUZ(2),BARDM,50,BARL,BARL1)) Q:BARL1'?1N.N  D
 ..S BARL2=0 F  S BARL2=$O(^BARDM(DUZ(2),BARDM,50,BARL,BARL1,BARL2)) Q:BARL2'?1N.N  D
 ...S X=^BARDM(DUZ(2),BARDM,50,BARL,BARL1,BARL2,0) D ^DIWP
 .S X="" D ^DIWP,^DIWW
 ;end new code
 D:'$G(BARDLQ) RTRN^BARDMU
 Q
