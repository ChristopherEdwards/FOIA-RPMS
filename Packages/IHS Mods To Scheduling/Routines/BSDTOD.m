BSDTOD ;cmi/flag/maw - Time of Day Appointment fills up ; 
 ;;5.3;PIMS;**1012**;APR 26, 2002
 ;
ASK ; -- ask user questions
 NEW VAUTC,VAUTD,POP,BSDBD,BSDED,BSDDET,BSDIND,Y
 ;
 D CLINIC^BSDU(2) Q:$D(BSDQ)                  ;get clinic choices
 ;
 S BSDBD=$$READ^BDGF("DO^::EX","Select First Date to Search") Q:'BSDBD
 S BSDED=$$READ^BDGF("DO^::EX","Select Last Date to Search") Q:'BSDED
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDTOD","TOD FILL UP","BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ;EP; -- called by SD IHS COUNT APPTS MADE list template
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D MSG^BDGF("Counting Appointments . . . Please wait",2,0)
 D EN^VALM("BSDRM TOD")
 D EXIT,CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S X="Time of Day Clinic Appointments Fill Up for  "_$$RANGE^BDGF(BSDBD,BSDED)
 S VALMHDR(1)=$$SP(70-$L(X)\2)_X
 ;no column headings if no details
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDTOD",$J),^TMP("BSDTOD1",$J)
 NEW ARRAY S ARRAY=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; loop thru selected clinics and put in principal clinic order
 NEW CLINIC,PC,ABBR,CLNE
 S CLINIC=0
 F  S CLINIC=$O(@ARRAY@(CLINIC)) Q:'CLINIC  D
 . Q:$D(^SC("AIHSPC",CLINIC))          ;quit if principal clinic
 . S PC=$$PRIN^BSDU(CLINIC)            ;get princ clinic name
 . S ABBR=$$GET1^DIQ(44,CLINIC,1)      ;clinic's abbreviation
 . S CLNE=$$GET1^DIQ(44,CLINIC,.01)    ;clinic name
 . S ^TMP("BSDTOD1",$J,PC,CLNE,CLINIC)=""  ;put in pc/clinic order
 ;
 ; loop thru sorted list and count available appts
 NEW PC,ABBR,CLINIC,CLINE,LINE,DATE,SCHED,COUNT,END
 S PC=0 F  S PC=$O(^TMP("BSDTOD1",$J,PC)) Q:PC=""  D
 . S ABBR=0 F  S ABBR=$O(^TMP("BSDTOD1",$J,PC,ABBR)) Q:ABBR=""  D
 .. S CLINIC=0
 .. F  S CLINIC=$O(^TMP("BSDTOD1",$J,PC,ABBR,CLINIC)) Q:'CLINIC  D
 ... ; now loop thru date range, count and put in display array
 ... S DATE=BSDBD-1,END=BSDED
 ... F  S DATE=$$FMADD^XLFDT(DATE,1) Q:DATE>END  D
 .... Q:'$$OKAY(CLINIC,DATE)                   ;quit if inactive or no schedule
 .... S SCHED=$G(^SC(CLINIC,"ST",DATE,1))
 .... Q:$G(SCHED)=""
 .... S COUNT=$$COUNT(SCHED)
 .... Q:+$G(COUNT)>0
 .... S BSDTOD=$$LASTAPPT(DATE,CLINIC)
 .... Q:'$G(BSDTOD)
 .... S CLINE=$$GET1^DIQ(44,CLINIC,.01)
 .... S LINE=$$PAD(CLINE,21)
 .... S LINE=LINE_$$PAD($$FMTE^XLFDT(DATE),28)
 .... S LINE=LINE_$$PAD($$FMTE^XLFDT(BSDTOD),22)
 .... D SET(LINE,.VALMCNT)  ;add clinic's line to display array
 ;
 K ^TMP("BSDTOD1",$J)
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
 S ^TMP("BSDTOD",$J,NUM,0)=LINE
 Q
 ;
OKAY(C,BSDATE) ; -- active clinic with schedule? (yes=true)
 NEW X
 S X=$G(^SC(C,"I")) Q:'$D(^SC(C,"ST")) 0 Q:'$O(^("ST",BSDATE)) 0
 Q $S($P(^SC(C,0),U,3)'="C":0,'X:1,(BSDATE>(X-1))&('$P(X,U,2)):0,1:1)
 ;
LASTAPPT(D,C) ;-- get the last appointment made for that date
 I '$D(^SC(C,"S")) Q 0
 N BSDA,BSDRR,BSDLAP,BSDI
 S BSDCNT=0
 S BSDA=D F  S BSDA=$O(^SC(C,"S",BSDA)) Q:'BSDA!(BSDA>(D+.9999))  D
 . S BSDI=0 F  S BSDI=$O(^SC(C,"S",BSDA,1,BSDI)) Q:'BSDI  D
 .. S BSDLAP=$P($G(^SC(C,"S",BSDA,1,BSDI,0)),U,7)
 .. Q:'$G(BSDLAP)
 .. S BSDRR(BSDLAP)=""
 I '$O(BSDRR("")) Q 0
 Q $O(BSDRR(""),-1)
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDDAM",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
 ;
PRINT ;EP; --prints report to paper
 NEW LINE
 U IO D HDG
 S LINE=0 F  S LINE=$O(^TMP("BSDTOD",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDTOD",$J,LINE,0)
 D ^%ZISC D EXIT
 Q
 ;
HDG ; -- 2nd half of heading
 NEW X
 W @IOF,!!?25,"Time of Day Clinic Fills Up"
 D HDR,MSG^BDGF(VALMHDR(1),0,1)
 S X=$$PAD("Clinic",21)
 S X=$$PAD(X_"Appointment Date",49)
 S X=X_"Date/Time"
 D MSG^BDGF(X,1,0),MSG^BDGF($$REPEAT^XLFSTR("=",80),1,1)
 Q
 ;
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
PC(C) ; -- returns name of principal clinic
 Q $$PRIN^BSDU(C)
 ;
HELP1 ;EP; called from DIR for Detailed Display question
 D MSG^BDGF("Answer YES to include totals for each date in your",2,0)
 D MSG^BDGF("date range in addition to the day of week averages.",1,0)
 D MSG^BDGF("Answer NO to only display day of week data.",2,1)
 Q
 ;
HELP2 ;EP; called by DIR for Include Individual Clinic Totals question
 D MSG^BDGF("Answer YES to display data on each individual clinic",2,0)
 D MSG^BDGF("as opposed to just principal clinic totals.",1,0)
 D MSG^BDGF("Answer NO to only see principal clinic data.",2,1)
 Q
 ;
XREFC(CLIN,DATE,PAT) ;EP; -- updates AIHSDAM xref when data is hard set
 ; Called by SDM1A and SDMM1
 NEW MADE
 S MADE=$P($G(^SC(CLIN,"S",DATE,1,PAT,0)),U,7)
 I MADE]"" S ^SC("AIHSDAM",CLIN,MADE,DATE,PAT)=""
 Q
 ;
