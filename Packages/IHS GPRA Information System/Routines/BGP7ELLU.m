BGP7ELLU ; IHS/CMI/LAB - print ind ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
I1AGEP ;EP
BL ; 
 S X=" " D S(X,1,1) S X="BASELINE YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U) S Y=V D S(Y,,X+1)
 S X="# w/exposure to at least 1 harmful drug" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/exposure to at least 1 harmful drug" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,3) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/antianxiety Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,4) S Y=V D S(Y,,X+1)
 S X="% A. w/antianxiety Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,5) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="B. # w/antiemetic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,6) S Y=V D S(Y,,X+1)
 S X="% B. w/antiemetic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,7) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="C. # w/analgesic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,8) S Y=V D S(Y,,X+1)
 S X="% C. w/analgesic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,9) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="D. # w/antihistamine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,10) S Y=V D S(Y,,X+1)
 S X="% D. w/antihistamine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,11) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="E. # w/antipsychotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,12) S Y=V D S(Y,,X+1)
 S X="% E. w/antipsychotic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,13) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="F. # w/amphetamine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,14) S Y=V D S(Y,,X+1)
 S X="% F. w/amphetamine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,15) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="G. # w/barbiturate Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,16) S Y=V D S(Y,,X+1)
 S X="% G. w/barbiturate Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,17) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="H. # w/benzodiazepine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,18) S Y=V D S(Y,,X+1)
 S X="% H. w/benzodiazepine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,19) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="I. # w/other benzodiazepine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,20) S Y=V D S(Y,,X+1)
 S X="% I. w/other benzodiazepine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,21) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="J. # w/calcium channel blocker Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,22) S Y=V D S(Y,,X+1)
 S X="% J. w/calcium channel blocker Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,23) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="K. # w/gastro antispasmodic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,24) S Y=V D S(Y,,X+1)
 S X="% K. w/gastro antispasmodic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,25) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="L. # w/belladonna alkaloid Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,26) S Y=V D S(Y,,X+1)
 S X="% L. w/belladonna alkaloid Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,27) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="M. # w/skeletal muscle relaxant Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,28) S Y=V D S(Y,,X+1)
 S X="% M. w/skeletal muscle relaxant Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,29) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="N. # w/oral estrogen Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,30) S Y=V D S(Y,,X+1)
 S X="% N. w/oral estrogen Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,31) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="O. # w/oral hypoglycemic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,32) S Y=V D S(Y,,X+1)
 S X="% O. w/oral hypoglycemic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,33) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="P. # w/narcotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,34) S Y=V D S(Y,,X+1)
 S X="% P. w/narcotic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,35) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="Q. # w/vasodilator Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,36) S Y=V D S(Y,,X+1)
 S X="% Q. w/vasodilator Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,37) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="R. # w/other avoid meds Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,38) S Y=V D S(Y,,X+1)
 S X="% R. w/other avoid meds Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,39) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# w/ exposure to multiple harmful drugs" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,40) S Y=V D S(Y,,X+1)
 S X="% w/ exposure to multiple harmful drugs" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,41) S Y=$$SB($J(V,6,1)) D S(Y,,X+1)
 ;% changes
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S BGP1="# w/exposure to at least 1 harmful drug",BGPPIE=3 D PPC
 S BGP1="A. # w/antianxiety Rx",BGPPIE=5 D PPC
 S BGP1="B. # w/antiemetic Rx",BGPPIE=7 D PPC
 S BGP1="C. # w/analgesic Rx",BGPPIE=9 D PPC
 S BGP1="D. # w/antihistamine Rx",BGPPIE=11 D PPC
 S BGP1="E. # w/antipsychotic Rx",BGPPIE=13 D PPC
 S BGP1="F. # w/amphetamine Rx",BGPPIE=15 D PPC
 S BGP1="G. # w/barbiturate Rx",BGPPIE=17 D PPC
 S BGP1="H. # w/benzodiazepine Rx",BGPPIE=19 D PPC
 S BGP1="I. # w/other benzodiazepine Rx",BGPPIE=21 D PPC
 S BGP1="J. # w/calcium channel blocker Rx",BGPPIE=23 D PPC
 S BGP1="K. # w/gastro antispasmodic Rx",BGPPIE=25 D PPC
 S BGP1="L. # w/belladonna alkaloid Rx",BGPPIE=27 D PPC
 S BGP1="M. # w/skeletal muscle relaxant Rx",BGPPIE=29 D PPC
 S BGP1="N. # w/oral estrogen Rx",BGPPIE=31 D PPC
 S BGP1="O. # w/oral hypoglycemic Rx",BGPPIE=33 D PPC
 S BGP1="P. # w/narcotic Rx",BGPPIE=35 D PPC
 S BGP1="Q. # w/vasodilator Rx",BGPPIE=37 D PPC
 S BGP1="R. # w/other avoid meds Rx",BGPPIE=39 D PPC
 S BGP1="# w/ exposure to multiple harmful drugs",BGPPIE=41 D PPC
 Q
PPC ;
 S X=BGP1 D S(X,1,1)
 F X=1:1:3 S N=$P(BGPDAC(X),U,BGPPIE),O=$P(BGPDAB(X),U,BGPPIE) S Y=$$SB($J((N-O),6,1)) D S(Y,,X+1)
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
 S BGPX="",BGPX=BGPCYN,$P(BGPX,U,2)=$$SB($J(BGPCYP,5,1)),$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)=$$SB($J(BGPPRP,5,1)),$P(BGPX,U,5)=$$SB($J($$CALC(BGPCYP,BGPPRP),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=$$SB($J(BGPBLP,5,1))
 S $P(BGPX,U,8)=$$SB($J($$CALC(BGPCYP,BGPBLP),6))
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
