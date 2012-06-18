BGOVIMM ;IHS/BAO/TMD - IMMUNIZATION mgt   ;27-Jun-2011 17:03;PLS
 ;;1.1;BGO COMPONENTS;**1,3,4,5,6,9**;Mar 20, 2007;Build 2
 ; Returns the version # of the Immunization package
VERSION(RET,DUMMY) ;
 S RET=$$VER^BILOGO
 Q
 ; Return the ICD9 code IEN for a vaccine
IMMICD(TYPE,VIEN,ACTV) ;EP
 N X,ICD,ICDIEN,DATE
 S ICD=$P($G(^AUTTIMM(TYPE,0)),U,14),ICDIEN=""
 I ICD'="" D
 .S ICDIEN=$O(^ICD9("AB",ICD,0))
 .S:'ICDIEN ICDIEN=$O(^ICD9("AB",ICD_" ",0))
 I ICDIEN,$G(ACTV) D
 .S DATE=$S($G(VIEN):+$G(^AUPNVSIT(VIEN,0)),1:"")
 .S X=$$CHKICD^BGOVPOV(ICDIEN,DATE)
 .S:X<0 ICDIEN=X
 Q ICDIEN
 ; Return the CPT code IEN for a vaccine and visit
IMMCPT(TYPE,VIEN,ACTV) ;EP
 N X,CVX,CPT,AGE,DFN,DATE
 Q:'VIEN $$ERR^BGOUTL(1002)
 S DFN=$P($G(^AUPNVSIT(VIEN,0)),U,5),DATE=+$G(^(0))
 Q:'DFN!'DATE $$ERR^BGOUTL(1003)
 S AGE=$$PTAGE^BGOUTL(DFN,DATE)
 S X=$G(^AUTTIMM(TYPE,0))
 S CVX=$P(X,U,3)
 S CPT=$P(X,U,11)
 I CVX=15 S CPT=$S(AGE>2:90658,1:90657)  ;ihs=90757
 E  I CVX=43 S CPT=$S(AGE>18:90746,1:90743) ;ihs=90743
 E  I CVX=111 S CPT=90660    ;ihs=none
 I CPT,$G(ACTV) D
 .S X=$$CHKCPT^BGOVCPT(CPT,DATE)
 .S:X<0 CPT=X
 Q CPT
 ; Get the patient's immunization defaults and contraindications
 ;  INP = Patient IEN ^ Immunization Type IEN
 ;  Returned as:
 ;   RET(0) = Default Lot # [1] ^ Default Volume [2] ^ Default VIS Date [3]
 ;   RET(n) = Contraindication IEN [1] ^ Contraindication Text [2] ^ Date Noted [3]
LOADIMM(RET,INP) ;EP
 N DFN,IMM,X,N,D,DFLTLOT,DFLTVOL,DFLTVISD,CNT
 S RET(0)=$$ERR^BGOUTL(1008)
 S DFN=+INP
 Q:'DFN
 S IMM=+$P(INP,U,2)
 Q:'IMM
 S X=$G(^AUTTIMM(IMM,0))
 S DFLTLOT=$P(X,U,4)
 S DFLTVOL=$P(X,U,18)
 S DFLTVISD=$$FMTDATE^BGOUTL($P(X,U,13))
 S RET(0)=DFLTLOT_U_DFLTVOL_U_DFLTVISD
 S (X,CNT)=0
 F  S X=$O(^BIPC("AC",DFN,IMM,X)) Q:'X  D
 .S N=$P($G(^BIPC(X,0)),U,3),D=$P(^(0),U,4)
 .Q:'N
 .Q:$P($G(^BICONT(N,0)),U,2)
 .S CNT=CNT+1,RET(CNT)=N_U_$P($G(^BICONT(N,0)),U)_U_D
 Q
 ; Get immunization history
 ;  INP = Patient IEN [1] ^ Record Types [2]
 ;  RET returned as a list of records in one of the following formats:
 ;  For immunizations:
 ;    I ^ Imm Name [2] ^ Visit Date [3] ^ V File IEN [4] ^ Other Location [5] ^ Group [6] ^ Imm IEN [7] ^ Lot [8] ^
 ;     Reaction [9] ^ VIS Date [10] ^ Age [11] ^ Visit Date [12] ^ Provider IEN~Name [13] ^ Inj Site [14] ^
 ;     Volume [15] ^ Visit IEN [16] ^ Visit Category [17] ^ Full Name [18] ^ Location IEN~Name [19] ^
 ;     Visit Locked [20] ^ Event Date/Time [21] ^ Dose Override [22] ^ VPED IEN [23] ^ VFC eligibility [24]
 ;  For forecast:
 ;    F ^ Imm Name [2] ^ Status [3]
 ;  For contraindications:
 ;    C ^ Contra IEN [2] ^ Imm Name [3] ^ Reason [4] ^ Date [5]
 ;  For refusals:
 ;    R ^ Refusal IEN [2] ^ Type IEN [3] ^ Type Name [4] ^ Item IEN [5] ^ Item Name [6] ^ Provider IEN [7] ^
 ;     Provider Name [8] ^ Date [9] ^ Locked [10] ^ Reason [11] ^ Comment [12]
GET(RET,INP) ;EP
 N BIRESULT,DFN,DLM,HX,ELE,CNT,VIEN,DOB,VIMM,TYPE,P,A,I,J,K,X,V,VFC
 N XREF,FNUM,OFF
 S RET=$$TMPGBL^BGOUTL
 S DFN=+INP,INP=$P(INP,U,2)
 Q:'DFN
 S:INP="" INP="IFCR"
 S DLM=$C(31,31),HX="",V="|",CNT=0
 S XREF=$$VFPTXREF^BGOUTL2,FNUM=$$FNUM,OFF=$S($G(DUZ("AG"))="I":0,1:9999999)
 D:INP["F" IMMFORC^BIRPC(.HX,DFN)
 S P=$P(HX,DLM,2)
 S:'$L(P) P=$P(HX,DLM)
 I $L(P) F I=1:1:$L(P,U) D:$L($P(P,U,I)) ADD("F^"_$P(P,U,I))
 S HX=""
 D:INP["C" CONTRAS^BIRPC5(.HX,DFN)
 S P=$P(HX,DLM,2)
 S:'$L(P) P=$P(HX,DLM)
 I $L(P) F I=1:1:$L(P,U) D:$L($P(P,U,I)) ADD("C^"_$P(P,U,I))
 S HX="",P=1
 ;MSC/MGH - 07/08/09 - Branching for compatibility with Vista and RPMS
 I DUZ("AG")="I" D
 .;IHS/MSC/MGH patch 6 added field 77 VFC
 .F I=4,21,24,36,27,30,33,44,51,57,60,61,67,68,76,35,9,34,0,0,65,77 S P=P+1 S:I ELE(I)=P
 .D:INP["I" IMMHX^BIRPC(.HX,DFN,.ELE,0)
 .S P=$P(HX,DLM,2)
 .I $L(P) D ADD("I^"_P) Q   ; Error
 .S HX=$P(HX,DLM)
 .F I=1:1 S P=$P(HX,U,I) Q:P=""  D
 ..Q:$P(P,V)'="I"
 ..S A="I",J=0,K=1
 ..F  S J=$O(ELE(J)) Q:'J  S K=K+1,$P(A,V,ELE(J))=$P(P,V,K)
 ..S VIMM=+$P(A,V,4),VIEN=$P(A,V,16),TYPE=$P(A,V,7),VFC=$P(A,V,23)
 ..S:$P(A,V,10)="NO DATE" $P(A,V,10)=""
 ..S X=$P(A,V,14)
 ..S:$L(X) $P(A,V,14)=X_"~"_$$EXTERNAL^DILFD(9000010.11,.09,,X)
 ..D GI1(13,200),GI1(19,9999999.06)
 ..S $P(A,V,20)=$$ISLOCKED^BEHOENCX(VIEN)
 ..S $P(A,V,21)=$P($G(^AUPNVIMM(VIMM,12)),U)
 ..S $P(A,V,23)=$$FNDPED(VIEN,$$IMMCPT(TYPE,VIEN))
 ..S $P(A,V,24)=$S(VFC=0:"Unknown",VFC=1:"Not Eligible",VFC=2:"Medicaid",VFC=3:"Uninsured",VFC=4:"Am Indian/AK Native",VFC=5:"Federally Qualified",VFC=6:"State-specific Elig",VFC=7:"Local-specific Elig",1:"")
 ..D ADD(A)
 E  D
 .N REC,LP,X,Y,Z,FNUM
 .S FNUM=9000010.11,OFF=9999999
 .S LP="" F  S LP=$O(^AUPNVIMM("C",DFN,LP)) Q:'LP  D
 ..S X=$G(^AUPNVIMM(LP,0))
 ..Q:$P(X,U,2)'=DFN
 ..S $P(X,U,8,99)=$P($G(^AUPNVIMM(LP,9999999)),U,8,99)
 ..S Y=$G(^AUTTIMM(+X,0))
 ..Q:'$L(Y)
 ..S VIEN=+$P(X,U,3)
 ..S Z=$G(^AUPNVSIT(VIEN,0))
 ..Q:'$L(Z)
 ..S REC="I"
 ..S REC=REC_U_$P(Y,U,2)                                 ; Imm Short
 ..S REC=REC_U_$$FMTDATE^BGOUTL(+Z)                      ; Visit Date
 ..S REC=REC_U_LP                                        ; V File IEN
 ..S REC=REC_U_$P($G(^AUPNVSIT(VIEN,21)),U)              ; Other Loc
 ..S REC=REC_U_$$GET1^DIQ(FNUM,LP,.09)                   ; Group
 ..S REC=REC_U_+X                                     ; Imm IEN
 ..S REC=REC_U_$$GET1^DIQ(9999999.41,+$P(X,U,5),.01)     ; Lot
 ..S REC=REC_U_$$GET1^DIQ(FNUM,LP,.06)                   ; Reaction
 ..S REC=REC_U_$$ENTRY^CIAUDT($P(X,U,12))             ; VIS Date
 ..;S REC=REC_U_$$PTAGE^BGOUTL($P($G(^AUPNVSIT(VIEN,0)),U,5))
 ..S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 ..S REC=REC_U_$$GETAGE^BGOVSK(+Z,DOB)                     ; Age
 ..S REC=REC_U_$$ENTRY^CIAUDT(+Z,0)                     ; Visit Date
 ..S REC=REC_U_$$GI2($P($G(^AUPNVIMM(LP,12)),U,4),200)   ; Provider
 ..S REC=REC_U_$P(X,U,9)_"~"_$$GET1^DIQ(FNUM,LP,.09+OFF)   ; Inj Site
 ..S REC=REC_U_$P(X,U,11)                                 ; Volume
 ..S REC=REC_U_VIEN                                      ; Visit IEN
 ..S REC=REC_U_$P(Z,U,7)                                ; Visit Cat
 ..S REC=REC_U_$P(Y,U)                                     ; Full Name
 ..S REC=REC_U_$$GI2($P(Z,U,6),9999999.06)                    ; Location
 ..S REC=REC_U_$$ISLOCKED^BEHOENCX(VIEN)                      ; Visit Loc
 ..D ADD(REC)
 D:INP["R" REFGET^BGOUTL2(RET,DFN,9999999.14,.CNT)
 Q
GI1(PC,FN) ;EP
 N X
 S X=+$P(A,V,PC)
 S:X $P(A,V,PC)=X_"~"_$$GET1^DIQ(FN,X,.01)
 Q
GI2(PC,FN) ;EP
 Q $S(PC:PC_"~"_$$GET1^DIQ(FN,PC,.01),1:"")
 ; Delete an immunization
 ;  VIMM = V File IEN
 ;  FLG  = Delete flag where
 ;    0: V File and codes (default)
 ;    1: V File only
 ;    2: Codes only
DEL(RET,VIMM,FLG) ;EP
 N VIEN,TYPE,CPT,ICD,INJS,DATE,DFN,PRV,VPED,X0,X12
 S RET=""
 S VIMM=+$G(VIMM),FLG=+$G(FLG)
 S X0=$G(^AUPNVIMM(VIMM,0)),X12=$G(^(12))
 I 'X0 S RET=$$ERR^BGOUTL(1080) Q
 S TYPE=+X0,DFN=$P(X0,U,2),VIEN=$P(X0,U,3),INJS=$P(X0,U,9)
 S DATE=+X12,PRV=$P(X12,U,4)
 S:'DATE DATE=+$G(^AUPNVSIT(VIEN,0))
 D:FLG'=2 BIDEL(.RET,VIMM,$$FNUM)
 Q:RET!(FLG=1)
 S CPT=$$IMMCPT(TYPE,VIEN),ICD=$$IMMICD(TYPE,VIEN),VPED=$$FNDPED(VIEN,CPT)
 S:CPT>0 RET=$$DELCPT(CPT,ICD,VIEN,DFN,PRV,INJS,DATE,VPED)
 Q:RET
 D:VPED DEL^BGOVPED(,VPED)
 S:ICD>0 RET=$$DELICD(ICD,VIEN,DFN,PRV)
 Q
 ; Immunization education topic IEN
IMMTOP() Q $O(^AUTTEDT("B","IM-INFORMATION",0))
 ; Find patient ed entry corresponding to immunization CPT code
FNDPED(VIEN,CPT) ;
 N VPED,TOP,X
 Q:'CPT ""
 S VPED=0,TOP=$$IMMTOP
 F  S VPED=$O(^AUPNVPED("AD",VIEN,VPED)) Q:'VPED  S X=$G(^AUPNVPED(VPED,0)) I +X=TOP,$P(X,U,9)=CPT Q
 Q VPED
 ; Call BI delete
BIDEL(RET,VFIEN,FNUM) ;EP
 N GBL,DATA,VIEN
 S GBL=$$ROOT^DILFD(FNUM,,1)
 S DATA=$G(@GBL@(VFIEN,0)),VIEN=$P(DATA,U,3)
 S RET=$$CHKVISIT^BGOUTL(VIEN)
 Q:RET
 D DELETE^BIRPC3(.RET,VFIEN,$S(FNUM=$$FNUM:"I",1:"S"))
 S RET=$$IMMERR(RET)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,2,DATA)
 Q
 ; Delete ICD9 code
DELICD(ICD,VIEN,DFN,PRV) ;EP
 N RET,VPOV,X0,X12
 Q:"E"[$P($G(^AUPNVSIT(VIEN,0)),U,7)!'$G(ICD) ""
 S VPOV=0
 F  S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:'VPOV  D  Q:$D(RET)
 .S X0=$G(^AUPNVPOV(VPOV,0)),X12=$G(^(12))
 .Q:ICD'=+X0
 .I $G(PRV),$P(X12,U,4)'=PRV Q
 .D VFDEL^BGOUTL2(.RET,9000010.07,VPOV)
 Q $G(RET)
 ; Delete CPT code(s)
DELCPT(CPT,ICD,VIEN,DFN,PRV,SITE,DATE,CNSL) ;EP
 N RET
 S RET=""
 ;IHS/MSC/MGH CPT codes no longer added or deleted
 Q RET
 Q:"E"[$P($G(^AUPNVSIT(VIEN,0)),U,7) ""
 S:CPT CPT=$$ADJCPT(CPT,DFN,DATE,.CNSL)
 S:CPT RET=$$DC1(CPT,VIEN,.PRV)
 Q:RET RET
 I 'RET D
 .N C
 .I SITE'="O",SITE'="IN" F C=90465,90466,90471,90472 S C(C)=""
 .E  F C=90467,90468,90473,90474 S C(C)=""
 .S RET=$$DC1(.C,VIEN,.PRV,.ICD)
 I 'RET D
 .N C
 .S C=$$SYRCPT(SITE)
 .S:C RET=$$DC1(C,VIEN,.PRV)
 Q RET
 ; Delete CPT in visit
DC1(CPTS,VIEN,PRV,ICD) ;
 N C,X0,X12,VCPT,RET,QTY
 S VCPT=0
 S:$D(CPTS)=1 CPTS(CPTS)=""
 F  S VCPT=$O(^AUPNVCPT("AD",VIEN,VCPT)) Q:'VCPT  D  Q:$D(RET)
 .S X0=$G(^AUPNVCPT(VCPT,0)),X12=$G(^(12)),C=$P(X0,U)
 .Q:$G(PRV)'=$P(X12,U,4)
 .Q:$G(ICD)'=$P(X0,U,5)
 .Q:'$D(CPTS(C))
 .S QTY=$P(X0,U,16)
 .I QTY>1 D
 ..D SETQTY^BGOVCPT(.RET,VCPT_U_(QTY-1))
 .E  D VFDEL^BGOUTL2(.RET,9000010.18,VCPT)
 Q $G(RET)
 ; Add CPT code(s)
ADDCPT(CPT,ICD,VIEN,DFN,PRV,SITE,DATE,CNSL) ;EP
 ;IHS/MSC/MGH Patch 9 CPT codes no longer added or deleted
 Q 0
 N RET,CPT2,CPT3
 Q:$$GET^XPAR("ALL","BGO IMM STOP ADDING CPT CODES") 0
 S:'$G(DATE) DATE=+$G(^AUPNVSIT(VIEN,0))
 S CPT2=$$ADMINCPT(VIEN,CPT,SITE),CPT3=$$SYRCPT(SITE),RET=0
 Q:'CPT2 RET ; Already exists
 S CPT=$$ADJCPT(CPT,DFN,DATE,.CNSL),CPT2=$$ADJCPT(CPT2,DFN,DATE,.CNSL)
 S RET=$$ADDCPT^BGOVCPT(CPT,,VIEN,DFN,PRV)
 S:RET'<0 RET=$$ADDCPT^BGOVCPT(CPT2,.ICD,VIEN,DFN,PRV)
 I 'RET,CPT3 S RET=$$ADDCPT^BGOVCPT(CPT3,,VIEN,DFN,PRV)
 Q RET
 ; Get syringe CPT
SYRCPT(SITE) ;
 Q $S(SITE="O":"",SITE="IN":"",1:$O(^ICPT("B","A4206",0)))
 ; Get administration CPT
ADMINCPT(VIEN,CPT,SITE) ;
 N C,X,Y,CPT2,CNT
 S (X,Y,CNT)=0,CPT2=90471
 F  S X=$O(^AUPNVCPT("AD",VIEN,X)) Q:'X!Y  D
 .S C=$P($G(^AUPNVCPT(X,0)),U)
 .S:(C=90471)!(C=90473)!(C=90465)!(C=90467) CPT2=90472
 .S:C=CPT Y=1
 Q:Y "" ; Already exists
 S:SITE="O"!(SITE="IN") CPT2=$S(CPT2=90471:90473,1:90474)
 Q CPT2
 ; Adjust CPT code for age
ADJCPT(CPT,DFN,DATE,CNSL) ;
 Q $S('$G(CNSL,1):CPT,$$PTAGE^BGOUTL(DFN,DATE)'<8:CPT,CPT=90471:90465,CPT=90472:90466,CPT=90473:90467,CPT=90474:90468,1:CPT)
 ; Add an ICD9 code
ADDICD(ICDIEN,VIEN,DFN,PRV) ;EP
 N X,Y,RET,APCDALVR,DLAYGO,ICD
 Q:$$GET^XPAR("ALL","BGO IMM STOP ADDING ICD CODES") 0
 S (X,Y)=0
 F  S X=$O(^AUPNVPOV("AD",VIEN,X)) Q:'X!Y  S Y=ICDIEN=$P($G(^AUPNVPOV(X,0)),U)
 D:'Y SET^BGOVPOV(.RET,U_VIEN_U_"`"_ICDIEN_U_DFN_U_$P($G(^ICD9(+ICDIEN,0)),U,3)_"^^^^^^^^^^"_PRV)
 Q $G(RET)
 ; Add/Edit immunization
 ;  INP = Visit IEN [1] ^ Historical [2] ^ Patient IEN [3] ^ Imm IEN [4] ^ V File IEN [5] ^
 ;        Provider IEN [6] ^ Location [7] ^ Other Location [8] ^ Imm Date [9] ^ Lot # [10] ^
 ;        Reaction [11] ^ VIS Date [12] ^ Dose Override [13] ^ Inj Site [14] ^ Volume [15] ^
 ;        Counselled [16] ^ VFC Eligibility [17]
SET(RET,INP) ;EP
 N V,CPT,ICD,VFIEN,VOL,OVRD,VIEN,DFN,TYPE,LOT,RXN,PRV,VISD,CNSL
 N EVNTDT,LOCIEN,OUTLOC,HIST,CAT,INJS,IMMNM,FNUM,VFNEW,ARG,OFF,VFC
 S RET="",FNUM=$$FNUM,V="|"
 S OFF=$S($G(DUZ("AG"))="I":0,1:9999999)
 S VIEN=+INP
 S HIST=$P(INP,U,2)
 I 'VIEN,'HIST S RET=$$ERR^BGOUTL(1002) Q
 S DFN=+$P(INP,U,3)
 S TYPE=+$P(INP,U,4)
 S VFIEN=$P(INP,U,5)
 S VFNEW='VFIEN
 S PRV=$P(INP,U,6)
 S LOCIEN=$P(INP,U,7)
 S OUTLOC=$P(INP,U,8)
 S EVNTDT=$$CVTDATE^BGOUTL($P(INP,U,9))
 I 'DFN!'TYPE S RET=$$ERR^BGOUTL(1008) Q
 S CAT=$P($G(^AUPNVSIT(VIEN,0)),U,7)
 S:CAT="E" HIST=1
 I HIST D  Q:RET<0
 .S PRV=""
 .S RET=$$MAKEHIST^BGOUTL(DFN,EVNTDT,$S($L(OUTLOC):OUTLOC,1:LOCIEN),VIEN)
 .S:RET>0 VIEN=RET,CAT="E",RET=""
 S RET=$$CHKVISIT^BGOUTL(VIEN,DFN)
 Q:RET
 S LOT=$P(INP,U,10)
 S RXN=$P(INP,U,11)   ; Reaction
 S VISD=$P(INP,U,12)
 S OVRD=$P(INP,U,13)  ; Dose override
 S INJS=$$TOINTRNL^BGOUTL(FNUM,.09+OFF,$P(INP,U,14))  ; Immunization Site
 S VOL=+$P(INP,U,15)
 S CNSL=$P(INP,U,16)  ; Patient/family counselled
 S VFC=$P(INP,U,17)   ;VFC eligibility for children
 I VFC'="" D
 .S VFC=$S(VFC="Unknown":0,VFC="Not Eligible":1,VFC="Medicaid":2,VFC="Uninsured":3,VFC="Am Indian/AK Native":4,VFC="Federally Qualified":5,VFC="State-specific Elig":6,VFC="Local-specific Elig":7,1:"")
 S:'$L(CNSL) CNSL=$P($G(^VA(200,DUZ,"PS")),U)&($$PTAGE^BGOUTL(DFN,EVNTDT)<8)
 I 'VFIEN D  Q:RET
 .S IMMNM=$$GET1^DIQ(9999999.14,TYPE,.01)
 .D VFCHK^BGOUTL2(.RET,FNUM,TYPE,IMMNM,VIEN)
 I VFIEN,'HIST D DEL(,VFIEN,2)
 S ARG=$$BIARG("I",VIEN,VFIEN,TYPE,PRV)
 S:LOT $P(ARG,V,5)=LOT
 S:RXN $P(ARG,V,15)=RXN
 S $P(ARG,V,16)=VFC
 S $P(ARG,V,17)=VISD
 S $P(ARG,V,19)=OVRD
 S $P(ARG,V,20)=INJS
 S $P(ARG,V,21)=VOL
 I 'HIST D  Q:RET
 .S ICD=$$IMMICD(TYPE,VIEN,1),CPT=0
 .;IHS/MSC/MGH patch 9 stop adding CPT codes
 .;CPT=$$IMMCPT(TYPE,VIEN,1)
 .S:ICD<0 RET=ICD
 .S:CPT<0 RET=CPT
 D BISET(.RET,ARG,FNUM,TYPE,VIEN,VFIEN,EVNTDT)
 Q:HIST!(RET'>0)
 ;I CPT D
 ;.N RET1
 ;.S RET1=$$ADDCPT(CPT,.ICD,VIEN,DFN,PRV,INJS,EVNTDT,CNSL)
 ;.S:RET1 RET=RET1
 I RET'<0,CNSL D
 .N RET1,TOP
 .S TOP=$$IMMTOP
 .Q:'TOP
 .D SET^BGOVPED(.RET1,U_TOP_U_DFN_U_VIEN_U_PRV_"^^^^^^^^^"_EVNTDT_"^^^^^1")
 .S:RET1 RET=RET1
 I RET'<0,$G(ICD) D
 .N RET1
 .S RET1=$$ADDICD(ICD,VIEN,DFN,PRV)
 .S:RET1 RET=RET1
 Q
 ; Set data using BI add/edit call
BISET(RET,ARG,FNUM,TYPE,VIEN,VFIEN,EVNTDT) ;EP
 N VFNEW,FDA
 S VFNEW='VFIEN
 D ADDEDIT^BIRPC3(.RET,ARG)
 S RET=$$IMMERR(.RET)
 Q:RET
 D VFFND^BGOUTL2(.VFIEN,FNUM,TYPE,VIEN)
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(1201)=$S(EVNTDT:EVNTDT,1:"")
 I FNUM=9000010.11 D
 .;Patch 6 Updated to capture user last update
 .S @FDA@(1214)="`"_DUZ
 I $$UPDATE^BGOUTL(.FDA,"E@")
 D VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S RET=VFIEN
 Q
 ; Format argument for BI add/edit call
BIARG(REC,VIEN,VFIEN,ITM,PRV) ;EP
 N X,V,X0,X21
 S V="|",X=REC,X0=$G(^AUPNVSIT(VIEN,0)),X21=$G(^(21))
 S $P(X,V,2)=$P(X0,U,5)
 S $P(X,V,3)=ITM
 S $P(X,V,6)=$P(X0,U)
 S $P(X,V,7)=$P(X0,U,6)
 S $P(X,V,8)=$P(X21,U)
 S $P(X,V,9)=$P(X0,U,7)
 S $P(X,V,10)=VIEN
 S:VFIEN $P(X,V,11)=VFIEN
 S:PRV $P(X,V,18)=PRV
 S $P(X,V,23)=DUZ(2)
 Q X
 ; Format error message from immunization package
IMMERR(MSG) ;EP
 N X
 S X=$P($G(MSG),$C(31),3)
 S:X[" #" X=$P(X," #")
 Q $S($L(X):$$ERR^BGOUTL(1082,X),1:"")
 ; Add record to output
ADD(X) S CNT=CNT+1,@RET@(CNT)=$TR(X,"|",U)
 Q
 ; Return V File #
FNUM() Q 9000010.11
