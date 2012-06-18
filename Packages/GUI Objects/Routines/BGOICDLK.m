BGOICDLK ; IHS/BAO/TMD - FHL - PROGRAM TO GET LIST OF DIAGNOSES ;01-Jun-2011 13:24;DU
 ;;1.1;BGO COMPONENTS;**1,3,6,8,9**;Mar 20, 2007
 ;---------------------------------------------------------------
 ; Lookup ICD's matching input
 ;  INP = Lookup Value [1] ^ Use Lexicon [2] ^ Visit Date [3] ^
 ;        Patient Gender [4] ^ ECodes [5] ^ VCodes [6]
 ;   where ECodes = 0: exclude, 1: include, 2: only ecodes
 ;         VCodes = 0: include, 1: exclude, 2: only vcodes
 ;  Returned as a list of records in the format:
 ;    Descriptive Text [1] ^ ICD IEN [2] ^ Narrative Text [3] ^ ICD Code [4]
ICDLKUP(RET,INP) ;PEP - ICD lookup
 N LKUP,VDT,SEX,ECD,VCD,CNT,DIC,X,Y,I,ICD,LEX,RES
 N AICDRET,XTLKSAY,REC,DESC,CODE,NARR
 S RET=$$TMPGBL^BGOUTL
 S LKUP=$P(INP,U)
 S LEX=$P(INP,U,2)
 S VDT=$$CVTDATE^BGOUTL($P(INP,U,3))
 S SEX=$P(INP,U,4)
 S ECD=$P(INP,U,5)
 S VCD=$P(INP,U,6)
 S CNT=0
 I LEX D
 .N HITS
 .D LEXLKUP^BGOUTL(.HITS,LKUP_"^ICD")
 .S HITS=0
 .F  S HITS=$O(HITS(HITS)) Q:'HITS  D
 ..S LEX=+HITS(HITS)
 ..S X=$$ICDONE^LEXU(LEX)
 ..Q:X=""
 ..S ICD=$O(^ICD9("BA",X,0))
 ..S:'ICD ICD=$O(^ICD9("BA",X_" ",0))
 ..D:ICD CHKHITS
 E  I $G(DUZ("AG"))="I"  D
 .S DIC="^ICD9(",DIC(0)="TM",X=LKUP,XTLKSAY=0
 .K ^UTILITY("AICDHITS",$J),^TMP("XTLKHITS",$J)
 .D ^DIC
 .I Y'=-1 D
 ..S ICD=+Y
 ..D CHKHITS
 .E  I $G(^DD(80,0,"DIC"))="XTLKDICL" D
 ..D XTLKUP
 .E  D AICDLKUP
 .I 'CNT,$L(LKUP)>2 D
 ..N LK,LN
 ..S LK=LKUP,LN=$L(LKUP)
 ..F  D  S LK=$O(^ICD9("BA",LK)) Q:$E(LK,1,LN)'=LKUP
 ...S ICD=0
 ...F  S ICD=$O(^ICD9("BA",LK,ICD)) Q:'ICD  D CHKHITS
 .K ^UTILITY("AICDHITS",$J),^TMP("XTLKHITS",$J)
 E  D
 .D FIND^DIC(80,,".01;10","M",LKUP,,,,,"RES")
 .I '$O(RES("DILIST",0)) Q
 .M ^TMP("XTLKHITS",$J)=RES("DILIST",2)
 .D XTLKUP
 .K ^TMP("XTLKHITS",$J)
 K @RET@(0)
 Q
AICDLKUP S I=0
 F  S I=$O(^UTILITY("AICDHITS",$J,I)) Q:'I  D
 .S ICD=$G(^UTILITY("AICDHITS",$J,I))
 .D CHKHITS
 Q
XTLKUP S I=0
 F  S I=$O(^TMP("XTLKHITS",$J,I)) Q:'I  D
 .S ICD=$G(^TMP("XTLKHITS",$J,I))
 .D CHKHITS
 Q
CHKHITS Q:$D(@RET@(0,ICD))  S ^(ICD)=""
 I $$CSVACT^BGOUTL2("ICDCODE") D
 .S IEN=$$ICDDX^ICDCODE(ICD,VDT)
 .I IEN>0&($P(IEN,U,10)=1) D     ;PATCH 8
 ..S CNT=CNT+1
 ..;Patch 9
 ..S NARR=$G(^ICD9(ICD,1))
 ..I NARR="" S NARR=$P(IEN,U,4)
 ..S @RET@(CNT)=$P(IEN,U,4)_U_ICD_U_NARR_U_$P(IEN,U,2)
 E  D
 .S REC=$G(^ICD9(ICD,0))
 .Q:$P(REC,U,9)
 .I 'ECD,$E(REC)="E" Q
 .I ECD=2,$E(REC)'="E" Q
 .I VCD=1,$E(REC)="V" Q
 .I VCD=2,$E(REC)'="V" Q
 .I VDT,$P(REC,U,11),$$FMDIFF^XLFDT(VDT,$P(REC,U,11))>-1 Q
 .I $L(SEX),$P(REC,U,10)'="",SEX'=$P(REC,U,10) Q
 .S NARR=$G(^ICD9(ICD,1)),CODE=$P(REC,U),DESC=$P(REC,U,3)
 .S CNT=CNT+1
 .S @RET@(CNT)=DESC_U_ICD_U_NARR_U_CODE
 Q
 ; Retrieve diagnosis list
DXLIST(RET,INP) ;PEP - retrieve dx list
 N LKUP,VDT,SEX,ECD,VCD
 S LKUP=$P(INP,U)
 S MAX=$P(INP,U,2)
 S MORE=$P(INP,U,3)
 S VDT=$P(INP,U,4)
 S SEX=$P(INP,U,5)
 S ECD=$P(INP,U,6)
 S VCD=$P(INP,U,7)
 D ICDLKUP(.RET,LKUP_U_VDT_U_SEX_U_ECD_U_VCD)
 Q
