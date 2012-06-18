LR7OGMP ;VA/DALOI/STAFF- Interim report rpc memo print ;JUL 06, 2010 3:14 PM
 ;;5.2;LAB SERVICE;**187,246,282,286,344,1027**;NOV 01, 1997
 ;
PRINT(OUTCNT) ; from LR7OGMC
 N ACC,AGE,CDT,CMNT,DATA,DOC,FLAG,HIGH,IDT,INTP,LINE,LOW,LRCW,LRX,PORDER,PRNTCODE,RANGE,REFHIGH,REFLOW,SEX,SITE,SPEC,SUB,TESTNUM
 N TESTSPEC,THER,THERHIGH,THERLOW,UNITS,VALUE,X,ZERO
 NEW LRPLS,TIDT,SITECNT           ; IHS/OIT/MKK - LR*5.2*1027
 ; the variables AGE, SEX, LRCW, and X are used withing the lab's print codes and ref ranges
 S AGE=$P(^TMP("LR7OG",$J,"G"),U,4),SEX=$P(^("G"),U,5),LRCW=$P(^("G"),U,6)
 S CDT=0
 S SITECNT=0                      ; IHS/OIT/MKK - LR*5.*1027
 F  S CDT=$O(^TMP("LR7OG",$J,"TP",CDT)) Q:CDT=""  D
 . S IDT=9999999-CDT
 . S ZERO=$S($D(^TMP("LR7OG",$J,"TP",CDT))#2:^(CDT),1:"")
 . I '$P(ZERO,U,3) Q
 . S SPEC=+$P(ZERO,U,5)
 . S DOC=$$NAME(+$P(ZERO,U,10))
 . D SETLINE("",.OUTCNT)
 . D SETLINE("Provider : "_DOC,.OUTCNT)
 . S LINE="  Specimen: "_$P(^LAB(61,SPEC,0),U)_"."
 . S ACC=$P(ZERO,U,6)
 . S LINE=$$SETSTR^VALM1(" "_ACC,LINE,30,1+$L(ACC))
 . D SETLINE(LINE,.OUTCNT)
 . ; D SETLINE("                              "_$$DD(CDT),.OUTCNT)
 . ; D SETLINE("     Test name                Result    units      Ref.   range   Site Code",.OUTCNT)
 . ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1027
 . D SETLINE("  Collect Date/Time: "_$$DD(CDT),.OUTCNT)
 . D SETLINE(" ",.OUTCNT)
 . D SETLINE("                          Res",.OUTCNT)
 . D SETLINE("Test name          Result Flg units        Ref.   range     Site  Result Dt/Time",.OUTCNT)
 . ; ----- END IHS/OIT/MKK - LR*5.2*1027
 . S PORDER=0
 . F  S PORDER=$O(^TMP("LR7OG",$J,"TP",CDT,PORDER)) Q:PORDER'>0  S DATA=^(PORDER) D
 .. I $P(DATA,U,7)="" Q
 .. S TESTNUM=+DATA,PRNTCODE=$P(DATA,U,5),SUB=$P(DATA,U,6),FLAG=$P(DATA,U,8),X=$P(DATA,U,7),UNITS=$P(DATA,U,9),RANGE=$P(DATA,U,10),SITE=$P(DATA,U,11)
 .. S:+$G(SITE) SITECNT=SITECNT+1      ; IHS/OIT/MKK - LR*5.*1027
 .. S LOW=$P(RANGE,"-"),HIGH=$P(RANGE,"-",2),THER=$P(DATA,U,12)
 .. ; S LINE="     "_$S($L($P(DATA,U,2))>20:$P(DATA,U,3),1:$P(DATA,U,2))
 .. S LINE=$S($L($P(DATA,U,2))>15:$P(DATA,U,3),1:$P(DATA,U,2))
 .. ; S LINE=$$SETSTR^VALM1("",LINE,28,0)
 .. S LINE=$$SETSTR^VALM1("",LINE,17,0)          ; IHS/OIT/MKK - LR*5.2*1027
 .. ; I PRNTCODE="" S LINE=LINE_$J(X,8)
 .. ; E  S @("VALUE="_PRNTCODE),LINE=LINE_VALUE
 .. ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1027
 .. I PRNTCODE="" S VALUE=X
 .. I PRNTCODE'="" S @("VALUE="_PRNTCODE)
 .. S LINE=$$SETSTR^VALM1($J(VALUE,7),LINE,19,8)
 .. ; ----- END IHS/OIT/MKK - LR*5.2*1027
 .. S LINE=LINE_" "_FLAG
 .. ; I $L(LINE)>38 D SETLINE(LINE,.OUTCNT) S LINE=""
 .. ; I UNITS'="" S LINE=$$SETSTR^VALM1("  "_UNITS,LINE,39,2+$L(UNITS))
 .. I UNITS'="" S LINE=$$SETSTR^VALM1(UNITS,LINE,31,2+$L(UNITS))     ; IHS/OIT/MKK - LR*5.2*1027
 .. I $G(RANGE)["$S(" D MUMPRNGE(.RANGE)    ; IHS/OIT/MKK - LR*5.2*1027
 .. S LRX=RANGE
 .. ; I LRX'="" S LINE=$$SETSTR^VALM1(LRX,LINE,52,$L(LRX))
 .. I LRX'="" S LINE=$$SETSTR^VALM1(LRX,LINE,44,$L(LRX))   ; IHS/OIT/MKK - LR*5.2*1027
 .. ; I $L(LINE)>67,SITE D SETLINE(LINE,.OUTCNT) S LINE=""
 .. ; I SITE S LINE=$$SETSTR^VALM1(" ["_SITE_"]",LINE,68,3+$L(SITE))
 .. I SITE S LINE=$$SETSTR^VALM1($J("["_SITE_"]",7),LINE,59,7)   ; IHS/OIT/MKK - LR*5.2*1027
 .. I IDT S LINE=$$SETSTR^VALM1($TR($$FMTE^XLFDT($P($G(^LR(LRDFN,"CH",IDT,0)),"^",3),"2MZ"),"@"," "),LINE,67,14) ; IHS/OIT/MKK - LR*5.2*1027
 .. I LINE'="" D SETLINE(LINE,.OUTCNT)
 .. I $O(^TMP("LR7OG",$J,"TP",CDT,PORDER,0))>0 D
 ... S INTP=0
 ... F  S INTP=+$O(^TMP("LR7OG",$J,"TP",CDT,PORDER,INTP)) Q:INTP<1  D SETLINE("      Eval: "_^(INTP),.OUTCNT)
 . I $D(^TMP("LR7OG",$J,"TP",CDT,"C")) D
 .. S LINE="Comment: "
 .. S CMNT=0
 .. F  S CMNT=+$O(^TMP("LR7OG",$J,"TP",CDT,"C",CMNT)) Q:CMNT<1  S LINE=LINE_^(CMNT) D
 ... D SETLINE(LINE,.OUTCNT)
 ... I $O(^TMP("LR7OG",$J,"TP",CDT,"C",CMNT)) S LINE="        "
 . ; D:SITECNT<1 SETLINE("===============================================================================",.OUTCNT)
 . D:SITECNT<1 SETLINE($TR($J("",81)," ","="),.OUTCNT)     ; IHS/OIT/MKK - LR*5.2*1027
 . D:SITECNT>0 PLS
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1027
MUMPRNGE(RANGE) ; EP -- MUMPS Code in Reference Range -- Evaluate and store
 NEW LOW,HIGH,RV1,RV2
 ;
 S LOW=$$TRIM^XLFSTR($P(RANGE,"-"),"LR"," ")
 S HIGH=$$TRIM^XLFSTR($P(RANGE,"-",2),"LR"," ")
 ;
 I $G(LOW)=""&($G(HIGH)="") S RANGE=" "  Q
 ;
 S RV1=$$MUMPEVAL(LOW)
 S RV2=$$MUMPEVAL(HIGH)
 ;
 I $G(RV1)=""&($G(RV2)="")  S RANGE=" "  Q
 ;
 S RANGE=RV1_" - "_RV2
 Q
 ;
MUMPEVAL(EVAL) ; 
 NEW STR,WOT
 ;
 ; If no SELECT, just Return the string, BUT ... if the string contains punctuation, that means the
 ; reference range code has been mis-parsed.  Return NULL.
 I EVAL'["$S(" D  Q EVAL
 .  I EVAL["("!(EVAL["?")!(EVAL["<")!(EVAL[")")!(EVAL["&") S EVAL=""
 ;
 ; If there is an "(" in the string, but no ")", that means the reference range code is too complex
 ; and/or has been mis-parsed.  Return NULL.
 I EVAL'[")" Q ""
 ;
 S STR="WOT="_EVAL
 S @STR
 ;
 ; ANY punctuation in string means parsing failed.  Return NULL.
 I WOT["("!(WOT["?")!(WOT["<")!(WOT[")")!(WOT["&") S WOT=""
 ;
 Q WOT
 ;
 ; ----- END IHS/OIT/MKK - LR*5.2*1027
 ; 
SETLINE(LINE,CNT) ;
 S ^TMP("LR7OGX",$J,"OUTPUT",CNT)=LINE
 S CNT=CNT+1
 Q
 ;
 ;
NAME(X) ; $$(#) -> name
 N LRDOC
 D DOC^LRX
 Q LRDOC
 ;
 ;
DD(Y) ; $$(date/time) -> date/time format
 D DD^LRX
 Q Y
 ;
 ;
PLS ; List performing laboratories
 ;
 N LINE,LRPLS,X
 D SETLINE(" ",.OUTCNT)                          ; IHS/OIT/MKK -- LR*5.2*1027
 D SETLINE("Performing Lab Sites",.OUTCNT)
 S LRPLS=0
 F  S LRPLS=$O(^TMP("LRPLS",$J,LRPLS)) Q:LRPLS<1  D
 . S LINE=$$LJ^XLFSTR("["_LRPLS_"] ",8)_$$NAME^XUAF4(LRPLS)
 . D SETLINE(LINE,.OUTCNT)
 . S X=$$PADD^XUAF4(LRPLS)
 . S LINE=$$REPEAT^XLFSTR(" ",8)_$P(X,U)_"  "_$P(X,U,2)_", "_$P(X,U,3)_" "_$P(X,U,4)
 . D SETLINE(LINE,.OUTCNT)
 ;
 D SETLINE("================================================================================",.OUTCNT)
 ;
 K ^TMP("LRPLS",$J)
 Q
