BSDU2 ; IHS/ANMC/LJF - IHS UTILITY CALLS-APPT INFO ;  [ 12/22/2003  8:37 AM ]
 ;;5.3;PIMS;**1004,1005,1010**;MAY 28, 2004
 ;IHS/OIT/LJF 11/03/2005 PATCH 1004 added EP to BOFF and BON subroutines
 ;IHS/OIT/LJF 12/29/2005 PATCH 1005 removed BOFF and BON subroutines - no longer needed
 ;cmi/anch/maw 11/20/2008 PATCH 1010 added print of no shows if parameter turned on
 ;
SCIEN(PAT,CLINIC,DATE) ;PEP; returns ien for appt in ^SC
 NEW X,IEN
 S X=0 F  S X=$O(^SC(CLINIC,"S",DATE,1,X)) Q:'X  Q:$G(IEN)  D
 . Q:$P($G(^SC(CLINIC,"S",DATE,1,X,0)),U,9)="C"  ;cancelled
 . I +$G(^SC(CLINIC,"S",DATE,1,X,0))=PAT S IEN=X
 Q $G(IEN)
 ;
OI(PAT,CLINIC,DATE) ;PEP; returns other info comments for patient's appt
 NEW X
 S X=$$SCIEN(PAT,CLINIC,DATE) I 'X Q ""
 Q $P($G(^SC(CLINIC,"S",DATE,1,X,0)),U,4)
 ;
APPTYP(PAT,DATE) ;PEP; -- returns type of appt (scheduled or walk-in)
 NEW X S X=$P($G(^DPT(PAT,"S",DATE,0)),U,7)
 Q $S(X=3:"SCHED",X=4:"WALK-IN",1:"??")
 ;
WALKIN(PAT,DATE) ;PEP; -- returns 1 if appt is walk-in
 Q $S($P($G(^DPT(PAT,"S",DATE,0)),U,7)=4:1,1:0)
 ;
CI(PAT,CLINIC,DATE,SDIEN) ;PEP; -- returns 1 if appt already checked-in
 NEW X
 S X=$G(SDIEN)   ;ien sent in call
 I 'X S X=$$SCIEN(PAT,CLINIC,DATE) I 'X Q 0
 S X=$P($G(^SC(CLINIC,"S",DATE,1,X,"C")),U)
 Q $S(X:1,1:0)
 ;
CO(PAT,CLINIC,DATE,SDIEN) ;PEP; -- returns 1 if appt already checked-out
 NEW X
 S X=$G(SDIEN)   ;ien sent in call
 I 'X S X=$$SCIEN(PAT,CLINIC,DATE) I 'X Q 0
 S X=$P($G(^SC(CLINIC,"S",DATE,1,X,"C")),U,3)
 Q $S(X:1,1:0)
 ;
GETVST(PAT,DATE) ;PEP; returns visit ien for appt date and patient
 NEW X
 I ('PAT)!('DATE) Q 0
 S X=$G(^DPT(PAT,"S",DATE,0)) I 'X Q 0   ;appt node
 S X=$P(X,U,20) I 'X Q 0                 ;outpt encounter ptr
 S X=$G(^SCE(X,0)) I 'X Q 0              ;outpt encounter node
 I $P(X,U,2)'=PAT Q 0                    ;patient ptr
 Q $P(X,U,5)                             ;visit ptr
 ;
PEND(DFN,BSDTALK,BSDARRAY) ;PEP - description follows:
 ; called by SDAM2 & AMER1 to display pending appts
 ; BSDTALK=1 means display results to current device
 ; BSDTALK=0 means be silent
 ; BSDARRAY if set, is array for returning data found
 ;    array(2-9999)=date^clinic name^other info
 ;
 NEW BSDLN,BSDT,BSDCNT,X,I,NODE,BSDSP
 S BSDSP=$S(BSDTALK:"  ",1:U)                ;data item separator
 S BSDCNT=1,BSDT=$$NOW^XLFDT                 ;start with now
 F  S BSDT=$O(^DPT(DFN,"S",BSDT)) Q:'BSDT  D
 . S NODE=$G(^DPT(DFN,"S",BSDT,0))  Q:'NODE
 . ;
 . Q:$P(NODE,U,2)["C"                        ;skip if canceled
 . I $P(NODE,U,2)["N",$P(NODE,U,2)'="NT" Q   ;skip if no-show
 . ;
 . ; if lab, x-ray or ekg appts set, display first
 . F I=3,4,5 S X=$P(NODE,U,I) Q:X[""  D
 .. S BSDCNT=BSDCNT+1
 .. S BSDLN(BSDCNT)=$$FMTE^XLFDT(X)_BSDSP_$P("LAB^X-RAY^EKG",U,I-2)
 . ;
 . ; then display this appt
 . S BSDCNT=$G(BSDCNT)+1
 . S X=$$FMTE^XLFDT(BSDT)_BSDSP_$$GET1^DIQ(44,+NODE,.01)
 . S BSDLN(BSDCNT)=$$PAD(X,43)_BSDSP_$E($$OI^BSDU2(DFN,+NODE,BSDT),1,34)
 . S BSDLN(BSDCNT,0)=+NODE
 ;
 I BSDCNT>1 D
 . S BSDLN(1,"F")="!!?20",BSDLN(1)="**** PENDING APPOINTMENTS ****"
 . F I=1:1:BSDCNT S BSDLN(BSDCNT,"F")="!"
 E  D
 . S BSDLN(1)="No Pending Appointments",BSDLN(1,"F")="!"
 ;
 I $G(BSDTALK) D EN^DDIOL(.BSDLN)     ;print to current device
 ;
 I $G(BSDARRAY)]""  D  Q              ;return data in array
 . NEW %X,%Y S %X="BSDLN(",%Y=BSDARRAY D %XY^%RCR
 Q
 ;
APPT(PAT,CLN,DATE,LEN) ;EP; called by SDM1A to display appt made
 D MSG^BDGF($$SP(3)_$$REPEAT^XLFSTR("*",60),2,0)
 D MSG^BDGF($$SP(5)_LEN_"-MIN. APPOINTMENT MADE FOR "_$$GET1^DIQ(2,PAT,.01),1,0)
 D MSG^BDGF($$SP(5)_"IN "_$$GET1^DIQ(44,CLN,.01)_" CLINIC FOR "_$$FMTE^XLFDT(DATE),1,0)
 D MSG^BDGF($$SP(3)_$$REPEAT^XLFSTR("*",60),1,1)
 Q
 ;
NOSHOW(DFN,CLINIC) ;EP; -- called to print # noshows for patient
 ; will count patient's no-shows in this clinic & principal clinic
 ; date range for search is based on division and clinic parameters
 NEW PRINC,TOTL,NOCLN,PCNT,LMT,LMT2,X,X1,X2,APPDT,LINE,LASTNOS
 Q:'$G(DFN)  Q:'$G(CLINIC)
 S PRINC=$P($G(^SC(+CLINIC,"SL")),U,5)     ;princ clinic
 S (TOTL,NOCLN,PCNT)=0
 S LMT=$$GET1^DIQ(9009020.2,$$DIV^BSDU,.15)    ;division limit
 I 'LMT S LMT=365
 S LMT2=$$GET1^DIQ(9009017.2,+CLINIC,.03)      ;clinic limit
 S LMT2=$S(LMT2="":LMT,1:LMT2)                   ;clinic overrides div
 ;
 ; loop by division date limit to get patient's total no-shows for site
 S X1=DT,X2=-LMT D C^%DTC S APPDT=X
 F  S APPDT=$O(^DPT(DFN,"S",APPDT)) Q:'APPDT  D
 . S X=$P(^DPT(DFN,"S",APPDT,0),U,2) Q:(X="NT")  Q:(X'["N")
 . S TOTL=TOTL+1
 ;
 ; loop by clinic date range for clinic specific totals
 S X1=DT,X2=-LMT2 D C^%DTC S APPDT=X
 F  S APPDT=$O(^DPT(DFN,"S",APPDT)) Q:'APPDT  D
 . S X=$P(^DPT(DFN,"S",APPDT,0),U,2) Q:(X="NT")  Q:(X'["N")
 . ;
 . ; if appt for specified clinic, add to subtotal & set last no-show
 . I +^DPT(DFN,"S",APPDT,0)=+CLINIC D
 .. S NOCLN=NOCLN+1,LASTNOS=$$LASTNOS(DFN,CLINIC,APPDT)
 . ;
 . ; if part of specified principal clinic, add to its subtotal
 . I PRINC]"",$D(^SC("AIHSPC",+PRINC,+^DPT(DFN,"S",APPDT,0))) S PCNT=PCNT+1
 ;
 ; set up display lines for totals and subtotals
 I TOTL>0!(NOCLN>0)!(PCNT>0) D
 . S LINE(1)="Total No-shows (ALL clinics) in last "_(LMT\30)_" months:"
 . S LINE(1)=$$PAD(LINE(1),50)_TOTL,LINE(1,"F")="!!"
 . I PRINC]"" D
 .. S LINE(2)="No-shows in principal clinic (last "_(LMT2\30)
 .. S LINE(2)=$$PAD(LINE(2)_" months):",50)_PCNT,LINE(2,"F")="!"
 . S X=$S(PRINC]"":3,1:2)  ;line number
 . S LINE(X)="No-shows in this clinic (last "_(LMT2\30)_" months):"
 . S LINE(X)=$$PAD(LINE(X),50)_NOCLN,LINE(X,"F")="!"
 . I $G(LASTNOS)]"" S LINE(X+1)="Last No-Show in this clinic: "_LASTNOS
 . S LINE(X+1,"F")="!",LINE(X+2,"F")="!"
 . D EN^DDIOL(.LINE)
 . D NOSHOWA  ;cmi/maw 11/20/2008 PATCH 1010 RQMT 2
 Q
 ;
LASTNOS(PAT,CLINIC,DATE) ; -- returns appt display line
 NEW X,Y,Z
 S X=$$FMTE^XLFDT(DATE,2)_"  "           ;appt date/time
 ; get info out of hospital location file entry
 S Y=0 F  S Y=$O(^SC(+CLINIC,"S",DATE,1,Y)) Q:'Y!$D(Z)  D
 . Q:$P(^SC(+CLINIC,"S",DATE,1,Y,0),U)'=PAT
 . S Z=^SC(+CLINIC,"S",DATE,1,Y,0)
 . S X=X_$P(Z,U,2)_"MIN  "_$E($P(Z,U,4),1,25)  ;appt length&other info
 Q X
 ;
NOSHOWA ;-- ask to print no show list PATCH 1010 RQMT 2
 N BSDNSD
 S BSDNSD=$$READ^BDGF("YO","Display No Shows","NO")
 Q:BSDNSD=U
 Q:'BSDNSD  ;cmi/maw 08/31/2009 PATCH 1010
 W !!,"NO SHOWS FOR PATIENT: "_$$GET1^DIQ(2,DFN,.01)
 W !!,"Date",?25,"Clinic"
 N BSDDA
 S BSDDA=0 F  S BSDDA=$O(^DPT(DFN,"S",BSDDA)) Q:'BSDDA  D
 . N BSDDATA
 . S BSDDATA=$G(^DPT(DFN,"S",BSDDA,0))
 . Q:$P(BSDDATA,U,2)'="N"
 . W !,$$FMTE^XLFDT(BSDDA),?25,$$GET1^DIQ(44,$P(BSDDATA,U),.01)
 Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
