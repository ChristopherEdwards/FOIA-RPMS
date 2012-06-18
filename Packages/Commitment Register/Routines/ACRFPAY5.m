ACRFPAY5 ;IHS/OIRM/DSD/THL,AEF - MISC PM REPORTS;  [ 09/23/2005  9:40 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**5,19**;NOV 05, 2001
 ;;
 Q
INVRPT ;EP;TO PRINT INVOICE WORKLOAD REPORT
 F  D INV1 Q:$D(ACRQUIT)!$D(ACROUT)
INVEXIT K ACRQUIT,ACROUT,ACRDUE,ACRDC,ACRBEGIN,ACRDATE,ACREND,ACREXP,ACRFOR,ACRTV
 K ^TMP("ACRINVR",$J)
 Q
INV1 ;
 K ^TMP("ACRINVR",$J)
 W @IOF
 W !?10,"Select beginning and ending dates for INVOICE WORKLOAD REPORT"
 W !
 D ^ACRFDATE
 I '$G(ACRBEGIN)!'$G(ACREND) S ACRQUIT="" Q
 S DIR(0)="SO^1:Report by LOCATION;2:Report by DATA ENTRY Personnel"
 S DIR("A")="Which report"
 S DIR("B")=1
 W !
 D DIR^ACRFDIC
 I 'Y S ACRQUIT="" Q
 N ACRWHICH
 S ACRWHICH=Y
 S (ACRRTN,ZTRTN)="INV2^ACRFPAY5"
 S ZTDESC="INVOICE WORKLOAD REPORT"
 D ^ACRFZIS
 Q
INV2 ;EP;TO PRINT INVOICE WORKLOAD REPORT
 D INVHEAD
 S ACRDATE=ACRBEGIN-1
 F  S ACRDATE=$O(^AFSLAFP("J",ACRDATE)) Q:'ACRDATE!(ACRDATE>ACREND)  D
 .S ACRFYDA=0
 .F  S ACRFYDA=$O(^AFSLAFP("J",ACRDATE,ACRFYDA)) Q:'ACRFYDA  D
 ..S ACRBATDA=0
 ..F  S ACRBATDA=$O(^AFSLAFP("J",ACRDATE,ACRFYDA,ACRBATDA)) Q:'ACRBATDA  D
 ...S ACREXP=$P($G(^AFSLAFP(ACRFYDA,1,ACRBATDA,2)),U)
 ...S ACRSEQDA=0
 ...F  S ACRSEQDA=$O(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA)) Q:'ACRSEQDA  D
 ....I ACRWHICH=1 D
 .....S ACRLCODE=$P($G(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,1)),U,18)
 .....S ACRLCODE=$P($G(^AUTTLCOD(+ACRLCODE,0)),U)
 ....I ACRWHICH=2 D
 .....S ACRLCODE=$P($G(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,0)),U,3)
 .....;S ACRLCODE=$E($P($G(^VA(200,+ACRLCODE,0)),U),1,20)  ;ACR*2.1*19.02 IM16848
 .....S ACRLCODE=$E($$NAME2^ACRFUTL1(+ACRLCODE),1,20)  ;ACR*2.1*19.02 IM16848
 ....S:ACRLCODE="" ACRLCODE="NOT STATED"
 ....S:'$D(^TMP("ACRINVR",$J,ACRLCODE)) ^TMP("ACRINVR",$J,ACRLCODE)=""
 ....S (ACRFOR,ACRTV)=""
 ....I $P($G(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,0)),U,24) S ACRTV=1
 ....E  S ACRFOR=$S($L($P($G(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,2)),U,2))>3:$P(^(2),U,2),1:$P($G(^(2)),U,14))
 ....I ACRFOR]"" D  I 1
 .....S:$L(ACRFOR,",") ACRFOR=$L(ACRFOR,",")
 .....S:$L(ACRFOR,";") ACRFOR=$L(ACRFOR,";")
 ....E  S ACRFOR=1
 ....I 'ACRTV S $P(^TMP("ACRINVR",$J,ACRLCODE),U,$S(ACREXP:1,1:2))=$P(^TMP("ACRINVR",$J,ACRLCODE),U,$S(ACREXP:1,1:2))+ACRFOR
 ....E  S $P(^TMP("ACRINVR",$J,ACRLCODE),U,$S(ACREXP:3,1:4))=$P(^TMP("ACRINVR",$J,ACRLCODE),U,$S(ACREXP:3,1:4))+1
 S (ACR1,ACR2,ACR3,ACR4)=0
 S ACRLCODE=""
 F  S ACRLCODE=$O(^TMP("ACRINVR",$J,ACRLCODE)) Q:ACRLCODE=""!$D(ACRQUIT)  D
 .W:ACRWHICH=1 !?10,ACRLCODE
 .W:ACRWHICH=2 !,ACRLCODE
 .W ?22,$J($P(^TMP("ACRINVR",$J,ACRLCODE),U),5),?32,$J($P(^(ACRLCODE),U,2),5),?42,$J($P(^TMP("ACRINVR",$J,ACRLCODE),U,3),5),?52,$J($P(^(ACRLCODE),U,4),5)
 .N J
 .F J=1:1:4 S @("ACR"_J)=@("ACR"_J)+$P(^TMP("ACRINVR",$J,ACRLCODE),U,J)
 .I IOSL-4<$Y D PAUSE^ACRFWARN Q:$D(ACRQUIT)  D INVHEAD
 W !?22,"-------",?32,"-------",?42,"-------",?52,"-------"
 W !?13,"TOTALS:",?22,$J(ACR1,5),?32,$J(ACR2,5),?42,$J(ACR3,5),?52,$J(ACR4,5)
 D PAUSE^ACRFWARN
 Q
INVHEAD ;
 W @IOF
 W !?10,"INVOICE WORKLOAD REPORT"
 W !?10,"REPORT DATE: "
 S Y=DT
 X ^DD("DD")
 W Y
 S ACRDC=$G(ACRDC)+1
 W ?55,"PAGE: ",ACRDC
 W !?10,"REPORT FROM: "
 S Y=ACRBEGIN
 X ^DD("DD")
 W Y
 W !?10,"REPORT TO..: "
 S Y=ACREND
 X ^DD("DD")
 W Y
 W !!?22,"VENDOR PAYMENTS",?42,"TRAVEL PAYMENTS"
 W:ACRWHICH=1 !?10,"LOCATION"
 W:ACRWHICH=2 !,"DATA ENTRY PERSONNEL"
 W ?22,"PAID",?32,"PENDING",?42,"PAID",?52,"PENDING"
 W:ACRWHICH=1 !?10,"--------"
 W:ACRWHICH=2 !,"--------------------"
 W ?22,"-------",?32,"-------",?42,"-------",?52,"-------"
 Q
VALCHK ;EP;TO CHECK VALIDITY OF BATCH RECORDS
 N X,Y,Z,K,A
 S ACRSEQDA=0
 F  S ACRSEQDA=$O(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA)) Q:'ACRSEQDA  D   ;ACR*2.1*5.05
 .S X=$G(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,0))   ;ACR*2.1*5.05
 .S Y=$G(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,1))   ;ACR*2.1*5.05
 .S A=$G(^AFSLAFP(ACRFYDA,1,ACRBATDA,1,ACRSEQDA,2))   ;ACR*2.1*5.05
 .K ACRQUIT                                           ;ACR*2.1*5.05
 .I X=""!(Y="")!(A="") D                              ;ACR*2.1*5.05
 ..W !!,"File ",ACRFYDA_","_ACRBATDA_","_ACRSEQDA     ;ACR*2.1*5.05
 ..W " is corrupt, report to Site Manager"            ;ACR*2.1*5.05
 ..S ACRQUIT=""                                       ;ACR*2.1*5.05
 .I $P(X,U,10) D                                      ;ACR*2.1*5.05
 ..S:$L($P($G(^AUTTVNDR($P(X,U,10),11)),U))'=10 Z=$P($G(^AUTTVNDR($P(X,U,10),0)),U)  ;ACR*2.1*5.05
 ..S K=$G(^AUTTVNDR($P(X,U,10),19))                   ;ACR*2.1*5.05
 .I $P(X,U,24) D                                      ;ACR*2.1*5.05
 ..;S:$L($P($G(^VA(200,$P(X,U,24),1)),U,9))'=9 Z=$P($G(^VA(200,$P(X,U,24),0)),U)   ;ACR*2.1*5.05  ;ACR*2.1*19.02 IM16848
 ..S:$L($P($G(^VA(200,$P(X,U,24),1)),U,9))'=9 Z=$$NAME2^ACRFUTL1($P(X,U,24))  ;ACR*2.1*19.02 IM16848
 ..S K=$G(^VA(200,$P(X,U,24),19))                     ;ACR*2.1*5.05
 .I $G(Z)]"" D
 ..W:$G(Z)]"" !!,"The EIN for ",Z," is missing or incorrect."
 ..S ACRQUIT=""
 .I $G(ACRBTYP)]"","AB"[ACRBTYP,$P(K,U)=""!($P(K,U,2)="")!($P(K,U,3)="") D
 ..W !!,"The Bank Routing Information is missing or incorrect."
 ..S ACRQUIT=""
 .I '$P(X,U,10),'$P(X,U,24) D
 ..W !!,"I can't determine who you are trying to pay."
 ..S ACRQUIT=""
 .I $P(X,U,28)="" W !!,"Street Address is missing " S ACRQUIT=""
 .I $P(Y,U)="" W !!,"City is missing " S ACRQUIT=""
 .I $P(Y,U,2)="" W !!,"State is missing " S ACRQUIT=""
 .I $P(Y,U,3)="" W !!,"Zipcode is missing " S ACRQUIT=""
 .I $P(X,U,14)="",$P(A,U,2)="",$P(A,U,14)="" W !!,"ACH-Addendum/Paid For information is missing." S ACRQUIT=""
 .Q:'$D(ACRQUIT)
 .W !,"Sequence NO.: ",$P(X,U)                         ;ACR*2.1*5.14
 .W !,"Batch NO....: ",$P($G(^AFSLAFP(ACRFYDA,1,ACRBATDA,0)),U) ;ACR*2.1*5.14
 .W !,"Fiscal Year.: ",$P($G(^AFSLAFP(ACRFYDA,0)),U)   ;ACR*2.1*5.14
 .W !!,"This data must be updated before the batch can be exported."
 .D PAUSE^ACRFWARN
 .K ACROUT
 .S ACRQUIT=""
 Q
