ACDVFIX ;IHS/ADC/EDE/KML - FIX CDMIS visit DEMOGRAPHIC INFO;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;Go through CDMIS VISIT file and set missing demographic info.
 ;
START ;
 D ^XBKVAR
 W !,"Checking visits for missing demographic data"
 S ACDVIEN=0
 F  S ACDVIEN=$O(^ACDVIS(ACDVIEN)) Q:'ACDVIEN  I $D(^ACDVIS(ACDVIEN,0)) S X=^(0) D CHK Q:ACDQ
 Q
 ;
CHK ; CHECK FOR MISSING VISIT DEMO DATA
 S ACDQ=0
 W:'ACDVIEN#100 "."
 S ACDDFNP=$P(X,U,5)
 Q:'ACDDFNP  ;                   not patient related visit
 Q:'$D(^DPT(ACDDFNP,0))  ;       corrupted patient file
 S ACDSEX=$P(^DPT(ACDDFNP,0),U,2)
 S DIE="^ACDVIS(",DA=ACDVIEN,DR="103////"_ACDSEX
 D DIE^ACDFMC
 I $D(Y) W !,"Modify of 9002172.1,103 failed for visit ",ACDVIEN Q
 W "|"
 Q
