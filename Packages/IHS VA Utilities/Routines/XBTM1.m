XBTM1 ; IHS/ADC/GTH - TECH MANUAL : Facility Parameters ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A,B,C
 F A=1:1 S X=$P($T(PR+A),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D DIWW
 Q
 ;
DIWW NEW A,B,C D ^DIWW Q
PR(X) NEW A,B,C D PR^XBTM(X) Q
 ;;There are no facility parameters for this package.
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;###
 ;
