ACDCLN ;IHS/ADC/EDE/KML - UTILITY TO CLEAN BROKEN LINKS IN DB;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;*******************************************************************
 ;//PROG MODE
 ;*******************************************************************
EN ;EP
 ;//^ACDGSAVE
 ;
 W !!,"Re-indexing files now.....",!
 K ^ACDIIF("C") S DIK(1)="99.99^C",DIK="^ACDIIF(" D ENALL^DIK
 K ^ACDTDC("C") S DIK(1)="99.99^C",DIK="^ACDTDC(" D ENALL^DIK
 K ^ACDCS("C") S DIK(1)="99.99^C",DIK="^ACDCS(" D ENALL^DIK
 K ^ACDVIS("B") S DIK(1)=".01^B",DIK="^ACDVIS(" D ENALL^DIK
 K ^ACDVIS("C") S DIK(1)="99.99^C",DIK="^ACDVIS(" D ENALL^DIK
 ;
EN1 ;EP skip re-indexing
 ;//^ACDDFAC
 ;//^ACDPURG
 ;
 D D
V ;Delete visits in ^ACDVIS last
 W !!!!!,"Cleaning up entries from the CDMIS visit file that are not being"
 W !,"referenced."
 S ACDCNT=0 F ACDVISP=0:0 S ACDVISP=$O(^ACDVIS(ACDVISP)) Q:'ACDVISP  D V1
 W !,"Total of ",ACDCNT," visits deleted."
 K DA,DIK,ACDVISP,ACD80,ACDDA,ACDOK,ACDDO,ACDCNT
 Q
V1 ;
 S ACDOK=0
 I $O(^ACDIIF("C",ACDVISP,0)) S ACDOK=1
 I $O(^ACDTDC("C",ACDVISP,0)) S ACDOK=1
 I $O(^ACDCS("C",ACDVISP,0)) S ACDOK=1
 I 'ACDOK D VDEL W !,"Entry ",ACDVISP," is unreferenced...deleting now."
 ;
 Q
VDEL ;Delete unreferenced visit
 S DA=ACDVISP,DIK="^ACDVIS(" D ^DIK
 S ACDCNT=ACDCNT+1
 Q
D ;Check link files first
 S ACDCNT=0
 W !,"Now cleaning up incomplete data links..."
 F ACDDO=0:0 S ACDDO=$O(^ACDIIF(ACDDO)) Q:'ACDDO  S ACDVISP=$S($D(^(ACDDO,"BWP")):^("BWP"),1:"??") I '$D(^ACDIIF(ACDDO,0))!('$D(^ACDIIF(ACDDO,"BWP")))!('$D(^ACDVIS(ACDVISP,0))) S DA=ACDDO,DIK="^ACDIIF(" D ^DIK W "." S ACDCNT=ACDCNT+1
 F ACDDO=0:0 S ACDDO=$O(^ACDTDC(ACDDO)) Q:'ACDDO  S ACDVISP=$S($D(^(ACDDO,"BWP")):^("BWP"),1:"??") I '$D(^ACDTDC(ACDDO,0))!('$D(^ACDTDC(ACDDO,"BWP")))!('$D(^ACDVIS(ACDVISP,0))) S DA=ACDDO,DIK="^ACDTDC(" D ^DIK W "." S ACDCNT=ACDCNT+1
 F ACDDO=0:0 S ACDDO=$O(^ACDCS(ACDDO)) Q:'ACDDO  S ACDVISP=$S($D(^(ACDDO,"BWP")):^("BWP"),1:"??") D
 .  S D=0
 .  I '$D(^ACDCS(ACDDO,0))!('$D(^ACDCS(ACDDO,"BWP")))!('$D(^ACDVIS(ACDVISP,0))) S D=1
 .  I 'D,$P(^ACDCS(ACDDO,0),U,2)="" S D=1
 .  I D S DA=ACDDO,DIK="^ACDCS(" D ^DIK W "." S ACDCNT=ACDCNT+1
 .  Q
 ;F ACDDO=0:0 S ACDDO=$O(^ACDCS(ACDDO)) Q:'ACDDO  S ACDVISP=$S($D(^(ACDDO,"BWP")):^("BWP"),1:"??") I '$D(^ACDCS(ACDDO,0))!('$D(^ACDCS(ACDDO,"BWP")))!('$D(^ACDVIS(ACDVISP,0))) S DA=ACDDO,DIK="^ACDCS(" D ^DIK W "." S ACDCNT=ACDCNT+1
 W !,"Total of ",ACDCNT," entries deleted."
 Q
