IBINI01E	; ; 21-MAR-1994
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	Q:'DIFQ(350.1)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(350.1,.08,"DT")
	;;=2920227
	;;^DD(350.1,.09,0)
	;;=NEW ACTION TYPE^P350.1'^IBE(350.1,^0;9^Q
	;;^DD(350.1,.09,21,0)
	;;=^^1^1^2920227^
	;;^DD(350.1,.09,21,1,0)
	;;=This is the IB ACTION TYPE entry that is the 'NEW' type for this entry.
	;;^DD(350.1,.09,"DT")
	;;=2920227
	;;^DD(350.1,.1,0)
	;;=PLACE ON HOLD^S^1:YES;0:NO;^0;10^Q
	;;^DD(350.1,.1,21,0)
	;;=1^^8^8^2920414^^
	;;^DD(350.1,.1,21,1,0)
	;;=This field is used to flag those IB Actions (as identified by the IB
	;;^DD(350.1,.1,21,2,0)
	;;=Action Type) which may be 'held up' in Integrated Billing until
	;;^DD(350.1,.1,21,3,0)
	;;=reimbursement from an Insurance company for the billing of the same
	;;^DD(350.1,.1,21,4,0)
	;;=event has been received.
	;;^DD(350.1,.1,21,5,0)
	;;= 
	;;^DD(350.1,.1,21,6,0)
	;;=The field will be set to 'YES' if the Action Type is one which
	;;^DD(350.1,.1,21,7,0)
	;;=represents a billable action which may be billed to a patient's
	;;^DD(350.1,.1,21,8,0)
	;;=insurance company as well as to the patient.
	;;^DD(350.1,.1,"DT")
	;;=2920227
	;;^DD(350.1,.11,0)
	;;=BILLING GROUP^S^1:INPT/NHCU FEE SERVICE;2:INPT/NHCU COPAY;3:INPT/NHCU PER DIEM;4:OPT COPAY;5:RX COPAY;6:CHAMPVA;^0;11^Q
	;;^DD(350.1,.11,3)
	;;=Enter Group for manual charge processing.
	;;^DD(350.1,.11,21,0)
	;;=^^2^2^2920415^
	;;^DD(350.1,.11,21,1,0)
	;;=This field is a set of codes used to enter the group for
	;;^DD(350.1,.11,21,2,0)
	;;=manual charge processing.
	;;^DD(350.1,.11,"DT")
	;;=2930729
	;;^DD(350.1,10,0)
	;;=PARENT TRACE LOGIC^K^^10;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
	;;^DD(350.1,10,3)
	;;=This is Standard MUMPS code.
	;;^DD(350.1,10,21,0)
	;;=^^8^8^2940209^^^^
	;;^DD(350.1,10,21,1,0)
	;;=This is the executable code that will expand the field RESULTING FROM in
	;;^DD(350.1,10,21,2,0)
	;;=the INTEGRATED BILLING ACTION File to return in Y(n) the zeroth node
	;;^DD(350.1,10,21,3,0)
	;;=of the entry creating this entry.  If the entry is caused by a top
	;;^DD(350.1,10,21,4,0)
	;;=level entry then Y(0) will equal the zeroth node of the file.  If
	;;^DD(350.1,10,21,5,0)
	;;=an entry is caused by a lower level entry then in addition to Y(0),
	;;^DD(350.1,10,21,6,0)
	;;=Y(1) will be the zeroth node of the next lower level, Y(2) will be the
	;;^DD(350.1,10,21,7,0)
	;;=zeroth node of the third level, etc.  If a node described in the
	;;^DD(350.1,10,21,8,0)
	;;=RESULTING FROM field in file 350 is not present then Y=-1^error code.
	;;^DD(350.1,20,0)
	;;=SET LOGIC^K^^20;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
	;;^DD(350.1,20,3)
	;;=This is Standard MUMPS code.
	;;^DD(350.1,20,21,0)
	;;=^^4^4^2910305^^^
	;;^DD(350.1,20,21,1,0)
	;;=This is the executable MUMPS code that will calculate the BRIEF DESCRIPTION
	;;^DD(350.1,20,21,2,0)
	;;=stored in file 350.  This is used by the IB application interface routines.
	;;^DD(350.1,20,21,3,0)
	;;=This may execute the PARENT TRACE LOGIC to return data from the
	;;^DD(350.1,20,21,4,0)
	;;=application.
	;;^DD(350.1,30,0)
	;;=FULL PROFILE LOGIC^K^^30;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
	;;^DD(350.1,30,3)
	;;=This is Standard MUMPS code.
	;;^DD(350.1,30,21,0)
	;;=^^3^3^2910305^^
	;;^DD(350.1,30,21,1,0)
	;;=This is the standard MUMPS code that will calculate the full profile
	;;^DD(350.1,30,21,2,0)
	;;=of an IB ACTION entry as approved by the DBA agreements between integrating
	;;^DD(350.1,30,21,3,0)
	;;=applications.
	;;^DD(350.1,40,0)
	;;=ELIGIBILITY LOGIC^K^^40;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
	;;^DD(350.1,40,3)
	;;=This is Standard MUMPS code.
	;;^DD(350.1,40,21,0)
	;;=^^2^2^2910305^^
	;;^DD(350.1,40,21,1,0)
	;;=This field the standard mumps code to determine  eligibility
