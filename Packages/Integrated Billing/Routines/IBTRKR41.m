IBTRKR41	;ALB/AAS - CLAIMS TRACKING - ADD/TRACK OUTPATIENT ENCOUNTERS ; 13-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
OPCHK	; -- check and add rx
	S IBCNT=IBCNT+1
	K IBRMARK
	I '$D(ZTQUEUED),($G(IBTALK)) W "."
	;
	S IBOEDATA=$G(^SCE(IBOE,0)),IBOESTAT=$P(IBOEDATA,"^",15)
	S DFN=$P(IBOEDATA,"^",2)
	I 'DFN G OPCHKQ
	I $P(IBOEDATA,"^",5) S IBVSIT=$P(IBOEDATA,"^",5)
	;
	; -- not already in claims tracking
	I $O(^IBT(356,"AENC",+DFN,+IBOE,0)) G OPCHKQ ; already in claims tracking
	I $O(^IBT(356,"APTY",DFN,IBOETYP,IBDT,0)) G OPCHKQ ; already visit for same date time
	;
	; -- see if tracking only insured and pt is insured
	I $P(IBTRKR,"^",4)=1,'$$INSURED^IBCNS1(DFN,IBDT) G OPCHKQ ; patient not insure
	;
	; -- check visit status (checked in/out, inpatient, canceled, etc)
	I '$P(IBOEDATA,"^",7) G OPCHKQ ; check out not complete
	I $P($G(^DPT(DFN,"S",IBDT,0)),"^",2)'="" G OPCHKQ ;is canceled or inpatient or something
	;
	; -- see if appointment type is billable
	I '$$RPT^IBEFUNC($P(IBOEDATA,"^",10),+IBOEDATA) S IBRMARK="NON-BILLABLE APPOINTMENT TYPE"
	;
	; -- is it a primary visit
	I $P(IBOEDATA,"^",6),$P(IBOEDATA,"^",6)'=IBOE G OPCHKQ ; only store primary visits for now
	; -- get visit status
	I $P(IBOEDATA,"^",12)'=2 G OPCHKQ ;only checked out encounters can be added
	;
	; -- check sc status, special conditions etc.
	I $G(IBRMARK)="" S IBENCL=$$ENCL^IBAMTS2(IBOE) I IBENCL["1" D  ; return 1 in string if true "ao^ir^sc^ec"
	.I $P(IBENCL,"^",3) S IBRMARK="SC TREATMENT" Q
	.I $P(IBENCL,"^",1) S IBRMARK="AGENT ORANGE" Q
	.I $P(IBENCL,"^",2) S IBRMARK="IONIZING RADIATION" Q
	.I $P(IBENCL,"^",4) S IBRMARK="ENV. CONTAM." Q
	;
	; -- check for non-billable stops
	S X=$P(IBOEDATA,"^",3) I X,$$NBCSC^IBEFUNC(X,+IBOEDATA) S IBRMARK="NON-BILLABLE STOP CODE"
	;
	; -- ok to add to tracking module
	D OPT^IBTUTL1(DFN,IBOETYP,IBDT,IBOE,$G(IBRMARK),$G(IBVSIT)) I '$D(ZTQUEUED),$G(IBTALK) W "+"
	I $G(IBRMARK)'="" S IBCNT2=IBCNT2+1
	I $G(IBRMARK)="" S IBCNT1=IBCNT1+1
OPCHKQ	K IBRMARK,VAEL,VA,IBOEDATA,IBVSIT,DFN,X,Y
	Q
	;
BULL	; -- send bulletin
	;
	S XMSUB="Outpatient Encounters added to Claims Tracking Complete"
	S IBT(1)="The process to automatically add Opt Encounters has successfully completed."
	S IBT(1.1)=""
	S IBT(2)="              Start Date: "_$$DAT1^IBOUTL(IBTSBDT)
	S IBT(3)="                End Date: "_$$DAT1^IBOUTL(IBTSEDT)
	I $D(IBMESS) S IBT(3.1)=IBMESS
	S IBT(4)=""
	S IBT(5)="            Total Encounters Checked: "_$G(IBCNT)
	S IBT(6)="              Total Encounters Added: "_$G(IBCNT1)
	S IBT(7)=" Total Non-billable Encounters Added: "_$G(IBCNT2)
	S IBT(8)=""
	S IBT(9)="*The SC, Agent Orange, Environmental Contaminate, and Ionizing "
	S IBT(10)="Radiation visits have been added for insured patients but"
	S IBT(11)="automatically indicated as not billable"
	D SEND^IBTRKR31
BULLQ	Q
