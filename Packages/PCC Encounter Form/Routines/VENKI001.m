VENKI001 ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQ(19707.11)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(19707.11,0,"GL")
 ;;=^VEN(7.11,
 ;;^DIC("B","VEN EHP KB CATEGORY",19707.11)
 ;;=
 ;;^DIC(19707.11,"%D",0)
 ;;=^^1^1^3050509^^^^
 ;;^DIC(19707.11,"%D",1,0)
 ;;=KNOWLEDGEBASE CATEGORY.  Ea. category can have multiple items.
 ;;^DD(19707.11,0)
 ;;=FIELD^^5.02^22
 ;;^DD(19707.11,0,"DDA")
 ;;=N
 ;;^DD(19707.11,0,"DT")
 ;;=3051227
 ;;^DD(19707.11,0,"IX","B",19707.11,.01)
 ;;=
 ;;^DD(19707.11,0,"NM","VEN EHP KB CATEGORY")
 ;;=
 ;;^DD(19707.11,0,"PT",19707.12,.01)
 ;;=
 ;;^DD(19707.11,0,"PT",19707.131,.01)
 ;;=
 ;;^DD(19707.11,0,"PT",19707.41,.19)
 ;;=
 ;;^DD(19707.11,0,"PT",19707.4116,.01)
 ;;=
 ;;^DD(19707.11,0,"VRPK")
 ;;=PCC+A
 ;;^DD(19707.11,.01,0)
 ;;=NAME^RF^^0;1^K:$L(X)>40!($L(X)<3)!'(X'?1P.E) X
 ;;^DD(19707.11,.01,1,0)
 ;;=^.1
 ;;^DD(19707.11,.01,1,1,0)
 ;;=19707.11^B
 ;;^DD(19707.11,.01,1,1,1)
 ;;=S ^VEN(7.11,"B",$E(X,1,30),DA)=""
 ;;^DD(19707.11,.01,1,1,2)
 ;;=K ^VEN(7.11,"B",$E(X,1,30),DA)
 ;;^DD(19707.11,.01,3)
 ;;=Answer must be 3-40 characters in length.
 ;;^DD(19707.11,.01,"DT")
 ;;=3050914
 ;;^DD(19707.11,.02,0)
 ;;=MNEMONIC^F^^0;2^K:$L(X)>5!($L(X)<1) X
 ;;^DD(19707.11,.02,3)
 ;;=Answer must be 1-5 characters in length.
 ;;^DD(19707.11,.02,"DT")
 ;;=3050304
 ;;^DD(19707.11,.03,0)
 ;;=USE EXTERNAL CODE^S^1:YES;0:NO;^0;3^Q
 ;;^DD(19707.11,.03,"DT")
 ;;=3050304
 ;;^DD(19707.11,.04,0)
 ;;=ASK IF ACTIVE^S^1:YES;0:NO;^0;4^Q
 ;;^DD(19707.11,.04,"DT")
 ;;=3050304
 ;;^DD(19707.11,.05,0)
 ;;=SCREEN BY AGE RANGE^S^1:YES;0:NO;^0;5^Q
 ;;^DD(19707.11,.05,"DT")
 ;;=3050304
 ;;^DD(19707.11,.06,0)
 ;;=SCREEN BY WKS GESTATION^S^1:YES;0:NO;^0;6^Q
 ;;^DD(19707.11,.06,"DT")
 ;;=3050304
 ;;^DD(19707.11,.07,0)
 ;;=SCREEN BY TIME SINCE LAST^S^1:YES;0:NO;^0;7^Q
 ;;^DD(19707.11,.07,"DT")
 ;;=3050304
 ;;^DD(19707.11,.08,0)
 ;;=SCREEN BY GENDER^S^1:YES;0:NO;^0;8^Q
 ;;^DD(19707.11,.08,"DT")
 ;;=3050304
 ;;^DD(19707.11,.09,0)
 ;;=COLUMN HEADER^F^^0;9^K:$L(X)>60!($L(X)<1) X
 ;;^DD(19707.11,.09,3)
 ;;=Answer must be 1-60 characters in length.
 ;;^DD(19707.11,.09,"DT")
 ;;=3050913
 ;;^DD(19707.11,.1,0)
 ;;=TIME UNITS^S^D:DAY;W:WEEK;M:MONTH;Y:YEAR;^0;10^Q
 ;;^DD(19707.11,.1,"DT")
 ;;=3050308
 ;;^DD(19707.11,.11,0)
 ;;=TYPE^S^1:PATIENT ED;2:DEVEL EXAM;3:SPECIAL RISK SCREENING;4:PHYSICAL EXAM;5:TESTS AND MEASUREMENTS;6:NUTRITION;7:BEHAVIORAL HEALTH SCREENING;8:GENERAL HEALTH SCREENING;^0;11^Q
 ;;^DD(19707.11,.11,"DT")
 ;;=3051227
 ;;^DD(19707.11,.12,0)
 ;;=PATIENT ED CODE GROUP^F^^0;12^K:$L(X)>6!($L(X)<1) X
 ;;^DD(19707.11,.12,3)
 ;;=Answer must be 1-6 characters in length.
 ;;^DD(19707.11,.12,"DT")
 ;;=3051128
 ;;^DD(19707.11,.13,0)
 ;;=PT ED TOPIC MNEMONIC^F^^0;13^K:$L(X)>6!($L(X)<1) X
 ;;^DD(19707.11,.13,3)
 ;;=Answer must be 1-6 characters in length.
 ;;^DD(19707.11,.13,"DT")
 ;;=3051128
 ;;^DD(19707.11,1,0)
 ;;=SCREEN BY CUSTOM LOGIC (EP)^F^^1;E1,245^K:$L(X)>240!($L(X)<1) X
 ;;^DD(19707.11,1,3)
 ;;=Answer must be 1-240 characters in length.
 ;;^DD(19707.11,1,"DT")
 ;;=3050304
 ;;^DD(19707.11,2,0)
 ;;=DESCRIPTION^19707.112^^2;0
 ;;^DD(19707.11,3,0)
 ;;=RPC CALL^F^^3;E1,245^K:$L(X)>240!($L(X)<1) X
 ;;^DD(19707.11,3,3)
 ;;=Answer must be 1-240 characters in length.
 ;;^DD(19707.11,3,"DT")
 ;;=3050304
 ;;^DD(19707.11,4.01,0)
 ;;=V FILE^P1'^DIC(^4;1^Q
 ;;^DD(19707.11,4.01,"DT")
 ;;=3051118
 ;;^DD(19707.11,4.02,0)
 ;;=ITEM FIELD^NJ16,6^^4;2^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."7N.N) X
 ;;^DD(19707.11,4.02,3)
 ;;=Type a Number between 0 and 999999999, 6 Decimal Digits
 ;;^DD(19707.11,4.02,"DT")
 ;;=3051118
 ;;^DD(19707.11,4.03,0)
 ;;=REFERENCE FILE^P1'^DIC(^4;3^Q
 ;;^DD(19707.11,4.03,"DT")
 ;;=3051118
 ;;^DD(19707.11,4.04,0)
 ;;=RESULT FIELD^NJ16,6^^4;4^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."7N.N) X
 ;;^DD(19707.11,4.04,3)
 ;;=Type a Number between 0 and 999999999, 6 Decimal Digits
 ;;^DD(19707.11,4.04,21,0)
 ;;=^^2^2^3051118^
 ;;^DD(19707.11,4.04,21,1,0)
 ;;=If the item has a result, this is the field number is the V-File
 ;;^DD(19707.11,4.04,21,2,0)
 ;;=(or V-File subfile) that contains the result.
 ;;^DD(19707.11,4.04,"DT")
 ;;=3051118
 ;;^DD(19707.11,5.01,0)
 ;;=SECONDARY V FILE^P1'^DIC(^5;1^Q
 ;;^DD(19707.11,5.01,3)
 ;;=
 ;;^DD(19707.11,5.01,"DT")
 ;;=3051130
 ;;^DD(19707.11,5.02,0)
 ;;=SECONDARY FIELD^NJ16,6^^5;2^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."7N.N) X
 ;;^DD(19707.11,5.02,3)
 ;;=Type a Number between 0 and 999999999, 6 Decimal Digits
 ;;^DD(19707.11,5.02,"DT")
 ;;=3051125
 ;;^DD(19707.112,0)
 ;;=DESCRIPTION SUB-FIELD^^.01^1
 ;;^DD(19707.112,0,"DT")
 ;;=3050304
 ;;^DD(19707.112,0,"NM","DESCRIPTION")
 ;;=
 ;;^DD(19707.112,0,"UP")
 ;;=19707.11
 ;;^DD(19707.112,.01,0)
 ;;=DESCRIPTION^W^^0;1^Q
 ;;^DD(19707.112,.01,"DT")
 ;;=3050304
