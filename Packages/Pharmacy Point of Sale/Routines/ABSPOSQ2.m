ABSPOSQ2 ; IHS/FCS/DRS - form transmission packets ;  [ 11/07/2002  6:57 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,31,42**;JUN 01, 2001;Build 15
 ;
 ;  Status comes in as 30. Or as 31.
 ;  Status set to 40 which PACKET() is in progress.
 ;  When PACKET() is done, the status is changed to 50
 ;  The transmission packet is in ^ABSPECX("POS",DIALOUT,"C",*)
 ;  and ABSPOSQ3 is scheduled to do the transmission.
 ;
 ;  Split-off code:
 ;      STATUS31^ABSPOSQF - Insurer asleep condition is handled here
 ;      PACKET^ABSPOSQG   - packetizing RXILIST(*)
 ;
 ;----------------------------------------------------------------
 ; IHS/SD/lwj 8/5/02  NCPDP 5.1 changes
 ;  Prior Authorization claims must now be sent one by one - no
 ;  bundling allowed.  New logic added before bundling to check
 ;  the overrides for field 498.01 (Request Type), 498.02 (Request
 ;  period date-begin),  498.03 (Request period date-end), and 498.04
 ;  (basis of request).  These four fields are required for a prior
 ;  authorization claim, and if we encounter even one of the fields
 ;  we will keep the claim from bundling.
 ;
 ;
PACKETS ; construct packets for transmission to NDC
 ; your work list is ^ABSPT("AD",30)
 ;
 ; LOGGING:  Do NOT keep a "current" slot.
 ;  When you need to log something, use one of these routines:
 ;  LOG59^ABSPOSQ(MSG,IEN59) - log MSG to this one slot
 ;  LOG2LIST^ABSPOSQ(MSG) - log MSG to all on RXILIST(*)
 ;  LOG2CLM^ABSPOSQ(MSG,IEN02) - log MSG to all on this 9002313.02 claim
 ;
 N ERROR,SILENT S SILENT=1
 N RXILIST,STATUS30
 D STATUS31^ABSPOSQF ; deal with insurer alseep waiting
 F STATUS30=30 I $D(^ABSPT("AD",STATUS30)) D STATUS30
 ; If there are still any claims with status 30,
 ; perhaps due to failed LOCK59, queue up ABSPOSQ2 to run again
 N NEEDQ1 S NEEDQ1=$O(^ABSPT("AD",30,0))
 ; Don't worry about status 31 - retry after insurer asleep
 ; was already scheduled, when the response packet came.
 ;I 'NEEDQ1 S NEEDQ1=$O(^ABSPT("AD",31,0))
 I NEEDQ1 H 60 D TASK^ABSPOSQ1
 Q
SETSTAT(NEWSTAT) ;EP - ABSPOSQF ; given IEN59
 N ABSBRXI S ABSBRXI=IEN59 ; unfortunate variable naming convention
 D SETSTAT^ABSPOSU(NEWSTAT)
 Q
SETRESU(RESCODE,TEXT)   ; given IEN59
 N ABSBRXI S ABSBRXI=IEN59 ; unfortunate variable naming convention
 D SETRESU^ABSPOSU(RESCODE,TEXT)
 Q
 ; Locking and unlocking the list of claims with
 ; with STATUS30=30 or 31. The lock should always succeed.
 ; But since it's required to be a timed lock, LOCK59 is a $$,
 ; true if successful, false if failure.
LOCK59() ;EP - ABSPOSQF
 L +^ABSPT("AD",STATUS30):60 Q $T
UNLOCK59 ;EP - ABSPOSQF
 L -^ABSPT("AD",STATUS30) Q
NEXT59(X) ;EP - ABSPOSQF
 N INS,T
N59A S X=$O(^ABSPT("AD",STATUS30,X))
 I X="" Q X  ; end of list, return ""
 ; but if the insurer is asleep, don't take this one
 S INS=$P(^ABSPT(X,1),U,6)
 I $G(INS)="" Q X  ;IHS/OIT/SCR 05/12/09 patch 31 avoid undefined
 I '$D(^ABSPEI(INS)) Q X ;IHS/OIT/RAN 03/31/2011 patch 42 avoid undefined
 S T=$P($G(^ABSPEI(INS,101)),U) ; insurer asleep retry time
 I 'T Q X  ; insurer is not asleep
 ; - below here - insurer is asleep -
 ; If cancellation is requested, let it through, regardless of sleep.
 ; This will speed it on its way to cancellation
 I $G(^ABSPT(X,3)) Q X
 ; If necessary, update the .59's record of when to retry
 I $P($G(^ABSPT(X,8)),U)'=T D  ;
 . S $P(^ABSPT(X,8),U)=T ; stamp with latest retry time
 . N IEN59 S IEN59=X D SETSTAT(31) ; force screen update, too
 . D LOG59^ABSPOSQ("Insurer still asleep - retry at "_T,IEN59)
 I T<$$NOW Q X  ; time to retry, so yes, we do this one
 ;. don't clear this - a successful non-sleep response will clear it
 ;. S $P(^ABSPEI(INS,101),U)="" ; clear the sleep-until time
 ;. but don't clear the piece 5 current interval, as we may increment
 ; Else still in waiting - if it's status 30, change it to 31
 I STATUS30=30 D
 . N IEN59 S IEN59=X D SETSTAT(31)
 . S $P(^ABSPT(IEN59,8),U)=$P(^ABSPEI(INS,101),U)
 . S $P(^ABSPT(IEN59,8),U,3)=INS
 G N59A ; still in wait time; don't look at this claim
NOW() N %,%H,%I,X D NOW^%DTC Q %
STATUS30 ; given STATUS30=30
 N IEN59 S IEN59=""
 Q:'$$LOCK59
 F  S IEN59=$$NEXT59(IEN59) Q:IEN59=""  D
 . K RXILIST ; init list each time through this loop
 . S RXILIST(IEN59)=""
 . D SETSTAT(40) ; set its status to "packetizing"
 .; Reversals go in a packet alone
 . I $G(^ABSPT(IEN59,4)) G POINTX
 .;
 .;IHS/SD/lwj 8/5/02  NCPDP 5.1 - claim cannot be bundled if 
 .; there is prior authorization information
 .; use CHKPA when the processor are ready to use the actual
 .; prior authorization segment - for now, use the CHKPA2
 .; G:$$CHKPA() POINTX   
 . G:$$CHKPA2() POINTX
 .; 
 .; Who is the patient?   Find all other prescriptions for this
 .; patient which have status 30, and add them to the RXILIST, too
 .; Must also have same VISIT and same DIVISION
 .;
 . N RA0,RA1 S RA0=^ABSPT(IEN59,0),RA1=^(1)
 . N IEN59 S IEN59="" ; preserve the top-level index!
 . F  S IEN59=$$NEXT59(IEN59) Q:'IEN59  D
 . . N RB0,RB1 S RB0=^ABSPT(IEN59,0),RB1=^(1)
 . . ; Only bundle when you have the same:
 . . ; Patient, Visit, Division, Division Source, Insurer, Pharmacy
 . . I $P(RA0,U,6,7)'=$P(RB0,U,6,7) Q
 . . I $P(RA1,U,4,7)'=$P(RB1,U,4,7) Q
 . . I $P(RB0,U,2)'=30 Q  ; might have been canceled, or maybe 31'd
 . . I $P(RB0,U,2)'=STATUS30 D  Q
 . . . D IMPOSS^ABSPOSUE("P","TI","IEN59 status "_$P(RB0,U,2)_" but must be 30",,"STATUS30",$T(+0))
 . . D SETSTAT(40)
 . . S RXILIST(IEN59)=""
POINTX . ; (reversals branch here around multi-claim packeting)
 . ;
 . ; so now we have a big list of prescriptions, RXILIST(*)
 . ; they're all marked with status = 40 PACKETIZING
 . ; Get going - packetize them!
 . ;
 . S ERROR=$$PACKET^ABSPOSQG ; 
 . ;
 . ; Having packetized, reset status to 50, Waiting for transmit
 . ; There should never be an error returned by $$PACKET,
 . ; although it could happen.
 . ; But if there was an error, reset the status to 99 right now.
 . ; And set that status for every prescription in the RXILIST,
 . ;  even if maybe only one of them caused all the trouble.
 . ;
 . S IEN59="" F  S IEN59=$O(RXILIST(IEN59)) Q:IEN59=""  D
 . . I ERROR D
 . . . D SETSTAT(99) ; 
 . . . D SETRESU($P(ERROR,U),$P(ERROR,U,2,$L(ERROR,U))) ;
 . . E  D
 . . . D SETSTAT(50) ; "Waiting for transmit"
 D UNLOCK59
 Q
 ;
 ; TASK^ABSPOSQ2  starts up a sender-receiver in ABSPOSQ3.
 ; TASK is an entry point used by POKE^ABSPOS2D
 ; It may well be called from other places in the future, 
 ; if we try to be clever and start the dialing while we're getting
 ; claim information together, for instance.
 ;
TASK ;EP - ABSPOS2D,ABSPOSAP,ABSPOSC3,ABSPOSQG
 N X,Y,%DT
 S X="N",%DT="ST" D ^%DT
 D TASKAT(Y)
 Q
TASKAT(ZTDTH) ;EP - ABSPOSQJ
 ;ZTDTH = time when you want COMMS^ABSPOSQ3 to run
 ; called from TASK, above, normally
 ; called here from ABSPOSQ3 when it's requeueing itself for 
 ; retry after a dial-out error condition
 ;N (DUZ,DIALOUT,TIME,ZTDTH)
 N ZTRTN,ZTIO,ZTSAVE
 S ZTRTN="COMMS^ABSPOSQ3",ZTIO=""
 S ZTSAVE("DIALOUT")="" ; which entry in 9002313.55
 D ^%ZTLOAD
 Q
KSCRATCH ;EP - ABSPOSQG ; Kill scratch globals
 K ^ABSPECX($J,"R")
 K ^ABSPECX($J,"C")
 Q
 ;
CHKPA() ;---------------------------------------------------------------  
 ;IHS/SD/lwj 8/30/02 NCPDP 5.1 - we aren't quite ready for this 
 ; yet - the below logic is going to work with the actual 
 ; prior authorization segment, and no one is going to use that
 ; or support that segment for a while.  SO.....I'm leaving this
 ; here for future reference - BUT for now, we're going to use
 ; the CHKPA2 routine to simply check for field 461 and 461.
 ;*
 ;IHS/SD/lwj  8/5/02  NCPDP 5.1  If any of the following fields  
 ; appear as an override on this claim, we must consider it a prior
 ; authorization claim, and it cannot be bundled with other claims.
 ; 498.01 Request Type
 ; 498.02 Request Period Date Begin
 ; 498.03 Request Period Date End
 ; 498.04 Basis of Request
 ;
 N OVRREC,OVRFLD,NCPDPF,NCPDPFN,PACLM
 S PACLM=0
 ;
 S OVRREC=$P($G(^ABSPT(IEN59,1)),U,13)   ;grab the overrides
 Q:OVRREC="" 0   ;no overrides - can't be a prior auth claim
 ;
 ; loop through the overrides and look for the prior auth fields
 S OVRFLD=0
 F  S OVRFLD=$O(^ABSP(9002313.511,OVRREC,1,OVRFLD)) Q:'+OVRFLD  D
 . S NCPDPF=$P($G(^ABSP(9002313.511,OVRREC,1,OVRFLD,0)),U) ;int fld
 . S NCPDPFN=$P($G(^ABSPF(9002313.91,NCPDPF,0)),U)  ;fld number
 . Q:(NCPDPFN<498.01)!(NCPDPFN>498.04)
 . S PACLM=1
 ;
 Q PACLM
 ;
CHKPA2() ;---------------------------------------------------------------  
 ; IHS/SD/lwj  8/30/02  NCPDP 5.1
 ;Until processors are ready to use the prior authorization 
 ; segment, we are going to use this routine to check for 
 ; a prior authorization.  To do this we will simply check
 ; for field 461 (Prior Authorization type code) and field
 ; 462 (Prior Authorization Number Submitted)
 ; If either exist, we will not bundle the claim.  Prior 
 ; authorization claims must be sent on their own.
 ;*
 ;
 N PATYP,PANUM
 S PACLM=0
 ;
 S PATYP=$P($G(^ABSPT(IEN59,1)),U,15)    ;prior auth type code
 S PANUM=$P($G(^ABSPT(IEN59,1)),U,9)     ;prior auth number
 I ($G(PATYP)'="")!($G(PANUM)'="") S PACLM=1
 ;
 Q PACLM
