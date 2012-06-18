BGP7DP12 ; IHS/CMI/LAB - print ind 19 AGE DIST ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I1AGE ;EP  special age tallies
 S BGPHD1="ACTIVE CLINICAL TOBACCO USERS",BGPHD2="Active Clin Tobacco Users"
 D HEADER^BGP7DPH Q:BGPQUIT  W !,^BGPINDA(BGPIC,53,1,0)  D H4^BGP7DPH
 K BGPDAC,BGPDAP,BGPDAB S (C,D)=0 F BGPX=8,9,10 D I1AGE1,I1AGE2
 D I1AGEP
 Q:BGPQUIT
 S BGPHD1="MALE ACTIVE CLINICAL TOBACCO USERS",BGPHD2="Male AC Tobacco Users"
 D HEADER^BGP7DPH Q:BGPQUIT  W !,^BGPINDA(BGPIC,53,1,0)  D H4^BGP7DPH
 K BGPDAC,BGPDAP,BGPDAB S (D,C)=0 F BGPX=14,15,16 D I1AGE1,I1AGE2
 D I1AGEP
 Q:BGPQUIT
FEM ;
 S BGPHD1="FEMALE ACTIVE CLINICAL TOBACCO USERS",BGPHD2="Female AC Tobacco Users"
 D HEADER^BGP7DPH Q:BGPQUIT  W !,^BGPINDA(BGPIC,53,1,0)  D H4^BGP7DPH
 K BGPDAC,BGPDAP,BGPDAB S (C,D)=0 F BGPX=20,21,22 D I1AGE1,I1AGE2
 D I1AGEP
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF="H.BA."_BGPX S BGPPC=$O(^BGPINDAC("C",BGPF,0))
 S BGPDF=$P(^BGPINDAC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90530.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V^BGP7DP1C(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V^BGP7DP1C(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V^BGP7DP1C(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPINDAC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90530.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V^BGP7DP1C(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V^BGP7DP1C(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V^BGP7DP1C(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGE2 ;
 S D=D+1
 S BGPF="H.BA."_(BGPX+3) S BGPPC=$O(^BGPINDAC("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPINDAC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90530.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,4)=$$V^BGP7DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,5)=$S($P(BGPDAC(D),U,1):($P(BGPDAC(D),U,4)/$P(BGPDAC(D),U)*100),1:"")
 S $P(BGPDAP(D),U,4)=$$V^BGP7DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,5)=$S($P(BGPDAP(D),U,1):($P(BGPDAP(D),U,4)/$P(BGPDAP(D),U)*100),1:"")
 S $P(BGPDAB(D),U,4)=$$V^BGP7DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,5)=$S($P(BGPDAB(D),U,1):($P(BGPDAB(D),U,4)/$P(BGPDAB(D),U)*100),1:"")
 Q
I1AGEP ;
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2
 S T=33 F X=1:1:3 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+12
 W !!,"# w/tobacco cessation",!,?2,"counseling or refusal"
 S T=33 F X=1:1:3 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/ tobacco cessation",!,?2,"counseling or refusal"
 S T=32 F X=1:1:3 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+12
 W !!,"# who quit"
 S T=33 F X=1:1:3 S V=$P(BGPDAC(X),U,4) W ?T,$$C(V,0,6) S T=T+12
 W !,"% who quit"
 S T=32 F X=1:1:3 S V=$P(BGPDAC(X),U,5) W ?T,$J(V,6,1) S T=T+12
PR ; 
 I $Y>(BGPIOSL-13) D HEADER^BGP7DPH Q:BGPQUIT  W !,^BGPINDA(BGPIC,53,1,0) D H4^BGP7DPH
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2
 S T=33 F X=1:1:3 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+12
 W !!,"# w/tobacco cessation",!,?2,"counseling or refusal"
 S T=33 F X=1:1:3 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/tobacco cessation",!,?2,"counseling or refusal"
 S T=32 F X=1:1:3 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+12
 W !!,"# who quit"
 S T=33 F X=1:1:3 S V=$P(BGPDAP(X),U,4) W ?T,$$C(V,0,6) S T=T+12
 W !,"% who quit"
 S T=32 F X=1:1:3 S V=$P(BGPDAP(X),U,5) W ?T,$J(V,6,1) S T=T+12
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"w/tobacco cessation",!,?2,"counseling or refusal"
 S T=32 F X=1:1:3 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"who quit"
 S T=32 F X=1:1:3 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
BL ;
 I $Y>(BGPIOSL-13) D HEADER^BGP7DPH Q:BGPQUIT  W !,^BGPINDA(BGPIC,53,1,0) D H4^BGP7DPH
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2
 S T=33 F X=1:1:3 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+12
 W !!,"# w/tobacco cessation",!,?2,"counseling or refusal"
 S T=33 F X=1:1:3 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+12
 W !,"% w/tobacco cessation",!,?2,"counseling or refusal"
 S T=32 F X=1:1:3 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+12
 W !!,"# who quit"
 S T=33 F X=1:1:3 S V=$P(BGPDAB(X),U,4) W ?T,$$C(V,0,6) S T=T+12
 W !,"% who quit"
 S T=32 F X=1:1:3 S V=$P(BGPDAB(X),U,5) W ?T,$J(V,6,1) S T=T+12
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"w/tobacco cessation",!,?2,"counseling or refusal"
 S T=32 F X=1:1:3 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 W !,"who quit"
 S T=32 F X=1:1:3 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+12
 Q
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
