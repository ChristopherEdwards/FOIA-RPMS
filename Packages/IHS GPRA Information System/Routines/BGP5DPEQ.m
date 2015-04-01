BGP5DPEQ ; IHS/CMI/LAB - IHS gpra print ;
 ;;15.0;IHS CLINICAL REPORTING;;NOV 18, 2014;Build 134
 ;
7 ;EP
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2)
 D H1^BGP5DPH
 S BGPCYD=$$V^BGP5DPEP(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP5DPEP(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP5DPEP(3,BGPRPT,11,29)
 I $G(BGPSEAT) W !!,$P(^DIBT(BGPSEAT,0),U,1)," Population"
 W:'$G(BGPSEAT) ! W !,"# User Pop"
 W ?20,$$C^BGP5DPEP(BGPCYD,0,8),?35,$$C^BGP5DPEP(BGPPRD,0,8),?58,$$C^BGP5DPEP(BGPBLD,0,8),!
 S N=11,P=24 D SETN^BGP5DPEP
 W !,"# w/ Goal Set"
 D H2^BGP5DPH
 K BGPPROVS
 S N=16 D SETNM
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPQUIT)!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2!(BGPQUIT)  D
 ..I $Y>(BGPIOSL-3) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2) D H1^BGP5DPH W !
 ..W !?2,BGPCNT,". ",$E($P(BGPX(BGP1,BGP2),U,2),1,15)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP5DPH
 ;not set
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2) D H1^BGP5DPH
 S BGPCYD=$$V^BGP5DPEP(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP5DPEP(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP5DPEP(3,BGPRPT,11,29)
 ;I $G(BGPSEAT) W !!,$P(^DIBT(BGPSEAT,0),U,1)," Population"
 ;W:'$G(BGPSEAT) ! W !,"Total User Population",!," Patients"
 W !!
 S N=11,P=25 D SETN^BGP5DPEP
 W !,"# w/ Goal Not Set"
 D H2^BGP5DPH
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2)
 K BGPPROVS
 S N=17 D SETNM^BGP5DPEQ
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPQUIT)!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2!(BGPQUIT)  D
 ..I $Y>(BGPIOSL-3) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2) D H1^BGP5DPH W !
 ..W !?2,BGPCNT,". ",$E($P(BGPX(BGP1,BGP2),U,2),1,15)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP5DPH
 ;
 ;met
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2) D H1^BGP5DPH
 S BGPCYD=$$V^BGP5DPEP(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP5DPEP(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP5DPEP(3,BGPRPT,11,29)
 ;I $G(BGPSEAT) W !!,$P(^DIBT(BGPSEAT,0),U,1)," Population"
 ;W:'$G(BGPSEAT) ! W !,"Total User Population",!," Patients"
 W !!
 S N=11,P=26 D SETN^BGP5DPEP
 W !,"# w/ Goal Met"
 D H2^BGP5DPH
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2)
 K BGPPROVS
 S N=18 D SETNM^BGP5DPEQ
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPQUIT)!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2!(BGPQUIT)  D
 ..I $Y>(BGPIOSL-3) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2) D H1^BGP5DPH W !
 ..W !?2,BGPCNT,". ",$E($P(BGPX(BGP1,BGP2),U,2),1,15)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP5DPH
 ;maintain
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2) D H1^BGP5DPH
 S BGPCYD=$$V^BGP5DPEP(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP5DPEP(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP5DPEP(3,BGPRPT,11,29)
 ;I $G(BGPSEAT) W !!,$P(^DIBT(BGPSEAT,0),U,1)," Population"
 ;W:'$G(BGPSEAT) ! W !,"Total User Population",!," Patients"
 W !!
 S N=11,P=27 D SETN^BGP5DPEP
 W !,"# w/ Goal Maintained"
 D H2^BGP5DPH
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2)
 K BGPPROVS
 S N=19 D SETNM^BGP5DPEQ
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPQUIT)!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2!(BGPQUIT)  D
 ..I $Y>(BGPIOSL-3) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2) D H1^BGP5DPH W !
 ..W !?2,BGPCNT,". ",$E($P(BGPX(BGP1,BGP2),U,2),1,15)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP5DPH
 ;not met
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2) D H1^BGP5DPH
 S BGPCYD=$$V^BGP5DPEP(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP5DPEP(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP5DPEP(3,BGPRPT,11,29)
 ;I $G(BGPSEAT) W !!,$P(^DIBT(BGPSEAT,0),U,1)," Population"
 ;W:'$G(BGPSEAT) ! W !,"Total User Population",!," Patients"
 W !!
 S N=11,P=28 D SETN^BGP5DPEP
 W !,"# w/ Goal Not Met"
 D H2^BGP5DPH
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2)
 K BGPPROVS
 S N=21 D SETNM^BGP5DPEQ
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPQUIT)!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2!(BGPQUIT)  D
 ..I $Y>(BGPIOSL-3) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2) D H1^BGP5DPH W !
 ..W !?2,BGPCNT,". ",$E($P(BGPX(BGP1,BGP2),U,2),1,15)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP5DPH
 ;UP PED
 I $Y>(BGPIOSL-6) D HEADER^BGP5DPEP Q:BGPQUIT  W !,$P(^BGPPEIK(BGPIC,0),U,2)
 D H1^BGP5DPH
 S BGPCYD=$$V^BGP5DPEP(1,BGPRPT,11,19)
 S BGPPRD=$$V^BGP5DPEP(2,BGPRPT,11,19)
 S BGPBLD=$$V^BGP5DPEP(3,BGPRPT,11,19)
 I '$G(BGPSEAT) W !!,"# User Pop w/ Pat Ed"
 I $G(BGPSEAT) W !!,$P(^DIBT(BGPSEAT,0),U,1)," Population",!," w/ Pat Ed"
 W ?20,$$C^BGP5DPEP(BGPCYD,0,8),?35,$$C^BGP5DPEP(BGPPRD,0,8),?58,$$C^BGP5DPEP(BGPBLD,0,8),!
 W ! ;,"Goal Setting"
 S N=11,P=20 D SETN^BGP5DPEP
 W !,"# w/goal set"
 D H2^BGP5DPH
 S N=11,P=21 D SETN^BGP5DPEP
 W !,"# w/goal not set"
 D H2^BGP5DPH
 S N=11,P=22 D SETN^BGP5DPEP
 W !,"# w/goal met"
 D H2^BGP5DPH
 S N=11,P=23 D SETN^BGP5DPEP
 W !,"# w/goal not met"
 D H2^BGP5DPH
 ;
 Q
 ;----------
SETNM ;EP
 K BGPPROVS
 S (BGPCYD,BGPPRD,BGPBLD)=0
 I $G(BGPAREAA) D SETNMA Q
 S X=0 F  S X=$O(^BGPPEDCK(BGPRPT,N,X)) Q:X'=+X  D
 .S C=$P(^BGPPEDCK(BGPRPT,N,X,0),U),L=$P(^BGPPEDCK(BGPRPT,N,X,0),U,2),M=$P(^BGPPEDCK(BGPRPT,N,X,0),U,3)
 .S $P(BGPPROVS(C,L),U,1)=M,BGPCYD=BGPCYD+M
 S X=0 F  S X=$O(^BGPPEDPK(BGPRPT,N,X)) Q:X'=+X  D
 .S C=$P(^BGPPEDPK(BGPRPT,N,X,0),U),L=$P(^BGPPEDPK(BGPRPT,N,X,0),U,2),M=$P(^BGPPEDPK(BGPRPT,N,X,0),U,3)
 .S $P(BGPPROVS(C,L),U,2)=M,BGPPRD=BGPPRD+M
 S X=0 F  S X=$O(^BGPPEDBK(BGPRPT,N,X)) Q:X'=+X  D
 .S C=$P(^BGPPEDBK(BGPRPT,N,X,0),U),L=$P(^BGPPEDBK(BGPRPT,N,X,0),U,2),M=$P(^BGPPEDBK(BGPRPT,N,X,0),U,3)
 .S $P(BGPPROVS(C,L),U,3)=M,BGPBLD=BGPBLD+M
 ;set %ages
 S X="" F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  D
 .S A=$P(BGPPROVS(X,Y),U,1),$P(BGPPROVS(X,Y),U,4)=$S(BGPCYD:((A/BGPCYD)*100),1:"")
 .S B=$P(BGPPROVS(X,Y),U,2),$P(BGPPROVS(X,Y),U,5)=$S(BGPPRD:((B/BGPPRD)*100),1:"")
 .S C=$P(BGPPROVS(X,Y),U,3),$P(BGPPROVS(X,Y),U,6)=$S(BGPBLD:((C/BGPBLD)*100),1:"")
 .Q
 Q
SETNMA ;
 NEW X,V,C S Z=0,C="" F  S Z=$O(BGPSUL(Z)) Q:Z'=+Z  D SETNMA1
 S X="" F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  D
 .S A=$P(BGPPROVS(X,Y),U,1),$P(BGPPROVS(X,Y),U,4)=$S(BGPCYD:((A/BGPCYD)*100),1:"")
 .S B=$P(BGPPROVS(X,Y),U,2),$P(BGPPROVS(X,Y),U,5)=$S(BGPPRD:((B/BGPPRD)*100),1:"")
 .S C=$P(BGPPROVS(X,Y),U,3),$P(BGPPROVS(X,Y),U,6)=$S(BGPBLD:((C/BGPBLD)*100),1:"")
 .Q
 Q
SETNMA1 ;
 S X=0 F  S X=$O(^BGPPEDCK(Z,N,X)) Q:X'=+X  D
 .S C=$P(^BGPPEDCK(Z,N,X,0),U),L=$P(^BGPPEDCK(Z,N,X,0),U,2),M=$P(^BGPPEDCK(Z,N,X,0),U,3)
 .S $P(BGPPROVS(C,L),U,1)=$P($G(BGPPROVS(C,L)),U,1)+M,BGPCYD=BGPCYD+M
 S X=0 F  S X=$O(^BGPPEDPK(Z,N,X)) Q:X'=+X  D
 .S C=$P(^BGPPEDPK(Z,N,X,0),U),L=$P(^BGPPEDPK(Z,N,X,0),U,2),M=$P(^BGPPEDPK(Z,N,X,0),U,3)
 .S $P(BGPPROVS(C,L),U,2)=$P($G(BGPPROVS(C,L)),U,2)+M,BGPPRD=BGPPRD+M
 S X=0 F  S X=$O(^BGPPEDBK(Z,N,X)) Q:X'=+X  D
 .S C=$P(^BGPPEDBK(Z,N,X,0),U),L=$P(^BGPPEDBK(Z,N,X,0),U,2),M=$P(^BGPPEDBK(Z,N,X,0),U,3)
 .S $P(BGPPROVS(C,L),U,3)=$P($G(BGPPROVS(C,L)),U,3)+M,BGPBLD=BGPBLD+M
 .Q
 Q