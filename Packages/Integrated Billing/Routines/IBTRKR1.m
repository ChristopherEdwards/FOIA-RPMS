IBTRKR1	;ALB/AAS - CLAIMS TRACKER - AUTO-ENROLLER ; 4-AUG-93
	;;Version 2.0 ; INTEGRATED BILLING ;; 21-MAR-94
	;;Per VHA Directive 10-93-142, this routine should not be modified.
	;
RANDOM(IBSPEC)	; -- see if random sample
	; -- input  = treating specialty from 45.7 (piece 9 of dgpma)
	;    output = 1 if random sample
	;             0 if not random sample
	;
	N X,Y,RANDOM,IBTRKR,SVC
	S RANDOM=0
	I '$G(IBSPEC) G RQ
	S IBTRKR=$G(^IBE(350.9,1,6))
	I $$FMDIFF^XLFDT(DT,$P(IBTRKR,"^",7))>7 D UP1
	S SVC=$P($G(^DIC(42.4,+$P($G(^DIC(45.7,+IBSPEC,0)),"^",2),0)),"^",3)
	I SVC="" G RQ
	S X=$S(SVC="M":8,SVC="S":13,SVC="P":18,1:0)
	S NAME=$P($G(^DIC(42.4,+$P($G(^DIC(45.7,+IBSPEC,0)),"^",2),0)),"^")
	;
	; -- don't count drug and alcohol, substance abuse or intermediate specialties
	I NAME["ALCOHOL"!(NAME["DRUG")!(NAME["SUBSTANCE")!(NAME["ABUSE")!(NAME["INTERMEDIATE") G RQ
	;
	I X S RANDOM=$$PROC(X)
	;
RQ	Q RANDOM
	;
PROC(X)	; -- process random sample, x= Service="M":8,Service="S":13,Serv="P":18
	N SAMPLE,SAMPDT,COUNT,RANDNUM,RANDOM
	S RANDOM=0
	G:'$G(X) PQ
	G:$S(X=8:0,X=13:0,X=18:0,1:1) PQ
	S SAMPLE=$P(IBTRKR,"^",X) ;     sample size
	;I SAMPLE<1 S SAMPLE=1 ;         default sample size = 1
	S SAMPTD=+$P(IBTRKR,"^",X+3) ;  samples to date
	S COUNT=$P(IBTRKR,"^",X+4)+1 ;  increment service counter
	S $P(^IBE(350.9,1,6),"^",X+4)=COUNT
	I SAMPLE'>SAMPTD G PQ ;         sample size already met
	S RANDNUM=$P(IBTRKR,"^",X+2) ;  get random number
	I RANDNUM<1 S RANDNUM=3 ;       default randon number
	I COUNT#RANDNUM=0 S RANDOM=1 ;  if count mod random number = 0 then is random sample
	I RANDOM S $P(^IBE(350.9,1,6),"^",X+3)=SAMPTD+1
PQ	Q RANDOM
	;
UPDATE	; -- weekly update of random sampler called from nightly job
	;
	I $$DOW^XLFDT(DT,1)'=0 Q  ; run on sunday night only
	;
UP1	; -- enter here to force update, nightly job didn't update in over 7 days
	N IBX,IBTRKR,SAMPLE,COUNT,RANDNUM
	S $P(^IBE(350.9,1,6),"^",7)=DT
	S IBTRKR=$G(^IBE(350.9,1,6))
	F IBX=8,13,18 D
	.S SAMPLE=$P(IBTRKR,"^",IBX) ;   get sample size
	.I SAMPLE<1 S SAMPLE=1 ;       default = 1
	.S ADMNUM=$P(IBTRKR,"^",IBX+1) ; get ave. number of admissions
	.I ADMNUM<5 S ADMNUM=5 ;       default = 5
	.F  S RANDOM=$R(ADMNUM/SAMPLE)+1 I RANDOM>0,RANDOM'>ADMNUM Q
	.S $P(^IBE(350.9,1,6),"^",IBX,IBX+4)=SAMPLE_"^"_ADMNUM_"^"_RANDOM_"^0^0"
	Q
	;
CLEAR	; -- Clear random sampler
	;
	N IBX
	S $P(^IBE(350.9,1,6),"^",7)=DT
	F IBX=8,13,18 S $P(^IBE(350.9,1,6),"^",IBX,IBX+4)="2^5^1^0^0"
