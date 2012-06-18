APSPEC06 ;IHS/CIA/PLS - APSP ENVIRONMENT CHECK ROUTINE ;03-Jan-2008 11:36;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1006**;DEC 11, 2003
 ;
ENV ;EP
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_", Patch 1006.",IOM)
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ; Suppress the Disable options and Move routines prompts
 S XPDABORT=0
 D:'$L($G(^APSPZCPX(33331,0))) MES("APSP ZIP CODE 1.0 build is required and hasn't been installed.",2)
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
 D EN^XPAR("SYS","APSP ZIPCODE PROXIMITY RADIUS",,50)
 D REGPROT("PS EVSEND OR","APSP AUTO RX",30)
 D ZCXREF
 Q
 ;
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
 ; Create "B" xref for ZipCodes
ZCXREF ;EP
 D MES("Building ZipCode Proximity crossreference (a '.' represents 100 entries)")
 N ZC
 S ZC=0 F  S ZC=$O(^APSPZCPX(ZC)) Q:'ZC  D
 .D ONEZC(ZC)
 .W:'(ZC#100) "."
 Q
 ;
ONEZC(ZC) ;EP
 N LP,DAT
 K ^APSPZCPX(ZC,1,"B")
 S LP=0 F  S LP=$O(^APSPZCPX(ZC,1,LP)) Q:'LP  D
 .S DAT=^APSPZCPX(ZC,1,LP,0)
 .S ^APSPZCPX(ZC,1,"B",$P(DAT,U,2),LP)=""
 Q
