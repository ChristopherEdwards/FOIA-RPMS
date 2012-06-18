AG7P2 ;IHS/SD/EFG - Patient Registration 7.0 Patch 2 ENVIRONMENT CHECKER ;   [ 05/08/2003  1:14 PM ]
 ;;7.0;IHS PATIENT REGISTRATION;**1,2,3**;MAR 28, 2003
 ;
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM),!
 ;
 NEW AGQUIT
 S AGQUIT=0
 I '$$VCHK("AG","7.0",2) S AGQUIT=2
 ;
 I '$$VCHK("AUPN","99.1",2) S AGQUIT=2
 ;
 ;S X=$$LAST^XPDUTL("IHS DICTIONARIES (PATIENT)","99.1")
 S X=$$LAST^AG7P2("IHS DICTIONARIES (PATIENT)","99.1")
 I $P(X,U,1)'=12&($P(X,U,1)'>12) W !,$$CJ^XLFSTR("AUPN v99.1 Patch 12 NOT INSTALLED",IOM) S AGQUIT=2
 ;
 I '$$VCHK("AUT","98.1",2) S AGQUIT=2
 ;
 ;S X=$$LAST^XPDUTL("IHS DICTIONARIES (POINTERS)","98.1")
 S X=$$LAST^AG7P2("IHS DICTIONARIES (POINTERS)","98.1")
 I $P(X,U,1)'=13&($P(X,U,1)'>13) W !,$$CJ^XLFSTR("AUT v98.1 Patch 13 NOT INSTALLED",IOM) S AGQUIT=2
 ;
 NEW DA,DIC
 S X="AG",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AG")) D  S AGQUIT=2
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AG"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 .Q
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D OPTSAV("AGMENU")
 .Q
 ;
 I AGQUIT D SORRY(AGQUIT) Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(AGPRE,AGVER,AGQUIT) ; Check versions needed.
 ;  
 NEW AGV
 S AGV=$$VERSION^XPDUTL(AGPRE)
 W !,$$CJ^XLFSTR("Need at least "_AGPRE_" v "_AGVER_"....."_AGPRE_" v "_AGV_" Present",IOM)
 I AGV<AGVER W *7,!,$$CJ^XLFSTR("^^^^**NEEDS FIXED**^^^^",IOM) Q 0
 Q 1
 ;
OPTSAV(AGM) ;
 D BMES^XPDUTL("Saving the configuration of option '"_AGM_"'...")
 I $D(^XTMP("AG7P2",7.2,"OPTSAV",AGM)) D BMES^XPDUTL("NOT SAVED.  Option '"_AGM_"' has previously been saved.") Q
 I '$D(^XTMP("AG7P2")) S ^XTMP("AG7P2",0)=$$FMADD^XLFDT(DT,30)_U_DT_U_"AG7P2 - SAVE OPTION CONFIGURATIONS."
 NEW I,A
 S I=$O(^DIC(19,"B",AGM,0))
 I 'I D BMES^XPDUTL("NOT SAVED.  Option '"_AGM_"' not found in OPTION file.") Q
 S A=0
 F  S A=$O(^DIC(19,I,10,A)) Q:'A  S ^XTMP("AG7P2",7.2,"OPTSAV",AGM,A)=$P(^DIC(19,+^DIC(19,I,10,A,0),0),U,1)_U_$P(^DIC(19,I,10,A,0),U,2,3)
 Q
 ;
INSTALLD(AGINSTAL) ;EP - Determine if patch AGINSTAL was installed, where AGINSTAL is
 ; the name of the INSTALL.  E.g "AG*6.0*10".
 ;;^DIC(9.4,D0,22,D1,PAH,D2,0)=
 ;;(#.01) PATCH APPLICATION HISTORY [1F] ^ (#.02)DATE APPLIED [2D] ^ (#.03) APPLIED BY [3P] ^ 
 NEW DIC,X,Y
 S X=$P(AGINSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(AGINSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(AGINSTAL,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ;
LAST(PKG,VER) ;returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
