BDGLOS1 ; IHS/ANMC/LJF - LOS BY WARD BY MONTH ;  [ 09/30/2004  11:32 AM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
EN ; -- main entry point for BDG LOS BY WARD & MONTH
 NEW VALMCNT
 I $E(IOST,1,2)="P-" D INIT,PRINT Q   ;if printing to paper
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG LOS BY WARD & MONTH")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 NEW X S X=$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW DFN,CA,DATE,IEN,WARD,ENDDT,BEGIN,MONTH,END,LOS,LINE,NAME,BDGEDT
 K ^TMP("BDGLOS1",$J),^TMP("BDGLOS1A",$J)
 S VALMCNT=0
 S BDGEDT=$$FMADD^XLFDT(BDGED,1)
 ;
 ; first find all inpatients during date range
 S DFN=0 F  S DFN=$O(^DGPM("APCA",DFN)) Q:'DFN  D
 . S CA=0 F  S CA=$O(^DGPM("APCA",DFN,CA)) Q:'CA  D
 .. ;
 .. Q:'$G(^DGPM(CA,0))       ;bad xref entry
 .. I $$DSCH(CA)<BDGBD Q     ;if patient discharged before begin date
 .. I +^DGPM(CA,0)>BDGED Q   ;if patient admitted after end date
 .. ;
 .. ; for each inpatient, find all wards & their los
 .. S DATE=0
 .. F  S DATE=$O(^DGPM("APCA",DFN,CA,DATE)) Q:'DATE  Q:(DATE>BDGED)  D
 ... S IEN=0 F  S IEN=$O(^DGPM("APCA",DFN,CA,DATE,IEN)) Q:'IEN  D
 .... ;
 .... Q:'$G(^DGPM(IEN,0))               ;bad xref entry
 .... Q:$P(^DGPM(IEN,0),U,2)=3          ;discharge movement
 .... S WARD=$$GET1^DIQ(405,IEN,.06)    ;find ward for this movement
 .... S ENDDT=$$NEXTDT(DFN,CA,DATE)     ;find date pat left ward
 .... S NAME=$$GET1^DIQ(2,DFN,.01)      ;patient name
 .... ;
 .... ;IHS/ITSC/WAR 9/30/04 PATCH #1001 resolve incorrect display of
 .... ;  a Pt's LOS. Was displaying each month instead of combining
 .... S BDGADT=$E(DATE,1,5)
 .... ;
 .... ; loop thru months for date pair
 .... S BEGIN=DATE F  Q:BEGIN>ENDDT  D
 ..... S MONTH=$E(BEGIN,1,5)
 ..... ;
 ..... ; if pat left ward in same month
 ..... I $E(BEGIN,1,5)=$E(ENDDT,1,5) D  Q   ;same month
 ...... S LOS=$$FMDIFF^XLFDT(ENDDT,BEGIN)  ;difference
 ...... I DATE=ENDDT S LOS=1               ;if 1 day admit
 ...... I LOS S ^TMP("BDGLOS1A",$J,MONTH,WARD,NAME,CA)=$G(^TMP("BDGLOS1A",$J,MONTH,WARD,NAME,CA))+LOS
 ...... S BEGIN=9999999   ;end loop
 ..... ;
 ..... ; else find days for first month
 ..... ;IHS/ITSC/WAR 8/11/04 PATCH #1001 per /IHS/ANMC/DLG  05AUG2004
 ..... ; problem with leap-year required a change and in DAYS subrtn
 ..... ;S END=MONTH_$$DAYS(+$E(MONTH,4,5))
 ..... S END=MONTH_$$DAYS(MONTH)        ; pass the year and month
 ..... S END=$$FMADD^XLFDT(END,1)
 ..... S LOS=$$FMDIFF^XLFDT(END,BEGIN)
 ..... ;IHS/ITSC/WAR 9/30/04 PATCH #1001 see above note, dated same
 ..... ;I LOS S ^TMP("BDGLOS1A",$J,MONTH,WARD,NAME,CA)=$G(^TMP("BDGLOS1A",$J,MONTH,WARD,NAME,CA))+LOS
 ..... I LOS S ^TMP("BDGLOS1A",$J,BDGADT,WARD,NAME,CA)=$G(^TMP("BDGLOS1A",$J,BDGADT,WARD,NAME,CA))+LOS
 ..... ;
 ..... ; then for all others until discharge or end of date range
 ..... S BEGIN=END   ;beginning of next month
 ;
 S MONTH=0
 F  S MONTH=$O(^TMP("BDGLOS1A",$J,MONTH)) Q:'MONTH  D
 . S WARD=0
 . F  S WARD=$O(^TMP("BDGLOS1A",$J,MONTH,WARD)) Q:WARD=""  D
 .. S NAME=0
 .. F  S NAME=$O(^TMP("BDGLOS1A",$J,MONTH,WARD,NAME)) Q:NAME=""  D
 ... S CA=0
 ... F  S CA=$O(^TMP("BDGLOS1A",$J,MONTH,WARD,NAME,CA)) Q:'CA  D
 .... S LOS=^TMP("BDGLOS1A",$J,MONTH,WARD,NAME,CA)   ;length of stay
 .... ;
 .... S LINE=$$FMTE^XLFDT(MONTH_"00")           ;month - external format
 .... S LINE=$$PAD(LINE,12)_$E(WARD,1,6)        ;then ward
 .... S LINE=$$PAD(LINE,20)_$E(NAME,1,18)       ;then patient
 .... S DFN=$$GET1^DIQ(405,CA,.03,"I")
 .... S LINE=$$PAD(LINE,40)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)   ;chart #
 .... S LINE=$$PAD(LINE,50)_$P($$GET1^DIQ(405,CA,.01),"@")   ;admit date
 .... S LINE=$$PAD(LINE,65)_$J(LOS,4)                        ;# of days
 .... D SET(LINE,.VALMCNT)
 ;
 I '$D(^TMP("BDGLOS1",$J)) D SET("NO DATA FOUND",.VALMCNT)
 K ^TMP("BDGLOS1A",$J)
 Q
 ;
DSCH(ADM) ; return discharge date for admission ADM
 NEW X
 S X=$P($G(^DGPM(ADM,0)),U,17) I X="" Q 9999999    ;still inpatient
 Q $S($G(^DGPM(X,0)):+^(0),1:9999999)
 ;
NEXTDT(PAT,ADM,LAST) ; return date when patient left ward
 NEW DATE
 S DATE=$O(^DGPM("APCA",PAT,ADM,LAST))
 I 'DATE S DATE=$$DSCH(ADM)         ;if last mvmt, return discharge date
 Q $S(DATE>BDGED:BDGEDT,1:DATE)      ;only go as far as date range
 ;
 ;IHS/ITSC/WAR 8/11/04 PATCH #1001 per /IHS/ANMC/DLG  05AUG2004
DAYS(YRMONTH) ; return # of days in particular year/month
 ; /IHS/ANMC/DLG  05AUG2004  Fix the leap year bug
 ; Original line-label and following line are below:
 ;DAYS(M)        ; return # of days in particular month
 ; I M=2,$E($$FMADD^XLFDT(M_"28",1),6,7)=29 Q 29   ;leap year
 ; 
 NEW M
 S M=+$E(YRMONTH,4,5)
 I M=2,$E($$FMADD^XLFDT(YRMONTH_"28",1),6,7)=29 Q 29   ;leap year
 ; /IHS/ANMC/DLG  end of changes
 Q $P($T(DAY),";;",M+1)
 ;
DAY ;;31;;28;;31;;30;;31;;30;;31;;31;;30;;31;;30;;31
 ;
SET(DATA,NUM) ; puts display data into array
 S NUM=NUM+1
 S ^TMP("BDGLOS1",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGLOS1",$J)
 K BDGBD,BDGED
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print to paper
 NEW BDGN
 U IO
 D HDG S BDGN=0
 F  S BDGN=$O(^TMP("BDGLOS1",$J,BDGN)) Q:'BDGN  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGLOS1",$J,BDGN,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading if printing to paper
 W @IOF
 NEW X S X="LENGTH OF STAY BY MONTH AND WARD" W !?80-$L(X)\2,X
 D HDR S X=0 F  S X=$O(VALMHDR(X)) Q:'X  W !,VALMHDR(X)
 W !,$$REPEAT^XLFSTR("=",80)
 W !,"Month",?12,"Ward",?20,"Patient Name",?40,"Chart #"
 W ?50,"Admit Date",?65,"Length of Stay",!,$$REPEAT^XLFSTR("-",80),!
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
