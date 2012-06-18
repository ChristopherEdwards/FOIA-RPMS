AGTXST ; IHS/ASDS/EFG - UTILITY HANDLER FOR UPDATING TRANSMISSIONS FILE ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;Modified per Patrick Cox of OKCAO.  Allows adding a multiple date
 ;for the first time.
 Q
AGR1 ;EP - find date to begin agpatch scan
 ;LOOK FOR LAST ENTRY IN THE TRANS FILE THAT'S COMPLETE
 ;AND RETURN THE DA IN AGLIEN
 ;agtxsite is used and should already be set to $O(^AUTTSITE(0))
 D INIT
LOOP S (AGLIEN,AGIEN)=0 F  S AGIEN=$O(^AGTXST(AGTXSITE,1,AGIEN)) Q:AGIEN'>0  S AGLIEN=AGIEN
 I AGLIEN,$P(^AGTXST(AGTXSITE,1,AGLIEN,0),U,10)="Y" G END ;---> found last completed run
 I AGLIEN S DA=AGLIEN,DIK="^AGTXST(AGTXSITE,1,",DA(1)=AGTXSITE D ^DIK G LOOP ;kill incomplete runs and rescan
END ;EP -
 I AGLIEN S $P(^AGTXST(AGTXSITE,1,0),U,3)=AGLIEN ;update 3rd piece to the last file entry
 K AGIEN
 Q
SET ;EP - set transmission data/status into file
 D INIT
 K DIC,DR,DA S DIC="^AGTXST("_AGTXSITE_",1,",DIC(0)="MQL",DA(1)=AGTXSITE,X=DT D ^DIC
 K DR S DA(1)=AGTXSITE,DA=+Y,DIE=DIC,DR="1///"_AGFDATE_";2///"_AGLDATE_";4///"_AG("TOT")_";9///N"
 F %=11:1:18 S DR=DR_";"_%_"///"_$G(AG("TOT",%-10))
 S DR=DR_";21///"_AG("T")_";22///"_$G(AGIN06)_";23///"_$G(AGIN01)_";24///"_$$NOW^XLFDT
 D ^DIE
 Q
COM ;EP - set tape OK and othr completion data into transmission file
 D INIT
 K DIC,DR,DA S DIC="^AGTXST("_AGTXSITE_",1,",DIC(0)="MQL",DA(1)=AGTXSITE,X=DT D ^DIC
 K DR S DA(1)=AGTXSITE,DA=+Y,DIE=DIC,DR="9///Y" D ^DIE
 Q
INIT ;EP -
 S AGTXSITE=$S($G(AGTXSITE):AGTXSITE,1:DUZ(2))
 S DIC="^AGTXST(",DIC(0)="QML",X="`"_AGTXSITE D ^DIC
 Q:Y'>0
 S:'$D(^AGTXST(AGTXSITE,1,0)) $P(^AGTXST(AGTXSITE,1,0),"^",2)=$P(^DD(9009063,1,0),"^",2)
 Q
