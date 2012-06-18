BRARPT4 ; IHS/ADC/PDW - Print Exam Roster by Tech, Proc. ;  
 ;;5.0;Radiology/Nuclear Medicine;;Feb 20, 2004
 ;
PRINT ;
 U IO S RAPAGE=0,BRAY=1
 ;---> N=DIV,O=TECH,P=PROC,Q=PAT,R=DATE,S=PROC-RETAKES
 ;---> T=PROC-TOTALFILMS, V=TECH-RETAKES, W=TECH-TOTALFILMS, X=NODEDATA.
 ;---> K=FILM IEN, L=KEEPER OF PREVIOUS NAME
 N K,L,N,O,P,Q,R,S,T,V,W,X S L=""
 S N=0 F  S N=$O(^TMP($J,"RA",N)) Q:N=""  D
 .S O=0 F  S O=$O(^TMP($J,"RA",N,O)) Q:O=""  D HD Q:'BRAY  D  Q:'BRAY
 ..S (P,V,W)=0
 ..F  S P=$O(^TMP($J,"RA",N,O,P)) D:P="" TOT Q:P=""  D HD2 Q:'BRAY  D
 ...S (Q,S,T)=0
 ...F  S Q=$O(^TMP($J,"RA",N,O,P,Q)) D:Q="" SUB Q:Q=""  D  Q:'BRAY
 ....S R=0 F  S R=$O(^TMP($J,"RA",N,O,P,Q,R)) Q:R=""  D  Q:'BRAY
 .....S K=0 F  S K=$O(^TMP($J,"RA",N,O,P,Q,R,K)) Q:K=""  D  Q:'BRAY
 ......S X=^TMP($J,"RA",N,O,P,Q,R,K) D LINE
EXIT ;
 W:$E(IOST)'="C" @IOF
 I $E(IOST)="C"&('$D(IO("S")))&(BRAY) W ! S DIR(0)="E" D ^DIR
 D ^%ZISC
 Q
 ;
LINE ;---> PRINT A LINE OF PATIENT DATA.
 S T=T+$P(X,U,3),S=S+$P(X,U,4)                ;---> TOTALS & RETAKES
 I ($Y+6)>IOSL D HD2 Q:'BRAY
 Q:'RAEX                                      ;---> DON'T DISPLAY EXAMS
 W ! W:Q'=L $P(X,U,2),?10,$E(Q,1,20)          ;---> CHART#, NAME
 S L=Q                                        ;---> KEEP PREVIOUS NAME
 W ?31,$E(R,4,7),$E(R,2,3),"-",$P(X,U)        ;---> DATE-CASE#
 W ?43,$E($P(^RA(78.4,K,0),U),1,20)           ;---> FILM SIZE
 W ?65,$J($P(X,U,3),4)                        ;---> TOTAL FILMS
 W ?75,$J($P(X,U,4),4)                        ;---> RETAKES
 Q
 ;
HD ;---> HEADER
 N X,Y
 I $E(IOST)="C",RAPAGE W ! S DIR(0)="E" D ^DIR S BRAY=Y Q:'BRAY
 W:RAPAGE @IOF W:'RAPAGE&($E(IOST)="C") @IOF
 W ?12,"  ***  FILM USAGE BY TECHNOLOGIST AND PROCEDURE  ***"
 S RAPAGE=RAPAGE+1 W ?70,"Page: ",RAPAGE
 W !!?1,"Division: ",$P(^DIC(4,N,0),U),?52,"For period: "
 S Y=RABEGDT D D^RAUTL W ?64,Y,?76,"to"
 S X="NOW",%DT="T" D ^%DT K %DT D D^RAUTL W !?1,"Run Date: ",Y
 S Y=RAENDDT D D^RAUTL W ?64,Y
 W ! F I=1:1:80 W "-"
 W !,"Chart#",?10,"Patient",?31,"Date-Case#",?43,"Films: Size"
 W ?64,"Total",?73,"Retakes"
 W ! F I=1:1:80 W "-"
 Q
 ;
HD2 ;---> SUBHEADER
 I ($Y+9)>IOSL D HD Q:'BRAY
 W !!?4,"TECHNOLOGIST: ",$E(O,1,19),?40,"PROCEDURE: ",P
 W !?4 F I=1:1:$L(O)+14 W "-"
 W ?40 F I=1:1:$L(P)+11 W "-"
 Q
 ;
SUB ;
 W:RAEX !?65,"---------------"
 W !?37,"Totals for this procedure: ",?65,$J(T,4),?75,$J(S,4)
 S W=W+T,V=V+S
 Q
TOT ;
 I ($Y+6)>IOSL D HD
 W ! F I=1:1:80 W "*"
 W !,"TECHNOLOGIST:  ",$E(O,1,22)
 W ?39,"Total Films and Retakes: ",?65,$J(W,4),?75,$J(V,4)
 W ! F I=1:1:80 W "*"
 Q
