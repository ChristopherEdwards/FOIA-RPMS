ABPACDF2 ;PVT-INSDELETE OPEN CLAIMS;[ 05/24/91  1:13 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
DTHD D ^%AUCLS S X=ABPATLE_" - DELETE CLAIMS for a patient"
 W ?(40-($L(X)/2)),X,!,ABPAX,!
 W @ABPARON,ABPAPAT_"  ("_ABPAHRN_") "_$E(ABPAL,1,25),@ABPAROFF
 W !,"Other Names Used:"
 S ZR=0 F I=0:0 D  Q:+ZR=0
 .S ZR=$O(^ABPVAO(ABPATDFN,"AKA",ZR)) Q:+ZR=0
 .W:$X>20 ! W ?20,$P(^ABPVAO(ABPATDFN,"AKA",ZR,0),"^")," ("
 .W:$P(^ABPVAO(ABPATDFN,"AKA",ZR,0),"^",2)=1 "Alias)"
 .W:$P(^ABPVAO(ABPATDFN,"AKA",ZR,0),"^",2)'=1 "Look-up only)"
 W !,ABPAX
 W !?8,"Insurance",?23,"Date of",?34,".....Claim.....",?53,"......."
 W "..Payment........",!,?8,"Company",?23,"Service",?34,"Amount",?43
 W "Status",?53,"Date(s)",?65,"Amount  Type",!,ABPAXX
 Q
