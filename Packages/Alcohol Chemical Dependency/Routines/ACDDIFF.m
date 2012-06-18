ACDDIFF ;IHS/ADC/EDE/KML - remove DIFF reason;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
EN ;EP
 ;//^ACDDIC
 ;This program will remove the difference reason from the
 ;^ACDIIF file or the ^ACDTDC file when the actual placement
 ;and recommended placement have been set the same via a edit.
 Q:'$D(ACDVISP)
 S ACDDA=$O(^ACDIIF("C",ACDVISP,0)) I ACDDA D
 .D ^ACDWIIF
 .I ACDPLAA=ACDPLAR,ACDPLAA1=ACDPLAR1,ACDDIF'="NONE" S DIE="^ACDIIF(",DA=ACDDA,DR="19///@" D DIE^ACDFMC W !!,"   *** Deleting invalid difference code now.",*7,*7
 .Q
 S ACDDA=$O(^ACDTDC("C",ACDVISP,0)) I ACDDA D
 .D ^ACDWTDC
 .I ACDPLAA=ACDPLAR,ACDPLAA1=ACDPLAR1,ACDDIF'="NONE" S DIE="^ACDTDC(",DA=ACDDA,DR="16///@" D DIE^ACDFMC W !!,"   *** Deleting invalid difference code now.",*7,*7
 .Q
