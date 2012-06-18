BARDINQ ; IHS/SD/LSL - A/R Debt Collection Bill Inquire ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/28/2004 - V1.8
 ;      Routine created.
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 Q
 ; ********************************************************************
 ;
EP ; EP
 K BARY,BAR
 D:'$D(BARUSR) INIT^BARUTL           ; Set up basic A/R Variables
 D SELBILL                        ; Select bill by #, pat, dos
 Q:'$D(BARBIEN)                   ; Bill not selected
 S BARPAT=$$GET1^DIQ(90050.01,BARBIEN,101)
 D DATES^BARDLOG                  ; Ask date range
 I +BARSTART<1  Q                   ;No dates entered
 S BARQ("RC")="PROCESS^BARDINQ"     ; Build tmp global with data
 S BARQ("RP")="PRINT^BARDINQ"       ; Print reports from tmp global
 S BARQ("NS")="BAR"                 ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"        ; Clean-up routine
 D ^BARDBQUE                        ; Double queuing
 ;D PAZ^BARRUTL                      ; Press return to continue
 Q
 ; ********************************************************************
 ;
SELBILL ;
 W !!
 K DIC,DR,X,Y,DA
 S DIC=90050.01
 S DIC(0)="AEMQZ"
 K DD,DO
 D ^DIC
 I $D(DUOUT)!($D(DTOUT)) Q
 I +Y<0 D  Q
 . D PAT
 . K BARTMP,BARPAT,BARDOS,BARBL,BARCNT
 S BARBIEN=+Y
 Q
 ; ********************************************************************
 ;
PAT ;
 ; If don't know bill, ask patient
 N BARBL,BARCNT
 K DIC,DA,DR,X,Y
 S DIC="^AUPNPAT("
 S DIC(0)="IAEMQZ"
 S DIC("S")="Select Patient: "
 S DIC("S")="I $D(^BARBL(DUZ(2),""ABC"",Y))"
 D ^DIC
 K DIC
 Q:+Y<0
 S BARPAT=+Y
 ;
 S BARDOS=0,BARCNT=0
 F  S BARDOS=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDOS)) Q:'+BARDOS  D
 . S BARBL=0
 . F  S BARBL=$O(^BARBL(DUZ(2),"ABC",BARPAT,BARDOS,BARBL)) Q:'+BARBL  D
 . . Q:'$D(^BARBL(DUZ(2),BARBL,0))
 . . S BARCNT=BARCNT+1
 . . S BARTMP(BARCNT)=$$GET1^DIQ(90050.01,BARBL,.01)_U_$$SDT^BARDUTL(BARDOS)_U_BARBL
 ;
 W !
 S BARCNT=0
 F  S BARCNT=$O(BARTMP(BARCNT)) Q:'+BARCNT  D
 . W !,$J(BARCNT,2),".",?5,$P(BARTMP(BARCNT),U),?40,$P(BARTMP(BARCNT),U,2)
 ;
 S BARANS=0
 W !
 K DIR
 S DIR(0)="NAO^1:"_BARCNT
 S DIR("A")="Please enter the LINE # of the bill chosen for Inquiry: "
 S DIR("?")="Enter a number between 1 and "_BARCNT
 D ^DIR
 Q:'+Y
 S BARBIEN=$P(BARTMP(+Y),U,3)
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PROCESS ; EP
 K ^TMP($J,"BAR-DLOG")
 Q:'$D(^BARDEBT("C",BARBIEN))      ; Bill not in log.
 S BARIEN=0
 F  S BARIEN=$O(^BARDEBT("C",BARBIEN,BARIEN)) Q:'+BARIEN  D DATA
 Q
 ; ********************************************************************
 ;
DATA ;
 Q:'$D(^BARDEBT(BARIEN,0))        ; No data
 Q:DUZ(2)'=$P($G(^BARDEBT(BARIEN,0)),U,8)      ; Bill not this DUZ(2)
 S BARDATE=$P($G(^BARDEBT(BARIEN,0)),U)        ; date sent
 Q:BARDATE<BARSTART
 Q:BARDATE>BAREND
 D DATA^BARDLOG                   ; Set temp global
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PRINT ; EP
 K BARAC,BARDOS,BARIEN,BARBL,BARDATE,BARBAL,BARACT,BARHOLD
 S BARHDR="DEBT COLLECTION BILL INQUIRY REPORT"
 S BARPG=0
 D NOW^%DTC
 S Y=%
 X ^DD("DD")
 S BARUN=$P(Y,":",1,2)
 S $P(BARDASH,"-",81)=""
 D HEADP^BARDLOG
 ;
 ; No data
 I '$D(^TMP($J,"BAR-DLOG")) D  Q
 . W !!,$$CJ^XLFSTR("******* NO RECORDS TO PRINT *******",IOM)
 . D PAZ^BARRUTL
 ;
 W !?5,"Patient Name: ",$G(BARPAT)
 S (BARTOT,BARCNT,BARSTOP)=0
 S BARTOT2=0
 S BARAC=""
 F  S BARAC=$O(^TMP($J,"BAR-DLOG",BARAC)) Q:BARAC=""  D ACCTP^BARDLOG Q:BARSTOP
 Q:BARSTOP
 W !?42,"----------",?69,"----------"
 W !?42,$J(BARTOT,10,2)," (",BARCNT,")",?69,$J(BARTOT2,10,2)
 D PAZ^BARRUTL
 Q
