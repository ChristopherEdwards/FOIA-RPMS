PSGWI046 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"PKG",115,4,12,1,"B","AR/WS VERSION",9)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,12,1,"B","BACKORDER CONVERSION",5)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,12,1,"B","DATE INSTALLED",4)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,12,1,"B","MULTI-DIVISION CONVERSION",6)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,12,1,"B","RETURN REASON CONVERSION",8)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,12,1,"B","SITE NAME",3)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,12,1,"B","WARD (for %) CONVERSION",7)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,12,222)
 ;;=y^y^^y^^^n^^y
 ;;^UTILITY(U,$J,"PKG",115,4,"B",50,11)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,"B",58.1,1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,"B",58.16,3)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,"B",58.17,4)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,"B",58.19,5)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,"B",58.2,2)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,"B",58.3,6)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,"B",58.5,10)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,"B",59.4,8)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,4,"B",59.7,12)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,5)
 ;;=BIRMINGHAM
 ;;^UTILITY(U,$J,"PKG",115,7)
 ;;=^^I
 ;;^UTILITY(U,$J,"PKG",115,11)
 ;;=50^60
 ;;^UTILITY(U,$J,"PKG",115,22,0)
 ;;=^9.49I^2.6^13
 ;;^UTILITY(U,$J,"PKG",115,22,1.1,0)
 ;;=1.1^2880503^2880321
 ;;^UTILITY(U,$J,"PKG",115,22,1.12,0)
 ;;=1.12^2880505
 ;;^UTILITY(U,$J,"PKG",115,22,2,0)
 ;;=2^2900329^2900329
 ;;^UTILITY(U,$J,"PKG",115,22,2.02,0)
 ;;=2.02^2900209^2891003
 ;;^UTILITY(U,$J,"PKG",115,22,2.03,0)
 ;;=2.03^2900228^2900214
 ;;^UTILITY(U,$J,"PKG",115,22,2.04,0)
 ;;=2.04^2900320^2900321
 ;;^UTILITY(U,$J,"PKG",115,22,2.1,0)
 ;;=2.1^2901019^2901017
 ;;^UTILITY(U,$J,"PKG",115,22,2.12,0)
 ;;=2.12^2910221^2910226
 ;;^UTILITY(U,$J,"PKG",115,22,2.2,0)
 ;;=2.2^2910326^2910326
 ;;^UTILITY(U,$J,"PKG",115,22,2.3,0)
 ;;=2.3^2940104^2930405
 ;;^UTILITY(U,$J,"PKG",115,22,2.4,0)
 ;;=2.3T2^2930722
 ;;^UTILITY(U,$J,"PKG",115,22,2.5,0)
 ;;=2.3T3^2930817
 ;;^UTILITY(U,$J,"PKG",115,22,2.6,0)
 ;;=2.3V1^2930830
 ;;^UTILITY(U,$J,"PKG",115,22,"B",1.1,1.1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B",1.12,1.12)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B",2,2)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B",2.02,2.02)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B",2.03,2.03)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B",2.04,2.04)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B",2.1,2.1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B",2.12,2.12)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B",2.2,2.2)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B",2.3,2.3)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B","2.3T2",2.4)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B","2.3T3",2.5)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,22,"B","2.3V1",2.6)
 ;;=
 ;;^UTILITY(U,$J,"PKG",115,"DEV")
 ;;=KELLY ALLEN/BHAM ISC
 ;;^UTILITY(U,$J,"PKG",115,"DIE",0)
 ;;=^9.47^^0
 ;;^UTILITY(U,$J,"PKG",115,"DIPT",0)
 ;;=^9.46^^0
 ;;^UTILITY(U,$J,"PKG",115,"INIT")
 ;;=PSGWPOST^
 ;;^UTILITY(U,$J,"PKG",115,"PRE")
 ;;=PSGWPRE1^
 ;;^UTILITY(U,$J,"PKG",115,"ST",0)
 ;;=^9.444D
 ;;^UTILITY(U,$J,"SBF",50,50)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.1,58.1)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.1,58.11)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.1,58.12)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.1,58.13)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.1,58.14)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.1,58.15)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.1,58.26)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.1,58.27)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.1,58.28)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.16,58.16)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.16,58.18)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.17,58.17)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.19,58.19)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.19,58.24)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.19,58.25)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.2,58.2)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.2,58.21)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.2,58.22)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.2,58.23)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.2,58.29)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.2,58.291)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.3,58.3)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.3,58.31)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.3,58.32)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.5,58.5)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.5,58.501)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.5,58.51)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.5,58.52)
 ;;=
 ;;^UTILITY(U,$J,"SBF",58.5,58.53)
 ;;=
 ;;^UTILITY(U,$J,"SBF",59.4,59.4)
 ;;=
 ;;^UTILITY(U,$J,"SBF",59.7,59.7)
 ;;=