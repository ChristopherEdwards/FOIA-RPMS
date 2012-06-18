ABSPOSCE ; IHS/FCS/DRS - New entry in 9002313.02 ;   [ 12/20/2002  11:24 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,5,42**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 ;Creates an Electronic Claim Submission record
 ;
 ;Parameters:  START     - START Medication Number
 ;             END       - END Medication Number
 ;             TOTAL     - TOTAL Medications in Claim
 ;   the ABSP(*) array pointed to by START, END
 ;
 ;----------------------------------------------------------------------
 ; NEWCLAIM^ABSPOSCE called from ABSPOSCA from ABSPOSQG from ABSPOSQ2
 ;
 ;IHS/SD/lwj  08/01/02  NCPDP 5.1 changes
 ; This routine is responsible for creating a new entry in the 
 ; claims file, and for calling the routines that then populate
 ; that new entry.
 ; 
 ; For 5.1 we needed to adjust this routine just a little.  In 3.2
 ; there were only 4 segments to a claim, in 5.1 there are 14, so
 ; as we loop through the calling of ABSPOSCF to populate the claim
 ; file we will verify which version of claim we are working with
 ; and adjust the calling appropriately.  Worthy of noting is that
 ; the "header" portion of the claim in 5.1 is comprised of 3 
 ; segments - 100 (Header), 110 (Insurance) and 120 (Patient).  The
 ; "detail" or "rx" portion of the claim will hold the remaining
 ; 11 segments.
 ;
 ; I also had to create a new ABSP field (i.e. "Transaction Count")
 ; to track the number of transactions per claim.
 ;
 ;
 ;IHS/SD/lwj  12/20/02 NCPDP fix
 ; Field 308 changed definition in NCPDP 5.1 - it was a header field in
 ; 3.x claims - in 5.1 it migrated to a detail level.  Because we are 
 ; supporting 3.x and 5.1 claims,this duel personality caused the claims
 ; to be created erroneously on 3.2 claims when two claims were created
 ; back to back. To fix this ABSP(9002313.0201) needs to be reset to
 ; blanks prior to the claim header being created.
 ;
 Q
 ;
NEWCLAIM(START,END,TOTAL) ;EP
 ;Manage local variables
 N CLAIMID,DIC,DLAYGO,X,Y,COUNT,INDEX,DIK,DA,NODE0,ROU S ROU=$T(+0)
 ;
 ;Create new record in Claim Submission File (9002313.02)
L L +^TMP("ABSPOSCE"):300 I '$T G L:$$IMPOSS^ABSPOSUE("L","RTI","Single-threaded routine",,,$T(+0))
 S CLAIMID=$$CLAIMID^ABSPECX1(ABSP("NCPDP","IEN"),"P")
 I CLAIMID="" S ERROR=8001 D  L -^TMP($T(+0)) Q
 .D LOG(ROU_" - $$CLAIMID^ABSBPECX1() failed")
 ;U $P W "Creating CLAIMID ",CLAIMID,"...",!
 S DLAYGO=9002313.02,DIC="^ABSPC(",DIC(0)="LXZ",X=CLAIMID
 D ^DIC S Y=+Y
 L -^TMP("ABSPOSCE")
 I Y<1 D  S ERROR=8002 Q
 .D LOG(ROU_" - Failed to create an entry in file 9002313.02")
 ;
 S ABSP(9002313.02)=Y
 D LOG(ROU_" - Created claim ID "_CLAIMID_" (IEN "_ABSP(9002313.02)_")")
 ;
 S NODE0=$G(^ABSPC(ABSP(9002313.02),0))
 S $P(NODE0,U,2)=ABSP("Insurer","IEN")
 ;S $P(NODE0,U,3)=BItemIEN
 S $P(NODE0,U,4)=2 ; TRANSMIT FLAG - use 2 instead of 1 because
 ;  ANMC is running POS and Traditional batch file together and we
 ;  want to be entirely sure of no conflicts
 S $P(NODE0,U,6)=$$NOWFM^ABSPOSU1()
 S ^ABSPC(ABSP(9002313.02),0)=NODE0
 S $P(^ABSPC(ABSP(9002313.02),1),U)=ABSP("Patient","Name")
 ;
 S:ABSP("NCPDP","Version")[3 ABSP("Transaction Code")=TOTAL
 ;
 ; IHS/SD/lwj 8/5/02 NCPDP 5.1 - the value of field 103 changed
 ;  from being either the number of transactions for billing, or
 ;  an 11 for reversal, to a B1 for billing or a B2 for reversal
 ;  5.1 also requires that we send the number of transactions in
 ;  the claim.  So...for reversals we will set this to 1, and for
 ;  all others, we can still use TOTAL
 ;
 S ABSP("Transaction Count")=TOTAL
 I TOTAL=11 S ABSP("Transaction Count")=1   ;only 1 rev at a time
 ;
 ; IHS/SD/lwj 8/1/02  begin the 5.1 changes for the "header" section
 ; If the claim type is 3.2 we will call ABSPOSCF with nodes 10
 ; and 20 - if it is 5.1, we will call with 100,110 and 120.
 ;
 ; first remark out old code
 ;Execute claim header (required) code
 ;D XLOOP^ABSPOSCF(ABSP("NCPDP","IEN"),10)
 ;
 ;Execute claim header (optional) code
 ;D XLOOP^ABSPOSCF(ABSP("NCPDP","IEN"),20)
 ;
 ;IHS/SD/lwj 12/20/02 NCPDP fix - clear ABSP(9002313.0201)
 S ABSP(9002313.0201)=""    ;IHS/SD/lwj 12/20/02
 ;
 ; Now for the new code
 D
 . N SEG,SEGBEG,SEGEND
 . I ABSP("NCPDP","Version")[3 S SEGBEG=10,SEGEND=20
 . I ABSP("NCPDP","Version")[5 S SEGBEG=100,SEGEND=120
 . ;IHS/OIT/CASSEVERN/RAN - 02/09/2011 - Patch 42 For D.0 development START
 . ;Don't do this if we've run the conversion....no longer use NCPDP formats
 . I $G(^ABSP(9002313.99,1,"ABSPICNV"))=1 Q
 . F SEG=SEGBEG:10:SEGEND D
 .. D XLOOP^ABSPOSCF(ABSP("NCPDP","IEN"),SEG)
 ;IHS/OIT/CASSEVERN/RAN - 02/09/2011 - Patch 42 For D.0 development
 I $G(^ABSP(9002313.99,1,"ABSPICNV"))=1 D
 . I ABSP("NCPDP","Version")["D" D
 . . I TOTAL=11 D
 . . . D EN^ABSPDB2("CLAIMHD") ;Replaces steps above
 . . ELSE  D EN^ABSPDB1("CLAIMHD")
 . I ABSP("NCPDP","Version")["5" D
 . . I TOTAL=11 D
 . . . D EN^ABSP5B2("CLAIMHD") ;Replaces steps above
 . . ELSE  D EN^ABSP5B1("CLAIMHD")
 ;IHS/OIT/CASSEVERN/RAN - 02/09/2011 - Patch 42 For D.0 development STOP
 ;Create multiple zero node
 S ^ABSPC(ABSP(9002313.02),400,0)="^9002313.0201PA^^"
 ;
 S COUNT=0
 F INDEX=START:1:END D
 .;Create prescription record
 .S COUNT=COUNT+1
 .S NODE0=""
 .S $P(NODE0,U,1)=INDEX
 .S $P(NODE0,U,2)=$G(ABSP("RX",INDEX,"VCPT IEN"))
 .S $P(NODE0,U,3)=INDEX
 .S $P(NODE0,U,4)=$G(ABSP("RX",INDEX,"Drug Name"))
 .S ^ABSPC(ABSP(9002313.02),400,INDEX,0)=NODE0
 .S $P(^ABSPC(ABSP(9002313.02),400,INDEX,400),U,1)=$$DTF1^ABSPECFM($G(ABSP("RX","Date Filled")))
 .S ABSP(9002313.0201)=INDEX ;07/28/96.
 .;
 .; IHS/SD/lwj 8/1/02 begin changes for NCPDP 5.1 - subroutine called 
 .; to lessen the looping here
 .; First we will remark out the old code
 .;       Execute claim information (required) code
 .;       D XLOOP^ABSPOSCF(ABSP("NCPDP","IEN"),30,INDEX)
 .;
 .;       Execute claim information (optional) code
 .;       D XLOOP^ABSPOSCF(ABSP("NCPDP","IEN"),40,INDEX)
 .;
 .; Now let's call the subroutine to process
 .;IHS/OIT/CASSEVERN/RAN - 02/09/2011 - Patch 42 For D.0 development - START
 . ;D PROCRX
 .I $G(^ABSP(9002313.99,1,"ABSPICNV"))'=1 D
 . . D PROCRX
 .ELSE  D
 . . I ABSP("NCPDP","Version")["D" D
 . . . I TOTAL=11 D
 . . . . D EN^ABSPDB2("CLAIMRST",INDEX)
 . . . ELSE  D EN^ABSPDB1("CLAIMRST",INDEX)
 . . I ABSP("NCPDP","Version")["5" D
 . . . I TOTAL=11 D
 . . . . D EN^ABSP5B2("CLAIMRST",INDEX)
 . . . ELSE  D EN^ABSP5B1("CLAIMRST",INDEX)
 .;IHS/OIT/CASSEVERN/RAN - 02/09/2011 - Patch 42 For D.0 development - END
 .; IHS/SD/lwj end changes for 5.1 rx detail
 .S ^ABSPC(ABSP(9002313.02),400,"B",INDEX,INDEX)=""
 .S ^ABSPC(ABSP(9002313.02),400,"AC",INDEX,INDEX)=""
 .S NODE0=$G(^ABSPC(ABSP(9002313.02),400,0))
 .S $P(NODE0,U,4)=COUNT
 .S $P(NODE0,U,3)=$O(^ABSPC(ABSP(9002313.02),400,"A"),-1)
 .S ^ABSPC(ABSP(9002313.02),400,0)=NODE0
 ;
 ;Cross-Reference Claim Submission Record
 S DIK="^ABSPC("
 S DA=ABSP(9002313.02)
 D IX1^DIK
 Q
LOG(X) ; write the message to all of the log files for the IEN59's
 ; being bundled into this 9002313.02 claim (usually, up to 4 presc's)
 N IEN59,I
 F I=START:1:END D
 . S IEN59=ABSP("RX",I,"IEN59")
 . D LOG59^ABSPOSQ(X,IEN59)
 Q
 ;
PROCRX ;IHS/SD/lwj  8/1/02  This routine contains the calls to 
 ; ABSPOSCF needed to actually get the values, and store them
 ; in the claim file.  It was created as a result of the major
 ; segment changes that took place in NCPDP 5.1.  For 3.2 claims
 ; we will still only call ABSPOSCF with nodes 30 and 40, but for
 ; 5.1 claims, we will call the routine with nodes 130, 140, 150,
 ; 160, 170, 180, 190, 200, 210, 220, 230.  These nodes are defined
 ; in the ABSPF(9002313.92 file.
 ;
 N SEG,SEGBEG,SEGEND
 I ABSP("NCPDP","Version")[3 S SEGBEG=30,SEGEND=40
 I ABSP("NCPDP","Version")[5 S SEGBEG=130,SEGEND=230
 F SEG=SEGBEG:10:SEGEND D
 . D XLOOP^ABSPOSCF(ABSP("NCPDP","IEN"),SEG,INDEX)
 ;
 Q
