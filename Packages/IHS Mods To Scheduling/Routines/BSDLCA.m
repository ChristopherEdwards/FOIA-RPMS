BSDLCA ; IHS/ANMC/LJF - CLERK WHO MADE APPT LIST ; 
 ;;5.3;PIMS;**1010**;APR 26, 2002
 ;
REPORT ; -- ask user which report to run
 K DIR S DIR(0)="SO^1:LIST APPOINTMENTS;2:LIST USERS WITH COUNTS"
 S DIR("?",1)="Do you want a List of Appointments with the user who"
 S DIR("?",2)="made the appointment OR a List of Users with the number"
 S DIR("?",3)="of appointments each made to the clinic."
 S DIR("?")=" "
 S DIR("A")="Select Type of Report" D ^DIR I Y<1 D EXIT Q
 S BSDTYP=Y
 ;
CLINIC ; -- select clinic
 D CLINIC^BSDU(1) I $D(BSDQ) D EXIT Q
 ;
BD ; -- beginning date
 K DIR S DIR(0)="DO^::EX",DIR("A")="Select beginning date"
 D ^DIR K DIR G REPORT:$D(DIRUT),REPORT:Y<1 S BSDBDT=Y
 ;
ED ; -- ending date
 K DIR S DIR(0)="DO^::EX",DIR("A")="Select ending date"
 D ^DIR K DIR G BD:$D(DIRUT),BD:Y<1 S BSDEDT=Y
 ;
ZIS ; -- select device
 D ZIS^BDGF("PQ","EN^BSDLCA","LIST WHO MADE APPTS","BSD*;VA*")
 Q
 ;
EXIT K X,Y,DIR,BSDTYP,BSDBDT,BSDEDT,VAUTC,VAUTD,ZTSK
 K ^TMP("BSDLCA",$J),VALMCNT,BSDLN
 D ^%ZISC Q
 ;
EN ;EP; entry point for start of reports
 I BSDTYP=2 D EN^BSDLCA1 Q  ;stats report
 I IOST'["C-" D INIT,PRINT,EXIT Q  ;printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSM APPT MADE LIST")
 D CLEAR^VALM1,EXIT Q
 ;
HDR ;EP; list template header
 S VALMHDR(1)=$$SP(25)_$$RANGE^BDGF(BSDBDT,BSDEDT)
 Q
 ;
INIT ;EP; begin calculate for list template list
 K ^TMP("BSDLCA",$J),^TMP("BSDLCA1",$J)
 NEW SD,SC S BSDLN=0
 I VAUTC D ALL Q   ;all clinics chosen
 ; or loop thru selected clinics
 S SD="" F  S SD=$O(VAUTC(SD)) Q:SD=""  S SC=VAUTC(SD) Q:'SC  D DISPLAY
 S VALMCNT=BSDLN
 Q
 ;
ALL ; -- all clinics
 S SC=0 F  S SC=$O(^SC(SC)) Q:'SC  D
 . I $O(VAUTD(0)) Q:'$D(VAUTD(+$P(^SC(SC,0),U,15)))
 . Q:'$$ACTV^BSDU(SC,BSDBDT)  D DISPLAY
 S VALMCNT=BSDLN
 Q
 ;
DISPLAY ; -- loop clinics and set display lines
 NEW DATE,PAT,NODE,FIRST,LINE
 S FIRST=1
 S DATE=BSDBDT-.001
 F  S DATE=$O(^SC(+SC,"S",DATE)) Q:'DATE  Q:DATE>(BSDEDT+.9)  D
 . S PAT=0 F  S PAT=$O(^SC(+SC,"S",DATE,1,PAT)) Q:'PAT  D
 .. S NODE=^SC(+SC,"S",DATE,1,PAT,0)
 .. ; if first time in this clinic, display clinic name
 .. I FIRST D SET^BSDLCA1($$GET1^DIQ(44,+SC,.01)) S FIRST=0
 .. ;
 .. ; set up line with appt date, chart #, age, user, date appt made
 .. S LINE=$$PAD($$FMTE^XLFDT(DATE),20)_$J($$HRCN^BDGF2(+NODE,DUZ(2)),6)
 .. S LINE=$$PAD(LINE,30)_$$GET1^DIQ(9000001,+NODE,1102.98)
 .. S LINE=$$PAD(LINE,40)_$E($$GET1^DIQ(200,+$P(NODE,U,6),.01),1,20)
 .. S LINE=$$PAD(LINE,60)_$E($$FMTE^XLFDT($P(NODE,U,7)),1,18)
 .. D SET^BSDLCA1(LINE)
 I 'FIRST D SET^BSDLCA1("")
 Q
 ;
PRINT ; -- prints list to paper
 NEW BSDLN,BSDQT
 U IO S BSDQT=0 D HD(0)
 S BSDLN=0 F  S BSDLN=$O(^TMP("BSDLCA",$J,BSDLN)) Q:'BSDLN  Q:BSDQT  D
 . I $Y>(IOSL-4) D HD(1) Q:BSDQT
 . W !,^TMP("BSDLCA",$J,BSDLN,0)
 D ^%ZISC
 Q
 ;
HD(X) ; -- heading
 I IOST["C-",X S DIR(0)="E" D ^DIR S:'Y BSDQT=1 Q:'Y
 W @IOF,!!,?20,"LISTING OF APPTS MADE AND WHO MADE THEM"
 W !!,"DATE/TIME",?20,"HRCN"
 W ?30,"AGE",?40,"CLERK WHO MADE APPT",?65,"DATE APPT MADE",!!
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(N) ; -- returns N number of spaces
 Q $$PAD(" ",N)
