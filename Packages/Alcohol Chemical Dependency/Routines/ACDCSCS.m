ACDCSCS ;IHS/ADC/EDE/KML - ADD/EDIT COPY SETS;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
START ;
 ;//[ACD CS COPY SET ADD/EDIT]
 S ACDQ=1
 W @IOF,"Signon Program is            : ",$P(^DIC(4,DUZ(2),0),U)
 W !,"Adding/editing CS copy sets for auto cs duplication",!
 ;
 S DIE="^ACDF5PI(",DA=DUZ(2),DR="[ACD CS COPY SET ADD/EDIT]",DIE("NO^")="BACK"
 D ^DIE
 I $D(ACDCSCS) S ACDQ=0
 D K
 Q
 ;
K ;
 D ^XBFMK
 Q
