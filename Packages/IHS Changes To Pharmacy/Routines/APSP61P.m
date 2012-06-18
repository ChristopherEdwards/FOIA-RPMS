APSP61P ;IHS/DSD/ENM - PRE VERSION 6 CONV RTN  [ 09/03/97   1:30 PM ]
 ;;6.0;IHS PHARMACY MODIFICATIONS;;09/03/97
 ;ORIGINAL VA ROUTINE = PSOPATCH
 ;BHAM ISC/SAB
 ;; 5.6;Outpatient Pharmacy;**60,61**;ORIGINALLY FROM V5.6 PATCHES
 ;Rx File 52, New Person File 200 pre-version check rtn
 S ZTRTN="EN^APSP61P",ZTIO="",ZTDTH=$H,ZTDESC="Outpatient pharmacy patch version 5.6 number 60" D ^%ZTLOAD
ZZE W !!,"Pre-version 6.0 conversion routine has been queued !!",!!,"Check your mailbox in a while for a conversion notice!",!
 Q
EN S RX=0 F  S RX=$O(^PSRX(RX)) Q:'RX  I $G(^PSRX(RX,0))]"",$P(^(0),"^",2),$G(^(2)) S PRV=+$P(^PSRX(RX,0),"^",4) S:'$G(^DIC(16,PRV,"A3"))!('PRV) RX(RX)=RX_"^"_$S($G(^DIC(16,PRV,0)):$P(^(0),"^"),1:"UNKNOWN")
 I $O(RX(0)) D
 .S RXR=4,(RX,REC)=0 F  S RX=$O(RX(RX)) Q:'RX  S RXR=RXR+1,^TMP($J,"TRANS",RXR,0)="RX: "_$P(^PSRX(RX,0),"^")_"   Provider: "_$P(RX(RX),"^",2) I RXR=180 D TM K ^TMP($J,"TRANS") S RXR=3
 .I RXR>4 D TM
 E  S ^TMP($J,"TRANS",1,0)=" ",^TMP($J,"TRANS",2,0)="All pointer values are convertible !!  All is well in file #52." D TM1
EX K XMDUZ,PSOPSTF,RXR,REC,^TMP($J),RXQ,RX,DRG,NPD,RXN,IFN,EXDT,DFN,RX,PRV,HLD,NPRV S:$D(ZTQUEUED) ZTREQ="@" K ZTSK
 S ^DD(59,0,"VR")="5.6/60"
 Q
TM S ^TMP($J,"TRANS",1,0)="Following is a list of prescriptions found that could have invalid providers."
 S ^TMP($J,"TRANS",2,0)="Please edit these prescriptions using 'Edit Prescription' option located under the RX (Prescription) Menu.",^TMP($J,"TRANS",3,0)="The 'A3' node in file #16 (person) may also be invalid or non-existent."
 S ^TMP($J,"TRANS",4,0)=" "
TM1 ;S HLD=0  F  S HLD=$O(^XUSEC("XUPROG",HLD)) Q:'HLD  S XMY(HLD)=""
 S XMSUB="Prescriptions with bad provider pointers",XMDUZ=.5,XMY(DUZ)="",XMY(DUZ,1)="I",XMTEXT="^TMP($J,""TRANS""," D ^XMD
 Q
