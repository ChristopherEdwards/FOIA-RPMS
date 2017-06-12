BGOICDLK ; IHS/BAO/TMD - FHL - PROGRAM TO GET LIST OF DIAGNOSES ;06-Mar-2014 20:24;DU
 ;;1.1;BGO COMPONENTS;**1,3,6,8,9,12,14**;Mar 20, 2007;Build 5
 ;---------------------------------------------------------------
 ; Lookup ICD's matching input
 ;  INP = Lookup Value [1] ^ Use Lexicon [2] ^ Visit Date [3] ^
 ;        Patient Gender [4] ^ ECodes [5] ^ VCodes [6]
 ;   where ECodes = 0: exclude, 1: include, 2: only ecodes
 ;         VCodes = 0: include, 1: exclude, 2: only vcodes
 ;  Returned as a list of records in the format:
 ;    Descriptive Text [1] ^ ICD IEN [2] ^ Narrative Text [3] ^ ICD Code [4]
 ;  Patch 12 updated for new ICD lookup
ICDLKUP(RET,INP) ;PEP - ICD lookup
 N LKUP,VDT,SEX,ECD,VCD,CNT,DIC,X,Y,I,ICD,LEX,RES,IEN
 N AICDRET,XTLKSAY,REC,DESC,CODE,NARR,SYS,INJ,APP,IMP
 S RET=$$TMPGBL^BGOUTL
 S LKUP=$P(INP,U)
 S LEX=$P(INP,U,2)
 S VDT=$$CVTDATE^BGOUTL($P(INP,U,3))
 I VDT="" S VDT=DT
 S SEX=$P(INP,U,4)
 S ECD=$P(INP,U,5)
 S VCD=$P(INP,U,6)
 S CNT=0
 ;Patch 14 find coding system
 S SYS=$$IMP^AUPNSICD(VDT)
 S IMP=$$IMP^ICDEX("10D",DT)
 I LEX D
 .N HITS
 .I $$AICD^BGOUTL2 D
 ..S APP=$S(IMP<VDT:"10D",1:"ICD")
 .D LEXLKUP^BGOUTL(.HITS,LKUP_U_APP_U_VDT)
 .S HITS=0
 .F  S HITS=$O(HITS(HITS)) Q:'HITS  D
 ..S LEX=+HITS(HITS)
 ..;I APP="ICD" S X=$$ICDONE^LEXU(LEX.VDT,APP)
 ..S X=$$ONE^LEXU(LEX,VDT,APP)
 ..Q:X=""
 ..;S ICD=$O(^ICD9("BA",X,0))
 ..;S:'ICD ICD=$O(^ICD9("BA",X_" ",0))
 ..I $$AICD^BGOUTL2 S ICD=$P($$ICDDX^ICDEX(X,VDT),U,1)
 ..E  S ICD=$P($$ICDDX^ICDCODE(X,VDT),U,1)
 ..D:ICD CHKHITS
 E  I $G(DUZ("AG"))="I"  D
 .S DIC="^ICD9(",DIC(0)="TM",X=LKUP,XTLKSAY=0
 .K ^UTILITY("AICDHITS",$J),^TMP("XTLKHITS",$J)
 .D ^DIC
 .I $P(Y,U,1)'=-1 D
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
 I $$AICD^BGOUTL2 S IEN=$$ICDDX^ICDEX(ICD,VDT)
 E  S IEN=$$ICDDX^ICDCODE(ICD,VDT)
 ;I IEN>0&($P(IEN,U,10)=1) D     ;PATCH 8
 I +IEN>0&($P(IEN,U,12)="") D
 .S CNT=CNT+1
 .;Patch 12
 .I $$AICD^BGOUTL2 D
 ..S NARR=$$LD^ICDEX(80,+IEN,VDT)
 ..S INJ=$$CHKINJ(IEN,SYS)
 .E  D
 ..;Patch 9
 ..S NARR=$G(^ICD9(ICD,1))
 ..I NARR="" S NARR=$P(+IEN,U,4)
 ..S INJ=$$CHKINJ(IEN,SYS)
 .I 'ECD,INJ=1 Q
 .I ECD=2,INJ=0 Q
 .S @RET@(CNT)=$P(IEN,U,4)_U_ICD_U_NARR_U_$P(IEN,U,2)
 Q
CHKINJ(IEN,SYS) ;Check for an injury code
 N J
 S J=0
 ;Patch 14 changed injury code lookup
 I SYS=30 D
 .I $E($P(IEN,U,2),1)="V" S J=1  ;only codes V00-Y99 per Leslie Racine.
 .I $E($P(IEN,U,2),1)="W" S J=1
 .I $E($P(IEN,U,2),1)="X" S J=1
 .I $E($P(IEN,U,2),1)="Y" S J=1 D
 ..I $P(IEN,".",1)'="Y92" S J=1
 E  D
 .I $E($P(IEN,U,2))="E" S J=1
 Q J
 ; Retrieve diagnosis list
DXLIST(RET,INP) ;PEP - retrieve dx list
 N LKUP,VDT,SEX,ECD,VCD,MAX,MORE
 S LKUP=$P(INP,U)
 S MAX=$P(INP,U,2)
 S MORE=$P(INP,U,3)
 S VDT=$P(INP,U,4)
 S SEX=$P(INP,U,5)
 S ECD=$P(INP,U,6)
 S VCD=$P(INP,U,7)
 D ICDLKUP(.RET,LKUP_U_VDT_U_SEX_U_ECD_U_VCD)
 Q
