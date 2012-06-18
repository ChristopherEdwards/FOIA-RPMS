AUM111EN ;IHS/ASDST/RNB - ICD 9 CODES FOR FY 2012 ; [ 09/09/2010  8:30 AM ]
 ;;12.0;TABLE MAINTENANCE;;SEP 27,2011
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_".",IOM)
 ;
 S XPDQUIT=0,AUMQUIT=0
 I $$VCHK("XU","8.0",2)
 I $$VCHK("DI","22.0",2)
 ;
 I $$VCHK("AUM","11.0",2)
 ;;S X=$$LAST("ICD UPDATE","11.0")
 ;;I $P(X,U)'=4 W !,$$CJ^XLFSTR("AUM 10.2 NOT INSTALLED",IOM) S XPDQUIT=2  ;need AUM 10.2 installed
 ;
 NEW DA,DIC
 S X="AUM",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUM")) D
 .W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUM"" prefix.",IOM)
 .W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 .D SORRY(2)
 .Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","AZHBENV")
 ;
 I $G(XPDENV)=1 D
 .; The following line prevents the "Disable Options..." and "Move
 .; Routines..." questions from being asked during the install.
 .S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 .D HELP^XBHELP("INTROI","AZHBENV")
 .Q
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
PRE ;
 S AUMK="^ICD9(""BA"")"
 K @AUMK
 S AUMK="^ICD9(""AB"")"
 K @AUMK
 D ^XBFMK
 S DIK="^ICD9("
 S DIK(1)=".01"
 D ENALL^DIK
 ;
 S AUMK="^ICD0(""BA"")"
 K @AUMK
 S AUMK="^ICD0(""AB"")"
 K @AUMK
 D ^XBFMK
 S DIK="^ICD0("
 S DIK(1)=".01"
 D ENALL^DIK
 ;
 ;D CLEANALL^AUMPREX  ;remove control characters
 D CLEANALL^AUM111PX
 ;
 D RSLT^AUM91RL1("Removing data from ICD EXPANDED field...")
 D START^AUM91P2  ;remove data from ICD EXPANDED field
 ;
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(AUMPRE,AUMVER,AUMQUIT) ; Check versions needed.
 ;  
 NEW AUMV
 S AUMV=$$VERSION^XPDUTL(AUMPRE)
 W !,$$CJ^XLFSTR("Need at least "_AUMPRE_" v "_AUMVER_"....."_AUMPRE_" v "_AUMV_" Present",IOM)
 I AUMV<AUMVER KILL DIFQ S XPDQUIT=AUMQUIT D SORRY(XPDQUIT) Q 0
 Q 1
 ;
LAST(PKG,VER) ;EP - returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
 ;
INTROE ; Intro text during KIDS Environment check.
 ;;This is the annual update to the ICD files.  There are modifications,
 ;;inactivations, and new entries to both files.
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
 ;
