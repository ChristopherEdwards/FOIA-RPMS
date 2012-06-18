BGP8DP4 ; IHS/CMI/LAB - print ind 31 ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
I031 ;EP
 S BGPORXX=$P(^BGPINDE(BGPIC,0),U,6)
 D H1^BGP8DPH
 I BGPRTYPE=4,BGPINDT="C" D  Q
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".7.3D",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".8.3D",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".9.3D",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".7.3E",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".8.3E",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".9.3E",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".7.3F",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".8.3F",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".9.3F",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".7.3G",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".8.3G",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".9.3G",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".7.3H",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".8.3H",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 .S BGPDENP=0 S BGPPC=$O(^BGPINDEC("OR",BGPORXX_".9.3H",0)) D PI1^BGP8DP1C
 .Q:BGPQUIT
 F BGPPC1=BGPORXX_".1",BGPORXX_".2",BGPORXX_".3" Q:BGPQUIT  D PI^BGP8DP1C
 Q:BGPQUIT
 I BGPRTYPE=4 W !
 F BGPPC1=BGPORXX_".4",BGPORXX_".5",BGPORXX_".6" Q:BGPQUIT  D PI^BGP8DP1C
 D I1AGE
 Q:BGPQUIT
 Q
I1AGE ;EP special age tallies
 ;Q:BGPRTYPE'=4
 I BGPINDT="W",BGPRTYPE=4 G FEM
 S BGPHD1="TOTAL ACTIVE CLINICAL POPULATION",BGPHD2="Total # Active Clin",BGPHD3=""
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPINDE(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (C,D)=0 F BGPX="CD","CG","CJ","CM","CP","CS","CV","CY" D I1AGE1,I1AGE2
 D I1AGEP
 ;Q:BGPRTYPE'=4
 Q:BGPQUIT
 S BGPHD1="MALE ACTIVE CLINICAL POPULATION",BGPHD2="Total MALE AC",BGPHD3=""
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPINDE(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (D,C)=0 F BGPX="CE","CH","CK","CN","CQ","CT","CW","CZ" D I1AGE1,I1AGE2
 D I1AGEP
 Q:BGPQUIT
FEM ;
 S BGPHD1="FEMALE ACTIVE CLINICAL POPULATION",BGPHD2="Total FEMALE AC",BGPHD3=""
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPINDE(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (C,D)=0 F BGPX="CF","CI","CL","CO","CR","CU","CX","DA" D I1AGE1,I1AGE2
 D I1AGEP
 K BGPHD3
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF="031."_BGPX_".1" S BGPPC=$O(^BGPINDEC("C",BGPF,0))
 S BGPDF=$P(^BGPINDEC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90533.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V^BGP8DP1C(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V^BGP8DP1C(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V^BGP8DP1C(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPINDEC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90533.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V^BGP8DP1C(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V^BGP8DP1C(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V^BGP8DP1C(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGE2 ;
 S D=D+1
 S BGPF="031."_BGPX_".2" S BGPPC=$O(^BGPINDEC("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPINDEC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90533.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,4)=$$V^BGP8DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,5)=$S($P(BGPDAC(D),U,2):($P(BGPDAC(D),U,4)/$P(BGPDAC(D),U,2)*100),1:"")
 S $P(BGPDAP(D),U,4)=$$V^BGP8DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,5)=$S($P(BGPDAP(D),U,2):($P(BGPDAP(D),U,4)/$P(BGPDAP(D),U,2)*100),1:"")
 S $P(BGPDAB(D),U,4)=$$V^BGP8DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,5)=$S($P(BGPDAB(D),U,2):($P(BGPDAB(D),U,4)/$P(BGPDAB(D),U,2)*100),1:"")
I1AGE3 ;
 S BGPF="031."_BGPX_".3" S BGPPC=$O(^BGPINDEC("C",BGPF,0))
 ;set 6th piece to numerator and 7th to %
 S BGPNF=$P(^BGPINDEC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90533.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,6)=$$V^BGP8DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,7)=$S($P(BGPDAC(D),U,2):($P(BGPDAC(D),U,6)/$P(BGPDAC(D),U,2)*100),1:"")
 S $P(BGPDAP(D),U,6)=$$V^BGP8DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,7)=$S($P(BGPDAP(D),U,2):($P(BGPDAP(D),U,6)/$P(BGPDAP(D),U,2)*100),1:"")
 S $P(BGPDAB(D),U,6)=$$V^BGP8DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,7)=$S($P(BGPDAB(D),U,2):($P(BGPDAB(D),U,6)/$P(BGPDAB(D),U,2)*100),1:"")
I1AGE4 ;
 S BGPF="031."_BGPX_".4" S BGPPC=$O(^BGPINDEC("C",BGPF,0))
 ;set 8th piece to numerator and 9th to %
 S BGPNF=$P(^BGPINDEC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90533.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,8)=$$V^BGP8DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,9)=$S($P(BGPDAC(D),U,2):($P(BGPDAC(D),U,8)/$P(BGPDAC(D),U,2)*100),1:"")
 S $P(BGPDAP(D),U,8)=$$V^BGP8DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,9)=$S($P(BGPDAP(D),U,2):($P(BGPDAP(D),U,8)/$P(BGPDAP(D),U,2)*100),1:"")
 S $P(BGPDAB(D),U,8)=$$V^BGP8DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,9)=$S($P(BGPDAB(D),U,2):($P(BGPDAB(D),U,8)/$P(BGPDAB(D),U,2)*100),1:"")
I1AGE5 ;
 S BGPF="031."_BGPX_".5" S BGPPC=$O(^BGPINDEC("C",BGPF,0))
 ;set 8th piece to numerator and 9th to %
 S BGPNF=$P(^BGPINDEC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90533.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,10)=$$V^BGP8DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,11)=$S($P(BGPDAC(D),U,2):($P(BGPDAC(D),U,10)/$P(BGPDAC(D),U,2)*100),1:"")
 S $P(BGPDAP(D),U,10)=$$V^BGP8DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,11)=$S($P(BGPDAP(D),U,2):($P(BGPDAP(D),U,10)/$P(BGPDAP(D),U,2)*100),1:"")
 S $P(BGPDAB(D),U,10)=$$V^BGP8DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,11)=$S($P(BGPDAB(D),U,2):($P(BGPDAB(D),U,10)/$P(BGPDAB(D),U,2)*100),1:"")
 Q
I1AGEP ;
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2 I BGPHD3]"" W !,?1,BGPHD3
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ BMI calculated"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/BMI calculated"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# A. Overweight"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% A. Overweight w/",!," % Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,5) W ?T,$J(V,6,1) S T=T+7
 W !!,"# B. Obese"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,6) W ?T,$$C(V,0,6) S T=T+7
 W !,"% B. Obese w/",!," % of Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,7) W ?T,$J(V,6,1) S T=T+7
 W !!,"# C. Overweight",!," or Obese"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,8) W ?T,$$C(V,0,6) S T=T+7
 W !,"% C. Overweight or Obese w/",!," % Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,9) W ?T,$J(V,6,1) S T=T+7
 W !!,"# D. w/refusal in",!," in past yr"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,10) W ?T,$$C(V,0,6) S T=T+7
 W !,"% D. w/refusal in past yr w/",!," % Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,11) W ?T,$J(V,6,1) S T=T+7
PR ; 
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPINDE(BGPIC,53,1,0) D H3
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2 I BGPHD3]"" W !,?1,BGPHD3
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ BMI calculated"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/BMI calculated"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# A. Overweight"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% A. Overweight w/",!," % Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,5) W ?T,$J(V,6,1) S T=T+7
 W !!,"# B. Obese"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,6) W ?T,$$C(V,0,6) S T=T+7
 W !,"% B. Obese w/",!," % of Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,7) W ?T,$J(V,6,1) S T=T+7
 W !!,"# C. Overweight",!," or Obese"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,8) W ?T,$$C(V,0,6) S T=T+7
 W !,"% C. Overweight or Obese w/",!," % Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,9) W ?T,$J(V,6,1) S T=T+7
 W !!,"# D. w/refusal in",!," past yr"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,10) W ?T,$$C(V,0,6) S T=T+7
 W !,"% D. w/refusal in past yr w/",!," % Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,11) W ?T,$J(V,6,1) S T=T+7
PB ;
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"w/ BMI calculated"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"A. Overweight"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"B. Obese"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"C. Overweight",!," or Obese"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"D. w/refusal in",!," past yr"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAP(X),U,11) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
BL ;
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPINDE(BGPIC,53,1,0) D H3
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2 I BGPHD3]"" W !,?1,BGPHD3
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ BMI calculated"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/BMI calculated"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# A. Overweight"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% A. Overweight w/",!," % Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,5) W ?T,$J(V,6,1) S T=T+7
 W !!,"# B. Obese"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,6) W ?T,$$C(V,0,6) S T=T+7
 W !,"% B. Obese w/",!," % of Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,7) W ?T,$J(V,6,1) S T=T+7
 W !!,"# C. Overweight",!," or Obese"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,8) W ?T,$$C(V,0,6) S T=T+7
 W !,"% C. Overweight or Obese w/",!," % Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,9) W ?T,$J(V,6,1) S T=T+7
 W !!,"# D. w/refusal in",!," past yr"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,10) W ?T,$$C(V,0,6) S T=T+7
 W !,"% D. w/refusal in past yr w/",!," % Total BMI"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,11) W ?T,$J(V,6,1) S T=T+7
BP ;
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"w/ BMI calculated"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"A. Overweight"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"B. Obese"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"C. Overweight",!," or Obese"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"D. w/refusal in",!," past yr"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAB(X),U,11) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 Q
SETN ;set numerator fields
 S BGPCYN=$$V^BGP8DP1C(1,BGPRPT,N,P)
 S BGPPRN=$$V^BGP8DP1C(2,BGPRPT,N,P)
 S BGPBLN=$$V^BGP8DP1C(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 I T=1 Q $P($G(^BGPGPDCE(R,N)),U,P)
 I T=2 Q $P($G(^BGPGPDPE(R,N)),U,P)
 I T=3 Q $P($G(^BGPGPDBE(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPGPDCE(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPGPDPE(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPGPDBE(X,N)),U,P)
 .Q
 Q C
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
H3 ;EP
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?25,"2-5",?30,"6-11",?37,"12-19",?44,"20-24",?51,"25-34",?58,"35-44",?65,"45-54",?72,"55-74",!
 Q
