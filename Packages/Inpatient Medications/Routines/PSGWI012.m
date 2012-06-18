PSGWI012 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.27,1,21,2,0)
 ;;=out of 100 on the ward would be 40%.
 ;;^DD(58.27,1,"DT")
 ;;=2850812
 ;;^DD(58.28,0)
 ;;=ON-DEMAND REQUEST DATE/TIME SUB-FIELD^NL^5^6
 ;;^DD(58.28,0,"IX","AMIS",58.28,1)
 ;;=
 ;;^DD(58.28,0,"IX","AMISERR",58.28,1)
 ;;=
 ;;^DD(58.28,0,"NM","ON-DEMAND REQUEST DATE/TIME")
 ;;=
 ;;^DD(58.28,0,"UP")
 ;;=58.11
 ;;^DD(58.28,.01,0)
 ;;=ON-DEMAND REQUEST DATE/TIME^D^^0;1^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(58.28,.01,1,0)
 ;;=^.1
 ;;^DD(58.28,.01,1,1,0)
 ;;=58.1^OND
 ;;^DD(58.28,.01,1,1,1)
 ;;=S ^PSI(58.1,"OND",$E(X,1,30),DA(2),DA(1),DA)=""
 ;;^DD(58.28,.01,1,1,2)
 ;;=K ^PSI(58.1,"OND",$E(X,1,30),DA(2),DA(1),DA)
 ;;^DD(58.28,.01,3)
 ;;=Enter the Date/Time for the On-Demand Request
 ;;^DD(58.28,.01,21,0)
 ;;=^^2^2^2930714^
 ;;^DD(58.28,.01,21,1,0)
 ;;=This contains the DATE/TIME of the request for an item which is not
 ;;^DD(58.28,.01,21,2,0)
 ;;=currently a standard stocked item in the Area of Use.
 ;;^DD(58.28,.01,"DT")
 ;;=2900703
 ;;^DD(58.28,1,0)
 ;;=ON-DEMAND QUANTITY DISPENSED^NJ4,0X^^0;2^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X D:$D(X) OND^PSGWUTL
 ;;^DD(58.28,1,.1)
 ;;=ON-DEMAND QUANTITY
 ;;^DD(58.28,1,1,0)
 ;;=^.1
 ;;^DD(58.28,1,1,1,0)
 ;;=58.28^AMIS^MUMPS
 ;;^DD(58.28,1,1,1,1)
 ;;=Q:$D(PSGWV)  D OD^PSGWUTL
 ;;^DD(58.28,1,1,1,2)
 ;;=Q:$D(PSGWV)  D KOD^PSGWUTL
 ;;^DD(58.28,1,1,1,"%D",0)
 ;;=^^5^5^2930827^
 ;;^DD(58.28,1,1,1,"%D",1,0)
 ;;=This cross-reference is set everytime a quantity greater than zero is 
 ;;^DD(58.28,1,1,1,"%D",2,0)
 ;;=dispensed for an On-Demand Request for a stock item. The nightly job
 ;;^DD(58.28,1,1,1,"%D",3,0)
 ;;="Update AMIS Stats File" will process this cross-reference and store
 ;;^DD(58.28,1,1,1,"%D",4,0)
 ;;=the data in the AR/WS Stats File (58.5). After the cross-reference is
 ;;^DD(58.28,1,1,1,"%D",5,0)
 ;;=processed, it is deleted.
 ;;^DD(58.28,1,1,2,0)
 ;;=58.28^AMISERR^MUMPS
 ;;^DD(58.28,1,1,2,1)
 ;;=Q:$D(PSGWV)  D ODERR^PSGWUTL
 ;;^DD(58.28,1,1,2,2)
 ;;=Q:$D(PSGWV)  D KODERR^PSGWUTL
 ;;^DD(58.28,1,1,2,"%D",0)
 ;;=^^5^5^2930827^
 ;;^DD(58.28,1,1,2,"%D",1,0)
 ;;=This cross-reference is set by the nightly job "Update AMIS Stats File"
 ;;^DD(58.28,1,1,2,"%D",2,0)
 ;;=if an AMIS transaction is found to have invalid or missing Inpatient Site
 ;;^DD(58.28,1,1,2,"%D",3,0)
 ;;=data. Existence of this cross-reference will cause a MailMan message to
 ;;^DD(58.28,1,1,2,"%D",4,0)
 ;;=be sent to holders of the PSGWMGR security key informing them of the 
 ;;^DD(58.28,1,1,2,"%D",5,0)
 ;;=invalid or missing data.
 ;;^DD(58.28,1,3)
 ;;=Type a Number between 0 and 9999, 0 Decimal Digits.
 ;;^DD(58.28,1,21,0)
 ;;=^^1^1^2920708^^^^
 ;;^DD(58.28,1,21,1,0)
 ;;=This contains the quantity dispensed for the on-demand request.
 ;;^DD(58.28,1,"DT")
 ;;=2910228
 ;;^DD(58.28,2,0)
 ;;=ON-DEMAND REQUEST ENTERED BY^RP200'^VA(200,^0;3^Q
 ;;^DD(58.28,2,.1)
 ;;=REQUEST ENTERED BY:
 ;;^DD(58.28,2,3)
 ;;=Enter the name of the original user for this request.
 ;;^DD(58.28,2,21,0)
 ;;=^^2^2^2900712^^^^
 ;;^DD(58.28,2,21,1,0)
 ;;=This points to File 200 - the New Person File.  It contains the pointer number
 ;;^DD(58.28,2,21,2,0)
 ;;=of the person who has entered the on-demand request.
 ;;^DD(58.28,2,"DT")
 ;;=2900712
 ;;^DD(58.28,3,0)
 ;;=COMPILED INTO AMIS?^S^1:YES;0:NO;^0;4^Q
 ;;^DD(58.28,3,.1)
 ;;=COMPILED FLAG
 ;;^DD(58.28,3,21,0)
 ;;=^^5^5^2910221^^^^
 ;;^DD(58.28,3,21,1,0)
 ;;=A TaskMan background routine ^PSGWUAS (option PSGW UPDATE AMIS STATS) runs
 ;;^DD(58.28,3,21,2,0)
 ;;=each night.  As the data for an on-demand transaction is completed, this
 ;;^DD(58.28,3,21,3,0)
 ;;="COMPILED FLAG" will be set to "1".  This will enable the cross-reference
 ;;^DD(58.28,3,21,4,0)
 ;;=^PSI(58.5,"AMIS") to be recompiled via the option PSGW RE-INDEX AMIS or
 ;;^DD(58.28,3,21,5,0)
 ;;=via VA FileMan should the need arise.
 ;;^DD(58.28,3,"DT")
 ;;=2880126
 ;;^DD(58.28,4,0)
 ;;=ON-DEMAND REQUEST EDITED BY^P200'^VA(200,^0;5^Q
 ;;^DD(58.28,4,.1)
 ;;=LAST EDITED BY:
 ;;^DD(58.28,4,3)
 ;;=Enter the name of the person who last edited this request.
 ;;^DD(58.28,4,21,0)
 ;;=^^2^2^2900712^^^^
