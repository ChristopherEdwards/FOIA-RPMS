IBINI0AD	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(399)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(399,103,21,1,0)
	;;=This is the name of the tertiary insurance carrier from which the provider
	;;^DD(399,103,21,2,0)
	;;=might expect some payment for this bill.
	;;^DD(399,103,"DT")
	;;=2940201
	;;^DD(399,104,0)
	;;=MAILING ADDRESS NAME^F^^M;4^K:$L(X)>30!($L(X)<1) X
	;;^DD(399,104,3)
	;;=Enter the name or title of the person to which this bill is to be sent.
	;;^DD(399,104,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,104,21,1,0)
	;;=This is the name of the party to whom this bill is to be sent.
	;;^DD(399,104,"DT")
	;;=2880523
	;;^DD(399,105,0)
	;;=MAILING ADDRESS STREET^FX^^M;5^K:$L(X)>35!($L(X)<3) X
	;;^DD(399,105,3)
	;;=Enter the 3-35 character street address to which this bill is to be mailed.
	;;^DD(399,105,9.3)
	;;=I '$D(^DGCR(399,D0,"M")),$D(^DGCR(399,D0,"I1")) S IBITY=$P(^DGCR(399,D0,"I1"),"^",1),IBIMA=^DIC(36,IBITY,2,1,0) I $D(IBIMA),IBIMA'="" S ^DGCR(399,D0,"M")=IBIMA
	;;^DD(399,105,21,0)
	;;=^^1^1^2900307^^^
	;;^DD(399,105,21,1,0)
	;;=This is the street address to which this bill is to be sent.
	;;^DD(399,105,"DT")
	;;=2890131
	;;^DD(399,106,0)
	;;=MAILING ADDRESS STREET2^F^^M;6^K:$L(X)>35!($L(X)<3) X
	;;^DD(399,106,3)
	;;=Enter the 3-35 character street address to which this bill is to be mailed.
	;;^DD(399,106,21,0)
	;;=^^1^1^2900307^^^
	;;^DD(399,106,21,1,0)
	;;=This is the street address to which this bill is to be sent.
	;;^DD(399,107,0)
	;;=MAILING ADDRESS CITY^F^^M;7^K:$L(X)>25!($L(X)<2) X
	;;^DD(399,107,3)
	;;=Enter the 2-25 character city to which this bill is to be mailed.
	;;^DD(399,107,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,107,21,1,0)
	;;=This is the city to which this bill is to be sent.
	;;^DD(399,107,"DT")
	;;=2890213
	;;^DD(399,108,0)
	;;=MAILING ADDRESS STATE^P5'^DIC(5,^M;8^Q
	;;^DD(399,108,3)
	;;=Enter the state to which this bill is to be mailed.
	;;^DD(399,108,21,0)
	;;=^^1^1^2880831^
	;;^DD(399,108,21,1,0)
	;;=This is the state to which this bill is to be sent.
	;;^DD(399,108,"DT")
	;;=2880523
	;;^DD(399,109,0)
	;;=MAILING ADDRESS ZIP CODE^F^^M;9^K:$L(X)>9!($L(X)<5)!'(X?5N!(X?9N)) X
	;;^DD(399,109,3)
	;;=Enter the 5-digit or 9-digit zip code to which this bill is to be sent.
	;;^DD(399,109,21,0)
	;;=^^1^1^2930223^^
	;;^DD(399,109,21,1,0)
	;;=This is the 5-digit or 9-digit zip code to which this bill is to be sent.
	;;^DD(399,109,"DT")
	;;=2880831
	;;^DD(399,110,0)
	;;=PATIENT SHORT MAILING ADDRESS^RF^^M;10^K:$L(X)>47!($L(X)<1) X
	;;^DD(399,110,3)
	;;=Answer with the 1-47 character short form of the patient mailing address.  This is all the information run together with a maximum of 47 characters.
	;;^DD(399,110,21,0)
	;;=^^5^5^2940120^^^^
	;;^DD(399,110,21,1,0)
	;;=This is the 1-47 character patient mailing address that will print in
	;;^DD(399,110,21,2,0)
	;;=block 11 on the UB-82 form and block 13 on the UB-92.  The computer will
	;;^DD(399,110,21,3,0)
	;;=try to calculate this.  If the length of all the patient address
	;;^DD(399,110,21,4,0)
	;;=fields is longer than 47 characters you will need to abbreviate this in
	;;^DD(399,110,21,5,0)
	;;=order to get it to print in this block.
	;;^DD(399,110,"DT")
	;;=2890419
	;;^DD(399,111,0)
	;;=RESPONSIBLE INSTITUTION^RP4^DIC(4,^M;11^Q
	;;^DD(399,111,1,0)
	;;=^.1
	;;^DD(399,111,1,1,0)
	;;=399^AML^MUMPS
	;;^DD(399,111,1,1,1)
	;;=D MAILIN^IBCU5
	;;^DD(399,111,1,1,2)
	;;=D DEL^IBCU5
	;;^DD(399,111,1,1,"%D",0)
	;;=^^1^1^2940214^
	;;^DD(399,111,1,1,"%D",1,0)
	;;=Sets/deletes mailing address.
	;;^DD(399,111,1,2,0)
	;;=399^AREV5^MUMPS
	;;^DD(399,111,1,2,1)
	;;=S DGRVRCAL=1
	;;^DD(399,111,1,2,2)
	;;=S DGRVRCAL=2
	;;^DD(399,111,1,2,"%D",0)
	;;=^^2^2^2940214^
