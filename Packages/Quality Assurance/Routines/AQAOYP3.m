AQAOYP3 ; IHS/ORDC/LJF - PATCH #3 DRIVER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 W !!?20,"QAI PATCH 3 DRIVER"
 W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Are you READY to proceed with this update"
 D ^DIR G EXIT:Y'=1
 ;
START ; -- Start of process to install patch #3
 ; -- install 3 print templates & 4 input templates
 W !!,"First I need to run an init to install some templates:"
 W !?5,"Print templates: AQAO ACTION LIST"
 W !?5,"                 AQAO FINDINGS LIST"
 W !?5,"                 AQAO WORKSHEET"
 W !?5,"Input template:  AQAO RATE REVIEW"
 W !?5,"                 AQAO PROV ACTION EDIT"
 W !?5,"                 AQAO PROV ACTION ADD"
 W !?5,"                 AQAO PROV LEVEL ADD"
 W !,"And the Help Frames detailing the QAI patches",!!
 D ^AQAXINIT
 ;
 ; -- delete temp entry in package file
 W !!,"I will now delete the temporary entry in the PACKAGE file"
 W !,"used to install these templates and help frames.  .  ."
 S DA=$O(^DIC(9.4,"C","AQAX",0)) I DA="" W !,"No entry to DELETE!!"
 I DA]"" S DIK="^DIC(9.4," D ^DIK W !,"Entry DELETED.",!
 K DA,DIK
 ;
 ; -- update entry/exit actions for 2 options from patch 2
 D CUMP2^AQAOYP2
 ;
 ; -- update
 D CUMP3
 ;
 ; -- inform users patch has been installed
 D MAIL
 ;
 ;
EXIT ; -- eoj
 W !!,"PATCH #3 INSTALLED!",!
 Q
 ;
CUMP3 ;EP -- to be called by future patches
 D 1,2
 Q
1 ; -- SUBRTN edit qi data entry option
 W !!,"Updating QI Data Entry so provider add function works"
 W !,"during review process.",!
 NEW X,DIC,Y,DIE,DA,DR
 S X="AQAO ACTION LEVEL",DIC="^AQAQX(",DIC(0)="" D ^DIC Q:Y=-1
 S DIE="^AQAQX(",DA=+Y,DR=".01///AQAO PROVIDER;.02///PROVIDER ADD"
 D ^DIE
 S DA(1)=DA,DA=1,DIE="^AQAQX("_DA(1)_",""PG"","
 S DR=".03///UPDATE PROVIDER LIST;.12///[AQAO PROVIDER" D ^DIE
 Q
 ;
2 ; -- SUBRTN to edit help text on inactive fields
 W !!,"Fixing help text on Inactive fields.",!
 NEW AQAOI,AQAO,X,Y,Z
 S AQAO("ACTIVATE")="REACTIVATE",AQAO("activate")="REACTIVATE"
 F AQAOI=1:1:3 D
 . S Y=$P($T(FILE+AQAOI),";;",2),Z=$P($T(FILE+AQAOI),";;",3)
 . S X=^DD(Y,Z,3),^DD(Y,Z,3)=$$REPLACE^XLFSTR(X,.AQAO)
 Q
 ;
MAIL ; -- SUBRTN to send mail message
 NEW AQAOI,AQAO,XMTEXT,XMSUB,XMY
 S XMSUB="QAI PATCH #3 INSTALLED",XMTEXT="AQAO("
 F AQAOI=1:1:8 S AQAO(AQAOI)=$P($T(MSG+AQAOI),";;",2)
 S X=0
 F  S X=$O(^XUSEC("AQAOZMENU",X)) Q:X=""  S XMY(X)="",XMY(X,1)="I"
 D ^XMD W !!,"Mail message sent to all QAI users.",!
 Q
 ;
FILE ;;
 ;;9002168.6;;.05;;QI ACTION file INACTIVE field
 ;;9002168.8;;.04;;QI FINDINGS file INACTIVE field
 ;;9002169.3;;.03;;QI LEVEL file INACTIVE field
 ;
MSG ;;
 ;;*****************************************************************
 ;;                   Congratulations!
 ;;The QAI PATCH #3 has just been installed on your computer system!
 ;;*****************************************************************
 ;;
 ;;For your convenience all the changes are documented on-line for 
 ;;you. Use the option "HELP on Using QAI Package" and select choice
 ;;#2 for PATCHES. It will tell you what has been fixed.  Have fun!
