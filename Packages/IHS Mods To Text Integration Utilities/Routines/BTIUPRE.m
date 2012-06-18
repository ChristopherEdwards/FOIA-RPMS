BTIUPRE ; IHS/ITSC/LJF - PRE-INSTALL ROUTINE FOR TIU ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
PRGNOT ; make sure if have Progress Notes class, name is correct
 ; VA Health Summary routine ^GMTSPN expects an S on end of name
 NEW NAME
 S NAME=$$GET1^DIQ(8925.1,3,.01)
 I NAME="PROGRESS NOTE" D
 . NEW DIE,DA,DR
 . S DIE="^TIU(8925.1,",DA=3,DR=".01///PROGRESS NOTES"
 . D ^DIE
 ;
CLEAN ; clean out BTIU OBJECT DESCRIPTION file before restoring data
 NEW X
 S X=0 F  S X=$O(^BTIUOD(X)) Q:'X  K ^BTIUOD(X)
 K ^BTIUOD("B")
 Q
