FHINI0KQ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.05,1,21,1,0)
	;;=This field indicates for which meal the early or late tray is ordered.
	;;^DD(115.05,1,"DT")
	;;=2850608
	;;^DD(115.05,2,0)
	;;=TIME^F^^0;3^K:$L(X)>10!($L(X)<1) X
	;;^DD(115.05,2,3)
	;;=ANSWER MUST BE 1-10 CHARACTERS IN LENGTH
	;;^DD(115.05,2,21,0)
	;;=^^2^2^2930428^^^^
	;;^DD(115.05,2,21,1,0)
	;;=This field contains a printable time for which the meal is to
	;;^DD(115.05,2,21,2,0)
	;;=delivered.
	;;^DD(115.05,2,"DT")
	;;=2850525
	;;^DD(115.05,3,0)
	;;=BAGGED MEAL?^S^Y:YES;N:NO;^0;4^Q
	;;^DD(115.05,3,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.05,3,21,1,0)
	;;=If answered YES, this field indicates that a bagged meal is desired.
	;;^DD(115.05,3,"DT")
	;;=2850526
	;;^DD(115.05,4,0)
	;;=CLERK^RP200'^VA(200,^0;5^Q
	;;^DD(115.05,4,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.05,4,21,1,0)
	;;=This field is automatically updated with the user entering
	;;^DD(115.05,4,21,2,0)
	;;=the order.
	;;^DD(115.05,4,"DT")
	;;=2850526
	;;^DD(115.05,5,0)
	;;=ENTRY DATE/TIME^RD^^0;6^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.05,5,21,0)
	;;=^^2^2^2910506^^
	;;^DD(115.05,5,21,1,0)
	;;=This field contains the date/time the order was actually
	;;^DD(115.05,5,21,2,0)
	;;=entered.
	;;^DD(115.05,5,"DT")
	;;=2850526
	;;^DD(115.05,6,0)
	;;=OE/RR ORDER^P100^OR(100,^0;7^Q
	;;^DD(115.05,6,21,0)
	;;=^^2^2^2890918^
	;;^DD(115.05,6,21,1,0)
	;;=This field contains a pointer to the OE/RR file order corresponding
	;;^DD(115.05,6,21,2,0)
	;;=to this order.
	;;^DD(115.05,6,"DT")
	;;=2890918
	;;^DD(115.06,0)
	;;=ADDITIONAL ORDERS SUB-FIELD^NL^7^8
	;;^DD(115.06,0,"NM","ADDITIONAL ORDERS")
	;;=
	;;^DD(115.06,0,"UP")
	;;=115.01
	;;^DD(115.06,.01,0)
	;;=ORDER NUMBER^RNJ5,0X^^0;1^K:'X!(X'?1N.N) X I $D(X) S DINUM=X
	;;^DD(115.06,.01,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 99999
	;;^DD(115.06,.01,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.06,.01,21,1,0)
	;;=This field is merely the sequence number of the Additional
	;;^DD(115.06,.01,21,2,0)
	;;=Orders entered and has no meaning beyond that.
	;;^DD(115.06,.01,"DT")
	;;=2851126
	;;^DD(115.06,1,0)
	;;=DATE/TIME ENTERED^RD^^0;2^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.06,1,1,0)
	;;=^.1^^0
	;;^DD(115.06,1,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.06,1,21,1,0)
	;;=This is the date/time the Additional Order was entered.
	;;^DD(115.06,1,"DT")
	;;=2851126
	;;^DD(115.06,2,0)
	;;=ORDER^F^^0;3^K:$L(X)>60!($L(X)<1) X
	;;^DD(115.06,2,3)
	;;=ANSWER MUST BE 1-60 CHARACTERS IN LENGTH
	;;^DD(115.06,2,21,0)
	;;=^^1^1^2880710^
	;;^DD(115.06,2,21,1,0)
	;;=This is the text of the order.
	;;^DD(115.06,2,"DT")
	;;=2851126
	;;^DD(115.06,3,0)
	;;=CLERK^RP200'^VA(200,^0;4^Q
	;;^DD(115.06,3,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.06,3,21,1,0)
	;;=This is the clerk entering the order and is automatically
	;;^DD(115.06,3,21,2,0)
	;;=captured at time of entry.
	;;^DD(115.06,3,"DT")
	;;=2851126
	;;^DD(115.06,4,0)
	;;=STATUS^RS^A:ACTIVE;C:COMPLETE;S:SAVED;X:CANCELLED;^0;5^Q
	;;^DD(115.06,4,1,0)
	;;=^.1
	;;^DD(115.06,4,1,1,0)
	;;=115^AOO^MUMPS
	;;^DD(115.06,4,1,1,1)
	;;=S:X="A" ^FHPT("AOO",DA(2),DA(1),DA)="" K:X'="A" ^FHPT("AOO",DA(2),DA(1),DA)
	;;^DD(115.06,4,1,1,2)
	;;=K ^FHPT("AOO",DA(2),DA(1),DA)
	;;^DD(115.06,4,1,1,"%D",0)
	;;=^^1^1^2940824^
	;;^DD(115.06,4,1,1,"%D",1,0)
	;;=This cross-reference is a list of active orders only.
	;;^DD(115.06,4,21,0)
	;;=^^3^3^2920319^^^^
	;;^DD(115.06,4,21,1,0)
	;;=This is the status of the order. A saved order is one that has
	;;^DD(115.06,4,21,2,0)
	;;=been responded to but continues to display as it may require
	;;^DD(115.06,4,21,3,0)
	;;=further or on-going action.
	;;^DD(115.06,4,"DT")
	;;=2890514
	;;^DD(115.06,5,0)
	;;=DATE/TIME CLEARED^D^^0;6^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.06,5,21,0)
	;;=^^1^1^2880718^^
	;;^DD(115.06,5,21,1,0)
	;;=This is the date/time that the order was completed or saved.
	;;^DD(115.06,5,"DT")
	;;=2851126
	;;^DD(115.06,6,0)
	;;=CLERK CLEARING^P200'^VA(200,^0;7^Q
	;;^DD(115.06,6,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.06,6,21,1,0)
	;;=This is the dietetic person clearing the order and is
	;;^DD(115.06,6,21,2,0)
	;;=automatically captured at time of entry.
	;;^DD(115.06,6,"DT")
	;;=2851126
	;;^DD(115.06,7,0)
	;;=OE/RR ORDER^P100^OR(100,^0;8^Q
	;;^DD(115.06,7,21,0)
	;;=^^2^2^2890918^
	;;^DD(115.06,7,21,1,0)
	;;=This field contains a pointer to the OE/RR file order corresponding
	;;^DD(115.06,7,21,2,0)
	;;=to this order.
	;;^DD(115.06,7,"DT")
	;;=2890918
	;;^DD(115.07,0)
	;;=SUPPLEMENTAL FEEDING SUB-FIELD^^44^34
	;;^DD(115.07,0,"DT")
	;;=2940722
	;;^DD(115.07,0,"NM","SUPPLEMENTAL FEEDING")
	;;=
	;;^DD(115.07,0,"UP")
	;;=115.01
	;;^DD(115.07,.01,0)
	;;=SUPPLEMENTAL FEEDING^NJ4,0^^0;1^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
