APC7I001 ; ; 29-OCT-2002
 ;;2.0;APC7;;OCT 29, 2002
 Q:'DIFQ(9000010.09)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(9000010.09,0,"GL")
 ;;=^AUPNVLAB(
 ;;^DIC("B","V LAB",9000010.09)
 ;;=
 ;;^DIC(9000010.09,"%D",0)
 ;;=^^7^7^2941125^^^^
 ;;^DIC(9000010.09,"%D",1,0)
 ;;=This file contains all lab tests ordered, with results being entered
 ;;^DIC(9000010.09,"%D",2,0)
 ;;=optionally for selected tests.  The file does not currently interface with
 ;;^DIC(9000010.09,"%D",3,0)
 ;;=the VA Radiology system.  The file contains backward pointers to the IHS 
 ;;^DIC(9000010.09,"%D",4,0)
 ;;=Patient file, and visit file, and data must exist in both of these files for
 ;;^DIC(9000010.09,"%D",5,0)
 ;;=a visit for before data can be entered here. There will be one record for
 ;;^DIC(9000010.09,"%D",6,0)
 ;;=each type lab test ordered for the patient on a given visit; the .01 record
 ;;^DIC(9000010.09,"%D",7,0)
 ;;=may therefore be duplicated.
 ;;^DIC(9000010.09,"%D",8,0)
 ;;=on a given visit; the .01 record may therefore be duplicated.
 ;;^DD(9000010.09,0)
 ;;=FIELD^^2100^38
 ;;^DD(9000010.09,0,"DDA")
 ;;=N
 ;;^DD(9000010.09,0,"DT")
 ;;=3021029
 ;;^DD(9000010.09,0,"ID",.02)
 ;;=W "   ",$S($D(^AUPNPAT(+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),@("$E("_DIC_"Y,0),0)")
 ;;^DD(9000010.09,0,"ID",.03)
 ;;=W "   ",$S($D(^AUPNVSIT(+$P(^(0),U,3),0))#2:$P(^(0),U,1),1:""),@("$E("_DIC_"Y,0),0)")
 ;;^DD(9000010.09,0,"ID",.06)
 ;;=W ""
 ;;^DD(9000010.09,0,"IX","AA",9000010.09,.03)
 ;;=
 ;;^DD(9000010.09,0,"IX","AATOO",9000010.09,.02)
 ;;=
 ;;^DD(9000010.09,0,"IX","AATOO2",9000010.09,.01)
 ;;=
 ;;^DD(9000010.09,0,"IX","AC",9000010.09,.02)
 ;;=
 ;;^DD(9000010.09,0,"IX","AD",9000010.09,.03)
 ;;=
 ;;^DD(9000010.09,0,"IX","AE",9000010.09,.03)
 ;;=
 ;;^DD(9000010.09,0,"IX","AETOO",9000010.09,.01)
 ;;=
 ;;^DD(9000010.09,0,"IX","AETOO2",9000010.09,.02)
 ;;=
 ;;^DD(9000010.09,0,"IX","ALR",9000010.09,.06)
 ;;=
 ;;^DD(9000010.09,0,"IX","ALR0",9000010.09,.06)
 ;;=
 ;;^DD(9000010.09,0,"IX","AOP",9000010.09,1202)
 ;;=
 ;;^DD(9000010.09,0,"IX","AOP2",9000010.09,.02)
 ;;=
 ;;^DD(9000010.09,0,"IX","AOP3",9000010.09,.03)
 ;;=
 ;;^DD(9000010.09,0,"IX","AQ",9000010.09,.04)
 ;;=
 ;;^DD(9000010.09,0,"IX","AQTOO",9000010.09,.01)
 ;;=
 ;;^DD(9000010.09,0,"IX","AR",9000010.09,.04)
 ;;=
 ;;^DD(9000010.09,0,"IX","ARDT",9000010.09,1212)
 ;;=
 ;;^DD(9000010.09,0,"IX","AV10",9000010.09,.03)
 ;;=
 ;;^DD(9000010.09,0,"IX","AV9",9000010.09,.01)
 ;;=
 ;;^DD(9000010.09,0,"IX","B",9000010.09,.01)
 ;;=
 ;;^DD(9000010.09,0,"NM","V LAB")
 ;;=
 ;;^DD(9000010.09,0,"PT",68.999999901,.04)
 ;;=
 ;;^DD(9000010.09,0,"PT",90221,.01)
 ;;=
 ;;^DD(9000010.09,0,"PT",9000010.09,1208)
 ;;=
 ;;^DD(9000010.09,0,"VRPK")
 ;;=APCD
 ;;^DD(9000010.09,.01,0)
 ;;=LAB TEST^RP60'^LAB(60,^0;1^Q
 ;;^DD(9000010.09,.01,1,0)
 ;;=^.1
 ;;^DD(9000010.09,.01,1,1,0)
 ;;=9000010.09^B
 ;;^DD(9000010.09,.01,1,1,1)
 ;;=S ^AUPNVLAB("B",$E(X,1,30),DA)=""
 ;;^DD(9000010.09,.01,1,1,2)
 ;;=K ^AUPNVLAB("B",$E(X,1,30),DA)
 ;;^DD(9000010.09,.01,1,2,0)
 ;;=9000010.09^AV9^MUMPS
 ;;^DD(9000010.09,.01,1,2,1)
 ;;=S:$D(APCDLOOK) DIC("DR")=""
 ;;^DD(9000010.09,.01,1,2,2)
 ;;=Q
 ;;^DD(9000010.09,.01,1,2,"DT")
 ;;=2960709
 ;;^DD(9000010.09,.01,1,3,0)
 ;;=9000010.09^AATOO2^MUMPS
 ;;^DD(9000010.09,.01,1,3,1)
 ;;=I $P(^AUPNVLAB(DA,0),U,2)]"",$P(^(0),U,3)]"" S ^AUPNVLAB("AA",$P(^AUPNVLAB(DA,0),U,2),X,(9999999-$P(+^AUPNVSIT($P(^AUPNVLAB(DA,0),U,3),0),".",1)),DA)=""
 ;;^DD(9000010.09,.01,1,3,2)
 ;;=I $P(^AUPNVLAB(DA,0),U,2)]"",$P(^(0),U,3)]"" K ^AUPNVLAB("AA",$P(^AUPNVLAB(DA,0),U,2),X,(9999999-$P(+^AUPNVSIT($P(^AUPNVLAB(DA,0),U,3),0),".",1)),DA)
 ;;^DD(9000010.09,.01,1,4,0)
 ;;=9000010.09^AETOO^MUMPS
 ;;^DD(9000010.09,.01,1,4,1)
 ;;=I $P(^AUPNVLAB(DA,0),U,2)]"",$P(^(0),U,3)]"" S ^AUPNVLAB("AE",$P(^AUPNVLAB(DA,0),U,2),(9999999-$P(+^AUPNVSIT($P(^AUPNVLAB(DA,0),U,3),0),".",1)),X,DA)=""
 ;;^DD(9000010.09,.01,1,4,2)
 ;;=I $P(^AUPNVLAB(DA,0),U,2)]"",$P(^(0),U,3)]"" K ^AUPNVLAB("AE",$P(^AUPNVLAB(DA,0),U,2),(9999999-$P(+^AUPNVSIT($P(^AUPNVLAB(DA,0),U,3),0),".",1)),X,DA)
 ;;^DD(9000010.09,.01,1,5,0)
 ;;=9000010.09^AQTOO^MUMPS
 ;;^DD(9000010.09,.01,1,5,1)
 ;;=N V S V=X N X S X="AUPNCIXL" X ^%ZOSF("TEST") I  S X=V D AQ1^AUPNCIXL
 ;;^DD(9000010.09,.01,1,5,2)
 ;;=N V S V=X N X S X="AUPNCIXL" X ^%ZOSF("TEST") I  S X=V D AQKILL1^AUPNCIXL
 ;;^DD(9000010.09,.01,1,5,"%D",0)
 ;;=^^1^1^2911010^^^
 ;;^DD(9000010.09,.01,1,5,"%D",1,0)
 ;;=Q-MAN XREF
 ;;^DD(9000010.09,.01,1,5,"DT")
 ;;=2910318
 ;;^DD(9000010.09,.01,3)
 ;;=
 ;;^DD(9000010.09,.01,23,0)
 ;;=^^1^1^2960924^
 ;;^DD(9000010.09,.01,23,1,0)
 ;;=APCDALVR Variable = APCDALVR("APCDTLAB")
 ;;^DD(9000010.09,.01,"AUDIT")
 ;;=
 ;;^DD(9000010.09,.01,"DT")
 ;;=2960709
 ;;^DD(9000010.09,1202,0)
 ;;=ORDERING PROVIDER^P6'^DIC(6,^12;2^Q
