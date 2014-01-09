BPMENVC ; IHS/OIT/NKD - Environment checker for BPM - 7/23/12 ;
 ;;1.0;IHS PATIENT MERGE;**2**;MAR 01, 2010;Build 1
 ;IHS/OIT/NKD  6/05/2012 Added new requirements
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM),!
 ;
 S XPDQUIT=0,BPMQUIT=0
 I '$$VCHK2("XU","8.0.1017",2)
 I '$$VCHK("DI","21.0",2)
 I '$$VCHK2("XT","7.3.1017",2)
 I '$$VCHK("BPM","1.0",2)
 ;IHS/OIT/NKD BPM*1.0*2 Check to ensure official BADE*1.0*1 patch is installed
 I $$PATCH^XPDUTL("BADE*1.0*1") N X S X="BADEMRG" X ^%ZOSF("TEST") I '$T D
 . W !,$$CJ^XLFSTR("ERROR: BADE*1.0*1 is installed but BADEMRG routine not present.",IOM)
 . W !,$$CJ^XLFSTR("This may be due to an unofficial release of BADE*1.0*1.",IOM)
 . W !,$$CJ^XLFSTR("The official November 2011 patch of BADE*1.0*1 must be installed to continue.",IOM)
 . W *7,!,$$CJ^XLFSTR("^^^^**NEEDS TO BE FIXED**^^^^",IOM)
 . S XPDQUIT=2
 ;
 I XPDQUIT D SORRY(XPDQUIT) Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(BPMPRE,BPMVER,BPMQUIT) ; Check versions needed.
 ;  
 NEW BPMV
 S BPMV=$$VERSION^XPDUTL(BPMPRE)
 W !,$$CJ^XLFSTR("Need at least "_BPMPRE_" v "_BPMVER_"....."_BPMPRE_" v "_BPMV_" Present",IOM)
 I BPMV<BPMVER S XPDQUIT=BPMQUIT W *7,!,$$CJ^XLFSTR("^^^^**NEEDS FIXED**^^^^",IOM) Q 0
 Q 1
 ;
VCHK2(BPMPRE,BPMVER,BPMQUIT) ; Check patch level
 NEW BPMV
 S BPMV=$$VERSION^XPDUTL(BPMPRE)
 I $L(BPMV)<1 S XPDQUIT=BPMQUIT W !,$$CJ^XLFSTR("Need at least "_BPMPRE_" v "_BPMVER_"....."_BPMPRE_" Not Installed",IOM),*7,!,$$CJ^XLFSTR("^^^^**NEEDS TO BE FIXED**^^^^",IOM) Q 1
 S PTCH=+$$LAST(BPMPRE,BPMV) S:PTCH=-1 DPTCH="" S:PTCH'=-1 DPTCH="."_PTCH
 W !,$$CJ^XLFSTR("Need at least "_BPMPRE_" v "_BPMVER_"....."_BPMPRE_" v "_BPMV_DPTCH_" Present",IOM)
 I (BPMV=$P(BPMVER,".",1,2))&(PTCH<$P(BPMVER,".",3)) KILL DIFQ S XPDQUIT=BPMQUIT W *7,!,$$CJ^XLFSTR("^^^^**NEEDS TO BE FIXED**^^^^",IOM)
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
