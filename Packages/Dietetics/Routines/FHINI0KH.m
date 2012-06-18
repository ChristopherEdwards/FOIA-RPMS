FHINI0KH	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.01,2.1,21,1,0)
	;;=This field contains the most recent type of service (tray,
	;;^DD(115.01,2.1,21,2,0)
	;;=cafeteria or dining room) selected for the patient. It is
	;;^DD(115.01,2.1,21,3,0)
	;;=used as a default for future orders.
	;;^DD(115.01,2.1,"DT")
	;;=2880515
	;;^DD(115.01,3,0)
	;;=DIET^115.02A^^DI;0
	;;^DD(115.01,3,21,0)
	;;=^^2^2^2911223^^^^
	;;^DD(115.01,3,21,1,0)
	;;=This multiple contains the individual diet orders which have
	;;^DD(115.01,3,21,2,0)
	;;=been entered during this admission.
	;;^DD(115.01,4,0)
	;;=DIET SEQUENCE^115.14DA^^AC;0
	;;^DD(115.01,4,21,0)
	;;=^^5^5^2911223^^^
	;;^DD(115.01,4,21,1,0)
	;;=This multiple indicates the sequence in which the diet orders
	;;^DD(115.01,4,21,2,0)
	;;=actually become effective. Since orders entered later supercede
	;;^DD(115.01,4,21,3,0)
	;;=earlier orders, the sequence times may not be the same as those
	;;^DD(115.01,4,21,4,0)
	;;=of the original order. This multiple is the outcome of a
	;;^DD(115.01,4,21,5,0)
	;;=recursive templating schemata.
	;;^DD(115.01,6,0)
	;;=CURRENT SF ORDER^NJ4,0I^^0;7^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(115.01,6,3)
	;;=Type a Number between 0 and 9999, 0 Decimal Digits
	;;^DD(115.01,6,21,0)
	;;=^^4^4^2880710^
	;;^DD(115.01,6,21,1,0)
	;;=This field is actually a pointer to the Supplemental Feeding
	;;^DD(115.01,6,21,2,0)
	;;=multiple (Field 20) and, if present, indicates which order
	;;^DD(115.01,6,21,3,0)
	;;=is presently in effect. It is updated any time any diet
	;;^DD(115.01,6,21,4,0)
	;;=activity involving supplemental feedings takes place.
	;;^DD(115.01,6,"DT")
	;;=2880515
	;;^DD(115.01,9,0)
	;;=ISOLATION/PRECAUTION^P119.4'^FH(119.4,^0;10^Q
	;;^DD(115.01,9,1,0)
	;;=^.1
	;;^DD(115.01,9,1,1,0)
	;;=115^AIS^MUMPS
	;;^DD(115.01,9,1,1,1)
	;;=S ^FHPT("AIS",DA(1),DA)=""
	;;^DD(115.01,9,1,1,2)
	;;=K ^FHPT("AIS",DA(1),DA)
	;;^DD(115.01,9,1,1,"%D",0)
	;;=^^1^1^2940824^
	;;^DD(115.01,9,1,1,"%D",1,0)
	;;=This cross-reference is a list of patients on isolation/precautions.
	;;^DD(115.01,9,3)
	;;=
	;;^DD(115.01,9,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.01,9,21,1,0)
	;;=This field, if present, indicates that the patient is presently
	;;^DD(115.01,9,21,2,0)
	;;=on isolation or special precautions.
	;;^DD(115.01,9,"DT")
	;;=2871010
	;;^DD(115.01,10,0)
	;;=OE/RR ISOLATION ORDER^P100^OR(100,^0;13^Q
	;;^DD(115.01,10,21,0)
	;;=^^2^2^2890919^
	;;^DD(115.01,10,21,1,0)
	;;=This field contains the OE/RR file order pointer corresponding
	;;^DD(115.01,10,21,2,0)
	;;=to the current Isolation/Precautions.
	;;^DD(115.01,10,"DT")
	;;=2890919
	;;^DD(115.01,11,0)
	;;=LAST LABEL WARD^P119.6'I^FH(119.6,^0;11^Q
	;;^DD(115.01,11,3)
	;;=
	;;^DD(115.01,11,21,0)
	;;=^^4^4^2930121^^
	;;^DD(115.01,11,21,1,0)
	;;=This field contains the internal number of the ward (from File 42)
	;;^DD(115.01,11,21,2,0)
	;;=for which the last diet card label was prepared. Whenever a
	;;^DD(115.01,11,21,3,0)
	;;=label run is made, this field is compared with the current ward
	;;^DD(115.01,11,21,4,0)
	;;=and, if different, a new label is prepared.
	;;^DD(115.01,11,"DT")
	;;=2860702
	;;^DD(115.01,12,0)
	;;=LAST LABEL ROOM^FI^^0;12^K:$L(X)>10!($L(X)<1) X
	;;^DD(115.01,12,3)
	;;=ANSWER MUST BE 1-10 CHARACTERS IN LENGTH
	;;^DD(115.01,12,21,0)
	;;=^^4^4^2880710^
	;;^DD(115.01,12,21,1,0)
	;;=This field contains the room-bed for which the last diet card
	;;^DD(115.01,12,21,2,0)
	;;=label was prepared. Whenever a label run is made, this field
	;;^DD(115.01,12,21,3,0)
	;;=is compared with the current room-bed and, if different, a new
	;;^DD(115.01,12,21,4,0)
	;;=label is prepared.
	;;^DD(115.01,12,"DT")
	;;=2850826
	;;^DD(115.01,13,0)
	;;=DIETETIC WARD^P119.6'^FH(119.6,^0;8^Q
	;;^DD(115.01,13,1,0)
	;;=^.1
	;;^DD(115.01,13,1,1,0)
	;;=115^AW^MUMPS
	;;^DD(115.01,13,1,1,1)
	;;=S ^FHPT("AW",X,DA(1))=DA
	;;^DD(115.01,13,1,1,2)
	;;=K ^FHPT("AW",X,DA(1))
	;;^DD(115.01,13,1,1,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(115.01,13,1,1,"%D",1,0)
	;;=This is a cross-reference of Dietetic Ward by Patient. The
	;;^DD(115.01,13,1,1,"%D",2,0)
	;;=cross-reference is set to the admission number.
	;;^DD(115.01,13,1,1,"DT")
	;;=2930408
	;;^DD(115.01,13,21,0)
	;;=^^2^2^2911204^
	;;^DD(115.01,13,21,1,0)
	;;=This field indicates the Dietetic Ward on which the patient is currently
	;;^DD(115.01,13,21,2,0)
	;;=residing.
	;;^DD(115.01,13,"DT")
	;;=2930408
	;;^DD(115.01,14,0)
	;;=ROOM-BED^P405.4'^DG(405.4,^0;9^Q
	;;^DD(115.01,14,21,0)
	;;=^^2^2^2911204^
	;;^DD(115.01,14,21,1,0)
	;;=This field contains the free-text room-bed in which the patient is
	;;^DD(115.01,14,21,2,0)
	;;=currently residing.
	;;^DD(115.01,14,"DT")
	;;=2911023
