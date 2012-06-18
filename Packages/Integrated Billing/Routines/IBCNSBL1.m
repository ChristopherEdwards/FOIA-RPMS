IBCNSBL1	;ALB/AAS - NEW INSURANCE POLICY BULLETIN ; 29-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
BULL	; -- send bulletin
	;
	S XMSUB="New Insurance Policy For "_$E($P(IBP,"^"),1,20)_"   Pt. Id: "_$P(IBP,"^",2)
	S IBT(1)=" A new insurance policy has been added for:"
	S IBT(2)=" Patient: "_$E($P(IBP,"^")_"               ",1,25)_"  PT. ID: "_$P(IBP,"^",2)
	S IBT(3)=""
	S IBT(4)=" New Policy: "
	S IBCNT=4 D HDR,NPOL
	S IBCNT=IBCNT+1,IBT(IBCNT)=""
	S IBCNT=IBCNT+1,IBT(IBCNT)=" Previous Policy(s): "
	D HDR,OPOL
	S IBCNT=IBCNT+1,IBT(IBCNT)=""
	S IBCNT=IBCNT+1,IBT(IBCNT)=" Possible billable Inpt. Care: "
	D INPT
	S IBCNT=IBCNT+1,IBT(IBCNT)=""
	S IBCNT=IBCNT+1,IBT(IBCNT)=" Possible billable Opt. Care: "
	D OPT
	S IBCNT=IBCNT+1,IBT(IBCNT)=""
	S IBCNT=IBCNT+1,IBT(IBCNT)=" Added by: "_$P($G(^VA(200,+$P(IBEVT1,"^",2),0)),"^")
	S IBCNT=IBCNT+1,IBT(IBCNT)="       on: "_$$DAT1^IBOUTL(+IBEVT1,"2P")
	S IBCNT=IBCNT+1,IBT(IBCNT)="   Option: "
	I $D(XQY0) S IBT(IBCNT)=IBT(IBCNT)_$P($G(XQY0),"^",2)
	I $D(ZTQUEUED),$P($G(XQY0),"^",2)="" S IBT(IBCNT)=IBT(IBCNT)_"Queued Job - "_$G(ZTDESC)
	D SEND
BULLQ	Q
	;
NPOL	; -- set up new policy
	S IBCNT=IBCNT+1
	S IBT(IBCNT)=$$D1(IBEVTA)
	Q
	;
OPOL	; -- set up old policies
	N J,X,IBPCNT
	S J=0 F  S J=$O(^DPT(DFN,.312,J)) Q:'J  I J'=IBCDFN S X=$G(^DPT(DFN,.312,J,0)) S IBCNT=IBCNT+1,IBT(IBCNT)=$$D1(X) S IBPCNT=$G(IBPCNT)+1
	I $G(IBPCNT)<1 S IBCNT=IBCNT+1,IBT(IBCNT)="    No Previous Policies On file!"
	Q
	;
SEND	S XMDUZ="INTEGRATED BILLING PACKAGE",XMTEXT="IBT("
	K XMY S XMN=0
	S IBGRP=$P($G(^XMB(3.8,+$P($G(^IBE(350.9,1,4)),"^",4),0)),"^")
	I IBGRP]"" S XMY("G."_IBGRP_"@"_^XMB("NETNAME"))=""
	D ^XMD
	K X,Y,IBI,IBT,IBGRP,XMDUZ,XMTEXT,XMY,XMSUB
	Q
	;
HDR	; -- print standard header
	D HDR1("=",76)
	Q
	;
HDR1(CHAR,LENG)	; -- print header, specify character
	S IBCNT=IBCNT+1
	S IBT(IBCNT)="    Insurance Co.     Subscriber ID     Group       Holder  Effective Expires"
	S IBCNT=IBCNT+1,X="",$P(X,CHAR,LENG)=""
	S IBT(IBCNT)=X
	Q
	;
	;
D1(IBINS)	N X,IBX
	S IBX="" I '$G(IBINS) G DQ
	S IBX="    "_$E($S($D(^DIC(36,+IBINS,0)):$E($P(^(0),"^",1),1,16),1:"UNKNOWN")_"                 ",1,16)_"  "
	S IBX=IBX_$E($P(IBINS,"^",2)_"                ",1,16)_"  "
	S IBX=IBX_$E($$GRP^IBCNS($P(IBINS,"^",18))_"          ",1,10)_"  "
	S X=$P(IBINS,"^",6) S IBX=IBX_$E($S(X="v":"SELF",X="s":"SPOUSE",1:"OTHER")_"      ",1,8)
	S IBX=IBX_$E($$DAT1^IBOUTL($P(IBINS,"^",8))_"          ",1,10)_$$DAT1^IBOUTL($P(IBINS,"^",4))
DQ	Q IBX
	;
OPT	; -- list opt treatment (sched appoints only)
	N CNT S CNT=0
	S OPT=START
	F  S OPT=$O(^DPT(DFN,"S",OPT)) Q:'OPT!(OPT>END)  D
	.S IBCNT=IBCNT+1
	.Q:$P(^DPT(DFN,"S",OPT,0),"^",2)]""  ; can't be canceled, inpatient, etc
	.S IBT(IBCNT)="   Outpatient Visit on "_$$DAT1^IBOUTL(OPT,"2P")_" to "_$P($G(^SC(+$G(^DPT(DFN,"S",OPT,0)),0)),"^")
	.S CNT=CNT+1
	I 'CNT S IBCNT=IBCNT+1,IBT(IBCNT)="    No Scheduled appointments found."
	Q
	;
INPT	; -- list inpt. treatment (admissions only)
	N CNT S CNT=0
	I $G(^DPT(DFN,.1))]"" S CNT=CNT+1,IBCNT=IBCNT+1,IBT(IBCNT)="    Currently an Inpatient on "_$G(^DPT(DFN,.1))
	I $G(IBTADD) S IBCNT=IBCNT+1,IBT(IBCNT)="    Entry Added to Claims Tracking for Current Admission."
	I $G(VAIN(1)) S CNT=CNT+1,IBCNT=IBCNT+1,IBT(IBCNT)="    Previously an inpatient on ward "_$P(VAIN(4),"^",2)_" on "_$$DAT1^IBOUTL($P(START,"."))
	S INPT=START F  S INPT=$O(^DGPM("APTT1",DFN,INPT)) Q:'INPT!(INPT>END)  S DGPM=0 F  S DGPM=$O(^DGPM("APTT1",DFN,INPT,DGPM)) Q:'DGPM  D
	.Q:'$G(^DGPM(DGPM,0))
	.S IBCNT=IBCNT+1
	.S IBT(IBCNT)="    Inpatient Admission on "_$$DAT1^IBOUTL(+^DGPM(DGPM,0),"2P")
	.S CNT=CNT+1
	I 'CNT S IBCNT=IBCNT+1,IBT(IBCNT)="    No Admissions found."
	Q
