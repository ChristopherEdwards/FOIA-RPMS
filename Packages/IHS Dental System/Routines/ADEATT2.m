ADEATT2 ; IHS/HQT/MJL  - ATTENDING DDS STMNT PT 2 ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;**26**;APRIL 1999;Build 13
 ;;IHS/OIT/GAB 10.2014 Modified for 2015 Code Updates - PATCH 26
READ D LIST^ADEGRL3 W !,"INSURER: ",ADEINSN
 W !,"Select ADA CODE: " R X:DTIME
 I '$T!(X="^") S Y=0 W !?5,"***ABORTED***" Q
 I X="" S Y=1 Q
 I X="?" W !?5,"Select an ADA CODE from the above list,",!?5,"or enter `^C' to edit the TOTAL CHARGE" H 1.7 G READ
 I X="^C" D TFEE^ADEGRL31 G READ
 I '$D(ADEV(X)) W " ??",*7 G READ
 ;IHS/OIT/GAB 11.2014 Modified below line and added the next for 2015 Code updates - PATCH #26
 ;I X="0190"!(X="0000")!(X="9130")!(X="9140") W *7," -- FEE NOT ALLOWED" H 1 G READ
 I X="0190"!(X="0000")!(X="9130")!(X="9140")!(X="9986")!(X="9987") W *7," -- FEE NOT ALLOWED" H 1 G READ
 S ADECOD=X
 D FEE^ADEGRL31
 G READ
 Q
FEE ;EP
 ;------->LOOP THRU ADEV AND GET FEE FROM ^ADEFEE
 S X=0 F J=0:0 S X=$O(ADEV(X)) Q:X=""  I $D(^AUTTADA("B",X)) S Y=$O(^AUTTADA("B",X,0)) D:Y F1
 Q
F1 I $D(^ADEFEE(Y,0)) S $P(ADEV(X),U,3)=$P(^ADEFEE(Y,0),U,2)
 Q
