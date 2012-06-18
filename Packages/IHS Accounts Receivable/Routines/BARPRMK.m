BARPRMK ; IHS/SD/LSL - Remark Codes Inquiry ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 02/13/04 - V1.7 Patch 5
 ;     Routine created.  Inquiry to A/R EDI REMARK CODES
 ;
 Q
 ; ********************************************************************
 ;
EN ; EP
 D INIT                                ; Initialize environment
 D MSG                                 ; Note entire list user manual
 D LOOKUP                              ; Ask user code to lookup
 Q:'+BARMKIEN                          ; No code to lookup
 S BARQ("RC")="COMPUTE^BARPRMK"    ; Compute routine
 S BARQ("RP")="PRINT^BARPRMK"      ; Print routine
 S BARQ("NS")="BAR"                ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"       ; Clean-up routine
 D ^BARDBQUE                       ; Double queuing
 D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
INIT ;
 I '$D(BARUSR) D INIT^BARUTL
 S BARMKIEN=0
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
 W ?7,"To obtain a complete hardcopy listing of Remittance Advice Remark Codes,"
 I BARV<1.8 W !?7,"please refer to the User Manual Addendum for A/R V1.7 Patch 5."
 E  W !?7,"please refer to the User Manual."
 W !!
 Q
 ; ********************************************************************
 ;
LOOKUP ;
 ; Ask for code user wants to see
 K DIC,DR,DA,X,Y
 S DIC="^BARMKCD("
 S DIC(0)="AEMQZ"
 S DIC("A")="Remittance Advice Remark Code: "
 K DD,DO
 D ^DIC
 Q:Y<1
 S BARMKIEN=+Y
 S BARMK=Y(0)
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
COMPUTE ;
 ; Required for queueing
 Q
 ; ********************************************************************
 ;
PRINT ;
 ; Print data of inquiry
 S BAR("HD",0)="Standard Remittance Advice Remark Code Inquiry"
 S BAR("PG")=BAR("PG")+1
 S BAR("LVL")=1
 D WHD^BARRHD                         ; Report header
 W !!?6,$$EN^BARVDF("ULN"),"CODE:",$$EN^BARVDF("ULF")
 W ?15,$P(BARMK,U)
 W !!,$$EN^BARVDF("ULN"),"SHORT DESC:",$$EN^BARVDF("ULF")
 W ?15,$E($P(BARMK,U,2),1,63)
 I $L($P(BARMK,U,2))>63 W !?15,$E($P(BARMK,U,2),64,80)
 W !!,$$EN^BARVDF("ULN")," LONG DESC:",$$EN^BARVDF("ULF")
 W !
 ;
 F BARLOOP=1:1 Q:$G(^BARMKCD(BARMKIEN,1,BARLOOP,0))=""  D  Q:+BAR("F1")
 . W !?5,^BARMKCD(BARMKIEN,1,BARLOOP,0)
 . I $Y>(IOSL-5) D  Q:$G(BAR("F1"))
 . . D PAZ^BARRUTL
 . . I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
 . . S BAR("PG")=BAR("PG")+1
 . . D WHD^BARRHD                   ; Report header
 Q
