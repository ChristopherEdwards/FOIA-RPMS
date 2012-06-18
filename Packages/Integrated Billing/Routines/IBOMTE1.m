IBOMTE1	;ALB/CPM - ESTIMATE CATEGORY C CHARGES (PRINT) ; 17-DEC-91
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
	;***
	;S XRTL=$ZU(0),XRTN="IBOMTE1-2" D T0^%ZOSV ;start rt clock
	; Set up report header.
	S IBLINE="",$P(IBLINE,"-",IOM+1)="",(IBPAG,IBQUIT)=0
	S DFN=IBDFN,IBPT=$$PT^IBEFUNC(DFN) D HDR
	;
	; Check to see if patient will be Category C upon admission.
	S IBLASTC=$$BILST^DGMTUB(DFN)
	I IBBDT>DT&(IBLASTC<DT)!(IBBDT'>DT&(IBLASTC<IBBDT)) D
	. I 'IBLASTC W "** Please note that this patient has never been Category C. **",! Q
	. W "Please note that this patient ",$S(IBBDT'<DT:"will not be",1:"was not")," Category C on the admission date."
	. W !,"Last date as Category C: ",$$DAT1^IBOUTL(IBLASTC),!
	;
	; Check to see if the patient has an active billing clock
	; from which to base the charges.  Print active clock data.
	D CLOCK^IBAUTL3
	I IBCLDA D
	. S X1=IBBDT,X2=IBCLDT D ^%DTC S IBCLCT=X I X>365 S IBCLDA=0 Q
	. W "** THIS PATIENT HAS AN ACTIVE BILLING CLOCK **",!?6,"Clock date: ",$$DAT1^IBOUTL(IBCLDT),"   Days of inpatient care within clock: ",$J(+IBCLDAY,2)
	. W !?6,"Copayments made for current 90 days of inpatient care: ",$J("$"_$J(IBCLDOL,0,2),7),!
	I 'IBCLDA S IBCLDT=IBBDT,(IBCLCT,IBCLDAY,IBCLDOL)=0 D DED^IBAUTL3
	;
	; Build necessary processing variables.
	S (IBCHGT,IBTOT)=0 K IBA
	S X1=IBEDT,X2=IBBDT D ^%DTC S IBLOS=$S(IBEDT=IBBDT&('IBEVDA):1,1:X)
	S X=IBBDT D H^%DTC S IBBDH=%H,IBFCTR=IBBDH-1
	S X=IBEDT D H^%DTC S IBEDH=%H-1
	S IBNH=$P($G(^DGCR(399.1,IBBS,0)),"^")["NURSING"
	;
	; If continuous patient, just calculate the per diem.
	I $$CONT^IBAUTL5(DFN)>IBEDT D COHDR^IBOMTE2,NOCOP W ?3,"(PATIENT IS CONTINUOUS SINCE 7/1/86)",! G PER
	;
	; Process each day in the admission for co-payments.
	D ^IBOMTE2 G:IBQUIT END
	;
PER	; Calculate the total per diem charge and print total.
	I $Y>(IOSL-7) D PAUSE^IBOUTL G:IBQUIT END D HDR
	W !,"PER DIEM CHARGES for ",$S(IBNH:"NURSING HOME",1:"HOSPITAL")," CARE",!,IBLINE
	S IBDIEM=$$DIEM^IBAUTL5,X=IBEDT I IBBDT'=IBEDT S %H=IBEDH D YMD^%DTC S IBEDT=X
	I IBEDT<IBDIEM D NOPD G TOT
	I IBDIEM>IBBDT S X1=IBEDT,(X2,IBBDT)=IBDIEM D ^%DTC S IBLOS=X+1
	I IBLOS<1 D NOPD G TOT
	S IBCHG=IBLOS*$S(IBNH:5,1:10),IBTOT=IBTOT+IBCHG
	W !,$$DAT1^IBOUTL(IBBDT),?12,$$DAT1^IBOUTL(IBEDT),?26,IBLOS," day",$E("s",IBLOS>1),"  @ $",$S(IBNH:"5.00",1:"10.00"),"/day"
	S X=IBCHG,X2="2$",X3=12 D COMMA^%DTC W ?61,X
	;
TOT	W !?62,"----------",!?35,"Total Estimated Charges:" S X=IBTOT,X2="2$",X3=12 D COMMA^%DTC W ?61,X
	D PAUSE^IBOUTL
	;
END	; Close device and quit
	;***
	;I $D(XRT0) S:'$D(XRTN) XRTN="IBOMTE1" D T1^%ZOSV ;stop rt clock
	Q:$D(ZTQUEUED)
	K %H,IBJ,IBDIEM,IBCLDOL,IBTOT,IBH,IBLOS,IBNH,IBFCTR,IBBDH,IBEDH,IBLASTC,IBMED,IBCLDA,IBCLDT,IBCLCT,IBCLDAY,IBQUIT,IBCHG,IBCHGT,IBPAG,IBLINE,IBMAX,IBDT,IBATYP,IBDESC,IBI,IBCHARG,IBPT
	D ^%ZISC Q
	;
	;
HDR	; Print header.
	S IBPAG=IBPAG+1,IBH="Estimated Category C Inpatient Charges for "_$P(IBPT,"^")_"  "_$P(IBPT,"^",3)_$S(IBPAG>1:"  (Con't.)",1:"")
	I $E(IOST,1,2)["C-"!(IBPAG>1) W @IOF
	W !?IOM-$L(IBH)\2,IBH,!!
	I IBEVDA W "Please note that this patient is a current inpatient.",!
	W "Charges will be estimated from ",$$DAT1^IBOUTL(IBBDT)," through ",$$DAT1^IBOUTL(IBEDT),"."
	I IBBDT=IBEDT,'IBEVDA W "  (ONE-DAY ADMISSION)"
	W ! Q
	;
NOCOP	; Print 'No Copay' message.
	W !,"** NO COPAYMENT CHARGES WILL BE APPLIED **",?67,"$0.00",! Q
	;
NOPD	; Print 'No Per Diem' message.
	W !,"** NO PER DIEM CHARGES WILL BE APPLIED **",?67,"$0.00" Q
