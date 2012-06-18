ACDPPFIX ;IHS/ADC/EDE/KML - fix files pointing to patient;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;Go through CDMIS files and repoint bad patient pointers to 885.
 ;
START ;
 D ^XBKVAR
 NEW F,P
 W !,"Checking CDMIS patient pointers"
 S ACDTIEN=0,ACDGBL="^ACDVIS(",ACDFP="4;5"
 F  S ACDTIEN=$O(^ACDVIS(ACDTIEN)) Q:'ACDTIEN  I $D(^ACDVIS(ACDTIEN,0)) S X=^(0) D CHK
 S ACDTIEN=0,ACDGBL="^ACDINTV(",ACDFP="1;2"
 F  S ACDTIEN=$O(^ACDINTV(ACDTIEN)) Q:'ACDTIEN  I $D(^ACDINTV(ACDTIEN,0)) S X=^(0) D CHK
 S ACDTIEN=0
 F  S ACDTIEN=$O(^ACDPAT(ACDTIEN)) Q:'ACDTIEN  I $D(^ACDPAT(ACDTIEN,0)) D
 .  S ACDMIEN=0
 .  F  S ACDMIEN=$O(^ACDPAT(ACDTIEN,1,ACDMIEN)) Q:'ACDMIEN  D
 ..  I $D(^DPT(ACDMIEN,0)),$D(^AUPNPAT(ACDMIEN,0)) Q  ; pointer is good
 ..  S DIK="^ACDPAT("_ACDTIEN_",1,",DA=ACDMIEN,DA(1)=ACDTIEN
 ..  D DIK^ACDFMC
 ..  W "|"
 ..  Q
 .  Q
 Q
 ;
CHK ; CHECK FOR BAD PATIENT POINTERS
 W:'(ACDTIEN#100) "."
 S F=$P(ACDFP,";"),P=$P(ACDFP,";",2)
 S Y=$P(X,U,P)
 Q:'Y  ;                                  no patient pointer
 I $D(^DPT(Y,0)),$D(^AUPNPAT(Y,0)) Q  ;   pointer is good
 S DIE=ACDGBL,DA=ACDTIEN,DR=F_"////885"
 D DIE^ACDFMC
 I $D(Y) W !,"Modify of "_ACDGBL_" failed for entry ",ACDTIEN Q
 W "|"
 Q
