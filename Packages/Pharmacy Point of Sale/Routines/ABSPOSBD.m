ABSPOSBD ; IHS/FCS/DRS - POS billing - background ;      [ 06/22/2001  2:14 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**22,28,32,36**;JUN 21, 2001
 ;
 ;IHS/SD/RLT - 09/12/07 - Patch 22
 ; Added code to hold claims from being sent to 3PB if the site
 ; affiliation is IHS and the insurer does not have a tax id.
 ; -----
 ;IHS/OIT/SCR - 09/16/08 - Patch 28
 ; REMOVED code to hold claims being sent to 3PB if the site
 ; affiliation is IHS and the insurer does not have a tax id.
 Q
SCHEDULE(DELTA) ; EP - schedule it to run again, if needed
 ; DELTA = how many minutes
 L +^TMP("ABSPOSBD","SCHEDULE"):0 Q:'$T
 I '$D(DELTA) S DELTA=$$DELTA
 S DELTA=DELTA*60\1 ; how many seconds
 I DELTA<60 S DELTA=60 ; but not immediately
 N ATTIME S ATTIME=$$TADDNOWS^ABSPOSUD(DELTA)
 N NEXTTIME S NEXTTIME=$$NEXTTIME
 I 'NEXTTIME!(ATTIME<NEXTTIME) D
 . D TASKAT(ATTIME)
 L -^TMP("ABSPOSBD","SCHEDULE")
 Q
NEXTTIME() ; when is it scheduled to run again?
 N NEXTTIME S NEXTTIME=$P($G(^ABSP(9002313.99,1,"BILLING - NEW")),U)
 I NEXTTIME'>$$NOW^ABSPOS Q 0 ; this time is already past
 Q NEXTTIME ; future
DELTA() ; delta time until background job runs - in minutes
 N DELTA S DELTA=$P($G(^ABSP(9002313.99,1,"BILLING - NEW")),U,2)
 I 'DELTA S DELTA=15
 I $$DISABLED,DELTA<60 S DELTA=60 ; min 1 hour if it's disabled
 Q DELTA
DISABLED() Q $P($G(^ABSP(9002313.99,1,"BILLING - NEW")),U,3)=1
DISABLE ; EP -
 S $P(^ABSP(9002313.99,1,"BILLING - NEW"),U,3)=1 Q
ENABLE ; EP -
 S $P(^ABSP(9002313.99,1,"BILLING - NEW"),U,3)=0
 D TASKAT()
 Q
TASKAT(ZTDTH)    ; 
 I '$D(ZTDTH) S ZTDTH=$$NOW^ABSPOS
 I '$$NEXTTIME!(ZTDTH<$$NEXTTIME) D
 . S $P(^ABSP(9002313.99,1,"BILLING - NEW"),U)=ZTDTH
 N ZTRTN,ZTIO
 S ZTRTN="BACKGR^"_$T(+0),ZTIO=""
 ;ZW ZTDTH,ZTRTN
 D ^%ZTLOAD
 Q
ANY() Q $O(^ABSPTL("AS",1,0)) ; any need billing?
 ;IHS/OIT/SCR - 9/16/08 - START changes to REMOVE code to hold claims
 ;ANYHOLD() ;
 ;check for any entries in ^ABSPHOLD
 ;quit if no entries
 ;N ANYHOLD
 ;S ANYHOLD=$O(^ABSPHOLD(0))
 ;Q:'ANYHOLD 0
 ;if there are entries check last run
 ;run only once a day when date changes
 ;N RUNDT
 ;S RUNDT=$P($G(^ABSP(9002313.99,1,"BILLING - NEW")),U,8)
 ;Q:RUNDT'=CURRDT 1
 ;Q 0
 ;
 ;IHS/OIT/SCR - 9/16/08 - END changes to REMOVE code to hold claims
 ; LOCK, UNLOCK also used by ABSPOSBX
LOCK() ;EP -
 L +^TMP("ABSPOSBD","BACKGR"):15 Q $T
 ;
UNLOCK ;EP -
 L -^TMP("ABSPOSBD","BACKGR") Q
BACKGR ;
 N CURRDT
 N ABSPBILD  ;IHS/OIT/SCR 011210 patch 36
 D NOW^%DTC
 S CURRDT=X
 ;IHS/OIT/SCR 9/16/08 START changes to REMOVE code to hold claims
 ; I '$$ANY&('$$ANYHOLD) Q  ; none need billing
 I '$$ANY Q  ; none need billing
 ;IHS/OIT/SCR 9/16/08 END changes to REMOVE code to hold claims
 I '$$LOCK Q
 D INIT^ABSPOSL(DT+.2,1)
 I $$ANY D
 . D LOG("Billing job begins")
 . I $$DISABLED D  G BACKGR99
 .. D LOG("Disabled; will reschedule.")
 . ;
 . ;  Loop: Process the 9002313.57 entries which need billing.
 . ;  They are listed in ^ABSPTL("AS",1,*)
 . ;  ABSP57 is the variable name expected by POSTING^ABSPOSBB
 . ;
 . N ABSP57 S ABSP57=0
 . F  S ABSP57=$O(^ABSPTL("AS",1,ABSP57)) Q:'ABSP57  D
 .. ;D LOG^ABSPOSL("Posting transaction "_ABSP57_".")
 .. ; ;IHS/OIT/SCR 12/24/09 Santa Rosa pre-patch 36 : Before calling the 3PB API, check to
 ..;see if the transaction has NEEDS BILLED flag set - if not, Kill the cross-reference
 ..;START
 ..S ABSPBILD=$P(^ABSPTL(ABSP57,0),"^",16)  ;corrupt x-reference causes infinite loop in background process
 ..I ABSPBILD'=1 K ^ABSPTL("AS",1,ABSP57)  ;IHS/OIT/SCR 011210 patch 36
 ..I ABSPBILD=1 D
 ...D POSTING^ABSPOSBB ; post the transaction
 ...;IHS/OIT/SCR 062309 patch 32 the condition has to do with HELD claims functionality removed in patch 29
 ...;D:'$D(^ABSPTL("AS",2,ABSP57)) SETFLAG^ABSPOSBC(ABSP57,0) ; clear the "needs billing" flag
 ...D SETFLAG^ABSPOSBC(ABSP57,0) ; clear the "needs billing" flag
 ...Q
 ..Q
 .Q
 ;IHS/OIT/SCR 12/24/09 Santa Rosa pre-patch 36 : Before calling the 3PB API, check to
 ;see if the transaction has information in the .15 field - if so, Kill the cross-reference
 ;END
 ;
 ;IHS/OIT/SCR - 09/16/07 - Patch 28 - START changes to REMOVE code to hold claims
 ;IHS/SD/RLT - 09/12/07 - Patch 22
 ;  Loop: Process the held claims in ^ABSPHOLD.
 ;  If tax id has been entered send to 3PB.
 ;I $$ANYHOLD D
 ;. D LOG("Holding job begins")
 ;. I $$DISABLED D  G BACKGR99
 ;.. D LOG("Disabled; will reschedule.")
 ;. N HOLDCNT S HOLDCNT=0
 ;. N HOLDIEN S HOLDIEN=0
 ;. F  S HOLDIEN=$O(^ABSPHOLD(HOLDIEN)) Q:'+HOLDIEN  D
 ;.. D CHKHOLD^ABSPOSBH
 ;. S $P(^ABSP(9002313.99,1,"BILLING - NEW"),U,8)=CURRDT
 ;. D LOG^ABSPOSL(HOLDCNT_" 3PB transactions on hold.")
 ;IHS/OIT/SCR - 09/16/07 - Patch 28 - END changes to REMOVE code to hold claims
 ;
 D DONE^ABSPOSL
 ;
BACKGR99 ;
 D UNLOCK
 I $$ANY D SCHEDULE($S($$DISABLED:60,1:1)) ; in case any slipped in while we were leaving
 Q
ILCAR ;
 Q
LOG(X) D LOG^ABSPOSL(X) Q
PRINTLOG D PRINTLOG^ABSPOSL(DT+.2) Q
