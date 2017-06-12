BADEENV4 ;IHS/MSC/MGH - BADE ENVIRONMENT CHECK ROUTINE PATCH 4;10-JUL-2015 16:21;GAB
 ;;1.0;DENTAL/EDR INTERFACE;**1,2.4**;FEB 22, 2010;Build 12
 ;
ENV ;EP
 N IN,PATCH,INSTDA,STAT
 W !,"Checking environment ....",!
 ;Check for the installation of the EDR Patch 3
 S IN="BADE*1.0*3",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .D MES("You must first install the DENTAL/EDR INTERFACE BADE Patch 3 before this patch",2)
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .D MES("DENTAL/EDR INTERFACE BADE Patch 1 must be completely installed before installing this patch",2)
 ; now check the DUZ ..
 I '$G(IOM) D HOME^%ZIS
 I '$G(DUZ) W !,"YOUR DUZ VARIABLE IS UNDEFINED!! Please login with your Access & Verify." D SORRY(2) Q
 I '$L($G(DUZ(0))) W !,"Your DUZ(0) VARIABLE IS UNDEFINED OR NULL." D SORRY(2) Q
 I '(DUZ(0)["@") W:'$D(ZTQUEUED) !,"YOUR DUZ(0) VARIABLE DOES NOT CONTAIN AN '@'." D SORRY(2)
 Q
MES(TXT,QUIT) ;EP
 D BMES^XPDUTL("  "_$G(TXT))
 S:$G(QUIT) XPDABORT=QUIT
 Q
 ;
SORRY(X) ;
 K DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....Please fix it.",40)
 Q
