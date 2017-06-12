BJPN20EN ;GDIT/HS/BEE-Prenatal Care Module 2.0 Env Checking ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;;Feb 24, 2015;Build 63
 ;
 ;Check for BMX*4.0*3
 I '$$INSTALLD("BMX*4.0*3") D FIX(2)
 ;
 ;Check for BJPC*2.0*11
 I '$$INSTALLD("BJPC*2.0*11") D FIX(2)
 ;
 ;Check for EHR*1.1*14
 I '$$INSTALLD("EHR*1.1*14") D FIX(2)
 ;
 ;Check for LEX*2.0*1003
 I '$$INSTALLD("LEX*2.0*1003") D FIX(2)
 ;
 ;Check for BSTS ICD10 Patch
 I $T(CCHK^BSTSVRSC)="" D
 . D MES^XPDUTL($$CJ^XLFSTR("The BSTS ICD-10 Patch is *NOT* installed.",IOM))
 . D FIX(2)
 I $T(CCHK^BSTSVRSC)]"" D MES^XPDUTL($$CJ^XLFSTR("The BSTS ICD-10 Patch is installed",IOM))
 ;
 ;Make sure DTS is working
 I $G(XPDQUIT)'=2 D
 . NEW STS
 . D EN^DDIOL("**Verifying that BSTS connection to DTS is working. This may take several minutes to complete**","","!!")
 . S STS=$$VALTERM^BSTSAPI("VAR","NORMAL PREGNANCY^^^2")
 . I +STS=2 D EN^DDIOL("**BSTS connection to DTS is working properly**","","!!") Q
 . D EN^DDIOL("**BSTS connection to DTS is not working properly. Please get it working before installing this build**","","!!")
 . S XPDQUIT=2
 Q
 ;
INSTALLD(BJPNSTAL) ;EP - Determine if patch BJPNSTAL was installed, where
 ; BJPNSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BJPNY,INST
 ;
 S BJPNY=$O(^XPD(9.7,"B",BJPNSTAL,""))
 S INST=$S(BJPNY>0:1,1:0)
 D IMES(BJPNSTAL,INST)
 Q INST
 ;
IMES(BJPNSTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BJPNSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
 ;
FIX(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of Prenatal 2.0",IOM)
 Q
