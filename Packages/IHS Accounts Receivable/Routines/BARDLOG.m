BARDLOG ; IHS/SD/LSL - A/R Debt Collection Log Report ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ;
 ; IHS/SD/LSL - 04/08/2004 - V1.8
 ;      Routine created.  Modified from BBMDCLOG
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892
 ; ********************************************************************
 ;
EP ; EP
 K BARY,BAR
 D:'$D(BARUSR) INIT^BARUTL           ; Set up basic A/R Variables
 S BARMENU=$S($D(XQY0):$P(XQY0,U,2),1:$P($G(^XUTL("XQ",$J,"S")),U,3))
 D DATES                            ; Ask date range
 I +BARSTART<1  Q                   ;No dates entered
 S BARQ("RC")="PROCESS^BARDLOG"     ; Build tmp global with data
 S BARQ("RP")="PRINT^BARDLOG"       ; Print reports from tmp global
 I BARMENU["Payment" S BARQ("RP")="PRINTP^BARDLOG"
 S BARQ("NS")="BAR"                 ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"        ; Clean-up routine
 D ^BARDBQUE                        ; Double queuing
 ;D PAZ^BARRUTL                      ; Press return to continue
 Q
 ; ********************************************************************
 ;
DATES ; EP
 W !!,"Enter Transmission Date Range...",!
 S BARSTART=$$DATE^BARDUTL(1)
 I BARSTART<1 Q
 S BAREND=$$DATE^BARDUTL(2)
 I BAREND<1 W ! G DATES
 I BAREND<BARSTART D  G DATES
 .W *7
 .W !!,"The END date must not be before the START date.",!
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PROCESS ; EP
 K ^TMP($J,"BAR-DLOG")
 S X1=BARSTART
 S X2=-1
 D C^%DTC
 S BARDATE=X                 ; Find day before start
 ;
 F  S BARDATE=$O(^BARDEBT("B",BARDATE)) Q:'+BARDATE!(BARDATE>BAREND)  D LOOP
 Q
 ; ********************************************************************
 ;
LOOP ;
 S BARIEN=0
 F  S BARIEN=$O(^BARDEBT("B",BARDATE,BARIEN)) Q:'+BARIEN  D DATA
 Q
 ; ********************************************************************
 ;
DATA ; EP
 Q:'$D(^BARDEBT(BARIEN,0))        ; No data
 S BARAC=$$GET1^DIQ(90050.05,BARIEN,.07)
 S:BARAC="" BARAC="Unknown"
 S BARHOLD=DUZ(2)
 S DUZ(2)=$P($G(^BARDEBT(BARIEN,0)),U,8)
 I '+DUZ(2) S DUZ(2)=BARHOLD
 S BARBL=$$GET1^DIQ(90050.05,BARIEN,.02)
 S BARBLI=$$GET1^DIQ(90050.05,BARIEN,.02,"I")                  ;RLT
 S BARDOS=$$GET1^DIQ(90050.05,BARIEN,".02:DOS BEGIN","I")
 S:BARDOS="" BARDOS="******"
 S BARBAL=$$GET1^DIQ(90050.05,BARIEN,.03)
 S BARACT=$$GET1^DIQ(90050.05,BARIEN,.04)
 ;S:BARACT="STARTS" BARPAID=$$TRANS^BARDUTL(DUZ(2),BARIEN,"P")   ; payments for bill
 S:BARACT="STARTS" BARPAID=$$TRANS^BARDUTL(DUZ(2),BARBLI,"P")   ; RLT
 S DUZ(2)=BARHOLD
 S ^TMP($J,"BAR-DLOG",BARAC,BARDOS,BARIEN)=BARBL_U_BARDATE_U_BARBAL_U_BARACT
 S:BARACT="STARTS" $P(^TMP($J,"BAR-DLOG",BARAC,BARDOS,BARIEN),U,5)=BARPAID
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PRINT ; EP
 ; Print Debt Collection Log Report
 K BARAC,BARDOS,BARIEN,BARBL,BARDATE,BARBAL,BARACT,BARHOLD
 S BARPG=0
 D NOW^%DTC
 S Y=%
 X ^DD("DD")
 S BARUN=$P(Y,":",1,2)
 S $P(BARDASH,"-",81)=""
 D HEAD
 ;
 ; No data
 I '$D(^TMP($J,"BAR-DLOG")) D  Q
 . W !!,$$CJ^XLFSTR("******* NO RECORDS TO PRINT *******",IOM)
 . D PAZ^BARRUTL
 ;
 S (BARTOT,BARCNT,BARSTOP)=0
 S BARAC=""
 F  S BARAC=$O(^TMP($J,"BAR-DLOG",BARAC)) Q:BARAC=""  D ACCT Q:BARSTOP
 Q:BARSTOP
 W !?50,"------------"
 W !?50,$J(BARTOT,10,2)," (",BARCNT,")"
 D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
ACCT ;
 W !?5,"A/R Account: ",BARAC
 S BARPTOT=0,BARPCNT=0
 S BARDOS=""
 F  S BARDOS=$O(^TMP($J,"BAR-DLOG",BARAC,BARDOS)) Q:BARDOS=""  D DOS  Q:BARSTOP
 Q:BARSTOP
 W !?50,"------------"
 W !?50,$J(BARPTOT,10,2)," (",BARPCNT,")"
 Q
 ; ********************************************************************
 ;
DOS ;
 S BARIEN=0
 F  S BARIEN=$O(^TMP($J,"BAR-DLOG",BARAC,BARDOS,BARIEN)) Q:'+BARIEN  D BILL  Q:BARSTOP
 Q
 ; ********************************************************************
 ;
BILL ;
 S BAREC=^TMP($J,"BAR-DLOG",BARAC,BARDOS,BARIEN)
 S BARBL=$P(BAREC,U)
 S BARDATE=$P(BAREC,U,2)
 S BARBAL=$P(BAREC,U,3)
 S BARACT=$P(BAREC,U,4)
 S BARSTOP=$$CHKLINE(BARAC)
 Q:BARSTOP
 W !,$$SDT^BARDUTL(BARDATE),?12,BARBL,?35,$$SDT^BARDUTL(BARDOS)
 W ?50,$J(BARBAL,10,2),?65,BARACT
 S BARPTOT=BARPTOT+BARBAL
 S BARTOT=BARTOT+BARBAL
 S BARCNT=BARCNT+1
 S BARPCNT=BARPCNT+1
 Q
 ; ********************************************************************
 ;
CHKLINE(BARAC) ;EP
 ; Q 0 = CONTINUE
 ; Q 1 = STOP
 N X
 I ($Y+5)<IOSL Q 0
 W !?(IOM-15),"continued==>"
 I $E(IOST)="C" D  I 'Y Q 1
 . S DIR(0)="E" W ! D ^DIR
 D HEAD
 W !?5,"A/R Account: "_BARAC
 Q 0
 ; ********************************************************************
 ;
HEAD ;
 S BARPG=BARPG+1
 W $$EN^BARVDF("IOF")
 W !,$$CJ^XLFSTR("DEBT COLLECTION LOG",IOM)
 W !!,"Run Date: ",BARUN
 W ?IOM-15,"Page: "_BARPG
 W !!,"DATE SENT",?12,"AR BILL",?35,"DOS",?50,"AR BALANCE",?65,"ACTION CODE"
 W !,BARDASH
 Q
 ; ********************************************************************
 ; ********************************************************************
 ;
PRINTP ; EP
 ; Print Debt Collection Payment Report
 K BARAC,BARDOS,BARIEN,BARBL,BARDATE,BARBAL,BARACT,BARHOLD
 S BARHDR="DEBT COLLECTION PAYMENT REPORT"
 S BARPG=0
 D NOW^%DTC
 S Y=%
 X ^DD("DD")
 S BARUN=$P(Y,":",1,2)
 S $P(BARDASH,"-",81)=""
 D HEADP
 ;
 ; No data
 I '$D(^TMP($J,"BAR-DLOG")) D  Q
 . W !!,$$CJ^XLFSTR("******* NO RECORDS TO PRINT *******",IOM)
 . D PAZ^BARRUTL
 ;
 S (BARTOT,BARCNT,BARSTOP)=0
 S BARTOT2=0
 S BARAC=""
 F  S BARAC=$O(^TMP($J,"BAR-DLOG",BARAC)) Q:BARAC=""  D ACCTP Q:BARSTOP
 Q:BARSTOP
 W !?42,"----------",?69,"----------"
 W !?42,$J(BARTOT,10,2)," (",BARCNT,")",?69,$J(BARTOT2,10,2)
 D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
ACCTP ; EP
 W !?5,"A/R Account: ",BARAC
 S BARPTOT=0,BARPCNT=0,BARPTOT2=0
 S BARDOS=""
 F  S BARDOS=$O(^TMP($J,"BAR-DLOG",BARAC,BARDOS)) Q:BARDOS=""  D DOSP  Q:BARSTOP
 Q:BARSTOP
 W !?42,"----------",?69,"----------"
 W !?42,$J(BARPTOT,10,2)," (",BARPCNT,")",?69,$J(BARPTOT2,10,2)
 Q
 ; ********************************************************************
 ;
DOSP ;
 S BARIEN=0
 F  S BARIEN=$O(^TMP($J,"BAR-DLOG",BARAC,BARDOS,BARIEN)) Q:'+BARIEN  D BILLP  Q:BARSTOP
 Q
 ; ********************************************************************
 ;
BILLP ;
 S BAREC=^TMP($J,"BAR-DLOG",BARAC,BARDOS,BARIEN)
 S BARBL=$P(BAREC,U)
 S BARDATE=$P(BAREC,U,2)
 S BARBAL=$P(BAREC,U,3)
 S BARACT=$P(BAREC,U,4)
 S BARPAID=$P(BAREC,U,5)
 S BARSTOP=$$CHKLINEP(BARAC)
 Q:BARSTOP
 W !,$$SDT^BARDUTL(BARDATE)       ; Date transmitted
 W ?13,$E(BARBL,1,15)             ; Bill Name
 W ?30,$$SDT^BARDUTL(BARDOS)      ; Date of Service (Begin)
 W ?42,$J(BARBAL,10,2)            ; Bill balance from Log
 W ?55,BARACT                     ; Action code
 W:BARACT="STARTS" ?69,$J(BARPAID,10,2)           ; All payments for bill
 S BARPTOT=BARPTOT+BARBAL
 S BARTOT=BARTOT+BARBAL
 S:BARACT="STARTS" BARPTOT2=BARPTOT2+BARPAID
 S:BARACT="STARTS" BARTOT2=BARTOT2+BARPAID
 S BARCNT=BARCNT+1
 S BARPCNT=BARPCNT+1
 Q
 ; ********************************************************************
 ;
CHKLINEP(BARAC) ;EP
 ; Q 0 = CONTINUE
 ; Q 1 = STOP
 N X
 I ($Y+5)<IOSL Q 0
 W !?(IOM-15),"continued==>"
 I $E(IOST)="C" D  I 'Y Q 1
 . S DIR(0)="E" W ! D ^DIR
 D HEADP
 W !?5,"A/R Account: "_BARAC
 Q 0
 ; ********************************************************************
 ;
HEADP ;EP
 S BARPG=BARPG+1
 W $$EN^BARVDF("IOF")
 W !,$$CJ^XLFSTR(BARHDR,IOM)
 W !!,"Run Date: ",BARUN
 W ?IOM-15,"Page: "_BARPG
 W !!,"DATE SENT",?13,"AR BILL",?30,"DOS",?42,"AR BALANCE",?55,"ACTION CODE",?72,"PAYMENT"
 W !,BARDASH
 Q
