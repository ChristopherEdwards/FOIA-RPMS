BGP5ELLU ; IHS/CMI/LAB - print ind ;
 ;;15.1;IHS CLINICAL REPORTING;;MAY 06, 2015;Build 143
 ;
I1AGEP ;EP
BL ; 
 S X=" " D S(X,1,1) S X="BASELINE YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U) S Y=V D S(Y,,X+1)
 S X="# w/exposure to at least 1 high-risk med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/exposure to at least 1 high-risk med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,3) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/anticholinergic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,4) S Y=V D S(Y,,X+1)
 S X="A. % w/anticholinergic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,5) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="B. # w/antithrombotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,6) S Y=V D S(Y,,X+1)
 S X="B. % w/antithrombotic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,7) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="C. # w/anti-infective Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,8) S Y=V D S(Y,,X+1)
 S X="C. % w/anti-infective Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,9) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="D. # w/cardiovascular Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,10) S Y=V D S(Y,,X+1)
 S X="D. % w/cardiovascular Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,11) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="E. # w/central nervous system Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,12) S Y=V D S(Y,,X+1)
 S X="E. % w/central nervous system Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,13) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="F. # w/endocrine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,14) S Y=V D S(Y,,X+1)
 S X="F. % w/endocrine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,15) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="G. # w/gastrointestinal Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,16) S Y=V D S(Y,,X+1)
 S X="G. % w/gastrointestinal Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,17) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="H. # w/pain med Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,18) S Y=V D S(Y,,X+1)
 S X="H. % w/pain med Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,19) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 ;
 S X=" " D S(X,1,1) S X="I. # w/skeletal muscle relaxant Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,28) S Y=V D S(Y,,X+1)
 S X="I. % w/skeletal muscle relaxant Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,29) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 ;
 S X=" " D S(X,1,1) S X="# w/ exposure to multiple high-risk meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,40) S Y=V D S(Y,,X+1)
 S X="% w/ exposure to multiple high-risk meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,41) S Y=$$SB^BGP5ELL2($J(V,6,1)) D S(Y,,X+1)
 ;% changes
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S BGP1="# w/exposure to at least 1 high-risk med",BGPPIE=3 D PPC
 S BGP1="A. # w/anticholinergic Rx",BGPPIE=5 D PPC
 S BGP1="B. # w/antithrombotic Rx",BGPPIE=7 D PPC
 S BGP1="C. # w/anti-infective Rx",BGPPIE=9 D PPC
 S BGP1="D. # w/cardiovascular Rx",BGPPIE=11 D PPC
 S BGP1="E. # w/central nervous system Rx",BGPPIE=13 D PPC
 S BGP1="F. # w/endocrine Rx",BGPPIE=15 D PPC
 S BGP1="G. # w/gastrointestinal Rx",BGPPIE=17 D PPC
 S BGP1="H. # w/pain med Rx",BGPPIE=19 D PPC
 S BGP1="I. # w/skeletal muscle relaxant Rx",BGPPIE=29 D PPC
 S BGP1="# w/ exposure to multiple high-risk meds",BGPPIE=41 D PPC
 Q
PPC ;
 S X=BGP1 D S(X,1,1)
 F X=1:1:3 S N=$P(BGPDAC(X),U,BGPPIE),O=$P(BGPDAB(X),U,BGPPIE) S Y=$$SB^BGP5ELL2($J((N-O),6,1)) D S(Y,,X+1)
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
 S $P(BGPX,U,2)=$$SB^BGP5ELL2($J(BGPCYP,5,1)),$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)=$$SB^BGP5ELL2($J(BGPPRP,5,1)),$P(BGPX,U,5)=$$SB^BGP5ELL2($J($$CALC(BGPCYP,BGPPRP),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=$$SB^BGP5ELL2($J(BGPBLP,5,1))
 S $P(BGPX,U,8)=$$SB^BGP5ELL2($J($$CALC(BGPCYP,BGPBLP),6))
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
