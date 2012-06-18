PSGWI025 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(59.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(59.4,0,"GL")
 ;;=^PS(59.4,
 ;;^DIC("B","INPATIENT SITE",59.4)
 ;;=
 ;;^DIC(59.4,"%",0)
 ;;=^1.005^0^0
 ;;^DIC(59.4,"%D",0)
 ;;=^^3^3^2921203^^^^
 ;;^DIC(59.4,"%D",1,0)
 ;;=  Contains the site parameters for the various inpatient packages, giving
 ;;^DIC(59.4,"%D",2,0)
 ;;=the various VAMCs the ability to tailor the packages to their needs.
 ;;^DIC(59.4,"%D",3,0)
 ;;=Currently shared by the Ward Stock and Unit Dose packages.
 ;;^DD(59.4,0)
 ;;=FIELD^^31^35
 ;;^DD(59.4,0,"DDA")
 ;;=N
 ;;^DD(59.4,0,"DT")
 ;;=2910708
 ;;^DD(59.4,0,"IX","AC",59.4,8)
 ;;=
 ;;^DD(59.4,0,"IX","APLFC",59.4,.01)
 ;;=
 ;;^DD(59.4,0,"IX","AUPLK",59.4,.01)
 ;;=
 ;;^DD(59.4,0,"IX","B",59.4,.01)
 ;;=
 ;;^DD(59.4,0,"NM","INPATIENT SITE")
 ;;=
 ;;^DD(59.4,0,"PT",53.4104,1)
 ;;=
 ;;^DD(59.4,0,"PT",58.1,4)
 ;;=
 ;;^DD(59.4,0,"PT",58.501,.01)
 ;;=
 ;;^DD(59.4,0,"PT",58.8,2)
 ;;=
 ;;^DD(59.4,0,"PT",59.7,20.4)
 ;;=
 ;;^DD(59.4,.01,0)
 ;;=NAME^RF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<3)!'(X'?1P.E)!(X'?.ANP) X
 ;;^DD(59.4,.01,.1)
 ;;=Name
 ;;^DD(59.4,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(59.4,.01,1,1,0)
 ;;=59.4^B
 ;;^DD(59.4,.01,1,1,1)
 ;;=S ^PS(59.4,"B",$E(X,1,30),DA)=""
 ;;^DD(59.4,.01,1,1,2)
 ;;=K ^PS(59.4,"B",$E(X,1,30),DA)
 ;;^DD(59.4,.01,1,6,0)
 ;;=59.4^AUPLK^MUMPS
 ;;^DD(59.4,.01,1,6,1)
 ;;=I '$D(PSGINITF) S ^PS(59.4,"AUPLK")=$S($D(^PS(59.7,1,20)):$P(^(20),"^"),1:"")
 ;;^DD(59.4,.01,1,6,2)
 ;;=Q
 ;;^DD(59.4,.01,1,6,"%D",0)
 ;;=^^1^2920901^
 ;;^DD(59.4,.01,1,6,"%D",1,0)
 ;;=Sets Inpatient Pharmacy System data cross-ref.
 ;;^DD(59.4,.01,1,7,0)
 ;;=59.4^APLFC^MUMPS
 ;;^DD(59.4,.01,1,7,1)
 ;;=S ^PS(59.4,"APLFC")=$S($D(^PS(59.7,1,20)):$P(^(20),"^"),1:"")
 ;;^DD(59.4,.01,1,7,2)
 ;;=Q
 ;;^DD(59.4,.01,1,7,"%D",0)
 ;;=^^1^2920901^
 ;;^DD(59.4,.01,1,7,"%D",1,0)
 ;;=Sets Inpatient Pharmacy System data cross-ref.
 ;;^DD(59.4,.01,3)
 ;;=Name must be 3-30 characters, not starting with punctuation.
 ;;^DD(59.4,.01,20,0)
 ;;=^.3LA^2^2
 ;;^DD(59.4,.01,20,1,0)
 ;;=PSGW
 ;;^DD(59.4,.01,20,2,0)
 ;;=PS
 ;;^DD(59.4,.01,21,0)
 ;;=^^4^4^2900209^^^^
 ;;^DD(59.4,.01,21,1,0)
 ;;=This contains the name of the Inpatient Site.  A VAMC may have more than
 ;;^DD(59.4,.01,21,2,0)
 ;;=one inpatient site name, i.e. for multi-divisional sites or nursing
 ;;^DD(59.4,.01,21,3,0)
 ;;=homes.  A second site name would be used, for example, whenever different
 ;;^DD(59.4,.01,21,4,0)
 ;;=parameters are required.
 ;;^DD(59.4,.01,"DEL",1,0)
 ;;=D ^PSGRPNT
 ;;^DD(59.4,.01,"DT")
 ;;=2890920
 ;;^DD(59.4,4,0)
 ;;=MERGE INV. SHEET AND PICK LIST^S^1:YES;0:NO;^0;5^Q
 ;;^DD(59.4,4,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.4,4,20,1,0)
 ;;=PSGW
 ;;^DD(59.4,4,21,0)
 ;;=^^7^7^2890725^^^^
 ;;^DD(59.4,4,21,1,0)
 ;;=If 1 is entered, the Automatic Replenishment inventory sheet and pick list 
 ;;^DD(59.4,4,21,2,0)
 ;;=are merged - a separate pick list does not have to be printed.  The 
 ;;^DD(59.4,4,21,3,0)
 ;;=inventory sheet contains the quantity dispensed column. The on 
 ;;^DD(59.4,4,21,4,0)
 ;;=hand values do not have to be input. The user only enters the actual 
 ;;^DD(59.4,4,21,5,0)
 ;;=quantity dispensed. If 0 is entered, the inventory sheet and pick list are 
 ;;^DD(59.4,4,21,6,0)
 ;;=not merged.  The user prints the inventory sheet, enters on hand amounts, 
 ;;^DD(59.4,4,21,7,0)
 ;;=prints the pick list, and dispenses the items.
 ;;^DD(59.4,4,"DT")
 ;;=2850718
 ;;^DD(59.4,4.5,0)
 ;;=AR/WS AMIS FLAG^S^0:NO;1:YES;^0;25^Q
 ;;^DD(59.4,4.5,.1)
 ;;=BEGIN COLLECTING AMIS DATA NOW?
 ;;^DD(59.4,4.5,3)
 ;;=Set this parameter ONLY after completing the "Prepare AMIS Data" options!
 ;;^DD(59.4,4.5,20,0)
 ;;=^.3LA^1^1
 ;;^DD(59.4,4.5,20,1,0)
 ;;=PSGW
 ;;^DD(59.4,4.5,21,0)
 ;;=^^11^11^2910221^^^^
 ;;^DD(59.4,4.5,21,1,0)
 ;;=                        ***WARNING***
 ;;^DD(59.4,4.5,21,2,0)
 ;;=The setting of this parameter DIRECTLY AFFECTS THE ACCURACY of the
 ;;^DD(59.4,4.5,21,3,0)
 ;;=AMIS report!  This parameter should be set to "NO" until you have
 ;;^DD(59.4,4.5,21,4,0)
 ;;=completed ALL of the "Prepare AMIS Data" options on the 
 ;;^DD(59.4,4.5,21,5,0)
 ;;="Supervisor's Menu".  Carefully examine the reports produced by the
