BGP7P1 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 28 Jan 2005 1:34 PM ;
 ;;7.0;IHS CLINICAL REPORTING;**1**;JAN 24, 2007
 ;
 ;
 ;SEND OUT BGP TAXONOMIES
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$VERSION^XPDUTL("ACPT")'="2.07" S BGPSTAL="ACPT",BGPV="2.07" D IMEV,SORRY(2) Q
 I $$VERSION^XPDUTL("BGP")'="7.0" S BGPSTAL="BGP",BGPV="7.0" D IMEV,SORRY(2) Q
 Q
 ;
PRE ;EP
 F BGPX=1:1:50 S DA=BGPX,DIK="^BGPELIA(" D ^DIK
 F BGPX=1:1:50 S DA=BGPX,DIK="^BGPHEIA(" D ^DIK
 F BGPX=1:1:120 S DA=BGPX,DIK="^BGPINDA(" D ^DIK
 Q
POST ;EP - called from kids build
 ;install taxonomies for mammogram
 ;fix taxonomy entries
 S BGPX=0 F  S BGPX=$O(^ATXAX(BGPX)) Q:BGPX'=+BGPX  D
 .I $P($G(^ATXAX(BGPX,21,0)),U,2)[90530 S $P(^ATXAX(BGPX,21,0),U,2)="9002226.02101A"
 .I $P($G(^ATXAX(BGPX,41,0)),U,2)[90530 S $P(^ATXAX(BGPX,41,0),U,2)="9002226.04101P"
 D ^BGP7P1X
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
IMEV ;
 D MES^XPDUTL($$CJ^XLFSTR(BGPSTAL_" version "_BGPV_" is not installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
