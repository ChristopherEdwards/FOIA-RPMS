BDGICR4 ; IHS/ANMC/LJF - CODED A SHEET REPORTS ; 
 ;;5.3;PIMS;**1009,1010**;APR 26, 2002
 ;
 ;cmi/anch/maw 02/19/2009 PATCH 1009 requirement 67 in GATHER
 ;
 D ^XBCLS
 D MSG^BDGF($$SP(20)_"CODED A SHEET REPORTS",2,2)
 NEW Y S Y=$$READ^BDGF("SO^1:WITH DATE CODED;2:WITH DATE EXPORTED","Select CODED A SHEET REPORT") Q:'Y  I +Y=1 D ^BDGICR41 Q
 ;
 NEW BDGED,BDGBD
 S BDGBD=$$READ^BDGF("DO^::E","Select BEGINNING Discharge Date")
 Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::E","Select ENDING Discharge Date")
 Q:BDGED<1
 D ZIS^BDGF("PQ","EN^BDGICR4","EXPORTED A SHEETS","BDGBD;BDGED")
 Q
 ;
EN ;EP; -- main entry point for BDG IC DATE EXPORTED
 NEW VALMCNT
 I IOST'["C-" D GATHER(BDGBD,BDGED),PRINT Q
 D TERM^VALM0
 D EN^VALM("BDG IC DATE EXPORTED")
 Q
 ;
HDR ;EP; -- header code
 S VALMHDR(1)=$$SP(20)_$$CONF^BDGF
 Q
 ;
INIT ;EP; -- init variables and list array
 NEW BDGLN
 D MSG^BDGF("Building/Updating Display. . .Please wait.",2,0)
 D GATHER(BDGBD,BDGED)
 S VALMCNT=BDGLN
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("BDGICR4",$J) K BDGLN
 Q
 ;
EXIT2 ;EP; -- exit code for patient listing
 K VALMCNT Q
 ;
EXPND ; -- expand code
 Q
 ;
GATHER(BDGBD,BDGED) ; -- create display array
 NEW DATE,VH,VST,DATA,DFN,NAME,BDGTOT,BDGETOT,LINE,VDT
 K ^TMP("BDGICR4",$J),^TMP("BDGICR4A",$J)
 ;
 ; loop through hospitalizations by date and sort by date then name
 S DATE=BDGBD-.0001,BDGLN=0
 F  S DATE=$O(^AUPNVINP("B",DATE)) Q:'DATE!(DATE>(BDGED+.24))  D
 . S VH=0 F  S VH=$O(^AUPNVINP("B",DATE,VH)) Q:'VH  D
 .. ;
 .. Q:'$D(^AUPNVINP(VH,0))  S VST=$P(^(0),U,3)
 .. Q:$P(^AUPNVINP(VH,0),U,15)'=""        ;check coded flag
 .. Q:'$D(^AUPNVSIT(VST,0))  S DATA=^(0)
 .. Q:$P(DATA,U,11)'=""                   ;screen out deleted visits
 .. Q:$P(DATA,U,6)'=DUZ(2)                ;screen out other facilities
 .. S DFN=$P(DATA,U,5),NAME=$P(^DPT(DFN,0),U),VDT=$P(DATA,U)
 .. S ^TMP("BDGICR4A",$J,$P(DATE,"."),NAME,DFN,VH)=VST_U_VDT
 ;
 ; loop through sorted list and put into display array
 S DATE=0,(BDGTOT,BDGETOT)=0
 F  S DATE=$O(^TMP("BDGICR4A",$J,DATE)) Q:'DATE  D
 . ;
 . D SET("",.BDGLN),SET($$SP(20)_"DISCHARGED ON: "_$$DATE(DATE),.BDGLN)
 . ;
 . S NAME=0 F  S NAME=$O(^TMP("BDGICR4A",$J,DATE,NAME)) Q:NAME=""  D
 .. S DFN=0 F  S DFN=$O(^TMP("BDGICR4A",$J,DATE,NAME,DFN)) Q:'DFN  D
 ... S VH=0 F  S VH=$O(^TMP("BDGICR4A",$J,DATE,NAME,DFN,VH)) Q:'VH  D
 .... ;
 .... S DATA=^TMP("BDGICR4A",$J,DATE,NAME,DFN,VH)
 .... S VST=+DATA,VDT=$P(DATA,U,2),BDGTOT=BDGTOT+1
 .... S HRCN=$$HRCN^BDGF2(DFN,DUZ(2))
 .... S LINE=" "_$$PAD($E(NAME,1,20),26)_$J(HRCN,6)   ;name & chart #
 .... S LINE=$$PAD(LINE,40)_$$DATE(VDT) ;admit date
 .... S LINE=$$PAD(LINE,52)_$$DATE($$GET1^DIQ(9000010,VST,.13,"I")) ;mod
 .... ;S Y=$$GET1^DIQ(9000010,VST,.14,"I") I Y]"" S BDGETOT=BDGETOT+1  ;cmi/maw 2/19/2008 orig line PATCH 1009 requirement 67
 .... S Y=$$GET1^DIQ(9000010,VST,1106,"I") I Y]"" S BDGETOT=BDGETOT+1  ;cmi/maw 2/19/2008 PATCH 1008 requirement 67
 .... I Y S LINE=$$PAD(LINE,64)_$$DATE(Y)  ;date exported
 .... D SET(LINE,.BDGLN)
 ;
 S LINE=$$SP(5)_"Total Coded: "_BDGTOT
 S LINE=$$PAD(LINE,40)_"Total Exported: "_BDGETOT
 D SET("",.BDGLN),SET(LINE,.BDGLN)
 ;
 K ^TMP("BDGICR4A",$J)
 Q
 ;
SET(LINE,BDGLN) ; -- sets ^tmp
 S BDGLN=BDGLN+1
 S ^TMP("BDGICR4",$J,BDGLN,0)=LINE
 Q
 ;
 ;
PRINT ; -- print lists to paper
 NEW BDGX,BDGL,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 S BDGL=0 F  S BDGL=$O(^TMP("BDGICR4",$J,BDGL)) Q:'BDGL  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGICR4",$J,BDGL,0)
 ;
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading when printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?16,$$CONF^BDGF
 W !,BDGDATE,?25,"CODED A SHEETS WITH EXPORT DATE",?71,"Page: ",BDGPG
 NEW X S X=$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Patient Name",?27,"Chart #",?40,"Admitted",?52,"Modified"
 W ?64,"Exported",!,$$REPEAT^XLFSTR("=",80)
 Q
 ;
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
 ;
DATE(X) ; -- returns date in readable format
 NEW Y S Y=$$FMTE^XLFDT(X,"2DF")
 Q $TR(Y," ","0")
