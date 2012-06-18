GMPLI003	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(125)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(125,0,"GL")
	;;=^GMPL(125,
	;;^DIC("B","PROBLEM SELECTION LIST",125)
	;;=
	;;^DIC(125,"%D",0)
	;;=^^3^3^2940526^^^^
	;;^DIC(125,"%D",1,0)
	;;=This file contains information defining lists of problems commonly seen
	;;^DIC(125,"%D",2,0)
	;;=by a particular clinic or user.  These lists will be presented as menus
	;;^DIC(125,"%D",3,0)
	;;=to select from, to facilitate adding new problems.
	;;^DD(125,0)
	;;=FIELD^^.03^3
	;;^DD(125,0,"DDA")
	;;=N
	;;^DD(125,0,"DT")
	;;=2940202
	;;^DD(125,0,"ID",.03)
	;;=W ""
	;;^DD(125,0,"IX","B",125,.01)
	;;=
	;;^DD(125,0,"IX","C",125,.03)
	;;=
	;;^DD(125,0,"NM","PROBLEM SELECTION LIST")
	;;=
	;;^DD(125,0,"PT",125.1,.01)
	;;=
	;;^DD(125,0,"PT",200,125.1)
	;;=
	;;^DD(125,.01,0)
	;;=NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X
	;;^DD(125,.01,1,0)
	;;=^.1
	;;^DD(125,.01,1,1,0)
	;;=125^B
	;;^DD(125,.01,1,1,1)
	;;=S ^GMPL(125,"B",$E(X,1,30),DA)=""
	;;^DD(125,.01,1,1,2)
	;;=K ^GMPL(125,"B",$E(X,1,30),DA)
	;;^DD(125,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(125,.01,21,0)
	;;=^^3^3^2931004^
	;;^DD(125,.01,21,1,0)
	;;=This is a free text name for the list; it should contain the name of
	;;^DD(125,.01,21,2,0)
	;;=the clinic or user who will be the primary user(s) of this list, as this
	;;^DD(125,.01,21,3,0)
	;;=name will be used as an ID and a title.
	;;^DD(125,.02,0)
	;;=DATE LAST MODIFIED^D^^0;2^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
	;;^DD(125,.02,3)
	;;=Enter the date/time this list was last edited.
	;;^DD(125,.02,21,0)
	;;=^^2^2^2940107^^
	;;^DD(125,.02,21,1,0)
	;;=This is the date[/time] this list was last changed in any way; this value
	;;^DD(125,.02,21,2,0)
	;;=is stuffed in by the Problem List pkg utilities that manage this file.
	;;^DD(125,.02,"DT")
	;;=2931004
	;;^DD(125,.03,0)
	;;=CLINIC^*P44'^SC(^0;3^S DIC("S")="I $P(^(0),U,3)=""C""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(125,.03,1,0)
	;;=^.1
	;;^DD(125,.03,1,1,0)
	;;=125^C
	;;^DD(125,.03,1,1,1)
	;;=S ^GMPL(125,"C",$E(X,1,30),DA)=""
	;;^DD(125,.03,1,1,2)
	;;=K ^GMPL(125,"C",$E(X,1,30),DA)
	;;^DD(125,.03,1,1,"DT")
	;;=2940107
	;;^DD(125,.03,3)
	;;=Enter the clinic to be associated with this list.
	;;^DD(125,.03,12)
	;;=Only hospital locations that are clinics are allowed.
	;;^DD(125,.03,12.1)
	;;=S DIC("S")="I $P(^(0),U,3)=""C"""
	;;^DD(125,.03,21,0)
	;;=^^4^4^2940202^^^^
	;;^DD(125,.03,21,1,0)
	;;=This is the clinic to be associated with this list.  This should be the
	;;^DD(125,.03,21,2,0)
	;;=primary clinic in which this list will be used to populate patient
	;;^DD(125,.03,21,3,0)
	;;=problem lists; when adding new problems for a patient from this clinic,
	;;^DD(125,.03,21,4,0)
	;;=this list will automatically be presented to select problems from.
	;;^DD(125,.03,"DT")
	;;=2940202
