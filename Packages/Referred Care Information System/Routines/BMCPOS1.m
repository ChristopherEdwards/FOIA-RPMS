BMCPOS1 ; IHS/PHXAO/TMJ - PATCH #1 POST-INIT ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
START ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Delete old Option
 S DA=$O(^DIC(19,"B","BMC OUTSIDE REFERRALS",0)) I DA S DIK="^DIC(19," D ^DIK
 ;
 Q
 ;
OPT ;add 2 options (existing option and new option)
 S X=$$ADD^XPDMENU("BMC MENU-RPTS ADMINISTRATIVE","BMC OUTSIDE REFERRALS","OUT")
 I 'X W "Attempt to add Referrals Initiated At Outside Facility option failed.." H 3
 NEW X S X=$$ADD^XPDMENU("BMC MENU-RPTS ADMINISTRATIVE","BMC RPT-SECONDARY WORKLOAD","SWK")
 I 'X W "Attempt to add Secondary Provider Letter Workload option failed." H 3
 ;
SEC ;Security Key Change
 ;Add Security Key BMCZEDIT to BMC MENU-DATA ENTRY Option
 S DA=$O(^DIC(19,"B","BMC MENU-DATA ENTRY",0)) I DA S DIE="^DIC(19,",DR="3////"_"BMCZEDIT"  D ^DIE K DIE,DR,DA
 ;
 ;Remove Security Key BMCZMGR from BMC MODIFY REFERRAL
 S DA=$O(^DIC(19,"B","BMC MODIFY REFERRAL",0)) I DA S DIE="^DIC(19,",DR="3///"_"@"  D ^DIE K DIE,DR,DA
 ;
 ;
END ;End of Post Init Routine
 ;
 W "The Referred Care Package - Patch #1 Post Init Routine has",!,"successfully completed",!
 ;
 Q
