ACDAUTO2 ;IHS/ADC/EDE/KML - update 'CS' entries duplicated from an original; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
EN ;EP
 ;//ACDDIC
 ;
 ;Check for 'adding additional client services'
 Q:$G(DR)'="[ACD 1 (ACS)]"
 Q:'$G(ACDVISP)
 ;
 ;Check for original or duplicate
 Q:$P($G(^ACDVIS(ACDVISP,0)),U,9)
 ;
 ;List duplicates for user to see.
 F ACDUP=0:0 S ACDUP=$O(^ACDVIS("ADUP",ACDVISP,ACDUP)) Q:'ACDUP  D
 .S ACDUP(ACDUP)=""
 Q:'$O(ACDUP(0))
 W !!,"The following visits were duplicated from this original visit."
 F ACDUP=0:0 S ACDUP=$O(ACDUP(ACDUP)) Q:'ACDUP  W !,ACDUP
 W !!,*7,*7,"Shall I update them now with any changes you just made to",!,"the original visit?",!!
 S DIR(0)="S^1:YES;2:NO" D ^DIR
