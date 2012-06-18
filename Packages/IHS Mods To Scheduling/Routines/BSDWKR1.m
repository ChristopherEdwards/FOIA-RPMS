BSDWKR1 ; IHS/ANMC/LJF - WORKLOAD STATS; [ 01/04/2005  4:42 PM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
ASK ; -- ask user questions
 NEW VAUTC,VAUTD,POP,BSDBD,BSDED,BSDTT,BSDDET,BSDSUB,BSDSRT,BSDSEEN,Y
 ;
 S BSDSUB=$$READ^BDGF("SO^C:Clinic;P:Principal Clinic;V:Provider;T:Team","Subtotal Report by","","^D HELP1^BSDWKR1")
 Q:BSDSUB=""  Q:BSDSUB=U
 ;
 ; get clinic arrays based on subtotal category
 I (BSDSUB="C")!(BSDSUB="P") D CLINIC^BSDU(2) Q:$D(BSDQ)
 I (BSDSUB="V")!(BSDSUB="T") D PCASK^BSDU(2,BSDSUB) Q:$D(BSDQ)
 ;
 S BSDBD=$$READ^BDGF("DO^::EX","Select First Date to Search") Q:'BSDBD
 S BSDED=$$READ^BDGF("DO^::EX","Select Last Date to Search") Q:'BSDED
 ;
 S BSDDET=$$READ^BDGF("Y","List Individual Dates","NO","^D HELP3^BSDWKR1") Q:BSDDET=U
 ;
 S BSDSRT=$$READ^BDGF("SO^1:Morning vs. Afternoon;2:Pediatric vs. Adult Patients;3:Male vs. Female Patients","Select addition sort (optional)")
 Q:BSDSRT=U  S BSDSRT=+BSDSRT   ;optional=0
 ;
 S BSDSEEN=$$READ^BDGF("YO","Assume Patient Seen if Appt NOT Checked In","NO","^D HELP2^BSDWKR1") Q:BSDSEEN=""  Q:BSDSEEN=U
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDWKR1","WORKLOAD STATS","BSDDET;BSDSUB;BSDSRT;BSDSEEN;BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM WORK STATS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM WORK STATS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(25)_"Completed Appointments by Type"
 S VALMHDR(2)=$$SP(20)_"For dates: "_$$RANGE^BDGF(BSDBD,BSDED)
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDWKR1",$J),^TMP("BSD",$J)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; -- loop by clinic
 NEW CLN,NAME,SUB,APPT,APPN,PAT,STATUS,TYPE,SUB2,END
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . ;IHS/ITSC/WAR 3/25/04 2 lines added to handle ALL/2 or more DIVs
 . Q:'$$GET1^DIQ(44,CLN,3.5,"I")  ;No Div entered for this clinic
 . ;IHS/ITSC/WAR 12/29/04 PATCH 1001 fixed 'undefined' when selecting Prov or Team
 . ;Q:(VAUTD'=1&('$D(VAUTD($$GET1^DIQ(44,CLN,3.5,"I")))))  ;this Div notd
 . I $D(VAUTD) Q:(VAUTD'=1&('$D(VAUTD($$GET1^DIQ(44,CLN,3.5,"I")))))  ;this Div notd
 . Q:$D(^SC("AIHSPC",CLN))               ;quit if principal clinic
 . S NAME=$$GET1^DIQ(44,CLN,.01)         ;set clinic's name
 . S SUB=$$SUB1(CLN,NAME)                ;get subcategory for clinic
 . ;
 . ; -- then by appt date (within range)
 . S APPT=BSDBD,END=BSDED+.2400
 . F  S APPT=$O(^SC(CLN,"S",APPT)) Q:'APPT!(APPT>END)  D
 .. ;
 .. ; -- then find appts to count
 .. S APPN=0
 .. F  S APPN=$O(^SC(CLN,"S",APPT,1,APPN)) Q:'APPN  D
 ... S PAT=+^SC(CLN,"S",APPT,1,APPN,0)             ;patient ien
 ... S STATUS=$$VAL^XBDIQ1(2.98,PAT_","_APPT,100)  ;current status
 ... Q:STATUS["CANCEL"  Q:STATUS="FUTURE"
 ... Q:STATUS="NON-COUNT"  Q:STATUS="DELETED"
 ... I BSDSEEN=0 Q:STATUS="NO ACTION TAKEN"
 ... ;
 ... S TYPE=$$TYPE(CLN,APPT,APPN,PAT,STATUS)      ;type of appt
 ... S SUB2=$$SUB2(APPT,PAT)                      ;2nd sort
 ... ;
 ... ; increment totals
 ... D INCR(SUB,TYPE,NAME,SUB2,APPT)
 ;
 ;
 ; put totals into display array
 NEW S1,S2,S3,S4,X,LINE,I,J,BSDI,BSDJ
 S S1=0 F  S S1=$O(^TMP("BSD",$J,S1)) Q:S1=""  D
 . ;
 . S LINE=$$PAD(S1,25)                   ;subtotal category name
 . ; line up 5 type of appt columns
 . F I=1:1:5 S LINE=LINE_$$SP(2)_$J(+$G(^TMP("BSD",$J,S1,I)),6)
 . S LINE=$$PAD(LINE,73)_$J(+$G(^TMP("BSD",$J,S1)),6)         ;add in total
 . D SET(LINE,.VALMCNT)
 . ;
 . I BSDSRT D      ;total of 2nd sort for subtotal category
 .. S BSDI=$$SUB21(BSDSRT),BSDJ=$$SUB22(BSDSRT)
 .. F J=BSDI,BSDJ D
 ... S LINE=$$PAD(" TOTAL "_J,25)
 ... F I=1:1:5 S LINE=LINE_$$SP(2)_$J(+$G(^TMP("BSD",$J,S1,I,0,J)),6)
 ... S LINE=$$PAD(LINE,73)_$J(+$G(^TMP("BSD",$J,S1,0,0,J)),6)
 ... D SET(LINE,.VALMCNT)
 . D SET("",.VALMCNT)
 . ;
 . ; totals by clinic
 . S S2=0 F  S S2=$O(^TMP("BSD",$J,S1,0,S2)) Q:S2=""  D
 .. I S2'=S1 D   ;if sort by clinic, don't repeat data
 ... S LINE=$$PAD($$SP(3)_S2,25)            ;clinic name
 ... F I=1:1:5 S LINE=LINE_$$SP(2)_$J(+$G(^TMP("BSD",$J,S1,I,S2)),6)
 ... S LINE=$$PAD(LINE,73)_$J(+$G(^TMP("BSD",$J,S1,0,S2)),6)
 ... D SET(LINE,.VALMCNT)
 ... ;
 ... ; subtotal clinics by 2nd subcategory
 ... I BSDSRT D
 .... S BSDI=$$SUB21(BSDSRT),BSDJ=$$SUB22(BSDSRT)
 .... F J=BSDI,BSDJ D
 ..... S LINE=$$PAD($$SP(4)_"TOTAL "_J,25)
 ..... F I=1:1:5 S LINE=LINE_$$SP(2)_$J(+$G(^TMP("BSD",$J,S1,I,S2,J)),6)
 ..... S LINE=$$PAD(LINE,73)_$J(+$G(^TMP("BSD",$J,S1,0,S2,J)),6)
 ..... D SET(LINE,.VALMCNT)
 .. ;
 .. ; subtotal clinics by date
 .. S S3="" F  S S3=$O(^TMP("BSD",$J,S1,0,S2,S3)) Q:S3=""  D
 ... S S4=0 F  S S4=$O(^TMP("BSD",$J,S1,0,S2,S3,S4)) Q:S4=""  D
 .... S X=$S(S3=0:"",1:" - "_S3)   ;2nd category if used
 .... S LINE=$$PAD($$SP(4)_$$FMTE^XLFDT(S4)_X,25)
 .... F I=1:1:6 S LINE=LINE_$$SP(2)_$J(+$G(^TMP("BSD",$J,S1,I,S2,S3,S4)),6)
 .... S LINE=$$PAD(LINE,73)_$J(+$G(^TMP("BSD",$J,S1,0,S2,S3,S4)),6)
 .... D SET(LINE,.VALMCNT)
 .. D SET("",.VALMCNT)
 ;
 S LINE=$$PAD("REPORT TOTALS",25)
 F I=1:1:5 S LINE=LINE_$$SP(2)_$J(+$G(^TMP("BSD",$J,0,I)),6)
 S LINE=$$PAD(LINE,73)_$J(+$G(^TMP("BSD",$J,0)),6)
 D SET("",.VALMCNT),SET(LINE,.VALMCNT)
 ;
 K ^TMP("BSD",$J)
 Q
 ;
SUB1(C,N) ; -- return name of subcategory for clinic C 
 I BSDSUB="P" Q $$PRIN^BSDU(CLN)
 I BSDSUB="V" Q $P($$PRV^BSDU(CLN),U,2)
 I BSDSUB="T" Q $P($$TEAM^BSDU(CLN),U,2)
 Q N
 ;
SUB2(D,P) ; -- returns value of 2nd sort if asked for
 I BSDSRT=0 Q 0
 I BSDSRT=1 NEW X S X=$E($P(D,".",2),1,2) Q $S(X<12:"AM",1:"PM")
 I BSDSRT=2 NEW X,Y S X=$$GET1^DIQ(2,P,.03,"I"),Y=$$FMDIFF^XLFDT(D,X)/365.25 Q $S(Y<15:"PEDS",1:"ADULT")
 I BSDSRT=3 Q $$GET1^DIQ(2,P,.02)
 Q "??"    ;error in case one slips thru
 ;
SUB21(X) ; returns external category
 Q $S(X=1:"AM",X=2:"PEDS",1:"MALE")
 ;
SUB22(X) ; returns 2nd value of 2nd subcategory
 Q $S(X=1:"PM",X=2:"ADULT",1:"FEMALE")
 ;
TYPE(C,D,N,P,S) ; -- return type of appt.
 ; returns column #
 ;     1=sched, 2=same day, 3=walk-in, 4=overbook, 5=inpt, 6=no-show
 I S["NO-SHOW" Q 6                                   ;no-show
 I S["INPAT" Q 5                                     ;inpatient
 NEW X S X=$P($G(^DPT(P,"S",D,0)),U,7) I X=4 Q 3         ;walkin
 I X=9,(D\1)=($P($G(^SC(C,"S",D,1,N,0)),U,7)\1) Q 3    ;same day CR
 I X=9,(D\1)'=($P($G(^SC(C,"S",D,1,N,0)),U,7)\1) Q 1   ;future CR
 I X=3,(D\1)=($P($G(^SC(C,"S",D,1,N,0)),U,7)\1) Q 2    ;same day appt
 I $G(^SC(C,"S",D,1,N,"OB"))="O" Q 4                 ;sched overbook
 I X=3 Q 1                                           ;scheduled
 Q "??"    ;error in case one slips thru
 ;
INCR(SUB,TYPE,NAME,SUB2,APPT) ; increment totals
 NEW DATE S DATE=APPT\1
 I TYPE'=6 S ^TMP("BSD",$J,0)=$G(^TMP("BSD",$J,0))+1
 I TYPE'=6 S ^TMP("BSD",$J,SUB)=$G(^TMP("BSD",$J,SUB))+1
 S ^TMP("BSD",$J,0,TYPE)=$G(^TMP("BSD",$J,0,TYPE))+1
 S ^TMP("BSD",$J,SUB,TYPE)=$G(^TMP("BSD",$J,SUB,TYPE))+1
 I TYPE'=6 S ^TMP("BSD",$J,SUB,0,NAME)=$G(^TMP("BSD",$J,SUB,0,NAME))+1
 S ^TMP("BSD",$J,SUB,TYPE,NAME)=$G(^TMP("BSD",$J,SUB,TYPE,NAME))+1
 S ^TMP("BSD",$J,SUB,0,0,SUB2)=$G(^TMP("BSD",$J,SUB,0,0,SUB2))+1
 S ^TMP("BSD",$J,SUB,TYPE,0,SUB2)=$G(^TMP("BSD",$J,SUB,TYPE,0,SUB2))+1
 S ^TMP("BSD",$J,SUB,0,NAME,SUB2)=$G(^TMP("BSD",$J,SUB,0,NAME,SUB2))+1
 S ^TMP("BSD",$J,SUB,TYPE,NAME,SUB2)=$G(^TMP("BSD",$J,SUB,TYPE,NAME,SUB2))+1
 I BSDDET S ^TMP("BSD",$J,SUB,0,NAME,SUB2,DATE)=$G(^TMP("BSD",$J,SUB,0,NAME,SUB2,DATE))+1
 I BSDDET S ^TMP("BSD",$J,SUB,TYPE,NAME,SUB2,DATE)=$G(^TMP("BSD",$J,SUB,TYPE,NAME,SUB2,DATE))+1
 Q
 ;
SET(LINE,NUM) ; -- sets display line into array
 S NUM=NUM+1
 S ^TMP("BSDWKR1",$J,NUM,0)=LINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
HELP1 ;EP; help for subtotal question
 D MSG^BDGF("This report will subtotal results any of 4 ways:",2,0)
 D MSG^BDGF("  Choose C to subtotal by individual clinic;",1,0)
 D MSG^BDGF("  Choose P to subtotal by principal clinic;",1,0)
 D MSG^BDGF("  Choose V to subtotal by a clinic's provider;",1,0)
 D MSG^BDGF("  Choose T to subtotal by a clinic's team.",1,0)
 D MSG^BDGF("Clinics not affiliated with a principal clinic,",2,0)
 D MSG^BDGF("provider or team, will be subtotaled under the",1,0)
 D MSG^BDGF("""Unaffiliated"" designation.",1,1)
 Q
 ;
HELP2 ;EP; help for assume patient seen question
 D MSG^BDGF("Answer YES if you want the report to assume patients",2,0)
 D MSG^BDGF("were seen even when their appointments were NOT",1,0)
 D MSG^BDGF("checked-in or flagged as no-shows.",1,0)
 D MSG^BDGF("Answer NO if only appointments with a check-in date/time",2,0)
 D MSG^BDGF("are to be counted.  No-shows are counted separately.",1,0)
 D MSG^BDGF("The Appt. Management Report can list all appointments",1,0)
 D MSG^BDGF("without an action status so the data can be cleaned up.",1,1)
 Q
 ;
HELP3 ;EP; help for print individual dates question
 D MSG^BDGF("Answer YES to have the report totals for each date",2,0)
 D MSG^BDGF("within the date range you have selected.",1,0)
 D MSG^BDGF("Answer NO to just have one set of totals for each",1,0)
 D MSG^BDGF("clinic for the entire date range.",1,1)
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDWKR1",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW X S X=0 F  S X=$O(^TMP("BSDWKR1",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDWKR1",$J,X,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF,?30,"Workload Statistics"
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Category Names",?28,"SCHED",?34,"SAMEDAY",?43,"WALKIN"
 W ?51,"OVERBK",?61,"INPT",?70,"TOTAL SEEN"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
