BSDCLA ; IHS/ANMC/LJF - LIST CLINIC ABBREVIATIONS ;  [ 01/13/2004  2:10 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 S Y=$$BROWSE^BDGF I Y="B" D EN^BSDCLA Q
 I Y="P" D ZIS^BDGF("PQ","START^BSDCLA","LIST CLINIC ABBREV") Q
 K POP
 Q
 ;
START ;EP; called if printing to paper
 NEW BSDPG,ABBRV,CLN
 U IO S BSDPG=0 D HED
 S ABBRV=0 F  S ABBRV=$O(^SC("C",ABBRV)) Q:ABBRV=""  D
 . S CLN=0 F  S CLN=$O(^SC("C",ABBRV,CLN)) Q:CLN=""  D
 .. Q:$P(^SC(CLN,0),U,3)'["C"  Q:'$$ACTV^BSDU(CLN,DT)
 .. I $Y>(IOSL-4) D HED
 .. W !,ABBRV,?10,$P(^SC(CLN,0),U)
 D ^%ZISC Q
 ;
EN ;EP -- main entry point for BSDRM CLINIC ABBREVIATIONS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM CLINIC ABBREVIATIONS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 D MSG^BDGF("Gathering clinics and sorting by abbreviations...",1,0)
 NEW ABBRV,CLN
 S VALMCNT=0 K ^TMP("BSDCLA",$J)
 S ABBRV=0 F  S ABBRV=$O(^SC("C",ABBRV)) Q:ABBRV=""  D
 . S CLN=0 F  S CLN=$O(^SC("C",ABBRV,CLN)) Q:CLN=""  D
 .. Q:$P(^SC(CLN,0),U,3)'["C"  Q:'$$ACTV^BSDU(CLN,DT)
 .. S VALMCNT=VALMCNT+1
 .. S ^TMP("BSDCLA",$J,VALMCNT,0)=$$PAD(ABBRV,10)_$$GET1^DIQ(44,CLN,.01)
 I VALMCNT=0 S ^TMP("BSDCLA",$J,1,0)="NO ACTIVE CLINICS FOUND",VALMCNT=1
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDCLA",$J),POP
 Q
 ;
EXPND ; -- expand code
 Q
 ;
HED ; -- heading
 I (BSDPG>0) W @IOF
 S BSDPG=BSDPG+1 W !!?25,"CLINIC ABBREVIATIONS",?70,"Page ",BSDPG
 W !,$$REPEAT^XLFSTR("=",80),!
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
