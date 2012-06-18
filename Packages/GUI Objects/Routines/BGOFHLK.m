BGOFHLK ; IHS/BAO/TMD - FHL - PROGRAM TO GET LIST OF DIAGNOSES ;15-Jan-2009 09:33;MGH
 ;;1.1;BGO COMPONENTS;**6**;Mar 20, 2007
 ;---------------------------------------------------------------
 ; Lookup ICD's matching input
 ;  INP = Lookup Value [1] ^ Visit Date [2] ^ Patient Gender [3]
 ;        ^ FROM [4], TO [5]
 ;  Returned as a list of records in the format:
 ;    Descriptive Text [1] ^ ICD IEN [2] ^ Narrative Text [3] ^ ICD Code [4]
ICDLKUP(RET,INP) ;PEP - ICD lookup
 N LKUP,VDT,SEX,CNT,DIC,X,Y,I,ICD,FROM,TO,CNT
 N AICDRET,XTLKSAY,REC,DESC,CODE,NARR
 S RET=$$TMPGBL^BGOUTL
 S LKUP=$P(INP,U)
 S FROM=$P(INP,U,4)
 S TO=$P(INP,U,5)
 S VDT=$$CVTDATE^BGOUTL($P(INP,U,3))
 S SEX=$P(INP,U,3)
 S CNT=0
 I LKUP'="" D
 .S DIC="^ICD9(",DIC(0)="TM",X=LKUP,XTLKSAY=0
 .K ^UTILITY("AICDHITS",$J),^TMP("XTLKHITS",$J)
 .D ^DIC
 .I Y'=-1 D
 ..S ICD=+Y
 ..D CHKHITS
 .I 'CNT,$L(LKUP)>2 D
 ..N LK,LN
 ..S LK=LKUP,LN=$L(LKUP)
 ..F  D  S LK=$O(^ICD9("BA",LK)) Q:$E(LK,1,LN)'=LKUP
 ...S ICD=0
 ...F  S ICD=$O(^ICD9("BA",LK,ICD)) Q:'ICD  D CHKHITS
 I LKUP="" D
 . N LK,LK1
 .I FROM="" S FROM="V16"
 .I TO="" S TO="V20.0"
 .S LK=FROM F  S LK=$O(^ICD9("AB",LK)) S LK1=$E(LK,2,$L(LK))  Q:LK=TO!(LK1>19.9)  D
 ..S ICD="" F  S ICD=$O(^ICD9("AB",LK,ICD)) Q:'ICD  D CHKHITS
 K @RET@(0)
 Q
CHKHITS ;Q:$D(@RET@(0,ICD))  S ^(ICD)=""
 N OK,RECN
 S REC=$G(^ICD9(ICD,0))
 Q:$P(REC,U,9)
 S RECN=$P(REC,U,1)
 S OK=$$CHKFH^AUPNSICD(ICD)
 I OK=0 Q
 I VDT,$P(REC,U,11),$$FMDIFF^XLFDT(VDT,$P(REC,U,11))>-1 Q
 I $L(SEX),$P(REC,U,10)'="",SEX'=$P(REC,U,10) Q
 S NARR=$G(^ICD9(ICD,1)),CODE=$P(REC,U),DESC=$P(REC,U,3)
 S CNT=CNT+1
 S @RET@(CNT)=DESC_U_ICD_U_NARR_U_CODE
 Q
CHKFH ;Family history lookup
