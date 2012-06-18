AUTP8 ; IHS/ASDST/GTH - AUT 98.1 PATCH 8 ; [ 06/04/2001  5:53 PM ]
 ;;98.1;IHS DICTIONARIES (POINTERS);**8**;MAR 04, 1998
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(1) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(1) Q
 ;
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"DUZ(0) DOES NOT CONTAIN AN '@'." D SORRY(1) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$C^XBFUNC("Hello, "_$P(X,",",2)_" "_$P(X,","))
 W !!,$$C^XBFUNC("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".")
 ;
 S X=$$VERSION^XPDUTL("AUT")
 W !!,$$C^XBFUNC("Need AUT v 98.1.....AUT v "_X_" Present")
 I X<98.1 D SORRY(1) Q
 ;
 S X=$$VERSION^XPDUTL("DI")
 W !,$$C^XBFUNC("Need at least FileMan 21.....FileMan "_X_" Present")
 I X<21 D SORRY(1) Q
 ;
 S X=$$VERSION^XPDUTL("XU")
 W !,$$C^XBFUNC("Need at least Kernel 8.....Kernel "_X_" Present")
 I X<8 D SORRY(1) Q
 ;
 NEW DA,DIC
 S X="AUT",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUT")) D  Q
 . W !!,*7,*7,$$C^XBFUNC("You Have More Than One Entry In The"),!,$$C^XBFUNC("PACKAGE File with an ""AUT"" prefix.")
 . W !,$$C^XBFUNC("One entry needs to be deleted.")
 . W !,$$C^XBFUNC("FIX IT! Before Proceeding."),!!,*7,*7,*7
 . D SORRY(1)
 . I $$DIR^XBDIR("E")
 .Q
 W !,$$C^XBFUNC("No 'AUT' dups in PACKAGE file")
 ;
 ; If patches 1-7 have already been installed, don't load them.
 I $G(XPDENV)=0 D  ; Run only during Load of Installation.
 . NEW DA
 . S DA(1)=+Y ; Y is set from previous DIC lookup into PACKAGE.
 . S DA=$O(^DIC(9.4,DA(1),22,"B",98.1,0))
 . F %=1:1:7 I $D(^DIC(9.4,DA(1),22,DA,"PAH","B",%)) S XPDQUIT("AUT*98.1*"_%)=1
 .Q
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 ;
 NEW B
 I $G(XPDA) S B=$O(^XTMP("XPDI",XPDA,"BLD",0))
 I $G(B),$$DIR^XBDIR("Y","Do you want to see the notes","NO","Do you want to see the notes file for this patch","","",1) D
 . S %=0
 . F  S %=$O(^XTMP("XPDI",XPDA,"BLD",B,1,%)) Q:'%   W !,^(%,0) I '(%#20),'$$DIR^XBDIR("E","","","","","",1) Q
 .Q
 KILL B
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(1) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 F %=1:1:5 S XPDQUIT("AUT*98.1*"_%)=1
 W:'$D(ZTQUEUED) *7,!,$$C^XBFUNC("Sorry...."),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
PRE ;EP - From KIDS.
 Q
 D BMES^XPDUTL("Beginning pre-install routine (PRE^AUTP8).")
 D BMES^XPDUTL("Pre-install routine is complete.")
 Q
 ;
POST ;EP - From KIDS.
 D BMES^XPDUTL("Beginning post-install routine (POST^AUTP8).")
 D BMES^XPDUTL("Delivering MailMan message to select users...")
 D SAVE
 NEW DIFROM
 D MAIL^XBMAIL("ACHSZMGP,ACRZ MANAGERS MENU,XUMGR-XUPROGMODE","MSG^AUTP8MSG")
 S X="AUTP8MSG"
 X ^%ZOSF("DEL")
 D BMES^XPDUTL("Post-install routine is complete.")
 Q
 ;
SAVE ; Save first few lines of install message into tmp global.
 KILL ^TMP("AUTP8MSG",$J)
 S ^TMP("AUTP8MSG",$J,1,0)="AUTP8MSG ; IHS/ASDST/GTH - AUT INSTALL MESSAGE ;"
 S ^TMP("AUTP8MSG",$J,2,0)=$T(+2)
 S ^TMP("AUTP8MSG",$J,3,0)="MSG ;;"
 S ^TMP("AUTP8MSG",$J,4,0)=" ;;AUT V "_$P($T(+2),";",3)_" "_$P($T(+2),";",4)_", Patch "_$P($P($T(+2),";",5),"**",2)
 S ^TMP("AUTP8MSG",$J,5,0)=" ;; --- AUT v 98.1, Patch 8, has been installed into this uci ---"
 NEW B,XCM,DIE,XCN
 S B=$O(^XTMP("XPDI","AUT*98.1*8","BLD",0))
 I B S %=0 F  S %=$O(^XTMP("XPDI","AUT*98.1*8","BLD",B,1,%)) Q:'%   S ^TMP("AUTP8MSG",$J,(%+5),0)=" ;;"_^(%,0)
 KILL B
 S X="AUTP8MSG",DIE="^TMP(""AUTP8MSG"",$J,",XCN=0
 X ^%ZOSF("SAVE")
 KILL ^TMP("AUTP8MSG",$J)
 Q
 ;
