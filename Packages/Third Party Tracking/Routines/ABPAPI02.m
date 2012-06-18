ABPAPI02 ;POST INITIALIZATION TASKS - PART 2; [ 04/18/91  9:53 AM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
 ;---------------------------------------------------------------------
OPTS ;PROCEDURE TO CHECK FOR AND REMOVE UNUSED OPTIONS
 W !!,"   Checking for old, unused options..."
 S ABPAMENU=$O(^DIC(19,"B","ABPAMENU","")) Q:+ABPAMENU'>0
 Q:$D(^DIC(19,ABPAMENU,10,"B"))'=10
 K X S R1=0 F I=0:0 D  Q:+R1=0
 .S R1=$O(^DIC(19,ABPAMENU,10,"B",R1)) Q:+R1=0  S X(1,R1)=""
 I $D(X(1))=10 S R1=0 F I=0:0 D  Q:+R1=0
 .S R1=$O(X(1,R1)) Q:+R1=0
 .S R2=0 F I=0:0 D  Q:+R2=0
 ..S R2=$O(^DIC(19,R1,10,"B",R2)) Q:+R2=0  S X(2,R2)=""
 I $D(X(2))=10 S R2=0 F I=0:0 D  Q:+R2=0
 .S R2=$O(X(2,R2)) Q:+R2=0
 .S R3=0 F I=0:0 D  Q:+R3=0
 ..S R3=$O(^DIC(19,R2,10,"B",R3)) Q:+R3=0  S X(3,R3)=""
 I $D(X(3))=10 S R3=0 F I=0:0 D  Q:+R3=0
 .S R3=$O(X(3,R3)) Q:+R3=0
 .S R4=0 F I=0:0 D  Q:+R4=0
 ..S R4=$O(^DIC(19,R3,10,"B",R4)) Q:+R4=0  S X(4,R4)=""
 I $D(X(4))=10 S R4=0 F I=0:0 D  Q:+R4=0
 .S R4=$O(X(4,R4)) Q:+R4=0
 .S R5=0 F I=0:0 D  Q:+R5=0
 ..S R5=$O(^DIC(19,R4,10,"B",R5)) Q:+R5=0  S X(5,R5)=""
 K ABPAOPT S R=0 F I=0:0 D  Q:+R=0
 .S R=$O(X(R)) Q:+R=0
 .S RR=0 F I=0:0 D  Q:+RR=0
 ..S RR=$O(X(R,RR)) Q:+RR=0  S ABPAOPT(RR)=$P(^DIC(19,RR,0),"^",2)
 K X,MSG S ABPAOPT(ABPAMENU)=$P(^DIC(19,ABPAMENU,0),"^",2)
 S ABPAR="ABPA",MSG="no problems here!"
 F I=0:0 D  Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPAR=$O(^DIC(19,"B",ABPAR)) Q:$E(ABPAR,1,4)'="ABPA"
 .Q:ABPAR["AUTO"  S ABPARR=0 F J=0:0 D  Q:+ABPARR=0
 ..S ABPARR=$O(^DIC(19,"B",ABPAR,ABPARR)) Q:+ABPARR=0
 ..Q:$D(^DIC(19,ABPARR,0))'=1
 ..I $D(ABPAOPT(ABPARR))'=1 D
 ...W !,"      Deleting the '",ABPAR,"' option." K MSG
 ...K DIK,DA S DIK="^DIC(19,",DA=ABPARR D ^DIK
 W:$D(MSG)=1 MSG K ABPAOPT
 Q
 ;---------------------------------------------------------------------
LOCKS ;PROCEDURE TO CHECK VALIDITY OF THE OPTION/LOCK RELATIONSHIPS
 W !!,"   Inspecting your option/lock relationships..."
 K MSG S MSG="everything looks O.K.!"
 S ABPAR="ABPA" F I=0:0 D  Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPAR=$O(^DIC(19,"B",ABPAR)) Q:$E(ABPAR,1,4)'="ABPA"
 .S ABPARR=0 F J=0:0 D  Q:+ABPARR=0
 ..S ABPARR=$O(^DIC(19,"B",ABPAR,ABPARR)) Q:+ABPARR=0
 ..Q:$D(^DIC(19,ABPARR,0))'=1
 ..S ABPALOCK="ABPAZ"_$E(ABPAR,5,99)
 ..I $P(^DIC(19,ABPARR,0),"^",6)]"" D
 ...I $P(^DIC(19,ABPARR,0),"^",6)'=ABPALOCK D
 ....W !,"      '",ABPAR,"' has the wrong lock..." K MSG
 ....K DIE,DA,DR S DIE="^DIC(19,",DR="3///@",DA=ABPARR D ^DIE
 ....W "fixed!"
 I $D(MSG)=1 W MSG
 Q
