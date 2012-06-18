BNIBAN ; IHS/CMI/LAB - Banner routine for BNI package ;
 ;;1.0;BNI CPHD ACTIVITY DATASYSTEM;;DEC 20, 2006
 ;
 ;Writes all menu banners.
EP ;EP
V ; GET VERSION
 S BNI("VERSION")="",BNI("VERSION")=$O(^DIC(9.4,"C","BNI",BNI("VERSION"))),BNI("VERSION")=^DIC(9.4,BNI("VERSION"),"VERSION")
 I $G(BNITEXT)="" S BNITEXT="TEXT",BNILINE=3 G PRINT
 S BNITEXT="TEXT"_BNITEXT
 F BNIJ=1:1 S BNIX=$T(@BNITEXT+BNIJ),BNIX=$P(BNIX,";;",2) Q:BNIX="QUIT"!(BNIX="")  S BNILINE=BNIJ
PRINT W:$D(IOF) @IOF
 F BNIJ=1:1:BNILINE S BNIX=$T(@BNITEXT+BNIJ),BNIX=$P(BNIX,";;",2) W !?80-$L(BNIX)\2,BNIX K BNIX
 S X=$P(^DIC(4,DUZ(2),0),U)
 W !?80-$L(X)/2,X
 W !?80-(8+$L(BNI("VERSION")))/2,"Version ",BNI("VERSION")
XIT ;
 K DIC,DA,X,Y,%Y,%,BNIJ,BNIX,BNITEXT,BNILINE
 Q
TEXT ;chr
 ;;******************************************************************
 ;;** RPMS Computerized Public Health Activity Data System (CPHAD) **
 ;;******************************************************************
 ;;QUIT
TEXTR ;reports menu
 ;;******************************************************************
 ;;** RPMS Computerized Public Health Activity Data System (CPHAD) **
 ;;**                         Reports                              **
 ;;******************************************************************
 ;;QUIT
TEXTT ;table listings
 ;;******************************************************************
 ;;** RPMS Computerized Public Health Activity Data System (CPHAD) **
 ;;**                       Table Listings                         **
 ;;******************************************************************
 ;;QUIT
