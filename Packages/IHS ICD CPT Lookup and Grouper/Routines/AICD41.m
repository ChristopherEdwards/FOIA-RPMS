AICD41 ; IHS/OIT/FBD&NKD - AICD 4.0 PATCH 1 LOAD ENVIRONMENT CHECKS ;04/19/2016
 ;;4.0;AICD;**1**;DEC 12, 2014;Build 1
 ;
 ;
 D:'$D(IOM) HOME^%ZIS
 ;
 ; The following line prevents the "Disable Options..." and "Move Routines..."
 ;  questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_$S($L($P($T(+2),";",5))>4:" Patch "_$P($T(+2),";",5),1:"")_".",IOM),!
 ;
 ; REQUIRED VERSION/PATCH CHECKS
 S:'$$VCHK("XU","8.0") XPDQUIT=2          ; KERNEL
 S:'$$VCHK("DI","22.0") XPDQUIT=2         ; FILEMAN
 S:'$$VCHK("AICD","4.0") XPDQUIT=2        ; AICD
 ; END OF REQUIRED VERSION/PATCH CHECKS
 ;
 ; REQUIRED UPDATE GLOBALS
 ;
 ; ADDITIONAL CHECKS IF RE-INSTALLING
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 I +$G(XPDQUIT) D SORRY(XPDQUIT)
 ;
 ; END OF ENVIRONMENT CHECK RUN LOGIC
 Q
 ;
SORRY(X) ; Environment check failure message
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
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
GCHK(AICDGL,AICDMSG) ; Check for global
 Q:'$L($G(AICDGL)) 0
 N AICDS
 S AICDS="Requires "_$S('$L($G(AICDMSG)):AICDGL,1:$G(AICDMSG))_"....."
 S AICDS=AICDS_$S($D(@AICDGL):"Present",1:"Not found ***FIX IT***")
 W !,$$CJ^XLFSTR(AICDS,IOM)
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
 W !,$$CJ^XLFSTR(AICDS,IOM)
 Q $S(+$G(PATIEN):1,1:0)
 ;
DISP(AICDPRE,AICDVER,AICDPAT,AICDV,AICDP,AICDR) ; Display requirement checking results
 N AICDS
 S AICDS="Need at least "_$G(AICDPRE)_" v"_$G(AICDVER)_$S($G(AICDPAT)]"":" p"_$G(AICDPAT),1:"")_"....."
 S AICDS=AICDS_$G(AICDPRE)_" v"_$G(AICDV)_$S($G(AICDP)]"":" p"_$G(AICDP),1:"")_" Present"
 S AICDS=AICDS_$S('AICDR:" ***FIX IT***",1:"")
 W !,$$CJ^XLFSTR(AICDS,IOM)
 Q
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
 Q
 ;
POST ; EP FR KIDS
 Q
 ;
