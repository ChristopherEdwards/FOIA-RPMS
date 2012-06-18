XBTM10 ; IHS/ADC/GTH - TECH MANUAL : ONLINE DOC ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW A
 F A=1:1 S X=$P($T(PR+A),";;",2) Q:X="###"  D PR(X) Q:$D(DUOUT)
 Q:$D(DUOUT)
 D ^DIWW
 Q
 ;
PR(X) NEW A D PR^XBTM(X) Q
 ;;The package
 ;;documentation presented in this manual is extensive and should 
 ;;provide most site managers, ISC staff members, and developers
 ;;with sufficient information.
 ;;|SETTAB("C")||TAB| 
 ;;This manual can be generated from programmer mode by DO'ing
 ;;^XBTM.  This is a cpu-intensive routine.  Please q to TaskMan
 ;;to run after hours, and expect approximately 150 pages of output.
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;###
