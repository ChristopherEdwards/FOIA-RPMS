XPARDD2 ;SLC/KCM - DD Logic for Parameter Template (8989.52) [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**26**;Apr 25, 1995
 ;
VALID01 ; -- Input transform for NAME (8989.51,.01), prevent duplicate names
 ; ( Need to figure out how to check for duplicates and have verify
 ;   fields still work )
 I $L(X)>30!($L(X)<3)!'(X'?1P.E) K X Q  ; Length 3-30
 I X'?2A.E K X Q                        ; Must begin with namespace
 I $D(^XTV(8989.52,"B",X)) D  Q         ; No duplicates
 . K X D EN^DDIOL("Duplicate template names not allowed.")
 Q
