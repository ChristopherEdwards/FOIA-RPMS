BSDWKR7 ;cmi/anch/maw - BSD Chart Request and Routing Slip Report 2/20/2007 2:42:22 PM
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;cmi/anch/maw 2/20/2007 PATCH 1007 item 1007.25
 ;
ASK ; -- ask user questions
 NEW VAUTC,VAUTD,POP,BSDBD,BSDED,BSDTT,BSDDET,BSDSUB,BSDSRT,BSDSEEN,Y
 ;
 S BSDSUB="C"
 ;
 S BSDBD=$$READ^BDGF("DO^::EX","Select First Date to Search") Q:'BSDBD
 S BSDED=$$READ^BDGF("DO^::EX","Select Last Date to Search") Q:'BSDED
 ;
 ; get clinic arrays based on subtotal category
 I (BSDSUB="C")!(BSDSUB="P") D CLINIC^BSDU(2) Q:$D(BSDQ)
 ;
 S BSDSRT=$$READ^BDGF("S^C:Clinic Name;P:Principal Clinic;O:Clinic Code;D:Date","Sort By","Clinic Name")
 Q:BSDSRT=U
 ;
 ;S BSDDET=$$READ^BDGF("Y","Subtotal sort criteria as well","NO","^D HELP1^BSDWKR7") Q:BSDDET=U
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDWKR7","ROUTING SLIP/CHART REQUEST","BSDDET;BSDSUB;BSDSRT;BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM WORK STATS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM RS/CR REPORT")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(19)_"Routing Slips and Chart Requests by Month"
 S VALMHDR(2)=$$SP(20)_"For dates: "_$$RANGE^BDGF(BSDBD,BSDED)
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDWKR7",$J),^TMP("BSD",$J)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; -- loop by clinic
 NEW CLN,NAME,SUB,APPT,APPN,PAT,STATUS,TYPE,SUB2,END,BSDS,BSDSCD,BSDPC,BSDH
 I BSDSRT="C" S BSDH="CLINIC NAME"
 I BSDSRT="P" S BSDH="PRINCIPAL CLINIC"
 I BSDSRT="O" S BSDH="CLINIC CODE"
 I BSDSRT="D" S BSDH="DATE"
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . Q:'$$GET1^DIQ(44,CLN,3.5,"I")  ;No Div entered for this clinic
 . I $D(VAUTD) Q:(VAUTD'=1&('$D(VAUTD($$GET1^DIQ(44,CLN,3.5,"I")))))  ;this Div notd
 . Q:$D(^SC("AIHSPC",CLN))               ;quit if principal clinic
 . S NAME=$$GET1^DIQ(44,CLN,.01)         ;set clinic's name
 . S BSDSCD=$$GET1^DIQ(44,CLN,8)         ;clinic code
 . S BSDPC=$$GET1^DIQ(44,CLN,1916)       ;principal clinic
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
 ... Q:STATUS["CANCEL"
 ... Q:STATUS="FUTURE"
 ... Q:STATUS="NON-COUNT"
 ... Q:STATUS="DELETED"
 ... I BSDSRT="C" S BSDS=NAME
 ... I BSDSRT="P" S BSDS=$S(BSDPC]"":BSDPC,1:NAME)
 ... I BSDSRT="O" S BSDS=BSDSCD
 ... I BSDSRT="D" S BSDS=$$FMTE^XLFDT($P(APPT,"."))
 ... S BSDMON=$E($P(APPT,"."),1,5)  ;get the month so I can count
 ... ;
 ... S TYPE=$$TYPE(CLN,APPT,APPN,PAT,STATUS,BSDH)      ;type of appt
 ... K BSDRSP
 ... I $P($G(^DPT(PAT,"S",APPT,0)),U,7) S BSDRSP=1
 ... ;
 ... ; increment totals
 ... I TYPE=3 D  Q
 .... D INCR(BSDS,BSDH,3,+$G(BSDRSP),BSDMON)  ;count walkins
 ... D INCR(BSDS,BSDH,1,+$G(BSDRSP),BSDMON)  ;count rs/sched
 . ;
 . ; -- then by appt date (within range)
 . S APCR=BSDBD,END=BSDED+.2400
 . F  S APCR=$O(^SC(CLN,"C",APCR)) Q:'APCR!(APCR>END)  D
 .. ;
 .. ; -- then find appts to count
 .. S APCN=0
 .. F  S APCN=$O(^SC(CLN,"C",APCR,1,APCN)) Q:'APCN  D
 ... S PAT=+^SC(CLN,"C",APCR,1,APCN,0)             ;patient ien
 ... ;S STATUS=$$VAL^XBDIQ1(2.98,PAT_","_APCR,100)  ;current status
 ... ;Q:STATUS["CANCEL"
 ... ;Q:STATUS="FUTURE"
 ... ;Q:STATUS="NON-COUNT"
 ... ;Q:STATUS="DELETED"
 ... I BSDSRT="C" S BSDS=NAME
 ... I BSDSRT="P" S BSDS=$S(BSDPC]"":BSDPC,1:NAME)
 ... I BSDSRT="O" S BSDS=BSDSCD
 ... I BSDSRT="D" S BSDS=$$FMTE^XLFDT($P(APCR,"."))
 ... S BSDMON=$E($P(APCR,"."),1,5)  ;get the month so I can count
 ... ;
 ... ;S TYPE=$$TYPE(CLN,APPT,APPN,PAT,STATUS,BSDH)      ;type of appt
 ... K BSDRSP
 ... I $P($G(^DPT(PAT,"S",APCR,0)),U,7) S BSDRSP=1
 ... ;
 ... ; increment totals
 ... D INCR(BSDS,BSDH,2,+$G(BSDRSP),BSDMON)
 ;
 ;
 N BSDDA,BSDRS
 S BSDDA=0 F  S BSDDA=$O(^TMP("BSD",$J,BSDDA)) Q:BSDDA=""  D
 . N BSDIEN
 . S BSDIEN=0 F  S BSDIEN=$O(^TMP("BSD",$J,BSDDA,BSDIEN)) Q:BSDIEN=""  D
 .. I BSDDA'="DATE" D SET("",.VALMCNT)  ;cmi/anch/maw 8/14/2007 patch 1007
 .. I BSDDA'="DATE" D SET(BSDIEN,.VALMCNT)  ;cmi/anch/maw 8/14/2007 patch 1007
 .. N BSDOEN
 .. S BSDOEN=0 F  S BSDOEN=$O(^TMP("BSD",$J,BSDDA,BSDIEN,BSDOEN)) Q:'BSDOEN  D
 ... ;D SET($$MON(BSDOEN),.VALMCNT)
 ... ;TODO FIX IF DATE SORT
 ... N BSDCR,BSDSA,BSDWI,RS
 ... S BSDRS=+$G(^TMP("BSD",$J,BSDDA,BSDIEN,BSDOEN,"RS"))
 ... S BSDCR=+$G(^TMP("BSD",$J,BSDDA,BSDIEN,BSDOEN,2))
 ... S BSDSA=+$G(^TMP("BSD",$J,BSDDA,BSDIEN,BSDOEN,1))
 ... S BSDWI=+$G(^TMP("BSD",$J,BSDDA,BSDIEN,BSDOEN,3))
 ... I BSDDA'="DATE" S LINE=$$MON(BSDOEN)_$$SP(9)_$$PAD(BSDRS,20)  ;cmi/anch/maw 8/14/2007 patch 1007 added month print here
 ... I BSDDA="DATE" S LINE=BSDIEN_$$SP(4)_$$PAD(BSDRS,20)  ;cmi/anch/maw 8/14/2007 patch 1007 added date print here
 ... S LINE=LINE_$$PAD(BSDCR,20)
 ... S LINE=LINE_$$PAD(BSDSA,15)
 ... S LINE=LINE_$$PAD(BSDWI,10)
 ... D SET(LINE,.VALMCNT)
 .. Q:BSDDA="DATE"
 .. N BSDCRS,BSDCCR,BSDCSA,BSDCWI
 .. S BSDCRS=+$G(^TMP("BSDS",$J,BSDDA,BSDIEN,"RS"))
 .. S BSDCCR=+$G(^TMP("BSDS",$J,BSDDA,BSDIEN,2))
 .. S BSDCSA=+$G(^TMP("BSDS",$J,BSDDA,BSDIEN,1))
 .. S BSDCWI=+$G(^TMP("BSDS",$J,BSDDA,BSDIEN,3))
 .. S LINE="Sub Total"_$$SP(8)_$$PAD(BSDCRS,20)
 .. S LINE=LINE_$$PAD(BSDCCR,20)
 .. S LINE=LINE_$$PAD(BSDCSA,15)
 .. S LINE=LINE_$$PAD(BSDCWI,10)
 .. D SET("",.VALMCNT)
 .. D SET(LINE,.VALMCNT)
 D SET("",.VALMCNT)
 D SET("REPORT TOTALS",.VALMCNT)
 N BSDRST,BSDCRT,BSDSAT,BSDWIT
 S BSDRST=+$G(^TMP("BSDTOT",$J,"RS"))
 S BSDCRT=+$G(^TMP("BSDTOT",$J,2))
 S BSDSAT=+$G(^TMP("BSDTOT",$J,1))
 S BSDWIT=+$G(^TMP("BSDTOT",$J,3))
 I BSDH="DATE" D
 . S LINE=$$SP(16)_$$PAD(BSDRST,20)  ;cmi/anch/maw 8/14/2007 patch 1007
 I BSDH'="DATE" D
 . S LINE=$$SP(17)_$$PAD(BSDRST,20)  ;cmi/anch/maw 8/14/2007 patch 1007
 S LINE=LINE_$$PAD(BSDCRT,20)
 S LINE=LINE_$$PAD(BSDSAT,15)
 S LINE=LINE_$$PAD(BSDWIT,10)
 D SET(LINE,.VALMCNT)
 K ^TMP("BSD",$J)
 K ^TMP("BSDTOT",$J)
 K ^TMP("BSDS",$J)
 Q
 ;
TYPE(C,D,N,P,S,H) ; -- return type of appt.
 ; returns column #
 ;     1=appt, 2=chart request, 3=walk-in
 I S["NO-SHOW" Q 1                                   ;no-show
 I S["INPAT" Q 5                                     ;inpatient
 NEW X S X=$P($G(^DPT(P,"S",D,0)),U,7) I X=4 Q 3         ;walkin
 I (D\1)=($P($G(^SC(C,"C",D,1,N,9999999)),U,7)\1) Q 2    ;same day CR
 I H'="DATE",(D\1)'=($P($G(^SC(C,"C",D,1,N,9999999)),U,7)\1) Q 2   ;future CR
 I X=3,(D\1)=($P($G(^DPT(P,"S",D,0)),U,19)\1) Q 1    ;same day appt
 I H'="DATE",X=3,(D\1)'=($P($G(^DPT(P,"S",D,0)),U,19)\1) Q 1  ;future appt
 I X=3 Q 1  ;scheduled
 Q "??"    ;error in case one slips thru
 ;
INCR(SUB,SUBH,TYPE,RS,MON) ; increment totals
 Q:TYPE=5
 I RS D
 . S ^TMP("BSD",$J,SUBH,SUB,MON,"RS")=$G(^TMP("BSD",$J,SUBH,SUB,MON,"RS"))+1
 . S ^TMP("BSDS",$J,SUBH,SUB,"RS")=$G(^TMP("BSDS",$J,SUBH,SUB,"RS"))+1
 . S ^TMP("BSDTOT",$J,"RS")=$G(^TMP("BSDTOT",$J,"RS"))+1
 S ^TMP("BSD",$J,SUBH,SUB,MON,TYPE)=$G(^TMP("BSD",$J,SUBH,SUB,MON,TYPE))+1
 S ^TMP("BSDS",$J,SUBH,SUB,TYPE)=$G(^TMP("BSDS",$J,SUBH,SUB,TYPE))+1
 S ^TMP("BSDTOT",$J,TYPE)=$G(^TMP("BSDTOT",$J,TYPE))+1
 Q
 ;
SET(LINE,NUM) ; -- sets display line into array
 S NUM=NUM+1
 S ^TMP("BSDWKR7",$J,NUM,0)=LINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
HELP1 ;EP; help for print individual dates question
 D MSG^BDGF("The report will subtotal by Chart requests,",2,0)
 D MSG^BDGF("scheduled appointments, and walkins.",1,0)
 D MSG^BDGF("Answer YES to have it subtotal by sort criteria",1,0)
 D MSG^BDGF("as well.",1,1)
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDWKR7",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW X S X=0 F  S X=$O(^TMP("BSDWKR7",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDWKR7",$J,X,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF,?30,"Routing Slip Statistics"
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 W !,?10,"Routing Slips",?30,"Chart Requests",?50,"Sch Appts",?70,"Walkins"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
MON(MI) ;-- return external month
 S MY=$E(MI,1,3)+1700
 S MI=$E(MI,4,5)
 I MI="01" S MO="Jan"
 I MI="02" S MO="Feb"
 I MI="03" S MO="Mar"
 I MI="04" S MO="Apr"
 I MI="05" S MO="May"
 I MI="06" S MO="Jun"
 I MI="07" S MO="Jul"
 I MI="08" S MO="Aug"
 I MI="09" S MO="Sep"
 I MI="10" S MO="Oct"
 I MI="11" S MO="Nov"
 I MI="12" S MO="Dec"
 Q MO_" "_MY
 ;
