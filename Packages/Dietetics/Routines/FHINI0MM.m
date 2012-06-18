FHINI0MM	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(119.6)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(119.6,4,1,1,2)
	;;=S $P(^FH(119.6,DA,0),"^",10)=""
	;;^DD(119.6,4,1,1,"%D",0)
	;;=^^3^3^2940823^
	;;^DD(119.6,4,1,1,"%D",1,0)
	;;=This cross-reference, along with that on Fields 3 and 5, is used to
	;;^DD(119.6,4,1,1,"%D",2,0)
	;;=set the Services Field. It is a string containing C, T, and/or D
	;;^DD(119.6,4,1,1,"%D",3,0)
	;;=indicating which services are available for this ward.
	;;^DD(119.6,4,1,1,"DT")
	;;=2911031
	;;^DD(119.6,4,12)
	;;=Allows selction only of cafeterias
	;;^DD(119.6,4,12.1)
	;;=S DIC("S")="I $P(^(0),U,2)=""C"""
	;;^DD(119.6,4,21,0)
	;;=^^2^2^2911211^^^
	;;^DD(119.6,4,21,1,0)
	;;=This field, if used, indicates that cafeteria service is available
	;;^DD(119.6,4,21,2,0)
	;;=to this ward and is provided by the indicated Service Point.
	;;^DD(119.6,4,"DT")
	;;=2911204
	;;^DD(119.6,4.5,0)
	;;=CAFETERIA FORECAST %^NJ3,0^^0;18^K:+X'=X!(X>120)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.6,4.5,3)
	;;=Type a Number between 0 and 120, 0 Decimal Digits
	;;^DD(119.6,4.5,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.6,4.5,21,1,0)
	;;=This is the % of patients on the ward typically receiving cafeteria
	;;^DD(119.6,4.5,21,2,0)
	;;=service.
	;;^DD(119.6,4.5,"DT")
	;;=2911120
	;;^DD(119.6,5,0)
	;;=DINING ROOM TRAY SERVICE?^S^1:YES;0:NO;^0;7^Q
	;;^DD(119.6,5,1,0)
	;;=^.1
	;;^DD(119.6,5,1,1,0)
	;;=119.6^AS3^MUMPS
	;;^DD(119.6,5,1,1,1)
	;;=S Y="" S:$P(^FH(119.6,DA,0),"^",5) Y=Y_"T" S:$P(^(0),"^",6) Y=Y_"C" S:$P(^(0),"^",7) Y=Y_"D" S $P(^(0),"^",10)=Y
	;;^DD(119.6,5,1,1,2)
	;;=S $P(^FH(119.6,DA,0),"^",10)=""
	;;^DD(119.6,5,1,1,"%D",0)
	;;=^^3^3^2940823^
	;;^DD(119.6,5,1,1,"%D",1,0)
	;;=This cross-reference, along with that on Fields 3 and 4, is used to
	;;^DD(119.6,5,1,1,"%D",2,0)
	;;=set the Services Field. It is a string containing C, T, and/or D
	;;^DD(119.6,5,1,1,"%D",3,0)
	;;=indicating which services are available for this ward.
	;;^DD(119.6,5,1,1,"DT")
	;;=2911104
	;;^DD(119.6,5,3)
	;;=
	;;^DD(119.6,5,21,0)
	;;=^^1^1^2911204^^
	;;^DD(119.6,5,21,1,0)
	;;=A YES means that Dining Room tray service is available to this ward.
	;;^DD(119.6,5,"DT")
	;;=2911204
	;;^DD(119.6,5.5,0)
	;;=DINING ROOM FORECAST %^NJ3,0^^0;19^K:+X'=X!(X>120)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(119.6,5.5,3)
	;;=Type a Number between 0 and 120, 0 Decimal Digits
	;;^DD(119.6,5.5,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.6,5.5,21,1,0)
	;;=This is the % of patients on the ward typically receiving dining room
	;;^DD(119.6,5.5,21,2,0)
	;;=service.
	;;^DD(119.6,5.5,"DT")
	;;=2911204
	;;^DD(119.6,6,0)
	;;=COMMUNICATION OFFICE^RP119.73'^FH(119.73,^0;8^Q
	;;^DD(119.6,6,21,0)
	;;=^^2^2^2920505^^^
	;;^DD(119.6,6,21,1,0)
	;;=This field indicates which Communication Office is responsible for
	;;^DD(119.6,6,21,2,0)
	;;=processing diet requests from this ward.
	;;^DD(119.6,6,"DT")
	;;=2911204
	;;^DD(119.6,7,0)
	;;=SUPP. FDG. SITE^P119.74'^FH(119.74,^0;9^Q
	;;^DD(119.6,7,21,0)
	;;=^^2^2^2911204^
	;;^DD(119.6,7,21,1,0)
	;;=This field indicates which Supplemental Feeding Site is responsible for
	;;^DD(119.6,7,21,2,0)
	;;=preparing Supplemental Feedings and Bulk Nourishments for this ward.
	;;^DD(119.6,7,"DT")
	;;=2911204
	;;^DD(119.6,11,0)
	;;=PRINT ORDER^RNJ2,0^^0;4^K:+X'=X!(X>99)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(119.6,11,1,0)
	;;=^.1
	;;^DD(119.6,11,1,1,0)
	;;=119.6^AP
	;;^DD(119.6,11,1,1,1)
	;;=S ^FH(119.6,"AP",$E(X,1,30),DA)=""
	;;^DD(119.6,11,1,1,2)
	;;=K ^FH(119.6,"AP",$E(X,1,30),DA)
	;;^DD(119.6,11,1,1,3)
	;;=This field is required
	;;^DD(119.6,11,1,1,"DT")
	;;=2911029
	;;^DD(119.6,11,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 99
	;;^DD(119.6,11,21,0)
	;;=^^3^3^2921008^^^^
	;;^DD(119.6,11,21,1,0)
	;;=This field represents the print order of this ward. It is used
	;;^DD(119.6,11,21,2,0)
	;;=to sort the wards for delivery purposes which are then printed
	;;^DD(119.6,11,21,3,0)
	;;=from low print order to high print order.
	;;^DD(119.6,11,"DT")
	;;=2911029
	;;^DD(119.6,15,0)
	;;=DEFAULT ADMISSION DIET^P111'^FH(111,^0;15^Q
	;;^DD(119.6,15,21,0)
	;;=^^3^3^2940413^^^^
	;;^DD(119.6,15,21,1,0)
	;;=This field is optional. It may contain a diet from the Diets
	;;^DD(119.6,15,21,2,0)
	;;=file (111) and, if so, the diet will automatically be ordered
	;;^DD(119.6,15,21,3,0)
	;;=for each patient at the time of admission.
	;;^DD(119.6,15,"DT")
	;;=2850629
	;;^DD(119.6,16,0)
	;;='NO ORDER' DIET ON ADMISSION^S^Y:YES;N:NO;^0;16^Q
	;;^DD(119.6,16,21,0)
	;;=^^3^3^2940413^^^
	;;^DD(119.6,16,21,1,0)
	;;=This field is used to indicate whether a 'No Order' Diet
	;;^DD(119.6,16,21,2,0)
	;;=order should be generated upon admission; this field is
	;;^DD(119.6,16,21,3,0)
	;;=applicable only if no default admission diet is specified.
