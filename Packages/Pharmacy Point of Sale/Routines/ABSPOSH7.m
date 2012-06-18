ABSPOSH7  ;IHS/SD/lwj - NCPDP 5.1 Post 5.1 response [ 09/04/2002  10:54 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;-------------------------------------------------------------
 ; Originally, the entire response was processed in the 
 ; ABSPOSH5 routine - but it exceed SAC limitations on 
 ; routine size - so the processing of some of the transaction 
 ; level information was moved to this routine. Other portions
 ; were moved to the ABSPOSH6 routine.
 ; 
 ; This routine is called solely from ABSPOSH5.
 ;
 ;
 Q
RESPPRC ;EP  - NCPDP 5.1 response processing (moved from ABSPOSH5)  
 ; called from WRTTRAN^ABSPOSH5
 ; MEDN is set in ABSPOSH5 in the WRTTRAN subroutine
 ; process the response pricing segment - here's the fields we MIGHT 
 ; encounter:
 ; 505 - patient pay amount
 ; 506 - ingredient code paid
 ; 507 - dispensing fee paid
 ; 557 - tax exempt indicator
 ; 558 - flat sales tax amount paid
 ; 559 - percentage sales tax amount paid
 ; 560 - percentage sales tax rate paid
 ; 561 - percentage sales tax basis paid
 ; 521 - incentive amount paid
 ; 562 - professional service fee paid
 ; 563 - other amount paid count
 ; 564 - other amount paid qualifier (repeating)
 ; 565 - other amount paid (repeating)
 ; 566 - other payer amount recognized
 ; 509 - total amount paid
 ; 522 - basis of reimbursement determination
 ; 523 - amount attributed to sales tax
 ; 512 - accumulated deductible amount
 ; 513 - remaining deductible amount
 ; 514 - remaining benefit amount
 ; 517 - amount applied to periodic deductible
 ; 518 - amount of copay/co-insurance
 ; 519 - amount attributed to product selection
 ; 520 - amount exceeding periodic benefit maximum
 ; 346 - basis of calculation - dispensing fee
 ; 347 - basis of calculation - copay
 ; 348 - basis of calculation - flat sales tax
 ; 349 - basis of calculation - percentage sales tax
 ;
 ; process everything up to the repeating fields
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,5)=$G(FDATA("M",MEDN,505))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,6)=$G(FDATA("M",MEDN,506))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,7)=$G(FDATA("M",MEDN,507))
 S $P(^ABSPR(RESPIEN,1000,INDEX,550),U,7)=$G(FDATA("M",MEDN,557))
 S $P(^ABSPR(RESPIEN,1000,INDEX,550),U,8)=$G(FDATA("M",MEDN,558))
 S $P(^ABSPR(RESPIEN,1000,INDEX,550),U,9)=$G(FDATA("M",MEDN,559))
 S $P(^ABSPR(RESPIEN,1000,INDEX,550),U,10)=$G(FDATA("M",MEDN,560))
 S $P(^ABSPR(RESPIEN,1000,INDEX,560),U)=$G(FDATA("M",MEDN,561))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,21)=$G(FDATA("M",MEDN,521))
 S $P(^ABSPR(RESPIEN,1000,INDEX,560),U,2)=$G(FDATA("M",MEDN,562))
 ;
 ; figure out if we have any of the other paid amount repeating flds
 S $P(^ABSPR(RESPIEN,1000,INDEX,560),U,3)=$G(FDATA("M",MEDN,563))
 I $D(FDATA("M",MEDN,563)) D REPOPA      ;process the repeating flds
 ;
 ; now back to the reqular fields
 S $P(^ABSPR(RESPIEN,1000,INDEX,560),U,6)=$G(FDATA("M",MEDN,566))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,9)=$G(FDATA("M",MEDN,509))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,22)=$G(FDATA("M",MEDN,522))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,23)=$G(FDATA("M",MEDN,523))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,12)=$G(FDATA("M",MEDN,512))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,13)=$G(FDATA("M",MEDN,513))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,14)=$G(FDATA("M",MEDN,514))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,17)=$G(FDATA("M",MEDN,517))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,18)=$G(FDATA("M",MEDN,518))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,19)=$G(FDATA("M",MEDN,519))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,20)=$G(FDATA("M",MEDN,520))
 S $P(^ABSPR(RESPIEN,1000,INDEX,340),U,6)=$G(FDATA("M",MEDN,346))
 S $P(^ABSPR(RESPIEN,1000,INDEX,340),U,7)=$G(FDATA("M",MEDN,347))
 S $P(^ABSPR(RESPIEN,1000,INDEX,340),U,8)=$G(FDATA("M",MEDN,348))
 S $P(^ABSPR(RESPIEN,1000,INDEX,340),U,9)=$G(FDATA("M",MEDN,349))
 ;
 ;
 Q
 ;
 ;
REPOPA ; This subroutine will process the other amount paid repeating fields 
 ; that are a part of the pricing segment.
 ; Two fields here - 564 - other amount paid qualifier 
 ;                   565 - other amount paid
 ;
 N CNTR,COUNT,AMTPDQ,AMTPD,CKREC
 ;
 S RLCNT=0
 S COUNT=$G(FDATA("M",MEDN,563))    ;other amoutn paid count
 Q:COUNT'>0
 ;
 F CNTR=1:1:COUNT  D
 . S (AMTPDQ,AMTPD)=""
 . S AMTPDQ=$G(FDATA("M",MEDN,564,CNTR))  ;other amount paid qual
 . S AMTPD=$G(FDATA("M",MEDN,565,CNTR))   ;other amount paid
 . S CKREC=AMTPDQ_AMTPD                   ;quick chk for values
 . I $D(CKREC) D
 .. S $P(^ABSPR(RESPIEN,1000,INDEX,563.01,CNTR,0),U)=CNTR
 .. S ^ABSPR(RESPIEN,1000,INDEX,563.01,"B",CNTR,CNTR)=""
 .. S RLCNT=RLCNT+1
 . S:$D(AMTPDQ) $P(^ABSPR(RESPIEN,1000,INDEX,563.01,CNTR,1),U,1)=AMTPDQ
 . S:$D(AMTPD) $P(^ABSPR(RESPIEN,1000,INDEX,563.01,CNTR,1),U,2)=AMTPD
 ;
 I RLCNT>0 D
 . S ^ABSPR(RESPIEN,1000,INDEX,563.01,0)="^9002313.1401A^"_RLCNT_"^"_RLCNT
 ;
 Q
 ;
RESPDUR ;EP  - NCPDP 5.1 response processing (moved from ABSPOSH5)  
 ; called from WRTTRAN^ABSPOSH5
 ; MEDN is set in ABSPOSH5 in the WRTTRAN subroutine
 ; process the response DUR segment - here's the fields we MIGHT 
 ; encounter:
 ; 567 - DUR/PPS Response Code counter (repeating)
 ; 439 - reason for service (repeating)
 ; 528 - clinical significance code (repeating)
 ; 529 - other pharmacy indicator (repeating)
 ; 530 - previous date of fill (repeating)
 ; 531 - quanityt of previous fill (repeating)
 ; 532 - database indicator (repeating)
 ; 533 - other prescriber indicator (repeating)
 ; 544 - DUR free text message (repeating)
 ;
 ; All fields on this segment are not only optional, but also
 ; repeating.  Please note that field 567 is NOT a count, but
 ; a counter, which changes how we process this repeating
 ; segment.  Since this entire record is repeating, and the
 ; logic is different, we will keep it here, rather than have
 ; it call a separate repeating subroutine.
 ;
 ;
 N CNTR,RLCNT,RSNCD,CLINCD,OTHPHM,PREVDT,PRVQTY,DBID,OTHPRS,FREETX
 ;
 Q:'$D(FDATA("M",MEDN,567))  ;just quit if there isn't anything
 ;
 S (CNTR,RLCNT)=0
 ;
 F  S CNTR=$O(FDATA("M",MEDN,567,CNTR)) Q:CNTR=""  D
 . ;first lets retrieve the values for this record
 . S RLCNT=RLCNT+1
 . S (RSNCD,CLINCD,OTHPHM,PREVDT,PRVQTY,DBID,OTHPRS,FREETX)=""
 . S RSNCD=$G(FDATA("M",MEDN,439,CNTR))  ;reason for service code 
 . S CLINCD=$G(FDATA("M",MEDN,528,CNTR)) ;clinical significance code
 . S OTHPHM=$G(FDATA("M",MEDN,529,CNTR)) ;other pharmacy indicator
 . S PREVDT=$G(FDATA("M",MEDN,530,CNTR)) ;previous date of fill
 . S PRVQTY=$G(FDATA("M",MEDN,531,CNTR)) ;quantity of previous fill
 . S DBID=$G(FDATA("M",MEDN,532,CNTR))   ;database indicator
 . S OTHPRS=$G(FDATA("M",MEDN,533,CNTR)) ;other prescriber indicator
 . S FREETX=$G(FDATA("M",MEDN,544,CNTR)) ;DUR free text message 
 . ;
 . ; now lets set the response file with the values we just got
 . ; don't forget that we have to hard set the "b" xref too
 . S $P(^ABSPR(RESPIEN,1000,INDEX,567.01,CNTR,0),U)=CNTR
 . S ^ABSPR(RESPIEN,1000,INDEX,567.01,"B",CNTR,CNTR)=""
 . S:$D(RSNCD) $P(^ABSPR(RESPIEN,1000,INDEX,567.01,CNTR,0),U,2)=RSNCD
 . S:$D(CLINCD) $P(^ABSPR(RESPIEN,1000,INDEX,567.01,CNTR,0),U,3)=CLINCD
 . S:$D(OTHPHM) $P(^ABSPR(RESPIEN,1000,INDEX,567.01,CNTR,0),U,4)=OTHPHM
 . S:$D(PREVDT) $P(^ABSPR(RESPIEN,1000,INDEX,567.01,CNTR,0),U,5)=PREVDT
 . S:$D(PRVQTY) $P(^ABSPR(RESPIEN,1000,INDEX,567.01,CNTR,0),U,6)=PRVQTY
 . S:$D(DBID) $P(^ABSPR(RESPIEN,1000,INDEX,567.01,CNTR,0),U,7)=DBID
 . S:$D(OTHPRS) $P(^ABSPR(RESPIEN,1000,INDEX,567.01,CNTR,0),U,8)=OTHPRS
 . S:$D(FREETX) $P(^ABSPR(RESPIEN,1000,INDEX,567.01,CNTR,0),U,9)=FREETX
 ;
 I RLCNT>0 D
 . S ^ABSPR(RESPIEN,1000,INDEX,567.01,0)="^9002313.1101A^"_RLCNT_"^"_RLCNT
 ;
 Q
 ;
 ;
RESPPA ;EP  - NCPDP 5.1 response processing (moved from ABSPOSH5)  
 ; called from WRTTRAN^ABSPOSH5
 ; MEDN is set in ABSPOSH5 in the WRTTRAN subroutine
 ; process the response prior authorization segment - here's the  
 ; fields we MIGHT encounter:
 ; 498.51 - prior authorization processed date
 ; 498.52 - prior authorization effective date
 ; 498.53 - prior authorization expiration date
 ; 498.57 - prior authorization quantity
 ; 498.58 - prior authorization dollars authorized
 ; 498.54 - prior authorization number of refills authorized
 ; 498.55 - prior authorization quantity accumulated
 ; 498.14 - prior authorization number - assigned
 ;
 ; no repeating fields on this segments so we will simply process
 ; what we find
 ;
 S $P(^ABSPR(RESPIEN,1000,INDEX,498),U,1)=$G(FDATA("M",MEDN,498.51))
 S $P(^ABSPR(RESPIEN,1000,INDEX,498),U,2)=$G(FDATA("M",MEDN,498.52))
 S $P(^ABSPR(RESPIEN,1000,INDEX,498),U,3)=$G(FDATA("M",MEDN,498.53))
 S $P(^ABSPR(RESPIEN,1000,INDEX,498),U,7)=$G(FDATA("M",MEDN,498.57))
 S $P(^ABSPR(RESPIEN,1000,INDEX,498),U,8)=$G(FDATA("M",MEDN,498.58))
 S $P(^ABSPR(RESPIEN,1000,INDEX,498),U,4)=$G(FDATA("M",MEDN,498.54))
 S $P(^ABSPR(RESPIEN,1000,INDEX,498),U,5)=$G(FDATA("M",MEDN,498.55))
 S $P(^ABSPR(RESPIEN,1000,INDEX,498),U,6)=$G(FDATA("M",MEDN,498.14))
 ;
 ;
 Q
 ;
