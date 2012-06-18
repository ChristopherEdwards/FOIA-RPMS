PSGWI004 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(58.1,0,"GL")
 ;;=^PSI(58.1,
 ;;^DIC("B","PHARMACY AOU STOCK",58.1)
 ;;=
 ;;^DIC(58.1,"%",0)
 ;;=^1.005^1^1
 ;;^DIC(58.1,"%",1,0)
 ;;=PSGW
 ;;^DIC(58.1,"%","B","PSGW",1)
 ;;=
 ;;^DIC(58.1,"%D",0)
 ;;=^^3^3^2930603^^^^
 ;;^DIC(58.1,"%D",1,0)
 ;;=This file defines the items, their location, and quantity for each area
 ;;^DIC(58.1,"%D",2,0)
 ;;=of use (AOU) in the hospital.  Additionally, information for each
 ;;^DIC(58.1,"%D",3,0)
 ;;=inventory, by item, is stored for an audit trail of usage.
 ;;^DD(58.1,0)
 ;;=FIELD^^7^10
 ;;^DD(58.1,0,"DDA")
 ;;=N
 ;;^DD(58.1,0,"DT")
 ;;=2930308
 ;;^DD(58.1,0,"ID","WRITE")
 ;;=I $D(^("I")),^("I")]"",^("I")'>DT W "    *** INACTIVE ***" 
 ;;^DD(58.1,0,"IX","AD",58.11,30)
 ;;=
 ;;^DD(58.1,0,"IX","AEXP",58.11,35)
 ;;=
 ;;^DD(58.1,0,"IX","ASITE",58.1,4)
 ;;=
 ;;^DD(58.1,0,"IX","B",58.1,.01)
 ;;=
 ;;^DD(58.1,0,"IX","D",58.26,.01)
 ;;=
 ;;^DD(58.1,0,"IX","OND",58.28,.01)
 ;;=
 ;;^DD(58.1,0,"NM","PHARMACY AOU STOCK")
 ;;=
 ;;^DD(58.1,0,"PT",58.21,.01)
 ;;=
 ;;^DD(58.1,0,"PT",58.24,.01)
 ;;=
 ;;^DD(58.1,0,"PT",58.31,.01)
 ;;=
 ;;^DD(58.1,.01,0)
 ;;=AREA OF USE (AOU)^RF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<2) X
 ;;^DD(58.1,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(58.1,.01,1,1,0)
 ;;=58.1^B
 ;;^DD(58.1,.01,1,1,1)
 ;;=S ^PSI(58.1,"B",$E(X,1,30),DA)=""
 ;;^DD(58.1,.01,1,1,2)
 ;;=K ^PSI(58.1,"B",$E(X,1,30),DA)
 ;;^DD(58.1,.01,3)
 ;;=Answer must be 2-30 characters in length
 ;;^DD(58.1,.01,21,0)
 ;;=^^4^4^2930714^^
 ;;^DD(58.1,.01,21,1,0)
 ;;=This is the name of the Area Of Use.  The AOU may represent a single
 ;;^DD(58.1,.01,21,2,0)
 ;;=ward or a combination of wards and their percentages of the total use.
 ;;^DD(58.1,.01,21,3,0)
 ;;=Areas of Use may also represent an area of the hospital with no affiliated
 ;;^DD(58.1,.01,21,4,0)
 ;;=wards, i.e. cardiac cath lab or dental clinic.
 ;;^DD(58.1,.01,"DEL",13000,0)
 ;;=I $O(^PSI(58.1,DA,1,0)) W !,"AOUs CANNOT BE DELETED IF THERE ARE ITEMS DEFINED!"
 ;;^DD(58.1,.01,"DT")
 ;;=2890920
 ;;^DD(58.1,.5,0)
 ;;=RETURNS CREDITED TO^S^A:AUTOMATIC REPLENISHMENT;W:WARD STOCK - ON DEMAND;^0;2^Q
 ;;^DD(58.1,.5,3)
 ;;=Enter "A" or "W".
 ;;^DD(58.1,.5,21,0)
 ;;=^^2^2^2930714^
 ;;^DD(58.1,.5,21,1,0)
 ;;=For returns purposes, identify the "usual" method of drug
 ;;^DD(58.1,.5,21,2,0)
 ;;=distribution for this Area of Use.
 ;;^DD(58.1,.5,"DT")
 ;;=2870603
 ;;^DD(58.1,.75,0)
 ;;=COUNT ON AMIS?^S^0:YES;1:NO;^0;3^Q
 ;;^DD(58.1,.75,3)
 ;;=Enter "yes" or "no".
 ;;^DD(58.1,.75,21,0)
 ;;=^^5^5^2910221^^^^
 ;;^DD(58.1,.75,21,1,0)
 ;;=Some AOUs are created for internal Inpatient Pharmacy inventory
 ;;^DD(58.1,.75,21,2,0)
 ;;=purposes and should not be included in AMIS counts.  "COUNT ON AMIS?"
 ;;^DD(58.1,.75,21,3,0)
 ;;=will be checked when quantity dispensed is entered to determine
 ;;^DD(58.1,.75,21,4,0)
 ;;=if the data should be added to the AR/WS Stats File.  If answered
 ;;^DD(58.1,.75,21,5,0)
 ;;="NO", then NO data is collected for AMIS calculation for this AOU.
 ;;^DD(58.1,.75,"DT")
 ;;=2870814
 ;;^DD(58.1,1,0)
 ;;=ITEM^58.11IP^^1;0
 ;;^DD(58.1,2,0)
 ;;=WARD/LOCATION (FOR PERCENTAGE)^58.14P^^2;0
 ;;^DD(58.1,3,0)
 ;;=INACTIVE DATE^D^^I;1^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(58.1,3,3)
 ;;=Enter date when this AOU is no longer active.
 ;;^DD(58.1,3,21,0)
 ;;=^^1^1^2890606^^
 ;;^DD(58.1,3,21,1,0)
 ;;=This contains the date on which the AOU was inactivated.
 ;;^DD(58.1,3,"DT")
 ;;=2890606
 ;;^DD(58.1,4,0)
 ;;=INPATIENT SITE^R*P59.4'^PS(59.4,^SITE;1^S DIC("S")="I $P(^(0),""^"",26)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X
 ;;^DD(58.1,4,1,0)
 ;;=^.1
 ;;^DD(58.1,4,1,1,0)
 ;;=58.1^ASITE
 ;;^DD(58.1,4,1,1,1)
 ;;=S ^PSI(58.1,"ASITE",$E(X,1,30),DA)=""
 ;;^DD(58.1,4,1,1,2)
 ;;=K ^PSI(58.1,"ASITE",$E(X,1,30),DA)
 ;;^DD(58.1,4,3)
 ;;=Enter the INPATIENT SITE that will receive credit for the AMIS statistics for this AOU. Enter "^" to Exit option.
 ;;^DD(58.1,4,12)
 ;;=Select only sites that are 'Selectable for AR/WS' in file #59.4.
 ;;^DD(58.1,4,12.1)
 ;;=S DIC("S")="I $P(^(0),""^"",26)"
 ;;^DD(58.1,4,21,0)
 ;;=^^2^2^2890906^^
 ;;^DD(58.1,4,21,1,0)
 ;;=This field will point to the AR/WS INPATIENT SITE that will receive the
