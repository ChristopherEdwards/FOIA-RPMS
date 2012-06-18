BARDMAN ; IHS/SD/LSL - A/R Debt Collection Process ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/08/2004 - V1.8
 ;      Routine created.  Moved (modified) from BBMDC1
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; ********************************************************************
 ;
 Q
 ;
EP ; EP
 D:'$D(BARUSR) INIT^BARUTL        ; Set up basic A/R Variables
 ;D INUSE                          ; Check process not already in use
 I $D(BARQUIT) D CLEAN Q
 D NOTE                           ; logged into facility, continue?
 I $D(BARQUIT) D CLEAN Q
 D SITE                           ; Select site (parent)
 I $D(BARQUIT) D CLEAN Q
 D VARS                           ; Set vars for parameters
 D CHECK                          ; Check parameters
 I $D(BARQUIT) D CLEAN Q
 D ^BARBAN                        ; Refresh screen
 D DISPDT                         ; Display last dates chosen
 D ASKDT                          ; Ask new dates
 Q:BARSTART<1                     ; Date range not entered
 D ASKPARAM                       ; Ask other parameters
 I $D(BARQUIT) D CLEAN Q
 D ^BARBAN
 D DISPARAM                        ; Display new parameters chosen
 I $D(BARQUIT) D CLEAN Q
 D PROCESS                        ; Find bills and build temp global
 I $D(BARQUIT) D CLEAN Q
 W !!,"Creating and sending Files..."
 D SEND^BARDMAN2                  ; create and Send file to ITSC Server
 Q
 ; ********************************************************************
 ;
INUSE ;
 ; Process can only be run by one person at a time.
 I $D(^BARTMP("DEBT COLLECTION")) D  Q
 . W !!!,"This menu option is currently in use by ",$P($G(^VA(200,^BARTMP("DEBT COLLECTION"),0)),U)
 . W !,"Please try again later. "
 . S BARQUIT=1
 . D PAZ^BARRUTL
 S ^BARTMP("DEBT COLLECTION")=DUZ
 Q
 ; ********************************************************************
 ;
NOTE ;
 W !!,$$EN^BARVDF("HIN"),"NOTE:",$$EN^BARVDF("HIF")
 W ?8,"You must be logged into the facility for which you wish to process"
 W !?8,"Debt Collection.  You are logged into ",$$GET1^DIQ(90052.06,DUZ(2),.01)
 W !!
 K DIC,DA,DR,DIR
 S DIR(0)="Y"
 S DIR("A")="Continue"
 S DIR("B")="Y"
 D ^DIR
 S:Y'=1 BARQUIT=1
 Q
 ; ********************************************************************
 ;
SITE ;
 ; No debt collection parameters defined
 K DIC,DA,DR,DIR
 I '$D(^BAR(90052.06,DUZ(2),DUZ(2),10)) D  Q
 . S BARQUIT=1
 . D MSG
 . D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
MSG ;
 W !!,$$CJ^XLFSTR("Debt Collection parameters have not been defined for this facility,",IOM)
 W !,$$CJ^XLFSTR("Please enter the missing data via the Debt Collection Site Parameters Option.",IOM)
 Q
 ; ********************************************************************
 ;
VARS ; EP
 ; Debt Collection Parameter Values
 F I=10:1:12 S BARP(I)=$G(^BAR(90052.06,DUZ(2),DUZ(2),I))
 S BARINUM=$P(BARP(10),U)          ; TSI assigned insurer number
 S BARSNUM=$P(BARP(10),U,4)         ; TSI assigned self pay number
 S BARPATH=$P(BARP(10),U,7)       ; Directory for DCM Files
 S BARIMAX=$P(BARP(10),U,2)       ; TSI contract max INS transactions
 S BARSMAX=$P(BARP(10),U,5)       ; TSI contract max SELF PAY transact
 S BARICUR=$P(BARP(10),U,3)       ; INSURER transactions to date
 S BARSCUR=$P(BARP(10),U,6)       ; SELF PAY transaction to date
 S BAREDOS=$P(BARP(11),U,3)      ; Earliest DOS to check
 S BARLEND=$P(BARP(11),U,6)       ; Last end date used
 S BARLSTRT=$P(BARP(11),U,5)      ; Last start date used
 S BARLENDO=$$GET1^DIQ(90052.06,DUZ(2),1106)
 S BARLSTRO=$$GET1^DIQ(90052.06,DUZ(2),1105)
 S BARMAGE=$P(BARP(11),U,2)       ; Minumum age of bill in days
 I '+BARMAGE S BARMAGE=90         ; Default to 90 days, if min undef
 S BARMAGE=BARMAGE-1              ; Not sure yet.....
 S BARSRCHD=$P(BARP(11),U,4)     ; Earliest date to search
 S BARMAMT=$P(BARP(11),U)         ; Minimum principle amount
 I +BARMAMT=0 S BARMAMT=50        ; Default minimum amount $50
 S BAROS=$$VERSION^%ZOSV(1)       ; Operating system
 S BARASDT=$P(BARP(11),U,8)       ; Start date for auto process
 ;
 K ^TMP($J,"BAR-STARTS-CNT")
 K ^TMP($J,"BAR-STOPS-CNT")
 K ^TMP($J,"BAR-UPD")
 F I="^BARSSELF","^BARSTOPS","^BARTSELF","^BARSTART" D
 . S K=0
 . F  S K=$O(@I@(K)) Q:'+K  D
 . . K @I@(K)
 Q
 ; ********************************************************************
 ;
CHECK ;
 I ((BARINUM="")&(BARSNUM="")) D ERROR Q
 I BARPATH="" D ERROR Q
 I +BARIMAX=0 D ERROR Q
 I +$L(BARSNUM),'+BARSMAX D ERROR Q
 I BARINUM]"",BARICUR'<BARIMAX D  Q:$D(BARQUIT)
 . K DIC,DA,DR,DIR
 . S DIR("A",1)="The contract determined maximum number of INSURER transactions has been reached."
 . S DIR("A")="Continue"
 . S DIR(0)="Y"
 . S DIR("B")="N"
 . D ^DIR
 . S:Y'=1 BARQUIT=1
 . ;
 I BARSNUM]"",+BARSMAX,BARSCUR'<BARSMAX D  Q:$D(BARQUIT)
 . K DIC,DA,DR,DIR
 . S DIR("A",1)="The contract determined maximum number of SELF PAY transactions has been reached."
 . S DIR("A")="Continue"
 . S DIR(0)="Y"
 . S DIR("B")="N"
 . D ^DIR
 . S:Y'=1 BARQUIT=1
 Q
 ; ********************************************************************
 ;
ERROR ;
 ; Paramaters not complete.  If not auto, msg.  Always quit
 S BARQUIT=1
 D MSG
 D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
DISPDT ;
 ; Display last date range used
 W !!,"The last chosen 3P Approval date range was..."
 W !!,"Starting Date: ",$S(BARLSTRO="":"None",1:BARLSTRO)
 W !,"  Ending Date: ",$S(BARLENDO="":"None",1:BARLENDO)
 Q
 ; ********************************************************************
 ;
ASKDT ;
 ; Ask for date range
 W !!!!,"Select 3P Approval date range for this Debt Collection process...",!
 S BARSTART=$$DATE^BARDUTL(1)
 I BARSTART<1 Q
 S BAREND=$$DATE^BARDUTL(2)
 I BAREND<1 W ! G ASKDT
 I BAREND<BARSTART D  G ASKDT
 .W *7
 .W !!,"The END date must not be before the START date.",!
 Q
 ; ********************************************************************
 ;
ASKPARAM ;
 ; Ask other parameteres
 W !
 K DIR,DIC,DA,DR
 S DIR("B")=BARMAMT               ; Minimum Dollar amount
 S DIR(0)="NO^20:5000"
 S DIR("A")="Enter the Debt Collection Minimum Bill Balance Amount"
 D ^DIR
 K DIR
 I '+Y S BARQUIT=1 Q
 S BARAMT=Y
 Q
 ; ********************************************************************
 ;
DISPARAM ;
 ; Display chosen parameters
 W !!,"Start Date: ",$$SDT^BARDUTL(BARSTART)
 W !,"  End Date: ",$$SDT^BARDUTL(BAREND)
 W !!,"  $$ Limit: ",$J($FN(BARAMT,",",2),5),!!
 K DIR,DIC,DA,DR
 S DIR(0)="Y"
 S DIR("A")="Do you want to proceed"
 S DIR("B")="N"
 D ^DIR
 S:Y'=1 BARQUIT=1
 Q
 ; ********************************************************************
 ;
PROCESS ;
 ; Find bills to send.
 W !!,"...Pass 1 - Finding bills on which to STOP collections... "
 D FINDSTOP^BARDMAN2
 W !!,$G(^TMP($J,"BAR-STOPS-CNT"))_" bills FOUND on which to STOP collections!"
 ;
 I BARICUR>BARIMAX,(+BARSMAX&(BARSCUR>BARSMAX)) D  Q
 . W !!,"Maximum number of STARTS have been reached.  Start Files will not be created."
 . D PAZ^BARRUTL
 ;
 I BARICUR>BARIMAX,'+BARSMAX D  Q
 . W !!,"Maximum number of STARTS have been reached.  Start Files will not be created."
 . D PAZ^BARRUTL
 ;
 W !!!,"...Pass 2 - Finding bills on which to START collections... "
 D FINDSTRT^BARDMAN2
 W !!,$G(^TMP($J,"BAR-STARTS-CNT"))," bills FOUND on which to START collections!"
 I +BARSRCHD W !!,"Maximum number of transactions for Self Pay Starts has been reached."
 I +BARIRCHD W !!,"Maximum number of transactions for Insurer Starts has been reached."
 ;
 I $G(^TMP($J,"BAR-STARTS-CNT"))+$G(^TMP($J,"BAR-STOPS-CNT"))=0 D  Q
 . W !!,"Sorry no bills found meeting the selection criteria.",!
 . S BARQUIT=1
 . K DIR
 . S DIR(0)="E"
 . S DIR("A")="Press 'ENTER' to continue"
 . D ^DIR
 . K DIR
 Q
 ; ********************************************************************
 ;
CLEAN ;
 ;K ^BARXTMP("DEBT COLLECTION")
 D ^BARVKL0
 Q
