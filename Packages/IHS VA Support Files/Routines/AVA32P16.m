AVA32P16 ;IHS/ITSC/AEF - AVA 93.2 PATCH 16 ; [ 05/12/2003  5:07 PM ]
 ;;93.2;VA SUPPORT FILES;**16**;JUL 01, 1993
 ;
 ;IHS/ITSC/AEF AVA*93.2*16 05/07/2003
 ;
ENV ;----- ENVIRONMENT CHECK
 ;
 N IORVOFF,IORVON
 ;
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
 D BMES^XPDUTL("Beginning pre-install routine (PRE^AVA32P16).")
 ;
 D MES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP -- POST INSTALL FROM KIDS.
 NEW AVA
 D BMES^XPDUTL("Beginning post-install routine (POST^AVA32P16).")
 ;
 D BMES^XPDUTL("Changing sub-file dictionary number in the 9999999.18 multiple...")
 D SFDD
 ;
 D BMES^XPDUTL("Delivering AVA*93.2*16 install message to select users...")
 D MAIL
 ;
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
SFDD ;----- CHANGE SUB-FILE DD NUMBER IN THE 9999999.18 MULTIPLE OF FILE 200
 ;
 N I,P
 ;
 S P=$P(^DD(200,9999999.18,0),U,2)
 S I=0
 F  S I=$O(^VA(200,I)) Q:'(I=+I)  D
 . I $D(^VA(200,I,9999999.18,0)) S $P(^(0),U,2)=P
 Q
 ;
MAIL ;----- SEND INSTALL MAIL MESSAGE 
 ;
 N DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 ;
 K ^TMP("AVAP16MS",$J)
 ;
 S ^TMP("AVAP16MS",$J,1)=" --- AVA v 93.2, Patch 16, has been installed into this uci ---"
 ;
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   D
 . S ^TMP("AVAP16MS",$J,(%+1))=" "_^(%,0)
 ;
 S XMSUB=$P($P($T(+1),";",2)," ",4,99)
 S XMDUZ=$S($G(DUZ):DUZ,1:.5)
 S XMTEXT="^TMP(""AVAP16MS"",$J,"
 S XMY(1)=""
 S XMY(DUZ)=""
 ;
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 ;
 D ^XMD
 ;
 K ^TMP("AVAP16MS",$J)
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
