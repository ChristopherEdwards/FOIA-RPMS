AG71EN3 ;IHS/SD/EFG - Patient Registration 7.1 PATCH 3 ENVIRONMENT CHECKER ;   
 ;;7.1;PATIENT REGISTRATION;**1,2,3**;AUG 25,2005
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_$S($P($T(+2),";",5)="":"",1:" Patch "_$P($T(+2),";",5)_"."),IOM),!
 ;
 N AGQUIT
 S AGQUIT=0
 ;
 ;CHECK FOR KERNEL PATCH 1009 TO AVOID LINER ERROR
 I '$$PATCH("XU*8.0*1009") D SORRY(2) W !,$$CJ^XLFSTR("Need at least Kernel patch 1009....patch 1009 NOT INSTALLED",IOM) Q
 W !,$$CJ^XLFSTR("Need at least Kernel patch 1012....patch 1012 Present",IOM)
 ;
 I $$VERSION^XPDUTL("AG")="7.1" W !,$$CJ^XLFSTR("Version 7.1 Present",IOM) G CONT
 I '$$VCHK("AG","7.1",2) S AGQUIT=2
 ;
CONT ;EP
 I '$$VCHK("AUPN","99.1",2) S AGQUIT=2
 ;
 S X=$$LAST^XPDUTL("XU","8.0")
 ;
 S X=$$LAST^XPDUTL("IHS DICTIONARIES (PATIENT)","99.1")
 I $P(X,U)<17 W !,$$CJ^XLFSTR("AUPN v99.1 Patch 17 NOT INSTALLED",IOM) S AGQUIT=2
 ;
 I '$$VCHK("AUT","98.1",2) S AGQUIT=2
 ;
 S X=$$LAST^XPDUTL("IHS DICTIONARIES (POINTERS)","98.1")
 I $P(X,U)<20 W !,$$CJ^XLFSTR("AUT v98.1 Patch 20 NOT INSTALLED",IOM) S AGQUIT=2
 ;
 I '$$VCHK("DI","22.0",2) S AGQUIT=2
 ;
 I '$$INSTALLD("DI*22.0*1003") D
 .W !,$$CJ^XLFSTR("DI  VA FILEMAN 22.0 Patch 1003 NOT INSTALLED",IOM) S AGQUIT=2
 ;
 NEW DA,DIC
 S X="AG",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AG")) D  S AGQUIT=2
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AG"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 .Q
 I $G(XPDENV)=1 D
 . ;The following line prevents the "Disable Options..." and "Move
 . ;Routines..." questions from being asked during the install.
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
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
VCHK(AGPRE,AGVER,AGQUIT) ;Check versions needed.
 NEW AGV
 S AGV=$$VERSION^XPDUTL(AGPRE)
 W !,$$CJ^XLFSTR("Need at least "_AGPRE_" v "_AGVER_"....."_AGPRE_" v "_AGV_" Present",IOM)
 I AGV<AGVER W *7,!,$$CJ^XLFSTR("^^^^**NEED TO UPGRADE**^^^^",IOM) Q 0
 Q 1
OPTSAV(AGM) ;
 D BMES^XPDUTL("Saving the configuration of option '"_AGM_"'...")
 I $D(^XTMP("AG71",7.2,"OPTSAV",AGM)) D BMES^XPDUTL("NOT SAVED.  Option '"_AGM_"' has previously been saved.") Q
 I '$D(^XTMP("AG71")) S ^XTMP("AG71",0)=$$FMADD^XLFDT(DT,30)_U_DT_U_"AG71 - SAVE OPTION CONFIGURATIONS."
 NEW I,A
 S I=$O(^DIC(19,"B",AGM,0))
 I 'I D BMES^XPDUTL("NOT SAVED.  Option '"_AGM_"' not found in OPTION file.") Q
 S A=0
 F  S A=$O(^DIC(19,I,10,A)) Q:'A  S ^XTMP("AG71",7.2,"OPTSAV",AGM,A)=$P(^DIC(19,+^DIC(19,I,10,A,0),0),U,1)_U_$P(^DIC(19,I,10,A,0),U,2,3)
 Q
INSTALLD(AGINSTAL) ;EP - Determine if patch AGINSTAL was installed, where AGINSTAL is
 ;the name of the INSTALL.  E.g "AG*6.0*10".
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
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 N %,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S %=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+%)