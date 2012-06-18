AQAQP7 ;IHS/ORDC/LJF - DRIVER FOR PATCH #7 [ 09/15/95  12:08 PM ]
 ;;2.2;STAFF CREDENTIALS;**7**;01 OCT 1992
 ;
 W !!?20,"STAFF CREDENTIALS PATCH 7 DRIVER"
 W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Are you READY to proceed with this update"
 D ^DIR I Y'=1 K DIR,Y Q
 ;
EN ;EP; entry from A9AQAQ7
 ;
3 ; -- changes master screen on med lic file; from patch #3        
 S ^DD(9002161.2,0,"SCR")="I (+$G(^DIC(6,$P(^AQAQML(Y,0),U,2),""I""))=0)!($G(^DIC(6,$P(^AQAQML(Y,0),U,2),""I""))>DT)!($D(AQAQINAC))"
 ;
6 ; --change PCC routine called; patch #6
 S DA=$O(^DIC(19,"B","AQAQ PROVIDER COUNTS",0))
 I DA]"" S DIE=19,DR="25////APCLYV6" D ^DIE
 ;
7 ; -- add setting of DLAYGO so boards can be added
 S DA=$O(^DIC(19,"B","AQAQ EDIT SPEC BOARD",0))
 I DA]"" S DIE=19,DR="20////S DLAYGO=9002156;15////K DLAYGO" D ^DIE
 ;
 ;
END ; -- eoj
 K DA,DIE,DR,DIR
 Q
