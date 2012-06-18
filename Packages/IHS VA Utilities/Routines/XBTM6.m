XBTM6 ; IHS/ADC/GTH - TECH MANUAL : ARCHIVING & PURGING ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A
 F A=1:1 S X=$P($T(PR+A),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 Q
 ;
PR(X) NEW A D PR^XBTM(X) Q
 ;;At the present time there are no
 ;;archiving and/or purging capabilities with this package.  
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;###
