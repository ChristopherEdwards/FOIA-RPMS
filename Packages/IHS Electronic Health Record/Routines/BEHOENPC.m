BEHOENPC ;MSC/IND/DKM - PCC Data Management ;01-Sep-2011 12:42;DU
 ;;1.1;BEH COMPONENTS;**005003,005004,005005,005006,005007**;Sep 18, 2007
 ;=================================================================
 ; RPC: Update PCC data
 ; DATA = Returned as 0 if successful
 ; PCC  = Array of PCC data to process
 ; X,Y  = Not used (but required)
SAVE(DATA,PCC,X,Y) ;EP
 N IDX,TYP,CODE,VIEN,VCAT,VLOC,VDAT,VOLOC,ADD,DEL,VAL,DFN,PRV,FLD,DAT,COM,VMSR
 S IDX=0,DATA=0,PRV=0
 F  S IDX=$O(PCC(IDX)) Q:'IDX!DATA  D
 .S VAL=PCC(IDX),TYP=$P(VAL,U),CODE=$P(VAL,U,2),ADD=TYP["+",DEL=TYP["-",TYP=$TR(TYP,"+-")
 .D LOOK("COM",.COM)
 .I TYP?1.3AN,$T(@TYP)'="" D @TYP
 Q
 ; Look ahead for modifiers
 ; TYP = modifier type
 ; ARY = array to receive data
LOOK(TYP,ARY) ;
 K ARY
 N IDX2,CNT
 S IDX2=IDX
 F CNT=0:1 S IDX2=$O(PCC(IDX2)) Q:'IDX2  Q:$P(PCC(IDX2),U)'=TYP  D
 .I CNT S ARY(CNT)=PCC(IDX2)
 .E  S ARY=PCC(IDX2)
 .S IDX=IDX2
 Q
SET(FLN,PC,CV) ;
 S PC=$P(VAL,U,PC),FLD(FLN)=$S($D(CV):$$SET^CIAU(PC,CV),$L(PC):PC,1:"@")
 Q
 ; Find an existing V file entry
 ; CRT = Scalar or array of additional criteria in (field|format|value) format
FIND(FN,CODE,VIEN,CRT) ;
 N GBL,IEN,PC
 S GBL=$$ROOT^DILFD(FN,,1),IEN=0,PC=$S(FN=120.5:3,1:1)
 S:$L($G(CRT)) CRT(-1)=CRT
 F  S IEN=+$O(@GBL@("AD",VIEN,IEN)) Q:'IEN  Q:$P($G(@GBL@(IEN,0)),U,PC)=CODE&$$EVAL(.CRT)
 Q IEN
 ; Evaluate list of additional fields and values
EVAL(ARY) ;
 N LP,RES,ITM,TYP,FLD
 S RES=1,LP=""
 F  S LP=$O(CRT(LP)) Q:LP=""  D  Q:'RES
 .S ITM=CRT(LP),FLD=$P(ITM,"|"),TYP=$P(ITM,"|",2),TYP=$S($L(TYP):TYP,1:"E"),ITM=$P(ITM,"|",3,99)
 .I FLD=.001 S RES=IEN=ITM
 .E  S RES=$$GET1^DIQ(FN,IEN,FLD,TYP)=ITM
 Q RES
 ; Store the data in the specified V file
 ; FN = Fractional portion of V file file #
 ; CF = Field # of comment field (0=none; defaults to 81101)
 ; CRT = Additional lookup criteria
 ; NEW = Returned as true if entry is new
STORE(FN,CF,CRT,NEW) ;
 N BEHFLD,BEHERR,BEHIEN,IEN,DELX,BPRV
 S NEW=0
 S:'$G(VIEN) VIEN=$$FNDVIS^BEHOENCX(DFN,VDAT,VCAT,VLOC,1,,.VOLOC)
 I VIEN'>0 S:'DEL DATA=VIEN,VIEN="" G STXIT
 G:'$G(FN) STXIT
 I $$ISLOCKED^BEHOENCX(VIEN) S DATA="-1^The data associated with this visit may no longer be modified." Q
 S:FN<1 FN=9000010+FN
 S:'$D(CF) CF=81101
 I ADD S IEN="+1",NEW=1
 E  S IEN=$$FIND(FN,CODE,VIEN,.CRT) I 'IEN G:DEL STXIT S IEN="+1",NEW=1
 S:'$D(FLD(.01)) FLD(.01)=$S(DEL:"@",1:CODE)
 S:DEL DELX=$$ROOT^DILFD(FN,,1),DELX=$S($L(DELX):$G(@DELX@(IEN,0)),1:"")
 S FLD(.02)=DFN
 I FN=120.5 D
 .S FLD(9000010)=VIEN
 E  D
 .S FLD(.03)=VIEN
 .S:CF&$D(COM) FLD(CF)=$P(COM,U,3,999)
 .I '$D(FLD(1204)),VCAT'="E" S FLD(1204)=DUZ
 .S:'$D(FLD(1201))&$G(DAT) FLD(1201)=DAT
 I TYP="PRV"&($G(FLD(.04))="P") D
 .S BPRV="" F  S BPRV=$O(^AUPNVPRV("AD",VIEN,BPRV)) Q:BPRV=""  D
 ..Q:FLD(.01)=$P($G(^AUPNVPRV(BPRV,0)),U,1)
 ..I $P($G(^AUPNVPRV(BPRV,0)),U,4)="P" S FLD(.04)="S"
 M BEHFLD(FN,IEN_",")=FLD
 K FLD
 D UPDATE^DIE("","BEHFLD","BEHIEN","BEHERR")
 S:$G(DIERR) DATA=-BEHERR("DIERR",1)_U_BEHERR("DIERR",1,"TEXT",1)
 S:$G(BEHIEN(1)) IEN=$G(BEHIEN(1))
 D VFEVT(FN,IEN,$S(DEL:2,1:'NEW),.DELX)
STXIT Q:$Q $G(IEN)
 Q
 ; Fire V file update events
 ;  FNUM  = V File #
 ;  VFIEN = V File IEN
 ;  OPR   = Operation (0 = add, 1 = edit, 2 = delete)
VFEVT(FNUM,VFIEN,OPR,X) ;EP
 N ID,GBL,DFN,VIEN,DATA
 S GBL=$$ROOT^DILFD(FNUM,,1)
 Q:'$L(GBL)
 S ID=$P(GBL,"AUPNV",2)
 S:'$D(X) X=$G(@GBL@(VFIEN,0))
 S DFN=$P(X,U,2),VIEN=$P(X,U,3),DATA=VFIEN_U_$G(CIA("UID"))_U_OPR_U_$P(X,U)_U_VIEN
 D:DFN BRDCAST^CIANBEVT("PCC."_DFN_"."_ID,DATA)
 D:VIEN BRDCAST^CIANBEVT("VISIT."_VIEN_"."_ID,DATA)
 D:VIEN VFMOD(VIEN)
 Q
 ; Update the visit modification date
VFMOD(AUPNVSIT) ;
 N DIE,DA,DR,DIU,DIV
 D:DUZ("AG")="I" MOD^AUPNVSIT
 Q
HDR ;; Visit string
 N X
 S X=$P(VAL,U,4),VLOC=+X,VDAT=$P(X,";",2),VCAT=$P(X,";",3),VIEN=$P(X,";",4)
 S:'(VDAT\1#100) VDAT=VDAT+1
 S:'(VDAT\100#100) VDAT=VDAT+100
 Q
VST ;; Patient and encounter date
 N X
 S X=$P(VAL,U,3)
 I CODE="PT" S DFN=+X
 E  I CODE="DT" S DAT=+X
 E  I CODE="VC" S VCAT=X
 E  I CODE="OL" S VOLOC=$S(X:X,1:$P(VAL,U,4))
 Q
PRV ;; Provider
 ; PRV[1]^ien[2]^^^name[5]^primary/secondary flag[6]
 N BPRV
 S PRV=+CODE,ADD=0
 D:PRV>0 SET(.04,6,"1:P;0:S;:@"),STORE(.06)
 Q
POV ;; Purpose of visit
 ;POV[1]^code[2]^^narrative[4]^^P/S[6]^^Add to problem list[8]
 N NAR,VAL1
 ;IHS/MSC/MGH updated to use correct lookup
 ;S CODE=$$FIND1^DIC(80,,"X",CODE_" ","BA")
 ;MGH fix for patch 9
 S CODE=$P(CODE,":",1)
 S CODE=+$$CODEN^ICDCODE(CODE,80)
 Q:CODE'>0
 ;S NAR=$$NARR($P(VAL,U,4))
 S $P(VAL,U,4)=$$NARR($P(VAL,U,4))
 S NAR=$P(VAL,U,4)
 S VAL1=$P(VAL,U,2)
 D SET(.04,4),SET(.12,6,"1:P;0:S;:@"),SET(.08,7),STORE(.07)
 ;Update problem list
 I $P(VAL,U,8)=1 D PROBLST(VAL1)
 Q
CPT ;; CPT codes
 ;IHS/MSC/MGH fix for patch 9
 S CODE=$P(CODE,":",1)
 S CODE=+$$CPT^ICPTCOD(CODE)
 D:CODE>0 SET(.16,7),STORE(.18)
 Q
IMM ;; Immunizations
 ;  TIMM[1]^Code[2]^Cat[3]^Nar[4]^Com[5]^Prv[6]^Series[7]^Reaction[8]^
 ;    Contraindicated[9]^Refused[10]^LotNum[11]^Site[12]^Volume[13]^
 ;    VISDate[14]
 N REF,LOT,NEW,OFF
 ;MSC/MGH added offset for Vista/RPMS field conflicts
 S OFF=$S($G(DUZ("AG"))="I":0,1:9999999)
 S REF=$P(VAL,U,10),LOT="",NEW=0
 I $G(VIEN),$P($G(^AUPNVSIT(VIEN,0)),U,7)'="E" S LOT=$P(VAL,U,11)
 I $L(REF) D STORE(),REFUSAL("IMMUNIZATION",REF) Q:REF'="@"
 D SET(.04,7),SET(.06,8),SET(.07,9),SET(.05,11),SET(.09+OFF,12),SET(.11+OFF,13),SET(.12+OFF,14)
 Q:$$STORE(.11,,,.NEW)'>0
 I NEW,LOT,$L($T(LOTDECR^BIRPC3)) D LOTDECR^BIRPC3(LOT)
 I $P(VAL,U,9),$L($T(SETCONT^BGOVIMM2)) D
 .N X
 .S X=$P(VAL,U,8),X=$S(X=12:1,X=6:3,X=7:5,X=9:4,1:10)
 .D SETCONT^BGOVIMM2(,DFN_U_CODE_U_X)
 Q
SK ;; Skin tests
 ; SK[1]^Code[2]^Cat[3]^Nar[4]^Com[5]^Prv[6]^result[7]^reading[8]^
 ;    d/t read[9]^d/t given[10]^read by[11]^refused[12]^site[13]^vol[14]
 N REF,GVN,DTR,DTG,TODAY,ERR,OFF,GTR
 ;MSC/MGH added offset for Vista/RPMS field conflicts
 S OFF=$S($G(DUZ("AG"))="I":0,1:9999999)
 S TODAY=$$DT^XLFDT()
 S DTR=$P(VAL,U,9)
 S GTR=$P(VAL,U,10)
 I GTR>TODAY!(DTR>TODAY) S DATA="-1^You cannot enter dates in the future" Q
 I +DTR,GTR>DTR S DATA="-1^The skin test read date must be after the applied date" Q
 S REF=$P(VAL,U,12),GVN=$P(VAL,U,10)
 S:'$L(GVN) (GVN,$P(VAL,U,10))=$G(VDAT)
 I GVN,GVN\1'=(VDAT\1) N VDAT,VCAT,VLOC,VOLOC,VIEN D
 .S VDAT=GVN,VCAT="E",VLOC=""  ; Force historical visit
 I $L(REF) D STORE(),REFUSAL("SKIN TEST",REF) Q:REF'="@"
 I $P(VAL,U,7)="N" D
 .I $P(VAL,U,8)=""!($P(VAL,U,8)="@") S $P(VAL,U,8)=0
 D SET(.04,7),SET(.05,8),SET(.06,9),SET(1201,10),SET(.08+OFF,11),SET(.09+OFF,13),SET(.11+OFF,14),STORE(.12)
 Q
PED ;; Patient education
 ; PED[1]^Code[2]^Cat[3]^Nar[4]^Com[5]^Prv[6]^level of understanding[7]^
 ;    refused[8]^elapsed[9]^setting[10]^goals[11]^outcome[12]
 N REF
 S REF=$P(VAL,U,8)
 I "@"[REF,$P(VAL,U,7)=5 S REF="R"
 D:$L(REF) STORE(),REFUSAL("EDUCATION TOPICS",REF)
 S:'$P(VAL,U,6) $P(VAL,U,6)=DUZ  ;Patch 003
 S $P(VAL,U,3)=$$PEDTOPIC($P(VAL,U,3))  ;Patch 004
 S:"@"'[REF $P(VAL,U,7)=5
 D SET(.12,3),SET(.05,6),SET(.06,7),SET(.08,9),SET(.07,10),SET(.13,11),SET(.14,12),STORE(.16,.11)
 Q
HF ;; Health factors
 ; HF[1]^Code[2]^Cat[3]^Nar[4]^Com[5]^Prv[6]^level/severity[7]
 D SET(.01,2),SET(.04,7),STORE(.23)
 Q
XAM ;; Patient exams
 ; XAM[1]^Code[2]^Cat[3]^Nar[4]^Com[5]^Prv[6]^result[7]^refused[8]
 N REF
 S REF=$P(VAL,U,8)
 I $L(REF) D STORE(),REFUSAL("EXAM",REF) Q:REF'="@"
 D SET(.04,7),STORE(.13)
 Q
TRT ;; Treatments
 ; TRT[1]^Code[2]^Cat[3]^Nar[4]^Com[5]^Prv[6]^Qty[7]
 D SET(.04,7),STORE(.15)
 Q
MSR ;; Vital measurements (new format)
 ; MSR[1]^Code[2]^Cat[3]^Nar[4]^Com[5]^Prv[6]^Value[7]^Units[8]^
 ;VMSR IEN[9]^GMRV IEN[10]^When entered[11]^Taken date[12]^Entered by[13]^Qualfier[14]
 N GMRV,IEN,WHEN,XM,YM,Z,BEHDATA,TAKEN,ENTER,ENTERIEN,I,QUALNAME,QUALS,RESULT,NEW
 S ENTERIEN=""
 S:'$D(VMSR) VMSR=$$GET^XPAR("ALL","BEHOVM USE VMSR")
 S XM=$P(VAL,U,7),YM=$P(VAL,U,8)
 ;OIT/MSC/MGH Delete is now marked as entered in error
 I DEL S BEHDATA=$P(VAL,U,9)_U_DUZ_U_4 D EIE^BEHOVM2(.RESULT,BEHDATA) I RESULT="OK" S DATA=0 Q
 ;OIT/MSC/MGH Edits are now a delete and make a new entry
 I 'ADD D
 .S BEHDATA=$P(VAL,U,9)_U_DUZ_U_4 D EIE^BEHOVM2(.RESULT,BEHDATA)
 .I RESULT="OK" S DATA=0
 .E  S DATA=RESULT Q DATA
 .S ADD=1,$P(VAL,U,9)=0
 I 'DEL,$L(YM) D
 .S DATA=$$NORM^BEHOVM(CODE,.XM,.YM,VMSR)
 .S:'DATA $P(VAL,U,7)=XM,$P(VAL,U,8)=YM
 Q:DATA
 S GMRV=$P(VAL,U,10),IEN=$P(VAL,U,9)
 ;S:'WHEN WHEN=$$NOW^XLFDT()  ;Patch 003
 S WHEN=$$NOW^XLFDT()
 S TAKEN=$P(VAL,U,12),TAKEN=$$CVTDATE^BGOUTL(TAKEN)
 I TAKEN="" S TAKEN=$P(VAL,U,11),TAKEN=$$CVTDATE^BGOUTL(TAKEN)
 ;IHS/MSC/MGH Change for EHR patch 9
 I TAKEN=""&(VCAT="E") S TAKEN=VDAT
 I TAKEN="" S TAKEN=WHEN
 S ENTERIEN=$P(VAL,U,13)
 I ENTERIEN="" S ENTERIEN=DUZ
 S $P(VAL,U,6)=DUZ   ;Patch 003
 I VMSR D
 .D SET(.04,7),SET(1204,6)
 .D FIELD^DID(9000010.01,.07,"","DESCRIPTION","NEW")
 .S FLD(1201)=TAKEN,FLD(.08)=ENTERIEN
 .S FLD(.07)=WHEN
 .S IEN=$$STORE(.01,,$S(IEN:".001||"_IEN,1:""))
 .I GMRV,IEN!DEL D
 ..N BEHFLD
 ..S BEHFLD(120.5,GMRV_",",9999999)=$S(DEL:"@",1:IEN)
 ..D UPDATE^DIE("","BEHFLD")
 E  D
 .D SET(1.2,7),SET(.06,6),SET(.03,2)
 .S TAKEN=$P(VAL,U,12),TAKEN=$$CVTDATE^BGOUTL(TAKEN)
 .I TAKEN="" S TAKEN=$P(VAL,U,11),TAKEN=$$CVTDATE^BGOUTL(TAKEN)
 .I TAKEN="" S TAKEN=$$NOW^XLFDT
 .S FLD(.01)=$S(DEL:"@",1:TAKEN),FLD(.04)=$$NOW^XLFDT,FLD(.05)=VLOC
 .S IEN=$$STORE(120.5,,$S(IEN:".001||"_IEN,1:""))
 I IEN&($P(VAL,U,14)'="") D
 .K QUAL
 .S QUALS=$P(VAL,U,14)
 .F I=1:1 S QUALNAME=$P(QUALS,"~",I) Q:QUALNAME=""  S QUAL(QUALNAME)=""
 .D QUAL^BEHOVM2(.RESULT,IEN,.QUAL)
 Q
VIT ;; Vital measurements (old format)
 S TYP="MSR"
 S VAL="MSR^"_CODE_"^^^^"_$P(VAL,U,6)_U_$P(VAL,U,5)_U_$P(VAL,U,7)_U_$P(VAL,U,3)_U_$P(VAL,U,4)_U_$P(VAL,U,8)_U_$P(VAL,U,9)_U_$P(VAL,U,10)_U_$P(VAL,U,11)
 D MSR
 Q
 ; Store/update a refusal
REFUSAL(TYPE,RSN) ;
 Q:'$L(RSN)!(VIEN'>0)
 S TYPE=$$FIND1^DIC(9999999.73,,"X",TYPE)
 Q:'TYPE
 N FDA,ERR,FNUM,IEN,OPR,DELX
 S FNUM=$P(^AUTTREFT(TYPE,0),U,2),OPR=1
 D REFUSAL^BEHOENP1(FNUM,CODE,VIEN,.IEN)
 I "@"[RSN Q:'IEN  S TYPE="@",OPR=2,DELX=$G(^AUPNPREF(IEN,0))
 S:'IEN IEN="+1",OPR=0
 S FDA=$NA(FDA(9000022,IEN_","))
 S @FDA@(.01)=TYPE
 S @FDA@(.02)=DFN
 S @FDA@(.03)=^AUPNVSIT(VIEN,0)\1
 S @FDA@(.04)=$P(VAL,U,4)
 S @FDA@(.05)=FNUM
 S @FDA@(.06)=CODE
 S @FDA@(.07)=RSN
 D UPDATE^DIE("","FDA","IEN","ERR")
 Q:$D(ERR("DIERR"))
 S:'OPR IEN=IEN(1)
 D REFEVT(IEN,OPR,.DELX)
 Q
 ; Broadcast a refusal event
REFEVT(IEN,OPR,X) ;EP
 N DFN,TYPE
 S:'$D(X) X=$G(^AUPNPREF(IEN,0))
 S DFN=$P(X,U,2)
 Q:'DFN
 S TYPE=$P($G(^AUTTREFT(+X,0)),U)
 D BRDCAST^CIANBEVT("REFUSAL."_DFN_"."_TYPE,IEN_U_$G(CIA("UID"))_U_OPR)
 Q
 ; Lookup and optionally add narrative
 ; Returns pointer to PROVIDER NARRATIVE file
NARR(TXT) ;
 N IEN,TRC,FDA
 Q:'$L(TXT) ""
 S TXT=$$STRPNAR(TXT)  ;P7
 S TXT=$E(TXT,1,160),TRC=$E(TXT,1,30)
 F IEN=0:0 S IEN=$O(^AUTNPOV("B",TRC,IEN)) Q:'IEN  Q:$P($G(^AUTNPOV(IEN,0)),U)=TXT
 Q:IEN IEN
 S FDA(9999999.27,"+1,",.01)=TXT
 D UPDATE^DIE("E","FDA","IEN")
 Q $G(IEN(1))
PROBLST(VAL) ; Add item to problem list if not already there
 N IEN,PROB,FOUND,NCODE,NUMBER,DATA,ICD,NUM,NUMBER,NEW
 S PROB="",FOUND=0
 S NCODE=$P(VAL,U,1)
 ;If this patient already has this code on his problem list, just quit
 F  S PROB=$O(^AUPNPROB("AC",DFN,PROB)) Q:PROB=""!(FOUND=1)  D
 .S ICD=$P($G(^AUPNPROB(PROB,0)),U,1)
 .S DATA=$$ICDDX^ICDCODE(ICD,80)
 .I $P(DATA,U,2)=NCODE S FOUND=1
 .S NUM=$P($G(^AUPNPROB(PROB,0)),U,7)
 .S NUMBER(NUM)=""
 Q:FOUND=1
 S NUM=9999
 S IEN="+1",OPR=0
 S NEW=$O(NUMBER(NUM),-1)+1
 S FDA=$NA(FDA(9000011,IEN_","))
 S @FDA@(.01)=CODE
 S @FDA@(.02)=DFN
 S @FDA@(.03)=$$NOW^XLFDT
 S @FDA@(.05)=NAR
 S @FDA@(.06)=DUZ(2)
 S @FDA@(.07)=NEW
 S @FDA@(.08)=$$NOW^XLFDT
 S @FDA@(.12)="A"
 S @FDA@(.14)=DUZ
 D UPDATE^DIE("","FDA","IEN","ERR")
 Q:$D(ERR("DIERR"))
 Q
UPPER(X) ; Convert lower case X to UPPER CASE
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 ; Lookup Education Topic and return pointer if text passed
PEDTOPIC(TOP) ;EP
 Q:TOP=+TOP TOP
 N TIEN
 S TIEN=$$FIND1^DIC(9001002.5,,"X",TOP)
 Q $S(TIEN>0:+TIEN,1:"")
 ;Strip out leading punctuation characters from Provider Narrative text
STRPNAR(NARR) ;EP-
 N LP,C,FLG
 F LP=1:1:$L(NARR) S C=$E(NARR,LP) I '(C?1P) S FLG=1 Q
 Q $S($G(FLG):$E(NARR,LP,$L(NARR)),1:"")
