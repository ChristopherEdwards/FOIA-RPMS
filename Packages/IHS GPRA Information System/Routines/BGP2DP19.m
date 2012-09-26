BGP2DP19 ; IHS/CMI/LAB - print ind 1 03 Jul 2010 7:40 AM ;
 ;;12.1;IHS CLINICAL REPORTING;;MAY 17, 2012;Build 66
 ;
 ;
I1AGE ;EP  special age tallies
 Q:$G(BGPSUMON)
 Q:BGPRTYPE=9
 S BGPHD1="TOTAL USER POPULATION",BGPHD2="Total # User Pop"
 I '$G(BGPSUMON) D HEADER^BGP2DPH Q:BGPQUIT  W !,^BGPINDW(BGPIC,53,1,0) W:$D(^BGPINDW(BGPIC,53,2,0)) !,^BGPINDW(BGPIC,53,2,0)  D H9^BGP2DPH
 K BGPDAC,BGPDAP,BGPDAB S (C,D)=0 F BGPX="A","B","D","E","F","G","H" D I1AGE1,I1AGE2
 D I1AGEP
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF="013.B.1"_BGPX S BGPPC=$O(^BGPINDWC("C",BGPF,0))
 S BGPDF=$P(^BGPINDWC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90548.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V^BGP2DP1C(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V^BGP2DP1C(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V^BGP2DP1C(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPINDWC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90548.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V^BGP2DP1C(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V^BGP2DP1C(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V^BGP2DP1C(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 I $G(BGPIIDEL),BGPROT="B" Q
 I BGPF="013.B.1A"!(BGPF="013.B.1B") D GPRANT1^BGP2DP1C
 Q
I1AGE2 ;
 S D=D+1
 S BGPF="013.B.2"_BGPX S BGPPC=$O(^BGPINDWC("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPINDWC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90548.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,4)=$$V^BGP2DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,5)=$S($P(BGPDAC(D),U,1):($P(BGPDAC(D),U,4)/$P(BGPDAC(D),U,1)*100),1:"")
 S $P(BGPDAP(D),U,4)=$$V^BGP2DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,5)=$S($P(BGPDAP(D),U,1):($P(BGPDAP(D),U,4)/$P(BGPDAP(D),U,1)*100),1:"")
 S $P(BGPDAB(D),U,4)=$$V^BGP2DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,5)=$S($P(BGPDAB(D),U,1):($P(BGPDAB(D),U,4)/$P(BGPDAB(D),U,1)*100),1:"")
 Q
I1AGEP ;
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:7 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/dental visit in past yr-No",!?2,"Refusals (GPRA)"
 S T=23 F X=1:1:7 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/dental visit in past yr-No",!?2,"Refusals (GPRA)"
 S T=22 F X=1:1:7 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+7
 I BGPRTYPE'=1 D
 .W !!,"# w/dental exam refusal"
 .S T=23 F X=1:1:7 S V=$P(BGPDAC(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 .W !,"% w/dental exam refusal"
 .S T=22 F X=1:1:7 S V=$P(BGPDAC(X),U,5) W ?T,$J(V,6,1) S T=T+7
PR ; 
 I $Y>(BGPIOSL-13) D:'$G(BGPSUMON) HEADER^BGP2DPH Q:BGPQUIT  W !,^BGPINDW(BGPIC,53,1,0) W:$D(^BGPINDW(BGPIC,53,2,0)) !,^BGPINDW(BGPIC,53,2,0) D H9^BGP2DPH
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:7 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/dental visit in past yr-No",!?2,"Refusals (GPRA)"
 S T=23 F X=1:1:7 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/dental visit in past yr-No",!?2,"Refusals (GPRA)"
 S T=22 F X=1:1:7 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+7
 I BGPRTYPE'=1 D
 .W !!,"# w/dental exam refusal"
 .S T=23 F X=1:1:7 S V=$P(BGPDAP(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 .W !,"% w/dental exam refusal"
 .S T=22 F X=1:1:7 S V=$P(BGPDAP(X),U,5) W ?T,$J(V,6,1) S T=T+7
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"w/dental visit in past yr-No",!?2,"Refusals (GPRA)"
 S T=22 F X=1:1:7 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 I BGPRTYPE'=1 D
 .W !,"w/dental exam refusal"
 .S T=22 F X=1:1:7 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
BL ;
 D:'$G(BGPSUMON) HEADER^BGP2DPH Q:BGPQUIT  W !,^BGPINDW(BGPIC,53,1,0) W:$D(^BGPINDW(BGPIC,53,2,0)) !,^BGPINDW(BGPIC,53,2,0) D H9^BGP2DPH
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:7 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/dental visit in past yr-No",!?2,"Refusals (GPRA)"
 S T=23 F X=1:1:7 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/dental visit in past yr-No",!?2,"Refusals (GPRA)"
 S T=22 F X=1:1:7 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+7
 I BGPRTYPE'=1 D
 .W !!,"# w/dental exam refusal"
 .S T=23 F X=1:1:7 S V=$P(BGPDAB(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 .W !,"% w/dental exam refusal"
 .S T=22 F X=1:1:7 S V=$P(BGPDAB(X),U,5) W ?T,$J(V,6,1) S T=T+7
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"w/dental visit in past yr-No",!?2,"Refusals (GPRA)"
 S T=22 F X=1:1:7 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 I BGPRTYPE'=1 D
 .W !,"w/dental exam refusal"
 .S T=22 F X=1:1:7 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 Q
SETN ;set numerator fields
 S BGPCYN=$$V^BGP2DP1C(1,BGPRPT,N,P)
 S BGPPRN=$$V^BGP2DP1C(2,BGPRPT,N,P)
 S BGPBLN=$$V^BGP2DP1C(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 I $G(BGPIIDEL),BGPROT="B" Q
 I BGPF="013.B.1A"!(BGPF="013.B.1B") D GPRANT1^BGP2DP1C
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 I T=1 Q $P($G(^BGPGPDCW(R,N)),U,P)
 I T=2 Q $P($G(^BGPGPDPW(R,N)),U,P)
 I T=3 Q $P($G(^BGPGPDBW(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPGPDCW(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPGPDPW(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPGPDBW(X,N)),U,P)
 .Q
 Q C
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
