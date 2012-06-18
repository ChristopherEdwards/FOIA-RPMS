BGOVCPT2 ; IHS/BAO/TMD - Manage V CPT PART 2 ;20-Jun-2011 09:51;DU
 ;;1.1;BGO COMPONENTS;**1,3,5,6,8,9**;Mar 20, 2007
 ;---------------------------------------------
 ; Lookup CPT code for input
 ;  INP = Lookup Text [1] ^ Use Lexicon [2] ^ Date [3] ^ Exclude Med [4] ^ Exclude Surg [5] ^
 ;        Exclude HCPCS [6] ^ Exclude E&M [7] ^ Exclude Rad [8] ^ Exclude Lab [9] ^
 ;        Exclude Anesth [10] ^ Exclude Home [11]
 ;  RET = List of CPT4 codes matching selection criteria in format:
 ;         Description ^ CPT IEN ^ CPT Code ^ Narrative
CPTLKUP(RET,INP) ;EP
 N LKUP,VDT,HCPCS,CNT,DIC,X,XTLKSAY,BGO,LEX,RES
 N HOME,MED,SURG,HCPCS,EM,RAD,LAB,ANEST,DATE
 S RET=$$TMPGBL^BGOUTL
 S LKUP=$P(INP,U)
 S LEX=$P(INP,U,2)
 S VDT=$$CVTDATE^BGOUTL($P(INP,U,3))
 ;IHS/MSC/MGH Patch 9 - make a vdate
 I VDT="" S DATE="TODAY",VDT=$$DT^CIAU(DATE)
 S MED=$P(INP,U,4)     ; Exclude MED
 S SURG=$P(INP,U,5)    ; Exclude SURG
 S HCPCS=$P(INP,U,6)   ; Exclude HCPCS
 S EM=$P(INP,U,7)      ; Exclude EM
 S RAD=$P(INP,U,8)     ; Exclude RAD
 S LAB=$P(INP,U,9)     ; Exclude LAB
 S ANEST=$P(INP,U,10)  ; Exclude ANEST
 S HOME=$P(INP,U,11)   ; Exclude HOME
 S CNT=0
 I LEX D
 .N HITS,CODE
 .D LEXLKUP^BGOUTL(.HITS,LKUP_U_"CHP")
 .S BGO=0
 .F  S BGO=$O(HITS(BGO)) Q:'BGO  D
 ..S X=+HITS(BGO)
 ..S CODE=$$CPTONE^LEXU(X)
 ..S:CODE="" CODE=$$CPCONE^LEXU(X)
 ..Q:CODE=""
 ..S CODE=$O(^ICPT("B",CODE,0))
 ..D:CODE CHKHITS(CODE)
 E  I $G(DUZ("AG"))="I"  D
 .K ^TMP("XTLKHITS",$J)
 .S DIC="^ICPT(",DIC(0)="TM",XTLKSAY=0,X=LKUP
 .D ^DIC
 .I Y'=-1 D
 ..D CHKHITS(Y)
 .E  D
 ..S BGO=0
 ..F  S BGO=$O(^TMP("XTLKHITS",$J,BGO)) Q:'BGO  D
 ...D CHKHITS($G(^TMP("XTLKHITS",$J,BGO)))
 .K ^TMP("XTLKHITS",$J)
 E  D
 .D FIND^DIC(81,,".01;2","M",LKUP,,,,,"RES")
 .Q:'$O(RES("DILIST",0))
 .M ^TMP("XTLKHITS",$J)=RES("DILIST",2)
 .S BGO=0 F  S BGO=$O(^TMP("XTLKHITS",$J,BGO)) Q:'BGO  D
 ..D CHKHITS($G(^TMP("XTLKHITS",$J,BGO)))
 .K ^TMP("XTLKHITS",$J)
 Q
 ; Add code to output if meets criteria
CHKHITS(CPTIEN) ;
 N N0,CODE,DESC,NARR,ISNUM,X,CHK
 S CPTIEN=+CPTIEN,N0=$G(^ICPT(CPTIEN,0))
 Q:'$L(N0)
 ;IHS/MSC/MGH Patch 9 for non-CSV sites
 I '$$CSVACT^BGOUTL2() D  I CHK=1 Q
 .S CHK=0
 .I $P(N0,U,4)=1 S CHK=1
 .I +$P(N0,U,7) S CHK=1
 S CODE=$P(N0,U),ISNUM=$TR(CODE,"0123456789")=""
 I ISNUM,MED,CODE>89999,CODE<99200 Q
 I ISNUM,SURG,CODE>9999,CODE<70000 Q
 I ISNUM,HCPCS,$E(CODE)?1A Q
 I ISNUM,EM,CODE>99200,CODE<99500 Q
 I ISNUM,HOME,CODE>99499,CODE<99605 Q
 I ISNUM,RAD,CODE>69999,CODE<80000 Q
 I ISNUM,LAB,CODE>79999,CODE<90000 Q
 I ISNUM,ANEST,CODE>0,CODE<10000 Q
 ;I VDT,$P(N0,U,7),$$FMDIFF^XLFDT(VDT,$P(N0,U,7))>-1 Q
 ;IHS/MSC/MGH added to check if code is effective on date
 ;IHS/MSC/MGH changed dates patch 9
 N XX S XX=DT_"^1"
 I VDT D  I $P(XX,U,2)'=1 Q
 .N CHKDT
 .S CHKDT=VDT I VDT<2890101 S CHKDT=2890101
 .I $$CSVACT^BGOUTL2() S XX=$$EFF^ICPTSUPT(81,CPTIEN,CHKDT)
 S DESC=$P(N0,U,2)
 S NARR="",X=0
 F  S X=$O(^ICPT(CPTIEN,"D",X)) Q:'X  S NARR=NARR_$S(NARR="":"",1:" ")_$P($G(^ICPT(CPTIEN,"D",X,0)),U)
 S:NARR="" NARR=DESC
 S CNT=CNT+1
 S @RET@(CNT)=DESC_U_CPTIEN_U_CODE_U_NARR
 Q
 ; Returns procedures for a visit as a single string
PRCSTR(RET,VCPT) ;EP
 N X,PRC
 S RET="",X=0,VCPT=+VCPT
 F  S X=$O(^AUPNVCPT("AD",VCPT,X)) Q:'X  D
 .S PRC=$P($G(^AUPNVCPT(X,0)),U)
 .S:PRC RET=RET_$S($L(RET):"; ",1:"")_$P($G(^ICPT(PRC,0)),U)
 Q
 ; Return CPT modifiers
 ;  INP = Reference CPT Code ^ Reference Date ^ CPT IEN
 ;  RET = Name ^ CPT Modifier Code ^ Modifier IEN
GETMODS(RET,INP) ;EP
 N NAME,MOD,CODE,CNT,REC,CPT,CDT,CPTIEN
 K RET
 S CNT=0,CPT=$P(INP,U),CDT=$P(INP,U,2),CPTIEN=$P(INP,U,3)
 I $$CSVACT^BGOUTL2("ICPTCOD") D
 .S CDT=$$CVTDATE^BGOUTL(CDT)
 .S:'CDT CDT=DT
 .Q:CPTIEN=""
 .;IHS/MSC/MGH account for dates prior to Jan 1,1990
 .I CDT<2890101 S CDT=2890101
 .D CODM^ICPTCOD(CPTIEN,"MOD",0,CDT)
 .S CODE=""
 .F  S CODE=$O(MOD(CODE)) Q:'$L(CODE)  D
 ..;PATCH 9 check each mod to see if it applicable
 ..S REC=MOD(CODE)
 ..S NAME=$P(REC,U)
 ..S MOD=$P(REC,U,2)
 ..S X=$$MODP^ICPTMOD(CPTIEN,MOD,"I")
 ..I X>0 D
 ...I NAME="" D
 ....S NAME=MOD
 ...S CNT=CNT+1,RET(CNT)=NAME_U_CODE_U_MOD
 E  D
 .S MOD=0
 .F  S MOD=$O(^AUTTCMOD(MOD)) Q:'MOD  D
 ..S REC=$G(^AUTTCMOD(MOD,0))
 ..S NAME=$P(REC,U,2)
 ..S CODE=$P(REC,U)
 ..Q:CODE=""
 ..I NAME="" D
 ...S NAME=CODE
 ..S CNT=CNT+1,RET(CNT)=NAME_U_CODE_U_MOD
 Q
 ; Screen modifiers against CPT code
CHKMOD(MOD,CPT) ;EP
 Q:'$$CSVACT^BGOUTL2("ICPTMOD") 1
 Q $$MODP^ICPTMOD(CPT,MOD,"I")>0
