BRARPT2 ; IHS/ADC/PDW - Print Rad Exam Roster by Rad, Proc, Diag Code. ;  
 ;;5.0;Radiology/Nuclear Medicine;;Feb 20, 2004
 ;
PRINT ;
 U IO S RAPAGE=0,BRAY=1
 ;---> N=DIV,O=RAD,P=PROC,Q=PAT,R=DATE,X=NODEDATA
 N N,O,P,Q,R,X
 S N=0 F  S N=$O(^TMP($J,"RA",N)) Q:N=""  D  Q:'BRAY
 .S O=0 F  S O=$O(^TMP($J,"RA",N,O)) Q:O=""  D HD Q:'BRAY  D  Q:'BRAY
 ..S P=0
 ..F  S P=$O(^TMP($J,"RA",N,O,P)) Q:P=""  D HD2 Q:'BRAY  D  Q:'BRAY
 ...S Q=0 F  S Q=$O(^TMP($J,"RA",N,O,P,Q)) Q:Q=""  D  Q:'BRAY
 ....S R=0 F  S R=$O(^TMP($J,"RA",N,O,P,Q,R)) Q:R=""  D  Q:'BRAY
 .....S X=^TMP($J,"RA",N,O,P,Q,R) D LINE
EXIT ;
 W:$E(IOST)'="C" @IOF
 I $E(IOST)="C"&('$D(IO("S")))&(BRAY) W ! S DIR(0)="E" D ^DIR
 D ^%ZISC
 Q
 ;
LINE ;---> PRINT A LINE OF PATIENT DATA.
 I ($Y+6)>IOSL D HD2 Q:'BRAY
 W !,$P(X,U,2),?10,$E(Q,1,20)              ;---> CHART#, NAME
 W ?31,$E(R,4,7),$E(R,2,3),"-",$P(X,U)     ;---> DATE-CASE#
 W ?43,$E($P(X,U,3),1,4)                   ;---> EXAM STATUS
 W ?49,$E($P(X,U,4),1,31)                  ;---> DIAGNOSTIC CODE
 Q
 ;
HD ;---> HEADER
 N X,Y
 I $E(IOST)="C",RAPAGE W ! S DIR(0)="E" D ^DIR S BRAY=Y Q:'BRAY
 W:RAPAGE @IOF W:'RAPAGE&($E(IOST)="C") @IOF
 W ?8,"  ***  EXAM ROSTER BY RADIOLOGIST, PROCEDURE, DIAG CODE  ***"
 S RAPAGE=RAPAGE+1 W ?70,"Page: ",RAPAGE
 W !!?1,"Division: ",$P(^DIC(4,N,0),U),?52,"For period: "
 S Y=RABEGDT D D^RAUTL W ?64,Y,?76,"to"
 S X="NOW",%DT="T" D ^%DT K %DT D D^RAUTL W !?1,"Run Date: ",Y
 S Y=RAENDDT D D^RAUTL W ?64,Y
 W ! F I=1:1:80 W "-"
 W !,"Chart#",?10,"Patient",?31,"Date-Case#",?43,"Status"
 W ?53,"Diagnostic Code"
 W ! F I=1:1:80 W "-"
 Q
 ;
HD2 ;---> SUBHEADER
 I ($Y+9)>IOSL D HD Q:'BRAY
 W !!?4,"RADIOLOGIST: ",O,?40,"PROCEDURE: ",P
 W !?4 F I=1:1:$L(O)+13 W "-"
 W ?40 F I=1:1:$L(P)+11 W "-"
 Q
