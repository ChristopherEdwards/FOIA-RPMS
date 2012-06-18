BDGILD2 ; IHS/ANMC/LJF - READMISSIONS BY DATE ; 
 ;;5.3;PIMS;**1009**;APR 26, 2002
 ;
 ;cmi/anch/maw 05/08/2008 PATCH 1009 requirements 22,31,71 for insurance display
 ;
EN ;EP; -- main entry point for BDG ILD READMISSIONS
 ; Assumes BDGTYP,BDGBD,BDGED,BDGTYP are set
 ;
 I $E(IOST,1,2)="P-" D INIT,PRINT Q    ;if printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG ILD READMISSIONS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(10)_"*** "_$$CONF^BDGF_" ***"
 S X="Sorted by "_$P($T(TYPE+BDGTYP),";;",2)
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(3)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0
 K ^TMP("BDGILD2",$J),^TMP("BDGILD2A",$J)
 ;
 D SET("Maximum days between inpatient stays:  "_BDGMAX,.VALMCNT)
 ;
 ; loop through admissions by date range and put into sorted array
 NEW DATE,DFN,IEN,END,SORT,LAST
 S DATE=BDGBD-.0001,END=BDGED+.24
 F  S DATE=$O(^DGPM("AMV1",DATE)) Q:'DATE  Q:(DATE>END)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV1",DATE,DFN)) Q:'DFN  D
 .. S IEN=0 F  S IEN=$O(^DGPM("AMV1",DATE,DFN,IEN))  Q:'IEN  D
 ... ;
 ... ; is this a readmission?
 ... S LAST=$$READM^BDGF1(IEN,DFN,BDGMAX) Q:'LAST
 ... ;
 ... ;  okay to use this admission based on sort criteria?
 ... Q:'$$OKAY^BDGILD1(BDGTYP,.BDGSRT,IEN,DFN)
 ... ;
 ... S SORT=$$SORT^BDGILD1(BDGTYP,IEN) S:SORT="" SORT="??"
 ... S ^TMP("BDGILD2A",$J,SORT,DATE,IEN)=DFN_U_$P(LAST,U,2)
 ;
 ;
 ; loop thru sorted array and put into display array
 NEW SORT,DATE,IEN,LINE,X,BDGCOV,BDGRR,I,DFN,LAST
 S SORT=0 F  S SORT=$O(^TMP("BDGILD2A",$J,SORT)) Q:SORT=""  D
 . ;
 . ; display sort heading (unless sorting by date alone)
 . I BDGTYP>1 D
 .. S X="*** "_SORT_" ***"
 .. D SET("",.VALMCNT),SET($$SP(75-$L(X)\2)_X,.VALMCNT)
 . ;
 . S DATE=0 F  S DATE=$O(^TMP("BDGILD2A",$J,SORT,DATE)) Q:'DATE  D
 .. S IEN=0 F  S IEN=$O(^TMP("BDGILD2A",$J,SORT,DATE,IEN)) Q:'IEN  D
 ... ;
 ... ; build display lines
 ... S DFN=+^TMP("BDGILD2A",$J,SORT,DATE,IEN)
 ... S LAST=$P(^TMP("BDGILD2A",$J,SORT,DATE,IEN),U,2)
 ... S LINE=$E($$GET1^DIQ(2,DFN,.01),1,20)                  ;pat name
 ... S LINE=$$PAD(LINE,23)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)   ;chart #
 ... S LINE=$$PAD(LINE,31)_$$NUMDATE^BDGF(DATE\1)           ;admit date
 ... I LAST S LINE=$$PAD(LINE,45)_$$NUMDATE^BDGF(LAST\1)    ;dsch date
 ... S LINE=$$PAD(LINE,57)_$J($$FMDIFF^XLFDT(DATE,LAST),3)  ;days diff
 ... S LINE=$$PAD(LINE,65)_$P($$ADMSRVC^BDGF1(IEN,DFN)," ")  ;srv abbrv
 ... S LINE=$$PAD(LINE,72)_$$WRDABRV2^BDGF1(IEN)            ;ward abbrv
 ... D SET(LINE,.VALMCNT)
 ... ;
 ... S LINE=$$SP(10)_"New Dx: "_$E($$GET1^DIQ(405,IEN,.1),1,25)  ;adm dx
 ... ; find admission ien for last discharge date
 ... S LASTCA=$P($G(^DGPM(+$O(^DGPM("APTT3",DFN,LAST,0)),0)),U,14)
 ... S LINE=$$PAD(LINE,45)_"Last Dx: "_$$GET1^DIQ(405,+LASTCA,.1)
 ... D SET(LINE,.VALMCNT)
 ... ;
 ... I BDGINS=1 D    ;include insurance coverage
 .... S BDGCOV=0
 .... ;S X=$$MCR^BDGF2(DFN,IEN),Y=$$MCD^BDGF2(DFN,IEN)  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31 orig line
 .... ;D INS^BDGF2(DFN,IEN,.BDGRR)  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31 orig line
 .... N BDGW,BDGX,BDGY,BDGZ
 .... S BDGX=$$NEWINS^BDGF2(DFN,IEN,"MCR"),BDGY=$$NEWINS^BDGF2(DFN,IEN,"MCD")  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31
 .... S BDGZ=$$NEWINS^BDGF2(DFN,IEN,"PI"),BDGW=$$NEWINS^BDGF2(DFN,IEN,"RR")  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31
 .... I BDGCOV=0 D SET($$SP(10)_"**No Additional Coverage**",.VALMCNT) Q
 .... I (BDGW]"")!(BDGX]"")!(BDGY]"") D SET($$SP(10)_BDGX_$$SP(2)_BDGY_$$SP(2)_BDGW,.VALMCNT)  ;cmi/anch/maw 5/2/2008 PATCH 1009 requirements 22,31
 .... ;I (X]"")!(Y]"") D SET($$PAD($$SP(10)_X,40)_Y,.VALMCNT)  ;cmi/anch/maw 5/2/2008 PATCH 1009 orig line
 .... ; display all current private insurance coverage
 .... S I=0 F  S I=$O(BDGRR(I)) Q:'I  D
 ..... D SET($$SP(3)_BDGRR(I),.VALMCNT)
 ... ;
 ... ; separate patients by blank line
 ...D SET("",.VALMCNT)
 ;
 ;
 I VALMCNT=1 D SET("No data found",.VALMCNT)
 ;
 K ^TMP("BDGILD2A",$J)
 Q
 ;
 ;
SET(DATA,NUM) ; puts display line into array
 S NUM=NUM+1
 S ^TMP("BDGILD2",$J,NUM,0)=DATA
 Q
 ;         
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGILD2",$J) K BDGBD,BDGED,BDGTYP,BDGSRT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print to paper
 NEW LINE,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 S LINE=0 F  S LINE=$O(^TMP("BDGILD2",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGILD2",$J,LINE,0)
 ;
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading when printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !?13,"***",$$CONF^BDGF,"***"
 W !,BDGUSR,?30,"Readmissions by Date",?71,"Page: ",BDGPG
 NEW X S X="Sorted by "_$P($T(TYPE+BDGTYP),";;",2)
 W !,BDGDATE,?(80-$L(X)\2),X
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Patient Name",?23,"Chart #",?31,"Admit Date",?45,"Last Dsch"
 W ?55,"Diff",?65,"Serv",?72,"Ward"
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
TYPE ;;
 ;;Date;;
 ;;Ward;;
 ;;Treating Specialty;;
 ;;Admitting Provider;;
 ;;Provider's Service;;
 ;;Community;;
 ;;Service Unit;;
 ;;Patient Name;;
