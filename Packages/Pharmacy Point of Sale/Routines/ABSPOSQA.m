ABSPOSQA ; IHS/FCS/DRS - POS background, Part 1 ;   
 ;;1.0;PHARMACY POINT OF SALE;**10,42,43**;JUN 21, 2001
 ;------------------------------------------------
 ;IHS/SD/lwj 03/10/04 patch 10
 ; Routine adjusted to call ABSPFUNC to retrieve
 ; and update Prescription Refill NDC value.  At some
 ; point the call needs to be modified to call APSPFUNC.
 ; See ABSPFUNC for details on why call was done.
 ;------------------------------------------------
 Q
ONE59 ;EP - from ABSPOSQ1
 ; Process this one IEN59 (was status 0, now status 10)
 ; MODULO also comes in from ABSPOSQ1
 ; MODULO,COUNT,ERROR were NEW'ed in ABSPOSQ1
 ;
 S ERROR=0
 N X S X=^ABSPT(IEN59,1)
 N ABSBRXR,ABSBNDC,ABSBRXI
 S ABSBRXR=$P(X,U),ABSBNDC=$P(X,U,2),ABSBRXI=$P(X,U,11)
 I '$D(^PSRX(ABSBRXI,0)) S ERROR=101 G ERRJOIN
 I ABSBRXR,'$D(^PSRX(ABSBRXI,1,ABSBRXR,0)) S ERROR=102 G ERRJOIN
 ;
 I $E(IEN59,$L(IEN59))=1 D  ; if it's a prescription claim,
 . I ABSBNDC]"" D  ; store NDC number if specified in the input
 . . ; store in refill if this is a refill, otherwise store in main
 . . ;IHS/SD/lwj 03/10/04 patch 10, nxt line rmkd out, new line added
 . . ;I ABSBRXR S $P(^PSRX(ABSBRXI,1,ABSBRXR,0),U,13)=ABSBNDC
 . . I ABSBRXR D RFNDC^ABSPFUNC(ABSBRXI,ABSBRXR,ABSBNDC) ;patch 10
 . . ;IHS/SD/lwj 03/10/04 patch 10 end changes
 . . E  S $P(^PSRX(ABSBRXI,2),U,7)=ABSBNDC
 . . ; and now that it's been stored, make it 11N for rest of proc'g
 . . I ABSBNDC'?11N S ABSBNDC=$$NDCF^ABSPECFM(ABSBNDC)
 . E  D  ; NDC number not specified, get it from prescription file
 . . ;IHS/SD/lwj 03/10/04 patch 10, nxt line rmkd out, new line added
 . . ;I ABSBRXR S ABSBNDC=$P(^PSRX(ABSBRXI,1,ABSBRXR,0),U,13)
 . . I ABSBRXR S ABSBNDC=$$NDCVAL^ABSPFUNC(ABSBRXI,ABSBRXR) ;patch 10
 . . ;IHS/SD/lwj 03/10/04 patch 10 end changes
 . . ;IHS/OIT/CASSEVERN/RCS patch43 3/21/2012 Strip out the dashes
 . . E  S ABSBNDC=$P(^PSRX(ABSBRXI,2),U,7),ABSBNDC=$TR(ABSBNDC,"-")
 ;
 ; Set up lots of info about this claim
 ;
 S ERROR=$$CLAIMINF^ABSPOSQB ; set up lots of info about this claim
 I ERROR G ERRJOIN
 ;
 ; After setting up the extra info, update the status
 ; Change status to 30 to say "Ready to be put into a trasmit. packet"
 ;
 ; Check if the drug is billable
 ;
 N INSIEN,DRUGIEN,NDCNUM,BILLABLE,BILLFLAG
 S INSIEN=$P(^ABSPT(IEN59,1),U,6)
 S DRUGIEN=$P(^PSRX(ABSBRXI,0),U,6)
 S NDCNUM=$P(^ABSPT(IEN59,1),U,2)
 ;
ERRJOIN I ERROR D
 . D SETSTAT(99)
 . N ERRTEXT
 . I ERROR=12 S ERRTEXT="PCC Link problem during visit lookup"
 . E  I ERROR=101 S ERRTEXT="Missing ^PSRX("_ABSBRXI_",0)"
 . E  I ERROR=102 S ERRTEXT="Missing ^PSRX("_ABSBRXI_",1,"_ABSBRXR_",0)"
 . E  S ERRTEXT="ERROR - see LOG"
 . D SETRESU2(ERROR,ERRTEXT)
 . D INCSTAT^ABSPOSUD("R",1) ; count how many Unbillable
 E  I '$$BILLABLE D  ; the prescription/fill is marked as Manual bill
 . D SETSTAT(99)
 . D SETRESU2(1,"Prescription is marked for Manual Bill")
 . D INCSTAT^ABSPOSUD("R",1) ; count how many Unbillable
 E  S BILLABLE=$$BILLABLE^ABSPOSQQ(INSIEN,DRUGIEN,NDCNUM) I 'BILLABLE D
 . D LOG^ABSPOSL($P(BILLABLE,U,2))
 . I $$BUMPINS(IEN59) D  ; bump to next insurer
 . . ; loop will pick up this claim again; don't need to task anything
 . E  D  ; no more insurers
 . . D SETRESU2(1,"Unbillable to ins.; "_$$ELGBEN_"; "_$P(BILLABLE,U,2))
 . D INCSTAT^ABSPOSUD("R",1) ; count how many Unbillable
 E  I $$PAPER D
 . D SETSTAT(99)
 . N X,Y
 . S X=$P(^ABSPT(IEN59,1),U,6)
 . S Y=$S(X:$P(^AUTNINS(X,0),U),1:"")
 . I Y="SELF PAY"!(Y="") D
 . . S X="No insurance,"_$$ELGBEN
 . E  S X="Paper claim to "_$P(^AUTNINS(X,0),U)
 . D SETRESU2(1,X) ; or statement or writeoff, to be det.
 . D LOG^ABSPOSL(X)
 . D INCSTAT^ABSPOSUD("R",1) ; count how many Unbillable
 E  D  ; it's an electronic claim
 . N STAT S STAT=30 ; new status will be 30 usually, or maybe 99 or 19
 . I $P($G(^ABSP(9002313.99,1,"SPECIAL")),U) D
 . . ; The special Oklahoma Medicaid rule is in effect
 . . ; so hold Oklahoma Medicaid prescriptions a little longer
 . . N INS S INS=$P(^ABSPT(IEN59,7),U)
 . . I INS=$P(^ABSP(9002313.99,1,"SPECIAL"),U) S STAT=19
 . D SETSTAT^ABSPOSQ1(STAT)
 ;
 ; Every so often, start up a packeter.
 ; We hope that for patients with many prescriptions,
 ; they'll be bundled into single packets.
 ;
 I COUNT#MODULO=0 D PACKETER^ABSPOSQ1 ; start one up every Nth claim 
 ;
 Q
ELGBEN() ; construct ELG_","_BEN string ; given IEN59
 N BEN,ELG,Y,I,X
 S X=$P(^ABSPT(IEN59,0),U,6)
 S X=$P($G(^AUPNPAT(X,11)),U,11,12)
 I X="1^C"!(X="1^D") Q "Native ben."
 S BEN=$P(X,U),ELG=$P(X,U,2)
 I BEN S BEN=$P($G(^AUTTBEN(BEN,0)),U)
 S X=$P(^DD(9000001,1112,0),U,3) ; set of codes detail
 F I=1:1:$L(X,";") S Y=$P(X,";",I) I ELG=$P(Y,":") S ELG=$P(Y,":",2) Q
 Q ELG_","_BEN
BUMPINS(IEN59) ;EP - ABSPOSQS
 ; bump up to the next insurer
 ; When you call this, be sure you have the logging slot set to
 ; the current prescription.
 N INSIEN,MSG,PINPIECE,OLDINS ; return value is next insurer
 S PINPIECE=$P(^ABSPT(IEN59,1),U,8)+1
 I PINPIECE>$L($G(^ABSPT(IEN59,6)),U) S INSIEN=0
 E  S INSIEN=$P(^ABSPT(IEN59,7),U,PINPIECE)
 S OLDINS=$P(^ABSPT(IEN59,1),U,6)
 I 'OLDINS Q 0 ; we were already at the "no insurance" case
 S $P(^ABSPT(IEN59,1),U,6)=INSIEN
 S $P(^ABSPT(IEN59,1),U,8)=PINPIECE
 I INSIEN D
 . S MSG="Bump from insurer "_$$INSNAME(OLDINS)_" to "_$$INSNAME(INSIEN)
 . I '$P($G(^ABSPT(IEN59,5)),U,6) D  ; if price autocalc'd,
 . . K ^ABSPT(IEN59,5) ; delete old insurer's pricing
 . D SETSTAT^ABSPOSQ1(0) ; recompute the claim
 ;E  D
 I 'INSIEN D
 . D SETSTAT^ABSPOSQ1(99) ; processing has gone as far as it can
 . S MSG="Insurer "_$$INSNAME(OLDINS)_" was the last one."
 D LOG^ABSPOSL(MSG)
 Q INSIEN
INSNAME(N)         I 'N Q "(no more insurances)"
 Q $P($G(^AUTNINS(N,0)),U)
BILLABLE()         ; per field 9999999.07 ; only at Pawhuska in the beginning
 N RESULT
 I ABSBRXR S RESULT=$P($G(^PSRX(ABSBRXI,1,ABSBRXR,9999999)),U,7)
 E  S RESULT=$P($G(^PSRX(ABSBRXI,9999999)),U,7)
 I RESULT="" S RESULT=1 ; default to billable
 I 'RESULT D  ; Manual Bill is indicated in prescription file.
 . N X S X=$P(^ABSPT(IEN59,0),U,14) ; ORIGIN
 . I X=2!(X=3) S RESULT="1^Manual input, okay" Q
 . S RESULT="0^Manual Bill is indicated in prescription file."
 Q RESULT
 ;IHS/OIT CASSEVERN/RCS patch 43 3/7/2012 Added Billing Flag Check
BILLFLAG(INS)         ; per field .23 of ^AUTNINS
 N RESULT,CUR
 S RESULT=1
 I 'INS Q RESULT
 S CUR=$P($G(^AUTNINS(INS,2)),U,3) ; current value
 I CUR'="P" S RESULT=0
 Q RESULT
FLAG23(INS,VAL) ; change field .23 of ^AUTNINS to appropriate value if needed
 ; A recent patch issued by (who? 3PBilling?) has a "P" value they want
 N CUR S CUR=$P($G(^AUTNINS(INS,2)),U,3) ; current value
 I VAL="P" D  ; make sure "P" is supported (recent patch they issued)
 . I $P($G(^DD(9999999.18,.23,0)),U,3)'["P:" S VAL="" ; nope, not yet
 I CUR=VAL Q  ; already set the value we want
 ;IHS/OIT CASSEVERN/RCS patch43 3/7/2012 Added 'O' and null so flag will not change
 I CUR="U"!(CUR="O")!(CUR="") Q  ; currently set to Unbillable for drugs? Can't be.
 N FDA,MSG ; okay, we're going to change it
 S FDA(9999999.18,INS_",",.23)=VAL
F23A D FILE^DIE(,"FDA","MSG")
 Q:'$D(MSG)  ; success
 D ZWRITE^ABSPOS("FDA","MSG")
 G F23A:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"FLAG23",$T(+0))
 Q
PAPER() ; Return TRUE if this has to be sent as a paper claim.
 ; Also take care of the ^AUTNINS field .23 flag "P" value
 N INSURER,FORMAT,ACTDATE,FLAG23,BIN
 S INSURER=+$P($G(^ABSPT(IEN59,1)),U,6)
 ;IHS/OIT/CASSEVERN/RAN patch42 3/31/2011 Added to prevent undefined error when insurer doesn't exist in ABSP INSURER file
 ;IHS/OIT/CASSEVERN/RCS patch43 3/2/2012 Moved variable set to fix If/Else problem in Patch 42
 Q:'$D(^ABSPEI(INSURER)) 1
 S (FORMAT,ACTDATE,FLAG23)=""
 I INSURER D
 . S FORMAT=$P($G(^ABSPEI(INSURER,100)),U),BIN=$P($G(^ABSPEI(INSURER,100)),U,16)
 . S BILLFLAG=$$BILLFLAG(INSURER) I 'BILLFLAG S BIN="" ;IHS/OIT/CASSEVERN/RCS patch 43 3/21/2012 Check the Insurance flag if set as unbillable
 . ;IHS/OIT/CASSEVERN/RCS patch 43 3/2/2012 Make sure if no BIN then FORMAT="", not real ins
 . I FORMAT,'BIN,$G(^ABSP(9002313.99,1,"ABSPICNV"))=1 S FORMAT=""
 . ;IHS/OIT/CASSEVERN/RAN patch42 3/30/2011 Added to prevent claims without format from going paper
 . ;IHS/OIT CASSEVERN/RCS patch43 12/23/2011 Added BIN check to make sure valid Insurer
 . I 'FORMAT,BIN,$G(^ABSP(9002313.99,1,"ABSPICNV"))=1 S FORMAT=1	
 . S ACTDATE=$P($G(^ABSPEI(INSURER,100)),U,3)
 . S FLAG23=$P($G(^AUTNINS(INSURER,2)),U,3)
 I FORMAT,ACTDATE'>DT D  ; yes, this insurer is billed electronically
 . D FLAG23(INSURER,"P")
 E  D
 . Q:'INSURER  ; uninsured
 . D FLAG23(INSURER,"")
 I 'FORMAT Q 1 ; not an electronic insurer
 I ACTDATE>DT Q 1 ; not activated until some future date
 ; Looks like it's electronic but 
 ; test some more (maybe electronic for presc. but paper for postage)
 G @("PAPER"_$$TYPE^ABSPOSQ)
PAPER1 ; prescription
 N P S P=$P(^ABSPT(IEN59,5),U,5) ; price
 I P>0,P<10000 Q 0  ; make sure positive, and < $10000 (6 digits limit)
 Q 1  ; otherwise, must go via paper
PAPER2 ; postage - depends on insurer and amount
 N X S X=$G(^ABSPEI(INSURER,102))
 I X="" Q 1  ; doesn't handle postage, must send by paper
 I '$$RXI^ABSPOSQ,'$P(X,U,3) Q 1  ; supplies postage not allowed in POS
 N AMT S AMT=$$AMT^ABSPOSQ
 I $P(X,U,2)]"",AMT>$P(X,U,2) Q 1  ; exceeds maximum postage amount
 Q 0  ; meets requirements for POS billing
PAPER3 ;
 N X S X=$G(^ABSPEI(INSURER,103))
 I X="" Q 1  ; doesn't handle supplies, must send by paper
 Q 0  ; does handle supplies (as of 06/21/2000, we know of none that do)
SETSTAT(X)         D SETSTAT^ABSPOSQ1(X) Q
SETRESU(RESCODE)   ;
 N ABSBRXI S ABSBRXI=IEN59 ; unfortunate variable name convention
 D SETRESU^ABSPOSU(RESCODE) ;
 Q
SETRESU2(RESCODE,RESTEXT)    ;
 N ABSBRXI S ABSBRXI=IEN59 ; unfortunate variable name convention
 D SETRESU^ABSPOSU(RESCODE,RESTEXT)
 Q
