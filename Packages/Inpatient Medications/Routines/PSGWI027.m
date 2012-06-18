PSGWI027 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(59.7)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(59.7,0,"GL")
 ;;=^PS(59.7,
 ;;^DIC("B","PHARMACY SYSTEM",59.7)
 ;;=
 ;;^DIC(59.7,"%",0)
 ;;=^1.005^1^1
 ;;^DIC(59.7,"%",1,0)
 ;;=PS
 ;;^DIC(59.7,"%","B","PS",1)
 ;;=
 ;;^DIC(59.7,"%D",0)
 ;;=^^17^17^2921203^^^^
 ;;^DIC(59.7,"%D",1,0)
 ;;=  This file contains data that pertains to the entire Pharmacy system of
 ;;^DIC(59.7,"%D",2,0)
 ;;=a medical center, and not to any one site or division.  The number ranges
 ;;^DIC(59.7,"%D",3,0)
 ;;=for the nodes and field numbers are as follows:
 ;;^DIC(59.7,"%D",4,0)
 ;;=   0 -  9.99  RESERVED
 ;;^DIC(59.7,"%D",5,0)
 ;;=  10 - 19.99  National Drug File
 ;;^DIC(59.7,"%D",6,0)
 ;;=  20 - 29.99  Inpatient
 ;;^DIC(59.7,"%D",7,0)
 ;;=  30 - 39.99  IV's
 ;;^DIC(59.7,"%D",8,0)
 ;;=  40 - 49.99  Outpatient
 ;;^DIC(59.7,"%D",9,0)
 ;;=  50 - 59.99  Ward Stock/AR
 ;;^DIC(59.7,"%D",10,0)
 ;;=  60 - 69.99  Unit Dose
 ;;^DIC(59.7,"%D",11,0)
 ;;= 
 ;;^DIC(59.7,"%D",12,0)
 ;;=  THERE SHOULD ONLY BE ONE ENTRY IN THIS FILE.
 ;;^DIC(59.7,"%D",13,0)
 ;;= 
 ;;^DIC(59.7,"%D",14,0)
 ;;=                           *** NOTE ***
 ;;^DIC(59.7,"%D",15,0)
 ;;=  Because of the nature of this file and the fact that ALL the Pharmacy
 ;;^DIC(59.7,"%D",16,0)
 ;;=packages use this file, it is VERY IMPORTANT to stress that sites DO NOT
 ;;^DIC(59.7,"%D",17,0)
 ;;=edit fields or make local field additions to the Pharmacy System file.
 ;;^DD(59.7,0)
 ;;=FIELD^^70.2^43
 ;;^DD(59.7,0,"DDA")
 ;;=N
 ;;^DD(59.7,0,"DT")
 ;;=2921110
 ;;^DD(59.7,0,"IX","B",59.7,.01)
 ;;=
 ;;^DD(59.7,0,"NM","PHARMACY SYSTEM")
 ;;=
 ;;^DD(59.7,.01,0)
 ;;=SITE NAME^RF^^0;1^K:$L(X)>40!($L(X)<1) X S:$D(X) DINUM=1
 ;;^DD(59.7,.01,1,0)
 ;;=^.1
 ;;^DD(59.7,.01,1,1,0)
 ;;=59.7^B
 ;;^DD(59.7,.01,1,1,1)
 ;;=S ^PS(59.7,"B",$E(X,1,30),DA)=""
 ;;^DD(59.7,.01,1,1,2)
 ;;=K ^PS(59.7,"B",$E(X,1,30),DA)
 ;;^DD(59.7,.01,3)
 ;;=Answer must be 1-40 characters in length
 ;;^DD(59.7,.01,8.5)
 ;;=^
 ;;^DD(59.7,.01,9)
 ;;=^
 ;;^DD(59.7,.01,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.7,.01,20,1,0)
 ;;=PS
 ;;^DD(59.7,.01,21,0)
 ;;=^^1^1^2891031^^^^
 ;;^DD(59.7,.01,21,1,0)
 ;;=  This is the name of the site using the Pharmacy package.
 ;;^DD(59.7,.01,21,2,0)
 ;;=a medical center, and not to any one site or division.  The number ranges
 ;;^DD(59.7,.01,21,3,0)
 ;;=for the nodes and field numbers are as follows:
 ;;^DD(59.7,.01,21,4,0)
 ;;=   0 -  9.99  RESERVED
 ;;^DD(59.7,.01,21,5,0)
 ;;=  10 - 19.99  National Drug File
 ;;^DD(59.7,.01,21,6,0)
 ;;=  20 - 20.99  Inpatient
 ;;^DD(59.7,.01,21,7,0)
 ;;=  30 - 30.99  IV's
 ;;^DD(59.7,.01,21,8,0)
 ;;=  40 - 40.99  Outpatient
 ;;^DD(59.7,.01,21,9,0)
 ;;=  50 - 50.99  Ward Stock/AR
 ;;^DD(59.7,.01,21,10,0)
 ;;=  60 - 60.99  Unit Dose
 ;;^DD(59.7,.01,21,11,0)
 ;;= 
 ;;^DD(59.7,.01,21,12,0)
 ;;=THERE SHOULD ONLY BE ONE ENTRY IN THIS FILE.
 ;;^DD(59.7,.01,"DT")
 ;;=2890728
 ;;^DD(59.7,50,0)
 ;;=AR/WS AMIS UPDATE^MD^^50;1^S %DT="ESTX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(59.7,50,8.5)
 ;;=^
 ;;^DD(59.7,50,9)
 ;;=^
 ;;^DD(59.7,50,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.7,50,20,1,0)
 ;;=PSGW
 ;;^DD(59.7,50,21,0)
 ;;=^^3^3^2910221^^^
 ;;^DD(59.7,50,21,1,0)
 ;;=This field contains the Date/Time that the nightly job to update the
 ;;^DD(59.7,50,21,2,0)
 ;;=AR/WS Stats File (#58.5) was last run to completion.  This field is
 ;;^DD(59.7,50,21,3,0)
 ;;=set automatically when the nightly job is run.
 ;;^DD(59.7,50,"DT")
 ;;=2900209
 ;;^DD(59.7,59.01,0)
 ;;=AR/WS VERSION^NJ7,3^^59.99;1^K:+X'=X!(X>999)!(X<1)!(X?.E1"."4N.N) X
 ;;^DD(59.7,59.01,3)
 ;;=Type a Number between 1 and 999, 3 Decimal Digits
 ;;^DD(59.7,59.01,8.5)
 ;;=^
 ;;^DD(59.7,59.01,9)
 ;;=^
 ;;^DD(59.7,59.01,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.7,59.01,20,1,0)
 ;;=PSGW
 ;;^DD(59.7,59.01,21,0)
 ;;=^^1^1^2891027^^
 ;;^DD(59.7,59.01,21,1,0)
 ;;=This field will contain the current version of the AR/WS package.
 ;;^DD(59.7,59.01,"DT")
 ;;=2890620
 ;;^DD(59.7,59.02,0)
 ;;=DATE INSTALLED^D^^59.99;2^S %DT="EX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(59.7,59.02,3)
 ;;=Enter Date the current AR/WS version was installed.
 ;;^DD(59.7,59.02,8.5)
 ;;=^
 ;;^DD(59.7,59.02,9)
 ;;=^
 ;;^DD(59.7,59.02,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.7,59.02,20,1,0)
 ;;=PSGW
