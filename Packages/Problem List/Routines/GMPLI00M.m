GMPLI00M	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(9000011)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DIC(9000011,0,"GL")
	;;=^AUPNPROB(
	;;^DIC("B","PROBLEM",9000011)
	;;=
	;;^DIC(9000011,"%D",0)
	;;=^^8^8^2940511^^^^
	;;^DIC(9000011,"%D",1,0)
	;;=This file contains patient specific problems entered by the various
	;;^DIC(9000011,"%D",2,0)
	;;=providers of service.  The PATIENT NAME field (.02) is a backward pointer
	;;^DIC(9000011,"%D",3,0)
	;;=to the IHS PATIENT file.  This file contains one record for each problem
	;;^DIC(9000011,"%D",4,0)
	;;=for each patient, therefore, the KEY field (.01) is duplicated.
	;;^DIC(9000011,"%D",5,0)
	;;= 
	;;^DIC(9000011,"%D",6,0)
	;;=As of March 17, 1986 the FACILITY must be entered prior to the NUMBER.
	;;^DIC(9000011,"%D",7,0)
	;;=If the NUMBER is entered without previously entering the FACILITY the
	;;^DIC(9000011,"%D",8,0)
	;;="AA" index is created with no FACILITY pointer.
	;;^DD(9000011,0)
	;;=FIELD^^1.14^25
	;;^DD(9000011,0,"DDA")
	;;=N
	;;^DD(9000011,0,"DT")
	;;=2940412
	;;^DD(9000011,0,"ID",.02)
	;;=W "   ",$S($D(^DPT(+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),@("$E("_DIC_"Y,0),0)")
	;;^DD(9000011,0,"ID",.06)
	;;=S %I=Y,Y=$S('$D(^(0)):"",$D(^DIC(4,+$P(^(0),U,6),0))#2:$P(^(0),U,1),1:""),C=$P(^DD(4,.01,0),U,2) D Y^DIQ:Y]"" W "   ",Y,@("$E("_DIC_"%I,0),0)") S Y=%I K %I
	;;^DD(9000011,0,"ID",.07)
	;;=W "   ",$P(^(0),U,7)
	;;^DD(9000011,0,"IX","AA",9000011,.07)
	;;=
	;;^DD(9000011,0,"IX","AATOO",9000011,.02)
	;;=
	;;^DD(9000011,0,"IX","AATOO2",9000011,.06)
	;;=
	;;^DD(9000011,0,"IX","AC",9000011,.02)
	;;=
	;;^DD(9000011,0,"IX","ACTIVE",9000011,.12)
	;;=
	;;^DD(9000011,0,"IX","ACTIVE1",9000011,.02)
	;;=
	;;^DD(9000011,0,"IX","AV1",9000011,.06)
	;;=
	;;^DD(9000011,0,"IX","AV9",9000011,.01)
	;;=
	;;^DD(9000011,0,"IX","B",9000011,.01)
	;;=
	;;^DD(9000011,0,"IX","C",9000011,1.01)
	;;=
	;;^DD(9000011,0,"NM","PROBLEM")
	;;=
	;;^DD(9000011,0,"PT",125.8,.01)
	;;=
	;;^DD(9000011,0,"PT",9000010.07,.16)
	;;=
	;;^DD(9000011,0,"SP",.06)
	;;=
	;;^DD(9000011,0,"SP",.07)
	;;=
	;;^DD(9000011,.01,0)
	;;=DIAGNOSIS^R*P80'^ICD9(^0;1^S DIC("S")="I 1 Q:$G(DUZ(""AG""))=""V""  I $E(^(0))'=""E"",$P(^(0),U,9)="""" Q:$P(^(0),U,10)=""""  I $P(^(0),U,10)=AUPNSEX" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
	;;^DD(9000011,.01,1,0)
	;;=^.1
	;;^DD(9000011,.01,1,1,0)
	;;=9000011^B
	;;^DD(9000011,.01,1,1,1)
	;;=S ^AUPNPROB("B",$E(X,1,30),DA)=""
	;;^DD(9000011,.01,1,1,2)
	;;=K ^AUPNPROB("B",$E(X,1,30),DA)
	;;^DD(9000011,.01,1,2,0)
	;;=9000011^AV9^MUMPS
	;;^DD(9000011,.01,1,2,1)
	;;=S:$D(APCDLOOK) DIC("DR")=""
	;;^DD(9000011,.01,1,2,2)
	;;=Q
	;;^DD(9000011,.01,1,2,"%D",0)
	;;=^^2^2^2940110^
	;;^DD(9000011,.01,1,2,"%D",1,0)
	;;=Controls the behaviour of the input templates used by IHS to populate
	;;^DD(9000011,.01,1,2,"%D",2,0)
	;;=and maintain this file.
	;;^DD(9000011,.01,1,2,"DT")
	;;=2940110
	;;^DD(9000011,.01,3)
	;;=Enter the ICD Code for this problem.
	;;^DD(9000011,.01,12)
	;;=Cannot be an E code or an inactive code and must be appropriate for the sex of the Patient.
	;;^DD(9000011,.01,12.1)
	;;=S DIC("S")="I 1 Q:$G(DUZ(""AG""))=""V""  I $E(^(0))'=""E"",$P(^(0),U,9)="""" Q:$P(^(0),U,10)=""""  I $P(^(0),U,10)=AUPNSEX"
	;;^DD(9000011,.01,21,0)
	;;=^^2^2^2930908^^^^
	;;^DD(9000011,.01,21,1,0)
	;;=This is the ICD coded diagnosis of the narrative entered describing
	;;^DD(9000011,.01,21,2,0)
	;;=this problem.
	;;^DD(9000011,.01,23,0)
	;;=^^5^5^2930908^^
	;;^DD(9000011,.01,23,1,0)
	;;=The DHCP Problem List application derives its entries from a lookup
	;;^DD(9000011,.01,23,2,0)
	;;=into the Clinical Lexicon Utility rather than the ICD Diagnosis file.
	;;^DD(9000011,.01,23,3,0)
	;;=If the term selected from the CLU is not coded to ICD, then code 799.99
