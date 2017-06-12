ABSPOSH6  ;IHS/SD/lwj - NCPDP 5.1 Post 5.1 response [ 09/04/2002  12:57 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,9,39,42,43**;JUN 21, 2001;Build 15
 ;-------------------------------------------------------------
 ; Originally, the entire response was processed in the 
 ; ABSPOSH5 routine - but it exceed SAC limitations on 
 ; routine size - so the processing of some of the transaction 
 ; level information was moved to this routine. Other portions
 ; were moved to the ABSPOSH7 routine.
 ; 
 ; This routine is called solely from ABSPOSH5.
 ;
 ;--------------------------------------------------------------
 ;IHS/SD/lwj 01/22/04 Patch 9
 ; In January 2004, BC/BS Oklahoma and WebMD allowed responses
 ; to be returned that indicated multiple rejection codes, when
 ; in fact only a single rejection code was being returned.  This
 ; caused problems, as we had followed the HIPAA standards that
 ; said that the count should match the number of rejection codes.
 ; While the issue was raised to WebMD that they were out of
 ; compliance, we still made changes to our code just in case
 ; they allowed others through.
 ; The change was originate by POC in Oklahoma.
 ;--------------------------------------------------------------
 ;
 Q
 ;
RESPSTS ;EP  - NCPDP 5.1 response processing (moved from ABSPOSH5)  
 ; called from WRTTRAN^ABSPOSH5
 ; MEDN is set in ABSPOSH5 in the WRTTRAN subroutine
 ; process the response status segment - here's the fields we MIGHT 
 ; encounter:
 ; 112 - transaction response status (mandatory)
 ; 503 - authorization number
 ; 510 - reject count 
 ; 511 - reject code (repeating field)
 ; 546 - reject field occurrence indicator (repeating field)
 ; 547 - approved message code count 
 ; 548 - approved message code (repeating field)
 ; 526 - additional message information
 ; 549 - help desk phone number qualifier
 ; 550 - help desk phone number
 ;
 ; *special note - in 3.2 the transaction response is stored in field
 ; 501 at the prescription level.  In 5.1 that was moved to field 112.
 ; All the reports are based on the 501 field, so to keep things
 ; simple, we will simply update both the 112 and 501 fields with 
 ; the transaction level response status.
 ;
 S $P(^ABSPR(RESPIEN,1000,INDEX,110),U,2)=$G(FDATA("M",MEDN,112))
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U)=$G(FDATA("M",MEDN,112))  ;501
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,3)=$G(FDATA("M",MEDN,503))
 ;
 ; process reject information if there
 S $P(^ABSPR(RESPIEN,1000,INDEX,500),U,10)=$G(FDATA("M",MEDN,510))
 I $D(FDATA("M",MEDN,510)) D REPREJ      ;process the rejection codes
 ;
 ; process approved information if there
 S $P(^ABSPR(RESPIEN,1000,INDEX,540),U,7)=$G(FDATA("M",MEDN,547))
 I $D(FDATA("M",MEDN,547)) D REPAPP      ;process the repeating fld
 ;
 ; finish up with the additional message, and help desk information
 ;IHS/OIT/CASSevern/Pieran/RAN 11-28-2011 42 making field 526 a repeating field
 ;S $P(^ABSPR(RESPIEN,1000,INDEX,526),U)=$G(FDATA("M",MEDN,526))
 I $D(FDATA("M",MEDN,526)) D REPADM      ;process additional messages
 S $P(^ABSPR(RESPIEN,1000,INDEX,540),U,9)=$G(FDATA("M",MEDN,549))
 S $P(^ABSPR(RESPIEN,1000,INDEX,540),U,10)=$G(FDATA("M",MEDN,550))
 ;
 ;
 Q
 ;
REPREJ ; This subroutine will process the reject repeating fields 
 ; that are a part of the status segment.
 ; Two fields here - 511 - Reject Code and
 ;                   546 - Reject field occurrence indicator
 ;
 N CNTR,COUNT,RJCD,RJOC,RLCNT
 ;
 S RLCNT=0
 S COUNT=$G(FDATA("M",MEDN,510))    ;reject count
 Q:COUNT'>0
 ;
 F CNTR=1:1:COUNT  D
 . S (RJCD,RJOC)=""
 . S RJCD=$G(FDATA("M",MEDN,511,CNTR))   ;rejection code
 . ;IHS/OIT/CNI/RAN 5/21/2010 Patch 39 Strip out unwanted spaces being sent by EMDEON
 . S RJCD=$TR(RJCD," ","")
 . S RJOC=$G(FDATA("M",MEDN,546,CNTR))   ;reject fld occurence ind
 . ;IHS/SD/lwj 1/22/04 patch 9 nxt line remarked out, following
 . ; added
 . ;I $D(RJCD) D
 . I $G(RJCD)]"" D
 .. S $P(^ABSPR(RESPIEN,1000,INDEX,511,CNTR,0),U)=RJCD
 .. S ^ABSPR(RESPIEN,1000,INDEX,511,"B",RJCD,CNTR)=""
 . ;IHS/SD/lwj 1/22/04 patch 9 nxt two lns remkd out, nxt 2 added
 . ;S:$D(RJOC) $P(^ABSPR(RESPIEN,1000,INDEX,511,CNTR,0),U,2)=RJOC
 . ;S:(($D(RJOC))!($D(RJCD))) RLCNT=RLCNT+1
 . S:$G(RJOC)]"" $P(^ABSPR(RESPIEN,1000,INDEX,511,CNTR,0),U,2)=RJOC
 . S:(($G(RJOC)]"")!($G(RJCD)]"")) RLCNT=RLCNT+1
 ;
 I RLCNT>0 D
 . S ^ABSPR(RESPIEN,1000,INDEX,511,0)="^9002313.03511A^"_RLCNT_"^"_RLCNT
 ;
 Q
 ;
 ;
REPAPP ; This subroutine will process the approved repeating field 
 ; that is a part of the status segment.
 ; Field 548 - Approved Message Code
 ;
 N CNTR,COUNT,RLCNT,APP
 ;
 S RLCNT=0
 S COUNT=$G(FDATA("M",MEDN,547))    ;approved message code count
 Q:COUNT'>0
 ;
 F CNTR=1:1:COUNT  D
 . S APP=$G(FDATA("M",MEDN,548,CNTR))   ;approved message code
 . I $L(APP) D
 .. S $P(^ABSPR(RESPIEN,1000,INDEX,548,CNTR,0),U)=APP
 .. S ^ABSPR(RESPIEN,1000,INDEX,548,"B",APP,CNTR)=""
 .. S RLCNT=RLCNT+1
 ;
 I RLCNT>0 D
 . S ^ABSPR(RESPIEN,1000,INDEX,548,0)="^9002313.301548A^"_RLCNT_"^"_RLCNT
 ;
 Q
 ;
RESPCLM ;EP  - NCPDP 5.1 response processing (moved from ABSPOSH5)  
 ; called from WRTTRAN^ABSPOSH5
 ; MEDN is set in ABSPOSH5 in the WRTTRAN subroutine
 ; process the response claim segment - here's the fields we MIGHT
 ; encounter:
 ; 455 - prescription/service reference number qualifier
 ; 402 - prescripton/service reference number
 ; 551 - preferred product count
 ; 552 - preferred product id qualifier (repeating)
 ; 553 - preferred product id (repeating)
 ; 554 - preferred product incentive (repeating)
 ; 555 - preferred product copay incentive (repeating)
 ; 556 - preferred product description (repeating)
 ;
 ; start with what are suppose to be mandatory fields
 S $P(^ABSPR(RESPIEN,1000,INDEX,450),U,5)=$G(FDATA("M",MEDN,455))
 S $P(^ABSPR(RESPIEN,1000,INDEX,400),U,2)=$G(FDATA("M",MEDN,402))
 ;
 ; now lets try to process the preferred product repeating fields
 S $P(^ABSPR(RESPIEN,1000,INDEX,550),U)=$G(FDATA("M",MEDN,551))
 I $D(FDATA("M",MEDN,551)) D REPPPD      ;process the repeating fld
 ;
 Q
 ;
REPPPD ; This subroutine will process the preferred product repeating fields 
 ; that are a part of the claim segment.
 ; five fields here- 552 - Preferred product id qualifier 
 ;                   553 - Preferred product id 
 ;                   554 - Preferred product incentive
 ;                   555 - preferred product copay incentive
 ;                   556 - preferred product description
 ;
 N CNTR,COUNT,PPIDQ,PPID,PPINC,PPCOP,PPDESC,CKREC
 ;
 S RLCNT=0
 S COUNT=$G(FDATA("M",MEDN,551))    ;preferred product count
 Q:COUNT'>0
 ;
 F CNTR=1:1:COUNT  D
 . S (PPIDQ,PPID,PPINC,PPCOP,PPDESC)=""
 . S PPIDQ=$G(FDATA("M",MEDN,552,CNTR))  ;preferred product id qual
 . S PPID=$G(FDATA("M",MEDN,553,CNTR))   ;preferred product id
 . S PPINC=$G(FDATA("M",MEDN,554,CNTR))  ;preferred product incentive
 . S PPCOP=$G(FDATA("M",MEDN,555,CNTR))  ;preferred product copay inc
 . S PPDESC=$G(FDATA("M",MEDN,556,CNTR)) ;preferred product desc
 . S CKREC=PPIDQ_PPID_PPINC_PPCOP_PPDESC ;quick chk for values
 . I $D(CKREC) D
 .. S $P(^ABSPR(RESPIEN,1000,INDEX,551.01,CNTR,0),U)=CNTR
 .. S ^ABSPR(RESPIEN,1000,INDEX,551.01,"B",CNTR,CNTR)=""
 .. S RLCNT=RLCNT+1
 . S:$D(PPIDQ) $P(^ABSPR(RESPIEN,1000,INDEX,551.01,CNTR,1),U,1)=PPIDQ
 . S:$D(PPID) $P(^ABSPR(RESPIEN,1000,INDEX,551.01,CNTR,1),U,2)=PPID
 . S:$D(PPINC) $P(^ABSPR(RESPIEN,1000,INDEX,551.01,CNTR,1),U,3)=PPINC
 . S:$D(PPCOP) $P(^ABSPR(RESPIEN,1000,INDEX,551.01,CNTR,1),U,4)=PPCOP
 . S:$D(PPDESC) $P(^ABSPR(RESPIEN,1000,INDEX,551.01,CNTR,1),U,5)=PPDESC
 ;
 I RLCNT>0 D
 . S ^ABSPR(RESPIEN,1000,INDEX,551.01,0)="^9002313.1301A^"_RLCNT_"^"_RLCNT
 ;
 Q
 ;
REPADM ; This subroutine will process the repeating additional message info 
 ; that is a part of the status segment.
 ; Field 526 - Additional Message Information
 ;
 N CNTR,COUNT,RLCNT,MSG
 ;
 S RLCNT=0
 S COUNT=$O(FDATA("M",MEDN,526,""),-1)    ;Additional message count
 Q:COUNT'>0
 ;
 F CNTR=1:1:COUNT  D
 . S MSG=$G(FDATA("M",MEDN,526,CNTR))   ;Additional message
 . I $L(MSG) D
 .. S $P(^ABSPR(RESPIEN,1000,INDEX,526,CNTR,0),U)=MSG
 .. S ^ABSPR(RESPIEN,1000,INDEX,526,"B",MSG,CNTR)=""
 .. S RLCNT=RLCNT+1
 ;
 I RLCNT>0 D
 . S ^ABSPR(RESPIEN,1000,INDEX,526,0)="^9002313.301526A^"_RLCNT_"^"_RLCNT
 ;
 Q
