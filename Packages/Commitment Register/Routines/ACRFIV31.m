ACRFIV31 ;IHS/OIRM/DSD/THL,AEF - INVOICE AUDITS CONTINUED;  [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;ROUTINE CALLED DURING PROCESSING OF INVOICES
INVOICE ;EP
 D TOTACP1
 I ACRIVDX'<ACRACP D
 .W !!,ACRACP," of these items ",$S(ACRRQD=1:"was",1:"were")," recieved and accepted,"
 .W !,ACRIVDX,$S(ACRIVDX=1:" has",1:" have")," already been invoiced."
 .W !,"No further invoice action should be taken for this item."
 .D PAUSE^ACRFWARN
 S DIR(0)="NOA^-999999:9999999:3"
 S DIR("A")="UNIT COST...........: "
 S DIR("?")="Enter the actual UNIT COST of the item from the invoice"
 S DIR("B")=ACRUC
 D DIR^ACRFDIC
 I $D(ACRQUIT)!$D(ACROUT) D INCOMPLT Q
 S ACRUCX=Y
 S DIR(0)="NOA^0:"_ACRUNINV
 S DIR("A")="NUMBER INVOICED.....: "
 S DIR("?")="Enter the actual number on the invoice"
 S DIR("B")=ACRUNACP
 D DIR^ACRFDIC
 I $D(ACRQUIT)!$D(ACROUT) D INCOMPLT Q
 S ACRIVDX=Y,ACRIVD=ACRIVD+Y
 D DATE
 D ADD
 Q
ADD ;EP;ADD INVOICE AUDIT
 D NOW^%DTC
 S ACRDATE=%
 S DA=ACRRRDA
 S ACRACPX=$P(^ACRRR(DA,"DT"),U,3)
 S ACRSSDA=+^ACRRR(DA,0)
 S ACRUCX=$P(^ACRSS(ACRSSDA,"DT"),U,3)
 S DIE="^ACRRR("
 S DR=".09////"_DUZ_";.1////"_%_";5////"_ACRUCX_";6////"_ACRACPX_";7////"_ACRIVNO
 D DIE^ACRFDIC
 S X=ACRDATE
 S DA(1)=ACRRRDA
 S DIC(0)="L"
 S DIC="^ACRRR("_ACRRRDA_",12,"
 S DIC("DR")=".02////"_DUZ_";.03////1"
 S:'$D(@(DIC_"0)")) ^ACRRR(ACRRRDA,12,0)="^9002193.2121D"
 D FILE^ACRFDIC
C1 ;EP;
 D TOTAL
 S DA=ACRSSDA
 S DIE="^ACRSS("
 S DR="16////"_(ACRIVD*ACRUC)_";17////"_ACRIVD_";32////"_ACRUC
 D DIE^ACRFDIC
 Q
INCOMPLT W !!,*7,*7,"Data entry for ITEM NO. ",ACRJ," not completed, entry not accepted."
 H 2
 K ACRQUIT
 Q
TOTAL S (X,ACRIVD,ACRUC,ACRACP)=0
 F  S X=$O(^ACRRR("B",ACRSSDA,X)) Q:'X  D
 .I $D(^ACRRR(X,"DT")) S ACRRRDT=^("DT") D
 ..S ACRACP=ACRACP+$P(ACRRRDT,U,3)
 ..S ACRIVD=ACRIVD+$P(ACRRRDT,U,6)
 ..S:$P(ACRRRDT,U,5)>ACRUC ACRUC=$P(ACRRRDT,U,5)
 Q
RRNO ;EP;TO DETERMINE THE NO OF RECEIVING REPORTS ON FILE
 S (X,Z)=0
 F  S X=$O(^ACRRR("AC",ACRDOCDA,X)) Q:'X  S Z=Z+1
 S ACRRRNO=Z
 Q
TOTCHK ;EP;CALLED BY INPUT TRANSFOR TO ENSURE THAT THE QUANTITY INVOICED ON A
 ;INVOICE AUDIT DOES NOT MAKE THE TOTAL QUANTITY INVOICED GREATER THAN
 ;TOTAL QUANTITY RECEIVED AND ACCEPTED
 D TOTACP
 S:$D(^ACRRR(DA,"DT")) ACRIVDX=ACRIVD-$P(^("DT"),U,2)
 I ACRIVDX+X>ACRACP D
 .W !!,*7,*7
 .W "The quantity received on this receiving action cannot make the total quantity"
 .W !,"received greater than the total quantity ordered (",ACRRQD,")"
 .W !
 .K X
 Q
TOTACP ;EP;TO CALCULATE THE TOTAL INVOICED FOR AN ITEM
 S ACRIVDX=0
 I '$D(ACRRRDA),'$D(DA) D TOTACP1 Q
 I '$D(DA),$D(ACRRRDA) S DA=ACRRRDA
 N ACRRRDA,ACRSSDA
 S ACRRRDA=DA
 Q:'$D(^ACRRR(DA,0))  S ACRSSDA=+^(0)
TOTACP1 Q:'$D(^ACRSS(ACRSSDA,"DT"))  S ACRACP=$P(^("DT"),U,3)
 S (ACRIVD,ACRRRX,ACRACP)=0
 F  S ACRRRX=$O(^ACRRR("B",ACRSSDA,ACRRRX)) Q:'ACRRRX  S:$D(^ACRRR(ACRRRX,"DT")) ACRRRDT=^("DT"),ACRIVD=ACRIVD+$P(ACRRRDT,U,6)
 K ACRRRX
 Q
DATE ;
 S DIR(0)="DOA^::E"
 S DIR("A")="DATE INVOICED.......: "
 S DIR("?")="Enter the date the items were actually received"
 D DIR^ACRFDIC
 I $D(ACRQUIT)!$D(ACROUT) D INCOMPLT Q
 S ACRDATE=Y
 Q
ALL ;EP;TO UP-DATE ALL INVOICED ITEMS BASED ON THE RECEIVING REPORT
 Q:'$D(ACRRR)#2
 S X=0,Y=""
 F  S X=$O(^TMP("ACRRR",$J,X)) Q:'X  S Y=Y_X_","
 Q:'+Y
 S ACRIVY=Y
 W !!,"The following procedure will update the invoice record to show that the"
 W !,"quantities and costs on the invoice are the same as the quantities and costs"
 W !,"shown on this receiving report."
 S DIR(0)="YO"
 S DIR("A")="Do you want to proceed"
 S DIR("B")="NO"
 S DIR("?")="Enter 'Y' to proceed with this update, 'N' to return without an invoice update."
 W !
 D DIR^ACRFDIC
 Q:Y'=1
 N ACRI
 F ACRI=1:1 S Y=$P(ACRIVY,",",ACRI) Q:'Y  I $D(^TMP("ACRRR",$J,Y)) S ACRRRDA=+ACRRR(Y) D ADD
 Q
