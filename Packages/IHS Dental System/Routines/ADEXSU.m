ADEXSU ; IHS/HQT/MJL - DENTAL EXTRACT PART 1 ;  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;;APRIL 1999
 W !!,"Dental Service Data Extraction for Transmission to Area HQ",!!
INIT D ^XBKVAR
 I '$D(^AUTTSITE(1,0)) W "RPMS SITE File not properly initialized. Contact Site Manager." G QUIT
 I '$D(^ADEPARAM(+^AUTTSITE(1,0),0)) W "DENTAL SITE PARAMETER File not initialized. Contact Site Manager." G QUIT
 S ADECHS=0 S:$P(^ADEPARAM(+^AUTTSITE(1,0),0),U,6)="y" ADECHS=1
CTRL ;------->IF NO PREVIOUS EXTRACTION GO SUEX0
 I '$D(^ADELOG("LAST","D")) S ADEXDT=DT G ADEXCK^ADEXSU0
 ;------->GET INFO ON LAST EXTRACTION
 S ADELAST=^ADELOG("LAST","D"),ADESTAT=$P(ADELAST,U,2),ADELAST=$P(ADELAST,U) S Y=ADELAST X ^DD("DD") S ADELDAY=Y W "The last data extraction was performed on ",ADELDAY
 ;------->LAST EXTRACTION ABENDED - FORCE RE-EXRACTION
 I ADESTAT["AB" W " but it ended abnormally." G LOG1
 ;------->LAST EXTRACTION ENDED OK
 W " and it finished normally."
 ;------->IF LAST EXTRACT DONE BEFORE TODAY - NEW OR DUPE EXTRACT
 G:ADELAST'=DT LOG3
 ;------->LAST EXTRACT WAS EARLIER TODAY - CHECK LOG FILE INTEGRITY
 I '+$P(^ADELOG("LAST","D"),U,3) W !,"LOG FILE CORRUPTED!" G QUIT
 I '$D(^ADELOG($P(^ADELOG("LAST","D"),U,3),0)) W !,"LOG FILE CORRUPTED!" G QUIT
 S ADEXDA=$P(^ADELOG("LAST","D"),U,3)
 ;------->FORCE RE-EXTRACT IF LOG-FILE INACCURATE
 G:$P(^ADELOG(ADEXDA,0),U,5)'="D" LOG1
 ;------->OTW REPEAT OR DUPE EXTRACT
 G LOG2
END ;
LOG1 R !!,"Do you want to reset that day's extract flags",!,"and run a fresh extraction  //N ",X:DTIME G:('$T)!(X["^") QUIT S X=$E(X_"N")
 I X["?" W !!,"Answer 'Yes' to delete all extract flags set on ",ADELDAY," and proceed",!,"with a fresh extraction of all unflagged visits.  You will be prompted"
 I X["?" W !,"for a Beginning Date and an Ending date.",!,"Answer 'N' to quit without changing anything." G LOG1
 G:"Yy"'[X QUIT
 S ADERDV=ADELAST,ADEXDT=DT
 D RESET2^ADERFLG K ADERDV
 S ADEXDA=$P(^ADELOG("LAST","D"),U,3) I '+ADEXDA K ADEXDA
 S ADERERUN=1
 G ADEXCK^ADEXSU0
LOG2 R !!,"Do you want to repeat an extraction run earlier today? N// ",X:DTIME G:('$T)!(X["^") QUIT S X=$E(X_"N")
 I X["?" W !!,"Answer 'Yes' to delete all extract flags set earlier today",!,"and proceed with a fresh extraction of unflagged visits.  You will be"
 I X["?" W !,"prompted for a Beginning Date and an Ending date.",!,"Answer 'N' to quit without changing anything." G LOG2
 I "Yy"'[X G LOG3
 S ADERERUN=1,ADERDV=ADELAST,ADEXDT=DT D RESET2^ADERFLG G ADEXCK^ADEXSU0
LOG3 R !!,"Do you want to DUPLICATE an extraction run previously? N// ",X:DTIME G:('$T)!(X["^") QUIT S X=$E(X_"N")
 I X["?" W !!,"Answer 'Yes' to duplicate a previous extraction. No extraction flags will be",!,"set or reset. You will be asked to select a date from the Data Extraction Log",!,"File. Only visits extracted on that day will be stored." G LOG3
 I "Yy"'[X G LOG6
LOG4 S DIC="^ADELOG(",DIC(0)="AEZQ",DIC("S")="I $P(^ADELOG(Y,0),U,5)=""D""",DIC("A")="Select Extraction Log Date: ",%DT="AEQP" D ^DIC K DIC,%DT I Y=-1 W " -- Data extraction cancelled" G QUIT
 S ADEXDA=$P(Y,U),ADEXNOD=^ADELOG(ADEXDA,0),ADEXDT=$P(ADEXNOD,U),ADEBDT=$P(ADEXNOD,U,2),ADEND=$P(ADEXNOD,U,3),ADEREX=1
 W !!,"Ready to repeat extraction performed originally on ",Y(0,0),".",!,"The original record count was ",$S($P(ADEXNOD,U,4)]"":$P(ADEXNOD,U,4),1:0),", but this may be different",!,"today if visits have been modified or deleted."
LOG5 R !!,"Are you sure everything's OK? NO// ",X:DTIME G:'$T QUIT S X=$E(X_"N")
 I X["?" W !,"Answer 'Y' or 'N'" G LOG5
 I "Yy"'[X W " -- Data extraction cancelled" G QUIT
 G ADEXCK^ADEXSU0
LOG6 G:ADELAST=DT QUIT R !,"Do you want to run a new data extraction today? N//",X:DTIME G:'$T QUIT G:X["^" LOG3 S X=$E(X_"N")
 I X["?" W !!,"Answer 'Y' to extract data from all dental records not already flagged",!,"as extracted.  You will be asked for a range of dates to extract from.",!,"Answer 'N' to quit without changing anything.",! G LOG6
 I "Yy"'[X W " -- Data extraction cancelled" G QUIT
 S ADEXDT=DT
 G ADEXCK^ADEXSU0
QUIT K ADELAST,ADELDAY,ADESTAT,ADEXDT,ADEXDA,ADEBDT,ADEND,ADEREX,ADEXNOD,ADERERUN,ADECHS Q
