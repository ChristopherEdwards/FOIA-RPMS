ABMDTLAB ; IHS/ASDT/DMJ - Enter/Edit Lab CPT's in table  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/ASDS/LSL - 07/02/01 - V2.4 Patch 9 - NOIS NEA-0600-180021
 ;     New routine to allow entry of Lab CPT's to 3P CPT TABLE file.
 ;     Thanks to Jim Gray for the code.         
 ;
 ; *********************************************************************
 Q
 ;
START ; EP
 F  D START2 Q:$G(Y)=-1!$D(DTOUT)!$D(DUOUT)
 Q
 ; *********************************************************************
START2 ;
 K DTOUT,DUOUT
 S DIC=9002274.37
 S DIC(0)="AQEMSLN"
 S DIC("A")="Select Lab CPT table entry: "
 S DIC("S")="I $P(^(0),U,2)=""LAB"""
 S DIC("W")="W ""  "",$P(^(0),U,4,5)"
 S DLAYGO=9002274
 D ^DIC
 Q:Y=-1!$D(DTOUT)!$D(DUOUT)
 S ABMDA=+Y
 S ABMNEW=$P(Y,U,3)
 K DIR
 I 'ABMNEW D  Q:$D(DTOUT)!$D(DUOUT)  I Y="D" D DEL Q
 . S DIR(0)="SM^M:Modify;D:Delete"
 . S DIR("A")="Select action on selected table entry"
 . S DIR("?")="Do you wish to modify or delete the selected entry?"
 . D ^DIR
 S DIR(0)="N^80000:89999:0"
 S DIR("A")="Low CPT: "
 S DIR("?")="Enter LAB CPT code at lower end of range."
 S DIR("B")=$$GET1^DIQ(9002274.37,ABMDA_",",4)
 D ^DIR
 I ABMNEW,+Y=0 S ABMDEL="@" D DEL S Y=-1 Q
 Q:+Y=0
 S ABML=Y
 S DIR(0)="N^"_ABML_":89999:0"
 S DIR("A")="High CPT: "
 S DIR("?")="Enter LAB CPT code at higher end of range."
 S DIR("B")=$$GET1^DIQ(9002274.37,ABMDA_",",5)
 D ^DIR
 I ABMNEW,+Y=0 S ABMDEL="@" D DEL S Y=-1 Q
 Q:+Y=0
 S ABMH=Y
 K DIR
 S DIE=DIC
 S DA=ABMDA
 S DR="2///LAB;4///"_ABML_";5///"_ABMH
 D ^DIE
 Q
 ;
DEL ;Delete entry if both CPT codes not entered
 W !,"Deleting"
 S DIE=DIC
 S DA=ABMDA
 S DR=".01///@"
 D ^DIE
 Q
