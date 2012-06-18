XBTMPR ; IHS/ADC/GTH - TECH MANUAL : PREFACE ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 NEW XBCTR
 F XBCTR=1:1 S X=$P($T(PREFACE+XBCTR),";;",2) Q:X=""  D PR^XBTM(X)
 D ^DIWW
 Q
 ;
PREFACE ;;
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB|PREFACE 
 ;; 
 ;;This document is designed primarily for RPMS application
 ;;programmers.  Area and site IRM personnel can find this
 ;;document helpful in understanding how the XB/ZIB utility
 ;;routines operate.  
 ;; 
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB|INTRODUCTION 
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
 ;;The IHS/VA UTILITIES are in the XB
 ;;namespace, for routines that are not MUMPS
 ;;implementation specific.  Routines that are implementation specific
 ;;will be in the ZIB namespace.
 ;; 
 ;;Programmer tools are available from programmer mode thru the
 ;;menu-driver routine XB.
 ;;   
 ;;There are no files associated with this package.
 ;;     
 ;;To aid in your reading the routines, if required, the following
 ;;style guidelines have been followed in most of the routines.
 ;;|SETTAB("C")||TAB| 
 ;;    (1)  all NEW and KILL commands are not abbreviated;
 ;;|SETTAB("C")||TAB| 
 ;;    (2)  only one command scope per line;
 ;;|SETTAB("C")||TAB| 
 ;;    (3)  unconditional GOs/QUITs are followed by a comment line;
 ;;|SETTAB("C")||TAB| 
 ;;    (4)  lines with labels have no executable code;
 ;;|SETTAB("C")||TAB| 
 ;;|SETTAB("C")||TAB| 
