APCLDF2 ; IHS/CMI/LAB - YRULER<->PCC PROCESS ALGORITHM ;
 ;;2.0;IHS PCC SUITE;**2,4**;MAY 14, 2009
 ;
VI ; - ENTRY POINT - Ptr val for .01 field not in "AA" xref for this V FILE
 I VAL]"",'$D(APCLTX) S TVAL=$O(@TABLE@(XREF,VAL_" ","")) I TVAL="" S X=VAL,DIC(0)=$S($D(APCLINT):"MQEZ",1:"MO"),DIC=$S($E(TABLE,$L(TABLE))=")":$TR(TABLE,")",","),1:TABLE_"(") D ^DIC K DIC D  I Y=-1 S APCLER=8 G X4
 . I Y'=-1 S TVAL=+Y,VAL=$P(@TABLE@(+Y,0),U)
 S N=$S($G(N):N,1:0),C=$S($G(C):C,1:0)
 F D=0:0 S D=$O(@LKUP@("AA",PAT,D)) Q:'D  S E="" F  S E=$O(@LKUP@("AA",PAT,D,E)) Q:'E  I $D(@LKUP@(E,0)),$D(@TABLE@(+@LKUP@(E,0),0)) D
 . I $S('$D(TVAL)&($D(APCLTX)):$D(^TMP("APCLTAX",$J,$P(@LKUP@(E,0),U))),$D(TVAL):$P(@LKUP@(E,0),U)=TVAL,1:1) S C=C+1,N=N+1 S:'$D(TVAL) VAL=$P(@TABLE@(+@LKUP@(E,0),0),U) D TMP
 I '$D(APCLTX) D RESULTS
 I $D(APCLTX) S VAL=""
X4 Q
 ;
VV ; - ENTRY POINT - Ptr val. for .01 field in "AA" xref for this V FILE
 K NVAL
 I VAL]"",'$D(APCLTX) S TVAL=$O(@TABLE@(XREF,VAL,"")) S:$P($O(@TABLE@(XREF,VAL)),VAL)="" TVAL=""
 E  S TVAL=0,NVAL=""
 I VAL]"",TVAL="" S X=VAL,DIC(0)=$S($D(APCLINT):"MZQE",1:"MO"),DIC=$S($E(TABLE,$L(TABLE))=")":$TR(TABLE,")",","),1:TABLE_"(") D ^DIC K DIC D  I Y=-1 S APCLER=8 G X5
 . I Y'=-1 S TVAL=+Y,VAL=$P(@TABLE@(+Y,0),U)
 I 'TVAL D  I 1
 . S (C,N)=0 F  S TVAL=$O(@LKUP@("AA",PAT,TVAL)) Q:'TVAL  I $S('$D(APCLTX):1,$D(APCLTX)&$D(^TMP("APCLTAX",$J,TVAL)):1,1:0) D
 .. F D=0:0 S D=$O(@LKUP@("AA",PAT,TVAL,D)) Q:'D  S E="" F  S E=$O(@LKUP@("AA",PAT,TVAL,D,E)) Q:'E  I $D(@LKUP@(E,0)) S C=C+1,N=N+1,VAL=$P(@TABLE@(+@LKUP@(E,0),0),U) D TMP
 E  D
 . S N=$S($G(N):N,1:0),C=$S($G(C):C,1:0)
 . F D=0:0 S D=$O(@LKUP@("AA",PAT,TVAL,D)) Q:'D  S E="" F  S E=$O(@LKUP@("AA",PAT,TVAL,D,E)) Q:'E  I $D(@LKUP@(E,0)) S C=C+1,N=N+1 D TMP
 I '$D(APCLTX) D RESULTS
X5 Q
 ;
NV ; - ENTRY POINT - Not a V FILE
 I VAL]"" S TVAL=$S('$D(APCLTX):$O(@TABLE@(XREF,VAL,"")),1:VAL)
 E  I VAL="" F D=0:0 S D=$O(@LKUP@("AC",PAT,D)) D:'D RESULTS Q:'D  D
 . X:$D(SCRN) SCRN I $T S ^TMP("APCLDF",$J,"TMP",$S(COND="LAST":9999999-$P(@LKUP@(D,0),U,3),1:$P(@LKUP@(D,0),U,3)),D)=$P(@TABLE@(+@LKUP@(D,0),0),U)_"^"_$P(@TABLE@(+@LKUP@(D,0),0),U)_"^"_D_";"_$E(LKUP,2,20)
 I VAL]"",TVAL="" S X=VAL,DIC(0)=$S($D(APCLINT):"MZQE",1:"MO"),DIC=TABLE_"(" D ^DIC K DIC D  I Y=-1 S APCLER=8 G X6
 . I Y'=-1 S TVAL=+Y,VAL=$P(@TABLE@(+Y,0),U)
 I VAL]"" D
 . F D=0:0 S D=$O(@LKUP@("AC",PAT,D)) D:'D RESULTS Q:'D  D
 .. I 1 X:$D(SCRN) SCRN I $T,+@LKUP@(D,0)=TVAL D
 ... Q:$P(@LKUP@(D,0),U,3)=""
 ... S ^TMP("APCLDF",$J,"TMP",$S(COND="LAST":9999999-$P(@LKUP@(D,0),U,3),1:$P(@LKUP@(D,0),U,3)),D)=$S('$D(APCLTX):VAL,1:TVAL)_"^"_$S('$D(APCLTX):VAL_"^"_D_";"_$E(LKUP,1,20),1:TVAL_"^"_D_";"_$E(LKUP,2,20))
X6 Q
 ;
TMP ; Store dates, values
 ; if in a lab taxonomy lookup q if vlab site exists and doesn't equal site in taxonomy file
 ;I $D(APCLTX),TAX="LAB TAX",$P($G(^AUPNVLAB(E,11)),U,3)]"",$O(^TMP("APCLTAX",$J,TVAL,0)),'$D(^TMP("APCLTAX",$J,TVAL,$P($G(^AUPNVLAB(E,11)),U,3))) Q  ;IHS/CMI/LAB - do not look at site/specimen
 I LKUP["AUPNVMSR" Q:$P($G(^AUPNVMSR(E,2)),U,1)  ;skip measurements entered in error
 S ^TMP("APCLDF",$J,"TMP",$S(COND="LAST"&(DATE=""):D,1:9999999-D),C)=$S(TYPE="VV"&($P(@LKUP@(E,0),U,4)]""):$P(^(0),U,4)_"^"_VAL,1:$S(TYPE="VI":VAL_"^"_VAL,1:"?"_"^"_VAL))_"^"_E_";"_$E(LKUP,2,20)_"^"_$P(^(0),U,3)
 I DATE="",COND="LAST",N=NUM,'$D(NVAL) S (D,E)=999999999,VAL=""
X2 Q
 ;
RESULTS ;EP - Store results
 NEW D
 I DATE]"" D DATE^APCLDF3
 S I=0,%="" F  S %=$O(^TMP("APCLDF",$J,"TMP",%)) Q:'%  F D=0:0 S D=$O(^TMP("APCLDF",$J,"TMP",%,D)) S:D I=I+1 Q:'D!(I>NUM)  D
 . S @(APCLY_I_")")=$S(COND="LAST":9999999-%,1:%)_"^"_^TMP("APCLDF",$J,"TMP",%,D)
 K ^TMP("APCLDF",$J,"TMP")
 Q
 ;
ERROR ; Error flag list - APCLER value
1 ;;variable with patient and script value not passed
2 ;;variable with array value not passed
3 ;;taxonomy not allowed for this file
4 ;;demographic field/value not found
5 ;;class (file name) not found
6 ;;patient id not passed
7 ;;lookup into QMAN DICTIONARY OF TERMS failed
8 ;;entity unresolved, i.e., the name of a lab test or medication
9 ;;
10 ;;unresolved taxonomy
11 ;;value(s) not indicated
12 ;;unresolvable class(file name)
13 ;;unresolvable demographic attribute
14 ;;use last or first only for visit related data
15 ;;patient demographic attribute not entered
16 ;;indicated date parameter, i.e., since, before, etc., unacceptable
17 ;;date(s) not correctly indicated
18 ;;visit date not allowed for this attribute
