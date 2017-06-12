BGP6ELLU ; IHS/CMI/LAB - print ind ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
I1AGEP ;EP
BL ; 
 S X=" " D S(X,1,1) S X="BASELINE YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U) S Y=V D S(Y,,X+1)
 S X="# w/ Exposure to 1+ High-Risk Med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/ Exposure to 1+ High-Risk Med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,3) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/ Anticholinergic Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,4) S Y=V D S(Y,,X+1)
 S X="A. % w/ Anticholinergic Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,5) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="B. # w/ Antithrombotic Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,6) S Y=V D S(Y,,X+1)
 S X="B. % w/ Antithrombotic Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,7) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="C. # w/ Anti-infective R w/ % of Total Medsx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,8) S Y=V D S(Y,,X+1)
 S X="C. % w/ Anti-infective Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,9) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="D. # w/ Cardiovascular Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,10) S Y=V D S(Y,,X+1)
 S X="D. % w/ Cardiovascular Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,11) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="E. # w/ Central Nervous System Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,12) S Y=V D S(Y,,X+1)
 S X="E. % w/ Central Nervous System Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,13) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="F. # w/ Endocrine Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,14) S Y=V D S(Y,,X+1)
 S X="F. % w/ Endocrine Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,15) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="G. # w/ Gastrointestinal Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,16) S Y=V D S(Y,,X+1)
 S X="G. % w/ Gastrointestinal Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,17) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="H. # w/ Pain Med Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,18) S Y=V D S(Y,,X+1)
 S X="H. % w/ Pain Med Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,19) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 ;
 S X=" " D S(X,1,1) S X="I. # w/ Skeletal Muscle Relaxant Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,28) S Y=V D S(Y,,X+1)
 S X="I. % w/ Skeletal Muscle Relaxant Rx w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,29) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 ;
 S X=" " D S(X,1,1) S X="# w/ Exposure to Multiple High-Risk Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,40) S Y=V D S(Y,,X+1)
 S X="% w/ Exposure to Multiple High-Risk Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,41) S Y=$$SB^BGP6ELL2($J(V,6,1)) D S(Y,,X+1)
 ;% changes
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S BGP1="# w/ Exposure to 1+ High-Risk Med",BGPPIE=3 D PPC
 S BGP1="A. # w/ Anticholinergic Rx",BGPPIE=5 D PPC
 S BGP1="B. # w/ Antithrombotic Rx",BGPPIE=7 D PPC
 S BGP1="C. # w/ Anti-infective Rx",BGPPIE=9 D PPC
 S BGP1="D. # w/ Cardiovascular Rx",BGPPIE=11 D PPC
 S BGP1="E. # w/ Central Nervous System Rx",BGPPIE=13 D PPC
 S BGP1="F. # w/ Endocrine Rx",BGPPIE=15 D PPC
 S BGP1="G. # w/ Gastrointestinal Rx",BGPPIE=17 D PPC
 S BGP1="H. # w/ Pain Med Rx",BGPPIE=19 D PPC
 S BGP1="I. # w/ Skeletal Muscle Relaxant Rx",BGPPIE=29 D PPC
 S BGP1="# w/ Exposure to Multiple High-Risk Meds",BGPPIE=41 D PPC
 Q
PPC ;
 S X=BGP1 D S(X,1,1)
 F X=1:1:3 S N=$P(BGPDAC(X),U,BGPPIE),O=$P(BGPDAB(X),U,BGPPIE) S Y=$$SB^BGP6ELL2($J((N-O),6,1)) D S(Y,,X+1)
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
S(Y,F,P) ;set up array
 I '$G(F) S F=0
 S %=$P(^TMP($J,"BGPDEL",0),U)+F,$P(^TMP($J,"BGPDEL",0),U)=%
 I '$D(^TMP($J,"BGPDEL",%)) S ^TMP($J,"BGPDEL",%)=""
 S $P(^TMP($J,"BGPDEL",%),U,P)=Y
 Q
CALC(N,O) ;
 NEW Z
 S Z=N-O,Z=$FN(Z,"+,",1)
 Q Z
SB(X) ;EP
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
H2 ;
 S BGPX="",BGPX=BGPCYN
 S $P(BGPX,U,2)=$$SB^BGP6ELL2($J(BGPCYP,5,1)),$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)=$$SB^BGP6ELL2($J(BGPPRP,5,1)),$P(BGPX,U,5)=$$SB^BGP6ELL2($J($$CALC(BGPCYP,BGPPRP),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=$$SB^BGP6ELL2($J(BGPBLP,5,1))
 S $P(BGPX,U,8)=$$SB^BGP6ELL2($J($$CALC(BGPCYP,BGPBLP),6))
 D S(BGPX,,2)
 Q
H1 ;EP
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
