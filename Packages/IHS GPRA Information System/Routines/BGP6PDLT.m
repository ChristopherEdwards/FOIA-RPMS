BGP6PDLT ; IHS/CMI/LAB - print ind 1 03 Jul 2010 7:40 AM ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
 ;
I1AGE ;EP  special age tallies
 Q:BGPRTYPE'=4
 Q:BGPINDM="I"
 Q:$G(BGPSUMON)
 S BGPHD1="TOTAL ACTIVE CLINICAL 5 AND OLDER",BGPHD2="Total # AC Pts 5+"
 I '$G(BGPSUMON) D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPINDM(BGPIC,53,1,0) W:$D(^BGPINDM(BGPIC,53,2,0)) !,^BGPINDM(BGPIC,53,2,0)  D HPA^BGP6DPH
 K BGPDAC,BGPDAP,BGPDAB,BGPPAD S BGPPAD=7 S (C,D,E)=0 F BGPX="A","B","C","D","E","F","G","H" D I1AGE1,I1AGE2,I1AGE3
 D I1AGEP
MALE ;
 S BGPHD1="TOTAL MALE ACTIVE CLINICAL 5 AND OLDER",BGPHD2="Total # Male AC Pts 5+"
 I '$G(BGPSUMON) D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPINDM(BGPIC,53,1,0) W:$D(^BGPINDM(BGPIC,53,2,0)) !,^BGPINDM(BGPIC,53,2,0)  D HPA^BGP6DPH
 K BGPDAC,BGPDAP,BGPDAB,BGPPAD S BGPPAD=8 S (C,D,E)=0 F BGPX="A","B","C","D","E","F","G","H" D I1AGE1,I1AGE2,I1AGE3
 D I1AGEP
FEMALE ;
 S BGPHD1="TOTAL FEMALE ACTIVE CLINICAL 5 AND OLDER",BGPHD2="Total # Female AC Pts 5+"
 I '$G(BGPSUMON) D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPINDM(BGPIC,53,1,0) W:$D(^BGPINDM(BGPIC,53,2,0)) !,^BGPINDM(BGPIC,53,2,0)  D HPA^BGP6DPH
 K BGPDAC,BGPDAP,BGPDAB,BGPPAD S BGPPAD=9 S (C,D,E)=0 F BGPX="A","B","C","D","E","F","G","H" D I1AGE1,I1AGE2,I1AGE3
 D I1AGEP
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF=156_"."_BGPPAD_".1"_BGPX S BGPPC=$O(^BGPINDMC("OR",BGPF,0))
 S BGPDF=$P(^BGPINDMC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90556.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V^BGP6DP1C(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V^BGP6DP1C(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V^BGP6DP1C(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPINDMC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90556.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V^BGP6DP1C(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V^BGP6DP1C(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V^BGP6DP1C(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGE2 ;
 S D=D+1
 S BGPF=156_"."_BGPPAD_".2"_BGPX  S BGPPC=$O(^BGPINDMC("OR",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPINDMC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90556.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,4)=$$V^BGP6DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,5)=$S($P(BGPDAC(D),U,2):($P(BGPDAC(D),U,4)/$P(BGPDAC(D),U,2)*100),1:"")
 S $P(BGPDAP(D),U,4)=$$V^BGP6DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,5)=$S($P(BGPDAP(D),U,2):($P(BGPDAP(D),U,4)/$P(BGPDAP(D),U,2)*100),1:"")
 S $P(BGPDAB(D),U,4)=$$V^BGP6DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,5)=$S($P(BGPDAB(D),U,2):($P(BGPDAB(D),U,4)/$P(BGPDAB(D),U,2)*100),1:"")
 Q
I1AGE3 ;
 S E=E+1
 S BGPF=156_"."_BGPPAD_".3"_BGPX  S BGPPC=$O(^BGPINDMC("OR",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPINDMC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90556.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(E),U,6)=$$V^BGP6DP1C(1,BGPRPT,N,P),$P(BGPDAC(E),U,7)=$S($P(BGPDAC(E),U,2):($P(BGPDAC(E),U,6)/$P(BGPDAC(E),U,2)*100),1:"")
 S $P(BGPDAP(E),U,6)=$$V^BGP6DP1C(2,BGPRPT,N,P),$P(BGPDAP(E),U,7)=$S($P(BGPDAP(E),U,2):($P(BGPDAP(E),U,6)/$P(BGPDAP(E),U,2)*100),1:"")
 S $P(BGPDAB(E),U,6)=$$V^BGP6DP1C(3,BGPRPT,N,P),$P(BGPDAB(E),U,7)=$S($P(BGPDAB(E),U,2):($P(BGPDAB(E),U,6)/$P(BGPDAB(E),U,2)*100),1:"")
 Q
I1AGEP ;
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ Physical Activity",!,?2,"Assessment"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ Physical Activity",!,?2,"Assessment"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# w/ Exercise Educ w/",!?2,"% of Total Assessed"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ Exercise Educ w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,5) W ?T,$J(V,6,1) S T=T+7
 W !!,"# w/ Exercise Goal w/",!?2,"% of Total Assessed"
 S T=23 F X=1:1:8 S V=$P(BGPDAC(X),U,6) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ Exercise Goal w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S V=$P(BGPDAC(X),U,7) W ?T,$J(V,6,1) S T=T+7
PR ; 
 I $Y>(BGPIOSL-13) D:'$G(BGPSUMON) HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPINDM(BGPIC,53,1,0) W:$D(^BGPINDM(BGPIC,53,2,0)) !,^BGPINDM(BGPIC,53,2,0) D HPA^BGP6DPH
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ Physical Activity",!,?2,"Assessment"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ Physical Activity",!,?2,"Assessment"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# w/ Exercise Educ w/",!?2,"% of Total Assessed"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ Exercise Educ w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,5) W ?T,$J(V,6,1) S T=T+7
 W !!,"# w/ Exercise Goal w/",!?2,"% of Total Assessed"
 S T=23 F X=1:1:8 S V=$P(BGPDAP(X),U,6) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ Exercise Goal w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S V=$P(BGPDAP(X),U,7) W ?T,$J(V,6,1) S T=T+7
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"# w/ Physical Activity",!,?2,"Assessment"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"# w/ Exercise Educ w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"# w/ Exercise Goal w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
BL ;
 D:'$G(BGPSUMON) HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPINDM(BGPIC,53,1,0) W:$D(^BGPINDM(BGPIC,53,2,0)) !,^BGPINDM(BGPIC,53,2,0) D HPA^BGP6DPH
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# w/ Physical Activity",!,?2,"Assessment"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ Physical Activity",!,?2,"Assessment"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# w/ Exercise Educ w/",!?2,"% of Total Assessed"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ Exercise Educ w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,5) W ?T,$J(V,6,1) S T=T+7
 W !!,"# w/ Exercise Goal w/",!?2,"% of Total Assessed"
 S T=23 F X=1:1:8 S V=$P(BGPDAB(X),U,6) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/ Exercise Goal w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S V=$P(BGPDAB(X),U,7) W ?T,$J(V,6,1) S T=T+7
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"# w/ Physical Activity",!,?2,"Assessment"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"# w/ Exercise Educ w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"# w/ Exercise Goal w/",!?2,"% of Total Assessed"
 S T=22 F X=1:1:8 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 Q
SETN ;set numerator fields
 S BGPCYN=$$V^BGP6DP1C(1,BGPRPT,N,P)
 S BGPPRN=$$V^BGP6DP1C(2,BGPRPT,N,P)
 S BGPBLN=$$V^BGP6DP1C(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 I T=1 Q $P($G(^BGPGPDCM(R,N)),U,P)
 I T=2 Q $P($G(^BGPGPDPM(R,N)),U,P)
 I T=3 Q $P($G(^BGPGPDBM(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPGPDCM(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPGPDPM(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPGPDBM(X,N)),U,P)
 .Q
 Q C
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
