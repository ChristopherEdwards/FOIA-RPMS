ABSPOSQL ; IHS/FCS/DRS - Process responses ;   [ 10/07/2002  8:20 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,29,31,32**;JUN 21, 2001
 ;
 ;-----------------------------------------------------
 ;IHS/SD/lwj 10/07/02 NCPDP 5.1 changes
 ; The reversal claim now has a transaction code of "B2" instead of 
 ; 11.  Needed to adjust the ISREVERS routine to account for the 
 ; difference.  Also adjusted the RESP1 routine to check the
 ; additional message field (526) since not all processors will use
 ; the 504 message field in 5.1.
 ;
 ;-----------------------------------------------------
 Q
 ;
 ; Subroutines from ABSPOSQ4 - the main line of processing is in here.
 ; The utility subroutines remain in ABSPOSQ4.
 ;
 ;  RESPONSE(DIALOUT)
 ;     Processes all response packets for this DIALOUT
 ;     Creates 9002313.03 response record
 ;     At this point, you are guaranteed to be the only job
 ;     processing responses for this DIALOUT - you have a LOCK on
 ;     that privilege, set up in ABSPOSQ4.  But the old LOCK logic
 ;     is retained in here, in case that ABSPOSQ4 restriction is
 ;     ever removed.
 ;  ONE(CLAIMIEN,RESPIEN)
 ;     Process the 9002313.03 RESPIEN for the 9002313.02 CLAIMIEN
 ;     Loops through all 9002313.59's represented in the CLAIMIEN
 ;  ONE1(IEN59)
 ;     Processing the 9002313.03 RESPIEN for this one IEN59
 ;     It's just a tiny wrapper for RESP1 to save,set,restore logging
 ;  RESP1
 ;     The real work of response handling for one IEN59 is in here
 ;
RESPONSE(DIALOUT) ;EP - ABSPOSQ4
 ;
 ; Currently, the caller from ABSPOSQ4 will already have the
 ; lock on ^TMP("ABSPOSQ4",DIALOUT)
 ; This routine tries to get L +^ABSPECX("POS",DIALOUT,"R")
 ; and then L +^ABSPECX("POS",DIALOUT,"R",CLAIMIEN)
 ; All of this locking could be greatly simplified, it seems.
 ; 
 N CLAIMIEN,RESPIEN,RESPREC,CLAIMID,DIC,X,Y
 S CLAIMIEN=""
 F  D  Q:CLAIMIEN=""
 . I '$$LLIST S CLAIMIEN="" Q  ; Lock the whole list of responses
 . ;D LOG^ABSPOSL("PRAscii1^"_$T(+0)_" 1. with CLAIMIEN="_CLAIMIEN)
 . S CLAIMIEN=$O(^ABSPECX("POS",DIALOUT,"R",CLAIMIEN))
 . ;D LOG^ABSPOSL("PRAscii1^"_$T(+0)_" 2. with CLAIMIEN="_CLAIMIEN)
 . I CLAIMIEN="" D ULLIST Q
 . ; lock the individual response and unlock the list (useless oper?)
 . F  Q:$$LRESP  Q:'$$IMPOSS^ABSPOSUE("L","RI","Locking response for CLAIMIEN="_CLAIMIEN,,"RESPONSE",$T(+0))
 . D ULLIST ; unlock the list
 . ;
 . ;Assemble RESPREC from scratch global
 . S RESPREC=""
 . N I F I=1:1:^ABSPECX("POS",DIALOUT,"R",CLAIMIEN,0) D
 . . S RESPREC=RESPREC_^ABSPECX("POS",DIALOUT,"R",CLAIMIEN,I)
 . S RESPREC=$P(RESPREC,$C(3))
 . I RESPREC="" D  Q  ; null response?  should be impossible,
 . . ; but we saw it once at Parker.
 . . D LOG^ABSPOSL($T(+0)_" - ??? Null response to CLAIMIEN "_CLAIMIEN)
 . . D KILLRESP
 . ;
 . S CLAIMID=$P($G(^ABSPC(CLAIMIEN,0)),U,1)
 . I CLAIMID="" D  Q  ; impossible?
 . . D LOG^ABSPOSL($T(+0)_" - ??? CLAIMID is missing from "_CLAIMIEN)
 . . D KILLRESP
 . ;
 . ;Create Claim Response Record (9002313.03)
 . F  D  Q:RESPIEN'<1  Q:$$IMPOSS^ABSPOSUE("FM","TI","^DIC failed to create new ^ABSPR record for CLAIMID="_CLAIMID,,,$T(+0))
 . . N X,DLAYGO,DIC,Y S X=""""_CLAIMID_""""
 . . S DIC="^ABSPR(",DIC(0)="LXZ",DLAYGO=9002313.03 D ^DIC
 . . S RESPIEN=+Y
 . ;
 . D LOG^ABSPOSL($T(+0)_" - Claim "_CLAIMIEN_" got Response "_RESPIEN)
 . ;
 . N STAMP S STAMP=$$NOWFM^ABSPOSU1()
 . ;
 . ;Set Date/Time Response Received field, set cross-reference
 . S $P(^ABSPR(RESPIEN,0),U,2)=STAMP
 . S ^ABSPR("AE",STAMP,RESPIEN)=""
 . ;
 . ;Set Transmitted On field, set cross-reference
 . S $P(^ABSPC(CLAIMIEN,0),U,5)=STAMP
 . S ^ABSPC("AE",STAMP,CLAIMIEN)=""
 . ;
 . ;Turn off transmit flag, reset cross-reference
 . S $P(^ABSPC(CLAIMIEN,0),U,4)=0
 . K ^ABSPC("AD",2,CLAIMIEN) ; 2 (POS) not 1 (old batch)
 . S ^ABSPC("AD",0,CLAIMIEN)=""
 . ;
 . ;Parse and File Ascii Response record in Claim Response File
 . D PARSE^ABSPECA4(RESPREC,RESPIEN)
 .    ;
 .    ;  and the right place to process POS responses is here!!!!
 .    ;
 . ; (there was some problem with this slot stacking mechanism?)
 . ;N OLDSLOT S OLDSLOT=$$GETSLOT^ABSPOSL ; remember current slot
 . D ONE(CLAIMIEN,RESPIEN)
 . ;D SETSLOT^ABSPOSL(OLDSLOT) ; restore the old one
 . ;
 . D KILLRESP ; kill the scratch response
 . ; Save a copy of the received packet, too
 . N WP,I F I=1:100:$L(RESPREC) S WP(I/100+1,0)=$E(RESPREC,I,I+99)
 . D WP^DIE(9002313.03,RESPIEN_",",9999,"","WP")
 . D ULRESP ; unlock the response
 . Q
 Q
 ;IHS/SD/lwj 10/07/02 NCPDP 5.1 changes - for reversals we need
 ; to account for a transaction code of 11 for 3.2 claims and
 ; B2 for 5.1 claims.  The next line was remarked out and 
 ; replaced with the 6 lines following it.
 ;ISREVERS(X)        Q $P(^ABSPC(X,100),U,3)=11 ; trans.code REVERSAL
ISREVERS(X)        ; trans.code REVERSAL
 ;
 N REVS
 S REVS=0
 S:($P(^ABSPC(X,100),U,3)=11)!($P(^ABSPC(X,100),U,3)="B2") REVS=1
 Q REVS
 ;
 ;IHS/SD/lwj 10/07/02 end changes to ISREVERS
 ;
ONE(CLAIMIEN,RESPIEN)        ;
 ; Both the 9002313.02 and 9002313.03 are correct and complete
 ; Now update all of the prescription records affected by them.
 ; Loop:  for each prescription represented in the original claim:
 N OLDSLOT S OLDSLOT=$$GETSLOT^ABSPOSL
 N ISREVERS S ISREVERS=$$ISREVERS(CLAIMIEN)
 N X S X="RESPONSE -"
 I ISREVERS S X=X_" REVERSAL -"
 S X=X_" Response #"_RESPIEN
 S X=X_" for Claim #"_CLAIMIEN D LOG^ABSPOSL(X)
 N INDEX S INDEX=$S(ISREVERS:"AER",1:"AE")
 N IEN59 S IEN59=0
 F  S IEN59=$O(^ABSPT(INDEX,CLAIMIEN,IEN59)) Q:IEN59=""  D
 . D ONE1(IEN59)
 Q
ONE1(ABSBRXI) ; ABSBRXI would more properly be called IEN59
 D SETSLOT^ABSPOSL(OLDSLOT)
 D LOG^ABSPOSL("RESPONSE - for ^ABSPT("_ABSBRXI_")")
 D RESP1
 D SETSLOT^ABSPOSL(OLDSLOT) ; because RESP1 changed it, probably
 Q
 ;----------------------------------------------------------------------
 ;Process ASCII Claim Response Records:
 ;
 ;     1.  Loop through ^ABSPECX("POS",DIALOUT,$J,"R",CLAIMIEN) 
 ;         transmission scratch global
 ;     2.  Assemble ASCII Claim Response Records
 ;     3.  Create new records in Claim Response File (9002313.03)
 ;     4.  Parse ASCII Claim Response Records then file in
 ;         Claim Response File (9002313.03)
 ;----------------------------------------------------------------------
 ;
LLIST() L +^ABSPECX("POS",DIALOUT,"R"):60 Q $T
ULLIST L -^ABSPECX("POS",DIALOUT,"R") Q
LRESP() L +^ABSPECX("POS",DIALOUT,"R",CLAIMIEN):60 Q $T
ULRESP L -^ABSPECX("POS",DIALOUT,"R",CLAIMIEN) Q
KILLRESP K ^ABSPECX("POS",DIALOUT,"R",CLAIMIEN) Q
 ;
RESP1 ; called from  ONE1
 ; ABSBRXI would more properly be called IEN59
 N ERROR
 S ERROR=0  ;IHS/OIT/SCR 050409
 D SETSLOT^ABSPOSL(ABSBRXI) ;  point to slot for logging
 N REVERSAL S REVERSAL=$G(^ABSPT(ABSBRXI,4))>0
 D  ; store pointer to response
 . N DIE,DA,DR S DIE=9002313.59,DA=ABSBRXI
 . S DR=$S(REVERSAL:402,1:4)_"////"_RESPIEN
 . D ^DIE
 D SETSTAT^ABSPOSU(90) ; "Processing response"
 ;D LOG^ABSPOSL("RESPONSE - Status (Header) = "_$P($G(^ABSPR(RESPIEN,500)),U)
 N POSITION S POSITION=$P(^ABSPT(ABSBRXI,0),U,9)
 I REVERSAL S POSITION=1 ; but reversals have only 1 transaction
 D LOG^ABSPOSL("RESPONSE - #"_RESPIEN_", POSITION="_POSITION)
 ;IHS/OIT/SCR 2/13/09 patch 29 modify next line to avoid undefined error is no such node exists
 ;I '$D(^ABSPR(RESPIEN,1000,POSITION,500)) S ERROR=1 G RESPBAD
 ;IHS/OIT/SCR 05/12/09 start changes to avoid continued undefined problems patch 31
 I $G(POSITION)="" D
  .S ERROR=1
  .D RESPBAD
  .Q
 Q:ERROR
 I $G(^ABSPR(RESPIEN,1000,POSITION,500))="" D
 .S ERROR=1
 .D RESPBAD
 .Q
 Q:ERROR
 ;IHS/OIT/SCR 05/12/09 end changes to avoid continued undefined problems patch 31
 N RESP S RESP=$P(^ABSPR(RESPIEN,1000,POSITION,500),U)
 D INCSTAT^ABSPOSUD("R",$S(RESP="R":2,RESP="P":3,RESP="D":4,RESP="C":5,1:19))
 D
 . N X S X="RESPONSE - Position "_POSITION_" = "_RESP
 . I RESP="P" S X=X_" $"_$$INSPAID1^ABSPOS03(RESPIEN,POSITION)
 . D LOG^ABSPOSL(X)
 ;
 ;IHS/SD/lwj 10/07/02  NCPDP 5.1 changes - look at field 526 
 ; (additional message) if nothing found in 504
 N X S X=$G(^ABSPR(RESPIEN,1000,POSITION,504))
 I X="" S X=$G(^ABSPR(RESPIEN,1000,POSITION,526))  ;IHS/SD/lwj 10/07/02
 I X]"" D LOG^ABSPOSL("RESPONSE - MESSAGE - "_X)
 ;
 I RESP="R" D  ; rejected, give rejection reasons
 .N J S J=0 F  S J=$O(^ABSPR(RESPIEN,1000,POSITION,511,J)) Q:'J  D
 ..N R S R=$P($G(^ABSPR(RESPIEN,1000,POSITION,511,J,0)),U)
 ..N X I R]"" D
 ...S X=$O(^ABSPF(9002313.93,"B",R,0))
 ...I X]"" S X=$P($G(^ABSPF(9002313.93,X,0)),U,2)
 ..E  S X=""
 ..D LOG^ABSPOSL("REJECT - "_R_" - "_X)
 ;
 N INSURER S INSURER=$P(^ABSPT(ABSBRXI,1),U,6)
 I $G(INSURER)="" D RESPBAD Q  ;IHS/OIT/SCR 061809 patch 32 - if no insurer,process as corrupted response
 I $$REJSLEEP^ABSPOSQ4(RESPIEN,POSITION) D  ; ins. asleep: want to retry
 . D SETSTAT^ABSPOSU(31)
 . N X S X=$$INCSLEEP^ABSPOSQ4(INSURER)
 . S $P(^ABSPT(IEN59,8),U)=X_U_U_INSURER
 . D LOG^ABSPOSL($T(+0)_" - Insurer asleep; retry scheduled for "_X)
 E  D  ; else: a normal kind of response, so we are done
 . D CLRSLEEP^ABSPOSQ4(INSURER,1)
 . D SETSTAT^ABSPOSU(99) ; "Done"
 . I $G(^ABSPT(ABSBRXI,3)) D
 . . D SETRESU^ABSPOSU(0,"Cancellation tried too late; claim sent.")
 . E  D
 . . D SETRESU^ABSPOSU(0) ; indicates a complete response was received
 ;  status reports should refer to the ^ABSPR entry
 D RELSLOT^ABSPOSL
 Q
RESPBAD ; corrupted response escape from RESP1 ; reached by a GOTO
 N MSG S MSG="Corrupted response `"_RESPIEN
 D SETSTAT^ABSPOSU(99) ; "Done"
 D SETRESU^ABSPOSU(6500+$G(ERROR),MSG)
 D LOG^ABSPOSL(MSG)
 D DONE^ABSPOSL ; close up the logging slot
 Q
