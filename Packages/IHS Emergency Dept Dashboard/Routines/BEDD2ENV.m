BEDD2ENV ;GDIT/HS/BEE-BEDD VERSION 2.0 ENV CHECK ROUTINE ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;;Jun 04, 2014;Build 13
 ;
 NEW VERSION,X
 ;
 ;Add code to check for Ensemble version greater or equal to 2012
 S VERSION=$$VERSION^%ZOSV
 I VERSION<2012 D BMES^XPDUTL("Ensemble 2012 or later is required!") S XPDQUIT=2 Q
 ;
 ;Check for AMER*3.0*6
 I '$$INSTALLD("AMER*3.0*6") D FIX(2)
 ;
 I $T(XML^BEDD2XML)="" D BMES^XPDUTL("The BEDD XML build bedd0200.xml must first be installed!") S XPDQUIT=2 Q
 ;
 Q
INSTALLD(BEDDSTAL) ;EP - Determine if patch BEDDSTAL was installed, where
 ; BEDDSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BEDDY,INST
 ;
 S BEDDY=$O(^XPD(9.7,"B",BEDDSTAL,""))
 S INST=$S(BEDDY>0:1,1:0)
 D IMES(BEDDSTAL,INST)
 Q INST
 ;
IMES(BEDDSTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BEDDSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
 ;
FIX(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of BEDD V2.0",IOM)
 Q
