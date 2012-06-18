BGP7EL1R ; IHS/CMI/LAB - print ind ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
I1AGEP ;EP
PR ; 
 D HEADER^BGP7DPH W !,^BGPELIA(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3^BGP7EL1P S X=" " D S(X,1,1)
 S X="BASELINE YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="# w/exposure to at least 1" D S(X,1,1) S X=" harmful drug" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,2) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% # w/exposure to at least 1" D S(X,1,1) S X=" harmful drug" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,3) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/antianxiety Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,4) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% A. w/antianxiety Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,5) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="B. # w/antiemetic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,6) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% B. w/antiemetic Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,7) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="C. # w/analgesic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,8) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% C. w/analgesic Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,9) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="D. # w/antihistamine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,10) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% D. w/antihistamine Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,11) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="E. # w/antipsychotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,12) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% E. w/antipsychotic Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,13) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="F. # w/amphetamine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,14) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% F. w/amphetamine Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,15) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="G. # w/barbiturate Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,16) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% G. w/barbiturate Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,17) S Y=$J(V,5,1) D S(Y,,X+1)
 D HEADER^BGP7DPH W !,^BGPELIA(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3^BGP7EL1P S X=" " D S(X,1,1)
 S X=" " D S(X,1,1) S X="H. # w/benzodiazepine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,18) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% H. w/benzodiazepine Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,19) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="I. # w/other benzodiazepine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,20) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% I. w/other benzodiazepine Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,21) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="J. # w/calcium channel blocker Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,22) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% J. w/calcium channel blocker Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,23) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="K. # w/gastro antispasmodic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,24) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% K. w/gastro antispasmodic Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,25) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="L. # w/belladonna alkaloid Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,26) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% L. w/belladonna alkaloid Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,27) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="M. # w/skeletal muscle relaxant Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,28) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% M. w/skeletal muscle relaxant Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,29) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="N. # w/oral estrogen Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,30) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% N. w/oral estrogen Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,31) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="O. # w/oral hypoglycemic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,32) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% O. w/oral hypoglycemic Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,33) S Y=$J(V,5,1) D S(Y,,X+1)
 D HEADER^BGP7DPH W !,^BGPELIA(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3^BGP7EL1P S X=" " D S(X,1,1)
 S X=" " D S(X,1,1) S X="P. # w/narcotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,34) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% P. w/narcotic Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,35) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="Q. # w/vasodilator Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,36) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% Q. w/vasodilator Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,37) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="R. # w/other avoid meds Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,38) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% R. w/other avoid meds Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,39) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# w/ exposure to multiple" D S(X,1,1) S X=" harmful drugs" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,40) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% w/ exposure to multiple" D S(X,1,1) S X=" harmful drugs" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,41) S Y=$J(V,5,1) D S(Y,,X+1)
 Q:BGPQUIT
 ;% changes
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S BGP2="",BGP1="# w/exposure to at least",BGP2=" 1 harmful drug",BGPPIE=3 D PPC
 S BGP2="",BGP1="A. # w/antianxiety Rx",BGPPIE=5 D PPC
 S BGP2="",BGP1="B. # w/antiemetic Rx",BGPPIE=7 D PPC
 S BGP2="",BGP1="C. # w/analgesic Rx",BGPPIE=9 D PPC
 S BGP2="",BGP1="D. # w/antihistamine Rx",BGPPIE=11 D PPC
 S BGP2="",BGP1="E. # w/antipsychotic Rx",BGPPIE=13 D PPC
 S BGP2="",BGP1="F. # w/amphetamine Rx",BGPPIE=15 D PPC
 S BGP2="",BGP1="G. # w/barbiturate Rx",BGPPIE=17 D PPC
 S BGP2="",BGP1="H. # w/benzodiazepine Rx",BGPPIE=19 D PPC
 S BGP2="",BGP1="I. # w/other benzodiazepine Rx",BGPPIE=21 D PPC
 S BGP2="",BGP1="J. # w/calcium channel ",BGP2=" blocker Rx",BGPPIE=23 D PPC
 S BGP2="",BGP1="K. # w/gastro antispasmodic Rx",BGPPIE=25 D PPC
 S BGP2="",BGP1="L. # w/belladonna alkaloid Rx",BGPPIE=27 D PPC
 S BGP2="",BGP1="M. # w/skeletal muscle ",BGP2=" relaxant Rx",BGPPIE=29 D PPC
 S BGP2="",BGP1="N. # w/oral estrogen Rx",BGPPIE=31 D PPC
 S BGP2="",BGP1="O. # w/oral hypoglycemic Rx",BGPPIE=33 D PPC
 S BGP2="",BGP1="P. # w/narcotic Rx",BGPPIE=35 D PPC
 S BGP2="",BGP1="Q. # w/vasodilator Rx",BGPPIE=37 D PPC
 S BGP2="",BGP1="R. # w/other avoid meds Rx",BGPPIE=39 D PPC
 S BGP2="",BGP1="# w/ exposure to multiple",BGP2=" harmful drugs",BGPPIE=41 D PPC
 Q
PPC ;
 D S(BGP1,1,1)
 I BGP2]"" D S(BGP2,1,1)
 F X=1:1:3 S N=$P(BGPDAC(X),U,BGPPIE),O=$P(BGPDAB(X),U,BGPPIE) S Y=$J((N-O),6,1) D S(Y,,X+1)
 Q
V(T,R,N,P) ;EP
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
S(Y,F,P) ;set up array
 ;Q:BGPQUIT
 ;I $Y>(IOSL-5) D HEADER^BGP7DPH Q:BGPQUIT
 ;W !,^BGPELIA(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3 S X=" " D S(X,1,1)
 I $G(F) F J=1:1:F W !
 S T=$S(P=1:1,P=2:38,P=3:50,P=4:62,1:1)
 W ?T,Y
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
