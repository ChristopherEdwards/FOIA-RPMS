BGP90P1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 28 Jan 2005 1:34 PM 25 Nov 2007 7:41 PM ; 
 ;;9.0;IHS CLINICAL REPORTING;**1**;JUL 1, 2009
 ;
 ;
 ;SEND OUT BGP TAXONOMIES
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$VERSION^XPDUTL("BGP")'="9.0" D SORRY(2)
 Q
 ;
PRE ;EP
 S BGPX=0 F  S BGPX=$O(^BGPINDNC(BGPX)) Q:BGPX'=+BGPX  S DA=BGPX,DIK="^BGPINDNC(" D ^DIK
 S BGPX=0 F  S BGPX=$O(^BGPINDN(BGPX)) Q:BGPX'=+BGPX  S DA=BGPX,DIK="^BGPINDN(" D ^DIK
 S BGPX=0 F  S BGPX=$O(^BGPCTRL(BGPX)) Q:BGPX'=+BGPX  S DA=BGPX,DIK="^BGPCTRL(" D ^DIK
 S BGPX=0 F  S BGPX=$O(^BGPHEIN(BGPX)) Q:BGPX'=+BGPX  S DA=BGPX,DIK="^BGPHEIN(" D ^DIK
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
