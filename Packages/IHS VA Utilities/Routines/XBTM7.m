XBTM7 ; IHS/ADC/GTH - TECH MANUAL : ROUTINES ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A
 F A=1:1 S X=$P($T(PR+A),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 KILL ^TMP("XBTM-RTN",$J)
 NEW A,B
 S DIWF="WN"
 D PR("Routines & sub-routines in namespace :"),PR(" "),PR(" ")
 Q:$D(DUOUT)
 S %=$$RSEL^ZIBRSEL("XB*","^TMP(""XB"",$J,")
 S %=$$RSEL^ZIBRSEL("ZIB*","^TMP(""XB"",$J,")
 S %=""
 F  S %=$O(^TMP("XB",$J,%)) Q:%=""  Q:$D(DUOUT)  D
 . D PR($E("|_|"_%_"|_| "_$P($T(+1^@%)," ",2,99),1,(DIWR-DIWL+7)))
 . Q:$D(DUOUT)
 . S B=$T(+1^@%)
 . I B["; GENERATED FROM "!(B["; DRIVER FOR")!(B["; COMPILED XREF") S ^TMP("XBTM-RTN",$J,"C",%)=B
 . F A=3:1 S B=$T(+A^@%) Q:B=""!('($E(B,1,2)=" ;"))  D PR("   "_$E(B,1,(DIWR-DIWL-2))) Q:$D(DUOUT)
 . Q:$D(DUOUT)
 . F A=3:1 S B=$T(+A^@%) Q:B=""  I '($E(B)=" ") D PR("   "_$E(B,1,(DIWR-DIWL-2))) I B[";EP"!(B["ENTRY POINT") S ^TMP("XBTM-RTN",$J,%,$P(B," "))=$P(B," ",2,999) Q:$D(DUOUT)
 . Q:$D(DUOUT)
 . D PR(" ")
 .Q
 ;
 D PR("|TOP|"),PR(" "),PR("Documented entry points:"),PR(" ")
 Q:$D(DUOUT)
 S (A,B)=""
 F  S A=$O(^TMP("XBTM-RTN",$J,A)) Q:A=""!(A="C")  Q:$D(DUOUT)  F  S B=$O(^TMP("XBTM-RTN",$J,A,B)) Q:B=""  D PR($E(B_U_A_" : "_^(B),1,(DIWR-DIWL))) Q:$D(DUOUT)
 Q:$D(DUOUT)
 ;
 D PR(" "),PR(" "),PR("Compiled/Generated routines:"),PR(" ")
 Q:$D(DUOUT)
 S A=""
 F  S A=$O(^TMP("XBTM-RTN",$J,"C",A)) Q:A=""  D PR($E(^(A),1,(DIWR-DIWL))) Q:$D(DUOUT)
 Q:$D(DUOUT)
 ;
 KILL ^TMP("XBTM-RTN",$J)
 S DIWF="W"
 Q
 ;
PR(X) NEW %,A,B D PR^XBTM(X) Q
 ;;These are the routine descriptions, which are usually contained
 ;;in the commented lines prior to the first label or executable
 ;;line.
 ;;|SETTAB("C")||TAB| 
 ;;Each line label is also listed.  The internally documented
 ;;entry points (" ;EP") are listed.
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;###
