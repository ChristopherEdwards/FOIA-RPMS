IBERS2	;ALB/ARH - APPOINTMENT CHECK-OFF SHEET GENERATOR (CONTINUED) ; 12/6/91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;gather the data for an individual patient appointment check-off sheet (all data needed is passed in, in IBLN)
	S IBLC=0,IBDT=$P(IBLN,"^",9),DFN=$P(IBLN,"^",1) D ELIG^VADPT
	S IBX="AMBULATORY SURGERY CHECK-OFF SHEET",IBW=1 D LINE S IBX="" D ENDLN
PAT	;name,clinic,appointment date/time
	S IBX="   Patient Name: "_$P(IBLN,"^",3),IBY=$J("",15)_"Clinic: "_$P(IBLN,"^",5),IBW=2 D LINE
	S IBX="     Patient Id: "_$P(IBLN,"^",8),IBY="Appointment Date/Time: "_$P(IBLN,"^",4),IBW=2 D LINE
	S IBX="",IBY="     Appointment Type: "_$P(IBLN,"^",7),IBW=2 D LINE
	S IBX=IBDSH D ENDLN
	;
MT	;means test, date of last means test, primary eligibility
	S Y=$$LST^DGMTU(DFN,IBDT)
	S IBX="     Means Test: "_$P(Y,"^",3),IBY="  Primary Eligibility: "_$P(VAEL(1),"^",2),IBW=2 D LINE
	S Y=$P(Y,"^",2) X ^DD("DD")
	S IBX="Last Means Test: "_Y,IBY="    Service Connected: "_$S(+VAEL(3):$P(VAEL(3),"^",2)_"%",1:"NO"),IBW=2 D LINE
	S IBX=IBDSH D ENDLN
	;
	;find active insurance companies and SC disabilities
INS	S IBCOND=0,IBINDT=IBDT,IBOUTP=1 D ^IBCNS
	S IBX="      Insurance: " I 'IBINS S IBINS(1)=IBX_"None Active" G SC
	S ^TMP("IBRSP",$J,1)=$E(^TMP("IBRSP",$J,1),1,(IOM-4))_$J("INS",(IOM-4-$L(^TMP("IBRSP",$J,1))))
	;S $E(^TMP("IBRSP",$J,1),(IOM-3),IOM)="INS"
	I $D(IBDD) S IBNS="",IBI=1 F  S IBNS=$O(IBDD(IBNS)) Q:IBNS=""  D
	. S IBLX=$G(IBINS(IBI)),IBCMP=$P($G(^DIC(36,+IBNS,0)),"^",1)
	. I IBLX="" S IBINS(IBI)=IBX_IBCMP,IBX=$J("",17) Q
	. I IB2>($L(IBLX)+$L(IBCMP)+2) S IBINS(IBI)=IBLX_", "_IBCMP Q
	. S IBI=IBI+1 S IBINS(IBI)=IBX_IBCMP,IBX=$J("",17)
SC	G:'+VAEL(3)&('$D(^DPT(DFN,.372))) ENDINSC
	S IBX="      SC Disabilities: "
	I 'VAEL(4),$S($P($G(^DG(391,+VAEL(6),0)),"^",2):0,1:1) S IBSCD(1)=IBX_"Not A Veteran" G ENDINSC
	I '$D(^DPT(DFN,.372)) S IBSCD(1)=IBX_"No SC Disabilities Listed" G ENDINSC
	I '$O(^DPT(DFN,.372,0)) S IBSCD(1)=IBX_"None Stated" G ENDINSC
	S (IBCOND,IBSC)=0 F  S IBSC=$O(^DPT(DFN,.372,IBSC)) Q:IBSC=""  D
	. S IBDIS=$G(^DPT(DFN,.372,IBSC,0)) Q:'$P(IBDIS,"^",3)  S IBDISC=$G(^DIC(31,+IBDIS,0)),IBCOND=IBCOND+1
	. S IBSCD(IBCOND)=IBX_IBCOND_" "_$E($S($P(IBDISC,"^",4)'="":$P(IBDISC,"^",4),1:$P(IBDISC,"^",1)),1,(IB2-$S(IBCOND>9:31,1:30)))_$J($P(IBDIS,"^",2),4)_"%"
	. S IBX=$J("",23)
	I 'IBCOND S IBSCD(1)=IBX_"None"
ENDINSC	;print the INS and SC arrays on the same lines
	F IBI=1:1 Q:'$D(IBINS(IBI))&'$D(IBSCD(IBI))  S IBX=$G(IBINS(IBI)),IBY=$G(IBSCD(IBI)),IBW=2 D LINE
	S IBX=IBDSH D ENDLN
	K IBLX,IBCMP,IBINS,IBSCD,IBNS,IBDIS,IBDISC,IBSC,IBI,IBINDT,IBINS,IBOUTP,IBDD,VAEL,VAERR
	;
DX	;print discharge and billing dx's for last 6 appointments
	;D ^IBERS3
	;
CHECKS	;print space for checks
	S IBZ=IB3\2,IBX=$J("EKG  (  )",IBZ+5),IBY=$J("LAB  (  )",IBZ+5),IBZ=$J("X-RAY  (  )",IBZ+6),IBW=3 D LINE
	S IBX=IBDSH D ENDLN
	;
END	;end of sheet, Last section on patient printed on RS: new dx's, signature
	I IBCOND S IBX=$J("",IB1)_"Visit for SC condition: 1" F IBI=2:1:IBCOND S IBX=IBX_", "_IBI
	D:IBCOND ENDLN
	S IBX="Diagnosis: ",IBY="Signature: ",IBW=2 D LINE
	S IBX=IBDSH D ENDLN S IBX="" D ENDLN
	;
EXIT	K IBDT,IBLC,IBI,IBX,IBY,IBZ,IBW,IBCOND,DFN,X,Y
	Q
	;
LINE	;prints 1 (IBW=1) 2 (IBW=2) or three (IBW=3) pieces of data on a formated line
	;(IBX, IBY, IBZ should contain the 1st, 2nd, and 3rd piece of data, respectively)
	;use IBW=1 for headers centered on the page: IBX=header text
	;entry at lable ENDLN can be used to insert a line with no additional frmating
	I IBW=1 S IBT=IB1+(IB2-($L(IBX)/2)),IBX=$J("",IBT)_IBX G ENDLN
	S IBL=$S(IBW=2:IB2,1:IB3),IBT=IB4
	S IBX=$E(IBX,1,IBL),IBX=$J("",IB1)_IBX_$J("",(IBL-$L(IBX)))
	S IBY=$E(IBY,1,IBL),IBX=IBX_$J("",IBT)_IBY_$J("",(IBL-$L(IBY)))
	I IBW=3 S IBZ=$E(IBZ,1,IBL),IBX=IBX_$J("",IBT)_IBZ_$J("",(IBL-$L(IBZ)))
ENDLN	S IBLC=IBLC+1,^TMP("IBRSP",$J,IBLC)=IBX
	K IBT,IBL
	Q
