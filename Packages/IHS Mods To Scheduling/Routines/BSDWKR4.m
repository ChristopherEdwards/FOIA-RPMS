BSDWKR4 ; IHS/ANMC/LJF - WORKLOAD SCHED VS SEEN ;  [ 11/01/2004  3:05 PM ]
 ;;5.3;PIMS;**1001,1008**;APR 26, 2002
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
 ;S BSDDET=$$READ^BDGF("Y","List Individual Dates","NO","^D HELP3^BDGWKR1") Q:BSDDET=U  ;cmi/maw 10/3/2007 orig line
 S BSDDET=$$READ^BDGF("Y","List Individual Dates","NO","^D HELP3^BDGWKR1") Q:BSDDET=U  ;cmi/maw 10/3/2007 changed BDGWKR1 to BDGWKR4
 ;
 S BSDSRT=$$READ^BDGF("SO^1:Morning vs. Afternoon;2:Pediatric vs. Adult Patients;3:Male vs. Female Patients","Select addition sort (optional)")
 Q:BSDSRT=U  S BSDSRT=+BSDSRT   ;optional=0
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDWKR4","SCHED VS. SEEN","BSDDET;BSDSUB;BSDSRT;BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM WORK STATS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM SCHED VS SEEN")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(20)_"For dates: "_$$RANGE^BDGF(BSDBD,BSDED)
 S VALMHDR(2)=$$SP(18)_"(Assumes patients seen if not flagged as no-shows)"
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDWKR4",$J),^TMP("BSD",$J)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; -- loop by clinic
 NEW CLN,NAME,SUB,APPT,APPN,PAT,STATUS,TYPE,SUB2,END
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . ;IHS/ITSC/WAR 3/25/04 2 lines added to handle ALL/2 or more DIVs
 . ;IHS/ITSC/WAR 5/5/04 PATCH #1001 REM'd previous change,DIV ck not needed here
 . ;Q:'$$GET1^DIQ(44,CLN,3.5,"I")  ;No Div entered for this clinic
 . ;Q:(VAUTD'=1&('$D(VAUTD($$GET1^DIQ(44,CLN,3.5,"I")))))  ;this Div notd
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
 ... Q:STATUS="NON-COUNT"  Q:STATUS="DELETED"  Q:STATUS="FUTURE"
 ... ;
 ... S TYPE=$$TYPE(CLN,APPT,APPN,PAT,STATUS)      ;type of appt
 ... S SUB2=$$SUB2(APPT,PAT)                      ;2nd sort
 ... ;
 ... ; increment totals
 ... D INCR(SUB,TYPE,NAME,SUB2,APPT)
 ;
 ;
 ; put totals into display array
 NEW S1,S2,S3,S4,X,LINE,I,J,BSDI,BSDJ,BSDA
 S S1=0 F  S S1=$O(^TMP("BSD",$J,S1)) Q:S1=""  D
 . ;
 . S LINE=$$PAD(S1,22)                   ;subtotal category name
 . ; line up 5 type of appt columns
 . K BSDA F I=1:1:5 D BLDLINE(I,+$G(^TMP("BSD",$J,S1,I)),.LINE)
 . D SET(LINE,.VALMCNT)
 . ;
 . I BSDSRT D      ;total of 2nd sort for subtotal category
 .. S BSDI=$$SUB21(BSDSRT),BSDJ=$$SUB22(BSDSRT)
 .. F J=BSDI,BSDJ D
 ... S LINE=$$PAD(" TOTAL "_J,22)
 ... K BSDA F I=1:1:5 D BLDLINE(I,+$G(^TMP("BSD",$J,S1,I,0,J)),.LINE)
 ... D SET(LINE,.VALMCNT)
 . D SET("",.VALMCNT)
 . ;
 . ; totals by clinic
 . S S2=0 F  S S2=$O(^TMP("BSD",$J,S1,0,S2)) Q:S2=""  D
 .. I S2'=S1 D   ;if sort by clinic, don't repeat data
 ... S LINE=$$PAD($$SP(3)_S2,22)            ;clinic name
 ... K BSDA F I=1:1:5 D BLDLINE(I,+$G(^TMP("BSD",$J,S1,I,S2)),.LINE)
 ... D SET(LINE,.VALMCNT)
 ... ;
 ... ; subtotal clinics by 2nd subcategory
 ... I BSDSRT D
 .... S BSDI=$$SUB21(BSDSRT),BSDJ=$$SUB22(BSDSRT)
 .... F J=BSDI,BSDJ D
 ..... S LINE=$$PAD($$SP(4)_"TOTAL "_J,22)
 ..... K BSDA F I=1:1:5 D BLDLINE(I,+$G(^TMP("BSD",$J,S1,I,S2,J)),.LINE)
 ..... D SET(LINE,.VALMCNT)
 .. ;
 .. ; subtotal clinics by date
 .. S S3="" F  S S3=$O(^TMP("BSD",$J,S1,0,S2,S3)) Q:S3=""  D
 ... S S4=0 F  S S4=$O(^TMP("BSD",$J,S1,0,S2,S3,S4)) Q:S4=""  D
 .... S X=$S(S3=0:"",1:" - "_S3)   ;2nd category if used
 .... S LINE=$$PAD($$SP(4)_$$FMTE^XLFDT(S4)_X,22)
 .... K BSDA F I=1:1:5 D BLDLINE(I,+$G(^TMP("BSD",$J,S1,I,S2,S3,S4)),.LINE)
 .... D SET(LINE,.VALMCNT)
 .. D SET("",.VALMCNT)
 ;
 S LINE=$$PAD("REPORT TOTALS",22)
 K BSDA F I=1:1:5 D BLDLINE(I,+$G(^TMP("BSD",$J,0,I)),.LINE)
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
 ; returns column #: 1=sched, 2=overbook, 3=canceld, 4=no-show, 5=walkin
 I S["NO-SHOW" Q 4                                   ;no-show
 I S["CANCEL" Q 3                                    ;cancelled
 I $G(^SC(C,"S",D,1,N,"OB"))="O" Q 2                 ;overbook
 NEW X S X=$$VALI^XBDIQ1(2.98,P_","_D,9) I X=4 Q 5   ;walkin
 Q 1                                           ;rest must be scheduled
 ;
INCR(SUB,TYPE,NAME,SUB2,APPT) ; increment totals
 NEW DATE S DATE=APPT\1
 S ^TMP("BSD",$J,SUB)=$G(^TMP("BSD",$J,SUB))+1
 S ^TMP("BSD",$J,0,TYPE)=$G(^TMP("BSD",$J,0,TYPE))+1
 S ^TMP("BSD",$J,SUB,TYPE)=$G(^TMP("BSD",$J,SUB,TYPE))+1
 S ^TMP("BSD",$J,SUB,0,NAME)=$G(^TMP("BSD",$J,SUB,0,NAME))+1
 S ^TMP("BSD",$J,SUB,TYPE,NAME)=$G(^TMP("BSD",$J,SUB,TYPE,NAME))+1
 S ^TMP("BSD",$J,SUB,0,0,SUB2)=$G(^TMP("BSD",$J,SUB,0,0,SUB2))+1
 S ^TMP("BSD",$J,SUB,TYPE,0,SUB2)=$G(^TMP("BSD",$J,SUB,TYPE,0,SUB2))+1
 S ^TMP("BSD",$J,SUB,0,NAME,SUB2)=$G(^TMP("BSD",$J,SUB,0,NAME,SUB2))+1
 S ^TMP("BSD",$J,SUB,TYPE,NAME,SUB2)=$G(^TMP("BSD",$J,SUB,TYPE,NAME,SUB2))+1
 I BSDDET S ^TMP("BSD",$J,SUB,0,NAME,SUB2,DATE)=$G(^TMP("BSD",$J,SUB,0,NAME,SUB2,DATE))+1
 I BSDDET S ^TMP("BSD",$J,SUB,TYPE,NAME,SUB2,DATE)=$G(^TMP("BSD",$J,SUB,TYPE,NAME,SUB2,DATE))+1
 I (TYPE=3)!(TYPE=4) D INCR(SUB,1,NAME,SUB2,APPT)  ;add to scheduled
 Q
 ;
BLDLINE(I,NUM,LINE) ; build columns in display line
 ; Array BSDA killed by calling code
 S BSDA(I)=NUM                                  ;# of appts for type
 S LINE=LINE_$$SP(2)_$J(NUM,6)                  ;add to display
 I I=3 S LINE=LINE_$$SP(2)_$J(BSDA(1)+BSDA(2)-BSDA(3),6)    ;# expected
 I I=5 S LINE=$$PAD(LINE,73)_$J(BSDA(1)+BSDA(2)-BSDA(3)-BSDA(4)+BSDA(5),6)  ;# seen
 Q
 ;
SET(LINE,NUM) ; -- sets display line into array
 S NUM=NUM+1
 S ^TMP("BSDWKR4",$J,NUM,0)=LINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDWKR4",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW X S X=0 F  S X=$O(^TMP("BSDWKR4",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDWKR4",$J,X,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF,?30,"Scheduled vs. Actual Appointments"
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Category Names",?28,"SCHED  +  OVERBK  -  CANCEL  =  EXPECTED"
 W ?51,"-  NOSHOW  + WALKIN  =  TOTAL SEEN"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
