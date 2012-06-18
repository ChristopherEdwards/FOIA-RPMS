XBTM9 ; IHS/ADC/GTH - TECH MANUAL : INTERNAL RELATIONS ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A
 F A=1:1 S X=$P($T(PR+A),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 Q
 ;
PR(X) NEW A D PR^XBTM(X) Q
 ;;XB/ZIB contains routines and entry points that are for use
 ;;both interactively by programmers, and as calls from applications.
 ;;The XB menu can be accessed from programmer mode thru routine XB,
 ;;i.e., DO ^XB.
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;###
