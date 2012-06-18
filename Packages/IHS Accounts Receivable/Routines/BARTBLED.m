BARTBLED ; IHS/SD/LSL - TYPES 'N' CATEGORIES EDIT DEC 4,1996 ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 10/16/02 - HIPAA
 ;       Modified to include new adjustment categories in screen.
 ;
 ; IHS/SD/AML - 11/2/2010 - SENT TO COLLECTION Adjustment codes
 ;	Modified report to include new 'SENT TO COLLECTION' items.
 ; ********************************************************************
 ;
TYPE ;EP
 ; select TYPE and then ENTRY
 W !!
 K DIC
 S DIC="^BAR(90052.01,"
 S DIC(0)="AEQMZ"
 S DIC("A")="TYPE OF TABLE: "
 D ^DIC
 G:Y'>0 EXIT
 S (DA,BARDA1)=+Y
 K DIE
 S DIE=DIC
 S DR=".01"
 I $P(^BAR(90052.01,DA,0),U,2)']"" S DR=DR_";2"
 S DIDEL=90050
 D ^DIE
 K DIDEL,DIE
 ;
SKP ;
 S BARAC=$P(^BAR(90052.01,BARDA1,0),"^",2)
 ;
ENTRY ;
 ; edit ENTRY
 W !!
 ; adjust table entry numbers as to local or distributed
 I ^%ZOSF("PROD")="PRD,DSD" S X=$O(^BARTBL(999),-1),$P(^BARTBL(0),U,3,4)=X_U_X,BARY=1 I 1
 E  S X=1000,$P(^BARTBL(0),U,3,4)=X_U_X,BARY=1000
 K DIC
 S DIC="^BARTBL("
 S DIC(0)="AEQML"
 S DIC("S")="S BARPT=$P(^(0),U,2) I +Y>BARY,(BARPT="""")!(BARPT=BARDA1)"
 S DIC("A")="TABLE ENTRY: "
 D ^DIC
 G:Y'>0 TYPE
 S DA=+Y
 K DIE
 S DIE=DIC
 S DR="2////"_BARDA1_";.01;4;5;6"
 S DIDEL=90050
 D ^DIE
 K DIDEL,DIE
 G ENTRY
 ; *********************************************************************
 ;
EXIT ;EP
 K BARDA1,DIC,DIE,BARPT
 Q
 ; *********************************************************************
 ;
PRT ;EP - print adjustment types
 S DIC=90052.02
 S DHD="A/R Posting Categories & Elements"
 S FLDS="[BAR TYPE,IEN;IEN,.01]"
 S BY="[BAR TABLE TYPE:IEN;IEN]"
 ;S DIS(0)="N Z S Z=$P(^BARTBL(D0,0),U,2) I (Z=3)!(Z=4)!(Z=13)!(Z=14)!(Z=15)!(Z=16)!(Z=19)!(Z=20)!(Z=21)!(Z=22)"  ;IHS/SD/AML 11/2/2010
 S DIS(0)="N Z S Z=$P(^BARTBL(D0,0),U,2) I (Z=3)!(Z=4)!(Z=13)!(Z=14)!(Z=15)!(Z=16)!(Z=19)!(Z=20)!(Z=21)!(Z=22)!(Z=25)"  ;IHS/SD/AML 11/2/2010 - MODIFY TO PRINT BAD DEBT
 D EN1^DIP
 Q
