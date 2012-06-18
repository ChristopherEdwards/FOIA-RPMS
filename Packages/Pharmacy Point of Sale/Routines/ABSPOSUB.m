ABSPOSUB ; IHS/FCS/DRS - diagnostic data collection ;   [ 09/12/2002  10:20 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q  ; diagnostics data collection from full screen display
 ;  You may need to rework this if/when it's ever needed to debug
 ;  the user screen and the continuous update.
FILE(N) Q "/usr/spool/uucppublic/absbposm"_N_".tmp"
COMMON N %,%H,%I,X,NOW D NOW^%DTC
 N NOW S NOW=%
 S ^TMP("ABSP",$J,"ABSPOSUB","DATE CREATED")=NOW
 M ^TMP("ABSP",$J,"ABSPOSUB","ABSPOSL")=^ABSPECP("LOG") ; too hard to separate by $J
 M ^TMP("ABSP",$J,"ABSPOSUB",9002313.58)=^ABSPECX("S")
 Q
INIT S ROU=$T(+0) K ^TMP("ABSP",$J,"ABSPOSUB") S ^TMP("ABSP",$J,"ABSPOSUB")=""
 W "Collecting diagnostic data...",!
 Q
BOTH ;EP - ABSPOS6K
 W "Doing first part...",! D FULL
 W "Doing second part...",! D JOB
 W "Both parts done.",!
 Q
FULL ;EP - ABSPOS6K
 N ROU D INIT
 S ^TMP("ABSP",$J,"ABSPOSUB")="Created by FULL^"_$T(+0)
 D COMMON
 M ^TMP("ABSP",$J,"ABSPOSUB","ABSPOS")=^TMP("ABSPOS")
 M ^TMP("ABSP",$J,"ABSPOSUB","ABSPOSUA")=^TMP("ABSPOSUA")
 ; take the last hundred ^ABSPC( and associated responses
 D LAST0203(100)
 D LAST59(100)
 W "Writing file ",$$FILE(1),"...",!
 D GS(1)
 W "Done.",!
 Q
JOB ;EP - ABSPOS6K
 D INIT
 S ^TMP("ABSP",$J,"ABSPOSUB")="Created by JOB^"_$T(+0)_" for $JOB="_$J
 D COMMON
 M ^TMP("ABSP",$J,"ABSPOSUB","ABSPOS",$J)=^TMP("ABSPOS",$J)
 M ^TMP("ABSP",$J,"ABSPOSUB","ABSPOSUA",$J)=^TMP("ABSPOSUA",$J)
 D LISTMGR
 D LAST0203(10)
 D LAST59(10)
 W "Writing file ",$$FILE(2),"...",!
 D GS(2)
 W "Done.",!
 Q
LISTMGR ; List Manager data
 F X="VALMCNT","VALMBG","VALMAR" D
 . I $D(@X) S ^TMP("ABSP",$J,"ABSPOSUB",X)=@X
 M ^TMP("ABSP",$J,"ABSPOSUB","VALMAR")=@VALMAR
 Q
LAST59(N)          ; last N 9002313.59 entries
 N X S X="A"
 N J F J=1:1:100 S X=$O(^ABSPT(X),-1) Q:'X  D
 .M ^TMP("ABSP",$J,"ABSPOSUB","9002313.59",X)=^ABSPT(X)
 Q
LAST0203(N)        ; last N 9002313.02 entries and associated 9002313.03's.
 N X S X=$P(^ABSPC(0),"^",3)
 N CLAIM,RESP F CLAIM=X:-1:X-N+1 D
 .M ^TMP("ABSP",$J,"ABSPOSUB","CLAIM",CLAIM)=^ABSPC(CLAIM)
 .S RESP="" F  S RESP=$O(^ABSPR("B",CLAIM,RESP)) Q:'RESP  D
 ..M ^TMP("ABSP",$J,"ABSPOSUB","RESP",RESP)=^ABSPR(RESP)
 Q
GS(TYPE) ; write file in ^%GS format
 ; TYPE = 1 - from the FULL option
 ; TYPE = 2 - from the JOB option
 N FILE,R,R0
 S FILE=$$FILE(TYPE)
 D IMPOSS^ABSPOSUE("P","TI","routine still in development",,"GS",$T(+0))
 ; O 51:(FILE:"W")
 ;U 51 W $T(+1),!,$G(NOW)_" "_$H,!
 S R="^TMP(""ABSP"","_$J_",""_ROU_"")"
 S R0=$E(R,1,$L(R)-1)
 F  D  Q:$E(R,1,$L(R0))'=R0
 . W R,!,@R,!
 . S R=$Q(@R)
 W "*",!,"*",!,"**",!,"**",!
 ;C 51
 Q
