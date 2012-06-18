IBTOSUM	;ALB/AAS - CLAIMS TRACKING BILLING INFORMATION PRINT ; 29-OCT-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
%	I '$D(DT) D DT^DICRW
	W !!,"MCCR/UR Summary Report",!!
	S IBQUIT=0
	;
	; -- print either by admissions or discharges
SORT	; -- ask how they want it sorted
	N DIR
	S DIR(0)="SOBA^A:Admissions;D:Discharges"
	S DIR("A")="Print Report By [A]dmissions  [D]ischarges: "
	S DIR("B")="D"
	S DIR("?",1)="This summary report may be prepared by either Admissions or Discharges."
	S DIR("?",2)="If you choose by discharge the report will contain information on all"
	S DIR("?",3)="claims tracking information for the discharges that fall in the date"
	S DIR("?",4)="Range.  That is, all reviews for discharges found in the date range"
	S DIR("?",5)="will be included in the report.  If you choose by Admissions all"
	S DIR("?",6)="reviews found in the date range will be included but the reviews"
	S DIR("?",7)="may be for cases not related to the admissions."
	S DIR("?",8)="  "
	S DIR("?")="If you want to know the total reviews done during a date range sort by admissions.  If you want to know the total reviews done on the discharges for a date range sort by Discharges"
	D ^DIR K DIR
	S IBSORT=Y I "AD"'[Y!($D(DIRUT)) G END
	;
	; -- get date range
	W ! D DATE^IBOUTL
	I IBBDT=""!(IBEDT="") G END
	;
DEV	; -- select device, run option
	W ! S %ZIS="QM" D ^%ZIS G:POP END
	I $D(IO("Q")) S ZTRTN="RPT^IBTOSUM",ZTSAVE("IB*")="",ZTDESC="IB - MCCR/UR Summary Report" D ^%ZTLOAD K IO("Q"),ZTSK D HOME^%ZIS G END
	U IO
	;
RPT	; -- entry point from task man
	;    store data in ^tmp($j,"IBTOSUM",N)
	K ^TMP($J)
	S IBQUIT=0,IBPAG=0,Y=DT D D^DIQ S IBHDT=Y
	F I=0:1:13 S IBCNT(I)=0
	F I=20,21,80,81,82,99 S IBCNT(I)=0
	F I=0:1:4 S IBCNT(30+I)=0
	I IBSORT="A" D ADM
	I IBSORT="D" D DIS
	D CHK^IBTOSUM2
	I $G(ZTSTOP) G END
	;
	D PRINT^IBTOSUM2
	;
END	; -- Clean up
	W !
	I $D(IBCNT(1)),$E(IOST,1,2)="C-" D PAUSE^VALM1
	K ^TMP($J)
	I $D(ZTQUEUED) S ZTREQ="@" Q
	D ^%ZISC
	K X,X1,X2,X3,Y,%ZIS,POP,DA,DIRUT,DUOUT,IBRATE,IBBBS,IBSORT,IBC,IBPCNT,IBDCNT,IBMAX,IBCDT
	K IBDT,IBBDT,IBEDT,IBQUIT,IBPAG,IBHDT,IBCNT,IBSPEC,IBINS,IBAC,IBPEN,IBPEND,IBTRN,IBTRND,IBTRC,IBTRCD,DFN,DGPM,IBNOD,IBDAY,IBFAC,IBSITE,IBSNM,X,Y,I,J
	Q
	;
ADM	; -- count admission
	D CHK^IBTOSUM2 I $G(ZTSTOP) Q
	S IBDT=IBBDT-.000000001
	F  S IBDT=$O(^DGPM("AMV1",IBDT)) Q:'IBDT!(IBDT>(IBEDT+.24))  D
	.S DFN=0 F  S DFN=$O(^DGPM("AMV1",IBDT,DFN)) Q:'DFN  D
	..S DA=0 F  S DA=$O(^DGPM("AMV1",IBDT,DFN,DA)) Q:'DA  D PROC
	..Q
	.Q
	Q
	;
DIS	; -- count discharges
	D CHK^IBTOSUM2 I $G(ZTSTOP) Q
	S IBDT=IBBDT-.000000001
	F  S IBDT=$O(^DGPM("AMV3",IBDT)) Q:'IBDT!(IBDT>(IBEDT+.24))  D
	.S DFN=0 F  S DFN=$O(^DGPM("AMV3",IBDT,DFN)) Q:'DFN  D
	..S DA=0 F  S DA=$O(^DGPM("AMV3",IBDT,DFN,DA)) Q:'DA  D PROC
	..Q
	.Q
	Q
	;
PROC	; -- Process each admission or discharge
	S DGPM=$P($G(^DGPM(DA,0)),"^",14)
	S IBCNT(1)=IBCNT(1)+1 ; count of admsisions or discharges
	S IBTRN=$O(^IBT(356,"AD",DGPM,0))
	Q:'IBTRN
	;
	S IBTRND=$G(^IBT(356,+IBTRN,0)) ;W !,IBTRND
	Q:'$P(IBTRND,"^",20)  ; must be an active visit
	;
	Q:'$$INSURED^IBCNS1(DFN,IBDT)  ; must be insured for visit to count
	;
	S IBCNT(2)=IBCNT(2)+1 ; count of insured admissions or discharges discharges
	;
	S IBCNT(3,+$P(IBTRND,"^",19))=$G(IBCNT(3,+$P(IBTRND,"^",19)))+1 ;count of billable
	;
	S X=$P($G(^IBT(356,+IBTRN,1)),"^",7) I X>3 S IBCNT(4)=IBCNT(4)+1
	I X="",$P(IBTRND,"^",24),'$P(IBTRND,"^",19) S IBCNT(4)=IBCNT(4)+1 ;reviews required
	;
	I $$APPEAL(IBTRN) S IBCNT(80)=IBCNT(80)+1
	;
	K IBDCNT,IBPCNT
	S IBTRC=0 F  S IBTRC=$O(^IBT(356.2,"C",IBTRN,IBTRC)) Q:'IBTRC  D RCNT^IBTOSUM1
	S:$D(IBPCNT(IBTRN)) IBCNT(99)=IBCNT(99)+1
	S:$O(IBPCNT(IBTRN,+$O(IBPCNT(IBTRN,0)))) IBCNT(13)=IBCNT(13)+1 ;more than one policy per case
	Q
	;
APPEAL(IBTRN)	; -- was this case appealed:
	;
	N A,X
	S A=0
	I 'IBTRN G APPEALQ
	S X=$O(^IBE(356.11,"ACODE",60,0)) ; initial appeal
	I $O(^IBT(356.2,"ATRTP",IBTRN,X,0)) S A=1 G APPEALQ
	S X=$O(^IBE(356.11,"ACODE",65,0)) ; subsequent appeal
	I $O(^IBT(356.2,"ATRTP",IBTRN,X,0)) S A=1 G APPEALQ
APPEALQ	Q A
