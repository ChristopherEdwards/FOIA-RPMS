BGP7EL1Q ; IHS/CMI/LAB - print ind 05 Feb 2017 9:01 AM ; 
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
I1AGEP ;EP
PR ; 
 D HEADER^BGP7DPH W !,^BGPELIG(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3^BGP7EL1P S X=" " D S(X,1,1)
 S X="PREVIOUS YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1) S X=BGPHD3 D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="# w/ Exposure to 1+" D S(X,1,1) S X=" High-Risk Med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,2) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% w/ Exposure to 1+" D S(X,1,1) S X=" High-Risk Med" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,3) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="A. # w/ Anticholinergic Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,4) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="A. % w/ Anticholinergic Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,5) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="B. # w/ Antithrombotic Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,6) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="B. % w/ Antithrombotic Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,7) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="C. # w/ Anti-infective Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,8) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="C. % w/ Anti-infective Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,9) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="D. # w/ Cardiovascular Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,10) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="D. % w/ Cardiovascular Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,11) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="E. # w/ Central Nervous System Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,12) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="E. % w/ Central Nervous System Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,13) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="F. # w/ Endocrine Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,14) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="F. % w/ Endocrine Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,15) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="G. # w/ Gastrointestinal Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,16) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="G. % w/ Gastrointestinal Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,17) S Y=$J(V,5,1) D S(Y,,X+1)
 D HEADER^BGP7DPH W !,^BGPELIG(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3^BGP7EL1P S X=" " D S(X,1,1)
 S X=" " D S(X,1,1) S X="H. # w/ Pain Med Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,18) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="H. % w/ Pain Med Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,19) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="I. # w/ Skeletal Muscle Relaxant Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,28) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="I. % w/ Skeletal Muscle Relaxant Rx" D S(X,1,1) S X="  w/ % of Total Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,29) S Y=$J(V,5,1) D S(Y,,X+1)
 S X=" " D S(X,1,1) S X="# w/ Exposure to Multiple" D S(X,1,1) S X=" High-Risk Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,40) S Y=$$C(V,0,6) D S(Y,,X+1)
 S X="% w/ Exposure to Multiple" D S(X,1,1) S X=" High-Risk Meds" D S(X,1,1)
 F X=1:1:3 S V=$P(BGPDAP(X),U,41) S Y=$J(V,5,1) D S(Y,,X+1)
 Q:BGPQUIT
 ;% changes
 S X=" " D S(X,1,1) S X="CHANGE FROM PREV YR %" D S(X,1,1)
 S BGP2="",BGP1="# w/ Exposure to 1+",BGP2=" High-Risk Med",BGPPIE=3 D PPC
 S BGP2="",BGP1="A. # w/ Anticholinergic Rx",BGPPIE=5 D PPC
 S BGP2="",BGP1="B. # w/ Antithrombotic Rx",BGPPIE=7 D PPC
 S BGP2="",BGP1="C. # w/ Anti-infective Rx",BGPPIE=9 D PPC
 S BGP2="",BGP1="D. # w/ Cardiovascular Rx",BGPPIE=11 D PPC
 S BGP2="",BGP1="E. # w/ Central Nervous System Rx",BGPPIE=13 D PPC
 S BGP2="",BGP1="F. # w/ Endocrine Rx",BGPPIE=15 D PPC
 S BGP2="",BGP1="G. # w/ Gastrointestinal Rx",BGPPIE=17 D PPC
 S BGP2="",BGP1="H. # w/ Pain Med Rx",BGPPIE=19 D PPC
 S BGP2="",BGP1="I. # w/ Skeletal Muscle ",BGP2=" Relaxant Rx",BGPPIE=29 D PPC
 S BGP2="",BGP1="# w/ Exposure to Multiple",BGP2=" High-Risk Meds",BGPPIE=41 D PPC
 D ^BGP7EL1R
 Q
PPC ;
 D S(BGP1,1,1)
 I BGP2]"" D S(BGP2,1,1)
 F X=1:1:3 S N=$P(BGPDAC(X),U,BGPPIE),O=$P(BGPDAP(X),U,BGPPIE) S Y=$J((N-O),6,1) D S(Y,,X+1)
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPEDLCG(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPEDLPG(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPEDLBG(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPEDLCG(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPEDLPG(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPEDLBG(X,N)),U,P)
 .Q
 Q $S(C:C,1:0)
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
S(Y,F,P) ;set up array
 ;Q:BGPQUIT
 ;I $Y>(IOSL-5) D HEADER^BGP7DPH Q:BGPQUIT
 ;W !,^BGPELIG(BGPIC,53,1,0) S X=" " D S(X,1,1) D H3 S X=" " D S(X,1,1)
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
