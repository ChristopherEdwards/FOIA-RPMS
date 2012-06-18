XB3P9 ;IHS/SET/GTH - XB 3 PATCH 9 ; [ 04/21/2003  9:21 AM ]
 ;;3.0;IHS/VA UTILITIES;**9**;FEB 07, 1997
 ;
 ; IHS/SET/GTH XB*3*9 10/29/2002
 ;
 I '$G(IOM) D HOME^%ZIS
 ;
 NEW IORVON,IORVOFF
 S X="IORVON;IORVOFF"
 D ENDR^%ZISS
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 D BMES^XPDUTL($$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM))
 D BMES^XPDUTL($$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM))
 ;
 NEW XBQUIT
 S XBQUIT=0
 I '$$VCHK("XB","3.0",2,"'=") S XBQUIT=2
 ;
 NEW DA,DIC
 S X="XB",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","XB")) D  S XBQUIT=2
 . D BMES^XPDUTL($$CJ^XLFSTR("You Have More Than One Entry In The",IOM)),MES^XPDUTL($$CJ^XLFSTR("PACKAGE File with an ""XB"" prefix.",IOM))
 . D MES^XPDUTL($$CJ^XLFSTR(IORVON_"One entry needs to be deleted."_IORVOFF,IOM))
 . D MES^XPDUTL($$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM))
 .Q
 ;
 I $G(XPDENV)=1 D
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . Q:DUZ(0)["@"
 . D BMES^XPDUTL("I need ""@"" in your DUZ(0) for the install to work.")
 . D MES^XPDUTL("In programmer mode, D P^DI,^XUP, and select ""XPD MAIN"" when you're prompted")
 . D MES^XPDUTL("for OPTION NAME.")
 . S XBQUIT=2
 .Q
 ;
 I XBQUIT D SORRY(XBQUIT) Q
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("ENVIRONMENT OK.",IOM))
 ;
 I '$$DIR^XBDIR("E","","","","","",2) D SORRY(2)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR(IORVON_"Sorry...."_IORVOFF,IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(XBPRE,XBVER,XBQUIT,XBCOMP) ; Check versions needed.
 ;  
 NEW XBV
 S XBV=$$VERSION^XPDUTL(XBPRE)
 W !,$$CJ^XLFSTR("Need "_$S(XBCOMP="<":"at least ",1:"")_XBPRE_" v "_XBVER_"....."_XBPRE_" v "_XBV_" Present",IOM)
 I @(""""_XBV_""""_XBCOMP_""""_XBVER_"""") Q 0
 Q 1
 ;
 ;
PRE ;EP - From KIDS.
 Q
 D BMES^XPDUTL("Begin 'PRE^XB3P9' at "_$$FMTE^XLFDT($$NOW^XLFDT)_".")
 D BMES^XPDUTL("End 'PRE^XB3P9' at "_$$FMTE^XLFDT($$NOW^XLFDT)_".")
 Q
 ;
POST ;EP - From KIDS.
 D BMES^XPDUTL("Begin 'POST^XB3P9' at "_$$FMTE^XLFDT($$NOW^XLFDT)_".")
 ;
 D BMES^XPDUTL("Attaching ""XB PACKAGE TRACKING"" option to the Site Manager menu.")
 D ATTACH
 ;
 D BMES^XPDUTL("Setting up Q'ing of option 'XBTRK' for every 30 days.")
 D QUE
 ;
 I $$VERSION^%ZOSV(1)["Cache" D LOAD
 ;
 D BMES^XPDUTL("Delivering XB*3*9 install message to select users...")
 D MAIL
 ;
 D BMES^XPDUTL("Creating Task to delete old/unused XB/ZIB routines.")
 D DELR
 ;
 D BMES^XPDUTL("End 'POST^XB3P9' at "_$$FMTE^XLFDT($$NOW^XLFDT)_".")
 Q
 ;
ATTACH ; Attach option for protection and interactive access.
 I $$ADD^XPDMENU("XUSITEMGR","XB PACKAGE TRACKING","PTRK",10) D BMES^XPDUTL("....successfully atch'd....allocating Security Keys...") D  I 1
 . NEW XB,DA,DIC,DINUM
 . S XB=0,XB("PG")=$O(^DIC(19.1,"B","XUPROGMODE",0)),XB("TRK")=$O(^DIC(19.1,"B","XBZ PACKAGE TRACKING",0))
 . Q:'XB("PG")!'XB("TRK")
 . S DIC(0)="NMQ",DIC("P")=$P(^DD(200,51,0),U,2)
 . F  S XB=$O(^XUSEC("XUPROGMODE",XB)) Q:'XB  D
 .. Q:$D(^VA(200,XB,51,XB("TRK")))
 .. S DIC="^VA(200,XB,51,",DA(1)=XB,(DINUM,X)=XB("TRK")
 .. D FILE^DICN
 ..Q
 .Q
 E  D BMES^XPDUTL("....Attachment *FAILED*.")
 Q
 ;
QUE ; Add the option to the OPTION SCHEDULING file.
 NEW DA,DIC
 S DIC=19.2,DIC(0)="L",X="XB PACKAGE TRACKING",DIC("DR")="2////"_$$SCH^XLFDT("1D",DT)_".05;6///30D"
 D ^DIC
 I +Y<0 D BMES^XPDUTL("Entry of ""XB PACKAGE TRACKING"" into OPTION SCHEDULING file failed.") Q
 S DA(1)=+Y,DIC="^DIC(19.2,"_DA(1)_",2,",DIC(0)="",DIC("P")=$P(^DD(19.2,10,0),U,2),XBSYSID(1)="cmbsyb.hqw.DOMAIN.NAME",XBSYSID(2)=$P(^AUTTSITE(1,0),U,14)
 KILL DO,DD
 F X="XBSYSID(1)","XBSYSID(2)" S DIC("DR")="1///"""_(@X)_"""" D FILE^DICN
 D BMES^XPDUTL("""XB PACKAGE TRACKING"" has been entered into OPTION SCHEDULING file.")
 Q
 ;
MAIL ; Send install mail message.
 NEW DIFROM,XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("XB3P9MS",$J)
 S ^TMP("XB3P9MS",$J,1)=" --- XB v 3, Patch 9, has been installed ---"
 S %=0
 F  S %=$O(^XTMP("XPDI",XPDA,"BLD",XPDBLD,1,%)) Q:'%   S ^TMP("XB3P9MS",$J,(%+1))=" "_^(%,0)
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$S($G(DUZ):DUZ,1:.5),XMTEXT="^TMP(""XB3P9MS"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUMGR","XUPROG","XUPROGMODE" D SINGLE(%)
 D ^XMD
 KILL ^TMP("XB3P9MS",$J)
 Q
 ;
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
DELR ; Create task to delete unnecessary routines.
 S ZTRTN="DEL^XBDELR(""XBP8"")",ZTDESC="Delete routines in the 'XBP8' namespace.",ZTDTH=$$HADD^XLFDT($H,0,0,30,0),ZTIO="",ZTPRI=1
 D ^%ZTLOAD
 Q
 ;
LOAD ; If Cache', save %-routines into Namespace
 D BMES^XPDUTL("Saving 5 routines as % routines in current Namespace.")
 NEW DIE,DIF,X,XB,XBF,XBL,XBT,XCM,XCN,XCNP
 KILL ^TMP("XB3P9",$J)
 F XB=1:1 S XBL=$P($T(RTN+XB),";",3) Q:'$L(XBL)  D
 . S XBF=$P(XBL,U,1),XBT=$P(XBL,U,2)
 . D MES^XPDUTL("   Saving '"_$$LJ^XLFSTR(XBF,8)_"' as '"_$$LJ^XLFSTR(XBT,8)_"'.")
 . S DIF="^TMP(""XB3P9"",$J,",XCNP=0,X=XBF
 . X ^%ZOSF("LOAD")
 . S DIE="^TMP(""XB3P9"",$J,",X=XBT,XCN=0
 . X ^%ZOSF("SAVE")
 . KILL ^TMP("XB3P9",$J)
 .Q
 Q
 ;
RTN ; Routine ^ Rename As
 ;;XBCLS^%XBCLS
 ;;ZIBGD^%ZIBGD
 ;;ZIBRD^%ZIBRD
 ;;ZIBCLU0^%ZIBCLU0
 ;;ZIBZUCI^%ZUCI
 ;
