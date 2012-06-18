ACDCLN0 ;IHS/ADC/EDE/KML - UTILITY TO LIST BROKEN LINKS IN DB;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;***************************************************************
 ;//PROG MODE
 ;List broken links in dbase
 ;*****************************************************************
 D D
V ;Check visit file last
 W !!,"Listing entries from the CDMIS visit file that are not being"
 W !,"referenced by any of the CDMIS data files",!!!
 S ACDCNT=0 F ACDVISP=0:0 S ACDVISP=$O(^ACDVIS(ACDVISP)) Q:'ACDVISP  D V1
 W !!,"Total of ",ACDCNT," visits not referenced.",!!
 K DA,DIK,ACDVISP,ACD80,ACDDA,ACDDO,ACDOK,ACDCNT
 D ^%ZISC
 Q
V1 ;
 S ACDOK=0
 I $O(^ACDIIF("C",ACDVISP,0)) S ACDOK=1
 I $O(^ACDTDC("C",ACDVISP,0)) S ACDOK=1
 I $O(^ACDCS("C",ACDVISP,0)) S ACDOK=1
 I 'ACDOK W !,"ENTRY ",ACDVISP," FROM THE ^ACDVIS GLOBAL IS NOT REFERENCED" S ACDCNT=ACDCNT+1
 Q
D ;Check data files first
 S ACDCNT=0
 W !!!,"Listing partial entries from CDMIS data files that need to be corrected",!
 F ACDDO=0:0 S ACDDO=$O(^ACDIIF(ACDDO)) Q:'ACDDO  S ACDVISP=$S($D(^(ACDDO,"BWP")):^("BWP"),1:"??") I '$D(^ACDIIF(ACDDO,0))!('$D(^ACDIIF(ACDDO,"BWP")))!('$D(^ACDVIS(ACDVISP,0))) W !,"ENTRY ",ACDDO," FROM THE ^ACDIIF GLOBAL IS" D D1
 F ACDDO=0:0 S ACDDO=$O(^ACDTDC(ACDDO)) Q:'ACDDO  S ACDVISP=$S($D(^(ACDDO,"BWP")):^("BWP"),1:"??") I '$D(^ACDTDC(ACDDO,0))!('$D(^ACDTDC(ACDDO,"BWP")))!('$D(^ACDVIS(ACDVISP,0))) W !,"ENTRY ",ACDDO," FROM THE ^ACDTDC GLOBAL IS" D D1
 F ACDDO=0:0 S ACDDO=$O(^ACDCS(ACDDO)) Q:'ACDDO  S ACDVISP=$S($D(^(ACDDO,"BWP")):^("BWP"),1:"??") I '$D(^ACDCS(ACDDO,0))!('$D(^ACDCS(ACDDO,"BWP")))!('$D(^ACDVIS(ACDVISP,0))) W !,"ENTRY ",ACDDO," FROM THE ^ACDCS GLOBAL IS" D D1
 W !,"Total of ",ACDCNT," entries with errors found",!!!
 Q
D1 ;
 W !,"Missing one of the following:",!,"1 THE 0 NODE",!,"2 THE 'BWP' NODE",!,"3 THE POINTED TO VISIT",!!
 S ACDCNT=ACDCNT+1
