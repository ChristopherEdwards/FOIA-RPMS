BGP5DP50 ; IHS/CMI/LAB - print ind H ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
I1AGEP ;EP
 W !,"CURRENT REPORT PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# Tobacco Screening"
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/Tobacco Screening"
 S T=22 F X=1:1:6 S V=$P(BGPDAC(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Tobacco Users"
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Tobacco Users w/ % of ",!," Total Screened"
 S T=22 F X=1:1:6 S V=$P(BGPDAC(X),U,5) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Smokers"
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,6) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Smokers w/ % of",!," Total Tobacco Users"
 S T=22 F X=1:1:6 S V=$P(BGPDAC(X),U,7) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Smokeless"
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,8) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Smokeless w/ % of",!," Total Tobacco Users"
 S T=22 F X=1:1:6 S V=$P(BGPDAC(X),U,9) W ?T,$J(V,6,1) S T=T+7
 ;W !!,"# Smokers receiving",!,"Cessation Counseling"
 ;S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,10) W ?T,$$C(V,0,6) S T=T+7
 ;W !,"% Smokers w/ % of",!," Tobacco Users" w/% of",!," Tobacco Users" receiving",!,"Cessation Counseling"
 ;S T=22 F X=1:1:6 S V=$P(BGPDAC(X),U,11) W ?T,$J(V,6,1) S T=T+7
 W !!,"# ETS/Smk Home"
 S T=23 F X=1:1:6 S V=$P(BGPDAC(X),U,12) W ?T,$$C(V,0,6) S T=T+7
 W !,"% ETS/Smk Home w/ % of",!," Total Screened"
 S T=22 F X=1:1:6 S V=$P(BGPDAC(X),U,13) W ?T,$J(V,6,1) S T=T+7
PR ; 
 I $Y>(BGPIOSL-12) D HEADER^BGP5DPH Q:BGPQUIT  W !,^BGPINDV(BGPIC,53,1,0) D H3
 W !!,"PREVIOUS YEAR PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# Tobacco Screening"
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/Tobacco Screening"
 S T=22 F X=1:1:6 S V=$P(BGPDAP(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Tobacco Users"
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Tobacco Users w/ % of",!," Total Screened"
 S T=22 F X=1:1:6 S V=$P(BGPDAP(X),U,5) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Smokers"
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,6) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Smokers w/ % of",!," Total Tobacco Users"
 S T=22 F X=1:1:6 S V=$P(BGPDAP(X),U,7) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Smokeless"
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,8) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Smokeless w/ % of",!," Total Tobacco Users"
 S T=22 F X=1:1:6 S V=$P(BGPDAP(X),U,9) W ?T,$J(V,6,1) S T=T+7
 ;W !!,"# Smokers receiving",!,"Cessation Counseling"
 ;S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,10) W ?T,$$C(V,0,6) S T=T+7
 ;W !,"% Smokers w/% of",!," Tobacco Users" w/% of",!," Tobacco Users" receiving",!,"Cessation Counseling"
 ;S T=22 F X=1:1:6 S V=$P(BGPDAP(X),U,11) W ?T,$J(V,6,1) S T=T+7
 W !!,"# ETS/Smk Home"
 S T=23 F X=1:1:6 S V=$P(BGPDAP(X),U,12) W ?T,$$C(V,0,6) S T=T+7
 W !,"% ETS/Smk Home w/ % of",!," Total Screened"
 S T=22 F X=1:1:6 S V=$P(BGPDAP(X),U,13) W ?T,$J(V,6,1) S T=T+7
PB ;
 I $Y>(BGPIOSL-12) D HEADER^BGP5DPH Q:BGPQUIT  W !,^BGPINDV(BGPIC,53,1,0) D H3
 I $Y>(BGPIOSL-12) D HEADER^BGP5DPH Q:BGPQUIT  W !,^BGPINDV(BGPIC,53,1,0) D H3
 ;percentage changes
 W !!,"CHANGE FROM PREV YR %"
 W !,"Tobacco Screening"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAP(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Tobacco Users"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAP(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Smokers"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAP(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Smokeless"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAP(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 ;W !,"Counseling"
 ;S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAP(X),U,11) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"ETS"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAP(X),U,13) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
BL ;
 I $Y>(BGPIOSL-12) D HEADER^BGP5DPH Q:BGPQUIT  W !,^BGPINDV(BGPIC,53,1,0) D H3
 W !!,"BASELINE REPORT PERIOD"
 W !,BGPHD2
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U) W ?T,$$C(V,0,6) S T=T+7
 W !,"# Tobacco Screening"
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,2) W ?T,$$C(V,0,6) S T=T+7
 W !,"% w/Tobacco Screening"
 S T=22 F X=1:1:6 S V=$P(BGPDAB(X),U,3) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Tobacco Users"
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,4) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Tobacco Users w/ % of ",!," Total Screened"
 S T=22 F X=1:1:6 S V=$P(BGPDAB(X),U,5) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Smokers"
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,6) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Smokers w/ % of",!," Total Tobacco Users"
 S T=22 F X=1:1:6 S V=$P(BGPDAB(X),U,7) W ?T,$J(V,6,1) S T=T+7
 W !!,"# Smokeless"
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,8) W ?T,$$C(V,0,6) S T=T+7
 W !,"% Smokeless w/ % of",!," Total Tobacco Users"
 S T=22 F X=1:1:6 S V=$P(BGPDAB(X),U,9) W ?T,$J(V,6,1) S T=T+7
 ;W !!,"# Smokers receiving",!,"Cessation Counseling"
 ;S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,10) W ?T,$$C(V,0,6) S T=T+7
 ;W !,"% Smokers w/% of",!," Tobacco Users" w/% of",!," Tobacco Users" receiving",!,"Cessation Counseling"
 ;S T=22 F X=1:1:6 S V=$P(BGPDAB(X),U,11) W ?T,$J(V,6,1) S T=T+7
 W !!,"# ETS/Smk Home w/ % of",!," Total Screened"
 S T=23 F X=1:1:6 S V=$P(BGPDAB(X),U,12) W ?T,$$C(V,0,6) S T=T+7
 W !,"% ETS/Smk Home"
 S T=22 F X=1:1:6 S V=$P(BGPDAB(X),U,13) W ?T,$J(V,6,1) S T=T+7
BP ;
 ;percentage changes
 W !!,"CHANGE FROM BASE YR %"
 W !,"Tobacco Screening"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,3),O=$P(BGPDAB(X),U,3) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Tobacco Users"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,5),O=$P(BGPDAB(X),U,5) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Smokers"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,7),O=$P(BGPDAB(X),U,7) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"Smokeless"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,9),O=$P(BGPDAB(X),U,9) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 ;W !,"Counseling"
 ;S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,11),O=$P(BGPDAB(X),U,11) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
 W !,"ETS"
 S T=22 F X=1:1:6 S N=$P(BGPDAC(X),U,13),O=$P(BGPDAB(X),U,13) W ?T,$J($FN((N-O),"+,",1),6) S T=T+7
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
 W !?25,"5-13",?30,"14-17",?37,"18-24",?44,"25-44",?51,"45-64",?58,"65 and older",!
 Q
