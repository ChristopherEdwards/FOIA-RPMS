BDGILD4 ; IHS/ANMC/LJF - ICU TRANSFERS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ;EP; -- main entry point for BDG ILD ICU TRANSFERS
 ; Assumes BDGTYP,BDGBD,BDGED,BDGTYP are set
 ;
 I $E(IOST,1,2)="P-" D INIT,PRINT Q    ;if printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 S X=$S(BDGTYP=1:"BDG ILD ICU TRANSFERS",1:"BDG ILD RETURNS TO ICU")
 D EN^VALM(X)
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(10)_"*** "_$$CONF^BDGF_" ***"
 S X=$S(BDGTYP=1:"Transfers",1:"Returns")_" to ICU"
 I BDGTYP=2 S X=X_" within "_BDGMAX_" days"
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(3)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0
 K ^TMP("BDGILD4",$J),^TMP("BDGILD4A",$J)
 ;
 ; loop through ward transfers by date range and put into sorted array
 NEW DATE,DFN,IEN,END,DIFF
 S DATE=BDGBD-.0001,END=BDGED+.24
 F  S DATE=$O(^DGPM("AMV2",DATE)) Q:'DATE  Q:(DATE>END)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV2",DATE,DFN)) Q:'DFN  D
 .. S IEN=0 F  S IEN=$O(^DGPM("AMV2",DATE,DFN,IEN))  Q:'IEN  D
 ... ;
 ... Q:'$$ICU^BDGPAR(IEN)                  ;quit if not ICU
 ... ;
 ... ;  is it a return to ICU and within time limit?
 ... I BDGTYP=2 S DIFF=$$OKAY(DATE,DFN,IEN) Q:'DIFF
 ... ;
 ... S ^TMP("BDGILD4A",$J,DATE,IEN)=DFN_U_$G(DIFF)
 ;
 ;
 ; loop thru sorted array and put into display array
 NEW DATE,IEN,LINE,X,BDGCOV,BDGRR,I
 S DATE=0 F  S DATE=$O(^TMP("BDGILD4A",$J,DATE)) Q:'DATE  D
 . S IEN=0 F  S IEN=$O(^TMP("BDGILD4A",$J,DATE,IEN)) Q:'IEN  D
 .. ;
 .. ; build display lines
 .. S DFN=+^TMP("BDGILD4A",$J,DATE,IEN)
 .. S LINE=$E($$GET1^DIQ(2,DFN,.01),1,20)                             ;pat name
 .. S LINE=$$PAD(LINE,23)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)              ;chart #
 .. ;
 .. I BDGTYP=1 D               ; transfers
 ... S LINE=$$PAD(LINE,31)_$$NUMDATE^BDGF(DATE)                       ;trans date
 ... S X=$$PRIORTXN^BDGF1((DATE+.0001),+$P(^DGPM(IEN,0),U,14),DFN)
 ... S X=$$GET1^DIQ(405,X,.09,"I")                                    ;last serv
 ... S LINE=$$PAD($$PAD(LINE,49)_$$GET1^DIQ(45.7,+X,99),56)           ;serv abbrv
 .. ;
 .. I BDGTYP=2 D              ; returns
 ... S LINE=$$PAD(LINE,31)_$$NUMDATE^BDGF(DATE)                       ;trans date 
 ... S X=$P(^TMP("BDGILD4A",$J,DATE,IEN),U,2)                         ;diff
 ... S LINE=$$PAD($$PAD(LINE,49)_X_$S(X=1:" day",1:" days"),61)
 .. ;
 .. ; admitting dx
 .. S LINE=LINE_$E($$GET1^DIQ(405,+$$GET1^DIQ(405,IEN,.14,"I"),.1),1,23)
 .. D SET(LINE,.VALMCNT)
 ;
 I '$D(^TMP("BDGILD4",$J)) D SET("No data found",.VALMCNT)
 ;
 K ^TMP("BDGILD4A",$J)
 Q
 ;
OKAY(DATE,PAT,IEN) ; is transfer a return and within the time limit?
 NEW TO,LAST,ADM,FOUND,N
 S ADM=$$GET1^DIQ(405,IEN,.14,"I") I 'ADM Q 0
 S (TO,LAST)=DATE,FOUND=0
 ; look for last ICU transfer, then use date of next transfer
 ;     as discharge from ICU
 F  S TO=$O(^DGPM("APCA",PAT,ADM,TO),-1) Q:'TO  Q:FOUND  D
 . S N=$O(^DGPM("APCA",PAT,ADM,TO,0)) Q:'N   ;ien for movement
 . I $$ICU^BDGPAR(N) S FOUND=1 Q       ;if ICU stop looking
 . S LAST=TO                           ;save last date
 I 'FOUND Q 0                          ;not a return to ICU
 ;
 S X=$$FMDIFF^XLFDT(DATE,LAST)         ;difference
 I X'>BDGMAX Q X                       ;if w/in limit, return diff
 Q 0
 ;
 ;
SET(DATA,NUM) ; puts display line into array
 S NUM=NUM+1
 S ^TMP("BDGILD4",$J,NUM,0)=DATA
 Q
 ;         
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGILD4",$J) K BDGBD,BDGED,BDGTYP,BDGSRT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print to paper
 NEW LINE,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 S LINE=0 F  S LINE=$O(^TMP("BDGILD4",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGILD4",$J,LINE,0)
 ;
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading when printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?13,"***",$$CONF^BDGF,"***"
 NEW X S X=$S(BDGTYP=1:"Transfers",1:"Returns")_" to ICU"
 I BDGTYP=2 S X=X_" within "_BDGMAX_" days"
 W !,BDGDATE,?(80-$L(X)\2),X,?71,"Page: ",BDGPG
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Patient Name",?23,"Chart #"
 I BDGTYP=1 W ?31,"Admit Date",?46,"Transferred"
 I BDGTYP=2 W ?31,"Transferred",?46,"Returned w/in"
 W ?61,"Admitting Dx"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
 ;
