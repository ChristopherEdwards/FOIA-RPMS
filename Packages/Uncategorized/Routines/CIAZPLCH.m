CIAZPLCH ;CIA/PLS - PCC Hook for Lab- Chem data ;23-Apr-2004 11:11;PLS
 ;;1.1;VUECENTRIC RPMS SUPPORT;;Sep 14, 2004
 ;;Copyright 2000-2004, Clinical Informatics Associates, Inc.
 ;=================================================================
EN(DATA) N MSG
 I $D(DATA)=1 M MSG=@DATA
 E  M MSG=DATA
 D LOG(.MSG)
 ;I $$QUEUE^CIAUTSK("TASK^CIAZPLCH","PCC VLAB FILER",,"MSG(")
 D TASK
 Q
 ; Log data
LOG(ARY,NMSP) ;
 S NMSP="CIAZPLCH"_$S($G(NMSP)="":"",1:"."_NMSP)
 L +^XTMP(NMSP):2
 M ^($O(^XTMP(NMSP,""),-1)+1)=ARY
 L -^XTMP(NMSP)
 Q
TASK N SEG,LP,DL1,DL2,OIEN,ORD,ACC,STATUS,DFN,DAT,LOC,ERR,PCC,VSIT
 N CAT,CONTROL,LABORD,PRV,ODT,CDT,VLAB,SPEC,VSTAT,CPTP,CPTCODE
 N DAT,ACT,LOINC,DIAG,LODT,LSEQ
 S LP=0
 S SEG=$$SEG("MSH",.LP)
 Q:'LP
 S DL1=$E(SEG,4),DL2=$E(SEG,5)
 Q:$P(SEG,DL1,3)'="LABORATORY"
 S SEG=$$SEG("PID",.LP)
 Q:'LP
 S DFN=+$P(SEG,DL1,4)
 Q:'DFN
 S SEG=$$SEG("PV1",.LP)
 Q:'LP
 S LOC=+$P($P(SEG,DL1,4),DL2)
 S CAT=$S($P(SEG,DL1,3)="I":"I",1:"A")
 S SEG=$$SEG("ORC",.LP)
 Q:'LP
 S STATUS=$P(SEG,DL1,6)          ; Order status
 S OIEN=$P($P(SEG,DL1,3),DL2)    ; OE/RR order number
 Q:'OIEN                         ; Must have an OE/RR order number
 S LABORDF=$P($P(SEG,DL1,4),DL2) ; Lab order information
 S LABORD=$P(LABORDF,";")        ; Lab order number w/File 69 ref
 S LODT=$P(LABORDF,";",2)        ; Lab order date
 S LSEQ=$P(LABORDF,";",3)        ; Lab order seq number
 S CONTROL=$P(SEG,DL1,2)
 S PRV=+$P(SEG,DL1,13)                    ; Ordering Provider
 S ODT=$$FMDATE^LR7OU0($P(SEG,DL1,16))    ; Order effective Date/Time
 S CMPDT=$$FMDATE^LR7OU0($P($P(SEG,DL1,8),U,5))    ; Complete Date/Time
 ;
 I CONTROL?2U,$L($T(@CONTROL)) D @CONTROL
 Q
SN ; New Order
 ; Currently not used
 Q
SC ; Status Change
 N DAT,LP1,TSTARY,VSIT,ERR,TST,FLN,SUB,LOINC
 N RES,AFLG,ORG,ATB,COLSPL,CMPDT,UNITS,RLOW,RHIGH,ORG,ATB
 N CMPDT
 S SEG=$$SEG("OBR",.LP)
 Q:'LP
 S TST=+$P($P(SEG,DL1,5),DL2,4)     ; Primary test
 S CDT=$$FMDATE^LR7OU0($P(SEG,DL1,8))                ; Collection Date/Time
 S SPEC=$P($P($P(SEG,DL1,16),DL2,4),";")  ;Specimen pointer to File 61
 S COLSPL=$P($P(SEG,DL1,16),";",4)  ; Collection Sample to File 62
 S ACC=$P(SEG,DL1,21)               ; Accession Number
 S VSTAT="A"                        ; V File Status
 S TCST=$$GET1^DIQ(60,TST,1,"E")    ; Test cost
 S SUB=$$GET1^DIQ(60,TST,4,"I")     ; Subscript
 S LOINC=$$LOINC(TST,SPEC)          ; LOINC Code associated with test/specimen
 S (UNITS,RLOW,RHIGH,ORG,ATB)=""
 S FLN=$S(SUB="MI":.25,SUB="BB":.31,1:.09)   ; V File based on Subscript
 D GETCPT(TST,ODT,.DAT)
 S CPTP=$G(DAT("CPTPTR"))
 S CPTCODE=$G(DAT("CPTCODES"))
 S ACT="LR"_$S(SUB="MI":"M",SUB="BB":"B",1:"C")_"+"
 S (RES,AFLG,ORG,ATB,CMPDT)=""
 D ADD("HDR^^^"_LOC_";"_ODT_";"_CAT_";")
 D ADD("VST^PT^"_DFN)
 D ADD("VST^DT^"_ODT)
 ;D ADD("PRV^"_PRV_"^^^^1")  ;V Lab doesn't appear to set V Provider
 D ADD(ACT_U_TST_U_FLN_U_VSTAT_U_ACC_U_LABORDF_U_ODT_U_CDT_U_PRV_U_TCST_U_SPEC_U_COLSPL)
 D GETCOM(.DAT)
 D:$D(DAT(1)) ADD("COM^1^"_DAT(1))
 D:$D(DAT(2)) ADD("COM^2^"_DAT(2))
 D:$D(DAT(3)) ADD("COM^3^"_DAT(3))
 ; Add Panel Tests - returns expanded panel plus original test
 D EXPAND^LR7OU1(TST,.TSTARY)
 I $D(TSTARY) D
 .K TSTARY(TST)  ; remove original test
 .S TST="" F  S TST=$O(TSTARY(TST)) Q:TST=""  D
 ..S FLN=$S($$GET1^DIQ(60,TST,4,"I")="MI":.25,SUB="BB":.31,1:.09)   ; V File based on Subscript
 ..S TCST=$$GET1^DIQ(60,TST,1,"E")     ; Test Cost
 ..D ADD(ACT_U_TST_U_FLN_U_VSTAT_U_ACC_U_LABORDF_U_ODT_U_CDT_U_PRV_U_TCST_U_SPEC_U_COLSPL)
 D SAVE
 Q
 ;
RE ; Result Message
 N DAT,LP1,TSTARY,VSIT,ERR,TST,FLN,RLOW,RHIGH
 N RES,AFLG,ORG,ATB,COLSPL,SUB,SPEC,RESDT
 Q:$$FINDNODE(.MSG,"OBX")<0               ; Result message without OBX segment
 S SEG=$$SEG("OBR",.LP)
 Q:'LP
 S TST=+$P($P(SEG,DL1,5),DL2,4)           ; Primary test
 S CDT=$$FMDATE^LR7OU0($P(SEG,DL1,8))     ; Collection Date/Time
 S SPEC=$P($P($P(SEG,DL1,16),DL2,4),";")  ; Specimen pointer to File 61
 S COLSPL=$P($P(SEG,DL1,16),";",4)  ; Collection Sample to File 62
 S ACC=$P(SEG,DL1,21)                     ; Accession Number
 S VSTAT="R"                              ; V File Status
 S SUB=$$GET1^DIQ(60,TST,4,"I")
 S FLN=$S(SUB="MI":.25,SUB="BB":.31,1:.09)   ; V File based on Subscript
 S ACT="LR"_$S(SUB="MI":"M",SUB="BB":"B",1:"C")
 S (TCST,RES,AFLG,UNITS,RLOW,RHIGH,ORG,ATB)=""
 D ADD("HDR^^^"_LOC_";"_ODT_";"_CAT_";")
 D ADD("VST^PT^"_DFN)
 D ADD("VST^DT^"_ODT)
 D GETCOM(.DAT)
 D:$D(DAT(1)) ADD("COM^1^"_DAT(1))
 D:$D(DAT(2)) ADD("COM^2^"_DAT(2))
 D:$D(DAT(3)) ADD("COM^3^"_DAT(3))
 ; Save OBR data
 I ACT["LRM" D  ; Process Micro Results
 .D RE^CIAZPLMI
 E  D
 .D ADD(ACT_U_TST_U_FLN_U_VSTAT_U_ACC_U_LABORDF_U_ODT_U_CDT_U_PRV_U_TCST_U_SPEC_U_COLSPL_U_RES_U_CMPDT)
 .F  S SEG=$$SEG("OBX",.LP) Q:'LP  D
 ..S TST=+$P($P(SEG,DL1,4),U,4) Q:'TST
 ..S RES=$P(SEG,DL1,6)
 ..S UNITS=$P(SEG,DL1,7)
 ..S AFLG=$P(SEG,DL1,9)
 ..S RLOW=$$FREFRNG("L",TST,SPEC)
 ..S RHIGH=$$FREFRNG("H",TST,SPEC)
 ..D ADD(ACT_U_TST_U_FLN_U_VSTAT_U_ACC_U_LABORDF_U_ODT_U_CDT_U_PRV_U_TCST_U_SPEC_U_COLSPL_U_RES_U_CMPDT_U_AFLG_U_UNITS_U_RLOW_U_RHIGH_U_ORG_U_ATB)
 D SAVE
 Q
 ; Order Cancel message
OC ;
 N DAT,LP1,TSTARY,VSIT,ERR,TST,FLN,SUB,COLSPL
 S SEG=$$SEG("OBR",.LP)
 Q:'LP
 S TST=+$P($P(SEG,DL1,5),DL2,4)     ; Primary test
 S ACC=$P(SEG,DL1,21)               ; Accession Number
 S VSTAT="D"                        ; V File Status
 S SUB=$$GET1^DIQ(60,TST,4,"I")     ; Subscript
 S (TCST,UNITS,RLOW,RHIGH,ORG,ATB,COLSPL,CDT)=""
 S FLN=$S(SUB="MI":.25,SUB="BB":.31,1:.09)   ; V File based on Subscript
 S ACT="LR"_$S(SUB="MI":"M",SUB="BB":"B",1:"C")_"-"
 D ADD("HDR^^^"_LOC_";"_ODT_";"_CAT_";")
 D ADD("VST^PT^"_DFN)
 D ADD("VST^DT^"_ODT)
 D ADD(ACT_U_TST_U_FLN_U_VSTAT_U_ACC_U_LABORDF_U_ODT_U_CDT_U_PRV)
 ; Add Panel Tests - returns expanded panel plus original test
 D EXPAND^LR7OU1(TST,.TSTARY)
 I $D(TSTARY) D
 .K TSTARY(TST)  ; remove original test
 .S TST="" F  S TST=$O(TSTARY(TST)) Q:TST=""  D
 ..S FLN=$S($$GET1^DIQ(60,TST,4,"I")="MI":.25,SUB="BB":.31,1:.09)   ; V File based on Subscript
 ..D ADD(ACT_U_TST_U_FLN_U_VSTAT_U_ACC_U_LABORDF_U_ODT_U_CDT_U_PRV)
 D SAVE
 ;
SAVE L +^CIAZPLCH(OIEN):30
 I  D
 .D SAVE^CIAVCXPC(.ERR,.PCC)
 .L -^CIAZPLCH(OIEN)
 E  S ERR="-1^Timeout while trying to lock record."
 D:ERR BUL
 Q
 ; Add to PCC array
ADD(X,Y) ;
 I +$G(Y) D
 .S PCC(Y)=X
 E  S PCC=$G(PCC)+1,PCC(PCC)=X
 Q
 ; Find a node in PCC array
FINDNODE(ARY,VAL) ;
 N LP
 S LP=0 F  S LP=$O(ARY(LP)) Q:'LP  Q:$E(ARY(LP),1,$L(VAL))=VAL
 Q $S(LP:LP,1:-1)
 ; Return reference range for given test and specimen
FREFRNG(TYPE,TST,SPEC) ;
 N AGE,SEX,SNODE,VAL
 S TYPE=$G(TYPE,"L")
 S AGE=$$GET1^DIQ(2,DFN,.033,"E")
 S SEX=$$GET1^DIQ(2,DFN,.02,"I")
 S SNODE=$G(^LAB(60,TST,1,SPEC,0))
 I $L(SNODE) D
 .S VAL=$P(SNODE,U,$S(TYPE="H":3,1:2))
 .X:VAL'?.N!(VAL'="") "S VAL="_VAL
 Q VAL
 ; Return specified segment, starting at line LP
SEG(TYP,LP) ;
 F  S LP=$O(MSG(LP)) Q:'LP  Q:$E(MSG(LP),1,$L(TYP))=TYP
 Q $S(LP:MSG(LP),1:"")
 ; Send a bulletin on error
BUL N XMB,XMTEXT,XMY,XMDUZ,XMDT,XMYBLOB,XMZ
 S XMB="APCD PCC PACKAGE LINK FAIL"
 S XMB(1)=OIEN
 S XMB(2)=$P($G(^DPT(DFN,0)),U)
 S XMB(3)=LABORD
 S XMB(4)=$$FMTE^XLFDT(ODT)
 S XMB(5)=$P(ERR,U,2)
 S XMDUZ=.5
 D ^XMB
 Q
 ; Return CPT code for given test
GETCPT(TST,ODTM,DAT) ;
 ;Input: TST - pointer to File 60
 ;       ODTM - Order Date/Time
 N PTST,FND,LP,CPTP,CPCODE,CPCOST,CPRC,CPAC
 N CPDAT,MOD,QUAL,CPTCODES
 S FND=0,PTST=0,(MOD,QUAL,CPTCODES)=""
 K DAT
 F  S PTST=$O(^BLRCPT("C",TST,PTST)) Q:'PTST!FND  D
 .Q:$$GET1^DIQ(9009021,PTST,102,"I")  ; Inactive Flag
 .Q:ODTM<$$GET1^DIQ(9009021,PTST,.03,"I")  ; Order Date>Create Date
 .D GETCPT1
 .S DAT("CPTPTR")=PTST
 .S DAT("CPTCODES")=CPTCODES
 Q
GETCPT1 ;
 S FND=1
 S CPTP=0 F  S CPTP=$O(^BLRCPT(PTST,11,CPTP)) Q:'CPTP  D
 .S CPDAT=$G(^BLRCPT(PTST,11,CPTP,0))
 .S CPCODE=$P(CPDAT,U),CPCOST=$P(CPDAT,U,2),CPRC=$P(CPDAT,U,3),CPAC=$P(CPDAT,U,4)
 .S LP=0 F  S LP=$O(^BLRCPT(PTST,11,CPTP,1,LP)) Q:'LP  D
 ..S MOD=MOD_^BLRCPT(PTST,11,CPTP,1,LP,0)_","
 .S:$E(MOD,$L(MOD))="," MOD=$E(MOD,1,$L(MOD)-1)
 .S LP=0 F  S LP=$O(^BLRCPT(PTST,11,CPTP,2,LP)) Q:'LP  D
 ..S QUAL=QUAL_^BLRCPT(PTST,11,CPTP,2,LP,0)_","
 .S:$E(QUAL,$L(QUAL))="," QUAL=$E(QUAL,1,$L(QUAL)-1)
 .S CPTCODES=CPTCODES_CPCODE_DL1_CPCOST_DL1_CPRC_DL1_CPAC_DL1_MOD_DL1_QUAL_";"
 S:$E(CPTCODES,$L(CPTCODES))=";" CPTCODES=$E(CPTCODES,1,$L(CPTCODES)-1)
 Q
 ; Return comments
GETCOM(ARY) ;
 N CNT,LP
 K ARY
 S CNT=0,LP=0
 F  S LP=$O(MSG(LP),-1) Q:'LP  I $E(MSG(LP),1,3)="NTE" D
 .S CNT=CNT+1,ARY(CNT)=$P(MSG(LP),DL1,4)
 Q
 ; Return LOINC code
 ; Input: TST - Laboratory Test File IEN
 ;        SPEC - Site/Specimen IEN
LOINC(TST,SPEC) ;
 Q $$GET1^DIQ(60.01,SPEC_","_TST_",",95.3,"I")
 ; Return Diagnosis stored in Lab Order File
 ; Input: TST - Laboratory Test File IEN
 ;        ODT - Lab Order File Date
 ;        SEQ - Lab Order File Date Sequence number
DIAG(TST,ODT,SEQ) ;
 N TIEN
 S TIEN=$O(^LRO(69,ODT,1,SEQ,2,"B",TST,""))
 Q $$GET1^DIQ(69.03,TIEN_","_SEQ_","_ODT_",",9999999.1)
