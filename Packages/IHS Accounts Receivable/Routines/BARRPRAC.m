BARRPRAC ; IHS/SD/SDR - Reimbursable Activity Report ; 04/09/2013
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**23**;OCT 26, 2005
 ;;AUG 2013 NOHEAT P.OTTIS ADDED FILTER FOR FED LOC ONLY
 Q
 ; *********************************************************************
 ;
EN ; EP
 K BARY,BAR
 S BARDONE=0
 D:'$D(BARUSR) INIT^BARUTL      ; Set up basic A/R Variables
 S BARP("RTN")="BARRPRAC"       ; Routine used to gather data
 S BAR("PRIVACY")=1             ; Privacy act applies (used BARRHD)
 S BAR("LOC")="VISIT"           ; PSR should always be VISIT
 D DTTYP
 Q:BARDONE=1
 D DATES                        ; Ask transaction date range
 I +BARSTART<1 D XIT Q          ; Dates answered wrong
 D SETHDR                       ; Build header array
 S BARQ("RC")="COMPUTE^BARRPRAC"  ; Build tmp global with data
 S BARQ("RP")="PRINT^BARRPRAC"    ; Print reports from tmp global
 S BARQ("NS")="BAR"             ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"    ; Clean-up routine
 D ^BARDBQUE                    ; Double queuing
 D PAZ^BARRUTL                  ; Press return to continue
 Q
 ; *********************************************************************
DTTYP ;EP
 D ^XBFMK
 S DIR(0)="SO^1:Approval Date;2:Visit Date"
 S DIR("A")="Select TYPE of DATE Desired"
 D ^DIR
 K DIR
 I $D(DUOUT)!$D(DTOUT) S BARDONE=1
 S BARY("DT")=$S(Y=1:"A",1:"V")
 Q
 ;
DATES ;
 ; Ask Date Range
 S BARDTYP=$S(BARY("DT")="A":"Approval Date",1:"Date of Service")
 W !!," ============ Entry of "_BARDTYP_" Range =============",!
 S BARSTART=$$DATE^BARDUTL(1)
 I BARSTART<1 Q
 S BAREND=$$DATE^BARDUTL(2)
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
 S BAR("OPT")="RAC"
 S BAR("LVL")=0
 S BAR("HD",0)="Reimbursable Activity Report"
 D DT^BARRHD
 S BAR("LVL")=$G(BAR("LVL"))+1
 S BAR("HD",BAR("LVL"))=""
 S BAR("TXT")="ALL"
 I $D(BARY("LOC")) S BAR("TXT")=$P(^DIC(4,BARY("LOC"),0),U)
 I BAR("LOC")="BILLING" D
 . S BAR("TXT")=BAR("TXT")_" Visit location(s) under "
 . S BAR("TXT")=BAR("TXT")_$P(^DIC(4,DUZ(2),0),U)
 . S BAR("TXT")=BAR("TXT")_" Billing Location"
 E  S BAR("TXT")=BAR("TXT")_" Visit location(s) regardless of Billing Location"
 S BAR("CONJ")="at "
 D CHK^BARRHD
 Q
 ; *********************************************************************
 ;
COMPUTE ; EP
 S BAR("SUBR")="BAR-RAC"
 K ^TMP($J,"BAR-RAC")
 I BAR("LOC")="BILLING" D LOOP^BARRUTL Q
 S BARDUZ2=DUZ(2)
 S DUZ(2)=0
 ;F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2) D LOOP^BARRUTL ;old code
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  I $$IHS^BARUFUT(DUZ(2)) D LOOP^BARRUTL ;FED LOC ONLY 8/27/13
 S DUZ(2)=BARDUZ2
 Q
 ; *********************************************************************
 ;
DATA ; EP
 S BAR0=$G(^BARBL(DUZ(2),BAR,0))
 S D0=$P(BAR0,U,3)
 S BARITYP=$$VALI^BARVPM(8)  ;GET INTERNAL CODE INSTEAD OF 'STANDS FOR'
 S:(BARITYP'="N") BARACCT=$$GET1^DIQ(90050.02,$P(BAR0,U,3),".01","E")
 S:(BARITYP="N") BARACCT="NON-BENEFICIARY"
 S BARBILLN=$P(BAR0,U)
 S BARAPPDT=$$CDT^BARDUTL($P(BAR0,U,18))
 S BARDUZ2=$P(BAR0,U,22)
 S BARIEN=$P(BAR0,U,17)
 S BARAPPR=$P($G(^ABMDBILL(BARDUZ2,BARIEN,1)),U,4)
 S BARAPPR=$$GET1^DIQ(200,BARAPPR,".01","E")
 S BARBAMT=$J($FN($P(BAR0,U,13),",",2),13)
 S BARCBAMT=$J($FN($P(BAR0,U,15),",",2),13)
 S BARDOS=$$CDT^BARDUTL($P($G(^BARBL(DUZ(2),BAR,1)),U,2))
 S D0=$P(BAR0,U,3)
 S BARITYP=$$VALI^BARVPM(8)  ;GET INTERNAL CODE INSTEAD OF 'STANDS FOR'
 S BARITIEN=$O(^AUTTINTY("C",BARITYP,0))
 S BARITYP=$$GET1^DIQ(9999999.181,BARITIEN,".01","E")
 S BARSIEN=$O(^BARBL(DUZ(2),BAR,9,9999999),-1)
 S:BARSIEN BARSTAT=$P($G(^BARBL(DUZ(2),BAR,9,BARSIEN,0)),U,3)
 S:'BARSIEN BARSTAT="NONE"
 S BARVLOC=$$GET1^DIQ(90050.01,BAR,108,"E")
 S BARREC=BARBILLN_U_BARACCT_U_BARAPPDT_U_BARAPPR_U_BARBAMT_U_BARCBAMT_U_BARDOS_U_BARITYP_U_BARSTAT_U_BARVLOC
 S ^TMP($J,"BAR-RAC",BARBILLN)=BARREC
 Q
 ; *********************************************************************
XIT ;
 D ^BARVKL0
 Q
PRINT ;
 W !,"BILL#^A/R ACCT^APPROVAL DATE^APPROVING OFFICAL^BILL AMOUNT^CURRENT BILL AMOUNT^DATE OF SERVICE^INSURER TYPE^STATUS FIELD^VISIT LOCATION"
 S BARB=""
 F  S BARB=$O(^TMP($J,"BAR-RAC",BARB)) Q:BARB=""  D
 .W !,$G(^TMP($J,"BAR-RAC",BARB))
 Q
