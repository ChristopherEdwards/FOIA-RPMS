BGOVPOV ; IHS/BAO/TMD - Visit POV maintenance ;14-Apr-2016 06:35;MGH
 ;;1.1;BGO COMPONENTS;**1,3,4,5,6,7,10,11,12,13,14,19,20**;Mar 20, 2007;Build 1
 ; Check for note signed by provider
 ; Patch 6 added check for asthma DX
 ; Patch 7 added bulletin for first time diagnosis
 ; Patch 13 added changes to store SNOMED into POV
 ; Patch 14 added changes for ICD-10 implementation
CKSIGNBY(RET,VIEN) ;EP
 N X
 S VIEN=+VIEN
 Q:'VIEN
 S RET=$$PRIPRV^BGOUTL(VIEN)
 Q:RET<0
 S RET=+RET
 I RET'=DUZ S RET=$$ERR^BGOUTL(1089) Q
 S RET="",X=0
 F  S X=$O(^TIU(8925,"V",VIEN,X)) Q:'X  D  Q:RET
 .S:$P($G(^TIU(8925,X,15)),U,2)=DUZ RET=X
 S:'RET RET=$$ERR^BGOUTL(1090)
 Q
 ; Lookup ICD code
 ;  INP = ICD code ^ Reference Date
 ;  RET = Null if not found or ICD IEN^ICD Text
GETICD(RET,INP) ;EP
 N IEN,ICD,CDT
 S RET="",ICD=$P(INP,U),CDT=$P(INP,U,2)
 ;IHS/MSC/MSC Patch 12 changes
 S IEN=$P($$ICDDX^ICDEX(ICD,CDT,"","E"),U,2)
 S:IEN>0 RET=+IEN_U_$P(IEN,U,4)
 Q
 ; Return ICD code given ICD IEN
 ; INP = ICD IEN ^ Reference Date
 ; RET = Null if not found or ICD Code^ICD Text
GETCODE(RET,INP) ;EP
 N ICDIEN,CDT
 S ICDIEN=$P(INP,U),CDT=$P(INP,U,2)
 ;Patch 12 changes
 S RET=$$ICDDX^ICDEX(ICDIEN,CDT,"","I")
 S RET=$S(RET<0:"",1:$P(RET,U,2)_U_$P(RET,U,4))
 E  S RET=""
 Q
 ; Set primary/secondary for a POV
 ;  INP = VPOV IEN ^ Primary/Secondary (P/S)
 ;  For patch 13 changes made to store or unstore the primary DX SNOMED code
SETPRI(RET,INP,NOEVT) ;EP
 N PRI,VFIEN,VIEN,FDA,X
 S VFIEN=+INP
 I 'VFIEN S RET=$$ERR^BGOUTL(1008) Q
 S PRI=$P(INP,U,2)
 I '$D(^AUPNVPOV(VFIEN,0)) S RET=$$ERR^BGOUTL(1091) Q
 S VIEN=$P(^AUPNVPOV(VFIEN,0),U,3)
 S FDA($$FNUM,VFIEN_",",.12)=PRI
 I PRI="P" D
 .S FDA($$FNUM,VFIEN_",",1103)=63161005  ;Set required code
 .S X=0
 .F  S X=$O(^AUPNVPOV("AD",VIEN,X)) Q:'X  D:X'=VFIEN
 ..I $P($G(^AUPNVPOV(X,0)),U,12)="P" D
 ...S FDA($$FNUM,X_",",.12)="S"
 ...S FDA($$FNUM,X_",",1103)="@"
 E  D
 .S FDA($$FNUM,VFIEN_",",1103)="@"
 S RET=$$UPDATE^BGOUTL(.FDA)
 Q:RET
 ;I $$FIXVPOVS^BGOVPOV1(VIEN,.VFIEN)  ; Fix VPOV sequencing
 D:'$G(NOEVT) VFEVT^BGOUTL2($$FNUM,VFIEN,1)
 S RET=VFIEN
 Q
 ; Returns POV for current visit context
TIUSTR() N X,Y
 S X=$$GETVAR^CIANBUTL("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I X="" Q " "
 S X=$$VSTR2VIS^BEHOENCX(DFN,X)
 I X<1 Q " "
 D GET(.X,X_"^^1")
 S Y=$G(@X@(1))
 K @X
 Q $S(Y<0:"",1:Y)
 ; Returns POV for current visit context in multi-line format
TIUML(RET) ;EP
 N X,I,CNT
 S X=$$GETVAR^CIANBUTL("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I X="" Q " "
 S X=$$VSTR2VIS^BEHOENCX(DFN,X)
 I X<1 Q " "
 D GET(.X,X_"^^2")
 K @RET
 S (I,CNT)=0
 F  S I=$O(@X@(I)) Q:'I  D
 .S CNT=CNT+1
 .S @RET@(CNT,0)=@X@(I)
 S:'CNT @RET@(1,0)="No Diagnosis."
 K @X
 Q "~@"_$NA(@RET)
 ; Get VPOVs associated with a visit
 ;  INP=Visit IEN ^ VPOV IEN (optional) ^ Format (0-detailed,1-tiu string,2-multi-line)
 ;  Removed ICD name for Patch 12. This data is view only now
 ;Return array
 ;IEN [1] ^ Visit date [2] ^ Facility [3] ^ Facility Name [4] ^ ICD code [5] ^ Episodicity [6]
 ;^ Provider Narrative [7] ^ Mod [8] ^ Onset [9]
 ;^ Stage [10] ^Revisit [11] ^ Cause [12]^ Injury date [13] ^ External cause [14]
 ;^ Place of injury [15] ^Primary [16] ^Provider [17] ^ Visit IEN [18]
 ;^ Locked [19] ^ Asthma Cont [20] ^ SNOMED CT [21] ^ Provider Text [22] ^ qualifiers [23]
 ;^ Problem [24] ^ Ecode [25] ^ ICD Name [26] ^ ICD IEN [27] ^ Norm/Abn [28] ^ Laterality [29]
GET(RET,INP) ;EP
 N CNT,REC,VIEN,VPOVIEN,FORMAT,IEN,PRV,PNAR,POV,ICD,ICDNAME,VDATE,DFN,CT,CT2,DESC
 N STAGE,MOD,CAUSE,REVISIT,PRIM,ONSET,IDT,IPL,ICAU,FNUM,OFF,ASTHMA,CONTROL,LINE,LST,LAT,LATEXT
 N SMDATA,SMCNCPCT,SMCNCP,SNOMEDCT,SNOMEDTX,PROVTEXT,QUAL,PROB,EPIS,ICCODE,ICCIEN,ICDDATA,NORM
 ;MSC/MGH - 07/08/09 - Offset created to support VistA and RPMS
 S OFF=$S($G(DUZ("AG"))="I":0,1:9999999)
 S LATEXT=""
 S RET=$$TMPGBL^BGOUTL
 S FNUM=$$FNUM
 S VIEN=+INP
 S VPOVIEN=$P(INP,U,2)
 S FORMAT=+$P(INP,U,3)
 S (CNT,IEN)=0
 F  S IEN=$O(^AUPNVPOV("AD",VIEN,IEN)) Q:'IEN  D
 .I VPOVIEN,VPOVIEN'=IEN Q
 .S REC=$G(^AUPNVPOV(IEN,0))
 .Q:REC=""
 .S PRV=$P($G(^AUPNVPOV(IEN,12)),U,4)
 .S:PRV PRV=$P($G(^VA(200,PRV,0)),U)
 .S PNAR=$$GET1^DIQ(9000010.07,IEN,.04)
 .Q:PNAR=""
 .;S PNAR=$P(REC,U,4)
 .S VDATE=$$FMTDATE^BGOUTL($P($G(^AUPNVSIT(VIEN,0)),U))
 .I FORMAT=1 D
 ..S:$L(PNAR) CNT=CNT+1,@RET@(1)=$S(CNT=1:"",1:@RET@(1)_"; ")_PNAR
 .E  I FORMAT=2 D
 ..S:$L(PNAR) CNT=CNT+1,@RET@(CNT)=CNT_") "_PNAR_":"
 .E  D
 ..S POV=+REC
 ..;IHS/MSC/MGH Patch 12 changes
 ..S ICDDATA=$$ICDDX^ICDEX(POV,VDATE,"","I")
 ..S ICD=$P(ICDDATA,U,2),ICDNAME=$P(ICDDATA,U,4)
 ..Q:ICD=""
 ..S F=$P($G(^AUPNVSIT(VIEN,0)),U,6),DFN=$P($G(^AUPNVSIT(VIEN,0)),U,5)
 ..I F S FAC=$P($G(^AUTTLOC(F,0)),U,10),FACNAM=$P($G(^(0)),U)
 ..E  S (FAC,FACNAM)=""
 ..S:FACNAM FACNAM=$P($G(^DIC(4,FACNAM,0)),U)
 ..S STAGE=$P(REC,U,5)
 ..S MOD=$$EXTERNAL^DILFD(FNUM,.06,,$P(REC,U,6))
 ..S CAUSE=$$EXTERNAL^DILFD(FNUM,.07,,$P(REC,U,7))
 ..S REVISIT=$$EXTERNAL^DILFD(FNUM,.08,,$P(REC,U,8))
 ..S PRIM=$P(REC,U,12)
 ..S PRIM=$$EXTERNAL^DILFD(FNUM,.12,,$S($L(PRIM):PRIM,1:"S"))
 ..I DUZ("AG")="I" S ONSET=$$FMTDATE^BGOUTL($P(REC,U,17))
 ..E  S ONSET=$$FMTDATE^BGOUTL($P($G(^AUPNVPOV(IEN,9999999)),U,17))
 ..S IDT=$$FMTDATE^BGOUTL($P(REC,U,13))
 ..S IPL=$P(REC,U,11)
 ..S IPL=$$EXTERNAL^DILFD(FNUM,.11,,IPL)_"~"_IPL
 ..S ICCIEN=$P(REC,U,9)
 ..S (ICCODE,ICAU)=""
 ..;IHS/MSC/MGH Patch 12
 ..S:ICCIEN ICAU=$P($$ICDDX^ICDEX(ICCIEN,VDATE,"","I"),U,4),ICCODE=$P($$ICDDX^ICDEX(ICCIEN,VDATE,"","I"),U,2)
 ..;CHECK FOR ASTHMA DX PATCH 10 check for entry only on this visit
 ..S CONTROL=""
 ..;MSC/DKA Patch 13 - Add SNOMED CT and Provider Text
 ..S SMDATA=$G(^AUPNVPOV(IEN,11)),SMCNCPCT=$P(SMDATA,U,1)
 ..S SMCNCP=$$CONC^BSTSAPI(SMCNCPCT_"^^^1")
 ..S SNOMEDCT=$P(SMCNCP,U,3),SNOMEDTX=$P(SMCNCP,U,4)
 ..;S PROVTEXT=$P($P(SNOMEDCT,U,4),"|",2)
 ..S PROVTEXT=$P(PNAR,"|",2)
 ..;IHS/MSC/MGH Add in SNOMED code for asthma check
 ..I DUZ("AG")="I" D
 ...S ASTHMA=$$CHECK^BGOASLK(ICD,SNOMEDCT)
 ...I ASTHMA=1 D
 ....S LEVEL=$$ACONTROL^BGOASLK(DFN,VIEN)
 ....;Patch 20 return both IEN and control
 ....S CONTROL=$P(LEVEL,U,2)_";"_$P(LEVEL,U)
 ....I LEVEL=""  S CONTROL=";NONE RECORDED"
 ..S QUAL=$$GETQUAL^BGOVPOV1(IEN)
 ..S EPIS=$P(QUAL,U,2),QUAL=$P(QUAL,U,1)
 ..S PROB=$P(REC,U,16)
 ..S NORM=$$GET1^DIQ(9000010.07,IEN,.29,"I")   ;P18
 ..I NORM'="" D
 ...D GETLST^XPAR(.LST,"ALL","BGO NORMAL/ABNORMAL")
 ...F I=1:1:LST D
 ....S ITEM=$P(LST(I),";",3)
 ....I ITEM=NORM S NORM=NORM_";"_$P($P(LST(I),U,2),";",1)
 ..;IHS/MSC/MGH return laterality
 ..S LAT=$$GET1^DIQ(9000010.07,IEN,1104)   ;p20
 ..I LAT'="" D
 ...S LATEXT=$$CVPARM^BSTSMAP1("LAT",$P(LAT,"|",2))
 ..;S CNT=CNT+1,@RET@(CNT)=IEN_U_VDATE_U_FAC_U_FACNAM_U_ICD_U_U_PNAR_U_MOD_U_ONSET_U_STAGE_U_REVISIT_U_CAUSE_U_IDT_U_ICAU_U_IPL_U_PRIM_U_PRV_U_VIEN_U_$$ISLOCKED^BEHOENCX(VIEN)_U_CONTROL
 ..S LINE=IEN_U_VDATE_U_FAC_U_FACNAM_U_ICD_U_EPIS_U_PNAR_U_MOD_U_ONSET_U_STAGE_U_REVISIT_U_CAUSE_U_IDT_U_ICAU
 ..S LINE=LINE_U_IPL_U_PRIM_U_PRV_U_VIEN_U_$$ISLOCKED^BEHOENCX(VIEN)_U_CONTROL_U_SNOMEDTX_U_PROVTEXT_U_QUAL_U_PROB_U_ICCODE_U_ICDNAME_U_POV_U_NORM_U_LATEXT
 ..S CNT=CNT+1,@RET@(CNT)=LINE
 Q
 ; Delete a VPOV entry
DEL(RET,VPOV,PROB) ;EP
 N IEN,VIEN,FDA,OKAY,ERR
 I $G(PROB) D
 .S VIEN=$P($G(^AUPNVPOV(VPOV,0)),U,3)
 .Q:'+VIEN
 .S IEN="" S IEN=$O(^AUPNPROB(PROB,14,"B",VIEN,IEN)) Q:'+IEN  D
 ..S FDA(9000011.14,IEN_","_PROB_",",.01)="@"
 ..D UPDATE^DIE("","FDA","OKAY","ERR")
 D VFDEL^BGOUTL2(.RET,$$FNUM,VPOV)
 Q
 ; Checks validity of ICD code
 ;  ICDIEN = ICD IEN
 ;  ACTDT  = Active Date
 ;  Returns null if valid or -n^error text if not
CHKICD(ICDIEN,ACTDT) ;EP
 N RET,X
 S RET=""
 S ACTDT=$G(ACTDT,DT)
 ;IHS/MSC/MGH Patch 12
 S X=$$ICDDX^ICDEX(ICDIEN,ACTDT,"","I")
 I X<0 S RET=$$ERR^BGOUTL(1092)
 E  I '$P(X,U,10) S RET=$$ERR^BGOUTL(1093)
 I RET'="" Q RET
 I $P(X,U,11)'="",$P(X,U,11)'=$P(^DPT(DFN,0),U,2) S RET=$$ERR^BGOUTL(1095)
 E  S RET=""
 Q RET
 ;
CHRTREVW(RET,VIEN) ;EP
 N VCODE,SNO,X,DESC,TXT,IMP,VDTE,FAC,PICD
 S RET=0
 S VDTE=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 S VCODE=$$GET^XPAR("ALL","BGO POV DEFAULT CHART",1,"E")  ;P6
 S FAC=$$GET1^DIQ(9000010,VIEN,.06,"I")
 ;P14 Changes added for ICD-10 conversion
 I $$AICD^BGOUTL2 D
 .S IMP=$$IMP^ICDEX("10D",DT)
 .I IMP<VDTE&(VCODE["V") S VCODE="Z02.9"
 .;I VCODE="" D
 .;.I IMP<VDTE S VCODE="Z02.9"
 .;.E  S VCODE="V68.9"
 E  I VCODE="" S VCODE="V68.9"
 S SNO=107728002
 S X=$$CONC^BSTSAPI(SNO_"^^^1")
 Q:X=""
 S DESC=$P(X,U,3)
 S PICD=$P(X,U,5)
 S TXT="CHART REVIEW"
 D TELECHRT(.RET,VIEN,"C",VCODE,TXT,SNO,DESC,FAC,PICD)
 Q
 ;
TELEPHON(RET,VIEN) ;EP
 N VCODE,SNO,X,DESC,TXT,VDTE,PICD
 S RET=0
 S VDTE=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 S VCODE=$$GET^XPAR("ALL","BGO POV DEFAULT TELEPHONE",1,"E")  ;P6
 S FAC=$$GET1^DIQ(9000010,VIEN,.06,"I")
 ;Changes added for ICD-10 conversion
 I $$AICD^BGOUTL2 D
 .S IMP=$$IMP^ICDEX("10D",DT)
 .I IMP<VDTE&(VCODE["V") S VCODE="Z71.9"
 E  I VCODE="" S VCODE="V65.9"
 S SNO=185317003
 S X=$$CONC^BSTSAPI(SNO_"^^^1")
 Q:X=""
 S DESC=$P(X,U,3)
 S PICD=$P(X,U,5)
 S TXT="TELEPHONE CALL"
 D TELECHRT(.RET,VIEN,"T",VCODE,TXT,SNO,DESC,FAC,PICD)
 Q
TELECHRT(RET,VIEN,VCAT,VCODE,TXT,SNO,DESC,FAC,PICD) ;
 N DFN,X,DEL,SPROB,PROB,SPEC,PROBSTAT
 Q:$$ISLOCKED^BEHOENCX(VIEN)
 S SPEC=1
 S X=$G(^AUPNVSIT(+VIEN,0))
 S DFN=$P(X,U,5)
 Q:'DFN
 Q:$P(X,U,7)'=VCAT
 I '$D(^AUPNVPOV("AD",VIEN)) D
 .;Next, see if this already exists as a problem on the patients list
 .S MATCH=0,SPROB=""
 .S PROB="" F  S PROB=$O(^AUPNPROB("APCT",DFN,SNO,PROB)) Q:PROB=""!(MATCH=1)  D
 ..S DEL=$$GET1^DIQ(9000011,PROB,2.02)
 ..I DEL="" S MATCH=1,SPROB=PROB
 .S PROBSTAT=$$GET1^DIQ(9000011,SPROB,.12,"I")
 .I PROBSTAT'="R" D UPSTAT^BGOPROB2(SPROB,"R")     ;P20
 .I 'SPROB S SPROB=$$ADDPROB^BGOCPTP3(DFN,SNO,DESC,VCODE,FAC,SPEC,"Routine/Admin")
 .D SET(.RET,U_VIEN_U_SPROB_U_DFN_U_TXT_U_DESC_U_SNO_U_VCODE,"","","",SPEC)
 Q
 ; Add/Edit VPOV data
 ;  INP = VPOV IEN [1] ^ Visit IEN [2] ^ Problem IEN [3] ^ Patient IEN [4] ^ Prov Text [5] ^ Descriptive CT [6] ^
 ;        SNOMED CT [7] ^ ICD code [8] ^ Primary/Secondary [9] ^ Provider IEN [10]^ asthma control [11] ^ norm/abn [12] ^ laterality [13]
 ;  QUAL = Q[1] ^ TYPE [2] ^IEN (If edit)  [3] ^ SNOMED [4] ^ BY [5] ^ WHEN [6] ^DEL [7]
 ;  INJ  = Cause DX[1] ^ Injury Code [2] ^ Injury Place [3] ^ First/Revisit [4] ^ Injury Dt [5] ^ Onset Date [6]
 ;  NORM = normal/abnormal codes
 ;  SPEC = Special cases
SET(RET,INP,QUAL,INJ,NORM,SPEC) ;EP
 N VIEN,FNUM,OFF,VFIEN,PRIEN,RET2,ADD,ADDICD,ADDIEN,DFN,DUP,FIVE
 S RET="",FNUM=$$FNUM,RET2="",DUP="",FIVE=""
 S SPEC=$G(SPEC)
 S INJ=$G(INJ)
 S QUAL=$G(QUAL)
 S NORM=$G(NORM)
 S VIEN=$P(INP,U,2)
 ;MSC/MGH - 07/08/09 - Offset to support VistA and RPMS
 S OFF=$S($G(DUZ("AG"))="I":0,1:9999999)
 S VFIEN=+INP
 S PRIEN=$P(INP,U,3)
 S DFN=$P(INP,U,4)
 ;Check to see if it was missed
 N X,Y,MATCH
 S MATCH=0
 ;IHS/MSC/MGH changed for edits now since ICD can change
 ;I +VFIEN S SPEC=1
 I 'VFIEN D
 .Q:PRIEN=""
 .S X="" F  S X=$O(^AUPNVPOV("AD",VIEN,X)) Q:X=""!(MATCH=1)  D
 ..S Y=$P($G(^AUPNVPOV(X,0)),U,16)
 ..I Y=PRIEN S VFIEN=X,MATCH=1
 D SET2^BGOVPOV2(.RET,INP,QUAL,INJ,VFIEN,.DUP,.FIVE,SPEC,NORM)            ;Set the main ICD as POV
 ;Check for additional ICDs
 D ADDICD^BGOVPOV2(.RET,INP,QUAL,INJ,VFIEN,.DUP,.FIVE,SPEC)
 ;Add updated/reviewed data
 D UPREV^BGOVPOV1(.RET2,DFN,VIEN)
 Q
 ; Check validity of an ICD9 code
 ;  INP = ICD IEN ^ Patient IEN ^ Visit Date ^ SNOMED ^ Laterality
 ; .RET = Returned as -1^Reason if not valid or null if valid
CHECK(RET,INP) ;EP
 ;Patch 11 changed input to fileman date
 N DFN,ICDIEN,VDT,X,ANSWER,PVIEN,ITEM,ITEM2,SNO,LAT,ITEM3
 S ANSWER=""
 S RET=""
 S ICDIEN=+INP
 Q:'ICDIEN
 S DFN=$P(INP,U,2)
 S VDT=$P(INP,U,3)
 S SNO=$P(INP,U,4)
 S LAT=$P(INP,U,5)
 I VDT["/" D DT^DILF("T",VDT,.ANSWER)
 I ANSWER'=-1 S VDT=ANSWER
 S RET=$$CHKICD(ICDIEN,VDT)
 I RET="" D
 .S PVIEN="" F  S PVIEN=$O(^AUPNVPOV("AD",VIEN,PVIEN)) Q:PVIEN=""  D
 ..S ITEM=$P($G(^AUPNVPOV(PVIEN,0)),U,1)
 ..;I ITEM=ICDIEN S RET="-1^ICD already used in this visit"
 ..S ITEM2=$P($G(^AUPNVPOV(PVIEN,11)),U,1)
 ..S ITEM3=$P($G(^AUPNVPOV(PVIEN,11)),U,4)
 ..I SNO]"",ITEM2=SNO,ITEM=ICDIEN,ITEM3=LAT S RET="-99^SNOMED/Laterality code already used in this visit"
 Q
 ; Return recent POV's by patient or by visit
 ;  INP = Patient IEN ^ Max Records ^ Visit IEN
 ;  RET returned as a list of records in the format:
 ;    Visit Date [1] ^ Facility ID [2] ^ Facility Name [3] ^ ICD Code [4] ^ ICD Text [5] ^
 ;    Provider Narrative [6] ^ V POV IEN [7] ^ Visit IEN [8] ^ ICD IEN [9] ^ Visit Locked [10] ^
 ;    Onset Date [11] ^ Asthma Control [12] ^ SNOMED CT [13]
RECENT(RET,INP) ;EP
 N DFN,CNT,VIEN,MAX,VPOV,VDT
 S RET=$$TMPGBL^BGOUTL
 S DFN=$P(INP,U)
 S MAX=$P(INP,U,2)
 S:'MAX MAX=9999
 S VIEN=$P(INP,U,3)
 S CNT=0
 D RECBYVIS:VIEN,RECBYPAT:'VIEN
 Q
 ; VPOV's by patient
RECBYPAT S VDT=0
 F  S VDT=$O(^AUPNVPOV("AA",DFN,VDT)) Q:'VDT  D  Q:CNT'<MAX
 .S VPOV=0
 .F  S VPOV=$O(^AUPNVPOV("AA",DFN,VDT,VPOV)) Q:'VPOV  D RECBUILD Q:CNT'<MAX
 Q
 ; VPOV's by visit
RECBYVIS S VPOV=0
 F  S VPOV=$O(^AUPNVPOV("AD",VIEN,VPOV)) Q:'VPOV  D RECBUILD
 Q
RECBUILD N REC,POV,ICD,ICDNAME,VIEN,F,FAC,FACNAM,VSIT,VDATE,PNAR,ONSET,CONTROL,SNOMED,DESCT
 S REC=$G(^AUPNVPOV(VPOV,0))
 S POV=+REC
 Q:'POV
 S VIEN=$P(REC,U,3)
 Q:'VIEN
 S VSIT=$G(^AUPNVSIT(VIEN,0))
 S F=$P(VSIT,U,6)
 I F S FAC=$P($G(^AUTTLOC(F,0)),U,10),FACNAM=$P($G(^(0)),U)
 E  S (FAC,FACNAM)=""
 S:FACNAM FACNAM=$P($G(^DIC(4,FACNAM,0)),U)
 S VDATE=$$FMTDATE^BGOUTL(+VSIT)
 ;Patch 12
 S ICD=$P($$ICDDX^ICDEX(POV,VDATE,"","I"),U,2)
 S ICDNAME=$P($$ICDDX^ICDEX(POV,VDATE,"","I"),U,4)
 Q:ICDNAME=""
 ;end patch 12 changes
 S PNAR=$$GET1^DIQ(9000010.07,VPOV,.04)
 Q:PNAR=""
 S SNOMED=$$GET1^DIQ(9000010.07,VPOV,1101)
 S DESCT=$$GET1^DIQ(9000010.07,VPOV,1102)
 S ONSET=$$FMTDATE^BGOUTL($P(REC,U,17))
 ;CHECK FOR ASTHMA DX PATCH 10 check for entry only on this visit
 S CONTROL=""
 I DUZ("AG")="I" D
 .S ASTHMA=$$CHECK^BGOASLK(ICD,DESCT)
 .I ASTHMA=1 S CONTROL=$P($$ACONTROL^BGOASLK(DFN,VIEN),U) I CONTROL=""  S CONTROL="NONE RECORDED"
 S CNT=CNT+1
 S @RET@(CNT)=VDATE_U_FAC_U_FACNAM_U_ICD_U_ICDNAME_U_PNAR_U_VPOV_U_VIEN_U_POV_U_$$ISLOCKED^BEHOENCX(VIEN)_U_ONSET_U_CONTROL_U_SNOMED
 Q
ASTHMA(DFN,CONTROL,VIEN) ;Find last control, if it has changed store the change
 N LEVEL,INP,RET,RETURN,AIEN
 Q:CONTROL="@"
 ;IHS/MSC/MGH change in patch 10 to always store, not just if a change
 S RETURN=$$ACONTROL^BGOASLK(DFN,VIEN)
 S LEVEL=$P(RETURN,U,1),AIEN=$P(RETURN,U,2)
 I LEVEL'=CONTROL D
 .S INP=AIEN_U_VIEN_U_CONTROL
 .D SET^BGOVAST(.RET,INP)
 Q
 ; Return V File #
FNUM() Q 9000010.07
