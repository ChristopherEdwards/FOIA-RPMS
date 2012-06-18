BGP7ELLV ; IHS/CMI/LAB - print ind ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
BL ;EP
 S X=" " D S(X,1,1) S X="BASELINE REPORT PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U) S Y=V D S(Y,,X+1)
 S X="# w/Cholesterol screen w/in 5 yrs (GPRA)" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/Cholesterol screen w/in 5 yrs (GPRA)" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,3) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/ High Chol =>240 w/ % of Total Chol Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,4) S Y=V D S(Y,,X+1)
 S X="% A. # w/ High Chol =>240 w/ % of Total Chol Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,5) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1)
 S X="# w/LDL done in past 5 yrs" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,6) S Y=V D S(Y,,X+1)
 S X="% w/LDL done in past 5 yrs" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,7) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/ LDL =<100 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,8) S Y=V D S(Y,,X+1)
 S X="% A. # w/ LDL =<100 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,9) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="B. # w/ LDL 101-130 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,10) S Y=V D S(Y,,X+1)
 S X="% B. # w/ LDL 101-130 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,11) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="C. # w/ LDL 131-160 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,12) S Y=V D S(Y,,X+1)
 S X="% C. # w/ LDL 131-160 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,13) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="D. # w/ LDL >160 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,14) S Y=V D S(Y,,X+1)
 S X="% D. # w/ LDL >160 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,15) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S X="w/Cholesterol screen w/in 5 yrs (GPRA)" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="A. # w/ High Chol =>240 w/ % of Total Chol Screen" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="w/LDL done in past 5 yrs" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="A. # w/ LDL =<100 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="B. # w/ LDL 101-130 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAB(X),U,11) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="C. # w/ LDL 131-160 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAB(X),U,13) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 S X="D. # w/ LDL >160 w/ % of Total LDL Screen" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,15),O=$P(BGPDAB(X),U,15) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
 Q
V(T,R,N,P) ;
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPELDCA(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPELDPA(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPELDBA(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCA(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPA(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBA(X,N)),U,P)
 .Q
 Q $S(C:C,1:0)
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
S(Y,F,P) ;
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
 Q
CALC(N,O) ;
 NEW Z
 S Z=N-O,Z=$FN(Z,"+,",1)
 Q Z
H3 ;EP
 S X="Cardiovascular Disease and Cholesterol Screening" D S(X,1,1) S Y=" " D S(Y,1,1) S X=BGPHD1 D S(X,1,1) S Y=" " D S(Y,1,1)
 S X="Age Distribution" D S(X,1,1) S X=" " D S(X,1,1)
 S Y="55-64" D S(Y,1,2)
 S Y="65-74" D S(Y,,3)
 S Y="75-84" D S(Y,,4)
 S Y=">84 yrs" D S(Y,,5)
 Q
SB(X) ;
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
H2 ;
 S BGPX="",BGPX=BGPCYN,$P(BGPX,U,2)=$$SB($J(BGPCYP,5,1)),$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)=$$SB($J(BGPPRP,5,1)),$P(BGPX,U,5)=$$SB($J($$CALC(BGPCYP,BGPPRP),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=$$SB($J(BGPBLP,5,1))
 S $P(BGPX,U,8)=$$SB($J($$CALC(BGPCYP,BGPBLP),6))
 D S(BGPX,,2)
 Q
H1 ;
 S Y="REPORT" D S(Y,1,2)
 S Y="%" D S(Y,,3)
 S Y="PREV YR" D S(Y,,4)
 S Y="%" D S(Y,,5)
 S Y="CHG from" D S(Y,,6)
 S Y="BASE" D S(Y,,7)
 S Y="%" D S(Y,,8)
 S Y="CHG from" D S(Y,,9)
 S Y="PERIOD" D S(Y,1,2)
 S Y="PERIOD" D S(Y,,4)
 S Y="PREV YR %" D S(Y,,6)
 S Y="PERIOD" D S(Y,,7)
 S Y="BASE %" D S(Y,,9)
 Q
