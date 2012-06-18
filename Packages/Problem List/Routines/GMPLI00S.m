GMPLI00S	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(9000011)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(9000011.11,.01,21,0)
	;;=^^1^1^2940110^^
	;;^DD(9000011.11,.01,21,1,0)
	;;=This is the location at which the notes in this multiple originated.
	;;^DD(9000011.11,.01,"AUDIT")
	;;=n
	;;^DD(9000011.11,.01,"DT")
	;;=2930909
	;;^DD(9000011.11,1101,0)
	;;=NOTE^9000011.1111IA^^11;0
	;;^DD(9000011.11,1101,21,0)
	;;=^^4^4^2940208^
	;;^DD(9000011.11,1101,21,1,0)
	;;=Each entry in this multiple is a notation appended to a problem for
	;;^DD(9000011.11,1101,21,2,0)
	;;=further clarification or information.  Data includes a note number
	;;^DD(9000011.11,1101,21,3,0)
	;;=and status, the date the note was added, the provider who added it,
	;;^DD(9000011.11,1101,21,4,0)
	;;=and the actual text of the note.
	;;^DD(9000011.1111,0)
	;;=NOTE SUB-FIELD^^.06^5
	;;^DD(9000011.1111,0,"DT")
	;;=2940110
	;;^DD(9000011.1111,0,"ID",.03)
	;;=W "   ",$P(^(0),U,3)
	;;^DD(9000011.1111,0,"IX","AV9",9000011.1111,.01)
	;;=
	;;^DD(9000011.1111,0,"IX","B",9000011.1111,.01)
	;;=
	;;^DD(9000011.1111,0,"NM","NOTE")
	;;=
	;;^DD(9000011.1111,0,"UP")
	;;=9000011.11
	;;^DD(9000011.1111,.01,0)
	;;=NOTE NMBR^RNJ3,0^^0;1^K:+X'=X!(X>999)!(X<1)!(X?.E1"."1N.N) X
	;;^DD(9000011.1111,.01,1,0)
	;;=^.1
	;;^DD(9000011.1111,.01,1,1,0)
	;;=9000011.1111^B
	;;^DD(9000011.1111,.01,1,1,1)
	;;=S ^AUPNPROB(DA(2),11,DA(1),11,"B",$E(X,1,30),DA)=""
	;;^DD(9000011.1111,.01,1,1,2)
	;;=K ^AUPNPROB(DA(2),11,DA(1),11,"B",$E(X,1,30),DA)
	;;^DD(9000011.1111,.01,1,2,0)
	;;=9000011.1111^AV9^MUMPS
	;;^DD(9000011.1111,.01,1,2,1)
	;;=S:$D(APCDLOOK) DIC("DR")=""
	;;^DD(9000011.1111,.01,1,2,2)
	;;=Q
	;;^DD(9000011.1111,.01,1,2,"%D",0)
	;;=^^2^2^2940204^^^
	;;^DD(9000011.1111,.01,1,2,"%D",1,0)
	;;=Controls the behaviour of the input templates used by IHS to populate
	;;^DD(9000011.1111,.01,1,2,"%D",2,0)
	;;=and maintain this file.
	;;^DD(9000011.1111,.01,1,2,"DT")
	;;=2940125
	;;^DD(9000011.1111,.01,3)
	;;=Type a Number between 1 and 999, 0 Decimal Digits
	;;^DD(9000011.1111,.01,21,0)
	;;=^^1^1^2940204^^^^
	;;^DD(9000011.1111,.01,21,1,0)
	;;=This is the unique note identifier.
	;;^DD(9000011.1111,.01,"AUDIT")
	;;=n
	;;^DD(9000011.1111,.01,"DT")
	;;=2940125
	;;^DD(9000011.1111,.03,0)
	;;=NOTE NARRATIVE^RF^^0;3^K:$L(X)>60!($L(X)<3) X
	;;^DD(9000011.1111,.03,3)
	;;=Answer must be 3-60 characters in length.
	;;^DD(9000011.1111,.03,21,0)
	;;=^^1^1^2930726^
	;;^DD(9000011.1111,.03,21,1,0)
	;;=Additional comments may be entered here to further describe this problem.
	;;^DD(9000011.1111,.03,"AUDIT")
	;;=n
	;;^DD(9000011.1111,.03,"DT")
	;;=2930726
	;;^DD(9000011.1111,.04,0)
	;;=STATUS^RS^A:ACTIVE;^0;4^Q
	;;^DD(9000011.1111,.04,3)
	;;=If this note is currently ACTIVE, indicate it here.
	;;^DD(9000011.1111,.04,21,0)
	;;=^^1^1^2930726^
	;;^DD(9000011.1111,.04,21,1,0)
	;;=This flag indicates if this note is currently active.
	;;^DD(9000011.1111,.04,"DT")
	;;=2900501
	;;^DD(9000011.1111,.05,0)
	;;=DATE NOTE ADDED^D^^0;5^S %DT="EX" D ^%DT S X=Y K:DT<X!(1800000>X) X
	;;^DD(9000011.1111,.05,3)
	;;=TYPE A DATE BETWEEN 1880 AND TODAY
	;;^DD(9000011.1111,.05,21,0)
	;;=^^1^1^2930726^
	;;^DD(9000011.1111,.05,21,1,0)
	;;=This is the date this note was entered into this file.
	;;^DD(9000011.1111,.05,"DT")
	;;=2930726
	;;^DD(9000011.1111,.06,0)
	;;=AUTHOR^P200'^VA(200,^0;6^Q
	;;^DD(9000011.1111,.06,3)
	;;=Enter the name of the provider who authored the text of this note.
	;;^DD(9000011.1111,.06,21,0)
	;;=^^1^1^2930726^
	;;^DD(9000011.1111,.06,21,1,0)
	;;=This is the provider who authored the text of this note.
	;;^DD(9000011.1111,.06,"DT")
	;;=2930330
