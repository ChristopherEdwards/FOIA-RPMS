ABSPOSBF ; IHS/FCS/DRS - ILC/AR comments in 9002302 ; 
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
COMMENT(PCNDFN,COMMENT,DATE) ;EP - add a brief comment
 ; If you call it with $$, it returns pointer to the comment
 ; If it fails, the $$ returns false
 ; in ^ABSBITMS(9002302,PCNDFN,"MSG",*)
 N FDA,IEN,MSG,FN S FN=9002302.082
 N X S X="+1,"_PCNDFN_","
 S FDA(FN,X,.01)="NOW"
 N MAX S MAX=45 ; from ^DD(9002302.082,.03)
 I $L(COMMENT)>MAX S COMMENT=$E(COMMENT,1,MAX-3)_"..."
 S FDA(FN,X,.03)=COMMENT
 I $D(DATE) S FDA(FN,X,.04)=DATE
 D UPDATE^DIE("E","FDA","IEN","MSG")
 ;I $D(FDA) ZW FDA
 ;I $D(IEN) ZW IEN
 ;I $D(MSG) ZW MSG
 I $D(MSG) D
 . D LOG^ABSPOSL("COMMENT^"_$T(+0)_" failed for PCNDFN="_PCNDFN)
 . D LOGARRAY^ABSPOSL("MSG")
 Q:$Q $G(IEN(1)) Q
COMMWP(PCNDFN,COMMIEN,ROOT)        ;
 N FDA,IEN,MSG,FN S FN=9002302.082
 D WP^DIE(FN,COMMIEN_","_PCNDFN_",",1,"K",ROOT,"MSG")
 I $D(MSG) D
 . D LOG^ABSPOSL("COMMWP^"_$T(+0)_" failed for PCNDFN="_PCNDFN_",COMMIEN="_COMMIEN)
 Q:$Q '$D(MSG) ; so it returns true if success, false if failure
 Q
REJECTS(PCNDFN,COMMENT,ARRAY57)        ;EP
 ; Add a comment and then make extended remarks based on claims
 ; in ARRAY57(*).  Returns true/false (did it work?)
 N COMM ; COMM = Pointer: ^ABSBITMS(9002302,PCNDFN,"MSG",COMM)
 S COMM=$$COMMENT(PCNDFN,COMMENT) ; add the general comment, first
 I 'COMM Q 0
 ; and now deal with the details of the rejection
 K ^TMP($J,$T(+0)) N LINE S LINE=0
 N N57,FIRST S N57=0,FIRST=1
 F  S N57=$O(ARRAY57(N57)) Q:'N57  D REJ1 S FIRST=0
 ; Store the word processing field
 N OK S OK=$$COMMWP(PCNDFN,COMM,"^TMP("_$J_","""_$T(+0)_""")")
 Q OK
REJ1 N R0,R1 S R0=^ABSPTL(N57,0),R1=^(1)
 N INSDFN S INSDFN=$P(R1,U,6)
 N INSNAME S INSNAME=$P(^AUTNINS(INSDFN,0),U)
 N RXI S RXI=$P(R0,U)
 N DRGDFN S DRGDFN=$P(^PSRX(RXI,0),U,6)
 N DRGNAME S DRGNAME=$P(^PSDRUG(DRGDFN,0),U)
 N NDC S NDC=$P(R1,U,2),NDC=$$FORMTNDC^ABSPOS9(NDC)
 N CLAIM S CLAIM=$P(R0,U,4)
 N CLAIMID S CLAIMID=$P(^ABSPC(CLAIM,0),U)
 N RESP S RESP=$P(R0,U,5)
 N POS S POS=$P(R0,U,9)
 N TIME,Y S Y=$P(^ABSPR(RESP,0),U,2) X ^DD("DD") S TIME=Y
 D REJX(CLAIMID_"#"_POS_" for "_NDC_" "_DRGNAME)
 D REJX("Rejected by "_INSNAME_" on "_TIME)
 N MSG1 S MSG1=$P($G(^ABSPR(RESP,1000,POS,504)),U)
 I MSG1]"" D REJX(MSG1)
 N MSG2 S MSG2=$P($G(^ABSPR(RESP,1000,POS,526)),U)
 I MSG2]"" D REJX(MSG2)
 N REJ S REJ=""
 F  S REJ=$O(^ABSPR(RESP,1000,POS,511,"B",REJ)) Q:REJ=""  D
 . N MSG S MSG="/"_REJ_" "_$P($G(^ABSPF(9002313.93,REJ,0)),U,2)
 . D REJX(MSG)
 Q
REJX(X) S LINE=LINE+1,^TMP($J,$T(+0),LINE)=X Q  ; used by other subrous, below
 ; Observe:  what we just did lists every rejected claim with
 ; every rejection reason.  It would be nice to cleverly group
 ; things, e.g., to say ALL rejected because of M/I CARDHOLDER NUMBER
 ;
 ; Design for making intelligent comments about rejected claims:
 ;
 ; Build 
 ;  @TMP=count^$ amt of original claims
 ;  @TMP@(N)=drug name
 ;  @TMP@(N,0)=the message from the response packet
 ;  @TMP@(N,reason code)=""
 ;
 ;  @TMP1@(reason code)=count of rejects with this reason ^ reason text
 ;  @TMP1@(reason code,N)="" point back to @TMP@(N)
 ;
 ;  @TMP2@(message)=count
 ;  @TMP2@(message,N)=""   point back to @TMP@(N)
 ;
 ;  @TMP3@($P(ClaimID,"-",1,2),$P(ClaimID,"-",3))=""
 ;      well no, that's already done by the COMMENT we had coming in
 ;
 ;  Then the general form is   <X> REJECTED by <insurer> <Y>
 ; where <X> is either the Drug name or a count of how many
 ;  or the word ALL or BOTH
 ;
 ;  and <Y> is either   : <reasons>
 ;     or :see Claim ID xxxxx
 ;
LIST57(PCNDFN,COMMENT,ARR57) ;EP -
 ; Comment is a list of file 9002313.57 transaction
 ; numbers.  This paragraph is a copy of what's at REJECTS
 N COMM ; COMM = Pointer: ^ABSBITMS(9002302,PCNDFN,"MSG",COMM)
 S COMM=$$COMMENT(PCNDFN,COMMENT) ; add the general comment, first
 I 'COMM Q 0
 ; and now deal with the details of the rejection
 K ^TMP($J,$T(+0)) N LINE S LINE=0
 N N57,FIRST S N57=0,FIRST=1
 F  S N57=$O(ARR57(N57)) Q:'N57  D LIST571 S FIRST=0
 ; Store the word processing field
 N OK S OK=$$COMMWP(PCNDFN,COMM,"^TMP("_$J_","""_$T(+0)_""")")
 Q OK
LIST571 ;
 N R0,R1 S R0=^ABSPTL(N57,0),R1=^ABSPTL(N57,1)
 ; List the transaction #, the claim ID, the position in the claim
 N LAST S LAST=($O(ARR57(N57))="")
 N CLAIM S CLAIM=$P(R0,U,4)
 N CLAIMID,POS
 I CLAIM D
 . S CLAIMID=$P($G(^ABSPC(CLAIM,0)),U),POS=$P(R0,U,9)
 E  S CLAIMID="",POS=""
 N X S X="File 9002313.57 transaction number "_N57
 I CLAIMID]"" S X=X_", Claim ID "_CLAIMID_", position "_POS
 I ARR57(N57)]"" D
 . S X=X_" superseded transaction number "_ARR57(N57)
 I 'LAST S X=X_" / "
 D REJX(X)
 Q
PAYABLE(PCNDFN,COMMENT,ARR57) ;EP - comment on what was paid and how much $$
 ; this paragraph is a copy of what's a REJECTS
 ; with a little bit extra for $ amounts
 ; Also, order of things is switched a little
 K ^TMP($J,$T(+0)) N LINE S LINE=0
 N N57,FIRST S N57=0,FIRST=1
 N PAY ; PAY(*) accumulators
 F  S N57=$O(ARR57(N57)) Q:'N57  D PAY1 S FIRST=0  ; fill the PAY array
 I '$D(PAY) D  Q 0
 . D LOG^ABSPOSL("ERROR - no PAY(*) data? on PCNDFN="_PCNDFN)
 N COMM ; COMM = Pointer: ^ABSBITMS(9002302,PCNDFN,"MSG",COMM)
 S COMM=$$COMMENT(PCNDFN,COMMENT) ; add the general comment, first
 I 'COMM Q 0
 I $G(PAY("00.09 POS Paid"))=$G(PAY("00 POS Billed")) D
 . K PAY("00 POS Billed") ; since it's the same amount
 N X,FIRST S FIRST=1 S X="" F  S X=$O(PAY(X)) Q:X=""  D
 . Q:'PAY(X)  ; don't report zero amounts
 . N % S %=$P(X," ",2,$L(X," "))
 . S %=%_":$"_$J(PAY(X),0,2)
 . I FIRST S FIRST=0
 . E  S %="; "_%
 . D REJX(%)
 ; Store the word processing field
 ;N TMPDBG M TMPDBG=^TMP($J,$T(+0)) ZW TMPDBG R ">>>",%,!
 N OK S OK=$$COMMWP(PCNDFN,COMM,"^TMP("_$J_","""_$T(+0)_""")")
 Q OK
PAY1 ; payment details for transaction N57
 N R0,R1,R5 S R0=^ABSPTL(N57,0),R1=^(1),R5=^(5)
 D ADDPAY("00 POS Billed",$P(R5,U,5))
 N RESP S RESP=$P(R0,U,5)
 N POS S POS=$P(R0,U,9)
 N AMTS S AMTS=^ABSPR(RESP,1000,POS,500)
 D PAY2("00.09 POS Paid",9) ; first " " piece controls order
 D PAY2("05 Patient Pay",5)
 ;D PAY2("07 Contract Fee Paid",7)
 D PAY2("18 Copay",18)
 Q
PAY2(CATEG,AMTSPCE)          ;
 N AMT S AMT=$P(AMTS,U,AMTSPCE) Q:AMT=""
 S AMT=$$DFF2EXT^ABSPECFM(AMT)
 D ADDPAY(CATEG,AMT)
 Q:$Q AMT Q
ADDPAY(CATEG,AMOUNT) S PAY(CATEG)=$G(PAY(CATEG))+AMOUNT Q
