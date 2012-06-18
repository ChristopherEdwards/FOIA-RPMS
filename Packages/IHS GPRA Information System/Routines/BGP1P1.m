BGP1P1 ; IHS/CMI/LAB - v11.0 patch 1 env routine 08 Dec 2010 3:10 PM ;
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;;JUN 27, 2011;Build 33
 ;
 ;
 ;SEND OUT BGP TAXONOMIES
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;I '$$INSTALLD("BGP*11.0*1") D SORRY(2)
 ;I '$$INSTALLD("BJPC*2.0*5") D SORRY(2)
 I +$$VERSION^XPDUTL("BGP")<11 D MES^XPDUTL($$CJ^XLFSTR("Version 11.0 of BGP is required.  Not installed.",80)) D SORRY(2) I 1
 ;E  D MES^XPDUTL($$CJ^XLFSTR("Requires BMX v4.0....Present.",80))
 Q
 ;
PRE ;EP
 Q
POST ;EP - called from kids build
 ;wipe out partial area files.
 S BGPX=0 F  S BGPX=$O(^BGPGPDCB(BGPX)) Q:BGPX'=+BGPX  D
 .I '$D(^BGPGPDCB(BGPX,1.1)) S DA=BGPX,DIK="^BGPGPDCB(" D ^DIK S DA=BGPX,DIK="^BGPGPDPB(" D ^DIK S DA=BGPX,DIK="^BGPGPDBB(" D ^DIK
 Q
INSTALLD(BGPSTAL) ;EP - Determine if patch BGPSTAL was installed, where
 ; BGPSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BGPY,DIC,X,Y
 S X=$P(BGPSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BGPSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BGPSTAL,"*",3)
 D ^DIC
 S BGPY=Y
 D IMES
 Q $S(BGPY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BGPSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
