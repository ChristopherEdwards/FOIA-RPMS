BSDLCA1 ; IHS/ANMC/LJF - CLERK WHO MADE APPT TOTALS ; [ 03/01/2004  2:16 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ;EP; -- main entry point for SD IHS APPT MADE BY
 I IOST'["C-" D INIT,PRINT,EXIT Q   ;printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSM APPT MADE STATS")
 D CLEAR^VALM1,EXIT Q
 ;
HDR ;EP; -- header code
 S VALMHDR(1)=$$SP(25)_$$RANGE^BDGF(BSDBDT,BSDEDT)
 Q
 ;
INIT ; -- gather data
 NEW SD,SC
 K ^TMP("BSDLCA",$J),^TMP("BSDLCA1",$J)
 I VAUTC D ALL,DISPLAY Q
 S SD=""
 F  S SD=$O(VAUTC(SD)) Q:SD=""  S SC=VAUTC(SD) Q:'SC  D 1
 D DISPLAY
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDLCA",$J),^TMP("BSDLCA1",$J)
 K VALMBCK,VALMCNT,VALMHDR,BSDLN,BSDTYP,BSDBDT,BSDEDT,VAUTC,VAUTD,%DT
 Q
 ;
ALL ; -- all clinics
 S SC=0 F  S SC=$O(^SC(SC)) Q:'SC  D
 . I $O(VAUTD(0)) Q:'$D(VAUTD(+$P(^SC(SC,0),U,15)))
 . Q:'$$ACTV^BSDU(SC,BSDBDT)  D 1
 Q
 ;
1 ; -- loop clinics
 NEW DATE,PAT,NODE,CLN,USR,COUNT,NM
 S CLN=$P(^SC(+SC,0),U)
 S DATE=BSDBDT-.001
 F  S DATE=$O(^SC(+SC,"S",DATE)) Q:'DATE  Q:DATE>(BSDEDT+.9)  D
 . S PAT=0 F  S PAT=$O(^SC(+SC,"S",DATE,1,PAT)) Q:'PAT  D
 .. S NODE=^SC(+SC,"S",DATE,1,PAT,0)
 .. S USR=$P(NODE,U,6),NM=$S(USR="":"UNKNOWN",1:$P(^VA(200,USR,0),U))
 .. S COUNT=$G(COUNT)+1 ;increment total appts
 .. S ^TMP("BSDLCA1",$J,CLN,NM,+USR)=$G(^TMP("BSDLCA1",$J,CLN,NM,+USR))+1
 ;IHS/ITSC/WAR 3/1/04 Don't write rec unless there is a count
 ;S ^TMP("BSDLCA1",$J,CLN)=$G(COUNT)
 I +$G(COUNT) S ^TMP("BSDLCA1",$J,CLN)=$G(COUNT)
 Q
 ;
DISPLAY ; -- create ^tmp for list template display
 NEW CLN,NM,USR,LINE,TOTAL,NUM
 K ^TMP("BSDLCA",$J) S BSDLN=0
 S CLN=0 F  S CLN=$O(^TMP("BSDLCA1",$J,CLN)) Q:CLN=""  D
 . ; set line with clinic name
 . S TOTAL=^TMP("BSDLCA1",$J,CLN),LINE=" "_$$PAD(CLN,49)_$J(+TOTAL,4)
 . D SET(LINE)
 . ;
 . ; loop thru users and give counts
 . S NM=0 F  S NM=$O(^TMP("BSDLCA1",$J,CLN,NM)) Q:NM=""  D
 .. S USR="" F  S USR=$O(^TMP("BSDLCA1",$J,CLN,NM,USR)) Q:USR=""  D
 ... S NUM=^TMP("BSDLCA1",$J,CLN,NM,USR)  ;# of appt by user
 ... S LINE=$$SP(25)_$$PAD(NM,25)_$$PAD($J(NUM,4),15)
 ... S LINE=LINE_$$PERCENT(NUM,TOTAL)
 ... D SET(LINE)
 . D SET(" ")
 S VALMCNT=BSDLN
 Q
 ;
SET(DATA) ; -- sets ^tmp with display line
 S BSDLN=$G(BSDLN)+1
 S ^TMP("BSDLCA",$J,BSDLN,0)=DATA
 S ^TMP("BSDLCA",$J,"IDX",BSDLN,BSDLN)=""
 Q
 ;
PERCENT(X,Y) ; -- returns % of y in x
 Q $J(X/Y*100,5,0)_"%"
 ;
PRINT ; -- prints list to paper
 NEW BSDLN
 U IO D HD(0)
 S BSDLN=0 F  S BSDLN=$O(^TMP("BSDLCA",$J,BSDLN)) Q:'BSDLN  D
 . I $Y>(IOSL-4) D HD(1)
 . W !,^TMP("BSDLCA",$J,BSDLN,0)
 D ^%ZISC
 Q
 ;
HD(X) ; -- heading
 W:X @IOF W !!,?27,"NUMBER OF APPTS MADE BY USERS",!
 W !?1,"Clinic Name",?25,"User Name",?47,"# of Appts Made"
 W ?65,"% of Total",!,$$REPEAT^XLFSTR("=",79),!
 Q
 ;
D(Y) ; -- date
 NEW N,P,D
 X ^DD("DD") Q Y
 ;
AGE(X) ; -- age
 NEW N,D,P
 Q $$GET1^DIQ(9000001,X,1102.98)
 ;
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(N) ; -- returns N number of spaces
 Q $$PAD(" ",N)
 ;
