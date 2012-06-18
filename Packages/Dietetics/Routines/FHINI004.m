FHINI004	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(111.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(111.1,0,"GL")
	;;=^FH(111.1,
	;;^DIC("B","DIET PATTERNS",111.1)
	;;=
	;;^DIC(111.1,"%D",0)
	;;=^^2^2^2940121^
	;;^DIC(111.1,"%D",1,0)
	;;=This file contains diet patterns.  The entries for a specific pattern
	;;^DIC(111.1,"%D",2,0)
	;;=represent changes from the production diet for this particular pattern.
	;;^DD(111.1,0)
	;;=FIELD^^19^15
	;;^DD(111.1,0,"DDA")
	;;=N
	;;^DD(111.1,0,"DT")
	;;=2950418
	;;^DD(111.1,0,"IX","B",111.1,.01)
	;;=
	;;^DD(111.1,0,"NM","DIET PATTERNS")
	;;=
	;;^DD(111.1,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>70!($L(X)<3)!'(X'?1P.E) X
	;;^DD(111.1,.01,1,0)
	;;=^.1
	;;^DD(111.1,.01,1,1,0)
	;;=111.1^B
	;;^DD(111.1,.01,1,1,1)
	;;=S ^FH(111.1,"B",$E(X,1,30),DA)=""
	;;^DD(111.1,.01,1,1,2)
	;;=K ^FH(111.1,"B",$E(X,1,30),DA)
	;;^DD(111.1,.01,3)
	;;=Answer must be 3-70 characters in length.
	;;^DD(111.1,.01,21,0)
	;;=^^1^1^2940721^^^^
	;;^DD(111.1,.01,21,1,0)
	;;=This field contains the names of the diet or the diet modification ordered.
	;;^DD(111.1,.01,"DT")
	;;=2940103
	;;^DD(111.1,1,0)
	;;=DIET1^P111'^FH(111,^0;2^Q
	;;^DD(111.1,1,21,0)
	;;=^^2^2^2940526^^^^
	;;^DD(111.1,1,21,1,0)
	;;=This is the first diet modification selected from the Diets (111)
	;;^DD(111.1,1,21,2,0)
	;;=file.
	;;^DD(111.1,1,"DT")
	;;=2931130
	;;^DD(111.1,2,0)
	;;=DIET2^P111'^FH(111,^0;3^Q
	;;^DD(111.1,2,21,0)
	;;=^^2^2^2940526^^
	;;^DD(111.1,2,21,1,0)
	;;=This is the second diet modification selected from the Diets (111)
	;;^DD(111.1,2,21,2,0)
	;;=file.
	;;^DD(111.1,2,"DT")
	;;=2931130
	;;^DD(111.1,3,0)
	;;=DIET3^P111'^FH(111,^0;4^Q
	;;^DD(111.1,3,21,0)
	;;=^^2^2^2940526^
	;;^DD(111.1,3,21,1,0)
	;;=This is the third diet modification selected from the Diets (111)
	;;^DD(111.1,3,21,2,0)
	;;=file.
	;;^DD(111.1,3,"DT")
	;;=2931130
	;;^DD(111.1,4,0)
	;;=DIET4^P111'^FH(111,^0;5^Q
	;;^DD(111.1,4,21,0)
	;;=^^2^2^2940526^
	;;^DD(111.1,4,21,1,0)
	;;=This is the fourth diet modification selected from the Diets (111)
	;;^DD(111.1,4,21,2,0)
	;;=file.
	;;^DD(111.1,4,"DT")
	;;=2931130
	;;^DD(111.1,5,0)
	;;=DIET5^P111'^FH(111,^0;6^Q
	;;^DD(111.1,5,21,0)
	;;=^^2^2^2940526^
	;;^DD(111.1,5,21,1,0)
	;;=This is the fifth diet modification selected from the Diets (111)
	;;^DD(111.1,5,21,2,0)
	;;=file.
	;;^DD(111.1,5,"DT")
	;;=2931130
	;;^DD(111.1,10,0)
	;;=PRODUCTION DIET^P116.2'^FH(116.2,^0;7^Q
	;;^DD(111.1,10,21,0)
	;;=^^4^4^2950707^^
	;;^DD(111.1,10,21,1,0)
	;;=This is a pointer to the Production Diet (116.2) file and is the
	;;^DD(111.1,10,21,2,0)
	;;=outcome of the 'diet recoding' algorithm which is based upon the
	;;^DD(111.1,10,21,3,0)
	;;=diet modifications selected.  It is not present for NPO types of
	;;^DD(111.1,10,21,4,0)
	;;=orders.
	;;^DD(111.1,10,"DT")
	;;=2931130
	;;^DD(111.1,15,0)
	;;=BREAKFAST MODIFICATIONS^111.115P^^B;0
	;;^DD(111.1,15,21,0)
	;;=^^2^2^2950403^^^^
	;;^DD(111.1,15,21,1,0)
	;;=This multiple contains all the breakfast Recipe Categories selected
	;;^DD(111.1,15,21,2,0)
	;;=and their quantities.
	;;^DD(111.1,15.5,0)
	;;=ASSOCIATED STANDING ORDERS (B)^111.11P^^BS;0
	;;^DD(111.1,15.5,21,0)
	;;=^^2^2^2950717^^^^
	;;^DD(111.1,15.5,21,1,0)
	;;=This multiple contains all the Standing Orders selected from file
	;;^DD(111.1,15.5,21,2,0)
	;;=118.3 for breakfast.
	;;^DD(111.1,15.5,"DT")
	;;=2940721
	;;^DD(111.1,16,0)
	;;=NOON MODIFICATIONS^111.116P^^N;0
	;;^DD(111.1,16,21,0)
	;;=^^2^2^2940526^
	;;^DD(111.1,16,21,1,0)
	;;=This multiple contains all the noon Recipe Categories selected
	;;^DD(111.1,16,21,2,0)
	;;=and their quantities.
	;;^DD(111.1,16.5,0)
	;;=ASSOCIATED STANDING ORDERS (N)^111.12P^^NS;0
	;;^DD(111.1,16.5,21,0)
	;;=^^2^2^2940721^
	;;^DD(111.1,16.5,21,1,0)
	;;=This multiple contains all the Standing Orders selected from file 118.3
	;;^DD(111.1,16.5,21,2,0)
	;;=for noon.
	;;^DD(111.1,16.5,"DT")
	;;=2940721
	;;^DD(111.1,17,0)
	;;=EVENING MODIFICATIONS^111.117P^^E;0
	;;^DD(111.1,17,21,0)
	;;=^^2^2^2940526^^
	;;^DD(111.1,17,21,1,0)
	;;=This multiple contains all the evening Recipe Categories selected
	;;^DD(111.1,17,21,2,0)
	;;=and their quantities.
	;;^DD(111.1,17.5,0)
	;;=ASSOCIATED STANDING ORDERS (E)^111.13P^^ES;0
	;;^DD(111.1,17.5,21,0)
	;;=^^2^2^2950717^^
	;;^DD(111.1,17.5,21,1,0)
	;;=This multiple contains all the Standing Orders selected from file
	;;^DD(111.1,17.5,21,2,0)
	;;=118.3 for evening.
	;;^DD(111.1,17.5,"DT")
	;;=2940721
	;;^DD(111.1,18,0)
	;;=ASSOCIATED SF MENU^*P118.1'^FH(118.1,^0;8^S DIC("S")="I Y'=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(111.1,18,12)
	;;=Cannot enter INDIVIDUALIZED Supplemental Menu
	;;^DD(111.1,18,12.1)
	;;=S DIC("S")="I Y'=1"
	;;^DD(111.1,18,21,0)
	;;=^^3^3^2950717^^^^
	;;^DD(111.1,18,21,1,0)
	;;=This field will contain the Supplemental Feeding Menu, from file 118.1,
