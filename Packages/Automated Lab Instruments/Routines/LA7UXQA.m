LA7UXQA ;;DALISC/JMC - Utility - Send alert to users; Feb 5, 1997
 ;;5.2;LAB MESSAGING;**27**;Sep 27, 1994
 ;
XQA(LA7CTYP,LA76248,LA762485,LA76249,LA7AMSG,LA7DATA) ; Send alert when requested.
 ; Input
 ;   LA7CTYP  - Condition for alert (1=New Results, 2=Error on message, 3=New Orders)
 ;   LA76248  - Pointer to file 62.48
 ;   LA762485 - Optional, pointer to file 62.485 if condition=2
 ;   LA76249  - Optional, pointer to file 62.49 if condition=2 or 3
 ;   LA7AMSG  - Optional, alert message if missing will use default message
 ;   LA7DATA  - Optional, pass values for specific conditions
 ; Called by LA7LOG, LA7UIIN, LA7VORM
 N XQA,XQAID,XQADATA,XQAFLAG,XQAMSG,XQAOPT,XQAROU,X,Y
 S XQAMSG=$G(LA7AMSG)
 I $G(LA7CTYP)=1 D
 . S XQAID="LA7-CONFIG-"_$S($G(LA76248):LA76248,1:"UNKNOWN-"_$H)
 . I XQAMSG="" S XQAMSG="Lab Messaging - New results received for "_$P($G(^LAHM(62.48,+$G(LA76248),0),"UNKNOWN"),"^")
 I $G(LA7CTYP)=2 D
 . S XQAID="LA7-MESSAGE-"_$S($G(LA76249):LA76249,1:"UNKNOWN-"_$H)
 . I XQAMSG="" S XQAMSG="Lab Messaging error #"_$G(LA762485,"UNKNOWN")_" on message #"_$G(LA76249,"UNKNOWN")
 . I $G(LA76249) D  ; Error processing message, setup action alert.
 . . S XQAROU="DIS^LA7UXQA" ; Alert action.
 . . S XQADATA=LA76249 ; Alert data (ien of message in 62.49, date of error and error number).
 I $G(LA7CTYP)=3 D
 . S LA7DATA=$G(LA7DATA)
 . S XQAID="LA7-ORDERS-"_$S($L(LA7DATA):$P(LA7DATA,"^"),$G(LA76249):LA76249,1:"UNKNOWN-"_$H)
 . I XQAMSG="" S XQAMSG="Lab Messaging - Manifest# "_$P(LA7DATA,"^")_" received from "_$P($G(^LAHM(62.48,+$G(LA76248),0),"UNKNOWN"),"^")
 S X=""
 F  S X=$O(^LAHM(62.48,+$G(LA76248),20,"B",LA7CTYP,X)) Q:'X  D
 . S Y=$G(^LAHM(62.48,LA76248,20,X,0))
 . I $L($P(Y,"^",2)) S XQA("G."_$P(Y,"^",2))="" ; Send to mail group.
 I '$D(XQA) S XQA("G.LAB MESSAGING")="" ; Fail safe mail group when no mail group defined.
 I $L($G(XQAID)) D DEL(XQAID)
 D SETUP^XQALERT ; Send alert
 Q
 ;
DEL(ID) ; Delete previous alerts if present
 ; Call with ID = alert id
 N XQAID,XQAMSG,XQAROU,XQADATA,XQA
 S XQAKLL=0
 S XQAID=ID
 D DELETEA^XQALERT ;Clear previous alert with same pkg id.
 Q
 ;
DIS ; Display alert.
 N DIR,I,J,K,X,Y
 K ^TMP("DDB",$J),^TMP($J)
 I 'XQADATA W !,$C(7),"Missing message number, unable to proceed.",! G DIS1
 I '$D(^LAHM(62.49,XQADATA)) W !,$C(7),"Message number# ",XQADATA," has been deleted, unable to proceed.",! G DIS1
 S DIR(0)="YO",DIR("A")="Display message associated with this alert",DIR("B")="YES"
 D ^DIR K DIR
 I Y S LA7LIST(+XQADATA)="" D DEV^LA7UTILA
DIS1 S DIR(0)="YO",DIR("A")="Keep this alert on your list",DIR("B")="NO"
 S DIR("?",1)="If 'Yes' then the alert will remain for up to 14 days from date it was sent.",DIR("?")="If 'No' then it will be deleted."
 D ^DIR
 I Y K XQAKILL
 Q
DISIC ; Display Integrity Checker alert.
 N DIR,I,J,K,X,Y
 I '$L(XQADATA) W !,$C(7),"Missing error report to display, unable to proceed.",! G DIS1
 I '$D(^XTMP(XQADATA)) W !,$C(7),"Message number# ",XQADATA," has been deleted, unable to proceed.",! G DIS1
 S DIR(0)="YO",DIR("A")="Display Integrity Check Report associated with this alert",DIR("B")="YES"
 D ^DIR K DIR
 I Y S LA7IC=XQADATA D DEV^LA7CHKFP
 D DIS1
 Q
