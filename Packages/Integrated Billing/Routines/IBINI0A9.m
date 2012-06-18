IBINI0A9	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,59,12.1)
	;;=S DIC("S")="I $P(^(0),""^"",1)?1A.N"
	;;^DD(399,59,21,0)
	;;=^^3^3^2911104^^
	;;^DD(399,59,21,1,0)
	;;=This is a HCFA outpatient procedure code.
	;;^DD(399,59,21,2,0)
	;;= 
	;;^DD(399,59,21,3,0)
	;;=This field has been marked for deletion on 11/4/91.
	;;^DD(399,59,"DT")
	;;=2920122
	;;^DD(399,60,0)
	;;=OUTPATIENT DIAGNOSIS^FX^^C;10^K:$L(X)>45!($L(X)<1)!'(X?1U.ANP) X
	;;^DD(399,60,3)
	;;=Answer must be 1-45 characters in length.
	;;^DD(399,60,5,1,0)
	;;=399^64^1
	;;^DD(399,60,9)
	;;=^
	;;^DD(399,60,21,0)
	;;=^^1^1^2900525^^^^
	;;^DD(399,60,21,1,0)
	;;=The outpatient diagnosis is selectable from the ICD DIAGNOSIS file.
	;;^DD(399,60,"DT")
	;;=2900613
	;;^DD(399,61,0)
	;;=*PROCDEDURE DATE (1)^RDX^^C;11^S %DT="EX" D ^%DT S X=Y I $D(X) D DTMES^IBCU7
	;;^DD(399,61,.1)
	;;=PROCEDURE DATE (1)
	;;^DD(399,61,3)
	;;=TYPE A DATE ON OR BEFORE TODAY
	;;^DD(399,61,21,0)
	;;=^^4^4^2920615^^^^
	;;^DD(399,61,21,1,0)
	;;=This is the date on which the first procedure associated with this
	;;^DD(399,61,21,2,0)
	;;=billing episode occurred.
	;;^DD(399,61,21,3,0)
	;;= 
	;;^DD(399,61,21,4,0)
	;;=This field has been marked for deletion on 11/4/91.
	;;^DD(399,61,"DT")
	;;=2911104
	;;^DD(399,62,0)
	;;=*PROCEDURE DATE (2)^RDX^^C;12^S %DT="EX" D ^%DT S X=Y I $D(X) D DTMES^IBCU7
	;;^DD(399,62,.1)
	;;=PROCEDURE DATE (2)
	;;^DD(399,62,3)
	;;=
	;;^DD(399,62,21,0)
	;;=^^4^4^2911104^^
	;;^DD(399,62,21,1,0)
	;;=This is the date on which the second procedure associated with
	;;^DD(399,62,21,2,0)
	;;=this billing episode occurred.
	;;^DD(399,62,21,3,0)
	;;= 
	;;^DD(399,62,21,4,0)
	;;=This field has been marked for deletion on 11/4/91.
	;;^DD(399,62,"DT")
	;;=2911104
	;;^DD(399,63,0)
	;;=*PROCEDURE DATE (3)^RDX^^C;13^S %DT="EX" D ^%DT S X=Y I $D(X) D DTMES^IBCU7
	;;^DD(399,63,.1)
	;;=PROCEDURE DATE (3)
	;;^DD(399,63,3)
	;;=TYPE A DATE ON OR BEFORE TODAY
	;;^DD(399,63,21,0)
	;;=^^4^4^2911104^^
	;;^DD(399,63,21,1,0)
	;;=This is the date on which the third procedure associated with this
	;;^DD(399,63,21,2,0)
	;;=billing episode occurred.
	;;^DD(399,63,21,3,0)
	;;= 
	;;^DD(399,63,21,4,0)
	;;=This field has been marked for deletion on 11/4/91.
	;;^DD(399,63,"DT")
	;;=2911104
	;;^DD(399,64,0)
	;;=*ICD DIAGNOSIS CODE (1)^RP80'^ICD9(^C;14^Q
	;;^DD(399,64,.1)
	;;=ICD DIAGNOSIS CODE (1)
	;;^DD(399,64,1,0)
	;;=^.1
	;;^DD(399,64,1,1,0)
	;;=^^TRIGGER^399^60
	;;^DD(399,64,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X I $P(^DGCR(399,DA,0),"^",5)>2 I X S X=DIV S Y(1)=$S($D(^DGCR(399,D0,"C")):^("C"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X=DIV S X=$P(^ICD9(+X,0),"^",3) X ^DD(399,64,1,1,1.4)
	;;^DD(399,64,1,1,1.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"C")):^("C"),1:""),DIV=X S $P(^("C"),U,10)=DIV,DIH=399,DIG=60 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,64,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DGCR(399,D0,"C")):^("C"),1:"") S X=$P(Y(1),U,10),X=X S DIU=X K Y S X="" X ^DD(399,64,1,1,2.4)
	;;^DD(399,64,1,1,2.4)
	;;=S DIH=$S($D(^DGCR(399,DIV(0),"C")):^("C"),1:""),DIV=X S $P(^("C"),U,10)=DIV,DIH=399,DIG=60 D ^DICR:$N(^DD(DIH,DIG,1,0))>0
	;;^DD(399,64,1,1,"%D",0)
	;;=^^1^1^2920211^
	;;^DD(399,64,1,1,"%D",1,0)
	;;=Sets the Outpatient Diagnosis to the ICD DIAGNOSIS CODE (1).
	;;^DD(399,64,1,1,"CREATE CONDITION")
	;;=I $P(^DGCR(399,DA,0),"^",5)>2
	;;^DD(399,64,1,1,"CREATE VALUE")
	;;=S X=$P(^ICD9(+X,0),"^",3)
	;;^DD(399,64,1,1,"DELETE VALUE")
	;;=@
	;;^DD(399,64,1,1,"DT")
	;;=2920211
	;;^DD(399,64,1,1,"FIELD")
	;;=#60
	;;^DD(399,64,3)
	;;=Enter the ICD diagnosis code which pertains to this billing episode.
	;;^DD(399,64,21,0)
	;;=^^1^1^2931117^^^
