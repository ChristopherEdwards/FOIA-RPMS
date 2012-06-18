APSPEC07 ;IHS/CIA/PLS - APSP ENVIRONMENT CHECK ROUTINE ;09-Oct-2008 06:59;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1007**;DEC 11, 2003
 ;
ENV ;EP
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_", Patch 1007.",IOM)
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ; Suppress the Disable options and Move routines prompts
 S XPDABORT=0
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
 D EN^XPAR("SYS","APSP AUTO RX ADD PRV COMMENT",,"Y")
 D EN^XPAR("SYS","APSP AUTO RX ELECTRONIC",,"N")
 D ORRPFIX  ; Fix OE/RR BCMA reports
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
 ; Fix ROUTINE value in ORRP BCMA MAH and ORRP BCMA MED LOG reports
ORRPFIX ;EP -
 N I,IEN
 F I="ORRP BCMA MAH","ORRP BCMA MED LOG" D
 .S IEN=$O(^ORD(101.24,"B",I,0)) Q:'IEN  D
 ..S $P(^ORD(101.24,IEN,0),U,5)="ORWRP1A"
 Q
