PSGWI023 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.5)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(58.5,0,"GL")
 ;;=^PSI(58.5,
 ;;^DIC("B","AR/WS STATS FILE",58.5)
 ;;=
 ;;^DIC(58.5,"%D",0)
 ;;=^^9^9^2900918^^^^
 ;;^DIC(58.5,"%D",1,0)
 ;;=This file contains the data necessary to generate the AMIS statistics
 ;;^DIC(58.5,"%D",2,0)
 ;;=for AR/WS.  This data is accumulated automatically by a queued nightly
 ;;^DIC(58.5,"%D",3,0)
 ;;=job.
 ;;^DIC(58.5,"%D",4,0)
 ;;= 
 ;;^DIC(58.5,"%D",5,0)
 ;;=*** NOTE *** There are two cross-references that exist under this file
 ;;^DIC(58.5,"%D",6,0)
 ;;=that are created in the Pharmacy AOU Stock file (#58.1).  The xref
 ;;^DIC(58.5,"%D",7,0)
 ;;=names are "AMIS" and "AMISERR", if you create any local xrefs for this
 ;;^DIC(58.5,"%D",8,0)
 ;;=file (#58.5) DO NOT use these names as it will overwrite the existing
 ;;^DIC(58.5,"%D",9,0)
 ;;=xrefs.
 ;;^DD(58.5,0)
 ;;=FIELD^^1^2
 ;;^DD(58.5,0,"IX","AEX",58.52,2)
 ;;=
 ;;^DD(58.5,0,"IX","B",58.5,.01)
 ;;=
 ;;^DD(58.5,0,"IX","D",58.52,.01)
 ;;=
 ;;^DD(58.5,0,"NM","AR/WS STATS FILE")
 ;;=
 ;;^DD(58.5,.01,0)
 ;;=DATE^RDX^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X S:$D(X) DINUM=X
 ;;^DD(58.5,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(58.5,.01,1,1,0)
 ;;=58.5^B
 ;;^DD(58.5,.01,1,1,1)
 ;;=S ^PSI(58.5,"B",$E(X,1,30),DA)=""
 ;;^DD(58.5,.01,1,1,2)
 ;;=K ^PSI(58.5,"B",$E(X,1,30),DA)
 ;;^DD(58.5,.01,3)
 ;;=
 ;;^DD(58.5,.01,21,0)
 ;;=^^1^1^2890619^^
 ;;^DD(58.5,.01,21,1,0)
 ;;=This contains the date for which AMIS data is collected.
 ;;^DD(58.5,.01,"DT")
 ;;=2900302
 ;;^DD(58.5,1,0)
 ;;=INPATIENT SITE^58.501PA^^S;0
 ;;^DD(58.5,1,12)
 ;;=Enter only sites that are selectable for AR/WS.
 ;;^DD(58.5,1,12.1)
 ;;=S DIC("S")="I $P(^(0),""^"",26)"
 ;;^DD(58.501,0)
 ;;=INPATIENT SITE SUB-FIELD^^2^3
 ;;^DD(58.501,0,"IX","B",58.501,.01)
 ;;=
 ;;^DD(58.501,0,"NM","INPATIENT SITE")
 ;;=
 ;;^DD(58.501,0,"UP")
 ;;=58.5
 ;;^DD(58.501,.01,0)
 ;;=INPATIENT SITE^R*P59.4'X^PS(59.4,^0;1^S DIC("S")="I $P(^(0),""^"",26)" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X S:$D(X) DINUM=X
 ;;^DD(58.501,.01,1,0)
 ;;=^.1
 ;;^DD(58.501,.01,1,1,0)
 ;;=58.501^B
 ;;^DD(58.501,.01,1,1,1)
 ;;=S ^PSI(58.5,DA(1),"S","B",$E(X,1,30),DA)=""
 ;;^DD(58.501,.01,1,1,2)
 ;;=K ^PSI(58.5,DA(1),"S","B",$E(X,1,30),DA)
 ;;^DD(58.501,.01,12)
 ;;=Enter only sites that are selectable for AR/WS.
 ;;^DD(58.501,.01,12.1)
 ;;=S DIC("S")="I $P(^(0),""^"",26)"
 ;;^DD(58.501,.01,21,0)
 ;;=^^2^2^2890619^^^^
 ;;^DD(58.501,.01,21,1,0)
 ;;=This field contains the pointer to the INPATIENT SITE file (#59.4) for
 ;;^DD(58.501,.01,21,2,0)
 ;;=which the AMIS data is collected.
 ;;^DD(58.501,1,0)
 ;;=AMIS^58.51S^^AMIS;0
 ;;^DD(58.501,2,0)
 ;;=RECALCULATE AMIS^58.52P^^DRG;0
 ;;^DD(58.51,0)
 ;;=AMIS SUB-FIELD^^4^5
 ;;^DD(58.51,0,"IX","FLD",58.51,.01)
 ;;=
 ;;^DD(58.51,0,"NM","AMIS")
 ;;=
 ;;^DD(58.51,0,"UP")
 ;;=58.501
 ;;^DD(58.51,.01,0)
 ;;=AMIS FIELD^MS^03:FIELD 03;04:FIELD 04;06:FIELD 06;07:FIELD 07;17:FIELD 17;22:FIELD 22;^0;1^Q
 ;;^DD(58.51,.01,1,0)
 ;;=^.1
 ;;^DD(58.51,.01,1,1,0)
 ;;=58.51^FLD
 ;;^DD(58.51,.01,1,1,1)
 ;;=S ^PSI(58.5,DA(2),"S",DA(1),"AMIS","FLD",$E(X,1,30),DA)=""
 ;;^DD(58.51,.01,1,1,2)
 ;;=K ^PSI(58.5,DA(2),"S",DA(1),"AMIS","FLD",$E(X,1,30),DA)
 ;;^DD(58.51,.01,21,0)
 ;;=^^2^2^2890619^^^^
 ;;^DD(58.51,.01,21,1,0)
 ;;=AMIS FIELD identifies which field is to be credited for AMIS purposes.  
 ;;^DD(58.51,.01,21,2,0)
 ;;=These fields will be "03", "04", "06", "07", "17", or "22".
 ;;^DD(58.51,1,0)
 ;;=DOSES DISPENSED^NJ7,0^^0;2^K:+X'=X!(X>9999999)!(X<-9999999)!(X?.E1"."1N.N) X
 ;;^DD(58.51,1,3)
 ;;=Type a Number between -9999999 and 9999999, 0 Decimal Digits
 ;;^DD(58.51,1,21,0)
 ;;=^^1^1^2900227^^^
 ;;^DD(58.51,1,21,1,0)
 ;;=DOSES DISPENSED = QUANTITY DISPENSED * AMIS CONVERSION NUMBER
 ;;^DD(58.51,1,"DT")
 ;;=2900227
 ;;^DD(58.51,2,0)
 ;;=DISPENSED COST^NJ14,6^^0;3^K:+X'=X!(X>9999999)!(X<-9999999)!(X?.E1"."7N.N) X
 ;;^DD(58.51,2,3)
 ;;=Type a Number between -9999999 and 9999999, 6 Decimal Digits
 ;;^DD(58.51,2,21,0)
 ;;=^^1^1^2890619^^
 ;;^DD(58.51,2,21,1,0)
 ;;=DISPENSED COST = QUANTITY DISPENSED * PRICE PER DISPENSE UNIT.
 ;;^DD(58.51,2,"DT")
 ;;=2891102
 ;;^DD(58.51,3,0)
 ;;=DOSES RETURNED^NJ6,0^^0;4^K:+X'=X!(X>999999)!(X<1)!(X?.E1"."1N.N) X
