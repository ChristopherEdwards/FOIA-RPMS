BADEENV2 ;IHS/MSC/MGH - BADE ENVIRONMENT CHECK ROUTINE PATCH 2;20-Feb-2013 16:21;FJE
 ;;1.0;DENTAL/EDR INTERFACE;**1,2**;FEB 20, 2013;Build 7
 ;
ENV ;EP
 N IN,PATCH,INSTDA,STAT
 ;Check for the installation of the EDR Patch 1
 S IN="BADE*1.0*1",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .D MES("You must first install the DENTAL/EDR INTERFACE BADE Patch 1 before this patch",2)
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .D MES("DENTAL/EDR INTERFACE BADE Patch 1 must be completely installed before installing this patch",2)
 ;
 ;Check for the installation of the AGG Patch 1
 S IN="AGG*1.0*1",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .D MES("You must first install the Patient Registration GUI Version 1.0 Patch 1 before this patch",2)
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .D MES("Patient Registration GUI Patch 1 must be completely installed before installing this patch",2)
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
MES(TXT,QUIT) ;EP
 D BMES^XPDUTL("  "_$G(TXT))
 S:$G(QUIT) XPDABORT=QUIT
 Q
 ;
