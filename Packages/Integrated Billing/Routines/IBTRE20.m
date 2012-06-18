IBTRE20	;ALB/AAS - CLAIMS TRACKING EXECUTABLE HELP ; 13-OCT-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
LISTA	; -- list inpatient admissions for patient
	N C,I,J,N,X,Y,IBX
	K ^TMP("IBM",$J)
	Q:'$D(DFN)
	S C=0 F I=0:0 S I=$O(^DGPM("ATID1",DFN,I)) Q:'I  S N=$O(^(I,0)) I $D(^DGPM(+N,0)) S D=^(0),C=C+1,^TMP("IBM",$J,C)=N_"^"_D
	;
	I C=0 W !!,"No Admissions to Choose From." Q
	;
	W !!,"CHOOSE FROM:" F IBI=1:1:10 Q:'$D(^TMP("IBM",$J,IBI))  D WRA
	K ^TMP("IBM",$J)
	Q
	;
WRA	S IBX=$P(^TMP("IBM",$J,IBI),"^",2,20),Y=+IBX X ^DD("DD")
	W !,"     ",Y
	W ?27,$S('$D(^DG(405.1,+$P(IBX,"^",4),0)):"",$P(^(0),"^",7)]"":$P(^(0),"^",7),1:$E($P(^(0),"^",1),1,20))
	;
	W ?50,"TO:  ",$E($P($G(^DIC(42,+$P(IBX,"^",6),0)),"^"),1,17)
	I $D(^DG(405.4,+$P(IBX,"^",7),0)) W " [",$E($P(^(0),"^",1),1,10),"]"
	I $P(IBX,"^",18)=9 W !?23,"FROM:  ",$P($G(^DIC(4,+$P(IBX,"^",5),0)),"^")
	Q
	;
LISTO	; -- list outpatient appointments
	N C,I,J,N,X,Y,IBX,IBI
	K ^TMP("IBM",$J)
	Q:'$D(DFN)
	S C=0 S I=$G(IBTBDT) F  S I=$O(^DPT(DFN,"S",I)) Q:'I!(I>(IBTEDT+.24))  I $D(^DPT(DFN,"S",I,0)) S D=^(0),C=C+1,^TMP("IBM",$J,C)=I_"^"_D
	;
	I C=0 W !!,"No Outpatient Visits to Choose From." Q
	;
	W !!,"CHOOSE FROM:" F IBI=1:1:12 Q:'$D(^TMP("IBM",$J,IBI))  D WRO
	K ^TMP("IBM",$J)
	Q
	;
WRO	S IBX=$G(^TMP("IBM",$J,IBI)),Y=+IBX,IBX=$P(IBX,"^",2,99) X ^DD("DD")
	W !,"     ",Y
	W ?27,"Clinic: ",$P($G(^SC(+IBX,0)),"^"),?60," Type: ",$E($P($G(^SD(409.1,+$P(IBX,"^",16),0)),"^"),1,12)
	;
	I $P(IBX,"^",2)]"" W !,?10," [Status: ",$$EXPAND^IBTRE(2.98,3,$P(IBX,"^",2)),"]"
	Q
LISTS	; -- list scheduled admissions
	N C,I,J,N,X,Y,IBX,IBI
	K ^TMP("IBM",$J)
	Q:'$D(DFN)
	S C=0 F I=0:0 S I=$O(^DGS(41.1,"B",DFN,I)) Q:'I  I $D(^DGS(41.1,+I,0)) S D=$G(^DGS(41.1,+I,0)) I $P(D,"^",2)'<IBTBDT,$P(D,"^",2)'>IBTEDT S C=C+1,^TMP("IBM",$J,C)=I_"^"_D
	;
	I C=0 W !!,"No Scheduled Admissions to Choose From." Q
	;
	W !!,"CHOOSE FROM:" F IBI=1:1:12 Q:'$D(^TMP("IBM",$J,IBI))  D WRS
	K ^TMP("IBM",$J)
	Q
	;
WRS	S IBX=$P($G(^TMP("IBM",$J,IBI)),"^",2,20),Y=$P(IBX,"^",2) X ^DD("DD")
	W !,"     ",Y
	W ?27," Spec: ",$E($P($G(^DIC(45.7,+$P(IBX,"^",9),0)),"^"),1,25)
	;
	W ?58," To: ",$E($P($G(^DIC(42,+$P(IBX,"^",8),0)),"^"),1,16)
	Q
	;
FINDS	; -- match a scheduled admission
	Q:'$D(DFN)
	Q:'$D(IBTDT)
	N I,J
	S I=0 F  S I=$O(^DGS(41.1,"B",DFN,I)) Q:'I  S J=$P($G(^DGS(41.1,I,0)),"^",2) Q:IBTDT=J  I $P(IBTDT,".")=$P(J,".") S IBTDT=J Q
	Q
	;
ID	; -- write out identifier for entry, called by ^dd(356,0,"id","write")
	N IBOE
	S IBOE=$P(^(0),"^",4) I IBOE,$P($G(^SCE(+IBOE,0)),"^",4) W ?58,"["_$E($P($G(^SC(+$P($G(^SCE(+IBOE,0)),"^",4),0)),"^"),1,20),"]"
	Q
