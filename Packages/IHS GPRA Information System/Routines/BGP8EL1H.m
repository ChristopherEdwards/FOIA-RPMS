BGP8EL1H ; IHS/CMI/LAB - print ind 1 ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
I1AGE ;EP  special age tallies
 S BGPHD1="ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Active Clinical"
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPELIE(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (C,D,E,F,G,H,I,J,K)=0 F BGPX="CHD.1","CHD.2","CHD.3","CHD.4" D I1AGE1,I1AGE2,I1AGE3,I1AGE4,I1AGE5,I1AGE6,I1AGE7
 D I1AGEP
MALE ;
 S BGPHD1="MALE ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Male Active Clinical"
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPELIE(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (C,D,E,F,G,H,I,J,K)=0 F BGPX="CHE.1","CHE.2","CHE.3","CHE.4" D I1AGE1,I1AGE2,I1AGE3,I1AGE4,I1AGE5,I1AGE6,I1AGE7
 D I1AGEP
FEMALE ;
 S BGPHD1="FEMALE ACTIVE CLINICAL PATIENTS =>55",BGPHD2="# Female Active Clinical"
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPELIE(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (C,D,E,F,G,H,I,J,K)=0 F BGPX="CHF.1","CHF.2","CHF.3","CHF.4" D I1AGE1,I1AGE2,I1AGE3,I1AGE4,I1AGE5,I1AGE6,I1AGE7
 D I1AGEP
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF="ELD."_BGPX S BGPPC=$O(^BGPELIIE("C",BGPF,0))
 S BGPDF=$P(^BGPELIIE(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90535.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPELIIE(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90535.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U,1)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U,1)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U,1)*100),1:"")
 Q
I1AGE2 ;
 S D=D+1
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+4) S BGPPC=$O(^BGPELIIE("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPELIIE(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90535.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,4)=$$V(1,BGPRPT,N,P),$P(BGPDAC(D),U,5)=$S($P(BGPDAC(D),U,2):($P(BGPDAC(D),U,4)/$P(BGPDAC(D),U,2)*100),1:"")
 S $P(BGPDAP(D),U,4)=$$V(2,BGPRPT,N,P),$P(BGPDAP(D),U,5)=$S($P(BGPDAP(D),U,2):($P(BGPDAP(D),U,4)/$P(BGPDAP(D),U,2)*100),1:"")
 S $P(BGPDAB(D),U,4)=$$V(3,BGPRPT,N,P),$P(BGPDAB(D),U,5)=$S($P(BGPDAB(D),U,2):($P(BGPDAB(D),U,4)/$P(BGPDAB(D),U,2)*100),1:"")
 Q
I1AGE3 ;
 S E=E+1
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+8) S BGPPC=$O(^BGPELIIE("C",BGPF,0))
 S BGPNF=$P(^BGPELIIE(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90535.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(E),U,6)=$$V(1,BGPRPT,N,P),$P(BGPDAC(E),U,7)=$S($P(BGPDAC(E),U,1):($P(BGPDAC(E),U,6)/$P(BGPDAC(E),U,1)*100),1:"")
 S $P(BGPDAP(E),U,6)=$$V(2,BGPRPT,N,P),$P(BGPDAP(E),U,7)=$S($P(BGPDAP(E),U,1):($P(BGPDAP(E),U,6)/$P(BGPDAP(E),U,1)*100),1:"")
 S $P(BGPDAB(E),U,6)=$$V(3,BGPRPT,N,P),$P(BGPDAB(E),U,7)=$S($P(BGPDAB(E),U,1):($P(BGPDAB(E),U,6)/$P(BGPDAB(E),U,1)*100),1:"")
 Q
I1AGE4 ;
 S F=F+1
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+12) S BGPPC=$O(^BGPELIIE("C",BGPF,0))
 S BGPNF=$P(^BGPELIIE(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90535.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(F),U,8)=$$V(1,BGPRPT,N,P),$P(BGPDAC(F),U,9)=$S($P(BGPDAC(F),U,6):($P(BGPDAC(F),U,8)/$P(BGPDAC(F),U,6)*100),1:"")
 S $P(BGPDAP(F),U,8)=$$V(2,BGPRPT,N,P),$P(BGPDAP(F),U,9)=$S($P(BGPDAP(F),U,6):($P(BGPDAP(F),U,8)/$P(BGPDAP(F),U,6)*100),1:"")
 S $P(BGPDAB(F),U,8)=$$V(3,BGPRPT,N,P),$P(BGPDAB(F),U,9)=$S($P(BGPDAB(F),U,6):($P(BGPDAB(F),U,8)/$P(BGPDAB(F),U,6)*100),1:"")
 Q
I1AGE5 ;
 S G=G+1
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+16) S BGPPC=$O(^BGPELIIE("C",BGPF,0))
 S BGPNF=$P(^BGPELIIE(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90535.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(G),U,10)=$$V(1,BGPRPT,N,P),$P(BGPDAC(G),U,11)=$S($P(BGPDAC(G),U,6):($P(BGPDAC(G),U,10)/$P(BGPDAC(G),U,6)*100),1:"")
 S $P(BGPDAP(G),U,10)=$$V(2,BGPRPT,N,P),$P(BGPDAP(G),U,11)=$S($P(BGPDAP(G),U,6):($P(BGPDAP(G),U,10)/$P(BGPDAP(G),U,6)*100),1:"")
 S $P(BGPDAB(G),U,10)=$$V(3,BGPRPT,N,P),$P(BGPDAB(G),U,11)=$S($P(BGPDAB(G),U,6):($P(BGPDAB(G),U,10)/$P(BGPDAB(G),U,6)*100),1:"")
 Q
I1AGE6 ;
 S H=H+1
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+20) S BGPPC=$O(^BGPELIIE("C",BGPF,0))
 S BGPNF=$P(^BGPELIIE(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90535.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(H),U,12)=$$V(1,BGPRPT,N,P),$P(BGPDAC(H),U,13)=$S($P(BGPDAC(H),U,6):($P(BGPDAC(H),U,12)/$P(BGPDAC(H),U,6)*100),1:"")
 S $P(BGPDAP(H),U,12)=$$V(2,BGPRPT,N,P),$P(BGPDAP(H),U,13)=$S($P(BGPDAP(H),U,6):($P(BGPDAP(H),U,12)/$P(BGPDAP(H),U,6)*100),1:"")
 S $P(BGPDAB(H),U,12)=$$V(3,BGPRPT,N,P),$P(BGPDAB(H),U,13)=$S($P(BGPDAB(H),U,6):($P(BGPDAB(H),U,12)/$P(BGPDAB(H),U,6)*100),1:"")
 Q
I1AGE7 ;
 S I=I+1
 S BGPF="ELD."_$P(BGPX,".")_"."_($P(BGPX,".",2)+24) S BGPPC=$O(^BGPELIIE("C",BGPF,0))
 S BGPNF=$P(^BGPELIIE(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90535.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(I),U,14)=$$V(1,BGPRPT,N,P),$P(BGPDAC(I),U,15)=$S($P(BGPDAC(I),U,6):($P(BGPDAC(I),U,14)/$P(BGPDAC(I),U,6)*100),1:"")
 S $P(BGPDAP(I),U,14)=$$V(2,BGPRPT,N,P),$P(BGPDAP(I),U,15)=$S($P(BGPDAP(I),U,6):($P(BGPDAP(I),U,14)/$P(BGPDAP(I),U,6)*100),1:"")
 S $P(BGPDAB(I),U,14)=$$V(3,BGPRPT,N,P),$P(BGPDAB(I),U,15)=$S($P(BGPDAB(I),U,6):($P(BGPDAB(I),U,14)/$P(BGPDAB(I),U,6)*100),1:"")
 Q
I1AGEP ;
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+12
 W !,"# w/Cholesterol screen",!,"w/in 5 yrs (GPRA)"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/Cholesterol screen",!,"w/in 5 yrs (GPRA)"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+12
 W !!,"A. # w/High Chol =>240 w/",!," % of Total Chol Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,4) W ?T,$$C(V,0,6) S T=T+12
 W !,"% A. # w/High Chol =>240 w/",!," % of Total Chol Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,5) W ?T,$J(V,6,1) S T=T+12
 W !!,"# w/LDL done in",!,"past 5 yrs"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,6) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/LDL done in",!,"past 5 yrs"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,7) W ?T,$J(V,6,1) S T=T+12
 W !!,"A. # w/LDL =<100 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,8) W ?T,$$C(V,0,6) S T=T+12
 W !,"% A. # w/LDL =<100 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,9) W ?T,$J(V,6,1) S T=T+12
 W !!,"B. # w/LDL 101-130 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,10) W ?T,$$C(V,0,6) S T=T+12
 W !,"% B. # w/LDL 101-130 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,11) W ?T,$J(V,6,1) S T=T+12
 W !!,"C. # w/LDL 131-160 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,12) W ?T,$$C(V,0,6) S T=T+12
 W !,"% C. # w/LDL 131-160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,13) W ?T,$J(V,6,1) S T=T+12
 W !!,"D. # w/LDL >160 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAC(X),U,14) W ?T,$$C(V,0,6) S T=T+12
 W !,"% D. # w/LDL >160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAC(X),U,15) W ?T,$J(V,6,1) S T=T+12
PR ; 
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPELIE(BGPIC,53,1,0) D H3
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+12
 W !,"# w/Cholesterol screen",!,"w/in 5 yrs (GPRA)"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/Cholesterol screen",!,"w/in 5 yrs (GPRA)"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+12
 W !!,"A. # w/High Chol =>240 w/",!," % of Total Chol Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,4) W ?T,$$C(V,0,6) S T=T+12
 W !,"% A. # w/High Chol =>240 w/",!," % of Total Chol Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,5) W ?T,$J(V,6,1) S T=T+12
 W !!,"# w/LDL done in",!,"past 5 yrs"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,6) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/LDL done in",!,"past 5 yrs"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,7) W ?T,$J(V,6,1) S T=T+12
 W !!,"A. # w/LDL =<100 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,8) W ?T,$$C(V,0,6) S T=T+12
 W !,"% A. # w/LDL =<100 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,9) W ?T,$J(V,6,1) S T=T+12
 W !!,"B. # w/LDL 101-130 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,10) W ?T,$$C(V,0,6) S T=T+12
 W !,"% B. # w/LDL 101-130 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,11) W ?T,$J(V,6,1) S T=T+12
 W !!,"C. # w/LDL 131-160 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,12) W ?T,$$C(V,0,6) S T=T+12
 W !,"% C. # w/LDL 131-160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,13) W ?T,$J(V,6,1) S T=T+12
 W !!,"D. # w/LDL >160 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAP(X),U,14) W ?T,$$C(V,0,6) S T=T+12
 W !,"% D. # w/LDL >160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAP(X),U,15) W ?T,$J(V,6,1) S T=T+12
 ;percentage changes
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPELIE(BGPIC,53,1,0) D H3
 W !!,"CHANGE FROM PREV YR %"
 W !,"# w/Cholesterol screen",!,"w/in 5 yrs (GPRA)"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"A. # w/High Chol =>240 w/",!," % of Total Chol Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/LDL done in",!,"past 5 yrs"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"A. # w/LDL =<100 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"B. # w/LDL 101-130 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAP(X),U,11) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"C. # w/LDL 131-160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAP(X),U,13) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"D. # w/LDL >160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,15),O=$P(BGPDAP(X),U,15) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
BL ;
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPELIE(BGPIC,53,1,0) D H3
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+12
 W !,"# w/Cholesterol screen",!,"w/in 5 yrs (GPRA)"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/Cholesterol screen",!,"w/in 5 yrs (GPRA)"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+12
 W !!,"A. # w/High Chol =>240 w/",!," % of Total Chol Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,4) W ?T,$$C(V,0,6) S T=T+12
 W !,"% A. # w/High Chol =>240 w/",!," % of Total Chol Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,5) W ?T,$J(V,6,1) S T=T+12
 W !!,"# w/LDL done in",!,"past 5 yrs"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,6) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/LDL done in",!,"past 5 yrs"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,7) W ?T,$J(V,6,1) S T=T+12
 W !!,"A. # w/LDL =<100 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,8) W ?T,$$C(V,0,6) S T=T+12
 W !,"% A. # w/LDL =<100 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,9) W ?T,$J(V,6,1) S T=T+12
 W !!,"B. # w/LDL 101-130 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,10) W ?T,$$C(V,0,6) S T=T+12
 W !,"% B. # w/LDL 101-130 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,11) W ?T,$J(V,6,1) S T=T+12
 W !!,"C. # w/LDL 131-160 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,12) W ?T,$$C(V,0,6) S T=T+12
 W !,"% C. # w/LDL 131-160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,13) W ?T,$J(V,6,1) S T=T+12
 W !!,"D. # w/LDL >160 w/",!," % of Total LDL Screen"
 S T=28 F X=1:1:4 S V=$P(BGPDAB(X),U,14) W ?T,$$C(V,0,6) S T=T+12
 W !,"% D. # w/LDL >160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S V=$P(BGPDAB(X),U,15) W ?T,$J(V,6,1) S T=T+12
 ;percentage changes
 D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPELIE(BGPIC,53,1,0) D H3
 W !!,"CHANGE FROM BASE YR %"
 W !,"# w/Cholesterol screen",!,"w/in 5 yrs (GPRA)"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"A. # w/High Chol =>240 w/",!," % of Total Chol Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"# w/LDL done in",!,"past 5 yrs"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"A. # w/LDL =<100 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"B. # w/LDL 101-130 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAB(X),U,11) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"C. # w/LDL 131-160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAB(X),U,13) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"D. # w/LDL >160 w/",!," % of Total LDL Screen"
 S T=27 F X=1:1:4 S N=$P(BGPDAC(X),U,15),O=$P(BGPDAB(X),U,15) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
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
 I T=1 Q $P($G(^BGPELDCE(R,N)),U,P)
 I T=2 Q $P($G(^BGPELDPE(R,N)),U,P)
 I T=3 Q $P($G(^BGPELDBE(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPELDCE(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPELDPE(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPELDBE(X,N)),U,P)
 .Q
 Q C
C(X,X2,X3) ;
 NEW A,B,C,D,E,F,G,H,I,J,K
 D COMMA^%DTC
 Q X
