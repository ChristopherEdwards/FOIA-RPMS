BARRPRP ; IHS/SD/LSL - Payment Summary Report by Collection Batch ;08/20/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**7**;OCT 26, 2005
 ; MODIFIED XTMP FILE NAME TO TMP TO MEET SAC REQUIREMENTS;MRS:BAR*1.8*7 IM29892 
 ; IHS/SD/LSL - 04/18/03 - V1.8
 ;      Routine created
 Q
 ; *********************************************************************
 ;
EN ; EP
 K BARY,BAR
 D:'$D(BARUSR) INIT^BARUTL         ; Setup basic A/R variables
 S BARP("RTN")="BARRPRP"           ; Routine used to get data
 S BAR("PRIVACY")=1                ; Privacy act applies
 S BAR("LOC")="BILLING"            ; Location is ALWAYS billing
 D ^BARRSEL                        ; Select exclusion parameters
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) Q
 W !!," ============ Entry of COLLECTION BATCH OPEN DATE Range =============",!
 D DATES
 Q:+BARSTART<1                     ; Dates answered wrong
 D ASKSORT^BARRSEL                 ; Ask sort by Clinic/Visit
 D:BARASK SORT^BARRSEL             ; Ask Clinic/Visit
 S BARQ("RC")="COMPUTE^BARRPRP"    ; Compute routine
 S BARQ("RP")="PRINT^BARRPRP2"      ; Print routine
 S BARQ("NS")="BAR"                ; Namespace for variables
 S BARQ("RX")="POUT^BARRUTL"       ; Clean-up routine
 D ^BARDBQUE                       ; Double queuing
 D PAZ^BARRUTL
 Q
 ; *********************************************************************
 ;
DATES ;
 ; Ask Collection Batch Open Date Range
 S BARSTART=$$DATE^BARDUTL(1)
 I BARSTART<1 Q
 S BAREND=$$DATE^BARDUTL(2)
 I BAREND<1 W ! G DATES
 I BAREND<BARSTART D  G DATES
 .W *7
 .W !!,"The END date must not be before the START date.",!
 S X1=BAREND
 S X2=BARSTART
 D ^%DTC
 I X>31 D  G DATES
 . W *7
 . W !!,"The date range must not exceed 31 days.  Please try a different range.",!
 S BARY("DT",1)=BARSTART
 S BARY("DT",2)=BAREND
 Q
 ; ********************************************************************
 ;
COMPUTE ; EP
 ; Find bills matching criteria and store in ^TMP($J,"BAR-PRP")
 K ^TMP($J,"BAR-PRP")
 ; First loop Collection batch open dates
 S BARDT=$O(^BARCOL(DUZ(2),"C",BARSTART),-1)
 F  S BARDT=$O(^BARCOL(DUZ(2),"C",BARDT)) Q:((BARDT>BAREND)!(BARDT=""))  D BATCH
 ;
 ; Find Batched total for header
 K BARBTOT
 S BARBNAME=""
 F  S BARBNAME=$O(BARB(BARBNAME)) Q:BARBNAME=""  D
 . S $P(BARBTOT,U)=$P(BARB(BARBNAME),U)+$P($G(BARBTOT),U)
 . S $P(BARBTOT,U,2)=$P(BARB(BARBNAME),U,2)+$P($G(BARBTOT),U,2)
 . S $P(BARBTOT,U,3)=$P(BARB(BARBNAME),U,3)+$P($G(BARBTOT),U,3)
 Q
 ; ********************************************************************
 ;
BATCH ;
 ; Loop batches opened on BARDT
 S BARBATCH=0
 F  S BARBATCH=$O(^BARCOL(DUZ(2),"C",BARDT,BARBATCH)) Q:'+BARBATCH  D DATA
 Q
 ; ********************************************************************
 ;
DATA ;
 ; Collect data for report
 Q:'$D(^BARCOL(DUZ(2),BARBATCH,0))              ; No data for col batch
 Q:'$D(^BARTR(DUZ(2),"ACB",BARBATCH))         ; Batch not in TRANS file
 S BARCB(0)=$G(^BARCOL(DUZ(2),BARBATCH,0))      ; 0 node for batch
 I $D(BARY("COLPT")),BARY("COLPT")'=$P(BARCB(0),U,2) Q  ; Not col pt
 S BARBNAME=$P(BARCB(0),U)                      ; Collection batch name
 S BARBAMT=$$GET1^DIQ(90051.01,BARBATCH,15)     ; Batch amount
 S BARBPST=$$GET1^DIQ(90051.01,BARBATCH,16)      ; Batch posted amount
 S BARBUPST=$$GET1^DIQ(90051.01,BARBATCH,17)    ; Batch unposted amount
 S BARITM=0
 F  S BARITM=$O(^BARTR(DUZ(2),"ACB",BARBATCH,BARITM)) Q:'+BARITM  D TRANS
 Q
 ; ********************************************************************
 ;
TRANS ;
 ; Loop payment transanctions on the batch
 Q:'$D(^BARTR(DUZ(2),"ACB",BARBATCH,BARITM,40))  ; No payments
 S BARTR=0
 F  S BARTR=$O(^BARTR(DUZ(2),"ACB",BARBATCH,BARITM,40,BARTR)) Q:'+BARTR  D MORE
 Q
 ; ********************************************************************
 ;
MORE ;
 Q:'$D(^BARTR(DUZ(2),BARTR,0))                   ; No transaction data
 S BARTR(0)=$G(^BARTR(DUZ(2),BARTR,0))
 Q:'+$P(BARTR(0),U,4)                           ; No bill on transaction
 S BARBL=$P(BARTR(0),U,4)                       ; A/R Bill IEN
 Q:'$D(^BARBL(DUZ(2),BARBL,0))                  ; No bill data
 S BAR(0)=$G(^BARBL(DUZ(2),BARBL,0))            ; O node A/R Bill file
 S BAR(1)=$G(^BARBL(DUZ(2),BARBL,1))            ; 1 node A/R Bill file
 S BARAC=$P(BAR(0),U,3)                         ; A/R Account IEN
 S:+BARAC BARITYP=$$GET1^DIQ(90050.02,BARAC,1.08)  ; Insurer Type
 I $D(BARY("ITYP")),$G(BARITYP)'=BARY("ITYP","NM") Q  ; Not chsn Ins Type
 I $D(BARY("CLIN")),'$D(BARY("CLIN",$P(BAR(1),U,12))) Q  ;Not chsn clin
 I $D(BARY("VTYP")),'$D(BARY("VTYP",$P(BAR(1),U,14))) Q  ;Not chsn vtyp
 I $D(BARY("LOC")),BARY("LOC")'=$P(BAR(1),U,8) Q      ; Not chsn loc
 S BARVIS=$$GET1^DIQ(90050.01,BARBL,108)        ; Visit Location
 S:BARVIS="" BARVIS="No Visit Location"
 S BARCLIN=$$GET1^DIQ(90050.01,BARBL,112)       ; Clinic
 S:BARCLIN="" BARCLIN="No clinic"
 S BARVTYP=$$GET1^DIQ(90050.01,BARBL,114)       ; Visit Type
 S:BARVTYP="" BARVTYP="No Visit Type"
 S BARBLAMT=$P(BAR(0),U,13)                     ; Bill Amount
 S BARPAY=$$GET1^DIQ(90050.03,BARTR,3.6)        ; Payment
 S BARDOS=$$GET1^DIQ(90050.01,BARBL,102,"I")    ; DOS Begin
 S BARMDOS=$E(BARDOS,1,5)_"00"                  ; DOS Mon/yr
 S BARB(BARBNAME)=BARBAMT_U_BARBPST_U_BARBUPST
 I +BARASK D  Q
 . I BARY("SORT")="C" S BARSORT=BARCLIN
 . I BARY("SORT")="V"  S BARSORT=BARVTYP
 . D CLINVIS
 D DETAIL
 Q
 ; ********************************************************************
 ;
CLINVIS ;
 ; Data sorted by Clinic/Visit
 S BARHOLD=$G(^TMP($J,"BAR-PRP",BARVIS,BARSORT,BARMDOS))
 I $D(^TMP($J,"BAR-PRP",BARVIS,BARSORT,BARMDOS,BARBL)) D  Q
 . S $P(^TMP($J,"BAR-PRP",BARVIS,BARSORT,BARMDOS),U,3)=$P(BARHOLD,U,3)+BARPAY
 S ^TMP($J,"BAR-PRP",BARVIS,BARSORT,BARMDOS,BARBL)=""
 S $P(^TMP($J,"BAR-PRP",BARVIS,BARSORT,BARMDOS),U)=$P(BARHOLD,U,1)+1
 S $P(^TMP($J,"BAR-PRP",BARVIS,BARSORT,BARMDOS),U,2)=$P(BARHOLD,U,2)+BARBLAMT
 S $P(^TMP($J,"BAR-PRP",BARVIS,BARSORT,BARMDOS),U,3)=$P(BARHOLD,U,3)+BARPAY
 Q
 ; ********************************************************************
 ;
DETAIL ;
 ; Detail Report data
 S BARHOLD=$G(^TMP($J,"BAR-PRP",BARVIS,BARMDOS))
 I $D(^TMP($J,"BAR-PRP",BARVIS,BARMDOS,BARBL)) D  Q
 . S $P(^TMP($J,"BAR-PRP",BARVIS,BARMDOS),U,3)=$P(BARHOLD,U,3)+BARPAY
 S ^TMP($J,"BAR-PRP",BARVIS,BARMDOS,BARBL)=""
 S $P(^TMP($J,"BAR-PRP",BARVIS,BARMDOS),U)=$P(BARHOLD,U)+1
 S $P(^TMP($J,"BAR-PRP",BARVIS,BARMDOS),U,2)=$P(BARHOLD,U,2)+BARBLAMT
 S $P(^TMP($J,"BAR-PRP",BARVIS,BARMDOS),U,3)=$P(BARHOLD,U,3)+BARPAY
 Q
