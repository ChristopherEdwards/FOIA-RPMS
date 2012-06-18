BSDWKR8 ; cmi/flag/maw - BSD Advanced Access Report [ 01/04/2005  4:42 PM ]
 ;;5.3;PIMS;**1012,1013**;APR 26, 2002
 ;
ASK ; -- ask user questions
 NEW VAUTC,VAUTD,POP,BSDBD,BSDED,BSDTT,BSDDET,BSDSUB,BSDSRT,BSDSEEN,Y
 ;
 S BSDSUB=$$READ^BDGF("SO^C:Clinic;P:Principal Clinic;V:Provider;T:Team","Subtotal Report by","","^D HELP1^BSDWKR8")
 Q:BSDSUB=""  Q:BSDSUB=U
 ;
 ; get clinic arrays based on subtotal category
 I (BSDSUB="C")!(BSDSUB="P") D CLINIC^BSDU(2) Q:$D(BSDQ)
 I (BSDSUB="V")!(BSDSUB="T") D PCASK^BSDU(2,BSDSUB) Q:$D(BSDQ)
 ;
 S BSDBD=$$READ^BDGF("DO^::EX","Select First Date to Search") Q:'BSDBD
 S BSDED=$$READ^BDGF("DO^::EX","Select Last Date to Search") Q:'BSDED
 ;
 ;cmi/maw exclude demo patients here
 D DEMOCHK^APCLUTL(.BSDDEMO)
 Q:BSDDEMO=-1
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDWKR8","ADVANCED ACCESS","BSDSUB;BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM WORK STATS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM ADVANCED ACCESS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(30)_"Advanced Access Report"
 S VALMHDR(2)=$$SP(20)_"For dates: "_$$RANGE^BDGF(BSDBD,BSDED)
 S VALMHDR(3)=$$SP(40)_"External Demand"_$$SP(8)_"Internal"_$$SP(3)_"Unmet"
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDWKR8",$J),^TMP("BSD",$J)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; -- loop by clinic
 NEW CLN,NAME,SUB,APPT,APPN,PAT,STATUS,TYPE,SUB2,END,APPTM,WI,FU,WL,AP
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . Q:'$$GET1^DIQ(44,CLN,3.5,"I")  ;No Div entered for this clinic
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
 ... Q:$$DEMO^APCLUTL(PAT,$G(BSDDEMO))
 ... S APPTM=$P($G(^SC(CLN,"S",APPT,1,APPN,0)),U,7)  ;date appointment made
 ... S STATUS=$$VAL^XBDIQ1(2.98,PAT_","_APPT,100)  ;current status
 ... S AP=$$CNTAPP(CLN,APPT)  ;count all appointments made this day
 ... ;S AP=$S($P(APPTM,".")=$P(APPT,"."):1,1:0)  ;check if appointment made on same day
 ... S WI=$S($$VALI^XBDIQ1(2.98,PAT_","_APPT,9)=4:1,1:0)  ;type of appointment
 ... S FU=$$VALI^XBDIQ1(2.98,PAT_","_APPT,28)
 ... S WL=$$FNDWL(CLN,$P(APPT,"."))
 ... Q:STATUS["CANCEL"
 ... Q:STATUS="NON-COUNT"  Q:STATUS="DELETED"
 ... S TYPE=$$TYPE(CLN,APPT,APPN,PAT,STATUS)      ;type of appt
 ... ; increment totals
 ... D INCR(SUB,TYPE,NAME,APPT,AP,WI,FU,WL)
 ;
 N S1,S2,AC,WC,FC,LC,INT
 S S1=0 F  S S1=$O(^TMP("BSD",$J,S1)) Q:S1=""  D
 . Q:S1="TOT"
 . S LINE=$$PAD($$FMTE^XLFDT(S1),14)
 . D SET(LINE,.VALMCNT)
 . S S2=0 F  S S2=$O(^TMP("BSD",$J,S1,S2)) Q:S2=""  D
 .. S AC=+$G(^TMP("BSD",$J,S1,S2,"APPT"))
 .. S WC=+$G(^TMP("BSD",$J,S1,S2,"WI"))
 .. S FC=+$G(^TMP("BSD",$J,S1,S2,"FU"))
 .. S LC=+$G(^TMP("BSD",$J,S1,S2,"WL"))
 .. S LINE=""
 .. S LINE=LINE_$$PAD($$SP(13)_S2,40)
 .. S LINE=LINE_$$PAD(AC,11)
 .. S LINE=LINE_$$PAD(WC,12)
 .. S LINE=LINE_$$PAD(FC,11)
 .. S LINE=LINE_$$PAD(LC,11)
 .. D SET(LINE,.VALMCNT)
 . D SET("",.VALMCNT)
 . S LINE=""
 . S LINE="External Demand Subtotal"
 . S LINE=LINE_$$SP(16)
 . S INT=+$G(^TMP("BSD",$J,"TOT",S1,"EXTERNAL"))
 . S LINE=LINE_$$PAD(INT,10)
 . ;S LINE=LINE_$$PAD(+$G(^TMP("BSD",$J,"TOT",S1,"WI")),12)
 . D SET(LINE,.VALMCNT)
 . S LINE=""
 . S LINE=LINE_"Internal Demand Subtotal"
 . S LINE=LINE_$$SP(16)
 . S LINE=LINE_$$PAD(+$G(^TMP("BSD",$J,"TOT",S1,"FU")),11)
 . D SET(LINE,.VALMCNT)
 . S LINE=""
 . S LINE=LINE_"Unmet Demand Subtotal"
 . S LINE=LINE_$$SP(19)
 . S LINE=LINE_$$PAD(+$G(^TMP("BSD",$J,"TOT",S1,"WL")),11)
 . D SET(LINE,.VALMCNT)
 . D SET("",.VALMCNT)
 D SET("",.VALMCNT)
 D SET("",.VALMCNT)
 S LINE="External Demand Total"
 S LINE=LINE_$$SP(19)
 S LINE=LINE_+$G(^TMP("BSD",$J,"TOT","EXTTOTAL"))
 S LINE=LINE_$$SP(10)_"FU Total"_$$SP(4)
 S LINE=LINE_$G(^TMP("BSD",$J,"TOT","FUTOTAL"))
 D SET(LINE,.VALMCNT)
 K ^TMP("BSD",$J)
 Q
 ;
SUB1(C,N) ; -- return name of subcategory for clinic C 
 I BSDSUB="P" Q $$PRIN^BSDU(C)
 I BSDSUB="V" Q $P($$PRV^BSDU(C),U,2)
 I BSDSUB="T" Q $P($$TEAM^BSDU(C),U,2)
 Q N
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
INCR(SUB,TYPE,NAME,APPT,A,W,F,L) ; increment totals
 NEW DATE S DATE=APPT\1
 S:'$D(^TMP("BSD",$J,DATE,SUB,"APPT")) ^TMP("BSD",$J,DATE,SUB,"APPT")=0
 S ^TMP("BSD",$J,DATE,SUB,"APPT")=^TMP("BSD",$J,DATE,SUB,"APPT")+A
 S:'$D(^TMP("BSD",$J,DATE,SUB,"WI")) ^TMP("BSD",$J,DATE,SUB,"WI")=0
 S ^TMP("BSD",$J,DATE,SUB,"WI")=^TMP("BSD",$J,DATE,SUB,"WI")+W
 S:'$D(^TMP("BSD",$J,DATE,SUB,"FU")) ^TMP("BSD",$J,DATE,SUB,"FU")=0
 S ^TMP("BSD",$J,DATE,SUB,"FU")=^TMP("BSD",$J,DATE,SUB,"FU")+F
 S:'$D(^TMP("BSD",$J,DATE,SUB,"WL")) ^TMP("BSD",$J,DATE,SUB,"WL")=0
 S ^TMP("BSD",$J,DATE,SUB,"WL")=^TMP("BSD",$J,DATE,SUB,"WL")+L
 S:'$D(^TMP("BSD",$J,"TOT",DATE,"APPT")) ^TMP("BSD",$J,"TOT",DATE,"APPT")=0
 S ^TMP("BSD",$J,"TOT",DATE,"APPT")=^TMP("BSD",$J,"TOT",DATE,"APPT")+A
 S:'$D(^TMP("BSD",$J,DATE,"TOT","WI")) ^TMP("BSD",$J,"TOT",DATE,"WI")=0
 S ^TMP("BSD",$J,"TOT",DATE,"WI")=^TMP("BSD",$J,"TOT",DATE,"WI")+W
 S:'$D(^TMP("BSD",$J,"TOT",DATE,"FU")) ^TMP("BSD",$J,"TOT",DATE,"FU")=0
 S ^TMP("BSD",$J,"TOT",DATE,"FU")=^TMP("BSD",$J,"TOT",DATE,"FU")+F
 S:'$D(^TMP("BSD",$J,"TOT",DATE,"WL")) ^TMP("BSD",$J,"TOT",DATE,"WL")=0
 S ^TMP("BSD",$J,"TOT",DATE,"WL")=^TMP("BSD",$J,"TOT",DATE,"WL")+L
 S:'$D(^TMP("BSD",$J,"TOT",DATE,"EXTERNAL")) ^TMP("BSD",$J,"TOT",DATE,"EXTERNAL")=0
 S ^TMP("BSD",$J,"TOT",DATE,"EXTERNAL")=^TMP("BSD",$J,"TOT",DATE,"EXTERNAL")+(A+W)
 S:'$D(^TMP("BSD",$J,"TOT",DATE,"TOTAL")) ^TMP("BSD",$J,"TOT",DATE,"TOTAL")=0
 S ^TMP("BSD",$J,"TOT",DATE,"TOTAL")=^TMP("BSD",$J,"TOT",DATE,"TOTAL")+(A+W+F)
 S:'$D(^TMP("BSD",$J,"TOT","FUTOTAL")) ^TMP("BSD",$J,"TOT","FUTOTAL")=0
 S ^TMP("BSD",$J,"TOT","FUTOTAL")=^TMP("BSD",$J,"TOT","FUTOTAL")+F
 S:'$D(^TMP("BSD",$J,"TOT","EXTTOTAL")) ^TMP("BSD",$J,"TOT","EXTTOTAL")=0
 S ^TMP("BSD",$J,"TOT","EXTTOTAL")=^TMP("BSD",$J,"TOT","EXTTOTAL")+(A+W)
 S:'$D(^TMP("BSD",$J,"TOT","GRANDTOTAL")) ^TMP("BSD",$J,"TOT","GRANDTOTAL")=0
 S ^TMP("BSD",$J,"TOT","GRANDTOTAL")=^TMP("BSD",$J,"TOT","GRANDTOTAL")+(A+W+F)
 Q
 ;
FNDWL(C,A) ;-- check to see if a patient is on the wait list
 N AD,CNT,CL,BDA,PAT
 S CNT=0
 I $G(CNTR(C,A)) Q 0
 S CL=$O(^BSDWL("B",C,0))
 I '$G(CL) Q 0
 S BDA=0 F  S BDA=$O(^BSDWL(CL,1,BDA)) Q:'BDA  D
 . Q:$P($G(^BSDWL(CL,1,BDA,0)),U,7)
 . S PAT=+$P($G(^BSDWL(CL,1,BDA,0)),U)
 . S AD=$P($G(^BSDWL(CL,1,BDA,0)),U,3)
 . Q:$$DEMO^APCLUTL(PAT,$G(BSDDEMO))
 . I AD=A S CNT=CNT+1
 S CNTR(C,A)=1
 Q +$G(CNT)
 ;
CNTAPP(C,A) ;-- count all appointments made on date passed in for clinic
 N AD,CNT,DAM,BDA,BDI,BDO,PAT,AP,BG,ED
 S AP=$P(A,".")
 S CNT=0
 I $G(ACNTR(C,AP)) Q 0
 S BG=AP-.0001,ED=AP+.9999
 S BDA=BG F  S BDA=$O(^SC("AIHSDAM",C,BDA)) Q:'BDA!(BDA>ED)  D
 . S BDI=0 F  S BDI=$O(^SC("AIHSDAM",C,BDA,BDI)) Q:'BDI  D
 .. S BDO=0 F  S BDO=$O(^SC("AIHSDAM",C,BDA,BDI,BDO)) Q:'BDO  D
 ... S PAT=+$P($G(^SC(C,"S",BDI,1,BDO,0)),U)
 ... Q:'$G(PAT)  ;ihs/cmi/maw 08/08/2011 added for missing patient pointer
 ... Q:'$D(^DPT(PAT,"S",BDI))  ;another bad data filter
 ... Q:$$VALI^XBDIQ1(2.98,PAT_","_BDI,9)=4  ;8/19/2010 screen out walkins per lisa dolan email
 ... S DAM=$P(BDA,".")
 ... Q:$$DEMO^APCLUTL(PAT,$G(BSDDEMO))
 ... I DAM=AP S CNT=CNT+1
 S ACNTR(C,AP)=1
 Q +$G(CNT)
 ;
SET(LINE,NUM) ; -- sets display line into array
 S NUM=NUM+1
 S ^TMP("BSDWKR8",$J,NUM,0)=LINE
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
EXIT ; -- exit code
 K ^TMP("BSDWKR8",$J),CNTR,BSDDEMO,ACNTR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW X S X=0 F  S X=$O(^TMP("BSDWKR8",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDWKR8",$J,X,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF  ;,?30,"Advanced Access Report"
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Date",?13,"Category",?40,"Appt",?51,"WI"
 W ?63,"FU",?74,"WL"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
