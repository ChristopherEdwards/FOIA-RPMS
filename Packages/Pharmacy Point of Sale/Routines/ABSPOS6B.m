ABSPOS6B ; IHS/FCS/DRS - user display screen, cont ;  
 ;;1.0;PHARMACY POINT OF SALE;*29,31*;JUN 21, 2001
 Q
INFO(PAT,RXI)         ;EP - from ABSPOS6H
 ; IF '$G(RXI), then this is a patient summary line:
 ;   INFO("%")=% completion
 ;   INFO("COUNT")=how many for this patient
 ;   INFO("PATIEN")=ien into patient file
 ;   INFO("STAT",status)=count
 ;   INFO("RES")="- - - 3 prescriptions - - -", for example, if inc.
 ;   but if complete,
 ;   INFO("RES")="* FINISHED * 1 rejected * 2 payable", for example
 ;
 ; If we are going to do prescription detail, then the RESULTS
 ; area for this patient will simply say how many prescriptions
 ; and each individual prescription has its own result detail
 ; But if this is a patient summary with no prescription detail,
 ; then pull all the results together into:
 ; INFO("RES",result code^text)=count
 ;
 ; IF $G(RXI), then this is a prescription detail line
 ;  INFO("DRUG")=drug name
 ;  INFO("RES")=final result or processing status, and presc. #
 ;           (depending on whether status is 100% or not)
 ;  INFO("PATIEN") as above
 ;  INFO("STAT")=processing status (text)
 ;  INFO("DUR")=Brief DUR response info (just conflict and message)
 ;
INFO1 IF $G(RXI) D  Q
 .N REVERSAL S REVERSAL=$G(^ABSPT(RXI,4)) ; is it a rev'l?
 .I 'REVERSAL S REVERSAL=$P(REVERSAL,U,3) ; if not elect, maybe paper
 .N INSURER S INSURER=$P(^ABSPT(RXI,1),U,6)
 .S INSURER=$S(INSURER:$P(^AUTNINS(INSURER,0),U),1:"")
 .; eligibility etc. for SELF PAY reworded during final result
 .; in ABSPOSQ1 and then again for real in billing
 .N IEN52 S IEN52=$P(^ABSPT(RXI,1),U,11)
 .N X
 .I IEN52 D
 . . N RX0 S RX0=$G(^PSRX(IEN52,0)),X=$P(RX0,U,6)
 . . I X]"" S X=$P($G(^PSDRUG(X,0)),U)
 . . I X="" S X="(can't find in DRUG file?)"
 . . I RXI[".",$E(RXI,$L(RXI))=2 S X="Postage-"_X
 .E  D
 . . N CPT S CPT=$P(RXI,".",2),CPT=+$E(CPT,1,$L(CPT)-1)
 . . ; $GET because of timing problem?
 . . S X=$P($G(^ABSCPT(9002300,CPT,0)),U,2) ; short desc
 .S INFO("DRUG")=X,INFO("STAT")=""
 .;I ONEPAT S INFO("STAT")=$$ONEPAT^ABSPOS6C_" " ; dates
 .;I REVERSAL S INFO("STAT")=INFO("STAT")_"*REVERSAL* "
 .S INFO("RES")=INFO("STAT")
 .N STAT S STAT=$P(@DISP@(PAT,RXI),U,2)
 .I STAT=100 D
 . . S INFO("DUR")=$$DURBRIEF^ABSPOS6G(RXI)
 . . I INFO("DUR")]"" S INFO("RES")=INFO("RES")_"DUR! "
 .E  D
 . . S INFO("DUR")=""
 . . S INFO("STAT")=INFO("STAT")_$$STATI^ABSPOSU(STAT)
 .I STAT=31!(STAT=51) D  ; retry due to comms problem or ins. asleep
 . . N X S X=$G(^ABSPT(RXI,8)) Q:X=""
 . . N Y S Y=$P(X,U) X ^DD("DD") S Y=$P(Y,"@",2),X=$P(X,U,2)
 . . S INFO("STAT")=INFO("STAT")_" after "_Y
 . . Q:'X  S X=$P(^ABSP(9002313.55,X,0),U)
 . . I STAT=51 S INFO("STAT")=INFO("STAT")_" to dial out to "_X
 .I INSURER]"" D
 . . N X S X=INFO("STAT")_" "
 . . S X=X_$S(STAT>99:"by",STAT>69:"from",STAT>49:"to",1:"for")
 . . S INFO("STAT")=X_" "_INSURER
 .I STAT=100 D
 . . N X S X=$$RESULT(RXI)
 . . S INFO("RES")=$S(X]"":X,1:"(Missing result?)")
 . E  S INFO("RES")=INFO("STAT")
 .S INFO("RES")=INFO("RES")_" ("_$S(RXI[".":RXI,1:"Prescription `"_RXI)_")"
 .S INFO("PATIEN")=$P(^ABSPT(RXI,0),U,6)
 .I 'INFO("PATIEN") S INFO("PATIEN")=$P($G(^PSRX(IEN52,0)),U,2)
 .I INFO("DUR")]"" S INFO("RES")=INFO("RES")_" DUR:"_INFO("DUR")
 .I REVERSAL S INFO("RES")="*REVERSAL* "_INFO("RES")
 .I ONEPAT S INFO("RES")=$$ONEPAT^ABSPOS6C_" "_INFO("RES")
 .I STAT<99,$G(^ABSPT(RXI,3)) D
 ..S INFO("RES")="*CANCELLATION REQUESTED* "_INFO("RES")
 ;
 ; Else we're doing a patient record:
 ;
INFO6 N X S X=@DISP@(PAT)
 N N,K S (N,INFO("COUNT"))=$P(X,U,4)
 S INFO("%")=$P(X,U,2)/$P(X,U,4)+.5\1
 I INFO("%")=100 D
 .S INFO("RES")="** FINISHED ** "
 .I $P(X,U,5)+$P(X,U,6)+$P(X,U,7)+$P(X,U,8)+$P(X,U,9)'=N D INFO8 ;reCALC
 .S K=$P(X,U,5) I K D  S INFO("RES")=INFO("RES")_K_" rejected  *"
 ..S K=$S(N=1:"",K=N:$S(K=2:"BOTH",1:"ALL"),1:K)
 .S K=$P(X,U,6) I K D  S INFO("RES")=INFO("RES")_K_" not electronic  *"
 ..S K=$S(N=1:"",K=N:$S(K=2:"BOTH",1:"ALL"),1:K)
 .S K=$P(X,U,7) I K D  S INFO("RES")=INFO("RES")_K_" payable  *"
 ..S K=$S(N=1:"",K=N:$S(K=2:"BOTH",1:"ALL"),1:K)
 .S K=$P(X,U,8) I K D  S INFO("RES")=INFO("RES")_K_" rejected reversal *"
 ..S K=$S(N=1:"",K=N:$S(K=2:"BOTH",1:"ALL"),1:K)
 .S K=$P(X,U,9) I K D  S INFO("RES")=INFO("RES")_K_" accepted reversal *"
 ..S K=$S(N=1:"",K=N:$S(K=2:"BOTH",1:"ALL"),1:K)
 .S INFO("RES")=INFO("RES")_"*"
 E  D
 .N N,S ;,C
 .S N=$P(X,U,4),S=$S(N=1:"",1:"s") ;,C=$P(X,U,5)+$P(X,U,6)+$P(X,U,7)
 .S INFO("RES")="     - - - "_N_" prescription"_S_" - - -"
 ; Set DODETAIL=1 if we are doing prescription detail, 0 if not
 N DODETAIL S DODETAIL=1  ;(INFO("COUNT")'<^TMP("ABSPOS",$J,"DETAIL"))
 N RXI,I S RXI="" F I=1:1:INFO("COUNT") D
 .S RXI=$O(@DISP@(PAT,RXI))
 .N IEN52 S IEN52=$P(^ABSPT(RXI,1),U,11)
 .I I=1 D
 . . S INFO("PATIEN")=$P(^ABSPT(RXI,0),U,6)
 . . ;S INFO("PATIEN")=$P($G(^PSRX(IEN52,0)),U,2)
 .I 'DODETAIL D  ; if not doing line item detail, summarize it
 ..S X=$$RESULT(RXI)
 ..I X]"" S INFO("RES",X)=$G(INFO("RES",X))+1
 ..N STAT S STAT=$P(@DISP@(PAT,RXI),U,2),INFO("STAT",STAT)=$G(INFO("STAT",STAT))+1
 Q
INFO8 ; retally the counts of rejected, not electronic, payable
 ; This could be necessary if a prescription was rejected, then
 ; resubmitted with corrections, and then paid - it would have been
 ; counted in two different buckets.
 ; Given X = the current value of @DISP@(PAT)
 ; Fix X and also store the fixed-up version in @DISP@(PAT,RXI)
 S $P(X,U,5,9)="0^0^0^0^0" ; reset the counts
 N RXI S RXI="" F  S RXI=$O(@DISP@(PAT,RXI)) Q:RXI=""  D INFO9
 S @DISP@(PAT)=X
 Q
INFO9 ; Given X, PAT, RXI, @DISP@(PAT,RXI)
 N B S B=$$BUCKET(RXI)
 S $P(X,U,B)=$P(X,U,B)+1
 Q
BUCKET(RXI)        ;EP - from ABSPOS6I
 ; for ^TMP("ABSPOS",$J,"DISP") pieces
 N R S R=$E($$RSPTYP(RXI))
 N V S V=$G(^ABSPT(RXI,4))
 I R="P" Q 7
 I R="" Q 6
 I R="R" Q $S(V:8,1:5)
 I R="A" Q 9
 Q 6  ; NEED A VALID BUCKET, EVEN IF THIS IS THE WRONG ONE
 ; 5 if rejected claim
 ; 6 if other failure
 ; 7 if paid
 ; 8 if rejected reversal
 ; 9 if accepted reversal
RESULT(RXI)        ;EP - from ABSPOSIV
 N REC,RES,M S M=240 S REC(2)=$G(^ABSPT(RXI,2))
 I REC(2)="" Q ""
 N RES S RES=$P(REC(2),U),REC(2)=$P(REC(2),U,2,$L(REC(2),U))
 I RES=1 Q REC(2)
 I RES'=0 Q REC(2)_" (code "_RES_")"
 ; RES=0, good, we can go to the claim response and see what it says
 N RSP D RESPINFO^ABSPOSQ4(RXI,.RSP)
 ; Rework this - 10/28/2000 - because Oklahoma Medicaid seems to 
 ; make Packet Header Rejected, even though the Header is acceptable.
 ; But apparently if all the prescriptions are rejected, they give
 ; you a rejected packet header.  Or maybe if it's a patient-level
 ; problem, they do that.  Anyhow, the change made today is to always
 ; print individual prescription rejection reasons and to push the 
 ; "PACKET HEADER REJECTED" message to the end.
 D  ; 
 .;S RES=RSP("RSP") ; prescription response status
 .S RES=$G(RSP("RSP")) ; prescription response status IHS/OIT/SCR patch 29
 .I RES="Rejected" D
 ..S RES=RES_"("
 ..N I F I=1:1:RSP("REJ",0) D
 ...I I'=1 S RES=RES_","
 ...S RES=RES_RSP("REJ",I)
 ...I $L(RES)>M S RES=$E(RES,1,M)
 ..S RES=RES_")"
 ;I RSP("MSG")]"" S RES=RES_"; "_RSP("MSG") ; and any extra message
 I $G(RSP("MSG"))]"" S RES=RES_"; "_RSP("MSG") ; and any extra message
 ;I RSP("HDR")'="Accepted" D  ;packet header not accepted
 I $G(RSP("HDR"))'="Accepted" D  ;packet header not accepted
 .;I RSP("HDR")="" S RSP("HDR")="?status null?"
 .I $G(RSP("HDR"))="" S RSP("HDR")="?status null?"  ;IHS/OIT/SCR 05/15/09 patch 31
 .S RES=RES_";PACKET HEADER "_RSP("HDR")
 Q $E(RES,1,M)
RSPTYP(RXI)        ; quicker version of RESULT
 ; returns P payable, R rejected, or C or D, or "" if no resp packet
 N RSP D RESPINFO^ABSPOSQ4(RXI,.RSP)
 Q $G(RSP("RSP"))
 ;
