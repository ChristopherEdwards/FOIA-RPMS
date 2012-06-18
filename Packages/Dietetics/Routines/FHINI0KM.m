FHINI0KM	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.02,1,"DT")
	;;=2880514
	;;^DD(115.02,2,0)
	;;=DIET2^P111'I^FH(111,^0;3^Q
	;;^DD(115.02,2,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.02,2,21,1,0)
	;;=This is the second diet modification selected from the Diets (111)
	;;^DD(115.02,2,21,2,0)
	;;=file.
	;;^DD(115.02,2,"DT")
	;;=2880514
	;;^DD(115.02,3,0)
	;;=DIET3^P111'I^FH(111,^0;4^Q
	;;^DD(115.02,3,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.02,3,21,1,0)
	;;=This is the third diet modification selected from the Diets (111)
	;;^DD(115.02,3,21,2,0)
	;;=file.
	;;^DD(115.02,3,"DT")
	;;=2880514
	;;^DD(115.02,4,0)
	;;=DIET4^P111'I^FH(111,^0;5^Q
	;;^DD(115.02,4,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.02,4,21,1,0)
	;;=This is the fourth diet modification selected from the Diets (111)
	;;^DD(115.02,4,21,2,0)
	;;=file.
	;;^DD(115.02,4,"DT")
	;;=2880514
	;;^DD(115.02,5,0)
	;;=DIET5^P111'I^FH(111,^0;6^Q
	;;^DD(115.02,5,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.02,5,21,1,0)
	;;=This is the fifth diet modification selected from the Diets (111)
	;;^DD(115.02,5,21,2,0)
	;;=file.
	;;^DD(115.02,5,"DT")
	;;=2880514
	;;^DD(115.02,6,0)
	;;=WITHHOLD^SI^N:NPO;X:NO ORDER;P:PASS;^0;7^Q
	;;^DD(115.02,6,1,0)
	;;=^.1^^0
	;;^DD(115.02,6,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.02,6,21,1,0)
	;;=This field, if not null, indicates that an NPO type of order
	;;^DD(115.02,6,21,2,0)
	;;=was entered.
	;;^DD(115.02,6,"DT")
	;;=2880514
	;;^DD(115.02,7,0)
	;;=TYPE OF SERVICE^SI^T:TRAY;C:CAFETERIA;D:DINING ROOM;^0;8^Q
	;;^DD(115.02,7,21,0)
	;;=^^4^4^2880710^
	;;^DD(115.02,7,21,1,0)
	;;=This field indicates the type of service requested for this diet
	;;^DD(115.02,7,21,2,0)
	;;=order. It is not present for NPO orders. When this order becomes
	;;^DD(115.02,7,21,3,0)
	;;=effective, this type of service will become the current type of
	;;^DD(115.02,7,21,4,0)
	;;=service and will be the default for future orders.
	;;^DD(115.02,7,"DT")
	;;=2880514
	;;^DD(115.02,8,0)
	;;=DATE/TIME EFFECTIVE^DI^^0;9^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.02,8,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.02,8,21,1,0)
	;;=This is the date/time when this diet order takes effect.
	;;^DD(115.02,8,"DT")
	;;=2880514
	;;^DD(115.02,9,0)
	;;=DATE/TIME EXPIRES^DI^^0;10^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.02,9,21,0)
	;;=^^3^3^2880710^
	;;^DD(115.02,9,21,1,0)
	;;=This field indicates the date/time when this order is to expire.
	;;^DD(115.02,9,21,2,0)
	;;=If null, the order is 'open-ended' and will not expire until
	;;^DD(115.02,9,21,3,0)
	;;=superceded by another order.
	;;^DD(115.02,9,"DT")
	;;=2880514
	;;^DD(115.02,10,0)
	;;=CLERK^P200'^VA(200,^0;11^Q
	;;^DD(115.02,10,21,0)
	;;=^^1^1^2880718^^
	;;^DD(115.02,10,21,1,0)
	;;=This field is the person actually entering the order.
	;;^DD(115.02,10.5,0)
	;;=DATE/TIME ORDERED^D^^0;12^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.02,10.5,21,0)
	;;=^^3^3^2880710^
	;;^DD(115.02,10.5,21,1,0)
	;;=This is the date/time the order was actually entered and may bear
	;;^DD(115.02,10.5,21,2,0)
	;;=little relationship the effective and/or expiration date/times
	;;^DD(115.02,10.5,21,3,0)
	;;=of the actual order.
	;;^DD(115.02,11,0)
	;;=COMMENT^F^^1;1^K:$L(X)>50!($L(X)<1) X
	;;^DD(115.02,11,3)
	;;=ANSWER MUST BE 1-50 CHARACTERS IN LENGTH
	;;^DD(115.02,11,21,0)
	;;=^^2^2^2911226^^
	;;^DD(115.02,11,21,1,0)
	;;=This is a comment field for any specialized comments concerning
	;;^DD(115.02,11,21,2,0)
	;;=this diet order.
	;;^DD(115.02,12,0)
	;;=PRODUCTION DIET^RP116.2'^FH(116.2,^0;13^Q
	;;^DD(115.02,12,21,0)
	;;=^^4^4^2880710^
	;;^DD(115.02,12,21,1,0)
	;;=This is a pointer to the Production Diet (116.2) file and is
	;;^DD(115.02,12,21,2,0)
	;;=the outcome of the 'diet recoding' algorithm which is based
	;;^DD(115.02,12,21,3,0)
	;;=upon the diet modifications selected. It is not present for
	;;^DD(115.02,12,21,4,0)
	;;=NPO types of orders.
	;;^DD(115.02,12,"DT")
	;;=2870713
	;;^DD(115.02,13,0)
	;;=OE/RR ORDER^P100^OR(100,^0;14^Q
	;;^DD(115.02,13,21,0)
	;;=^^2^2^2890918^
	;;^DD(115.02,13,21,1,0)
	;;=This field contains a pointer the the OE/RR file order corresponding
	;;^DD(115.02,13,21,2,0)
	;;=to this order.
	;;^DD(115.02,13,"DT")
	;;=2890918
	;;^DD(115.02,14,0)
	;;=CURRENT OE/RR STATUS^P100.01'^ORD(100.01,^0;15^Q
	;;^DD(115.02,14,21,0)
	;;=^^2^2^2891008^
	;;^DD(115.02,14,21,1,0)
	;;=This field contains the current OE/RR status as passed to OE/RR.
	;;^DD(115.02,14,21,2,0)
	;;=It is a pointer to the OE/RR Status file (100.01).
	;;^DD(115.02,14,"DT")
	;;=2891008
	;;^DD(115.02,15,0)
	;;=LAST REVIEW DATE/TIME^D^^0;16^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.02,15,21,0)
	;;=^^3^3^2911204^
	;;^DD(115.02,15,21,1,0)
	;;=This is the date/time that the diet order was last reviewed if necessary.
