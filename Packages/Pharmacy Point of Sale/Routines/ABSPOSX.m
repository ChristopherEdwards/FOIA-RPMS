ABSPOSX ; IHS/FCS/DRS - Support ;    
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
 ; Directory:
 ;ABSPOSXE - search for error log entries
 ;
AUTO ; EP - automatic, using setup params for date range
 S RANGE=$$GETRANGE(1) Q:RANGE<1
 D THELIST
 Q
INTER ; EP - interactive use
 S RANGE=$$GETRANGE Q:RANGE<1
INTERJ ; join
 N POP D ^%ZIS Q:$G(POP)
 D THELIST
 D ^%ZISC
 Q
TODAY ;EP
 S RANGE=DT_U_DT G INTERJ
YESTER ;EP
 S RANGE=$$TADD^ABSPOSUD(DT,-1),RANGE=RANGE_U_RANGE G INTERJ
WEEK ;EP
 S RANGE=$$TADD^ABSPOSUD(DT,-8)_U_$$TADD^ABSPOSUD(DT,-1) G INTERJ
 ;
THELIST ; calls to all the little things you want to monitor
 ; given RANGE=fileman start^end dates
 ; Put errors and shouldn't-happen things first:
 W "Support Utility to survey Point of Sale activity (",$T(+0),")",!
 W "Site: ",$P(^DIC(4,DUZ(2),0),U),!
 W "Date: ",$$NOWEXT^ABSPOSU1,!
 D SEARCH^ABSPOSXE($$HRANGE(RANGE)) ; error log
 D STRANDED ; stranded claims - report and cleanup
 D UE ; impossible errors
 ; Then put informational things:
 D SHOWQ^ABSPOSR2
 W "Winnowing old data:",!
 W "  the log files are in: ",$G(^ABSP(9002313.99,1,"WINNOW LOGS")),!
 W "Update of Report Master file: ",$G(^ABSP(9002313.99,1,"ABSPOSM1")),!
 D TRANSACT
 D PRESSANY^ABSPOSU5()
 D VOLUME^ABSPOS35($P(RANGE,U),$P(RANGE,U,2)) ; pharmacy volume
 Q
TRANSACT ; count 9002313.57 transactions in RANGE
 ; It's a date range; be sure you get them all
 D TRANS1
 W "Count of complete transactions: ",^TMP($J,"TRANSACT"),!
 W "Tally by result type: ",!
 N R S R="" F  S R=$O(^TMP($J,"TRANSACT","R",R)) Q:R=""  D
 . W $J(^TMP($J,"TRANSACT","R",R),10)," ",R,!
 W "Tally by insurer and by result type: ",!
 N INS S INS="" F  S INS=$O(^TMP($J,"TRANSACT","INS",INS)) Q:INS=""  D
 . W ?10,$J(^TMP($J,"TRANSACT","INS",INS),5)," for ",INS
 . I ^TMP($J,"TRANSACT","INS",INS)=$G(^TMP($J,"TRANSACT","INS",INS,"R","PAPER")) W " - all PAPER",! Q
 . E  W !
 . S R="" F  S R=$O(^TMP($J,"TRANSACT","INS",INS,"R",R)) Q:R=""  D
 . . W ?20,$J(^TMP($J,"TRANSACT","INS",INS,"R",R),5)," ",R,!
 W "Tally by transaction time:",!
 N SECS S SECS="" F  S SECS=$O(^TMP($J,"TRANSACT","TIME",SECS)) Q:SECS=""  D
 . W $J(^TMP($J,"TRANSACT","TIME",SECS),10)," - "
 . I SECS?1N.N W $$SECSDHMS^ABSPOSUD(SECS)
 . E  W SECS
 . I SECS'?1N.N!(SECS>120) W " - IEN57=",$O(^TMP($J,"TRANSACT","TIME",SECS,""))
 . W !
 Q
TRANS1 ;
 ; ^TMP($J,"TRANSACT")=count of 9002313.57 transactions
 ; ^TMP($J,"TRANSACT","R",result)=count by result type
 ; ^TMP($J,"TRANSACT","INS",company)=count by insurance company
 ; ^TMP($J,"TRANSACT","INS",company,"R",result)=count result by company
 ; ^TMP($J,"TRANSACT","TIME",secs)=count
 ; ^TMP($J,"TRANSACT","TIME",secs,IEN57) for certain too-long ones
 ;
 K ^TMP($J,"TRANSACT") S ^TMP($J,"TRANSACT")=0 ; caller should have already NEWed this
 N T,X,Y S X=$P(RANGE,U),Y=$P(RANGE,U,2)
 I Y'["." S $P(Y,".",2)=24 ; thru midnight, if nothing specified
 S T=X
 F  D  S T=$O(^ABSPTL("AH",T)) Q:'T  Q:T>Y
 . N IEN57 S IEN57=""
 . F  S IEN57=$O(^ABSPTL("AH",T,IEN57)) Q:'IEN57  D
 . . N IEN57C S IEN57C=IEN57_","
 . . N R S R=$$GET1^DIQ(9002313.57,IEN57C,4.0098) S:R="" R="null??"
 . . N INS S INS=$$GET1^DIQ(9002313.57,IEN57C,1.06) S:INS="" INS="No Insurance"
 . . S ^TMP($J,"TRANSACT")=^TMP($J,"TRANSACT")+1
 . . S ^TMP($J,"TRANSACT","R",R)=$G(^TMP($J,"TRANSACT","R",R))+1
 . . S ^TMP($J,"TRANSACT","INS",INS)=$G(^TMP($J,"TRANSACT","INS",INS))+1
 . . S ^TMP($J,"TRANSACT","INS",INS,"R",R)=$G(^TMP($J,"TRANSACT","INS",INS,"R",R))+1
 . . N SECS S SECS=$$GET1^DIQ(9002313.57,IEN57C,9999.98)
 . . I SECS="" S SECS="null?"
 . . S ^TMP($J,"TRANSACT","TIME",SECS)=$G(^TMP($J,"TRANSACT","TIME",SECS))+1
 . . I SECS>120 S ^TMP($J,"TRANSACT","TIME",SECS,IEN57)=""
 Q
STRANDED ;
 N HRS S HRS=$P($G(^ABSP(9002313.99,"ABSPOSX TDIF")),U,3)*24
 I 'HRS S HRS=24*31 ; make it a month
 D PURGE^ABSPOSU7(HRS)
 Q
UE ; ^TMP("ABSPOSUE",$J)=DUZ^$H
 N NDAYS S NDAYS=$P($G(^ABSP(9002313.99,"ABSPOSX TDIF")),U,3)
 I 'NDAYS S NDAYS=31
 N J S J="" Q:$O(^TMP("ABSPOSUE",J))=""
 W "Errors which went through ABSPOSUE:",!
 F  S J=$O(^TMP("ABSPOSUE",J)) Q:J=""  D
 . N X S X=^TMP("ABSPOSUE",J)
 . N H S H=$P(X,U,2)
 . I H-$H>NDAYS D  Q  ; too old to report; winnow it if it's really old
 . . I H-$H>(NDAYS+30) K ^TMP("ABSPOSUE",J)
 . D  ; convert H from $H to Fileman
 . . N %H,%,X S %H=H D YMD^%DTC S H=X
 . Q:H<$P(RANGE,U)  Q:H>$P(RANGE,U,2)
 . W "Encountered by ",$P($G(^VA(200,+X,0)),U)," on ",H,!
 Q
GETRANGE(HOW)      ; HOW = 1 - silently, from setup file
 ; otherwise, interactive, ask
 I $G(HOW)=1 D
 . N X S X=$G(^ABSP(9002313.99,"ABSPOSX TDIF"))
 . I X?."^" S X="7^1",^ABSP(9002313.99,"ABSPOSX TDIF")=X
 . S RANGE=$$TADD^ABSPOSUD(DT,-$P(X,U))_U_$$TADD^ABSPOSUD(DT,-$P(X,U,2))
 E  D
 . S RANGE=$$DTR^ABSPOSU1
 Q RANGE
DTRANGE() ;EP -
 N DEF S DEF=$P($$NOWFM^ABSPOSU1,".")
 N X S X=$$DTR^ABSPOSU1("From date: ","Thru date: ",DEF,DEF,0)
 Q X
HRANGE(RANGE) ;EP - convert fileman^fileman to $H^$H
 N I,X,%H,%T,%Y
 F I=1:1:$L(RANGE,U) D
 . S X=$P(RANGE,U,I)
 . D H^%DTC
 . S $P(RANGE,U,I)=%H_$S(%T:","_%T,1:"")
 Q RANGE
