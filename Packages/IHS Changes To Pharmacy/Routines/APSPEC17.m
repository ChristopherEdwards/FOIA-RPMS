APSPEC17 ;IHS/CIA/PLS - APSP ENVIRONMENT CHECK ROUTINE ;04-Apr-2014 09:38;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1017**;Sep 23, 2004;Build 40
 ;
ENV ;EP
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_", Patch 1017.",IOM)
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ; Suppress the Disable options and Move routines prompts
 S XPDABORT=0
 D CHKINS^CIAOINIT("APSP ZIP CODE 2.0",1)
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
 D LOCKPOV
 D PAR
 D SUPALL^APSPRCUI
 D ROUTES^APSPRCUI
 D ADDMENU
 D ZCXREF
 I $$REGRPC^CIAURPC("PSB VALIDATE SCANNED MED","PSB GUI CONTEXT - USER")
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
 ; Lock down and mark all POV related fields and parameters
LOCKPOV ;EP-
 D UPDPAR("SYS","APSP POV CACHE")
 Q
 ;
UPDPAR(ENT,PARAM,VAL) ;EP-
 N IEN
 S IEN=$O(^XTV(8989.51,"B",PARAM,0))
 Q:'IEN
 S $P(^XTV(8989.51,IEN,0),U,6)=0
 D:$G(VAL)'="" EN^XPAR(ENT,PARAM,,VAL)
 S $P(^XTV(8989.51,IEN,0),U,6)=1
 Q
PAR ;Set system level for new parameter
 D EN^XPAR("SYS","APSP RXNORM NDC LOOKUP",,"L")
 Q
ADDMENU ;Add items to a menu
 D REGMENU^BEHUTIL("APSP MU MENU",,"MU","APSP MAIN MENU")
 ;D REGMENU^BEHUTIL("APSPRCUI UPDATE",,"RXN","APSP MAIN MENU")
 ;D REGMENU^BEHUTIL("APSP DRUGS W/O RXNORM",,"WOR","APSP MAIN MENU")
 ;D REGMENU^BEHUTIL("APSP REMAP RXNORM",,"REM","APSP MAIN MENU")
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
 ; UnRegister a protocol from an extended action protocol
 ; Input: P-Parent protocol
 ;        C-Child protocol
UREGPROT(P,C,ERR) ;EP-
 N IENARY,PIEN,AIEN,FDA
 D
 .I '$L(P)!('$L(C)) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .S AIEN=$$FIND1^DIC(101,"","",C)
 .I 'IENARY(1)!'AIEN S ERR="Unknown protocol name" Q
 .S IENARY(2)=$$FIND1^DIC(101.01,","_IENARY(1)_",","",C)
 .S FDA(101.01,IENARY(2)_","_IENARY(1)_",",.01)="@"
 .D UPDATE^DIE("S","FDA","","ERR")
 Q
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
 ; Fix Out of Order Message and lock with APSP Key
OFOMSG(OPT,MSG,KEY) ;
 N IEN,VAL,FDA,KIEN
 S IEN=$$FIND1^DIC(19,,"X",OPT)
 S KIEN=$$FIND1^DIC(19.1,,"X",KEY)
 I IEN D
 .S VAL=$S($L($G(MSG)):MSG,1:"Not used in IHS")
 .S FDA(19,IEN_",",2)=VAL
 .S:KIEN FDA(19,IEN_",",3)=KIEN
 .D FILE^DIE("K","FDA")
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
FIXNODE ;EP
 N IEN,NODE,INST,FN,FDA,IENS,ERR,DOSE,DISP,UNITS,UNIT,NOUN
 S FN=9009033.912
 S IEN=0 F  S IEN=$O(^APSPRREQ(IEN)) Q:'+IEN  D
 .S INST=0 F  S INST=$O(^APSPRREQ(IEN,2,INST)) Q:'+INST  D
 ..S IENS=INST_","_IEN_","
 ..S NODE=$G(^APSPRREQ(IEN,2,INST,0))
 ..Q:$D(^APSPRREQ(IEN,2,INST,1))     ;Quit if already converted
 ..S DOSE=$P(NODE,U,1)
 ..S FDA(FN,IENS,1.1)=DOSE           ;Dosage ordered
 ..S DISP=$P(NODE,U,2)
 ..S FDA(FN,IENS,1.2)=DISP           ;Dispense per dose
 ..S UNITS=$P(NODE,U,3)
 ..S UNIT=$$GET1^DIQ(50.607,UNITS,.01)
 ..S FDA(FN,IENS,1.3)=UNIT           ;Units
 ..S NOUN=$P(NODE,U,4)
 ..S FDA(FN,IENS,1.4)=NOUN           ;noun
 ..S FDA(FN,IENS,1.5)=$P(NODE,U,5)   ;duration
 ..S FDA(FN,IENS,1.6)=$P(NODE,U,6)   ;conjunction
 ..S FDA(FN,IENS,1.7)=$P(NODE,U,7)   ;route
 ..S FDA(FN,IENS,1.8)=$P(NODE,U,8)   ;schedule
 ..S FDA(FN,IENS,1.9)=$P(NODE,U,9)   ;route
 ..;S FDA(FN,IENS,.01)=DOSE_"&"_UNIT_"&"_DISP_"&"_NOUN_"&"_DOSE_UNIT
 ..D UPDATE^DIE("","FDA","IENS","ERR")
 ..S ^APSPRREQ(IEN,2,INST,0)=DOSE_"&"_UNIT_"&"_DISP_"&"_NOUN_"&"_DOSE_UNIT
 ..K FDA,IENS,ERR
 ..K ^APSPRREQ(IEN,2,"B",DOSE,INST)
 Q
 ; Fix VMed entries lacking Date Discontinued
FIXVMEDD(DAYS) ;EP -
 N RX,BDT,EDT,FDT,VMED,ACT
 S EDT=$$DT^XLFDT()
 S BDT=$$FMADD^XLFDT(EDT,-$G(DAYS,730))
 S FDTLP=BDT-.01
 F  S FDTLP=$O(^PSRX("AD",FDTLP)) Q:'FDTLP!(FDTLP>EDT)  D
 .S RX=0
 .F  S RX=$O(^PSRX("AD",FDTLP,RX)) Q:'RX  D
 ..Q:$G(^PSRX(RX,"STA"))'=15        ;status not Discontinued (Edit)
 ..S VMED=+$G(^PSRX(RX,999999911))
 ..Q:'VMED
 ..Q:$P($G(^AUPNVMED(VMED,0)),U,8)  ;already marked as discontinued
 ..;Check last activity node for a discontinued type
 ..S ACT=$P($G(^PSRX(RX,"A",0)),U,4)
 ..Q:'ACT
 ..S ACT=$G(^PSRX(RX,"A",ACT,0))
 ..I $P(ACT,U,2)="C" D
 ...S $P(^AUPNVMED(VMED,0),U,8)=$P(+ACT,".")
 Q
 ; Send Quantity Qualifier MailMan message
MM ;EP-
 N LP,XMTEXT,XMY,XMSUB,XMDUZ,DA,DIFROM,CNT,DATA
 N QQARY,DNM,QQNM,STR,X
 K ^TMP("DATA",$J)
 F LP=0:1 S X=$P($T(IENS+LP),";;",2) Q:'$L(X)  D
 .D SEARCH(+X)
 I $D(^TMP("DATA",$J)) D
 .S DATA=$NA(^TMP("APSP1016Z",$J))
 .K @DATA
 .S XMTEXT="^TMP(""APSP1016Z"",$J,"
 .S XMDUZ="NDF MANAGER"
 .S XMSUB="DRUGS ASSOCIATED WITH INACTIVATED QUANTITY QUALIFIERS"
 .D BLDTXT
 .S CNT=7
 .S DNM="" F  S DNM=$O(^TMP("DATA",$J,DNM)) Q:DNM=""  D
 ..S QQNM="" F  S QQNM=$O(^TMP("DATA",$J,DNM,QQNM)) Q:QQNM=""  D
 ...S X=^TMP("DATA",$J,DNM,QQNM)
 ...S STR=DNM,$E(STR,52)=+X,$E(STR,59)=QQNM
 ...S CNT=CNT+1
 ...S @DATA@(CNT)=STR
 .S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 .S XMY("G.NDF DATA@"_^XMB("NETNAME"))=""
 .D ^XMD
 Q
 ;
 ;Add fixed text to message global
BLDTXT ;EP-
 S @DATA@(1)="The following entries in your DRUG file (#50) are associated with"
 S @DATA@(2)="NCPDP Quantity Qualifiers in the APSP NCPDP Control Codes file."
 S @DATA@(3)="It is critical that you rematch these products immediately so that"
 S @DATA@(4)="the Surescripts interface will continue to work without errors."
 S @DATA@(5)=""
 S @DATA@(6)="DRUG                                               IEN    QTY QUALIFIER"
 S @DATA@(7)=""
 Q
SEARCH(QQ) ;EP- Given qualifier return list of drug file entries linked to quantity qualifier
 N DIEN,DRGQQ
 S DIEN=0 F  S DIEN=$O(^PSDRUG(DIEN)) Q:'DIEN  D
 .S DRGQQ=+$P($G(^PSDRUG(DIEN,9999999.145)),U)
 .Q:DRGQQ'=QQ
 .S ^TMP("DATA",$J,$$GET1^DIQ(50,DIEN,.01),$$GET1^DIQ(9009033.7,QQ,.01))=DIEN_U_QQ_U_$$GET1^DIQ(9009033.7,QQ,1)
 Q
IENS ;;147
 ;;150
 ;;154
 ;;155
 ;;167
 ;;
