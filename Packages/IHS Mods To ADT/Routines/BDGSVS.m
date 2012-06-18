BDGSVS ; IHS/ANMC/LJF - SCHED VISIT SUMMARY ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ; Assumes BDGN set to ien in Scheduled Visit file
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("PQ","EN^BDGSVS","SCHED VISIT SUMMARY","BDGN") Q
 ;
EN ; -- main entry point for BDG SCHED VISIT SUMMARY
 NEW VALMCNT
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SCHED VISIT SUMMARY")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X=$E($$GET1^DIQ(9009016.7,BDGN,.01),1,25)               ;pat name
 S X=$$PAD(X,30)_"#"_$$GET1^DIQ(9009016.7,BDGN,.011)       ;chart #
 S X=$$PAD(X,40)_"Age: "_$$GET1^DIQ(9009016.7,BDGN,.012)   ;age
 S X=$$PAD(X,50)_"Comm: "_$$GET1^DIQ(9009016.7,BDGN,.013)  ;community
 S VALMHDR(2)=X
 Q
 ;
INIT ; -- init variables and list array
 NEW DFN,LINE,X
 K ^TMP("BDGSVS",$J)
 S VALMCNT=0
 ;
 S X="SCHEDULED "_$$GET1^DIQ(9009016.7,BDGN,.03)
 S LINE=$$SP(79-$L(X)\2)_$G(IORVON)_X_$G(IORVOFF)     ;center visit type
 D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 ;
 ; set up display of fields based on visit type
 S X=$$GET1^DIQ(9009016.7,BDGN,.03,"I") Q:X=""  D @X
 D SET("",.VALMCNT)
 D TRAVEL                     ;travel fields
 D SET("",.VALMCNT)
 D DATA(203,21)                  ;additional comments
 ;
 Q
 ;
A ; process admission fields
 NEW FIELD
 F FIELD=.02,.13,.04,.05,.08,.09,201,.06,.14,.15,202,.16 D DATA(FIELD,26)
 Q
 ;
D ; process day surgery fields
 NEW FIELD
 F FIELD=.02,.14,.13,.17,.04,.05,.121,201,202,.06,.16 D DATA(FIELD,26)
 Q
 ;
O ; process outpatient visit fields
 NEW FIELD
 F FIELD=.02,.13,.04,.05,.11,201,202,.06,.16 D DATA(FIELD,26)
 Q
 ;
DATA(FLD,LEN) ; process one field
 NEW X,LINE
 S X=$$GET1^DIQ(9009016.7,BDGN,FLD) I X="" Q
 D SET($$RJ^XLFSTR($$TITLE(FLD),LEN)_X,.VALMCNT)
 Q
 ;
SET(DATA,NUM) ; put display data into array
 S NUM=NUM+1
 S ^TMP("BDGSVS",$J,NUM,0)=DATA
 Q
 ;
TITLE(F) ;  return field F name or title
 NEW X S X=$G(^DD(9009016.7,F,.1))
 Q $S(X]"":X,1:$P(^DD(9009016.7,F,0),U))_":  "
 ;
TRAVEL ; set up travel fields for display
 NEW FIELD
 F FIELD=101,103,104,105,102 D DATA(FIELD,26)
 D SET("",.VALMCNT)
 F FIELD=106,107,108,109,110,111 D DATA(FIELD,34)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSVS",$J)
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
 U IO D HDR
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGSVS",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGSVS",$J,BDGX,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF,?15,"Scheduled Visit Summary"
 F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
