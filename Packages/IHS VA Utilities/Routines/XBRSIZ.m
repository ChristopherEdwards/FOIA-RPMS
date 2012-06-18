XBRSIZ ; IHS/ADC/GTH - List routine names and sizes w/overall total. ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; List routine names, sizes, and total bytes.
 ;
START ;
 W !!,"XBRSIZ - List routine names, sizes, and total bytes.",!
 X ^%ZOSF("RSEL")
 G EXIT:$O(^UTILITY($J,""))=""
 D ^%ZIS
 G EXIT:POP
 KILL ^TMP("XBRSIZ",$J)
 S (A,%R)=0
 X "F I=1:1 S A=$O(^UTILITY($J,A)),T=0 Q:'$L(A)  ZL @A S %R=%R+1 F J=1:1 S ^TMP(""XBRSIZ"",$J,""CRF"",I,J)=$T(+J),T=T+$L($T(+J))+2 I $T(+J+1)="""" S ^TMP(""XBRSIZ"",$J,""CRF1"",I,0)=A_""^""_T Q"
 KILL %R,A,I,J
PRT ;
 U IO
 W @IOF
 W !!?10,"XBRSIZ - LIST ROUTINE SIZES of "
 X ^%ZOSF("UCI")
 W Y,", ",$$HTE^XLFDT($H),!!?24,"ROUTINE",?36,"SIZE",!
 S SIZT=0
 F %I=1:1 Q:'$D(^TMP("XBRSIZ",$J,"CRF1",%I,0))  S Y=^(0) W !?24,$P(Y,"^"),?34,$J($P(Y,"^",2),6) S SIZT=SIZT+$P(Y,"^",2)
 W !!?24,"TOTAL",?34,$J(SIZT,6)
 W !!?24,%I-1,"  ROUTINE" W:%I-1>1 "S"
 KILL %I,J,N,S,SIZT,T,V,W,X,Y,Z
EXIT ;
 KILL ^TMP("XBRSIZ",$J),I,X
 D ^%ZISC
 Q
 ;
