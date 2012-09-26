PSGWI011 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.15,1,1,1,"%D",2,0)
 ;;=returned for a stock item. The nightly job "Update AMIS Stats File" 
 ;;^DD(58.15,1,1,1,"%D",3,0)
 ;;=will process this cross-reference and store the data in the AR/WS Stats
 ;;^DD(58.15,1,1,1,"%D",4,0)
 ;;=File (#58.5). After the cross-reference is processed, it is deleted.
 ;;^DD(58.15,1,1,2,0)
 ;;=58.15^AMISERR^MUMPS
 ;;^DD(58.15,1,1,2,1)
 ;;=Q:$D(PSGWV)  D RETERR^PSGWUTL
 ;;^DD(58.15,1,1,2,2)
 ;;=Q:$D(PSGWV)  D KRETERR^PSGWUTL
 ;;^DD(58.15,1,1,2,"%D",0)
 ;;=^^5^5^2930811^
 ;;^DD(58.15,1,1,2,"%D",1,0)
 ;;=This cross-reference is set by the nightly job "Update AMIS Stats File"
 ;;^DD(58.15,1,1,2,"%D",2,0)
 ;;=if an AMIS transaction is found to have invalid or missing Inpatient
 ;;^DD(58.15,1,1,2,"%D",3,0)
 ;;=Site data. Existence of this cross-reference will cause a MailMan message
 ;;^DD(58.15,1,1,2,"%D",4,0)
 ;;=to be sent to holders of the PSGWMGR security key informing them of the
 ;;^DD(58.15,1,1,2,"%D",5,0)
 ;;=invalid or missing data.
 ;;^DD(58.15,1,3)
 ;;=Type a Number between 0 and 9999, 0 Decimal Digits.
 ;;^DD(58.15,1,21,0)
 ;;=^^1^1^2871008^^
 ;;^DD(58.15,1,21,1,0)
 ;;=This contains the quantity returned from the Area of Use for the item.
 ;;^DD(58.15,1,"DT")
 ;;=2910228
 ;;^DD(58.15,3,0)
 ;;=COMPILED INTO AMIS?^S^1:YES;0:NO;^0;4^Q
 ;;^DD(58.15,3,.1)
 ;;=COMPILED FLAG
 ;;^DD(58.15,3,21,0)
 ;;=^^5^5^2910221^^^^
 ;;^DD(58.15,3,21,1,0)
 ;;=A TaskMan background routine ^PSGWUAS (option PSGW UPDATE AMIS STATS) runs
 ;;^DD(58.15,3,21,2,0)
 ;;=each night.  As the data for a return transaction is completed, this
 ;;^DD(58.15,3,21,3,0)
 ;;="COMPILED FLAG" will be set to "1".  This will enable the cross-reference
 ;;^DD(58.15,3,21,4,0)
 ;;=^PSI(58.5,"AMIS") to be recompiled via the option PSGW RE-INDEX AMIS or
 ;;^DD(58.15,3,21,5,0)
 ;;=via VA FileMan should the need arise.
 ;;^DD(58.15,3,"DT")
 ;;=2880126
 ;;^DD(58.26,0)
 ;;=WARD (FOR ITEM) SUB-FIELD^NL^.01^1
 ;;^DD(58.26,0,"NM","WARD (FOR ITEM)")
 ;;=
 ;;^DD(58.26,0,"UP")
 ;;=58.11
 ;;^DD(58.26,.01,0)
 ;;=WARD (FOR ITEM)^MP42'X^DIC(42,^0;1^S:$D(X) DINUM=X
 ;;^DD(58.26,.01,1,0)
 ;;=^.1
 ;;^DD(58.26,.01,1,1,0)
 ;;=58.1^D^MUMPS
 ;;^DD(58.26,.01,1,1,1)
 ;;=I $D(^PSI(58.1,DA(2),1,DA(1),0)),^(0) D INACT^PSGWUTL I $D(PSGWFLG) S ^PSI(58.1,"D",+^(0),DA,DA(2))="" K PSGWFLG
 ;;^DD(58.26,.01,1,1,2)
 ;;=I $D(^PSI(58.1,DA(2),1,DA(1),0)),^(0) K ^PSI(58.1,"D",+^(0),DA,DA(2))
 ;;^DD(58.26,.01,1,1,"%D",0)
 ;;=^^3^3^2930811^
 ;;^DD(58.26,.01,1,1,"%D",1,0)
 ;;=This cross-reference is used by the UNIT DOSE package to identify items
 ;;^DD(58.26,.01,1,1,"%D",2,0)
 ;;=on the UD pick list that are Ward Stock items. It is also used by the
 ;;^DD(58.26,.01,1,1,"%D",3,0)
 ;;=option "Ward (For Item) Conversion".
 ;;^DD(58.26,.01,3)
 ;;=Enter the ward which uses this item.
 ;;^DD(58.26,.01,21,0)
 ;;=^^4^4^2880224^^^^
 ;;^DD(58.26,.01,21,1,0)
 ;;=This contains the pointer to File 42 - Ward Location File.
 ;;^DD(58.26,.01,21,2,0)
 ;;=Names of the ward or wards using this item will be entered.
 ;;^DD(58.26,.01,21,3,0)
 ;;=This is the link between the AR/WS package and the Unit Dose
 ;;^DD(58.26,.01,21,4,0)
 ;;=package for determining ward stocked items.
 ;;^DD(58.26,.01,"DT")
 ;;=2900213
 ;;^DD(58.27,0)
 ;;=SERVICE SUB-FIELD^NL^1^2
 ;;^DD(58.27,0,"NM","SERVICE")
 ;;=
 ;;^DD(58.27,0,"UP")
 ;;=58.14
 ;;^DD(58.27,.01,0)
 ;;=SERVICE^MP42.4'^DIC(42.4,^0;1^Q
 ;;^DD(58.27,.01,3)
 ;;=Enter the name of the service that makes up this ward/location.
 ;;^DD(58.27,.01,21,0)
 ;;=^^3^3^2910304^^^^
 ;;^DD(58.27,.01,21,1,0)
 ;;=This points to File 42.4 - the Specialty file.
 ;;^DD(58.27,.01,21,2,0)
 ;;=It contains the service (or services) served partially or totally
 ;;^DD(58.27,.01,21,3,0)
 ;;=by this ward/location.
 ;;^DD(58.27,.01,"DT")
 ;;=2850812
 ;;^DD(58.27,1,0)
 ;;=SERVICE % OF USE^NJ3,0^^0;2^K:+X'=X!(X>100)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(58.27,1,3)
 ;;=Type a whole number between 1 and 100
 ;;^DD(58.27,1,21,0)
 ;;=^^2^2^2900827^^^^
 ;;^DD(58.27,1,21,1,0)
 ;;=This contains the percentage of use for this service. For example 40 beds 
