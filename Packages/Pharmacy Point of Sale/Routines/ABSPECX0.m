ABSPECX0 ; IHS/FCS/DRS - JWS 04:26 PM 18 Jun 1996 ;  [ 09/09/2002  5:18 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,7,23**;JUN 21, 2001
 Q
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Retrieve Claim submission record
 ;
 ;Input Variables:   CLAIMIEN -  Claim Submission IEN (9002313.02)
 ;                   .ABSP    -  Pass by reference, output only
 ;
 ;Output Variables:  ABSP(9002313.02,CLAIMIEN,<field #>,"I")  = Value
 ;----------------------------------------------------------------------
 ; IHS/SD/lwj  08/13/02  NCPDP 5.1 changes
 ; Many fields that were once a part of the "header" of the claim
 ; were shifted to appear on the "rx" or "detail" segments of the
 ; claim in 5.1. Additionally, MANY new fields were added beyond 499. 
 ; For these reasons, we had to change the GETABSP3
 ; subroutine to pull fields 308 through 600 rather than just 
 ; 402 - 499. The really cool thing is that because we are at the
 ; subfile level, the duplicated fields (between header and rx)
 ; will only pull at the appropriate level.  3.2 claims should
 ; be unaffected by this change, as the adjusted and new fields
 ; were not populated for 3.2
 ;
 ; New subroutine added GETABSP4 to pull out the repeating fields for
 ; the DUR/PPS records
 ;----------------------------------------------------------------------
 ;IHS/SD/lwj 9/3/03 new subroutine added to extract the prior
 ; authorization segment values.  Subroutine called by ABSPECA1.
 ;----------------------------------------------------------------------
 ;IHS/SD/RLT - 06/27/07 - 10/18/07 - Patch 23
 ; New tag GETABSP6 for Diagnosis Code.
 ;
GETABSP2(CLAIMIEN,ABSP) ;EP - from ABSPECA1
 ;Manage local variables
 N DIC,DR,DA,DIQ,D0,DIQ2
 ;
 ;Make sure input variables are defined
 Q:$G(CLAIMIEN)=""
 ;
 ;Set input variables for FileMan data retrieval routine
 ;IHS/SD/lwj 9/9/02  need to expand the field range to include
 ; the "500" range fields now used in the header segments
 ; for NCPDP 5.1
 ;
 S DIC=9002313.02
 ; IHS/SD/lwj 9/9/02 NCPDP 5.1 changes   nxt line remarked
 ; out, following line added to replace it
 ;   S DR="101:401"
 S DR="101:600"
 S DA=CLAIMIEN
 S DIQ="ABSP",DIQ(0)="I"
 ;
 ;Execute data retrieval routine
 D EN^DIQ1
 Q
 ;----------------------------------------------------------------------
 ;Retrieve Claim Submission, Prescription(s) multiple record
 ;
 ;Input Variables:   CLAIMIEN - Claim Submission IEN (9002313.02)
 ;                   CRXIEN   - Prescription Multiple IEN (9002313.0201)
 ;
 ;Output Variables:  ABSP(9002313.0201,CRXIEN,<field #>,"I") = Value
 ;----------------------------------------------------------------------
GETABSP3(CLAIMIEN,CRXIEN,ABSP) ;EP - from ABSPECA1
 ;Manage local variables
 N DIC,DR,DA,DIQ,D0,DIQ2
 ;
 ;Make sure input variables are defined
 Q:$G(CLAIMIEN)=""
 Q:$G(CRXIEN)=""
 ;
 ;S input variables for FileMan data retrieval routine
 S DIC=9002313.02
 ;
 ;IHS/SD/lwj 8/13/02 NCPDP 5.1 nxt line rmkd out - following line added
 ;S DR="400",DR(9002313.0201)="402:499"
 S DR="400",DR(9002313.0201)="308:600"  ;need new RX fields
 ;IHS/SD/lwj 8/13/02 end changes         
 S DA=CLAIMIEN,DA(9002313.0201)=CRXIEN
 S DIQ="ABSP",DIQ(0)="I"
 ;
 ;Execute data retrieval routine
 D EN^DIQ1
 Q
 ;----------------------------------------------------------------------
 ;Retrieve Claim Submission, Prescription(s) multiple, DUR/PPS multiple 
 ; record
 ;
 ;Input Variables:   CLAIMIEN - Claim Submission IEN (9002313.02)
 ;                   CRXIEN   - Prescription Multiple IEN (9002313.0201)
 ;                   CDURIEN  - DUR/PPS Multiple IEN (9002313.1001)
 ;
 ;Output Variables:  ABSP(9002313.1001,CDURIEN,<field #>,"I") = Value
 ;----------------------------------------------------------------------
GETABSP4(CLAIMIEN,CRXIEN,CDURIEN,ABSP) ;EP - from ABSPECA1
 ;
 ;Manage local variables
 N DIC,DR,DA,DIQ,D0,DIQ2
 ;
 ;Make sure input variables are defined
 Q:$G(CLAIMIEN)=""
 Q:$G(CRXIEN)=""
 Q:$G(CDURIEN)=""
 ;
 ;S input variables for FileMan data retrieval routine
 S DIC=9002313.02
 ;
 S DR="400",DR(9002313.0201)=473.01  ;fields
 S DR(9002313.1001)=".01;439;440;441;474;475;476"  ;fields
 S DA=CLAIMIEN,DA(9002313.0201)=CRXIEN,DA(9002313.1001)=CDURIEN
 S DIQ="ABSP",DIQ(0)="I"
 ;
 ;Execute data retrieval routine
 D EN^DIQ1
 ;
 Q
 ;----------------------------------------------------------------------
 ;Retrieve Claim Submission, Prescription(s) multiple record
 ;          Prior authorization fields only
 ;
 ;Input Variables:   CLAIMIEN - Claim Submission IEN (9002313.02)
 ;                   CRXIEN   - Prescription Multiple IEN (9002313.0201)
 ;
 ;Output Variables:  ABSP(9002313.0201,CRXIEN,<field #>,"I") = Value
 ;----------------------------------------------------------------------
GETABSP5(CLAIMIEN,CRXIEN,ABSP) ;EP - from ABSPECA1
 ;Manage local variables
 N DIC,DR,DA,DIQ,D0,DIQ2
 ;
 ;Make sure input variables are defined
 Q:$G(CLAIMIEN)=""
 Q:$G(CRXIEN)=""
 ;
 ;S input variables for FileMan data retrieval routine
 S DIC=9002313.02
 ;
 S DR="400",DR(9002313.0201)="498.01:498.14"  ;need new RX fields
 S DA=CLAIMIEN,DA(9002313.0201)=CRXIEN
 S DIQ="ABSP",DIQ(0)="I"
 ;
 ;Execute data retrieval routine
 D EN^DIQ1
 Q
 ;----------------------------------------------------------------------
 ;Retrieve Claim Submission, Prescription(s) multiple, Diagnosis Code 
 ; multiple record
 ;
 ;Input Variables:   CLAIMIEN - Claim Submission IEN (9002313.02)
 ;                   CRXIEN   - Prescription Multiple IEN (9002313.0201)
 ;                   CDIAGIEN - Diagnosis Code Multiple IEN (9002313.0701)
 ;
 ;Output Variables:  ABSP(9002313.1001,CDIAGIEN,<field #>,"I") = Value
 ;----------------------------------------------------------------------
GETABSP6(CLAIMIEN,CRXIEN,CDIAGIEN,ABSP) ;EP - from ABSPECA1
 ;
 ;Manage local variables
 N DIC,DR,DA,DIQ,D0,DIQ2
 ;
 ;Make sure input variables are defined
 Q:$G(CLAIMIEN)=""
 Q:$G(CRXIEN)=""
 Q:$G(CDIAGIEN)=""
 ;
 ;S input variables for FileMan data retrieval routine
 S DIC=9002313.02
 ;
 S DR="400",DR(9002313.0201)=491.01  ;fields
 S DR(9002313.0701)="492;424"  ;fields
 S DA=CLAIMIEN,DA(9002313.0201)=CRXIEN,DA(9002313.0701)=CDIAGIEN
 S DIQ="ABSP",DIQ(0)="I"
 ;
 ;Execute data retrieval routine
 D EN^DIQ1
 ;
 Q
