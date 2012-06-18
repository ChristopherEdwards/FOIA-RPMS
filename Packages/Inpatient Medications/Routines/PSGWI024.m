PSGWI024 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.51,3,3)
 ;;=Type a whole number between 1 and 999999
 ;;^DD(58.51,3,21,0)
 ;;=^^1^1^2890619^^
 ;;^DD(58.51,3,21,1,0)
 ;;=DOSES RETURNED = QUANTITY RETURNED * AMIS CONVERSION NUMBER
 ;;^DD(58.51,4,0)
 ;;=RETURNS COST^NJ14,6^^0;5^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."7N.N) X
 ;;^DD(58.51,4,3)
 ;;=Type a Number between 0 and 9999999, 6 Decimal Digits
 ;;^DD(58.51,4,21,0)
 ;;=^^1^1^2890705^^^
 ;;^DD(58.51,4,21,1,0)
 ;;=RETURNS COST = QUANTITY RETURNED * PRICE PER DISPENSE UNIT
 ;;^DD(58.51,4,"DT")
 ;;=2891102
 ;;^DD(58.52,0)
 ;;=RECALCULATE AMIS SUB-FIELD^^2^3
 ;;^DD(58.52,0,"IX","B",58.52,.01)
 ;;=
 ;;^DD(58.52,0,"NM","RECALCULATE AMIS")
 ;;=
 ;;^DD(58.52,0,"UP")
 ;;=58.501
 ;;^DD(58.52,.01,0)
 ;;=DRUG^MP50'^PSDRUG(^0;1^Q
 ;;^DD(58.52,.01,1,0)
 ;;=^.1
 ;;^DD(58.52,.01,1,1,0)
 ;;=58.52^B
 ;;^DD(58.52,.01,1,1,1)
 ;;=S ^PSI(58.5,DA(2),"S",DA(1),"DRG","B",$E(X,1,30),DA)=""
 ;;^DD(58.52,.01,1,1,2)
 ;;=K ^PSI(58.5,DA(2),"S",DA(1),"DRG","B",$E(X,1,30),DA)
 ;;^DD(58.52,.01,1,2,0)
 ;;=58.5^D
 ;;^DD(58.52,.01,1,2,1)
 ;;=S ^PSI(58.5,"D",$E(X,1,30),DA(2),DA(1),DA)=""
 ;;^DD(58.52,.01,1,2,2)
 ;;=K ^PSI(58.5,"D",$E(X,1,30),DA(2),DA(1),DA)
 ;;^DD(58.52,.01,21,0)
 ;;=^^3^3^2890619^^^
 ;;^DD(58.52,.01,21,1,0)
 ;;=This contains the internal drug number of the drug being dispensed or 
 ;;^DD(58.52,.01,21,2,0)
 ;;=returned.  Thus, if cost data is found to be inaccurate, the AMIS may be 
 ;;^DD(58.52,.01,21,3,0)
 ;;=recalculated.
 ;;^DD(58.52,1,0)
 ;;=CATEGORY^58.53SA^^CAT;0
 ;;^DD(58.52,2,0)
 ;;=MISSING DATA^S^1:YES;0:NO;^0;2^Q
 ;;^DD(58.52,2,1,0)
 ;;=^.1
 ;;^DD(58.52,2,1,1,0)
 ;;=58.5^AEX^MUMPS
 ;;^DD(58.52,2,1,1,1)
 ;;=I X=1 S ^PSI(58.5,"AEX",DA(2),DA(1),DA)=""
 ;;^DD(58.52,2,1,1,2)
 ;;=K ^PSI(58.5,"AEX",DA(2),DA(1),DA)
 ;;^DD(58.52,2,1,1,"%D",0)
 ;;=^^3^3^2930827^
 ;;^DD(58.52,2,1,1,"%D",1,0)
 ;;=This cross-reference is used to sort drugs with missing AMIS data by 
 ;;^DD(58.52,2,1,1,"%D",2,0)
 ;;=Date/Inpatient Site/Drug. It is used by the options "Inventory Outline",
 ;;^DD(58.52,2,1,1,"%D",3,0)
 ;;="Print AMIS Report","Incomplete AMIS Data", and "Recalculate AMIS".
 ;;^DD(58.52,2,21,0)
 ;;=^^4^4^2890906^^^^
 ;;^DD(58.52,2,21,1,0)
 ;;=This flag is set if data needed to calculate the AMIS is missing at the 
 ;;^DD(58.52,2,21,2,0)
 ;;=time the quantity is dispensed or returned.  Also, an "exceptions" 
 ;;^DD(58.52,2,21,3,0)
 ;;=cross-reference is created.  Before the AMIS will print, this missing data 
 ;;^DD(58.52,2,21,4,0)
 ;;=must be supplied, the cross-reference deleted, and the flag reset.
 ;;^DD(58.53,0)
 ;;=CATEGORY SUB-FIELD^^1^2
 ;;^DD(58.53,0,"NM","CATEGORY")
 ;;=
 ;;^DD(58.53,0,"UP")
 ;;=58.52
 ;;^DD(58.53,.01,0)
 ;;=CATEGORY^S^A:AUTOMATIC REPLENISHMENT;W:WARD STOCK;RA:RETURNS - AUTO REPLENISHED;RW:RETURNS - WARD STOCKED;^0;1^Q
 ;;^DD(58.53,.01,21,0)
 ;;=^^3^3^2890619^^
 ;;^DD(58.53,.01,21,1,0)
 ;;=Category identifies how the quantity dispensed or returned was originally 
 ;;^DD(58.53,.01,21,2,0)
 ;;=ordered: Automatic Replenishment, On-Demand, returned from Automatic 
 ;;^DD(58.53,.01,21,3,0)
 ;;=Replenishment, or returned from On-Demand.
 ;;^DD(58.53,1,0)
 ;;=QUANTITY DISPENSED^NJ5,0^^0;2^K:+X'=X!(X>99999)!(X<-99999)!(X?.E1"."1N.N) X
 ;;^DD(58.53,1,3)
 ;;=Type a Number between -99999 and 99999, 0 Decimal Digits
 ;;^DD(58.53,1,21,0)
 ;;=^^1^1^2890619^^
 ;;^DD(58.53,1,21,1,0)
 ;;=This amount identifies the quantity dispensed or returned.
 ;;^DD(58.53,1,"DT")
 ;;=2891101
