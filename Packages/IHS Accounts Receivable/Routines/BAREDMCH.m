BAREDMCH ; IHS/SD/SDR - ERA User-defined matching logic ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**20**;OCT 26,2005
 ; new routine
EN ;
 W !!,"This option allows you to create the matching logic for matching bills from"
 W !,"the 835 to the RPMS A/R Bills.  The system will ask you to match based upon"
 W !,"certain questions.  Let's begin."
 W !
 D ^XBFMK
 S DIC=$$DIC^XBDIQ1(90056.24)
 S DIC("A")="Select A/R Account: "
 S DIC(0)="AEMQL"
 D ^DIC
 Q:$D(DTOUT)!$D(DUOUT)
 Q:Y<0
 S BARIEN=+Y
 I +$P(Y,U,3)=0 D  Q:Y=0  ;entry already exists; write info to screen
 .D DISPLAY
 .D ^XBFMK
 .K DIR
 .S DIR(0)="Y"
 .S DIR("A")="Do you wish to edit this entry?"
 .S DIR("B")="N"
 .D ^DIR
 W !
 D ^XBFMK
 S DIE=$$DIC^XBDIQ1(90056.24)
 S DA=BARIEN
 S DR=".02//"
 D ^DIE
 Q:X=""
 I $$GET1^DIQ(90056.24,BARIEN,".02","I")=1 D  Q:X=""
 . D ^XBFMK
 .S DIE=$$DIC^XBDIQ1(90056.24)
 .S DA=BARIEN
 .S DR=".03Ignore/Strip dashes from A/R Bill Number?//;.04Include facility code (up to 4 chars) in matching?//"
 .D ^DIE
 .D ^XBFMK
 .S DIE=$$DIC^XBDIQ1(90056.24)
 .S DA=BARIEN
 .S DR=".05Include HRN in matching?//"
 .I $$GET1^DIQ(90056.24,BARIEN,".04","I")=0 S DR=".05Include HRN in matching?////0"
 .D ^DIE
 .W !
 D ^XBFMK
 S DIE=$$DIC^XBDIQ1(90056.24)
 S DA=BARIEN
 S DR=".06Match on DATE OF SERVICE of A/R Bill?//;W !;.07Match on A/R ACCOUNT (INSURER) of A/R Bill?//;W !;.08Match on AMOUNT BILLED of A/R Bill?//"
 D ^DIE
 Q:X=""
 I $$GET1^DIQ(90056.24,BARIEN,".07","I")=1 D  Q:X=""
 .D ^XBFMK
 .S DIE=$$DIC^XBDIQ1(90056.24)
 .S DA=BARIEN
 .S DR=".09If the sum of all transactions is less than or equal to the Current Bill Amount, continue to post?//"
 .D ^DIE
 Q:X=""
 W !
 D ^XBFMK
 S DIE=$$DIC^XBDIQ1(90056.24)
 S DA=BARIEN
 S DR=".11CANCELLED BILLS -Process, Ask or Ignore//"
 D ^DIE
 Q
DISPLAY ;EP
 W !!?1,"Entry already exists for "_$$GET1^DIQ(90056.24,BARIEN,".01")
 W !?3,"Match on Bill Number: ",?55,$$GET1^DIQ(90056.24,BARIEN,".02")
 I $$GET1^DIQ(90056.24,BARIEN,".02","I")=1 D
 .W !?3,"Ignore/Strip Dashes from A/R Bill Number: ",?55,$$GET1^DIQ(90056.24,BARIEN,".03")
 .W !?3,"Include facility code (up to 4 chars) in matching: ",?55,$$GET1^DIQ(90056.24,BARIEN,".04")
 .W !?3,"Include HRN in matching: ",?55,$$GET1^DIQ(90056.24,BARIEN,".05")
 W !?3,"Match DATE OF SERVICE of the A/R Bill: ",?55,$$GET1^DIQ(90056.24,BARIEN,".06")
 W !?3,"Match on A/R Account (Insurer) of the A/R Bill: ",?55,$$GET1^DIQ(90056.24,BARIEN,".07")
 W !?3,"Match on AMOUNT BILLED of the A/R Bill: ",?55,$$GET1^DIQ(90056.24,BARIEN,".08")
 W !?3,"Continue to post if sum of transactions is",!?10,"less than or equal to CURRENT BILL AMOUNT: ",?55,$$GET1^DIQ(90056.24,BARIEN,".09")
 W !?3,"CANCELLED BILLS: ",?55,$$GET1^DIQ(90056.24,BARIEN,".11")
 ;
 W !!
 Q
