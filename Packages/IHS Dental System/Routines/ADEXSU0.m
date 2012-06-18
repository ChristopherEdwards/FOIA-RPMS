ADEXSU0 ; IHS/HQT/MJL  - DENTAL EXTRACT PART 2 ;  [ 05/12/1999  5:04 PM ]
 ;;6.0;ADE;**1**;MAY 12, 1999
ADEXCK ;EP
 G:'$D(^ADENDATA) OK
 G:$D(^ADENDATA(0)) ADEX1 W !,"The data storage area contains an incomplete file of previously extracted data."
ADEX R !,"Ok if I erase it? N//",X:DTIME S:'$T X=U S X=$E(X_"N")
 I X["?" W !,"The incomplete data file was probably created during an aborted extraction",!,"attempt." G ADEX
 I "Yy"'[X W !," -- data extraction cancelled." G QUIT
 G OK
ADEX1 W !,"Data extracted on " S Y=$P(^ADENDATA(0),U,3) S:$L(Y)=8 Y=Y-17000000 X ^DD("DD") W Y," is still stored.",!,"It will be erased if you continue.",!
 ;MJL On previous line subtracted 17 Million from CCYYMMDD formatted date to convert to FM internal date so ^DD("DD") could return a valid date
CONFIRM R "Ok to continue? N// ",X:DTIME S:'$T X=U S X=$E(X_"N")
 I X["?" W !,"It is ok to clear the data extraction holding file if the data",!,"has already been forwarded to Area for processing.",! G CONFIRM
 I "Yy"'[X W " -- data extraction cancelled.",! G QUIT
OK G:$D(ADEREX) ASKDEV
DATE S U="^",%DT="AXEP",%DT("A")="SELECT BEGINNING DATE: " D ^%DT K %DT
 G:Y<0 QUIT S ADEBDT=Y,%DT="AXEP",%DT(0)=ADEBDT,%DT("A")="SELECT ENDING DATE: " D ^%DT K %DT
 G:X="^" DATE G:Y<0 QUIT S ADEND=Y
ASKDEV S %ZIS="Q" D ^%ZIS G QUIT:POP I $D(IO("Q")) K IO("Q") D QUE W !,"REQUEST QUEUED." G QUIT
 U IO G START^ADEXSU1
QUE S ZTRTN="START^ADEXSU1",ZTDESC="DENTAL SERVICE DATA EXTRACT",ZTSAVE("ADEND")="",ZTSAVE("ADEBDT")="",ZTSAVE("ADEXDT")="" S:$D(ADEREX) ZTSAVE("ADEREX")="",ZTSAVE("ADEXDA")=""
 S ZTSAVE("ADECHS")=""
 S:$D(ADERERUN) ZTSAVE("ADERERUN")="",ZTSAVE("ADEXDA")=""
 D ^%ZTLOAD Q
QUIT K ADELAST,ADELDAY,ADESTAT,ADEXDT,ADEXDA,ADEBDT,ADEND,ADEREX,ADEXNOD,ADERERUN Q
