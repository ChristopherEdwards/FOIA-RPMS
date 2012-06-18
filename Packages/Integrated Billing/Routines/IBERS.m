	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
	;patient data for a particuar appointment is printed on the top of the check-off sheet
EN	;determine print option from user  (print by clinic or by patient)
	;***
	;S XRTL=$ZU(0),XRTN="IBERS-1" D T0^%ZOSV ;start rt clock
	D HOME^%ZIS S IBDT=DT
E1	W @IOF,!,?20,"Print Appointment Check-Off Sheets",!!
	S DIR("?")="Enter a code from the list or return to exit.",DIR("B")="Clinic"
	S DIR(0)="SO^P:Patient Name;C:Clinic",DIR("A")="Select Appointment by" D ^DIR K DIR G:$D(DIRUT) END S IBC=Y
	I IBC="P" S IBSRT=1 G E2
	S DIR(0)="SOB^C:Clinic and Patient;T:Terminal Digits",DIR("?")="Enter ""C"" for sorting by Clinic and Patient or ""T"" to sort by Terminal Digits"
	S DIR("A")="Sort sheets by",DIR("B")="Clinic" D ^DIR K DIR G:$D(DIRUT) END S IBSRT=$S(Y="T":2,1:1)
E2	D DATE I IBDT'=-1 D @IBC
END	G:'$D(^TMP("IBRS",$J)) EXIT
	W !,"This report requires 132 columns."
	S %ZIS="QM",%ZIS("A")="OUTPUT DEVICE: " D ^%ZIS G:POP EXIT
	I $D(IO("Q")) S ZTRTN="^IBERS1",ZTDESC="IB Appointment Check-Off Sheets",ZTSAVE("^TMP(""IBRS"",$J,")="",ZTSAVE("IBSRT")="" D ^%ZTLOAD K IO("Q") D HOME^%ZIS G EXIT
	U IO
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBERS" D T1^%ZOSV ;stop rt clock
	D ^IBERS1
EXIT	K ^TMP("IBRS",$J)
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBERS" D T1^%ZOSV ;stop rt clock
	I $D(ZTQUEUED) S ZTREQ="@" Q
	K IBC,IBDT,IBSRT,DTOUT,DUOUT,DIRUT,DIROUT,X,Y D ^%ZISC
	Q
	;
P	;print by patient - get patient then appointment(s) for date
	S DIC="^DPT(",DIC(0)="AEQM" D ^DIC K DIC G:Y<0 ENDP S IBPFN=+Y,IBPNM=$P(Y,"^",2)
	S IBDFN(IBPFN)="" D SEARCH S IBNM=IBPNM D DISP
	G P
ENDP	K IBPFN,IBPNM,IBNM,DTOUT,DUOUT,X,Y
	Q
	;
C	;print all appointments for a clinic - find division then clinic, print all/some clinics for all/some divisions
	D DIVISION^VAUTOMA G:$D(VAUTD)<11&(VAUTD=0) ENDC
	S DIC("S")="I +$P(^(0),U,25),$P(^(0),U,3)=""C"",$S(VAUTD:1,$D(VAUTD(+$P(^(0),U,15))):1,'+$P(^(0),U,15)&$D(VAUTD($O(^DG(40.8,0)))):1,1:0)"
	S DIC="^SC(",VAUTVB="VAUTC",VAUTNI=2,VAUTSTR="clinic" D FIRST^VAUTOMA K DIC G:$D(VAUTC)<11&(VAUTC=0) ENDC
	I VAUTC,VAUTD S ^TMP("IBRS",$J,"D","ALL",IBDT)=""
	I VAUTC,'VAUTD S IBDIV="" F IBI=1:1 S IBDIV=$O(VAUTD(IBDIV)) Q:IBDIV=""  S ^TMP("IBRS",$J,"D",IBDIV,IBDT)=""
	I 'VAUTC S IBCLN="" F IBI=1:1 S IBCLN=$O(VAUTC(IBCLN)) Q:IBCLN=""  S ^TMP("IBRS",$J,"C",IBCLN,IBDT)=""
ENDC	K VAUTNI,VAUTD,VAUTC,VAUTVB,VAUTSTR,IBDIV,IBCLN,IBI,DIC
	Q
	;
SEARCH	;get the appointment data on a patient (IBLN=APPT DT^CLINIC^STATUS^APPT TYPE)
	S DFN=""
S1	S DFN=$O(IBDFN(DFN)) G:DFN="" ENDS
	S (VASD("F"),VASD("T"))=IBDT,VASD("W")=129 D SDA^VADPT I VAERR!'($D(^UTILITY("VASD",$J))) G S1
	S IBX="" F IBI=1:1 S IBX=$O(^UTILITY("VASD",$J,IBX)) Q:IBX=""  D
	. S IBLN=^UTILITY("VASD",$J,IBX,"I") Q:'$P($G(^SC(+$P(IBLN,"^",2),0)),"^",25)  S IBPAT=$$PT^IBEFUNC(DFN) Q:IBPAT=""
	. S IBTMP($P(IBLN,"^",1))=DFN_"^"_$P(IBLN,"^",2)_"^"_$P(IBPAT,"^",1)_"^"_^UTILITY("VASD",$J,IBX,"E")_"^"_$P(IBPAT,"^",2)
	G S1
ENDS	K IBX,IBI,IBLN,DFN,IBPAT,VASD,VAERR,IBDFN
	Q
	;
DISP	;display patients/clinics appointments found and get users choice
	I '$D(^UTILITY("VASD",$J)) W !!,?5,"No Active Appointments for ",IBNM," on this date",! G ENDD
	I '$D(IBTMP) W !!,?10,"No Active Appointments in a Clinic with a Check-Off Sheet",!,?10,"for ",IBNM," on this date.",! G ENDD
	W !!,"Appointments for ",IBNM,!
	S IBX="" F IBI=1:1 S IBX=$O(IBTMP(IBX)) Q:IBX=""  S IBLN=IBTMP(IBX) W !,$J(IBI,3),"  ",$E($S(IBC="C":$P(IBLN,"^",3),1:$P(IBLN,"^",5)),1,20),?25,"   " F IBJ=4,6,7 W "  ",$P(IBLN,"^",IBJ)
	S DIR(0)="LO^1:"_(IBI-1)_"^K:X[""."" X",DIR("A")="    Select Appointments" D ^DIR K DIR G:$D(DIRUT) ENDD
	S IBX="" F IBI=1:1 S IBX=$O(IBTMP(IBX)) Q:IBX=""  I Y[(IBI_",") D
	. S IBSRT1=$S(IBSRT=2:0_$$TDG^IBEFUNC2($P(IBTMP(IBX),"^",8)),1:$P(IBTMP(IBX),"^",2))
	. S ^TMP("IBRS",$J,"P",IBSRT1,$P(IBTMP(IBX),"^",3),IBX)=IBTMP(IBX)_"^"_IBX
ENDD	K IBX,IBI,IBJ,IBLN,IBTMP,IBSRT1,DTOUT,DUOUT,DIRUT,DIROUT,X,Y,^UTILITY("VASD",$J)
	Q
	;
DATE	;get date for RS
	S Y=IBDT X ^DD("DD")
	S %DT="AEX",%DT("A")="Appointment DATE: ",%DT("B")=Y D ^%DT K %DT S IBDT=Y
	W !!,"Only Clinics and Patients with Appointments on this Date will be allowed."
	W !,"Appointments must be in Clinics that have a Check-Off Sheet, to be chosen.",!!
	Q
