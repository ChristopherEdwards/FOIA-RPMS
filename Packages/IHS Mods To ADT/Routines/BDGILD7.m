BDGILD7 ; IHS/ANMC/LJF - INPT DEATHS BY DATE ; 
 ;;5.3;PIMS;**1009**;APR 26, 2002
 ;
 ;cmi/anch/maw 05/08/2008 PATCH 1009 requirements 22,31,71 for insurance display
 ;
EN ;EP; -- main entry point for BDG ILD DEATHS
 ; Assumes BDGTYP,BDGBD,BDGED,BDGTYP are set
 ;
 I $E(IOST,1,2)="P-" D INIT,PRINT Q    ;if printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG ILD DEATHS")
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
 K ^TMP("BDGILD7",$J),^TMP("BDGILD7A",$J)
 ;
 ; loop through discharges by date range and put into sorted array
 NEW DATE,DFN,IEN,END,SORT
 S DATE=BDGBD-.0001,END=BDGED+.24
 F  S DATE=$O(^DGPM("AMV3",DATE)) Q:'DATE  Q:(DATE>END)  D
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DATE,DFN)) Q:'DFN  D
 .. S IEN=0 F  S IEN=$O(^DGPM("AMV3",DATE,DFN,IEN))  Q:'IEN  D
 ... ;
 ... Q:$$GET1^DIQ(405,IEN,.04)'["DEATH"            ;quit if not a death
 ... Q:'$$OKAY^BDGILD5(BDGTYP,.BDGSRT,IEN,DFN)  ;ok to use disch?
 ... ;
 ... S SORT=$$SORT^BDGILD5(BDGTYP,DFN,IEN,$$GET1^DIQ(405,IEN,.14,"I"))
 ... S:SORT="" SORT="??"
 ... S ^TMP("BDGILD7A",$J,SORT,DATE,IEN)=DFN
 ;
 ;
 ; loop thru sorted array and put into display array
 NEW SORT,DATE,IEN,LINE,X,BDGCOV,BDGRR,I
 S SORT=0 F  S SORT=$O(^TMP("BDGILD7A",$J,SORT)) Q:SORT=""  D
 . ;
 . ; display sort heading (unless sorting by date alone)
 . I BDGTYP>1 D
 .. S X="*** "_SORT_" ***"
 .. D SET("",.VALMCNT),SET($$SP(75-$L(X)\2)_X,.VALMCNT)
 . ;
 . S DATE=0 F  S DATE=$O(^TMP("BDGILD7A",$J,SORT,DATE)) Q:'DATE  D
 .. S IEN=0 F  S IEN=$O(^TMP("BDGILD7A",$J,SORT,DATE,IEN)) Q:'IEN  D
 ... ;
 ... ; build display lines
 ... S DFN=^TMP("BDGILD7A",$J,SORT,DATE,IEN)
 ... S ADM=+$$GET1^DIQ(405,IEN,.14,"I")
 ... S LINE=$E($$GET1^DIQ(2,DFN,.01),1,20)                  ;pat name
 ... S LINE=$$PAD(LINE,23)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)   ;chart #
 ... S LINE=$$PAD(LINE,31)_$$NUMDATE^BDGF(DATE)             ;disch date
 ... S LINE=$$PAD(LINE,41)_$J($$GET1^DIQ(405,ADM,201),3)    ;los
 ... S LINE=$$PAD(LINE,51)_$P($$LASTSRVC^BDGF1(ADM,DFN)," ")  ;srv abbrv
 ... S LINE=$$PAD(LINE,61)_$$GET1^DIQ(405,IEN,.04)          ;disch type
 ... D SET(LINE,.VALMCNT)
 ... ;
 ... S LINE=$$SP(10)_"(Attending: "
 ... S LINE=LINE_$E($$LASTPRV^BDGF1(ADM,DFN),1,18)    ;atten prov
 ... S LINE=$$PAD(LINE,45)_"Dx: "_$$GET1^DIQ(405,ADM,.1)_")"     ;adm dx
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
 I '$D(^TMP("BDGILD7",$J)) D SET("No data found",.VALMCNT)
 ;
 K ^TMP("BDGILD7A",$J)
 Q
 ;
 ;
SET(DATA,NUM) ; puts display line into array
 S NUM=NUM+1
 S ^TMP("BDGILD7",$J,NUM,0)=DATA
 Q
 ;         
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGILD7",$J) K BDGBD,BDGED,BDGTYP,BDGSRT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print to paper
 NEW LINE,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 S LINE=0 F  S LINE=$O(^TMP("BDGILD7",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGILD7",$J,LINE,0)
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading when printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?13,"***",$$CONF^BDGF,"***"
 W !,BDGDATE,?28,"Inpatient Deaths by Date",?71,"Page: ",BDGPG
 NEW X S X="Sorted by "_$P($T(TYPE+BDGTYP),";;",2)
 W !,BDGTIME,?(80-$L(X)\2),X
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 W !?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Patient Name",?23,"Chart #",?31,"Death Date",?41,"LOS"
 W ?51,"Serv",?61,"Disch Type"
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
