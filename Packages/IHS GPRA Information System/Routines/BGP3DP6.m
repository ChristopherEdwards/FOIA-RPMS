BGP3DP6 ; IHS/CMI/LAB - print ind C-1 ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
IC1 ;EP
 D H1^BGP3DPH
 F BGPPC1="C-1.AA","C-1.AB","C-1.AC" Q:BGPQUIT  D PI^BGP3DP1
 Q:BGPQUIT
 F BGPPC1="C-1.CA","C-1.CB","C-1.CC" Q:BGPQUIT  D PI^BGP3DP1
 Q:BGPQUIT
 F BGPPC1="C-1.BA","C-1.BB","C-1.BC" Q:BGPQUIT  D PI^BGP3DP1
 D I1AGE
 Q:BGPQUIT
 D I1AGE^BGP3DP60
 Q
PI ;EP
 F BGPX="A.1","B.1","C.1","A.2","B.2","C.2" S BGPPC2=BGPPC1_BGPX D PI1 Q:BGPQUIT
 Q
PI1 ;
 S BGPPC=$O(^BGPINDC("C",BGPPC2,0))
 I BGPRTYPE'=4,BGPINDT="G",$P(^BGPINDC(BGPPC,0),U,5)'=1 Q
 I BGPRTYPE'=4,BGPINDT="A",$P(^BGPINDC(BGPPC,0),U,6)'=1 Q
 I BGPINDT="D",$P(^BGPINDC(BGPPC,0),U,12)'=1 Q
 I BGPINDT="C",$P(^BGPINDC(BGPPC,0),U,13)'=1 Q
 S BGPDF=$P(^BGPINDC(BGPPC,0),U,8)
 ;get denominator value of indicator
 S BGPNP=$P(^DD(90243,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S BGPCYD=$$V(1,BGPRPT,N,P)
 S BGPPRD=$$V(2,BGPRPT,N,P)
 S BGPBLD=$$V(3,BGPRPT,N,P)
 ;write out denominator
 I $Y>(IOSL-13) D HEADER^BGP3DPH Q:BGPQUIT  W !!,^BGPIND(BGPIC,53,1,0) D H1^BGP3DPH
 I BGPRTYPE=4 W !!,$P(^BGPINDC(BGPPC,0),U,17) I $P(^BGPINDC(BGPPC,0),U,18)]"" W !,$P(^BGPINDC(BGPPC,0),U,18) I $P(^BGPINDC(BGPPC,0),U,21)]"" W !,$P(^BGPINDC(BGPPC,0),U,21)
 I BGPRTYPE=1,$P($G(^BGPINDC(BGPPC,11)),U,1)]"" W !!,$P(^BGPINDC(BGPPC,11),U,1) I $P(^BGPINDC(BGPPC,11),U,2)]"" W !,$P(^BGPINDC(BGPPC,11),U,2) I $P(^BGPINDC(BGPPC,11),U,3)]"" W !,$P(^BGPINDC(BGPPC,11),U,3)
 I BGPRTYPE=2,$P($G(^BGPINDC(BGPPC,11)),U,4)]"" W !!,$P(^BGPINDC(BGPPC,11),U,4) I $P(^BGPINDC(BGPPC,11),U,5)]"" W !,$P(^BGPINDC(BGPPC,11),U,5) I $P(^BGPINDC(BGPPC,11),U,6)]"" W !,$P(^BGPINDC(BGPPC,11),U,6)
 W:$P(^BGPINDC(BGPPC,0),U,4)["A.1" ?20,$$C(BGPCYD,0,8),?35,$$C(BGPPRD,0,8),?58,$$C(BGPBLD,0,8),!
 ;get numerator value of indicator and calc %
 S BGPNF=$P(^BGPINDC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90243,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 D SETN
 ;write header for 1A1
 W !,$P(^BGPINDC(BGPPC,0),U,15)
 I $P(^BGPINDC(BGPPC,0),U,16)]"" W !?1,$P(^BGPINDC(BGPPC,0),U,16)
 I $P(^BGPINDC(BGPPC,0),U,19)]"" W !?1,$P(^BGPINDC(BGPPC,0),U,19)
 D H2^BGP3DPH
 Q
I1AGE ; special age tallies
 I BGPRTYPE'=4,BGPRTYPE'=2 Q
 S BGPHD1="TOTAL ACTIVE CLINICAL POPULATION",BGPHD3="EXERCISE EDUCATION"
 D HEADER^BGP3DPH Q:BGPQUIT  W !,^BGPIND(BGPIC,53,1,0)  D H3
 K BGPDAC,BGPDCP,BGPDAB
 S (C,D)=0,BGPD=1,BGPN=2,BGPP=3 F BGPX="CD","CG","CJ","CM","CP" D I1AGE1
 S (C,D)=0,BGPD=4,BGPN=5,BGPP=6 F BGPX="CE","CH","CK","CN","CQ" D I1AGE1
 S (C,D)=0,BGPD=7,BGPN=8,BGPP=9 F BGPX="CF","CI","CL","CO","CR" D I1AGE1
 D I1AGEP
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF="C-1."_BGPX_"."_1 S BGPPC=$O(^BGPINDC("C",BGPF,0))
 S BGPDF=$P(^BGPINDC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90243,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,BGPD)=$$V(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U,BGPD)=$$V(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U,BGPD)=$$V(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPINDC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90243,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,BGPN)=$$V(1,BGPRPT,N,P),$P(BGPDAC(C),U,BGPP)=$S($P(BGPDAC(C),U,BGPD):($P(BGPDAC(C),U,BGPN)/$P(BGPDAC(C),U,BGPD)*100),1:"")
 S $P(BGPDAP(C),U,BGPN)=$$V(2,BGPRPT,N,P),$P(BGPDAP(C),U,BGPP)=$S($P(BGPDAP(C),U,BGPD):($P(BGPDAP(C),U,BGPN)/$P(BGPDAP(C),U,BGPD)*100),1:"")
 S $P(BGPDAB(C),U,BGPN)=$$V(3,BGPRPT,N,P),$P(BGPDAB(C),U,BGPP)=$S($P(BGPDAB(C),U,BGPD):($P(BGPDAB(C),U,BGPN)/$P(BGPDAB(C),U,BGPD)*100),1:"")
 Q
I1AGEP ;
 W !,"CURRENT REPORT PERIOD"
 W !,"Total # Active Clinical",!?2,"Pop =>6"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !!,"# w/ exercise ed"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Male w/ exercise ed"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,5) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Male w/ exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,6) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Female w/ exercise ed"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,8) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Female w/ exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,9) W ?T,$J(V,6,1) S T=T+7
PR ; 
 I $Y>(IOSL-12) D HEADER^BGP3DPH Q:BGPQUIT  W !,^BGPIND(BGPIC,53,1,0) D H3
 W !!,"PREVIOUS YEAR PERIOD"
 W !,"Total # Active Clinical",!?2,"Pop =>6"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ exercise ed"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Male w/ exercise ed"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,5) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Male w/ exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,6) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Female w/ exercise ed"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,8) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Female w/ exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,9) W ?T,$J(V,6,1) S T=T+7
PB ;
 I $Y>(IOSL-12) D HEADER^BGP3DPH Q:BGPQUIT  W !,^BGPIND(BGPIC,53,1,0) D H3
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"Total w/exercise ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Male w/ exercise ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,6),O=$P(BGPDAP(X),U,6) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Female w/exercise ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
BL ;
 I $Y>(IOSL-12) D HEADER^BGP3DPH Q:BGPQUIT  W !,^BGPIND(BGPIC,53,1,0) D H3
 W !!,"BASELINE REPORT PERIOD"
 W !,"Total # Active Clinical",!?2,"Pop =>6"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ exercise ed"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Male w/ exercise ed"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,5) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Male w/ exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,6) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Female w/ exercise ed"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,8) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Female w/ exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,9) W ?T,$J(V,6,1) S T=T+7
BP ;
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"Total w/exercise ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Male w/ exercise ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,6),O=$P(BGPDAB(X),U,6) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Female w/exercise ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
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
 I T=1 Q $P($G(^BGPGPDC(R,N)),U,P)
 I T=2 Q $P($G(^BGPGPDP(R,N)),U,P)
 I T=3 Q $P($G(^BGPGPDB(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPGPDC(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPGPDP(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPGPDB(X,N)),U,P)
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
 W !,BGPHD3,?32,"6-11",?37,"12-19",?44,"20-39",?51,"40-59",?58,"=>60",!
 Q
