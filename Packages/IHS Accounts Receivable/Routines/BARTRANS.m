BARTRANS ; IHS/SD/SDR - Transaction Summary/Detail Report ; 03/10/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**10,19,20**;OCT 26, 2005
 ;NEW ROUTINE BAR*1.8*10 H2470
 Q
 ; *********************************************************************
 ;
EN ; EP
 K BARY,BAR
 S BAR("OPT")="ADJ"  ; IHS/SD/PKD 1/3/11 1.8*20
 D:'$D(BARUSR) INIT^BARUTL           ; Set up basic A/R Variables
 S BARP("RTN")="BARTRANS"             ; Routine used to gather data
 S BAR("PRIVACY")=1                  ; Privacy act applies (used BARRHD)
 S BAR("LOC")="VISIT"                ; should always be VISIT
 D ASK                      ; Ask questions
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) D XIT Q
 D ADJTYPE^BARRSL3  ; Allow selection of Adjustment type(s) IHS/SD/PKD 1.8*20
 D DATES                             ; Ask transaction date range
 I +BARSTART<1 D XIT Q               ; Dates answered wrong
 ; Ask rpt type (only if sort by allow cat/bill ent-return BARY("RTYP")
 D RTYP                             ; Ask report type
 ; IHS/SD/PKD 1/25/11 1.8*20 Allow detail lines to all display $$
 I BARY("RTYP")=2 D
 . W !!,"Note: Some bills may contain more than one adjustment transaction on the report."
 . S DIR("A")="Do you wish to print the billed and payment amount for each adjustment? "
 . S DIR("B")="NO"
 . S DIR(0)="Y"
 . D ^DIR
 . K DIR
 . S BARDET=Y  ; 0 if no, 1 if yes to print for each line
EN1 D SETHDR                            ; Build header array  ;bar*1.8*20 added EN1 tag
 S BARQ("RC")="COMPUTE^BARTRNS1"      ; Build tmp global with data
 S BARQ("RP")="PRINT^BARTRNS1"       ; Print reports from tmp global
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"         ; Clean-up routine
 D ^BARDBQUE                         ; Double queuing
 D PAZ^BARRUTL                       ; Press return to continue
 Q
 ; *********************************************************************
ASK ; EP
 S BARA("LOC")=0
 S BARA("SORT")=0
 D MSG^BARRSEL                      ; Message about BILL/VIS loc
 D LOC^BARRSL1                      ; Ask loc - return BARY("LOC")
 Q:$D(DTOUT)!($D(DUOUT))            ; Q if time or "^" out
 W:'$D(BARY("LOC")) "ALL"
 F  D SORT Q:BARA("SORT")           ; Ask sort criteria-required
 Q:'+$G(BARY("STCR"))               ; No sort criteria specified - Q
 I BARY("STCR")=1 D  Q
 . W !
 . D ARACCT^BARRSL2                 ; Ask A/R Account-return BARY(
 I BARY("STCR")=2 D  Q
 . W !
 . D ALL^BARRSL1                    ; Ask allow cat-return BARY("ALL")
 . Q:$D(DTOUT)!($D(DUOUT))
 . W:'$D(BARY("ALL")) "ALL"         ; If not select category, then ALL
 I BARY("STCR")=3 D  Q
 . W !
 . D ITYP^BARRSL1                    ; Ask ins type-return BARY("ITYP")
 . Q:$D(DTOUT)!($D(DUOUT))
 . W:'$D(BARY("ITYP")) "ALL"        ; If not select ins type,ALL
 Q
 ; *********************************************************************
 ;
SORT ;
 K DIR,BARY("STCR")
 S DIR(0)="S^1:A/R ACCOUNT"
 S DIR(0)=DIR(0)_";2:ALLOWANCE CATEGORY"
 S DIR(0)=DIR(0)_";3:INSURER TYPE"
 S DIR("A")="Select criteria for sorting"
 S DIR("?")="This is a required response.  Enter ^ to exit"
 D ^DIR
 K DIR
 S:($D(DTOUT)!$D(DUOUT)) BARA("SORT")=1
 Q:Y<1
 S BARA("SORT")=1                   ; The question was answered
 S BARY("STCR")=+Y
 S BARY("STCR","NM")=Y(0)
 Q
 ;
RTYP ;
 ; Ask report type
 S DIR(0)="S^1:Summarize by ALLOW CAT/INS TYPE"
 S DIR(0)=DIR(0)_";2:Detail by PAYER w/in ALLOW CAT/INS TYPE"
 S DIR("A")="Select REPORT TYPE"
 S DIR("B")=1
 S DIR("?",1)="Enter the selection that best describes the summary information desired"
 S DIR("?")="Enter ^ to exit"
 D ^DIR
 K DIR
 Q:Y<1
 S BARY("RTYP")=+Y
 S BARY("RTYP","NM")=Y(0)
 Q
 ;
DATES ;
 ; Ask beginning and ending Transaction Dates.
 W !!," ============ Entry of TRANSACTION DATE Range =============",!
 K %DT  ;bar*1.8*20
 S BARSTART=$$DATE^BARDUTL(1)
 K %DT  ;bar*1.8*20
 I BARSTART<1 Q
 S BAREND=$$DATE^BARDUTL(2)
 K %DT  ;bar*1.8*20
 I BAREND<1 W ! G DATES
 I BAREND<BARSTART D  G DATES
 .W *7
 .W !!,"The END date must not be before the START date.",!
 S BARY("DT",1)=BARSTART
 S BARY("DT",2)=BAREND
 Q
 ; ********************************************************************
 ;
SETHDR ;
 ; Build header array
 S BAR("OPT")="GAO"
 S BARY("DT")="T"
 S BAR("LVL")=0
 S BAR("HD",0)="GAO Transaction Report"
 I ",1,2,3,"[(","_BARY("STCR")_",") S BAR("HD",0)=BAR("HD",0)_" by "_BARY("STCR","NM")
 I BARY("STCR")=2 D ALLOW^BARRHD,CHK^BARRHD
 I BARY("STCR")=3 D ITYP^BARRHD,CHK^BARRHD
 I $G(BARY("RTYP"))=1 D
 .S BAR("LVL")=$G(BAR("LVL"))+1
 .S BAR("HD",BAR("LVL"))=""
 .S BAR("TXT")="Summary"
 .S BAR("CONJ")=""
 .D CHK^BARRHD
 I $G(BARY("RTYP"))=2 D
 .S BAR("LVL")=$G(BAR("LVL"))+1
 .S BAR("HD",BAR("LVL"))=""
 .S BAR("TXT")="Detail"
 .S BAR("CONJ")=""
 .D CHK^BARRHD
 D DT^BARRHD
 S BAR("LVL")=$G(BAR("LVL"))+1
 S BAR("HD",BAR("LVL"))=""
 S BAR("TXT")="ALL"
 I $D(BARY("LOC")) S BAR("TXT")=$P(^DIC(4,BARY("LOC"),0),U)
 I BAR("LOC")="BILLING" D
 .S BAR("TXT")=BAR("TXT")_" Visit location(s) under "
 .S BAR("TXT")=BAR("TXT")_$P(^DIC(4,DUZ(2),0),U)
 .S BAR("TXT")=BAR("TXT")_" Billing Location"
 E  S BAR("TXT")=BAR("TXT")_" Visit location(s) regardless of Billing Location"
 S BAR("CONJ")="at "
 D CHK^BARRHD
 Q
XIT ;
 D ^BARVKL0
 Q
