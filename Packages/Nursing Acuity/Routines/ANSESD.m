ANSESD ;IHS/OIRM/DSD/CSC - DISPLAY STAFFING DATA; [ 02/25/98  10:32 AM ]
 ;;3.0;NURSING PATIENT ACUITY;;APR 01, 1996
 ;;DISPLAY STAFFING DATA
EN ;EP;
 Q:'$G(ANSDA)
 Q:'$D(^ANS(ANSDA,0))
 S X=^ANS(ANSDA,0)
 S (T,C)=0
 W !!,"RN Hours.......: ",$P(X,U,4),!,"Non-RN Hours...: ",$P(X,U,5)
 W !,"Non-Direct Care:"
 S (N,ANT)=0
 F I=4,5 S ANT=ANT+$P(X,U,I)
 ;S I=0
 F  S N=$O(^ANS(ANSDA,"N",N)) Q:'N  D
 .Q:'$D(^ANS(ANSDA,"N",N,0))
 .S X=^ANS(ANSDA,"N",N,0),Y=$P(X,U,2),X=+X
 .Q:'X
 .Q:'$D(^ANSD(59.2,X,0))
 .S X=$P(^ANSD(59.2,X,0),U),T=T+Y,I=I+1
 .W:I>1 !
 .W ?17,$E(X,1,20)
 .W $J(Y,5)
A9 I I=0 W !,"  None Recorded"
 E  W !!,"Total Non-Direct Hours: ",$J(T,5)
 W !!,"Total Staff Hours.....: ",$J(ANT,5)
 I T D
 .W !,"Less Non-Direct.......: ",$J(T,5),!,?24,"------"
 .W !,"Net Hours.............: ",$J(ANT-T,5)
 Q
