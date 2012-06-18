ABSPOS02 ; IHS/FCS/DRS - 9002313.02 utilities ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; General utilities for retrieval from 9002313.02, Claims
 ; Not sure who, if anybody, uses this!
BILLED(N)          ; total amount billed on a given Claim Submission
 ; (up to 4 prescriptions)         
 N RX,TOT S (TOT,RX)=0
 F  S RX=$O(^ABSPC(N,400,RX)) Q:'RX  D
 . S TOT=TOT+$$BILLED1(N,RX)
 Q TOT
BILLED1(N,RX)      ; amount billed on a single Claim Submission
 ; Try Gross Amount Due, and if that's zero, Usual and Customary
 S X=$$430(N,RX)
 I 'X S X=$$426(N,RX)
 Q X
FIRSTRX(N)         Q $O(^ABSPC(N,400,0))
DFF2EXT(X)         Q $$DFF2EXT^ABSPECFM(X)
426(M,N) Q $$400(M,N,26) ; Usual and Customary
430(M,N) Q $$400(M,N,30) ; Gross Amount Due
400(M,N,J)         ; field #400+J signed numeric
 N X S X=$P(^ABSPC(M,400,N,400),U,J)
 I $E(X,1,2)?2U S X=$E(X,3,$L(X))
 S X=$$DFF2EXT(X)
 Q X
