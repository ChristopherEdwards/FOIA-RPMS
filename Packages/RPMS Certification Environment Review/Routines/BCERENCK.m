BCERENCK ;IHS/SD/TPF - BCER ENVIRONMENT CHECKER FOR EHR
 ;;1.0;BCER EHR CERT;;SEP 29, 2011;Build 23
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for EHR Software",IOM),!
 W !,$$CJ^XLFSTR("At Facility "_$P($G(^DIC(4,DUZ(2),0)),U),IOM),!
 N BCERQUIT
 S BCERQUIT=0
 ;Write $system.Version.Format(5)
 ;2010.2.3 (Build 702)
 S ENSEMBLE=$system.Version.GetVersion()
 I ENSEMBLE'[("2009.1.6"),(ENSEMBLE'[("2010.2.3")) W !,$$CJ^XLFSTR("Need Ensemble version 2009.1.6 or version 2010.2.3  ....neither was found",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need Ensemble version 2009.1.6 or version 2010.2.3 ....."_ENSEMBLE_" was found",IOM)
 ;
 ;"IHS PATIENT REGISTRATION"
 ;W $$LAST^BCERENCK("IHS PATIENT REGISTRATION","7.1")
 ;3^3110927
 ;I '$$PATCH("AG*7.1*9")
 ;DON'T CHECK FOR VERSION HERE BECAUSE AG7.2 IS MPI AND A SEPARATE DEVELOPMENT LINE
 S X=$$LAST^BCERENCK("IHS PATIENT REGISTRATION","7.1")
 I $P(X,U)<9 W !,$$CJ^XLFSTR("Need at least AG V7.1 patch 9....patch 9 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least AG V7.1 patch 9....patch 9 Present",IOM)
 ;
 ;"IHS PCC REPORTS"
 ;I '$$PATCH("APCL*3.0*27")
 S X=$$LAST^BCERENCK("IHS PCC REPORTS","3.0")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of APCL was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<27 W !,$$CJ^XLFSTR("Need at least APCL V3.0 patch 27....patch 27 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least APCL V3.0 patch 27....patch 27 Present",IOM)
 ;
 ;IHS PHARMACY MODIFICATIONS
 ;I '$$PATCH("APSP*7.0*1010")
 S X=$$LAST^BCERENCK("IHS PHARMACY MODIFICATIONS","7.0")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of APSP was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<1010 W !,$$CJ^XLFSTR("Need at least APSP V7.0 patch 1010....patch 1010 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least APSP V7.0 patch 1010....patch 1010 Present",IOM)
 ;
 ;IHS CLINICAL REPORTING
 ;I '$$PATCH("BGP*11.0*3")
 S X=$$LAST^BCERENCK("IHS CLINICAL REPORTING","11.0")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of BGP was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<3 W !,$$CJ^XLFSTR("Need at least BGP V11.0 Patch 3 installed... at least Patch 3 not installed",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least patch 3 BGP v11.0 Patch "_$P(X,U)_" installed",IOM)
 ;
 ;
 ;C32/CCD Clinical Summary
 ;I '$$PATCH("BJMD*1.0*1")
 S X=$$LAST^BCERENCK("CDA/C32","1.0")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of BJMD was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<1 W !,$$CJ^XLFSTR("Need at least BJMD V1.0 patch 1....patch 1 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least BJMD V1.0 patch 1....patch 1 Present",IOM)
 ;
 ;IHS PCC SUITE
 ;I '$$PATCH("BJPC*2.0*6")
 S X=$$LAST^BCERENCK("IHS PCC SUITE","2.0")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of BGPC was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<6 W !,$$CJ^XLFSTR("Need at least BJPC V2.0 patch 6....patch 6 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least BJPC V2.0 patch 6....patch 6 Present",IOM)
 ;
 ;REFERRED CARE INFO SYSTEM
 ;I '$$PATCH("BMC*4.0*7")
 S X=$$LAST^BCERENCK("REFERRED CARE INFO SYSTEM","4.0")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of BMC was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<7 W !,$$CJ^XLFSTR("Need at least BMC V4.0 patch 7....patch 7 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least BMC V4.0 patch 7....patch 7 Present",IOM)
 ;
 ;ICARE MANAGEMENT SYSTEM
 ;I '$$VCHK("BQI","2.1",2)
 S X=$$LAST^BCERENCK("ICARE MANAGEMENT SYSTEM","2.1")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of BQI was found present. This is greater than the version required.",IOM)
 E  I $P(X,U,3)<2.1 W !,$$CJ^XLFSTR("Need at least BQI V2.1....BQI V2.1 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least BQI V2.1....BQI V2.1 Present",IOM)
 ;
 ;IHS RELEASE OF INFORMATION
 ;I '$$PATCH("BRN*2.0*3")
 S X=$$LAST^BCERENCK("IHS RELEASE OF INFORMATION","2.0")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of BRN was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<3 W !,$$CJ^XLFSTR("Need at least BRN V2.0 patch 3....patch 3 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least BRN V2.0 patch 3....patch 3 Present",IOM)
 ;
 ;BYIM IMMUNIZATION INTERFACE
 ;I '$$PATCH("BYIM*2.0*1")
 S X=$$LAST^BCERENCK("BYIM IMMUNIZATION INTERFACE","2.0")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of BYIM was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<1 W !,$$CJ^XLFSTR("Need at least BYIM V2.0 patch 1....patch 1 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least BYIM V2.0 patch 1....patch 1 Present",IOM)
 ;
 ;BGO COMPONENTS
 ;I '$$PATCH("BGO*1.1*8")
 S X=$$LAST^BCERENCK("BGO COMPONENTS","1.1")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of BGO was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<8 W !,$$CJ^XLFSTR("Need at least BGO V1.1 patch 8....patch 8 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least BGO V1.1 patch 8....patch 8 Present",IOM)
 ;
 ;LAB SERVICE
 ;I '$$PATCH("LR*5.2*1027")
 ;DO NOT CHECK VERSION THE VA HAS RESOLVED NOT TO UPGRADE THE LR VERSION
 ;S X=$$LAST^BCERENCK("LAB SERVICE","5.2")
 S X=$O(^XPD(9.7,"B","LR*5.2*1099"),-1)
 I $P(X,"*",3)<1027 W !,$$CJ^XLFSTR("Need at least LR V5.2 patch 1027....patch 1027 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least LR V5.2 patch 1027....patch 1027 Present",IOM)
 ;
 ;CLINICAL REMINDERS - IHS 1.5
 ;I '$$PATCH("PXRM*1.5*1007")
 S X=$$LAST^BCERENCK("CLINICAL REMINDERS - IHS 1.5","1.5")
 I X=-1 S X=$$LAST^BCERENCK("CLINICAL REMINDERS","1.5")
 I $P(X,U,4)>$P(X,U,3) D
 .W !,$$CJ^XLFSTR("Version "_$P(X,U,4)_" of PXRM was found present. This is greater than the version required.",IOM)
 E  I $P(X,U)<1007 W !,$$CJ^XLFSTR("Need at least PXRM V1.5 patch 1007....patch 1007 NOT INSTALLED",IOM) S BCERQUIT=2
 E  W !,$$CJ^XLFSTR("Need at least PXRM V1.5 patch 1007....patch 1007 Present",IOM)
 ;
 I BCERQUIT D SORRY(2) Q
 ;
 Q
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
LAST(PKG,VER) ;EP - returns last patch applied for a Package, PATCH^DATE^VERSION
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 E  S CURVER=$$VERSION^XPDUTL(PKG)
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST_U_VER_U_CURVER
