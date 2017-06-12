BGP7DPEF ; IHS/CMI/LAB - IHS gpra print ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
 ;
7 ;EP
 S X=""
 D S^BGP7DPED(" ",1,1) D S^BGP7DPED(" ",1,1) ;S X=$P(^BGPPEIG(BGPIC,0),U,2) D S^BGP7DPED(X,1,1)
 D H1^BGP7PDL1
 D S^BGP7DPED(" ",1,1)
 S BGPCYD=$$V^BGP7DPED(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP7DPED(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP7DPED(3,BGPRPT,11,29)
 I $G(BGPSEAT) S X=$P(^DIBT(BGPSEAT,0),U,1)_" Population w/ Pat Ed" D S^BGP7DPED(X,1,1)
 I '$G(BGPSEAT) S X="# User Pop" D S^BGP7DPED(X,1,1)
 S Y=BGPCYD_"^^"_BGPPRD_"^^^"_BGPBLD D S^BGP7DPED(Y,,2)
 D S^BGP7DPED(" ",1,1)
 S X="Goal Setting" D S^BGP7DPED(X,1,1)
 S N=11,P=24 D SETN^BGP7DPED
 S X="# w/goal set" D S^BGP7DPED(X,1,1)
 D H2^BGP7PDL1
 D S^BGP7DPED(" ",1,1)
 K BGPPROVS
 S N=16 D SETNM^BGP7DPEQ
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2  D
 ..S X=BGPCNT_".  "_$P(BGPX(BGP1,BGP2),U,2) D S^BGP7DPED(X,1,1)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP7PDL1
NOTSET ;
 D S^BGP7DPED(" ",1,1)
 S BGPCYD=$$V^BGP7DPED(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP7DPED(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP7DPED(3,BGPRPT,11,29)
 D S^BGP7DPED(" ",1,1)
 S N=11,P=25 D SETN^BGP7DPED
 S X="# w/goal not set" D S^BGP7DPED(X,1,1)
 D H2^BGP7PDL1
 D S^BGP7DPED(" ",1,1)
 K BGPPROVS
 S N=17 D SETNM^BGP7DPEQ
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2  D
 ..S X=BGPCNT_".  "_$P(BGPX(BGP1,BGP2),U,2) D S^BGP7DPED(X,1,1)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP7PDL1
MET ;
 D S^BGP7DPED(" ",1,1)
 S BGPCYD=$$V^BGP7DPED(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP7DPED(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP7DPED(3,BGPRPT,11,29)
 D S^BGP7DPED(" ",1,1)
 S N=11,P=26 D SETN^BGP7DPED
 S X="# w/goal met" D S^BGP7DPED(X,1,1)
 D H2^BGP7PDL1
 D S^BGP7DPED(" ",1,1)
 K BGPPROVS
 S N=18 D SETNM^BGP7DPEQ
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2  D
 ..S X=BGPCNT_".  "_$P(BGPX(BGP1,BGP2),U,2) D S^BGP7DPED(X,1,1)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP7PDL1
MAIN ;
 D S^BGP7DPED(" ",1,1)
 S BGPCYD=$$V^BGP7DPED(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP7DPED(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP7DPED(3,BGPRPT,11,29)
 D S^BGP7DPED(" ",1,1)
 S N=11,P=27 D SETN^BGP7DPED
 S X="# w/goal maintained" D S^BGP7DPED(X,1,1)
 D H2^BGP7PDL1
 D S^BGP7DPED(" ",1,1)
 K BGPPROVS
 S N=19 D SETNM^BGP7DPEQ
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2  D
 ..S X=BGPCNT_".  "_$P(BGPX(BGP1,BGP2),U,2) D S^BGP7DPED(X,1,1)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP7PDL1
NOTMET ;
 D S^BGP7DPED(" ",1,1)
 S BGPCYD=$$V^BGP7DPED(1,BGPRPT,11,29)
 S BGPPRD=$$V^BGP7DPED(2,BGPRPT,11,29)
 S BGPBLD=$$V^BGP7DPED(3,BGPRPT,11,29)
 D S^BGP7DPED(" ",1,1)
 S N=11,P=28 D SETN^BGP7DPED
 S X="# w/goal not met" D S^BGP7DPED(X,1,1)
 D H2^BGP7PDL1
 D S^BGP7DPED(" ",1,1)
 K BGPPROVS
 S N=21 D SETNM^BGP7DPEQ
 K BGPX
 S BGPCNT=0
 S X="",C=0 F  S X=$O(BGPPROVS(X)) Q:X=""  S Y="" F  S Y=$O(BGPPROVS(X,Y)) Q:Y=""  S C=C+1 S BGPX((9999999-$P(BGPPROVS(X,Y),U,1)),C)=X_U_Y_U_BGPPROVS(X,Y)
 S BGP1=0 F  S BGP1=$O(BGPX(BGP1)) Q:BGP1'=+BGP1!(BGPCNT>15)  D
 .S BGPCNT=BGPCNT+1 S BGP2=0 F  S BGP2=$O(BGPX(BGP1,BGP2)) Q:BGP2'=+BGP2  D
 ..S X=BGPCNT_".  "_$P(BGPX(BGP1,BGP2),U,2) D S^BGP7DPED(X,1,1)
 ..S BGPCYN=$P(BGPX(BGP1,BGP2),U,3)
 ..S BGPPRN=$P(BGPX(BGP1,BGP2),U,4)
 ..S BGPBLN=$P(BGPX(BGP1,BGP2),U,5)
 ..S BGPCYP=$P(BGPX(BGP1,BGP2),U,6)
 ..S BGPPRP=$P(BGPX(BGP1,BGP2),U,7)
 ..S BGPBLP=$P(BGPX(BGP1,BGP2),U,8)
 ..D H2^BGP7PDL1
 ;UPPED
 S X=""
 D S^BGP7DPED(" ",1,1) D S^BGP7DPED(" ",1,1) ;S X=$P(^BGPPEIG(BGPIC,0),U,2) D S^BGP7DPED(X,1,1)
 D H1^BGP7PDL1
 D S^BGP7DPED(" ",1,1)
 S BGPCYD=$$V^BGP7DPED(1,BGPRPT,11,19)
 S BGPPRD=$$V^BGP7DPED(2,BGPRPT,11,19)
 S BGPBLD=$$V^BGP7DPED(3,BGPRPT,11,19)
 I $G(BGPSEAT) S X=$P(^DIBT(BGPSEAT,0),U,1)_" Population w/ Pat Ed" D S^BGP7DPED(X,1,1)
 I '$G(BGPSEAT) S X="# User Pop w/ Pat Ed" D S^BGP7DPED(X,1,1)
 S Y=BGPCYD_"^^"_BGPPRD_"^^^"_BGPBLD D S^BGP7DPED(Y,,2)
 D S^BGP7DPED(" ",1,1)
 S X="Goal Setting" D S^BGP7DPED(X,1,1)
 S N=11,P=20 D SETN^BGP7DPED
 S X="# w/goal set" D S^BGP7DPED(X,1,1)
 D H2^BGP7PDL1
 S N=11,P=21 D SETN^BGP7DPED
 S X="# w/goal not set" D S^BGP7DPED(X,1,1)
 D H2^BGP7PDL1
 S N=11,P=22 D SETN^BGP7DPED
 S X="# w/goal met" D S^BGP7DPED(X,1,1)
 D H2^BGP7PDL1
 S N=11,P=23 D SETN^BGP7DPED
 S X="# w/goal not met" D S^BGP7DPED(X,1,1)
 D H2^BGP7PDL1
 Q