ACDGLOCK ;IHS/ADC/EDE/KML - MAKE OPTIONS UNAVAILABLE DURING DATA EXTRACTS/IMPORTS; 
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;**********************************************************************
 ;Lock menue during Extraction, Importing, Purging, and Deleting
 ;facility data from the area or HQ machine
 ;**********************************************************************
EN ;EP Lock
 ;//^ACDGSAVE, ^ACDGMRG, ^ACDDFAC, ^ACDPURG
 W !!,"Locking CDMIS menu until completion."
 S ACDOPT="ACD" F  S ACDOPT=$O(^DIC(19,"B",ACDOPT)) Q:ACDOPT=""!($E(ACDOPT,1,3)'="ACD")  D
 .I ACDOPT="ACD SERVER" Q
 .I ACDOPT="ACDMGR" Q
 .I ACDOPT="ACDUNLOCK" Q
 .S DA=$O(^DIC(19,"B",ACDOPT,0))
 .I DA S DIE=19,DR="2////"_"DATA TRANSEFER IN PROGRESS" D DIE^ACDFMC
 .Q
 K ACDOPT
 Q
 ;
 ;
EN1 ;EP Unlock
 ;//^ACDGSAVE, ^ACDGMRG, ^ACDDFAC, ^ACDPURG
 W !!,"Unlocking CDMIS menu now."
 S ACDOPT="ACD" F  S ACDOPT=$O(^DIC(19,"B",ACDOPT)) Q:ACDOPT=""!($E(ACDOPT,1,3)'="ACD")  D
 .S DA=$O(^DIC(19,"B",ACDOPT,0))
 .I DA S DIE=19,DR="2////@" D DIE^ACDFMC
 .Q
 K ACDOPT
 Q
 ;
 ;TRY USING XQUIT SET TO 1 TO LOCK MENUES
 ;KERNAL TRAINING-IDEA
 ;XQUIT IS A NEW FIELD FOR EACH OPTION. bY SETTING IT IT DISABLES
 ;THE OPTION. i THINK THIS IS K7 ONLY AND NOT K6.5
