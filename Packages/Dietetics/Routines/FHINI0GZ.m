FHINI0GZ	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(112.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(112.2,0,"GL")
	;;=^FH(112.2,
	;;^DIC("B","RDA VALUES",112.2)
	;;=
	;;^DIC(112.2,"%D",0)
	;;=^^4^4^2871125^
	;;^DIC(112.2,"%D",1,0)
	;;=This file contains the values of the Recommended Dietary Allowances,
	;;^DIC(112.2,"%D",2,0)
	;;=1989. Where ranges were originally specified, the file contains
	;;^DIC(112.2,"%D",3,0)
	;;=the mid-point. 'Estimated safe and adequate' values are used where
	;;^DIC(112.2,"%D",4,0)
	;;=no formal RDA exists.
	;;^DD(112.2,0)
	;;=FIELD^^22^24
	;;^DD(112.2,0,"DT")
	;;=2920704
	;;^DD(112.2,0,"IX","B",112.2,.01)
	;;=
	;;^DD(112.2,0,"IX","C",112.2,.5)
	;;=
	;;^DD(112.2,0,"NM","RDA VALUES")
	;;=
	;;^DD(112.2,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(112.2,.01,1,0)
	;;=^.1
	;;^DD(112.2,.01,1,1,0)
	;;=112.2^B
	;;^DD(112.2,.01,1,1,1)
	;;=S ^FH(112.2,"B",$E(X,1,30),DA)=""
	;;^DD(112.2,.01,1,1,2)
	;;=K ^FH(112.2,"B",$E(X,1,30),DA)
	;;^DD(112.2,.01,1,1,"%D",0)
	;;=^^1^1^2911118^
	;;^DD(112.2,.01,1,1,"%D",1,0)
	;;=This is the normal B cross-reference of the NAME field.
	;;^DD(112.2,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(112.2,.01,21,0)
	;;=^^2^2^2880717^
	;;^DD(112.2,.01,21,1,0)
	;;=This field contains the name of a category of people for whom
	;;^DD(112.2,.01,21,2,0)
	;;=Recommended Dietary Allowance values have been published.
	;;^DD(112.2,.01,"DEL",1,0)
	;;=I DUZ(0)'["@",'$D(^XUSEC("FHMGR",DUZ))
	;;^DD(112.2,.5,0)
	;;=MNEMONIC^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>8!($L(X)<1) X
	;;^DD(112.2,.5,1,0)
	;;=^.1
	;;^DD(112.2,.5,1,1,0)
	;;=112.2^C
	;;^DD(112.2,.5,1,1,1)
	;;=S ^FH(112.2,"C",$E(X,1,30),DA)=""
	;;^DD(112.2,.5,1,1,2)
	;;=K ^FH(112.2,"C",$E(X,1,30),DA)
	;;^DD(112.2,.5,3)
	;;=ANSWER MUST BE 1-8 CHARACTERS IN LENGTH
	;;^DD(112.2,.5,21,0)
	;;=^^2^2^2950221^^^
	;;^DD(112.2,.5,21,1,0)
	;;=This is a short name, or mnemonic, for the RDA category of
	;;^DD(112.2,.5,21,2,0)
	;;=persons.
	;;^DD(112.2,.5,"DT")
	;;=2950221
	;;^DD(112.2,1,0)
	;;=PROTEIN GM.^NJ5,1^^1;1^K:+X'=X!(X>100)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(112.2,1,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 100
	;;^DD(112.2,1,21,0)
	;;=^^2^2^2880717^^^
	;;^DD(112.2,1,21,1,0)
	;;=This field represents the recommended amount of Protein per
	;;^DD(112.2,1,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,2,0)
	;;=VITAMIN A RE^NJ4,0^^1;2^K:+X'=X!(X>3000)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,2,3)
	;;=Type a Number between 0 and 3000, 0 Decimal Digits
	;;^DD(112.2,2,21,0)
	;;=^^2^2^2891211^^^^
	;;^DD(112.2,2,21,1,0)
	;;=This field represents the recommended amount of Vitamin A in
	;;^DD(112.2,2,21,2,0)
	;;=Retinol Equivalents per day for this RDA group.
	;;^DD(112.2,2,"DT")
	;;=2891211
	;;^DD(112.2,3,0)
	;;=VITAMIN E MG^NJ3,0^^1;3^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,3,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 100
	;;^DD(112.2,3,21,0)
	;;=^^2^2^2880717^^^
	;;^DD(112.2,3,21,1,0)
	;;=This field represents the recommended amount of Vitamin E per
	;;^DD(112.2,3,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,4,0)
	;;=VITAMIN C MG^NJ3,0^^1;4^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,4,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 100
	;;^DD(112.2,4,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,4,21,1,0)
	;;=This field represents the recommended amount of Vitamin C per
	;;^DD(112.2,4,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,5,0)
	;;=THIAMIN MG^NJ3,1^^1;5^K:+X'=X!(X>3)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(112.2,5,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 3
	;;^DD(112.2,5,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,5,21,1,0)
	;;=This field represents the recommended amount of Thiamin per
	;;^DD(112.2,5,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,6,0)
	;;=RIBOFLAVIN MG^NJ3,1^^1;6^K:+X'=X!(X>3)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(112.2,6,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 3
	;;^DD(112.2,6,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,6,21,1,0)
	;;=This field represents the recommended amount of Riboflavin per
	;;^DD(112.2,6,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,7,0)
	;;=NIACIN MG^NJ2,0^^1;7^K:+X'=X!(X>50)!(X<0)!(X?.E1"."1N.N) X
	;;^DD(112.2,7,3)
	;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 50
	;;^DD(112.2,7,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,7,21,1,0)
	;;=This field represents the recommended amount of Niacin per
	;;^DD(112.2,7,21,2,0)
	;;=day for this RDA group.
	;;^DD(112.2,8,0)
	;;=VITAMIN B6 MG^NJ3,1^^1;8^K:+X'=X!(X>5)!(X<0)!(X?.E1"."2N.N) X
	;;^DD(112.2,8,3)
	;;=TYPE A NUMBER BETWEEN 0 AND 5
	;;^DD(112.2,8,21,0)
	;;=^^2^2^2880717^^
	;;^DD(112.2,8,21,1,0)
	;;=This field represents the recommended amount of Vitamin B6 per
	;;^DD(112.2,8,21,2,0)
	;;=day for this RDA group.
