ABSPOS03 ; IHS/FCS/DRS - 9002313.03 utilities ;     [ 09/17/2002  10:04 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,42,43**;JUN 21, 2001
 ;-----------------------------------------------------------
 ;IHS/SD/lwj  9/11/02  When running this report, the sites 
 ; were encountering an undefined error.  The error was caused
 ; by insurers being used on claims, and then removed from the 
 ; ABSP INSURER file.  This can only be done by either someone
 ; at the programmer level, or site manager level, and should
 ; not be done.  The fix was to simply $g the retrieval code.
 ;-----------------------------------------------------------
 Q
 ; General utilities for retrieval from 9002313.03, Claim Response
 ; $$INSPAID is used by ABSPOSQL
INSPAID(N)         ;EP - from ABSPOSQL -  total amount paid by insurer
 N RX,TOT,X S (TOT,RX)=0
 F  S RX=$O(^ABSPR(N,1000,RX)) Q:'RX  D
 . ; Try Gross Amount Due, and if that's zero, Usual and Customary
 . S X=$$INSPAID1(N,RX)
 . S TOT=TOT+X
 Q
INSPAID1(N,RX) ;EP -
 N X S X=$$509(N,RX) Q X
NETPAID1(N,RX) ; EP - computed field in 9002313.57
 N X S X=$$509(N,RX) ; X = (#509) Total Amount Paid
 N SUB S SUB=1 ; Do we need to subtract (#505) Patient Pay Amount?
 ;N IEN02,INS,FMT S IEN02=$P(^ABSPR(RESP,0),U)
 N IEN02,INS,FMT S IEN02=$P($G(^ABSPR(RESP,0)),U)
 I IEN02 D
 . ;IHS/SD/lwj 9/11/02 next two lines remarked out - following 2 added
 . ;S INS=$P(^ABSPC(IEN02,0),U,2) Q:'INS   ;IHS/SD/lwj 9/11/02
 . ;S FMT=$P(^ABSPEI(INS,100),U) Q:'FMT    ;IHS/SD/lwj 9/11/02
 . S INS=$P($G(^ABSPC(IEN02,0)),U,2) Q:'INS    ;IHS/SD/lwj 9/11/02
 . ;IHS/OIT/CASSEVER/RAN 03/24/2011 patch 42 Get rid of references to formats for new method of claims processing START
 . ;IHS/OIT/CASSEVERN/RAN 01/09/2012 patch 43, fix use of variable X
 . I $G(^ABSP(9002313.99,1,"ABSPICNV"))=1 D
 . . N X S X=$$GET1^DIQ(9002313.4,INS_",",100.4,"I")
 . . I X S SUB=0
 . ELSE  D
 . . S FMT=$P($G(^ABSPEI(INS,100)),U) Q:'FMT     ;IHS/SD/lwj 9/11/02
 . . N X S X=$P(^ABSPF(9002313.92,FMT,1),U,10)
 . . I X S SUB=0 ; Total paid means total paid by insurance
 I SUB S X=X-$$505(N,RX)
 I X<0,SUB D  ; apparently this format is supposed to be excl.
 . I ($G(^ABSP(9002313.99,1,"ABSPICNV"))=1),IEN02 D
 . . S INS=$P($G(^ABSPC(IEN02,0)),U,2)
 . . S INS(1,9002313.4,INS_",",100.4)=1
 . . D UPDATE^DIE("","INS(1)")
 . ELSE  D
 . . Q:'FMT
 . . S $P(^ABSPF(9002313.92,FMT,1),U,10)=1
 . ;IHS/OIT/CASSEVER/RAN 03/24/2011 patch 42 Get rid of references to formats for new method of claims processing END
 . S X=X+$$505(N,RX) ;*1.26*1*
 Q X
REJTEXT(RESP,POS,ARR) ; EP - fills array (passed by ref)
 K ARR
 N A,I,X,R S (A,I)=0
 F  S A=$O(^ABSPR(RESP,1000,POS,511,A)) Q:'A  D
 . S R=$P(^ABSPR(RESP,1000,POS,511,A,0),U)
 . Q:R=""
 . N S S S=$O(^ABSPF(9002313.93,"B",R,0))
 . I S S X=$TR($G(^ABSPF(9002313.93,S,0)),U,":")
 . E  S X=R_" unrecognized reject code"
 . S I=I+1,ARR(I)=X
 Q
MESSAGE(RESP,POS,N) ; EP - get additional message from response
 I $G(N)=1 Q $P($G(^ABSPR(RESP,1000,POS,504)),U)
 I $G(N)=2 Q $P($G(^ABSPR(RESP,1000,POS,526)),U)
 Q $$MESSAGE(RESP,POS,1)_$$MESSAGE(RESP,POS,2)
DFF2EXT(X)         Q $$DFF2EXT^ABSPECFM(X)
505(M,N) Q $$500(M,N,5) ; Patient Pay Amount
506(M,N) Q $$500(M,N,6) ; Ingredient Cost Paid
507(M,N) Q $$500(M,N,7) ; Contract Fee Paid
508(M,N) Q $$500(M,N,8) ; Sales Tax Paid
509(M,N) Q $$500(M,N,9) ; Total Amount Paid
512(M,N) Q $$500(M,N,12) ; Accumulated Deductible Amount
513(M,N) Q $$500(M,N,13) ; Remaining Deductible Amount
514(M,N) Q $$500(M,N,14) ; Remaining Benefit Amount
517(M,N) Q $$500(M,N,17) ; Amt Applied to Periodic Deduct
518(M,N) Q $$500(M,N,18) ; Amount of Copay/CoInsurance
519(M,N) Q $$500(M,N,19) ; Amt Attrib to Prod Selection
520(M,N) Q $$500(M,N,20) ; Amt Exceed Per Benefit Max
521(M,N) Q $$500(M,N,21) ; Incentive Fee Paid
523(M,N) Q $$500(M,N,23) ; Amount Attributed to Sales Tax
500(M,N,J)         ; field #500+J signed numeric
 Q:'M!'N ""
 N X S X=$P($G(^ABSPR(M,1000,N,500)),U,J)
 I $E(X,1,2)?2U S X=$E(X,3,$L(X))
 S X=$$DFF2EXT(X)
 Q X
