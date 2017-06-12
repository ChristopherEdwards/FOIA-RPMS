ZAGMU2 ;IHS/OIT/NKD - ENVIRONMENT CHECKER/POST-INSTALL FOR AG MU2 MULTI-PACKAGE BUILD ; FEBRUARY 10, 2014
 ;;7.1;PATIENT REGISTRATION;**11**;AUG 25, 2005;Build 1
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(1) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(1) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_$S($L($P($T(+2),";",5))>4:" Patch "_$P($T(+2),";",5),1:"")_".",IOM),!
 ;
 S:'$$VCHK("XU","8.0") XPDABORT=1
 S:'$$VCHK("DI","22.0") XPDABORT=1
 S:'$$VCHK("AG","7.1","10") XPDABORT=1
 S:'$$VCHK("AVA","93.2","22") XPDABORT=1
 S:'$$VCHK("AUPN","99.1","23") XPDABORT=1
 ;
 N ZAGPI,ZAGPV
 S ZAGPI=$$LKPKG^XPDUTL("AG")
 S ZAGPV=$$VERSION^XPDUTL("AG")
 ;
 I ZAGPI,+ZAGPV'=7.1 D
 . N FDA
 . S FDA(9.4,ZAGPI_",",13)="7.1PREV"_ZAGPV
 . W !,$$CJ^XLFSTR("Pre-init: Setting AG Package file entry to '7.1' from '"_ZAGPV_"'",IOM)
 . D UPDATE^DIE(,"FDA")
 ;
 I $G(XPDABORT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDABORT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(AGPRE,AGVER,AGPAT) ; Check patch level
 N AGV,AGP
 S AGV=$$VERSION^XPDUTL(AGPRE)
 I (AGV<AGVER) K DIFQ D DISP(AGPRE,AGVER,$G(AGPAT),AGV,$G(AGP),0) Q 0
 I '$D(AGPAT) D DISP(AGPRE,AGVER,$G(AGPAT),AGV,$G(AGP),1) Q 1
 S AGP=+$$LAST(AGPRE,AGVER)
 I (AGP<AGPAT) K DIFQ D DISP(AGPRE,AGVER,$G(AGPAT),AGVER,$G(AGP),0) Q 0
 D DISP(AGPRE,AGVER,$G(AGPAT),AGVER,$G(AGP),1)
 Q 1
DISP(AGPRE,AGVER,AGPAT,AGV,AGP,AGR) ; Display requirement checking results
 ;
 N AGS
 S AGS="Need at least "_$G(AGPRE)_" v"_$G(AGVER)_$S($G(AGPAT)]"":" p"_$G(AGPAT),1:"")_"....."
 S AGS=AGS_$G(AGPRE)_" v"_$G(AGV)_$S($G(AGP)]"":" p"_$G(AGP),1:"")_" Present"
 S AGS=AGS_$S('AGR:" ***FIX IT***",1:"")
 W !,$$CJ^XLFSTR(AGS,IOM)
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
POST ; EP - Post-install
 N ZAGPI,ZAGPV
 S ZAGPI=$$LKPKG^XPDUTL("AG")
 S ZAGPV=$$VERSION^XPDUTL("AG")
 ;
 I ZAGPI,ZAGPV["PREV" D
 . N FDA
 . S FDA(9.4,ZAGPI_",",13)=$P(ZAGPV,"PREV",2)
 . W !,$$CJ^XLFSTR("Post-init: Setting AG Package file entry back to '"_$P(ZAGPV,"PREV",2)_"' from '"_+ZAGPV_"'",IOM)
 . D UPDATE^DIE(,"FDA")
 ;
 Q
