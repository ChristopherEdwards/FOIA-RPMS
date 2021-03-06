BGP6EL1B ; IHS/CMI/LAB - print ind 1 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I1AGE ;EP  special age tallies
 S BGPHD1="ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Active Clinical"
 D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPELIS(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (C,D,E,F,G,H,I,J,K)=0 F BGPX="CCD.1","CCD.2","CCD.3","CCD.4" D I1AGE1,I1AGE2,I1AGE3,I1AGE4
 D I1AGEP
MALE ;
 S BGPHD1="MALE ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Male Active Clinical"
 D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPELIS(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (C,D,E,F,G,H,I,J,K)=0 F BGPX="CCE.1","CCE.2","CCE.3","CCE.4" D I1AGE1,I1AGE2,I1AGE3,I1AGE4
 D I1AGEP
FEMALE ;
 S BGPHD1="FEMALE ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Female Active Clinical"
 D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPELIS(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (C,D,E,F,G,H,I,J,K)=0 F BGPX="CCF.1","CCF.2","CCF.3","CCF.4" D I1AGE1,I1AGE2,I1AGE3,I1AGE4
 D I1AGEP
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF="ELD."_BGPX S BGPPC=$O(^BGPELIIS("C",BGPF,0))
 S BGPDF=$P(^BGPELIIS(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90376.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPELIIS(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90376.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGE2 ;
 S D=D+1
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+4) S BGPPC=$O(^BGPELIIS("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPELIIS(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90376.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,4)=$$V(1,BGPRPT,N,P),$P(BGPDAC(D),U,5)=$S($P(BGPDAC(D),U,2):($P(BGPDAC(D),U,4)/$P(BGPDAC(D),U,2)*100),1:"")
 S $P(BGPDAP(D),U,4)=$$V(2,BGPRPT,N,P),$P(BGPDAP(D),U,5)=$S($P(BGPDAP(D),U,2):($P(BGPDAP(D),U,4)/$P(BGPDAP(D),U,2)*100),1:"")
 S $P(BGPDAB(D),U,4)=$$V(3,BGPRPT,N,P),$P(BGPDAB(D),U,5)=$S($P(BGPDAB(D),U,2):($P(BGPDAB(D),U,4)/$P(BGPDAB(D),U,2)*100),1:"")
 Q
I1AGE3 ;
 S E=E+1
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+8) S BGPPC=$O(^BGPELIIS("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPELIIS(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90376.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(E),U,6)=$$V(1,BGPRPT,N,P),$P(BGPDAC(E),U,7)=$S($P(BGPDAC(E),U,1):($P(BGPDAC(E),U,6)/$P(BGPDAC(E),U)*100),1:"")
 S $P(BGPDAP(E),U,6)=$$V(2,BGPRPT,N,P),$P(BGPDAP(E),U,7)=$S($P(BGPDAP(E),U,1):($P(BGPDAP(E),U,6)/$P(BGPDAP(E),U)*100),1:"")
 S $P(BGPDAB(E),U,6)=$$V(3,BGPRPT,N,P),$P(BGPDAB(E),U,7)=$S($P(BGPDAB(E),U,1):($P(BGPDAB(E),U,6)/$P(BGPDAB(E),U)*100),1:"")
 Q
I1AGE4 ;
 S F=F+1
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+12) S BGPPC=$O(^BGPELIIS("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPELIIS(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90376.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(F),U,8)=$$V(1,BGPRPT,N,P),$P(BGPDAC(F),U,9)=$S($P(BGPDAC(F),U,1):($P(BGPDAC(F),U,8)/$P(BGPDAC(F),U)*100),1:"")
 S $P(BGPDAP(F),U,8)=$$V(2,BGPRPT,N,P),$P(BGPDAP(F),U,9)=$S($P(BGPDAP(F),U,1):($P(BGPDAP(F),U,8)/$P(BGPDAP(F),U)*100),1:"")
 S $P(BGPDAB(F),U,8)=$$V(3,BGPRPT,N,P),$P(BGPDAB(F),U,9)=$S($P(BGPDAB(F),U,1):($P(BGPDAB(F),U,8)/$P(BGPDAB(F),U)*100),1:"")
 Q
I1AGEP ;
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+12
 W !,"# w/CRC Screening",!," (GPRA)"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/CRC Screening",!," (GPRA)"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+12
 W !,"# A. Refusals w/ % of",!," Total CRC"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,4) W ?T,$$C(V,0,6) S T=T+12
 W !,"% A. Refusals w/ % of",!," Total CRC"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,5) W ?T,$J(V,6,1) S T=T+12
 W !,"B. # w/FOB test in",!," during Report Period"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,6) W ?T,$$C(V,0,6) S T=T+12
 W !,"% B. w/FOB test in",!," during Report Period"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,7) W ?T,$J(V,6,1) S T=T+12
 W !,"# w/rectal exam in past 2 yrs",!," or refusal past year"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,8) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/rectal exam in past 2 yrs",!," or refusal past year"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,9) W ?T,$J(V,6,1) S T=T+12
PR ; 
 I $Y>(BGPIOSL-13) D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPELIS(BGPIC,53,1,0) D H3
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+12
 W !,"# w/CRC Screening",!," (GPRA)"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/CRC Screening",!," (GPRA)"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+12
 W !!,"# A. Refusals w/ % of",!," Total CRC"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,4) W ?T,$$C(V,0,6) S T=T+12
 W !,"% A. Refusals w/ % of",!," Total CRC"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,5) W ?T,$J(V,6,1) S T=T+12
 W !,"B. # w/FOB test in",!," during Report Period"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,6) W ?T,$$C(V,0,6) S T=T+12
 W !,"% B. w/FOB test in",!," during Report Period"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,7) W ?T,$J(V,6,1) S T=T+12
 W !!,"# w/rectal exam in past 2 yrs",!," or refusal past year"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,8) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/rectal exam in past 2 yrs",!," or refusal past year"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,9) W ?T,$J(V,6,1) S T=T+12
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"# w/CRC screening"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# A. Refusals w/ % of",!," Total CRC"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# B. w/FOB test in",!," during Report Period"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/rectal exam in past 2 yrs",!," or refusal past year"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
BL ;
 I $Y>(BGPIOSL-18) D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPELIS(BGPIC,53,1,0) D H3
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+12
 W !,"# w/CRC Screening",!," (GPRA)"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/CRC Screening",!," (GPRA)"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+12
 W !!,"# A. Refusals w/ % of",!," Total CRC"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,4) W ?T,$$C(V,0,6) S T=T+12
 W !,"% A. Refusals w/ % of",!," Total CRC"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,5) W ?T,$J(V,6,1) S T=T+12
 W !,"B. # w/FOB test in",!," during Report Period"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,6) W ?T,$$C(V,0,6) S T=T+12
 W !,"% B. w/FOB test in",!," during Report Period"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,7) W ?T,$J(V,6,1) S T=T+12
 W !!,"# w/rectal exam in past 2 yrs",!," or refusal past year"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,8) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/rectal exam in past 2 yrs",!," or refusal past year"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,9) W ?T,$J(V,6,1) S T=T+12
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"# w/CRC screening"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# A. Refusals w/ % of",!," Total CRC"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# B. w/FOB test in",!," during Report Period"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/rectal exam in past 2 yrs",!," or refusal past year"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
H3 ;EP
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?30,"55-64",?42,"65-74",?54,"75-84",?65,">84 yrs",!
 Q
SETN ;set numerator fields
 S BGPCYN=$$V(1,BGPRPT,N,P)
 S BGPPRN=$$V(2,BGPRPT,N,P)
 S BGPBLN=$$V(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 I T=1 Q $P($G(^BGPELDCS(R,N)),U,P)
 I T=2 Q $P($G(^BGPELDPS(R,N)),U,P)
 I T=3 Q $P($G(^BGPELDBS(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCS(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPS(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBS(X,N)),U,P)
 .Q
 Q C
C(X,X2,X3) ;
 NEW A,B,C,D,E,F,G,H,I,J,K
 D COMMA^%DTC
 Q X
