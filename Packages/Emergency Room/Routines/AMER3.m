AMER3 ; IHS/ANMC/GIS - MORE DISCHARGE QUESTIONS ;  
 ;;3.0;ER VISIT SYSTEM;;FEB 23, 2009
 ;
QD10 ; ER PROCEDURES
 N AMERNONE S AMERNONE=$$OPT^AMER0("NONE","ER PROCEDURES")
 ; W "Type '??' to see choices"
 S AMEROPT=""
 I $D(^TMP("AMER",$J,2,10,AMERNONE))!('$D(^TMP("AMER",$J,2,10))) S DIC("B")="NONE" G DIC
 D PREV(10)
DIC S DIC("A")="Enter "_$S($O(^TMP("AMER",$J,2,10,0)):"another ",1:"")_"procedure: "
 S DIC="^AMER(3,",DIC(0)="AEQ",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("ER PROCEDURES")
 D ^DIC K DIC
 I $P(Y,U,2)="NONE" K ^TMP("AMER",$J,2,10) S ^TMP("AMER",$J,2,10,AMERNONE)=Y Q
 I X?2."^" S DIROUT=""
 D OUT^AMER I $D(AMERQUIT) Q
 I "^"[$E(X) S Y="" Q
 I $D(^TMP("AMER",$J,2,10,+Y)) D REM(10,Y) Q:$D(AMERQUIT)  G DIC
 S ^TMP("AMER",$J,2,10,+Y)=Y I +Y'=AMERNONE K ^(AMERNONE)
 G DIC
 ;
REM(X,Y) W !,*7,$P(Y,U,2)," has already been selected. Want to cancel it"
 S %=2 D YN^DICN S:%Y?2."^" DIROUT="" D OUT^AMER I $D(AMERQUIT) Q
 I "Nn"[$E(%Y) Q
 K ^TMP("AMER",$J,2,X,+Y) W !,$P(Y,U,2)," cancelled...",!!
 Q
 ;
PREV(X) ; ENTRY POINT FROM AMER31
 W !,"You have already selected =>",!
 F %=0:0 S %=$O(^TMP("AMER",$J,2,X,%)) Q:'%  W ?3,$P(^(%),U,2),!
 W !
 Q
 ;
QD11 ; FINAL DIAGNOSES
 D QD11^AMER31
 Q
 ;
QD12 ; FINAL TRIAGE CATEGORY
 S DIR("B")=$G(^TMP("AMER",$J,2,12))
 S DIR("?")="Enter a number from 1 to 5"
 S DIR("?",1)="This is a site-specified value that indicates severity of visit"
 S DIR(0)="N^1:5:0",DIR("A")="*Enter final acuity assessment from provider" KILL DA D ^DIR KILL DIR
 D OUT^AMER
 Q
 ;
QD14 ; DISPOSITION AND SCHEDULING
 N AMERDISP   ;IHS/OIT/SCR 10/10/08
 S DIC("A")="*Disposition: " K DIC("B")
 I $G(^TMP("AMER",$J,2,14))>0 S %=+^(14),DIC("B")=$P(^AMER(3,%,0),U)
 ;I $D(^TMP("AMER",$J,2,14)) S %=+^(14),DIC("B")=$P(^AMER(3,%,0),U) ;IHS/OIT/SCR 10/10/08
 I $D(AMERDOA) S DIC("B")="DEATH"
 I $D(AMERDNA) D
 .;IHS/OIT/SCR 01/20/09 - OPTION  MAY BE 'LEFT WITHOUT BEING SEEN' OR 'LEFT WITHOUT BEING DISCHARGED'
 .S DIC="^AMER(3,",DIC(0)="",X="LEFT WITHOUT"
 .D ^DIC
 .I Y>0 S DIC("B")=$P(Y,"^",2)
 .E  S DIC("B")=""
 .Q
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("DISPOSITION"),DIC(0)="AEQ"
 D ^DIC K DIC D OUT^AMER I $D(AMERQUIT) Q
 I Y=-1 Q
 S AMERDISP=+Y
 I AMERDISP=$$OPT^AMER0("REGISTERED IN ERROR","DISPOSITION") D  Q
 .D EN^DDIOL("Using this DISPOSITION will cause the entire VISIT to be deleted!!","","!")
 .D EN^DDIOL("This DISPOSITION can not be changed!!","","!")
 .S DIR(0)="Y",DIR("A")="Do you still wish use this DISPOSITION"
 .S DIR("B")="YES"
 .D ^DIR
 .I Y=0 D
 ..S AMERRUN=13
 ..S ^TMP("AMER",$J,2,14)=""
 ..Q
 .I Y=1 S AMERRUN=95
 .Q
 Q:AMERRUN=95
 ;I +Y=$$OPT^AMER0("HOME","DISPOSITION") S AMERRUN=15 D SCHEDULE Q
 I AMERDISP'=$$OPT^AMER0("TRANSFER TO ANOTHER FACILITY","DISPOSITION") S AMERRUN=15
 I AMERDISP'=$$OPT^AMER0($P($G(^AMER(3,AMERDISP,0)),U),"DISPOSITION") K ^TMP("AMER",$J,2,15)
 S Y=AMERDISP
 Q
 ;
QD15 ; OTHER FACILITIES
 ;W "If location lookup fails, try entering 'OTHER'"  - IHS/OIT/SCR 10/09/08 commented out
 S DIR("A")="Where is patient being transferred" K DIR("B")
 I $D(^TMP("AMER",$J,2,15)) S %=+^(15),DIR("B")=$P(^AMER(2.1,%,0),U)
 ;S DIR(0)="P^9009082.1:EMZ" D ^DIR K DIR
 S DIR(0)="PO^9009082.1:OEMZ" D ^DIR K DIR  ;SCR/CNI/OIT - MAKE RESPONSE OPTIONAL
 D OUT^AMER
 Q
 ;
QD16 ; DISCHARGE INSTRUCTIONS
 S DIC("A")="Follow up instructions: " K DIC("B")
 I $D(^TMP("AMER",$J,2,16)) S %=+^(16),DIC("B")=$P(^AMER(3,%,0),U)
 E  S DIC("B")="RTC PRN"
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("FOLLOW UP INSTRUCTIONS"),DIC(0)="AEQ"
 D ^DIC K DIC
 D OUT^AMER
 Q
 ;
QD17 ; DISCHARGE PHYSICIAN
 S DIC("A")="*(PRIMARY)Provider who signed PCC form: " K DIC("B")
 I '$D(^TMP("AMER",$J,2,17)) S %=$G(^TMP("AMER",$J,2,21)) I %]"" S ^TMP("AMER",$J,2,17)=%
 I $D(^TMP("AMER",$J,2,17)) S %=+^(17),DIC("B")=$P(^VA(200,%,0),U)
 S DIC="^VA(200,",DIC(0)="AEMQ"
 ; Screening so that only valid PCC providers identified
 S DIC("?")="Only active providers can be selected"
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIC K DIC
 D OUT^AMER
 Q
 ;
QD18 ; DISCHARGE NURSE
 S DIC("A")="*Discharge nurse: " K DIC("B")
 I $D(^TMP("AMER",$J,2,18)) S %=+^(18),DIC("B")=$P(^VA(200,%,0),U)
 S DIC="^VA(200,",DIC(0)="AEQM"
 ; Screening so that only valid PCC providers identified
 S DIC("?")="Only active providers can be selected"
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIC K DIC
 D OUT^AMER
 I $D(AMERDOA) D
 .S %=$$OPT^AMER0("NONE","ER PROCEDURES"),^TMP("AMER",$J,2,10,%)=%_U_"NONE"
 .S ^TMP("AMER",$J,1,6)=^TMP("AMER",$J,2,17)
 .S ^TMP("AMER",$J,1,7)=Y
 .S ^TMP("AMER",$J,2,12)=$G(^TMP("AMER",$J,1,9))
 .S %=$$OPT^AMER0("DEATH","DISPOSITION"),^TMP("AMER",$J,2,14)=%_"^DEATH"
 .Q
 Q
 ;
QD19 ; TIME OF DEPARTURE
 I $D(^TMP("AMER",$J,2,19)) S Y=^(19) X ^DD("DD") S DIR("B")=Y
 I '$T S DIR("B")="NOW"
 ;IHS/OIT/SCR 10/10/08 - Mark question mandatory
 ;S DIR(0)="DO^::ER",DIR("A")="What time did the patient depart from the ER",DIR("?")="Enter an exact date and time in Fileman format (e.g. 1/3/90@1PM)" D ^DIR K DIR
 S DIR(0)="DO^::ER",DIR("A")="*What time did the patient depart from the ER"
 S DIR("?")="Enter an exact date and time in Fileman format (e.g. 1/3/90@1PM)" D ^DIR K DIR
 I Y,$$TCK^AMER2A($G(^TMP("AMER",$J,1,2)),Y,1,"admission") K Y G QD19
 I Y,$$TCK^AMER2A($G(^TMP("AMER",$J,2,24)),Y,1,"triage") K Y G QD19
 I Y,$$TCK^AMER2A($G(^TMP("AMER",$J,2,25)),Y,1,"the provider visit") K Y G QD19
 I Y,$$TVAL^AMER2A($G(^TMP("AMER",$J,1,2)),Y,6) K Y G QD19
 I Y="" S Y=-1
 D OUT^AMER
 S AMERRUN=99
 Q
 ;
SCHEDULE ; APPOINTMENT STUB
 Q
