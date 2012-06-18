FHINI0I1	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(113.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(113.2,0,"GL")
	;;=^FH(113.2,
	;;^DIC("B","VENDOR",113.2)
	;;=
	;;^DIC(113.2,"%D",0)
	;;=^^3^3^2880717^^
	;;^DIC(113.2,"%D",1,0)
	;;=This file contains basic data on the various vendors supplying
	;;^DIC(113.2,"%D",2,0)
	;;=ingredients to the Dietetic Service. It contains address, telephone
	;;^DIC(113.2,"%D",3,0)
	;;=numbers and name of contacts.
	;;^DD(113.2,0)
	;;=FIELD^^7^7
	;;^DD(113.2,0,"DT")
	;;=2930312
	;;^DD(113.2,0,"IX","B",113.2,.01)
	;;=
	;;^DD(113.2,0,"NM","VENDOR")
	;;=
	;;^DD(113.2,0,"PT",113,3)
	;;=
	;;^DD(113.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(113.2,.01,1,0)
	;;=^.1
	;;^DD(113.2,.01,1,1,0)
	;;=113.2^B
	;;^DD(113.2,.01,1,1,1)
	;;=S ^FH(113.2,"B",$E(X,1,30),DA)=""
	;;^DD(113.2,.01,1,1,2)
	;;=K ^FH(113.2,"B",$E(X,1,30),DA)
	;;^DD(113.2,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(113.2,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(113.2,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(113.2,.01,21,0)
	;;=^^1^1^2880710^
	;;^DD(113.2,.01,21,1,0)
	;;=This is the name of a vendor from whom ingredients are ordered.
	;;^DD(113.2,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(113.2,.01,"DT")
	;;=2930312
	;;^DD(113.2,1,0)
	;;=1ST ADDRESS LINE^F^^0;2^K:$L(X)>30!($L(X)<1) X
	;;^DD(113.2,1,3)
	;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
	;;^DD(113.2,1,21,0)
	;;=^^2^2^2880710^
	;;^DD(113.2,1,21,1,0)
	;;=This field contains the first address line following the
	;;^DD(113.2,1,21,2,0)
	;;=vendor's name.
	;;^DD(113.2,1,"DT")
	;;=2850606
	;;^DD(113.2,2,0)
	;;=2ND ADDRESS LINE^F^^0;3^K:$L(X)>30!($L(X)<1) X
	;;^DD(113.2,2,3)
	;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
	;;^DD(113.2,2,21,0)
	;;=^^1^1^2880710^
	;;^DD(113.2,2,21,1,0)
	;;=This field may contain a second address line if necessary.
	;;^DD(113.2,2,"DT")
	;;=2850606
	;;^DD(113.2,3,0)
	;;=3RD ADDRESS LINE^F^^0;4^K:$L(X)>30!($L(X)<1) X
	;;^DD(113.2,3,3)
	;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
	;;^DD(113.2,3,21,0)
	;;=^^1^1^2880710^
	;;^DD(113.2,3,21,1,0)
	;;=This field may contain a third address line if necessary.
	;;^DD(113.2,3,"DT")
	;;=2850606
	;;^DD(113.2,4,0)
	;;=CITY, STATE ZIP^F^^0;5^K:$L(X)>30!($L(X)<1) X
	;;^DD(113.2,4,3)
	;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
	;;^DD(113.2,4,21,0)
	;;=^^2^2^2880710^
	;;^DD(113.2,4,21,1,0)
	;;=This field contains the last address line showing city, state
	;;^DD(113.2,4,21,2,0)
	;;=and zip code.
	;;^DD(113.2,4,"DT")
	;;=2850606
	;;^DD(113.2,6,0)
	;;=CONTACT^F^^0;6^K:$L(X)>30!($L(X)<1) X
	;;^DD(113.2,6,3)
	;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
	;;^DD(113.2,6,21,0)
	;;=^^2^2^2880710^
	;;^DD(113.2,6,21,1,0)
	;;=This is the name of person who is the usual contact person
	;;^DD(113.2,6,21,2,0)
	;;=with the vendor.
	;;^DD(113.2,6,"DT")
	;;=2850606
	;;^DD(113.2,7,0)
	;;=TELEPHONE^F^^0;7^K:$L(X)>20!($L(X)<1) X
	;;^DD(113.2,7,3)
	;;=ANSWER MUST BE 1-20 CHARACTERS IN LENGTH
	;;^DD(113.2,7,21,0)
	;;=^^2^2^2880710^
	;;^DD(113.2,7,21,1,0)
	;;=This field contains the telephone number of the vendor contact
	;;^DD(113.2,7,21,2,0)
	;;=person.
	;;^DD(113.2,7,"DT")
	;;=2850606
