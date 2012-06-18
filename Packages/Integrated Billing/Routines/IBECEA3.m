IBECEA3	;ALB/CPM - Cancel/Edit/Add... Add a Charge ; 30-MAR-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
ADD	; Add a Charge protocol
	S IBCOMMIT=0,IBEXSTAT=$$RXST^IBARXEU(DFN,DT),IBCATC=$$BILST^DGMTUB(DFN),IBCVAEL=$$CVA^IBAUTL5(DFN)
	I 'IBCVAEL,'IBCATC,'$G(IBRX),+IBEXSTAT<1 W !!,"This patient has never been Category C." S VALMBCK="" D PAUSE^VALM1 G ADDQ1
	;
	; - clear screen and begin
	D CLOCK^IBAUTL3 I 'IBCLDA S (IBMED,IBCLDAY,IBCLDOL,IBCLDT)=0
	D HDR^IBECEAU("A D D")
	I IBY<0 D NODED^IBECEAU3 G ADDQ
	;
	; - ask for the charge type
	D CHTYP^IBECEA33 G:IBY<0 ADDQ
	;
	; - process CHAMPVA charges
	I IBXA=6 D CHMPVA^IBECEA32 G ADDQ
	;
	; - display billing clock data
	I IBXA=2,$P(Y(0),"^",8)'["NHCU",IBCLDAY>90 S IBMED=IBMED/2
	I "^1^2^3^"[("^"_IBXA_"^"),IBCLDA W !!,"  ** Active Billing Clock **   # Inpt Days: ",IBCLDAY,"    ",$$INPT^IBECEAU(IBCLDAY)," 90 days: $",+IBCLDOL,!
	;
	; - ask units for rx copay charge
	I IBXA=5 D UNIT^IBECEAU2(0) G ADDQ:IBY<0 D CTBB^IBECEAU3 G PROC
	S IBLIM=$S(IBXA=4:DT,1:$$FMADD^XLFDT(DT,-1))
	;
FR	; - ask 'bill from' date
	D FR^IBECEAU2(0) G:IBY<0 ADDQ
	;
	; - check the billing clock
	D CLMSG^IBECEA33 G:IBY<0 ADDQ
	;
	; - calculate the inpt copay charge
	I IBXA=2 S IBDT=IBFR D COPAY^IBAUTL2 G ADDQ:IBY<0 I IBCHG+IBCLDOL<IBMED W *7,"   ($",IBCHG,"/day)"
	;
	; - find the correct clock from the 'bill from' date
	I 'IBCLDA!(IBCLDA&(IBFR<IBCLDT)) D NOCL^IBECEA33 G:IBY<0 ADDQ
	;
	; - perform outpatient edits
	I IBXA=4 D OPT^IBECEA33 G ADDQ:IBY<0,PROC
	;
	; - find per diem charge and description
	I IBXA=3 D  I 'IBCHG W !!,"Unable to determine the per diem rate.  Please check your rate table." G ADDQ
	.N IBDT S IBDT=IBFR D COST^IBAUTL2
	.S IBDESC="" X:$D(^IBE(350.1,IBATYP,20)) ^(20)
	;
	; - calculate charge for the inpatient copay
	I IBXA=2,IBCHG+IBCLDOL'<IBMED S IBCHG=IBMED-IBCLDOL,IBUNIT=1,IBTO=IBFR D CTBB^IBECEAU3 G EV
	;
TO	; - ask 'bill to' date
	D TO^IBECEAU2(0) G:IBY<0 ADDQ
	;
	; - calculate units and total charge
	S IBUNIT=$$FMDIFF^XLFDT(IBTO,IBFR) S:IBXA'=3!(IBFR=IBTO) IBUNIT=IBUNIT+1
	I IBXA=1 D FEPR^IBECEA32 G ADDQ:IBY<0,PROC
	S IBCHG=IBCHG*IBUNIT S:IBXA=2 IBCHG=$S(IBCLDOL+IBCHG>IBMED:IBMED-IBCLDOL,1:IBCHG)
	D CTBB^IBECEAU3 W:IBXA=3 "  (for ",IBUNIT," day",$E("s",IBUNIT>1),")"
	;
EV	; - find event record, or select admission for linkage
	S IBEVDA=$$EVF^IBECEA31(DFN,IBFR,IBTO,IBNH)
	I IBEVDA'>0 D NOEV^IBECEA31 G ADDQ:IBY<0,PROC
	S IBSL=$P($G(^IB(+IBEVDA,0)),"^",4)
	W !!,"Linked charge to admission on ",$$DAT1^IBOUTL($P(IBEVDA,"^",2)),"  ("
	W $S($P(IBEVDA,"^",3)=9999999:"Still admitted)",1:"Discharged on "_$$DAT1^IBOUTL($P(IBEVDA,"^",3))_$S($P(IBEVDA,"^",3)>DT:" [pseudo])",1:")"))," ..."
	S IBEVDA=+IBEVDA
	I '$G(IBSIBC) D SPEC^IBECEA32(0,$O(^IBE(351.2,"AD",IBEVDA,0)))
	;
PROC	; - okay to proceed?
	D PROC^IBECEAU4("add") G:IBY<0 ADDQ
	;
	; - build the event record first if necessary
	I $G(IBDG) D ADEV^IBECEA31 G:IBY<0 ADDQ
	;
	; - disposition the special inpatient billing case, if necessary
	I $G(IBSIBC) D CEA^IBAMTI1(IBSIBC,IBEVDA)
	;
	; - generate entry in file #350
	W !!,"Building the new transaction...  "
	D ADD^IBECEAU3 G:IBY<0 ADDQ W "done."
	;
	; - pass the charge off to AR on-line
	W !,"Passing the charge directly to Accounts Receivable... "
	D PASSCH^IBECEA22 W:IBY>0 "done." G:IBY<0 ADDQ
	;
	; - review the special inpatient billing case
	I $G(IBSIBC1) D CHK^IBAMTI1(IBSIBC1,IBEVDA)
	;
	; - handle updating of clock
	D CLUPD^IBECEA32
	;
ADDQ	; - display error, rebuild list, and quit
	D ERR^IBECEAU4:IBY<0,PAUSE^IBECEAU S VALMBCK="R"
	I IBCOMMIT S IBBG=VALMBG W !,"Rebuilding list of charges..." D ARRAY^IBECEA0 S VALMBG=IBBG
	K IBMED,IBCLDA,IBCLDT,IBCLDOL,IBCLDAY,IBATYP,IBDG,IBSEQNO,IBXA,IBNH,IBBS,IBLIM,IBFR,IBTO,IBRTED,IBSIBC,IBSIBC1,IBBG
	K IBX,IBCHG,IBUNIT,IBDESC,IBDT,IBEVDT,IBEVDA,IBSL,IBNOS,IBN,IBTOTL,IBARTYP,IBIL,IBTRAN,IBAFY,IBCVA,IBCLSF,IBDD,IBND,VADM,VA,VAERR
ADDQ1	K IBEXSTAT,IBCOMMIT,IBCATC,IBCVAEL
	Q
