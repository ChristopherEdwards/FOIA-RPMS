APSPEC03 ;IHS/CIA/PLS - APSP ENVIRONMENT CHECK ROUTINE ;24-Aug-2005 10:43;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1003**;DEC 11, 2003
 ;
ENV ;EP
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_", Patch 1003.",IOM)
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ; Suppress the Disable options and Move routines prompts
 S XPDABORT=0
 D:'$D(^XPD(9.7,"B","PIMS*5.3*1002")) MES("Patch PIMS*5.3*1002 is required and hasn't been installed.",1)
 D:'$D(^XPD(9.7,"B","APSP*7.0*1002")) MES("Patch APSP*7.0*1002 is required and hasn't been installed.",1)
 I 'XPDABORT D
 .W !!,"All requirements for installation have been met...",!
 E  D
 .W !!,"Unable to continue with the installation...",!
 Q
 ;
MES(TXT,QUIT) ;EP
 D BMES^XPDUTL("  "_$G(TXT))
 S:$G(QUIT) XPDABORT=QUIT
 Q
 ;
PRE ;EP - Pre-init
 D RENXPAR("CIAZPRX LOG MESSAGES","APSPPCC LOG MESSAGES")
 Q
RENXPAR(OLD,NEW) ; Rename parameter
 N IEN,FDA,FIL
 S FIL=8989.51
 Q:$$FIND1^DIC(FIL,,"X",NEW)  ; New name already exists
 S IEN=$$FIND1^DIC(FIL,,"X",OLD)
 Q:'IEN  ; Old name doesn't exist
 S FDA(FIL,IEN_",",.01)=NEW
 D FILE^DIE("E","FDA")
 Q
POST ;EP
 D REGPROT^CIAURPC("PS EVSEND OR","IHS PS HOOK")
 Q
