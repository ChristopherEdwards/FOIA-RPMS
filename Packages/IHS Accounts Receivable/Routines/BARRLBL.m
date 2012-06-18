BARRLBL ; IHS/SD/LSL - Large and Small Balance Reports ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; IHS/SD/LSL - 04/04/2003 - Version 1.8
 ;       Routine created.  New reports
 ;
 ; ********************************************************************
 Q
 ;
EN ; EP
 K BARY,BAR
 S BARP("RTN")="BARRLBL"
 S BAR("PRIVACY")=1                ; Privacy act applies
 D:'$D(BARUSR) INIT^BARUTL         ; Set A/R basic variable
 S BAR("LOC")="VISIT"              ; Always visit location
 D ^BARRSEL                        ; Select exclusion parameters
 I $D(BARY("ALL")) S BARY("ALL")=$$CONVERT^BARRSL2(BARY("ALL"))
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 ; Use OBAL x-ref if not specific patient or account
 I '$D(BARY("ACCT")),'$D(BARY("PAT")) S BARY("STCR")=1
 S BAR("HD",0)=BARMENU
 I BAR("OPT")="LBL" S BAR("HD",0)=BAR("HD",0)_" over $"_$FN(BARY("LBL"),",",2)
 I BAR("OPT")="SBL" S BAR("HD",0)=BAR("HD",0)_" under $"_$FN(BARY("SBL"),",",2)
 D ^BARRHD                         ; Report header
 S BARQ("RC")="COMPUTE^BARRLBL"    ; Compute routine
 S BARQ("RP")="PRINT^BARRLBL"      ; Print routine
 S BARQ("NS")="BAR"                ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"       ; Clean-up routine
 D ^BARDBQUE                       ; Double queuing
 D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
COMPUTE ;
 ;
 S BAR("SUBR")="BAR-LBL"
 K ^TMP($J,"BAR-LBL")
 S BARP("RTN")="BARRLBL"     ; Routine used to get data if no parameters
 S BARDUZ2=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(^BARBL(DUZ(2))) Q:'DUZ(2)  D LOOP^BARRUTL
 S DUZ(2)=BARDUZ2
 Q
 ; *********************************************************************
 ;
DATA ;
 S BARBAL=$$GET1^DIQ(90050.01,BAR,15)
 I BAR("OPT")="SBL",BARBAL<0 Q
 I BAR("OPT")="SBL",BARBAL>BARY("SBL") Q
 I BAR("OPT")="LBL",BARBAL<BARY("LBL") Q
 S BARP("HIT")=0
 D BILL^BARRCHK
 Q:'BARP("HIT")
 S BARLOC=""
 S:BAR("L")]"" BARLOC=$$GET1^DIQ(4,BAR("L"),.01)
 S:BARLOC="" BARLOC="No Visit Location"       ; Visit Location Name
 S BARACCT=""
 S:BAR("I")]"" BARACCT=$$GET1^DIQ(90050.02,BAR("I"),.01)
 S:BARACCT="" BARACCT="No A/R Account"        ; A/R Account Name
 S:'+BAR("A") BAR("A")=9999999
 I $G(BARY("SORT"))="C" D
 . S BAR2=BAR("C")
 . I BAR2]"",BAR2'=99999 S BAR2=$$GET1^DIQ(40.7,BAR2,.01)
 . S:BAR2=""!(BAR2=99999) BAR2="No Clinic Type"
 I $G(BARY("SORT"))="V" D
 . S BAR2=BAR("V")
 . I BAR2]"",BAR2'=99999 S BAR2=$$GET1^DIQ(9002274.8,BAR2,.01)
 . S:BAR2=""!(BAR2=99999) BAR2="No Visit Type"
 S BARBILL=$P(BAR(0),U,13)
 S BARBL=$P(BAR(0),U)
 S BARAGE=$$GET1^DIQ(90050.01,BAR,7.2)
 S BARDTB=$$FMDIFF^XLFDT(DT,BAR("D"))
 ;
 I $D(BARY("SORT")) D CLINVIS
 E  D ACCT
 ;
 S BARHOLD=$G(^TMP($J,"BAR-LBL",BARLOC))
 S $P(^TMP($J,"BAR-LBL",BARLOC),U)=$P(BARHOLD,U)+BARDTB
 S $P(^TMP($J,"BAR-LBL",BARLOC),U,2)=$P(BARHOLD,U,2)+BARBILL
 S $P(^TMP($J,"BAR-LBL",BARLOC),U,3)=$P(BARHOLD,U,3)+BARBAL
 S $P(^TMP($J,"BAR-LBL",BARLOC),U,4)=$P(BARHOLD,U,4)+BARAGE
 S $P(^TMP($J,"BAR-LBL",BARLOC),U,5)=$P(BARHOLD,U,5)+1
 ;
 S BARHOLD=$G(^TMP($J,"BAR-LBL"))
 S $P(^TMP($J,"BAR-LBL"),U)=$P(BARHOLD,U)+BARDTB
 S $P(^TMP($J,"BAR-LBL"),U,2)=$P(BARHOLD,U,2)+BARBILL
 S $P(^TMP($J,"BAR-LBL"),U,3)=$P(BARHOLD,U,3)+BARBAL
 S $P(^TMP($J,"BAR-LBL"),U,4)=$P(BARHOLD,U,4)+BARAGE
 S $P(^TMP($J,"BAR-LBL"),U,5)=$P(BARHOLD,U,5)+1
 Q
 ; ********************************************************************
 ;
ACCT ;
 ; Store data by AR Account
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT,BAR("A"),BARBL),U)=BAR("D")
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT,BAR("A"),BARBL),U,2)=BARDTB
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT,BAR("A"),BARBL),U,3)=BARBILL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT,BAR("A"),BARBL),U,4)=BARBAL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT,BAR("A"),BARBL),U,5)=BARAGE
 ;
 S BARHOLD=$G(^TMP($J,"BAR-LBL",BARLOC,BARACCT))
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT),U)=$P(BARHOLD,U)+BARDTB
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT),U,2)=$P(BARHOLD,U,2)+BARBILL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT),U,3)=$P(BARHOLD,U,3)+BARBAL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT),U,4)=$P(BARHOLD,U,4)+BARAGE
 S $P(^TMP($J,"BAR-LBL",BARLOC,BARACCT),U,5)=$P(BARHOLD,U,5)+1
 Q
 ; ********************************************************************
 ;
CLINVIS ;
 ; Store data by Clinic/Visit Type
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT,BAR("A"),BARBL),U)=BAR("D")
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT,BAR("A"),BARBL),U,2)=BARDTB
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT,BAR("A"),BARBL),U,3)=BARBILL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT,BAR("A"),BARBL),U,4)=BARBAL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT,BAR("A"),BARBL),U,5)=BARAGE
 ;
 S BARHOLD=$G(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT))
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT),U)=$P(BARHOLD,U)+BARDTB
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT),U,2)=$P(BARHOLD,U,2)+BARBILL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT),U,3)=$P(BARHOLD,U,3)+BARBAL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT),U,4)=$P(BARHOLD,U,4)+BARAGE
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2,BARACCT),U,5)=$P(BARHOLD,U,5)+1
 ;
 S BARHOLD=$G(^TMP($J,"BAR-LBL",BARLOC,BAR2))
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2),U)=$P(BARHOLD,U)+BARDTB
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2),U,2)=$P(BARHOLD,U,2)+BARBILL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2),U,3)=$P(BARHOLD,U,3)+BARBAL
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2),U,4)=$P(BARHOLD,U,4)+BARAGE
 S $P(^TMP($J,"BAR-LBL",BARLOC,BAR2),U,5)=$P(BARHOLD,U,5)+1
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PRINT ;
 ; Print reports
 K BAR2,BARHOLD,BARBILL,BAR3P,BARACCT,BARLOC,BARDTB,BAR("D"),BAR("A")
 K BARBAL,BARAGE
 I BAR("OPT")="LBL" D LARGE^BARRLBL2 Q
 I BAR("OPT")="SBL" D SMALL^BARRLBL3 Q
 Q
