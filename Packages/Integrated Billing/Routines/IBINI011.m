IBINI011	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(36)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(36,1,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36,1,"DT")
	;;=2901102
	;;^DD(36,2,0)
	;;=SIGNATURE REQUIRED ON BILL?^RS^0:NO;1:YES;^0;3^Q
	;;^DD(36,2,3)
	;;=Enter 'Yes' if a bill sent to this insurance carrier requires a manual signature or 'No' if it does not.
	;;^DD(36,2,21,0)
	;;=^^2^2^2911222^
	;;^DD(36,2,21,1,0)
	;;=Enter a yes or no in this field denoting whether a signature is required
	;;^DD(36,2,21,2,0)
	;;=on a bill before being submitted to the insurance carrier.
	;;^DD(36,2,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36,2,"DT")
	;;=2911222
	;;^DD(36,10,0)
	;;=SYNONYM^36.03^^10;0
	;;^DD(36,11,0)
	;;=REMARKS^36.011^^11;0
	;;^DD(36,11,21,0)
	;;=^^3^3^2931109^
	;;^DD(36,11,21,1,0)
	;;=You may enter unlimited free text comments about this insurance company.
	;;^DD(36,11,21,2,0)
	;;=It may be helpful to date ongoing comments and identify the source of 
	;;^DD(36,11,21,3,0)
	;;=the comments.
	;;^DD(36,11,"DT")
	;;=2931109
	;;^DD(36,30,0)
	;;=*ADDRESS^36.02I^^2;0
	;;^DD(36.011,0)
	;;=REMARKS SUB-FIELD^^.01^1
	;;^DD(36.011,0,"DT")
	;;=2931109
	;;^DD(36.011,0,"NM","REMARKS")
	;;=
	;;^DD(36.011,0,"UP")
	;;=36
	;;^DD(36.011,.01,0)
	;;=REMARKS^W^^0;1^Q
	;;^DD(36.011,.01,3)
	;;=You may enter comments about this insurance company.
	;;^DD(36.011,.01,"DT")
	;;=2931109
	;;^DD(36.02,0)
	;;=*ADDRESS SUB-FIELD^^6^6
	;;^DD(36.02,0,"ID",.01)
	;;=I $D(^(0)) S %A=^(0) W !?3,$P(%A,U,2),",",?15," ",$S($D(^DIC(5,+$P(%A,U,3),0)):$P(^(0),U,1),1:""),?30," ",$P(%A,U,4) K %A
	;;^DD(36.02,0,"IX","B",36.02,.01)
	;;=
	;;^DD(36.02,0,"IX","C",36.02,3)
	;;=
	;;^DD(36.02,0,"IX","D",36.02,2)
	;;=
	;;^DD(36.02,0,"NM","*ADDRESS")
	;;=
	;;^DD(36.02,0,"UP")
	;;=36
	;;^DD(36.02,.01,0)
	;;=STREET^FX^^0;1^K:$L(X)>35!($L(X)<3) X I $D(X) K:'$D(DGINS) X
	;;^DD(36.02,.01,1,0)
	;;=^.1
	;;^DD(36.02,.01,1,1,0)
	;;=36.02^B
	;;^DD(36.02,.01,1,1,1)
	;;=S ^DIC(36,DA(1),2,"B",$E(X,1,30),DA)=""
	;;^DD(36.02,.01,1,1,2)
	;;=K ^DIC(36,DA(1),2,"B",$E(X,1,30),DA)
	;;^DD(36.02,.01,3)
	;;=ANSWER MUST BE 3-35 CHARACTERS IN LENGTH
	;;^DD(36.02,.01,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36.02,.01,"DT")
	;;=2880914
	;;^DD(36.02,2,0)
	;;=CITY^FX^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>25!($L(X)<2) X I $D(X) K:'$D(DGINS) X
	;;^DD(36.02,2,1,0)
	;;=^.1
	;;^DD(36.02,2,1,1,0)
	;;=36.02^D
	;;^DD(36.02,2,1,1,1)
	;;=S ^DIC(36,DA(1),2,"D",$E(X,1,30),DA)=""
	;;^DD(36.02,2,1,1,2)
	;;=K ^DIC(36,DA(1),2,"D",$E(X,1,30),DA)
	;;^DD(36.02,2,3)
	;;=ANSWER MUST BE 2-25 CHARACTERS IN LENGTH
	;;^DD(36.02,2,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36.02,2,"DT")
	;;=2890124
	;;^DD(36.02,3,0)
	;;=STATE^P5'X^DIC(5,^0;3^K:'$D(DGINS) X I $D(X) K:'$D(DGINS) X
	;;^DD(36.02,3,1,0)
	;;=^.1
	;;^DD(36.02,3,1,1,0)
	;;=36.02^C
	;;^DD(36.02,3,1,1,1)
	;;=S ^DIC(36,DA(1),2,"C",$E(X,1,30),DA)=""
	;;^DD(36.02,3,1,1,2)
	;;=K ^DIC(36,DA(1),2,"C",$E(X,1,30),DA)
	;;^DD(36.02,3,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36.02,3,"DT")
	;;=2880914
	;;^DD(36.02,4,0)
	;;=ZIP CODE^FX^^0;4^K:$L(X)>5!($L(X)<5) X I $D(X) K:'$D(DGINS) X
	;;^DD(36.02,4,3)
	;;=ANSWER MUST BE 5 CHARACTERS IN LENGTH
	;;^DD(36.02,4,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36.02,4,"DT")
	;;=2890106
	;;^DD(36.02,5,0)
	;;=TELEPHONE^FX^^0;5^K:$L(X)>20!($L(X)<7) X I $D(X) K:'$D(DGINS) X
	;;^DD(36.02,5,3)
	;;=ANSWER MUST BE 7-20 CHARACTERS IN LENGTH
	;;^DD(36.02,5,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36.02,5,"DT")
	;;=2890124
	;;^DD(36.02,6,0)
	;;=POINT TO^P36IX^DIC(36,^0;6^K:'$D(DGINS) X I $D(X) K:'$D(DGINS) X
	;;^DD(36.02,6,"DEL",1,0)
	;;=I $D(DGINS)
	;;^DD(36.02,6,"DT")
	;;=2880914
	;;^DD(36.03,0)
	;;=SYNONYM SUB-FIELD^^.01^1
	;;^DD(36.03,0,"DT")
	;;=2930326
	;;^DD(36.03,0,"IX","B",36.03,.01)
	;;=
