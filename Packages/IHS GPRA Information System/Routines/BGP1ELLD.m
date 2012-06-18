BGP1ELLD ; IHS/CMI/LAB - print ind ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
I1AGE ;EP
 S BGPHD1="ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Active Clinical Patients"
 S X=" " D S(X,1,1) D H3^BGP1ELL2 S X=" " D S(X,1,1)
 F BGPX="CCD.1","CCD.2","CCD.3","CCD.4" D
 .S C=$P(BGPX,".",2)
 .S P1=2,P2=3,I=0 D I1AGE1
 .S P1=4,P2=5,I=4 D I1AGE1
 .S P1=6,P2=7,I=8 D I1AGE1
 .S P1=8,P2=9,I=12 D I1AGE1
 .S P1=10,P2=11,I=16 D I1AGE1
 .S P1=12,P2=13,I=20 D I1AGE1
 D I1AGEP
MALE ;
 S BGPHD1="MALE ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Male Active Clinical Patients"
 S X=" " D S(X,1,1) D H3^BGP1ELL2 S X=" " D S(X,1,1)
 K BGPDAC,BGPDAP,BGPDAB
 F BGPX="CCE.1","CCE.2","CCE.3","CCE.4" D
 .S C=$P(BGPX,".",2)
 .S P1=2,P2=3,I=0 D I1AGE1
 .S P1=4,P2=5,I=4 D I1AGE1
 .S P1=6,P2=7,I=8 D I1AGE1
 .S P1=8,P2=9,I=12 D I1AGE1
 .S P1=10,P2=11,I=16 D I1AGE1
 .S P1=12,P2=13,I=20 D I1AGE1
 D I1AGEP
FEMALE ;
 S BGPHD1="FEMALE ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Female Active Clinical Patients"
 S X=" " D S(X,1,1) D H3^BGP1ELL2 S X=" " D S(X,1,1)
 K BGPDAC,BGPDAP,BGPDAB S C=0
 F BGPX="CCF.1","CCF.2","CCF.3","CCF.4" D
 .S C=$P(BGPX,".",2)
 .S P1=2,P2=3,I=0 D I1AGE1
 .S P1=4,P2=5,I=4 D I1AGE1
 .S P1=6,P2=7,I=8 D I1AGE1
 .S P1=8,P2=9,I=12 D I1AGE1
 .S P1=10,P2=11,I=16 D I1AGE1
 .S P1=12,P2=13,I=20 D I1AGE1
 D I1AGEP
 Q
I1AGE1 ;
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+I) S BGPPC=$O(^BGPELIIB("C",BGPF,0))
 I I=0 D
 .S BGPDF=$P(^BGPELIIB(BGPPC,0),U,8)
 .S BGPNP=$P(^DD(90547.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 .S $P(BGPDAC(C),U)=$$V(1,BGPRPT,N,P)
 .S $P(BGPDAP(C),U)=$$V(2,BGPRPT,N,P)
 .S $P(BGPDAB(C),U)=$$V(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPELIIB(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90547.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,P1)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,P2)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,P1)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,P1)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,P2)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,P1)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,P1)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,P2)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,P1)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGEP ;
 S X=" " D S(X,1,1)
 S X="CURRENT REPORT PERIOD" D S(X,1,1) S X=" " D S(X,1,1)
 S X=BGPHD2 D S(X,1,1)
 NEW BGPL1,BGPL2,P1,P2
 F X=1:1:4 S V=$P(BGPDAC(X),U) S Y=V D S(Y,,X+1)
 S BGPL1="w/CRC screening-No Refusals (GPRA)",P1=2,P2=3 D DSP
 S BGPL1="# w/ CRC Screening Refusal",P1=4,P2=5 D DSP
 S BGPL1="w/FOBT/FIT test during Report Period",P1=6,P2=7 D DSP
 S BGPL1="# w/Flex Sig, DCBE, or Colonscopy",P1=8,P2=9 D DSP
 S BGPL1="# w/Flex Sig or Colonoscopy",P1=10,P2=11 D DSP
 S BGPL1="# w/Flex Sig & DCBE or Colonoscopy",P1=12,P2=13 D DSP
 ;
PR ; 
 S X=" " D S(X,1,1) S X="PREVIOUS YEAR PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAP(X),U) S Y=V D S(Y,,X+1)
 S BGPL1="w/CRC screening-No Refusals (GPRA)",P1=2,P2=3 D DSPP
 S BGPL1="# w/ CRC Screening Refusal",P1=4,P2=5 D DSPP
 S BGPL1="w/FOBT/FIT test during Report Period",P1=6,P2=7 D DSPP
 S BGPL1="# w/Flex Sig, DCBE, or Colonscopy",P1=8,P2=9 D DSPP
 S BGPL1="# w/Flex Sig or Colonoscopy",P1=10,P2=11 D DSPP
 S BGPL1="# w/Flex Sig & DCBE or Colonoscopy",P1=12,P2=13 D DSPP
 ;percentage changes
 S X=" " D S(X,1,1) S X="CHANGE FROM PREV YR %" D S(X,1,1)
 S X="w/CRC screening" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/ CRC Screening Refusal" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/FOBT/FIT test during Report Period" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/Flex Sig, DCBE, or Colonscopy" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/Flex Sig or Colonoscopy" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAP(X),U,11) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/Flex Sig & DCBE or Colonoscopy" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAP(X),U,13) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
BL ;
 S X=" " D S(X,1,1) S X="BASELINE REPORT PERIOD" D S(X,1,1)
 S X=" " D S(X,1,1) S X=BGPHD2 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U) S Y=V D S(Y,,X+1)
 S BGPL1="w/CRC screening-No Refusals (GPRA)",P1=2,P2=3 D DSPB
 S BGPL1="# w/ CRC Screening Refusal",P1=4,P2=5 D DSPB
 S BGPL1="w/FOBT/FIT test during Report Period",P1=6,P2=7 D DSPB
 S BGPL1="# w/Flex Sig, DCBE, or Colonscopy",P1=8,P2=9 D DSPB
 S BGPL1="# w/Flex Sig or Colonoscopy",P1=10,P2=11 D DSPB
 S BGPL1="# w/Flex Sig & DCBE or Colonoscopy",P1=12,P2=13 D DSPB
 ;percentage changes
 S X=" " D S(X,1,1) S X="CHANGE FROM BASE YR %" D S(X,1,1)
 S X="w/CRC screening" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/ CRC Screening Refusal" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/FOBT/FIT test during Report Period" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/Flex Sig, DCBE, or Colonscopy" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/Flex Sig or Colonoscopy" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAB(X),U,11) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 S X="# w/Flex Sig & DCBE or Colonoscopy" D S(X,1,1)
 F X=1:1:4 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAB(X),U,13) S Y=$$SB^BGP1ELL2($J((N-O),6,1)) D S(Y,,X+1)
 Q
DSP ;
 S X="# "_BGPL1 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAC(X),U,P1) S Y=V D S(Y,,X+1)
 S X="% "_BGPL1 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAC(X),U,P2) S Y=$$SB^BGP1ELL2($J(V,6,1)) D S(Y,,X+1)
 Q
DSPP ;
 S X="# "_BGPL1 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAP(X),U,P1) S Y=V D S(Y,,X+1)
 S X="% "_BGPL1 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAP(X),U,P2) S Y=$$SB^BGP1ELL2($J(V,6,1)) D S(Y,,X+1)
 Q
 ;
DSPB ;
 S X="# "_BGPL1 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,P1) S Y=V D S(Y,,X+1)
 S X="% "_BGPL1 D S(X,1,1)
 F X=1:1:4 S V=$P(BGPDAB(X),U,P2) S Y=$$SB^BGP1ELL2($J(V,6,1)) D S(Y,,X+1)
 Q
 ;
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 NEW X
 I T=1 S X=$P($G(^BGPELDCB(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=2 S X=$P($G(^BGPELDPB(R,N)),U,P) Q $S(X]"":X,1:0)
 I T=3 S X=$P($G(^BGPELDBB(R,N)),U,P) Q $S(X]"":X,1:0)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCB(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPB(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBB(X,N)),U,P)
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
H3 ;EP
 S X="Colorectal Cancer Screening" D S(X,1,1) S Y=" " D S(Y,1,1) S X=BGPHD1 D S(X,1,1) S Y=" " D S(Y,1,1)
 S X="Age Distribution" D S(X,1,1) S X=" " D S(X,1,1)
 S Y="55-64" D S(Y,1,2)
 S Y="65-74" D S(Y,,3)
 S Y="75-84" D S(Y,,4)
 S Y=">84 yrs" D S(Y,,5)
 Q
SB(X) ;EP - Strip leading and trailing blanks from X.
 X ^DD("FUNC",$O(^DD("FUNC","B","STRIPBLANKS",0)),1)
 Q X
H2 ;
 S BGPX="",BGPX=BGPCYN
 S $P(BGPX,U,2)=$$SB^BGP1ELL2($J(BGPCYP,5,1)),$P(BGPX,U,3)=BGPPRN,$P(BGPX,U,4)=$$SB^BGP1ELL2($J(BGPPRP,5,1)),$P(BGPX,U,5)=$$SB^BGP1ELL2($J($$CALC(BGPCYP,BGPPRP),6)),$P(BGPX,U,6)=BGPBLN,$P(BGPX,U,7)=$$SB^BGP1ELL2($J(BGPBLP,5,1))
 S $P(BGPX,U,8)=$$SB^BGP1ELL2($J($$CALC(BGPCYP,BGPBLP),6))
 D S(BGPX,,2)
 Q
