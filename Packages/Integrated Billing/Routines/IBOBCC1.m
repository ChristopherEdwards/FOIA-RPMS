IBOBCC1	;ALB/ARH - UNBILLED APPOINTMENT BASC FOR INSURED PATIENTS ; 2/27/92
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
PRINT	;set up headers and dates then print
	G:IBQ END
	D NOW^%DTC S Y=$E(%,1,12) D DD^%DT S IBCDT=$P(Y,"@",1)_"  "_$P(Y,"@",2)
	S Y=IBBDT X ^DD("DD") S IBBDTE=Y,Y=IBEDT X ^DD("DD") S IBEDTE=Y
	S (IBPGN,IBLN)=0,IBDSH="" F IBI=1:1:IOM S IBDSH=IBDSH_"-"
	D HDR,P1
END	K IBCDT,IBBDTE,IBEDTE,IBPGN,IBQ,IBLN,IBI,IBDSH,Y
	I $D(ZTQUEUED) S ZTREQ="@"
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOBCC" D T1^%ZOSV ;stop rt clock
	Q
	;
P1	;print the report from the temp sort file to the appropriate device
	I $D(^TMP("IBBC",$J)) S IBPNM="" F  S IBPNM=$O(^TMP("IBBC",$J,"N",IBPNM)) Q:IBPNM=""!(IBQ)  S IBDFN="" D
	. F  S IBDFN=$O(^TMP("IBBC",$J,"N",IBPNM,IBDFN)) Q:IBDFN=""!(IBQ)  W ! S IBLN=IBLN+1 D
	.. S IBPAT=$$PT^IBEFUNC(IBDFN) Q:IBPAT=""  S IBAD="" F  S IBAD=$O(^TMP("IBBC",$J,IBDFN,IBAD)) Q:IBAD=""!(IBQ)  D
	... D:(IBLN+2)>IOSL HDR S Y=IBAD X ^DD("DD") S IBADE=Y W ?3,$P(IBPAT,"^",1),?35,$P(IBPAT,"^",2),?52,IBADE S IBCPT=""
	... F  S IBCPT=$O(^TMP("IBBC",$J,IBDFN,IBAD,IBCPT)) Q:IBCPT=""!(IBQ)  S IBN=^(IBCPT) F IBI=1:1:IBN D  Q:IBQ
	.... I (IBLN+2)>IOSL D HDR W ?3,$P(IBPAT,"^",1),?35,$P(IBPAT,"^",2),?52,IBADE
	.... W ?68,$P($G(^ICPT(+IBCPT,0)),"^",1),"  ",$P(^(0),"^",2),! S IBLN=IBLN+1
	D:'IBQ PAUSE
	K IBPNM,IBDFN,IBCPT,IBAD,IBADE,IBN,IBI,IBPAT,X,Y,^TMP("IBBC",$J)
	Q
	;
HDR	;print the report header, allow user stops, for terminals only form feed on first page
	S IBQ=$$STOP Q:IBQ  D:IBPGN>0 PAUSE Q:IBQ  I IBPGN>0!($E(IOST,1,2)["C-") W @IOF
	S IBPGN=IBPGN+1,IBLN=5 W IBHDR," FOR ",IBBDTE," - ",IBEDTE I IOM<85 W !
	W ?(IOM-30),IBCDT,?(IOM-8),"PAGE ",IBPGN,!
	W !,?3,"PATIENT NAME",?35,"PATIENT ID",?50,"APPOINTMENT DATE",?68,"BILLABLE AMBULATORY PROCEDURE",! W IBDSH,!
	Q
	;
PAUSE	;pause at end of screen if being displayed on a terminal
	Q:$E(IOST,1,2)'["C-"
	S DIR(0)="E" D ^DIR K DIR I $D(DUOUT)!($D(DIRUT)) S IBQ=1
	Q
	;
STOP()	;determine if user requested task to be stopped
	I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1 K ZTREQ I +$G(IBPGN) W !!,"TASK STOPPED BY USER",!!
	Q +$G(ZTSTOP)
