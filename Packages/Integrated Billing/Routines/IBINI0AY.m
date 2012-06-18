IBINI0AY	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399.042,.08,23,4,0)
	;;=This is used to determine which of the revenue codes should be deleted
	;;^DD(399.042,.08,23,5,0)
	;;=before the calculator re-builds them.  (ALL^IBCU61)
	;;^DD(399.042,.08,"DT")
	;;=2940207
	;;^DD(399.043,0)
	;;=OP VISITS DATE(S) SUB-FIELD^^.01^1
	;;^DD(399.043,0,"DIK")
	;;=IBXX
	;;^DD(399.043,0,"NM","OP VISITS DATE(S)")
	;;=
	;;^DD(399.043,0,"UP")
	;;=399
	;;^DD(399.043,.01,0)
	;;=OP VISITS DATE(S)^MDX^^0;1^S %DT="E" D ^%DT S X=Y K:Y<1!('$D(IBIFN))!('$$OPV^IBCU41(X,IBIFN)) X I $D(X) S DINUM=X
	;;^DD(399.043,.01,1,0)
	;;=^.1
	;;^DD(399.043,.01,1,1,0)
	;;=399^AOPV^MUMPS
	;;^DD(399.043,.01,1,1,1)
	;;=S ^DGCR(399,"AOPV",$P(^DGCR(399,DA(1),0),U,2),$E(X,1,30),DA(1))=""
	;;^DD(399.043,.01,1,1,2)
	;;=K ^DGCR(399,"AOPV",$P(^DGCR(399,DA(1),0),U,2),$E(X,1,30),DA(1))
	;;^DD(399.043,.01,1,1,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399.043,.01,1,1,"%D",1,0)
	;;=Cross reference of bills by patient and outpatient visit date.
	;;^DD(399.043,.01,1,2,0)
	;;=399^AREV1^MUMPS
	;;^DD(399.043,.01,1,2,1)
	;;=S DGRVRCAL=1
	;;^DD(399.043,.01,1,2,2)
	;;=S DGRVRCAL=2
	;;^DD(399.043,.01,1,2,"%D",0)
	;;=^^2^2^2940214^^
	;;^DD(399.043,.01,1,2,"%D",1,0)
	;;=Variable causes revenue codes and chrges to be re-calculated on return
	;;^DD(399.043,.01,1,2,"%D",2,0)
	;;=to the enter/edit billing screens.
	;;^DD(399.043,.01,3)
	;;=Enter outpatient dates which are covered by this bill. These dates must be included within the period which this statement covers.
	;;^DD(399.043,.01,"DT")
	;;=2930903
	;;^DD(399.044,0)
	;;=REASON(S) DISAPPROVED-INITIAL SUB-FIELD^^.01^1
	;;^DD(399.044,0,"DIK")
	;;=IBXX
	;;^DD(399.044,0,"IX","B",399.044,.01)
	;;=
	;;^DD(399.044,0,"NM","REASON(S) DISAPPROVED-INITIAL")
	;;=
	;;^DD(399.044,0,"UP")
	;;=399
	;;^DD(399.044,.01,0)
	;;=REASON(S) DISAPPROVED-INITIAL^MP399.4'^DGCR(399.4,^0;1^Q
	;;^DD(399.044,.01,1,0)
	;;=^.1
	;;^DD(399.044,.01,1,1,0)
	;;=399.044^B
	;;^DD(399.044,.01,1,1,1)
	;;=S ^DGCR(399,DA(1),"D1","B",$E(X,1,30),DA)=""
	;;^DD(399.044,.01,1,1,2)
	;;=K ^DGCR(399,DA(1),"D1","B",$E(X,1,30),DA)
	;;^DD(399.044,.01,3)
	;;=Select reason(s) why this billing record has been disapproved.
	;;^DD(399.044,.01,"DT")
	;;=2880523
	;;^DD(399.045,0)
	;;=REASON(S) DISAPPROVED-SECOND SUB-FIELD^^.01^1
	;;^DD(399.045,0,"DIK")
	;;=IBXX
	;;^DD(399.045,0,"IX","B",399.045,.01)
	;;=
	;;^DD(399.045,0,"NM","REASON(S) DISAPPROVED-SECOND")
	;;=
	;;^DD(399.045,0,"UP")
	;;=399
	;;^DD(399.045,.01,0)
	;;=REASON(S) DISAPPROVED-SECOND^MP399.4'^DGCR(399.4,^0;1^Q
	;;^DD(399.045,.01,1,0)
	;;=^.1
	;;^DD(399.045,.01,1,1,0)
	;;=399.045^B
	;;^DD(399.045,.01,1,1,1)
	;;=S ^DGCR(399,DA(1),"D2","B",$E(X,1,30),DA)=""
	;;^DD(399.045,.01,1,1,2)
	;;=K ^DGCR(399,DA(1),"D2","B",$E(X,1,30),DA)
	;;^DD(399.045,.01,3)
	;;=Select reason(s) why this billing record has been disapproved.
	;;^DD(399.045,.01,"DT")
	;;=2880523
	;;^DD(399.046,0)
	;;=RETURNED LOG DATE/TIME SUB-FIELD^^.04^4
	;;^DD(399.046,0,"DIK")
	;;=IBXX
	;;^DD(399.046,0,"IX","AC",399.046,.04)
	;;=
	;;^DD(399.046,0,"IX","B",399.046,.01)
	;;=
	;;^DD(399.046,0,"NM","RETURNED LOG DATE/TIME")
	;;=
	;;^DD(399.046,0,"UP")
	;;=399
	;;^DD(399.046,.01,0)
	;;=LOG DATE/TIME^D^^0;1^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(399.046,.01,1,0)
	;;=^.1
	;;^DD(399.046,.01,1,1,0)
	;;=399.046^B
	;;^DD(399.046,.01,1,1,1)
	;;=S ^DGCR(399,DA(1),"R","B",$E(X,1,30),DA)=""
	;;^DD(399.046,.01,1,1,2)
	;;=K ^DGCR(399,DA(1),"R","B",$E(X,1,30),DA)
	;;^DD(399.046,.01,21,0)
	;;=^^1^1^2911025^
	;;^DD(399.046,.01,21,1,0)
	;;=This is the date and time that this entry was edited.
	;;^DD(399.046,.01,"DT")
	;;=2900605
