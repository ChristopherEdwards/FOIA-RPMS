IBINI01U	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(350.5,0,"GL")
	;;=^IBE(350.5,
	;;^DIC("B","BASC LOCALITY MODIFIER",350.5)
	;;=
	;;^DIC(350.5,"%D",0)
	;;=^^7^7^2940214^^^^
	;;^DIC(350.5,"%D",1,0)
	;;=This file is used in the calculation of the charge for an ambulatory
	;;^DIC(350.5,"%D",2,0)
	;;=surgery performed on any given date. This file contains time sensitive data
	;;^DIC(350.5,"%D",3,0)
	;;=with each entry defining a locality modifier and wage percentage for a
	;;^DIC(350.5,"%D",4,0)
	;;=division. There may be multiple entries for each division indicating changes
	;;^DIC(350.5,"%D",5,0)
	;;=effective on a particular date.
	;;^DIC(350.5,"%D",6,0)
	;;= 
	;;^DIC(350.5,"%D",7,0)
	;;=Per VHA Directive 10-93-142, this file definition should not be modified.
	;;^DD(350.5,0)
	;;=FIELD^^.07^6
	;;^DD(350.5,0,"DDA")
	;;=N
	;;^DD(350.5,0,"DT")
	;;=2920121
	;;^DD(350.5,0,"ID",.02)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DG(40.8,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(40.8,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(350.5,0,"ID",.04)
	;;=W "   ",@("$P($P($C(59)_$S($D(^DD(350.5,.04,0)):$P(^(0),U,3),1:0)_$E("_DIC_"Y,0),0),$C(59)_$P(^(0),U,4)_"":"",2),$C(59),1)")
	;;^DD(350.5,0,"ID",.07)
	;;=W "   ",$P(^(0),U,7)
	;;^DD(350.5,0,"IX","AIVDT",350.5,.01)
	;;=
	;;^DD(350.5,0,"IX","AIVDT1",350.5,.02)
	;;=
	;;^DD(350.5,0,"IX","B",350.5,.01)
	;;=
	;;^DD(350.5,0,"IX","C",350.5,.02)
	;;=
	;;^DD(350.5,0,"NM","BASC LOCALITY MODIFIER")
	;;=
	;;^DD(350.5,.01,0)
	;;=EFFECTIVE DATE^RD^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(350.5,.01,1,0)
	;;=^.1
	;;^DD(350.5,.01,1,1,0)
	;;=350.5^B
	;;^DD(350.5,.01,1,1,1)
	;;=S ^IBE(350.5,"B",$E(X,1,30),DA)=""
	;;^DD(350.5,.01,1,1,2)
	;;=K ^IBE(350.5,"B",$E(X,1,30),DA)
	;;^DD(350.5,.01,1,2,0)
	;;=350.5^AIVDT^MUMPS
	;;^DD(350.5,.01,1,2,1)
	;;=I $P(^IBE(350.5,DA,0),"^",2) S ^IBE(350.5,"AIVDT",$P(^(0),"^",2),-X,DA)=""
	;;^DD(350.5,.01,1,2,2)
	;;=I $P(^IBE(350.5,DA,0),"^",2) K ^IBE(350.5,"AIVDT",$P(^(0),"^",2),-X,DA)
	;;^DD(350.5,.01,1,2,"%D",0)
	;;=^^1^1^2911113^^
	;;^DD(350.5,.01,1,2,"%D",1,0)
	;;=Used to find the appropriate entry for a division on any particular date.
	;;^DD(350.5,.01,1,2,"DT")
	;;=2911113
	;;^DD(350.5,.01,3)
	;;=
	;;^DD(350.5,.01,21,0)
	;;=^^3^3^2911113^^
	;;^DD(350.5,.01,21,1,0)
	;;=The date on which this entries data becomes effective.
	;;^DD(350.5,.01,21,2,0)
	;;=The data in this entry will override any other entry for
	;;^DD(350.5,.01,21,3,0)
	;;=this DIVISION that has a previous EFFECTIVE DATE.
	;;^DD(350.5,.01,"DT")
	;;=2911113
	;;^DD(350.5,.02,0)
	;;=DIVISION^RP40.8'^DG(40.8,^0;2^Q
	;;^DD(350.5,.02,1,0)
	;;=^.1
	;;^DD(350.5,.02,1,1,0)
	;;=350.5^C
	;;^DD(350.5,.02,1,1,1)
	;;=S ^IBE(350.5,"C",$E(X,1,30),DA)=""
	;;^DD(350.5,.02,1,1,2)
	;;=K ^IBE(350.5,"C",$E(X,1,30),DA)
	;;^DD(350.5,.02,1,1,"DT")
	;;=2910829
	;;^DD(350.5,.02,1,2,0)
	;;=350.5^AIVDT1^MUMPS
	;;^DD(350.5,.02,1,2,1)
	;;=I $P(^IBE(350.5,DA,0),"^") S ^IBE(350.5,"AIVDT",X,-$P(^(0),"^"),DA)=""
	;;^DD(350.5,.02,1,2,2)
	;;=I $P(^IBE(350.5,DA,0),"^") K ^IBE(350.5,"AIVDT",X,-$P(^(0),"^"),DA)
	;;^DD(350.5,.02,1,2,"%D",0)
	;;=^^1^1^2911113^
	;;^DD(350.5,.02,1,2,"%D",1,0)
	;;=Used to find the correct entry for a division for a particular date.
	;;^DD(350.5,.02,1,2,"DT")
	;;=2910829
	;;^DD(350.5,.02,21,0)
	;;=^^1^1^2920121^^
	;;^DD(350.5,.02,21,1,0)
	;;=The division that this data applies to.
	;;^DD(350.5,.02,"DT")
	;;=2920121
	;;^DD(350.5,.04,0)
	;;=STATUS^RS^1:ACTIVE;0:INACTIVE;^0;4^Q
	;;^DD(350.5,.04,21,0)
	;;=^^1^1^2920723^^^
	;;^DD(350.5,.04,21,1,0)
	;;=The status for this DIVISION on/after this EFFECTIVE DATE.
