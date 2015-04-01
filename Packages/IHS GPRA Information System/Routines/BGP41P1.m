BGP41P1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 08 Dec 2010 3:10 PM ; 25 Jun 2014  10:57 AM
 ;;14.1;IHS CLINICAL REPORTING;**1**;MAY 29, 2014;Build 2
 ;
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I +$$VERSION^XPDUTL("BGP")<14.1 D MES^XPDUTL($$CJ^XLFSTR("Version 14.1 of the IHS CLINICAL REPORTING is required.  Not installed",80)) D SORRY(2) I 1
 Q
 ;
PRE ;EP
 S BGPX=0 F  S BGPX=$O(^BGPINDJC(BGPX)) Q:BGPX'=+BGPX  S DA=BGPX,DIK="^BGPINDJC(" D ^DIK
 Q
POST ;EP - called from kids build
 Q
 ;
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