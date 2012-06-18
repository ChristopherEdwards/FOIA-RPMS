ABPAALK3 ;PVT INS ACCOUNT DISPLAY SUPPLEMENT; [ 05/22/91  12:28 PM ]
 ;;1.4;AO PVT-INS TRACKING;*0*;IHS-OKC/KJR;JULY 25, 1991
DTHD W @IOF S X=ABPATLE_" - Display ALL Patient TRANSACTIONS"
 W ?(40-($L(X)/2)),X,!,ABPAX,!
 W:IO=IO(0) @ABPARON W ABPAPAT_"  ("_ABPAHRN_") "_$E(ABPAL,1,25)
 W:IO=IO(0) @ABPAROFF W !,"Other Names Used:"
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
