BDGEAN2 ; IHS/ANMC/LJF - INPTS W/OUT EXTERNAL ACCT # ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW BDGBD,BDGED,X
 S BDGBD=$$READ^BDGF("DO^::E","Enter Earliest Admission Date") Q:'BDGBD
 S BDGED=$$READ^BDGF("DO^"_BDGBD_":"_DT_":E","Enter Latest Admission Date") Q:'BDGED
 S X=$$BROWSE^BDGF I X="B" D EN Q
 I X="P" D ZIS^BDGF("PQ","EN^BDGEAN2","INPT W/OUT ACCT #","BDGBD;BDGED")
 Q
 ;
EN ; -- main entry point for BDG IPL W/OUT ACCT NO
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IPL W/OUT ACCT")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 ; uses same tmp global as BDGEAN so same edit protocol works
 NEW BDGDT,BDGEND,BDGN,DFN,VST,LINE,COUNT
 S VALMCNT=0,COUNT=1
 K ^TMP("BDGEAN",$J)
 ;
 S BDGDT=BDGBD-.0001,BDGEND=BDGED+.2359
 F  S BDGDT=$O(^DGPM("ATT1",BDGDT)) Q:'BDGDT  Q:(BDGDT>BDGEND)  D
 . S BDGN=0 F  S BDGN=$O(^BDGPM("ATT1",BDGDT,BDGN)) Q:'BDGN  D
 .. ;
 .. S VST=$$GET1^DIQ(405,BDGN,.27,"I")
 .. I VST,$$GET1^DIQ(9000010,VST,1211)]"" Q   ;has acct #
 .. ;
 .. S DFN=$$GET1^DIQ(405,BDGN,.03,"I") Q:'DFN
 .. S LINE=$J(COUNT,3)_". "_$E($$GET1^DIQ(2,DFN,.01),1,25)  ;pat name
 .. S LINE=$$PAD(LINE,32)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)     ;chart #
 .. S LINE=$$PAD(LINE,41)_$$NUMDATE^BDGF($$GET1^DIQ(405,BDGN,.01,"I"))
 .. S LINE=$$PAD(LINE,65)_$S('VST:"No PCC Visit for admission",1:"")
 .. D SET(LINE,COUNT,BDGN,.VALMCNT)
 .. S COUNT=COUNT+1
 ;
 I '$D(^TMP("BDGEAN",$J)) D SET("NO INPATIENTS FOUND FOR DATE RANGE",0,0,.VALMCNT)
 Q
 ;
SET(DATA,CNT,IEN,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGEAN",$J,NUM,0)=DATA
 S ^TMP("BDGEAN",$J,"IDX",NUM,CNT)=IEN
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ;
 NEW BDGPG
 U IO D INIT^BDGF,HDG
 S BDGX=0 F  S BDGX=$O(^TMP("BDGEAN",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGEAN",$J,BDGX,0)
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading when printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGTIME,?16,$$CONF^BDGF,?76,BDGUSR
 W !,BDGDATE,?25,"Admissions witout Account Numbers",?71,"Page: ",BDGPG
 W !,$$REPEAT^XLFSTR("-",80)
 W !?5,"Patient Name",?32,"Chart #",?41,"Admission Date"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
