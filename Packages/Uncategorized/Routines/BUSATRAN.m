BUSATRAN ;GDIT/HS/ALA-Update RPCs for transport ; 02 Apr 2013  2:20 PM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 ;
EN ;EP - entry point
 ;
 NEW DIC,DIE,DR,DA,DTOUT,DIRUT,DUOUT,X,Y,BRPCN,DLAYGO,CURRIEN,QUIT,CURRRPC
 ;
EN1 I $G(IOF)="" D HOME^%ZIS
 W @IOF
 ;
 ;Get RPC
 S DIC="^XWB(8994,",DIC(0)="AEMNZ"
 D ^DIC S BRPCN=+Y I BRPCN<1 Q
 I $G(DTOUT)!($G(DIRUT))!($G(DUOUT)) Q
 ;
 ;See if already exists
 S DIC="^BUSATR(",DIC(0)="MNZ",X=$P(^XWB(8994,BRPCN,0),U,1),DLAYGO=9002319.07
 D ^DIC
 S CURRIEN=+Y,CURRRPC=+$P(Y,U,2)
 S QUIT=1
 ;
 ;Check for adds
 I CURRIEN<0 D  G:'QUIT EN1
 . NEW DIR,X,Y
 . S DIR("A")="Add entry to transport list",DIR("B")="Yes"
 . S DIR(0)="Y"
 . D ^DIR
 . S QUIT=Y
 ;
 ;Check for edits/deletes
 I CURRIEN>0 D  G:'QUIT EN1
 . NEW DIR,X,Y,DA,DIK
 . S DIR(0)="SO^E:Edit Transport Entry;D:Delete Transport Entry"
 . S DIR("A")="Choose operation to perform"
 . S DIR("B")="E"
 . D ^DIR
 . ;
 . ;Edits
 . Q:Y="E"
 . ;
 . ;Quits
 . I Y'="D" S QUIT=0 Q
 . ;
 . ;Deletes
 . S DIR("A")="Are you sure you wish to delete the entry",DIR("B")="No"
 . S DIR(0)="Y"
 . D ^DIR
 . S QUIT=Y Q:'QUIT
 . S DA=CURRIEN,DIK="^BUSATR(" D ^DIK
 . W !,"TRANSPORT ENTRY DELETED..."
 . S QUIT=0
 . S DIR("A")="Do you wish to delete the BUSA RPC definition entry as well",DIR("B")="No"
 . S DIR(0)="Y"
 . D ^DIR
 . S QUIT=Y Q:'QUIT
 . S DA=CURRRPC,DIK="^BUSA(9002319.03," D ^DIK
 . W !,"BUSA RPC DEFINITION DELETED..." H 2
 . S QUIT=0
 ;
 ;Add/Edits
 S DIC="^BUSATR(",DIC(0)="LMNZ",X=$P(^XWB(8994,BRPCN,0),U,1),DLAYGO=9002319.07
 D ^DIC
 I $G(DTOUT)!($G(DIRUT))!($G(DUOUT)) Q
 S DA=+Y,DIE=DIC,DR="[BUSA UPDATE]"
 D ^DIE
 G EN1
 ;
CONV ;EP - Convert the pointers to text
 NEW BUSN,BUSRN,BUSUPD
 S BUSN=0
 F  S BUSN=$O(^BUSA(9002319.03,BUSN)) Q:'BUSN  D
 . S BUSRN=$P(^BUSA(9002319.03,BUSN,0),U,1)
 . I BUSRN'?.N Q
 . S BUSUPD(9002319.03,BUSN_",",.01)=$P(^XWB(8994,BUSRN,0),U,1)
 ;D FILE^DIE("","BUSUPD","ERROR")
 Q
