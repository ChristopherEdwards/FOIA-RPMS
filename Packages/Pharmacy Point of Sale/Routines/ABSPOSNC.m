ABSPOSNC ; IHS/FCS/DRS - PHARmacy POS interface query from without ;  
 ;;1.0;PHARMACY POINT OF SALE;*40*;JUN 21, 2001
 ;Target audience: the ANMC Nightly Checker
 ; Also, charge entry (At least at Sitka)
 ; May also be Ud by RXE,PAY option
 ; and who knows what else?
 Q
 ;
VMEDPAID(VMEDIEN)  ; $$VMEDPAID^ABSPOSNC(pointer to V MEDICATION)
 ; Returns   TruthValueResult^PSRX ien^remarks
 ; True result I claim was paid (and not reversed)
 ; False result I claim was no paid (or was paid and reversed)
 ;
 I VMEDIEN'?1.10N Q "0^^invalid VMEDIEN argument"
 N RXIEN S RXIEN=$O(^PSRX("APCC",VMEDIEN,0))
 I 'RXIEN Q "0^^VMEDIEN not found in PSRX(""APCC"" INDEX"
 Q $$RXPAID(RXIEN)
 ;
RXPAID(RXI,RXR) ;EP - $$RXPAID^ABSPOSNC(pointer to 9002313.59 or to 52) 
 ; Returns: as desribed above F VMEDPAID
 ; First, compute IEN59
 N IEN59,RETVAL
 I RXI["." D
 . S IEN59=RXI
 . N X S X=$P(IEN59,".",2)
 . I $E(X,$L(X))'=1 D  Q  ; think through postage, supplies later
 . . D IMPOSS^ABSPOSUE("P","TI","postage/supplies not supported yet",,"RXPAID",$T(+0))
 . S X=$E(X,1,$L(X)-1) ; remove trailing 1 - should leave RXR
 . S RETVAL="0^"_$P(IEN59,".")_","_X
 E  D
 . I '$D(RXR) S RXR=$$RXRDEF^ABSPOSRX(RXI)
 . S IEN59=$$IEN59^ABSPOSRX(RXI,RXR)
 . S RETVAL="0^"_RXI_","_RXR
 ; Now, find out what happened to it.
 I $D(^ABSPT(IEN59,0)) D
 . I $P($G(^ABSPT(IEN59,3)),U,2) D
 . . S $P(RETVAL,U,3)="Canceled"
 . E  I '$P(^ABSPT(IEN59,0),U,4) D
 . . S $P(RETVAL,U,3)="No POS claim sent"
 . E  I '$P(^ABSPT(IEN59,0),U,5) D
 . . S $P(RETVAL,U,3)="No POS response received"
 . E  D  ; yes, we did get a claim-response cycle
 . . N X D RESPINFO^ABSPOSQ4(IEN59,.X)
 . . ;IHS/OIT/CNI/SCR 08/17/10 patch 40 avoid undefined error START
 . . ;S $P(RETVAL,U,3)=X("RSP")
 . . S $P(RETVAL,U,3)=$G(X("RSP"))
 . . Q:'$G(X("RSP"))
 . . ;IHS/OIT/CNI/SCR 08/17/10 patch 40 avoid undefined error END
 . . I X("RSP")="Payable" S $P(RETVAL,U)=1
 . . I X("RSP")="Captured" S $P(RETVAL,U)=1 ; 03/13/2001
 . . I X("RSP")="Rejected reversal" S $P(RETVAL,U)=1
 E  D
 . S $P(RETVAL,U,3)="No POS record of prescription"
 Q RETVAL
