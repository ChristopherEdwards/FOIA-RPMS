BADEECP1 ;IHS/MSC/MGH - BADE ENVIRONMENT CHECK ROUTINE ;28-Jun-2010 16:21;MGH
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 ;
ENV ;EP
 N IN,PATCH,INSTDA,STAT
 ;Check for the installation of the EHR
 S IN="IHS PCC SUITE 2.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .D MES("You must first install the IHS PCC SUITE 2.0 before this patch",2)
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .D MES("IHS PCC SUITE 2.0 must be completely installed before installing this patch",2)
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;Check for the installation of the EDR
 S IN="DENTAL/EDR INTERFACE 1.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .D MES("You must first install the DENTAL/EDR INTERFACE 1.0 before this patch",2)
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .D MES("DENTAL/EDR INTERFACE 1.0 must be completely installed before installing this patch",2)
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
MES(TXT,QUIT) ;EP
 D BMES^XPDUTL("  "_$G(TXT))
 S:$G(QUIT) XPDABORT=QUIT
 Q
 ;
PRE ;EP - Pre-init
 Q
RENXPAR(OLD,NEW) ; Rename parameter
 N IEN,FDA,FIL
 S FIL=8989.51
 Q:$$FIND1^DIC(FIL,"","X",NEW)  ; New name already exists
 S IEN=$$FIND1^DIC(FIL,"","X",OLD)
 Q:'IEN  ; Old name doesn't exist
 S FDA(FIL,IEN_",",.01)=NEW
 D FILE^DIE("E","FDA")
 Q
POST ;EP
 N XMRG
 D EN^XPAR("SYS","BADE EDR PAUSE MRG LOAD",,"Y")
 D EN^XPAR("SYS","BADE EDR MRG DFN",,"")
 D EN^XPAR("SYS","BADE EDR MRG LOAD TSK",,"")
 D EN^XPAR("SYS","BADE EDR MRG TOTAL",,0)
 D EN^XPAR("SYS","BADE EDR MRG PTS ERRORS",,"")
 D EN^XPAR("SYS","BADE EDR MRG ERRORS",,0)
  ;CLEAN OUT OUT OF ORDER MESSAGES
 S MENU(1)="BADE EDR UPLOAD ALL MERGED PTS"
 S MENU(2)="BADE EDR PAUSE MRG LOAD"
 S MENU(3)="BADE EDR RESTART MRG UPLOAD"
 F I=1:1:3 D
 .N DA,DIE,DR
 .S MSG=""
 .S DA=$O(^DIC(19,"B",MENU(I),""))
 .I DA'=""  D
 ..S DIE="^DIC(19,",DR="2///@"
 ..D ^DIE
 ;
 ;Check and see if patient merge has been installed yet
 S XMRG=$$VERSION^XPDUTL("BPM")
 ;Check and see if patient merge patch 1 has been installed yet
 I 'XMRG D COMPLETE^BADEMRG("NO BPM") D BMES^XPDUTL("  Patient Merge not Installed")  ;SAIC/FJE DISPALY RESULTS
 D CKPATCH
 D BMES^XPDUTL("  Post Initialization Completed")  ;SAIC/FJE DISPLAY RESULTS
 Q
 ; Register a protocol to an extended action protocol
 ; Input: P-Parent protocol
 ;        C-Child protocol
 ;     SEQ-Sequence Number
REGPROT(P,C,SEQ,ERR) ;EP
 N IENARY,PIEN,AIEN,FDA
 D
 .I '$L(P)!('$L(C)) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .S AIEN=$$FIND1^DIC(101,"","",C)
 .I 'IENARY(1)!'AIEN S ERR="Unknown protocol name" Q
 .S FDA(101.01,"?+2,"_IENARY(1)_",",.01)=AIEN
 .S FDA(101.01,"?+2,"_IENARY(1)_",",3)=SEQ
 .D UPDATE^DIE("S","FDA","IENARY","ERR")
 ;Q:$Q $G(ERR)=""
 Q
 ; Return IEN to Clinic Stop Code file for given stop code
GETSC(SC) ;EP
 N RES
 S RES=$$FIND1^DIC(40.7,,,SC,"C")
 Q +RES
 ; Return first IEN to Hospital Location file for given stop code ien
GETHLOC(SIEN) ;EP
 N RES
 Q:'$G(SIEN) 0
 S RES=$O(^SC("ASTOP",SIEN,0))
 Q +RES
CKPATCH ;Only add protocol if BPM patch 1 is installed
 S PATCH="BPM*1.0*1"
 I $$PATCH^XPDUTL(PATCH) D REGPROT("BPM MERGE PATIENT ADT-A40","BADE MERGE PATIENT ADT-A40",967) D BMES^XPDUTL("  BADE Merge Protocol added")  ;SAIC/FJE DISPALY RESULTS
 I '$$PATCH^XPDUTL(PATCH) D BMES^XPDUTL("  BADE Merge Protocol Not Created")  ;SAIC/FJE DISPALY RESULTS
 Q
