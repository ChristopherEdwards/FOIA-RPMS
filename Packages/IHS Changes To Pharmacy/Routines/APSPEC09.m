APSPEC09 ;IHS/CIA/PLS - APSP ENVIRONMENT CHECK ROUTINE ;16-Nov-2010 11:37;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1009**;Sep 23, 2004
 ;
ENV ;EP
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_", Patch 1009.",IOM)
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
 N ID
 I '$D(^DD(50,9999999.41,0)) D
 .S ^DD(50,9999999.41,0)="OUTPATIENT SITE^50.999999941PA^^9999999.41;0"
 .S ^DD(50.999999941,0)="OUTPATIENT SITE SUB-FIELD^^.01^1"
 .;S ^DD(50.999999941,0,"NM","OUTPATIENT SITE")=""
 ;
 S ^DD(50,0,"SCR")="I $$SCREEN^APSPMULT(+$G(Y))"  ;Apply division screen
 S ID=$P(^PSDRUG(0),U,2) I ID'["s" S ID=ID_"s" S $P(^PSDRUG(0),U,2)=ID
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
 N I,A,INST,VAL
 D CLN50DD
 ;populate parameter with supported options
 F I=1:1 S A=$T(OPTIONS+I) S A=$P(A,";;",2) Q:A=""  S INST=$P(A,U),VAL=1 D
 .D EN^XPAR("SYS","APSP MULTI DRUG SCREEN OPTION",INST,VAL)
 D CLNNVA
 D MOVPRF
 ;D REGPROT("AVA PROVIDER UPDATE MFN_M02","APSP ERX MFN UPDATE",400)
 D EN^XPAR("SYS","APSP SS HLO RETENTION DAYS",,7)
 Q
 ; Add given namespace to Application
AAPPGRP(FILE,NMSP) ;EP
 N FDA,IEN,ERR
 Q:'$G(FILE)!('$L(NMSP))
 S FDA(1.005,"?+1,"_FILE_",",.01)=NMSP
 D UPDATE^DIE("","FDA","IEN","ERR")
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
 ;
SETPKGV(PKG,VER) ;EP
 N PIEN,FDA
 S PIEN=$$FIND1^DIC(9.4,,,PKG)
 Q:'PIEN
 S FDA(9.4,PIEN_",",13)=VER
 D UPDATE^DIE(,"FDA")
 Q
 ; Cleanup Drug File DD
CLN50DD ;EP -
 S DIU=50.03,DIU(0)="SD" D EN^DIU2
 Q
 ; Cleanup PCC Link in NVA node
CLNNVA ;EP -
 N DFN,IEN,FDA,NVAERR
 S DFN=0 F  S DFN=$O(^PS(55,"APCC","+1",DFN)) Q:'DFN  D
 .S IEN=0 F  S IEN=$O(^PS(55,"APCC","+1",DFN,IEN)) Q:'IEN  D
 ..S FDA(55.05,IEN_","_DFN_",",9999999.11)="@"
 D:$D(FDA) UPDATE^DIE("","FDA",,"NVAERR")
 W:$G(DIERR) $G(NVAERR("DIERR",1,"TEXT",1))
 Q
 ; Move Paperles Refill POV nodes from ^XTMP to Parameter
MOVPRF ;EP -
 N RXIEN,RFIEN,POV
 S RXIEN=0
 F  S RXIEN=$O(^XTMP("APSPPCC.VPOV",RXIEN)) Q:'RXIEN  D
 .S RFIEN=0 F  S RFIEN=$O(^XTMP("APSPPCC.VPOV",RXIEN,RFIEN)) Q:'RFIEN  D
 ..S POV=$G(^XTMP("APSPPCC.VPOV",RXIEN,RFIEN))
 ..Q:'$L(POV)
 ..D ADD^XPAR("SYS","APSP POV CACHE",+RXIEN_","_+RFIEN,$TR(POV,U,"~"))
 Q
 ; Set Mail field in File 55 to DO NOT MAIL if not defined
PPMAIL ;EP -
 N DFN
 S DFN=0
 F  S DFN=$O(^PS(55,DFN)) Q:'DFN  D
 .Q:$L($P($G(^PS(55,DFN,0)),U,3))
 .S $P(^PS(55,DFN,0),U,3)=2
 Q
OPTIONS ;
 ;;PSO LM BACKDOOR ORDERS
 ;;PSJ OE
 ;;PSO RXEDIT
 ;;PSJI ORDER
