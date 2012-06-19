BSDROUT0 ; IHS/ANMC/LJF - ROUTING SLIPS CALC ;  [ 08/20/2004  11:57 AM ]
 ;;5.3;PIMS;**1001,1004**;MAY 28, 2004
 ;IHS/OIT/LJF 11/03/2005 PATCH 1004 added EP to FIRST subroutine
 ;
FIND(CLN,APPT,APPN,ORDER,BSDMODE) ;EP; -- set up ^tmp sort for patient's appt
 ; called by START^BSDROUT and SINGLE^BSDROUT
 ; assumes SD variables SDX,SDSTART,SDREP,SDATE are set
 ; CLN=clinic ien, APPT=appt date/time, APPN=appt ien in ^SC
 ; ORDER=1 means sort by terminal digit (or chart # per site param)
 ; ORDER=2 means sort by clinic; ORDER=3 means sort by principal clinic
 ; ORDER=4 means sort by name; ORDER="" means single routing slip
 ; BSDMODE="WI" for walkins, "SD" for same day, "" for all others
 ; BSDMODE="CR" used for chart requests in routine BSDROUT
 ;
 ;
 NEW DFN,HRCN,TERM,FIRST
 NEW BSDSC,BSDGD,BSDL
 S DFN=$P(^SC(CLN,"S",APPT,1,APPN,0),U)     ;patient ien
 S HRCN=$$HRCN^BDGF2(DFN,$$FAC^BSDU(CLN))   ;chart #
 S TERM=$$HRCNT^BDGF2(HRCN)                 ;terminal digit format
 I $$GET1^DIQ(9009020.2,+$$DIVC^BSDU(CLN),.18)="NO" D
 . S TERM=$$HRCND^BDGF2(HRCN)               ;use chart # per site param
 ;
 Q:'$$PRTOK(DFN,APPT,TERM)                  ;okay to print this appt?
 ;
 S FIRST=$$FIRST(DFN,APPT)                  ;first appt that day? 
 ;
 D STOPS(DFN,APPT,CLN,TERM,ORDER)           ;xray, lab, ekg stops
 I ORDER=1 D TDO(DFN,APPT,CLN,TERM,"",FIRST) Q
 I ORDER=2 D CLO(DFN,APPT,CLN,TERM,"",FIRST) Q
 I ORDER=3 D PCO(DFN,APPT,CLN,TERM,"",FIRST) Q
 D NMO(DFN,APPT,CLN,TERM,"",FIRST) Q
 ;
TDO(P,D,C,T,S,F) ; -- sort by terminal digit
 I $G(F) S ^TMP("SDRS",$J," "_T," "_T,P)=1    ;1st for patient for date
 S ^TMP("SDRS",$J," "_T," "_T,P,D)=C_U_$G(S)_U_$G(BSDMODE)
 Q
 ;
CLO(P,D,C,T,S,F) ; -- sort by clinic
 NEW N S N=$$GET1^DIQ(44,C,.01) Q:N=""     ;clinic name
 I SDX["ALL",SDSTART]"",SDSTART]N Q  ;not in print range
 I SDX["ALL",SDSTOP]"",N]SDSTOP Q    ;not in print range
 ;
 ;IHS/ITSC/LJF 4/2/2004 set to find all appts later
 ;I $G(F) S ^TMP("SDRS",$J,N," "_T,P)=1                    ;1st for patient for date
 I $G(F),'$D(^TMP("SDRS",$J,P)) S ^TMP("SDRS",$J,P,N)=1    ;1st for patient for date
 S ^TMP("SDRS1",$J,P,D)=N
 ;IHS/ITSC/LJF 4/2/2004 end of changes
 ;
 S ^TMP("SDRS",$J,N," "_T,P,D)=C_U_$G(S)_U_$G(BSDMODE)
 Q
 ;
PCO(P,D,C,T,S,F) ; -- sort by principal clinic
 ;IHS/ITSC/LJF 4/8/2004 rewrote subroutine to use clinic name for unaffiliated clinics
 NEW PRINC S PRINC=$$PRIN^BSDU(C)
 I PRINC="UNAFFILIATED CLINICS" S PRINC=$$GET1^DIQ(44,+C,.01)
 I SDX["ALL",SDSTART]"",SDSTART]PRINC Q  ;not print range
 I SDX["ALL",SDSTOP]"",PRINC]SDSTOP Q    ;not print range
 ;
 I $G(F),'$D(^TMP("SDRS",$J,P)) S ^TMP("SDRS",$J,P,PRINC)=1     ;1st 4 pat 4 dt
 S ^TMP("SDRS1",$J,P,D)=PRINC                                   ;sort by patient then date/time
 ;
 S ^TMP("SDRS",$J,PRINC," "_T,P,D)=C_U_$G(S)_U_$G(BSDMODE)
 Q
 ;
NMO(P,D,C,T,S,F) ; -- sort by name
 NEW N S N=$$GET1^DIQ(2,P,.01)             ;patient name
 I $G(F) S ^TMP("SDRS",$J,N," "_T,P)=1        ;1st for patient for date
 S ^TMP("SDRS",$J,N," "_T,P,D)=C_U_$G(S)_U_$G(BSDMODE)
 Q
 ;
 ;
STOPS(P,D,C,T,ORDER) ; checks for xray, lab or ekg stops
 NEW I,A,STOP
 F I=3,4,5 I $P(^DPT(P,"S",D,0),U,I)]"" D
 . S A=$P(^DPT(P,"S",D,0),U,I),STOP=$S(I=3:"LAB",I=4:"XRAY",1:"EKG")
 . I ORDER=1 D TDO(P,A,C,T,STOP) Q
 . I ORDER=2 D CLO(P,A,C,T,STOP) Q
 . I ORDER=3 D PCO(P,A,C,T,STOP) Q
 . D NMO(P,A,C,T,STOP)
 Q
 ;
PRTOK(P,D,TERM) ; -- check to see if rs should be printed for patient
 ; remove cancelled appts from list
 I ('$G(^DPT(P,"S",D,0)))!($P($G(^DPT(P,"S",D,0)),U,2)["C") Q 0
 ;
 I SDX["ALL",SDSTART="" Q 1   ;1st printing of all routing slips
 ;
 ; can have range of items to print; checking range
 ;    clinic ranges to be checked later
 ;NEW X S X=1 I SDX["ALL" D  Q X        ;IHS/ITSC/LJF 5/20/2004; PATCH #1001
 NEW X S X=1 I 'SDREP D  Q X            ;IHS/ITSC/LJF 5/20/2004; PATCH #1001
 . I SDX["ADD",$P(^DPT(P,"S",D,0),U,13)]"" S X=0 Q          ;if add-on, don't print if already printed; PATCH #1001
 . I ORDER=1,SDSTART]"",SDSTART]$E(TERM,1,2) S X=0 Q   ;before beginning
 . I ORDER=1,SDSTOP]"",$E(TERM,1,2)]SDSTOP S X=0 Q     ;after end
 . I ORDER=4,SDSTART]$$GET1^DIQ(2,P,.01) S X=0 Q   ;before beginning
 . I ORDER=4,$$GET1^DIQ(2,P,.01)]SDSTOP S X=0 Q   ;before beginning
 ;
 ; if reprinting add-ons, only reprint those already printed that day
 I SDREP,SDX["ADD" Q $S($P($G(^DPT(P,"S",D,0)),U,13)\1=SDSTART:1,1:0)
 ;
 Q 1   ;PATCH #1001
 ;if add-ons & already printed, don't print
 ;Q $S($P(^DPT(P,"S",D,0),U,13)]"":0,1:1)
 ;
FIRST(DFN,DATE)    ;EP -- returns 1 if first appt that day for patient
 ;IHS/ITSC/LJF 4/2/2004 rewrote subroutine so it works correctly
 I (ORDER'=2),(ORDER'=3) Q 0       ;for sorts by clinic only
 NEW X,Y
 S X=DATE\1
 F  S X=$O(^DPT(DFN,"S",X)) Q:(X\1>DATE\1)  Q:'X  Q:$D(Y)  D
 . Q:$P(^DPT(DFN,"S",X,0),U,2)["C"    ;ignore cancelled appts
 . S Y=$S(X=DATE:1,1:0)
 Q $G(Y)
