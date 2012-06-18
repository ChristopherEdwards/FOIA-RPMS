ABSPOS6N ; IHS/OIT/SCR - Functions to Close and Re-open a claim ;   
 ;;1.0;PHARMACY POINT OF SALE;**37,40**;JUN 21, 2001
 Q
CLOSECLM(ABSP59)         ;EP - from ABSPOS6D
 ;
 ;  parameters: ABSP59 ien to Transaction Log where claim information is located
 ;
 ;IHS/OIT/CASSEVERN/RAN - 12/16/2010 - Patch 40 Following line added to Allow us to use full screen not 
 U $P D:IO=$P FULL^VALM1 U IO
 W "You have selected to close the following claim",!
 N ABSPRFL,ABSPNAM,ABSPDFN,ABSPRSLT,DIR,Y,ABSPANS,ABSPCLSD
 S ABSPANS=0
 S ABSPCLSD=0
 W "Prescription #",$P(^ABSPT(ABSP59,1),U,11) ;
 S ABSPRFL=$P($G(^ABSPT(ABSP59,1)),U) I ABSPRFL W " Refill #",ABSPRFL
 W "   (ABSP59=",ABSP59,")"
 W !
 W "Patient: "
 ;S X=$P(REC(0),U,6) I X]"" S X=$P($G(^DPT(X,0)),U) W X
 S ABSPDFN=$P($G(^ABSPT(ABSP59,0)),U,6)
 I ABSPDFN>0 S ABSPNAM=$P($G(^DPT(ABSPDFN,0)),U) W ABSPNAM
 ;
 ;NOW...find out if this claim was rejected - if not, it can't be closed
 S ABSPRSLT=$$CATEG^ABSPOSUC(ABSP59,1)
 W !,"This claim has a status of : ",ABSPRSLT
 I ABSPRSLT="E REJECTED" D
 .W !,"This claim can be closed"
 .S ABSPANS=1
 .S DIR("B")="YES"
 .Q
 I ABSPRSLT'="E REJECTED" D
 .W !,"This claim can not be closed"
 .S ABSPANS=0
 .S DIR("B")="NO"
 .Q
 S DIR("A")="CONTINUE CLOSING CLAIM"
 S DIR(0)="Y"
 D ^DIR
 Q:($G(DTOUT)!$G(DUOUT))
 S:ABSPANS ABSPANS=Y
 I ABSPANS D
 .;I 1 D
 .;IHS/OIT/CASSEVERN/RAN - 12/7/2010 - Patch 40 Added Product Not Covered as valid Reason for closure
 .S DIR(0)="SX^C:Claim Too Old;R:Refill Too Soon;P:Plan Limit Exceeded;X:Product Not Covered"
 .S DIR("B")="X"
 .S DIR("A")="CLOSE REASON"
 .D ^DIR
 .Q:($G(DTOUT)!$G(DUOUT))
 .W !,"ABOUT TO CLOSE THIS CLAIM WITH REASON "_Y
 .S ABSPCLSD=$$UPDTCLS(ABSP59,Y)
 .Q
 I ABSPCLSD D
 .N ABSP57 S ABSP57=$$NEW57^ABSPOSU(ABSP59)   ;create an entry in transaction log recording this change
 .W !,"THE CLAIM WAS CLOSED"
 .;S ^TMP("ABSPOS",$J,"PATIENT")=ABSPDFN
 W:'ABSPCLSD !,"THE CLAIM WAS *NOT* CLOSED"
 Q ABSPCLSD
 ;
UPDTCLS(ABSP59,ABSPRSN)  ;UPDATE ^ABSPT WITH CLOSED STATUS, USER INFO, DATE AND REASON
 N ABSPNOW,ABPDUZ,ABSPCLM,ABSPDUZ,ABSPRET,ABSPLOCK,DIE,DR,DA,%,Y,DIC,ABSPDFN
 D NOW^%DTC
 S ABSPRET=0
 S ABSPNOW=%
 S ABSPDUZ=DUZ
 S ABSPDFN=$P($G(^ABSPT(ABSP59,0)),U,6)
 S ABSPCLM=$P($G(^ABSPT(ABSP59,0)),U,4)
 W !,"Updating Claim '"_ABSPCLM
 ;Q:'ABSPCLM ABSPRET
 ;L +^ABSPC(ABSPCLM):0
 L +^ABSPT(ABSP59):3
 S ABSPLOCK=$T
 I ABSPLOCK D
 .S DIE="^ABSPT("
 .S DA=ABSP59
 .;S DR="901///1;902////"_ABSPNOW_";903////"_ABSPDUZ_";906///"_ABSPRSN
 .S DR="7////"_ABSPNOW_";901///1;902////"_ABSPNOW_";903////"_ABSPDUZ_";906///"_ABSPRSN
 .D ^DIE
 .L -^ABSPT(ABSP59)
 .S ABSPRET=1
 .Q
 I 'ABSPLOCK W !,"ANOTHER USER IS EDITING THIS ENTRY. TRY AGAIN LATER"
 ;S ^TMP("ABSPOS",$J,"PATIENT")=ABSPDFN
 Q ABSPRET
 ;
OPENCLM()  ;re-open claim display driver
 N ABSP59,ABSPRSLT,ABSPDONE,Y,ABSPTXN,ABSPDFN,DIR
 S ABSPRSLT=0
 W !,!
 S ABSPDONE=0
 F  Q:ABSPDONE  D
 .S ABSPDFN=$$CLSDPAT()
 .I ABSPDFN<1 S ABSPDONE=1 Q
 .I ABSPDFN=0 Q
 .S ABSPTXN=$$CLSDTXN(ABSPDFN)
 .I 'ABSPTXN S ABSPDONE=1 Q
 .S ABSPRSLT=$$UPDTOPN(ABSPTXN)
 .S DIR(0)="Y"
 .S DIR("B")="NO"
 .S DIR("A")="RE-OPEN more claims"
 .D ^DIR
 .I $G(DTOUT)!$G(DUOUT)!'$G(Y) S ABSPDONE=1 Q
 .W:ABSPRSLT !,"Done.",!
 H 1
 Q ABSPRSLT
 ;
UPDTOPN(ABSP59)  ;UPDATE ^ABSPT WITH OPEN STATUS, USER INFO, DATE
 N ABSPNOW,ABPDUZ,ABSPCLM,ABSPRET,ABSPLOCK,DIE,DR,DA,%,Y,DIC
 N DIR
 S DIR("A")="RE-OPEN THIS CLAIM"
 S DIR(0)="Y",DIR("B")="YES"
 D ^DIR
 Q:'+Y
 D NOW^%DTC
 S ABSPRET=0
 S ABSPNOW=%
 S ABSPDUZ=DUZ
 W !," ***Re-opening Claim*** "_ABSP59
 L +^ABSPT(ABSP59):3
 S ABSPLOCK=$T
 I ABSPLOCK D
 .S DIE="^ABSPT("
 .S DA=ABSP59
 .S DR="7////"_ABSPNOW_";901////0;904////"_ABSPNOW_";905////"_ABSPDUZ
 .D ^DIE
 .L -^ABSPT(ABSP59)
 .N ABSP57 S ABSP57=$$NEW57^ABSPOSU(ABSP59)   ;create an entry in transaction log recording this change
 .S ABSPRET=1
 .Q
 I 'ABSPLOCK W !,"ANOTHER USER IS EDITING THIS ENTRY. TRY AGAIN LATER"
 Q ABSPRET
CLSDPAT()  ;display patients that have POS transaction
 N DIC,ABSPDUZ2
 S ABSPDUZ2=DUZ(2)
 S DUZ(2)=0  ;TO ALLOW USERS TO SELECT FROM ALL LOCATIONS
 S DIC=2,DIC(0)="AEMQZ",DIC("A")="Select Closed Claims for which patient? "
 S DIC("S")="I $D(^ABSPT(""AC"",Y))"
 D ^DIC W !
 S DUZ(2)=ABSPDUZ2 ; Restore original DUZ(2) ; ABSP*1.0T7*7
 S ABSPDFN=+Y
 Q ABSPDFN
 ;
CLSDTXN(ABSPDFN)  ;display closed transactions for identified patient
 N ABSPTXN,DIR,ABSPRTRN,ABSPARRY,ABSPQUIT,ABSPCNT
 S ABSPCNT=0
 S ABSPQUIT=0
 S ABSPRTRN=0
 S ABSPTXN=""
 S DIR(0)="SO^"
 F  S ABSPTXN=$O(^ABSPT("AC",ABSPDFN,ABSPTXN)) Q:ABSPTXN=""  D
 .I $P($G(^ABSPT(ABSPTXN,9)),U,1)=1 D
  ..S ABSPCNT=ABSPCNT+1
  ..S DIR(0)=DIR(0)_ABSPCNT_":"_ABSPTXN_";"
  ..S ABSPARRY(ABSPCNT)=ABSPTXN
  ..S ABSPUSR=$P($G(^ABSPT(ABSPTXN,9)),U,3)
  ..S ABSPRSN=$P($G(^ABSPT(ABSPTXN,9)),U,6)
  ..;IHS/OIT/CASSEVERN/RAN - 12/16/2010 - Patch 40 Added Product Not Covered as valid Reason for closure
  ..S ABSPRSN=$S(ABSPRSN="C":"Claim Too Old",ABSPRSN="R":"Refill Too Soon",ABSPRSN="P":"Plan Limit Exceeded",ABSPRSN="X":"Product Not Covered",1:"NO CLOSE REASON")
  ..W !!,ABSPTXN,!," Closed on "
  ..S Y=$P($G(^ABSPT(ABSPTXN,9)),U,2)
  ..D DT^DIO2  ;this writes out a well formatted date...believe it or not...
  ..W !,"      By: "_$P($G(^VA(200,ABSPUSR,0)),U,1)_"      Close Reason: "_ABSPRSN
 .Q
 I DIR("0")="SO^" D
 .S DIR("B")="NO"
 .S DIR("A")="Would you like to look for another patient"
 .S DIR("A",1)="No CLOSED transactions found for this patient"
 .S DIR("0")="Y"
 .D ^DIR
 .I +Y S ABSPRTRN=0
 .S ABSPQUIT=1
 Q:ABSPQUIT ABSPRTRN
 I DIR("0")'="SO^" D
 .S DIR("B")="1"
 .S DIR("A")="Select CLOSED transaction to RE-OPEN"
 .D ^DIR
 .Q:$G(DTOUT)!$G(DUOUT)
 .S:$G(Y) ABSPRTRN=ABSPARRY(+Y)
 Q ABSPRTRN
