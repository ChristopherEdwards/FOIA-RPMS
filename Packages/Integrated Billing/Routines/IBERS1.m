IBERS1	;ALB/ARH - APPOINTMENT CHECK-OFF SHEET GENERATOR (CONTINUED); 12/6/91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;***
	;S XRTL=$ZU(0),XRTN="IBERS1-2" D T0^%ZOSV ;start rt clock
	;
	;collect data/print appointment check-off sheets for patients and clinics choosen
	;passed in: temp file and IBSRT with the method of sort
	S IBQ=0 I $D(^TMP("IBRS",$J,"D")) D ENDV
	I 'IBQ,$D(^TMP("IBRS",$J,"C")) D ENCL
	I 'IBQ,$D(^TMP("IBRS",$J,"P")) D ENPT
	K ^TMP("IBRSC",$J),IBHDR,IBLC,IBQ
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBERS1" D T1^%ZOSV ;stop rt clock
	I $D(ZTQUEUED) S ZTREQ="@" Q
	Q
ENPT	;print an appointment check-off sheet for each patient selected
	;input TMP file - contains appointment data:
	;^TMP("IBRS",$J,"P",IBSRT1,IBSRT2,IBSRT3)=DFN^CLN/I^PNM/E^APP DT/E^CLN/E^STAT/E^APP TYP/E^PID/E^APP DT/I
	S IB1=2,IB4=4,IB2=((IOM-(IB1*2)-IB4)/2),IB3=((IOM-(IB1*2)-(IB4*2))/3)
	S IBDSH="" F IBI=1:1:IOM S IBDSH=IBDSH_"-"
	S IBSRT1="" F  S IBSRT1=$O(^TMP("IBRS",$J,"P",IBSRT1)) Q:IBSRT1=""!(IBQ)  S IBSRT2="" D:$D(IBHDR)&(IBSRT=1) HDRPG D
	. F  S IBSRT2=$O(^TMP("IBRS",$J,"P",IBSRT1,IBSRT2)) Q:IBSRT2=""!(IBQ)  S IBSRT3="" D
	.. F  S IBSRT3=$O(^TMP("IBRS",$J,"P",IBSRT1,IBSRT2,IBSRT3)) Q:IBSRT3=""!(IBQ)  D
	... S IBLN=^(IBSRT3) D ^IBERS2,PRINT
	D:$D(IBHDR) HDRPG
	K IBSRT1,IBSRT2,IBSRT3,IBLN,IBDSH,IB1,IB2,IB3,IB4,IBI,IBHDR,IBHDRLN,Y,^TMP("IBRS",$J,"P")
	Q
	;
ENCL	;for every clinic choosen find every patient appointment on DATE
	S IBCNT=1,(IBHDR,IBCLN)=""
	F  S IBCLN=$O(^TMP("IBRS",$J,"C",IBCLN)) Q:IBCLN=""!IBQ  D  S IBQ=$$STOP
	. S IBY="" F  S IBY=$O(^TMP("IBRS",$J,"C",IBCLN,IBY)) Q:IBY=""  D
	.. S (IBDT,IBAPP)=$E(IBY,1,7) F  S IBAPP=$O(^SC(IBCLN,"S",IBAPP)) Q:$E(IBAPP,1,7)'=IBDT  D
	... S IBCLNE=$P($G(^SC(IBCLN,0)),"^",1),Y=IBAPP X ^DD("DD") S IBDTE=Y
	... S IBX=0 F  S IBX=$O(^SC(IBCLN,"S",IBAPP,1,IBX)) Q:IBX=""  D
	.... S IBPFN=+$G(^SC(IBCLN,"S",IBAPP,1,IBX,0)) S IBPAT=$$PT^IBEFUNC(IBPFN) Q:IBPAT=""
	.... S IBAPTYP=$G(^DPT(IBPFN,"S",IBAPP,0)) Q:"NT,I,"'[($P(IBAPTYP,"^",2)_",")
	.... S IBAPTYP=$P($G(^SD(409.1,+$P(IBAPTYP,"^",16),0)),"^")
	.... S IBSRT1=$S(IBSRT=2:0_$$TDG^IBEFUNC2($P(IBPAT,"^",2)),1:IBCLN),IBCNT=IBCNT+1
	.... S ^TMP("IBRS",$J,"P",IBSRT1,$P(IBPAT,"^",1),IBAPP)=IBPFN_"^"_IBCLN_"^"_$P(IBPAT,"^",1)_"^"_IBDTE_"^"_IBCLNE_"^^"_IBAPTYP_"^"_$P(IBPAT,"^",2)_"^"_IBAPP
ENDC	K IBAPP,IBAPTYP,IBCLN,IBCLNE,IBCNT,IBDT,IBDTE,IBPFN,IBPAT,IBSRT1,IBX,IBY,Y,^TMP("IBRS",$J,"C")
	Q
	;
ENDV	;entire divisions were choosen, find all clinics (with check-off sheets defined)
	I $D(^TMP("IBRS",$J,"D","ALL")) S IBDT="" F  S IBDT=$O(^TMP("IBRS",$J,"D","ALL",IBDT)) Q:IBDT=""  D
	. S IBDIV="" F  S IBDIV=$O(^DG(40.8,IBDIV)) Q:IBDIV'?1N.N  S ^TMP("IBRS",$J,"D",IBDIV,IBDT)=""
	S IBGRP="" F  S IBGRP=$O(^SC("AF",IBGRP)) Q:IBGRP=""!IBQ  S IBCLN="" D  S IBQ=$$STOP
	. F  S IBCLN=$O(^SC("AF",IBGRP,IBCLN))  Q:IBCLN=""  D
	.. S IBDIV=$G(^SC(IBCLN,0)) Q:$P(IBDIV,"^",3)'="C"
	.. S IBDIV=$P(IBDIV,"^",15) Q:'$D(^TMP("IBRS",$J,"D",+IBDIV))
	.. S IBDT="" F  S IBDT=$O(^TMP("IBRS",$J,"D",+IBDIV,IBDT)) Q:IBDT=""  S ^TMP("IBRS",$J,"C",IBCLN,IBDT)=""
	K IBDT,IBCLN,IBDIV,IBGRP,^TMP("IBRS",$J,"D")
	Q
	;
HDRPG	;print a header/trailer pages if entire clinics or divisions were requested
	I $D(IBHDRLN) S IBX=$L(IBHDRLN) W !!!!!!!,$J("End"_IBHDRLN,((IOM\2)+(IBX\2)+2)),@IOF
	I IBSRT1'="" S IBX=$G(^SC(IBSRT1,0)),IBHDRLN=" of Check-off sheets for "_$P(IBX,"^",1)_", "_$P($G(^DG(40.8,+$P(IBX,"^",15),0)),"^",1),IBX=$L(IBHDRLN) W !!!!,$J("Beginning"_IBHDRLN,((IOM\2)+(IBX\2)+5)),@IOF
	K IBX
	Q
	;
PRINT	;print the patient data and then the check-off sheet CPT list that has been gathered/created
	S IBX="",IBLC=0 S IBQ=$$STOP
	F IBI=1:1 S IBX=$O(^TMP("IBRSP",$J,IBX)) Q:IBX=""!(IBQ)  S IBLC=IBLC+1 D:IOSL<(IBLC+3) PAUSE W !,^TMP("IBRSP",$J,IBX)
	I 'IBQ D PAUSE I 'IBQ S IBX=$G(^SC(+$P(IBLN,"^",2),0)) D CPT^IBERSP(+$P(IBX,"^",25),+$P(IBX,"^",15),IBLC,$P(IBLN,"^",9),0)
	W @IOF K ^TMP("IBRSP",$J),IBLC,IBX,IBI
	Q
PAUSE	;
	Q:$E(IOST,1,2)'["C-"  S (IBLC,IBQ)=0,DIR(0)="E" D ^DIR K DIR,DTOUT,DUOUT,DIRUT,DIROUT S:'Y IBQ=1 W @IOF
	Q
	;
STOP()	;deterimine if user requested task to stop
	I $D(ZTQUEUED),$$S^%ZTLOAD S ZTSTOP=1 K ZTREQ
	Q +$G(ZTSTOP)
