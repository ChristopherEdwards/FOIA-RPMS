BGP4EL1R ; IHS/CMI/LAB - print ind ;
 ;;14.1;IHS CLINICAL REPORTING;;MAY 29, 2014;Build 114
 ;
I1AGEP ;EP
PR ; 
 D HEADER^BGP4DPH W !,^BGPELIJ(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3^BGP4EL1P S X=" " D S(X,1,1)
 S X="BASELINE YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="# w/exposure to at least 1" D S(X,1,1) S X=" high-risk med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,2) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% # w/exposure to at least 1" D S(X,1,1) S X=" high-risk med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,3) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/anticholinergic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,4) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="A. % w/anticholinergic Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,5) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="B. # w/antithrombotic Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,6) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="B. % w/antithrombotic Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,7) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="C. # w/anti-infective Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,8) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="C. % w/anti-infective Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,9) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="D. # w/cardiovascular Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,10) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="D. % w/cardiovascular Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,11) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="E. # w/central nervous system Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,12) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="E. % w/central nervous system Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,13) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="F. # w/endocrine Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,14) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="F. % w/endocrine Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,15) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="G. # w/gastrointestinal Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,16) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="G. % w/gastrointestinal Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,17) S Y=$J(V,5,1) D S(Y,,X+1)
 D HEADER^BGP4DPH W !,^BGPELIJ(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3^BGP4EL1P S X=" " D S(X,1,1)
 S X=" " D S(X,1,1) S X="H. # w/pain med Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,18) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="H. % w/pain med Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,19) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="I. # w/skeletal muscle relaxant Rx" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,28) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="I. % w/skeletal muscle relaxant Rx" D S(X,1,1) S X="  w/ % of total meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,29) S Y=$J(V,5,1) D S(Y,,X+1)
 ;D HEADER^BGP4DPH W !,^BGPELIJ(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3^BGP4EL1P S X=" " D S(X,1,1)
 S X=" " D S(X,1,1) S X="# w/ exposure to multiple" D S(X,1,1) S X=" high-risk meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,40) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% w/ exposure to multiple" D S(X,1,1) S X=" high-risk meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAB(X),U,41) S Y=$J(V,5,1) D S(Y,,X+1)
 Q:BGPQUIT
 ;% changes
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S BGP2="",BGP1="# w/exposure to at least",BGP2=" 1 high-risk med",BGPPIE=3 D PPC
 S BGP2="",BGP1="A. # w/anticholinergic Rx",BGPPIE=5 D PPC
 S BGP2="",BGP1="B. # w/antithrombotic Rx",BGPPIE=7 D PPC
 S BGP2="",BGP1="C. # w/anti-infective Rx",BGPPIE=9 D PPC
 S BGP2="",BGP1="D. # w/cardiovascular Rx",BGPPIE=11 D PPC
 S BGP2="",BGP1="E. # w/central nervous system Rx",BGPPIE=13 D PPC
 S BGP2="",BGP1="F. # w/endocrine Rx",BGPPIE=15 D PPC
 S BGP2="",BGP1="G. # w/gastrointestinal Rx",BGPPIE=17 D PPC
 S BGP2="",BGP1="H. # w/pain med Rx",BGPPIE=19 D PPC
 S BGP2="",BGP1="I. # w/skeletal muscle ",BGP2=" relaxant Rx",BGPPIE=29 D PPC
 S BGP2="",BGP1="# w/ exposure to multiple",BGP2=" high-risk meds",BGPPIE=41 D PPC
 Q
PPC ;
 D S(BGP1,1,1)
 I BGP2]"" D S(BGP2,1,1)
 F X=1:1:3 S N=$P(BGPDAC(X),U,BGPPIE),O=$P(BGPDAB(X),U,BGPPIE) S Y=$J((N-O),6,1) D S(Y,,X+1)
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPELDCJ(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPELDPJ(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPELDBJ(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCJ(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPJ(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBJ(X,N)),U,P)
 .Q
 Q $S(C:C,1:0)
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
S(Y,F,P) ;set up array
 ;Q:BGPQUIT
 ;I $Y>(IOSL-5) D HEADER^BGP4DPH Q:BGPQUIT
 ;W !,^BGPELIJ(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3 S X=" " D S(X,1,1)
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
