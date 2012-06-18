CIAVUTIL ;MSC/IND/DKM - VueCentric Manager Utilities ;27-Feb-2007 00:33;DKM
 ;;1.1V2;VUECENTRIC FRAMEWORK;;Mar 20, 2007
 ;;Copyright 2000-2006, Medsphere Systems Corporation
 ;=================================================================
 ; Initiate shutdown sequence for applications
SHUTDOWN N DELAY,MSG
 W !,"Initiate VueCentric Shutdown Sequence",!!
 D SHOWSESS()
 W:$$GETLOGIN'="" "Note: shutdown has already been initiated.",!!
 F  D  Q:$D(DELAY)
 .R !,"# of seconds till shutdown (30 minimum): ",DELAY:DTIME,!
 .E  S DELAY=U
 .S DELAY=$TR(DELAY," ")
 .Q:DELAY[U
 .I DELAY["?" D  Q
 ..K DELAY
 ..W "Enter number of seconds before shutdown.",!
 ..W "To specify time in minutes, follow number with letter M.",!
 .S:DELAY?1.N1(1"M",1"m") DELAY=DELAY*60
 .S DELAY=DELAY\1
 .K:DELAY<30 DELAY
 Q:DELAY[U
 Q:'$$ASK^CIAU("Do you really want to shut down VueCentric in "_DELAY_" seconds")
 D SDINIT(.MSG,DELAY,1)
 W !!,MSG,!!
 Q
 ; Abort a shutdown sequence in progress
ABORTSD N MSG
 W !,"Abort VueCentric Shutdown and Enable Logins",!!
 D SHOWSESS()
 W:$$GETLOGIN="" "Note: a shutdown does not appear to be in progress.",!!
 Q:'$$ASK^CIAU("Do you really want to abort any shutdowns in progress and enable logins")
 D SDABORT(.MSG,1)
 W !!,MSG,!!
 Q
 ; RPC: Initiate shutdown
SDINIT(DATA,DELAY,LOCK,USR) ;
 N MSG
 S MSG=$P(DELAY,U,2),DELAY=DELAY\1
 I DELAY<30 S DATA="Invalid value for shutdown delay." Q
 D:$G(LOCK) SETLOGIN("Application is currently offline.  Please try later.")
 S:'$L(MSG) MSG="Application is shutting down in "_DELAY_" seconds.  Please log off."
 D BRDCAST^CIANBEVT("SHUTDOWN",DELAY_U_MSG,.USR)
 S DATA="Shutdown sequence initiated.  "_$$SDMSG
 Q
 ; RPC: Abort shutdown
SDABORT(DATA,UNLOCK,USR) ;
 D BRDCAST^CIANBEVT("SHUTDOWN","-1^Application shutdown has been aborted.  You may continue.",.USR)
 D:$G(UNLOCK) SETLOGIN()
 S DATA="Shutdown sequence aborted.  "_$$SDMSG
 Q
 ; Login status message
SDMSG() Q "Logins are "_$S($L($$GETLOGIN):"disabled.",1:"enabled.")
 ; Get inhibit login message
GETLOGIN() ;
 Q $$OPTMSG^CIANBUTL("CIAV VUECENTRIC")
 ; Set inhibit login message
SETLOGIN(MSG) ;
 D OPTMSG^CIANBUTL("CIAV VUECENTRIC",$G(MSG))
 Q
 ; RPC: Get/set inhibit login message
MSGLOGIN(DATA,MSG) ;
 I '$D(MSG) S DATA=$$GETLOGIN
 E  D SETLOGIN(MSG)
 Q
 ; Cleanup user data upon user termination
USRTRM(USR) ;
 D TMPLDEL^CIAVMCFG("$"_USR)
 Q
 ; Show active VueCentric sessions
SHOWSESS() ;
 N X
 S X=$$SHOWSESS^CIANBUTL("CIAV VUECENTRIC")
 Q:$Q X
 Q
