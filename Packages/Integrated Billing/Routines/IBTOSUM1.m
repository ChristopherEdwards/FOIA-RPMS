IBTOSUM1	;ALB/AAS - CLAIMS TRACKING BILLING INFORMATION PRINT ; 29-OCT-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;
REV	; -- count reviews
	D CHK^IBTOSUM2 I $G(ZTSTOP) Q
	; -- count review for same period
	S IBDT=IBBDT-.000000001
	F  S IBDT=$O(^IBT(356.2,"B",IBDT)) Q:'IBDT!(IBDT>(IBEDT+.24))  S IBTRC=0 F  S IBTRC=$O(^IBT(356.2,"B",IBDT,IBTRC)) Q:'IBTRC  D RCNT
	;
RCNT	; -- process each review
	N IBDAY,IBETYP,IBAC,IBNOD,IBTALL,IBPEND
	S IBTRCD=$G(^IBT(356.2,+IBTRC,0))
	S IBETYP=$G(^IBE(356.11,+$P(IBTRCD,"^",4),0))
	I $P(IBETYP,"^",2)>65 Q  ;is a patient, other or an ins. verification call
	;
	I $P(IBETYP,"^",2)=60 D  Q  ; count initial appeals and quit
	.S IBCNT(81)=IBCNT(81)+1
	;
	I $P(IBETYP,"^",2)=65 D  Q  ; count subsequent appeals and quit
	.S IBCNT(82)=IBCNT(82)+1
	;
	I $P(IBTRCD,"^",19)'=10 Q  ;must be completed to included in report
	;
	S IBSPEC=$$SPEC(IBTRC)
	S IBBBS=$$BBS(+IBSPEC)
	S IBRATE=$$RATE(IBBBS,+IBTRCD)
	;
	S IBPCNT(IBTRN,+$P(^IBT(356.2,+IBTRC,1),"^",5))=""
	S IBCNT(5)=$G(IBCNT(5))+1 ;count of total reviews done
	S IBCNT(5,+IBSPEC)=$G(IBCNT(5,+IBSPEC))+1
	S IBAC=+$$ACTION(IBTRC),IBDAY=0
	;
	I IBAC=10 D
	.S IBTALL=+$P($G(^IBT(356.2,IBTRC,1)),"^",8) ;approved all days
	.S IBCDT=$$CDT^IBTODD1(IBTRN)
	.S IBMAX=$S($D(IBDCNT(IBTRN))#2:IBDCNT(IBTRN),1:$$DAY^IBTUTL3(+IBCDT,$S($P(IBCDT,"^",2):$P(IBCDT,"^",2),1:IBEDT))) ; max days approved for a visit
	.I '$D(IBDCNT(IBTRN))#2 S IBDCNT(IBTRN)=IBMAX
	.I 'IBTALL S IBDAY=$$DAY^IBTUTL3(+$P(IBTRCD,"^",12),+$P(IBTRCD,"^",13),IBTRN)
	.I IBTALL S IBDAY=$$DAY^IBTUTL3(+IBCDT,$S($P(IBCDT,"^",2):$P(IBCDT,"^",2),1:DT),IBTRN)
	.I IBDAY>IBMAX S IBDAY=IBMAX
	.S IBDCNT(IBTRN)=IBDCNT(IBTRN)-IBDAY ;count can't excede total days
	;
	I IBAC=20 D
	.S IBTALL=+$P($G(^IBT(356.2,IBTRC,1)),"^",7) ;denied all days
	.S IBCDT=$$CDT^IBTODD1(IBTRN)
	.S IBMAX=$S($D(IBDCNT(IBTRN))#2:IBDCNT(IBTRN),1:$$DAY^IBTUTL3(+IBCDT,$S($P(IBCDT,"^",2):$P(IBCDT,"^",2),1:IBEDT))) ; max days approved for a visit
	.I '$D(IBDCNT(IBTRN))#2 S IBDCNT(IBTRN)=IBMAX
	.I 'IBTALL S IBDAY=$$DAY^IBTUTL3(+$P(IBTRCD,"^",15),+$P(IBTRCD,"^",16),IBTRN)
	.I IBTALL S IBDAY=$$DAY^IBTUTL3(+IBCDT,$S($P(IBCDT,"^",2):$P(IBCDT,"^",2),1:DT),IBTRN)
	.I IBDAY>IBMAX S IBDAY=$S(IBMAX<0:0,1:IBMAX)
	.S IBDCNT(IBTRN)=IBDCNT(IBTRN)-IBDAY ;count can't excede total days
	;
	S IBCNT(IBAC)=$G(IBCNT(IBAC))+IBDAY,IBCNT(IBAC,+IBSPEC)=$G(IBCNT(IBAC,+IBSPEC))+IBDAY
	S IBCNT(IBAC+1)=$G(IBCNT(IBAC+1))+(IBDAY*IBRATE)
	S IBCNT(IBAC+1,+IBSPEC)=$G(IBCNT(IBAC+1,+IBSPEC))+(IBDAY*IBRATE)
	I IBAC=30 S IBPEN=0 F  S IBPEN=$O(^IBT(356.2,+IBTRC,13,IBPEN)) Q:'IBPEN  S IBPEND=$G(^(IBPEN,0)) D
	.S IBNOD=IBPEND+30
	.S $P(IBCNT(IBNOD),"^",1)=$P(IBCNT(IBNOD),"^",1)+1
	.S $P(IBCNT(IBNOD),"^",2)=$P(IBCNT(IBNOD),"^",2)+$P(IBPEND,"^",2)
	.S $P(IBCNT(IBNOD,+IBSPEC),"^",1)=+$G(IBCNT(IBNOD,+IBSPEC))+1
	.S $P(IBCNT(IBNOD,+IBSPEC),"^",2)=$P($G(IBCNT(IBNOD,+IBSPEC)),"^",2)+$P(IBPEND,"^",2)
	.Q
	Q
	;
ACTION(IBTRC)	; -- compute action code for a review
	Q $P($G(^IBE(356.7,+$P($G(^IBT(356.2,+$G(IBTRC),0)),"^",11),0)),"^",3)
	;
SPEC(IBTRC)	; -- compute treating specialty on review date
	N VAERR,VAIN,VAINDT,X,Y,I,J,DFN,IBTRN,IBCDT
	S VAINDT=+$G(^IBT(356.2,+IBTRC,0))+.2359,DFN=$P(^(0),"^",5)
	S IBTRN=$P($G(^IBT(356.2,+IBTRC,0)),"^",2),IBCDT=$$CDT^IBTODD1(IBTRN)
	I VAINDT,+IBCDT,VAINDT<(+IBCDT) S VAINDT=IBCDT+.2359
	I VAINDT,+$P(IBCDT,"^",2),VAINDT>$P(IBCDT,"^",2) S VAINDT=$P(IBCDT,"^",2)\1
	D:DFN INP^VADPT
	Q $G(VAIN(3))
	;
BBS(IBSPEC)	; -- compute billing bedsection from specialty
	N X
	S X=$P($G(^DIC(42.4,+$P($G(^DIC(45.7,+$G(IBSPEC),0)),"^",2),0)),"^",5)
	I X'="" S X=$O(^DGCR(399.1,"B",X,0))
	Q X
	;
RATE(IBBBS,IBDT)	; -- compute daily bed section rate for date
	N DGREV,DGBR,IBIDT,DGBRN,DGFND,IBCHK,X,IBAMT
	S IBAMT=0 I '$G(IBBBS)!('$G(IBDT)) G RATEQ
	D SETREV
RATEQ	Q IBAMT
	;
SETREV	; -- find current active revenue codes for bedsection
	S (IBAMT,DGREV,DGBR)=0,IBIDT=-(IBDT+.01) K DGFND
	F  S IBIDT=$O(^DGCR(399.5,"AIVDT",IBBBS,IBIDT)) Q:'IBIDT!($D(DGFND))  D
	. F  S DGREV=$O(^DGCR(399.5,"AIVDT",IBBBS,IBIDT,DGREV)) Q:'DGREV  D
	.. F  S DGBR=$O(^DGCR(399.5,"AIVDT",IBBBS,IBIDT,DGREV,DGBR)) Q:'DGBR  D CHKREV I IBCHK S IBAMT=IBAMT+X
	Q
CHKREV	; -- check if billing rate (dgbr) is active and starndard.
	S IBCHK=0,X=0
	S DGBRN=^DGCR(399.5,DGBR,0) I '$P(DGBRN,"^",5) Q  ;quit if inactive
	I +$P(DGBRN,"^",7) Q  ;quit if non-standard rate
	;
	; -- use cat c rate as total for tortuously liable rates
	I $P(DGBRN,U,6)["c" S:'$D(DGFND) DGFND="" S IBCHK=1
	;
	S X=$P(^DGCR(399.5,DGBR,0),"^",4)
	Q
