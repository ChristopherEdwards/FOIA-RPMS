AQAOYP2 ; IHS/ORDC/LJF - PATCH #2 DRIVER ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 W !!?20,"QAI PATCH 2 DRIVER"
 W !! K DIR S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Are you READY to proceed with this update"
 D ^DIR G EXIT:Y'=1
 ;
START ; -- Start of process to install patch #2
 ; -- install 2 print templates & 1 input template
 W !!,"First I need to run an init to install 3 templates:"
 W !?5,"Print templates: AQAO ACTION LIST"
 W !?5,"                 AQAO FINDINGS LIST"
 W !?5,"Input template:  AQAO RATE REVIEW"
 W !,"And to install Help Frames detailing patches",!!
 D ^AQAXINIT
 ;
 ; -- delete temp entry in package file
 W !!,"I will now delete the temporary entry in the PACKAGE file"
 W !,"used to install these templates and help frames.  .  ."
 S DA=$O(^DIC(9.4,"C","AQAX",0)) I DA="" W !,"No entry to DELETE!!"
 I DA]"" S DIK="^DIC(9.4," D ^DIK W !,"Entry DELETED.",!
 K DA,DIK
 ;
 ; -- update entry/exit actions for 2 options
 D CUMP2
 ;
 ;
EXIT ; -- eoj
 Q
 ;
CUMP2 ;EP -- to be called by future patches
 ; -edit entry & exit actions for 2 options
 W !,"I will now update the Entry & Exit Actions for options:"
 W !?5,"AQAO PKGLIST ACTION & AQAO PKGLIST FINDINGS"
 F AQAXI="AQAO PKGLIST ACTION","AQAO PKGLIST FINDINGS" D
 . S DA=$O(^DIC(19,"B",AQAXI,0)) Q:DA=""
 . S DIE=19,DR="20///S AQAOINAC="""";15///K AQAOINAC D PRTOPT^AQAOVAR"
 . D ^DIE
 K AQAXI,DA,DIE,DR W !,"Options UPDATED.",!
 Q
