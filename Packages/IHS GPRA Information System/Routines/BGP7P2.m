BGP7P2 ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED 28 Jan 2005 1:34 PM ;
 ;;7.0;IHS CLINICAL REPORTING;**2**;JAN 24, 2007
 ;
 ;
 ;SEND OUT BGP TAXONOMIES
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;I $$VERSION^XPDUTL("ACPT")'="2.07" S BGPSTAL="ACPT",BGPV="2.07" D IMEV,SORRY(2) Q
 ;I $$VERSION^XPDUTL("BGP")'="7.0" S BGPSTAL="BGP",BGPV="7.0" D IMEV,SORRY(2) Q
 I '$$INSTALLD("BGP*7.0*1") D SORRY(2)
 Q
 ;
PRE ;EP
 Q
POST ;EP - called from kids build
OPT ;add new options
 NEW X
 S X=$$ADD^XPDMENU("BGP 07 MENU NATIONAL","BGP 07 NGR FOR GPRA YR 2008","GP8")
 I 'X W "Attempt to add National GPRA report for GPRA year 2008 option failed.." H 3
 S X=$$ADD^XPDMENU("BGP 07 AREA MENU","BGP 07 AREA AGP GPRA YR 2008","AGP8")
 I 'X W "Attempt to add Area GPRA Report for 2008 report option failed.." H 3
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
