BDGICR41 ; IHS/ANMC/LJF - CODED A SHEET REPORTS ; 
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 12/21/2005 PATCH 1005 fixed code in case primary provider not first entered
 ;
 NEW BDGED,BDGBD
 S BDGBD=$$READ^BDGF("DO^::E","Select BEGINNING Discharge Date")
 Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::E","Select ENDING Discharge Date")
 Q:BDGED<1
 D ZIS^BDGF("PQ","EN^BDGICR41","CODED A SHEETS","BDGBD;BDGED")
 Q
 ;
EN ; -- main entry point for BDG IC DATE CODED
 NEW VALMCNT
 I IOST'["C-" D GATHER(BDGBD,BDGED),PRINT Q
 D TERM^VALM0
 D EN^VALM("BDG IC DATE CODED")
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
 K ^TMP("BDGICR41",$J) K BDGLN
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GATHER(BDGBD,BDGED) ; -- create display array
 NEW DATE,VH,VST,DATA,DFN,NAME,BDGTOT,LINE,VDT,BDGSTOT
 K ^TMP("BDGICR41",$J),^TMP("BDGICR41A",$J)
 ;
 ; loop through hospitalizations by date & sort by service and date
 S DATE=BDGBD-.0001,BDGLN=0
 F  S DATE=$O(^AUPNVINP("B",DATE)) Q:'DATE!(DATE>(BDGED+.24))  D
 . S VH=0 F  S VH=$O(^AUPNVINP("B",DATE,VH)) Q:'VH  D
 .. ;
 .. Q:'$D(^AUPNVINP(VH,0))  S VST=$P(^(0),U,3)
 .. Q:$P(^AUPNVINP(VH,0),U,15)'=""         ;check coded flag
 .. Q:'$D(^AUPNVSIT(VST,0))  S DATA=^(0)
 .. Q:$P(DATA,U,11)'=""                    ;screen out deleted visits
 .. Q:$P(DATA,U,6)'=DUZ(2)                 ;screen out other facilities
 .. S DFN=$P(DATA,U,5),SRV=$$GET1^DIQ(9000010.02,VH,.05)
 .. S ^TMP("BDGICR41A",$J,SRV,DATE,VH)=VST_U_DFN
 ;
 ; now loop through sorted list and put into display array
 S SRV=0,BDGTOT=0
 F  S SRV=$O(^TMP("BDGICR41A",$J,SRV)) Q:SRV=""  D
 . ;
 . D SET("",.BDGLN),SET($$SP(5)_"SERVICE: "_SRV,.BDGLN) K BDGSTOT
 . ;
 . S BDGD=0 F  S BDGD=$O(^TMP("BDGICR41A",$J,SRV,BDGD)) Q:BDGD=""  D
 .. S VH=0 F  S VH=$O(^TMP("BDGICR41A",$J,SRV,BDGD,VH)) Q:'VH  D
 ... ;
 ... S DATA=^TMP("BDGICR41A",$J,SRV,BDGD,VH)
 ... S VST=+DATA,DFN=$P(DATA,U,2),BDGTOT=BDGTOT+1
 ... S LINE=" "_$E($$GET1^DIQ(2,DFN,.01),1,20)             ;name
 ... S LINE=$$PAD(LINE,26)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)  ;chart #
 ... S LINE=$$PAD(LINE,40)_$$DATE(BDGD)                    ;disch date
 ... S CODE=$$CODE(VST),DIFF=$$DAYS(BDGD,CODE)
 ... S LINE=$$PAD(LINE,50)_$$DATE(CODE)                    ;date coded
 ... S LINE=$$PAD(LINE,60)_$J(DIFF,3)                      ;days to code
 ... S PROV=$$PPROV(VST)                                   ;prim prov
 ... S LINE=$$PAD(LINE,67)_$E(PROV,1,13)
 ... D SET(LINE,.BDGLN),COUNT(DIFF)
 . ;
 . ; at end of service listing
 . D SET("",.BDGLN)
 . D SET($$SP(22)_"# Coded    Low    High   Average",.BDGLN)
 . S LINE="Totals for Service: "_$J($P(BDGSTOT,U),4)
 . S LINE=$$PAD(LINE,33)_$J($P(BDGSTOT,U,2),3)
 . S LINE=$$PAD(LINE,40)_$J($P(BDGSTOT,U,3),3)
 . S X=$P(BDGSTOT,U,4)/$P(BDGSTOT,U)
 . S LINE=$$PAD(LINE,47)_$J(X,5,2) D SET(LINE,.BDGLN)
 ;
 S LINE=$$SP(5)_"Total Coded: "_BDGTOT
 D SET("",.BDGLN),SET(LINE,.BDGLN)
 ;
 K ^TMP("BDGICR41A",$J)
 Q
 ;
SET(LINE,BDGLN) ; -- sets ^tmp
 S BDGLN=BDGLN+1
 S ^TMP("BDGICR41",$J,BDGLN,0)=LINE
 Q
 ;
PRINT ; -- print lists to paper
 NEW BDGX,BDGL,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 S BDGL=0 F  S BDGL=$O(^TMP("BDGICR41",$J,BDGL)) Q:'BDGL  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGICR41",$J,BDGL,0)
 ;
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; -- heading when printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?16,$$CONF^BDGF
 W !,BDGDATE,?25,"CODED A SHEETS WITH DATE CODED",?71,"Page: ",BDGPG
 NEW X S X=$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 W !,BDGTIME,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Patient Name",?27,"Chart #",?40,"Dischrgd  Coded",?61,"Days"
 W ?67,"Provider"
 W !,$$REPEAT^XLFSTR("=",80)
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
 ;
PPROV(VST) ; -- returns name of primary provider for visit
 NEW X,PROV
 ;S X=0 F  S X=$O(^AUPNVPRV("AD",VST,0)) Q:'X!($G(PROV)]"")  D
 S X=0 F  S X=$O(^AUPNVPRV("AD",VST,X)) Q:'X!($G(PROV)]"")  D     ;IHS/OIT/LJF 12/21/2005 PATCH 1005
 . Q:$$GET1^DIQ(9000010.06,X,.04,"I")'="P"
 . S PROV=$$GET1^DIQ(9000010.06,X,.01)
 Q $G(PROV)
 ;
CODE(VST) ; -- returns date coded
 NEW IEN,PRV,CODE,DATE
 ; first look in IC file
 S IEN=$O(^BDGIC("AV",VST,0))
 I IEN Q $$GET1^DIQ(9009016.1,IEN,.13,"I")
 ;
 ; then check if coder entered as provider on visit
 S PRV=0 F  S PRV=$O(^AUPNVPRV("AD",VST,PRV)) Q:'PRV!($G(DATE))  D
 . S CODE=$$GET1^DIQ(9000010.06,PRV,.019) Q:$E(CODE,2,3)'=88
 . S DATE=$$GET1^DIQ(9000010.06,PRV,1201,"I")
 Q $G(DATE)
 ;
DAYS(DSCH,CODE) ; -- returns difference between dsch and coding
 I CODE="" Q "??"
 NEW X1,X2,X S X1=CODE,X2=DSCH D ^%DTC Q X
 ;
COUNT(DIFF) ; -- sets array to hold service counts
 I '$D(BDGSTOT) S BDGSTOT=1_U_DIFF_U_DIFF_U_DIFF Q
 S $P(BDGSTOT,U)=$P(BDGSTOT,U)+1  ;increment count
 I DIFF<$P(BDGSTOT,U,2) S $P(BDGSTOT,U,2)=DIFF
 I DIFF>$P(BDGSTOT,U,3) S $P(BDGSTOT,U,3)=DIFF
 S $P(BDGSTOT,U,4)=$P(BDGSTOT,U,4)+DIFF
 Q
