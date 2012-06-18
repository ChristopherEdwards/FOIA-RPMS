GMPLI001	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(49)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(49,0,"GL")
	;;=^DIC(49,
	;;^DIC("B","SERVICE/SECTION",49)
	;;=
	;;^DIC(49,"%",0)
	;;=^1.005^2^2
	;;^DIC(49,"%",1,0)
	;;=QAP
	;;^DIC(49,"%",2,0)
	;;=QAM
	;;^DIC(49,"%","B","QAM",2)
	;;=
	;;^DIC(49,"%","B","QAP",1)
	;;=
	;;^DIC(49,"%D",0)
	;;=^^9^9^2900724^^^
	;;^DIC(49,"%D",1,0)
	;;=This file is a list of the services and sections within the services.
	;;^DIC(49,"%D",2,0)
	;;=Some of the entries may be 'MIS COSTING SECTIONS' for use with the
	;;^DIC(49,"%D",3,0)
	;;=cost accounting part of the Management Information System software.
	;;^DIC(49,"%D",4,0)
	;;=A section is an MIS section if there is a code entered in the field
	;;^DIC(49,"%D",5,0)
	;;=called MIS COSTING CODE.  In the cost accounting system all medical
	;;^DIC(49,"%D",6,0)
	;;=center costs will be tied to a particular section.  When MIS sections
	;;^DIC(49,"%D",7,0)
	;;=change, do not delete the old section.  Instead, change the fields under
	;;^DIC(49,"%D",8,0)
	;;=the multiple field called "DATE CLOSED" to identify which sections are
	;;^DIC(49,"%D",9,0)
	;;=no longer in use.
	;;^DD(49,0)
	;;=FIELD^NL^16000^19
	;;^DD(49,0,"DDA")
	;;=N
	;;^DD(49,0,"DT")
	;;=2930202
	;;^DD(49,0,"ID",1.5)
	;;=W "   ",$P(^(0),U,8)
	;;^DD(49,0,"ID",1.6)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DIC(49,+$P(^(0),U,4),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(49,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(49,0,"IX","AC",49,10)
	;;=
	;;^DD(49,0,"IX","ACHLD",49,1.6)
	;;=
	;;^DD(49,0,"IX","AD",49,10)
	;;=
	;;^DD(49,0,"IX","B",49,.01)
	;;=
	;;^DD(49,0,"IX","C",49,1)
	;;=
	;;^DD(49,0,"IX","D",49,1.5)
	;;=
	;;^DD(49,0,"IX","D",49.01,.01)
	;;=
	;;^DD(49,0,"IX","E",49,9)
	;;=
	;;^DD(49,0,"IX","F",49,1.7)
	;;=
	;;^DD(49,0,"NM","SERVICE/SECTION")
	;;=
	;;^DD(49,0,"PT",3,29)
	;;=
	;;^DD(49,0,"PT",43,919)
	;;=
	;;^DD(49,0,"PT",45.7,2)
	;;=
	;;^DD(49,0,"PT",49,1.6)
	;;=
	;;^DD(49,0,"PT",59,1003)
	;;=
	;;^DD(49,0,"PT",70.03,7)
	;;=
	;;^DD(49,0,"PT",123.5,123.07)
	;;=
	;;^DD(49,0,"PT",200,29)
	;;=
	;;^DD(49,0,"PT",350.1,.04)
	;;=
	;;^DD(49,0,"PT",350.9,1.14)
	;;=
	;;^DD(49,0,"PT",410,6.3)
	;;=
	;;^DD(49,0,"PT",420.01,.5)
	;;=
	;;^DD(49,0,"PT",421.51,.01)
	;;=
	;;^DD(49,0,"PT",430,101)
	;;=
	;;^DD(49,0,"PT",430.4,4)
	;;=
	;;^DD(49,0,"PT",442,5.2)
	;;=
	;;^DD(49,0,"PT",443.6,5.2)
	;;=
	;;^DD(49,0,"PT",445.011,.01)
	;;=
	;;^DD(49,0,"PT",743,1)
	;;=
	;;^DD(49,0,"PT",605571.01,3)
	;;=
	;;^DD(49,0,"PT",605571.01,6)
	;;=
	;;^DD(49,0,"PT",9000011,1.06)
	;;=
	;;^DD(49,.01,0)
	;;=NAME^R^^0;1^K:$L(X)>30!(+X=X)!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
	;;^DD(49,.01,1,0)
	;;=^.1
	;;^DD(49,.01,1,1,0)
	;;=49^B
	;;^DD(49,.01,1,1,1)
	;;=S ^DIC(49,"B",$E(X,1,30),DA)=""
	;;^DD(49,.01,1,1,2)
	;;=K ^DIC(49,"B",$E(X,1,30),DA)
	;;^DD(49,.01,3)
	;;=NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION
	;;^DD(49,.01,21,0)
	;;=^^1^1^2910114^
	;;^DD(49,.01,21,1,0)
	;;=Enter Service or Section name.
	;;^DD(49,.01,"DT")
	;;=2901214
	;;^DD(49,1.6,0)
	;;=PARENT SERVICE^P49'^DIC(49,^0;4^Q
	;;^DD(49,1.6,1,0)
	;;=^.1
	;;^DD(49,1.6,1,1,0)
	;;=49^ACHLD
	;;^DD(49,1.6,1,1,1)
	;;=S ^DIC(49,"ACHLD",$E(X,1,30),DA)=""
	;;^DD(49,1.6,1,1,2)
	;;=K ^DIC(49,"ACHLD",$E(X,1,30),DA)
	;;^DD(49,1.6,1,1,"%D",0)
	;;=^^2^2^2930426^
	;;^DD(49,1.6,1,1,"%D",1,0)
	;;=If a selected  service is a 'parent' service, then all subordinate
	;;^DD(49,1.6,1,1,"%D",2,0)
	;;=services may be retrieved as well upon selection via this cross-reference.
	;;^DD(49,1.6,1,1,"DT")
	;;=2930426
	;;^DD(49,1.6,3)
	;;=Type the name of the service or section which is 'parent' to this section.  If this is an MIS Costing Section w/in medicine of surgery, type the MIS 'sub-specialty' admin sectn to which this belongs.
