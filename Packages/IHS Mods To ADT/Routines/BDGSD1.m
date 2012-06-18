BDGSD1 ; IHS/ANMC/LJF - APPTS FOR CURRENT INPTS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
ASK ;EP; ask user questions
 ; Called by ^BDGSD when choice 2 is selected
 NEW VAUTD,VAUTNI,VAUTC,VAUTW,BDGBD,BDGED
 D ASK2^SDDIV Q:Y<0  S VAUTNI=1 D WARD^VAUTOMA
 S VAUTNI=2 D CLINIC^VAUTOMA
 S BDGBD=$$READ^BDGF("DO^::EX","Select Beginning Date") Q:BDGBD<1
 S BDGED=$$READ^BDGF("DOA^"_BDGBD_"::EX","Select Ending Date:  ")
 Q:BDGED<1
 ;
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("PQ","EN^BDGSD1","APPTS FOR CURRENT INPTS","VAU*;BDG*")
 Q
 ;
EN ; -- main entry point for BDG INPT APPTS
 I $E(IOST,1,2)="P-" D INIT,PRINT Q    ;if printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG INPT APPTS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(10)_"*** "_$$CONF^BDGF_" ***"
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0
 K ^TMP("BDGSD1",$J),^TMP("BDGSD1A",$J)
 ;
 ; find all patients in selected wards with appts
 NEW WARD,DFN,DATE,CLINIC,END
 S WARD=0 F  S WARD=$O(^DPT("CN",WARD)) Q:WARD=""  D
 . I ('VAUTW),'$D(VAUTW(WARD)) Q    ;not in selected list
 . S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D
 .. ;
 .. ; see if patient has appts within date range
 .. S DATE=BDGBD-.0001,END=BDGED+.24
 .. F  S DATE=$O(^DPT(DFN,"S",DATE)) Q:'DATE  Q:(DATE>END)  D
 ... ;
 ... S CLINIC=+$G(^DPT(DFN,"S",DATE,0)) Q:'CLINIC
 ... I 'VAUTC,'$D(VAUTC(CLINIC)) Q    ;clinic not selected
 ... ;
 ... ; sort by ward then date/time
 ... S ^TMP("BDGSD1A",$J,WARD,DATE,DFN)=""
 ;
 ;
 ; put sorted list into display array
 NEW WARD,DATE,DFN,LAST,LINE,NODE,X
 S WARD=0 F  S WARD=$O(^TMP("BDGSD1A",$J,WARD)) Q:WARD=""  D
 . ;
 . ; display ward heading
 . S X="*** "_WARD_" Ward ***" D SET($$SP(79-$L(X)\2)_X,.VALMCNT)
 . ;
 . S (DATE,LAST)=0
 . F  S DATE=$O(^TMP("BDGSD1A",$J,WARD,DATE)) Q:'DATE  D
 .. ;
 .. ; display date when it changed
 .. I $P(DATE,".")'=LAST D SET($$FMTE^XLFDT(DATE,"D"),.VALMCNT)
 .. S LAST=DATE\1
 .. ;         
 .. S DFN=0 F  S DFN=$O(^TMP("BDGSD1A",$J,WARD,DATE,DFN)) Q:'DFN  D
 ... ;
 ... ; main data line
 ... S NODE=$G(^DPT(DFN,"S",DATE,0))                       ;appt data
 ... S LINE=$$PAD($$SP(3)_$$TIME^BDGF(DATE),13)            ;appt time
 ... S LINE=LINE_$E($$GET1^DIQ(2,DFN,.01),1,20)            ;patient name
 ... S LINE=$$PAD(LINE,35)_$J($$HRCN^BDGF2(DFN,DUZ(2)),7)  ;chart #
 ... S LINE=$$PAD(LINE,48)_$$GET1^DIQ(44,+NODE,.01)        ;clinic
 ... D SET(LINE,.VALMCNT)
 ... ;
 ... ; other info line
 ... S LINE=$$SP(14)_$$OI^BSDU2(DFN,+NODE,DATE)             ;other info
 ... S LINE=$$PAD(LINE,52)_"Appt Made "_$$FMTE^XLFDT($P(NODE,U,19),2)
 ... D SET(LINE,.VALMCNT)
 ... ;
 ... ; ancillary tests, if any
 ... I ($P(NODE,U,3)]"")!($P(NODE,U,4)]"")!($P(NODE,U,5)]"") D
 .... S LINE=$$SP(10)
 .... S X=$P(NODE,U,3) I X]"" S LINE=LINE_"Lab@"_$$FMTE^XLFDT(X)_" "
 .... S X=$P(NODE,U,4) I X]"" S LINE=LINE_"Xray@"_$$FMTE^XLFDT(X)_" "
 .... S X=$P(NODE,U,5) I X]"" S LINE=LINE_"EKG@"_$$FMTE^XLFDT(X)
 .... D SET(LINE,.VALMCNT)
 ... ;
 ... D SET("",.VALMCNT)    ;blank line between patients
 ;
 I '$D(^TMP("BDGSD1",$J)) D SET("No data found",.VALMCNT)
 ;
 K ^TMP("BDGSD1A",$J)
 Q
 ;
SET(DATA,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGSD1",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSD1",$J) K BDGBD,BDGED,VAUTD,VAUTC,VAUTW
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print to paper
 NEW LINE,BDGPG
 U IO D INIT^BDGF,HDG
 S LINE=0 F  S LINE=$O(^TMP("BDGSD1",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGSD1",$J,LINE,0)
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading when printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?16,$$CONF^BDGF
 W !,BDGTIME,?23,"Appointments for Current Inpatients",?71,"Page: ",BDGPG
 NEW X S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 W !,BDGDATE,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Appt",?13,"Patient Name",?35,"Chart #",?49,"Clinic"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
