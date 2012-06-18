BGP0DP8 ; IHS/CMI/LAB - print ind H ;
 ;;10.0;IHS CLINICAL REPORTING;;JUN 18, 2010
 ;
 ;
I1AGE ;EP special age tallies
 S BGPHD1="ACTIVE CLINICAL POPULATION",BGPHD2="# Active Clinical"
 I '$G(BGPSUMON) D HEADER^BGP0DPH Q:BGPQUIT  W !,^BGPINDT(BGPIC,53,1,0) W:$D(^BGPINDT(BGPIC,53,2,0)) !,^BGPINDT(BGPIC,53,2,0)  D H3
 K BGPDAC,BGPDAP,BGPDAB S (C,D,E)=0 F BGPX="A","B","C","D","E","F" D I1AGE1,I1AGE2,I1AGE3
 D I1AGEP
 Q
I1AGE1 ;
 ;gather up all #'s
 S C=C+1
 S BGPF="G.F.1"_BGPX S BGPPC=$O(^BGPINDTC("C",BGPF,0))
 S BGPDF=$P(^BGPINDTC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90377.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U)=$$V^BGP0DP1C(1,BGPRPT,N,P)
 S $P(BGPDAP(C),U)=$$V^BGP0DP1C(2,BGPRPT,N,P)
 S $P(BGPDAB(C),U)=$$V^BGP0DP1C(3,BGPRPT,N,P)
 ;set 2nd piece to numerator and 3rd to %
 S BGPNF=$P(^BGPINDTC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90377.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(C),U,2)=$$V^BGP0DP1C(1,BGPRPT,N,P),$P(BGPDAC(C),U,3)=$S($P(BGPDAC(C),U,1):($P(BGPDAC(C),U,2)/$P(BGPDAC(C),U)*100),1:"")
 S $P(BGPDAP(C),U,2)=$$V^BGP0DP1C(2,BGPRPT,N,P),$P(BGPDAP(C),U,3)=$S($P(BGPDAP(C),U,1):($P(BGPDAP(C),U,2)/$P(BGPDAP(C),U)*100),1:"")
 S $P(BGPDAB(C),U,2)=$$V^BGP0DP1C(3,BGPRPT,N,P),$P(BGPDAB(C),U,3)=$S($P(BGPDAB(C),U,1):($P(BGPDAB(C),U,2)/$P(BGPDAB(C),U)*100),1:"")
 Q
I1AGE2 ;
 S D=D+1
 S BGPF="G.G.1"_BGPX S BGPPC=$O(^BGPINDTC("C",BGPF,0))
 ;set 4th piece to numerator and 5th to %
 S BGPNF=$P(^BGPINDTC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90377.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,4)=$$V^BGP0DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,5)=$S($P(BGPDAC(D),U,1):($P(BGPDAC(D),U,4)/$P(BGPDAC(D),U,1)*100),1:"")
 S $P(BGPDAP(D),U,4)=$$V^BGP0DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,5)=$S($P(BGPDAP(D),U,1):($P(BGPDAP(D),U,4)/$P(BGPDAP(D),U,1)*100),1:"")
 S $P(BGPDAB(D),U,4)=$$V^BGP0DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,5)=$S($P(BGPDAB(D),U,1):($P(BGPDAB(D),U,4)/$P(BGPDAB(D),U,1)*100),1:"")
 Q
I1AGE3 ;
 S BGPF="G.H.1"_BGPX S BGPPC=$O(^BGPINDTC("C",BGPF,0))
 S E=E+1
 S BGPDF=$P(^BGPINDTC(BGPPC,0),U,8)
 S BGPNP=$P(^DD(90377.03,BGPDF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(E),U,6)=$$V^BGP0DP1C(1,BGPRPT,N,P)
 S $P(BGPDAP(E),U,6)=$$V^BGP0DP1C(2,BGPRPT,N,P)
 S $P(BGPDAB(E),U,6)=$$V^BGP0DP1C(3,BGPRPT,N,P)
 ;set 6th piece to numerator and 7th to %
 S BGPNF=$P(^BGPINDTC(BGPPC,0),U,9)
 S BGPNP=$P(^DD(90377.03,BGPNF,0),U,4),N=$P(BGPNP,";"),P=$P(BGPNP,";",2)
 S $P(BGPDAC(D),U,7)=$$V^BGP0DP1C(1,BGPRPT,N,P),$P(BGPDAC(D),U,8)=$S($P(BGPDAC(D),U,6):($P(BGPDAC(D),U,7)/$P(BGPDAC(D),U,6)*100),1:"")
 S $P(BGPDAP(D),U,7)=$$V^BGP0DP1C(2,BGPRPT,N,P),$P(BGPDAP(D),U,8)=$S($P(BGPDAP(D),U,6):($P(BGPDAP(D),U,7)/$P(BGPDAP(D),U,6)*100),1:"")
 S $P(BGPDAB(D),U,7)=$$V^BGP0DP1C(3,BGPRPT,N,P),$P(BGPDAB(D),U,8)=$S($P(BGPDAB(D),U,6):($P(BGPDAB(D),U,7)/$P(BGPDAB(D),U,6)*100),1:"")
 Q
I1AGEP ;EP
 W:'$G(BGPSUMON) !,"CURRENT REPORT PERIOD"
 W:'$G(BGPSUMON) !,BGPHD2
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"# w/ alcohol screening/Dx/",!?2,"Proc-No Refusals",!?2,"or Pt Ed"
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,2) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"% w/ alcohol screening/Dx/",!?2,"Proc-No Refusals",!?2,"or Pt Ed"
 S T=22 F X=1:1:6 S V=$P(BGPDAC(X),U,3) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+10
 W:'$G(BGPSUMON) !!,"# w/alcohol related",!?2,"education"
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,4) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"% w/alcohol related",!?2,"education"
 S T=22 F X=1:1:6 S V=$P(BGPDAC(X),U,5) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+10
 ;CHANGE DENOM AND DISPLAY THE DENOM
 ;
 W:'$G(BGPSUMON) !!!,"# Active Clinical w/ Alcohol",!?2,"Screening"
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,6) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !!,"# w/ positive alcohol",!?2,"screen"
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,7) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"% w/ positive alcohol",!?2,"screen"
 S T=22 F X=1:1:6 S V=$P(BGPDAC(X),U,8) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+10
PR ; 
 I $Y>(BGPIOSL-12) I '$G(BGPSUMON) D HEADER^BGP0DPH Q:BGPQUIT  W !,^BGPINDT(BGPIC,53,1,0) W:$D(^BGPINDT(BGPIC,53,2,0)) !,^BGPINDT(BGPIC,53,2,0) D H3
 W:'$G(BGPSUMON) !!,"PREVIOUS YEAR PERIOD"
 W:'$G(BGPSUMON) !,BGPHD2
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"# w/ alcohol screening/Dx/",!?2,"Proc-No Refusals",!?2,"or Pt Ed"
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,2) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"% w/ alcohol screening/Dx/",!?2,"Proc-No Refusals",!?2,"or Pt Ed"
 S T=22 F X=1:1:6 S V=$P(BGPDAP(X),U,3) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+10
 W:'$G(BGPSUMON) !!,"# w/alcohol related",!?2,"education"
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,4) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"% w/alcohol related",!?2,"education"
 S T=22 F X=1:1:6 S V=$P(BGPDAP(X),U,5) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+10
 ;CHANGE DENOM AND DISPLAY THE DENOM
 ;
 W:'$G(BGPSUMON) !!!,"# Active Clinical w/ Alcohol",!?2,"Screening"
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,6) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !!,"# w/ positive alcohol",!?2,"screen"
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,7) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"% w/ positive alcohol",!?2,"screen"
 S T=22 F X=1:1:6 S V=$P(BGPDAP(X),U,8) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+10
PB ;
 I $Y>(BGPIOSL-12) I '$G(BGPSUMON) D HEADER^BGP0DPH Q:BGPQUIT  W !,^BGPINDT(BGPIC,53,1,0) W:$D(^BGPINDT(BGPIC,53,2,0)) !,^BGPINDT(BGPIC,53,2,0) D H3
 ;percentage changes
 W:'$G(BGPSUMON) !!,"CHANGE FROM PREV YR %"
 W:'$G(BGPSUMON) !,"w/ alcohol screening/Dx/",!?2,"Proc-No Refusals",!?2,"or Pt Ed"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+10
 W:'$G(BGPSUMON) !,"w/ alcohol related",!?2,"education"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+10
 W:'$G(BGPSUMON) !,"w/ positive alcohol",!?2,"screen"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,8),O=$P(BGPDAP(X),U,8) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+10
BL ;
 I $Y>(BGPIOSL-12) I '$G(BGPSUMON) D HEADER^BGP0DPH Q:BGPQUIT  W:'$G(BGPSUMON) !,^BGPINDT(BGPIC,53,1,0) W:$D(^BGPINDT(BGPIC,53,2,0)) !,^BGPINDT(BGPIC,53,2,0) D H3
 W:'$G(BGPSUMON) !!,"BASELINE REPORT PERIOD"
 W:'$G(BGPSUMON) !,BGPHD2
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"# w/ alcohol screening/Dx/",!?2,"Proc-No Refusals",!?2,"or Pt Ed"
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,2) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"% w/ alcohol screening/Dx/",!?2,"Proc-No Refusals",!?2,"or Pt Ed"
 S T=22 F X=1:1:6 S V=$P(BGPDAB(X),U,3) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+10
 W:'$G(BGPSUMON) !!,"# w/alcohol related",!?2,"education"
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,4) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"% w/alcohol related",!?2,"education"
 S T=22 F X=1:1:6 S V=$P(BGPDAB(X),U,5) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+10
 ;CHANGE DENOM AND DISPLAY THE DENOM
 ;
 W:'$G(BGPSUMON) !!!,"# Active Clinical w/ Alcohol",!?2,"Screening"
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,6) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !!,"# w/ positive alcohol",!?2,"screen"
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,7) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+10
 W:'$G(BGPSUMON) !,"% w/ positive alcohol",!?2,"screen"
 S T=22 F X=1:1:6 S V=$P(BGPDAB(X),U,8) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+10
BP ;
 I $Y>(BGPIOSL-12) I '$G(BGPSUMON) D HEADER^BGP0DPH Q:BGPQUIT  W !,^BGPINDT(BGPIC,53,1,0) W:$D(^BGPINDT(BGPIC,53,2,0)) !,^BGPINDT(BGPIC,53,2,0) D H3
 ;percentage changes
 W:'$G(BGPSUMON) !!,"CHANGE FROM BASE YR %"
 W:'$G(BGPSUMON) !,"w/ alcohol screening/Dx/",!?2,"Proc-No Refusals",!?2,"or Pt Ed"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+10
 W:'$G(BGPSUMON) !,"w/ alcohol related",!?2,"education"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+10
 W:'$G(BGPSUMON) !,"w/ positive alcohol",!?2,"screen"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,8),O=$P(BGPDAB(X),U,8) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+10
 Q
SETN ;set numerator fields
 S BGPCYN=$$V^BGP0DP1C(1,BGPRPT,N,P)
 S BGPPRN=$$V^BGP0DP1C(2,BGPRPT,N,P)
 S BGPBLN=$$V^BGP0DP1C(3,BGPRPT,N,P)
 S BGPCYP=$S(BGPCYD:((BGPCYN/BGPCYD)*100),1:"")
 S BGPPRP=$S(BGPPRD:((BGPPRN/BGPPRD)*100),1:"")
 S BGPBLP=$S(BGPBLD:((BGPBLN/BGPBLD)*100),1:"")
 Q
V(T,R,N,P) ;EP
 I $G(BGPAREAA) G VA
 I T=1 Q $P($G(^BGPGPDCT(R,N)),U,P)
 I T=2 Q $P($G(^BGPGPDPT(R,N)),U,P)
 I T=3 Q $P($G(^BGPGPDBT(R,N)),U,P)
 Q ""
VA ;
 NEW X,V,C S X=0,C="" F  S X=$O(BGPSUL(X)) Q:X'=+X  D
 .I T=1 S C=C+$P($G(^BGPGPDCT(X,N)),U,P)
 .I T=2 S C=C+$P($G(^BGPGPDPT(X,N)),U,P)
 .I T=3 S C=C+$P($G(^BGPGPDBT(X,N)),U,P)
 .Q
 Q C
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
H3 ;EP
 Q:$G(BGPSUMON)
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !?25,"12-19",?34,"20-24",?44,"25-34",?55,"35-44",?64,"45-54",?74,"55-75",!
 Q
