XBTM8 ; IHS/ADC/GTH - TECH MANUAL : EXTERNAL RELATIONS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A
 F A=1:1 S X=$P($T(PR+A),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 KILL ^TMP("XBTM8",$J)
 NEW A,B
 S DIWF="WN"
 S %=$$RSEL^ZIBRSEL("XB*","^TMP(""XB"",$J,")
 S %=$$RSEL^ZIBRSEL("ZIB*","^TMP(""XB"",$J,")
 ;
 S %=""
 F  S %=$O(^TMP("XB",$J,%)) Q:%=""  D
 .S B=$T(+1^@%)
 .F A=3:1 S B=$T(+A^@%) Q:B=""  I '($E(B)=" ") I B[";PEP" S ^TMP("XBTM8",$J,%,$P(B," "))=$P(B," ",2,999)
 .Q
 ;
 F %=1:1 S B=$T(L+%^XBLCALL),A=$P(B,";",3) Q:B=""  I $E(A)=U S A=$E(A,2,99),^TMP("XBTM8",$J,A,A)=$P(B,";",4,999)
 D PR("|TOP|"),PR(" "),PR("Published entry points and supported routines:"),PR(" ")
 Q:$D(DUOUT)
 S (A,B)=""
 F  S A=$O(^TMP("XBTM8",$J,A)) Q:A=""  Q:$D(DUOUT)  F  S B=$O(^TMP("XBTM8",$J,A,B)) Q:B=""  D PR($E($S(A=B:"",1:$P(B,"(",1))_U_A_$S($L($P(B,"(",2)):"(",1:"")_$P(B,"(",2)_" : "_^(B),1,(DIWR-DIWL))) Q:$D(DUOUT)
 ;
 KILL ^TMP("XBTM8",$J)
 Q:$D(DUOUT)
 S DIWF="W"
 Q
 ;
PR(X) NEW %,A,B D PR^XBTM(X) Q
 ;;There are several published entry points that may be called
 ;;from other packages.  Some XB/ZIB routines were programmed to be
 ;;available to call from the top of the routine, and are so noted in
 ;;the routine.
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;###
