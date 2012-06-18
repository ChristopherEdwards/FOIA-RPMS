ABSPOSIY ; IHS/FCS/DRS - Filing with .51,.59 ;    [ 08/30/2002  10:26 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,34**;JUN 21, 2001
 ; continuation of ABSPOSIZ
 ;----------------------------------------------------------------
 ;IHS/SD/lwj 8/30/02  NCPDP 5.1 changes
 ; With 5.1 came a new way to handle and process the prior authorization
 ; code.  In 3.2, this was very horriably managed in field 416 - it
 ; contained both the type of authorization indicator and the 
 ; authorization number.  In 5.1, field 416 is no longer supported and
 ; the type and number were split into their own fields (fld 461 is 
 ; the type and fld 462 is now the number).  To incorporate this new
 ; change, the screen was altered to prompt for both fields, and 
 ; for now, we will simply concatenate the values to create field 416
 ; for those claims that still use the 3.2 format.
 ; Changes were made to this program to capture the new prior auth
 ; type code in the transaction file.
 ;------------------------------------------------------------------
 Q
IEN59() ;EP - given INPUT(), what should we use for an IEN in file 9002313.59?
 ; It's always a decimal, canonic number.
 ;
 ;For prescriptions and associated postage:
 ;
 ;  Let RXI = prescription ien, pointer to ^PSRX(RXI)
 ;  Let RXR = refill multiple, pointer to ^PSRX(RXI,1,RXR)
 ;      RXR = 0 if this is the first fill
 ;  Let D = 1 if this is a charge for the prescription,
 ;      D = 2 if this is a charge for the postage
 ;  Then $$IEN59 = RXI_"."_$J(RXR,4)_D
 ;  Example:  341641.00001   first fill of #341641
 ;            341641.00002   postage for it
 ;
 ;For non-prescription items:
 ;  Let VSTDFN = visit ien, pointer to ^AUPNVSIT(VSTDFN)
 ;  Let CPTIEN = charge file IEN, pointer to ^ABSCPT(9002300,CPTIEN)
 ;  Then $$IEN59 = VSTDFN_"."_$J(CPTIEN,6)_"3"
 ;
 ;  Example:  if VSTDFN = 1216873 and CPTIEN = 10322,
 ;            1216873.0103223
 ;
 N RXI,RET
 S RXI=$P(INPUT(1),U)
 I RXI D
 . S RXR=$P(INPUT(1),U,2)
 . I RXR>9000 D
 . . D IMPOSS^ABSPOSUE("DB","TI","Refill number near overflow point","RXI="_RXI,"IEN59",$T(+0))
 . ; you can raise the limit and be thinking of how to get around it
 . S RET=RXI_"."_$TR($J(RXR,4)," ","0")
 . S RET=RET_$S($P(INPUT(0),U,3)?1"POSTAGE".E:2,1:1)
 E  D
 . N VIS,CPT S VIS=$P(INPUT(1),U,6),CPT=$P(INPUT(1),U,8)
 . I 'VIS D  ; visit IEN, must not be zero
 . . D IMPOSS^ABSPOSUE("P","TI","Visit IEN missing; should have been detected by now",,"IEN59",$T(+0))
 . . S VIS="MISSING"
 . I 'CPT D  ; CPT IEN, must not be zero
 . . D IMPOSS^ABSPOSUE("P","TI","CPT IEN missing; should have been detected by now",,"IEN59",$T(+0))
 . . S CPT="MISSING"
 . S RET=VIS_"."_$TR($J(CPT,6)," ","0")_3
 Q RET
 ;SETUP59(N,ORIGIN) ;EP - from ABSPOSIZ -  given the INPUT array
SETUP59(N,ORIGIN,ABSPUSR) ;EP - from ABSPOSIZ -  given the INPUT array - IHS/OIT/SCR 082709 patch 34
 ; You don't have to set null fields, so long as you have called
 ; CLEAR, or if this is a NEW entry.
 N FLAGS,FDA,MSG,FN,REC,X,I S FN=9002313.59,REC=N_","
 N TYPE S TYPE=$E(N,$L(N))
 S FDA(FN,REC,.13)=TYPE
 ; TYPE = 1 for prescription, = 2 for mailing prescription,
 ;      = 3 for non-prescription items
 ; FDA(FN,REC,.01) = $P(INPUT(0),U,1) already stored in = field .01
 S FDA(FN,REC,.14)=ORIGIN
 S FDA(FN,REC,6)=ABSPUSR  ;IHS/OIT/SCR 082709 patch 34
 S FDA(FN,REC,1)=0 ; STATUS - waiting to start
 ; Field 1.06 - copied from field 701, below
 S FDA(FN,REC,1.08)=1 ; PINS piece
 I TYPE=1!(TYPE=2) S FDA(FN,REC,1.11)=$P(INPUT(1),U) ; RXI
 ;
 ;IHS/SD/lwj 8/30/02 NCPDP 5.1 changes
 ; the prior authorization code is now two fields - type and number
 ; begin changes to capture both values
 ;
 I $D(INPUT(2)),$P(INPUT(2),U,2)]"" D
 . S FDA(FN,REC,1.09)=$P(INPUT(2),U)    ; prior authorization number 
 . S FDA(FN,REC,1.15)=$P(INPUT(2),U,2)  ; prior auth type code 
 ;
 ;IHS/SD/lwj 8/30/02 end NCPDP 5.1 prior authorization changes
 ;
 S FDA(FN,REC,5)=$P(INPUT(1),U,4) ; Patient
 S FDA(FN,REC,7)=$$NOW ; LAST UPDATE
 S FDA(FN,REC,9)=$P(INPUT(1),U,2) ; RXR - refill index
 I TYPE=1 S FDA(FN,REC,10)=$P(INPUT(0),U,3) ; NDC
 I TYPE=1!(TYPE=2) S FDA(FN,REC,12)=$P(INPUT(1),U,6) ; Visit
 S FDA(FN,REC,13)=DUZ ; USER
 S FDA(FN,REC,15)=FDA(FN,REC,7) ; START TIME
 ;IHS/OIT/SCR 12/09/08 patch 28 SAVE NEW PRICE FIELD 'incentive amount' too
 ;F I=1:1:6 S X=$P($G(INPUT(5)),U,I) I X]"" S FDA(FN,REC,500+I)=X
 F I=1:1:7 S X=$P($G(INPUT(5)),U,I) I X]"" S FDA(FN,REC,500+I)=X
 I $G(INPUT(6))]""!($G(INPUT(7))]"") D
 . F I=1:1:3 D
 . . I $P(INPUT(6),U,I)]"" S FDA(FN,REC,600+I)=$P($G(INPUT(6)),U,I)
 . . I $P(INPUT(7),U,I)]"" S FDA(FN,REC,700+I)=$P($G(INPUT(7)),U,I)
 I $D(FDA(FN,REC,701)) D
 . S FDA(FN,REC,1.06)=FDA(FN,REC,701) ; INSURER
 ; 500's, 600's, 700's done above
 D FILE^DIE("","FDA","MSG") ; NO "E" FLAG - DATA IS IN INTERNAL FORMAT!
 ;I $D(MSG) ZW MSG
 Q $S($D(MSG):0,1:1)
ACTIVEWT(IEN59,IEN51,IEN512) ;EP - from ABSPOSIZ
 ; Return 0 = forget about it, don't wait, just skip this one
 ;        1 = yes, wait and check again in several seconds from now
 ;        
 N PROMPT
 ; An opportunity to wait for the active prescription to finish
 ; processing.  Return 1 if you do want to wait; 0 if you do not. 
 I '$G(ECHO) Q 1  ; not interactive, you can't ask - assume YES, wait
 W ?5,"There is currently an active transaction for this item"
 ;The new IEN59 should decisively say if it's the same date.
 ;N X,Y S X=$P(^ABSPT(IEN59,1),U)
 ;S Y=$P(^ABSP(9002313.51,IEN51,2,IEN512,0),U,8)
 ;I X'=Y W !?5,"though for a different fill date"
 W ".",!
 W ?5,"So this item will be skipped.",! H 1 ; 03/22/2001
 Q 0 ; 03/22/2001
ACWTA S PROMPT="Do you want to wait for the active transaction to finish"
 S Y=$$YESNO^ABSPOSU3(PROMPT,"YES",1) W !
 I Y=1 Q 1
 S PROMPT="Do you want to forget about this one"
 S Y=$$YESNO^ABSPOSU3(PROMPT,"NO",1) W !
 I Y=1 Q 0
 G ACWTA
RXPREV(IEN,ENTRY)  ; has this item previously been through point of sale?
 ; return false if not
 ; return pointer to 9002313.57 if true
 N RXI,RXR,VIS,CPT,INDEX,A,B
 S RXI=$$RXI(IEN,ENTRY)
 I RXI D
 . S RXR=$$RXR(IEN,ENTRY)
 . S INDEX=$S($$NDC(IEN,ENTRY)?1"POSTAGE".E:"POSTAGE",1:"RXIRXR")
 . S A=RXI,B=RXR
 E  D
 . S VIS=$$VIS(IEN,ENTRY)
 . S CPT=$$CPTIEN(IEN,ENTRY)
 . S A=VIS,B=CPT,INDEX="OTHERS"
 Q $O(^ABSPTL("NON-FILEMAN",INDEX,A,B,""),-1)
RXPAID(IEN,ENTRY)  ;EP - from ABSPOSIZ 
 ; return true if the prescription and fill has a "paid"
 ; status as far as point of sale is concerned
 ; A paper claim counts as a point of sale "paid" for this purpose
 ; Return 1 = POS, paid
 ; Return 2 = paper
 N N57 S N57=$$RXPREV(IEN,ENTRY)
 I 'N57 Q ""  ; no point of sale record of this
 ; If it's a reversal, then our result depends on the reversal:
 ;    Was the reversal accepted?   If so, then No, not paid.
 ;    Was the reversal rejected?   Assume Paid, since we try to
 ;         allow reversals only in the case of a paid original.
 I $$ISREVERS^ABSPOS57(N57) Q $S($$REVACC^ABSPOS57(N57):0,1:1)
 ; Not a reversal:
 N X S X=$$CATEG^ABSPOSUC(N57)
 Q $S(X="E PAYABLE":1,X="PAPER":2,X="E DUPLICATE":3,1:0)
RXI(IEN,ENTRY)     Q $P(^ABSP(9002313.51,IEN,2,ENTRY,1),U)
RXR(IEN,ENTRY)     Q $P(^ABSP(9002313.51,IEN,2,ENTRY,1),U,2)
VIS(IEN,ENTRY)     Q $P(^ABSP(9002313.51,IEN,2,ENTRY,1),U,6)
NDC(IEN,ENTRY)     Q $P(^ABSP(9002313.51,IEN,2,ENTRY,0),U,3)
CPTIEN(IEN,ENTRY)  Q $P(^ABSP(9002313.51,IEN,2,ENTRY,1),U,8)
WANTREV()         ;EP - from ABSPOSIZ 
 Q 0 ; TO BE IMPLEMENTED
NOW() N %,%H,%I,X D NOW^%DTC Q %
