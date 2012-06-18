SROXR1 ;B'HAM ISC/MAM - CROSS REFERENCES (CONT) ; [ 07/01/98  2:08 PM ]
 ;;3.0; Surgery ;**34,72,79**;24 Jun 93
AR ; 'AR' x-ref on the 'DATE OF OPERATION'
 ; field in the SURGERY file (130)
 Q:'$D(^SRF(DA,"REQ"))  I $P(^SRF(DA,"REQ"),"^")'=1 Q
 I $D(^SRF(DA,31)),$P(^(31),"^",4) Q
 S:$E(X,1,7)'<DT DFN=$P(^SRF(DA,0),"^"),^SRF("AR",$E(X,1,7),DFN,DA)=""
 Q
KAR ; 'KILL' logic of the 'AR' x-ref on the 'DATE OF
 ; OPERATION' field in the SURGERY file (130)
 S DFN=$P(^SRF(DA,0),"^") K ^SRF("AR",$E(X,1,7),DFN,DA)
 Q
SP ; set 'ASP' and 'AOR' x-refs when date is changed
 I $P(^SRF(DA,0),"^",4) S ^SRF("ASP",$P(^(0),"^",4),$E(X,1,7),DA)=DA
OR I $P(^SRF(DA,0),"^",2) S ^SRF("AOR",$P(^(0),"^",2),$E(X,1,7),DA)=""
 Q
KSP ; kill 'ASP' and 'AOR' x-refs when date is changed
 I $P(^SRF(DA,0),"^",4) K ^SRF("ASP",$P(^(0),"^",4),$E(X,1,7),DA)
KOR S DFN=$P(^SRF(DA,0),"^") I $P(^SRF(DA,0),"^",2) K ^SRF("AOR",$P(^(0),"^",2),$E(X,1,7),DA)
 Q
IV ; delete IV orders
 S SRT("X")=X,SRIV=1 D NOW^%DTC S X=SRT("X"),X1=$E(%,1,12) D MINS^SRSUTL2
 I X>1440 D OUT Q
 D IV1
OUT S X=SRT("X") K SRIV,SRT,X1,Y
 Q
IV1 I X>60 K DIR D
 .S DIR("A",1)="",DIR("A",2)="A considerable amount of time has passed since the operation start",DIR("A",3)="time and the present time.  Do you still want to cancel all of the",DIR("A")="patient's current IV orders ? "
 .S DIR("?",1)="If the operation has been completed and postoperative IV orders have been",DIR("?",2)="made, enter RETURN.  Enter 'YES' to cancel current IV orders.  Entering '^' ",DIR("?")="will not be accepted."
 .S DIR("B")="NO",DIR(0)="YA" D ^DIR K DIR I $D(DTOUT)!(Y=0) S SRIV=0
 I 'SRIV Q
 S X="PSIVACT" X ^%ZOSF("TEST") Q:'$T
 S ZTDESC="Cancel IV Orders from Surgery",ZTDTH=$H,ZTIO="",ZTRTN="DCOR^SROXR1",ZTSAVE("PSIVRES")="SURGERY PACKAGE",ZTSAVE("DFN")=DFN N X,Y D ^%ZTLOAD
 Q
DCOR ; entry for tasked job to cancel IVs
 D DCOR^PSIVACT S ZTREQ="@"
 Q
END K DFN,I,S,SRSC1,SRSDAT,SRSOR
 Q
STAFF ; update STAFF/RESIDENT field
 S STAFF="R" I $D(^XUSEC("SR STAFF SURGEON",X)) S STAFF="S"
 S $P(^SRF(DA,.1),"^",3)=STAFF
 Q
KSTAFF ; update STAFF/RESIDENT when deleted
 S $P(^SRF(DA,.1),"^",3)=""
 Q
ANES ; update ANESTHETIST CATEGORY field
 N SRASITE,SRAML,SRACAT S SRASITE=$O(^SRO(133,0)) I SRASITE S SRAML=$P(^SRO(133,SRASITE,0),"^",4)
 S SRACAT=$S($D(^XUSEC("SR ANESTHESIOLOGIST",X)):"A",$D(^XUSEC("SR SURGEON",X)):"A",$D(^XUSEC("SR NURSE ANESTHETIST",X)):"N",1:"O")
 I SRACAT="A",SRAML'=$P($G(^VA(200,X,5)),"^",2) S SRACAT="O"
 S $P(^SRF(DA,.3),"^",8)=SRACAT K SRASITE,SRAML,SRACAT
 Q
KANES ; update ANESTHETIST CATEGORY when deleted
 S $P(^SRF(DA,.3),"^",8)=""
 Q
