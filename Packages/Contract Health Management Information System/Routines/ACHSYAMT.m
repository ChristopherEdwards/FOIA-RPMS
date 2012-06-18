ACHSYAMT ; IHS/ITSC/PMF - RECALC OBLIGATION AMOUNTS ;  [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ; This routine ensures the obligated amount is correct for each
 ; document.  It is uncertain whether it needs to be run for each
 ; facility that installs CHS, as the incorrect obligated amount
 ; was incurred at a very few sites that participated in the Alpha
 ; test during development of 2.0.
 ;
 ; This was part of the postinit for version 2.0.
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." Q
 D HOME^%ZIS,DT^DICRW,INTRO
 S (DIR(0),DIR("B"))="Y"
 S DIR("A")="Do you want to queue the updates to TaskMan"
 S DIR("??")="^D Q2^ACHSYAMT"
 D ^DIR
 G Q2:$D(DIRUT),START:'Y
QUE ;
 S %DT="AERSX",%DT("A")="Requested Start Time: ",%DT("B")="T@2015",%DT(0)="NOW"
 D ^%DT
 I Y<1 W !,"QUEUE INFORMATION MISSING - NOT QUEUED",!!,"Okay.",! D Q2 Q
 S X=+Y
 D H^%DTC
 S ZTDTH=%H_","_%T
 S ZTRTN="START^ACHSYAMT",ZTIO="",ZTDESC=$P($P($T(+1),";",2)," ",4,99)
 D ^%ZTLOAD,HOME^%ZIS
 I $D(ZTSK) W !!,"QUEUED TO TASK ",ZTSK,!!,"A mail message with the results will be sent to your MailMan 'IN' basket.",! K ^TMP("ACHSYAMT",$J)
 E  W !!,*7,"QUEUE UNSUCCESSFUL.  RESTART UTILITY."
 Q
 ;
START ;EP - From Taskman
 ;
 N XMSUB,XMDUZ,XMTEXT,XMY
 K ^TMP("ACHSYAMT",$J)
 D WORK
 S (XMSUB,XMDUZ)=$P($P($T(+1),";",2)," ",4,99),XMTEXT="^TMP(""ACHSYAMT"",$J,""RSLT"",",XMY(1)="",XMY(DUZ)="" D ^XMD
 K ^TMP("ACHSYAMT",$J)
 I $D(ZTQUEUED) S ZTREQ="@"
 E  W !!,"The results are in your MailMan 'IN' basket.",!
 Q
 ;
WORK ;
 D RSLT("*** RESETTING 3RD PARTY PAY, OBLICATIONS AND PAYMENT NODES IN DOCUMENT FILE ***")
 ;
 ; L = Location (DUZ(2)), C = Counter
 S (C,L)=0
LOC ;
 S L=$O(^ACHSF(L))
 G END:'L
 D RSLT("Processing "_$P(^DIC(4,L,0),U)_" PO's.")
 S D=0
DOC ;
 S D=$O(^ACHSF(L,"D",D))
 G LOC:'D
 LOCK +^ACHSF(L,"D",D):30
 E  D RSLT("Can't LOCK ^ACHSF("_L_"""D"","_D_").") G DOC
 S ACHSOBLG=0,C=C+1
 I '$D(ZTQUEUED),'(C#100) W "."
 S T=0
TRANS ;
 S T=$O(^ACHSF(L,"D",D,"T",T))
 I 'T LOCK -^ACHSF(L,"D",D) G DOC
 S %=$P(^ACHSF(L,"D",D,"T",T,0),U,2)
 D @%
 G TRANS
END ;
 D RSLT(C_" PO's processed.")
 D RSLT("CHS data updates complete.")
 K ACHSAMT,D,T,ACHSOBLG,C
 Q
 ;
RSLT(%) S ^(0)=$G(^TMP("ACHSYAMT",$J,"RSLT",0))+1,^(^(0))=% W:'$D(ZTQUEUED) !,% Q
 ;
I ; Initial
 S ACHSOBLG=ACHSOBLG+$P(^ACHSF(L,"D",D,"T",T,0),U,4),$P(^ACHSF(L,"D",D,0),U,9)=ACHSOBLG
 Q
S ; Supplemental
 S ACHSOBLG=ACHSOBLG+$P(^ACHSF(L,"D",D,"T",T,0),U,4),$P(^ACHSF(L,"D",D,0),U,9)=ACHSOBLG
 Q
C ; Cancellation
 S ACHSOBLG=ACHSOBLG-$P(^ACHSF(L,"D",D,"T",T,0),U,4),$P(^ACHSF(L,"D",D,0),U,9)=ACHSOBLG
 Q
P ; Payment
 S ACHSAMT=$P(^ACHSF(L,"D",D,"T",T,0),U,8)
 S $P(^ACHSF(L,"D",D,"PA"),U,5)=ACHSAMT
 Q:'$D(^ACHSF(L,"D",D,"PA"))
 Q:$P(^ACHSF(L,"D",D,"PA"),U,6)
 S $P(^ACHSF(L,"D",D,"PA"),U,6)=$P(^("PA"),U,1)
 S:$D(^ACHSF(L,"D",D,"IP")) $P(^("PA"),U,1)=$P(^("PA"),U,1)+$P(^("IP"),U,1)
 S $P(^ACHSF(L,"D",D,"PA"),U,2)=$P(^("PA"),U,1)-$P(^ACHSF(L,"D",D,0),U,9)
 Q
ZA ; Adjustment
 S ACHSAMT=$P(^ACHSF(L,"D",D,"T",T,0),U,8)
 S $P(^ACHSF(L,"D",D,"ZA"),U,4)=ACHSAMT
 S $P(^ACHSF(L,"D",D,"ZA"),U,1)=$P(^("ZA"),U,2)+$P(^ACHSF(L,"D",D,"PA"),U,1)
 Q
IP ;
 Q
 ;
INTRO ;
 W ! F %=2:1:4 W ?5,$P($T(INTRO+%),";;",2),!
 ;;This utility reads thru each PO, re-adds the total amount obligated
 ;;for each document, and ensures the total amount obligated field
 ;;in the Document record is correct.
 Q
 ;
Q2 ;EP - From DIR
 W ! F %=2:1:6 W ?5,$P($T(Q2+%),";;",2),!
 ;;Answer "Y" or "N" to q to TaskMan or not.
 ;;
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message sent to you and user 1.  If you queue
 ;;to TaskMan, please read the mail message for results of this patch.
 Q
 ;
