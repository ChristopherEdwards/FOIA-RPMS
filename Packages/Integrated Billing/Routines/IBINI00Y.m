IBINI00Y	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,.168,1,1,"CREATE CONDITION")
	;;=S X='$P($G(^DIC(36,DA,.16)),"^",8)
	;;^DD(36,.168,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.168,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(36,.168,1,1,"DT")
	;;=2931006
	;;^DD(36,.168,1,1,"FIELD")
	;;=#.167
	;;^DD(36,.168,21,0)
	;;=^^1^1^2931007^^^^
	;;^DD(36,.168,21,1,0)
	;;=Enter "Yes" if another insurance company processes Outpatient Claims.
	;;^DD(36,.168,"DT")
	;;=2931007
	;;^DD(36,.169,0)
	;;=CLAIMS (OPT) FAX^F^^.16;9^K:$L(X)>20!($L(X)<7) X
	;;^DD(36,.169,3)
	;;=Enter the fax number of the outpatient claims office with 7 - 20 characters, ex. 999-9999, 999-999-9999.
	;;^DD(36,.169,21,0)
	;;=^^1^1^2931122^^
	;;^DD(36,.169,21,1,0)
	;;=Enter the fax number of the outpatient claims office of this insurance carrier.
	;;^DD(36,.169,"DT")
	;;=2931122
	;;^DD(36,.178,0)
	;;=ANOTHER CO. PROCESS PRECERTS?^S^0:NO;1:YES;^.17;8^Q
	;;^DD(36,.178,.1)
	;;=Are Precerts Processed by Another Insurance Co.?
	;;^DD(36,.178,1,0)
	;;=^.1
	;;^DD(36,.178,1,1,0)
	;;=^^TRIGGER^36^.139
	;;^DD(36,.178,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X='$P($G(^DIC(36,DA,.17)),"^",8) I X S X=DIV S Y(1)=$S($D(^DIC(36,D0,.13)):^(.13),1:"") S X=$P(Y(1),U,9),X=X S DIU=X K Y S X="" X ^DD(36,.178,1,1,1.4)
	;;^DD(36,.178,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.13)):^(.13),1:""),DIV=X S $P(^(.13),U,9)=DIV,DIH=36,DIG=.139 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.178,1,1,2)
	;;=Q
	;;^DD(36,.178,1,1,"CREATE CONDITION")
	;;=S X='$P($G(^DIC(36,DA,.17)),"^",8)
	;;^DD(36,.178,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.178,1,1,"DELETE VALUE")
	;;=NO EFFECT
	;;^DD(36,.178,1,1,"FIELD")
	;;=#.139
	;;^DD(36,.178,21,0)
	;;=^^1^1^2931007^^
	;;^DD(36,.178,21,1,0)
	;;=Enter "Yes" if another insurance company processes precerts.
	;;^DD(36,.178,"DT")
	;;=2931007
	;;^DD(36,.181,0)
	;;=CLAIMS (RX) STREET ADDRESS 1^F^^.18;1^K:$L(X)>30!($L(X)<3) X
	;;^DD(36,.181,1,0)
	;;=^.1
	;;^DD(36,.181,1,1,0)
	;;=^^TRIGGER^36^.182
	;;^DD(36,.181,1,1,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.18)):^(.18),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.181,1,1,1.4)
	;;^DD(36,.181,1,1,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.18)):^(.18),1:""),DIV=X S $P(^(.18),U,2)=DIV,DIH=36,DIG=.182 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.181,1,1,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.18)):^(.18),1:"") S X=$P(Y(1),U,2),X=X S DIU=X K Y S X="" X ^DD(36,.181,1,1,2.4)
	;;^DD(36,.181,1,1,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.18)):^(.18),1:""),DIV=X S $P(^(.18),U,2)=DIV,DIH=36,DIG=.182 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.181,1,1,"%D",0)
	;;=^^1^1^2940104^^
	;;^DD(36,.181,1,1,"%D",1,0)
	;;=When changing or deleting CLAIMS (RX) STREET 1 delete CLAIMS (RX) STREET ADDRESS 1.
	;;^DD(36,.181,1,1,"CREATE VALUE")
	;;=@
	;;^DD(36,.181,1,1,"DELETE VALUE")
	;;=@
	;;^DD(36,.181,1,1,"FIELD")
	;;=#.182
	;;^DD(36,.181,1,2,0)
	;;=^^TRIGGER^36^.183
	;;^DD(36,.181,1,2,1)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.18)):^(.18),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.181,1,2,1.4)
	;;^DD(36,.181,1,2,1.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.18)):^(.18),1:""),DIV=X S $P(^(.18),U,3)=DIV,DIH=36,DIG=.183 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.181,1,2,2)
	;;=K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(1)=$S($D(^DIC(36,D0,.18)):^(.18),1:"") S X=$P(Y(1),U,3),X=X S DIU=X K Y S X="" X ^DD(36,.181,1,2,2.4)
	;;^DD(36,.181,1,2,2.4)
	;;=S DIH=$S($D(^DIC(36,DIV(0),.18)):^(.18),1:""),DIV=X S $P(^(.18),U,3)=DIV,DIH=36,DIG=.183 D ^DICR:$O(^DD(DIH,DIG,1,0))>0
	;;^DD(36,.181,1,2,"%D",0)
	;;=^^1^1^2940104^
