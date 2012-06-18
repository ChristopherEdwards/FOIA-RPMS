BARBLCLC ;IHS/SD/LSL - A/R BILL CALCULATIONS ; 03/04/2010
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**17;OCT 22,2008
 ;;
 ; IHS/ASDS/LSL - 03/04/10 V1.8 Patch 17 - PKD
 ; 	New Routine for Calculated Fields in ^BARBL
 ; 	
CALC(D0) ; Calculated Amount field  PAYMENT - CO-PAY - DEDUCTIBLE
 ; Already have bill ^BARBL(DUZ(2),D0,0) where D0 = Bill Number
 ; ^BARBL(DUZ(2),"AC",D0,DATE.TIME)="" points to-> $P(^BARTR(DUZ(2),DATE.TIME,0),"^")
 ; I $P(^BARTR(DUZ(2),DATE.TIME,0),"^")=40 -  PAYMENT
 N ALWAMT,TRIEN,TCODE,TTCODE,TCR,TDB,T S ALWAMT=""
 S TRIEN="" F  S TRIEN=$O(^BARTR(DUZ(2),"AC",D0,TRIEN)) Q:'TRIEN  D
 . S TCODE=$G(^BARTR(DUZ(2),TRIEN,1))
 . Q:(+TCODE'=40)&(+TCODE'=43)  ; count PAYMENTS & ADJUSTMENTS ONLY
 . S T=$G(^BARTR(DUZ(2),TRIEN,0))
 . S TCR=$P(T,"^",2),TDB=$P(T,"^",3)
 . I +TCODE=43 S TTCODE=$P(TCODE,"^",2) Q:(TTCODE'=13)&(TTCODE'=14)
 . S ALWAMT=ALWAMT+TCR-TDB  ; Add credits / deduct debits for adjustments
 Q ALWAMT
 ; 
