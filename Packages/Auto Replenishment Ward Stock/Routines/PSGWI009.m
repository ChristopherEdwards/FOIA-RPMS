PSGWI009 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.12,1,"DT")
 ;;=2850227
 ;;^DD(58.12,3,0)
 ;;=COMPILED INTO AMIS?^S^1:YES;0:NO;^0;4^Q
 ;;^DD(58.12,3,.1)
 ;;=COMPILED FLAG
 ;;^DD(58.12,3,21,0)
 ;;=^^5^5^2910221^^^^
 ;;^DD(58.12,3,21,1,0)
 ;;=A TaskMan background routine ^PSGWUAS (option PSGW UPDATE AMIS STATS) runs
 ;;^DD(58.12,3,21,2,0)
 ;;=each night.  As the data for an inventory transaction is completed, this
 ;;^DD(58.12,3,21,3,0)
 ;;="COMPILED FLAG" will be set to "1".  This will enable the cross-reference
 ;;^DD(58.12,3,21,4,0)
 ;;=^PSI(58.5,"AMIS") to be recompiled via the option PSGW RE-INDEX AMIS or
 ;;^DD(58.12,3,21,5,0)
 ;;=via VA FileMan should the need arise.
 ;;^DD(58.12,3,"DT")
 ;;=2880126
 ;;^DD(58.12,3.5,0)
 ;;=ON HAND^NJ4,0^^0;6^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(58.12,3.5,1,0)
 ;;=^.1
 ;;^DD(58.12,3.5,1,1,0)
 ;;=^^TRIGGER^58.12^4
 ;;^DD(58.12,3.5,1,1,1)
 ;;=Q:$D(DIU(0))  K DIV S DIV=X,D0=DA(2),DIV(0)=D0,D1=DA(1),DIV(1)=D1,D2=DA,DIV(2)=D2 S Y(1)=$S($D(^PSI(58.1,D0,1,D1,1,D2,0)):^(0),1:"") S X=$P(Y(1),U,5) S DIU=X K Y X ^DD(58.12,3.5,1,1,1.1) X ^DD(58.12,3.5,1,1,1.4)
 ;;^DD(58.12,3.5,1,1,1,9.2)
 ;;=S Y(1)=$S($D(^PSI(58.1,D0,1,D1,1,D2,0)):^(0),1:"") S X=DIV<$P(Y(1),U,2),Y(2)=X,Y(3)=X S X=$P(Y(1),U,2),Y(4)=X S X=DIV,Y=X,X=Y(4),X=X-Y,Y(5)=X S X=1,Y(6)=X S X=0
 ;;^DD(58.12,3.5,1,1,1.1)
 ;;=S X=DIV X ^DD(58.12,3.5,1,1,1,9.2) S X=$S(Y(2):Y(5),Y(6):X)
 ;;^DD(58.12,3.5,1,1,1.4)
 ;;=S DIH=$S($D(^PSI(58.1,DIV(0),1,DIV(1),1,DIV(2),0)):^(0),1:""),DIV=X X "F %=0:0 Q:$L($P(DIH,U,4,99))  S DIH=DIH_U" S %=$P(DIH,U,6,999),DIU=$P(DIH,U,5),^(0)=$P(DIH,U,1,4)_U_DIV_$S(%]"":U_%,1:""),DIH=58.12,DIG=4 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
 ;;^DD(58.12,3.5,1,1,2)
 ;;=Q
 ;;^DD(58.12,3.5,1,1,"%D",0)
 ;;=^^5^5^2930827^
 ;;^DD(58.12,3.5,1,1,"%D",1,0)
 ;;=This cross-reference sets the value of the field DISPENSING QUANTITY
 ;;^DD(58.12,3.5,1,1,"%D",2,0)
 ;;=(58.12,4) for sites that are NOT merging their pick lists and inventory
 ;;^DD(58.12,3.5,1,1,"%D",3,0)
 ;;=sheets. This value will be calculated using the following logic:
 ;;^DD(58.12,3.5,1,1,"%D",4,0)
 ;;=ON HAND<STOCK LEVEL then DISPENSE QUANTITY=STOCK LEVEL-ON HAND
 ;;^DD(58.12,3.5,1,1,"%D",5,0)
 ;;=ON HAND>or=STOCK LEVEL then DISPENSE QUANTITY=zero
 ;;^DD(58.12,3.5,1,1,"CREATE VALUE")
 ;;=$S((ON-HAND)<LEVEL:(LEVEL-(ON-HAND)),1:0)
 ;;^DD(58.12,3.5,1,1,"DELETE VALUE")
 ;;=NO EFFECT
 ;;^DD(58.12,3.5,1,1,"FIELD")
 ;;=DISPENSE
 ;;^DD(58.12,3.5,3)
 ;;=Type a whole number between 0 and 9999
 ;;^DD(58.12,3.5,21,0)
 ;;=^^1^1^2871008^^^
 ;;^DD(58.12,3.5,21,1,0)
 ;;=This contains the quantity of the item currently in the Area of Use.
 ;;^DD(58.12,3.5,"DT")
 ;;=2850718
 ;;^DD(58.12,4,0)
 ;;=DISPENSE QUANTITY^NJ4,0^^0;5^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(58.12,4,1,0)
 ;;=^.1
 ;;^DD(58.12,4,1,1,0)
 ;;=58.12^AMIS^MUMPS
 ;;^DD(58.12,4,1,1,1)
 ;;=Q:$D(PSGWV)  D QD^PSGWUTL
 ;;^DD(58.12,4,1,1,2)
 ;;=Q:$D(PSGWV)  D KQD^PSGWUTL
 ;;^DD(58.12,4,1,1,"%D",0)
 ;;=^^4^4^2930811^
 ;;^DD(58.12,4,1,1,"%D",1,0)
 ;;=This cross-reference is set everytime a quantity greater than zero is 
 ;;^DD(58.12,4,1,1,"%D",2,0)
 ;;=dispensed for a stock item. The nightly job "Update AMIS Stats File" will
 ;;^DD(58.12,4,1,1,"%D",3,0)
 ;;=process this cross-reference and store the data in the AR/WS Stats File
 ;;^DD(58.12,4,1,1,"%D",4,0)
 ;;=(#58.5). After the cross-reference is processed, it is deleted.
 ;;^DD(58.12,4,1,2,0)
 ;;=58.12^AMISERR^MUMPS
 ;;^DD(58.12,4,1,2,1)
 ;;=Q:$D(PSGWV)  D QDERR^PSGWUTL
 ;;^DD(58.12,4,1,2,2)
 ;;=Q:$D(PSGWV)  D KQDERR^PSGWUTL
 ;;^DD(58.12,4,1,2,"%D",0)
 ;;=^^5^5^2930811^
 ;;^DD(58.12,4,1,2,"%D",1,0)
 ;;=This cross-reference is set by the nightly job "Update AMIS Stats file"
 ;;^DD(58.12,4,1,2,"%D",2,0)
 ;;=if an AMIS transaction is found to have invalid or missing Inpatient
 ;;^DD(58.12,4,1,2,"%D",3,0)
 ;;=Site data. Existence of this cross-reference will cause a MailMan message
 ;;^DD(58.12,4,1,2,"%D",4,0)
 ;;=to be sent to holders of the PSGWMGR security key informing them of the
 ;;^DD(58.12,4,1,2,"%D",5,0)
 ;;=invalid or missing data.
 ;;^DD(58.12,4,3)
 ;;=Type a Number between 0 and 9999, 0 Decimal Digits.
