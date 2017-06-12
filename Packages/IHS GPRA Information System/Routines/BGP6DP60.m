BGP6DP60 ; IHS/CMI/LAB - print ind H ; 02 Feb 2016  1:59 PM
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
 ;
I1AGEP ;EP
 W:'$G(BGPSUMON) !,"CURRENT REPORT PERIOD"
 W:'$G(BGPSUMON) !,BGPHD2
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"# w/ Medical Nutrition",!?2,"Therapy"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,2) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Medical Nutrition",!?2,"Therapy"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,3) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
 W:'$G(BGPSUMON) !!,"# w/ Specific Nutrition Educ",!?2,"Provided"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,4) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Specific Nutrition Educ",!?2,"Provided"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,5) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
 W:'$G(BGPSUMON) !!,"# w/ Exercise Educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,6) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Exercise Educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,7) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
 W:'$G(BGPSUMON) !!,"# w/ Other Exercise or",!?2,"Nutrition Educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAC(X),U,8) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Other Exercise or",!?2,"Nutrition Educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAC(X),U,9) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
PR ; 
 I $Y>(BGPIOSL-12),'$G(BGPSUMON) D HEADER^BGP6DPH Q:BGPQUIT  W:'$G(BGPSUMON) !,^BGPINDM(BGPIC,53,1,0) W:$D(^BGPINDM(BGPIC,53,2,0)) !,^BGPINDM(BGPIC,53,2,0) D H3
 W:'$G(BGPSUMON) !!,"PREVIOUS YEAR PERIOD"
 W:'$G(BGPSUMON) !,BGPHD2
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"# w/ Medical Nutrition",!?2,"Therapy"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,2) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Medical Nutrition",!?2,"Therapy"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,3) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
 W:'$G(BGPSUMON) !!,"# w/ Specific Nutrition Educ",!?2,"Provided"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,4) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Specific Nutrition Educ",!?2,"Provided"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,5) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
 W:'$G(BGPSUMON) !!,"# w/ Exercise Educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,6) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Exercise Educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,7) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
 W:'$G(BGPSUMON) !!,"# w/ Other Exercise or",!?2,"Nutrition Educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAP(X),U,8) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Other Exercise or",!?2,"Nutrition Educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAP(X),U,9) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
PB ;
 I $Y>(BGPIOSL-12),'$G(BGPSUMON) D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPINDM(BGPIC,53,1,0) W:$D(^BGPINDM(BGPIC,53,2,0)) !,^BGPINDM(BGPIC,53,2,0) D H3
 ;percentage changes
 W:'$G(BGPSUMON) !!,"CHANGE FROM PREV YR %"
 W:'$G(BGPSUMON) !,"# w/ Medical Nutrition",!?2,"Therapy"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W:'$G(BGPSUMON) !,"# w/ Specific Nutrition Ed"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W:'$G(BGPSUMON) !,"# w/ Exercise Educ"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W:'$G(BGPSUMON) !,"# w/ Other Exercise or",!?2,"Nutrition Educ"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+9
BL ;
 I $Y>(BGPIOSL-12),'$G(BGPSUMON) D HEADER^BGP6DPH Q:BGPQUIT  W !,^BGPINDM(BGPIC,53,1,0) W:$D(^BGPINDM(BGPIC,53,2,0)) !,^BGPINDM(BGPIC,53,2,0) D H3
 W:'$G(BGPSUMON) !!,"BASELINE REPORT PERIOD"
 W:'$G(BGPSUMON) !,BGPHD2
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"# w/ Medical Nutrition",!?2,"Therapy"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,2) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Medical Nutrition",!?2,"Therapy"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,3) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
 W:'$G(BGPSUMON) !!,"# w/ Specific Nutrition Educ",!?2,"Provided"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,4) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Specific Nutrition Educ",!?2,"Provided"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,5) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
 W:'$G(BGPSUMON) !!,"# w/ Exercise Educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,6) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% w/ Exercise Educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,7) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
 W:'$G(BGPSUMON) !!,"# w/ Other Exercise or",!?2,"Nutrition Educ"
 S T=30 F X=1:1:5 S V=$P(BGPDAB(X),U,8) W:'$G(BGPSUMON) ?T,$$C(V,0,6) S T=T+9
 W:'$G(BGPSUMON) !,"% # w / Other Exercise or",!?2,"Nutrition Educ"
 S T=29 F X=1:1:5 S V=$P(BGPDAB(X),U,9) W:'$G(BGPSUMON) ?T,$J(V,6,1) S T=T+9
BP ;
 ;percentage changes
 W:'$G(BGPSUMON) !!,"CHANGE FROM BASE YR %"
 W:'$G(BGPSUMON) !,"# w/ Medical Nutrition",!?2,"Therapy"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W:'$G(BGPSUMON) !,"# w/ Specific Nutrition Educ"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W:'$G(BGPSUMON) !,"# w/ Exercise Educ"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+9
 W:'$G(BGPSUMON) !,"# w/ Other Exercise or",!?2,"Nutrition Educ"
 S T=29 F X=1:1:5 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) W:'$G(BGPSUMON) ?T,$J($FN((N-O),"+,",1),6) S T=T+9
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
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
H3 ;EP
 Q:$G(BGPSUMON)
 W !!,$$CTR(BGPHD1,80)
 W !?40,"Age Distribution"
 W !,BGPHD2,?32,"6-11",?39,"12-19",?48,"20-39",?57,"40-59",?66,"60+",!
 Q
