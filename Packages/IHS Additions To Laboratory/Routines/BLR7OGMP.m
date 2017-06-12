BLR7OGMP ; IHS/OIT/MKK - Lab Interim Report for EHR ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1028,1030,1031,1033**;NOV 01, 1997
 ;
 ; Cloned from LR7OGMP. This is a 127 column "report"
 ;
PRINT(OUTCNT) ; from LR7OGMC
 NEW ACC,AGE,CDT,CMNT,DATA,DOC,FLAG,HIGH,IDT,INTP,LINE,LOW,LRCW,LRX,PORDER,PRNTCODE
 NEW RANGE,REFHIGH,REFLOW,SEX,SITE,SPEC,SUB,TESTNUM
 NEW TESTSPEC,THER,THERHIGH,THERLOW,UNITS,VALUE,X,ZERO
 ;
 NEW LINESTR,LRPLS,TIDT,SITECNT,TLOCDNM
 NEW SPECCOND      ; IHS/MSC/MKK - LR*5.2*1033
 ;
 ; the variables AGE, SEX, LRCW, and X are used with the lab's print codes and ref ranges
 S AGE=$P(^TMP("LR7OG",$J,"G"),U,4),SEX=$P(^("G"),U,5),LRCW=$P(^("G"),U,6)
 S CDT=0
 S SITECNT=0
 F  S CDT=$O(^TMP("LR7OG",$J,"TP",CDT)) Q:CDT=""  D
 . S IDT=9999999-CDT
 . S ZERO=$S($D(^TMP("LR7OG",$J,"TP",CDT))#2:^(CDT),1:"")
 . S SPEC=+$P(ZERO,U,5)
 . S DOC=$$NAME(+$P(ZERO,U,10))
 . ;
 . D SETLINE("",.OUTCNT)
 . ;
 . S LINE="     Provider: "_DOC
 . S ACC=$P(ZERO,U,6)
 . S LINE=$$SETSTR^VALM1(" Accession: "_ACC,LINE,54,12+$L(ACC))
 . D SETLINE(LINE,.OUTCNT)
 . ;
 . S LINE="     Specimen: "_$E($P($G(^LAB(61,SPEC,0),"<no specimen on file>"),U),1,25)_"."
 . S $E(LINE,42)="Spec Collect Date/Time: "_$$UP^XLFSTR($$FMTE^XLFDT(CDT,"5MPZ"))     ; IHS/OIT/MKK - LR*5.2*1030
 . D SETLINE(LINE,.OUTCNT)
 . ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
 . S SPECCOND=$$CONDSPEC()
 . I $L(SPECCOND) D
 .. S LINE="     Specimen Condition: "_SPECCOND
 .. D SETLINE(LINE,.OUTCNT)
 . D SETLINE("",.OUTCNT)
 . ;
 . D RESULTHD      ; 'Results' Header
 . ; ----- END IHS/MSC/MKK - LR*5.2*1033
 . ;
 . S PORDER=0
 . F  S PORDER=$O(^TMP("LR7OG",$J,"TP",CDT,PORDER)) Q:PORDER'>0  S DATA=^(PORDER) D
 .. I $P(DATA,U,7)="" Q
 .. S TESTNUM=+DATA,PRNTCODE=$P(DATA,U,5),SUB=$P(DATA,U,6),FLAG=$P(DATA,U,8),X=$P(DATA,U,7),UNITS=$P(DATA,U,9),RANGE=$P(DATA,U,10),SITE=$P(DATA,U,11)
 .. S STR=$G(^LAB(60,TESTNUM,1,SPEC,0))
 .. S REFLOW=$P(STR,"^",2)
 .. S REFHIGH=$P(STR,"^",3)
 .. ;
 .. S:$TR(REFLOW," ")'=""!($TR(REFHIGH," ")'="") RANGE=REFLOW_" - "_REFHIGH
 .. S THERLOW=$P(STR,"^",11)
 .. S THERHIGH=$P(STR,"^",12)
 .. ;
 .. I IDT S SITE=$P($G(^LR(LRDFN,"CH",IDT,+$P(SUB,";",2))),"^",9)
 .. S:+$G(SITE) SITECNT=SITECNT+1
 .. ;
 .. D ZEROFIX(TESTNUM,.X)                   ; IHS/OIT/MKK - LR*5.2*1031
 .. ;
 .. I PRNTCODE="" S VALUE=X
 .. I PRNTCODE'="" S @("VALUE="_PRNTCODE)
 .. ;
 .. I $G(RANGE)["$S(" D MUMPRNGE(.RANGE)
 .. ;
 .. ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1031
 .. ; S LOW=$$TRIM^XLFSTR($P($G(RANGE),"-"),"LR"," ")
 .. ; S HIGH=$$TRIM^XLFSTR($P($G(RANGE),"-",2),"LR"," ")
 .. ; D:$L(LOW) ZEROFIX(TESTNUM,.LOW)
 .. ; D:$L(HIGH) ZEROFIX(TESTNUM,.HIGH)
 .. ; I $L(LOW)!($L(HIGH)) S RANGE=$$EN^LRLRRVF(LOW,HIGH)
 .. ; ----- END IHS/MSC/MKK - LR*5.2*1031
 .. ;
 .. ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
 .. I $L(RANGE)&($$UP^XLFSTR(RANGE)'[" TO ") D
 ... S LOW=$$TRIM^XLFSTR($P($G(RANGE),"-"),"LR"," ")
 ... S HIGH=$$TRIM^XLFSTR($P($G(RANGE),"-",2),"LR"," ")
 ... D:$L(LOW) ZEROFIX(TESTNUM,.LOW)
 ... D:$L(HIGH) ZEROFIX(TESTNUM,.HIGH)
 ... I $L(LOW)!($L(HIGH)) S RANGE=$$EN^LRLRRVF(LOW,HIGH)
 .. ; I RANGE["Ref:" S RANGE=$P(RANGE,"Ref: ",2)
 .. I RANGE["Ref:" S RANGE=$TR($P(RANGE,"Ref: ",2),"=")    ; MU2 Only
 .. ; ----- END IHS/MSC/MKK - LR*5.2*1033
 .. ;
 .. S LRX=$G(RANGE)
 .. ;
 .. ; Have to determine if Ref Ranges came from THERAPEUTIC fields
 .. ; I $L(REFLOW)<1,$L(REFHIGH)<1,$L(THERLOW),$L(THERHIGH),$L(LRX) S LRX=LRX_"(TR)"
 .. ;
 .. I IDT S SITE=$P($G(^LR(LRDFN,"CH",IDT,+$P($G(SUB),";",2))),"^",9)
 .. S:+$G(SITE) SITECNT=SITECNT+1
 .. I SITE D
 ... ; S ^TMP("LRPLS",$J,SITE)=""
 ... S ^TMP("LRPLS",$J,SITE)=$P($G(^LR(LRDFN,"CH",IDT,"RF")),"^",2,3)     ; IHS/MSC/MKK - LR*5.2*1033
 .. ;
 .. ; LINE will be 127 characters wide
 .. K LINE
 .. S LINE=$E($P(DATA,U,2),1,33)                           ; Test Description
 .. S:$L(VALUE)<31 $E(LINE,35)=$G(VALUE)                   ; Result
 .. S $E(LINE,67)=FLAG                                     ; Abnormal Flag
 .. S:+$G(UNITS) UNITS=$P($G(^BLRUCUM(UNITS,0)),"^")
 .. S:$G(UNITS)'="" $E(LINE,70)=$E(UNITS,1,16)             ; Units
 .. ; S:$G(LRX)'="" $E(LINE,88)=$E(LRX,1,16)               ; Reference Range
 .. ; S:+$G(SITE) $E(LINE,106)="["_SITE_"]"                ; Site
 .. ; S:+$G(IDT) $E(LINE,113)=$TR($$FMTE^XLFDT($P($G(^LR(LRDFN,"CH",IDT,0)),"^",3),"2MZ"),"@"," ") ; Result Date/Time
 .. ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
 .. I $L(LRX)<16 D
 ... S:$G(LRX)'="" $E(LINE,88)=$E(LRX,1,16)                ; Reference Range
 ... S:+$G(SITE) $E(LINE,106)="["_SITE_"]"                 ; Site
 ... ; S:+$G(IDT) $E(LINE,113)=$TR($$FMTE^XLFDT($P($G(^LR(LRDFN,"CH",IDT,0)),"^",3),"2MZ"),"@"," ")  ; Result Date/Time
 ... S:+$G(IDT) $E(LINE,113)=$$GETCOMPD()
 .. I $L(LRX)>15 D REFWRAP
 .. ; ----- END IHS/MSC/MKK - LR*5.2*1033
 .. ;
 .. D:$L($G(LINE)) SETLINE(LINE,.OUTCNT)
 .. ;
 .. D:$L(VALUE)>30 MULTIVAL(VALUE)                          ; Result was too long; make multi-line
 .. ;
 .. I $O(^TMP("LR7OG",$J,"TP",CDT,PORDER,0))>0 D
 ... S INTP=0
 ... F  S INTP=+$O(^TMP("LR7OG",$J,"TP",CDT,PORDER,INTP)) Q:INTP<1  D SETLINE("      Eval: "_^(INTP),.OUTCNT)
 . ;
 . I $D(^TMP("LR7OG",$J,"TP",CDT,"C")) D
 .. S LINE="Comment: "
 .. S CMNT=0
 .. F  S CMNT=+$O(^TMP("LR7OG",$J,"TP",CDT,"C",CMNT)) Q:CMNT<1  S LINE=LINE_^(CMNT) D
 ... D SETLINE(LINE,.OUTCNT)
 ... I $O(^TMP("LR7OG",$J,"TP",CDT,"C",CMNT)) S LINE="        "
 . ;
 . D:SITECNT<1 SETLINE($TR($J("",132)," ","="),.OUTCNT)
 . D:SITECNT>0 PLS
 Q
 ;
RESULTHD ; EP - 'Results' Header
 K LINESTR
 S $E(LINESTR,66)="Res"
 S $E(LINESTR,106)="Site"
 D SETLINE(LINESTR,.OUTCNT)
 K LINESTR
 S LINESTR="Test name"
 S $E(LINESTR,35)="Result"
 S $E(LINESTR,66)="Flg"
 S $E(LINESTR,70)="Units"
 S $E(LINESTR,88)="Ref.   range"
 S $E(LINESTR,106)="Code"
 S $E(LINESTR,113)="Result Dt/Time"
 D SETLINE(LINESTR,.OUTCNT)
 Q
 ;
MUMPRNGE(RANGE) ; EP -- MUMPS Code in Reference Range -- Evaluate and store
 NEW LOW,HIGH,RV1,RV2
 ;
 ; S LOW=$$TRIM^XLFSTR($$TRIM^XLFSTR($P(RANGE,"-"),"R"," "),"L"," ")
 ; S HIGH=$$TRIM^XLFSTR($$TRIM^XLFSTR($P(RANGE,"-",2),"R"," "),"L"," ")
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1030
 ; S LOW=$$TRIM^XLFSTR($$TRIM^XLFSTR($P(RANGE," - "),"R"," "),"L"," ")
 ; S:LOW[$C(34)_$C(34) LOW=$$DQUOTER(LOW)
 ;
 ; S HIGH=$$TRIM^XLFSTR($$TRIM^XLFSTR($P(RANGE," - ",2),"R"," "),"L"," ")
 ; S:HIGH[$C(34)_$C(34) HIGH=$$DQUOTER(HIGH)
 ; ----- END IHS/OIT/MKK - LR*5.2*1030
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1033
 S LOW=$$TRIM^XLFSTR($P(RANGE," - "),"LR"," ")
 I LOW[$C(34)_$C(34),LOW'[$C(34)_$C(34)_$C(41),LOW'[$C(34)_$C(34)_$C(44) S LOW=$$DQUOTER(LOW)
 ;
 S HIGH=$$TRIM^XLFSTR($P(RANGE," - ",2),"LR"," ")
 I HIGH[$C(34)_$C(34),HIGH'[$C(34)_$C(34)_$C(41),HIGH'[$C(34)_$C(34)_$C(44) S HIGH=$$DQUOTER(HIGH)
 ; ----- END IHS/OIT/MKK - LR*5.2*1033
 ;
 S RV1=$$MUMPEVAL(LOW)
 S RV2=$$MUMPEVAL(HIGH)
 ;
 S RANGE=RV1_" - "_RV2
 S:$TR(RANGE," ")="-" RANGE=""    ; IHS/MSC/MKK - LR*5.2*1033 - if no values, just return null string
 ;
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1030
DQUOTER(STR) ; EP -- Get rid of double quotes in string
 NEW DBLQ,REMOVED
 ;
 S DBLQ=$C(34)_$C(34)                      ; Double Quotes
 S REMOVED=$$TRIM^XLFSTR(STR,"LR",$C(34))  ; Get rid of leading & traling quotes
 F  Q:REMOVED'[DBLQ  D
 . S REMOVED=$P(REMOVED,DBLQ,1)_$C(34)_$P(REMOVED,DBLQ,2,999)
 ;
 Q REMOVED
 ; ----- END IHS/OIT/MKK - LR*5.2*1030
 ;
MUMPEVAL(EVAL) ; 
 NEW EVALLEN,STR,WOT
 ;
 I EVAL'["$S(" Q EVAL
 ;
 ; ----- BEGIN IHS/MSC/MKK LR*5.2*1033
 S EVALLEN=$L(EVAL)
 I $E(EVAL,EVALLEN-3,EVALLEN)="1:"")" S $P(EVAL,":",$L(EVAL,":"))=$C(34)_$C(34)_")"
 ; ----- END IHS/MSC/MKK - LR*5.2*1033
 ;
 S STR="WOT="_EVAL
 S @STR
 Q WOT
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
 N STR,COUNTY,COUNTRY,ICOUNTRY   ; IHS/MSC/MKK - LR*5.2*1033
 ;
 D SETLINE(" ",.OUTCNT)
 D SETLINE("Performing Lab Site(s):",.OUTCNT)
 S LRPLS=0
 F  S LRPLS=$O(^TMP("LRPLS",$J,LRPLS)) Q:LRPLS<1  D
 . S LINE=$$LJ^XLFSTR("["_LRPLS_"] ",8)_$$NAME^XUAF4(LRPLS)
 . S X=$$PADD^XUAF4(LRPLS)     ; Physical Address
 . S LINE=LINE_"  "_$$REPEAT^XLFSTR(" ",8)_$P(X,U)_"  "_$P(X,U,2)_", "_$P(X,U,3)_" "_$P(X,U,4)
 . D SETLINE(LINE,.OUTCNT)
 . ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
 . S STR=$G(^TMP("LRPLS",$J,LRPLS))
 . Q:$L(STR)<1
 . S COUNTY=$P(STR,"^"),COUNTRY=+$P(STR,"^",2)
 . S LINE=$J("",8)_$$LJ^XLFSTR("County:"_COUNTY,15)
 . S:COUNTRY LINE=LINE_"Country:"_$$GET1^DIQ(779.004,COUNTRY,"CODE")
 . D SETLINE(LINE,.OUTCNT)
 . ; ----- END IHS/MSC/MKK - LR*5.2*1033
 ;
 D SETLINE($TR($J("",126)," ","="),.OUTCNT)
 ; D SETLINE("KEY: L=Abnormal Low     H=Abnormal High     *=Critical value     TR=Therapeutic Range",.OUTCNT)
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1030
 S STR=$$CJ^XLFSTR("KEY: A=Abnormal        L=Abnormal Low        H=Abnormal High        *=Critical value        TR=Therapeutic Range",127)
 D SETLINE(STR,.OUTCNT)
 ; ----- END IHS/OIT/MKK - LR*5.2*1030
 ;
 K ^TMP("LRPLS",$J)
 Q
 ;
 ; ----- BEGIN IHS/OIT/MKK - LR*5.2*1030
MULTIVAL(VALUE) ; EP - Multiple Line Value String
 D USEDIWP(VALUE,34,91)
 Q
 ;
USEDIWP(X,LM,CW) ; EP -- Use FileMan DIWP to wrap text
 NEW CNT,LINE,STR
 ;
 K ^UTILITY($J,"W")
 S DIWL=LM,DIWR="",DIWF="C"_CW
 D ^DIWP
 S LINE=0
 F  S LINE=$O(^UTILITY($J,"W",LM,LINE))  Q:LINE<1  D
 . S STR=$J("",LM)_$G(^UTILITY($J,"W",LM,LINE,0))
 . D SETLINE(STR,.OUTCNT)
 Q
 ; ----- END IHS/OIT/MKK - LR*5.2*1030
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
 F  Q:$E(RESULT)="."!($E(RESULT)?1N)!(RESULT="")  D   ; Adjust if ANY Non-Numeric is at the beginning of RESULT
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
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1033
REFWRAP ; EP -- Reference Range String too long -- have to wrap it
 NEW LINER,LM,MAX
 ;
 S MAX=15
 ;
 ; Use FileMan DIWP routine to "wrap" string
 S X=LRX
 K ^UTILITY($J,"W")
 S LM=2
 S DIWL=LM,DIWR="",DIWF="C"_MAX
 D ^DIWP
 ;
 M ^XTMP("BLR7OGMP",$J)=^UTILITY($J)
 ;
 S $E(LINE,88)=$G(^UTILITY($J,"W",2,1,0))               ; Reference Range
 S:+$G(SITE) $E(LINE,106)="["_SITE_"]"                  ; Site
 ; S:+$G(IDT) $E(LINE,113)=$TR($$FMTE^XLFDT($P($G(^LR(LRDFN,"CH",IDT,0)),"^",3),"2MZ"),"@"," ")     ; Result Date/Time
 S:+$G(IDT) $E(LINE,113)=$$GETCOMPD()
 D SETLINE(LINE,.OUTCNT)
 ;
 S LINER=1
 F  S LINER=$O(^UTILITY($J,"W",2,LINER))  Q:LINER<1  D
 . K LINE
 . S $E(LINE,88)=$G(^UTILITY($J,"W",2,LINER,0))
 . D SETLINE(LINE,.OUTCNT)
 K ^UTILITY($J,"W"),LINE
 Q
 ;
CONDSPEC() ; EP - Specimen Condition
 Q $P($G(^LR(+LRDFN,"CH",+IDT,"IHS")),"^")
 ;
GETCOMPD() ; EP - Get Completion Date
 NEW DATEHERE,DATANAME,LRSS
 ;
 S LRSS=$P($P(DATA,"^",6),";")
 Q:LRSS="" " "
 ;
 S DATANAME=+$P($P(DATA,"^",6),";",2)
 ;
 I LRSS="CH" D
 . S DATEHERE=+$G(^LR(LRDFN,"CH",IDT,DATANAME,"IHS"))
 ;
 I LRSS="MI" D
 . S DATEHERE=+$P($G(^LR(LRDFN,"MI",IDT,"IHS")),"^",3)
 ;
 S:$L(DATEHERE)<7 DATEHERE=+$P($G(^LR(LRDFN,LRSS,IDT,0)),"^",3)
 ;
 S DATEHERE=$S(DATEHERE:$TR($$FMTE^XLFDT(DATEHERE,"2MZ"),"@"," "),1:" ")
 ;
 Q DATEHERE
 ;
 ; ----- END IHS/MSC/MKK - LR*5.2*1033
