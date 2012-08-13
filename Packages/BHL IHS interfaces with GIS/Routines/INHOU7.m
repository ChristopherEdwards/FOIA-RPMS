INHOU7 ;DP; 28 Feb 96 14:58;27 Dec 95 10:39;LIST QUEUED TRANSACTIONS II 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
QUE ;Select que
 K QUE1 I X[U S POP=1 Q
 I +X<0!(+X>1) K X Q
 S QUE1=$S(X=1:"^INLHSCH",X=0:"^INLHDEST",1:"All")
 W " ",QUE1 Q:X=""
 I $O(@QUE1@(0))'?.N W " is empty" H 1 K X Q
 Q
HELP ;
 W !,"Select Queue: 1=INLHSCH"
 W !,"              0=INLHDEST"
 W !!,"Press 'Enter' to select all queues"
 Q
 ;
PRIO ;Priority
 I X[U K X S POP=1 Q
 Q:X?1.3N
 K X
 Q
HELP1 ;
 W !,"Enter a valid Priority Number or Return for All"
 Q
YN ;
 I X[U K X S POP=1 Q
 S X=$E($$UPCASE^%ZTF(X))
 I X]"YN " K X Q
 S X=1 S:X="N" X=0
 Q
YNH ;
 W !,"Enter Yes to see message details or No for message ID only."
 Q
P1 ;
 W:X="" "Yes"
 S ^DIZ(4001.1,INDA,9)=X
 Q
 ;Get begining and ending dates.
 S %DT("B")="Today"
 W ! S %DT("A")="Starting Date: ",%DT="ATE" D ^%DT Q:Y<0  S INBEG=+Y
 W ! S %DT("A")="  Ending Date: ",%DT="ATE" D ^%DT Q:Y<0  S INEND=+Y
 ;Direction
 W !! N INO S INO="IiOo"
 D ^UTSRD("Direction: ;1A;;;O;;;;I $F(INO,X)<1 K X;DIRC","Enter In or Out")
 I DIRC[U S POP=1 Q
 S DIRC=$$UPCASE^%ZTF(DIRC)
 W $S(DIRC="O":"ut",1:"n")
DES ;Get multiple destinations
 W ! K X,X2,IN1 S X2=""
 F I=1:1 D  W:Y=-1&(X2="") "ALL" Q:Y=-1
 .D ^DIC Q:+Y<1
 .S X(+Y)=$P(^INRHD(+Y,0),U)
 .S IN1(X(+Y))="",X2=X2_(+Y)_","
 W ! Q:POP
 ;
DET ;Detail yes/no
 W ! S DET=$$YN^UTSRD("Detailed: ;N")
 I DET[U S POP=1 Q
INT ;Read time interval
 W @IOF,!,"   Priority: ",PRIO
 W !,"       From: ",$$CDATASC^%ZTFDT($E(INBEG,1,12),3,1)
 W !,"         To: ",$$CDATASC^%ZTFDT($E(INEND,1,12),3,1)
 W !,"      Queue: ",QUE1
 W !,"  Direction: ",$S(DIRC="I":"In",1:"Out")
 W !,"     Detail: ",$S(DET=1:"Yes",1:"No"),!
 W !,"Destination: " I $L(X2)=0 W "All "
 E  F I=1:1:$L(X2,",")-1 W ?13,$P(^INRHD($P(X2,",",I),0),U),!
 W ! S Z=$$CR^UTSRD
 I Z S POP=1 Q
 ; taskman variables
 ; X2    = destination list (IEN,...)
 ; INBEG = beginning date@time
 ; INEND = ending date@time
 ;
 S INBEG=$$CDATF2H^%ZTFDT(INBEG) S:PRIO="All" PRIO=""
 S INEND=$$CDATF2H^%ZTFDT(INEND)
 S INLOAD=DET_U_X2_U_INBEG_U_INEND_U_DIRC_U_QUE_U_PRIO
 W !
 Q
 ;
