BSDWKR3 ; IHS/ANMC/LJF - WORKLOAD COMPARISONS ;  [ 01/05/2005  8:10 AM ]
 ;;5.3;PIMS;**1001,1007**;APR 26, 2002
 ;
 ;cmi/anch/maw 2/15/2007 added sort by clinic code PATCH 1007 item 1007.26
 ;
ASK ; -- ask user questions
 NEW VAUTC,VAUTD,POP,BSDBD,BSDED,BSDSUB,BSDTT,Y,BSDSEEN
 ;
 S BSDSUB=$$READ^BDGF("SO^C:Clinic;P:Principal Clinic;V:Provider;T:Team","Subtotal Report by","","^D HELP1^BSDWKR1")
 Q:BSDSUB=""  Q:BSDSUB=U
 ;
 ; get clinic arrays based on subtotal category
 I (BSDSUB="C")!(BSDSUB="P") D CLINIC^BSDU(2) Q:$D(BSDQ)
 I (BSDSUB="V")!(BSDSUB="T") D PCASK^BSDU(2,BSDSUB) Q:$D(BSDQ)
 ;
 ;cmi/anch/maw 2/15/2007 PATCH 1007 item 1007.26 added to ask for clinic code sort
 N BSDCC
 S BSDCC=$$READ^BDGF("Y","Sort by Clinic Code","NO")
 ;
 S BSDBD=$$READ^BDGF("DO^::EX","Select First Date to Search") Q:'BSDBD
 S BSDED=$$READ^BDGF("DO^::EX","Select Last Date to Search") Q:'BSDED
 ;
 S BSDSEEN=$$READ^BDGF("YO","Assume Patient Seen if Appt NOT Checked In","NO","^D HELP2^BSDWKR1") Q:BSDSEEN=""  Q:BSDSEEN=U
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDWKR3","WORKLOAD COMPARISONS","BSDSUB;BSDSEEN;BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM WORKLOAD COMPARISONS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM WORKLOAD COMPARISONS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(15)_"Monthly Comparisons on Completed Appointments by Type"
 S VALMHDR(2)=$$SP(22)_"For dates: "_$$RANGE^BDGF(BSDBD,BSDED)
 S VALMHDR(3)=$$SP(18)_"and corresponding dates from the previous year"
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDWKR3",$J),^TMP("BSD",$J)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; -- loop by clinic
 NEW CLN,X,Y
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . Q:$D(^SC("AIHSPC",CLN))               ;quit if principal clinic
 . S X=$O(^SC(CLN,"S",(BSDBD-.0001)))    ;next appt in date range
 . S Y=$O(^SC(CLN,"S",($$LAST(BSDBD)-.0001)))  ;appt for last year
 . I 'X,'Y Q                             ;quit if no appts
 . Q:X>(BSDED+.24)                       ;quit if next appt after end
 . ;
 . ; run thru each date range and increment totals
 . D INIT2(CLN,BSDBD,BSDED,1)
 . D INIT2(CLN,$$LAST(BSDBD),$$LAST(BSDED),0)
 . ;
 . ; initialize ^tmp subtotals by month for those with no data
 . D SETTMP(CLN,BSDBD,BSDED)
 . ;
 ;
 ; put totals into display array
 NEW S1,S2,S3,S4,LINE,I,LINE2,LINE3
 S S1=0 F  S S1=$O(^TMP("BSD",$J,S1)) Q:S1=""  D
 . ;
 . D SET(S1,.VALMCNT)                   ;subtotal category name
 . ;
 . ; get monthly totals for category
 . S S2=0 F  S S2=$O(^TMP("BSD",$J,S1,0,0,S2)) Q:S2=""  D
 .. S S3=0 F  S S3=$O(^TMP("BSD",$J,S1,0,0,S2,S3)) Q:S3=""  D
 ... S LINE=$$PAD($$SP(3)_$$FMTE^XLFDT(S3),25)   ;month/yr
 ... ;
 ... ; line up 5 type of appt columns
 ... F I=1:1:5 S LINE=LINE_$$SP(2)_$J(+$G(^TMP("BSD",$J,S1,I,0,S2,S3)),6)
 ... S LINE=$$PAD(LINE,73)_$J(^TMP("BSD",$J,S1,0,0,S2,S3),6)  ;total
 ... D SET(LINE,.VALMCNT)
 ... ;
 ... ;net change & % change; returns LINE2, LINE3
 ... I S2'=S3 D NET(S1,0,S2,S3)
 ... I S2=S3 D SET(LINE2,.VALMCNT),SET(LINE3,.VALMCNT),SET("",.VALMCNT)
 .. ;
 . ;
 . ; totals by clinic
 . S S2=0 F  S S2=$O(^TMP("BSD",$J,S1,0,S2)) Q:S2=""  D
 .. Q:S1=S2      ;if sort by clinic, don't repeat data
 .. D SET($$SP(3)_S2,.VALMCNT)            ;clinic name
 .. ;
 .. S S3=0 F  S S3=$O(^TMP("BSD",$J,S1,0,S2,S3)) Q:S3=""  D
 ... S S4=0 F  S S4=$O(^TMP("BSD",$J,S1,0,S2,S3,S4)) Q:S4=""  D
 .... S LINE=$$PAD($$SP(5)_$$FMTE^XLFDT(S4),25)   ;month/yr
 .... ;
 .... ; line up 5 type of appt columns
 .... F I=1:1:5 S LINE=LINE_$$SP(2)_$J(+$G(^TMP("BSD",$J,S1,I,S2,S3,S4)),6)
 .... S LINE=$$PAD(LINE,73)_$J(+$G(^TMP("BSD",$J,S1,0,S2,S3,S4)),6)
 .... D SET(LINE,.VALMCNT)
 .... ;
 .... ; net change & % change; returns LINE2, LINE3
 .... I S3'=S4 D NET(S1,S2,S3,S4)
 .... I S3=S4 D SET(LINE2,.VALMCNT),SET(LINE3,.VALMCNT),SET("",.VALMCNT)
 ;
 K ^TMP("BSD",$J)
 Q
 ;
INIT2(CLN,BEG,END,FIRST) ; loop by date and increment totals
 NEW NAME,SUB,APPT,APPN,PAT,STATUS,TYPE,SUB2,MON
 S NAME=$$GET1^DIQ(44,CLN,.01)         ;set clinic's name
 S SUB=$$SUB1(CLN,NAME)                ;get subcategory for clinic
 ;
 S APPT=BEG,END=END+.2400
 F  S APPT=$O(^SC(CLN,"S",APPT)) Q:'APPT!(APPT>END)  D
 . ;
 . ; -- then find appts to count
 . S APPN=0
 . F  S APPN=$O(^SC(CLN,"S",APPT,1,APPN)) Q:'APPN  D
 .. S PAT=+^SC(CLN,"S",APPT,1,APPN,0)             ;patient ien
 .. S STATUS=$$VAL^XBDIQ1(2.98,PAT_","_APPT,100)  ;current status
 .. Q:STATUS["NO-SHOW"  Q:STATUS["CANCEL"  Q:STATUS="FUTURE"
 .. Q:STATUS="NON-COUNT"  Q:STATUS="DELETED"
 .. I BSDSEEN=0 Q:STATUS="NO ACTION TAKEN"
 .. ;
 .. S TYPE=$$TYPE(CLN,APPT,APPN,PAT,STATUS)      ;type of appt
 .. ;
 .. ; sort by comparison months in order (2991000,2981000)
 .. S MON=$E(APPT,1,5)_"00"    ;month for appt
 .. ; appt month for date range chosen
 .. S SUB2=$S(FIRST:MON,1:($E(MON,1,3)+1)_$E(MON,4,7))
 .. ; increment totals
 .. D INCR(SUB,TYPE,NAME,SUB2,MON)
 Q
 ;
LAST(DATE) ; returns month and previous year
 Q ($E(DATE,1,3)-1)_$E(DATE,4,7)
 ;
SUB1(C,N) ; -- return name of subcategory for clinic C 
 I BSDSUB="P" Q $$PRIN^BSDU(CLN)
 I BSDSUB="V" Q $P($$PRV^BSDU(CLN),U,2)
 I BSDSUB="T" Q $P($$TEAM^BSDU(CLN),U,2)
 Q N
 ;
TYPE(C,D,N,P,S) ; -- return type of appt.
 ; returns column #: 1=sched, 2=same day, 3=walk-in, 4=overbook, 5=inpt
 I S["INPAT" Q 5                                     ;inpatient
 I $G(^SC(C,"S",D,1,N,"OB"))="O" Q 4                 ;overbook
 NEW X S X=$$VALI^XBDIQ1(2.98,P_","_D,9) I X=4 Q 3   ;walkin
 I X=3,(D\1)=($P($G(^DPT(P,"S",D,0)),U,19)\1) Q 2    ;same day appt
 I X=3 Q 1                                           ;scheduled
 Q "??"    ;error in case one slips thru
 ;
SETTMP(CLINIC,BEG,END) ; initialize ^tmp by month
 NEW MON,X,SUB,NAME
 S NAME=$$GET1^DIQ(44,CLN,.01)  ;clinic name
 S SUB=$$SUB1(CLN,NAME)         ;subcategory name
 S MON=$E(BEG,1,5)_"00"         ;beginning month
 ;cmi/anch/maw 2/15/2007, changed sub to clinic code for sort if selected PATCH 1007, item 1007.26
 I $G(BSDCC) D
 . S CLNC=$$GET1^DIQ(44,CLN,8)  ;clinic code
 . N CLNCI,CLNCC
 . S CLNCI=$$GET1^DIQ(44,CLN,8,"I")
 . S CLNCC=$P($G(^DIC(40.7,CLNCI,0)),U,2)
 . S SUB=CLNCC_" - "_CLNC
 ;
 ; for each month, fill in ^tmp for each type
 F  Q:MON>($E(END,1,5)_"00")  D
 . F I=0:1:5 D
 .. S ^TMP("BSD",$J,SUB,I,0,MON,MON)=+$G(^TMP("BSD",$J,SUB,I,0,MON,MON))
 .. S ^TMP("BSD",$J,SUB,I,0,MON,$$LAST(MON))=+$G(^TMP("BSD",$J,SUB,I,0,MON,$$LAST(MON)))
 .. S ^TMP("BSD",$J,SUB,I,NAME,MON,MON)=+$G(^TMP("BSD",$J,SUB,I,NAME,MON,MON))
 .. S ^TMP("BSD",$J,SUB,I,NAME,MON,$$LAST(MON))=+$G(^TMP("BSD",$J,SUB,I,NAME,MON,$$LAST(MON)))
 . S X=$E(MON,4,5)+1 S:X>12 X=X-12 S:$L(X)=1 X="0"_X  ;find next month
 . ;IHS/ITSC/WAR 2/12/03 P50 per Linda LJF41
 . ;S MON=$E(MON,1,3)_X_"00"                                ;IHS/ITSC/LJF 1/22/2003
 . S MON=$E(MON,1,3) S:X="01" MON=MON+1 S MON=MON_X_"00"    ;IHS/ITSC/LJF 1/22/2003 increment year, if needed
 Q
 ;
INCR(SUB,TYPE,NAME,SUB2,MON) ; increment totals
 S ^TMP("BSD",$J,SUB,0,0,SUB2,MON)=$G(^TMP("BSD",$J,SUB,0,0,SUB2,MON))+1
 S ^TMP("BSD",$J,SUB,TYPE,0,SUB2,MON)=$G(^TMP("BSD",$J,SUB,TYPE,0,SUB2,MON))+1
 S ^TMP("BSD",$J,SUB,0,NAME,SUB2,MON)=$G(^TMP("BSD",$J,SUB,0,NAME,SUB2,MON))+1
 S ^TMP("BSD",$J,SUB,TYPE,NAME,SUB2,MON)=$G(^TMP("BSD",$J,SUB,TYPE,NAME,SUB2,MON))+1
 Q
 ;
NET(SUB,CLINIC,MON1,MON2) ; sets up net change & % change lines
 ; CLINIC=0 if called by category
 NEW I,DIFF,PCNT,DIV
 K LINE2,LINE3
 S LINE2=$$PAD($$SP(15)_"Net Change",25)
 S LINE3=$$PAD($$SP(15)_"% Change",25)
 F I=1:1:5 D
 . S DIFF=$G(^TMP("BSD",$J,SUB,I,CLINIC,MON1,MON1))-$G(^TMP("BSD",$J,SUB,I,CLINIC,MON1,MON2))
 . S LINE2=LINE2_$$SP(2)_$J(DIFF,6)
 . S DIV=+$G(^TMP("BSD",$J,SUB,I,CLINIC,MON1,MON1))
 . S PCNT=$S(DIFF=0:"0",DIV=0:DIFF*100,1:(DIFF/DIV*100))
 . S LINE3=LINE3_$$SP(2)_$J(PCNT_"%",6,0)
 ;
 ; set differences for total column
 S DIFF=$G(^TMP("BSD",$J,SUB,0,CLINIC,MON1,MON1))-$G(^TMP("BSD",$J,SUB,0,CLINIC,MON1,MON2))
 S LINE2=$$PAD(LINE2,73)_$J(DIFF,6)
 S DIV=+$G(^TMP("BSD",$J,SUB,0,CLINIC,MON1,MON1))
 ;IHS/ITSC/WAR 9/23/04 PATCH #1001
 ;S PCNT=$S(DIFF=0:"0",DIV=0:0,1:DIFF\DIV*100)
 S PCNT=$S(DIFF=0:"0",DIV=0:0,1:DIFF/DIV*100)
 ;IHS/ITSC/WAR 9/23/04 PATCH #1001
 ;S LINE3=$$PAD(LINE3,73)_$J(PCNT_"%",6)
 S LINE3=$$PAD(LINE3,73)_$J(PCNT_"%",6,0)
 Q
 ;
SET(LINE,NUM) ; -- sets display line into array
 S NUM=NUM+1
 S ^TMP("BSDWKR3",$J,NUM,0)=LINE
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW LINE
 S LINE=0 F  S LINE=$O(^TMP("BSDWKR3",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDWKR3",$J,LINE,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF,?30,"Workload Comparisons"
 NEW I F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Category Name",?29,"SCHED",?35,"SAMEDAY",?44,"WALIKIN"
 ;IHS/ITSC/WAR 9/23/04 PATCH #1001
 ;W ?52,"OVERBK",?62,"INPT",70,"TOTAL SEEN"
 W ?52,"OVERBK",?62,"INPT",?70,"TOTAL SEEN"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
