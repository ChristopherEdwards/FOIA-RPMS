BPC7OGMP ; IHS/OIT/MJL - Interim report rpc memo print 5/22/97 18:40 ;
 ;;1.5;BPC;;MAY 26, 2005
 ;;
 ;;5.2;LAB SERVICE;**187**;Sep 27, 1994
 ;
PRINT(OUTCNT) ;EP from LR7OGMC
 N ACC,AGE,CDT,CMNT,DATA,DOC,FLAG,HIGH,IDT,INTP,LINE,LOW,LRCW,PORDER,PRNTCODE,REFHIGH,REFLOW,SEX,SPEC,SUB,TESTNUM
 N TESTSPEC,THER,THERHIGH,THERLOW,UNITS,VALUE,X,ZERO
 ; the variables AGE, SEX, LRCW, and X are used withing the lab's print codes and ref ranges
 S AGE=$P(^TMP("BPC7OG",$J,"G"),U,4),SEX=$P(^("G"),U,5),LRCW=$P(^("G"),U,6)
 S CDT=0 F  S CDT=$O(^TMP("BPC7OG",$J,"TP",CDT)) Q:CDT=""  D
 .S IDT=9999999-CDT
 .S ZERO=$S($D(^TMP("BPC7OG",$J,"TP",CDT))#2:^(CDT),1:"")
 .I '$P(ZERO,U,3) Q
 .S SPEC=+$P(ZERO,U,5)
 .S DOC=$$NAME(+$P(ZERO,U,10))
 .D SETLINE("",.OUTCNT)
 .D SETLINE("Provider : "_DOC,.OUTCNT)
 .S LINE="  Specimen: "_$P(^LAB(61,SPEC,0),U)_"."
 .S ACC=$P(ZERO,U,6)
 .S LINE=$$SETSTR^VALM1(" "_ACC,LINE,30,1+$L(ACC))
 .D SETLINE(LINE,.OUTCNT)
 .D SETLINE("                              "_$$DD(CDT),.OUTCNT)
 .D SETLINE("     Test name                Result    units      Ref.   range",.OUTCNT)
 .S PORDER=0 F  S PORDER=$O(^TMP("BPC7OG",$J,"TP",CDT,PORDER)) Q:PORDER'>0  S DATA=^(PORDER) D
 ..I $P(DATA,U,7)="" Q
 ..S TESTNUM=+DATA,PRNTCODE=$P(DATA,U,5),SUB=$P(DATA,U,6),FLAG=$P(DATA,U,8),X=$P(DATA,U,7)
 ..S LINE="     "_$S($L($P(DATA,U,2))>20:$P(DATA,U,3),1:$P(DATA,U,2))
 ..S LINE=$$SETSTR^VALM1("",LINE,28,0)
 ..I PRNTCODE="" S LINE=LINE_$J(X,8)
 ..E  S @("VALUE="_PRNTCODE),LINE=LINE_VALUE
 ..S LINE=LINE_" "_FLAG
 ..S TESTSPEC=$S($D(^LAB(60,TESTNUM,1,SPEC,0)):^(0),1:"")
 ..I '$L(TESTSPEC) D SETLINE(LINE,.OUTCNT) Q
 ..S REFLOW=$P(TESTSPEC,U,2),REFHIGH=$P(TESTSPEC,U,3),THERLOW=$P(TESTSPEC,U,11),THERHIGH=$P(TESTSPEC,U,12),UNITS=$P(TESTSPEC,U,7)
 ..S THER=$S($L(THERHIGH):1,$L(THERLOW):1,1:0)
 ..S LOW=$S(THER:THERLOW,1:REFLOW)
 ..S HIGH=$S(THER:THERHIGH,1:REFHIGH)
 ..S @("LOW="_$S($L(LOW):LOW,1:""""""))
 ..S @("HIGH="_$S($L(HIGH):HIGH,1:""""""))
 ..S LINE=$$SETSTR^VALM1("  "_UNITS,LINE,39,2+$L(UNITS))
 ..S LINE=$$SETSTR^VALM1($J(LOW,4)_$S($L(HIGH):" - "_$J(HIGH,4),1:""),LINE,52,4+$S($L(HIGH):7,1:0))
 ..S LINE=$$SETSTR^VALM1($S(THER:"(Ther. range)",1:""),LINE,64,$S(THER:13,1:0))
 ..D SETLINE(LINE,.OUTCNT)
 ..I $O(^TMP("BPC7OG",$J,"TP",CDT,PORDER,0))>0 D
 ...S INTP=0 F  S INTP=+$O(^TMP("BPC7OG",$J,"TP",CDT,PORDER,INTP)) Q:INTP<1  D SETLINE("      Eval: "_^(INTP),.OUTCNT)
 .I $D(^TMP("BPC7OG",$J,"TP",CDT,"C")) D
 ..S LINE="Comment: "
 ..S CMNT=0 F  S CMNT=+$O(^TMP("BPC7OG",$J,"TP",CDT,"C",CMNT)) Q:CMNT<1  S LINE=LINE_^(CMNT) D
 ...D SETLINE(LINE,.OUTCNT)
 ...I $O(^TMP("BPC7OG",$J,"TP",CDT,"C",CMNT)) S LINE="        "
 .D SETLINE("===============================================================================",.OUTCNT)
 Q
 ;
SETLINE(LINE,CNT) ;
 S ^TMP("BPC7OGX",$J,"OUTPUT",CNT)=LINE
 S CNT=CNT+1
 Q
 ;
NAME(X) ;EP $$(#) -> name
 N LRDOC
 D DOC^LRX
 Q LRDOC
 ;
DD(Y) ; $$(date/time) -> date/time format
 D DD^LRX
 Q Y
