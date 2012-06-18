ABSPOSEV ; IHS/SD/lwj  - Point of Sale environment checker  [ 05/28/2002  10:03 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**20,23,28,31,32,33,34,36,37,38,39,40,42**;JUN 21, 2001
 ;
 ;IHS/SD/RLT - 3/22/07 - Patch 20
 ;          New environment checker.  Replaced ABSPOSEC.
 ;          Added patch 1014 check for Kernel.
 ;
 ;IHS/SD/RLT - 11/21/07 - Patch 23
 ;          Added AICD v3.51 patch 7 check.
 ;
 ; This routine is an environment checker used with the installation
 ; of patches of the Point of Sale software. 
 ; It will check for the following RPMS packages, their version
 ; and patch numbers before allowing the user to continue
 ; with the installation of patch 1 for Point of Sale:
 ;
 ;    Fileman                   (DI)    v21
 ;    Kernel                    (XU)    v8.0   patch 1014
 ;    IHS Patient Dictionaries  (AUPN)  V99.1
 ;    IHS Dictionary Pointers   (AUT)   V98.1  patch 8
 ;    Outpatient Pharmacy       (PSO)   V6.0   patch 4
 ;    Pharmacy Point of Sale    (ABSP)  V1.0
 ;    Patient Registration      (AG)    V7.1   patch 1
 ;    IHS ICD/CPT LOOKUP & GRPR (AICD)  V3.51  patch 7
 ;
 ; (XPDQUIT will be set to 2 if the above mention packages are not
 ; at the require version and patch level.  2 indicates that
 ; the KIDS install will abort the installation, but will leave the
 ; ^XTMP global in place.)
 ;
 ;
CHECK ;EP - called from Kids install routine
 ; First let's make sure they have DUZ(0) defined, and greet the user
 ;
 N ABSPMSG
 S ABSPMSG=""
 I '$G(DUZ) S ABSPMSG="DUZ UNDEFINED OR 0." D SORRY(ABSPMSG,2) Q
 I '$L($G(DUZ(0))) S ABSPMSG="DUZ(0) UNDEFINED OR NULL." D SORRY(ABSPMSG,2) Q
 ;
 N ABSPERS
 S ABSPERS=$P($G(^VA(200,DUZ,0)),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(ABSPERS,",",2)_" "_$P(ABSPERS,","),IOM)
 ;IHS/OIT/SCR - 09/22/08 Patch 28 ; replaced line
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **26**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **28**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **30**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **31**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **32**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **33**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **34**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **36**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **37**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **38**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **39**.",IOM),!
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **40**.",IOM),!
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: **42**.",IOM),!
 ;
 ; Suppress the "Disable Options..." and "Move Routines..." install questions
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ; check versions and patch if needed
 ;
 N ABSPSTOP
 S ABSPSTOP=0
 D VCHK("DI","21.0")          ;Fileman
 D VPCHK("XU","8.0",1014)     ;Kernel
 D VCHK("AUPN","99.1")        ;IHS Patient Dictionaries
 ;D VCHK("AUT","98.1")         ;IHS Dictionary Pointers   ;IHS/OIT/CNI/SCR 042810 patch 39 replaced with line below
 D VPCHK("AUT","98.1",23)         ;IHS Dictionary Pointers   aut_9810.23k
 ;D SVPCHK("PSO","6.0",3)      ;Outpatient Pharmacy
 D VCHK("ABSP","1.0")         ;Pharmacy Point of Sale
 ;D VPCHK("AG","7.1",1)        ;Patient Registration ;IHS/OIT/SCR 09/22/08 Patch 28: replaced line below
 D VPCHK("AG","7.1",2)        ;Patient Registration
 D VPCHK("AICD","3.51",7)     ;IHS ICD/CPT LOOKUP & GRPR
 D VPCHK("APSP","7.0",1008)      ;IHS PHARMACY MODIFICATIONS ;IHS/OIT/SCR 011210 PATCH 36
 ;IHS/OIT/SCR 09/23/08 PATCH 28 START CHANGES
 ;I ($$VERSION^XPDUTL("ABM")="2.5") D ;IHS/OIT/CNI/SCR 042810 Patch 39: replaced with 2 lines below
 ;D VCHK("ABM","2.6")
 I ($$VERSION^XPDUTL("ABM")="2.6") D
 .;D VPCHK("ABM","2.5",15)
 .D VPCHK("ABM","2.6",1)
 ;IHS Third Party Billing
 ;I $$VERSION^XPDUTL("BAR") '= "" D VCHK("BAR","1.8")     -- IHS Accounts Receivable 
 ;IHS/OIT/SCR 09/23/08 PATCH 28 END CHANGES
 W !!
 I ABSPSTOP=1 D  Q
 . S ABSPMSG="You cannot continue, your environment does NOT meet all requirements."
 . D SORRY(ABSPMSG,2)
 Q
 ;
VCHK(ABSPPRE,ABSPVER)         ; Check version only
 ;
 N ABSPV
 S ABSPV=$$VERSION^XPDUTL(ABSPPRE)
 W !,"Required ",ABSPPRE," V",ABSPVER,?29
 W "...  Present ",ABSPPRE," V",ABSPV
 I ABSPV<ABSPVER D  Q
 . S ABSPSTOP=1
 . W ?65,"*** ERROR ***"
 W ?65,"OK"
 Q
 ;
VPCHK(ABSPPRE,ABSPVER,ABSPPTCH) ; Check version and patch
 ;
 N ABSPV,ABSPP,ABSPIEN,ABSPPKG,ABSPLAST
 S ABSPV=$$VERSION^XPDUTL(ABSPPRE)
 S ABSPP=$$PATCH^XPDUTL(ABSPPRE_"*"_ABSPVER_"*"_ABSPPTCH)
 S ABSPIEN=$O(^DIC(9.4,"C",ABSPPRE,""))
 S ABSPPKG=$P($G(^DIC(9.4,ABSPIEN,0)),U)
 S ABSPLAST=$P($$LAST(ABSPPKG),U)
 W !,"Required ",ABSPPRE," V",ABSPVER," Patch ",ABSPPTCH,?29
 W "...  Present ",ABSPPRE," V",ABSPV," Patch ",ABSPLAST
 I ABSPV<ABSPVER!(ABSPP'=1) D  Q
 . S ABSPSTOP=1
 . W ?65,"*** ERROR  ***"
 W ?65,"OK"
 Q
 ;
SVPCHK(ABSPPRE,ABSPVER,ABSPPTCH) ;Special version and patch check for PSO
 ;
 N ABSPV,ABSPP,ABSPIEN,ABSPPKG,ABSPLAST
 S ABSPV=$$VERSION^XPDUTL(ABSPPRE)
 S ABSPP=$$PATCH^XPDUTL(ABSPPRE_"*"_ABSPVER_"*"_ABSPPTCH)
 I ABSPVER'>"6.0"&(ABSPPTCH'>3) D
 . S X="APSQUTL" X ^%ZOSF("TEST")        ;check for Patch 3
 . S:$T ABSPP=1                          ;found Patch 3
 S ABSPIEN=$O(^DIC(9.4,"C",ABSPPRE,""))
 S ABSPPKG=$P($G(^DIC(9.4,ABSPIEN,0)),U)
 S ABSPLAST=$P($$LAST(ABSPPKG),U)
 W !,"Required ",ABSPPRE," V",ABSPVER," Patch ",ABSPPTCH,?29
 W "...  Present ",ABSPPRE," V",ABSPV," Patch ",ABSPLAST
 ;(current version < required version) or
 ;       (required patch not found  and  last patch < required patch)
 I ABSPV<ABSPVER!((ABSPP'=1)&(ABSPLAST<ABSPPTCH)) D  Q
 . S ABSPSTOP=1
 . W ?65,"*** ERROR  ***"
 W ?65,"OK"
 Q
 ;
LAST(PKG,VER) ;returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN,PATCHDT
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . S PATCHDT=$P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)
 . S PATCHNO=$P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U)
 . I PATCHDT=LATEST&(PATCHNO>PATCH) D
 .. S LATEST=PATCHDT,PATCH=PATCHNO
 . I PATCHDT>LATEST D
 .. S LATEST=PATCHDT,PATCH=PATCHNO
 Q PATCH_U_LATEST
 ;
SORRY(ABSPMSG,ABSPQUIT)      ; let the user know we didn't have what we needed 
 ;
 N ABSPV
 K DIFQ
 S XPDQUIT=$G(ABSPQUIT)
 W !,$$CJ^XLFSTR($G(ABSPMSG),IOM)
 W *7,!,$$CJ^XLFSTR("Sorry.....",IOM)
 Q:$D(ZTQUEUED)
 S ABSPV=$$DIR^XBDIR("E","Press RETURN")
 Q
