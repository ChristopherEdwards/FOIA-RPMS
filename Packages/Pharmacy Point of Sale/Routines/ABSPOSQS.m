ABSPOSQS ; IHS/FCS/DRS - special queuing considerations ; [ 08/28/2002  2:25 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**1,2,3,37,40**;JUN 21, 2001
 ;
 ; IHS/DSD/lwj 4/18/02 on behalf of Patrick Cox
 ; IHS/OKCAO/POC 10/2/01  In Oklahoma there is a general 3 punch
 ; a month limitation.  However, there are no limitation for kids
 ; under the age of 18, or for patients in a nursing home.  This 
 ; change will simply address the limitation on the kids under 18.
 ; The maximum number of prescriptions will simply be set to 999 
 ; to reflect no limitation.
 ;
 ; IHS/SD/lwj 6/17/02 on behalf of Patrick Cox
 ; IHS/OKCAO/POC 5/22/02  In the subroutine CAIDPAID, the routine
 ; attempts to count how many Medicaid paid repsonses have been
 ; received for a given month. The script count could be incorrectly 
 ; inflatted if a script was flled/reflled in a prev month, but was 
 ; sbmtd/resbmtd in the current month. Original logic was only  
 ; looking at the month of the claim - not the DOS.  Logic
 ; changed to use the scripts fill dt/refill dt instead of clm dt.
 ; (effected back billing, or resubmittal of previous month scripts
 ; when current month limitation had been reached)
 ; 
 ; IHS/SD/lwj 8/28/02 on behalf of Patrick Cox (OKCAO/POC)
 ; Cache systems do not allow the reverse dollar order on arrays.  
 ; Patrick simply reversed the sign in the PRICEORD array, which 
 ; allowed the values to appear in descending order - this eliminated
 ; the need for the reverse $O on the PRICEORD array.
 ;
 Q
STAT19() ;EP - is called at the bottom of ABSPOSQ1
 ; if there are any claims of status 19 - waiting for special 
 ; Oklahoma Medicaid rule to run its course
 N ROU S ROU=$T(+0)
 L +^TMP("ABSPOSQS"):0 Q:'$T 0 ; only one of these running
 N COUNT30 S COUNT30=0 ; count how many 19s got pushed to status 30
 D RULE19
 L -^TMP("ABSPOSQS")
 ; If there are still any claims with status = 19,
 ; then you need to schedule ABSPOSQ1 to run again in a little while.
 I $D(^ABSPT("AD",19)) D
 . N WAIT S WAIT=$P(^ABSP(9002313.99,1,"SPECIAL"),U,2)
 . S:'WAIT WAIT=60
 . S WAIT="."_$TR($J(WAIT\3600,2)_$J(WAIT#3600\60,2)_$J(WAIT#60,2)," ","0")
 . D TASKAT^ABSPOSIZ($$TADDNOW^ABSPOSUD(WAIT))
 Q COUNT30
RULE19 ;
 N INCYCLE,NLIMIT,SINCEDAT,PAT,IEN59,STAT,LASTUPD,I,X,Y
 ;
 ; Gather all the claims with status 19 into ^TMP("ABSPOSQS",$J,PAT,19,IEN59)
 ; Medicaid claims only - already taken care of, in that only 
 ;  Medicaid claims can ever be in status 19
 ; For any status, just set ^TMP("ABSPOSQS",$J,PAT,status)=latest last-update
 ;   to make it easy to detect if a given patient has any non-19's.
 ;
 K ^TMP("ABSPOSQS")
 S STAT="",IEN59=0
 F  S STAT=$O(^ABSPT("AD",STAT)) Q:STAT=""  Q:STAT=99  D
 . S IEN59=0
 . F  S IEN59=$O(^ABSPT("AD",STAT,IEN59)) Q:'IEN59  D
 . . ; $G() in next line guards against corrupt index
 . . S PAT=$P($G(^ABSPT(IEN59,0)),U,6) Q:'PAT
 . . S LASTUPD=$P(^ABSPT(IEN59,0),U,8)
 . . S X=$G(^TMP("ABSPOSQS",$J,PAT,STAT))
 . . I LASTUPD>X S ^TMP("ABSPOSQS",$J,PAT,STAT)=LASTUPD
 . . I STAT=19 S ^TMP("ABSPOSQS",$J,PAT,STAT,IEN59)=""
 ;
 ; Loop for each such patient:
 S PAT="" F  S PAT=$O(^TMP("ABSPOSQS",$J,PAT)) Q:'PAT  D
 . I '$D(^TMP("ABSPOSQS",$J,PAT,19)) Q  ; no 19's for this patient; nothing to do
 . D PAT19
 Q
PAT19 ; Then look at each patient's situation:
 ;
 ; If the patient has any claims with status 20-98 (i.e., actively
 ;  going through POS right now)  then leave their 19s as 19 for now.
 ; What we do with these depends on how the others turn out.
 ;
 ;  Also, if the patient has any with status <19, wait for those to
 ;  catch up - because apparently, data entry is still going on
 ;  and we want to wait, so we just pick off the three highest-priced.
 ;
 I $O(^TMP("ABSPOSQS",$J,PAT,""))'=19 Q  ; there are some w/status < 19
 I $O(^TMP("ABSPOSQS",$J,PAT,19))'="" Q  ; there are some w/status > 19
 ;
 ; IHS/DSD/lwj 04/18/02  on behalf of IHS/OKCAO/POC 10/2/2001 
 ; begin changes
 ;
 ;N LIMIT,MAX S MAX=3 S LIMIT=MAX-$$CAIDPAID  ;IHS/OKCAO/POC rmkd out
 N ABSPINS,ABSPERR,LIMIT,MAX,DFN      ;IHS/OKCAO/POC new def
 ;
 ; In the ABSP setup file, there is a special node:
 ;   ^ABSP(9002313.99,1,"SPECIAL")=OK MEDICAID INS NAME^OK MEDICAID
 ;                                  CYCLE^OK MEDICAID LIMIT
 ; This portion of the code is retrieving the INS name, and the limits
 ; If the insurer is Oklahoma, we will adjust the limits for kids
 ;
 S ABSPINS=$$GET1^DIQ(9002313.99,"1,",1960.01,"","","ABSPERR")
 S MAX=+$P($G(^ABSP(9002313.99,1,"SPECIAL")),U,3) ;IHS/OKCAO/POC def 
 S:'MAX MAX=3                          ;IHS/OKCAO/POC use def when pos
 ;
 ;If this is for Oklahoma and patient is under 18 extend limits
 ; (insurance name is either Oklahoma Medicaid or Oklahoma)
 I ($G(ABSPINS)["OKLAHOMA")&($$AGE^AUPNPAT(PAT)<18) S MAX=999
 ;
 S LIMIT=MAX-$$CAIDPAID
 ;
 ; IHS/DSD/lwj 04/18/02 for IHS/OKCAO/POC 10/2/01 end changes
 ;
 ;
 ; LIMIT = how many more paid responses we're allowed for this month
 ;
 ; If LIMIT=0,  we've used up our limit of Medicaid prescriptions
 ;   for the month.  Each of these will have to bump to the next
 ;   insurer.  (For now, just reject them
 ;
 I LIMIT=0 D  Q
 . S IEN59=0 F  S IEN59=$O(^TMP("ABSPOSQS",$J,PAT,19,IEN59)) Q:'IEN59  D
 . . D SETSLOT^ABSPOSL(IEN59)
 . . N MSG S MSG="Medicaid monthly limit of "_MAX_" reached."
 . . D LOG^ABSPOSL(MSG)
 . . I $$BUMPINS^ABSPOSQA(IEN59) D  ; bump to next insurer
 . . . ; Succeeded, there is more insurance ; 
 . . . ; And $$BUMPINS reset status to 0
 . . . D LOG^ABSPOSL("   We will try the next insurer.")
 . . E  D
 . . . ; Failed - no more insurance - $$BUMPINS set status to 99
 . . . N ABSBRXI S ABSBRXI=IEN59 ; unfortunate variable naming
 . . . D SETRESU^ABSPOSU(19,MSG)
 . . D RELSLOT^ABSPOSL
 ;
 ; We can still submit some Medicaid prescriptions, but let's
 ; make sure we have all the ones that we're going to get at 
 ; this visit - make sure that the most recent activity on
 ; any of the status 19 claims is at least 2 minutes old.
 ; Otherwise, there may be some more coming, and we would rather
 ; wait and make sure we get the more expensive ones.
 I $$TDIFNOW^ABSPOSUD(^TMP("ABSPOSQS",$J,PAT,19))<$P(^ABSP(9002313.99,1,"SPECIAL"),U,2) Q
 ;
 ; If LIMIT>0, then take this many of the patient's status 19 claims
 ; and change them to status 30.  Any other 19s stay as 19s, 
 ; as we need to wait and see how the others turn out.  If they're
 ; rejected, we could still submit a few of the other 19s.
 ;
 N PRICEORD ; set PRICEORD(price,ien59)="" for each of this pat's 19s
 N PRICE,N
 S IEN59=0
 F  S IEN59=$O(^TMP("ABSPOSQS",$J,PAT,19,IEN59)) Q:'IEN59  D
 . N PRICE S PRICE=$P(^ABSPT(IEN59,5),U,5)
 . ;IHS/SD/lwj 8/28/02 on behalf of IHS/OKCAO/POS nxt line remarked
 . ; out, following line added
 . ; S PRICEORD(PRICE,IEN59)=""  ;IHS/OKCAO/POS 8/28/02
 . S PRICEORD(0-PRICE,IEN59)=""  ;IHS/OKCAO/POC 8/28/02 reverse order
 S PRICE="",N=0
 F  D  Q:PRICE=""  Q:N=LIMIT
 . ;IHS/SD/lwj 8/28/02 on behalf of IHS/OKCAO/POC nxt line remarked
 . ;out, following line added (reverse $O does not work on arrays
 . ;Cache)
 . ;S PRICE=$O(PRICEORD(PRICE),-1) Q:PRICE=""  ; from highest to lowest
 . S PRICE=$O(PRICEORD(PRICE)) Q:PRICE=""  ; from highest to lowest
 . S IEN59=0
 . F  S IEN59=$O(PRICEORD(PRICE,IEN59)) Q:IEN59=""  Q:N=LIMIT  D
 . . N ABSBRXI S ABSBRXI=IEN59 D SETSTAT^ABSPOSU(30)
 . . S N=N+1 ; how many submitted for this patient
 . . S COUNT30=COUNT30+1 ; how many submitted in total by this routine
 Q
CAIDPAID()         ; count how many Medicaid paid responses for this patient
 ; this month, up to 3 maximum
 ; given PAT = patient IEN;   MAX=3
 ;
 ; IHS/OKCAO/POS 5/22/02 (IHS/SD/lwj 6/17/02) changed to look
 ; at month script was filled/refilled for considering script in cnt
 ;
 N INS S INS=$P(^ABSP(9002313.99,1,"SPECIAL"),U) ; insurer we seek
 N FOUND S FOUND=0 ; count how many are found
 N SINCE S SINCE=DT,$E(SINCE,6,7)="00" ; yyymm00
 N IEN59,STOP S IEN59=0,STOP=0
 F  S IEN59=$O(^ABSPT("AC",PAT,IEN59)) D  Q:STOP
 . I 'IEN59 S STOP=1 Q
 . S X=^ABSPT(IEN59,0)
 . ; IHS/OKCAO/POC 05/22/02 (IHS/SD/lwj 6/17/02) begin changes
 . ;I $P(X,U,8)<SINCE Q  ; previous month
 . N DATE
 . D
 . . N RXIEN,REFIEN
 . . S RXIEN=$P($G(^ABSPT(IEN59,1)),U,11),REFIEN=$P($G(^ABSPT(IEN59,1)),U,1)
 . . S DATE=$S(+REFIEN=0:$P($G(^PSRX(RXIEN,2)),U,2),1:$P($G(^PSRX(RXIEN,1,+REFIEN,0)),U,1))
 . I +DATE Q:DATE<SINCE
 . ; IHS/OKCAO/POS 05/22/02 (IHS/SD/lwj 6/17/02) end changes
 . I 99'=$P(X,U,2) Q  ; not completed yet
 . I INS'=$P(^ABSPT(IEN59,1),U,6) Q  ; not this insurer
 . ;IHS/OIT/RAN 021710 patch 37 Do not count if claim has been reversed -BEGIN
 . ;N Y S Y=$$RXPAID^ABSPOSNC(IEN59) Q:$P(Y,U,3)="Accepted reversal"  ;IHS/OIT/CNI/SCR patch 40 OKC - replaced with next three lines
 . N ABSPINFO
 . S ABSPINFO=$$RXPAID^ABSPOSNC(IEN59)
 . Q:$P(ABSPINFO,U,1)=0   ;there are a lot of reasons not to count this
 . ;IHS/OIT/RAN 021710 patch 37 Do not count if claim has been reversed -END
 . I $$PAID^ABSPOSQ4(IEN59) D
 . . S FOUND=FOUND+1
 . . I FOUND=MAX S STOP=1
 Q FOUND
