ABSPOSM1 ; IHS/FCS/DRS - build Report Master data ;     [ 09/12/2002  10:12 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,9,31,32,36**;JUN 21, 2001
 Q
 ;
 ; File 9002313.61 - ABSP REPORT MASTER
 ;  Purpose: make it easy to use Fileman to get data,
 ;  by storing pointers to various places, indexed by Release Date
 ;
 ;----------------------------------------------------------
 ; IHS/SD/lwj 2/5/04 patch 9  logic added to CLEAN61 to
 ; avoid missing RXI and RXR pointers.  (?? not sure why
 ; they are missing - and they are only missing at Santa Fe.
 ; Without the RX to reference, it's almost impossible to
 ; track down.)
 ;
 ;----------------------------------------------------------
 ;
UPDATE61(BEGINDT,ENDDT,SILENT) ; EP - update the .61 file.
 ; If called with $$, returns 1 success, 0 failure
 I '$D(SILENT) S SILENT=0
 I 'SILENT W !! D LASTRUN
 I '$$LOCK61 D  Q:$Q 0 Q
 . I 'SILENT W !,"Someone else is already using this program.",!
 I '$D(BEGINDT) D  I '$D(BEGINDT) Q:$Q 0 Q
 . N X
 . W !,"Choose the date range of prescription RELEASE DATE",!
 . W "to include in this report.",!
 . S X=$$DTR^ABSPOSU1("Starting at date@time: ","Thru date@time: ",,,"T")
 . Q:'X
 . S BEGINDT=$P(X,U),ENDDT=$P(X,U,2)
 I '$D(ENDDT) S ENDDT=BEGINDT
 I $P(ENDDT,".",2)="" S $P(ENDDT,".",2)=24 ; assume entire day
 I 'SILENT W !,"Thinking..."
 S ^ABSP(9002313.99,1,$T(+0))=BEGINDT_U_ENDDT_U_$$NOW
 D CLEAN61
 D BUILD61
 S $P(^ABSP(9002313.99,1,$T(+0)),U,4)=$$NOW
 D UNLOCK61
 I 'SILENT W !,"Done",!
 Q:$Q 1 Q
AUTO(SILENT) ; EP - entry action to the claims report menu
 ; automatically update for a few days prior to the last update
 ; up through the end of today
 I '$D(SILENT) D  S SILENT=1
 . W !,"...updating the Report Master file, please stand by...",!
 L +^ABSP(9002313.99,1,$T(+0)):+0 Q:'$T  ; could be timing probs; just go on
 N PREV S PREV=$P($G(^ABSP(9002313.99,1,$T(+0))),U,3) ;
 I 'PREV D
 . S PREV=$$TADD^ABSPOSUD($$NOW,-31)\1 ; first time? back 1 month
 . Q:SILENT
 . W !,"Report Master file is being prepared for its first use.",!
 . W "The past month's transactions will be loaded.",!
 . W "If you need to do older reports, use the menu option to ",!
 . W "update the Report Master for a specific date range.",!
 I PREV,PREV\1=DT S PREV=DT ; second time thru today? just do today
 E  S PREV=$$TADD^ABSPOSUD(PREV,-1) ; else reach back 1 day more
 N THRU S THRU=DT+.24
 I 'SILENT D
 . W !,"Updating the Report Master file for "
 . N Y S Y=PREV X ^DD("DD") W Y
 . S Y=THRU X ^DD("DD") W " thru ",Y,!
 ;W "Press ENTER at any time to stop the update.",!
 N ATTIME S ATTIME=$$NOW
 I '$$UPDATE61(PREV,THRU,SILENT) G AUTO9
AUTO9 L -^ABSP(9002313.99,1,$T(+0))
 Q
PREPARE ; not used?
 D WHY
P1 Q:$$UPDYN'=1
 N N S N=$$UPDWHEN I N="" G P1
 W !,"Updating..."
 S N=$$TADD^ABSPOSUD(DT,-N)
 Q:$$UPDATE61(N,DT)
 W !,"Couldn't update the Report Master file",!
 W "You may still try to run some reports, however.",!
 Q
PURPOSE W "The Report Master file is the mechanism which",!
 W "links the Prescription and POS Transaction files together",!
 W "for efficient sorting and Fileman reporting.",!
 Q
WHY ; 
 W "The Report Master file may need to be updated with the latest",!
 W "prescription Released Dates and POS Transaction Numbers",!
 W "to ensure 100% accurate reporting.",!
 Q
UPDYN() N PROMPT S PROMPT="Update the Report Master file now"
 N DEF S DEF="YES"
 N OPT S OPT=1
 N X S X=$$YESNO^ABSPOSU3(PROMPT,DEF,OPT)
 Q $S(X=0:0,X=1:1,1:"")
UPDWHEN() N PROMPT S PROMPT="Update the Report Master file going back how many days? "
 N DEF S DEF=7
 I DEF="" S DEF=1 ; yesterday and today
 N OPT S OPT=1 ; optional response
 N MIN S MIN=0 ; 0 would mean just today
 N MAX S MAX=366
 N X S X=$$NUMERIC^ABSPOSU2(PROMPT,DEF,OPT,MIN,MAX,0)
 I X'?1N.N Q ""
 Q X
LASTRUN N REC S REC=$G(^ABSP(9002313.99,1,$T(+0)))
 I REC="" W "This is the first time the Report Master file has ever been updated.",! Q
 W "The last time the Report Master file was updated was "
 N Y S Y=$P(REC,U,4) S:'Y Y=$P(REC,U,3) X ^DD("DD") W Y,!
 W "The update covered "
 S Y=$P(REC,U) X ^DD("DD") W Y
 S Y=$P(REC,U,2)
 I Y'=$P(REC,U) W " thru " X ^DD("DD") W Y
 W !
 Q
CLEAN61 ;EP - Clean up 9002313.61 for BEGINDT - ENDDT
 ; Delete all entries for which the release date has changed.
 ; Could be that the release date changed on something.
 ;
 ;IHS/SD/lwj 2/5/04 lost pointers for RXR/RXI (patch 9)
 ; adjusted logic of setting WHEN1 to avoid <SBSCR> error
 ; Within loop, E S WHEN1 remarked out, nxt line added
 ;
 N WHEN,WHEN1 S WHEN=BEGINDT
 S WHEN1=0     ;IHS/SD/lwj 2/5/04  patch 9
 F  D  S WHEN=$O(^ABSPECX("RPT","B",WHEN)) Q:'WHEN  Q:WHEN>ENDDT
 . N IEN S IEN=0 F  S IEN=$O(^ABSPECX("RPT","B",WHEN,IEN)) Q:'IEN  D
 . . ;N X S X=^ABSPECX("RPT",IEN,0) ; IHS/OIT/SCR 010510 START avoid undefined error patch 36
 . . N X S X=$G(^ABSPECX("RPT",IEN,0))
 . . I X="" W !,"CORRUPTED X-REF FOUND!",!,"RE-INDEX ABSP REPORT MASTER" Q  ;IHS/OIT/SCR 010510 END avoid undefined error patch 36
 . . S RXI=$P(X,U,4),RXR=$P(X,U,5)
 . . I RXR S WHEN1=$P($G(^PSRX(RXI,1,RXR,0)),U,18)
 . . ;E  S WHEN1=$P($G(^PSRX(RXI,2)),U,13) ;IHS/SD/lwj 2/5/04 ptch 9
 . . E  S:RXI'="" WHEN1=$P($G(^PSRX(RXI,2)),U,13)  ;IHS/SD/lwj 2/5/04
 . . I WHEN'=(WHEN1\1) D DELETE(IEN)
 Q
BUILD61 ; Build file 9002313.61 for BEGINDT - ENDDT
 N IEN S IEN=0
 N WHEN,RXI,RXR S WHEN=BEGINDT
 F  D  S WHEN=$O(^PSRX("AL",WHEN)) Q:'WHEN  Q:WHEN>ENDDT
 . S RXI="" F  S RXI=$O(^PSRX("AL",WHEN,RXI)) Q:RXI=""  D
 . . S RXR="" F  S RXR=$O(^PSRX("AL",WHEN,RXI,RXR)) Q:RXR=""  D
 . . . D ONE
 Q
LOCK61() L +^ABSPECX("RPT"):0 Q $T
UNLOCK61 L -^ABSPECX("RPT") Q
DELETE(IEN) ;
 N FDA,MSG
 S FDA(9002313.61,IEN_",",.01)=""
D5 D FILE^DIE(,"FDA","MSG")
 Q:'$D(MSG)  ; success
 D ZWRITE^ABSPOS("FDA","MSG")
 G D5:$$IMPOSS^ABSPOSUE("FM","TRI","FILE^DIE failed",,"DELETE",$T(+0))
 Q
FIND() ; look for existing RXI,RXR entry in 9002313.61
 N IEN,FOUND S (IEN,FOUND)=0
 F  S IEN=$O(^ABSPECX("RPT","C",RXI,IEN)) Q:'IEN  D  Q:FOUND
 . ;N X S X=^ABSPECX("RPT",IEN,0)  ;IHS/OIT/SCR 011510 START avoid undefined error patch 36
 . N X S X=$G(^ABSPECX("RPT",IEN,0))
 . I X="" W !,"CORRUPTED X-REF FOUND!",!,"RE-INDEX ABSP REPORT MASTER" Q  ;IHS/OIT/SCR 011510 END avoid undefined error patch 36
 . I $P(X,U,5)=RXR S FOUND=IEN
 Q FOUND
ONE ; RXI, RXR released at time WHEN
 N FDA,MSG,FN,IENS,IEN57,X
 S IENS=$$FIND
 I '$$FIND S IENS="+1"
 S IENS=IENS_","
 S FN=9002313.61
 S FDA(FN,IENS,.01)=WHEN\1 ; truncate - date only.
 S (IEN57,FDA(FN,IENS,.03))=$$LAST57^ABSPOSBB(RXI,RXR)
 ; added "I IEN57" to next line
 I IEN57 S FDA(FN,IENS,.02)=$P($P($G(^ABSPTL(IEN57,0)),U,8),".") ;ABSP*1.0T7*1
 S FDA(FN,IENS,.04)=RXI
 S FDA(FN,IENS,.05)=RXR
 N RWR,X
 I IEN57 S RWR=$$GET1^DIQ(9002313.57,IEN57_",","RESULT WITH REVERSAL")
 E  S RWR=""
 ;
 ; Note!  Computed fields rely on these code values.
 ; Also, AMOUNT OTHER takes in all the X<0 cases
 ;
 I RWR?1"E ".E D
 . S X=RWR
 . I X="E PAYABLE" S X=4
 . E  I X="E CAPTURED" S X=3
 . E  I X="E DUPLICATE" S X=2
 . E  I X="E REJECTED" S X=1
 . E  I X="E REVERSAL ACCEPTED" S X=11
 . E  I X="E REVERSAL REJECTED" S X=12
 . E  S X=0
 E  I RWR="PAPER" S X=9
 E  I RWR="PAPER REVERSAL" S X=19
 E  S X=15
 S FDA(FN,IENS,.06)=X
 ;
 ; If the claim has any message text, store it
 ; IHS/OIT/SCR 05/04/09 patch 31 : don't store information if it starts and ends with '&'
 ;  e.g. a value of '&ECL;RC:300;&' is a string of multiple Return Codes separated by ';' but
 ;  it looks like garbage on reports and we don't want to see it there. Only Caremark formats
 ;  are using these strings at the moment and no parsing is attempted by this patch
 N MSGTEXT
 I RWR?1"E ".E D
 . S X=$$MESSAGE^ABSPOSM(IEN57,1)
 . ;I ($E(X,1,1)="&")&&($E(X,$L(X),$L(X))="&") Q  ;IHS/OIT/SCR 05/12/09
 . I ($E(X,1,1)="&")&($E(X,$L(X),$L(X))="&") S MSGTEXT(1)="**Screened Msg" Q  ;IHS/OIT/SCR 05/15/09
 . ;I X["SPH:mmc3" Q  ;IHS/OIT/SCR 05/12/09
 . I X["SPH:mmc3" S MSGTEXT(1)="**Screened Msg" Q  ;IHS/OIT/SCR 05/12/09
 . I X]"" S MSGTEXT(1)=X
 . S MSGTEXT(1)=X
 . S X=$$MESSAGE^ABSPOSM(IEN57,2)
 . I ($E(X,1,1)=";") S X=$E(X,2,$L(X)) ;IHS/OIT/SCR patch 32 06/15/09 - remove leading ";"
 . I ($E(X,$L(X),$L(X))=";") S X=$E(X,1,$L(X)-1) ;IHS/OIT/SCR patch 32 06/15/09 - remove trailing ";"
 . I ($E(X,1,1)="&")&($E(X,$L(X),$L(X))="&") S MSGTEXT(2)="**Screened Msg" Q  ;IHS/OIT/SCR 05/15/09
 . I X["SPH:mmc3" S MSGTEXT(2)="**Screened Msg" Q  ;IHS/OIT/SCR 05/15/09
 . I X]"" S MSGTEXT(2)=X
 I $D(MSGTEXT) S FDA(FN,IENS,1300)="MSGTEXT"
 E  S FDA(FN,IENS,1300)=""
 ; 
 ; If it's a rejected claim, build the rejection text
 ;
 N REJTEXT
 I RWR="E REJECTED"!(RWR="E REVERSAL REJECTED") D
 . N RESP,POS D RESPPOS^ABSPOSM(IEN57) ; set RESP,POS pointers
 . D REJTEXT^ABSPOS03(RESP,POS,.REJTEXT)
 . ; word processing text goes into FDA(FILE,IENS,FIELD,n)=text
 . S FDA(FN,IENS,1800)=$S($D(REJTEXT):"REJTEXT",1:"")
 E  S FDA(FN,IENS,1800)=""
ONE5 I IENS["+" D
 . D UPDATE^DIE(,"FDA",,"MSG")
 E  D
 . D FILE^DIE(,"FDA","MSG")
 Q:'$D(MSG)  ; success
 D ZWRITE^ABSPOS("IENS","FDA","MSG")
 G ONE5:$$IMPOSS^ABSPOSUE("FM","TRI",$S(IENS["+":"UPDATE",1:"FILE")_"^DIE failed",,"ONE5",$T(+0))
 Q
NOW() N %,%H,%I,X D NOW^%DTC Q %
 Q
