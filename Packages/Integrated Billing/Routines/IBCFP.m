IBCFP	;ALB/ARH - PRINT AUTHORIZED BILLS IN ORDER ; 6-DEC-94
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;
	S IBPAR1=$G(^IBE(350.9,1,1))
	S IBFT=$G(^IBE(353,+$P(IBPAR1,U,26),0)) I $P(IBFT,U,2)="" W !,"Default printer in billing not defined for the "_$P(IBFT,U,1)_", none will print!",!
	I +$P(IBPAR1,U,22),$P($G(^IBE(353,+$$FNT^IBCU3("HCFA 1500"),0)),U,2)="" W !,"Default printer in billing not defined for the HCFA 1500, none will print!",!
	I '$D(^DGCR(399,"AST")) W !,"There are no Authorized but not Printed bills to print!" G END
	;
	S IBS="",IBZ="Z:ZIP;I:INSURANCE COMPANY NAME;P:PATIENT NAME;"
ORDER	S DIR("?")="This option prints all bills with a Status of Authorized in the order requested.  The printed bills may be sorted by: Zip Code, Insurance Company Name, and Patient name."
1	S DIR("A")="First Sort Bills By",DIR(0)="SOB^"_IBZ D ^DIR I $D(DIRUT) G END
	S IBS=IBS_$S(Y="Z":1,Y="I":2,Y="P":3,1:0) S IBX=$P($P(IBZ,Y_":",2),";",1)
	;
	S DIR("?",1)="Enter the field that the bills should be sorted on within "_IBX_".  Press return if the order already entered is sufficient.",DIR("?",2)=""
2	S DIR("A")="Then Sort Bills By",DIR(0)="SOB^"_IBZ D ^DIR I Y'="",$D(DIRUT) G END
	S IBS=IBS_$S(Y="Z":1,Y="I":2,Y="P":3,1:0) G:Y="" BEG S IBY=$P($P(IBZ,Y_":",2),";",1)
	;
	S DIR("?",1)="Enter the field that the bills should be sorted on within "_IBX_" and "_IBY_".  Press return if the order already entered is sufficient."
3	S DIR("A")="Then Sort Bills By",DIR(0)="SOB^"_IBZ D ^DIR K DIR I Y'="",$D(DIRUT) G END
	S IBS=IBS_$S(Y="Z":1,Y="I":2,Y="P":3,1:0)
	;
BEG	S DIR("A")="Begin printing bills",DIR("?")="Enter 'Y'es to begin printing of all authorized bills."
	W ! S DIR(0)="YBO",DIR("??")="^D DISP^IBCF" D ^DIR K DIR I 'Y W "... bills not printed!" G END
	;
	S ZTRTN="QTASK^IBCFP",ZTDESC="BATCH PRINT AUTHORIZED THIRD PARTY BILLS",ZTIO="",ZTSAVE("IBS")="" D ^%ZTLOAD
	I $D(ZTSK) W !," ... queued"
	;
END	K DIR,IBX,IBY,IBZ,IBS,IBPAR1,IBFT,Y,X,DIRUT ; end of interactive part
	Q
	;
QTASK	; first part, sorts authorized bills in to order requested by bill form type then queues off one job for each form type to print the bills
	;
SORT	;sort authorized bills by form type and requested sort order (notice that bill addendums only print for HCFA 1500's)
	S (IBQ,IBIFN)=0 F  S IBIFN=$O(^DGCR(399,"AST",3,IBIFN)) Q:'IBIFN!IBQ  D  I $$STOP S IBQ=1 Q
	. S IBFT=$$FT^IBCU3(IBIFN)
	. S IBX=$G(^DGCR(399,IBIFN,0)),IBPAT=$P($G(^DPT(+$P(IBX,U,2),0)),U,1) Q:$P(IBX,U,13)'=3
	. S IBX=$G(^DGCR(399,IBIFN,"M")),IBZIP=$P(IBX,U,9),IBINS=$P($G(^DIC(36,+IBX,0)),U,1)
	. S IBX=IBZIP_U_IBINS_U_IBPAT,IBS1=$P(IBX,U,$E(IBS,1))_" ",IBS2=$P(IBX,U,$E(IBS,2))_" ",IBS3=$P(IBX,U,$E(IBS,3))_" "
	. S ^TMP("IBCFP"_IBFT,$J,IBS1,IBS2,IBS3,IBIFN)="" Q:$$FTN^IBCU3(IBFT)'["HCFA 1500"
	. S IBFT=$$FNT^IBCU3("BILL ADDENDUM") I +IBFT S ^TMP("IBCFP"_IBFT,$J,IBS1,IBS2,IBS3,IBIFN)=""
	K IBIFN,IBFT,IBX,IBY,IBPAT,IBZIP,IBINS,IBS1,IBS2,IBS3,IBS
	;
QUEUE	; starts a queued job for each form type that an authorized bill was found for
	; first checks that a device has been defined for the form type
	I 'IBQ S IBX="IBCFP" F  S IBX=$O(^TMP(IBX)) Q:(IBX'?1"IBCFP"1N)  Q:($O(^TMP(IBX,0))'=$J)  S IBFT=$E(IBX,6) D
	. S ZTIO=$P($G(^IBE(353,+IBFT,0)),U,2) Q:ZTIO=""  S IBFTP=IBX,IBJ=$J
	. S ZTDTH=$H,ZTSAVE("IBFTP")="",ZTSAVE("IBFT")="",ZTSAVE("IBJ")="",ZTSAVE("^TMP(IBFTP,IBJ,")=""
	. S ZTDESC="BATCH PRINTING "_$$FTN^IBCU3(+IBFT),ZTRTN="QBILL^IBCFP" D ^%ZTLOAD
	K IBX,IBY,IBFTP,IBJ ; end of first queued part
	Q
	;
	;
QBILL	; second queued part, this will print all authorized bills for a specific form type
	; pass in IBFTP="IBCFP"_(form type) and "^TMP(IBFTP,$J)" sorted array of bills
	S (IBQ,IBS1)=0 F  S IBS1=$O(^TMP(IBFTP,IBJ,IBS1)) Q:IBS1=""!IBQ  D
	. S IBS2=0 F  S IBS2=$O(^TMP(IBFTP,IBJ,IBS1,IBS2)) Q:IBS2=""!IBQ  D
	.. S IBS3=0 F  S IBS3=$O(^TMP(IBFTP,IBJ,IBS1,IBS2,IBS3)) Q:IBS3=""!IBQ  D
	... S IBBN=0 F  S IBBN=$O(^TMP(IBFTP,IBJ,IBS1,IBS2,IBS3,IBBN)) Q:IBBN=""  D  I $$STOP S IBQ=1 Q
	.... D ROUT(IBFT,1,IBBN)
	K ^TMP(IBFTP,IBJ),IBJ,IBFT,IBFTP,IBL,IBIFN,IBBN,IBPNT,IBQ ; end of last queued part
	Q
	;
ROUT(IBFT,IBPNT,IBIFN)	; sub procedure so can protect variables with new
	N IBBN,IBS1,IBS2,IBS3,IBQ,IBFTP,IBJ
	I IBFT=1 S DFN=$P($G(^DGCR(399,+IBIFN,0)),U,2) D ENP^IBCF1 W @IOF G RE
	I IBFT=2 D EN^IBCF2 W @IOF G RE
	I $$FTN^IBCU3(+IBFT)="UB-92" D EN^IBCF3 W @IOF G RE
	I $$FTN^IBCU3(+IBFT)="BILL ADDENDUM" I +$$BILLAD^IBCF4(IBIFN) D EN^IBCF4 W @IOF G RE
RE	Q
	;
DATE(X)	Q $E(X,4,5)_"/"_$E(X,6,7)_"/"_$E(X,2,3)
	;
STOP()	;determine if user has requested the queued report to stop
	I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1 K ZTREQ I +$G(IBPGN) W !,"***TASK STOPPED BY USER***"
	Q +$G(ZTSTOP)
