GMP1I001 ; ; 01-SEP-1995
 ;;2.0;Problem List;**3**;AUG 25, 1994
 Q:'DIFQ(125.99)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(125.99,0,"GL")
 ;;=^GMPL(125.99,
 ;;^DIC("B","PROBLEM LIST SITE PARAMETERS",125.99)
 ;;=
 ;;^DIC(125.99,"%D",0)
 ;;=^^4^4^2940517^^^^
 ;;^DIC(125.99,"%D",1,0)
 ;;=This file controls the behavior of the Problem List application for each
 ;;^DIC(125.99,"%D",2,0)
 ;;=site where it is installed.
 ;;^DIC(125.99,"%D",3,0)
 ;;=  
 ;;^DIC(125.99,"%D",4,0)
 ;;=There should be only one entry in this file!!
 ;;^DD(125.99,0)
 ;;=FIELD^^6^7
 ;;^DD(125.99,0,"DDA")
 ;;=N
 ;;^DD(125.99,0,"DT")
 ;;=2950901
 ;;^DD(125.99,0,"IX","B",125.99,.01)
 ;;=
 ;;^DD(125.99,0,"NM","PROBLEM LIST SITE PARAMETERS")
 ;;=
 ;;^DD(125.99,.01,0)
 ;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
 ;;^DD(125.99,.01,1,0)
 ;;=^.1
 ;;^DD(125.99,.01,1,1,0)
 ;;=125.99^B
 ;;^DD(125.99,.01,1,1,1)
 ;;=S ^GMPL(125.99,"B",$E(X,1,30),DA)=""
 ;;^DD(125.99,.01,1,1,2)
 ;;=K ^GMPL(125.99,"B",$E(X,1,30),DA)
 ;;^DD(125.99,.01,3)
 ;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
 ;;^DD(125.99,.01,21,0)
 ;;=^^1^1^2930401^
 ;;^DD(125.99,.01,21,1,0)
 ;;=This is the name of the site, commonly HOSPITAL or VAMC.
 ;;^DD(125.99,6,0)
 ;;=SCREEN DUPLICATE ENTRIES^S^1:YES;^0;6^Q
 ;;^DD(125.99,6,3)
 ;;=Enter '1' or 'YES' and non-interactive duplicate problems will be screened.
 ;;^DD(125.99,6,21,0)
 ;;=^^3^3^2950901^^
 ;;^DD(125.99,6,21,1,0)
 ;;=If YES is entered in this field duplicate problems (those having the same 
 ;;^DD(125.99,6,21,2,0)
 ;;=ICD9 code) will NOT be added to the problem list.  The primary purpose of
 ;;^DD(125.99,6,21,3,0)
 ;;=this field in to screen entries added via the scannable encounter form.
 ;;^DD(125.99,6,23,0)
 ;;=^^5^5^2950901^
 ;;^DD(125.99,6,23,1,0)
 ;;=This field is being added with GMP*2*3 to preclude duplicate entries from
 ;;^DD(125.99,6,23,2,0)
 ;;=being entered on the problem list, primarily via the scannable encounter
 ;;^DD(125.99,6,23,3,0)
 ;;=form.  This parameter does NOT impact the interactive entry of problems
 ;;^DD(125.99,6,23,4,0)
 ;;=using the Problem List menu options.  Clinicians may continue to overide
 ;;^DD(125.99,6,23,5,0)
 ;;=the duplicate entry warning when working the list.
 ;;^DD(125.99,6,"DT")
 ;;=2950901
