ABPVPI02 ;POST INITIALIZATION TASKS - PART 2; [ 06/03/91  10:10 AM ]
 ;;2.0;FACILITY PVT-INS TRACKING;*0*;IHS-OKC/KJR;AUGUST 7, 1991
 W !!,"NOT AN ENTRY POINT!",!! Q
 ;---------------------------------------------------------------------
OPTS ;PROCEDURE TO CHECK FOR AND REMOVE UNUSED OPTIONS
 W !!,"   Checking for old, unused options..."
 S ABPVMENU=$O(^DIC(19,"B","ABPVMENU","")) Q:+ABPVMENU'>0
 Q:$D(^DIC(19,ABPVMENU,10,"B"))'=10
 K X S R1=0 F I=0:0 D  Q:+R1=0
 .S R1=$O(^DIC(19,ABPVMENU,10,"B",R1)) Q:+R1=0  S X(1,R1)=""
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
 K ABPVOPT S R=0 F I=0:0 D  Q:+R=0
 .S R=$O(X(R)) Q:+R=0
 .S RR=0 F I=0:0 D  Q:+RR=0
 ..S RR=$O(X(R,RR)) Q:+RR=0  S ABPVOPT(RR)=$P(^DIC(19,RR,0),"^",2)
 K X,MSG S ABPVOPT(ABPVMENU)=$P(^DIC(19,ABPVMENU,0),"^",2)
 S ABPVR="ABPV",MSG="no problems here!"
 F I=0:0 D  Q:$E(ABPVR,1,4)'="ABPV"
 .S ABPVR=$O(^DIC(19,"B",ABPVR)) Q:$E(ABPVR,1,4)'="ABPV"
 .Q:ABPVR["AUTO"  S ABPVRR=0 F J=0:0 D  Q:+ABPVRR=0
 ..S ABPVRR=$O(^DIC(19,"B",ABPVR,ABPVRR)) Q:+ABPVRR=0
 ..Q:$D(^DIC(19,ABPVRR,0))'=1
 ..I $D(ABPVOPT(ABPVRR))'=1 D
 ...W !,"      Deleting the '",ABPVR,"' option." K MSG
 ...K DIK,DA S DIK="^DIC(19,",DA=ABPVRR D ^DIK
 W:$D(MSG)=1 MSG K ABPVOPT
 Q
