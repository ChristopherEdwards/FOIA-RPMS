IBOUNP1	;ALB/CJM - OUTPATIENT INSURANCE REPORT ;JAN 25,1992
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	; VAUTD =1 if all divisions selected
	; VAUTD() - list of selected divisions
	; VAUTC =1 if all clinics selected in selected divisions
	; VAUTC() - list of selected clinics, indexed by record number
	; IBOEND - end of the date range for the report
	; IBOBEG - start of the date range for report
	; IBOQUIT - flag to exit
	; IBOUK =1 if vets whose insurance is unknow should be included
	; IBOUI =1 if vets that are no insured should be included
	; IBOEXP = 1 if vets whose insurance is expiring should be included
MAIN	;
	;***
	;S XRTL=$ZU(0),XRTN="IBOUNP1-1" D T0^%ZOSV ;start rt clock
	;
	S IBOQUIT=0 K ^TMP($J)
	D CLINIC,CATGRY:'IBOQUIT,DRANGE:'IBOQUIT
	D:'IBOQUIT DEVICE
	G:IBOQUIT EXIT
QUEUED	; entry point if queued
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOUNP1" D T1^%ZOSV ;stop rt clock
	;S XRTL=$ZU(0),XRTN="IBOUNP1-2" D T0^%ZOSV ;start rt clock
	;
	D:'IBOQUIT LCLINIC,LOOPCLNC^IBOUNP2,REPORT^IBOUNP3
EXIT	; 
	K ^TMP($J)
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOUNP1" D T1^%ZOSV ;stop rt clock
	;
	I $D(ZTQUEUED) S ZTREQ="@" Q
	D ^%ZISC
	K IBOQUIT,IBOBEG,IBOEND,IBOUK,IBOUI,IBOEXP,VAUTC,VAUTD
	Q
DRANGE	; select a date range for report
	S DIR(0)="D^::EX",DIR("A")="Start with DATE" D ^DIR I $D(DIRUT) S IBOQUIT=1 K DIR Q
	S IBOBEG=Y,DIR("A")="Go to DATE" F  D ^DIR S:$D(DIRUT) IBOQUIT=1 Q:(Y>IBOBEG)!(Y=IBOBEG)!IBOQUIT  W !,*7,"ENDING DATE must follow or be the same as the STARTING DATE"
	S IBOEND=Y K DIR
	Q
DEVICE	;
	I $D(ZTQUEUED) Q
	W !!,*7,"*** Margin width of this output is 132 ***"
	W !,"*** This output should be queued ***"
	S %ZIS="MQ" D ^%ZIS I POP S IBOQUIT=1 Q
	I $D(IO("Q")) S ZTRTN="QUEUED^IBOUNP1",ZTIO=ION,ZTSAVE("VA*")="",ZTSAVE("IBO*")="",ZTDESC="OUTPATIENT INSURANCE REPORT" D ^%ZTLOAD W !,$S($D(ZTSK):"REQUEST QUEUED TASK="_ZTSK,1:"REQUEST CANCELLED") D HOME^%ZIS S IBOQUIT=1 Q
	U IO Q
CLINIC	; gets list of selected clinics,or sets VAUTC=1 if all selected
	N VAUTNI S VAUTNI=2,IBOQUIT=1
	D DIVISION^VAUTOMA Q:Y<0  S VAUTNI=2 D CLINIC^VAUTOMA Q:Y<0
	S IBOQUIT=0 Q
LCLINIC	; lists clinics if not all divisions were chosen
	N IBCLN,NODE
	I VAUTD'=1&(VAUTC=1) S VAUTC=0,IBCLN="" F  S IBCLN=$O(^SC(IBCLN)) Q:IBCLN=""  D
	.S NODE=$G(^SC(IBCLN,0))
	.;make sure it's the one of selected divisions division
	.Q:'$D(VAUTD(+$P(NODE,"^",15)))
	.;check that location is a clinic
	.Q:$P(NODE,"^",3)'="C"
	.S VAUTC(IBCLN)=""
	Q
CATGRY	; allows user to select categories to include in report
	S DIR(0)="Y",DIR("A")="Include veterans whose insurance is unknown"
	S DIR("B")="YES" D ^DIR K DIR I $D(DIRUT) S IBOQUIT=1 Q
	S IBOUK=Y
	S DIR(0)="Y",DIR("A")="Include veterans whose insurance is expiring"
	S DIR("B")="YES" D ^DIR K DIR I $D(DIRUT) S IBOQUIT=1 Q
	S IBOEXP=Y
	S DIR(0)="Y",DIR("A")="Include veterans who have no insurance"
	S DIR("B")="YES" D ^DIR K DIR I $D(DIRUT) S IBOQUIT=1 Q
	S IBOUI=Y
	Q
