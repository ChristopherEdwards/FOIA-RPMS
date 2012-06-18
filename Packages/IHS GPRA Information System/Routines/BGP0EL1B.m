BGP0EL1B ; IHS/CMI/LAB - print ind 1 ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
I1AGE ;EP  special age tallies
 S BGPHD1="ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Active Clinical"
 D HEADER^BGP0DPH Q:BGPQUIT  W !,^BGPELIT(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S C=0
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
 S BGPHD1="MALE ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Male Active Clinical"
 D HEADER^BGP0DPH Q:BGPQUIT  W !,^BGPELIT(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S C=0
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
 S BGPHD1="FEMALE ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Female Active Clinical"
 D HEADER^BGP0DPH Q:BGPQUIT  W !,^BGPELIT(BGPIC,53,1,0)  D H3
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
 ;gather up all #'s
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+I) S BGPPC=$O(^BGPELIIT("C",BGPF,0))
 I I=0 D
 .S BGPDF=$P(^BGPELIIT(BGPPC,0),U,8)
 .S BGPNP=$P(^DD(90379.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 .S $P(BGPDAC(C),U)=$$V(1,BGPRPT,N,P)
 .S $P(BGPDAP(C),U)=$$V(2,BGPRPT,N,P)
 .S $P(BGPDAB(C),U)=$$V(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPELIIT(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90379.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,P1)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,P2)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,P1)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,P1)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,P2)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,P1)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,P1)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,P2)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,P1)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGEP ;
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+12
 S BGPL1="w/ CRC Screening",BGPL2="-No Refusals (GPRA)",P1=2,P2=3 D DSP
 S BGPL1="# w/ CRC Screening",BGPL2="Refusal",P1=4,P2=5 D DSP
 S BGPL1="# w/FOBT/FIT test during",BGPL2="Report Period",P1=6,P2=7 D DSP
 S BGPL1="# w/Flex Sig, DCBE, ",BGPL2="or Colonscopy",P1=8,P2=9 D DSP
 S BGPL1="# w/Flex Sig or ",BGPL2="Colonoscopy",P1=10,P2=11 D DSP
 S BGPL1="# w/Flex Sig & DCBE ",BGPL2="or Colonoscopy",P1=12,P2=13 D DSP
PR ; 
 D HEADER^BGP0DPH Q:BGPQUIT  W !,^BGPELIT(BGPIC,53,1,0) D H3
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+12
 S BGPL1="w/ CRC Screening",BGPL2="-No Refusals (GPRA)",P1=2,P2=3 D DSPP
 S BGPL1="# w/ CRC Screening",BGPL2="Refusal",P1=4,P2=5 D DSPP
 S BGPL1="# w/FOBT/FIT test during",BGPL2="Report Period",P1=6,P2=7 D DSPP
 S BGPL1="# w/Flex Sig, DCBE, ",BGPL2="or Colonscopy",P1=8,P2=9 D DSPP
 S BGPL1="# w/Flex Sig or ",BGPL2="Colonoscopy",P1=10,P2=11 D DSPP
 S BGPL1="# w/Flex Sig & DCBE ",BGPL2="or Colonoscopy",P1=12,P2=13 D DSPP
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"# w/CRC screening"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/ CRC Screening",!?2,"Refusal"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/FOBT/FIT test in",!," during Report Period"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/Flex Sig, DCBE, ",!," Colonscopy"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/Flex Sig or ",!," Colonoscopy"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAP(X),U,11) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/Flex Sig & DCBE ",!," or Colonoscopy"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAP(X),U,13) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
BL ;
 D HEADER^BGP0DPH Q:BGPQUIT  W !,^BGPELIT(BGPIC,53,1,0) D H3
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+12
 S BGPL1="w/ CRC Screening",BGPL2="-No Refusals (GPRA)",P1=2,P2=3 D DSPB
 S BGPL1="# w/ CRC Screening",BGPL2="Refusal",P1=4,P2=5 D DSPB
 S BGPL1="# w/FOBT/FIT test during",BGPL2="Report Period",P1=6,P2=7 D DSPB
 S BGPL1="# w/Flex Sig, DCBE, ",BGPL2="or Colonscopy",P1=8,P2=9 D DSPB
 S BGPL1="# w/Flex Sig or ",BGPL2="Colonoscopy",P1=10,P2=11 D DSPB
 S BGPL1="# w/Flex Sig & DCBE ",BGPL2="or Colonoscopy",P1=12,P2=13 D DSPB
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"# w/CRC screening"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/ CRC Screening",!?2,"Refusal"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/FOBT/FIT test in",!," during Report Period"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
  W !,"# w/Flex Sig, DCBE, ",!," Colonscopy"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/Flex Sig or ",!," Colonoscopy"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAB(X),U,11) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/Flex Sig & DCBE ",!," or Colonoscopy"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAB(X),U,13) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 Q
DSP ;
 W !,"# ",BGPL1,!?2,BGPL2
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,P1) W ?T,$$C(V,0,6) S T=T+12
 W !,"% ",BGPL1,!?2,BGPL2
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,P2) W ?T,$J(V,6,1) S T=T+12
 Q
DSPP ;
 W !,"# ",BGPL1,!?2,BGPL2
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,P1) W ?T,$$C(V,0,6) S T=T+12
 W !,"% ",BGPL1,!?2,BGPL2
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,P2) W ?T,$J(V,6,1) S T=T+12
 Q
DSPB ;
 W !,"# ",BGPL1,!?2,BGPL2
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,P1) W ?T,$$C(V,0,6) S T=T+12
 W !,"% ",BGPL1,!?2,BGPL2
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,P2) W ?T,$J(V,6,1) S T=T+12
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
H3 ;EP
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?30,"55-64",?42,"65-74",?54,"75-84",?65,">84 yrs",!
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 I T=1 Q $P($G(^BGPELDCT(R,N)),U,P)
 I T=2 Q $P($G(^BGPELDPT(R,N)),U,P)
 I T=3 Q $P($G(^BGPELDBT(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCT(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPT(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBT(X,N)),U,P)
 .Q
 Q C
C(X,X2,X3) ;
 NEW A,B,C,D,E,F,G,H,I,J,K
 D COMMA^%DTC
 Q X
