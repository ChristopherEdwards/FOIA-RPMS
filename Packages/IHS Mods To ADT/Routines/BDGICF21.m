BDGICF21 ; IHS/ANMC/LJF - VIEW IC SUMMARY ;  [ 08/20/2004  11:45 AM ]
 ;;5.3;PIMS;**1001**;APR 26, 2002
 ;
EN ; -- main entry point for BDG IC VIEW
 NEW VALMCNT
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC VIEW")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X=$E($$GET1^DIQ(9009016.1,BDGN,.01),1,25)               ;pat name
 S X=$$PAD(X,30)_"#"_$$GET1^DIQ(9009016.1,BDGN,.011)       ;chart #
 S X=$$PAD(X,40)_"Coverage: "_$$GET1^DIQ(9009016.1,BDGN,.0391)
 S VALMHDR(2)=X
 Q
 ;
INIT ; -- init variables and list array
 NEW DFN,LINE,X,TYP
 K ^TMP("BDGICF2",$J)
 S VALMCNT=0
 ;
 S X="INCOMPLETE "_$$GET1^DIQ(9009016.1,BDGN,.0392)_" CHART"
 ;6/19/2002 LJF8 (per Linda) Bold,RevVid,Underline,etc.
 ;S LINE=$$SP(79-$L(X)\2)_IORVON_X_IORVOFF     ;center visit type
 S LINE=$$SP(79-$L(X)\2)_$G(IORVON)_X_$G(IORVOFF)     ;center visit type
 D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 ;
 ; set up display of fields based on visit type
 S TYP=$E($$GET1^DIQ(9009016.1,BDGN,.0392),1,3) Q:TYP=""
 I (TYP="HOS")!(TYP="DAY")!(TYP="OBS") D @TYP I 1
 E  D SET("???",.VALMCNT) Q
 D SET("",.VALMCNT)
 D DATES(TYP)                  ;date fields
 D SET("",.VALMCNT)
 D DATA(.18,21)                ;additional comments
 D DEF                         ;display deficiencies with resolutions
 ;
 Q
 ;
HOS ; process admission fields
 NEW FIELD
 F FIELD=.03,.02,.04 D DATA(FIELD,25)
 Q
 ;
DAY ; process day surgery fields
 NEW FIELD
 F FIELD=.03,.05,.04 D DATA(FIELD,25)
 Q
 ;
OBS ; process observation fields     
 D DAY Q
 ;
DATA(FLD,LEN) ; process one field
 NEW X,LINE
 S X=$$GET1^DIQ(9009016.1,BDGN,FLD) I X="" Q
 S LINE=$$RJ^XLFSTR($$TITLE(FLD),LEN)_X
 I FLD=.13 S LINE=LINE_" by "_$$GET1^DIQ(9009016.1,BDGN,.22)  ;coder
 I FLD=.15 S LINE=LINE_" by "_$$GET1^DIQ(9009016.1,BDGN,.23)  ;bill pre
 D SET(LINE,.VALMCNT)
 Q
 ;
DEF ; find deficiencies to display
 NEW IEN,PRV,FIRST,LINE,X
 ; loop by provider name
 S FIRST=1
 S PRV=0 F  S PRV=$O(^BDGIC(BDGN,1,"B",PRV)) Q:'PRV  D
 . S IEN=0 F  S IEN=$O(^BDGIC(BDGN,1,"B",PRV,IEN)) Q:'IEN  D
 .. ;
 .. ; quit if deleted deficiency and only displaying pending ones
 .. I '$G(BDGIC),$$GET1^DIQ(9009016.11,IEN_","_BDGN,.04)]"" Q
 .. ;
 .. ; quit if resolved deficiency and only displaying pending ones
 .. I '$G(BDGIC),$$GET1^DIQ(9009016.11,IEN_","_BDGN,.03)]"" Q
 .. ;
 .. I FIRST D SET($$SP(3)_"Deficiencies:",.VALMCNT) S FIRST=0
 .. ;
 .. S LINE=$$PAD($$SP(5)_$E($$GET1^DIQ(200,+PRV,.01),1,20),30)  ;name
 .. S LINE=LINE_$$GET1^DIQ(9009016.11,IEN_","_BDGN,.02)  ;deficiency
 .. S LINE=$$PAD(LINE,60)_$$GET1^DIQ(9009016.11,IEN_","_BDGN,.0393)
 .. D SET(LINE,.VALMCNT)
 .. ;
 .. ; if resolved, give date and how long it took
 .. S X=$$GET1^DIQ(9009016.11,IEN_","_BDGN,.03) I X]"" D
 ... S LINE=$$SP(7)_"Resolved on "_X_" in "
 ... S LINE=LINE_$$GET1^DIQ(9009016.11,IEN_","_BDGN,.0392)_" days"
 ... D SET(LINE,.VALMCNT)
 .. ;
 .. ; if deleted, give date and reason
 .. S X=$$GET1^DIQ(9009016.11,IEN_","_BDGN,.04) I X]"" D
 ... S LINE=$$SP(7)_" Deleted on "_X_"; Reason: "
 ... S LINE=LINE_$$GET1^DIQ(9009016.11,IEN_","_BDGN,.05)
 ... D SET(LINE,.VALMCNT)
 .. ;
 .. ; display comment if one exists
 .. S X=$$GET1^DIQ(9009016.11,IEN_","_BDGN,.06) I X]"" D
 ... D SET($$SP(7)_"Comment: "_X,.VALMCNT)
 Q
 ;
SET(DATA,NUM) ; put display data into array
 S NUM=NUM+1
 S ^TMP("BDGICF2",$J,NUM,0)=DATA
 Q
 ;
TITLE(F) ;  return field F name or title
 NEW X S X=$G(^DD(9009016.1,F,.1))
 Q $S(X]"":X,1:$P(^DD(9009016.1,F,0),U))_":  "
 ;
DATES(TYP) ; set up travel fields for display
 NEW FIELD
 D DATA($S(TYP["DAY":.05,1:.02),30)
 F FIELD=.11,.19,.12,.13,.14,.15,.16 D DATA(FIELD,30)
 D SET("",.VALMCNT),DATA(.21,30)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGICF2",$J)
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
 ;
PRINT ; print report to paper
 NEW BDGX
 ;IHS/ITSC/LJF 6/2/2004;PATCH #1001
 ;U IO D HDR
 U IO D HDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGICF2",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGICF2",$J,BDGX,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 ;IHS/ITSC/LJF 6/2/2004;PATCH #1001
 ;D HDR W @IOF,?15,"Scheduled Visit Summary"
 D HDR W @IOF,?15,"Incomplete Chart Summary"
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
