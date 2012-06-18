BSDNS2 ; IHS/ANMC/LJF - FREQUENT NO-SHOWS ; 
 ;;5.3;PIMS;**1010**;APR 26, 2002
 ;
ASK ; ask user questions
 NEW VAUTC,VAUTD,POP,BSDBD,BSDED,BSDSUB,BSDTT,Y,BSDSEEN
 N BSDCP,BSDP,BSDPCNT
 D CLINIC^BSDU(2) Q:$D(BSDQ)
 ;
 ;cmi/maw patch 1010 possibility to ask for patient in later patch
 ; get clinic arrays
 ;S BSDCP=$$READ^BDGF("S^C:Clinic;P:Patient","Select Clinic or Patient","Clinic")  ;cmi/maw PATCH 1010
 ;Q:BSDCP=U  ;cmi/maw PATCH 1010
 ;
 ;I BSDCP="C" D CLINIC^BSDU(2) Q:$D(BSDQ)
 ;I BSDCP="P" D
 ;. S VAUTC=1
 ;. S BSDP=$$READ^BDGF("S^A:All Patients;I:Individual Patients","All or Individual Patients","All")
 ;. Q:BSDP=U
 ;. I BSDP="I" S BSDPCNT=0 D PAT
 ;I BSDCP="P" Q:'$D(BSDP(1))
 ;
 S BSDBD=$$READ^BDGF("DO^::EX","Select First Date to Search") Q:'BSDBD
 S BSDED=$$READ^BDGF("DO^::EX","Select Last Date to Search") Q:'BSDED
 ;
 S BSDLMT=$$READ^BDGF("N^1:99","Number of No-Shows that defines Frequent","","^D HELP1^BSDNS2") Q:BSDLMT=""  Q:BSDLMT=U
 ;
 S BSDMODE=$$READ^BDGF("S^F:Facility;P:Principal Clinic;C:Clinic;N:Patient;O:Clinic Code","No-Show Limit based on which category","","^D HELP2^BSDNS2") Q:BSDMODE=""  Q:BSDMODE=U  ;cmi/maw PATCH 1010 RQMT 1
 ;
 S BSDINFO=$$READ^BDGF("YO","Display Appt. Other Info","NO","^D HELP3^BSDNS2") Q:BSDINFO=U
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDNS2","FREQ NO-SHOWS","BSDINFO;BSDLMT;BSDMODE;BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
PAT ;-- select patients to show or all
 S DIC=9000001,DIC("A")="Select Patient: ",DIC(0)="AEMQZ"
 D ^DIC
 S BSDP=+Y
 Q:Y<0
 S BSDPCNT=BSDPCNT+1
 S BSDP(BSDPCNT)=+BSDP
 G PAT
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM FREQUENT NOSHOWS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM FREQUENT NOSHOWS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(15)_$$CONF^BSDU
 S VALMHDR(2)=$$SP(11)_"For appointments between "_$$FMTE^XLFDT(BSDBD)
 S VALMHDR(2)=VALMHDR(2)_" and "_$$FMTE^XLFDT(BSDED)
 S VALMHDR(3)=$$SP(13)_"Patients with at least "_BSDLMT_" no-shows "_$$MODEMSG(BSDMODE)
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDNS2",$J),^TMP("BSDNS21",$J)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; -- loop by clinic
 NEW CLN,PC,APPT,IEN,CLNM,PATNM,DFN,X,NOSHOWS
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . Q:$D(^SC("AIHSPC",CLN))           ;quit if principal clinic
 . S PC=$$PRIN^BSDU(CLN)             ;principal clinic name
 . S CLNM=$$GET1^DIQ(44,CLN,.01)     ;clinic's name
 . ;
 . ; now loop by date to find no-shows
 . ;   loop backwards to find most recent no-show
 . S APPT=BSDED+.24,END=BSDBD
 . F  S APPT=$O(^SC(CLN,"S",APPT),-1) Q:'APPT  Q:APPT<BSDBD  D
 .. S IEN=0 F  S IEN=$O(^SC(CLN,"S",APPT,1,IEN)) Q:'IEN  D
 ... S DFN=+^SC(CLN,"S",APPT,1,IEN,0)                  ;pat ien
 ... ; quit if not a no-show
 ... S X=$P($G(^DPT(DFN,"S",APPT,0)),U,2) Q:X="NT"  Q:X'["N"
 ... S PATNM=$$GET1^DIQ(2,DFN,.01)                     ;pat name
 ... Q:$D(^TMP("BSDNS21",$J,PC,CLNM,PATNM,DFN))   ;patient already done
 ... ;
 ... S NOSHOWS=$$PDATA(DFN,CLN,APPT,BSDED)    ;count no-shows for pat
 ... Q:'$$LIMIT(NOSHOWS,BSDLMT,BSDMODE)       ;quit if not within limit
 ... I BSDMODE'="N" S ^TMP("BSDNS21",$J,PC,CLNM,PATNM,DFN)=NOSHOWS_U_APPT
 ... I BSDMODE="N" S ^TMP("BSDNS21",$J,PATNM,DFN,CLNM)=NOSHOWS_U_APPT  ;cmi/maw PATCH 1010 RQMT 1
 ;
 ; put sorted list into display array
 ;below will be by clinic cmi/maw PATCH 1010 RQMT 1
 I BSDMODE'="N" D BYPC Q
 I BSDMODE="N" D BYPAT Q
 Q
 ;
BYPC ;-- sort everything by clinic
 NEW LINE,COUNTS
 S PC=0 F  S PC=$O(^TMP("BSDNS21",$J,PC)) Q:PC=""  D
 .  S LINE=$$PAD("Principal Clinic: "_PC,45)_" ("_$$LMT(PC)_")"
 . D SET(LINE,.VALMCNT)
 . ;
 . S CLNM=0 F  S CLNM=$O(^TMP("BSDNS21",$J,PC,CLNM)) Q:CLNM=""  D
 .. S LINE=" "_CLNM_" ("_$$LMT(CLNM)_")"    ;clinic name
 .. D SET("",.VALMCNT),SET(LINE,.VALMCNT)
 .. ;
 .. S PATNM=0
 .. F  S PATNM=$O(^TMP("BSDNS21",$J,PC,CLNM,PATNM)) Q:PATNM=""  D
 ... S DFN=0
 ... F  S DFN=$O(^TMP("BSDNS21",$J,PC,CLNM,PATNM,DFN)) Q:'DFN  D
 .... S COUNTS=^TMP("BSDNS21",$J,PC,CLNM,PATNM,DFN)   ;no-show counts
 .... S LINE=$$PAD($$SP(2)_PATNM,18)_$J($$HRCN^BDGF2(DFN,+$G(DUZ(2))),7)
 .... S LINE=$$PAD($$PAD(LINE,30)_$P(COUNTS,U,4),53)    ;last noshow dt
 .... F I=3,2,1 S LINE=LINE_$J($P(COUNTS,U,I),8)
 .... D SET(LINE,.VALMCNT)
 .... I BSDINFO D SET($$SP(15)_$P(COUNTS,U,5),.VALMCNT)
 . D SET("",.VALMCNT)
 ;
 ;K ^TMP("BSDNS21",$J)
 Q
 ;
BYPAT ;-- sort by patient
 NEW LINE,COUNTS
 S PAT=0 F  S PAT=$O(^TMP("BSDNS21",$J,PAT)) Q:PAT=""  D
 .  S LINE=$$PAD("Patient Name: "_$E(PAT,1,20)_"  Chart: "_$$HRCN^BDGF2($O(^TMP("BSDNS21",$J,PAT,0)),+$G(DUZ(2))),57)_" ("_$$LMT(PAT)_")"
 . D SET(LINE,.VALMCNT)
 . ;
 . S DFN=0 F  S DFN=$O(^TMP("BSDNS21",$J,PAT,DFN)) Q:DFN=""  D
 .. S CLNNM=0
 .. F  S CLNNM=$O(^TMP("BSDNS21",$J,PAT,DFN,CLNNM)) Q:CLNNM=""  D
 ... S COUNTS=^TMP("BSDNS21",$J,PAT,DFN,CLNNM)   ;no-show counts
 ... S LINE=$$PAD($$SP(2)_CLNNM,18)
 ... S LINE=$$PAD($$PAD(LINE,30)_$P(COUNTS,U,4),53)    ;last noshow dt
 ... F I=3,2,1 S LINE=LINE_$J($P(COUNTS,U,I),8)
 ... D SET(LINE,.VALMCNT)
 ... I BSDINFO D SET($$SP(15)_$P(COUNTS,U,5),.VALMCNT)
 . D SET("",.VALMCNT)
 Q
 ;
PRINT ; -- print list to paper
 U IO NEW BSDN,BSDT
 S BSDN=0 D HDG
 F  S BSDN=$O(^TMP("BSDNS2",$J,BSDN)) Q:'BSDN  D
 . I $Y>(IOSL-5) D HDG
 . W !,^TMP("BSDNS2",$J,BSDN,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ;Print report header
 NEW X,I
 W @IOF
 I '$D(BSDT) S X=$$HTFM^XLFDT($H),BSDT=$$FMTE^XLFDT($E(X,1,12),"2P")
 W !?20,"FREQUENT NO-SHOWS REPORT",?55,"Printed: ",BSDT
 D HDR F I=1:1:3 W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDNS2",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
HELP1 ;EP; help for number limit question
 D MSG^BDGF("Enter the number of no-shows a patient must have",2,0)
 D MSG^BDGF("within a clinic's time frame (up to a year) to be",1,0)
 D MSG^BDGF("included on this report.",1,1)
 Q
 ;
HELP2 ;EP; help for limit category
 D MSG^BDGF("Please select the no-show limit category.",2,1)
 D MSG^BDGF("Answer F to include patients with at least "_BSDLMT_" no-shows for your whole FACILITY.",1,0)
 D MSG^BDGF("Answer P to include patients with at least "_BSDLMT_" no-shows within a PRINCIPAL clinic.",1,0)
 D MSG^BDGF("Answer C to include patients with at least "_BSDLMT_" no-shows within a selected CLINIC.",1,1)
 Q
 ;
HELP3 ;EP; help for display other info question
 D MSG^BDGF("Answer YES to include appointment length and other info (used for appt reason).",2,0)
 D MSG^BDGF("Answer NO to list patient name, chart #, last no-show, and counts only.",2,1)
 Q
 ;
PDATA(DFN,CLINIC,BEGDT,ENDT) ;EP; -- called to calculate # noshows for patient
 ; will count patient's no-shows in this clinic & principal clinic
 ; date range for search is based on division and clinic parameters
 NEW PRINC,TOTL,NOCLN,PCNT,LMT,LMT2,X,X1,X2,APPDT,LINE,LASTNOS,CLNCD
 S PRINC=$P($G(^SC(+CLINIC,"SL")),U,5)     ;princ clinic
 S CLNCD=$P($G(^SC(+CLINIC,0)),U,7)  ;clinic code
 S (TOTL,NOCLN,PCNT,CLNCNT)=0
 S LMT=$$GET1^DIQ(9009020.2,$$DIV^BSDU,.15)    ;division limit
 I 'LMT S LMT=365
 S LMT2=$$GET1^DIQ(9009017.2,+CLINIC,.03)      ;clinic limit
 S LMT2=$S(LMT2="":LMT,1:LMT2)                   ;clinic overrides div
 ;
 ; loop by division date limit to get patient's total no-shows for site
 S X1=BEGDT,X2=-LMT D C^%DTC S APPDT=X
 F  S APPDT=$O(^DPT(DFN,"S",APPDT)) Q:'APPDT  Q:(APPDT>(ENDT+.24))  D
 . S X=$P(^DPT(DFN,"S",APPDT,0),U,2) Q:(X="NT")  Q:(X'["N")
 . S TOTL=TOTL+1
 ;
 ; loop by clinic date range for clinic specific totals
 S X1=BEGDT,X2=-LMT2 D C^%DTC S APPDT=X
 F  S APPDT=$O(^DPT(DFN,"S",APPDT)) Q:'APPDT  Q:(APPDT>(ENDT+.24))  D
 . S X=$P(^DPT(DFN,"S",APPDT,0),U,2) Q:(X="NT")  Q:(X'["N")
 . ;
 . ; if appt for specified clinic, add to subtotal & set last no-show
 . I +^DPT(DFN,"S",APPDT,0)=+CLINIC D
 .. S NOCLN=NOCLN+1,LASTNOS=$$LASTNOS(DFN,+CLINIC,APPDT)
 . ;
 . ; if part of specified principal clinic, add to its subtotal
 . I PRINC]"",$D(^SC("AIHSPC",+PRINC,+^DPT(DFN,"S",APPDT,0))) S PCNT=PCNT+1
 . I CLNCD]"" S CLNCNT=CLNCNT+1
 ;
 ; returns numbers: total facility^total prin^total clinic^last noshow^clinic code count
 Q TOTL_U_$G(PCNT)_U_NOCLN_U_$G(LASTNOS)_U_CLNCNT
 ;
LASTNOS(PAT,CLINIC,DATE) ; -- returns appt display line
 NEW X,Y,Z
 S X=$$FMTE^XLFDT(DATE,2)_"  "           ;appt date/time
 ; get info out of hospital location file entry
 S Y=0 F  S Y=$O(^SC(+CLINIC,"S",DATE,1,Y)) Q:'Y!$D(Z)  D
 . Q:$P(^SC(+CLINIC,"S",DATE,1,Y,0),U)'=PAT
 . S Z=^SC(+CLINIC,"S",DATE,1,Y,0)
 . S X=X_U_$P(Z,U,2)_"MIN  "_$E($P(Z,U,4),1,25)  ;appt length&other info
 Q X
 ;
LIMIT(NUM,LMT,MODE) ; returns 1 if number within limit for mode
 ; +NUM=# of no-shows for patient
 ; LMT=# no-shows needed to be included
 ; MODE=(F:facility, P:principal clinic C:clinic)
 I MODE="F" Q $S(+NUM<LMT:0,1:1)          ;enough for facility?
 I MODE="P" Q $S($P(NUM,U,2)<LMT:0,1:1)   ;enough for princ clinic?
 I MODE="C" Q $S($P(NUM,U,3)<LMT:0,1:1)   ;enough for this clinic?
 I MODE="N" Q $S(+NUM<LMT:0,1:1)   ;enough for this patient?  cmi/maw PATCH 1010 RQMT 1
 I MODE="O" Q $S($P(NUM,U,5)<LMT:0,1:1)  ;enough for this clinic code
 Q 0
 ;
LMT(CLN) ; return time limit for clinic
 NEW LMT,LMT2
 S LMT=$$GET1^DIQ(9009020.2,$$DIV^BSDU,.15)        ;division limit
 I 'LMT S LMT=365
 S LMT2=$$GET1^DIQ(9009017.2,+CLN,.03)             ;clinic limit
 Q "Count back "_$S(LMT2="":LMT,1:LMT2)_" days"  ;clinic overrides div
 ;
MODEMSG(MODE) ; return mode in external format
 I MODE="F" Q "for the facility"
 I MODE="P" Q "within principal clinics"
 Q "within any clinic"
 ;
SET(LINE,NUM) ; put display line into display array
 S NUM=NUM+1
 S ^TMP("BSDNS2",$J,NUM,0)=LINE
 Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
