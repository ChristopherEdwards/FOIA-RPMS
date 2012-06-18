BDGEAN ; IHS/ANMC/LJF - INPTS W/ EXTERNAL ACCT # ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("PQ","EN^BDGEAN","INPT W/ ACCT #","")
 Q
 ;
EN ; -- main entry point for BDG IPL W/ ACCT NO
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 NEW VALMCNT
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IPL W/ ACCT NO")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 NEW WARD,DFN,ADM,VST,LINE,COUNT,FIRST
 S VALMCNT=0,(COUNT,FIRST)=1
 K ^TMP("BDGEAN",$J)
 ;
 S WARD=0 F  S WARD=$O(^DPT("CN",WARD)) Q:WARD=""  D
 . ;
 . I 'FIRST D SET("",COUNT,"",.VALMCNT)
 . I FIRST S FIRST=0
 . D SET("WARD: "_WARD,COUNT,"",.VALMCNT)
 . ;
 . S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D
 .. S ADM=$G(^DPT("CN",WARD,DFN)) Q:'ADM
 .. S VST=+$$GET1^DIQ(405,ADM,.27,"I")
 .. S LINE=$J(COUNT,3)_". "_$E($$GET1^DIQ(2,DFN,.01),1,25)  ;pat name
 .. S LINE=$$PAD(LINE,32)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)     ;chart #
 .. S LINE=$$PAD(LINE,41)_$$NUMDATE^BDGF($$GET1^DIQ(405,ADM,.01,"I"))
 .. S LINE=$$PAD(LINE,65)_$$GET1^DIQ(9000010,VST,1211)       ;acct #
 .. D SET(LINE,COUNT,ADM,.VALMCNT)
 .. S COUNT=COUNT+1
 ;
 I '$D(^TMP("BDGEAN",$J)) D SET("NO CURRENT INPATIENTS FOUND",0,0,.VALMCNT)
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
EDIT ;EP; select patient from list and edit account #
 NEW X,Y,Z,BDGN
 D FULL^VALM1
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP("BDGEAN",$J,"IDX",Y)) Q:Y=""  D
 .. S Z=$O(^TMP("BDGEAN",$J,"IDX",Y,0))
 .. Q:^TMP("BDGEAN",$J,"IDX",Y,Z)=""
 .. I Z=X S BDGN=^TMP("BDGEAN",$J,"IDX",Y,Z)
 ;
 I '$G(BDGN) S VALMBCK="R" Q
 ;
 NEW VST S VST=$$GET1^DIQ(405,BDGN,.27,"I")
 I 'VST W !!,"NO visit attached to admission; cannot edit" D PAUSE^BDGF S VALMBCK="R" Q
 NEW DA,DR,DIE
 W !,$$GET1^DIQ(9000010,VST,.05),?40,$$GET1^DIQ(9000010,VST,.01),!
 S DIE="^AUPNVSIT(",DA=VST,DR=1211 D ^DIE
 S VALMBCK="R" D HDR,INIT
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
 W !,BDGDATE,?25,"Inpatients with Account Numbers",?71,"Page: ",BDGPG
 W !,$$REPEAT^XLFSTR("-",80)
 W !?5,"Patient Name",?32,"Chart #",?41,"Admission Date"
 W ?65,"Account #",!,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
