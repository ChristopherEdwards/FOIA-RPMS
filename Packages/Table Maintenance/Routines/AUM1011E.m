AUM1011E ;IHS/OIT/NKD - SCB UPDATE FOR OCT 2012 09/11/2012 ;
 ;;12.0;TABLE MAINTENANCE;**4**;SEP 27,2011;Build 1
 ;AUM* 12.7.2009 IHS/OIT/FCJ MODIFIED INTRO TEXT AND VERSION CHECKS
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_".",IOM)
 ;
 I $$VCHK("XU","8.0",2)
 I $$VCHK("DI","22.0",2)
 I $$VCHK2("AUM","12.0.3",2)
 ;
 NEW DA,DIC
 S X="AUM",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUM")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUM"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . D SORRY(2)
 .Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","AZHBENV")
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","AZHBENV")
 .Q
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)
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
 I AUMV<AUMVER KILL DIFQ S XPDQUIT=AUMQUIT D SORRY(AUMQUIT) Q 0
 Q 1
VCHK2(AUMPRE,AUMVER,AUMQUIT) ; Check patch level for AUM
 NEW AUMV
 S AUMV=$$VERSION^XPDUTL(AUMPRE)
 S PTCH=+$$LAST(AUMPRE,AUMV) S:PTCH=-1 DPTCH="" S:PTCH'=-1 DPTCH="."_PTCH
 W !,$$CJ^XLFSTR("Need at least "_AUMPRE_" v "_AUMVER_"....."_AUMPRE_" v "_AUMV_DPTCH_" Present",IOM)
 I (AUMV<($P(AUMVER,".",1,2))) KILL DIFQ S XPDQUIT=AUMQUIT D SORRY(AUMQUIT) Q 0
 I (AUMV=$P(AUMVER,".",1,2))&(PTCH<$P(AUMVER,".",3)) KILL DIFQ S XPDQUIT=AUMQUIT D SORRY(AUMQUIT) Q 0
 Q 1
LAST(PKG,VER) ;EP - returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"C",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
 ;
PRE ; EP FR KIDS
 ;CLEAN UP CONTROL CHAR AND REMOVE DATA FROM AUMDATA
 D START^AUMPRE
 ; CHECK FOR DUPLICATE PHQT MEASUREMENT TYPE
 D MES^XPDUTL("Checking for duplicate PHQT Measurement Type...")
 N AUMRES,AUMCNT,AUMCNT2,AUML1,AUML2,AUMTMP
 D FIND^DIC(9999999.07,"","@;.01;.02","PX","PHQT",,,,,"AUMRES")
 S AUMCNT=$P($G(AUMRES("DILIST",0)),U,1)
 I AUMCNT<2 D MES^XPDUTL("  No duplicates found!") Q
 D MES^XPDUTL("  "_(AUMCNT-1)_" duplicate(s) found!")
 S (AUML1,AUML2)=""
 ; PUT LOWERCASE DESCRIPTIONS INTO LIST 1 (FROM), UPPERCASE INTO LIST 2 (TO)
 F AUMCNT2=1:1:AUMCNT S AUMTMP=$G(AUMRES("DILIST",AUMCNT2,0)) D
 . S:$P(AUMTMP,"^",3)'=$$UP^XLFSTR($P(AUMTMP,"^",3)) AUML1=AUML1_AUMCNT2_"^"
 . S:$P(AUMTMP,"^",3)=$$UP^XLFSTR($P(AUMTMP,"^",3)) AUML2=AUML2_AUMCNT2_"^"
 ; MOVE ADDITIONAL UPPERCASES INTO LIST 1 (FROM)
 S AUML1=AUML1_$P(AUML2,"^",2,100),AUML2=$P(AUML2,"^",1)
 ; IF ONLY LOWERCASES, MOVE LOWEST IEN INTO LIST 2 (TO)
 S:AUML2']"" AUML2=$P(AUML1,"^",1),AUML1=$P(AUML1,"^",2,100)
 ; MERGE ALL LIST 1 (FROM) ENTRIES INTO LIST 2 (TO) ENTRY
 F AUMCNT2=1:1:$L(AUML1,"^") S AUMTMP=$P(AUML1,"^",AUMCNT2) Q:'AUMTMP  D
 . D MMERG($P($G(AUMRES("DILIST",AUMTMP,0)),"^",1),$P($G(AUMRES("DILIST",AUML2,0)),"^",1))
 Q
MMERG(FROM,TO) ; MEASUREMENT TYPE COMPARE/MERGE
 N DILN,DITM,L
 ;D MES^XPDUTL("MERGING ENTRY '"_FROM_"' INTO '"_TO_"'")
 S DILN=21
 S DITM=0
 S DITM("DDEF")=2
 S DITM("DDIF")=1
 S DITM("DELETE")=""
 S DITM("DFF")=9999999.07
 S DITM("DIC")="^AUTTMSR("
 S DITM("DIMERGE")=1
 S DITM("DIT(1)")=FROM
 S DITM("DIT(2)")=TO
 S DITM("NON-INTERACTIVE")=""
 S DITM("REPOINT")=""
 S L=1
 D ^DITM2,END^DITM
 Q
 ;
INTROE ; Intro text during KIDS Environment check.
 ;;This is the update to the standard code book tables.  There are modifications
 ;;and additions to the following files:  Community, Location, Tribe,
 ;;Reservation and Service Unit.
 ;;
 ;;The install message will report updates and failed updates to those files. 
 ;;
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;If you run interactively, results will be displayed on your screen,
 ;;and recorded in the entry in the INSTALL file.
 ;;If you queue to TaskMan, remember not to Q to the HOME device.
 ;;###
 ;
