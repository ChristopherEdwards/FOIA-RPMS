BSDDAM ; IHS/ANMC/LJF - APPTS MADE BY DATE REPORT ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
ASK ; -- ask user questions
 NEW VAUTC,VAUTD,POP,BSDBD,BSDED,BSDDET,BSDIND,Y
 ;
 D CLINIC^BSDU(2) Q:$D(BSDQ)                  ;get clinic choices
 ;
 S BSDBD=$$READ^BDGF("DO^::EX","Select First Date to Search") Q:'BSDBD
 S BSDED=$$READ^BDGF("DO^::EX","Select Last Date to Search") Q:'BSDED
 ;
 S BSDDET=$$READ^BDGF("YO","Include Daily Totals","NO","^D HELP1^BSDDAM") Q:BSDDET=""  Q:BSDDET=U
 ;
 S BSDIND=$$READ^BDGF("YO","Display Individual Clinic Totals","NO","^D HELP2^BDSDAM") Q:BSDIND=""  Q:BSDIND=U
 ;
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDDAM","APPT MADE BY MADE","BSDDET;BSDIND;BSDBD;BSDED;VAUTC*;VAUTD*")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ;EP; -- called by SD IHS COUNT APPTS MADE list template
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D MSG^BDGF("Counting Appointments . . . Please wait",2,0)
 D EN^VALM("BSDRM COUNT APPT MADE")
 D EXIT,CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S X="Appointments Made from "_$$RANGE^BDGF(BSDBD,BSDED)
 S VALMHDR(1)=$$SP(70-$L(X)\2)_X
 ;no column headings if no details
 I 'BSDDET S VALMCAP=$$SP(40)_"# Appts Made"_$$SP(7)_"Ave # Appts Made"
 Q
 ;
INIT ; -- init variables and list array
 NEW BSDPLO,BSDPHI,BSDLO,BSDHI
 K ^TMP("BSDDAM",$J),^TMP("BSDDAM1",$J),^TMP("BSDDAM2",$J)
 S VALMCNT=0 K ^TMP("BSDDAM3",$J)
 ; set up day of week array
 NEW BSDA F I=1:1:7 S BSDA($$DOW^XLFDT(DT+I,1))=$$DOW^XLFDT(DT+I)
 NEW BSDAR S BSDAR=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; -- loop by clinic
 NEW CLN,NAME,MADE,END,DOW,DOWN,APPT,PC
 K BSDPLO,BSDPHI
 S CLN=0 F  S CLN=$O(@BSDAR@(CLN)) Q:'CLN  D
 . Q:$D(^SC("AIHSPC",CLN))           ;quit if principal clinic
 . S NAME=$$GET1^DIQ(44,CLN,.01)     ;set clinic's name
 . S PC=$$PC(CLN)                    ;set clinc's principal clinic
 . K BSDLO,BSDHI
 . ;
 . ; -- then by date appt made
 . S MADE=BSDBD,END=BSDED+.2400
 . F  S MADE=$O(^SC("AIHSDAM",CLN,MADE)) Q:'MADE!(MADE>END)  D
 .. S DOW=$$DOW^XLFDT(MADE)          ;day of week
 .. S DOWN=$$DOW^XLFDT(MADE,1)       ;day of week number
 .. ;
 .. ; -- then by appts
 .. S APPT=0
 .. F  S APPT=$O(^SC("AIHSDAM",CLN,MADE,APPT)) Q:'APPT  D
 ... Q:$$WALKIN(CLN,MADE,APPT)           ;don't count walkins
 ... D INCR(PC,NAME,(MADE\1),DOWN)       ;increment totals for clinic
 ... D WAIT(PC,NAME,(MADE\1),APPT)       ;set appt wait times
 . ;
 . ; set high-low values for clinic
 . Q:'BSDIND
 . S ^TMP("BSDDAM3",$J,PC,NAME,0)=$G(BSDLO)_U_$G(BSDHI)
 ;
 ; -- set princ clinic high-low values
 NEW X S X=0 F  S X=$O(BSDPLO(X)) Q:X=""  D
 . S ^TMP("BSDDAM3",$J,X,0,0)=BSDPLO(X)_U_BSDPHI(X)
 ;
 ;
 ; -- set display lines by princ clinic
 NEW PC,LINE,TOT
 S PC=0 F  S PC=$O(^TMP("BSDDAM1",$J,PC)) Q:PC=""  D
 . D SET(PC,.VALMCNT)                ;display princ clinic name
 . ;
 . S LINE=$$PAD(" Total for this principal clinic:",40)
 . S TOT=+$G(^TMP("BSDDAM1",$J,PC))
 . S LINE=$$PAD(LINE_$J(TOT,5),60)_$J($$AVETOT(PC,0,TOT),5)
 . D SET(LINE,.VALMCNT)
 . ;
 . I BSDDET D DETAIL(PC,0)      ;display daily details
 . D AVEDOW(PC,0)               ;display averages for days of week
 . I BSDIND D CLOOP(PC)         ;display individual clinics if chosen
 . I $O(^TMP("BSDDAM1",$J,PC))]"" D SET("",.VALMCNT),SET("",.VALMCNT)
 ;
 K ^TMP("BSDDAM1",$J),^TMP("BSDDAM2",$J),^TMP("BSDDAM3",$J)
 Q
 ;
 ;
INCR(S1,S2,S3,S4) ; -- increment totals
 ; S1=princ cln, S2=Cln name, S3=Date appt made, S4=day of week #
 ; increment total appts made & day of week # for principal clinic
 S ^TMP("BSDDAM1",$J,S1)=$G(^TMP("BSDDAM1",$J,S1))+1
 S ^TMP("BSDDAM1",$J,S1,0,S3)=$G(^TMP("BSDDAM1",$J,S1,0,S3))+1
 S ^TMP("BSDDAM2",$J,S1,0,S4)=$G(^TMP("BSDDAM2",$J,S1,0,S4))+1
 ;
 Q:'BSDIND     ;quit if individual clinics not to be displayed
 ;
 ; increment totals for clinic
 S ^TMP("BSDDAM1",$J,S1,S2)=$G(^TMP("BSDDAM1",$J,S1,S2))+1
 S ^TMP("BSDDAM1",$J,S1,S2,S3)=$G(^TMP("BSDDAM1",$J,S1,S2,S3))+1
 S ^TMP("BSDDAM2",$J,S1,S2,S4)=$G(^TMP("BSDDAM2",$J,S1,S2,S4))+1
 Q
 ;
WAIT(S1,S2,S3,S4) ; -- set lo-hi-total wait times
 ; S1=princ clinic, S2=clinic name, S3=appt date, S4=date appt made
 NEW DAYS S DAYS=$$FMDIFF^XLFDT(S4,S3) I DAYS<0 Q
 ;
 ; increment total wait times
 S ^TMP("BSDDAM3",$J,S1,0)=$G(^TMP("BSDDAM3",$J,S1,0))+DAYS
 S ^TMP("BSDDAM3",$J,S1,S2)=$G(^TMP("BSDDAM3",$J,S1,S2))+DAYS
 ;
 ; reset high-low wait times for principal clinic
 S BSDPLO(S1)=$S('$D(BSDPLO(S1)):DAYS,DAYS<BSDPLO(S1):DAYS,1:BSDPLO(S1))
 S BSDPHI(S1)=$S('$D(BSDPHI(S1)):DAYS,DAYS>BSDPHI(S1):DAYS,1:BSDPHI(S1))
 Q:'BSDIND          ;quit if not displaying individual clinic data
 ;
 ; reset high-low wait times for clinic
 S BSDLO=$S('$D(BSDLO):DAYS,DAYS<BSDLO:DAYS,1:BSDLO)
 S BSDHI=$S('$D(BSDHI):DAYS,DAYS>BSDHI:DAYS,1:BSDHI)
 Q
 ;
 ;
DETAIL(S1,S2) ; -- daily details into display array
 ; S1=princ clinc, S2=clinic or 0
 NEW MADE,LAST,LINE
 S (LAST,MADE)=0
 F  S MADE=$O(^TMP("BSDDAM1",$J,S1,S2,MADE)) Q:'MADE  D
 . ;
 . ; extra line between weeks
 . I $$DOW^XLFDT(MADE,1)<$$DOW^XLFDT(LAST,1) D SET("",.VALMCNT)
 . ;
 . ; create display line
 . S LINE=$$PAD($$SP(2)_$$FMTE^XLFDT(MADE),21)_$$DOW^XLFDT(MADE)
 . S LINE=$$PAD(LINE,40)_$J(+$G(^TMP("BSDDAM1",$J,S1,S2,MADE)),5)
 . ;
 . ; put into display array
 . D SET(LINE,.VALMCNT) S LAST=MADE
 Q
 ;
CLOOP(S1) ; -- loop thru clinics for princ clinic S1
 NEW CLN,LINE,TOT
 S CLN=0 F  S CLN=$O(^TMP("BSDDAM1",$J,S1,CLN)) Q:CLN=""  D
 . D SET(CLN,.VALMCNT)                ;display princ clinic name
 . ;
 . S LINE=$$PAD($$SP(4)_"Total for this clinic:",40)
 . S TOT=+$G(^TMP("BSDDAM1",$J,S1,CLN))
 . S LINE=$$PAD(LINE_$J(TOT,5),60)_$J($$AVETOT(S1,CLN,TOT),5)
 . D SET(LINE,.VALMCNT)
 . ;
 . I BSDDET D DETAIL(S1,CLN)            ;display daily details
 . D AVEDOW(S1,CLN)                     ;day of week averages
 Q
 ;
AVEDOW(S1,S2) ; -- day of week averages
 ; S1=princ clinic, S2=clinic or 0 if called by princ clin code
 NEW DAY,LINE,X,AVE
 D SET("",.VALMCNT)
 S DAY="" F  S DAY=$O(BSDA(DAY)) Q:DAY=""  D
 . S LINE=$$PAD($$SP(10)_"Average for "_BSDA(DAY)_"s: ",40)
 . S LINE=LINE_$J(+$G(^TMP("BSDDAM2",$J,S1,S2,DAY)),5)    ;total
 . S LINE=$$PAD(LINE,60)_$J((+$G(^TMP("BSDDAM2",$J,S1,S2,DAY))\$$DOWC(S1,S2,DAY)),5)
 . D SET(LINE,.VALMCNT)
 ;
 S LINE=$$PAD($$SP(5)_"Wait Times:  Low - High - Average",40)
 D SET(LINE,.VALMCNT)
 S X=$G(^TMP("BSDDAM3",$J,S1,S2,0)),Y=$G(^TMP("BSDDAM3",$J,S1,S2))
 S AVE=$G(^TMP("BSDDAM1",$J,S1)),AVE=$S(AVE=0:0,1:Y\AVE)
 S LINE=$$SP(18)_$J(+$P(X,U),3)_" - "_$J(+$P(X,U,2),3)_"  - "_$J(AVE,4)
 D SET(LINE,.VALMCNT)
 Q
 ;
AVETOT(S1,S2,S3) ; -- returns average # appts made in clinic
 ; S1=prin cln, S2=clinic or 0
 NEW X S X=$$TOTC(S1,S2) I X=0 Q 0
 Q S3\X
 ;
DOWC(S1,S2,S3) ; -- returns # of day S3 for prin clinic S1 & clinic S2
 NEW X,Y S (X,Y)=0
 F  S X=$O(^TMP("BSDDAM1",$J,S1,S2,X)) Q:'X  D
 . I $$DOW^XLFDT(X,1)=S3 S Y=Y+1   ;increment if date is DOW in S3
 Q $S(Y=0:1,1:Y)
 ;
TOTC(S1,S2) ; -- returns # of days
 NEW X,Y S (X,Y)=0
 F  S X=$O(^TMP("BSDDAM1",$J,S1,S2,X)) Q:'X  S Y=Y+1
 Q Y
 ;
WALKIN(S1,S2,S3) ; -- returns 1 if appt not scheduled or an error
 ; S1=clinic ien, S2=date made, S3=appt date
 NEW X S X=$O(^SC("AIHSDAM",S1,S2,S3,0)) I 'X Q 1
 NEW PAT S PAT=+$G(^SC(CLN,"S",S3,1,X,0)) I 'PAT Q 1
 I $P($G(^DPT(PAT,"S",S3,0)),U,7)'=3 Q 1
 Q 0    ;scheduled appt
 ;
SET(LINE,NUM) ; -- put line into display array
 S NUM=NUM+1
 S ^TMP("BSDDAM",$J,NUM,0)=LINE
 Q
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
 S LINE=0 F  S LINE=$O(^TMP("BSDDAM",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDDAM",$J,LINE,0)
 D ^%ZISC D EXIT
 Q
 ;
HDG ; -- 2nd half of heading
 NEW X
 W @IOF,!!?20,"Number of Appointments Made by Date"
 D HDR,MSG^BDGF(VALMHDR(1),0,1)
 S X=$$PAD($$PAD($$SP(3)_"Date Appt Made",22)_"Day of Week",40)
 S X=$$PAD(X_"# Appts Made",57)_"Ave # Appts Made"
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
