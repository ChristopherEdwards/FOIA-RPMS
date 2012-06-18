ADEXER ; IHS/HQT/MJL - DENTAL ERROR REPORT PT 1 ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 W !!,"Dental Service Data Error Report",!!
 D ^XBKVAR
 I '$D(^AUTTSITE(1,0)) W "RPMS SITE File not properly initialized." R !,"Press 'ENTER' to continue ",X:DTIME G QUIT
ADEXCK I '$D(^ADERROR) W !,"No error reports are on file... " G OK
 ;I '$D(^ADERROR(0)) K ^ADERROR G OK ;NON-FILEMAN WORKING GLOBAL
 I '$D(^ADERROR(0)) D KILLERR G OK ;FHL 10/19/98
ADEX1 W !!,"The error report of " S Y=$P(^ADERROR(0),U,3) X ^DD("DD") W Y," is still stored.",!,"It covered the period from " S Y=$P(^ADERROR(0),U,1) X ^DD("DD") W Y," to "
 S Y=$P(^ADERROR(0),U,2) X ^DD("DD") W Y,".",!,"Do you want to print it out? N//" R X:DTIME S:'$T X=U S X=$E(X_"N")
 I X["?" W !!,"Answer 'Y' if you want to print out the report,",!,"Answer 'N' if you want to erase the old report and run a new error check." G ADEX1
 I "Yy"[X S ADEOLD=1 G ASKDEV
OK ;
DATE K ADEBDT,ADEND S U="^",%DT="AXEP",%DT("A")="SELECT BEGINNING DATE: " D ^%DT K %DT
 G:Y<0 QUIT S ADEBDT=Y,%DT="AXEP",%DT(0)=ADEBDT,%DT("A")="SELECT ENDING DATE: " D ^%DT K %DT
 G:X="^" DATE G:Y<0 QUIT S ADEND=Y
 I ADEBDT>ADEND W !,*7,"Beginning date must be before ending date." G DATE
ASKDEV S %ZIS="Q" D ^%ZIS G QUIT:POP I $D(IO("Q")) K IO("Q") D QUE W !,"REQUEST QUEUED." G QUIT
 I '$D(ADEOLD) U IO G START^ADEXER1
 U IO G ^ADEXER3
QUE I '$D(ADEOLD) S ZTRTN="START^ADEXER1",ZTDESC="DENTAL SERVICE ERROR RPT",ZTSAVE("ADEND")="",ZTSAVE("ADEBDT")="" D ^%ZTLOAD Q
 S ZTRTN="^ADEXER3",ZTDESC="DENTAL SERVICE ERROR RPT" D ^%ZTLOAD Q
QUIT K ADEBDT,ADEND,ADEOLD Q
 ;
KILLERR ; EP
 S ADESUB="" F  S ADESUB=$O(^ADERROR(ADESUB)) Q:ADESUB=""  K ^ADERROR(ADESUB)
 K ADESUB
 Q
