BIENVCHK ;IHS/CMI/MWR - ENVIRONMENTAL CHECK FOR KIDS; DEC 15, 2010
 ;;8.5;IMMUNIZATION;**6**;OCT 15,2013
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  ENVIRONMENTAL CHECK ROUTINE FOR KIDS INSTALLATION.
 ;;  PATCH 5, v8.5: Check environment for Imm v8.5 Patch 5.  START+53
 ;
 ;
 ;----------
START ;EP
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 N X,Z
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 S X="Checking Environment for "_$P($T(+2),";",4)_" v"_$P($T(+2),";",3)
 S Z=$P($P($T(+2),";",5),"**",2)
 S:Z X=X_", Patch "_Z_"."
 W !!,$$CJ^XLFSTR(X,IOM),!
 ;
 S XPDQUIT=0
 ;
 ;---> REQUIREMENTS
 ;
 ;---> Kernel v8.
 I '$$VCHK("XU","8.0",2) S XPDQUIT=2
 ;
 ;
 ;---> Fileman v22.
 I '$$VCHK("DI","22",2) S XPDQUIT=2
 ;
 ;
 ;I '$$VCHK("AUT","98.1",2) S XPDQUIT=2
 ;S X=$$LAST("IHS DICTIONARIES (POINTERS)","98.1")
 ;I $P(X,U,1)'=14&($P(X,U,1)'>14) D  S XPDQUIT=2
 ;.W !,$$CJ^XLFSTR("AUT v98.1 Patch 14 NOT INSTALLED",IOM)
 ;
 ;
 ;---> XB/ZIB v3.0 patch 11.
 ;I '$$VCHK("XB","3.0",2) S XPDQUIT=2
 ;S X=$$LAST("IHS/VA UTILITIES","3.0")
 ;I $P(X,U)'=11&($P(X,U)'>11) D  S XPDQUIT=2
 ;.W !,$$CJ^XLFSTR("XB/ZIB v3.0 patch 11 NOT INSTALLED",IOM)
 ;
 ;
 ;---> PCC Suite v2.0 patch 2.
 ;I '$$VCHK("BJPC","2.0",2) S XPDQUIT=2
 ;S X=$$LAST("IHS PCC SUITE","2.0")
 ;I $P(X,U)'=2&($P(X,U)'>2) D  S XPDQUIT=2
 ;.W !,$$CJ^XLFSTR("BJPC v2.0 Patch 2 NOT INSTALLED",IOM)
 ;
 ;
 ;---> IHS Clinical Reporting System v9.0 patch 1.
 ;I '$$VCHK("BGP","9.0",2) S XPDQUIT=2
 ;S X=$$LAST("IHS CLINICAL REPORTING","9.0")
 ;I $P(X,U)'=1&($P(X,U)'>1) D  S XPDQUIT=2
 ;.W !,$$CJ^XLFSTR("BGP v9.0 Patch 1 NOT INSTALLED",IOM)
 ;
 ;
 ;********** PATCH 1, v8.5, JAN 03,2012, IHS/CMI/MWR
 ;---> Check environment for previous load of Imm v8.5.
 D
 .;---> Either never before installed or at least v8.5, Patch 0.
 .;Q:($$VERSION^XPDUTL("BI")="")
 I '$$VCHK("BI","8.5",2) S XPDQUIT=2
 ;
 ;---> Check Patch Level of Imm.
 ;********** PATCH 4, v8.5, DEC 01,2012, IHS/CMI/MWR
 ;---> Check for Imm v8.5, required patch.
 D
 .S X=$$LAST("IMMUNIZATION","8.5")
 .;---> Patch 1.
 .;I $P(X,U)'=1&($P(X,U)'>1) D  S XPDQUIT=2
 .;.W !,$$CJ^XLFSTR("BI v8.5 Patch 1 NOT INSTALLED",IOM)
 .;---> Patch 2.
 .;I $P(X,U)'=2&($P(X,U)'>2) D  S XPDQUIT=2
 .;.W !,$$CJ^XLFSTR("BI v8.5 Patch 2 NOT INSTALLED",IOM)
 .;---> Patch 5.
 .I $P(X,U)'=5&($P(X,U)'>5) D  S XPDQUIT=2
 ..W !,$$CJ^XLFSTR("BI v8.5 Patch 5 NOT INSTALLED",IOM)
 .;
 .I XPDQUIT'=2 D
 ..;W !,$$CJ^XLFSTR("Checking for Patch 1 of BI v8.5.....Patch 1 Present",IOM)
 ..;W !,$$CJ^XLFSTR("Checking for Patch 2 of BI v8.5.....Patch 2 Present",IOM)
 ..W !,$$CJ^XLFSTR("Checking for Patch 5 of BI v8.5...Patch 5 Present",IOM)
 ;**********
 ;
 ;---> Check for multiple BI entries in the Package File.
 N DA,DIC
 S X="BI",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BI")) D  S XPDQUIT=2
 .W !!,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM)
 .W !,$$CJ^XLFSTR("PACKAGE File with a ""BI"" prefix.",IOM)
 .W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 .W !,$$CJ^XLFSTR("Please do this before Proceeding.",IOM),!!
 .Q
 ;
 ;---> Do not allow KIDS installation to be queued (at DEVICE: prompt).
 S XPDNOQUE=1
 ;---> Do not ask "DISABLE Options...etc.?" question.
 S XPDDIQ("XPZ1")=0
 ;---> Do not ask "MOVE routines to other CPUs?" question.
 S XPDDIQ("XPZ2")=0
 ;
 I XPDQUIT D SORRY(XPDQUIT) Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) !,$$CJ^XLFSTR("Sorry...",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(ABMPRE,ABMVER,ABMQUIT) ; Check versions needed.
 ;
 NEW ABMV
 S ABMV=$$VERSION^XPDUTL(ABMPRE)
 W !,$$CJ^XLFSTR("Need at least "_ABMPRE_" v"_ABMVER_"..."_ABMPRE_" v"_ABMV_" Present",IOM)
 I ABMV<ABMVER W !,$$CJ^XLFSTR("^^^^**NEEDS TO BE INSTALLED**^^^^",IOM) Q 0
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
