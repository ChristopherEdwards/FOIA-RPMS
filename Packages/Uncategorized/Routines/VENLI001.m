VENLI001 ; ; 28-NOV-2006
 ;;2.6;PCC+;;NOV 12, 2007
 Q:'DIFQ(9000010.16)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(9000010.16,0,"GL")
 ;;=^AUPNVPED(
 ;;^DIC("B","V PATIENT ED",9000010.16)
 ;;=
 ;;^DIC(9000010.16,"%D",0)
 ;;=7^^7^7^2950901^^
 ;;^DIC(9000010.16,"%D",1,0)
 ;;=This file has been designed for joint use by the Indian Health Service and
 ;;^DIC(9000010.16,"%D",2,0)
 ;;=the Department of Veteran Affairs.
 ;;^DIC(9000010.16,"%D",3,0)
 ;;= 
 ;;^DIC(9000010.16,"%D",4,0)
 ;;=This is the file which stores the patient education given to a patient 
 ;;^DIC(9000010.16,"%D",5,0)
 ;;=or his responsible care giver. Data must exist in the Patient/IHS file and
 ;;^DIC(9000010.16,"%D",6,0)
 ;;=Visit file for a patient visit before data can be entered in the V Patient
 ;;^DIC(9000010.16,"%D",7,0)
 ;;=Ed File.
 ;;^DD(9000010.16,0)
 ;;=FIELD^^81203^29
 ;;^DD(9000010.16,0,"DDA")
 ;;=N
 ;;^DD(9000010.16,0,"DT")
 ;;=3060203
 ;;^DD(9000010.16,0,"ID",.02)
 ;;=W "   ",$S($D(^DPT(+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),@("$E("_DIC_"Y,0),0)")
 ;;^DD(9000010.16,0,"ID",.03)
 ;;=W "   " S AIHSY=Y,Y=$S($D(^AUPNVSIT(+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:"") X:Y ^DD("DD") W Y S Y=AIHSY K AIHSY W @("$E("_DIC_"Y,0),0)")
 ;;^DD(9000010.16,0,"IX","AA",9000010.16,.03)
 ;;=
 ;;^DD(9000010.16,0,"IX","AATOO",9000010.16,.02)
 ;;=
 ;;^DD(9000010.16,0,"IX","AAVA",9000010.16,.01)
 ;;=
 ;;^DD(9000010.16,0,"IX","AAVATOO",9000010.16,.02)
 ;;=
 ;;^DD(9000010.16,0,"IX","AAVATOOO",9000010.16,.03)
 ;;=
 ;;^DD(9000010.16,0,"IX","AC",9000010.16,.02)
 ;;=
 ;;^DD(9000010.16,0,"IX","AD",9000010.16,.03)
 ;;=
 ;;^DD(9000010.16,0,"IX","AV10",9000010.16,.03)
 ;;=
 ;;^DD(9000010.16,0,"IX","AV9",9000010.16,.01)
 ;;=
 ;;^DD(9000010.16,0,"IX","AZ10",9000010.16,.03)
 ;;=
 ;;^DD(9000010.16,0,"IX","AZ9",9000010.16,.01)
 ;;=
 ;;^DD(9000010.16,0,"IX","B",9000010.16,.01)
 ;;=
 ;;^DD(9000010.16,0,"NM","V PATIENT ED")
 ;;=
 ;;^DD(9000010.16,0,"PT",9000010.16,1208)
 ;;=
 ;;^DD(9000010.16,0,"PT",9000010.433,.01)
 ;;=
 ;;^DD(9000010.16,0,"VRPK")
 ;;=AUPN
 ;;^DD(9000010.16,.01,0)
 ;;=TOPIC^R*P9999999.09'^AUTTEDT(^0;1^S DIC("S")="I $P(^(0),U,3)'=1" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 ;;^DD(9000010.16,.01,1,0)
 ;;=^.1
 ;;^DD(9000010.16,.01,1,1,0)
 ;;=9000010.16^B
 ;;^DD(9000010.16,.01,1,1,1)
 ;;=S ^AUPNVPED("B",$E(X,1,30),DA)=""
 ;;^DD(9000010.16,.01,1,1,2)
 ;;=K ^AUPNVPED("B",$E(X,1,30),DA)
 ;;^DD(9000010.16,.01,1,2,0)
 ;;=9000010.16^AV9^MUMPS
 ;;^DD(9000010.16,.01,1,2,1)
 ;;=S:$D(APCDLOOK) DIC("DR")=""
 ;;^DD(9000010.16,.01,1,2,2)
 ;;=Q
 ;;^DD(9000010.16,.01,1,3,0)
 ;;=9000010.16^AAVA^MUMPS
 ;;^DD(9000010.16,.01,1,3,1)
 ;;=I $P(^AUPNVPED(DA,0),U,2),$P(^(0),U,3) S ^AUPNVPED("AAVA",$P(^AUPNVPED(DA,0),U,2),X,(9999999-$P(+^AUPNVSIT($P(^AUPNVPED(DA,0),U,3),0),".",1)),DA)=""
 ;;^DD(9000010.16,.01,1,3,2)
 ;;=I $P(^AUPNVPED(DA,0),U,2),$P(^(0),U,3) K ^AUPNVPED("AAVA",$P(^AUPNVPED(DA,0),U,2),X,(9999999-$P(+^AUPNVSIT($P(^AUPNVPED(DA,0),U,3),0),".",1)),DA)
 ;;^DD(9000010.16,.01,1,3,"DT")
 ;;=3050711
 ;;^DD(9000010.16,.01,3)
 ;;=Select the topic on which education was delivered.
 ;;^DD(9000010.16,.01,12)
 ;;=Only active Education Topics may be selected.
 ;;^DD(9000010.16,.01,12.1)
 ;;=S DIC("S")="I $P(^(0),U,3)'=1"
 ;;^DD(9000010.16,.01,21,0)
 ;;=^^1^1^2870422^
 ;;^DD(9000010.16,.01,21,1,0)
 ;;=Pointer to the EDUCATION TOPICS file.
 ;;^DD(9000010.16,.01,21,2,0)
 ;;=education given to the patient.
 ;;^DD(9000010.16,.01,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.16,.01,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTTOP")
 ;;^DD(9000010.16,.01,"DT")
 ;;=3050711
 ;;^DD(9000010.16,.02,0)
 ;;=PATIENT NAME^RP9000001'I^AUPNPAT(^0;2^Q
 ;;^DD(9000010.16,.02,1,0)
 ;;=^.1
 ;;^DD(9000010.16,.02,1,1,0)
 ;;=9000010.16^AC
 ;;^DD(9000010.16,.02,1,1,1)
 ;;=S ^AUPNVPED("AC",$E(X,1,30),DA)=""
 ;;^DD(9000010.16,.02,1,1,2)
 ;;=K ^AUPNVPED("AC",$E(X,1,30),DA)
 ;;^DD(9000010.16,.02,1,2,0)
 ;;=9000010.16^AATOO^MUMPS
 ;;^DD(9000010.16,.02,1,2,1)
 ;;=I $P(^AUPNVPED(DA,0),U,3)]"" S ^AUPNVPED("AA",X,(9999999-$P(+^AUPNVSIT($P(^AUPNVPED(DA,0),U,3),0),".",1)),DA)=""
 ;;^DD(9000010.16,.02,1,2,2)
 ;;=I $P(^AUPNVPED(DA,0),U,3)]"" K ^AUPNVPED("AA",X,(9999999-$P(+^AUPNVSIT($P(^AUPNVPED(DA,0),U,3),0),".",1)),DA)
 ;;^DD(9000010.16,.02,1,3,0)
 ;;=9000010.16^AAVATOO^MUMPS
 ;;^DD(9000010.16,.02,1,3,1)
 ;;=I $P(^AUPNVPED(DA,0),U),$P(^AUPNVPED(DA,0),U,3) S ^AUPNVPED("AAVA",X,$P(^AUPNVPED(DA,0),U),(9999999-$P(+^AUPNVSIT($P(^AUPNVPED(DA,0),U,3),0),".",1)),DA)=""
 ;;^DD(9000010.16,.02,1,3,2)
 ;;=I $P(^AUPNVPED(DA,0),U),$P(^AUPNVPED(DA,0),U,3) K ^AUPNVPED("AAVA",X,$P(^AUPNVPED(DA,0),U),(9999999-$P(+^AUPNVSIT($P(^AUPNVPED(DA,0),U,3),0),".",1)),DA)
 ;;^DD(9000010.16,.02,1,3,"DT")
 ;;=3050711
 ;;^DD(9000010.16,.02,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.16,.02,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDPAT")
 ;;^DD(9000010.16,.02,"DT")
 ;;=3050711
 ;;^DD(9000010.16,.03,0)
 ;;=VISIT^R*P9000010'I^AUPNVSIT(^0;3^S DIC("S")="I $P(^(0),U,5)=$P(^AUPNVPED(DA,0),U,2)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 ;;^DD(9000010.16,.03,1,0)
 ;;=^.1
 ;;^DD(9000010.16,.03,1,1,0)
 ;;=9000010.16^AD
 ;;^DD(9000010.16,.03,1,1,1)
 ;;=S ^AUPNVPED("AD",$E(X,1,30),DA)=""
 ;;^DD(9000010.16,.03,1,1,2)
 ;;=K ^AUPNVPED("AD",$E(X,1,30),DA)
 ;;^DD(9000010.16,.03,1,2,0)
 ;;=9000010.16^AA^MUMPS
 ;;^DD(9000010.16,.03,1,2,1)
 ;;=Q:$P(^AUPNVPED(DA,0),U,2)=""  S ^AUPNVPED("AA",$P(^AUPNVPED(DA,0),U,2),(9999999-$P(+^AUPNVSIT(X,0),".",1)),DA)=""
 ;;^DD(9000010.16,.03,1,2,2)
 ;;=Q:$P(^AUPNVPED(DA,0),U,2)=""  K ^AUPNVPED("AA",$P(^AUPNVPED(DA,0),U,2),(9999999-$P(+^AUPNVSIT(X,0),".",1)),DA)
 ;;^DD(9000010.16,.03,1,2,"%D",0)
 ;;=^^2^2^2940131^
 ;;^DD(9000010.16,.03,1,2,"%D",1,0)
 ;;=This is a Health Summary cross-reference.
 ;;^DD(9000010.16,.03,1,2,"%D",2,0)
 ;;="AA",PATIENT,VISIT,DA
 ;;^DD(9000010.16,.03,1,3,0)
 ;;=9000010.16^AV10^MUMPS
 ;;^DD(9000010.16,.03,1,3,1)
 ;;=D ADD^AUPNVSIT
 ;;^DD(9000010.16,.03,1,3,2)
 ;;=D SUB^AUPNVSIT
 ;;^DD(9000010.16,.03,1,3,"%D",0)
 ;;=^^2^2^2940131^
 ;;^DD(9000010.16,.03,1,3,"%D",1,0)
 ;;=This cross-reference adds and subtracts from the dependent entry count in
 ;;^DD(9000010.16,.03,1,3,"%D",2,0)
 ;;=the VISIT file.
 ;;^DD(9000010.16,.03,1,4,0)
 ;;=9000010.16^AAVATOOO^MUMPS
 ;;^DD(9000010.16,.03,1,4,1)
 ;;=I $P(^AUPNVPED(DA,0),U),$P(^(0),U,2) S ^AUPNVPED("AAVA",$P(^AUPNVPED(DA,0),U,2),$P(^AUPNVPED(DA,0),U,1),(9999999-$P(+^AUPNVSIT($P(^AUPNVPED(DA,0),U,3),0),".",1)),DA)=""
 ;;^DD(9000010.16,.03,1,4,2)
 ;;=I $P(^AUPNVPED(DA,0),U),$P(^(0),U,2) K ^AUPNVPED("AAVA",$P(^AUPNVPED(DA,0),U,2),$P(^AUPNVPED(DA,0),U,1),(9999999-$P(+^AUPNVSIT($P(^AUPNVPED(DA,0),U,3),0),".",1)),DA)
 ;;^DD(9000010.16,.03,1,4,"DT")
 ;;=3050711
 ;;^DD(9000010.16,.03,3)
 ;;=Enter the visit date/time for the encounter where the education was provided.
 ;;^DD(9000010.16,.03,12)
 ;;=VISIT MUST BE FOR CURRENT PATIENT
 ;;^DD(9000010.16,.03,12.1)
 ;;=S DIC("S")="I $P(^(0),U,5)=$P(^AUPNVPED(DA,0),U,2)"
 ;;^DD(9000010.16,.03,21,0)
 ;;=^^2^2^2950901^
 ;;^DD(9000010.16,.03,21,1,0)
 ;;=This is the encounter or occasion of service defined in the Visit file
 ;;^DD(9000010.16,.03,21,2,0)
 ;;=that represents when and where the education was provided.
 ;;^DD(9000010.16,.03,23,0)
 ;;=^^3^3^2960924^
 ;;^DD(9000010.16,.03,23,1,0)
 ;;=This is a pointer to the Visit File (#9000010).  This field is stuffed by
 ;;^DD(9000010.16,.03,23,2,0)
 ;;=the applications. No editing is allowed.
 ;;^DD(9000010.16,.03,23,3,0)
 ;;=APCDALVR Variable = APCDALVR("APCDVSIT")
 ;;^DD(9000010.16,.03,"DT")
 ;;=3050711
 ;;^DD(9000010.16,.04,0)
 ;;=ICD DIAGNOSIS^P80'^ICD9(^0;4^Q
 ;;^DD(9000010.16,.04,"DT")
 ;;=3000323
 ;;^DD(9000010.16,.041,0)
 ;;=ICD TEXT^CJ8^^ ; ^X ^DD(9000010.16,.041,9.2) S Y(9000010.16,.041,101)=$S($D(^ICD9(D0,0)):^(0),1:"") S X=$P(Y(9000010.16,.041,101),U,3) S D0=Y(9000010.16,.041,80)
 ;;^DD(9000010.16,.041,9)
 ;;=^
