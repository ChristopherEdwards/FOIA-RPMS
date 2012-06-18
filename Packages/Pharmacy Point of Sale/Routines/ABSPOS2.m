ABSPOS2 ; IHS/FCS/DRS - POS manager's ScreenMan ;    
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ;
 ; SEE code at tag HELP - is this an entry point we can use?
 ;
 ; ALL writes of screen lines should be done as follows:
 ;  IF $$VISIBLE(line) DO WRITE^VALM10(line)
 ;  Then NODISPLY can be set so that $$VISIBLE always returns FALSE
 ;
 ; option ABSP MANAGER SCREEN
 D EN^ABSPOS2() Q
 ;; ;
ERROR D FULL^VALM1 Q  ; what's a ^%ZOSF way to ZQUIT ?
EN() ;EP - main entry point for list template ABSP STATISTICS AND MANAGEMENT
 ;S $ZT="ERROR^"_$T(+0) ; you lose the stack printout when you do this!
 N BASE,CURR,DISP,AVG,DIFF,CHG
 ; BASE(*) = base values, from when zeroed things out
 ; CURR(*) = current values, from most recent read
 ; DIFF(*) = differences
 ; CHG(*) = changed value to print, if any
 N LOCK S LOCK=1 ; should we lock stats when we fetch?
 ;D MYPARAMS
 ;D FETCHES(0) ; fetch stats into BASE() and CURR() both
 ;D DIFF
 ;S ^TMP("ABSPOS2",$J,"FREQ")=30 ;D UPDATE(-1)
 I $P($G(^ABSPECX("S",1,0)),U,2)="" D
 .N %,%H,%I,X D NOW^%DTC S $P(^ABSPECX("S",1,0),U,2)=%
 D EN^VALM("ABSP STATISTICS AND MANAGEMENT")
 Q
INIT ; -- init variables and list array
 N NODISPLY S NODISPLY=1
 D MYPARAMS
 D CLEAN^VALM10
 S VALMCNT=0 ; 0 lines so far
 D LABELS^ABSPOS2C
 D HDR
 D FETCHES(1) ; set up CURR 
 D DIFF ; compute DIFF = differences and changed ones go into CHG
 D VALUES^ABSPOS2B ; displays whatever's in CHG() and kills it off
 Q
FETCHES(B)         ;EP - from ABSPOS2A
 ; B = 0 to fetch into BASE(...) array, 1 for CURR(...) array
 N DST S DST=$S(B=1:"CURR",B=0:"BASE")
 S ^TMP("ABSPOS2",$J,"$H",DST)=$H
 D FETCH58(DST_"(""COMM"")")
 D FETSTAT(DST_"(""STAT"")")
 D FETPKTQ(DST_"(""PKTQ"")")
 I B=0 D  ; if setting BASE values, copy them into CURR
 .M CURR=BASE ; copy them into CURR
 .S ^TMP("ABSPOS2",$J,"$H","BASE")=$H
 Q
DIFF ;EP - from ABSPOS2A
 K CHG ; compute DIFF=CURR-BASE differences; set CHG for any changed
 N A,B,X  S A=""
 F  S A=$O(CURR(A)) Q:A=""  S B="" F  S B=$O(CURR(A,B)) Q:B=""  D
 .S X=CURR(A,B)-$G(BASE(A,B))
 .I X'=$G(DIFF(A,B)) S (DIFF(A,B),CHG(A,B))=X
 Q
UPD1 ; one update cycle
 N A,B,T
 D FETCHES(1) ; fetch into CURR array
 D DIFF ; compute differences
 D VALUES^ABSPOS2B ; compute values and display if changed
 Q
HDT(X) ; first convert fileman date-time to $H format, then $$H it
 N %H,%T,%Y D H^%DTC S X=$P(X,".",2)
 Q $$H(%H_","_($E(X,1,2)*3600+($E(X,3,4)*60)+$E(X,5,6)))
H(H) S:'$D(H) H=$H Q $P(H,",")-58000*86400+$P(H,",",2) ; $$H seconds
FETCH58(DST)         ; send DST = closed root of the destination
 K @DST
 N FN,DIC,DR,DA,DIQ,TMP ; note that DA=1 is hardcoded
 S @DST@("$$H")=$$H
 S (FN,DIC)=9002313.58,DR="1:10000",DIQ="TMP(",DA=1
 I LOCK L +^ABSP(FN):300
 D EN^DIQ1
 I LOCK L -^ABSP(FN)
 M @DST=TMP(FN,1)
 S @DST@(2)=$P(^ABSPECX("S",1,0),U,2) ; overwrite w/internal form
 S @DST@(2)=$$HDT(@DST@(2))
 Q
FETSTAT(DEST)       ;EP - from ABSPOSIW
 ; send DEST = closed root of the destination
 K @DEST
 S @DEST@("$$H")=$$H
 I LOCK LOCK +^ABSPT
 N Q,N,A F Q=0:10:90,19,31,51 D
 .S A="" F N=0:1 S A=$O(^ABSPT("AD",Q,A)) Q:A=""
 . I Q#10 S @DEST@(Q\10*10)=@DEST@(Q\10*10)+N
 . E  S @DEST@(Q)=N ; relies on multiples of 10 coming first!
 I LOCK LOCK -^ABSPT
 Q
FETPKTQ(DEST)      ;EP - from ABSPOSIW,ABSPOSRB
 ; send DEST = closed root of the destination
 ; send LOCK = true if you want to lock all the queues (for exact count)
 ; ^ABSPECX("POS",psetien,"C",n) and "R"
 ; @DEST@("C",PSetIEN) = packets waiting to send
 ; @DEST@("C")=total of all the "C" counts
 ; @DEST@("R",PSetIEN) = packets received awaiting receive processing
 ; @DEST@("R")=total
 K @DEST
 S @DEST@("$$H")=$$H,(@DEST@("C"),@DEST@("R"))=0
 ; Would need to do similarly for each PSetIEN value too INCOMPLETE
 I LOCK LOCK +^ABSPECX("POS")
 N A,B,C,N,P,X
 S A="" F  S A=$O(^ABSPECX("POS",A)) Q:A=""  D
 .F B="C","R" D
 ..S C="" F N=0:1 S C=$O(^ABSPECX("POS",A,B,C)) Q:C=""
 ..S @DEST@(B,A)=N
 ..S @DEST@(B)=$G(@DEST@(B))+N
 I LOCK LOCK -^ABSPECX("POS")
 Q
MYPARAMS ;
 Q
UPDFREQ() ;I DUZ=9598 Q 5   ; I get it every 5 seconds
 Q 15 ; every fifteen seconds is the usual case
 ;
CLEARAT()          ;
 S Y=$P(^ABSPECX("S",1,0),U,2) X ^DD("DD") Q Y
HDR ; -- header code
 S VALMHDR(1)="Communications statistics last cleared on "_$$CLEARAT
 S XQORM("B")="CU" ; the default is Update Continuously
 S XQORM("B")="U1" ; but we'd like to do U1 continuously from top lvl
 Q
 ;
UPD ;EP - From ABSPOS2A ; Protocol ABSP P2 UPDATE
 D UPDATE(1) S VALMBCK="",XQORM("B")="U1" Q  ; ABSB RXE POS P2 UPDATE
CONTUPD ; Protocol ABSP P2 CONTINUOUS
 W !!!!! D UPDATE(-1) S VALMBCK="" Q  ; ABSB RXE POS P2 CONTINUOUS
UPDATE(COUNTER)       ; with COUNTER = a count down
 N STOP F  D  Q:$G(STOP)
 .D UPD1
 .S COUNTER=COUNTER-1 I 'COUNTER S STOP=1 Q
 .I '$G(NODISPLY) D
 ..D MSG^VALM10("In continuous update mode: press Q to Quit")
 ..;I $D(^TMP("XGKEY",$J)) possible interference?
 ..N X S X=$$READ^XGKB(1,$$UPDFREQ) D MSG^VALM10(" ")
 ..;N X R X#1:^TMP("ABSPOS2",$J,"FREQ") D MSG^VALM10(" ")
 ..;I X]"","Qq^^"[X S STOP=1
 ..I '$G(DTOUT),X]"","Qq^^"[X S STOP=1
 ..N Y F  R Y:0 Q:'$T  ; clean out typeahead (like mistaken arrow keys)
 ..; But if timed out, keep looping and updating
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D FULL^VALM1
 Q
 ;
EXPND ; -- expand code
 Q
