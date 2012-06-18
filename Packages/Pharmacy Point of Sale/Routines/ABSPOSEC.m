ABSPOSEC ; IHS/SD/lwj  - Point of Sale environment checker  [ 05/28/2002  10:03 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**1**;JUN 21, 2001
 ;
 ; This routine is an environment checker used with the installation
 ; of patch 1 of the Point of Sale software. 
 ; It will check for the following RPMS packages, their version
 ; and patch numbers before allowing the user to continue
 ; with the installation of patch 1 for Point of Sale:
 ;
 ;    Fileman                  (DI)    v21
 ;    Kernel                   (XU)    v8.0
 ;    IHS Patient Dictionaries (AUPN)  V99.1
 ;    IHS Dictionary Pointers (AUT)  V98.1, patch 8
 ;    Outpatient Pharmacy     (PSO)  V6.0  patch 3
 ;    Pharmacy Point of Sale  (ABSP) V1.0
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
 N ABSPERS,X,ABSPMSG
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S ABSPERS=$P($G(^VA(200,DUZ,0)),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(ABSPERS,",",2)_" "_$P(ABSPERS,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_"  Ver: "_$P($T(+2),";",3)_"  Patch: "_$P($T(+2),";",5)_".",IOM),!
 ;
 ;now lets get the the nitty gritty and check the packages
 ; and their versions
 ;
 Q:'$$VCHK("DI","21.0",2)
 Q:'$$VCHK("XU","8.0",2)
 Q:'$$VCHK("AUPN","99.1",2)
 Q:'$$VCHK("AUT","98.1",2)
 Q:'$$VCHK("PSO","6.0",2)
 Q:'$$VCHK("ABSP","1.0",2)
 W !!
 ;
 ; okay - we have the packages, and they are on the right version
 ; but lets check for a couple of patchs
 ;
 ; first outpatient pharmacy patch 3 - not in package or kids file
 ; so we will look for a routine that was new in patch 3
 ;
 S X="APSQUTL" X ^%ZOSF("TEST")
 I '$T S ABSPMSG="Outpatient Pharmacy V6.0 Patch 3 MUST be loaded to continue."  D SORRY(ABSPMSG,2)
 ;
 ; now let's see if IHS dictionary pointers have at least patch 8
 ;
 S ABSPPK="AUT*98.1*8"
 S ABSPPTCH=$$INSTALLD(ABSPPK)
 I 'ABSPPTCH S ABSPMSG="IHS Dictionary Pointers (AUT) must be at V98.1 patch 8 to continue with this load" D SORRY(ABSPMSG,2)
 ;
 ;
 Q
 ;
VCHK(ABSPPRE,ABSPVER,ABSPQUIT)         ; Check versions needed
 ;
 NEW ABSPV
 S ABSPV=$$VERSION^XPDUTL(ABSPPRE)
 W !,$$CJ^XLFSTR("Need at least "_ABSPPRE_" v "_ABSPVER_"....."_ABSPPRE_" v "_ABSPV_" Present  ",IOM)
 I ABSPV<ABSPVER KILL DIFQ S XPDQUIT=ABSPQUIT W *7,!,$$CJ^XLFSTR("Sorry....",IOM) S ABSPV=$$DIR^XBDIR("E","Press RETURN") Q 0
 Q 1
 ;
 ;
INSTALLD(ABSPPKG)  ;check for a specific patch
 ; ABSPPKG in the form of AUT*98.1*8
 ;
 N DIC,X,Y
 ;
 ;lookup the package
 S X=$P(ABSPPKG,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;
 ; lookup the version
 S DIC=DIC_+Y_",22,",X=$P(ABSPPKG,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;
 ;lookup the patch
 ;
 S DIC=DIC_+Y_",""PAH"",",X=$P(ABSPPKG,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ;
 ;
SORRY(ABSPMSG,ABSPCD)      ; let the user know we didn't have what we needed 
 ;
 K DIFQ
 S XPDQUIT=ABSPCD
 I $T W !,$$CJ^XLFSTR(ABSPMSG,IOM)
 W *7,!,$$CJ^XLFSTR("Sorry.....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
