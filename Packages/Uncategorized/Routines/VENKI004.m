VENKI004 ; ; 16-MAR-2007
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQ(19707.12)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(19707.12,0,"GL")
 ;;=^VEN(7.12,
 ;;^DIC("B","VEN EHP KB ITEM",19707.12)
 ;;=
 ;;^DIC(19707.12,"%D",0)
 ;;=^^2^2^3051118^^^^
 ;;^DIC(19707.12,"%D",1,0)
 ;;=Items can be guidelines, patient ed topics or clinical tasks.
 ;;^DIC(19707.12,"%D",2,0)
 ;;=Items are filtered by demographics, time and clinical hx
 ;;^DD(19707.12,0)
 ;;=FIELD^^2.04^21
 ;;^DD(19707.12,0,"DDA")
 ;;=N
 ;;^DD(19707.12,0,"DT")
 ;;=3060306
 ;;^DD(19707.12,0,"IX","AC",19707.12,2.03)
 ;;=
 ;;^DD(19707.12,0,"IX","B",19707.12,.01)
 ;;=
 ;;^DD(19707.12,0,"IX","C",19707.12,.02)
 ;;=
 ;;^DD(19707.12,0,"NM","VEN EHP KB ITEM")
 ;;=
 ;;^DD(19707.12,0,"PT",19707.16,.03)
 ;;=
 ;;^DD(19707.12,0,"PT",9000010.461,.01)
 ;;=
 ;;^DD(19707.12,0,"PT",9000010.463,.01)
 ;;=
 ;;^DD(19707.12,0,"VRPK")
 ;;=PCC+A
 ;;^DD(19707.12,.01,0)
 ;;=TYPE^RP19707.11'^VEN(7.11,^0;1^Q
 ;;^DD(19707.12,.01,1,0)
 ;;=^.1
 ;;^DD(19707.12,.01,1,1,0)
 ;;=19707.12^B
 ;;^DD(19707.12,.01,1,1,1)
 ;;=S ^VEN(7.12,"B",$E(X,1,30),DA)=""
 ;;^DD(19707.12,.01,1,1,2)
 ;;=K ^VEN(7.12,"B",$E(X,1,30),DA)
 ;;^DD(19707.12,.01,3)
 ;;=
 ;;^DD(19707.12,.01,"DT")
 ;;=3050304
 ;;^DD(19707.12,.02,0)
 ;;=TITLE^F^^0;2^K:$L(X)>80!($L(X)<1) X
 ;;^DD(19707.12,.02,1,0)
 ;;=^.1
 ;;^DD(19707.12,.02,1,1,0)
 ;;=19707.12^C
 ;;^DD(19707.12,.02,1,1,1)
 ;;=S ^VEN(7.12,"C",$E(X,1,30),DA)=""
 ;;^DD(19707.12,.02,1,1,2)
 ;;=K ^VEN(7.12,"C",$E(X,1,30),DA)
 ;;^DD(19707.12,.02,1,1,"DT")
 ;;=3050503
 ;;^DD(19707.12,.02,3)
 ;;=Answer must be 1-80 characters in length.
 ;;^DD(19707.12,.02,"DT")
 ;;=3050503
 ;;^DD(19707.12,.03,0)
 ;;=INTERNAL CODE^F^^0;3^K:$L(X)>14!($L(X)<1) X
 ;;^DD(19707.12,.03,3)
 ;;=Answer must be 1-14 characters in length.
 ;;^DD(19707.12,.03,"DT")
 ;;=3051114
 ;;^DD(19707.12,.04,0)
 ;;=EXTERNAL CODE^F^^0;4^K:$L(X)>16!($L(X)<1) X
 ;;^DD(19707.12,.04,3)
 ;;=Answer must be 1-16 characters in length.
 ;;^DD(19707.12,.04,"DT")
 ;;=3050304
 ;;^DD(19707.12,.05,0)
 ;;=START AGE^NJ8,2^^0;5^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."3N.N) X
 ;;^DD(19707.12,.05,3)
 ;;=Type a Number between 0 and 99999, 2 Decimal Digits
 ;;^DD(19707.12,.05,5,1,0)
 ;;=19707.12^.13^1
 ;;^DD(19707.12,.05,"DT")
 ;;=3050913
 ;;^DD(19707.12,.06,0)
 ;;=STOP AGE^NJ8,2^^0;6^K:+X'=X!(X>99999)!(X<1)!(X?.E1"."3N.N) X
 ;;^DD(19707.12,.06,3)
 ;;=Type a Number between 1 and 99999, 2 Decimal Digits
 ;;^DD(19707.12,.06,5,1,0)
 ;;=19707.12^.14^1
 ;;^DD(19707.12,.06,"DT")
 ;;=3050304
 ;;^DD(19707.12,.07,0)
 ;;=START WKS GESTATION^NJ2,0^^0;7^K:+X'=X!(X>40)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(19707.12,.07,3)
 ;;=Type a Number between 1 and 40, 0 Decimal Digits
 ;;^DD(19707.12,.07,"DT")
 ;;=3050304
 ;;^DD(19707.12,.08,0)
 ;;=STOP WKS GESTATION^NJ2,0^^0;8^K:+X'=X!(X>50)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(19707.12,.08,3)
 ;;=Type a Number between 1 and 50, 0 Decimal Digits
 ;;^DD(19707.12,.08,"DT")
 ;;=3050901
 ;;^DD(19707.12,.09,0)
 ;;=SCHEDULING INTERVAL^NJ8,2^^0;9^K:+X'=X!(X>99999)!(X<1)!(X?.E1"."3N.N) X
 ;;^DD(19707.12,.09,3)
 ;;=Type a Number between 1 and 99999, 2 Decimal Digits
 ;;^DD(19707.12,.09,"DT")
 ;;=3050304
 ;;^DD(19707.12,.1,0)
 ;;=GENDER SCREEN^S^M:MALE;F:FEMALE;^0;10^Q
 ;;^DD(19707.12,.1,"DT")
 ;;=3050304
 ;;^DD(19707.12,.11,0)
 ;;=ACTIVE^S^1:NO;0:YES;^0;11^Q
 ;;^DD(19707.12,.11,"DT")
 ;;=3060131
 ;;^DD(19707.12,.12,0)
 ;;=MODIFIER TEXT^F^^0;12^K:$L(X)>60!($L(X)<1) X
 ;;^DD(19707.12,.12,3)
 ;;=Answer must be 1-60 characters in length.
 ;;^DD(19707.12,.12,"DT")
 ;;=3050309
 ;;^DD(19707.12,.13,0)
 ;;=EXTERNAL START AGE^NJ8,2^^0;13^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."3N.N) X
 ;;^DD(19707.12,.13,1,0)
 ;;=^.1
 ;;^DD(19707.12,.13,1,1,0)
 ;;=^^TRIGGER^19707.12^.05
 ;;^DD(19707.12,.13,1,1,1)
 ;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^VEN(7.12,D0,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X=DIV S X=$$TRIG^VENPCCK(X,DA,1) X ^DD(19707.12,.13,1,1,1.4)
 ;;^DD(19707.12,.13,1,1,1.4)
 ;;=S DIH=$S($D(^VEN(7.12,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,5)=DIV,DIH=19707.12,DIG=.05 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
 ;;^DD(19707.12,.13,1,1,2)
 ;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^VEN(7.12,D0,0)):^(0),1:"") S X=$P(Y(1),U,5),X=X S DIU=X K Y S X="" X ^DD(19707.12,.13,1,1,2.4)
 ;;^DD(19707.12,.13,1,1,2.4)
 ;;=S DIH=$S($D(^VEN(7.12,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,5)=DIV,DIH=19707.12,DIG=.05 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
 ;;^DD(19707.12,.13,1,1,"CREATE VALUE")
 ;;=S X=$$TRIG^VENPCCK(X,DA,1)
 ;;^DD(19707.12,.13,1,1,"DELETE VALUE")
 ;;=S X=""
 ;;^DD(19707.12,.13,1,1,"FIELD")
 ;;=START AGE
 ;;^DD(19707.12,.13,3)
 ;;=Type a Number between 0 and 99999, 2 Decimal Digits
 ;;^DD(19707.12,.13,"DT")
 ;;=3050309
 ;;^DD(19707.12,.14,0)
 ;;=EXTERNAL STOP AGE^NJ8,2^^0;14^K:+X'=X!(X>99999)!(X<0)!(X?.E1"."3N.N) X
 ;;^DD(19707.12,.14,1,0)
 ;;=^.1
 ;;^DD(19707.12,.14,1,1,0)
 ;;=^^TRIGGER^19707.12^.06
 ;;^DD(19707.12,.14,1,1,1)
 ;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^VEN(7.12,D0,0)):^(0),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X=DIV S X=$$TRIG^VENPCCK(X,DA,2) X ^DD(19707.12,.14,1,1,1.4)
 ;;^DD(19707.12,.14,1,1,1.4)
 ;;=S DIH=$S($D(^VEN(7.12,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,6)=DIV,DIH=19707.12,DIG=.06 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
 ;;^DD(19707.12,.14,1,1,2)
 ;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^VEN(7.12,D0,0)):^(0),1:"") S X=$P(Y(1),U,6),X=X S DIU=X K Y S X="" X ^DD(19707.12,.14,1,1,2.4)
 ;;^DD(19707.12,.14,1,1,2.4)
 ;;=S DIH=$S($D(^VEN(7.12,DIV(0),0)):^(0),1:""),DIV=X S $P(^(0),U,6)=DIV,DIH=19707.12,DIG=.06 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
 ;;^DD(19707.12,.14,1,1,"CREATE VALUE")
 ;;=S X=$$TRIG^VENPCCK(X,DA,2)
 ;;^DD(19707.12,.14,1,1,"DELETE VALUE")
 ;;=S X=""
 ;;^DD(19707.12,.14,1,1,"DT")
 ;;=3050309
 ;;^DD(19707.12,.14,1,1,"FIELD")
 ;;=STOP AGE
 ;;^DD(19707.12,.14,3)
 ;;=Type a Number between 0 and 99999, 2 Decimal Digits
 ;;^DD(19707.12,.14,"DT")
 ;;=3050309
 ;;^DD(19707.12,.15,0)
 ;;=ICD TAXONOMY^P9002226'^ATXAX(^0;15^Q
 ;;^DD(19707.12,.15,"DT")
 ;;=3050331
 ;;^DD(19707.12,.16,0)
 ;;=SORT LIST BY MODIFER VALUE^S^1:YES;0:NO;^0;16^Q
 ;;^DD(19707.12,.16,"DT")
 ;;=3051114
 ;;^DD(19707.12,1,0)
 ;;=SPECIAL SCREENING LOGIC (EP)^F^^1;E1,245^K:$L(X)>240!($L(X)<1) X
 ;;^DD(19707.12,1,3)
 ;;=Answer must be 1-240 characters in length.
 ;;^DD(19707.12,1,"DT")
 ;;=3050304
 ;;^DD(19707.12,2.01,0)
 ;;=REFERENCE IEN^NJ9,0^^2;1^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(19707.12,2.01,3)
 ;;=Type a Number between 0 and 999999999, 0 Decimal Digits
 ;;^DD(19707.12,2.01,21,0)
 ;;=^^4^4^3051118^^
 ;;^DD(19707.12,2.01,21,1,0)
 ;;=If the data element is stored in a V-File and the element itself
 ;;^DD(19707.12,2.01,21,2,0)
 ;;=is defined in a reference file (e.g., V MEASUREMENTS), this this
 ;;^DD(19707.12,2.01,21,3,0)
 ;;=field will contain the IEN if the entry in the reference file.  The
 ;;^DD(19707.12,2.01,21,4,0)
 ;;=rest of the filing parameters are stored in VEN EHP KB CATEGORY.
 ;;^DD(19707.12,2.01,"DT")
 ;;=3051118
 ;;^DD(19707.12,2.02,0)
 ;;=CPT CODE^P81'^ICPT(^2;2^Q
 ;;^DD(19707.12,2.02,"DT")
 ;;=3051127
 ;;^DD(19707.12,2.03,0)
 ;;=EDUCATION TOPIC CODE^F^^2;3^K:$L(X)>12!($L(X)<1) X
 ;;^DD(19707.12,2.03,1,0)
 ;;=^.1
 ;;^DD(19707.12,2.03,1,1,0)
 ;;=19707.12^AC
 ;;^DD(19707.12,2.03,1,1,1)
 ;;=S ^VEN(7.12,"AC",$E(X,1,30),DA)=""
 ;;^DD(19707.12,2.03,1,1,2)
 ;;=K ^VEN(7.12,"AC",$E(X,1,30),DA)
 ;;^DD(19707.12,2.03,1,1,"DT")
 ;;=3060131
 ;;^DD(19707.12,2.03,3)
 ;;=Answer must be 1-12 characters in length.
 ;;^DD(19707.12,2.03,"DT")
 ;;=3060306
 ;;^DD(19707.12,2.04,0)
 ;;=ICD PROCEDURE CODE^P80.1'^ICD0(^2;4^Q
 ;;^DD(19707.12,2.04,"DT")
 ;;=3051127
