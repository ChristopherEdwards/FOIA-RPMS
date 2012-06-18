IBTODD	;ALB/AAS - CLAIMS TRACKING DENIED DAYS REPORT ; 27-OCT-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
%	I '$D(DT) D DT^DICRW
	W !!,"Denied Days Report",!!
	;
	S IBSORT="P"
	N DIR
	S DIR("?")="Answer YES if you only want to print a summary or answer NO if you want a detailed listing plus the summary."
	S DIR(0)="Y",DIR("A")="Print Summary Only",DIR("B")="YES" D ^DIR K DIR
	I $D(DIRUT) G END
	S IBSUM=Y
	G:IBSUM DATE
	;
SORT	; -- ask how they want it sorted
	W !!
	S DIR(0)="SOBA^P:PATIENT;A:ATTENDING;S:SERVICE"
	S DIR("A")="Print Report By [P]atient  [A]ttending  [S]ervice: "
	S DIR("B")="P"
	S DIR("?",1)="This report may be prepared by either Patient, Attending, or Service."
	S DIR("?",2)=""
	S DIR("?",3)=""
	S DIR("?",4)=""
	S DIR("?",5)=""
	S DIR("?",6)=""
	S DIR("?",7)=""
	S DIR("?",8)="  "
	S DIR("?")=""
	D ^DIR K DIR
	S IBSORT=Y I "PAS"'[Y!($D(DIRUT)) G END
	;
DATE	; -- select date range
	W ! D DATE^IBOUTL
	I IBBDT=""!(IBEDT="") G END
	;
DEV	; -- select device, run option
	W !
	I 'IBSUM W !!,"You will need a 132 column printer for this report!",!
	S %ZIS="QM" D ^%ZIS G:POP END
	I $D(IO("Q")) S ZTRTN="DQ^IBTODD",ZTSAVE("IB*")="",ZTDESC="IB - Denied Days Report" D ^%ZTLOAD K IO("Q"),ZTSK D HOME^%ZIS G END
	;
	U IO
	D DQ G END
	Q
	;
END	; -- Clean up
	W ! K ^TMP($J,"IBTODD")
	I $D(ZTQUEUED) S ZTREQ="@" Q
	D ^%ZISC
	K I,J,X,X2,Y,DFN,%ZIS,DGPM,VA,IBI,IBJ,IBTRN,IBTRND,IBTRND1,IBPAG,IBHDT,IBDISDT,IBETYP,IBQUIT,IBTAG,IBTRC,IBTRCD,IBDEN,IBDAY,IBTALL,IBADM,IBDISCH,IBMAX
	K IBAPL,IBBBS,IBBDT,IBC,IBCDT,IBCNT,IBDT,IBD,IBDATA,IBEDT,IBNAM,IBPRIM,IBPROV,IBRATE,IBSECN,IBSERV,IBSORT,IBSPEC,IBSUM,IBSUBT,IBTOTL
	D KVAR^VADPT
	Q
DQ	; -- entry print from taskman
	K ^TMP($J,"IBTODD")
	S X=132 X ^%ZOSF("RM")
	S IBPAG=0,IBHDT=$$HTE^XLFDT($H,1),IBQUIT=0
	S IBDEN=$O(^IBE(356.7,"ACODE",20,0))
	D BLD,PRINT^IBTODD1
	I $D(ZTQUEUED) G END
	Q
	;
BLD	; -- sort through data and build array to print from
	;
	S IBTRC=0
	F  S IBTRC=$O(^IBT(356.2,"ACT",IBDEN,IBTRC)) Q:'IBTRC  D
	.N IBTRN,IBTRND,IBTRCD,DFN
	.S IBTRCD=$G(^IBT(356.2,+IBTRC,0))
	.S IBTALL=$P($G(^IBT(356.2,+IBTRC,1)),"^",7)
	.I +IBTRCD<IBBDT!(+IBTRCD>(IBEDT+.9)) Q
	.S IBTRN=$P(IBTRCD,"^",2),IBTRND=$G(^IBT(356,+IBTRN,0))
	.I $P($G(^IBE(356.6,+$P(IBTRND,"^",18),0)),"^",3)'=1 Q  ; not an admission type event
	.S DFN=$P(IBTRCD,"^",5),IBNAM=$P($G(^DPT(+DFN,0)),"^") Q:IBNAM=""
	.S IBD=$$PROV(IBTRC),IBPROV=+IBD,IBSPEC=$P(IBD,"^",2),IBSERV=$P(IBD,"^",3)
	.S IBBBS=$$BBS^IBTOSUM1($P(IBD,"^",2))
	.S IBRATE=$$RATE^IBTOSUM1(IBBBS,+IBTRCD)
	.S IBMAX=$$DAY^IBTUTL3(IBBDT,IBEDT)+1
	.S IBCDT=$$CDT^IBTODD1(IBTRN)
	.I 'IBTALL S IBDAY=$$DAY^IBTUTL3(+$P(IBTRCD,"^",15),+$P(IBTRCD,"^",16),IBTRN)
	.I IBTALL S IBDAY=$$DAY^IBTUTL3(+IBCDT,$S($P(IBCDT,"^",2):$P(IBCDT,"^",2),1:DT),IBTRN)
	.I IBDAY>IBMAX S IBDAY=IBMAX
	.D SET
	Q
	;
SET	; -- set array to print from
	; -- ^tmp($j,"ibtodd",primary sort,secondary sort,ibtrc)=DFN ^ attending ^ treating specialty ^ service ^ billing bed section ^ billing rate^ no. days denied
	S IBPRIM=$S(IBSORT="P":IBNAM,IBSORT="A":IBPROV,1:IBSERV)
	S IBSECN=$S(IBSORT="P":IBPROV,1:IBNAM)
	S:IBPRIM="" IBPRIM="UNKNOWN" S:IBSECN="" IBSECN="UNKNOWN"
	S ^TMP($J,"IBTODD",IBPRIM,IBSECN,IBTRC)=DFN_"^"_IBPROV_"^"_IBSPEC_"^"_IBSERV_"^"_IBBBS_"^"_IBRATE_"^"_IBDAY
	Q
	;
PROV(IBTRC)	; -- find attending for an inpt. stay
	N I,J,X,Y,DFN,DGPM,VA200,VAIN,VAERR
	;
	S VA200="",VAINDT=+$G(^IBT(356.2,+IBTRC,0)),DFN=$P($G(^(0)),"^",5) D INP^VADPT
	I VAIN(1)="" S VAINDT=+$G(^DGPM(+$P($G(^IBT(356,+$P($G(^IBT(356.2,+IBTRC,0)),"^",2),0)),"^",5),0)) S VAINDT=$P(VAINDT,".")+.24 D INP^VADPT
	;
	S X=+VAIN(11)
	S DGPM=$P($G(^IBT(356,+$P($G(^IBT(356.2,+IBTRC,0)),"^",2),0)),"^",5)
	S Y=$G(^IBT(356.94,+$O(^IBT(356.94,"ATP",+DGPM,1,0)),0))
	S:$P(Y,"^",3) X=$P(Y,"^",3)
PROVQ	Q X_"^"_+VAIN(3)_"^"_$P($G(^DIC(42.4,+$P($G(^DIC(45.7,+$G(VAIN(3)),0)),"^",2),0)),"^",3)
	;
	Q
	;
SUBH(Z)	; -- write sub header for report
	;    input z = subheader data
	;    requires ibsort = how report is sorted
	N X S X=""
	Q:IBSORT="P"  ; no sub header if sorting by patient
	I IBSORT="S" S X="Service: "_$$EXPAND^IBTRE(42.4,3,IBI)
	I IBSORT="A" S X="Attending: "_IBI
	I $L(X) W !!?15,X
	Q
	;
SUBT	; -- write out sub totals, initialize variable
	I '$G(IBSUBT) G SUBTQ
	W !?64,"------",!,?64,$J(IBSUBT,6)
SUBTQ	S IBSUBT=0
	Q
