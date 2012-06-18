ACRFIVDX ;IHS/OIRM/DSD/THL,AEF - INVOICE DISPLAY;  [ 03/01/2005  1:15 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**3,16**;NOV 05, 2001
 ;;ROUTINE TO CONTROL DISPLAY, SELECTION, ENTRY OF INVOICE NUMBERS
EN Q
DISPLAY ;EP;TO DISPLAY INVOICES FOR A DOCUMENT/RECEIVING REPORT
 Q:$G(ACRDOC)=""
 I '$D(^ACRINV("G",ACRDOC)) D  D A1
 .W !!,"NO Invoices currently on file for DOCUMENT NO.: ",ACRDOC
 K ^TMP("ACRINV",$J)
 N ACR,ACRJ,ACRN
 S (ACR,ACRJ)=0
 F  S ACR=$O(^ACRINV("G",ACRDOC,ACR)) Q:'ACR  S X=$G(^ACRINV(ACR,0)) I $P(X,U)]"" S ACRJ=ACRJ+1,^TMP("ACRINV",$J,"INV",$P(X,U),ACRJ)=ACR_U_$P(X,U)_U_$P(X,U,4)
 S ACRMAX=ACRJ
 S ACRN=""
 F  S ACRN=$O(^TMP("ACRINV",$J,"INV",ACRN)) Q:ACRN=""  D
 .S ACRJ=0
 .F  S ACRJ=$O(^TMP("ACRINV",$J,"INV",ACRN,ACRJ)) Q:'ACRJ  S ^TMP("ACRINV",$J,ACRJ)=^TMP("ACRINV",$J,"INV",ACRN,ACRJ)
DISP ;EP;TO DISPLAY INVOICE INVO
 D DH
 S ACRJ=0
 F  S ACRJ=$O(^TMP("ACRINV",$J,ACRJ)) Q:'ACRJ!$D(ACRQUIT)  D
 .N X,Y
 .S X=^TMP("ACRINV",$J,ACRJ)
 .S Y=$P(X,U,3)
 .X ^DD("DD")
 .I ACRMAX>20 D
 ..W:ACRJ#2 !,ACRJ,?5,$P(X,U,2),?27,Y
 ..W:ACRJ#2=0 ?40,ACRJ,?45,$P(X,U,2),?67,Y
 ..I ACRJ#2=0,IOSL-4<$Y D PAUSE^ACRFWARN Q:$D(ACRQUIT)  D DH
 .I ACRMAX<21 D
 ..W !?5,ACRJ,?10,$P(X,U,2),?32,Y
 ..I IOSL-4<$Y D PAUSE^ACRFWARN Q:$D(ACRQUIT)  D DH
 K ACRQUIT,ACROUT
 Q
DH W @IOF
DH1 W !?10,"INVOICES FOR DOCUMENT NO.: ",ACRDOC
 I ACRMAX>20 D
 .W !!,"NO.",?5,"INVOICE NUMBER",?27,"DATE REC'D",?40,"NO.",?45,"INVOICE NUMBER",?67,"DATE REC'D"
 .W !,"---",?5,"--------------------",?27,"-----------",?40,"---",?45,"--------------------",?67,"-----------"
 I ACRMAX<21 D
 .W !!?5,"NO.",?10,"INVOICE NUMBER",?32,"DATE RECEIVED"
 .W !?5,"---",?10,"--------------------",?32,"-------------"
 Q
EDIT ;EP;TO ADD OR EDIT INVOICE NUMBERS
 Q:'$D(ACRVDA)
 F  D EDIT1 Q:$D(ACRQUIT)!$D(ACROUT)
ESET Q:'$G(ACRMAX)!$D(ACROUT)
 I ACRMAX=1 S Y=1 D ES1 Q
 S DIR(0)="LOA^1:"_$G(ACRMAX)
 ;S DIR("A",1)="Select ALL INVOICES to include in"      ;ACR*2.1*16.06 IM15505
 ;S DIR("A")="PAID FOR/ACH ADDENDUM for this payment: "  ;ACR*2.1*16.06 IM15505
 S DIR("A",1)="Select the INVOICE to be included in the"  ;ACR*2.1*16.06 IM15505
 S DIR("A")="PAID FOR/ACH ADDENDUM field for this payment: "  ;ACR*2.1*16.06 IM15505
 W !
 D DIR^ACRFDIC
 I Y<1 D  G ESET
 .;W !!,"You must indicate ALL invoices which are included in this"  ;ACR*2.1*16.06 IM15505
 .;W !,"payment so the system knows which to include in the PAID FOR"  ;ACR*2.1*16.06 IM15505
 .;W !,"field or ACH ADDENDUM."  ;ACR*2.1*16.06 IM15505
 .W !!,"You must indicate the invoice that will be included in this"  ;ACR*2.1*16.06 IM15505
 .W !,"payment so the system knows which to include in the PAID FOR"  ;ACR*2.1*16.06 IM15505
 .W !,"or ACH ADDENDUM field."  ;ACR*2.1*16.06 IM15505
 S ACRY=","_ACRY
 S X=0
 F  S X=$O(^TMP("ACRINV",$J,X)) Q:'X  I ACRY'[(","_X_",") K ^TMP("ACRINV",$J,X)
ESET1 Q:$D(ACROUT)
 I $P(ACRY,",",2),'$P(ACRY,",",3) S Y=$P(ACRY,",",2) I $G(^TMP("ACRINV",$J,+Y)) D ES1 Q
 S DIR(0)="NOA^1:"_$G(ACRMAX)
 S DIR("A",1)="Select the INVOICE to use for"
 S DIR("A")="calculation of payment due dates: "
 S DIR("B")=$P(ACRY,",",2)
 W !
 D DIR^ACRFDIC
 I Y<1!'$D(^TMP("ACRINV",$J,+Y)) D  G ESET1
 .W !!,"You must indicate which is the PRIMARY Invoice so the system"
 .W !,"will know which dates to use to calculate when payment is due."
ES1 S ACRINVDA=+$G(^TMP("ACRINV",$J,Y))
 D SETDOC:ACRINVDA
EEXIT K ACRQUIT,ACRINVDA,ACRMAX
 Q
EDIT1 D DISPLAY
 K ACRQUIT
 I '$D(^ACRINV("G",ACRDOC)) S DIR(0)="SO^2:ADD Invoice"
 E  S DIR(0)="SO^1:EDIT Invoice;2:ADD Invoice;3:REMOVE Invoice"
 S DIR("A")="Which one"
 W !
 D DIR^ACRFDIC
 I +Y<1 S ACRQUIT="" Q
 I Y=1 D E1 S Y=1
 I Y=2 D A1 S Y=2
 I Y=3 D D1 S Y=3
 Q
E1 ;SELECT AND EDIT INVOICE
 Q:'$G(ACRMAX)
 S DIR(0)="NO^1:"_ACRMAX
 S DIR("A")="Edit which one"
 W !
 D DIR^ACRFDIC
 I +Y<1!$D(ACRQUIT)!'$G(^TMP("ACRINV",$J,+Y)) K ACRQUIT Q
 S (ACRINVDA,DA)=+^TMP("ACRINV",$J,Y)
E11 S DIE="^ACRINV("
 S DR="[ACR INVOICE EDIT]"
 D DIE^ACRFDIC
 Q
A1 ;ADD AN INVOICE
 S DIR(0)="FO^1:30"
 S DIR("A")="Invoice Number"
 I $G(ACRREF)=618,$G(ACRINVX)]"" S DIR("B")=ACRINVX K ACRINVX
 W !
 D DIR^ACRFDIC
 I $D(ACROUT)!(X["^")!(X="")!(Y="")!($E(Y)=" ") D  G A1 ;ACR*2.1*3.29
 .W !!,"Invoice number is required."
 .K ACROUT,ACRQUIT
 S ACRINV=Y
 I $G(ACRREF)'=618,$D(^ACRINV("B",Y)) D DUP I $D(ACRQUIT) K ACRQUIT Q
 S DIC="^ACRINV("
 S DIC(0)="L"
 S DIC("DR")=".06////"_ACRVDA_";.07////"_ACRDOC_";.08////"_$G(ACRFYDA)_";.09////"_$G(ACRBATDA)_";.1////"_$G(ACRSEQDA)
 D FILE^ACRFDIC
 S (ACRINVDA,DA)=+Y
 D E11
 Q
DUP ;INDICATE DUPLICATE INVOICE
 S ACRINVDA=$O(^ACRINV("B",Y,0))
 Q:'ACRINVDA
 W !!,"INVOICE NUMBER ",Y," is already on file for"
 W !,"DOCUMENT NUMBER: ",$P($G(^ACRDOC(+$P($G(^ACRINV(ACRINVDA,0)),U,2),0)),U)
 W !,"VENDOR.........: ",$P($G(^AUTTVNDR(+$P($G(^ACRINV(ACRINVDA,0)),U,6),0)),U)
 S DIR(0)="YO"
 S DIR("A")="Add this as new INVOICE"
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 I Y'=1 S ACRQUIT="" Q
 S X=ACRINV
 Q
D1 ;SELECT AND EDIT INVOICE
 Q:'$G(ACRMAX)
 S DIR(0)="NO^1:"_ACRMAX
 S DIR("A")="REMOVE which one"
 W !
 D DIR^ACRFDIC
 I +Y<1!$D(ACRQUIT) K ACRQUIT Q
 S DA=+^TMP("ACRINV",$J,Y)
 K ^TMP("ACRINV",$J,Y)
 S DIK="^ACRINV("
 D DIK^ACRFDIC
 Q
SETDOC ;SET DATE OF INVOICE AND DATE INVOICE RECEIVED IN FMS DOCUMENT FILE
 N X
 S X=$G(^ACRINV(+ACRINVDA,0))
 Q:X=""
 S ACRINV=$P(X,U)                      ;ACR*2.1*16.06 IM15505
 S:$G(ACRREF)=618 ACRINVX=$P(X,U)
 S:$G(ACRDOCDA) DA=ACRDOCDA
 S DIE="^ACRDOC("
 S DR="103200.1////"_$P(X,U,4)_";103200.2////"_$P(X,U,3)
 S ACRIVDAT=$P(X,U,4)
 D DIE^ACRFDIC:$G(ACRDOCDA)
 K DIE,DA,DR
 Q
