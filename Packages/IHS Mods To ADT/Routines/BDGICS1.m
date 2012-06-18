BDGICS1 ; IHS/ANMC/LJF - INPATIENT CODING STATUS ;  [ 04/08/2004  4:02 PM ]
 ;;5.3;PIMS;**1010**;APR 26, 2002
 ;
 ;
 ;cmi/anch/maw 10/20/2008 PATCH 1010 changed export date field from .14 to 1106
 ;
 NEW BDGBM,BDGEM
 S BDGBM=$$READ^BDGF("DO^::EP","Select Beginning Month") Q:BDGBM<1
 S BDGEM=$$READ^BDGF("DO^::EP","Select Ending Month") Q:BDGEM<1
 S BDGBM=$E(BDGBM,1,5)_"00",BDGEM=$E(BDGEM,1,5)_"31.24"
 ;
 D ZIS^BDGF("PQ","EN^BDGICS1","INPT CODING STATUS","BDGBM;BDGEM")
 Q
 ;
 ;
EN ; -- main entry point for BDG IC CODE STATUS INPT
 NEW VALMCNT
 I $E(IOST,1,2)="P-" S BDGPRT=1 D INIT,PRINT Q   ;if printing to paper
 D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC CODE STATUS INPT")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(20)_$$CONF^BDGF
 S X=$$GET1^DIQ(4,DUZ(2),.01),VALMHDR(2)=$$SP(79-$L(X)\2)_X
 S X=$$RANGE^BDGF(BDGBM,($E(BDGEM,1,5)_"00"))
 S VALMHDR(3)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 I '$G(BDGPRT) D MSG^BDGF("Please wait while I compile the list...",2,0)
 NEW DATE,TODAY,DFN,IEN,COUNT,VST,VH,MONTH,SUB,ADM,X,LINE,DSC,Y
 K ^TMP("BDGICS1",$J),^TMP("BDGICS1A",$J)
 S VALMCNT=0
 ;
 ; loop through discharges for date range
 S DATE=BDGBM,TODAY=DT+.24
 F  S DATE=$O(^DGPM("AMV3",DATE)) Q:('DATE)!(DATE>BDGEM)!(DATE>TODAY)  D
 . S MONTH=$E(DATE,1,5)
 . S DFN=0 F  S DFN=$O(^DGPM("AMV3",DATE,DFN)) Q:'DFN  D
 .. S IEN=0 F  S IEN=$O(^DGPM("AMV3",DATE,DFN,IEN)) Q:'IEN  D
 ... ;
 ... S ADM=$$GET1^DIQ(405,IEN,.14,"I")                     ;adm ien
 ... I $$LASTSRVN^BDGF1(ADM,DFN)["OBSERVATION" Q           ;inpt only
 ... ;
 ... ;increment # discharged per month
 ... S COUNT(MONTH,"DSC")=$G(COUNT(MONTH,"DSC"))+1
 ... ;
 ... ; check for errors
 ... S VST=$$GET1^DIQ(405,+ADM,.27,"I")                   ;visit ien
 ... I 'VST D ERR("No Visit linked to ADT Admission",IEN,DATE) Q
 ... I '$D(^AUPNVSIT(VST,0)) D ERR("Linked Visit doesn't exist.",IEN) Q
 ... I $$GET1^DIQ(9000010,VST,.11)="DELETED" D  Q
 .... D ERR("ADT Admission linked to Deleted visit.",IEN,DATE)
 ... ;
 ... S VH=$O(^AUPNVINP("AD",VST,0))      ;v hosp ien
 ... I 'VH D ERR("No V Hospitalization for Visit",IEN,DATE) Q
 ... I '$D(^AUPNVINP(VH,0)) D ERR("No V Hospitalization for Visit.",IEN,DATE) Q
 ... ; check if uncoded
 ... I $$GET1^DIQ(9000010.02,VH,.15)="NO" D UNCODED(DATE,IEN) Q
 ... ;
 ... ; check if exported
 ... S COUNT(MONTH,"COD")=$G(COUNT(MONTH,"COD"))+1
 ... ;I $$GET1^DIQ(9000010,VST,.14)]"" S COUNT(MONTH,"EXP")=$G(COUNT(MONTH,"EXP"))+1  ;cmi/maw 10/20/2008 orig line
 ... I $$GET1^DIQ(9000010,VST,1106)]"" S COUNT(MONTH,"EXP")=$G(COUNT(MONTH,"EXP"))+1  ;cmi/maw 10/20/2008 PATCH 1010 modified for new data export field
 ;
 ; build display array
 ;    monthly counts heading
 S LINE=$$PAD($$PAD("Month/Year",15)_"# Disch",26)
 S LINE=$$PAD($$PAD(LINE_"# Coded",36)_"# Not-Coded",50)
 S LINE=$$PAD(LINE_"# Exported",63)_"# Errors"
 D SET(LINE,.VALMCNT)
 ;    monthly counts
 S MON=0 F  S MON=$O(COUNT(MON)) Q:'MON  D
 . S LINE=$$PAD($$FMTE^XLFDT(MON_"00"),15)
 . F SUB="DSC","COD","UNC","EXP","ERR" D
 .. S LINE=LINE_$J(+$G(COUNT(MON,SUB)),4)_$$SP(8)
 . D SET(LINE,.VALMCNT)
 ;
 ;IHS/ITSC/LJF 4/8/2004 add totals for each column
 D SET($$REPEAT^XLFSTR("=",79),.VALMCNT)
 S LINE=$$SP(15)
 F SUB="DSC","COD","UNC","EXP","ERR" D
 . S TOTAL=0,MON=0
 . F  S MON=$O(COUNT(MON)) Q:'MON  S TOTAL=$G(TOTAL)+$G(COUNT(MON,SUB))
 . S LINE=LINE_$J(TOTAL,4)_$$SP(8)
 D SET(LINE,.VALMCNT)
 ;IHS/ITSC/LJF 4/8/2004 end of new code
 ;
 D SET("",.VALMCNT)
 ;
 ; list uncoded charts
 ;   if any uncoded charts, print heading
 I $D(^TMP("BDGICS1A",$J,"U")) D
 . S LINE=$$PAD("Admit & Dscharge Dates",24)
 . S LINE=$$PAD($$PAD(LINE_"Patient Name",48)_"Chart #",58)
 . S LINE=$$PAD(LINE_"Srv",64)_"Insurance"
 . D SET("",.VALMCNT),SET(LINE,.VALMCNT)
 ;
 S DSC=0 F  S DSC=$O(^TMP("BDGICS1A",$J,"U",DSC)) Q:'DSC  D
 . S IEN=0 F  S IEN=$O(^TMP("BDGICS1A",$J,"U",DSC,IEN)) Q:'IEN  D
 .. ;
 .. S ADM=$$GET1^DIQ(405,IEN,.14,"I")                        ;adm ien
 .. S DFN=$$GET1^DIQ(405,IEN,.03,"I")                        ;pat ien
 .. ;
 .. S LINE=$$PAD($$NUMDATE^BDGF(+$G(^DGPM(ADM,0))\1),12)  ;adm date
 .. S LINE=$$PAD(LINE_$$NUMDATE^BDGF(DSC\1),24)           ;dsc date
 .. S LINE=$$PAD(LINE_$E($$GET1^DIQ(405,IEN,.03),1,22),48)   ;name
 .. S LINE=LINE_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)
 .. S LINE=$$PAD(LINE,58)_$P($$LASTSRVC^BDGF1(ADM,DFN)," ")  ;srv
 .. ;
 .. ; add insurance coverage
 .. S LINE=$$PAD(LINE,64)_$$INSUR^BDGF2(DFN,+^DGPM(ADM,0))
 .. D SET(LINE,.VALMCNT)
 ;
 ; add error charts to display listing
 ;     if any errors, print heading
 I $D(^TMP("BDGICS1A",$J,"E")) D
 . I $E(IOST,1,2)="P-" D SET("@@@",.VALMCNT)   ;mark errors for paper
 . S LINE=$$PAD("Discharge Date",16)_"Patient Name"
 . S LINE=$$PAD($$PAD(LINE,38)_"Chart #",48)_"Error Message"
 . D SET("",.VALMCNT),SET(LINE,.VALMCNT)
 ;
 S DSC=0 F  S DSC=$O(^TMP("BDGICS1A",$J,"E",DSC)) Q:'DSC  D
 . S IEN=0 F  S IEN=$O(^TMP("BDGICS1A",$J,"E",DSC,IEN)) Q:'IEN  D
 .. ;
 .. S DFN=$$GET1^DIQ(405,IEN,.03,"I")                        ;pat ien
 .. S LINE=$$PAD($$NUMDATE^BDGF(DSC\1),16)                   ;dsc date
 .. S LINE=$$PAD(LINE_$E($$GET1^DIQ(405,IEN,.03),1,18),38)   ;name
 .. S LINE=LINE_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)               ;chart #
 .. S LINE=$$PAD(LINE,48)_^TMP("BDGICS1A",$J,"E",DSC,IEN)    ;err msg
 .. D SET(LINE,.VALMCNT)
 ;
 I '$D(^TMP("BDGICS1",$J)) D SET("NO DATA FOUND",.VALMCNT)
 K ^TMP("BDGICS1A",$J)
 Q
 ;
ERR(MSG,IEN,DATE) ; increment error count and save for listing
 NEW MON
 S MON=$E(DATE,1,5)
 S COUNT(MON,"ERR")=$G(COUNT(MON,"ERR"))+1
 S ^TMP("BDGICS1A",$J,"E",DATE,IEN)=MSG
 Q
 ;
UNCODED(DATE,IEN) ; save uncoded visits by discharge date
 NEW MON
 S MON=$E(DATE,1,5)
 S COUNT(MON,"UNC")=$G(COUNT(MON,"UNC"))+1
 S ^TMP("BDGICS1A",$J,"U",DATE,IEN)=""
 Q
 ;
SET(DATA,NUM) ; put data line into display array
 S NUM=NUM+1
 S ^TMP("BDGICS1",$J,NUM,0)=DATA
 Q
 ;
PRINT ; print report to paper
 NEW BDGL,FIRST
 U IO S FIRST=1 D HDG
 S BDGL=0 F  S BDGL=$O(^TMP("BDGICS1",$J,BDGL)) Q:'BDGL  D
 . I ^TMP("BDGICS1",$J,BDGL,0)="@@@" S FIRST=1 Q  ;beginning of errors
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGICS1",$J,BDGL,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading when printing to paper
 ;W @IOF W !?20,"INPATIENT CODING STATUS REPORT"
 I 'FIRST W @IOF                           ;IHS/ITSC/LJF 1/15/2004
 W !?20,"INPATIENT CODING STATUS REPORT"   ;IHS/ITSC/LJF 1/15/2004
 D HDR F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 I FIRST W !,$$REPEAT^XLFSTR("=",80),! S FIRST=0 Q
 W !,"Discharge/Admit Dates",?24,"Patient Name",?44,"Chart #"
 W !?54,"Serv",?60,"Insurance",!,$$REPEAT^XLFSTR("=",80),!
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGICS1",$J) K BDGPRT
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
