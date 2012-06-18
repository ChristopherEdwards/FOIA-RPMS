BGP5DP11 ; IHS/CMI/LAB - print ind 1 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I1AGE ;EP  special age tallies
 I BGPINDT="W",BGPRTYPE=4 G FEM
 S BGPHD1="TOTAL USER POPULATION",BGPHD2="Total # User Pop"
 D HEADER^BGP5DPH Q:BGPQUIT  W !,^BGPINDV(BGPIC,53,1,0)  D H3^BGP5DPH
 K BGPDAC,BGPDAP,BGPDAB S (C,D)=0 F BGPX="TA","TB","TC","TD","TE","TF","TG","TH" D I1AGE1,I1AGE2
 D I1AGEP
 Q:BGPQUIT
 S BGPHD1="MALE USER POPULATION",BGPHD2="Total MALE User Pop"
 D HEADER^BGP5DPH Q:BGPQUIT  W !,^BGPINDV(BGPIC,53,1,0)  D H3^BGP5DPH
 K BGPDAC,BGPDAP,BGPDAB S (D,C)=0 F BGPX="D","E","F","G","H","I","J","K" D I1AGE1,I1AGE2
 D I1AGEP
 Q:BGPQUIT
FEM ;
 S BGPHD1="FEMALE USER POPULATION",BGPHD2="Total FEMALE User Pop"
 D HEADER^BGP5DPH Q:BGPQUIT  W !,^BGPINDV(BGPIC,53,1,0)  D H3^BGP5DPH
 K BGPDAC,BGPDAP,BGPDAB S (C,D)=0 F BGPX="L","M","N","O","P","Q","R","S" D I1AGE1,I1AGE2
 D I1AGEP
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF="001."_BGPX_".1" S BGPPC=$O(^BGPINDVC("C",BGPF,0))
 S BGPDF=$P(^BGPINDVC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90371.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPINDVC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90371.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGE2 ;
 S D=D+1
 S BGPF="001."_BGPX_".2" S BGPPC=$O(^BGPINDVC("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPINDVC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90371.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,4)=$$V(1,BGPRPT,N,P),$P(BGPDAC(D),U,5)=$S($P(BGPDAC(D),U,1):($P(BGPDAC(D),U,4)/$P(BGPDAC(D),U)*100),1:"")
 S $P(BGPDAP(D),U,4)=$$V(2,BGPRPT,N,P),$P(BGPDAP(D),U,5)=$S($P(BGPDAP(D),U,1):($P(BGPDAP(D),U,4)/$P(BGPDAP(D),U)*100),1:"")
 S $P(BGPDAB(D),U,4)=$$V(3,BGPRPT,N,P),$P(BGPDAB(D),U,5)=$S($P(BGPDAB(D),U,1):($P(BGPDAB(D),U,4)/$P(BGPDAB(D),U)*100),1:"")
 Q
I1AGEP ;
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ DM DX ever"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ DM DX ever"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# w/DM DX in past yr"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/DM DX in past yr"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,5) W ?T,$J(V,6,1) S T=T+7
PR ; 
 I $Y>(BGPIOSL-13) D HEADER^BGP5DPH Q:BGPQUIT  W !,^BGPINDV(BGPIC,53,1,0) D H3^BGP5DPH
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ DM DX ever"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ DM DX ever"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# w/DM DX in past yr"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/DM DX in past yr"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,5) W ?T,$J(V,6,1) S T=T+7
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"w/ DM DX ever"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"w/DM DX in past yr"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
BL ;
 I $Y>(BGPIOSL-13) D HEADER^BGP5DPH Q:BGPQUIT  W !,^BGPINDV(BGPIC,53,1,0) D H3^BGP5DPH
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ DM DX ever"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ DM DX ever"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# w/DM DX in past yr"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/DM DX in past yr"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,5) W ?T,$J(V,6,1) S T=T+7
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"w/ DM DX ever"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"w/DM DX in past yr"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
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
 I T=1 Q $P($G(^BGPGPDCV(R,N)),U,P)
 I T=2 Q $P($G(^BGPGPDPV(R,N)),U,P)
 I T=3 Q $P($G(^BGPGPDBV(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPGPDCV(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPGPDPV(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPGPDBV(X,N)),U,P)
 .Q
 Q C
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
