AICDENV ; IHS/OIT/FBD&NKD - ICD-10 LOAD ENVIRONMENT CHECKS ;   
 ;;4.0;AICD;;DEC 12, 2014;Build 7
 ;
 ;
 D:'$D(IOM) HOME^%ZIS
 ;
 ; The following line prevents the "Disable Options..." and "Move Routines..."
 ;  questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 ; REQUIRED VERSION/PATCH CHECKS
 S:'$$VCHK("XU","8.0") XPDQUIT=2          ; KERNEL
 S:'$$VCHK("DI","22.0") XPDQUIT=2         ; FILEMAN
 S:'$$VCHK("AICD","3.51") XPDQUIT=2       ; AICD
 S:'$$VCHK("AUM","15.0") XPDQUIT=2        ; AUM
 S:'$$PCHK("AUM","13.0","2") XPDQUIT=2    ; AUM VERSION 13.0 PATCH 2
 S:'$$PCHK("LEX","2.0","1003") XPDQUIT=2  ; LEX VERSION 2.0 PATCH 1003
 ; END OF REQUIRED VERSION/PATCH CHECKS
 ;
 ; REQUIRED UPDATE GLOBALS
 S:'$$GCHK("^AICDICD9","ICD DIAGNOSIS update global") XPDQUIT=2            ; FILE 80
 S:'$$GCHK("^AICDICD0","ICD OPERATION/PROCEDURE update global") XPDQUIT=2  ; FILE 80.1
 S:'$$GCHK("^AICDICDS","ICD CODING SYSTEMS update global") XPDQUIT=2       ; FILE 80.4
 ;
 ; ADDITIONAL CHECKS IF RE-INSTALLING
 I $$SYSCHK() D
 . D HELP^XBHELP("PREV","AICDENV")  ; MESSAGE EXPRESSING CAUTION REGARDING RE-INSTALLATIONS
 . Q:'+$G(XPDENV)                   ; ONLY MESSAGE NEEDS TO DISPLAY ON LOAD, CHECKS CAN RUN ON INSTALL
 . ; REQUIRED BACKUP GLOBALS
 . S:'$$GCHK("^zICD9","ICD DIAGNOSIS backup global") XPDQUIT=2             ; FILE 80
 . S:'$$GCHK("^zICD0","ICD OPERATION/PROCEDURE backup global") XPDQUIT=2   ; FILE 80.1
 . S:'$$GCHK("^zICD","DRG backup global") XPDQUIT=2                        ; FILE 80.2
 . S:'$$GCHK("^zICM","MAJOR DIAGNOSTIC CATEGORY backup global") XPDQUIT=2  ; FILE 80.3
 . ; PREVENT 'ACCIDENTAL' RE-INSTALLATIONS
 . I '$D(^AICDALL(0)) D MES^XPDUTL($$CJ^XLFSTR("Re-installation of AICD v4.0 not allowed!",IOM)) S XPDQUIT=2
 . E  I $D(^AICDALL(0)) D MES^XPDUTL($$CJ^XLFSTR("Re-installation allowed by user "_$P($G(^AICDALL(0)),U)_" on "_$$FMTE^XLFDT($P($G(^AICDALL(0)),U,2)),IOM))
 ;
 I +$G(XPDQUIT) D SORRY(XPDQUIT)
 ;
 ; END OF ENVIRONMENT CHECK RUN LOGIC
 Q
 ;
VCHK(AICDPRE,AICDVER,AICDPAT) ; Check patch level
 N AICDV,AICDP
 S AICDV=$$VERSION^XPDUTL(AICDPRE)
 I (AICDV<AICDVER) K DIFQ D DISP(AICDPRE,AICDVER,$G(AICDPAT),AICDV,$G(AICDP),0) Q 0
 I '$D(AICDPAT) D DISP(AICDPRE,AICDVER,$G(AICDPAT),AICDV,$G(AICDP),1) Q 1
 S AICDP=+$$LAST(AICDPRE,AICDVER)
 I (AICDP<AICDPAT) K DIFQ D DISP(AICDPRE,AICDVER,$G(AICDPAT),AICDVER,$G(AICDP),0) Q 0
 D DISP(AICDPRE,AICDVER,$G(AICDPAT),AICDVER,$G(AICDP),1)
 Q 1
 ;
GCHK(AICDGL,AICDMSG) ; EP - Check for global
 Q:'$L($G(AICDGL)) 0
 N AICDS
 S AICDS="Requires "_$S('$L($G(AICDMSG)):AICDGL,1:$G(AICDMSG))_"....."
 S AICDS=AICDS_$S($D(@AICDGL):"Present",1:"Not found ***FIX IT***")
 D MES^XPDUTL($$CJ^XLFSTR(AICDS,IOM))
 Q $S($D(@AICDGL):1,1:0)
 ;
PCHK(PKG,VER,PAT) ; Check specific patch
 N PKGIEN,VERIEN,PATIEN,AICDS
 S PKG=$G(PKG),VER=$G(VER),PAT=$G(PAT)
 S AICDS="Requires "_PKG_" v"_VER_" p"_PAT_"....."
 D
 . S PKGIEN=+$O(^DIC(9.4,"C",PKG,"")) Q:'PKGIEN
 . S VERIEN=+$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN
 . S PATIEN=+$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH","B",PAT,""))
 S AICDS=AICDS_$S(+$G(PATIEN):"Present",1:"Not found ***FIX IT***")
 D MES^XPDUTL($$CJ^XLFSTR(AICDS,IOM))
 Q $S(+$G(PATIEN):1,1:0)
 ;
DISP(AICDPRE,AICDVER,AICDPAT,AICDV,AICDP,AICDR) ; Display requirement checking results
 N AICDS
 S AICDS="Need at least "_$G(AICDPRE)_" v"_$G(AICDVER)_$S($G(AICDPAT)]"":" p"_$G(AICDPAT),1:"")_"....."
 S AICDS=AICDS_$G(AICDPRE)_" v"_$G(AICDV)_$S($G(AICDP)]"":" p"_$G(AICDP),1:"")_" Present"
 S AICDS=AICDS_$S('$G(AICDR):" ***FIX IT***",1:"")
 D MES^XPDUTL($$CJ^XLFSTR(AICDS,IOM))
 Q
 ;
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
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 D MES^XPDUTL($$LJ^XLFSTR("Aborting environment check process.",IOM))
 Q
 ;
SYSCHK() ; EP - AICD SYSTEM VERSION DETECTION (0=ICD9, 1=ICD10)
 Q:$$VERSION^XPDUTL("AICD")="4.0" 1                                ; AICD PACKAGE VERSION IS 4.0
 Q:($G(^DD(80,0,"VRPK"))="AICD")&($G(^DD(80,0,"VR"))="4.0") 1      ; FILE 80 DD IS AICD 4.0
 Q:($G(^DD(80.1,0,"VRPK"))="AICD")&($G(^DD(80.1,0,"VR"))="4.0") 1  ; FILE 80.1 DD IS AICD 4.0
 Q:($D(^ICD9(500001)))!($D(^ICD0(500001))) 1                       ; DATA EXISTS IN EITHER FILE 80 OR 80.1 ICD10 IEN RANGE
 Q 0
 ;
ALLOW ; EP - ALLOW RE-INSTALLATION OF AICD V4.0
 Q:'$G(DUZ)
 S ^AICDALL(0)=$G(DUZ)_U_$$NOW^XLFDT  ; WHO/WHEN RE-INSTALL WAS ALLOWED
 Q
 ;
PREV ; Text explaining previous install
 ;;AICD v4.0 has already been installed on this system.
 ;;****************************************
 ;;Re-installation of this application will:
 ;;  1) DELETE all existing ICD9 / ICD10 content
 ;;  2) RESTORE ICD9 content from ^zICD9,^zICD0,^zICD,^zICM
 ;;  3) CONVERT ICD9 content to ICD10 file structure
 ;;  4) INSTALL initial VA ICD10 seed file
 ;;****************************************
 ;;Use extreme caution before proceeding as this will revert
 ;;the ICD9 and ICD10 content to its initial state.
 ;;****************************************
 ;;To prevent an accidental re-install, the following must
 ;;be entered from the programmer prompt between the KIDS Load
 ;;and KIDS Install phases:
 ;;D ALLOW^AICDENV
 ;;****************************************
 ;;
 ;;###
