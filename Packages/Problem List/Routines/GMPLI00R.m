GMPLI00R	; ; 25-AUG-1994
	;;2.0;Problem List;;Aug 25, 1994
	Q:'DIFQ(9000011)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(9000011,1.1,23,2,0)
	;;=patient is indicated for service connection.  Non-VA sites will not
	;;^DD(9000011,1.1,23,3,0)
	;;=be prompted for this information.
	;;^DD(9000011,1.1,"DT")
	;;=2930726
	;;^DD(9000011,1.11,0)
	;;=AGENT ORANGE EXPOSURE^S^1:YES;0:NO;^1;11^Q
	;;^DD(9000011,1.11,3)
	;;=Enter YES if this problem is related to exposure to Agent Orange.
	;;^DD(9000011,1.11,21,0)
	;;=^^2^2^2930726^
	;;^DD(9000011,1.11,21,1,0)
	;;=If this problem is related to a patient's exposure to Agent Orange,
	;;^DD(9000011,1.11,21,2,0)
	;;=it may be flagged here.
	;;^DD(9000011,1.11,23,0)
	;;=^^3^3^2930726^
	;;^DD(9000011,1.11,23,1,0)
	;;=This data will be prompted for in the DHCP Problem List only if a patient
	;;^DD(9000011,1.11,23,2,0)
	;;=has Agent Orange exposure indicated.  Non-VA sites will not be prompted
	;;^DD(9000011,1.11,23,3,0)
	;;=for this information.
	;;^DD(9000011,1.11,"DT")
	;;=2930726
	;;^DD(9000011,1.12,0)
	;;=IONIZING RADIATION EXPOSURE^S^1:YES;0:NO;^1;12^Q
	;;^DD(9000011,1.12,3)
	;;=Enter YES if this problem is related to exposure to ionizing radiation.
	;;^DD(9000011,1.12,21,0)
	;;=^^2^2^2930726^
	;;^DD(9000011,1.12,21,1,0)
	;;=If this problem is related to a patient's exposure to ionizing radiation,
	;;^DD(9000011,1.12,21,2,0)
	;;=it may be flagged here.
	;;^DD(9000011,1.12,23,0)
	;;=^^3^3^2930726^
	;;^DD(9000011,1.12,23,1,0)
	;;=This data will be prompted for in the DHCP Problem List only if the patient
	;;^DD(9000011,1.12,23,2,0)
	;;=has ionizing radiation exposure indicated.  Non-VA sites will not be
	;;^DD(9000011,1.12,23,3,0)
	;;=prompted for this information.
	;;^DD(9000011,1.12,"DT")
	;;=2930726
	;;^DD(9000011,1.13,0)
	;;=PERSIAN GULF EXPOSURE^S^1:YES;0:NO;^1;13^Q
	;;^DD(9000011,1.13,3)
	;;=Enter YES if this problem is related to a Persian Gulf exposure.
	;;^DD(9000011,1.13,21,0)
	;;=^^2^2^2930726^
	;;^DD(9000011,1.13,21,1,0)
	;;=If this problem is related to a patient's service in the Persian Gulf,
	;;^DD(9000011,1.13,21,2,0)
	;;=it may be flagged here.
	;;^DD(9000011,1.13,23,0)
	;;=^^2^2^2930726^
	;;^DD(9000011,1.13,23,1,0)
	;;=This data will be prompted for only if a patient has Persian Gulf service
	;;^DD(9000011,1.13,23,2,0)
	;;=indicated.  Non-VA sites will not be prompted for this information.
	;;^DD(9000011,1.13,"DT")
	;;=2930726
	;;^DD(9000011,1.14,0)
	;;=PRIORITY^S^A:ACUTE;C:CHRONIC;^1;14^Q
	;;^DD(9000011,1.14,3)
	;;=You may further refine the status of this problem by assigning it a priority.
	;;^DD(9000011,1.14,21,0)
	;;=^^2^2^2940323^^^
	;;^DD(9000011,1.14,21,1,0)
	;;=This is a flag to indicate how critical this problem is for this patient;
	;;^DD(9000011,1.14,21,2,0)
	;;=problems marked as Acute will be flagged on the Problem List display.
	;;^DD(9000011,1.14,"DT")
	;;=2940201
	;;^DD(9000011,1101,0)
	;;=NOTE FACILITY^9000011.11PA^^11;0
	;;^DD(9000011,1101,21,0)
	;;=^^1^1^2940208^
	;;^DD(9000011,1101,21,1,0)
	;;=This is the location at which the notes in this multiple originated.
	;;^DD(9000011.11,0)
	;;=NOTE FACILITY SUB-FIELD^^1101^2
	;;^DD(9000011.11,0,"DT")
	;;=2940110
	;;^DD(9000011.11,0,"IX","B",9000011.11,.01)
	;;=
	;;^DD(9000011.11,0,"NM","NOTE FACILITY")
	;;=
	;;^DD(9000011.11,0,"UP")
	;;=9000011
	;;^DD(9000011.11,.01,0)
	;;=NOTE FACILITY^MP9999999.06'^AUTTLOC(^0;1^Q
	;;^DD(9000011.11,.01,1,0)
	;;=^.1
	;;^DD(9000011.11,.01,1,1,0)
	;;=9000011.11^B
	;;^DD(9000011.11,.01,1,1,1)
	;;=S ^AUPNPROB(DA(1),11,"B",$E(X,1,30),DA)=""
	;;^DD(9000011.11,.01,1,1,2)
	;;=K ^AUPNPROB(DA(1),11,"B",$E(X,1,30),DA)
	;;^DD(9000011.11,.01,3)
	;;=Enter the location at which these notes originated.
