BRARPT6 ; IHS/ADC/PDW - Print Rad Exam Roster by Room, Procedure. ;  
 ;;5.0;Radiology/Nuclear Medicine;;Feb 20, 2004
 ;
PRINT ;
 U IO S RAPAGE=0,BRAY=1
 ;---> N=DIV,O=ROOM,P=PROC,Q=PAT,R=DATE,S=ROOM-PROC-EXAMS
 ;---> T=ROOM-TOTAL-EXAMS, X=NODEDATA.
 N N,O,P,Q,R,S,T,X
 S N=0 F  S N=$O(^TMP($J,"RA",N)) Q:N=""  D
 .S O=0 F  S O=$O(^TMP($J,"RA",N,O)) Q:O=""  D HD Q:'BRAY  D  Q:'BRAY
 ..S (P,T)=0
 ..F  S P=$O(^TMP($J,"RA",N,O,P)) D:P="" TOT Q:P=""  D HD2 Q:'BRAY  D
 ...S (Q,S)=0
 ...F  S Q=$O(^TMP($J,"RA",N,O,P,Q)) D:Q="" SUB Q:Q=""  D  Q:'BRAY
 ....S R=0 F  S R=$O(^TMP($J,"RA",N,O,P,Q,R)) Q:R=""  D  Q:'BRAY
 .....S X=^TMP($J,"RA",N,O,P,Q,R) D LINE
EXIT ;
 W:$E(IOST)'="C" @IOF
 I $E(IOST)="C"&('$D(IO("S")))&(BRAY) W ! S DIR(0)="E" D ^DIR
 D ^%ZISC
 Q
 ;
LINE ;---> PRINT A LINE OF PATIENT DATA.
 S S=S+1                                      ;---> TOTALS & RETAKES
 I ($Y+6)>IOSL D HD2 Q:'BRAY
 Q:'RAEX                                      ;---> DON'T DISPLAY EXAMS
 W !,$P(X,U,2),?10,$E(Q,1,20)                 ;---> CHART#, NAME
 W ?31,$E(R,4,7),$E(R,2,3),"-",$P(X,U)        ;---> DATE-CASE#
 S RATECH=$P(X,U,3)
 W ?44,$P(^VA(200,+RATECH,0),U)               ;---> TECH
 W:RATECH["(+)" "(+)"                         ;---> MORE THAN 1 TECH
 Q
 ;
HD ;---> HEADER
 N X,Y
 I $E(IOST)="C",RAPAGE W ! S DIR(0)="E" D ^DIR S BRAY=Y Q:'BRAY
 W:RAPAGE @IOF W:'RAPAGE&($E(IOST)="C") @IOF
 W ?22,"  ***  EXAM ROSTER BY ROOM  ***"
 S RAPAGE=RAPAGE+1 W ?70,"Page: ",RAPAGE
 W !!?1,"Division: ",$P(^DIC(4,N,0),U),?52,"For period: "
 S Y=RABEGDT D D^RAUTL W ?64,Y,?76,"to"
 S X="NOW",%DT="T" D ^%DT K %DT D D^RAUTL W !?1,"Run Date: ",Y
 S Y=RAENDDT D D^RAUTL W ?64,Y
 W ! F I=1:1:80 W "-"
 W !,"Chart#",?10,"Patient",?31,"Date-Case#",?44,"Technologist"
 W ?69,"Total"
 W ! F I=1:1:80 W "-"
 Q
 ;
HD2 ;---> SUBHEADER
 I ($Y+8)>IOSL D HD Q:'BRAY
 W !!?5,"ROOM: ",$E(O,1,25),?40,"PROCEDURE: ",P
 W !?5 F I=1:1:$L($E(O,1,25))+6 W "-"
 W ?40 F I=1:1:$L(P)+11 W "-"
 Q
 ;
SUB ;
 W:RAEX !?65,"---------------"
 W !?44,"Total for this procedure: ",?70,$J(S,4)
 S T=T+S
 Q
TOT ;
 I ($Y+6)>IOSL D HD
 W ! F I=1:1:80 W "*"
 W !,"ROOM:  ",$E(O,1,30)
 W ?52,"Total Procedures: ",?70,$J(T,4)
 W ! F I=1:1:80 W "*"
 Q
