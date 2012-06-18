PSGWI010 ; ; 04-JAN-1994
 ;;2.3; Automatic Replenishment/Ward Stock ;;4 JAN 94
 Q:'DIFQ(58.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(58.12,4,5,1,0)
 ;;=58.12^3.5^1
 ;;^DD(58.12,4,21,0)
 ;;=^^2^2^2910125^^^^
 ;;^DD(58.12,4,21,1,0)
 ;;=This contains the quantity of the item dispensed to restore stock 
 ;;^DD(58.12,4,21,2,0)
 ;;=to the required level.
 ;;^DD(58.12,4,"DT")
 ;;=2910228
 ;;^DD(58.12,5,0)
 ;;=PERCENTAGE OF STOCK ON HAND^CJ8^^ ; ^S Y(58.12,5,1)=$S($D(^PSI(58.1,D0,1,D1,1,D2,0)):^(0),1:"") S X=$P(Y(58.12,5,1),U,6),X=$S($P(Y(58.12,5,1),U,2):X/$P(Y(58.12,5,1),U,2),1:"*******")*100
 ;;^DD(58.12,5,9)
 ;;=^
 ;;^DD(58.12,5,9.01)
 ;;=58.12^1;58.12^3.5
 ;;^DD(58.12,5,9.1)
 ;;=ON HAND/LEVEL*100
 ;;^DD(58.12,5,9.2)
 ;;=S Y(58.12,5,1)=$S($D(^PSI(58.1,D0,1,D1,1,D2,0)):^(0),1:"") S X=$P(Y(58.12,5,1),U,2),Y(58.12,5,2)=X S X=$P(Y(58.12,5,1),U,6),Y=X,X=Y(58.12,5,2),X=X-Y,X=$S($P(Y(58.12,5,1),U,2):X/$P(Y(58.12,5,1),U,2),1:"*******")
 ;;^DD(58.12,5,21,0)
 ;;=^^2^2^2871008^^
 ;;^DD(58.12,5,21,1,0)
 ;;=Percentage stock on hand is computed by dividing the amount on hand
 ;;^DD(58.12,5,21,2,0)
 ;;=by the stock level times 100.
 ;;^DD(58.12,5,"DT")
 ;;=2871008
 ;;^DD(58.13,0)
 ;;=TYPE OF INVENTORY SUB-FIELD^NL^1^2
 ;;^DD(58.13,0,"NM","TYPE OF INVENTORY")
 ;;=
 ;;^DD(58.13,0,"UP")
 ;;=58.11
 ;;^DD(58.13,.01,0)
 ;;=TYPE^M*P58.16'X^PSI(58.16,^0;1^S DIC("S")="I $P(^(0),""^"")'=""ALL""" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X S:$D(X) DINUM=X
 ;;^DD(58.13,.01,1,0)
 ;;=^.1^^0
 ;;^DD(58.13,.01,12)
 ;;=Enter type for item
 ;;^DD(58.13,.01,12.1)
 ;;=S DIC("S")="I $P(^(0),""^"")'=""ALL"""
 ;;^DD(58.13,.01,21,0)
 ;;=^^3^3^2880114^^^
 ;;^DD(58.13,.01,21,1,0)
 ;;=This points to the types defined in File 58.16 -
 ;;^DD(58.13,.01,21,2,0)
 ;;=AOU Inventory Type File.  Inventory types are used to group
 ;;^DD(58.13,.01,21,3,0)
 ;;=related items in an Area of Use.
 ;;^DD(58.13,.01,"DT")
 ;;=2900213
 ;;^DD(58.13,1,0)
 ;;=*TEST^F^^0;2^K:$L(X)>1!($L(X)<1) X
 ;;^DD(58.13,1,3)
 ;;=ANSWER MUST BE 1 CHARACTER IN LENGTH
 ;;^DD(58.13,1,21,0)
 ;;=^^1^1^2880224^^
 ;;^DD(58.13,1,21,1,0)
 ;;=NOT CURRENTLY USED.
 ;;^DD(58.13,1,"DT")
 ;;=2851030
 ;;^DD(58.14,0)
 ;;=WARD/LOCATION (FOR PERCENTAGE) SUB-FIELD^NL^2^3
 ;;^DD(58.14,0,"NM","WARD/LOCATION (FOR PERCENTAGE)")
 ;;=
 ;;^DD(58.14,0,"UP")
 ;;=58.1
 ;;^DD(58.14,.01,0)
 ;;=WARD/LOCATION (FOR PERCENTAGE)^MRP44'^SC(^0;1^Q
 ;;^DD(58.14,.01,1,0)
 ;;=^.1^^0
 ;;^DD(58.14,.01,21,0)
 ;;=^^5^5^2891003^^^^
 ;;^DD(58.14,.01,21,1,0)
 ;;=This points to File 44 - the Hospital Location File.  It contains the
 ;;^DD(58.14,.01,21,2,0)
 ;;=name of the ward(s) or location(s) that are served partially or 
 ;;^DD(58.14,.01,21,3,0)
 ;;=totally by this Area of Use.  If the Area of Use is NOT composed 
 ;;^DD(58.14,.01,21,4,0)
 ;;=of any wards or locations, enter "^"<RETURN> at the WARD/LOCATION
 ;;^DD(58.14,.01,21,5,0)
 ;;=(FOR PERCENTAGE) prompt.
 ;;^DD(58.14,.01,"DT")
 ;;=2891003
 ;;^DD(58.14,1,0)
 ;;=WARD/LOCATION % OF USE^RNJ3,0^^0;2^K:+X'=X!(X>100)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(58.14,1,3)
 ;;=Type a whole number between 1 and 100
 ;;^DD(58.14,1,21,0)
 ;;=^^2^2^2891009^^^^
 ;;^DD(58.14,1,21,1,0)
 ;;=This ward/location uses a percentage of the items in this AOU.  
 ;;^DD(58.14,1,21,2,0)
 ;;=Enter that percentage here.  This is primarily used for report purposes.
 ;;^DD(58.14,1,"DT")
 ;;=2840915
 ;;^DD(58.14,2,0)
 ;;=SERVICE^58.27P^^1;0
 ;;^DD(58.15,0)
 ;;=RETURNS SUB-FIELD^NL^3^3
 ;;^DD(58.15,0,"IX","AMIS",58.15,1)
 ;;=
 ;;^DD(58.15,0,"IX","AMISERR",58.15,1)
 ;;=
 ;;^DD(58.15,0,"NM","RETURNS")
 ;;=
 ;;^DD(58.15,0,"UP")
 ;;=58.11
 ;;^DD(58.15,.01,0)
 ;;=DATE OF RETURN^MDX^^0;1^S %DT="EX" D ^%DT S X=Y K:Y<1 X S:$D(X) DINUM=X
 ;;^DD(58.15,.01,21,0)
 ;;=^^1^1^2871008^
 ;;^DD(58.15,.01,21,1,0)
 ;;=This contains the date the item was returned from the Area of Use.
 ;;^DD(58.15,.01,"DT")
 ;;=2900213
 ;;^DD(58.15,1,0)
 ;;=RETURN QUANTITY^NJ4,0X^^0;2^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X D:$D(X) OND^PSGWUTL
 ;;^DD(58.15,1,1,0)
 ;;=^.1
 ;;^DD(58.15,1,1,1,0)
 ;;=58.15^AMIS^MUMPS
 ;;^DD(58.15,1,1,1,1)
 ;;=Q:$D(PSGWV)  D RET^PSGWUTL
 ;;^DD(58.15,1,1,1,2)
 ;;=Q:$D(PSGWV)  D KRET^PSGWUTL
 ;;^DD(58.15,1,1,1,"%D",0)
 ;;=^^4^4^2930811^
 ;;^DD(58.15,1,1,1,"%D",1,0)
 ;;=This cross-reference is set everytime a quantity greater than zero is
