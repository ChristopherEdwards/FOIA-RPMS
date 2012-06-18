BAREDP0Z ; IHS/SD/LSL - MATCH REASONS AND CLAIMS ; 01/30/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**10,20**;OCT 26, 2005
 ; NEW ROUTINE TO LOCKOUT REVERSALS AND PLB SEGMENTS; MRS:BAR*1.8*10 D159
 ; MODIFIED TO LIMIT LOCK OUT TO INDIVIDUAL CHECKS
 ;
EN(IMPDA)     ; EP ; Scan SEGMENTS for PLB, REVERSALS AND NEGATIVE AMOUNTS
 N BARFLG
 Q:'$$IHS^BARUFUT(DUZ(2)) 0             ;Ignore if NON-IHS facility
 W !!,"Now will look for PLBs, Payment Reversals, and Negative Payments..."  ;bar*1.8*20 REQ4
 S BARFLG=0
 S BARFLG=$$PLB(IMPDA)            ;PLB
 S BARFLG=0  ;bar*1.8*20 REQ4
 S BARFLG=$$REV(IMPDA)            ;REVERSALS
 S BARFLG=0  ;bar*1.8*20 REQ4
 S BARFLG=$$NEGP(IMPDA)           ;NEGATIVE AMT PAYMENT
 ;start new code bar*1.8*20 REQ4
 K DIR
 S DIR(0)="E"
 S DIR("A")="<CR> - Continue"
 D ^DIR
 K ^XTMP("BAR-BILLS",$J,DUZ(2)),^XTMP("BAR-BMAMT",$J,DUZ(2))
 ;end new code REQ4
 Q BARFLG
 ;
 ; **************
PLB(IMPDA) ; EP  ;D159-2
 ;start old code bar*1.8*20 REQ4
 ;W !,"Looking for PLB Segment "
 ;N BARCDA,CNT,BARVCK,BARSEG,BARSCK
 ;S BARCDA=0
 ;S (BARVCK,BARSCK)=""
 ;F CNT=1:1 S BARCDA=$O(^BAREDI("I",DUZ(2),IMPDA,15,BARCDA)) Q:'BARCDA  D
 ;.W:'(CNT#1000) "."
 ;.S BAR15=^BAREDI("I",DUZ(2),IMPDA,15,BARCDA,0)
 ;.S BARSEG=$P(BAR15,"*")
 ;.S:BARSEG="TRN" BARVCK=$P(BAR15,"*",3) ;Check Number
 ;.Q:BARSEG'="PLB"                       ;Only want PLB
 ;.Q:BARVCK=BARSCK                       ;Only process once for each check
 ;.S BARFLG="NOT TO POST"
 ;.W !!?5,"PLB Segment found, all transactions"
 ;.W !?5,"in check ",BARVCK," will be set to ",BARFLG
 ;.D LOOP^BAREDP0Z(IMPDA,"PLB",BARVCK)   ;Mark all NOT TO POST
 ;.S BARSCK=BARVCK                       ;Save PLB check number
 ;I BARSCK="" W !,"No PBL Segments found "
 ;end old code start new code REQ4
 W !!,"Looking for PLB Segment... "
 S PLBAMT=+$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCKIEN,0)),U,9)
 I (PLBAMT=0) W "No PLB Segments found" Q BARFLG  ;No PLB
 W "PLB SEGMENT FOUND"
 I (PLBAMT<0) W !?2,"The PLB amount increases the check amount - no further action will be taken" Q BARFLG
 S IENS=BARCKIEN_","_IMPDA
 W !?2,"Bills will be marked Not To Post to accommodate amount ",$FN($$GET1^DIQ(90056.02011,IENS,.09),",",2)
 S BARFLG=1
 D PLBFIND
 ;end new code REQ4
 Q BARFLG
 ;
REV(IMPDA) ;EP ;D159-1
 ;W !,"Looking for Payment Reversals "  ;bar*1.8*20 REQ4
 W !!,"Looking for Payment Reversals... "  ;bar*1.8*20 REQ4
 N BARCDA,BAR15,BARAMT,CNT,BARVCK,BARSCK
 S BARCDA=0
 S (BARVCK,BARSCK)=""
 ;start old code bar*1.8*20 REQ4
 ;F CNT=1:1 S BARCDA=$O(^BAREDI("I",DUZ(2),IMPDA,15,BARCDA)) Q:'BARCDA  D
 ;.W:'(CNT#1000) "."
 ;.S BAR15=$G(^BAREDI("I",DUZ(2),IMPDA,15,BARCDA,0))
 ;.S BARSEG=$P(BAR15,"*")
 ;.S:BARSEG="TRN" BARVCK=$P(BAR15,"*",3)    ;Check number
 ;.Q:$P(BAR15,"*")'="CLP"         ;Only looking for PAYMENTS
 ;.Q:$P(BAR15,"*",3)'=22          ;Only looking for REVERSALS CLP02
 ;.Q:BARSCK=BARVCK                ;Only process once for each check
 ;.S BARFLG="NOT TO POST"
 ;.W !!?5,"Payment Reversal found, all transactions"
 ;.W !?5,"in check ",BARVCK," will be set to ",BARFLG
 ;.D LOOP^BAREDP0Z(IMPDA,"REV",BARVCK)    ;Mark all NOT TO POST
 ;.S BARSCK=BARVCK                        ;Save Reversal check number
 ;I BARSCK="" W !,"No Payment Reversals found "
 ;end old code start new code REQ4
 S BAR="REV"
 S REVAMT=0
 S BARCNT=0
 K ^XTMP("BAR=REV",$J)
 F CNT=1:1 S BARCDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA)) Q:'BARCDA  D
 .;W:'(CNT#1000) "."  ;bar*1.8*20 REQ4
 .Q:(+$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0)),U,11)'=22)  ;only looking for REVERSALS
 .Q:($P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,2)),U)'=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCKIEN,0)),U))  ;not check number I want
 .I BARFLG=0  D
 ..W "PAYMENT REVERSAL FOUND",!?3,"Bills will be marked Not To Post to accommodate "
 ..W !,?6,"E-Bill#",?27,"E-Pymt",?39,"E-Claim Status Code"
 .S BARFLG=1
 .S BARCNT=+$G(BARCNT)+1
 .S EAMT=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0)),U,4)
 .S EBILL=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0)),U)
 .S ESTAT=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0)),U,11)
 .S ^XTMP("BAR-REV",$J,DUZ(2),BARCDA)=EBILL
 .W !,BARCNT,?6,EBILL,?27,$FN(EAMT,",",2),?39,ESTAT
 .D UP(IMPDA,BARCDA,"REV")
 .S REVAMT=+$G(REVAMT)-$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0)),U,4)
 I BARFLG D REVFIND
 I 'BARFLG W "No Payment Reversals found" Q BARFLG  ;No Payment Reversals
 ;end new code REQ4
 Q BARFLG
 ;
NEGP(IMPDA) ;EP ;D159-1
 ;W !,"Looking for Negative Payments "  ;bar*1.8*20 REQ4
 W !!,"Looking for Negative Payments... "  ;bar*1.8*20 REQ4
 N BARCDA,BAR300,BARAMT,CNT,BARSTA,BAR302,BARVCK,BARSCK
 S BARCDA=0
 S BARSCK=""
 S BARCNT=0,REVAMT=0  ;bar*1.8*20 REQ4
 F CNT=1:1 S BARCDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA)) Q:'BARCDA  D
 .;W:'(CNT#1000) "."  ;bar*1.8*20 REQ4
 .S BAR300=$G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0))
 .S BAR302=$G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,2))
 .S BARVCK=$P(BAR302,U)           ;Check number
 .S BARSTA=+$P(BAR300,U,11)
 .I BARSTA="" S BARSTA=$P(BAR302,U,4)
 .Q:(U_"1"_U_"2"_U_"3"_U_"4"_U_"19"_U_"20"_U_"21"_U)'[(U_BARSTA_U)  ;Only want PAYMENTS & DENIALS
 .Q:($P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,2)),U)'=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCKIEN,0)),U))  ;not check number I want
 .S BARAMT=$P(BAR300,U,4)
 .I BARAMT<0 D
 ..Q:BARVCK=BARSCK                ;Only process once for each check
 ..I BARFLG=0 W "NEGATIVE PAYMENT AMOUNT FOUND",!?2,"Bills will be marked Not To Post to accommodate"  ;bar*1.8*20 REQ4
 ..I BARFLG=0 W !,?6,"E-Bill#",?27,"E-Pymt",?39,"E-Claim Status Code"  ;bar*1.8*20 REQ4
 ..S BARFLG=1
 ..;W !!?5,"Negative Payment Amount found, all transactions"  ;bar*1.8*20 REQ4
 ..;D LOOP^BAREDP0Z(IMPDA,"NEGP",BARVCK)   ;Mark all NOT TO POST  ;bar*1.8*20 REQ4
 ..S BARSCK=BARVCK                        ;Save Negative amount check number
 ..;Start new code bar*1.8*20 REQ4
 ..S BARCNT=+$G(BARCNT)+1
 ..S EAMT=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0)),U,4)
 ..S EBILL=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0)),U)
 ..S ^XTMP("BAR-REV",$J,DUZ(2),BARCDA)=EBILL
 ..W !,BARCNT,?6,EBILL,?27,$FN(EAMT,",",2),?39,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0)),U,11)
 ..D UP(IMPDA,BARCDA,"NEGP")
 ..S REVAMT=+$G(REVAMT)+$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,0)),U,4)
 I BARFLG S BAR="NEGP" D REVFIND
 ;end new code REQ4
 ;I BARSCK="" W !,"No Negative Payments found "  ;bar*1.8*20 REQ4
 I 'BARFLG W "No Negative Payments found "  ;bar*1.8*20 REQ4
 Q BARFLG
 ;
LOOP(IMPDA,REASON,VCHK) ;EP; LOOP THROUGH BAREDI("I",IMPDA AND FLAG NOT TO POST
 ;
 N BARCDA,TCHK
 S BARCDA=0
 F  S BARCDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA)) Q:'BARCDA  D
 .S TCHK=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,BARCDA,2)),U)   ;Transaction check #
 .Q:TCHK'=VCHK                  ; Limit it to just the one check
 .D UP(IMPDA,BARCDA,REASON)
 Q
 ;
UP(IMPDA,XCLM,REASON) ;EP; UPDATE STATUS
 K DIR,DIE,DA,DIC,DR,X
 ;start old code bar*1.8*20 REQ5
 ;S BARSTAT="N"
 ;S DIE=$$DIC^XBDIQ1(90056.0205)
 ;S DA(1)=IMPDA
 ;S DA=XCLM
 ;S DR=".02///^S X=BARSTAT"
 ;D ^DIE
 ;end old code REQ5
 K DIR,DIE,DA,DIC,DR
 S DIC("P")=$P(^DD(90056.0205,401,0),U,2)
 S DA(2)=IMPDA
 S DA(1)=XCLM
 S DIC(0)="L"
 S DIC="^BAREDI(""I"",DUZ(2),"_DA(2)_",30,"_DA(1)_",4,"
 S X=REASON
 D ^DIC
 Q
 ;start new code bar*1.8*20 REQ4
PLBFIND ; EP
 ;first put all bills for check into bill amount order
 S CLMDA=0
 K ^XTMP("BAR-MBAMT",$J,DUZ(2))
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA)) Q:'CLMDA  D
 .Q:($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,2)),U)'=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCKIEN,0)),U))  ;only my check
 .Q:$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U)="P"  ;already posted
 .Q:(("1^2^3^19^20^21^")'[("^"_$P($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,11)," | ")_"^"))  ;not a payment
 .S CHKREASN=$$RCHK
 .;if ERA claim has already been marked NTP for PLB, lessen PLB amount by that ERA claim amount
 .I BARRCHK=1,((CHKREASN)="PLB") D  Q
 ..S PLBAMT=PLBAMT-$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4)
 ..W !?5,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U)_" for $"_$J($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4),2)_" was marked Not To Post"
 .S ^XTMP("BAR-MBAMT",$J,DUZ(2),$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4),CLMDA)=""  ;E-payment
 S BAMT=0,BARDONE=0
 I PLBAMT=0!(PLBAMT<0) Q
 F  S BAMT=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),BAMT)) Q:'BAMT  D  Q:BARDONE
 .Q:(BAMT<PLBAMT)  ;bill amount must be = or > than PLB amount
 .S CLMDA=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),BAMT,0))  ;get first claim with that amount
 .;by here the BAMT should be as much or more than the PLB amount
 .D UP(IMPDA,CLMDA,"PLB")  ;mark bill Not To Post
 .S BARDONE=1
 .W !?2,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U)_" for $"_$J($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4),2)_" was marked Not To Post"
 Q:BARDONE  ;stop here if a bill was found and marked Not To Post
 S BAMT=99999999999
 F  S BAMT=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),BAMT),-1) Q:'BAMT  D  Q:BARDONE
 .S CLMDA=999999
 .F  S CLMDA=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),BAMT,CLMDA),-1) Q:'CLMDA  D  Q:BARDONE
 ..D UP(IMPDA,CLMDA,"PLB")  ;mark bill Not To Post
 ..S PLBAMT=PLBAMT-BAMT
 ..I PLBAMT=0!(PLBAMT<0) S BARDONE=1
 ..W !?5,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U)_" for $"_$J($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4),2)_" was marked Not To Post"
 W !
 Q
REVFIND ;EP
 ;find pymt to "counter" either payment reversal or negative payment and mark it Not To Post
 ;payment can be either on same bill, or different bill, or over several bills to "cover" amount
 S MTCHAMT=$S(REVAMT<0:(REVAMT*-1),1:REVAMT)  ;total amount that needs to be written off
 D BUILDLST
 Q:MTCHAMT<0  ;bills have already been marked Not To Post
 ;go through list first time looking for amount on same claim
 S REVDA=0,BARDONE=0
 S EDA=0
 F  S EDA=$O(^XTMP("BAR-REV",$J,DUZ(2),EDA)) Q:'EDA  D
 .S EBILL=$G(^XTMP("BAR-REV",$J,DUZ(2),EDA))
 .S EAMT=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,EDA,0)),U,4)
 .S EAMT=EAMT*-1
 .I $D(^XTMP("BAR-BILLS",$J,DUZ(2),EBILL)) D
 ..S MDA=0
 ..F  S MDA=$O(^XTMP("BAR-BILLS",$J,DUZ(2),EBILL,MDA)) Q:'MDA  D
 ...S MAMT=$P($G(^BAREDI("I",DUZ(2),IMPDA,30,EDA,0)),U,4)
 ...I EAMT=MAMT D
 ....S RCLMDA=$O(^XTMP("BAR-BILLS",$J,DUZ(2),EBILL,MDA,0))
 ....D UP(IMPDA,RCLMDA,$S(BAR="REV":"REV",1:"NEGP"))
 ....S MTCHAMT=MTCHAMT-MAMT
 ....W !?6,EBILL,?27,$J(MAMT,",",2),?39,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,MDA,0)),U,11)
 ....K ^XTMP("BAR-BILLS",$J,DUZ(2),EBILL,MDA)
 I MTCHAMT>0 D
 .S MAMT=0
 .F  S MAMT=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),MAMT)) Q:'MAMT  D
 ..S MDA=0
 ..F  S MDA=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),MAMT,MDA)) Q:'MDA  D
 ...Q:MTCHAMT'=MAMT
 ...;S RCLMDA=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),EBILL,MDA,0))
 ...D UP(IMPDA,MDA,$S(BAR="REV":"REV",1:"NEGP"))
 ...S MTCHAMT=MTCHAMT-MAMT
 ...W !?6,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,MDA,0)),U),?27,$J(MAMT,",",2),?39,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,MDA,0)),U,11)
 I MTCHAMT>0 D  Q:((MTCHAMT=0)!(MTCHAMT<0))
 .S MAMT=999999999
 .F  S MAMT=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),MAMT),-1) Q:'MAMT  D  Q:((MTCHAMT=0)!(MTCHAMT<0))
 ..S MDA=0
 ..F  S MDA=$O(^XTMP("BAR-MBAMT",$J,DUZ(2),MAMT,MDA)) Q:'MDA  D  Q:((MTCHAMT=0)!(MTCHAMT<0))
 ...D UP(IMPDA,MDA,$S(BAR="REV":"REV",1:"NEGP"))
 ...S MTCHAMT=MTCHAMT-MAMT
 ...W !?6,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,MDA,0)),U),?27,$J(MAMT,",",2),?39,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,MDA,0)),U,11)
 W !
 Q
BUILDLST ;EP
 S CLMDA=0
 K ^XTMP("BAR-MBAMT",$J,DUZ(2)),^XTMP("BAR-BILLS",$J,DUZ(2))
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA)) Q:'CLMDA  D
 .Q:($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,2)),U)'=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCKIEN,0)),U))  ;only my check
 .Q:$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,2)="P"  ;already posted
 .Q:$D(^XTMP("BAR-REV",$J,DUZ(2),CLMDA))  ;bill is reversal
 .S CHKREASN=$$RCHK
 .;if ERA claim has already been marked NTP for PLB, lessen PLB amount by that ERA claim amount
 .I BARRCHK=1,((CHKREASN)=$S(BAR="REV":"REV",1:"NEGP")) D  Q
 ..S MTCHAMT=MTCHAMT-$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4)
 ..W !?6,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U),?27,$J($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4),",",2),?39,$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,11)
 .S ^XTMP("BAR-MBAMT",$J,DUZ(2),$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4),CLMDA)=""  ;E-payment
 .S ^XTMP("BAR-BILLS",$J,DUZ(2),$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U),$P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,0)),U,4),CLMDA)=""  ;bills
 Q
RCHK(CHKREASN) ;
 S BARRCHK=0,CHKREASN=""
 Q:'$D(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4)) CHKREASN  ;no reasons not to post
 S BARNTPR=0
 F  S BARNTPR=$O(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4,BARNTPR)) Q:'BARNTPR  D  Q:CHKREASN
 .I "^PLB^REV^NEGP^"[("^"_$P($G(^BARERR($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4,BARNTPR,0)),U),0)),U)_"^") D
 ..S BARRCHK=1
 ..S CHKREASN=$P($G(^BARERR($P($G(^BAREDI("I",DUZ(2),IMPDA,30,CLMDA,4,BARNTPR,0)),U),0)),U)
 Q CHKREASN
 ;end new code REQ4
