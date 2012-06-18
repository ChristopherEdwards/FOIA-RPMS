ACDCSD ;IHS/ADC/EDE/KML - DATA ENTER/EDIT FOR CLIENT CATEGORIES;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
START ;
 D MAIN
 D EOJ
 Q
 ;
MAIN ;
 D INIT
 Q:ACDQ
 D GETCAT
 Q:ACDQ
 I ACDNEWG S Y=1 I 1
 E  S DIR(0)="S^1:Add new patients;2:Delete existing patients",DIR("A")="Choose",DIR("B")="1" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S ACDAE=Y
 F  D GETPATS Q:ACDQ
 Q
 ;
INIT ;
 S ACDQ=1
 Q:'$D(IOF)
 Q:'$G(DUZ(2))
 Q:'$D(^ACDF5PI(DUZ(2),0))  ;   should never happen
 S ACDPGM=DUZ(2)
 Q:'$G(IO)
 S Y=$O(^%ZIS(1,"C",IO,0)) I Y S Y=$P($G(^%ZIS(1,Y,"SUBTYPE")),U) I Y S X=$G(^%ZIS(2,Y,5)),ACDRVON=$P(X,U,4),ACDRVOF=$P(X,U,5)
 I $G(ACDRVON)="" S ACDRVON="""""",ACDRVOF=""""""
 S ACDDUZZ=DUZ(2)
 S ACDDOV=DT ;                  set visit date for ^ACDAGRG
 K ^TMP("ACD",$J),^TMP($J)
 S ACDDUZZ=DUZ(2)
 W @IOF,"Signon Program is            : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Adding/editing client categories for auto cs duplication",!
 S ACDQ=0
 Q
 ;
GETCAT ; GET CLIENT CATEGORY
 S ACDQ=1
 S DIC="^ACDPAT(",DIC(0)="AEMQL",DLAYGO=9002172.8,DIC("DR")="2////"_ACDPGM_";.03;.04",DIC("S")="I $P(^(0),U,2)=ACDPGM" D DIC^ACDFMC
 Q:Y<0
 S ACDCC=+Y
 S ACDNEWG=+$P(Y,U,3)
 I '$P(Y,U,3) S DIE="^ACDPAT(",DA=+Y,DR=".01" S ACDKPDA=1 D DIE^ACDFMC I '$D(DA) Q  ;         user must have deleted the client category
 K DA
 S ACDCOMC=$P(^ACDPAT(ACDCC,0),U,3),ACDCOMT=$P(^(0),U,4)
 S Y=ACDCOMC,C=$P(^DD(9002172.8,.03,0),U,2) D Y^DIQ S ACDCOMCL=Y
 S Y=ACDCOMT,C=$P(^DD(9002172.8,.04,0),U,2) D Y^DIQ S ACDCOMTL=Y
 I ACDCOMC=""!(ACDCOMT="") D FIXCAT Q:ACDQ
 I $O(^ACDPAT(ACDCC,1,0)) S DIC="^ACDPAT(",DA=ACDCC D DIQ^ACDFMC,PAUSE^ACDDEU
 S ACDQ=0
 Q
 ;
FIXCAT ; FIX OLD CATEGORY.  IT MUST HAVE COMC/COMT
 S ACDQ=0
 S DIE="^ACDPAT("
 S DA=ACDCC
 S DR=".03;.04"
 D DIE^ACDFMC
 S ACDCOMC=$P(^ACDPAT(ACDCC,0),U,3),ACDCOMT=$P(^(0),U,4)
 I ACDCOMC=""!(ACDCOMT="") S ACDQ=1 Q
 S Y=ACDCOMC,C=$P(^DD(9002172.8,.03,0),U,2) D Y^DIQ S ACDCOMCL=Y
 S Y=ACDCOMT,C=$P(^DD(9002172.8,.04,0),U,2) D Y^DIQ S ACDCOMTL=Y
 ; now make sure all patients in category have init for comc/comt
 S ACDY=0 F  S ACDY=$O(^ACDPAT(ACDCC,1,ACDY)) Q:'ACDY  S ACDDFNP=+^(ACDY,0) D
 . S ACDDFN=$P(^DPT(ACDDFNP,0),U) ;     get patient name
 . S ACDINR=1
 . NEW ACDY
 . D CHKFIN^ACDDEU ;       check for initial type contact
 . Q
 I ACDQ W !!,"WARNING - All patients must have an initial type contact for the",!,ACDCOMCL,"/",ACDCOMTL," component prior to using this client category,",!
 Q
 ;
GETPATS ; GET PATIENTS
 K ACDNEWP
 I ACDAE=2 D PATED Q
 D ^ACDDEGP
 Q:ACDQ
 D GETVSITS^ACDDEU ;       gather up all visits for this patient
 I $D(^ACDPAT(ACDCC,1,ACDDFNP,0)) D EDIT Q
 ; add a new patient
 S ACDINR=1
 D CHKFIN^ACDDEU ;         check for initial type contact
 I ACDQ S ACDQ=0 Q
 S DIC="^ACDPAT("_ACDCC_",1,"
 S DIC(0)="L"
 S DIC("P")=$P(^DD(9002172.8,1,0),U,2)
 S DA=ACDDFNP,DA(1)=ACDCC
 S DINUM=DA
 S X=ACDDFNP
 D FILE^ACDFMC
 I +Y<0 W !,"Creation of CLIENT entry failed.  Notify programmer.",!! S ACDQ=1 S:$D(^%ZOSF("$ZE")) X="CDMIS CLIENT CATEGORY CLIENT",@^("$ZE") D @^%ZOSF("ERRTN") Q
 S ACDNEWP=1
 D EDIT
 Q
 ;
PATED ; SELECT AN EXISTING PATIENT TO EDIT
 W !
 S DIC="^ACDPAT(ACDCC,1,",DIC(0)="AEMQ" D ^DIC
 I Y<0 S ACDQ=1 Q
 S ACDDFNP=+Y
 S ACDDFN=$P(^DPT(ACDDFNP,0),U)
 D GETDEMO^ACDDEGP
 D EDIT
 Q
 ;
EDIT ; EDIT AN EXISTING PATIENT
 S DIE="^ACDPAT("_ACDCC_",1,"
 S DA=ACDDFNP,DA(1)=ACDCC
 S DR=""
 S:'$G(ACDNEWP) DR=".01//"_ACDDFN_";"
 S DR=DR_"2////"_ACDTRBCD_";3////"_ACDSEX_";4////"_ACDAGER_";22////"_ACDSTACD_";23////"_ACDSTA_";24////"_ACDTRB_";25////"_ACDVET_";26////"_ACDAGE
 D DIE^ACDFMC
 W !,"  Patient demographic information set from Patient Registration data."
 Q
 ;
EOJ ;
 K ACDNEWG
 D ^ACDKILL
 Q
