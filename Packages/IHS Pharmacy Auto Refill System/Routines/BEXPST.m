BEXPST ; cmi/anch/maw - BEX AUTO REFILL POST INIT ; [ 03/02/2010  11:04 AM ]
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**1,2,4**;DEC 01, 2009
 ;
 ;
 ;
 ;this routine will set up the auto refill post install questions
 ;
MAIN ;PEP - this is the main routine driver
 D SET
 X ^%ZOSF("EON")  ;turn echo on for questions
 D EDIT
 D EOJ
 X ^%ZOSF("EOFF")  ;turn echo off for questions
 Q
 ;
EDIT ;-- ask which reference lab and then stuff the file
 W !!,"I Will now walk you through setting your Pharmacy Auto Refill Parameters",!!
 S DIC(0)="AELMQZ",DIC="^BEXHRXP("
 S DIC("A")="Setup parameters files for which Site: "
 D ^DIC
 Q:Y<0
 S BEXSITE=+Y
 S DIE=DIC,DA=BEXSITE,DR=".02:2"
 D ^DIE
 K DIC,DIE,DR,DA
 S DIR(0)="Y",DIR("A")="Setup Another Site "
 D ^DIR
 K DIR
 Q:'Y
 G EDIT
 Q
 ;
SET ;EP - set the global
 S ^DIC(19080.1,0,"AUDIT")="Pp"
 S ^DIC(90350.1,0,"DD")="#"
 S ^DIC(90350.1,0,"DEL")="Pp"
 S ^DIC(90350.1,0,"LAYGO")="Pp"
 S ^DIC(90350.1,0,"RD")="Pp"
 S ^DIC(90350.1,0,"WR")="Pp"
 S ^DIC(90350.2,0,"AUDIT")="Pp"
 S ^DIC(90350.2,0,"DD")="#"
 S ^DIC(90350.2,0,"DEL")="Pp"
 S ^DIC(90350.2,0,"LAYGO")="Pp"
 S ^DIC(90350.2,0,"RD")="Pp"
 S ^DIC(90350.2,0,"WR")="Pp"
 ;S ^DD(90350.1,0,"VR")="1.0"
 ;S ^DD(90350.2,0,"VR")="1.0"
 N BEXPKG
 S BEXPKG=$O(^DIC(9.4,"B","BEX AUDIOCARE TELEPHONE REFILL",0))
 I '$G(BEXPKG) D
 . N BEXIENS,BEXFDA,BEXERR
 . S BEXIENS=""
 . S BEXFDA(9.4,"+1,",.01)="BEX AUDIOCARE TELEPHONE REFILL"
 . S BEXFDA(9.4,"+1,",1)="BEX"
 . S BEXFDA(9.49,"+2,+1,",.01)="1.0T1"
 . S BEXFDA(9.49,"+2,+1,",1)=$G(DT)
 . S BEXFDA(9.49,"+2,+1,",2)=$G(DT)
 . D UPDATE^DIE("","BEXFDA","BEXIENS","BEXERR(1)")
 . Q:'$G(BEXIENS(1))
 . N DIE,DA,DR
 . S DA=$O(^XPD(9.6,"B","BEX REFILL TRANSACTION 1.0",0))
 . Q:'$G(DA)
 . S DIE="^XPD(9.6,",DR="1////"_$G(BEXIENS(1))
 . D ^DIE
 Q
 ;
EOJ ;-- kill variables and quit
 D EN^XBVK("BEX")
 Q
 ;
