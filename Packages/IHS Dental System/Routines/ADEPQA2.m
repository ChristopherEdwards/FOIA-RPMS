ADEPQA2 ; IHS/HQT/MJL - REPORT OPTIONS ;07:28 PM  [ 03/24/1999   9:04 AM ]
 ;;6.0;ADE;**15**;APRIL 1999
 ;
ROPT() ;EP - Returns Report options selection or ^ if timeout or hatout
 ;First ^ piece is option number, 2d piece is whether output
 ;template to be attached to PATIENT or DENTAL files
 ;3rd piece is fields to subtotal by
 N DIR,ADEROPT,Y,X
ROP1 K DIR,ADEROPT,Y,X
 W !,"You have the following options for displaying this report."
 S DIR(0)="S^1:Count Patients;2:Print Dental Record Review for Each Patient"
 S DIR(0)=DIR(0)_";3:Count ADA Codes;4:Count Visits;5:Print Visit List"
 S DIR("A")="Select Report Option"
 D ^DIR
 I $$HAT() Q 0
 S ADEROPT=Y
 I ADEROPT=1!(ADEROPT=2) S $P(ADEROPT,U,2)="PATIENT"
 E  S $P(ADEROPT,U,2)="DENTAL"
ROP2 ;Prompt for Subtotal fields
 K DIR
 I "34"[+ADEROPT D  G:$$HAT() ROP1
 . W !!,"You have the following options for SUBTOTALING your report."
 . F  D  Q:$$HAT()  Q:X=""
 . . S DIR(0)="SO^1:Location of visit;2:Attending Dentist;3:Hygienist/Therapist"
 . . I +ADEROPT=3 S DIR(0)=DIR(0)_";4:Operative Site;5:ADA Procedure Code"
 . . S DIR("A")="Select"_$S($P(ADEROPT,U,3)]"":" Another ",1:" ")_"SUBTOTAL"
 . . I $P(ADEROPT,U,3)]"" S $P(DIR(0),U)="SOB"
 . . D ^DIR
 . . I $$HAT() Q
 . . I X="" Q
 . . I $P(ADEROPT,U,3)="" S $P(ADEROPT,U,3)=Y
 . . S:$P(ADEROPT,U,3)'[Y $P(ADEROPT,U,3)=$P(ADEROPT,U,3)_","_Y
 Q ADEROPT
 ;
HAT() I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) Q 1
 Q 0
 ;
 ; Now that we know report option, we know which file to attach template
BY ;EP
 S BY="["_ADETNAM_"]"
 S DIOBEG="D CHK2^ADEPQA4"
 I +ADEROPT=1 D
 . ;S BY=BY_",@+.01"
 . S FLDS="!.01;""PATIENT COUNT"""
 . S (FR,TO)=""
 . S DIC="^AUPNPAT("
 I +ADEROPT=2 D
 . S FLDS="S ADEPAT=D0 D EN3^ADERVW"
 . S (FR,TO)=""
 . S DIC="^AUPNPAT("
 . S DHD="@"
 I +ADEROPT=3 D
 . ; IHS MODIFICATION - RVU's (patch 15)
Z . ;S FLDS="ADA CODE,!.01;""PROCEDURES"",&ADA CODE:ESTIMATED MINUTES;""MINUTES"""
 . S FLDS="ADA CODE,!.01;""PROCEDURES"",&ADA CODE:ESTIMATED MINUTES;""MINUTES"",&ADA CODE:RVU (Relative Value Unit);""RVU'S"""
 . ; End IHS MODIFICATION -RVU's (patch 15)
 . I $P(ADEROPT,U,3)]"" D SUBTOT
 . S BY=BY_",ADA CODE,@CODCAL"
 . S (FR,TO)=""
 . S DIC="^ADEPCD("
 I +ADEROPT=4 D
 . S FLDS="!.01;""VISIT COUNT"""
 . I $P(ADEROPT,U,3)]"" D SUBTOT
 . S (FR,TO)=""
 . S DIC="^ADEPCD("
 I +ADEROPT=5 D
 . S FLDS="[ADEPQ-VISLIST]"
 . S (FR,TO)=""
 . S DIC="^ADEPCD("
 Q
 ;
CODCAL ;EP
 ;CALLED BY BY SETS ADEY=1 IF D0, D1 IN ADEUTL
 S ADEY=0
 I '$D(ADEADA(1)) S ADEY=1 Q
 I $P(ADEADA(1),U,2)="" S ADEY=1 Q
 I $D(^ADEUTL("ADEPQA",$J,D0,D1)) S ADEY=1 Q
 Q
 ;
SUBTOT N ADESORT,ADESORTP,ADEJ
 S ADESORT=$P(ADEROPT,U,3)
 F ADEJ=1:1:$L(ADESORT,",") S ADESORTP=$P(ADESORT,",",ADEJ) D
 . S BY=BY_$S(ADESORTP=1:",+LOCATION",ADESORTP=2:",+REPORTING DENTIST;""ATTENDING DENTIST:  """,ADESORTP=3:",+AUXILIARY;""HYGIENIST/THERAPIST:  """,1:"") ;Get visit level fields
 F ADEJ=1:1:$L(ADESORT,",") S ADESORTP=$P(ADESORT,",",ADEJ) D
 . S BY=BY_$S(ADESORTP=4:",ADA CODE,+OPERATIVE SITE:MNEMONIC;""OPERATIVE SITE:  """,ADESORTP=5:",ADA CODE,+ADA CODE",1:"") ;Get code level fields
 Q
 K ADESORT,ADESORTP ;*NE
