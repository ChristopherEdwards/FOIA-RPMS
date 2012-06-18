BGP0ELLT ; IHS/CMI/LAB - print ind ;
 ;;10.0;IHS CLINICAL REPORTING;**1**;JUN 18, 2010
 ;
I1AGEP ;EP
PR ; 
 S X=" " D S(X,1,1) S X="PREVIOUS YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U) S Y=V D S(Y,,X+1)
 S X="# w/exposure to at least 1 high-risk med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,2) S Y=V D S(Y,,X+1)
 S X="% w/exposure to at least 1 high-risk med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,3) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/antianxiety Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,4) S Y=V D S(Y,,X+1)
 S X="% A. w/antianxiety Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,5) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="B. # w/antiemetic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,6) S Y=V D S(Y,,X+1)
 S X="% B. w/antiemetic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,7) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="C. # w/analgesic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,8) S Y=V D S(Y,,X+1)
 S X="% C. w/analgesic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,9) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="D. # w/antihistamine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,10) S Y=V D S(Y,,X+1)
 S X="% D. w/antihistamine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,11) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="E. # w/antipsychotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,12) S Y=V D S(Y,,X+1)
 S X="% E. w/antipsychotic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,13) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="F. # w/amphetamine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,14) S Y=V D S(Y,,X+1)
 S X="% F. w/amphetamine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,15) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="G. # w/barbiturate Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,16) S Y=V D S(Y,,X+1)
 S X="% G. w/barbiturate Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,17) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="H. # w/benzodiazepine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,18) S Y=V D S(Y,,X+1)
 S X="% H. w/benzodiazepine Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,19) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 ;S X=" " D S(X,1,1) S X="I. # w/other benzodiazepine Rx" D S(X,1,1)
 ;F X=1:1:3 S V=$P(BGPDAP(X),U,20) S Y=V D S(Y,,X+1)
 ;S X="% I. w/other benzodiazepine Rx w/ % of total meds" D S(X,1,1)
 ;F X=1:1:3 S V=$P(BGPDAP(X),U,21) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="I. # w/calcium channel blocker Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,22) S Y=V D S(Y,,X+1)
 S X="% I. w/calcium channel blocker Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,23) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="J. # w/gastro antispasmodic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,24) S Y=V D S(Y,,X+1)
 S X="% J. w/gastro antispasmodic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,25) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="K. # w/belladonna alkaloid Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,26) S Y=V D S(Y,,X+1)
 S X="% K. w/belladonna alkaloid Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,27) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="L. # w/skeletal muscle relaxant Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,28) S Y=V D S(Y,,X+1)
 S X="% L. w/skeletal muscle relaxant Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,29) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="M. # w/oral estrogen Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,30) S Y=V D S(Y,,X+1)
 S X="% M. w/oral estrogen Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,31) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="N. # w/oral hypoglycemic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,32) S Y=V D S(Y,,X+1)
 S X="% N. w/oral hypoglycemic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,33) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="O. # w/narcotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,34) S Y=V D S(Y,,X+1)
 S X="% O. w/narcotic Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,35) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="P. # w/vasodilator Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,36) S Y=V D S(Y,,X+1)
 S X="% P. w/vasodilator Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,37) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="Q. # w/other avoid meds Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,38) S Y=V D S(Y,,X+1)
 S X="% Q. w/other avoid meds Rx w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,39) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# w/ exposure to multiple high-risk meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,40) S Y=V D S(Y,,X+1)
 S X="% w/ exposure to multiple high-risk meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,41) S Y=$$SB^BGP0ELL2($J(V,6,1)) D S(Y,,X+1)
 ;% changes
 S X=" " D S(X,1,1) S X="CHANGE FROM PREV YR %" D S(X,1,1)
 S BGP1="# w/exposure to at least 1 high-risk med",BGPPIE=3 D PPC
 S BGP1="A. # w/antianxiety Rx",BGPPIE=5 D PPC
 S BGP1="B. # w/antiemetic Rx",BGPPIE=7 D PPC
 S BGP1="C. # w/analgesic Rx",BGPPIE=9 D PPC
 S BGP1="D. # w/antihistamine Rx",BGPPIE=11 D PPC
 S BGP1="E. # w/antipsychotic Rx",BGPPIE=13 D PPC
 S BGP1="F. # w/amphetamine Rx",BGPPIE=15 D PPC
 S BGP1="G. # w/barbiturate Rx",BGPPIE=17 D PPC
 S BGP1="H. # w/benzodiazepine Rx",BGPPIE=19 D PPC
 ;S BGP1="I. # w/other benzodiazepine Rx",BGPPIE=21 D PPC
 S BGP1="I. # w/calcium channel blocker Rx",BGPPIE=23 D PPC
 S BGP1="J. # w/gastro antispasmodic Rx",BGPPIE=25 D PPC
 S BGP1="K. # w/belladonna alkaloid Rx",BGPPIE=27 D PPC
 S BGP1="L. # w/skeletal muscle relaxant Rx",BGPPIE=29 D PPC
 S BGP1="M. # w/oral estrogen Rx",BGPPIE=31 D PPC
 S BGP1="N. # w/oral hypoglycemic Rx",BGPPIE=33 D PPC
 S BGP1="O. # w/narcotic Rx",BGPPIE=35 D PPC
 S BGP1="P. # w/vasodilator Rx",BGPPIE=37 D PPC
 S BGP1="Q. # w/other avoid meds Rx",BGPPIE=39 D PPC
 S BGP1="# w/ exposure to multiple high-risk meds",BGPPIE=41 D PPC
 D ^BGP0ELLU
 Q
PPC ;
 S X=BGP1 D S(X,1,1)
 F X=1:1:3 S N=$P(BGPDAC(X),U,BGPPIE),O=$P(BGPDAP(X),U,BGPPIE) S Y=$$SB^BGP0ELL2($J((N-O),6,1)) D S(Y,,X+1)
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPELDCT(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPELDPT(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPELDBT(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCT(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPT(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBT(X,N)),U,P)
 .Q
 Q $S(C:C,1:0)
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
 S $P(BGPX,U,2)=$$SB^BGP0ELL2($J(BGPCYP,5,1)),$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)=$$SB^BGP0ELL2($J(BGPPRP,5,1)),$P(BGPX,U,5)=$$SB^BGP0ELL2($J($$CALC(BGPCYP,BGPPRP),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=$$SB^BGP0ELL2($J(BGPBLP,5,1))
 S $P(BGPX,U,8)=$$SB^BGP0ELL2($J($$CALC(BGPCYP,BGPBLP),6))
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
