GMP1I002 ; ; 01-SEP-1995
 ;;2.0;Problem List;**3**;AUG 25, 1994
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OR",270,0)
 ;;=270^GMP1
 ;;^UTILITY(U,$J,"OR",270,1,0)
 ;;=^100.9951PA^5^5
 ;;^UTILITY(U,$J,"OR",270,1,1,0)
 ;;=GMPL MENU CREATE GROUP
 ;;^UTILITY(U,$J,"OR",270,1,2,0)
 ;;=GMPL MENU RESEQUENCE GROUPS
 ;;^UTILITY(U,$J,"OR",270,1,3,0)
 ;;=GMPL MENU RESEQUENCE PROBLEMS
 ;;^UTILITY(U,$J,"OR",270,1,4,0)
 ;;=GMPL MENU VIEW GROUP
 ;;^UTILITY(U,$J,"OR",270,1,5,0)
 ;;=GMPL MENU VIEW LIST
 ;;^UTILITY(U,$J,"OR",270,5,0)
 ;;=^100.9955^^0
 ;;^UTILITY(U,$J,"PKG",270,0)
 ;;=Problem List^GMP1^For use with GMP*2*3 (Problem List Allocation Errors)
 ;;^UTILITY(U,$J,"PKG",270,1,0)
 ;;=^^2^2^2950901^^^^
 ;;^UTILITY(U,$J,"PKG",270,1,1,0)
 ;;=This patch corrects numerous problems with local arrays and also precludes
 ;;^UTILITY(U,$J,"PKG",270,1,2,0)
 ;;=duplicate entries to the problem list using scannable encounter forms.
 ;;^UTILITY(U,$J,"PKG",270,4,0)
 ;;=^9.44PA^1^1
 ;;^UTILITY(U,$J,"PKG",270,4,1,0)
 ;;=125.99
 ;;^UTILITY(U,$J,"PKG",270,4,1,1,0)
 ;;=^9.45A^1^1
 ;;^UTILITY(U,$J,"PKG",270,4,1,1,1,0)
 ;;=SCREEN DUPLICATE ENTRIES
 ;;^UTILITY(U,$J,"PKG",270,4,1,1,"B","SCREEN DUPLICATE ENTRIES",1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",270,4,1,222)
 ;;=y^y^^n^^^n
 ;;^UTILITY(U,$J,"PKG",270,4,"B",125.99,1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",270,5)
 ;;=SLC
 ;;^UTILITY(U,$J,"PKG",270,7)
 ;;=SLC^^I
 ;;^UTILITY(U,$J,"PKG",270,22,0)
 ;;=^9.49I^1^1
 ;;^UTILITY(U,$J,"PKG",270,22,1,0)
 ;;=2.0^2940825
 ;;^UTILITY(U,$J,"PKG",270,22,"B","2.0",1)
 ;;=
 ;;^UTILITY(U,$J,"PKG",270,"DEV")
 ;;=MJC-DJP/ISC-SLC
 ;;^UTILITY(U,$J,"PKG",270,"INIT")
 ;;=GMP1POST^
 ;;^UTILITY(U,$J,"PKG",270,"PRE")
 ;;=GMP1PRE^
 ;;^UTILITY(U,$J,"SBF",125.99,125.99)
 ;;=
