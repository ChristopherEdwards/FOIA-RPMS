CIAZPLBB ;CIA/PLS - PCC Hook for Lab- Blood Bank data ;07-Sep-2004 19:36;DKM
 ;;1.1;VUECENTRIC RPMS SUPPORT;;Sep 14, 2004
 ;;Copyright 2000-2004, Clinical Informatics Associates, Inc.
 ;=================================================================
EN(DATA) N MSG
 I $D(DATA)=1 M MSG=@DATA
 E  M MSG=DATA
 ;D LOG(.MSG)
 ;check for PCC capture
 ;I $$QUEUE^CIAUTSK("TASK^CIAZPLBB","PCC VLAB FILER",,"MSG(")
 D TASK
 Q
 ; Log data
LOG(ARY,NMSP) ;
 S NMSP="CIAZPLBB"_$S($G(NMSP)="":"",1:"."_NMSP)
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
 S LOINC=$$LOINC^CIAZPLCH(TST,SPEC)          ; LOINC Code associated with test/specimen
 S (UNITS,RLOW,RHIGH,ORG,ATB)=""
 S FLN=$S(SUB="MI":.25,SUB="BB":.31,1:.09)   ; V File based on Subscript
 D GETCPT^CIAZPLCH(TST,ODT,.DAT)
 S CPTP=$G(DAT("CPTPTR"))
 S CPTCODE=$G(DAT("CPTCODES"))
 S ACT="LR"_$S(SUB="MI":"M",SUB="BB":"B",1:"C")_"+"  ;todo - are +- needed
 S (RES,AFLG,ORG,ATB,CMPDT)=""
 D ADD("HDR^^^"_LOC_";"_ODT_";"_CAT_";")
 D ADD("VST^PT^"_DFN)
 D ADD("VST^DT^"_ODT)
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
 N RES,AFLG,ORG,ATB,COLSPL,SUB,SPEC,RESDT,PTST
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
 S ACT="LR"_$S(SUB="MI":"M",SUB="BB":"B",1:"C")  ;todo - are +- needed
 S (TCST,RES,AFLG,ORG,ATB)=""
 D ADD("HDR^^^"_LOC_";"_ODT_";"_CAT_";")
 D ADD("VST^PT^"_DFN)
 D ADD("VST^DT^"_ODT)
 D GETCOM(.DAT)
 D:$D(DAT(1)) ADD("COM^1^"_DAT(1))
 D:$D(DAT(2)) ADD("COM^2^"_DAT(2))
 D:$D(DAT(3)) ADD("COM^3^"_DAT(3))
 ; Save OBR data
 S PTST=TST
 D SETADD
 F  S SEG=$$SEG("OBX",.LP) Q:'LP  D
 .S PTST=$P($P(SEG,DL1,4),U,4) Q:'$$VALTST(PTST)
 .I PTST["ANTIBODY SCREEN INTERPRETATION" D
 ..D COOMBS
 .E  I PTST["ABO INTERPRETATION"!(PTST["RH  INTERPRETATION") D
 ..S PTST=$TR(PTST,"  "," ")
 ..S RES=$P(SEG,DL1,6)
 ..D SETADD
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
SAVE L +^CIAZPLBB(OIEN):30
 I  D
 .D SAVE^CIAVCXPC(.ERR,.PCC)
 .L -^CIAZPLBB(OIEN)
 E  S ERR="-1^Timeout while trying to lock record."
 ;I 'ERR,ORD?2U,$L($T(@ORD)) D @ORD
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
 ; Return comments
GETCOM(ARY) ;
 N CNT,LP
 K ARY
 S CNT=0,LP=0
 F  S LP=$O(MSG(LP),-1) Q:'LP  I $E(MSG(LP),1,3)="NTE" D
 .S CNT=CNT+1,ARY(CNT)=$P(MSG(LP),DL1,4)
 Q
VALTST(TST) ;
 Q:TST="ANTIBODY SCREEN INTERPRETATION" 1
 Q:TST="ABO INTERPRETATION" 1
 Q:TST="RH  INTERPRETATION" 1
 Q 0
 ;
COOMBS ;
 N ATB
 S ATB=""
 I $E($G(DR),2,5)="LRBL" D
 .I $D(^LR(LRDFN,"BB",LRI,2)) D    ; Sets naked reference
 ..S RES=$P($G(^(2)),U,9)
 ..S PTST="DIRECT INTERPRETATION"
 ..D SETADD
 ..S ATB=0 F  S ATB=$O(^LR(LRDFN,"BB",LRI,"EA",ATB)) Q:'ATB  D
 ...S RES="POS"
 ...D SETADD
 .I $D(^LR(LRDFN,"BB",LRI,6)) D   ; Sets naked reference
 ..S RES=$G(^(6))
 ..S PTST="INDIRECT INTERPRETATION"
 ..D SETADD
 ..Q:RES="N"
 ..S RES="POS"
 ..S ATB=0 F  S ATB=$O(^LR(LRDFN,"BB",LRI,5,ATB)) Q:'ATB  D
 ...D SETADD
 Q
 ;
SETADD ;
 D ADD(ACT_U_PTST_U_FLN_U_VSTAT_U_ACC_U_LABORDF_U_ODT_U_CDT_U_PRV_U_TCST_U_SPEC_U_COLSPL_U_RES_U_CMPDT_U_ATB)
 Q
