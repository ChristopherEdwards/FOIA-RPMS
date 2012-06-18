ABSPOSK1 ; IHS/FCS/DRS - winnow POS data ;      [ 04/03/2002  10:05 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**1**;JUN 21, 2001
 Q
 ;
 ; IHS/SD/lwj 04/03/02  as per David's fix at ANMC - changed
 ; the check date so that it represents the date and time
 ; Without this fix, the log files are not being deleted properly.
 ; One change made to the "D" field in the LOGFILES subroutine.
 ;
 ; Contains the routines to evaluate one given entry
 ; The IEN is given to each one.  Called from loops in ABSPOSK
 ; Also passed in here:  AGE(*) array, BILLSYS
03 ;EP -  9002313.03 Responses
 N X,CLAIM,RECD S X=^ABSPR(IEN,0),CLAIM=$P(X,U),RECD=$P(X,U,2)
 I 'AGE("WINNOW .03 RAW DATA") S AGE("WINNOW .03 RAW DATA")=30
 I 'AGE("WINNOW .03 CONTENTS") S AGE("WINNOW .03 CONTENTS")=366
 ; The raw copy of the packet doesn't have to be kept around very 
 ; long - it's only there for diagnostic purposes; rarely used.
 I $$AGE(RECD)>AGE("WINNOW .03 RAW DATA") D
 . I $D(^ABSPR(IEN,"M")) D DELFIELD(9002313.03,IEN,9999)
 ; The contents should stick around awhile longer.
 ; In addition, if we're using the A/R interface, also require
 ; that the charge have been posted and that the bill have
 ; a zero balance.
 I ISILCAR,'$$CLOSED02(CLAIM) Q
 I $$PT5759(3) Q  ; no delete if pointed to by transaction
 I $$AGE02(CLAIM)>AGE("WINNOW .03 CONTENTS") D DELETE(9002313.03,IEN)
 Q
02 ;EP -  9002313.02 Claims
 ; Use the transmit date if it's there; otherwise the create date.
 I 'AGE("WINNOW .02 RAW DATA") S AGE("WINNOW .02 RAW DATA")=30
 I 'AGE("WINNOW .02 CONTENTS") S AGE("WINNOW .02 CONTENTS")=366
 ; Raw copy of the packet can be short-lived
 I $$AGE02(IEN)>AGE("WINNOW .02 RAW DATA") D
 . I $D(^ABSPC(IEN,"M")) D DELFIELD(9002313.02,IEN,9999)
 ; If using ILC A/R interface, also require that the charges have 
 ; been posted and that the bill have a zero balance.
 I ISILCAR,'$$CLOSED02(IEN) Q
 I $$PT5759(2) Q  ; no delete if pointed to by transaction
 I $O(^ABSPR("B",IEN,0)) Q  ; no delete if pointed to by .03
 I $$AGE02(IEN)>AGE("WINNOW .02 CONTENTS") D DELETE(9002313.02,IEN)
 Q
PT5759(F) ; does any 9002313.57 or 9002313.59 point to this claim or resp. IEN
 ; IEN points to the 9002313.02 or 9002313.03, too
 ; F = 2 for claims, F=3 for responses
 N RET,INDEX,FF S RET=0
 I F=2 D
 . F INDEX="AE","AER" F FF=9002313.57,9002313.59 D
 . . I FF=9002313.57,$O(^ABSPTL(INDEX,IEN,0)) S RET=1
 . . I FF=9002313.59,$O(^ABSPT(INDEX,IEN,0)) S RET=1
 E  I F=3 D
 . F INDEX="AF","AFR" F FF=9002313.57,9002313.59 D
 . . I FF=9002313.57,$O(^ABSPTL(INDEX,IEN,0)) S RET=1
 . . I FF=9002313.59,$O(^ABSPT(INDEX,IEN,0)) S RET=1
 E  D IMPOSS^ABSPOSUE("P","TI","Bad arg F="_F,,"PT5759",$T(+0))
 Q RET
AGE02(N) ; how old is the 9002313.02 entry?
 ; if dates are totally missing, it inserts a date
 ; Use transmit date if it's there; otherwise created date
 N X,Y S X=^ABSPC(N,0)
 S Y=$P(X,U,5) I 'Y S Y=$P(X,U,6) I 'Y D  Q:Y 0 Q $$IMPOSS^ABSPOSUE("DB","TI","Unable to store dates into ^ABSPC("_N,,"AGE02",$T(+0))
 . D LOG("Setting current date into 9002313.02 IEN="_N)
AG5 . N FDA,MSG S FDA(9002313.02,N_",",.06)="NOW"
 . D FILE^DIE("E","FDA","MSG")
 . I $D(MSG) G AG5:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"AGE02",$T(+0))
 . S Y=$$GET1^DIQ(9002313.02,N_",",.06,"I")
 Q $$AGE(Y)
CLOSED02(N) ; is ^ABSPC(N,... posted to A/R and with a zero balance?
 ;   ILC A/R only !!!  This code is not reached for other A/R types
 ; (also returns true if the .02 is unposted for over a year)
 N PCN S PCN=$P(^ABSPC(N,0),U,3)
 I PCN Q '$G(^ABSBITMS(9002302,PCN,3),U) ; true if zero balance
 ; not posted - is it over a year old?
 Q $$AGE02(N)>365
51 ;EP -  9002313.51 Input
 ; a month is more than enough
 I 'AGE("WINNOW .51") S AGE("WINNOW .51")=31
 I $$AGE($P(^ABSP(9002313.51,IEN,0),U))>AGE("WINNOW .51") D
 . D DELETE(9002313.51,IEN)
 Q
511 ;EP -  9002313.511 Override
 I 'AGE("WINNOW .511") S AGE("WINNOW .511")=366
 I $$AGE($P(^ABSP(9002313.51,IEN,0),U,2))>AGE("WINNOW .511") D
 . D DELETE(9002313.511,IEN)
 Q
ALL57 ;EP -  temporary - development use
 N DA F  S DA=$O(^ABSPTL(0)) Q:'DA  D
 . S DIE=9002313.57,DR=".01///@" D ^DIE
 K ^ABSPTL("NON-FILEMAN")
 Q
57 ;EP -  9002313.57 Billing
 ; AGE("WINNOW .57 AFTER POSTING") - if you have ILC A/R, then delete
 ;  a .57 entry this many days after posting, if account has 0 
 ;  balance.  Recommended 400.
 ; AGE("WINNOW UNPOSTED .57") - non ILC A/R or missed posting ILC A/R
 ;  Delete this many days after last update.
 ;  Recommended 100, though there shouldn't be a problem with 0, even.
 I 'AGE("WINNOW .57 AFTER POSTING") S AGE("WINNOW .57 AFTER POSTING")=400
 I 'AGE("WINNOW UNPOSTED .57") S AGE("WINNOW UNPOSTED .57")=100
 N BILLTHRU S BILLTHRU=$$BILLTHRU
 N IFACE57 S IFACE57=$$IFACE57
 ; BILLTHRU = which transaction # we've billed through
 ;  If there's no billing interface, then we say we've billed it all. 
 I IFACE57 S BILLTHRU=$$BILLTHRU
 E  S BILLTHRU=$P(^ABSPTL(0),U,3)
 ;
 I IEN>BILLTHRU Q  ; still need this one for billing
 N LUPDATE S LUPDATE=$$GET1^DIQ(9002313.57,IEN_",",7,"I") ; LAST UPDATE
 N ISPOSTED S ISPOSTED=$$GET1^DIQ(9002313.57,IEN_",",2,"I")
 I ISILCAR D  ; use the date the bill was created, instead
 . N PCNDFN S PCNDFN=$$GET1^DIQ(9002313.57,IEN_",",2,"I")
 . Q:'PCNDFN
 . N % S %=$$GET1^DIQ(9002302,PCNDFN_",",2.8)
 . I % S LUPDATE=%
 I 'LUPDATE D SETTODAY(9002313.57,7) Q
 N DELFLAG
 I ISPOSTED D
 . S DELFLAG=$$AGE(LUPDATE)>AGE("WINNOW .57 AFTER POSTING")&ISPOSTED
 E  D
 . S DELFLAG=$$AGE(LUPDATE)>AGE("WINNOW UNPOSTED .57")
 I DELFLAG D DELETE(9002313.57,IEN)
 Q
BILLTHRU()         ; through what transaction # have we billed?
 ; meaningful only for ILC and IHS a/r interfaces
 Q $$GET1^DIQ(9002313.99,"1,",230.01)
IFACE57()          ; true if you have a billing interface w/9002313.57
 Q $$DOINGAR^ABSPOSB
59 ;EP - 9002313.59 Working
 ; Let's keep them around for a year - someone might need to 
 ; set view to One Patient and call up something old
 I 'AGE("WINNOW .59") S AGE("WINNOW .59")=366
 N X S X=$P(^ABSPT(IEN,0),U,8)
 I 'X D  Q  ; stuff 
 . D LOG("Setting current date into 9002313.59 IEN="_N)
 . N FDA,MSG S FDA(9002313.59,IEN_",",7)=NOW D FILE^DIE("E","FDA","MSG")
 I $$AGE(X)>AGE("WINNOW .59") D DELETE(9002313.59,IEN)
 Q
LOGFILES ;EP -  ^ABSPECP("LOG",IEN,
 ; AGE("WINNOW LOG FILES") - this many days following the most recent
 ; write to the file - recommended 90; could be as low as you want
 I 'AGE("WINNOW LOG FILES") S AGE("WINNOW LOG FILES")=90
 N D S D=$P($G(^ABSPECP("LOG",IEN)),U,3)
 I 'D S D=$P($G(^ABSPECP("LOG",IEN)),U)
 I 'D S $P(^ABSPECP("LOG",IEN),U)=$H Q  ; no date - give it today's
 ;      and it will be deleted at some later date
 ; unusual case with log files - it's a $H date - must convert it
 ;
 ; IHS/SD/lwj 04/03/02 changed D to equal the date and seconds
 D
 . ;N %H,%,X S %H=D D YMD^%DTC S D=%  ;IHS/SD/lwj 04/03/02 rem out
 . N %H,%,X S %H=D D YMD^%DTC S D=X+% ;IHS/SD/lwj 04/03/02 D chgd
 N DELFLAG S DELFLAG=0
 I $$AGE(D)>AGE("WINNOW LOG FILES") S DELFLAG=1
 I DELFLAG D
 . N MSG S MSG=$S(TESTING:"We would delete",1:"Deleting")_" log file "
 . S MSG=MSG_IEN
 . D LOG(MSG)
 . D DELLOG(IEN)
 Q
COMBINS ;EP - ^ABSPCOMB(IEN,
 ; AGE("WINNOW COMBINED INSURANCE") - this many days following the 
 ;  completion of most recent 9002313.57 transaction
 ; Slight risk of conflict if you're deleting the record just as
 ; the next prescription for this patient is being processed.
 I 'AGE("WINNOW COMBINED INSURANCE") D
 . S AGE("WINNOW COMBINED INSURANCE")=100
 N PAT S PAT=$P(^ABSPCOMB(IEN,0),U)
 ; when was the last completed transaction for this patient?
 N N57 S N57=$O(^ABSPTL("AC",PAT,""),-1)
 N DELFLAG S DELFLAG=0
 I 'N57 S DELFLAG=1 ; no record of patient in completed transactions
 E  D  ; look at most recently-completed transaction's LAST UPDATE
 . N LUPDATE S LUPDATE=$P(^ABSPTL(N57,0),U,8)
 . I $$AGE(LUPDATE)>AGE("WINNOW COMBINED INSURANCE") S DELFLAG=1
 I DELFLAG D DELETE(9002313.1,IEN)
 Q
LOG(X) D LOG^ABSPOSL(X) Q
AGE(X2) ; given fileman date/time, how many days old is it?
 N X1,X,%Y
 S X2=$P(X2,"."),X1=$$TODAY
 D ^%DTC
 Q X
TODAY() N %,%H,%I,X D NOW^%DTC Q $P(%,".")
SETTODAY(FILE,IENS,FIELD)         ; the given FILE, FIELD is missing a date, unexpectedly
 ; set today's date in there, so that it will be winnowed at some time
 ; in the future
 N FDA
 S:IENS'?.E1"," IENS=IENS_","
 D LOG("Missing date; stuffed today into FILE="_FILE_",IENS="_IENS_",FIELD="_FIELD)
 S FDA(FILE,IENS,FIELD)=$$TODAY
ST5 D FILE^DIE(,"FDA","MSG")
 Q:'$D(MSG)  ; success
 D ZWRITE^ABSPOS("MSG")
 G ST5:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"SETTODAY",$T(+0))
 Q
DELETE(FILE,IENS)  ; this is where it happens!!!
 S:IENS'?.E1"," IENS=IENS_","
 ;
 ; Never delete the highest #d entry in a file.
 ; Prevent the re-use of IENs.
 ;
 Q:$$HIGHEST
 ;
 ; Do the delete:
 N FDA
 N MSG S MSG=$S(TESTING:"We would delete",1:"DELETING")
 S MSG=MSG_" FILE="_FILE_",IENS="_IENS
 D LOG(MSG)
 K MSG
 S FDA(FILE,IENS,.01)=""
 Q:TESTING
DE5 D FILE^DIE(,"FDA","MSG")
 I $D(MSG) D ZWRITE^ABSPOS("FDA","MSG") G DE5:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"DELETE",$T(+0))
 ; Make sure the deletion worked: fetch the .01 field
 I $$GET1^DIQ(FILE,IENS,.01)]"" G DE5:$$IMPOSS^ABSPOSUE("FM","TRI","deletion failed",,"DELETE",$T(+0))
 Q
HIGHEST() ; is IENS the highest #d top-level entry in FILE?
 I $L(IENS,",")>2 Q 0
 N ROOT S ROOT=$$ROOT^DILFD(FILE,",",1)
 Q '$O(@ROOT@(+IENS))
DELFIELD(FILE,IENS,FIELD) ; and here too
 N FDA
 S:IENS'?.E1"," IENS=IENS_","
 N MSG S MSG=$S(TESTING:"We would delete",1:"DELETING")
 S MSG=MSG_" FILE="_FILE_",IENS="_IENS_",FIELD="_FIELD
 D LOG(MSG)
 K MSG
 S FDA(FILE,IENS,FIELD)=""
 I 'TESTING D FILE^DIE(,"FDA","MSG")
 Q
DELLOG(N)          ; special for log files
 N MSG S MSG=$S(TESTING:"We would delete",1:"DELETING")
 S MSG=MSG_" Log file "_N
 D LOG(MSG)
 K MSG
 I 'TESTING K ^ABSPECP("LOG",N)
 Q
