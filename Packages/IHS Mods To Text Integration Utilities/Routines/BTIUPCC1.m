BTIUPCC1 ; IHS/ITSC/LJF - IHS PCC OBJECTS ;01-Jun-2010 11:18;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1002,1004,1005,1006**;NOV 04, 2004
 ;IHS/ITSC/LJF 02/24/2005 PATCH 1002 - enhanced measurement display
 ;             04/14/2005 PATCH 1002 - fixed logic for last measurement on same day
 ;             01/26/2006 PATCH 1004 - Added fix for problem list w/o dates
 ;                                     Fixed BMI logic
 ;                                     Fixed logic for vitals for inpts
 ;            Patch 1005 fixed formatting error on date for correct sorting
 ;            Patch 1006 added classification for problems, skip entered in error vitals
LASTPRC(DFN,TIUICD,TIUPRC) ;EP -- returns date of last X procedure
 ;TIUICD=array of ICD procedure codes
 ;TIUPRC=phrase explaining type of procedures; used in output
 Q:'$G(DFN)  Q:'$O(TIUICD(0))  Q:$G(TIUPRC)=""
 NEW PRCN,PRCDT,TIUARR,TIU
 ; -- loop thru all procedures for patient
 S PRCN=0 F  S PRCN=$O(^AUPNVPRC("AC",DFN,PRCN)) Q:'PRCN  D
 . K TIU D ENP^XBDIQ1(9000010.08,PRCN,".01;.03;.04;1201","TIU(","I")
 . I '$D(TIUICD(TIU(.01))) Q  ;ICD code not on list
 . ;
 . ; -- get date: use event date if set, otherwise find visit date
 . S PRCDT=$S(TIU(1201,"I")]"":TIU(1201,"I"),1:$$GET1^DIQ(9000010,TIU(.03,"I"),.01,"I"))
 . ;
 . ; -- set array using date
 . S TIUARR(PRCDT)=TIU(.04)
 ;
 ; -- find most recent procedure from list
 S PRCDT=$O(TIUARR(""),-1) I 'PRCDT Q "No "_TIUPRC_" found"
 ;
 ; -- return caption, date and provider narrative
 Q "Last "_TIUPRC_": "_$$FMTE^XLFDT(PRCDT,"5D")_" ("_TIUARR(PRCDT)_")"
 ;
 ;
LSTSK(DFN,TIUTST) ;EP; -- returns most current skin test for single test
 NEW SKT,VDT,IEN,X,TIU,LINE
 S SKT=$O(^AUTTSK("B",TIUTST,0)) I SKT="" Q ""
 S VDT=0
 F  S VDT=$O(^AUPNVSK("AA",DFN,SKT,VDT)) Q:'VDT!($G(LINE)]"")  D
 . S IEN=0
 . F  S IEN=$O(^AUPNVSK("AA",DFN,SKT,VDT,IEN)) Q:'IEN!($G(LINE)]"")  D
 .. K TIU D ENP^XBDIQ1(9000010.12,IEN,".03:.06","TIU(")
 .. I TIU(.04)="" S LINE="Placed on "_TIU(.03) Q
 .. S LINE=$$PAD($J(TIU(.04),12)_"  "_TIU(.05),25)
 .. S LINE=LINE_"Date Read: "_TIU(.06)
 S X="Last "_$$PAD(TIUTST_":",12)
 Q X_$S($G(LINE)]"":LINE,1:" - Not Done -")
 ;
LASTMSR(DFN,TIUMSR,TIUCAP,TIUDATE) ;EP; -- returns last measurement for patient
 ; TIUMSR=measurement name
 ; TIUCAP=1 if caption with measurement name is to be returned
 ; TIUDATE=1 return date measurement taken
 NEW LINE,X,VAIN
 ;Run different routine if patient is an inpatient
 ;Added in patch 4
 D INP^VADPT
 I $G(VAIN(1)) S LINE=$$LSTMEAS^BTIUPCC4(DFN,TIUMSR,.VAIN)
 I '$G(VAIN(1)) S LINE=$$LSTMEAS(DFN,TIUMSR)
 S X=$S($G(TIUCAP):"Last "_TIUMSR_": ",1:"")
 ;
 ;IHS/ITSC/LJF 02/24/2005 PATCH 1002 lines added to display more details
 NEW Y
 I $P(LINE,U,2)="" Q X_$P(LINE,U)
 I TIUMSR="TMP" S Y=$P(LINE,U),Y=Y_" F ["_$J((Y-32)*(5/9),3,1)_" C]",$P(LINE,U)=Y
 I ((TIUMSR="HT")!(TIUMSR="HC")!(TIUMSR="WC")!(TIUMSR="AG")) S Y=$P(LINE,U),Y=$J(Y,5,2)_" in ["_$J((Y*2.54),5,2)_" cm]",$P(LINE,U)=Y
 I TIUMSR="WT" S Y=$P(LINE,U),Y=$J(Y,5,2)_" lb ["_$J((Y*.454),5,2)_" kg]",$P(LINE,U)=Y
 ;
 Q X_$P(LINE,U)_$$LSTDATE($P(LINE,U,2),$P(LINE,U,3),$G(TIUDATE))
 ;
BMI(DFN,TIUCAP) ;EP -- returns BMI based on last ht and wt
 ; TIUCAP=1 if caption with measurement name is to be returned
 NEW HT,WT,H,W,BMI,X
 S HT=$$LASTMSR($G(DFN),"HT",0,0) I HT<1 Q ""
 S WT=$$LASTMSR($G(DFN),"WT",0,0) I WT<1 Q ""
 S BMI=""
 ; -- "borrowed" code from APCHS9B1
 ;S W=(WT/5)*2.3,H=(HT*2.5),H=(H*H)/10000,BMI=(W/H),BMI=$J(BMI,4,1)
 ; -- PATCH 1004 changed logic to match BEH MEASUREMENT CONTROL FILE
 S WT=WT*.45359,HT=HT*.0254,HT=HT*HT,BMI=+$J(WT/HT,0,2)
 S X=$S($G(TIUCAP):"BMI: ",1:"")
 Q X_BMI
 ;
LSTMEAS(DFN,TIUMSR) ; -- returns most current measurement (internal values)
 ;IHS/ITSC/LJF 04/`4/2005 PATCH 1002 rewrote logic to deal with >1 measurement per day
 NEW MSR,VDT,IEN,X,TIU,LINE,ARR,DATE,STOP
 S MSR=$O(^AUTTMSR("B",TIUMSR,0)) I MSR="" Q ""
 ;
 ;S STOP=$O(^AUPNVMSR("AA",DFN,MSR,0))\1   ;stop at most recent date
 ;I 'STOP Q "none found"                             ;none to be found
 S VDT=0
 S LINE=""
 F  S VDT=$O(^AUPNVMSR("AA",DFN,MSR,VDT)) Q:'VDT!(LINE'="")  D
 . S IEN=0
 . F  S IEN=$O(^AUPNVMSR("AA",DFN,MSR,VDT,IEN)) Q:'IEN  D
 .. K TIU D ENP^XBDIQ1(9000010.01,IEN,".03;.04;2;1201","TIU(","I")
 .. ; value ^ visit ien ^ event date internal format
 .. Q:TIU(2,"I")=1                ;Quit if entered in error
 .. S LINE=$G(TIU(.04))_U_$G(TIU(.03,"I"))_U_$G(TIU(1201,"I"))
 .. S DATE=$S($G(TIU(1201,"I"))]"":TIU(1201,"I"),1:(9999999-$P(VDT,"."))_"."_$P(VDT,".",2))
 .. S ARR(DATE,IEN)=LINE
 ;
 I '$D(ARR) Q "None found"
 S DATE=$O(ARR(""),-1),IEN=$O(ARR(DATE,""),-1),LINE=ARR(DATE,IEN)
 Q $G(LINE)
 ;
LSTDATE(DATE1,DATE2,YES) ;EP -- returns event date or visit date;PATCH 1002 fixed typo
 I 'YES Q ""  ;no date asked for
 ;
 ;IHS/ITSC/LJF 02/24/2005 PATCH 1002 add parens around dates
 ;I $G(DATE2) Q "  "_$$FMTE^XLFDT(DATE2)  ;event date
 ;Q "  "_$$GET1^DIQ(9000010,+DATE1,.01)  ;visit date from visit ien
 I $G(DATE2) Q "  ("_$$FMTE^XLFDT(DATE2)_")"  ;event date
 I 'DATE1 Q " "
 ; IHS/MSC/MGH Patch 1005 changed to get date in upper and lower case for correct sorting
 N Y S Y=$$GET1^DIQ(9000010,+DATE1,.01,"I") ;visit date from visit ien
 Q "  ("_$$FMTE^XLFDT(Y)_")"  ;visit date from visit ien
 ;
PROBLEM(DFN,STATUS,DATES,TARGET) ;EP -- returns the patient's problem list
 ; If STATUS="A" then active list is returned
 ; If STATUS="I" then inactive list is returned
 NEW PROB,CNT,LINE,MOD,ADD,CLASS
 S CNT=0
 S PROB=0 F  S PROB=$O(^AUPNPROB("ACTIVE",DFN,STATUS,PROB)) Q:'PROB  D
 . S CNT=$G(CNT)+1
 . I CNT=1 S @TARGET@(1,0)=$S(STATUS="A":"Active",1:"Inactive")_" Problems: " S CNT=2
 . S LINE=$$GET1^DIQ(9000011,PROB,.05)      ;prov narrative
 . S CLASS=$$GET1^DIQ(9000011,PROB,.15)     ;Classification
 . I CLASS'="" S LINE=LINE_" Classification: "_CLASS
 . I DATES="D" D
 . . S ADD=$$GET1^DIQ(9000011,PROB,.08),MOD=$$GET1^DIQ(9000011,PROB,.03)  ;dates added/modified
 . . S LINE=LINE_"  ("_$S(ADD=MOD:"Added on "_ADD,1:"Last update on "_MOD)_")"
 . S @TARGET@(CNT,0)=$$SP(5)_LINE
 I CNT=0 S @TARGET@(1,0)=$S(STATUS="A":"Active",1:"Inactive")_" Problems:  None Found"
 Q "~@"_$NA(@TARGET)
 ;
UPDPROB(DFN,TARGET) ;EP; -- returns list of problems added or updated today
 NEW PROB,CNT,LINE,STATUS,ADD,MOD,CLASS
 F STATUS="A","I" D
 . S PROB=0 F  S PROB=$O(^AUPNPROB("ACTIVE",DFN,STATUS,PROB)) Q:'PROB  D
 .. S ADD=$$GET1^DIQ(9000011,PROB,.08,"I"),MOD=$$GET1^DIQ(9000011,PROB,.03,"I")  ;dates added/modified (internal format)
 .. I (ADD'=DT)&(MOD'=DT) Q                                                      ;not added or updated today
 .. S CNT=$G(CNT)+1
 .. I CNT=1 S @TARGET@(1,0)="Problem List Updates: " S CNT=2
 .. S LINE=$$GET1^DIQ(9000011,PROB,.05)_" ["_STATUS_"] "       ;prov narrative and status
 .. S CLASS=$$GET1^DIQ(9000011,PROB,.15)  ;CLASSIFICATION
 .. I CLASS'="" S LINE=LINE_" Classification: "_LINE
 .. S LINE=LINE_"  ("_$S(ADD=MOD:"Added",1:"Updated")_")"
 .. S @TARGET@(CNT,0)=$$SP(5)_LINE
 I '$G(CNT) S @TARGET@(1,0)="Problem List Updates:  None Found"
 Q "~@"_$NA(@TARGET)
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
