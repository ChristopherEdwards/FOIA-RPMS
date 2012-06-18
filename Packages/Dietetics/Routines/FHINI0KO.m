FHINI0KO	; ; 11-OCT-1995
	;;5.0;Dietetics;;Oct 11, 1995
	Q:'DIFQ(115)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q	Q
	;;^DD(115.021,5,21,0)
	;;=^^1^1^2891121^
	;;^DD(115.021,5,21,1,0)
	;;=This field contains the lab test result.
	;;^DD(115.021,5,"DT")
	;;=2890705
	;;^DD(115.021,6,0)
	;;=DATE PERFORMED^D^^0;7^S %DT="EX" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.021,6,21,0)
	;;=^^1^1^2891121^
	;;^DD(115.021,6,21,1,0)
	;;=This field contains the date the lab test was performed.
	;;^DD(115.021,6,"DT")
	;;=2890705
	;;^DD(115.03,0)
	;;=CONSULTATION SUB-FIELD^NL^11^10
	;;^DD(115.03,0,"ID",1)
	;;=W:$D(^(0)) "   ",$S($D(^FH(119.5,+$P(^(0),U,2),0))#2:$P(^(0),U,1),1:""),@("$E("_DIC_"Y,0),0)")
	;;^DD(115.03,0,"NM","CONSULTATION")
	;;=
	;;^DD(115.03,0,"UP")
	;;=115.01
	;;^DD(115.03,.01,0)
	;;=DATE/TIME ENTERED^RD^^0;1^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.03,.01,1,0)
	;;=^.1
	;;^DD(115.03,.01,1,1,0)
	;;=115^ADR
	;;^DD(115.03,.01,1,1,1)
	;;=S ^FHPT("ADR",$E(X,1,30),DA(2),DA(1),DA)=""
	;;^DD(115.03,.01,1,1,2)
	;;=K ^FHPT("ADR",$E(X,1,30),DA(2),DA(1),DA)
	;;^DD(115.03,.01,3)
	;;=
	;;^DD(115.03,.01,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.03,.01,21,1,0)
	;;=This field contains the date/time the consult request was
	;;^DD(115.03,.01,21,2,0)
	;;=entered.
	;;^DD(115.03,.01,"DT")
	;;=2850512
	;;^DD(115.03,1,0)
	;;=CONSULT REQUEST^RP119.5'^FH(119.5,^0;2^Q
	;;^DD(115.03,1,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.03,1,21,1,0)
	;;=This field contains the specific consult request drawn from
	;;^DD(115.03,1,21,2,0)
	;;=the Dietetic Consults file (119.5).
	;;^DD(115.03,1,"DT")
	;;=2850512
	;;^DD(115.03,2,0)
	;;=COMMENT^F^^0;3^K:$L(X)>80!($L(X)<1) X
	;;^DD(115.03,2,3)
	;;=ANSWER MUST BE 1-80 CHARACTERS IN LENGTH
	;;^DD(115.03,2,21,0)
	;;=^^1^1^2880718^^
	;;^DD(115.03,2,21,1,0)
	;;=This field allows the user to enter a comment as to the consult.
	;;^DD(115.03,2,"DT")
	;;=2850418
	;;^DD(115.03,4,0)
	;;=CLINICIAN^RP200'^VA(200,^0;5^Q
	;;^DD(115.03,4,1,0)
	;;=^.1
	;;^DD(115.03,4,1,1,0)
	;;=115^ADRU^MUMPS
	;;^DD(115.03,4,1,1,1)
	;;=S X9=$P(^FHPT(DA(2),"A",DA(1),"DR",DA,0),U,8) K:X9'="A" ^FHPT("ADRU",X,DA(2),DA(1),DA) S:X9="A" ^FHPT("ADRU",X,DA(2),DA(1),DA)=""
	;;^DD(115.03,4,1,1,2)
	;;=K:X ^FHPT("ADRU",X,DA(2),DA(1),DA)
	;;^DD(115.03,4,1,1,"%D",0)
	;;=^^2^2^2940824^
	;;^DD(115.03,4,1,1,"%D",1,0)
	;;=This is a cross-reference by Clinician of all consultations with
	;;^DD(115.03,4,1,1,"%D",2,0)
	;;=an Active status.
	;;^DD(115.03,4,21,0)
	;;=^^4^4^2880710^
	;;^DD(115.03,4,21,1,0)
	;;=This field indicates the clinician currently assigned to the
	;;^DD(115.03,4,21,2,0)
	;;=consult. Initially, it will contain the clinician assigned
	;;^DD(115.03,4,21,3,0)
	;;=to the consult type, if one has been specified, otherwise, the
	;;^DD(115.03,4,21,4,0)
	;;=clinician assigned to the ward on which the patient resides.
	;;^DD(115.03,4,"DT")
	;;=2850506
	;;^DD(115.03,6,0)
	;;=CLERK^RP200'^VA(200,^0;7^Q
	;;^DD(115.03,6,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.03,6,21,1,0)
	;;=This field contains the user entering the request and is
	;;^DD(115.03,6,21,2,0)
	;;=automatically captured at time of entry.
	;;^DD(115.03,6,"DT")
	;;=2850418
	;;^DD(115.03,7,0)
	;;=STATUS^RS^A:ACTIVE;C:COMPLETE;X:CANCELLED;^0;8^Q
	;;^DD(115.03,7,1,0)
	;;=^.1
	;;^DD(115.03,7,1,1,0)
	;;=115^ADRV^MUMPS
	;;^DD(115.03,7,1,1,1)
	;;=S X9=$P(^FHPT(DA(2),"A",DA(1),"DR",DA,0),U,5) S:X9&(X="A") ^FHPT("ADRU",X9,DA(2),DA(1),DA)="" K:X9&(X'="A") ^FHPT("ADRU",X9,DA(2),DA(1),DA)
	;;^DD(115.03,7,1,1,2)
	;;=S X9=$P(^FHPT(DA(2),"A",DA(1),"DR",DA,0),U,5) K:X9 ^FHPT("ADRU",X9,DA(2),DA(1),DA)
	;;^DD(115.03,7,1,1,"%D",0)
	;;=^^2^2^2940824^^
	;;^DD(115.03,7,1,1,"%D",1,0)
	;;=This is a cross-reference by Clinician (Field 4) of all consults
	;;^DD(115.03,7,1,1,"%D",2,0)
	;;=with an Active status.
	;;^DD(115.03,7,21,0)
	;;=^^1^1^2920611^^
	;;^DD(115.03,7,21,1,0)
	;;=This is the current status of the request.
	;;^DD(115.03,7,"DT")
	;;=2850506
	;;^DD(115.03,8,0)
	;;=DATE/TIME CLEARED^D^^0;9^S %DT="ETXR" D ^%DT S X=Y K:Y<1 X
	;;^DD(115.03,8,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.03,8,21,1,0)
	;;=This is the date/time the consult was cleared, either by
	;;^DD(115.03,8,21,2,0)
	;;=completion or cancellation.
	;;^DD(115.03,8,"DT")
	;;=2850506
	;;^DD(115.03,9,0)
	;;=CLERK CLEARING^P200'^VA(200,^0;10^Q
	;;^DD(115.03,9,21,0)
	;;=^^2^2^2880710^
	;;^DD(115.03,9,21,1,0)
	;;=This is the dietetic person who indicated that the consult
	;;^DD(115.03,9,21,2,0)
	;;=had been cleared.
	;;^DD(115.03,9,"DT")
	;;=2850506
	;;^DD(115.03,10,0)
	;;=INITIAL/FOLLOW-UP^S^I:INITIAL;F:FOLLOW-UP;^0;11^Q
	;;^DD(115.03,10,21,0)
	;;=^^3^3^2880710^
	;;^DD(115.03,10,21,1,0)
	;;=If follow-ups are associated with this consult type, then
	;;^DD(115.03,10,21,2,0)
	;;=this field will indicate whether the consult was an
