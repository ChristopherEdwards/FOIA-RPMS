AVA32P17 ;IHS/ITSC/AEF - AVA 93.2 PATCH 17 ; [ 07/01/2003  10:38 AM ]
 ;;93.2;VA SUPPORT FILES;**17**;JUL 01, 1993
 ;
 ;IHS/ITSC/AEF AVA*93.2*17 06/26/2003
 ;
ENV ;----- ENVIRONMENT CHECK
 ;
 N IORVOFF,IORVON
 ;
 D ^XBKVAR
 D HOME^%ZIS
 ;
 D DUZ
 I $G(XPDQUIT) D SORRY Q
 ;
 D RV
 D XPZ
 D HELLO
 D VER
 D DUPE
 D OK
 ;
 I $D(XPDQUIT) W !,"INSTALL ABORTED!"
 ;
 Q
 ;
DUZ ;----- CHECK FOR VALID DUZ VARIABLES
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D FAIL(2)
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D FAIL(2)
 I '($G(DUZ(0))["@") W !,"THE DD UPDATES REQUIRE AN '@' IN YOUR DUZ(0)" D FAIL(2)
 Q
 ;
RV ;----- SET REVERSE VIDEO ON/OFF VARIABLES
 ;
 D HOME^%ZIS
 N X
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 Q
 ;
XPZ ;----- PREVENT 'DISABLE OPTIONS' AND 'MOVE ROUTINES' PROMPTS
 ;
 I $G(XPDENV)=1 D
 . S XPDDIQ("XPZ1")=0 ;SUPPRESS 'DISABLE OPTIONS' PROMPT
 . S XPDDIQ("XPZ2")=0 ;SUPPRESS 'MOVE ROUTINES' PROMT
 Q
 ;
HELLO ;----- HELLO MESSAGE AND ENVIRONMENT CHECK
 ;
 N X
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 Q
 ;
VER ;----- CHECK FOR VERSIONS
 ;
 I $$VCHK("AVA","93.2",2)
 I $$VCHK("DI","21.0",2)
 I $$VCHK("XU","8.0",2)
 Q
 ;
CHKPAT(X)          ;
 ;----- CHECK IF PATCH HAS BEEN INSTALLED
 ;
 ;      RETURNS 1 IF PATCH HAS BEEN INSTALLED, 0 IF NOT
 ;
 N XPDA,OK
 S OK=0
 S XPDA=0
 F  S XPDA=$O(^XPD(9.7,"B",X,XPDA)) Q:'XPDA  D
 . I $P($G(^XPD(9.7,XPDA,0)),U,9)=3 S OK=1
 Q OK
 ;
DUPE ;----- CHECK FOR DUPLICATE AVA ENTRIES IN PACKAGE FILE
 ;
 N D,DA,DIC,X,Y
 S X="AVA",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AVA")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You have more than one entry in the      ",IOM)
 . W !,$$CJ^XLFSTR("PACKAGE file with an 'AVA' prefix.     ",IOM)
 . W !,$$CJ^XLFSTR(IORVON_"One entry needs to be deleted"_IORVOFF,IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before proceeding.      ",IOM),!!,*7,*7
 . D FAIL(2)
 Q
 ;
OK ;----- OK TO INSTALL?
 ;
 I $D(XPDQUIT) D
 . W !!,$$CJ^XLFSTR(IORVON_"Please FIX it!!"_IORVOFF,IOM) D SORRY
 ;
 I '$D(XPDQUIT) D
 . W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 . I '$$DIR^XBDIR("E","","","","","",1) D FAIL(2)
 Q
 ;
FAIL(X) ;----- SET XPDQUIT
 ;
 K DIFQ
 S XPDQUIT=X
 Q
 ;
SORRY ;----- ISSUE 'SORRY... PRESS RETURN' MESSAGES
 ;
 N Y
 I '$D(ZTQUEUED) D
 . W *7,!,$$CJ^XLFSTR("Sorry....  ",IOM)
 . S Y=$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(AVAPRE,AVAVER,AVAQUIT) ;
 ;----- CHECK VERSIONS NEEDED
 ;  
 N AVAV,AVAMSG,Y
 ;
 S Y=1
 S AVAV=$$VERSION^XPDUTL(AVAPRE)
 S AVAMSG=$S(AVAV<AVAVER:" <<<--- FIX IT!",1:"")
 ;
 W !,$$CJ^XLFSTR("Need at least "_AVAPRE_" v "_AVAVER_"....."_AVAPRE_" v "_AVAV_" Present"_AVAMSG,IOM)
 ;
 I AVAV<AVAVER D FAIL(AVAQUIT) S Y=0
 ;
 Q Y
 ;
PRE ;EP -- PREINSTALL FROM KIDS.
 ;
 D ^XBKVAR
 ;
 D BMES^XPDUTL("Beginning pre-install routine (PRE^AVA32P17)...")
 ;
 D MES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP -- POST INSTALL FROM KIDS.
 ;
 D ^XBKVAR
 ;
 D BMES^XPDUTL("Beginning post-install routine (POST^AVA32P17)...")
 ;
 D P12
 D P15
 D P17
 ;
 D BMES^XPDUTL("Delivering AVA*93.2*17 install message to select users...")
 D MAIL
 ;
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
MAIL ;----- SEND INSTALL MAIL MESSAGE 
 ;
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 ;
 K ^TMP("AVAP17MS",$J)
 ;
 S ^TMP("AVAP17MS",$J,1)=" --- AVA v 93.2, Patch 17, has been installed into this uci ---"
 ;
 I $G(XPDA) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D
 . . S ^TMP("AVAP17MS",$J,(%+1))=" "_^(%,0)
 ;
 S XMSUB=$P($P($T(+1),";",2)," ",3,99)
 S XMDUZ=$S($G(DUZ):DUZ,1:.5)
 S XMTEXT="^TMP(""AVAP17MS"",$J,"
 S XMY(1)=""
 S XMY(DUZ)=""
 ;
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 ;
 D ^XMD
 ;
 K ^TMP("AVAP17MS",$J)
 ;
 Q
 ;
SINGLE(K) ;----- GET HOLDERS OF A SINGLE KEY K.
 ;
 N Y
 ;
 Q:'$D(^XUSEC(K))
 ;
 S Y=0
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 ;
 Q
 ;
P12 ;----- CHANGE SUB-FILE DD NUMBER IN THE 9999999.18 MULTIPLE OF FILE 200
 ;      FROM PATCH 12
 ;
 N I,P
 D BMES^XPDUTL("Changing sub-file dictionary number in the 9999999.18 multiple in file 200...")
 ;
 S P=$P(^DD(200,9999999.18,0),U,2)
 S I=0
 F  S I=$O(^VA(200,I)) Q:'(I=+I)  D
 . I $D(^VA(200,I,9999999.18,0)) S $P(^(0),U,2)=P
 Q
P15 ;----- UPDATE IHS XREFS IN FILES 200, 4
 ;      FROM PATCH 15
 ;
 Q:$$CHKPAT("AVA*93.2*15")
 D BMES^XPDUTL("Updating IHS CROSS-REFERENCES in files 4 and 200...")
 D ^AVAP15
 Q
P17 ;----- ADD/UPDATE RACE FILE ENTRIES 
 ;      FROM PATCH 17
 ;
 D ^XBKVAR
 N RACE
 ;
 K ^DD(10,.01,1,2) ;KILL 2ND "B" XREF - SHOULD ONLY BE 1
 ;
 D BMES^XPDUTL("UPDATING RACE FILE ENTRIES...")
 ;
 D BLDLST(.RACE)
 ;
 S IEN=0
 F  S IEN=$O(RACE("FDA",IEN)) Q:'IEN  D
 . N FDAROOT,IENROOT,IENS,MSG,MSGROOT
 . S RACE=RACE("FDA",IEN,.01)
 . S IENS=$O(^DIC(10,"B",$E(RACE,1,45),0))
 . S:'IENS IENS="+1"
 . S IENS=IENS_","
 . M FDAROOT(10,IENS)=RACE("FDA",IEN)
 . D UPDATE^DIE("","FDAROOT","IENROOT","MSGROOT")
 . S MSG(1)=RACE("FDA",IEN,.01)_" ** ADDED/UPDATED **"
 . I $D(MSGROOT) D
 . . S MSG(1)=" "
 . . S MSG(2)="** ERROR **"
 . . S MSG(3)="** Unable to add/update entry for "_RACE("FDA",IEN,.01)
 . . S MSG(4)="** Entry should be added/updated via FileMan:"
 . . S MSG(5)="**    Name  (.01): "_RACE("FDA",IEN,.01)
 . . S MSG(6)="**    Abbrev  (2): "_RACE("FDA",IEN,2)
 . . S MSG(7)=" "
 . D BMES^XPDUTL(.MSG)
 Q
BLDLST(ARRAY)      ;
 ;----- BUILT LIST OF VALID RACES
 ;
 N I,TXT
 F I=1:1 S TXT=$P($T(RACES+I),";;",2) Q:TXT["$$END"  D
 . S ARRAY("FDA",I,.01)=$P(TXT,U)
 . S ARRAY("FDA",I,2)=$P(TXT,U,2)
 Q
RACES ;RACE (#.01)^ABBREVIATION (#2)
 ;;AMERICAN INDIAN OR ALASKA NATIVE^3
 ;;ASIAN^A
 ;;BLACK OR AFRICAN AMERICAN^B
 ;;DECLINED TO ANSWER^D
 ;;NATIVE HAWAIIAN OR OTHER PACIFIC ISLANDER^H
 ;;UNKNOWN BY PATIENT^U
 ;;WHITE^W
 ;;$$END
 ;
PREV ;EP -- INSTALL PREVIOUS PATCHES 1-10
 ;
 ;PATCH 1 IS ROUTINE ONLY; OBSOLETE
 D ^AVAP2 ;PATCH 2
 ;D ^AVAP3 ;PATCH 3; OBSOLETE
 D CLASS^AVAP4 ;PATCH 4;PATCH 5;PATCH 6
 D ^AVAPINIT ;PATCH 7
 ;PATCH 8 IS ROUTINE ONLY
 D INSTALL^AVASLXR ;PATCH 9
 D ^AVAP10 ;PATCH 10
 Q
