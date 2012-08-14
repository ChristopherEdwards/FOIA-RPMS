ACRFXMY ;IHS/OIRM/DSD/THL,AEF - SEND ARMS MESSAGES TO MM; [ 09/26/2005  10:20 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**5,19**;NOV 05, 2001
 ;;ROUTINE USED TO PROCESS MAILMAN MESSAGES GENERATED BY VARIOUS ARMS
 ;;FUNCTIONS
XMY ;EP;
 S:$D(ACRAPDA) ACRAPDAX=ACRAPDA
 N ACRAPDA
 K XMY
 S ACRAPDA=0
 F  S ACRAPDA=$O(^ACRAPVS("AB",ACRDOCDA,ACRAPDA)) Q:'ACRAPDA  D
 .S ACRDT=$G(^ACRAPVS(ACRAPDA,"DT"))
 .S ACR0=$G(^ACRAPVS(ACRAPDA,0))
 .Q:$P(ACRDT,U)=""
 .I $P(ACRDT,U,2),$P(ACR0,U,6)=$P(^ACRDOC(ACRDOCDA,0),U,13) D XMY1
 S XMY($P(^ACROBL(ACRDOCDA,0),U,5))=""
 S XMY(DUZ)=""
 I ACRAPDAS="D" D
 . I $G(ACRAPDAX) Q:$P(^ACRAPVS(ACRAPDAX,0),U,11)
 .S DA=ACRDOCDA
 .S DIE="^ACROBL("
 .S DR="905////D"
 .D DIE^ACRFDIC
 S:$D(ACRAPDAX) ACRAPDA=ACRAPDAX
 K:'$D(ACRAPDAX) ACRAPDA
 K ACRAPDAX
 D:$D(XMY) MESSAGE
 Q
XMY1 S XMY($P(ACRDT,U,2))=""
 I $P(ACRDT,U,6),$P(ACRDT,U,6)'=$P(ACRDT,U,2) S XMY($P(ACRDT,U,6))=""
 Q
MESSAGE ;EP;
 I $G(ACRAPDA) D
 .W !!,"One moment please, message being delivered."
 .H 2
 .S ^ACROBL(ACRDOCDA,"CNG")=$G(^ACRAPVS(ACRAPDA,"CNG"))
 .S ^ACROBL(ACRDOCDA,"RSN")=$G(^ACRAPVS(ACRAPDA,"RSN"))
 I '$G(ACRAPDA) D
 .S DA=ACRDOCDA
 .S DIE="^ACROBL("
 .S DR="[ACR REASON FOR CHANGE]"
 .D DDS^ACRFDIC
 .Q:'$D(ACRSCREN)
 .K ACRSCREN
 .W !
 .D DIE^ACRFDIC
 S ACRCNG=$G(^ACROBL(ACRDOCDA,"CNG"))
 S ACRRSN=$G(^ACROBL(ACRDOCDA,"RSN"))
 S ACRDOC0=^ACRDOC(ACRDOCDA,0)
 I $G(ACRAPDA) D
 . I $P(^ACRAPVS(ACRAPDA,0),U,11) S XMB(1)="TRAVEL ADVANCE for "
 S XMB(1)=$G(XMB(1))_"Document no. "_$P(ACRDOC0,U)_" ("_$S($P(ACRDOC0,U,2)]""&($P(ACRDOC0,U)'=$P(ACRDOC0,U,2)):$P(ACRDOC0,U,2)_" - ",1:"")_$P(^ACRDOC(ACRDOCDA,0),U,14)_") ,was "
 S XMB(1)=XMB(1)_$S(ACRAPDAS="A":"APPROVED",ACRAPDAS="R":"RETURNED FOR CLARIFICATION",ACRAPDAS="D":"DISAPPROVD",1:"PROCESSED, READ COMMENTS BELOW")_" by "
 ;S XMB(2)=$P(^VA(200,DUZ,0),U)  ;ACR*2.1*19.02 IM16848
 S XMB(2)=$$NAME2^ACRFUTL1(DUZ)  ;ACR*2.1*19.02 IM16848
 S XMB(2)=$P($P(XMB(2),",",2)," ")_" "_$P(XMB(2),",")
 S XMB(3)=$S($G(ACRAPDA):$P(^ACRAPVT($P(^ACRAPVS(ACRAPDA,0),U,3),0),U),1:"")
 S XMB(3)=$P($P(XMB(3),",",2)," ")_" "_$P(XMB(3),",")
 S XMB(2)=XMB(2)_" as the "_XMB(3)
 S XMB(3)="  "
 S XMB(4)="Information which needs to be changed:"
 I ACRCNG]"" D
 .N ACRI
 .F ACRI=1:1:5 S:$P(ACRCNG,U,ACRI)]"" XMB(ACRI+4)=$P(ACRCNG,U,ACRI)
 S XMB(10)="  "
 S XMB(11)="Reason for change: "
 I ACRRSN]"" D
 .N ACRI
 .F ACRI=1:1:5 S:$P(ACRRSN,U,ACRI)]"" XMB(ACRI+11)=$P(ACRRSN,U,ACRI)
 S XMDUZ=.5
 S XMTEXT="XMB("
 S XMSUB="REQUEST COMMENT/DISAPPROVAL NOTIFICATION"
 S XMB="ACR REQUEST STATUS"
 D ^XMD
 K ACRAPV,ACRCNG,ACRRSN,XMB,XMDUZ,XMSUB,XMY,XMTEXT
 Q
TVAPP ;EP;TO SEND MESSAGE TO TRAVELER WHEN PAYMENT IS CERTIFIED
 Q:'$P($G(^ACRDOC(ACRDOCDA,"TO")),U,9)
 N ACRDUZ
 S ACRDUZ=$P(^ACRDOC(ACRDOCDA,"TO"),U,9)
 S XMY(ACRDUZ)=""
 S ACRDOC0=^ACRDOC(ACRDOCDA,0)
 ;S XMB(1)="The Travel Voucher for Travel Order NO. "_$P(ACRDOC0,U)_" ("_$P(ACRDOC0,U,14)_") for "_$P($G(^VA(200,+ACRDUZ,0)),U)  ;ACR*2.1*19.02 IM16848
 S XMB(1)="The Travel Voucher for Travel Order NO. "_$P(ACRDOC0,U)_" ("_$P(ACRDOC0,U,14)_") for "_$$NAME2^ACRFUTL1(+ACRDUZ)  ;ACR*2.1*19.02 IM16848
 S Y=$P(^ACRAPVS(ACRAPDA,"DT"),U,4)
 X ^DD("DD")
 S X=$P(^ACRAPVS(ACRAPDA,"DT"),U,2)
 ;S XMB(2)="was Certified for Payment on "_Y_" by "_$P($G(^VA(200,+X,0)),U)  ;ACR*2.1*19.02 IM16848
 ;S XMB(3)="Payment should be made to "_$P($G(^VA(200,+ACRDUZ,0)),U)  ;ACR*2.1*19.02 IM16848
 S XMB(2)="was Certified for Payment on "_Y_" by "_$$NAME2^ACRFUTL1(+X)  ;ACR*2.1*19.02 IM16848
 S XMB(3)="Payment should be made to "_$$NAME2^ACRFUTL1(+ACRDUZ)  ;ACR*2.1*19.02 IM16848
 D ^ACRFTOT
 S:$G(ACRREIM)]"" XMB(4)="in the amount of "_$FN(ACRREIM,"P,",2)_" on Schedule No.: "_$P($G(^ACRDOC(ACRDOCDA,18)),U,3)
 S XMDUZ=.5
 S XMTEXT="XMB("
 S XMSUB="TRAVEL VOUCHER CERTIFIED FOR PAYMENT"
 S XMB="ACR TV CERT FOR PAY"
 D ^XMD
 Q
TOAPP ;EP;TO SEND MESSAGE TO TRAVELER WHEN PAYMENT IS CERTIFIED
 Q:'$P($G(^ACRDOC(ACRDOCDA,"TO")),U,9)  S ACRDUZ=$P(^("TO"),U,9)
 S XMY(ACRDUZ)=""
 S ACRDOC0=^ACRDOC(ACRDOCDA,0)
 ;S XMB(1)="Travel Order NO. "_$P(ACRDOC0,U)_" ("_$P(ACRDOC0,U,14)_") for"_$P($G(^VA(200,+ACRDUZ,0)),U)  ;ACR*2.19*1.02 IM16848
 S XMB(1)="Travel Order NO. "_$P(ACRDOC0,U)_" ("_$P(ACRDOC0,U,14)_") for"_$$NAME2^ACRFUTL1(+ACRDUZ)  ;ACR*2.1*19.02 IM16848
 S Y=$P(^ACRAPVS(ACRAPDA,"DT"),U,4)
 X ^DD("DD")
 S X=$P(^ACRAPVS(ACRAPDA,"DT"),U,2)
 ;S XMB(2)="was approved on "_Y_" by "_$P($G(^VA(200,+X,0)),U)  ;ACR*2.1*19.02 IM16848
 S XMB(2)="was approved on "_Y_" by "_$$NAME2^ACRFUTL1(+X)  ;ACR*2.1*19.02 IM16848
 S XMDUZ=.5
 S XMTEXT="XMB("
 S XMSUB="TRAVEL ORDER APPROVED"
 S XMB="ACR TO SIGNED"
 D ^XMD
 Q
POAPP ;EP;TO SEND MESSAGE TO REQUEST INITIATOR WHEN PO IS SIGNED
 Q:'$P($G(^ACRDOC(ACRDOCDA,"REQ2")),U,8)
 S XMY($P(^ACRDOC(ACRDOCDA,"REQ2"),U,8))=""
 S ACRDOC0=^ACRDOC(ACRDOCDA,0)
 S XMB(1)="Purchase Order NO. "_$P(ACRDOC0,U,2)_"  ("_$P(ACRDOC0,U)_"  - "_$P(ACRDOC0,U,14)_")"
 S Y=$P(^ACRAPVS(ACRAPDA,"DT"),U,4)
 X ^DD("DD")
 S X=$P(^ACRAPVS(ACRAPDA,"DT"),U,2)
 ;S XMB(2)="was approved on "_Y_" by "_$P($G(^VA(200,+X,0)),U)  ;ACR*2.1*19.02 IM16848
 S XMB(2)="was approved on "_Y_" by "_$$NAME2^ACRFUTL1(+X)  ;ACR*2.1*19.02 IM16848
 S XMDUZ=.5
 S XMTEXT="XMB("
 S XMSUB="PO SIGNED"
 S XMB="ACR PO SIGNED"
 D ^XMD
 Q
TRAPP ;EP;TO SEND MESSAGE TO REQUEST INITIATOR WHEN PO IS SIGNED
 Q:'$P($G(^ACRDOC(ACRDOCDA,"TRNG")),U,2)  S ACRDUZ=$P(^("TRNG"),U,2)
 S XMY(ACRDUZ)=""
 S ACRDOC0=^ACRDOC(ACRDOCDA,0)
 ;S XMB(1)="Training Request NO. "_$P(ACRDOC0,U,2)_"  ("_$P(ACRDOC0,U)_"  - "_$P(ACRDOC0,U,14)_") for "_$P($G(^VA(200,+ACRDUZ,0)),U)  ;ACR*2.1*19.02 IM16848
 S XMB(1)="Training Request NO. "_$P(ACRDOC0,U,2)_"  ("_$P(ACRDOC0,U)_"  - "_$P(ACRDOC0,U,14)_") for "_$$NAME2^ACRFUTL1(+ACRDUZ)  ;ACR*2.1*19.02 IM16848
 S Y=$P(^ACRAPVS(ACRAPDA,"DT"),U,4)
 X ^DD("DD")
 S X=$P(^ACRAPVS(ACRAPDA,"DT"),U,2)
 ;S XMB(2)="was approved on "_Y_" by "_$P($G(^VA(200,+X,0)),U)  ;ACR*2.1*19.02 IM16848
 S XMB(2)="was approved on "_Y_" by "_$$NAME2^ACRFUTL1(+X)  ;ACR*2.1*19.02 IM16848
 S XMDUZ=.5
 S XMTEXT="XMB("
 S XMSUB="TRAINING REQUEST SIGNED"
 S XMB="ACR TR SIGNED"
 D ^XMD
 Q
TO25(ACRDOCDA,ACRAPDA) ;EP;TO SEND MESSAGE TO AREA FMO WHEN AMOUNT IS GREATER THAN 2500   ;ACR*2.1*5.15
 ;ALSO SENDS MESSAGE TO THE TRAVEL VOUCHER AUDITOR
 ;ENTERS WITH FMS DOCUMENT IEN AND FMS REQUEST CONTROLLER FILE IEN
 ;
 N ACRDUZ,ACRFMO,ACRAMT,ACRTMP,ACRDOC0,ACRNAM,ACRID,XMY
 N ACRDOC,X,Y,XMDUZ,XMTEXT,XMSUB
 S ACRDUZ=$P($G(^ACRDOC(ACRDOCDA,"TO")),U,9)     ; TRAVELER
 Q:'ACRDUZ
 S ACRAMT=$$TOTAMT^ACRFSSU(ACRDOCDA)             ; TOTAL AMOUNT
 Q:ACRAMT<2500
 S ACRFMO=$P($G(^ACRDOC(ACRDOCDA,"REQ1")),U,13)  ; AREA FMO
 Q:'ACRFMO
 S ACRFMO=$$NAME^ACRFUTL1(ACRFMO)
 S XMY(ACRFMO)=""
 S ACRTVA=$P($G(^ACRDOC(ACRDOCDA,"TO")),U,24)    ;TRAVEL VOUCHER AUDITOR
 I ACRTVA]"" D
 .S ACRTVA=$$NAME^ACRFUTL1(ACRTVA)
 .S XMY(ACRTVA)=""
 S ACRDOC0=^ACRDOC(ACRDOCDA,0)
 S ACRDOC=$P(ACRDOC0,U)
 S ACRNAM=$$NAME^ACRFUTL1(ACRDUZ)
 S ACRID=$P(ACRDOC0,U,14)                        ; DOCUMENT ID
 S XMB(1)="Travel Order NO. "_ACRDOC_" ("_ACRID_") for "_ACRNAM
 S X=$P(^ACRAPVS(ACRAPDA,"DT"),U,2)              ; REQUESTED BY
 S ACRNAM=$$NAME^ACRFUTL1(X)
 S Y=DT X ^DD("DD")
 S XMB(2)="for "_ACRAMT_" was requested on "_Y_" by "_ACRNAM
 S XMDUZ=.5
 S XMTEXT="XMB("
 S XMSUB="TRAVEL ORDER REQ >$2500"
 S XMB="ACR TO REQ >2500"
 D ^XMD
 Q