BDGSD ; IHS/ANMC/LJF - FUTURE APPTS FOR NEW INPTS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
MENU ;EP; choice of inpt appt reports
 NEW REPORT
 S REPORT=$$READ^BDGF("SO^1:Future Appts for New Admissions;2:Appts for Current Inpatients","Select Report to Run")
 Q:REPORT<1
 S X=$S(REPORT=1:"^SDWARD",1:"^BDGSD1") D @X
 Q
 ;
 ;
EN ;EP; -- main entry point for BDG FUTURE APPTS
 ; Called by SDWARD if displaying to screen
 ; Used ADT namespace because option going on ADT menu
 ; Reset SDY from saved variable BDGADT
 ;
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG FUTURE APPTS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(10)_"*** "_$$CONF^BDGF_" ***"
 S X="For patients admitted on "_$$FMTE^XLFDT(BDGDT)
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW X
 K ^TMP("BDGSD",$J),^TMP("BDGSDA",$J)
 S SDY=BDGDT
 D GUIR^XBLM("START^SDWARD","^TMP(""BDGSDA"",$J,")
 S (X,VALMCNT)=0
 F  S X=$O(^TMP("BDGSDA",$J,X)) Q:'X  D
 . S ^TMP("BDGSD",$J,X,0)=$G(^TMP("BDGSDA",$J,X))
 . S VALMCNT=VALMCNT+1
 ;
 I VALMCNT=0 S VALMCNT=1,^TMP("BDGSD",$J,1,0)="No Appts Found"
 K ^TMP("BDGSDA",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSD",$J) K BDGDT
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
