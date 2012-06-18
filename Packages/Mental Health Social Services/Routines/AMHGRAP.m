AMHGRAP ; IHS/CMI/MAW - AMHG Intake Form Data - frmIntake 9/16/2009 10:57:49 AM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;
 ;
INIT(DFN,AMHBD,AMHED) ;EP -- init variables and list array
 ; variables set are DFN, AMHBD, AMHED
 ; AMHLN keeps track of line #s to update VALMCNT which is returned
 ; AMHNUM used to link display line with entry
 NEW APDT,NODE,LINE,END,AMHNUM,AMHLN,X,AMHM,AMHU
 K ^TMP("AMHDPA",$J)
 ;
 ; loop thru pat's appts in date range
 S HDR=$$SP(4)_"Appt Date/Time"_$$SP(6)_"Clinic Name"_$$SP(14)_"Type - Status"
 D SET(HDR,"",1,.AMHLN)
 S APDT=AMHBD,END=AMHED+.2400
 F  S APDT=$O(^DPT(DFN,"S",APDT)) Q:'APDT!(APDT>END)  D
 . S NODE=^DPT(DFN,"S",APDT,0)
 . S LINE=$$PAD($$FMTE^XLFDT(APDT),20)                   ;appt dt
 . S LINE=LINE_$$PAD($$GET1^DIQ(44,+NODE,.01),24)_" "    ;clinic
 . S LINE=LINE_$$STATUS(DFN,APDT,NODE)                   ;type/status
 . S AMHNUM=$G(AMHNUM)+1,LINE=$J(AMHNUM,2)_". "_LINE     ;add number
 . S X=DFN_U_+NODE_U_APDT D SET(LINE,X,AMHNUM,.AMHLN)    ;set line
 . D SET($$OI(DFN,+NODE,APDT),"",AMHNUM,.AMHLN)          ;other info
 . I $P(NODE,U,2)["C",$G(^DPT(DFN,"S",APDT,"R"))]"" D
 .. D SET($$SP(15)_"Cancel Remark: "_^DPT(DFN,"S",APDT,"R"),"",AMHNUM,.AMHLN)  ;cncl rmark
 . D SET(" ","",AMHNUM,.AMHLN)                           ;blank line
 ;
 ;IHS/OIT/LJF 07/20/2005 PATCH 1004 added display of active waiting list entries for patient
 K AMHWLR D WLDATA^BSDWLV(DFN,"C",.AMHWLR)
 S:'$D(AMHNUM) AMHNUM=0 D SET(" ","",AMHNUM,.AMHLN)
 ;
 I '$O(AMHWLR(0)) D SET($$SP(10)_AMHWLR(0),"",AMHNUM,.AMHLN) I 1
 E  D
 . D SET($$SP(17)_"**** ACTIVE WAIT LIST ENTRIES FOR PATIENT ****","",AMHNUM,.AMHLN)
 . D SET(AMHWLR(0),"",AMHNUM,.AMHLN)                   ;caption line
 . D SET($$REPEAT^XLFSTR("-",77),"",AMHNUM,.AMHLN)     ;dividing line
 . NEW DATE,LINE
 . S DATE=0 F  S DATE=$O(AMHWLR(DATE)) Q:'DATE  D
 . . S LINE=0 F  S LINE=$O(AMHWLR(DATE,LINE)) Q:'LINE  D
 . . . D SET($S(LINE=1:"",1:$$SP(3))_$P(AMHWLR(DATE,LINE),U,2),"",AMHNUM,.AMHLN)
 . D SET(" ","",AMHNUM,.AMHLN)    ;extra line for spacing
 ;end of PATCH 1004 additions
 ;
 S VALMCNT=+$G(AMHLN)
 Q
 ;
SET(LINE,DATA,NUM,AMHLN) ; -- set ^tmp with display line
 S AMHLN=$G(AMHLN)+1
 S ^TMP("AMHDPA",$J,AMHLN,0)=LINE
 S ^TMP("AMHDPA",$J,"IDX",AMHLN,NUM)=DATA
 Q
 ;
EXIT ;EP -- exit code
 K AMHBD,AMHED,AMHLN,AMHNUM
 K SDC,SDIFN,SDP,SDPP,SDS,SDSTAT,VALMY,ORX
 K VALMBCK,VALMCNT,VALMHDR
 D KILL^AUPNPAT
 Q
 ;
 ;
STATUS(PAT,DATE,NODE) ; returns appt status
 NEW TYP
 S TYP=$$APPTYP^BSDU2(PAT,DATE)    ;sched vs. walkin
 I $P(NODE,U,2)["C" Q TYP_" - CANCELLED"
 I $P(NODE,U,2)'="NT",$P(NODE,U,2)["N" Q TYP_" - NO SHOW"
 I $$CO^BSDU2(PAT,+NODE,DATE) Q TYP_" - CHECKED OUT"
 I $$CI^BSDU2(PAT,+NODE,DATE) Q TYP_" - CHECKED IN"
 Q TYP
 ;
OI(PAT,CLINIC,DATE) ; -- returns other info display line
 Q $$SP(15)_$E($$OI^BSDU2(PAT,CLINIC,DATE),1,65)
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
RESVIEW() ; -- returns 1 if restrict viewing of who made appt turned on
 Q +$$GET1^DIQ(9009020.2,$$DIV^BSDU,.12,"I")
 ;
GETVST(PAT,DATE) ; returns visit ien for appt date and patient
 NEW X
 I ('PAT)!('DATE) Q 0
 S X=$G(^DPT(PAT,"S",DATE,0)) I 'X Q 0   ;appt node
 S X=$P(X,U,20) I 'X Q 0                 ;outpt encounter ptr
 S X=$G(^SCE(X,0)) I 'X Q 0              ;outpt encounter node
 I $P(X,U,2)'=PAT Q 0                    ;patient ptr
 Q $P(X,U,5)                             ;visit ptr
 ;
