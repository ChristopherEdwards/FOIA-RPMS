ABSPOSH5 ; IHS/SD/lwj - Post 5.1 Claim Response ;8/7/02 [ 09/04/2002  12:57 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;File FDATA() Array Data in Claim Response File (9002313.03)
 ;
 ;Parameters:  RESPIEN  - Claim Response Record IEN (9002313.03)
 ;---------------------------------------------------------------------
 ; Called from ABSPOSH4 from ABSPECA4 from ABSPOSQL from ABSPOSQ4
 ;
 ;---------------------------------------------------------------------
 ; IHS/SD/lwj 8/7/02  NCPDP 5.1 changes
 ; NCPDP 5.1 response segments are completely different from 3.2
 ; response segments, and as such many new fields had to be added
 ; to ABSPR to store the information coming back. (52 new flds added) 
 ; (There were several significant differences in the parsing of 
 ;  data from a 3.2 response and a 5.1 response - please refer to
 ;  ABSPOSH4 for details regarding the parsing.)
 ; The purpose of this routine is to load the information from a 5.1
 ; response into the ^ABSPR global after the parsing is complete.
 ;(please see ABSPECA5 for the storing of information from a 3.2
 ; claim into ^ABSPR)
 ;
 ; Of interest - in 3.2, if the response was for a duplicate, the
 ; information for the response was duplicated in the Response subfile,
 ; on node 1000, in addition to be stored in node 500 and 504.
 ; With 5.1 being so much different, the node 1000 on the subfile
 ; will not be populated since the information is stored at all the
 ; other nodes.
 ;
 ; Special Note - The values are hard set into the ABSP response 
 ; file within this routine and cross references are rebuilt 
 ; manually.  While this is not considered the optimum way of 
 ; approaching this, it does two things.  It works as documentation
 ; for what is being set where, and it stays consistent with the
 ; original coding of POS (please see the ABSPECA5 routine for 
 ; loading of values for 3.2 claims).
 ;
 ; For ALL the repeating fields, we will make a general assumption
 ; that the counter field that goes with the repeating field section
 ; really does tell us how many occurences of the repeating fields 
 ; there will be.  This counter will be used to loop through the
 ; repeating fields.
 ;
 ;
 ;--------------------------------------------------------------------
 ;
FILE(RESPIEN) ;EP - from ABSPOSH4
 ;
 I 'RESPIEN Q:$$IMPOSS^ABSPOSUE("P",,,,,$T(+0))
 ;
 N MEDN,COUNT,INDEX,RJTN,RJTCOUNT,RJTCODE,NEXT,CLAIMIEN
 ;
 D CLNDATA^ABSPOSHU        ;clean out spaces and zeros
 D WRTTMSN                 ;write the transmission level data
 D WRTTRAN                 ;write the transaction level data
 ;
 ;
 Q
WRTTMSN ; The purpose of this subroutine is to read through the 
 ; FDATA transmission level fields, and write out the data
 ; to the ^ABSPR (ABSP Responses) file.
 ;
 ; first lets work on what we got from the header segment
 S $P(^ABSPR(RESPIEN,100),U,2)=$G(FDATA(102))   ;version/release #
 S $P(^ABSPR(RESPIEN,100),U,3)=$G(FDATA(103))   ;transaction code
 S $P(^ABSPR(RESPIEN,100),U,9)=$G(FDATA(109))   ;transaction count
 S $P(^ABSPR(RESPIEN,500),U,1)=$G(FDATA(501))   ;header response status
 S $P(^ABSPR(RESPIEN,200),U,1)=$G(FDATA(201))   ;service provider id
 S $P(^ABSPR(RESPIEN,200),U,2)=$G(FDATA(202))   ;service prov id qual
 S $P(^ABSPR(RESPIEN,400),U,1)=$G(FDATA(401))   ;date of service
 ;
 ; now lets look for a message, if there was one
 S $P(^ABSPR(RESPIEN,504),U,1)=$G(FDATA(504))   ;message
 ;
 ; if there was any insurance information passed back - let's record it
 S $P(^ABSPR(RESPIEN,300),U,1)=$G(FDATA(301))    ;group ID
 S $P(^ABSPR(RESPIEN,500),U,24)=$G(FDATA(524))   ;plan ID
 S $P(^ABSPR(RESPIEN,540),U,5)=$G(FDATA(545))    ;network reimbrsmnt id
 S $P(^ABSPR(RESPIEN,560),U,8)=$G(FDATA(568))    ;payer ID qualifier
 S $P(^ABSPR(RESPIEN,560),U,9)=$G(FDATA(569))    ;payer ID
 ;
 Q
 ;
WRTTRAN ;The purpose of this routine is to write the transaction level 
 ; information out to the ^ABSPR (ABSP Responses) file.
 ; **Special Note - the cross references and header for the subfiles
 ; are hard set within this subroutine - this is done to stay 
 ; consistent with the original POS software (please see ABSPECA5)
 ;
 ; the logic for setting of COUNT and INDEX was borrowed from 
 ; ABSPECA5 - INDEX will stay in line with the subfile ien on the
 ; claim 400 subfile, COUNT is used to update the subfile header in
 ; the response file
 ;
 N COUNT,INDEX,CLAIMIEN,MEDN
 ;
 ; claimien was set in ABSPOSQL
 S CLAIMIEN=$P($G(^ABSPR(RESPIEN,0)),U,1)   ;claim pointer
 S INDEX=$S(CLAIMIEN="":0,1:$O(^ABSPC(CLAIMIEN,400,0))-1)
 S:INDEX<0 INDEX=0
 S COUNT=0
 ;
 ; now find where we need to start with the transaction data
 ; and loop through each one to write out to the response file
 S MEDN=""
 F  D  Q:MEDN=""
 . S MEDN=$O(FDATA("M",MEDN))
 . Q:MEDN=""
 . ;
 . S COUNT=COUNT+1       ;sub file record count
 . S INDEX=INDEX+1       ;sub file index
 . ;
 . S ^ABSPR(RESPIEN,1000,INDEX,0)=INDEX     ;.01 fld Medication order
 . ;
 . ; let's take it a segment at a time - remember most everything 
 . ; is optional
 . ; (all the below subroutines were originally in ABSPOSH5, but
 . ; because of SAC routine size limitations, they were relocated.)
 . D RESPSTS^ABSPOSH6                      ;status segment
 . D RESPCLM^ABSPOSH6                      ;claim segment   
 . D RESPPRC^ABSPOSH7                      ;pricing segment
 . D RESPDUR^ABSPOSH7                      ;DUR segment
 . D RESPPA^ABSPOSH7                       ;prior authorization segment
 . ;
 . ; now - lets update the "b" cross reference
 . S ^ABSPR(RESPIEN,1000,"B",INDEX,INDEX)=""
 ;
 ; last step - let's update the 0 node with the last rec and rec cnt
 S ^ABSPR(RESPIEN,1000,0)="^9002313.0301A^"_INDEX_"^"_COUNT
 ;
 Q
