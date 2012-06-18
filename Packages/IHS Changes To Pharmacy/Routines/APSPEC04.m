APSPEC04 ;IHS/CIA/PLS - APSP ENVIRONMENT CHECK ROUTINE ;23-May-2006 20:58;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1004**;DEC 11, 2003
 ;
ENV ;EP
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_", Patch 1004.",IOM)
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ; Suppress the Disable options and Move routines prompts
 S XPDABORT=0
 D:'$D(^XPD(9.7,"B","PIMS*5.3*1004")) MES("Patch PIMS*5.3*1004 is required and hasn't been installed.",2)
 D:'$D(^XPD(9.7,"B","APSP*7.0*1003")) MES("Patch APSP*7.0*1003 is required and hasn't been installed.",2)
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
 D REMXPAR("CIAZPRX PHARMACY LOCATION") ; Remove existing values for parameter
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
 ;
REMXPAR(PAR) ;Remove values stored for a given parameter
 N PIEN,ENT,INT,VIEN,DIK,DA
 S PIEN=$O(^XPAR(8989.51,"B",PAR,0))
 Q:'PIEN
 S ENT=0 F  S ENT=$O(^XPAR(8989.5,"AC",PIEN,ENT)) Q:ENT=""  D  ;Entity
 .S INT=0 F  S INT=$O(^XPAR(8989.5,"AC",PIEN,ENT,INT)) Q:INT=""  D  ;Instance
 ..S DA=0 F  S DA=$O(^XPAR(8989.5,"AC",PIEN,ENT,INT,DA)) Q:'DA  D  ;Value IEN
 ...S DIK="^XTV(8989.5," D ^DIK
 Q
POST ;EP
 D REGPROT^CIAURPC("PS EVSEND OR","IHS PS HOOK")
 D FIXCMF
 Q
 ;
FIXCMF ; EP - Remove Chronic Med Flag for Discontinued/Deleted Medications
 N RX,CNT
 D MES("Removing Chronic Med flag on Discontinued/Deleted Medications...")
 W !!
 S (CNT,RX)=0 F  S RX=$O(^PSRX(RX)) Q:'RX  D
 .S ST=+$P($G(^PSRX(RX,"STA")),U)
 .S CNT=CNT+1
 .I ST>11&(ST<16) D
 ..D KILLOCM^PSORN52(RX)
 .W:'(CNT#100) "."
 Q
