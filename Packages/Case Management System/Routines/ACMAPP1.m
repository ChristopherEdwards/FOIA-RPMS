ACMAPP1 ; IHS/TUCSON/TMJ - ACMAPPT SUBROUTINE LISTS CURRENT APPTS ; [ 01/24/96  10:37 AM ]
 ;;2.0;ACM CASE MANAGEMENT SYSTEM;;JAN 10, 1996
 ;FINDS RESOURCE, CHECKS FOR RELATED SERVICE, ADDS NEW SERVICE AND/OR
 ;APPOINTMENTS, CALLED BY ACMAPPT, NO INTERNAL ENTRY POINTS
EN D PRO K ACMSCNO
 D TEST:'$D(ACMQUIT)
 I '$D(ACMQUIT),$D(ACMSCNO) D CHK,EXIT Q
 D SVC:'$D(ACMQUIT) K DA
 D CHK:'$D(ACMQUIT)
 D EXIT
 Q
 ;
PRO K ACMQUIT
 S DIC="^ACM(50,",DIC(0)="AEMQ",DIC("A")="    RESOURCE: "
 S DIC("S")="I $D(^ACM(50,+Y,""RG"",""B"",ACMRG))"
 W ! D ^DIC K DIC
 I X=""!($E(X)=U)!(Y=-1) S ACMQUIT="" Q
 S ACMCLNO=+Y,ACMCLNA=$P(^ACM(50,ACMCLNO,0),U)
 Q
 ;
SVC K DIC,DD
 S DIC="^ACM(47.1,"
 S DIC(0)="AEMQ"
 S DIC("A")="     SERVICE: "
 S DIC("S")="I $D(^ACM(50,ACMCLNO,2,""B"",Y))"
 W ! D ^DIC K DIC,DD
 I X=U S ACMQUIT="" Q
 I Y=-1 W !!?10,"Enter the RELATED SERVICE for the appointment.",! G SVC
 S ACMSCNO=+Y,ACMSCNA=$P(Y,U,2)
 Q
 ;
EXIT K ACMU,%Y,ACMCLNO,ACMCLNA,ACMSVNO,ACMSVNA,ACMSCNA,ACMSCNO,ACMQUIT
 Q
 ;
CHK I '$D(^ACM(47.1,ACMSCNO,"RG","B",ACMRG)) D SVMESS
 S ACMU="" F ACMI=0:0 S ACMU=$O(^ACM(47,"AC",ACMRG,ACMPTNO,ACMU)) Q:'ACMU  S ACMUA=^(ACMU) I +^ACM(47,ACMUA,0)=ACMSCNO S ACMSVNO=ACMUA Q
 I $D(ACMSVNO) D CHKS Q
 D ADDSERV
 D NEW:'$D(ACMQUIT)
 Q
 ;
CHKS S:'$D(^ACM(47,ACMSVNO,"DT")) ^ACM(47,ACMSVNO,"DT")="E"
 I $P(^ACM(47,ACMSVNO,"DT"),U)'="E" D STAT Q:$D(ACMQUIT)
 S ACMU=0 F ACMI=0:0 S ACMU=$O(^ACM(49,"C",ACMPTNO,ACMU)) Q:'ACMU  I $P(^ACM(49,ACMU,"DT"),U,5)=ACMSCNO D WANTNEW Q
 I $D(ACMNONU) K ACMNONU Q
 D NEW
 Q
 ;
SVMESS S:'$D(^ACM(47.1,ACMSCNO,"RG")) ^ACM(47.1,ACMSCNO,"RG",0)="^9002247.12P^^"
 S DIC="^ACM(47.1,DA(1),""RG"",",X=ACMRG,DIC(0)="L",DA(1)=ACMSCNO
 K DD,DO D FILE^DICN Q
 W !!?10,"The ",@ACMRVON,ACMRGNA,@ACMRVOFF," register is not associated with"
 W !?10,"the ",@ACMRVON,ACMSCNA,@ACMRVOFF," service."
 W !?10,"The ",ACMRGNA," register must be added for this service."
 W !?10,"Use the 'Supporting Data' Option from the MAIN MENU."
 W !!?10,"Strike <CR> to continue." R ACMX:DTIME
 Q
 ;
WANTNEW W !!?10,"Do you want to add another appointment for this service"
 S %=1 D YN^DICN
 I %=-1!($E(%Y)="N") S ACMNONU="" Q
 Q
 ;
ADDSERV W !!?10,@ACMRVON,ACMPTNA2,@ACMRVOFF," is not signed up for"
 W !?10,@ACMRVON,ACMSCNA,@ACMRVOFF,"."
 W !!?10,"Want to enroll him/her for ",ACMSCNA S %=1 D YN^DICN
 I %Y["^" S ACMQUIT="" Q
 I %'=1 W !!?10,"CLIENT must be ENROLLED in the SERVICE before he/she",!?10,"can get an appointment to this provider.  If you want to",!?10,"escape without enrolling this CLIENT, type '^' followed by a <CR>." G ADDSERV
 K DIC,DD S DIC="^ACM(47,",DIC(0)="L",X=ACMSCNO
 S DIC("DR")=".02////"_ACMPTNO_";.03////"_ACMRGDFN_";.04////"_ACMRG
 K DD,DO D FILE^DICN K DIC,DR,DD
 S DIE="^ACM(47,",(DA,ACMSVNO)=+Y,DR="1///E" D DIE1
 Q
 ;
DIE1 D ^DIE K DIC,DIE,DR
 S DIE="^ACM(41,",DA=ACMRGDFN,DR="11///TODAY" D ^DIE K DIC,DIE,DR
 Q
 ;
STAT W !!?10,"This CLIENT is signed up for ",@ACMRVON,ACMSCNA,@ACMRVOFF
 W !?10,"but his/her status is not indicated as being ENROLLED."
 W !?10,"Want to change the status to ENROLLED"
 S %=1 D YN^DICN
 I %'=1 W !!?10,"CLIENT must be ENROLLED for ",ACMSCNA,!?10," before he/she can get an appointment for this service.",!?10,"If you want to escape without enrolling this CLIENT, type '^' followed by a <CR>." G STAT
 S DA=ACMSVNO,DR="1///E",DIE="^ACM(47," D DIE1
 Q
 ;
NEW W !!?10,"I will add the following appointment for this client =>"
 W !!?14,"Provider: ",@ACMRVON,ACMCLNA,@ACMRVOFF
 W !?15,"Service: ",@ACMRVON,ACMSCNA,@ACMRVOFF
 W !!?10,"OK" S %=1 D YN^DICN
 I %'=1 S ACMQUIT="" K DA Q
 S X=ACMCLNO
 K DIC,DD
 S DIC="^ACM(49,",DIC(0)="L"
 S DIC("DR")=".02////"_ACMPTNO_";.03////"_ACMRGDFN_";.04////"_ACMRG_";11////"_ACMSCNO
 W ! D WAIT^DICD W !
 K DD,DO D FILE^DICN S DA=+Y K DIC,DR,DD
 Q
 ;
TEST S ACMU="" F ACMI=1:1 S ACMU=$O(^ACM(50,ACMCLNO,2,ACMU)) Q:'ACMU  S X=^(ACMU,0) S:ACMI=1 ACMSCNO=X,ACMSCNA=$P(^ACM(47.1,X,0),U) I ACMI>1 Q
 I ACMI=1 Q
 K ACMSCNO,ACMSCNA
 Q
 ;
