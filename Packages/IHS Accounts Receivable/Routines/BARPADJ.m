BARPADJ ; IHS/SD/LSL - Standard Adjustment Reason Codes Inquiry ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 02/13/04 - V1.7 Patch 5
 ;     Routine created.  Inquiry to A/R EDI STND CLAIM ADJ REASONS
 ;
 Q
 ; ********************************************************************
 ;
EN ; EP
 D INIT                                ; Initialize environment
 D MSG                                 ; Note entire list user manual
 D LOOKUP                              ; Ask user code to lookup
 Q:'+BARAJIEN                          ; No code to lookup
 S BARQ("RC")="COMPUTE^BARPADJ"    ; Compute routine
 S BARQ("RP")="PRINT^BARPADJ"      ; Print routine
 S BARQ("NS")="BAR"                ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"       ; Clean-up routine
 D ^BARDBQUE                       ; Double queuing
 D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
INIT ;
 I '$D(BARUSR) D INIT^BARUTL
 S BARAJIEN=0
 S BAR("PG")=0
 S BAR("F1")=0
 Q
 ; ********************************************************************
 ;
MSG ;
 ; Display message informing user that a complete listing of codes may be
 ; found in the user manual.
 S BARV=$$VERSION^XPDUTL("BAR")
 W !!,$$EN^BARVDF("RVN"),"NOTE:",$$EN^BARVDF("RVF")
 W ?7,"For a complete hardcopy listing of Standard Adjustment Reason Codes,"
 I BARV<1.8 W !?7,"please refer to the User Manual Addendum for A/R V1.7 Patch 4."
 E  W !?7,"please refer to the User Manual."
 W !!
 Q
 ; ********************************************************************
 ;
LOOKUP ;
 ; Ask for code user wants to see
 K DIC,DR,DA,X,Y
 S DIC="^BARADJ("
 S DIC(0)="AEMQZ"
 S DIC("A")="Standard Adjustment Reason Code: "
 K DD,DO
 D ^DIC
 Q:Y<1
 S BARAJIEN=+Y
 S BARADJ=Y(0)
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
COMPUTE ;
 S BARDESC=$$GET1^DIQ(90056.06,BARAJIEN,101)
 D WP^BARDUTL($P(BARADJ,U,2),"BARSD",40)
 D WP^BARDUTL(BARDESC,"BARLD",70)
 ; Required for queueing
 Q
 ; ********************************************************************
 ;
PRINT ;
 ; Print data of inquiry
 S BAR("HD",0)="Standard Adjustment Reason Code Inquiry"
 S BAR("PG")=BAR("PG")+1
 S BAR("LVL")=1
 D WHD^BARRHD                         ; Report header
 ;
 W !!,$$EN^BARVDF("ULN"),"STANDARD",$$EN^BARVDF("ULF")
 W ?30,$$EN^BARVDF("ULN"),"SHORT",$$EN^BARVDF("ULF")
 I $O(BARSD($J,""),-1)>1 D
 . W ?36,BARSD($J,1)
 . K BARSD($J,1)
 W !?4,$$EN^BARVDF("ULN"),"CODE:",$$EN^BARVDF("ULF")
 W ?10,$P(BARADJ,U)
 W ?30,$$EN^BARVDF("ULN"),"DESC:",$$EN^BARVDF("ULF")
 S I=0
 F  S I=$O(BARSD($J,I)) Q:'+I  D
 . W ?36,BARSD($J,I),!
 ;
 W !!?4,$$EN^BARVDF("ULN"),"RPMS",$$EN^BARVDF("ULF")
 W ?10,$P(BARADJ,U,3)
 W ?30,$$EN^BARVDF("ULN"),"RPMS",$$EN^BARVDF("ULF")
 W ?38,$P(BARADJ,U,4)
 W !,$$EN^BARVDF("ULN"),"CATEGORY:",$$EN^BARVDF("ULF")
 W ?10,$$GET1^DIQ(90052.01,$P(BARADJ,U,3),.01)
 W ?30,$$EN^BARVDF("ULN"),"REASON:",$$EN^BARVDF("ULF")
 W ?38,$$GET1^DIQ(90052.02,$P(BARADJ,U,4),.01)
 ;
 W !!!,$$EN^BARVDF("ULN"),"FULL STANDARD CODE DESCRIPTION:",$$EN^BARVDF("ULF"),!
 S I=0
 F  S I=$O(BARLD($J,I)) Q:'+I  D
 . W !?5,BARLD($J,I)
 Q
