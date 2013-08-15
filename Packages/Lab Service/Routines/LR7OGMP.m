LR7OGMP ;VA/DALOI/STAFF- Interim report rpc memo print ;7/15/09  12:15
 ;;5.2;LAB SERVICE;**1027,1031**;NOV 01, 1997
 ;
 ;;VA LR Patche(s): 187,246,282,286,344,395
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
 . S SPEC=+$P(ZERO,U,5)
 . S DOC=$$NAME(+$P(ZERO,U,10))
 . D SETLINE("",.OUTCNT)
 . S LINE="Report Released Date/Time: "_$$FMTE^XLFDT($P(ZERO,"^",3),"M")
 . D SETLINE(LINE,.OUTCNT)
 . S LINE="Provider: "_DOC
 . D SETLINE(LINE,.OUTCNT)
 . S LINE="  Specimen: "_$P($G(^LAB(61,SPEC,0),"<no specimen on file>"),U)_"."
 . S ACC=$P(ZERO,U,6)
 . S LINE=$$SETSTR^VALM1(" "_ACC,LINE,30,1+$L(ACC))
 . D SETLINE(LINE,.OUTCNT)
 . D SETLINE("    Specimen Collection Date: "_$$LRUDT^LR7OSUM6(CDT),.OUTCNT)
 . ; D SETLINE("     Test name                Result    units      Ref.   range   Site Code",.OUTCNT)
 . ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1031
 . D SETLINE(" ",.OUTCNT)
 . D SETLINE("                          Res",.OUTCNT)
 . D SETLINE("Test name          Result Flg units        Ref.   range     Site  Result Dt/Time",.OUTCNT)
 . ; ----- END IHS/MSC/MKK - LR*5.2*1031
 . S PORDER=0
 . F  S PORDER=$O(^TMP("LR7OG",$J,"TP",CDT,PORDER)) Q:PORDER'>0  S DATA=^(PORDER) D
 .. I $P(DATA,U,7)="" Q
 .. S TESTNUM=+DATA,PRNTCODE=$P(DATA,U,5),SUB=$P(DATA,U,6),FLAG=$P(DATA,U,8),X=$P(DATA,U,7),UNITS=$P(DATA,U,9),RANGE=$P(DATA,U,10),SITE=$P(DATA,U,11)
 .. S:+$G(SITE) SITECNT=SITECNT+1      ; IHS/OIT/MKK - LR*5.*1027
 .. S LOW=$P(RANGE,"-"),HIGH=$P(RANGE,"-",2),THER=$P(DATA,U,12)
 .. ;
 .. ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1031
 .. NEW REFLOW,REFHIGH
 .. S REFLOW=$$TRIM^XLFSTR($P($G(RANGE),"-"),"LR"," ")
 .. S REFHIGH=$$TRIM^XLFSTR($P($G(RANGE),"-",2),"LR"," ")
 .. D:$L(REFLOW) ZEROFIX(TESTNUM,.REFLOW)
 .. D:$L(REFHIGH) ZEROFIX(TESTNUM,.REFHIGH)
 .. I $L(REFLOW)!($L(REFHIGH)) S RANGE=$$EN^LRLRRVF(REFLOW,REFHIGH)
 .. K REFLOW,REFHIGH
 .. ; ----- END IHS/MSC/MKK - LR*5.2*1031
 .. ;
 .. ; I $L($P(DATA,U,2))>28,$P(DATA,U,3)'="" S LINE=$P(DATA,U,3)
 .. ; E  S LINE=$E($P(DATA,U,2),1,28)
 .. S LINE=$S($L($P(DATA,U,2))>15:$P(DATA,U,3),1:$P(DATA,U,2))       ; IHS/MSC/MKK - LR*5.2*1031
 .. ; S LINE=$$SETSTR^VALM1("",LINE,28,0)
 .. S LINE=$$SETSTR^VALM1("",LINE,17,0)                              ; IHS/MSC/MKK - LR*5.2*1031
 .. ; I PRNTCODE="" S LINE=LINE_$J(X,8)
 .. ; E  S @("VALUE="_PRNTCODE),LINE=LINE_VALUE
 .. ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1031
 .. I PRNTCODE="" S VALUE=X
 .. I PRNTCODE'="" S @("VALUE="_PRNTCODE)
 .. S LINE=$$SETSTR^VALM1($J(VALUE,7),LINE,19,8)
 .. ; ----- END IHS/MSC/MKK - LR*5.2*1031
 .. S LINE=LINE_" "_FLAG
 .. ; I $L(LINE)>38 D SETLINE(LINE,.OUTCNT) S LINE=""
 .. ; I UNITS'="" S LINE=$$SETSTR^VALM1("  "_UNITS,LINE,39,2+$L(UNITS))
 .. I UNITS'="" S LINE=$$SETSTR^VALM1(UNITS,LINE,31,2+$L(UNITS))     ; IHS/OIT/MKK - LR*5.2*1027
 .. I $G(RANGE)["$S(" D MUMPRNGE(.RANGE)                             ; IHS/OIT/MKK - LR*5.2*1027
 .. S LRX=RANGE
 .. ; I LRX'="" S LINE=$$SETSTR^VALM1(LRX,LINE,52,$L(LRX))
 .. I LRX'="" S LINE=$$SETSTR^VALM1(LRX,LINE,44,$L(LRX))             ; IHS/OIT/MKK - LR*5.2*1027
 .. ; I $L(LINE)>67,SITE D SETLINE(LINE,.OUTCNT) S LINE=""
 .. ; I SITE S LINE=$$SETSTR^VALM1(" ["_SITE_"]",LINE,68,3+$L(SITE))
 .. I SITE S LINE=$$SETSTR^VALM1($J("["_SITE_"]",7),LINE,59,7)       ; IHS/OIT/MKK - LR*5.2*1027
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
 . ; D SETLINE("===============================================================================",.OUTCNT)
 . D:SITECNT<1 SETLINE($TR($J("",81)," ","="),.OUTCNT)               ; IHS/OIT/MKK - LR*5.2*1027
 . ; D SETLINE(" ",.OUTCNT)
 . D:SITECNT>0 PLS                                                   ; IHS/MSC/MKK - LR*5.2*1031
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
 ; I $G(RV1)=""&($G(RV2)="")  S RANGE=" "  Q
 ;
 ; S RANGE=RV1_" - "_RV2
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1031
 D:$L(RV1) ZEROFIX(TESTNUM,.RV1)
 D:$L(RV2) ZEROFIX(TESTNUM,.RV2)
 S RANGE=$$EN^LRLRRVF(RV1,RV2)       ; IHS/MSC/MKK - LR*5.2*1031
 ; ----- END IHS/MSC/MKK - LR*5.2*1031
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
 D SETLINE(" ",.OUTCNT)                                              ; IHS/OIT/MKK -- LR*5.2*1027
 D SETLINE("Performing Lab Sites",.OUTCNT)
 S LRPLS=0
 F  S LRPLS=$O(^TMP("LRPLS",$J,LRPLS)) Q:LRPLS<1  D
 . S LINE=$$LJ^XLFSTR("["_LRPLS_"] ",8)_$$NAME^XUAF4(LRPLS)
 . D SETLINE(LINE,.OUTCNT)
 . S X=$$PADD^XUAF4(LRPLS)
 . S LINE=$$REPEAT^XLFSTR(" ",8)_$P(X,U)_"  "_$P(X,U,2)_", "_$P(X,U,3)_" "_$P(X,U,4)
 . D SETLINE(LINE,.OUTCNT)
 ;
 D SETLINE("===============================================================================",.OUTCNT)
 ;
 K ^TMP("LRPLS",$J)
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1031
ZEROFIX(F60PTR,RESULT) ; EP - Leading & Trailing Zero Fix for Results
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,F60PTR,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,RESULT,U,XPARSYS,XQXFLG)
 ;
 Q:$$UP^XLFSTR($G(RESULT))["SPECIMEN IN LAB"          ; Skip if not resulted
 ;
 Q:$L($G(RESULT))<1                      ; Skip if no Result
 Q:$L($G(F60PTR))<1                      ; Skip if no File 60 Pointer
 ;
 S DN=+$G(^LAB(60,F60PTR,.2))
 Q:DN<1                                  ; Skip if no DataName
 ;
 Q:$G(^DD(63.04,DN,0))'["^LRNUM"         ; Skip if no numeric defintiion
 ;	
 S STR=$P($P($G(^DD(63.04,DN,0)),"Q9=",2),$C(34),2)     ; Get numeric formatting
 ;
 S DP=+$P(STR,",",3)                     ; Decimal Places
 Q:DP<1                                  ; Skip if no Decimal Defintion
 ;
 S SYMBOL="",ORIGRSLT=RESULT
 F  Q:$E(RESULT)="."!($E(RESULT)?1N)!(RESULT="")  D       ; Adjust if ANY Non-Numeric is at the beginning of RESULT
 . S SYMBOL=SYMBOL_$E(RESULT)
 . S RESULT=$E(RESULT,2,$L(RESULT))
 ;
 S:$E(RESULT)="." RESULT="0"_RESULT      ; Leading Zero Fix
 ;
 I $E(RESULT)'?1N  S RESULT=ORIGRSLT  Q  ; Skip if RESULT has no numeric part
 ;
 S RESULT=$TR($FN(RESULT,"P",DP)," ")
 ;
 S:$L($G(SYMBOL)) RESULT=SYMBOL_RESULT   ; Restore "symbol", if necessary
 ;
 Q
 ; ----- END IHS/MSC/MKK - LR*5.2*1031
