BTIUPCC3 ;IHS/CIA/MGH - TIU Object Support ;28-May-2010 09:53;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1003,1004,1005,1006**;NOV 04,2004
 ;IHS/CIA/MGH New routine for objects added for TIU use
 ;Patch 1006 incorporated reproductive history field changes
REPRO(DFN,TARGET) ;EP Return reproductive history
 N TOT,GRAV,CNT,PARA,LC,SA,TA,X,OTHER,BTIUN,BTIUM,G,MB,FT,PRE,EC
 K @TARGET
 I $P(^DPT(DFN,0),U,2)="M" S @TARGET@(1,0)="Patient is male" G END
 I '$D(^AUPNREP(DFN,0)) S @TARGET@(1,0)="No history on file" G END
 S BTIUN=$G(^AUPNREP(DFN,0))
 S G=$$GET1^DIQ(9000017,+$G(DFN),1103)
 I G="" D OLD
 E  D NEW
END Q "~@"_$NA(@TARGET)
NEW ;Get the reproductive history using the new fields
 S MB=$$GET1^DIQ(9000017,+$G(DFN),1105)
 S FT=$$GET1^DIQ(9000017,+$G(DFN),1107)
 S PRE=$$GET1^DIQ(9000017,+$G(DFN),1109)
 S EC=$$GET1^DIQ(9000017,+$G(DFN),1111)
 S LC=$$GET1^DIQ(9000017,+$G(DFN),1113)
 S TA=$$GET1^DIQ(9000017,+$G(DFN),1131)
 S SA=$$GET1^DIQ(9000017,+$G(DFN),1133)
 S CNT=1
 S @TARGET@(CNT,0)="Gravida: "_G
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Multiple Births: "_MB
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Full Term: "_FT
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Premature Births: "_PRE
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Ectopics: "_EC
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Living Children: "_LC
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Theraputic Abortions: "_TA
 S CNT=CNT+1
 S @TARGET@(CNT,0)="Spontaneous Abortions: "_SA
 D LMP
 Q
OLD ;Get the reproductive history using the old fields
 S X=$P(BTIUN,U,2)
 ;Patch 1005 upgraded the reproductive history
 I X]"" D
 .S GRAV=$P(X,"P",1),OTHER=$P(X,"P",2)
 .S PARA=$P(OTHER,"LC",1),OTHER=$P(OTHER,"LC",2)
 .S LC=$P(OTHER,"SA",1),OTHER=$P(OTHER,"SA",2)
 .S SA=$P(OTHER,"TA",1),OTHER=$P(OTHER,"TA",2)
 .S TA=OTHER
 .S TOT=GRAV_" P"_PARA_" LC"_LC_" SA"_SA_" TA"_TA
 .S CNT=1
 .S @TARGET@(CNT,0)=TOT_" (obtained on, "_$$GET1^DIQ(9000017,+$G(DFN),1.1)_")"
 .S X=$P(BTIUN,U,4) S:X="" X="<LMP not recorded>"
 .I +X  S X="LMP: "_$$GET1^DIQ(9000017,+$G(DFN),2)_" (recorded on, "_$$GET1^DIQ(9000017,+$G(DFN),2.1)_")"
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=X
 .D LMP
 Q
LMP ;Get the LMP data
 N FPBEGIN,FPDATE
 S X=$$GET1^DIQ(9000017,+$G(DFN),3)
 S CNT=CNT+1
 I X="" D
 .S @TARGET@(CNT,0)="FP METHOD: "_$S(X="":"None Recorded",1:X)
 E  D
 .S FPBEGIN=$$GET1^DIQ(9000017,DFN,3.05),FPDATE=$$GET1^DIQ(9000017,DFN,3.1)
 .S @TARGET@(CNT,0)="FP METHOD: "_X_" (begun "_FPBEGIN_"; recorded "_FPDATE_")"
 .S X=$P(BTIUN,U,9) I X]""  D EDC
 Q
EDC NEW X,HOW,EDCDT
 S X=$$GET1^DIQ(9000017,+$G(DFN),4)
 S CNT=CNT+1
 I X="" S @TARGET@(CNT,0)="EDC: "_$S(X="":"None Recorded",1:X) Q
 S HOW=$$GET1^DIQ(9000017,+DFN,4.05),EDCDT=$$GET1^DIQ(9000017,DFN,4.1)
 S @TARGET@(CNT,0)="EDC: "_X_" (determined by "_$S(HOW="":"UNKNOWN METHOD",1:HOW)_" on "_EDCDT_")"
 Q
SURG(DFN,DATE) ;EP
 ; returns multi-line listing of patient's surgical history;PATC
 ; If DATE=1, return date each item obtained
 NEW COUNT,TIUX,LINE,TIUA,BTIUIVD,BTIUSQ,BTIUDFN,BHSICD
 S COUNT=0
 K ^TMP("BTIUPCC3",$J)
 ;
 ; for this patient, find all surgical history entries
 S TIUX=0,LINE=""
 I '$D(^AUPNVPRC("AC",DFN)) S ^TMP("BTIUPCC3",$J,1,0)="No procedures found for pt"
 S COUNT=0
 S BTIUIVD=0 F BTIUSQ=0:0 S BTIUIVD=$O(^AUPNVPRC("AA",DFN,BTIUIVD)) Q:'BTIUIVD  D
 .S BTIUDFN=0 F BTIUDFN=0:0 S BTIUDFN=$O(^AUPNVPRC("AA",DFN,BTIUIVD,BTIUDFN)) Q:'BTIUDFN  D
 ..K TIUA D ENP^XBDIQ1(9000010.08,BTIUDFN,".01:.04","TIUA(")
 ..D HOSCHK
 ..I BHSICD'="" D
 ...S LINE=TIUA(.04)_" ["_TIUA(.019)_"]"     ;prov narrative [ICD dx code]
 ...I $G(DATE) S LINE=LINE_" - "_TIUA(.03)   ;date noted
 ...S COUNT=$G(COUNT)+1 S ^TMP("BTIUPCC3",$J,COUNT,0)=LINE
 ;
 ;Check for surgical CPT codes
 S BTIUIVD=0 F  S BTIUIVD=$O(^AUPNVCPT("C",DFN,BTIUIVD)) Q:'BTIUIVD  D
 .D CHKCPT
 I '$D(^TMP("BTIUPCC3",$J)) Q "No Surgical History Found for Patient"
 Q "~@^TMP(""BTIUPCC3"",$J)"
HOSCHK ;
 ;Check for real surgical codes
 I TIUA(.01)>85 S BHSICD="" Q
 I TIUA(.01)=69.7 S BHSICD="" Q
 I TIUA(.01)\1=23 S BHSICD="" Q
 I TIUA(.01)\1=24 S BHSICD="" Q
 I $E(TIUA(.01),1,4)="38.9" S BHSICD="" Q
 E  S BHSICD=1
 Q
CHKCPT ;Check for surgical CPT codes
 N REC,CPTIEN,CODE
 S REC=$G(^AUPNVCPT(BTIUIVD,0)) Q:REC=""
 S CPTIEN=$P(REC,U) Q:CPTIEN=""
 S CODE=$P($G(^ICPT(CPTIEN,0)),U) Q:CODE=""
 I ((CODE<10000)&(CODE'="00099"))!(CODE>69999) Q
 K TIUA D ENP^XBDIQ1(9000010.18,BTIUIVD,".01:.04","TIUA(")
 ;I TIUA(.04)="" Q
 S LINE=TIUA(.04)_" ["_TIUA(.019)_"]"     ;prov narrative [ICD dx cod
 I $G(DATE) S LINE=LINE_" - "_TIUA(.03)   ;date noted
 S COUNT=$G(COUNT)+1 S ^TMP("BTIUPCC3",$J,COUNT,0)=LINE
 Q
