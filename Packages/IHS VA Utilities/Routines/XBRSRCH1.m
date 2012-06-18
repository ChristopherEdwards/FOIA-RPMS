XBRSRCH1 ; IHS/ADC/GTH - COMMON CHECK LOGIC ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 ; Part of XBRSRCH
 ;
CHECK ; EXCLUDE ^%DT,^DIC,^DIK,^DIQ, AND GLOBALS
 Q:Y=""
 Q:$E(Y)=""""
 Q:$E(Y,1,3)="%DT"
 Q:$E(Y,1,3)="DIC"
 Q:$E(Y,1,3)="DIK"
 Q:$E(Y,1,3)="DIQ"
 S X0=$F(Y,")"),X1=$F(Y,"("),X2=$F(Y," ")
 S:'X0 X0=999
 S:'X1 X1=999
 S:'X2 X2=888
 Q:X0<X2
 Q:X1<X2
 S XBRSRCH("FOUND")=1
 S YY=$P(Y," ",1),YY=$P(YY,",",1),YY=$P(YY,")",1),YY=$P(YY,":",1)
 S:YY]"" ^UTILITY("XBRSRCH",$J,YY)=""
 Q
 ;
