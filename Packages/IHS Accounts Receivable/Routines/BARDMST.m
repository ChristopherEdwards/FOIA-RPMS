BARDMST ;IHS/OIT/FCJ - DEBT MANAGEMENT STATUS EDIT
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**22**;OCT 26, 2005;Build 38
 ;New routine 5-12-2011 for Debt Letter Management
 ;
 ;Edit status of Debt Management Bills for printing letters
 ;
ST ;
 W !,"Edit status of Debt Management Bills for printing letters"
 W !,"If status changes to Suspended you must enter a comment.",!!
 D SEL
 G:BARQ XIT
 D:BARST'=BARST1 COM,LETST
 G XIT
 Q
XIT ;
 K DIC,DIE,DR,DA
 Q
 ;
SEL ;SELECT and EDIT DM BILL
 D SEL^BARDMU
 Q:BARQ=1
 ;Test for comments
 S L=0 F  S L=$O(^BARDM(DUZ(2),BARDM,50,L)) Q:L'?1N.N  D
 .Q:$P(^BARDM(DUZ(2),BARDM,50,L,0),U,3)'="S"
 .W !!,"* This bill has a comment for being previously suspended,"
 .W !,"to review use option: Print the Debt Management Bill Status Comments",!
 S BARST=$P(^BARDM(DUZ(2),BARDM,0),U,2)
 S DA=BARDM,DR=".02"
 D ^DIE
 S BARST1=$P(^BARDM(DUZ(2),BARDM,0),U,2)
 S:(BARST'=BARST1)&(BARST1="S") BARREQ=1
 Q
COM ;
 ;ADD SUB ENTRY
 S DA(1)=BARDM
 ;S DIC="^BARDM("_DUZ(2)_","_BARDM_",50,",DIC(0)="L",X=DT  ;bar*1.8*22 SDR make date/time for comments
 ;start new code bar*1.8*22 SDR
 D NOW^%DTC
 S X=%
 S DIC="^BARDM("_DUZ(2)_","_BARDM_",50,",DIC(0)="L"
 ;end new code bar*1.8*22 SDR
 S DIC("P")=$P(^DD(90053.05,50,0),U,2)
 D FILE^DICN
 S:+Y>0 DA=+Y
 I +Y<0 W !,"ERROR ADDING STATUS COMMENTS ENTRY " Q
 S DIE=DIC
 S DR=".02///"_DUZ_";.03///"_BARST1
 D ^DIE
COM1 ;COMMENT
 S DR=1
 D ^DIE
 ;I BARREQ=1,X="NO" W !,"COMMENT REQUIRED FOR SUSPENDED BILLS" G COM1  ;bar*1.8*22 SDR
 I BARREQ=1,(X="NO"!(X["^")) W !,"COMMENT REQUIRED FOR SUSPENDED BILLS" G COM1  ;bar*1.8*22 SDR
 Q
LETST ;LETTER STATUS
 S BARDMC=0,BARCYL=0
 F  S BARDMC=$O(^BARDM(DUZ(2),BARDM,100,BARDMC)) Q:BARDMC'?1N.N  S BARCYL=BARDMC
 S BARCYST=$S(BARST1="A":"Q",1:"N")
 S (DIC,DIE)="^BARDM(DUZ(2),"_BARDM_",100,",DA(1)=BARDM,DA=BARCYL
 S DR=".03///"_BARCYST
 D ^DIE
 K DIE,DIC,DA
 Q
