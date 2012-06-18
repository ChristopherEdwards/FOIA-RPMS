BSDAMR3 ;cmi/anch/maw - BSD Appointment Management Reports - Eligibility Appoinment List 2/12/2007 1:20:15 PM
 ;;5.3;PIMS;**1007**;DEC 01, 2006
 ;
 ;cmi/anch/maw new report for PATCH 1007 item 1007.18 Eligibility Appointment List
 ;
ASK ; -- ask user questions
 NEW VAUTC,VAUTD,POP,BSDBD,BSDED,BSDSUB,BSDTT
 D EXIT
 ;
 S BSDSUB="Clinic"
 ;
 ; get clinic arrays based on subtotal category
 D CLINIC^BSDU(2) Q:$D(BSDQ)
 ;
 S BSDBD=$$READ^BDGF("DO^::EX","Select First Date to Search") Q:'BSDBD
 S BSDED=$$READ^BDGF("DO^::EX","Select Last Date to Search") Q:'BSDED
 ;
 N BSDSRT
 S BSDSRT=$$READ^BDGF("S^D:Date/Time;P:Patient Name;C:Coverage Type","Sort By","Date/Time")
 ;
 D CT
 N BSDCTYP
 S BSDCTYP=$$GETCT()
 I $G(BSDCT)="" S BSDCT(4)=""
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDAMR3","APPT ELG","BSDSUB;BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
CT ;-- coverage type
 W !!,?5,"1) Medicaid",!,?5,"2) Medicare",!,?5,"3) Private Insurace",!,?5,"4) All",!
 S BSDCT=$$READ^BDGF("LO^1:4","Show which Coverage Type(s)","")
 I $G(BSDCT)]"" D
 . N I
 . F I=1:1 D  Q:$P(BSDCT,",",I)=""
 .. Q:$P(BSDCT,",",I)=""
 .. S BSDCT($P(BSDCT,",",I))=""
 Q
 ;
GETCT() ;-- return coverage types for header
 N BSDSTR
 S BSDSTR=""
 I $D(BSDCT(1)) S BSDSTR="MCD/"
 I $D(BSDCT(2)) S BSDSTR=BSDSTR_"MCR/"
 I $D(BSDCT(3)) S BSDSTR=BSDSTR_"PI"
 I $D(BSDCT(4)) S BSDSTR="MCR/MCD/PI"
 I $G(BSDSTR)="" S BSDSTR="MCR/MCD/PI"
 Q BSDSTR
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM APPT MGT NO ACTION
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM APPT MGT ELG")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(15)_$$CONF^BSDU
 S VALMHDR(2)=$$SP(20)_"For dates: "_$$RANGE^BDGF(BSDBD,BSDED)
 S VALMHDR(3)=$$SP(25)_"For Coverage Type(s): "_$G(BSDCTYP)
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDAMR3",$J),^TMP("BSD",$J)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; -- loop by clinic
 NEW CLN,NAME,SUB,APPT,APPN,PAT,STATUS,TYPE,END,LINE
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . Q:$D(^SC("AIHSPC",CLN))               ;quit if principal clinic
 . S NAME=$$GET1^DIQ(44,CLN,.01)         ;set clinic's name
 . S SUB=$$SUB1^BSDWKR1(CLN,NAME)        ;get subcategory for clinic
 . I '$G(VAUTD) Q:'$D(VAUTD(+$P($G(^SC(CLN,0)),U,15)))  ;cmi/anch/maw 11/22/06 added to screen on division item 1007.17 patch 1007
 . ;
 . ; -- then by appt date (within range)
 . S APPT=BSDBD,END=BSDED+.2400
 . F  S APPT=$O(^SC(CLN,"S",APPT)) Q:'APPT!(APPT>END)  D
 .. ;
 .. ; -- then find appts to count
 .. S APPN=0
 .. F  S APPN=$O(^SC(CLN,"S",APPT,1,APPN)) Q:'APPN  D
 ... S PAT=+^SC(CLN,"S",APPT,1,APPN,0)                ;patient ien
 ... S BSDSSN=$P($G(^DPT(PAT,0)),U,9)                    ;patient SSN
 ... N BSDMCR,BSDMCD,BSDPI
 ... S BSDMCR=$$MCR^AUPNPAT(PAT,APPT) I BSDMCR=1 S BSDMCR="MCR/"
 ... S BSDMCD=$$MCD^AUPNPAT(PAT,APPT) I BSDMCD=1 S BSDMCD="MCD/"
 ... S BSDPI=$$PI^AUPNPAT(PAT,APPT) I BSDPI=1 S BSDPI="PVT/"
 ... I $G(BSDMCR)=0 K BSDMCR
 ... I $G(BSDMCD)=0 K BSDMCD
 ... I $G(BSDPI)=0 K BSDPI
 ... I '$D(BSDCT(2)),'$D(BSDCT(4)) K BSDMCR
 ... I '$D(BSDCT(1)),'$D(BSDCT(4)) K BSDMCD
 ... I '$D(BSDCT(3)),'$D(BSDCT(4)) K BSDPI
 ... N BSDINS
 ... S BSDINS="*"_$G(BSDMCR)_$G(BSDMCD)_$G(BSDPI)_"*"
 ... ;
 ... ; put appts into display array
 ... S LINE=$$PAD($$FMTE^XLFDT(APPT),22)                   ;appt date
 ... S LINE=LINE_$J($$HRCN^BDGF2(PAT,$$FAC^BSDU(CLN)),7)   ;chart#
 ... S LINE=$$PAD(LINE,33)_$E($$GET1^DIQ(2,PAT,.01),1,18)  ;patient name
 ... S LINE=$$PAD(LINE,53)_$G(BSDSSN)                      ;ssn
 ... S LINE=$$PAD(LINE,64)_BSDINS                          ;insurance info
 ... I BSDSRT="D" D
 .... S ^TMP("BSD",$J,BSDSUB,NAME,APPT,BSDINS)=LINE  ;sort by category,clinic,date
 ... I BSDSRT="P" D
 .... S ^TMP("BSD",$J,BSDSUB,NAME,PAT,APPT)=LINE  ;sort by category,clinic,date
 ... I BSDSRT="C" D
 .... S ^TMP("BSD",$J,BSDSUB,NAME,BSDINS,APPT)=LINE  ;sort by category,clinic,date
 ;
 ; put sorted list into display array
 NEW S1,S2,S3,S4
 S S1=0 F  S S1=$O(^TMP("BSD",$J,S1)) Q:S1=""  D
 . D SET(S1,.VALMCNT)
 . S S2=0 F  S S2=$O(^TMP("BSD",$J,S1,S2)) Q:S2=""  D
 .. I S1'=S2 D SET($$SP(2)_S2,.VALMCNT)
 .. S S3=0 F  S S3=$O(^TMP("BSD",$J,S1,S2,S3)) Q:S3=""  D
 ... S S4=0 F  S S4=$O(^TMP("BSD",$J,S1,S2,S3,S4)) Q:S4=""  D
 .... D SET(^TMP("BSD",$J,S1,S2,S3,S4),.VALMCNT)
 ... I S1'=S2 D SET("",.VALMCNT)
 . D SET("",.VALMCNT)
 ;
 K ^TMP("BSD",$J)
 Q
 ;
SET(LINE,NUM) ; set line into display array
 S NUM=NUM+1
 S ^TMP("BSDAMR3",$J,NUM,0)=LINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDAMR3",$J),BSDCT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW X S X=0 F  S X=$O(^TMP("BSDAMR3",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDAMR3",$J,X,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF,?30,"Appointments Elgibility Information"
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Appt Date",?24,"HRCN",?34,"Patient Name",?54,"SSN",?65,"Insurance Info"
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
