BDW10P1 ; IHS/CMI/LAB - PRE/POST INIT ;
 ;;1.0;IHS DATA WAREHOUSE;**1,2**;JAN 23, 2006
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("BDW*1.0*1") D SORRY(2)
 I '$$INSTALLD("GIS*3.01*15") D SORRY(2)
 ;
 Q
INSTALLD(BDWSTAL) ;EP - Determine if patch BDWSTAL was installed, where
 ; BDWSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BDWY,DIC,X,Y
 S X=$P(BDWSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BDWSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BDWSTAL,"*",3)
 D ^DIC
 S BDWY=Y
 D IMES
 Q $S(BDWY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BDWSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
POST ;EP
 NEW X
 S X=$$ADD^XPDMENU("BDWMENU","BDW REFLAG PATIENT FOR EXPORT","RPE")
 I 'X W "Attempt to add REFLAG PATIENT option failed." H 3
 S X=$$ADD^XPDMENU("BDWMENU","BDW INT MARK VISIT FOR EXPORT","UXP")
 I 'X W "Attempt to add Mark Unexported Patient option failed." H 3
 Q
