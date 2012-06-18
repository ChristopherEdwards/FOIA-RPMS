ABSPOSAE ; IHS/SD/lwj - send/receive E1 trans ;   [ 10/07/2005  2:11 pM ]
 ;;1.0;PHARMACY POINT OF SALE;**14,16,17,21,28,42**;JUN 21, 2001
 ;
 ;  ABSPOSAE is the main program for send/receive communications
 ;  with the Envoy switch for E1 transactions.  It was originally
 ;  a copy of ABSPOSAM that was modified to fit the needs of the
 ;  E1.  The largest difference is that the E1 will not be tasked -
 ;  it will be online / real time, with an immediate response for
 ;  the user when possible.
 ;
 ;  This routine will be checking ^ABSPECX("ABSPOSQ3 to make sure
 ;  that we aren't currently sending claims, if claims are currently
 ;  sending, we will need wait until the line is clear.
 ;
 ;  The E1 transaction is the eligibility transaction, and was
 ;  needed when Medicare Part D was introduced in January 2006.
 ;
 ;--------------------------------------------------------------------
 ;IHS/SD/RLT - 3/22/06 - Fixed SAC check error.
 ;                       S12+10 - Added spaces after Q 0.
 ;--------------------------------------------------------------------
 ;IHS/SD/RLT - 5/17/06 - Patch 17
 ;                       Added lock so the regular claims processing
 ;                       doesn't clobber this process in the call to
 ;                       JOBCOUNT^ABSPOSQ3.  Also made sure the lock
 ;                       wasn't left if the program errored out.
 ;IHS/SD/RLT - 05/24/07 - Patch 21
 ;                        E1 enhancements - ^ABSPOSE2
 ;
 ;--------------------------------------------------------------------                        
 ;IHS/OIT/SCR - 09/22/08 - Patch 28 - Modified subroutine CALLOIT
 ;                        Changed contact information from 'OIT HELP DESK'
 ;                        to 'LOCAL HELP DESK'
 ;--------------------------------------------------------------------                        
 Q
SEND(E1MSG,E1IEN) ;EP - from ABSPOSE1/ABSPOSE2
 ;
 ;must have these defined for ABSPOSAR
 N ACK,ENQ,EOT,ETX,NAK,STX,ETB
 S ACK=$C(6),ENQ=$C(5),EOT=$C(4),ETX=$C(3)
 S NAK=$C(21),STX=$C(2),ETB=$C(23)
 ;
 N DIALOUT,TRYCNT,SENDE1,RESPMSG,RESPLRC
 S DIALOUT=$$DIALOUT
 S (TRYCNT,SENDE1)=0
 ;
 ; Let's make sure that claims aren't currently being
 ; processed - if they are, let's wait a little and
 ; and see if we can grab the connection.
 S ^ABSPECX("ABSPOSQ3","JOB",$J)=$H
 S ^ABSPECX("ABSPOSQ3","JOB",$J,"DIALOUT")=DIALOUT
 N ABSPERR
 S ABSPERR=0
 F  D  Q:(SENDE1)!(TRYCNT>3)!(ABSPERR)
 . ;S:$$JOBCOUNT^ABSPOSQ3'>$$MAXJOBS^ABSPOSQ3 SENDE1=1
 . I $$JOBCOUNT^ABSPOSQ3'>$$MAXJOBS^ABSPOSQ3 D
 . . L +^ABSPECX("ABSPOSQ3","JOB",$J):0
 . . I '$T D  Q
 . . . S ABSPERR=1
 . . . D RECERR
 . . . D IMPOSS^ABSPOSUE("P","TI","E1 can't obtain job-specific lock for $J="_$J_" ????",,"COMMS",$T(+0))
 . . Q:ABSPERR
 . . S SENDE1=1
 . Q:ABSPERR
 . I 'SENDE1 D
 . . S TRYCNT=TRYCNT+1
 . . D CLMSMSG
 Q:ABSPERR
 I 'SENDE1 D ERRCPRC Q
 ;
 ; now let's make sure we have all the information we need to
 ; make a connection and that we are not in a shutdown mode
S12 ;
 ;N IO S IO=$$IO^ABSPOSA(DIALOUT) I IO="" G S12:$$IMPOSS^ABSPOSUE("DB","TRI","IO field missing in DIALOUT="_DIALOUT,,"S12",$T(+0))
 N IO S IO=$$IO^ABSPOSA(DIALOUT)
 I IO="" D  Q
 . D RECERR
 . D IMPOSS^ABSPOSUE("DB","TRI","IO field missing in DIALOUT="_DIALOUT,,"S12",$T(+0))
 ;
 N T1LINE S T1LINE=$$T1DIRECT^ABSPOSA(DIALOUT)
 ;
 I $$SHUTDOWN^ABSPOSQ3 D SHUTERR Q 0
 ;
 ; Make the connection to Envoy (aka WebMD, aka Emdeon)
 S RET=$$CONNECT^ABSPOSAQ(DIALOUT)
 I RET D CONNERR Q 0   ;if we can't connect, we need to quit for now
 ;
 ;
 ;Send message to host
 D SENDREQ^ABSPOSAS(DIALOUT,.E1MSG)
 ;
 ; special note - none of the checking done in ABSPOSAM is
 ; done here - E1s are only set up for a T1 connection -
 ; no modem commands.
 ;
 ;Get the response
 S HMSG=$$GETMSG^ABSPOSAR(DIALOUT,.RESPMSG,.RESPLRC,60)
 ;
 ;HMSG="ETX" or "EOT" or "" (if timed out)
 ;
 I HMSG="ETX" D
 . N DIE,DR,DA
 . S DIE="^ABSPR(",DA=E1IEN,DR="9999999////RECEIVED   "_$L(HMSG)_" bytes."
 E  D  Q RET
 . I HMSG'="+++" D HANGUP^ABSPOSAB(DIALOUT)
 . S RET=$S(HMSG="+++":30261,HMSG="":30262,1:30263)
 . D ERRRESP
 ;
 D CLOSE^ABSPOSAB(DIALOUT)  ;close the connection for other transactions
 D ENDJOB99^ABSPOSQ3    ;release it so the claims can process again
 ;
 ; now let's parse the raw response, store it in ^ABSPE, and print
 ; it out for the user to view
 D PRCRESP
 ;
 D PRNTRESP
 ;
 ;
 Q 0
 ;
PRCRESP ; this subroutine is responsible for facilitating the parsing of the
 ; raw response and storing the information in ^ABSPE. We will leave
 ; the displaying of the data up to ^ABSPOSE1/^ABSPOSE2.
 ;
 N FDATA
 N WP,I,RREC
 N DIE,DR,DA
 ;
 M RREC=RESPMSG
 ;
 ; let's go ahead and write out the raw response to ^ABSPE
 F I=1:100:$L(RREC) S WP(I/100+1,0)=$E(RREC,I,I+99)
 D WP^DIE(9002313.7,E1IEN_",",2000,"","WP")
 ;
 ;start here when we are ready to parse data out again
 ; next let's parse the data out into the actual fields
 D PARSEE1^ABSPOSH4(RREC,E1IEN)
 ;
 ; now let's file the parsed data in ^ABSPE
 K DIE
 S DIE="^ABSPE(",DA=E1IEN
 D FILEDT
 D FILEMIN
 D FILESTS
 ;
 Q
 ;
FILEDT ;this subroutine simply gets the current date and time
 ; and files it in the .03 field in ^ABSPE file.
 ;
 N %,X
 D NOW^%DTC
 S DR=".03////"_$G(%)_";"
 ;
 Q
 ;
FILEMIN ; This subroutine will take out the data that was parsed
 ; out for the message and insurance segments and file it
 ; in the ^ABSPE file.
 ;
 ; now lets look for a message, if there was one
 I $G(FDATA(102))="D0",$G(FDATA("M",1,112))'="R" D MESBLD
 S:$D(FDATA(504)) DR=$G(DR)_"504////"_$TR(FDATA(504),";","#")_";"
 ;
 ; if there was any insurance information passed back - let's record it
 S:$D(FDATA(301)) DR=$G(DR)_"301.01////"_FDATA(301)_";"  ;group ID
 S:$D(FDATA(524)) DR=$G(DR)_"524.01////"_FDATA(524)_";"  ;plan ID
 S:$D(FDATA(545)) DR=$G(DR)_"545////"_FDATA(545)_";"     ;network reimbrsment id
 S:$D(FDATA(568)) DR=$G(DR)_"568////"_FDATA(568)_";"     ;payer ID qualifier
 S:$D(FDATA(569)) DR=$G(DR)_"569////"_FDATA(569)_";"     ;payer ID
 ;
 Q
 ;
MESBLD ; Build the 504 message from the D.0 data
 ;
 N X,Y
 S Y=$E($G(FDATA("M",1,311.01)),1,13),X="LN:"_Y_$J("",13-$L(Y))
 S Y=$E($G(FDATA("M",1,310.01)),1,10),X=X_"FN:"_Y_$J("",10-$L(Y))
 S Y=$E($G(FDATA("M",1,304.01)),1,8),X=X_"BD:"_Y_$J("",8-$L(Y))_"PD:0"
 S Y=$E($G(FDATA("M",1,340,1)),1,6),X=X_"BN:"_Y_$J("",6-$L(Y))
 S Y=$E($G(FDATA("M",1,991,1)),1,10),X=X_"PN:"_Y_$J("",10-$L(Y))
 S Y=$E($G(FDATA("M",1,992,1)),1,15),X=X_"GP:"_Y_$J("",15-$L(Y))
 S Y=$E($G(FDATA("M",1,356,1)),1,20),X=X_"ID:"_Y_$J("",20-$L(Y))
 S Y=$E($G(FDATA("M",1,142,1)),1,3),X=X_"PC:"_Y_$J("",3-$L(Y))
 S Y=$E($G(FDATA("M",1,127,1)),1,10),X=X_"PH:"_Y_$J("",10-$L(Y))
 S Y=$E($G(FDATA("M",1,240)),1,6),X=X_"CD:"_Y_$J("",6-$L(Y))
 S Y=$E($G(FDATA("M",1,757)),1,3),X=X_"PB:"_Y_$J("",3-$L(Y))
 S Y=$E($G(FDATA("M",1,144,1)),1,8),X=X_"ED:"_Y_$J("",8-$L(Y))
 S Y=$E($G(FDATA("M",1,145,1)),1,8),X=X_"TD:"_Y_$J("",8-$L(Y))
 S Y=$G(FDATA("M",1,138)),X=X_"LC:"_Y_$J("",1-$L(Y))
 S Y=$E($G(FDATA("M",1,926)),1,8),X=X_"FI:"_Y_$J("",8-$L(Y))
 S Y=$E($G(FDATA("M",1,140)),1,8),X=X_"FE:"_Y_$J("",8-$L(Y))
 S Y=$E($G(FDATA("M",1,141)),1,8),X=X_"FT:"_Y_$J("",8-$L(Y))
 S FDATA(504)=X
 Q
 ;
FILESTS ;EP  - NCPDP 5.1, D.0 response processing
 ; basic logic borrowed from ABSPOSH6
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
 N MEDN
 S MEDN=1   ;E1 will only have 1 transaction returned
 S:$D(FDATA("M",MEDN,112)) DR=$G(DR)_"112////"_$G(FDATA("M",MEDN,112))_";"
 S:$D(FDATA("M",MEDN,503)) DR=$G(DR)_"503////"_$G(FDATA("M",MEDN,503))_";"
 ;
 ; process reject and approved information if there is any
 S:$D(FDATA("M",MEDN,510)) DR=$G(DR)_"510////"_$G(FDATA("M",MEDN,510))_";"
 S:$D(FDATA("M",MEDN,547)) DR=$G(DR)_"547////"_$G(FDATA("M",MEDN,547))_";"
 ;
 ;last of the "normal fields" - additional and help desk information
 I $G(FDATA(102))="D0",$G(FDATA("M",1,112))'="R" D ADDBLD
 S:$D(FDATA("M",MEDN,526)) DR=$G(DR)_"526////"_$TR($G(FDATA("M",MEDN,526)),";","#")_";"
 S:$D(FDATA("M",MEDN,549)) DR=$G(DR)_"549////"_$G(FDATA("M",MEDN,549))_";"
 S:$D(FDATA("M",MEDN,550)) DR=$G(DR)_"550////"_$G(FDATA("M",MEDN,550))
 ;
 D ^DIE
 ;
 ;now for the subfiles
 K DIE,DA
 D:$D(FDATA("M",MEDN,510)) REPREJ   ;process the rej code multiple
 D:$D(FDATA("M",MEDN,547)) REPAPP   ;process the apprvd msg multiple
 ;
 ;
 ;
 Q
 ;
REPREJ ; This subroutine will process the reject repeating fields 
 ; that are a part of the status segment.
 ; Two fields here - 511 - Reject Code and
 ;                   546 - Reject field occurrence indicator
 ;
 N CNTR,COUNT,RJOC
 N DIC,DA,DIE,DR,X,DLAYGO
 ;
 S COUNT=$G(FDATA("M",MEDN,510))    ;reject count
 Q:COUNT'>0
 ;
 ;set up our DIC variables for adding the multi header & entries
 S DIC="^ABSPE("_E1IEN_","_"511,"
 S DA(1)=E1IEN
 S DIC("P")=$P($G(^DD(9002313.7,511,0)),"^",2)
 S DIC(0)="L"
 S DLAYGO=9002313
 S X=0
 ;
 ;now we can add the individual entries
 ;
 F CNTR=1:1:COUNT  D
 . S (X,RJOC)=""
 . S X=$G(FDATA("M",MEDN,511,CNTR))   ;rejection code
 . S RJOC=$G(FDATA("M",MEDN,546,CNTR))   ;reject fld occurence ind
 . I $G(X)]"" D
 .. D ^DIC    ;add the entry
 .. I $G(RJOC)]"" D  ;if there is an occurence
 ... N DIE,DR,DA     ;we'll need to update the record
 ... S DIE=DIC       ;with the information
 ... S DA(1)=E1IEN,DA=+Y
 ... S DR="546////"_RJOC
 ... D ^DIE
 ;
 Q
 ;
 ;
REPAPP ; This subroutine will process the approved repeating field 
 ; that is a part of the status segment.
 ; Field 548 - Approved Message Code
 ;
 N CNTR,COUNT,APP
 N DIC,DA,DIE,DR,X
 ;
 S COUNT=$G(FDATA("M",MEDN,547))    ;approved message code count
 Q:COUNT'>0
 ;
 ;
 ;because this is a multiple, we need to add the top level first
 S DIC="^ABSPE("_E1IEN_","_"548,"
 S DA(1)=E1IEN
 S DIC("P")=$P($G(^DD(9002313.7,548,0)),"^",2)
 S DIC(0)="L"
 S X=0
 ;
 ;now we can add the individual entries
 ;
 F CNTR=1:1:COUNT  D
 . S X=""
 . S X=$G(FDATA("M",MEDN,548,CNTR))   ;approved message code
 . D:$D(X) ^DIC
 ;
 Q
 ;
ADDBLD ;Build Field 526 - Additional message from D.0 fields
 N X,Y,I,LVL
 S X=""
 F I=2,3 D
 . S LVL=I-1 I '$D(FDATA("M",1,340,I)) S LVL=" "
 . S X=X_"OH:"_LVL
 . S Y=$E($G(FDATA("M",1,340,I)),1,6),X=X_"BN:"_Y_$J("",6-$L(Y))
 . S Y=$E($G(FDATA("M",1,991,I)),1,10),X=X_"PN:"_Y_$J("",10-$L(Y))
 . S Y=$E($G(FDATA("M",1,992,I)),1,15),X=X_"GP:"_Y_$J("",15-$L(Y))
 . S Y=$E($G(FDATA("M",1,356,I)),1,20),X=X_"ID:"_Y_$J("",20-$L(Y))
 . S Y=$E($G(FDATA("M",1,142,I)),1,3),X=X_"PC:"_Y_$J("",3-$L(Y))
 . S Y=$G(FDATA("M",1,143,I)),X=X_"RC:"_Y_$J("",1-$L(Y))
 . S Y=$E($G(FDATA("M",1,127,I)),1,10),X=X_"PH:"_Y_$J("",10-$L(Y))
 S FDATA("M",MEDN,526)=X
 ;
 Q
 ;
PRNTRESP ; let's print the response for them to see
 ;
 ; right here we need to prompt for the device
 ;
 Q:'$$DEVICE^ABSPOS6D
 U IO
 ;D DISPLAY^ABSPOSE1(E1IEN)
 D DISPLAY^ABSPOSE2(E1IEN)
 D BYE^ABSPOSU5
 ;
 Q
 ;
DIALOUT()          ; determine where we are connecting to
 ; Return a pointer to File 9002313.55, the DIAL OUT file.
 ; get the default dial-out, otherwise
 S X=$P($G(^ABSP(9002313.99,1,"DIAL-OUT DEFAULT")),U)
 I 'X S X=$O(^ABSP(9002313.55,"B","DEFAULT",0))
 I 'X S X=$O(^ABSP(9002313.55,0)) ; they deleted the DEFAULT one??
 Q X
CLMSMSG ; let the user know that we are processing - please stand by
 ;
 U 0
 W !!!,"Waiting to make a connection - please stand by."
 H 5
 Q
 ;
SHUTERR ; user requested that the comm line be shut down - can't
 ; process right now
 ;
 N WP
 S WP="COMM line is shut down ????? Can't sent E1."
 D RECERR
 ;
 U 0
 W !!,"*****************************************************",!
 W "*      COMM line is shut down-  UNABLE to send      *",!
 W "*      the eligibility check at this time.          *",!
 D CALLOIT
 ;
 Q
CONNERR ; can't connect - let user know and ask them to try again
 ; later
 ;
 N WP
 S WP="ABSPECX(ABSPOSQ3 is currently running - can't send E1."
 D RECERR
 ;
 U 0
 W !!,"*****************************************************",!
 W "*                  UNABLE to send                   *",!
 W "*      the eligibility check at this time.          *",!
 D CALLOIT
 ;
 Q
ERRCPRC ; can't send just now - claims are processing - ask user to
 ; try again later
 ;
 N WP
 S WP="ABSPECX(ABSPOSQ3 is currently running - can't send E1."
 D RECERR
 ;
 U 0
 W !!,"*****************************************************",!
 W "*  Claims are currently being sent - connection     **",!
 W "*  required for eligibility check is unavailable.   *",!
 D CALLOIT
 ;
 Q
ERRRESP ; we didn't get a good response - let user now, log it in the
 ; raw message in ^ABSPE
 ;
 N WP
 S WP="ERROR in receiving message - RET is: "_RET
 D RECERR
 ;
 U 0
 W !!,"*****************************************************",!
 W "*  Response was corrupt, or did not come back.      *",!
 D CALLOIT
 ;
 Q
CALLOIT ; this is standard for all messages when we are communicating
 ; with the user
 ;
 W "*                                                   *",!
 W "*    Please wait a few minutes and try again.       *",!
 W "*                                                   *",!
  ;IHS/OIT/SCR 09/23/08 patch 28 - BEGIN changed support info
 ;W "*  If the problem persist, please contact the       *",!
 W "*   If the problem persist, please contact          *",!
 ;W "*  OIT support desk at 1-888-830-7280.              *",!
 W "*                 your local helpdesk.              *",!
 ;IHS/OIT/SCR 09/23/08 patch 28 - END changed support info
 W "*****************************************************",!!
 H 5
 ;
 Q
 ;
RECERR ; this will record that the response was not received in the 9999999
 ; field in the ^ABSPE file
 ;
 N DIE,DA,DR
 ;
 D WP^DIE(9002313.7,E1IEN_",",2000,"","WP")  ;raw resp data
 ;
 S DA=E1IEN
 S DIE="^ABSPE("
 S DR="9999999////ERROR"     ;RESPSTS field 
 D ^DIE
 ;
 D CLOSE^ABSPOSAB(DIALOUT)  ;close the connection for other transactions
 D ENDJOB99^ABSPOSQ3  ;kill entry in ^ABSPECX("ABSPOSQ3"
 ;
 Q
