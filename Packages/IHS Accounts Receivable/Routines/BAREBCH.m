BAREBCH ; IHS/SD/SDR - EDIT COLLECTION BATCH/ITEMS JAN 15,1997 ; 11/21/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**4,10,20**;OCT 26, 2005
 ; New routine in bar*1.8*4 for DD item 4.1.5.2
 ;
EN ;EP;
 K BARSTAR,BAREQUAL,BARDASH
 K BARCBIEN,BARTRIEN,BARPFLG,BARVALUE
 ;K BARNBCH,BARNAMT  ;IHS/SD/AML 5/3/2011 bar*1.8*20
 K BARNBCH,BARNAMT,BARNDDT  ;IHS/SD/AML 5/3/2011 bar*1.8*20
 ;
 S $P(BARSTAR,"*",79)="*"
 S $P(BAREQUAL,"=",79)="="
 S $P(BARDASH,"-",79)="-"
 ;
 W !!,$$EN^BARVDF("RVN"),"Note: ",$$EN^BARVDF("RVF")
 W "Collection Batch and Item's that have not been posted may be modified."
 W !?6,"If you entered a TDN/IPAC in error and the batch has been posted, you"
 W !?6,"may not edit the TDN/IPAC and must notify your Finance Office to make"
 W !?6,"adjustments in the financial system.",!!
 ;
SELECT ;
 I $G(BARCBIEN)'="" D
 .K BARCBIEN
 .D CLEAR^VALM1
 K DIC,DIE,X,Y,DA
 S DIC="^BARCOL(DUZ(2),"
 S DIC(0)="AEMQ"
 D ^DIC
 Q:$D(DTOUT)!$D(DUOUT)
 Q:Y<0
 S BARCBIEN=+Y
 ;
 ;check for payments posted to selected collection batch
 S BARTRIEN=0
 S BARPFLG=0
 F  S BARTRIEN=$O(^BARTR(DUZ(2),"AD",BARCBIEN,BARTRIEN)) Q:+BARTRIEN=0!(BARPFLG=1)  D  Q:BARPFLG=1
 .I $P($G(^BARTR(DUZ(2),BARTRIEN,1)),U)=40 S BARPFLG=1
 ;
 I BARPFLG=1 W !!,"ITEMS WITHIN THIS COLLECTION BATCH ALREADY HAVE PAYMENTS POSTED AND IS THEREFORE UNEDITABLE",!! H 2 K BARVALUE G SELECT
 ;
 ;no payments posted so display batch/item info and confirm entry
 W !!!!
 W BARSTAR
 W !?2,"Collection Batch: ",$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U),!
 W BARSTAR
 W !?4,"TDN/IPAC: ",$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,28)
 W ?40,"TOTAL AMOUNT BATCHED: $",$FN($P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29),",",2)
 W !?2,"Batched by: ",$P($G(^VA(200,$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,5),0)),U)
 W ?48,"DATE CREATED: ",$$SDT^BARDUTL($P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,4))
 W !,"DEPOSIT DATE: ",$$SDT^BARDUTL($P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,30)),!!  ;IHS/SD/AML 5/3/2011 - ADD TDN/IPAC DEPOSIT DATE bar*1.8*20
 W "Item",?9,"Check#",?27,"A/R ACCOUNT",?46,"TDN/IPAC",?69,"Amount"
 W !
 W BARDASH
 S BARITEM=0
 F  S BARITEM=$O(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM)) Q:+BARITEM=0  D
 .I $P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,17)'="",($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,17)'="E") Q
 .W !,$J(BARITEM,3)  ;item number
 .W ?5,$E($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,11),1,20)  ;item check#
 .W ?27,$E($$GET1^DIQ(90051.1101,BARITEM_","_BARCBIEN_",",7,"E"),1,17)    ;item A/R Acct
 .W ?46,$P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,20)  ;item TDN
 .W ?68,$J($FN($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,1)),U),",",2),12)  ;item amt
 ;
 S DIR(0)="Y"
 S DIR("A")="Correct"
 S DIR("B")="Y"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 I Y<1 G SELECT
 ;
 ;edit the batch TDN and amount
 ;it will prompt for information and display for user to confirm before filling new
 ;data on the collection batch
EDITBCH ;
 W !,"Now Editing COLLECTION BATCH HEADER data:",!!
 ;
 K DIR,DIE,DIC,X,Y,DA
 S DIR(0)="F^6:20^K:'$$GOODIPAC^BARUFEX3(X) X"
 S DIR("A")="Collection Batch TDN/IPAC"
 S DIR("B")=$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,28)
 D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) W !!,"NOTHING CHANGED",!! H 2 G SELECT
 S BARNBCH=Y
 K DIR,DIE,DIC,S,Y,DA
 S DIR(0)="NOA^0:999999999:2"
 S DIR("A")="Total Amount Batched: "
 S DIR("B")=$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29)
 D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) W !!,"NOTHING CHANGED",!! H 2 G SELECT
 S BARNAMT=Y
 ;IHS/SD/AML 5/3/2011 - Begin new code, Added ability to edit Deposit Date bar*1.8*20
 K DIR,DIE,DIC,D,Y,DA
 S DIR(0)="DO"
 S DIR("A")="TDN/IPAC Deposit Date: "
 S DIR("B")=$$SDT^BARDUTL($P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,30))
 D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) W !!,"NOTHING CHANGED",!! H 2 G SELECT
 S BARNDDT=Y
 ;IHS/SD/AML 5/3/2011 - End new code, Added ability to edit Deposit Date
 ;
 ;display header with new info and verify
 W !!,"You have edited the COLLECTION BATCH HEADER data to reflect:",!!
 W BARSTAR
 W !?2,"Collection Batch: ",$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U),!
 W BARSTAR
 W !?4,"TDN/IPAC: ",BARNBCH
 W ?40,"TOTAL AMOUNT BATCHED: $",$FN(BARNAMT,",",2)
 W !?2,"Batched by: ",$P($G(^VA(200,$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,5),0)),U)
 W ?48,"DATE CREATED: ",$$SDT^BARDUTL($P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,4)),!
 W "DEPOSIT DATE: ",$$SDT^BARDUTL(BARNDDT),!!  ;IHS/SD/AML 5/3/2011 - ADD TDN/IPAC DEPOSIT DATE bar*1.*20
 W BARDASH
 ;
 S DIR(0)="Y"
 S DIR("A")="Is this correct"
 D ^DIR K DIR
 I Y<1 G EDITBCH
 ;
 ;TDN entered is the same one on file now; don't edit
 S BAROBCH=$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,28)
 I BAROBCH=BARNBCH D
 .W !!,"TDN not changed.  The TDN entered is the same one currently on file."
 I BAROBCH'=BARNBCH D
 .K DIC,DIE,DR,DA,X,Y
 .S DA(1)=BARCBIEN
 .S DIC="^BARCOL(DUZ(2),"_DA(1)_",1101,"
 .S DIC(0)="LMQ"
 .D NOW^%DTC
 .S X=%
 .S DIC("DR")=".02////28;.03////"_BAROBCH_";.04////"_BARNBCH_";.05////"_DUZ
 .S DLAYGO=90050
 .S DIC("P")=$P(^DD(90051.01,1101,0),U,2)
 .D ^DIC
 .K DIC,DIE,DR,DA,X,Y
 .S DIE="^BARCOL(DUZ(2),"
 .S DA=BARCBIEN
 .S DR="28////"_BARNBCH
 .D ^DIE
 ;
 I $P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29)=BARNAMT D
 .W !!,"Amount not changed.  The amount entered is the same one currently on file."
 I $P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29)'=BARNAMT D
 .K DIC,DIE,DR,DA,X,Y
 .S DA(1)=BARCBIEN
 .S DIC="^BARCOL(DUZ(2),"_DA(1)_",1101,"
 .S DIC(0)="LMQ"
 .H 1
 .D NOW^%DTC
 .S X=%
 .S DIC("DR")=".02////29;.03////"_$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29)_";.04////"_BARNAMT_";.05////"_DUZ
 .S DLAYGO=90050
 .S DIC("P")=$P(^DD(90051.01,1101,0),U,2)
 .D ^DIC
 .K DIC,DIE,DR,DA,X,Y
 .S DIE="^BARCOL(DUZ(2),"
 .S DA=BARCBIEN
 .S DR="29////"_BARNAMT
 .D ^DIE
 ;
 ;IHS/SD/AML 5/3/2011 - BEGIN NEW CODE - ADD ABILITY TO EDIT DEPOSIT DATE bar*1.8*20
 I $P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,30)=BARNDDT D
 .W !!,"Date not changed.  The deposit date entered is the same one currently on file."
 I $P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,30)'=BARNDDT D
 .K DIC,DIE,DR,DA,D,X,Y
 .S DA(1)=BARCBIEN
 .S DIC="^BARCOL(DUZ(2),"_DA(1)_",1101,"
 .S DIC(0)="LMQ"
 .H 1
 .D NOW^%DTC
 .S X=%
 .S DIC("DR")=".02////30;.03////"_$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,30)_";.04////"_BARNDDT_";.05////"_DUZ
 .S DLAYGO=90050
 .S DIC("P")=$P(^DD(90051.01,1101,0),U,2)
 .D ^DIC
 .K DIC,DIE,DR,DA,D,X,Y
 .S DIE="^BARCOL(DUZ(2),"
 .S DA=BARCBIEN
 .S DR="30////"_BARNDDT
 .D ^DIE
 .;
 .;IHS/SD/AML 5/3/2011 - END NEW CODE
 ;now put this TDN on all items with the same TDN
 S BARITEM=0
 F  S BARITEM=$O(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM)) Q:+BARITEM=0  D
 .I $P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,20)=BAROBCH D
 ..K DIC,DIE,DR,DA,X,Y
 ..S DA(1)=BARCBIEN
 ..S DA=BARITEM
 ..S DIE="^BARCOL(DUZ(2),"_DA(1)_",1,"
 ..S DR="20////"_BARNBCH
 ..D ^DIE
 ;
 ;now prompt to change items
EDITITEM ;
 W !!,"Now editing Collection Batch Items....",!
 W BARDASH,!
 W "Item",?9,"Check#",?27,"A/R ACCOUNT",?46,"TDN/IPAC",?69,"Amount"
 W !
 W BARDASH
 S BARITEM=0,BARCNT=0
 F  S BARITEM=$O(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM)) Q:+BARITEM=0  D
 .S BARCNT=+$G(BARCNT)+1
 .I $P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,17)'="",($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,17)'="E") Q
 .W !,$J(BARITEM,3)  ;item number
 .W ?5,$E($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,11),1,20)  ;item check#
 .W ?27,$E($$GET1^DIQ(90051.1101,BARITEM_","_BARCBIEN_",",7,"E"),1,17)    ;item A/R Acct
 .W ?46,$P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,20)  ;item TDN
 .W ?68,$J($FN($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,1)),U),",",2),12)  ;item amt
 W !,BARDASH
 K DIR,DIE,DIC,X,Y,DA
 ;S DIR(0)="NO^1:"_BARCNT
 S DIR(0)="NO"
 S DIR("A")="Select Collection Batch Item to edit"
 D ^DIR K DIR
 ;
 ;I +Y'=0,(($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,17)'="")&($P($G(^BARCOL(DUZ(2),BARCBIEN,1,+Y,0)),U,17)'="E")) W !!,"ITEM NOT EDITABLE; PLEASE CHOOSE FROM DISPLAYED ITEMS" H 1 W !! G EDITITEM  ;MRS:BAR*1.8*10 H1359
 I +Y'=0,(($P($G(^BARCOL(DUZ(2),BARCBIEN,1,+Y,0)),U,17)'="")&($P($G(^BARCOL(DUZ(2),BARCBIEN,1,+Y,0)),U,17)'="E")) W !!,"ITEM NOT EDITABLE; PLEASE CHOOSE FROM DISPLAYED ITEMS" H 1 W !! G EDITITEM  ;MRS:BAR*1.8*10 H1359
 ;display selection
 I +Y'=0 D
 .S BARITEM=Y
 .W !!,$J(BARITEM,3)  ;item number
 .W ?5,$E($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,11),1,20)  ;item check#
 .W ?27,$E($$GET1^DIQ(90051.1101,BARITEM_","_BARCBIEN_",",7,"E"),1,17)    ;item A/R Acct
 .W ?46,$P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,0)),U,20)  ;item TDN
 .W ?68,$J($FN($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,1)),U),",",2),12)  ;item amt
 .;
 .W !
 .K DIC,DIE,X,Y,DA,DR
 .S DA(1)=BARCBIEN
 .S DA=BARITEM
 .S DIE="^BARCOL(DUZ(2),"_DA(1)_",1,"
 .S DR="101Item Amount"
 .I $P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,28)="" S DR="20Item TDN;"_DR
 .D ^DIE
EDITEOB .;
 .I $P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,6,0)),U,4)>1 D  ;more than one EOB
 ..;list EOBs
 ..S BAREOB=0,BARCNT=0
 ..W !!,"Edit EOB Locations..."
 ..W !!?2,"#",?5,"VISIT LOCATION",?40,"AMOUNT",!,BARDASH
 ..F  S BAREOB=$O(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,6,BAREOB)) Q:+BAREOB=0  D
 ...S BARCNT=+$G(BARCNT)+1
 ...W !,$J(BARCNT,3),?5,$P($G(^AUTTLOC($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,6,BAREOB,0)),U),0)),U,2)
 ...W ?40,$J($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,6,BAREOB,0)),U,2),",",2)
 ...S BARLIST(BARCNT)=BAREOB
 ..W !,BARDASH
 ..K DIR,DIE,DIC,X,Y,DA
 ..S DIR(0)="NO^1:"_BARCNT
 ..S DIR("A")="Select Item EOB to edit"
 ..D ^DIR K DIR
 ..S BARSEL=+Y
 ..Q:BARSEL<1
 ..K DIC,DIE,DA,X,Y,DR
 ..S DA(2)=BARCBIEN
 ..S DA(1)=BARITEM
 ..S DIE="^BARCOL(DUZ(2),"_DA(2)_",1,"_DA(1)_",6,"
 ..S DA=$G(BARLIST(BARSEL))
 ..S DR="2//"
 ..D ^DIE
 .I +$G(BARSEL)>0 G EDITEOB
 .;
 .I $P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,6,0)),U,4)=1 D  ;one EOB
 ..K DIC,DIE,DA,X,Y,DR
 ..S DA(2)=BARCBIEN
 ..S DA(1)=BARITEM
 ..S DIE="^BARCOL(DUZ(2),"_DA(2)_",1,"_DA(1)_",6,"
 ..S DA=$O(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,6,0))
 ..S DR="2////"_$P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,1)),U)
 ..D ^DIE
 .;
 .S BAREOB=0,BAREOBT=0
 .F  S BAREOB=$O(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,6,BAREOB)) Q:+BAREOB=0  D
 ..S BAREOBT=+$G(BAREOBT)+($P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,6,BAREOB,0)),U,2))
 .I BAREOBT'=+$P($G(^BARCOL(DUZ(2),BARCBIEN,1,BARITEM,1)),U) W !!,"Total of EOBs don't match item amount." G EDITEOB
 ;
 S BARITTOT=$$ITEMTOT^BARCLU(BARCBIEN)
PICKEDIT ;
 I BARITTOT'=$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29) D
 .W !!,"Batched amount of $",$FN(BARITTOT,",",2)," does not match TDN/IPAC amount of $",$FN($P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29),",",2)
 .K DIR,DIE,DIC,X,Y,DA
 .S DIR(0)="SO^B:BATCH;I:ITEM"
 .S DIR("A")="Which would you like to correct"
 .D ^DIR K DIR
 .S BARSEL=Y
 I $G(BARSEL)="",(BARITTOT'=$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29)) G PICKEDIT
 I "IB"'[($G(BARSEL)),(BARITTOT'=$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29)) G PICKEDIT
 G:(BARITTOT'=$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29)&($G(BARSEL)="I")) EDITITEM
 G:(BARITTOT'=$P($G(^BARCOL(DUZ(2),BARCBIEN,0)),U,29)&($G(BARSEL)="B")) EDITBCH
 ;
 ;if it gets here the batch and items balance and they haven't selected an item to edit
 ;I $D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT) W !!,"NOTHING CHANGED",!!
 ;
 S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
