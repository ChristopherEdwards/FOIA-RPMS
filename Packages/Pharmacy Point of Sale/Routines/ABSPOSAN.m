ABSPOSAN ; IHS/FCS/DRS - Cancellation ;   [ 09/12/2002  10:05 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ;
 ; CANCEL:  See any of CLAIMIEN's claims have been marked for
 ;   cancellation.  If so, we don't want to send the claim.
 ;  Called from GETNEXT^ABSPOSAP.
 ;
CANCEL() ;EP - Deal with Cancellations in CLAIMIEN
 N RXI,CXL,KEEP S RXI="",(CXL,KEEP)=0
 N OLDSLOT S OLDSLOT=$$GETSLOT^ABSPOSL
 F  S RXI=$O(^ABSPT("AE",CLAIMIEN,RXI)) Q:RXI=""  D
 .I $G(^ABSPT(RXI,3)) S CXL=CXL+1 Q
 I 'CXL Q 0  ; none being canceled
 ; At least one being canceled
 ; The canceled one gets stamped as finished
 ; The others get sent back to status 30, Waiting for packet build
 S RXI="" F  S RXI=$O(^ABSPT("AE",CLAIMIEN,RXI)) Q:RXI=""  D
 .N ABSBRXI S ABSBRXI=RXI ; as some called subroutines expect it
 .D SETSLOT^ABSPOSL(ABSBRXI)
 .I $G(^ABSPT(RXI,3)) D
 ..D DOCANCEL(RXI) ; cancel this claim
 .E  D  ; send this claim back to status 30
 ..S KEEP=KEEP+1
 ..D SETSTAT^ABSPOSU(30)
 ..D LOG(CXL_" claim"_$S(CXL>1:"s",1:"")_" in the transmit packet were canceled; this claim was requeued.")
 ; Finally, rev up a packeter to make sure that any surviving claims
 ; get another chance
 I KEEP D PACKETER^ABSPOSQ1 ; ensure surviving claims get repacketed
 D SETSLOT^ABSPOSL(OLDSLOT)
 Q CXL
 ;
 ;
DOCANCEL(IEN59) ; actually do the cancellation
 ; This may be called from other places.
 N BYDUZ S BYDUZ=$P(^ABSPT(IEN59,3),U)
 N MSG S MSG=RXI_" CANCELED by "_DUZ_" "_$P($G(^VA(200,BYDUZ,0)),U)
 N OLDSLOT S OLDSLOT=$$GETSLOT^ABSPOSL
 D SETSLOT^ABSPOSL(IEN59)
 D LOG(MSG)
 D RELSLOT^ABSPOSL
 I OLDSLOT D SETSLOT^ABSPOSL(OLDSLOT)
 ; In field 302, put the status of the claim at the time it was canceled
 ; Test:  I field 302 ]"", then the claim was successfully canceled.
 S $P(^ABSPT(IEN59,3),U,2)=$P(^ABSPT(IEN59,0),U,2)
 D SETSTAT^ABSPOSU(99)
 D SETRESU^ABSPOSU(-1,MSG)
 Q
LOG(X) D LOG^ABSPOSL($T(+0)_" - "_X) Q
