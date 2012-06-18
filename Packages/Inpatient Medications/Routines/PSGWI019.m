PSGWI019 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.21,.01,1,1,2)
 ;;=K ^PSI(58.2,DA(1),1,"B",$E(X,1,30),DA)
 ;;^DD(58.21,.01,1,2,0)
 ;;=58.2^WS^MUMPS
 ;;^DD(58.21,.01,1,2,1)
 ;;=S ^PSI(58.2,"WS",DA(1),$E(X,1,30))=""
 ;;^DD(58.21,.01,1,2,2)
 ;;=K ^PSI(58.2,"WS",DA(1),$E(X,1,30))
 ;;^DD(58.21,.01,1,2,"%D",0)
 ;;=^^4^4^2920220^
 ;;^DD(58.21,.01,1,2,"%D",1,0)
 ;;=This cross-reference is used to distinguish between inventory groups
 ;;^DD(58.21,.01,1,2,"%D",2,0)
 ;;=that belong to the AR/WS module and those belonging to the CS module.
 ;;^DD(58.21,.01,1,2,"%D",3,0)
 ;;=This cross-reference will identify AR/WS inventory groups and will be
 ;;^DD(58.21,.01,1,2,"%D",4,0)
 ;;=used for lookup and sorting.
 ;;^DD(58.21,.01,1,2,"DT")
 ;;=2920220
 ;;^DD(58.21,.01,3)
 ;;=Enter the AOU for this inventory group.
 ;;^DD(58.21,.01,21,0)
 ;;=^^2^2^2931014^^^^
 ;;^DD(58.21,.01,21,1,0)
 ;;=This contains the name of the AOU that is to be inventoried when selecting 
 ;;^DD(58.21,.01,21,2,0)
 ;;=this inventory group.  This points to File 58.1 - Pharmacy AOU Stock File.
 ;;^DD(58.21,.01,"DT")
 ;;=2920220
 ;;^DD(58.21,1,0)
 ;;=INVENTORY TYPE^58.22PA^^1;0
 ;;^DD(58.21,2,0)
 ;;=SORT KEY^NJ15,4^^0;2^K:+X'=X!(X>9999999999)!(X<0)!(X?.E1"."5N.N) X
 ;;^DD(58.21,2,1,0)
 ;;=^.1
 ;;^DD(58.21,2,1,1,0)
 ;;=58.21^D
 ;;^DD(58.21,2,1,1,1)
 ;;=S ^PSI(58.2,DA(1),1,"D",$E(X,1,30),DA)=""
 ;;^DD(58.21,2,1,1,2)
 ;;=K ^PSI(58.2,DA(1),1,"D",$E(X,1,30),DA)
 ;;^DD(58.21,2,3)
 ;;=Type a Number between 0 and 9999999999, 4 Decimal Digits
 ;;^DD(58.21,2,21,0)
 ;;=^^2^2^2871009^^
 ;;^DD(58.21,2,21,1,0)
 ;;=The sort key is used to define the sort order of AOUs within an 
 ;;^DD(58.21,2,21,2,0)
 ;;=inventory group.
 ;;^DD(58.21,2,"DT")
 ;;=2891102
 ;;^DD(58.22,0)
 ;;=INVENTORY TYPE SUB-FIELD^NL^.01^1
 ;;^DD(58.22,0,"DT")
 ;;=2920213
 ;;^DD(58.22,0,"NM","INVENTORY TYPE")
 ;;=
 ;;^DD(58.22,0,"UP")
 ;;=58.21
 ;;^DD(58.22,.01,0)
 ;;=INVENTORY TYPE^MRP58.16'X^PSI(58.16,^0;1^S:$D(X) DINUM=X
 ;;^DD(58.22,.01,3)
 ;;=Enter the inventory type(s) for this AOU.
 ;;^DD(58.22,.01,21,0)
 ;;=^^3^3^2931014^^^
 ;;^DD(58.22,.01,21,1,0)
 ;;=This contains the inventory type that is to be inventoried within
 ;;^DD(58.22,.01,21,2,0)
 ;;=the AOU.  More than one inventory type can be entered.  The inventory
 ;;^DD(58.22,.01,21,3,0)
 ;;=types must have been defined in File 58.16 - AOU Inventory Type File.
 ;;^DD(58.22,.01,"DT")
 ;;=2920213
 ;;^DD(58.23,0)
 ;;=GROUP DESCRIPTION SUB-FIELD^NL^.01^1
 ;;^DD(58.23,0,"NM","GROUP DESCRIPTION")
 ;;=
 ;;^DD(58.23,0,"UP")
 ;;=58.2
 ;;^DD(58.23,.01,0)
 ;;=GROUP DESCRIPTION^W^^0;1^Q
 ;;^DD(58.23,.01,21,0)
 ;;=^^3^3^2910304^
 ;;^DD(58.23,.01,21,1,0)
 ;;=This text describes the inventory group and its use, and perhaps
 ;;^DD(58.23,.01,21,2,0)
 ;;=the times when normally processed.  This is purely for documentation
 ;;^DD(58.23,.01,21,3,0)
 ;;=of your site specific information.
 ;;^DD(58.29,0)
 ;;=NARCOTIC AREA OF USE (NAOU) SUB-FIELD^^2^3
 ;;^DD(58.29,0,"DT")
 ;;=2920309
 ;;^DD(58.29,0,"IX","B",58.29,.01)
 ;;=
 ;;^DD(58.29,0,"IX","D",58.29,2)
 ;;=
 ;;^DD(58.29,0,"NM","NARCOTIC AREA OF USE (NAOU)")
 ;;=
 ;;^DD(58.29,0,"UP")
 ;;=58.2
 ;;^DD(58.29,.01,0)
 ;;=NARCOTIC AREA OF USE (NAOU)^MR*P58.8'X^PSD(58.8,^0;1^S DIC("S")="I $P(^(0),""^"",2)'=""P""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X S:$D(X) DINUM=X
 ;;^DD(58.29,.01,1,0)
 ;;=^.1
 ;;^DD(58.29,.01,1,1,0)
 ;;=58.29^B
 ;;^DD(58.29,.01,1,1,1)
 ;;=S ^PSI(58.2,DA(1),3,"B",$E(X,1,30),DA)=""
 ;;^DD(58.29,.01,1,1,2)
 ;;=K ^PSI(58.2,DA(1),3,"B",$E(X,1,30),DA)
 ;;^DD(58.29,.01,1,2,0)
 ;;=58.2^CS^MUMPS
 ;;^DD(58.29,.01,1,2,1)
 ;;=S ^PSI(58.2,"CS",DA(1),$E(X,1,30))=""
 ;;^DD(58.29,.01,1,2,2)
 ;;=K ^PSI(58.2,"CS",DA(1),$E(X,1,30))
 ;;^DD(58.29,.01,1,2,"%D",0)
 ;;=^^4^4^2920220^
 ;;^DD(58.29,.01,1,2,"%D",1,0)
 ;;=This cross-reference is used to distinguish between inventory groups
 ;;^DD(58.29,.01,1,2,"%D",2,0)
 ;;=that belong to the AR/WS module and those belonging to the CS module.
 ;;^DD(58.29,.01,1,2,"%D",3,0)
 ;;=This cross-reference will identify CS inventory groups and will be
 ;;^DD(58.29,.01,1,2,"%D",4,0)
 ;;=used for lookup and sorting.
 ;;^DD(58.29,.01,1,2,"DT")
 ;;=2920220
