BGP8DP60 ; IHS/CMI/LAB - print ind H ;
 ;;8.0;IHS CLINICAL REPORTING;**2**;MAR 12, 2008
 ;
 ;
I1AGEP ;EP
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+9
 W !,"# Med Nutr Educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/Med Nutr Educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+9
 W !!,"# w/spec nutr educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,4) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/spec nutr ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,5) W ?T,$J(V,6,1) S T=T+9
 W !!,"# w/exercise educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,6) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,7) W ?T,$J(V,6,1) S T=T+9
 W !!,"# w/other educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,8) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/other educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,9) W ?T,$J(V,6,1) S T=T+9
PR ; 
 I $Y>(BGPIOSL-12) D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPINDE(BGPIC,53,1,0) D H3
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+9
 W !,"# Med Nutr Educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/Med Nutr Educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+9
 W !!,"# w/spec nutr educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,4) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/spec nutr ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,5) W ?T,$J(V,6,1) S T=T+9
 W !!,"# w/exercise educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,6) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,7) W ?T,$J(V,6,1) S T=T+9
 W !!,"# w/other educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,8) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/other educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,9) W ?T,$J(V,6,1) S T=T+9
PB ;
 I $Y>(BGPIOSL-12) D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPINDE(BGPIC,53,1,0) D H3
 I $Y>(BGPIOSL-12) D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPINDE(BGPIC,53,1,0) D H3
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"Med Nutr Educ"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W !,"Spec nutr ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W !,"w/exercise ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W !,"w/other educ"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+9
BL ;
 I $Y>(BGPIOSL-12) D HEADER^BGP8DPH Q:BGPQUIT  W !,^BGPINDE(BGPIC,53,1,0) D H3
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+9
 W !,"# Med Nutr Educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/Med Nutr Educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+9
 W !!,"# w/spec nutr educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,4) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/spec nutr ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,5) W ?T,$J(V,6,1) S T=T+9
 W !!,"# w/exercise educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,6) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/exercise ed"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,7) W ?T,$J(V,6,1) S T=T+9
 W !!,"# w/other educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,8) W ?T,$$C(V,0,6) S T=T+9
 W !,"% w/other educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,9) W ?T,$J(V,6,1) S T=T+9
BP ;
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"Med Nutr Educ"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W !,"Spec nutr ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W !,"w/exercise ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W !,"w/other educ"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+9
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
 W !,BGPHD2,?32,"6-11",?39,"12-19",?48,"20-39",?57,"40-59",?66,"=>60",!
 Q
