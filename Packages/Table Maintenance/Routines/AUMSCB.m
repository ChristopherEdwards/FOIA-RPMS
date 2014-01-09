AUMSCB ;IHS/OIT/NKD - SCB UPDATE ENVIRONMENT CHECK/PRE/POST INSTALL 3/08/2013 ;
 ;;13.0;TABLE MAINTENANCE;**3**;AUG 30,2012;Build 1
 ; 03/08/13 - ICD and Language file cleanup
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_$S($L($P($T(+2),";",5))>4:" Patch "_$P($T(+2),";",5),1:"")_".",IOM),!
 ;
 I $$VCHK("XU","8.0",2)
 I $$VCHK("DI","22.0",2)
 I $$VCHK2("AUT","98.1.26",2) ; IHS/OIT/NKD - AUM*13.0*3 REQS
 I $$VCHK2("AUM","13.0.2",2) ; IHS/OIT/NKD - AUM*13.0*3 REQS
 ; IHS/OIT/NKD - AUM*13.0*2 REQUIRE AUM V13 FOR ICD CLEANUP
 ;I $$VCHK("AUM","13.0",2)
 ;I $$VCHK2("AUM","13.0.1",2)
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
VCHK(AUMPRE,AUMVER,AUMQUIT) ; Check version level
 ;  
 NEW AUMV
 S AUMV=$$VERSION^XPDUTL(AUMPRE)
 W !,$$CJ^XLFSTR("Need at least "_AUMPRE_" v "_AUMVER_"....."_AUMPRE_" v "_AUMV_" Present",IOM)
 I AUMV<AUMVER KILL DIFQ S XPDQUIT=AUMQUIT D SORRY(AUMQUIT) Q 0
 Q 1
VCHK2(AUMPRE,AUMVER,AUMQUIT) ; Check patch level
 NEW AUMV
 S AUMV=$$VERSION^XPDUTL(AUMPRE)
 S PTCH=+$$LAST(AUMPRE,AUMV) S:PTCH=-1 DPTCH="" S:PTCH'=-1 DPTCH="."_PTCH
 W !,$$CJ^XLFSTR("Need at least "_AUMPRE_" v "_AUMVER_"....."_AUMPRE_" v "_AUMV_DPTCH_" Present",IOM)
 I (AUMV<($P(AUMVER,".",1,2))) KILL DIFQ S XPDQUIT=AUMQUIT D SORRY(AUMQUIT) Q 0
 I (AUMV=$P(AUMVER,".",1,2))&(PTCH<$P(AUMVER,".",3)) KILL DIFQ S XPDQUIT=AUMQUIT D SORRY(AUMQUIT) Q 0
 Q 1
PCHK(AUMPAT,AUMQUIT) ; Check specific patch
 N AUMP
 S AUMP=$$PATCH^XPDUTL(AUMPAT)
 W !,$$CJ^XLFSTR("Patch "_AUMPAT_" is "_$S(AUMP<1:"*NOT* ",1:"")_"installed.",IOM)
 I 'AUMP KILL DIFQ S XPDQUIT=AUMQUIT D SORRY(AUMQUIT) Q 0
 Q 1
LAST(PKG,VER) ; EP - returns last patch applied for a Package, PATCH^DATE
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
 ; IHS/OIT/NKD - AUM*13.0*2 ICD CLEANUP
 ;D ICD132
 ; IHS/OIT/NKD - AUM*13.0*2 LANGUAGE CLEANUP
 ;D LANG132
 Q
 ;
POST ; EP FR KIDS
 D POST^AUMSCBD
 Q
 ;
ICD132 ; IHS/OIT/NKD - AUM*13.0*2 - CLEANUP ICD ENTRIES FROM AUM V13
 N AUMI,AUMI2,AUMI3,AUMC,AUMM
 D BMES^XPDUTL("Correcting MDC fields in the ICD files...")
 K ^TMP("AUM",$J,"ICD9"),^TMP("AUM",$J,"ICD0")
 ; FILE 80 - ICD DIAGNOSIS
 S AUMC="0^0"
 S AUMI=0 F  S AUMI=$O(^ICD9(AUMI)) Q:'AUMI  D
 . D  ; NON-VERSIONED FIELD
 . . Q:'$D(^ICD9(AUMI,0))  ; SKIP IF 0 NODE DOESN'T EXIST
 . . S AUMM=$P(^ICD9(AUMI,0),U,5)  ; GET MDC FIELD
 . . Q:AUMM=""  ; SKIP IF BLANK
 . . Q:AUMM=+AUMM  ; SKIP IF ALREADY A POINTER
 . . S $P(AUMC,U,1)=$P(AUMC,U,1)+1,^TMP("AUM",$J,"ICD9",AUMI)=AUMM  ; ELSE COUNT & RECORD INVALID ENTRY
 . . S $P(^ICD9(AUMI,0),U,5)=+AUMM  ; THEN CORRECT ENTRY
 . S AUMI2=0 F  S AUMI2=$O(^ICD9(AUMI,4,AUMI2)) Q:'AUMI2  D   ; REPEAT FOR VERSIONED FIELD
 . . Q:'$D(^ICD9(AUMI,4,AUMI2,0))
 . . S AUMM=$P(^ICD9(AUMI,4,AUMI2,0),U,2)
 . . Q:AUMM=""
 . . Q:AUMM=+AUMM
 . . S $P(AUMC,U,2)=$P(AUMC,U,2)+1,^TMP("AUM",$J,"ICD9",AUMI,AUMI2)=AUMM
 . . S $P(^ICD9(AUMI,4,AUMI2,0),U,2)=+AUMM
 S ^TMP("AUM",$J,"ICD9")=$P(AUMC,U,1)_U_$P(AUMC,U,2)
 ; FILE 80.1 - ICD OPERATION/PROCEDURE
 S AUMC="0^0"
 S AUMI=0 F  S AUMI=$O(^ICD0(AUMI)) Q:'AUMI  D
 . S AUMI2=0 F  S AUMI2=$O(^ICD0(AUMI,"MDC",AUMI2)) Q:'AUMI2  D  ; NON-VERSIONED FIELD
 . . Q:'$D(^ICD0(AUMI,"MDC",AUMI2,0))  ; SKIP IF 0 NODE DOESN'T EXIST
 . . S AUMM=$P(^ICD0(AUMI,"MDC",AUMI2,0),U,1)  ; GET MDC FIELD
 . . Q:AUMM=""  ; SKIP IF BLANK
 . . Q:AUMM=+AUMM  ; SKIP IF ALREADY A POINTER
 . . S $P(AUMC,U,1)=$P(AUMC,U,1)+1,^TMP("AUM",$J,"ICD0",AUMI,AUMI2)=AUMM  ; ELSE COUNT & RECORD INVALID ENTRY
 . . S $P(^ICD0(AUMI,"MDC",AUMI2,0),U,1)=+AUMM  ; THEN CORRECT ENTRY
 . S AUMI2=0 F  S AUMI2=$O(^ICD0(AUMI,2,AUMI2)) Q:'AUMI2  D  ; REPEAT FOR VERSIONED FIELD
 . . S AUMI3=0 F  S AUMI3=$O(^ICD0(AUMI,2,AUMI2,1,AUMI3)) Q:'AUMI3  D  ;
 . . . Q:'$D(^ICD0(AUMI,2,AUMI2,1,AUMI3,0))
 . . . S AUMM=$P(^ICD0(AUMI,2,AUMI2,1,AUMI3,0),U,1)
 . . . Q:AUMM=""
 . . . Q:AUMM=+AUMM
 . . . S $P(AUMC,U,2)=$P(AUMC,U,2)+1,^TMP("AUM",$J,"ICD0",AUMI,AUMI2,AUMI3)=AUMM
 . . . S $P(^ICD0(AUMI,2,AUMI2,1,AUMI3,0),U,1)=+AUMM
 S ^TMP("AUM",$J,"ICD0")=$P(AUMC,U,1)_U_$P(AUMC,U,2)
 D BMES^XPDUTL("FILE 80   - ICD DIAGNOSIS")
 D MES^XPDUTL("  # of entries corrected          : "_$P($G(^TMP("AUM",$J,"ICD9")),U,1))
 D BMES^XPDUTL("FILE 80.1 - ICD OPERATION/PROCEDURE")
 D MES^XPDUTL("  # of entries corrected          : "_$P($G(^TMP("AUM",$J,"ICD0")),U,1))
 K ^TMP("AUM",$J,"ICD9"),^TMP("AUM",$J,"ICD0")
 Q
 ; 
LANG132 ; IHS/OIT/NKD - AUM*13.0*2 LANGUAGE FILE CLEANUP - UPPER CASE 639-1 AND 639-2, STRING CLEANUP
 N AUMI,AUMC,AUMT,DA,DIK
 D BMES^XPDUTL("Correcting Language File entries...")
 S AUMI=0 F  S AUMI=$O(^AUTTLANG(AUMI)) Q:'AUMI  D
 . Q:'$D(^AUTTLANG(AUMI,0))
 . ; STRING CLEANUP
 . F AUMC=1,2,3,4 S AUMT=$P(^AUTTLANG(AUMI,0),U,AUMC) S:AUMT]"" $P(^AUTTLANG(AUMI,0),U,AUMC)=$$CLEAN^AUMSCBD(AUMT)
 . ; CONVERT ISO 639-1 AND ISO 639-2 FIELDS TO UPPER CASE
 . F AUMC=3,4 S AUMT=$P(^AUTTLANG(AUMI,0),U,AUMC) S:AUMT]"" $P(^AUTTLANG(AUMI,0),U,AUMC)=$$UP^XLFSTR(AUMT)
 ; RE-INDEX FILE
 K AUMC,DA,DIK
 F AUMC="B","C","ISO1","ISO2" K ^AUTTLANG(AUMC)
 S DIK="^AUTTLANG("
 D IXALL^DIK
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
