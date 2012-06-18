BDGICS2 ; IHS/ANMC/LJF - DAY SURGERY CODING STATUS ;  [ 04/08/2004  4:02 PM ]
 ;;5.3;PIMS;**1005,1010**;MAY 28, 2004
 ;IHS/OIT/LJF 02/16/2006 PATCH 1005 fixed logic for determining if uncoded
 ;cmi/anch/maw 10/20/2008 PATCH 1010 changed export date field from .14 to 1106
 ;
 NEW BDGBM,BDGEM
 S BDGBM=$$READ^BDGF("DO^::EP","Select Beginning Month") Q:BDGBM<1
 S BDGEM=$$READ^BDGF("DO^::EP","Select Ending Month") Q:BDGEM<1
 S BDGBM=$E(BDGBM,1,5)_"00",BDGEM=$E(BDGEM,1,5)_"31.24"
 ;
 D ZIS^BDGF("PQ","EN^BDGICS2","DS CODING STATUS","BDGBM;BDGEM")
 Q
 ;
 ;
EN ; -- main entry point for BDG IC CODE STATUS DS
 NEW VALMCNT
 I $E(IOST,1,2)="P-" S BDGPRT=1 D INIT,PRINT Q   ;if printing to paper
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC CODE STATUS DS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(20)_$$CONF^BDGF
 S X=$$GET1^DIQ(4,DUZ(2),.01),VALMHDR(2)=$$SP(79-$L(X)\2)_X
 S X=$$RANGE^BDGF(BDGBM,(BDGEM\1))
 S VALMHDR(3)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 I '$G(BDGPRT) D MSG^BDGF("Please wait while I compile the list...",2,0)
 NEW DATE,TODAY,DFN,IEN,COUNT,VST,VH,MONTH,SUB,ADM,X,LINE,DSC,Y
 K ^TMP("BDGICS2",$J),^TMP("BDGICS2A",$J)
 S VALMCNT=0
 ;
 ; loop through day surgery visits for date range
 S DATE=BDGBM,TODAY=DT+.24
 F  S DATE=$O(^AUPNVSIT("B",DATE)) Q:('DATE)!(DATE>BDGEM)!(DATE>TODAY)  D
 . S MONTH=$E(DATE,1,5)
 . S VST=0 F  S VST=$O(^AUPNVSIT("B",DATE,VST)) Q:'VST  D
 .. ;
 .. Q:$P(^AUPNVSIT(VST,0),U,7)'="S"     ;day surgery visits only
 .. Q:$P(^AUPNVSIT(VST,0),U,11)=1       ;deleted
 .. Q:$P(^AUPNVSIT(VST,0),U,6)'=DUZ(2)  ;different location
 .. ;
 .. ;increment # day surgeries per month
 .. S COUNT(MONTH,"DS")=$G(COUNT(MONTH,"DS"))+1
 .. ;
 .. ; check for errors if running VA Surgery
 .. I $O(^SRF("ADS",0)) D
 ... S SRN=$O(^SRF("ADS",VST,0))
 ... I 'SRN D ERR("NO Surgery entry for visit",VST,DATE) Q
 ... I $$GET1^DIQ(130,SRN,.011,"I")'["DS" D ERR("Visit linked to "_$$GET1^DIQ(130,SRN,.011),VST,DATE) Q
 ... S SRRS=$$GET1^DIQ(130,SRN,9999999.06,"I")  ;ds release status
 ... I SRRS="AD" D ERR("Surgery says unplanned admit",VST,DATE) Q
 ... I (SRRS="NS")!(SRRS="CA") D ERR("Surgery says "_$S(SRRS="NS":"No-show",1:"Cancelled"),VST,DATE) Q
 .. ;
 .. ; check if uncoded
 .. S X=$O(^AUPNVPOV("AD",VST,0)),Y=$O(^AUPNVPRV("AD",VST,0))
 .. ;I (X=""),(Y="") D UNCODED(DATE,VST) Q
 .. I (X="")!(Y="") D UNCODED(DATE,VST) Q   ;IHS/OIT/LJF 02/16/2006 PATCH 1005
 .. ;
 .. ; check if exported
 .. S COUNT(MONTH,"COD")=$G(COUNT(MONTH,"COD"))+1
 .. ;I $$GET1^DIQ(9000010,VST,.14)]"" S COUNT(MONTH,"EXP")=$G(COUNT(MONTH,"EXP"))+1  ;cmi/maw 10/20/2008 PATCH 1010 orig line
 .. I $$GET1^DIQ(9000010,VST,1106)]"" S COUNT(MONTH,"EXP")=$G(COUNT(MONTH,"EXP"))+1  ;cmi/maw 10/20/2008 PATCH 1010 new export date field
 ;
 ; build display array
 ;    monthly counts heading
 S LINE=$$PAD($$PAD("Month/Year",13)_"# Surgeries",26)
 S LINE=$$PAD(LINE_"# Coded",36)
 S LINE=$$PAD($$PAD(LINE_"# Not-Coded",50)_"# Exported",62)
 S LINE=LINE_"# Errors" D SET(LINE,.VALMCNT)
 ;    monthly counts
 S MON=0 F  S MON=$O(COUNT(MON)) Q:'MON  D
 . S LINE=$$PAD($$FMTE^XLFDT(MON_"00"),15)
 . F SUB="DS","COD","UNC","EXP","ERR" D
 .. S LINE=LINE_$J(+$G(COUNT(MON,SUB)),4)_$$SP(8)
 . D SET(LINE,.VALMCNT)
 ;
 D SET($$REPEAT^XLFSTR("=",79),.VALMCNT)
 S LINE=$$SP(15)
 F SUB="DS","COD","UNC","EXP","ERR" D
 . S TOTAL=0,MON=0
 . F  S MON=$O(COUNT(MON)) Q:'MON  S TOTAL=$G(TOTAL)+$G(COUNT(MON,SUB))
 . S LINE=LINE_$J(TOTAL,4)_$$SP(8)
 D SET(LINE,.VALMCNT)
 D SET("",.VALMCNT)
 ;
 ; list uncoded charts
 ;   if any uncoded charts, print heading
 I $D(^TMP("BDGICS2A",$J,"U")) D
 . S LINE=$$PAD($$PAD("Surgery Date",15)_"Patient Name",45)
 . S LINE=$$PAD(LINE_"Chart #",58)_"Srv"
 . S LINE=$$PAD(LINE,64)_"Insurance"
 . D SET("",.VALMCNT),SET(LINE,.VALMCNT)
 ;
 S DATE=0 F  S DATE=$O(^TMP("BDGICS2A",$J,"U",DATE)) Q:'DATE  D
 . S VST=0 F  S VST=$O(^TMP("BDGICS2A",$J,"U",DATE,VST)) Q:'VST  D
 .. ;
 .. S SRN=+$O(^SRF("ADS",VST,0))                          ;surgery entry
 .. S DFN=$$GET1^DIQ(9000010,VST,.05,"I")                 ;pat ien
 .. ;
 .. S LINE=$$PAD($$NUMDATE^BDGF(DATE\1),15)               ;surgery date
 .. S LINE=$$PAD(LINE_$E($$GET1^DIQ(2,DFN,.01),1,22),45)  ;name
 .. S LINE=$$PAD(LINE_$J($$HRCN^BDGF2(DFN,DUZ(2)),6),58)
 .. S LINE=LINE_$E($$GET1^DIQ(130,SRN,.04),1,3)           ;sur specialty
 .. ;
 .. ; add insurance coverage
 .. S LINE=$$PAD(LINE,64)_$$INSUR^BDGF2(DFN,DATE)
 .. D SET(LINE,.VALMCNT)
 ;
 ; add error charts to display listing
 ;     if any errors, print heading
 I $D(^TMP("BDGICS2A",$J,"E")) D
 . I $E(IOST,1,2)="P-" D SET("@@@",.VALMCNT)   ;mark errors for paper
 . S LINE=$$PAD("Surgery Date",16)_"Patient Name"
 . S LINE=$$PAD($$PAD(LINE,38)_"Chart #",48)_"Error Message"
 . D SET("",.VALMCNT),SET(LINE,.VALMCNT)
 ;
 S DATE=0 F  S DATE=$O(^TMP("BDGICS2A",$J,"E",DATE)) Q:'DATE  D
 . S VST=0 F  S VST=$O(^TMP("BDGICS2A",$J,"E",DATE,VST)) Q:'VST  D
 .. ;
 .. S DFN=$$GET1^DIQ(9000010,VST,.05,"I")                    ;pat ien
 .. S LINE=$$PAD($$NUMDATE^BDGF(DATE\1),16)                  ;sur date
 .. S LINE=$$PAD(LINE_$E($$GET1^DIQ(2,DFN,.01),1,18),38)     ;name
 .. S LINE=LINE_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)               ;chart #
 .. S LINE=$$PAD(LINE,48)_^TMP("BDGICS2A",$J,"E",DATE,VST)   ;err msg
 .. D SET(LINE,.VALMCNT)
 ;
 I '$D(^TMP("BDGICS2",$J)) D SET("NO DATA FOUND",.VALMCNT)
 K ^TMP("BDGICS2A",$J)
 Q
 ;
ERR(MSG,VST,DATE) ; increment error count and save for listing
 NEW MON
 S MON=$E(DATE,1,5)
 S COUNT(MON,"ERR")=$G(COUNT(MON,"ERR"))+1
 S ^TMP("BDGICS2A",$J,"E",DATE,VST)=MSG
 Q
 ;
UNCODED(DATE,VST) ; save uncoded visits by discharge date
 NEW MON
 S MON=$E(DATE,1,5)
 S COUNT(MON,"UNC")=$G(COUNT(MON,"UNC"))+1
 S ^TMP("BDGICS2A",$J,"U",DATE,VST)=""
 Q
 ;
SET(DATA,NUM) ; put data line into display array
 S NUM=NUM+1
 S ^TMP("BDGICS2",$J,NUM,0)=DATA
 Q
 ;
PRINT ; print report to paper
 NEW BDGL,FIRST
 U IO S FIRST=1 D HDG
 S BDGL=0 F  S BDGL=$O(^TMP("BDGICS2",$J,BDGL)) Q:'BDGL  D
 . I ^TMP("BDGICS2",$J,BDGL,0)="@@@" S FIRST=1 Q  ;beginning of errors
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGICS2",$J,BDGL,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading when printing to paper
 W @IOF W !?20,"DAY SURGERY CODING STATUS REPORT"
 D HDR F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 I FIRST W !,$$REPEAT^XLFSTR("=",80),! S FIRST=0 Q
 W !,"Surgery Date",?24,"Patient Name",?44,"Chart #"
 W !?54,"Serv",?60,"Insurance",!,$$REPEAT^XLFSTR("=",80),!
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGICS2",$J) K BDGPRT
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
