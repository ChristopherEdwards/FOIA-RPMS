IBINI05B	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(356)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(356,0,"GL")
	;;=^IBT(356,
	;;^DIC("B","CLAIMS TRACKING",356)
	;;=
	;;^DIC(356,"%D",0)
	;;=^^6^6^2940214^^^^
	;;^DIC(356,"%D",1,0)
	;;=This file may contain entries of all type of billable events that need
	;;^DIC(356,"%D",2,0)
	;;=to be tracked by MCCR.  The information in this file is used for MCCR and
	;;^DIC(356,"%D",3,0)
	;;=or UR purposes.  It is information about the event itself not otherwise
	;;^DIC(356,"%D",4,0)
	;;=stored or pertinent for MCCR purposes.
	;;^DIC(356,"%D",5,0)
	;;= 
	;;^DIC(356,"%D",6,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(356,0)
	;;=FIELD^^1.08^38
	;;^DD(356,0,"DT")
	;;=2940128
	;;^DD(356,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DPT(+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(2,.01,0),U,2) D Y^DIQ:Y]"" W "  ",$E(Y,1,20),@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356,0,"ID",.06)
	;;=W "   ",$E($P(^(0),U,6),4,5)_"-"_$E($P(^(0),U,6),6,7)_"-"_$E($P(^(0),U,6),2,3)
	;;^DD(356,0,"ID",.07)
	;;=I $P(^(0),U,7) W ?38,@("$P($P($C(59)_$S($D(^DD(356,.07,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,7)_"":"",2),$C(59),1)")
	;;^DD(356,0,"ID",.18)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^IBE(356.6,+$P(^(0),U,18),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(356.6,.01,0),U,2) D Y^DIQ:Y]"" W " ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(356,0,"ID","WRITE")
	;;=D ID^IBTRE20
	;;^DD(356,0,"IX","ABD",356,.17)
	;;=
	;;^DD(356,0,"IX","AC",356,.12)
	;;=
	;;^DD(356,0,"IX","AD",356,.05)
	;;=
	;;^DD(356,0,"IX","ADFN",356,.02)
	;;=
	;;^DD(356,0,"IX","ADM",356,.05)
	;;=
	;;^DD(356,0,"IX","ADM1",356,.02)
	;;=
	;;^DD(356,0,"IX","AENC",356,.04)
	;;=
	;;^DD(356,0,"IX","AENC1",356,.02)
	;;=
	;;^DD(356,0,"IX","AI",356,.24)
	;;=
	;;^DD(356,0,"IX","ANABD1",356,.19)
	;;=
	;;^DD(356,0,"IX","ANABD2",356,.2)
	;;=
	;;^DD(356,0,"IX","ANABD3",356,.18)
	;;=
	;;^DD(356,0,"IX","APRO",356,.09)
	;;=
	;;^DD(356,0,"IX","APTDT",356,.06)
	;;=
	;;^DD(356,0,"IX","APTDT1",356,.02)
	;;=
	;;^DD(356,0,"IX","APTY",356,.02)
	;;=
	;;^DD(356,0,"IX","APTY1",356,.06)
	;;=
	;;^DD(356,0,"IX","APTY2",356,.18)
	;;=
	;;^DD(356,0,"IX","AR",356,.19)
	;;=
	;;^DD(356,0,"IX","ARXFL",356,.1)
	;;=
	;;^DD(356,0,"IX","ARXFL1",356,.08)
	;;=
	;;^DD(356,0,"IX","ASCE",356,.04)
	;;=
	;;^DD(356,0,"IX","ASCH",356,.32)
	;;=
	;;^DD(356,0,"IX","ASPC",356,.12)
	;;=
	;;^DD(356,0,"IX","ASPC1",356,.02)
	;;=
	;;^DD(356,0,"IX","ATOBIL",356,.02)
	;;=
	;;^DD(356,0,"IX","ATOBIL1",356,.17)
	;;=
	;;^DD(356,0,"IX","AVSIT",356,.03)
	;;=
	;;^DD(356,0,"IX","B",356,.01)
	;;=
	;;^DD(356,0,"IX","C",356,.02)
	;;=
	;;^DD(356,0,"IX","D",356,.06)
	;;=
	;;^DD(356,0,"IX","E",356,.11)
	;;=
	;;^DD(356,0,"IX","EVNT",356,.18)
	;;=
	;;^DD(356,0,"NM","CLAIMS TRACKING")
	;;=
	;;^DD(356,0,"PT",356.1,.02)
	;;=
	;;^DD(356,0,"PT",356.2,.02)
	;;=
	;;^DD(356,0,"PT",356.399,.01)
	;;=
	;;^DD(356,0,"PT",362.1,.02)
	;;=
	;;^DD(356,.01,0)
	;;=ENTRY ID^RNJ11,0^^0;1^K:+X'=X!(X>99999999999)!(X<1001)!(X?.E1"."1N.N) X
	;;^DD(356,.01,1,0)
	;;=^.1
	;;^DD(356,.01,1,1,0)
	;;=356^B
	;;^DD(356,.01,1,1,1)
	;;=S ^IBT(356,"B",$E(X,1,30),DA)=""
	;;^DD(356,.01,1,1,2)
	;;=K ^IBT(356,"B",$E(X,1,30),DA)
	;;^DD(356,.01,3)
	;;=Type a Number between 1001 and 99999999999, 0 Decimal Digits
	;;^DD(356,.01,21,0)
	;;=^^2^2^2930609^
	;;^DD(356,.01,21,1,0)
	;;=This is a unique number assigned to this entry.  The first 3 characters
	;;^DD(356,.01,21,2,0)
	;;=of the number are the station number.
	;;^DD(356,.01,"DEL",1,0)
	;;=I $P(^IBT(356,DA,0),U,2) W *7,!,"Only can be deleted from Menus"
	;;^DD(356,.01,"DT")
	;;=2930609
	;;^DD(356,.02,0)
	;;=PATIENT^P2'^DPT(^0;2^Q
	;;^DD(356,.02,1,0)
	;;=^.1
