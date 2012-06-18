BSDNAA ; IHS/ANMC/LJF - NUM AVAIL APPT REPORT ;  [ 02/10/2005  3:59 PM ]
 ;;5.3;PIMS;**1002**;APR 26, 2002
 ;
ASK ; -- ask user for clinics and device
 NEW VAUTC,VAUTD,BSDNUM,X,POP,BSDATE
 S X="Enter date to start 14 day range for viewing available appts."
 S BSDATE=$$READ^BDGF("DO^::EX","Starting Date","TODAY",X) Q:BSDATE<1
 D CLINIC^BSDU(2) Q:$D(BSDQ)
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 ;IHS/ITSC/WAR 1/10/05 PATCH #1002 Added VALMHDR* variable for printing
 ;D ZIS^BDGF("PQ","START^BSDNAA","NUM AVAIL APPT","BSDATE;VAUTC*;VAUTD*")
 D ZIS^BDGF("PQ","START^BSDNAA","NUM AVAIL APPT","BSDATE;VAUTC*;VAUTD*;VALMHDR*")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ; -- main entry point for BSDRM NUM AVAIL APPT
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM NUM AVAIL APPT")
 D EXIT,CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(20)_"NUMBER OF APPTS AVAILABLE BY CLINIC AND DATE"
 S VALMHDR(2)=$$SP(25)_$$RANGE^BDGF(BSDATE,$$FMADD^XLFDT(BSDATE,13))
 S VALMCAP=$$DAYS   ;column headings
 Q
 ;
INIT ; -- loop thru clinics selected and build display array
 S VALMCNT=0 K ^TMP("BSDNAA",$J),^TMP("BSDNAA1",$J)
 NEW ARRAY S ARRAY=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; loop thru selected clinics and put in principal clinic order
 NEW CLINIC,PC,ABBR
 S CLINIC=0
 F  S CLINIC=$O(@ARRAY@(CLINIC)) Q:'CLINIC  D
 . Q:'$$OKAY(CLINIC)                   ;quit if inactive or no schedule
 . Q:$D(^SC("AIHSPC",CLINIC))          ;quit if principal clinic
 . S PC=$$PRIN^BSDU(CLINIC)            ;get princ clinic name
 . S ABBR=$$GET1^DIQ(44,CLINIC,1)      ;clinic's abbreviation
 . S:ABBR="" ABBR="??"_CLINIC
 . S ^TMP("BSDNAA1",$J,PC,ABBR,CLINIC)=""  ;put in pc/clinic order
 ;
 ; loop thru sorted list and count available appts
 NEW PC,ABBR,CLINIC,LINE,DATE,SCHED,COUNT,END
 S PC=0 F  S PC=$O(^TMP("BSDNAA1",$J,PC)) Q:PC=""  D
 . D SET("Principal Clinic:  "_PC,.VALMCNT)
 . S ABBR=0 F  S ABBR=$O(^TMP("BSDNAA1",$J,PC,ABBR)) Q:ABBR=""  D
 .. S CLINIC=0
 .. F  S CLINIC=$O(^TMP("BSDNAA1",$J,PC,ABBR,CLINIC)) Q:'CLINIC  D
 ... S LINE=$$PAD(ABBR,8)_"|"     ;begin line for display array
 ... ;
 ... ; now loop thru date range, count and put in display array
 ... S DATE=BSDATE-1,END=$$FMADD^XLFDT(BSDATE,13)
 ... F  S DATE=$$FMADD^XLFDT(DATE,1) Q:DATE>END  D
 .... S SCHED=$G(^SC(CLINIC,"ST",DATE,1))
 .... I SCHED="" S LINE=LINE_"  0 |" Q
 .... S COUNT=$$COUNT(SCHED),LINE=LINE_$J(COUNT,3)_" |"
 ... D SET(LINE,.VALMCNT)  ;add clinic's line to display array
 ;
 K ^TMP("BSDNAA1",$J)
 Q
 ;
COUNT(LINE) ; returns # of avail appts in display line LINE
 NEW I,CNT,J,X
 I LINE["CANCELLED" Q 0
 S LINE=$P(LINE,"|",2,999)
 F I="|","[","]","*"," ","0" S LINE=$$STRIP^XLFSTR(LINE,I)
 ;
 ; -- count up appts left
 S CNT=0 F I=1:1:9 Q:LINE=""  D
 . S X=LINE F J=1:1 Q:X=""  S:$E(X)=I CNT=CNT+I S X=$E(X,2,99)
 . S LINE=$$STRIP^XLFSTR(LINE,I)
 Q +$G(CNT)
 ;
SET(LINE,NUM) ; put display line into display array
 S NUM=NUM+1
 S ^TMP("BSDNAA",$J,NUM,0)=LINE
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDNAA",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
 ;
PRINT ; -- loop thru ^tmp and print
 ;IHS/ITSC/WAR 1/10/2005 PATCH 1002 Added next line for printing
 U IO D HDR
 NEW X,VALMHDR,BSDPG,BSDAYS
 S BSDAYS=$$DAYS D HED
 S X=0 F  S X=$O(^TMP("BSDNAA",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HED
 . W !,^TMP("BSDNAA",$J,X,0)
 D ^%ZISC,EXIT
 Q
 ;
 ;
HED ; -- heading
 ;IHS/ITSC/WAR 1/10/2005 PATCH 1002 - split command for form feed.
 ;W @IOF S BSDPG=$G(BSDPG)+1
 I +$G(BSDPG)>0 W @IOF
 S BSDPG=$G(BSDPG)+1
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)  W:I=1 ?70,"Page ",BSDPG
 W !,BSDAYS,!,$$REPEAT^XLFSTR("=",80)
 Q
 ;
DAYS() ; -- creates array of date range
 NEW X,DAYS,Y,END
 S DAYS(BSDATE)="",X=BSDATE,END=$$FMADD^XLFDT(BSDATE,13)
 F  S X=$$FMADD^XLFDT(X,1) Q:X>END  S DAYS(X)=""
 S Y=$$SP(8)_"| "
 S X=0 F  S X=$O(DAYS(X)) Q:X=""  S Y=Y_$E(X,6,7)_" | "
 Q $G(Y)
 ;
OKAY(C) ; -- active clinic with schedule? (yes=true)
 NEW X
 S X=$G(^SC(C,"I")) Q:'$D(^SC(C,"ST")) 0 Q:'$O(^("ST",BSDATE)) 0
 Q $S($P(^SC(C,0),U,3)'="C":0,'X:1,(BSDATE>(X-1))&('$P(X,U,2)):0,1:1)
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
