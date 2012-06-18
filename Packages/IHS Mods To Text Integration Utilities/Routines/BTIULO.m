BTIULO ; IHS/ITSC/LJF - CODE FOR IHS OBJECTS ;03-Aug-2009 17:16;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1001,1004,1006**;NOV 04, 2004
 ;Added EHR 1.1 call for finding a visit
 ;Added error message if visit not found
 ;
RELIGION(DFN) ;EP; Patient NAME
 Q $$GET1^DIQ(2,DFN,.08)
 ;
SU(DFN) ;EP; Patient Service Unit of Residence
 NEW X
 S X=$$GET1^DIQ(9000001,DFN,1117,"I")
 I X="" S X=$O(^AUPNPAT(DFN,51,""),-1) I X S X=$P(^AUPNPAT(DFN,51,X,0),U,3)
 I X="" Q "??"
 Q $$GET1^DIQ(9999999.05,+X,.05)
 ;
LASTDIFF(DFN,TYPE,VISIT) ;EP; returns last documnt of diff type for patient
 ;IHS/ITSC/LJF 01/13/2005 PATCH 1001 - code added to accommodate calls from EHR
 ; TYPE=Title IEN
 ; if visit not sent, assume called by EHR and look for visit context
 I '$G(VISIT) D  I $G(VISIT)<1 Q "Invalid visit "
 . I $T(GETVAR^CIAVMEVT)="" S VISIT=0 Q
 . NEW VST,X
 . S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 . I VST="" S VISIT=0 Q
 . S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S VISIT=VST Q
 . ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 . S VISIT=VST
 ;IHS/ITSC/LJF 01/13/2005 end of new code
 ;
 NEW DATE
 S DATE=$$GET1^DIQ(9000010,VISIT,.01,"I") I DATE="" Q ""
 S DATE=$O(^TIU(8925,"AA",DFN,TYPE,9999999-(DATE+1))) I DATE="" Q ""
 Q $$FMTE^XLFDT(9999999-DATE,"1D")
 ;
AGE(DFN) ;EP; returns printable age
 Q $$LOW^XLFSTR($$GET1^DIQ(9000001,DFN,1102.98)_" old")
 ;
PTED(VISIT) ;EP; returns all pat ed topics for visit
 NEW TIUX,TIUY
 S TIUX=0,TIUY="" F  S TIUX=$O(^AUPNVPED("AD",VISIT,TIUX)) Q:'TIUX  D
 . S TIUY=TIUY_$$GET1^DIQ(9000010.16,TIUX,.01)_";"
 Q $S(TIUY="":"",1:$P(TIUY_";",";;"))
 ;
TAXDX(DFN,TAXNM) ;EP; returns dx date and prov narrative
 ; TAXNM=taxonomy name
 NEW TAX,RDT,LINE,IEN,TIUR
 S LINE="",TAX=$O(^ATXAX("B",TAXNM,0)) I TAX="" Q ""
 S RDT=0 F  S RDT=$O(^AUPNVPOV("AA",DFN,RDT)) Q:'RDT!(LINE]"")  D
 . S IEN=0 F  S IEN=$O(^AUPNVPOV("AA",DFN,RDT,IEN)) Q:'IEN!(LINE]"")  D
 .. Q:'$$ICD^ATXCHK(+$G(^AUPNVPOV(IEN,0)),TAX,9)
 .. K TIUR D ENP^XBDIQ1(9000010.07,IEN,".03;.04;.13;.17","TIUR(")
 .. S LINE=$S(TIUR(.13)]"":TIUR(.13),TIUR(.17)]"":TIUR(.17),1:TIUR(.03))
 .. S LINE=LINE_"   "_TIUR(.04)
 Q LINE
 ;
TAXOP(DFN,TAXNM) ;EP; returns op/proc date and prov narrative
 ; TAXNM=taxonomy name
 NEW TAX,RDT,LINE,IEN,TIUR
 S LINE="",TAX=$O(^ATXAX("B",TAXNM,0)) I TAX="" Q ""
 S RDT=0 F  S RDT=$O(^AUPNVPRC("AA",DFN,RDT)) Q:'RDT!(LINE]"")  D
 . S IEN=0 F  S IEN=$O(^AUPNVPRC("AA",DFN,RDT,IEN)) Q:'IEN!(LINE]"")  D
 .. Q:'$$ICD^ATXCHK(+$G(^AUPNVPRC(IEN,0)),TAX,0)
 .. K TIUR D ENP^XBDIQ1(9000010.08,IEN,".03;.04;.06","TIUR(")
 .. S LINE=$S(TIUR(.06)]"":TIUR(.06),1:TIUR(.03))
 .. S LINE=LINE_"   "_TIUR(.04)
 Q LINE
 ;
NEXTAPPT(DFN) ;EP; returns patient's next appt
 NEW DATE,YES,DATA,CLN,X,LINE,OI
 K ^TMP("BTIULO",$J)
 S DATE=$$NOW^XLFDT,YES=0
 F  S DATE=$O(^DPT(DFN,"S",DATE)) Q:'DATE!(YES)  D
 . S DATA=$G(^DPT(DFN,"S",DATE,0)) Q:DATA=""
 . Q:$P(DATA,U,2)["C"  ;cancelled
 . S X=0 F  S X=$O(^SC(+DATA,"S",DATE,1,X)) Q:'X  D
 .. Q:+$G(^SC(+DATA,"S",DATE,1,X,0))'=DFN
 .. S OI="  "_$P($G(^SC(+DATA,"S",DATE,1,X,0)),U,4)  ;other info
 .. S YES=DATE_U_+DATA_U_OI
 I 'YES Q "Next Appt:  None Found"
 S LINE="Next Appt: "_$$FMTE^XLFDT(+YES,"1P")_" with "
 S LINE=LINE_$$GET1^DIQ(44,$P(YES,U,2),.01)
 S ^TMP("BTIULO",$J,1,0)=LINE,^TMP("BTIULO",$J,2,0)=OI
 Q "~@^TMP(""BTIULO"",$J)"
 ;
FUTAPPT(DFN) ;EP; returns patient's future appts
 NEW DATE,DATA,CLN,X,LN,CNT,OI
 K ^TMP("BTIULO",$J)
 S DATE=$$NOW^XLFDT,CNT=1
 F  S DATE=$O(^DPT(DFN,"S",DATE)) Q:'DATE  D
 . S DATA=$G(^DPT(DFN,"S",DATE,0)) Q:DATA=""
 . Q:$P(DATA,U,2)["C"  ;cancelled
 . S X=0 F  S X=$O(^SC(+DATA,"S",DATE,1,X)) Q:'X  D
 .. Q:+$G(^SC(+DATA,"S",DATE,1,X,0))'=DFN
 .. S OI=$$SP(10)_$P($G(^SC(+DATA,"S",DATE,1,X,0)),U,4)  ;other info
 .. S LN=$$FMTE^XLFDT(+DATE,"1P")
 .. S LN=LN_" ("_$P($G(^SC(+DATA,"S",DATE,1,X,0)),U,2)_" MINUTES)"
 .. S LN=LN_" with "_$$GET1^DIQ(44,+DATA,.01)
 .. S ^TMP("BTIULO",$J,CNT,0)=LN
 .. S ^TMP("BTIULO",$J,CNT+1,0)=OI
 .. S CNT=CNT+2
 I '$D(^TMP("BTIULO",$J)) Q "Future Appt:  None Found"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
VLAB(VISIT,ABN) ;EP; returns all lab results given for a visit
 ; ABN=1 means return abnormal results only (optional)
 NEW TIUX,TIUY,COUNT,TIUA
 K ^TMP("BTIULO",$J)
 S TIUX=0,TIUY="" F  S TIUX=$O(^AUPNVLAB("AD",VISIT,TIUX)) Q:'TIUX  D
 . K TIUA
 . D ENP^XBDIQ1(9000010.09,TIUX,".01;.04;.05;1109","TIUA(")
 . I TIUA(.04)="",TIUA(1109)="RESULTED" Q
 . I $G(ABN),TIUA(.05)="" Q                  ;quit if abnormals only requested
 . S TIUY="  "_$$PAD(TIUA(.01),25)_"  "      ;lab test
 . S TIUY=TIUY_$$PAD(TIUA(.04),10)_TIUA(.05) ;result
 . I TIUA(.04)="" S TIUY=TIUY_TIUA(1109)
 . S COUNT=$G(COUNT)+1 S ^TMP("BTIULO",$J,COUNT,0)=TIUY
 I '$D(^TMP("BTIULO",$J)) Q "No "_$S($G(ABN):"Abnormal ",1:"")_"Labs Found for Visit"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
VMED(VISIT) ;EP; returns all medications given for a visit
 NEW TIUX,TIUY,COUNT
 K ^TMP("BTIULO",$J)
 S TIUX=0,TIUY="" F  S TIUX=$O(^AUPNVMED("AD",VISIT,TIUX)) Q:'TIUX  D
 . S TIUY=TIUY_$$GET1^DIQ(9000010.14,TIUX,.01)_"; "
 S:TIUY]"" TIUY=$$WRAP^TIULS(TIUY,73)
 F COUNT=1:1 Q:$P(TIUY,"|",COUNT)=""  S ^TMP("BTIULO",$J,COUNT,0)=$P(TIUY,"|",COUNT)
 I '$D(^TMP("BTIULO",$J)) Q "No Medications Found for Visit"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
VMEDEX(VISIT) ;EP; returns all medications given for a visit plus sig
 NEW TIUX,TIUY,TIUCNT
 K ^TMP("BTIULO",$J)
 S (TIUCNT,TIUX)=0,TIUY=""
 F  S TIUX=$O(^AUPNVMED("AD",VISIT,TIUX)) Q:'TIUX  D
 . NEW BTIU D ENP^XBDIQ1(9000010.14,TIUX,".01;.05:.07","BTIU(")
 . S TIUY=BTIU(.01)_" #"_BTIU(.06)_" ("_BTIU(.07)_" days)" D VMSET
 . S TIUY=$$SIG(TIUX,BTIU(.05)) D VMSET
 I '$D(^TMP("BTIULO",$J)) Q "No Medications Found for Visit"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
VMSET ; -- set string into wrapped line
 NEW COUNT
 S:TIUY]"" TIUY=$$WRAP^TIULS(TIUY,73)
 F COUNT=1:1 Q:$P(TIUY,"|",COUNT)=""  D
 . S TIUCNT=TIUCNT+1
 . S ^TMP("BTIULO",$J,TIUCNT,0)=$P(TIUY,"|",COUNT)
 Q
 ;
SIG(VMED,SSIG) ;CONSTRUCT THE FULL TEXT FROM THE ENCODED SIG
 ; VMED=ien in v med file; SSIG=short sig
 NEW SIG,PIECE,Y,X
 S SIG="" F PIECE=1:1:$L(SSIG," ") S X=$P(SSIG," ",PIECE) I X]"" D
 . S Y=$O(^PS(51,"B",X,0)) I Y>0 S X=$P(^PS(51,Y,0),U,2) I $D(^(9)) S Y=$P(SSIG," ",PIECE-1),Y=$E(Y,$L(Y)) S:Y>1 X=$P(^(9),U,1)
 . S SIG=SIG_X_" "
 Q SIG
 ;
ALLERGY(DFN) ;EP; returns allergies and ADRs
 NEW GMRA,GMRAL,X,ALLRG,ADR,TIUY,Y,Z
 K ^TMP("BTIULO",$J)
 S GMRA="0^0^111" D EN1^GMRADPT
 I GMRAL=0 D  Q X
 . S Z="Allergies/ADRs: "
 . S Y=$O(GMRAL(0)) I Y S X=$P(GMRAL(Y),U,2) I X]"" S X=Z_X Q
 . S X=Z_"None found in system"
 S (ALLRG,ADR)=""
 S X=0 F  S X=$O(GMRAL(X)) Q:'X  D
 . I $P(GMRAL(X),U,5)=0 S ALLRG=ALLRG_$P(GMRAL(X),U,2)_"; " Q
 . S ADR=ADR_$P(GMRAL(X),U,2)_"; "
 S ALLRG=$S(ALLRG="":"None found",1:$P(ALLRG_";","; ;"))
 S ADR=$S(ADR="":"None found",1:$P(ADR_";","; ;"))
 S X="Allergies: "_ALLRG_";  ADRs: "_ADR S TIUY=$$WRAP^TIULS(X,73)
 F COUNT=1:1 Q:$P(TIUY,"|",COUNT)=""  S ^TMP("BTIULO",$J,COUNT,0)=$P(TIUY,"|",COUNT)
 Q "~@^TMP(""BTIULO"",$J)"
 ;
 ;
UPDATE(DUZ,DFN,VISIT,TIUSUB) ;EP -- called to populate multiple objects
 ; -- TIUSUB=subrtn for finding data
 NEW TIUCNT
 K ^TMP("BTIULO",$J)
 I '$G(VISIT) Q ""  ;visit not set
 D @TIUSUB
 Q "~@^TMP(""BTIULO"",$J)"
 ;
 ;
EDEVAL ; -- subrtn to find pat ed evaluations
 NEW TIUX,TIUY,TIUZ,LINE
 I '$O(^AUPNVPED("AD",VISIT,0)) S ^TMP("BTIULO",$J,1,0)="None Found" Q
 ;
 S TIUX=0,TIUY="",TIUCNT=1
 F  S TIUX=$O(^AUPNVPED("AD",VISIT,TIUX)) Q:'TIUX  D
 . D ENP^XBDIQ1(9000010.16,TIUX,".01;.05:.08","TIUZ(","I")
 . S LINE=$$SP(2)_$$EDABBRV(TIUZ(.01,"I"))_": "_TIUZ(.08)_" min.; "
 . S LINE=LINE_TIUZ(.07)_"; Understanding-"_TIUZ(.06)
 . S ^TMP("BTIULO",$J,TIUCNT,0)=LINE
 . S TIUCNT=TIUCNT+1
 Q
 ;
EDABBRV(X) ; -- returns education topic abbreviation
 Q $$GET1^DIQ(9999999.09,X,1)
 ;
HS(APCHSPAT,CODE,APCHSDLM) ;EP; -- calls HS component
 ; CODE=entry point to call
 NEW APCHSTYP,APCHSCKP,APCHSNPG,APCHSBRK,X,CNT,APCHSEGH
 NEW APCHSEGL,APCHSCVD
 K ^TMP("BTIULO",$J),^TMP("BTIU",$J)
 I '$G(APCHSPAT) Q ""  ;patient not set
 S APCHSCKP="Q:$D(APCHSQIT)",APCHSNPG=0
 S APCHSBRK="D BREAK^APCHS",(APCHSEGH,APCHSEGL)=""
 S X1=DT,X2=-APCHSDLM D C^%DTC S APCHSDLM=9999999-X K X1,X2
 S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_($E(Y,1,3)+1700)"
 ;
 D GUIR^XBLM(CODE,"^TMP(""BTIU"",$J,")
 D TERM^VALM0 D KILLHS
 ;
 S X=0 F  S X=$O(^TMP("BTIU",$J,X)) Q:'X  D
 . I ^TMP("BTIU",$J,X)=""!(^(X)?1"--------".E) Q
 . S CNT=$G(CNT)+1
 . S ^TMP("BTIULO",$J,CNT,0)=^TMP("BTIU",$J,X)
 Q "~@^TMP(""BTIULO"",$J)"
 ;
KILLHS ; kill health summary variables (copied from KILLS^APCHS0)
 K APCHSCVD,APCHSICF,APCHSCKP,APCHSNPG,APCHSP,%,APCHSVAR,X,Y,APCHSQIT,APCHSHDR,APCHSHD2,APCHSBRK,APCHSPG
 K APCHSEGN,APCHSEGC,APCHSEGT,APCHSEGH,APCHSEGL,APCHSEGP,APCHSDLM,APCHSDLS,APCHSNDM,APCHSN,APCHSQ
 Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
