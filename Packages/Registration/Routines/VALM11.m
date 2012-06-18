VALM11 ;ALB/MJK - VALM Utilities ;08:17 PM  6 Dec 1992
 ;;1;List Manager;;Aug 13, 1993
 ;
RANGE ; -- change date range
 ; input: ^TMP("VALM DATA",$J VALMEVL,"DAYS") := number of days allowed
 ;                 VALMB := default beginning date {optional}
 ;
 S (VALMBEG,VALMEND)=""
 I $D(VALMB) S Y=VALMB D DD^%DT S:Y]"" %DT("B")=Y
 W ! S:$D(VALMIN) %DT(0)=VALMIN S %DT="AEX",%DT("A")="Select Beginning Date: " D ^%DT K %DT
 G RANGEQ:Y<0 S (X1,VALMX)=Y,X2=+$G(^TMP("VALM DATA",$J,VALMEVL,"DAYS")) D C^%DTC S VALMX1=X,X=""
 I VALMX'>DT,VALMX1>DT S X="TODAY"
 I X="" S Y=VALMX D DD^%DT S X=Y
 S DIR("B")=X
 S DIR(0)="DA"_U_VALMX_":"_VALMX1_":EX",DIR("A")="Select    Ending Date: "
 S DIR("?",1)="Date range can be a maximum of "_+$G(^TMP("VALM DATA",$J,VALMEVL,"DAYS"))_" days long.",DIR("?",2)=" "
 S DIR("?",3)="Enter a date between "_$$FDATE^VALM1(VALMX)_" and "_$$FDATE^VALM1(VALMX1)_".",DIR("?")=" "
 D ^DIR K DIR G RANGEQ:Y'>0 S VALMEND=Y,VALMBEG=VALMX
RANGEQ K VALMX,VALMX1 Q
 ;
