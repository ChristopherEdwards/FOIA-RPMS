ATXLABA ; IHS/OHPRD/TMJ -  TAXONOMY FOR ICD9 CODES INTO ICD DIAG FILE ;  
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ; -- ADD A NEW TAXONOMY OR ADD CODES TO A TAXONOMY
 ;
START ;
 W !,"It is recommended that you have one of the laboratory personnel assist you"
 W !,"when entering this data.",!!
 S DIC="^ATXLAB(",DIC(0)=$S('$D(ATXTXNM):"AEMQL",1:"EMQL"),DIC("DR")="",DLAYGO=9002228 D ^DIC K DIC,DLAYGO
 Q:Y=-1
 S ATXX=+Y
 ;DO DIQ DISPLAY HERE!!
 S %H=$H D YX^%DTC S ATXTIME=X_%
 S DIE="^ATXLAB(",DR="[ATX ADD LAB TAXONOMY]",DA=ATXX D ^DIE K DIE,DR,ATXTIME
 I '$O(^ATXLAB(ATXX,21,0)) S ATXSTP=1 Q
 Q
 ;
EN ;EP - CALLED FROM OPTION
 I '$D(ATXTXNM) W !!,"Error - missing DM AUDIT Lab Taxonomy name!" Q
 W !!,"You are creating/editing the ",ATXTXNM," Lab Taxonomy.",!
 I $D(^ATXLAB("B",ATXTXNM)) W !,"CURRENT DEFINITION: ",! S DA=$O(^ATXLAB("B",ATXTXNM,0)),DIC="^ATXLAB(" D EN^DIQ K DIC,DA,DR
 S X=ATXTXNM
 D START
 D XIT
 Q
XIT ;
 K ATXSTP,ATXTXNM,ATXTXBD
 Q
 ;
 ;
