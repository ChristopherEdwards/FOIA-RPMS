BSDALS ; IHS/ANMC/LJF - SHORT APPT LIST - LT CODE ; 
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 02/02/2006 PATCH 1005 screened out cancelled appointments
 ;
EN(SC,BSDATE) ;EP; -- main entry point for appt list list template
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDAM APPT LIST SHORT")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 S VALMHDR(1)=$$REPEAT^XLFSTR(" ",12)_$$CONF^BDGF
 NEW X S X=$$SP(15)_"Other Appts Already Scheduled for "
 S VALMHDR(2)=X_$$FMTE^XLFDT(BSDATE,5)
 Q
 ;
INIT ;EP; -- init variables and list array
 K ^TMP("BSDALS",$J) S VALMCNT=0
 NEW APDT,PAT,NODE,END,LINE
 S END=BSDATE+.2400,APDT=BSDATE-.0001
 F  S APDT=$O(^SC(SC,"S",APDT)) Q:'APDT!(APDT>END)  D
 . S PAT=0 F  S PAT=$O(^SC(SC,"S",APDT,1,PAT)) Q:'PAT  D
 .. S NODE=$G(^SC(SC,"S",APDT,1,PAT,0)) Q:NODE=""
 .. Q:$P(NODE,U,9)="C"                           ;cancelled ;IHS/OIT/LJF 02/03/2006 PATCH 1005
 .. S LINE="  "_$P($$FMTE^XLFDT(APDT),"@",2)     ;appt time
 .. S LINE=$$PAD(LINE,10)_$P(NODE,U,2)_" min"    ;appt length
 .. S LINE=$$PAD(LINE,20)_$E($P(NODE,U,4),1,59)  ;appt comments
 .. I $$WALKIN^BSDU2(+NODE,APDT) S LINE=$$PAD(LINE,20)_"Walk-in"
 .. S VALMCNT=VALMCNT+1
 .. S ^TMP("BSDALS",$J,VALMCNT,0)=LINE
 I VALMCNT=0 S ^TMP("BSDALS",$J,1,0)="No Appointments Scheduled",VALMCNT=1
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BSDALS",$J)
 S VALMNOFF=1  ;suppress form feed before next question
 Q
 ;
EXPND ;EP; -- expand code
 Q
 ;
PAUSE ; -- end of action pause
 D PAUSE^BDGF Q
 ;
RESET ; -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
RESET2 ; -- update partition without recreating display array
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R" D HDR Q
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
