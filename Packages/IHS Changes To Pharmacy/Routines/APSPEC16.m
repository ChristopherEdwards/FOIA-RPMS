APSPEC16 ;IHS/CIA/PLS - APSP ENVIRONMENT CHECK ROUTINE ;27-Sep-2013 11:23;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1016**;Sep 23, 2004;Build 74
 ;
ENV ;EP
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_", Patch 1016.",IOM)
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
 N DIU
 S DIU=9009033.91,DIU(0)="" D EN^DIU2
 S DIU=9009033.7,DIU(0)="D" D EN^DIU2
 D RENXPAR("APSP SS REFILL REQUEST","APSP SS RENEW REQUEST")
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
 ;Move the zero node of the APSP REFILL FILE to the 1 node and rebuild zero node
 D FIXNODE
 D MM
 D DELETE^XPDMENU("APSP MAIN MENU","APSP XPAR AUTOFINISH MAIN")
 D DELETE^XPDMENU("APSP MAIN MENU","APSP REFILL REQUESTS")
 D FIXVMEDD()
 D LNAME
 D XREF
 D FIXLBL
 D EN^XPAR("SYS","APSP SS PHARMACY MAILORDER",,"YES")
 N DATA,INSDT
 I $$INSTALDT^XPDUTL("APSP*7.0*1013",.DATA) D
 .S INSDT=$P($O(DATA(0)),".")
 .D FIXEXP(INSDT)
 Q
 ;
XREF ;EP-
 N DIK
 S DIK=$$ROOT^DILFD(9009033.91)
 S DIK(1)=".01"
 D ENALL^DIK
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
 ;
FIXEXP(INSDT) ; EP-
 N FDT,RX,DRG,EXTEXP,X2,NEXPDT,ISSDT,RX0
 S FDT=INSDT-.01 F  S FDT=$O(^PSRX("AD",FDT)) Q:'FDT  D
 .S RX=0 F  S RX=$O(^PSRX("AD",FDT,RX)) Q:'RX  D
 ..Q:'$$RMNRFL^APSPFUNC(RX)  ;quit if no remaining fills
 ..N DA,DR,DIE
 ..S RX0=^PSRX(RX,0)
 ..S DRG=+$P(RX0,U,6)
 ..S ISSDT=$P(RX0,U,13)
 ..Q:'$$ISSCH^APSPFNC2(DRG,"345")  ;quit if not a schedule 3-5 drug
 ..S EXTEXP=$$GET1^DIQ(50,DRG,9999999.08)
 ..S X2=$S(EXTEXP:EXTEXP,1:184)
 ..S NEXPDT=$$FMADD^XLFDT(ISSDT,X2)
 ..S DA=RX,DIE="^PSRX("
 ..S DR="26///"_NEXPDT D ^DIE
 ..W !,"Fixed Expiration date for RX IEN: "_RX
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
 ;
FIXLBL ;EP check for missing data in label
 N RDTE,RX
 S RDTE=3130301
 F  S RDTE=$O(^PSRX("AC",RDTE)) Q:RDTE=""  D
 .S RX="" F  S RX=$O(^PSRX("AC",RDTE,RX)) Q:RX=""  D
 ..D FIXLBL1(RX)
 Q
FIXLBL1(RX) ;Check label nodes
 N LBL,NODE,TYPE
 S LBL="" F  S LBL=$O(^PSRX(RX,"L",LBL)) Q:LBL=""  D
 .S NODE=$G(^PSRX(RX,"L",LBL,0))
 .I $P(NODE,U,4)="" S TYPE=$P(NODE,U,2) D FIXLBL2(LBL,RX,TYPE)
 Q
FIXLBL2(LBL,RX,TYPE) ;Update missing data
 N USER,AIEN,FDA,ERR
 S USER=""
 I TYPE=0 D
 .S USER=$P($G(^PSRX(RX,"OR1")),"^",5)
 .I USER="" S USER=$P($G(^PSRX(RX,2)),"^",3)
 I TYPE>0 D
 .S USER=$P($G(^PSRX(RX,1,TYPE,0)),U,7)
 .I USER="" S USER=$P($G(^PSRX(RX,1,TYPE,0)),U,5)
 I USER'="" D
 .S AIEN=LBL_","_RX_","
 .S FDA(52.032,AIEN,3)=USER
 .D UPDATE^DIE("","FDA","AIEN","ERR")
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
LNAME ;Loop through drugs and copy generic name to long name field
 N DRG,LNAME,NAM,FNUM
 S DRG=0 F  S DRG=$O(^PSDRUG(DRG)) Q:'+DRG  D
 .S NAM=$$GET1^DIQ(50,DRG,.01)
 .Q:NAM=""
 .S LNAME=$$GET1^DIQ(50,DRG,9999999.352)
 .Q:LNAME'=""
 .N FDA,IEN,ERR
 .S IEN=DRG_","
 .S FDA(50,IEN,9999999.352)=NAM
 .D UPDATE^DIE("","FDA","IEN","ERR")
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
