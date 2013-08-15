BDW10P3 ; IHS/CMI/MAW - BDW Patch 3 Post Init ;
 ;;1.0;IHS DATA WAREHOUSE;**3**;JAN 23, 2006
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("BDW*1.0*2") D SORRY(2)
 I '$$INSTALLD("GIS*3.01*16") D SORRY(2)
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
EN ;-- main routine driver
 D GIS
 Q
 ;
GIS ;-- populate the PID-3 field of GIS, then recompile
 N BDWX
 S BDWX=$O(^INTHL7F("B","HL IHS DW1 PID-3",0))
 Q:'BDWX
 S ^INTHL7F(BDWX,5)="S X=$$UID^BDWAID(DFN)_""^""_DFN_""^""_$$ICN^BDWAID(DFN)"
 N I,BDWM
 F I="HL IHS DW1 A31","HL IHS DW1 A08","HL IHS DW1 A40" D
 . S BDWM=$O(^INTHL7M("B",I,0))
 . Q:'BDWM
 . D COMPILE^BHLU(BDWM)
 Q
 ;
