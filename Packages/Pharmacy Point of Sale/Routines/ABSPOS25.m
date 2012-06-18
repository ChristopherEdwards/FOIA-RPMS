ABSPOS25 ; IHS/FCS/DRS - insurance auto-selection ;  [ 08/28/2002  2:43 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,11,13,21,37**;JUN 21, 2001
 ; Changed: POS always used ^ABSPCOMB, regardless of ILC presence
 Q
 ; Called from:
 ;   ABSPOSQB as called from ABSPOSQ1
 ;   ABSPOSI8 - Screenman input
 ;   ABSPOSD1 - find unbilled prescriptions
 ;   ABSPOS28 - development, research
 ;   ABSPOS32 - survey insurers
 ;
 ;----------------------------------------------------------
 ;IHS/SD/lwj 8/28/02 Reversed the order of TMP used within the 
 ;INSURER subroutine.  This reversed order is done to simplify 
 ;processing of the array and to comply with Cache systems.
 ;
 ;----------------------------------------------------------
 ;IHS/SD/lwj 10/18/04 patch 11 grace days incorrect
 ; In the subroutine GRACE, and invalid reference was made
 ; to the setup file "INS" entry.
 ;----------------------------------------------------------
 ;IHS/SD/lwj 6/28/05 patch 13 lookup of coverage type
 ;altered to not assume a value is in place
 ;----------------------------------------------------------
 ;IHS/SD/RLT - 5/9/07 - Patch 21
 ;       In ELGDATE tag added code to skip insurance records
 ;       with no effective date.
 ;----------------------------------------------------------
INSURER(ARRAY,FRESH,MAXARRAY,FORRX)    ;EP
 ; pass ARRAY by reference (.ARRAY)
 ; given ABSBVISI, ABSBPATI, ABSBRXI, ABSBRXR
 ; $G(FRESH) true if you want to see all insurances, not just
 ;   what's in the default order of billing for this visit
 ;   (to be implemented - relevant to ILC new A/R package only)
 ;   Default is FRESH = 1 = true
 ; $G(MAXARRAY) if you want no more than this many to be returned
 ;   Default is 0 = no limit
 ;   Working copy of array may be larger than what you specify.
 ; ABSBRXI, ABSBRXR needed only for precision in date filled;
 ;  you can send them as both false and ABSBVISI date will be used.
 ; FORRX = true if this is being called for pharmacy (default = TRUE)
 ;
 ; Fill ARRAY(n) with InsurerIEN^PINS piece^ABSPCOMB n^score^rules
 ;      InsurerIEN points to ^AUTNINS(*)
 ;      PINS piece is   type,D0,D1
 ;          D1 = pointer to subindex of AUPNPRVT; 0 for caid, care
 ;      ABSPCOMB n pointer to ^ABSPCOMB(ABSBPATI,1,*)v
 ;      score = how many points scored in ranking the insurances
 ;      RULES = ";"-delimited list of rules which affected this choice
 ;
 ; and set ARRAY(0)=count^count of prvt^count of care^count of caid
 ; Set ARRAY("ORDER")=$$ returned value from ABSPOS26
A ;N (ABSBVISI,ABSBPATI,ABSBRXI,ABSBRXR,DUZ,DT,U,DEBUG,ARRAY,FRESH,MAXARRAY,FORRX)
 N ONDATE
 I '$D(FRESH) S FRESH=1
 I '$G(MAXARRAY) S MAXARRAY=3 ; send MAXARRAY=0 same as "no limit"
 I '$D(FORRX) S FORRX=1
 K ARRAY S ARRAY(0)=0
 I '$D(DEBUG) N DEBUG S DEBUG=0
 E  I DEBUG D
 . W $T(+0)," for ABSBVISI=",$G(ABSBVISI),", ABSBPATI=",ABSBPATI
 . W ", ABSBRXI=",ABSBRXI,", ABSBRXR=",ABSBRXR
 . W !
 ;
 ; ABSPOS29 is different from VTLCOMB in that ABSPOS29 takes the
 ;   Medicaid FI field into account - ABSPOS29 translates the IEN 3
 ;   into a specific state's IEN. (But site-specific switchable)
B ;I $$ILCAR D
 ;. D EN^VTLCOMB(ABSBPATI) ; update in the combined insurance file
 ;E  D
 D  ; everybody does the point of sale version:
 . D EN^ABSPOS29(ABSBPATI) ; copied from VTLCOMB but in ABSPOS namespace
 ;
 ; We are interested in eligibility on the date filled
 ; (Or visit date, if date filled is missing or not supplied)
 ; (Or just take DT, if you don't even have a visit pointer)
 ;
 ;I ABSBRXR S ONDATE=$P(^PSRX(ABSBRXI,1,ABSBRXR,0),U)
 ;;IHS/OIT/RAN 021810 patch 37 Prevent UNDEFINED errors here -BEGIN
 I $G(ABSBRXR) S ONDATE=$P($G(^PSRX(ABSBRXI,1,ABSBRXR,0)),U)
 ;;IHS/OIT/RAN 021810 patch 37 Prevent UNDEFINED errors here -END
 E  I ABSBRXI S ONDATE=$P(^PSRX(ABSBRXI,2),U,2)
 E  S ONDATE=0
 I 'ONDATE I $G(ABSBVISI) S ONDATE=$P(^AUPNVSIT(ABSBVISI,0),U)\1
 I 'ONDATE S ONDATE=DT
 D GATHER ; PRVT, CAID, and CARE types into ARRAY()
 D SELF ; tack on a SELF PAY at the end
F ;
 ; Now all of the insurances are in the array with initial scores.
 ; Adjust the scores based on the rules in effect for this site.
 ;
 N ORDER,IEN,RULE,ROUTINE,PTSPLUS,PTSMINUS,STOP S (ORDER,STOP)=""
 F  D  Q:ORDER=""
 . S ORDER=$O(^ABSP(9002313.99,1,"INS RULES","B",ORDER))
 . Q:ORDER=""  S IEN=""
 . F  D  Q:IEN=""
 . . S IEN=$O(^ABSP(9002313.99,1,"INS RULES","B",ORDER,IEN))
 . . I IEN="" Q
 . . N X S X=^ABSP(9002313.99,1,"INS RULES",IEN,0)
 . . S RULE=$P(X,U,2),PTSPLUS=$P(X,U,3),PTSMINUS=$P(X,U,4)
 . . S ROUTINE=$TR($P(^ABSPF(9002313.94,RULE,0),U,2),"~","^")
 . . ; these rules are all in ABSPOS26, at least to start with
 . . X "DO "_ROUTINE_"(.ARRAY,ABSBPATI,ABSBVISI,PTSPLUS,PTSMINUS)"
 ;
 ; Finally, put the insurances in order of their scores
 ; IHS/SD/lwj 8/28/02 reversed order of TMP for easier reading
 ; add to comply with Cache systems
 N TMP,I,II,PTS F I=1:1:ARRAY(0) D
 . S PTS=$P(ARRAY(I),U,4)
 . I PTS<0 D  Q  ; negative points and you don't get considered
 . . I $G(DEBUG) W "Not counting ARRAY(",I,")=",ARRAY(I),!
 . ;IHS/SD/lwj 8/28/02 nxt line remarked out - following added
 . ;S TMP(PTS,I)=ARRAY(I)
 . S TMP(0-PTS,I)=ARRAY(I)  ;reverse for Cache 
 K ARRAY
 ;IHS/SD/lwj 8/28/02 Cache cannot handle a reverse $O on arrays
 ; so we reversed the order of the TMP array and can now simply
 ; read it.  The next line was remarked out and the following added.
 ;  S PTS="",II=0 F  S PTS=$O(TMP(PTS),-1) Q:PTS=""  D
 S PTS="",II=0 F  S PTS=$O(TMP(PTS)) Q:PTS=""  D   ;in high to low now
 . S I=0 F  S I=$O(TMP(PTS,I)) Q:'I  D
 . . S X=TMP(PTS,I) Q:$P(X,U,4)<0
 . . S II=II+1,ARRAY(II)=TMP(PTS,I)
 S ARRAY(0)=II
 ; Since we did a NEW() earlier, junk like II, TMP, etc. is deleted.
 Q:$Q ARRAY(0) Q
 ;
GRACE(INSIEN)     ; 
 N RET S RET=$P($G(^ABSPEI(INSIEN,100)),U,8)
 ;IHS/SD/lwj 10/18/04 nxt ln rmkd out, following added
 ;I RET="" S RET=$P($G(^ABSP(9002313.99,"INS")),U)
 I RET="" S RET=$P($G(^ABSP(9002313.99,1,"INS")),U)
 I RET="" S RET=30 ; the default default
 Q RET
SELF ; add SELF PAY to the list
 N INSIEN
 S INSIEN=$P($G(^ABSP(9002313.99,1,0)),U,5)
 I 'INSIEN S INSIEN=$O(^AUTNINS("B","SELF PAY",0))
 I 'INSIEN Q
 D ADD(INSIEN,"SELF PAY","",$$TYPEPTS("SELF"))
 Q
ILCAR() Q $P(^ABSP(9002313.99,1,"A/R INTERFACE"),U)=0 ; is ILC A/R pkg here?
GATHER ; return the count of how many of these we put in the array
 N COUNT,DFN,X S (COUNT,DFN)=0
 F  S DFN=$O(^ABSPCOMB(ABSBPATI,1,DFN)) Q:'DFN  D
 . S X=^ABSPCOMB(ABSBPATI,1,DFN,0)
 . N INSIEN,TYPE S INSIEN=$P(X,U),TYPE=$P(X,U,2)
 . N POINTS S POINTS=$$TYPEPTS(TYPE) ; based on type, how many pts 
 . S POINTS=DFN/10000+POINTS ;higher DFN is most recent, give it an edge
 . S POINTS=POINTS+$P($G(^ABSPEI(INSIEN,104)),U) ; insurer's delta value
 . ; Check RX BILLING STATUS for this insurer - may be "U" = unbillable
 . ; There's also a field in the ^AUPNPRVT record about RX billing
 . ; if it's unbillable for RX, give it a score of -1000
 . ; Keep it in the array because some rules may need to refer to it.
 . ; (Example:  SEARHC0^ABSPOS26)
 . I FORRX,$P($G(^AUTNINS(INSIEN,2)),U,3)="U" S POINTS=-1000
 . I FORRX,'$$DRUGCOVG(ABSBPATI,$P(X,U,10)) S POINTS=-1000
 . I '$$ELGDATE($P(X,U,5,6),INSIEN) D:DEBUG>99  Q  ; it's expired
 . D ADD(INSIEN,$P(X,U,2)_","_$P(X,U,9)_","_$P(X,U,10),DFN,POINTS)
 . S COUNT=COUNT+1
 Q:$Q ARRAY(0) Q
TYPEPTS(TYPE)      ;
 N X S X=$G(^ABSP(9002313.99,1,"INS BASE SCORES"))
 I TYPE="PRVT" Q +$P(X,U)
 I TYPE="CARE" Q +$P(X,U,2)
 I TYPE="CAID" Q +$P(X,U,3)
 I TYPE="RR" Q +$P(X,U,4)
 I TYPE="SELF" Q +$P(X,U,5)
 D IMPOSS^ABSPOSUE("DB","TI","type of insurance",,"TYPEPTS",$T(+0))
 Q 0 ; if you ignore
ELGDATE(FROMTO,INSIEN)          ; does ONDATE fall in the FROM^TO range?
 ; need INSIEN, too!  for $$ADDGRACE
 I DEBUG>99 D
 . N DEBUG S DEBUG=0
 . W "$$ELGDATE(",FROMTO,") testing INSIEN: "_INSIEN_" for ONDATE=",ONDATE,"..."
 . W $$ELGDATE(FROMTO),!
 N FROM,TO S FROM=$P(FROMTO,U),TO=$P(FROMTO,U,2)
 I 'FROM Q 0        ;RLT 21
 I FROM,ONDATE<FROM Q 0
 I 'TO Q 1
 I ONDATE'>TO Q 1
 I $G(INSIEN),ONDATE'>$$ADDGRACE(TO,INSIEN) Q 1
 Q 0
ADDGRACE(X1,INSIEN)     ; add grace period to the given date ; have INSIEN set, too
 N X2,X,%H S X2=$$GRACE(INSIEN) D C^%DTC
 ;I DEBUG W "Added grace period ",$$GRACE(INSIEN)," to ",TO," giving ",X,!
 Q X
 ;
DRUGCOVG(D0,D1)    ;
 I 'D1 Q 1 ; not private?  or no private pointer?
 N X S X=$G(^AUPNPRVT(D0,11,D1,0))
 S X=$P(X,U,3) I 'X Q 1 ; follow coverage to ^AUTTPIC
 ;IHS/SD/lwj patch 13 added $G to next line
 N Y S Y=$P($G(^AUTTPIC(X,0)),U)
 ;I X["INPATIENT ONLY" Q 0
 ;I X["MEDICARE"!(X["PART A")!(X["PART B") Q 0
 ; I X?.E1P1"DENTAL".E Q 0 ; contains DENTAL in its name
 ; I X?1"DENTAL"1P.E Q 0 ; contains DENTAL in its name
 Q 1 ; didn't explictly say it doesn't cover drugs
ADD(INSIEN,PINS,ABSPCOMB,POINTS)   ;
 I $P(PINS,",",3)="" S $P(PINS,",",3)=0
 S ARRAY(0)=ARRAY(0)+1
 S ARRAY(ARRAY(0))=INSIEN_U_PINS_U_ABSPCOMB_U_POINTS
 Q
