BARUTLST ; IHS/SD/SDR - BAR/UFMS Transactions not export report   
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19,20,23**;OCT 26,2005
 ; IHS/SD/TMM 1.8*19 3/10/10
 ; IHS/SD/PKD HEAT   11/10/10
 ;MAR 2012 P.OTTIS HEAT# 62025 FIX $ZE= <SUBSCRIPT>GETDATA+14^BARUTLST
 ;JUN 2012 P.OTTIS ADDED FILTER OPTION: SKIP "INGORE"-TYPE OF TRANSACTION
 ;                  SHOW "I" IF INDIAN BENEFICIARY PATIENT
 ;MAY 2013 P.OTTIS CHANGED HDR: INDIAN BENEFICIARY FOR INDIAN PATIENT
DT ;
 ;
 W !!,"This report will look through all the A/R Transactions in the selected date"
 W !,"range and report any that have not been transmitted to UFMS.  Caution should"
 W !,"be used when running this report as it could contain a substantial amount of"
 W !,"data depending on your site."
 W !!," ============ Entry of TRANSACTION DATE Range =============",!
 S DIR("A")="Enter STARTING TRANSACTION DATE for the Report"
 S DIR(0)="DO^::EP"
 S DIR("B")="10/01/2008"
 D ^DIR
 Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S BARY("DT",1)=Y
 W !
 S DIR("A")="Enter ENDING DATE for the Report"
 S DIR("B")="TODAY"
 D ^DIR
 K DIR
 Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S BARY("DT",2)=Y
 I BARY("DT",1)>BARY("DT",2) W !!,*7,"INPUT ERROR: Start Date is Greater than than the End Date, TRY AGAIN!",!! H 1 G DT
 I BARY("DT",1)<3081001 W !!,*7,"INPUT ERROR: Start Date must be on or after 10/01/2008, TRY AGAIN!",!! H 1 G DT
 ;
FILTER ;P.OTT
 K DIR
 S DIR(0)="SO^1:NO FILTERING;2:FILTER I-MARKED TRANSACTIONS"
 S DIR("A")="Enter filtering criteria:"
 S DIR("L",1)="Select one of the following:"
 S DIR("L",2)=""
 S DIR("L",3)="  1		NO FILTERING (SHOW ALL)"
 S DIR("L",4)="  2		Don't show transactions marked as 'IGNORE'"
 S DIR("B")=1
 D ^DIR
 G:$D(DTOUT)!$D(DIROUT)!$D(DUOUT)!(Y="") DT
 S BARFLTR=Y-1
 ;W !,"GOT Y=",Y,"  BARFLTR=",BARFLTR R ASD ;G FILTER
 ;
 ;--------------------------------------------<
SEL ;
 ; Select device
 I $G(BARUFXMT)=1 I 'PF D PRINT  Q  ; IHS/SD/PKD 1.8*20 HEAT 12/3/1
 S DIR(0)="F"
 S DIR("A")="Enter Path"
 S DIR("B")=$P($G(^BAR(90052.06,DUZ(2),DUZ(2),0)),"^",17)
 D ^DIR K DIR
 Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S BARPATH=Y
 S DIR(0)="F",DIR("A")="Enter File Name"
 D ^DIR K DIR
 Q:$D(DIRUT)!$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S BARFN=Y
PRINT ;EP
 ; Callable point for queuing
 S BARE("PG")=0
 D GETDATA
 D WRITE  Q:(IOST["C")&(($G(Y)=0)!($D(DIRUT)!$D(DIROUT)!$D(DTOUT)!$D(DUOUT)))
 I $G(BARUFXMT)=1 Q:'PF  ; IHS/SD/PKD HEAT 1.8*20 12/3/1
 W !!,$$EN^BARVDF("HIN"),"E N D   O F   R E P O R T",$$EN^BARVDF("HIF"),!
 I $E(IOST)="C" S DIR(0)="E" D ^DIR K DIR
 I $E(IOST)="P" W $$EN^BARVDF("IOF")
 I $D(IO("S")) D ^%ZISC
 D CLOSE^%ZISH("BAR")
 W "DONE"
 K BARE
 Q
GETDATA ;
 NEW BARTMP1,BARTMPG1,BARTMPG2,BARTMP3,BARTMPIT
 W !!,"Searching...."
 K BARPSFLG,BARLOC
 K ^TMP($J,"BARUTLST")
 S BARY("DT")=$G(BARY("DT",1))-.5
 S BARY("DT",2)=BARY("DT",2)_".999999"
 F  S BARY("DT")=$O(^BARTR(DUZ(2),"B",BARY("DT"))) Q:'BARY("DT")!(BARY("DT")>BARY("DT",2))  D
 .S BARP("TRANS")=0
 .F  S BARP("TRANS")=$O(^BARTR(DUZ(2),"B",BARY("DT"),BARP("TRANS"))) Q:'BARP("TRANS")  D
 .. ;Q:($G(^BARTR(DUZ(2),BARP("TRANS"),6))'="")  ;already transmitted
 .. ; IHS/SD/PKD 1.8*19 Check if UFMS FileName has been set to null OR TRX never X'mitted
 ..Q:$P($G(^BARTR(DUZ(2),BARP("TRANS"),6)),U)'=""  ;already transmitted
 ..Q:($$GET1^DIQ(90050.03,BARP("TRANS"),3.5,"E")=0)  ;Credit-Debit
 .. ;--->IND PAT
 .. ;SET (BARTMP3,BARTMPIT,BARINDP)=""                                        ;JUST IN CASE WE WILL NOT FIND THEM
 .. ;SET BARTMP3=$P($G(^BARTR(DUZ(2),BARP("TRANS"),0)),U,4)                   ;PTR TO ACCNT FILE
 .. ;IF BARTMP3]"" S BARTMPIT=$$GET1^DIQ(90050.03,BARTMP3_",",6,"I")          ;'A/R ACCOUNT' PTR
 .. ;IF BARTMPIT]"",$$GET1^DIQ(9999999.18,BARTMPIT,.21,"I")="I" S BARINDP=1   ;INSURER TYPE 'INDIAN PATIENT' 
 .. ;
 .. S BARINDP=$$ISINDPAT(BARP("TRANS"))
 .. IF BARFLTR=1 IF $P($G(^BARTR(DUZ(2),BARP("TRANS"),1)),U,12)="I" QUIT        ;IGNORE THIS TX P.OTTIS
 .. ;
 .. ; MAR 2012 HEAT# 62025 FIX P.OTTIS  ----------------------->
 .. S BARTMP01=$G(^BARTR(DUZ(2),BARP("TRANS"),1))
 .. I (($P(BARTMP01,U)'=40)&($P(BARTMP01,U)'=43)&($P(BARTMP01,U)'=993)) Q  ;pymts/adjs/status change only
 .. ;;;OLD CODE I (($P($G(^BARTR(DUZ(2),BARP("TRANS"),1)),U)'=40)&($P($G(^BARTR(DUZ(2),BARP("TRANS"),1)),U)'=43)&($P($G(^BARTR(DUZ(2),BARP("TRANS"),1)),U)'=993)) Q  ;pymts/adjs/status change only
 .. ;;;OLD CODE S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U)=$P($G(^BARBL(DUZ(2),$P($G(^BARTR(DUZ(2),BARP("TRANS"),0)),U,4),0)),U)  ;bill#
 .. S BARTMP02=$G(^BARTR(DUZ(2),BARP("TRANS"),0))
 .. S BARTMP03=$P(BARTMP02,U,4) IF BARTMP03="" QUIT
 .. S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U)=$P($G(^BARBL(DUZ(2),BARTMP03,0)),U)  ;bill#
 .. ;------------------------------------------------------------<
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,2)=$$GET1^DIQ(90050.02,$P($G(^BARTR(DUZ(2),BARP("TRANS"),0)),U,6),".01","E")  ;A/R acct
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,3)=$$GET1^DIQ(90050.02,$P($G(^BARTR(DUZ(2),BARP("TRANS"),0)),U,6),"1.08","E")  ;ins type
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,4)=$$GET1^DIQ(90050.03,BARP("TRANS"),3.6,"I")  ;payment
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,5)=$$GET1^DIQ(90050.03,BARP("TRANS"),3.7,"I")  ;adj
 ..I $$GET1^DIQ(90050.03,BARP("TRANS"),102,"E")="PAYMENT CREDIT" D
 ...S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,5)=$P(^TMP($J,"BARUTLST",BARP("TRANS")),U,4)
 ...S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,4)=""
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,6)=$$GET1^DIQ(90050.03,BARP("TRANS"),3.5,"E")  ;credit-debit
 .. ;
 ..S BARTTYP=$$GET1^DIQ(90050.03,BARP("TRANS"),101,"I")  ;trans type
 ..;status change transactions - treat like adjs
 ..I BARTTYP=993 S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,5)=$$GET1^DIQ(90050.03,BARP("TRANS"),3.5,"E")
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,7)=$S(BARTTYP=40:"PYMT",BARTTYP=43:"ADJ",BARTTYP=993:"SCHNG",1:"") ;trans type
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,8)=$$GET1^DIQ(90051.01,$$GET1^DIQ(90050.03,BARP("TRANS"),14,"I"),".01","E")  ;C.batch
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,9)=$$GET1^DIQ(90050.03,BARP("TRANS"),15,"E")  ;C.item
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,10)=$$GET1^DIQ(90051.01,$$GET1^DIQ(90050.03,BARP("TRANS"),14,"I"),28,"E")  ;TDN
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,11)=$$CDT^BARDUTL($P($G(^BARBL(DUZ(2),$P($G(^BARTR(DUZ(2),BARP("TRANS"),0)),U,4),0)),U,18))  ;3p approval date
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,12)=$P($G(^BARTR(DUZ(2),BARP("TRANS"),6)),U)  ;UFMS export file
 ..S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,13)=$P($G(^BARBL(DUZ(2),$P($G(^BARTR(DUZ(2),BARP("TRANS"),0)),U,4),1)),U,14)
 ..IF BARINDP S $P(^TMP($J,"BARUTLST",BARP("TRANS")),U,14)="I" ;P.OTT
 Q
WRITE ;EP
 ; IHS/SD/PKD 10/15/10 Called from BARUFXMT
 I $G(BARUFXMT)=1 Q:'PF  ; IHS/SD/PKD 1.8*20 HEAT 12/3/10
 W !!,"Creating file..."
 I $G(BARPATH)'="" D
 . D OPEN^%ZISH("BAR",BARPATH,BARFN,"W")
 Q:POP
 U IO
 S BARDUZ2=0
 W !,"Missing Transaction List for "_$P($G(^AUTTLOC(DUZ(2),0)),U,2)
 W !,"TRANS IEN^BILL#^A/R ACCT^INS TYPE^PYMT^ADJ^CR-DEB^TRANS TYPE^CBATCH^CITEM^TDN^3P APPRV DT^UFMS EXP FILE^VISIT TYPE^INDIAN PATIENT"
 S BARP("TRANS")=0
 F  S BARP("TRANS")=$O(^TMP($J,"BARUTLST",BARP("TRANS"))) Q:'BARP("TRANS")  D
 .S BARREC=$G(^TMP($J,"BARUTLST",BARP("TRANS")))
 .W !,BARP("TRANS")_U_BARREC
 Q:$G(BARUFXMT)=1  ; Called from ^BARUFXMT which wants the ^TMP($J data ;IHS/SD/PKD 1.8*20
 K ^TMP($J,"BARUTLST")
 Q
QUE ;QUE TO TASKMAN
 S ZTRTN="PRINT^BARUTLST"
 S ZTDESC="BAR UFMS Transaction Transmit Check"
 S ZTSAVE("BAR*")=""
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZSK) !,"Task # ",ZTSK," queued.",!
 Q
ISINDPAT(BARTRIEN) ;EP - IS BEN OR NO INS TYP
 NEW BARTR0,BARBL,BARAC,BARITYP,BARXX
 S BARTR0=$G(^BARTR(DUZ(2),BARTRIEN,0))
 S BARBL=$P(BARTR0,U,4)
 I BARBL="" Q 0   ;NO BILL FOUND FOR THIS TX
 S BARXX=$G(^BARBL(DUZ(2),BARBL,0))
 S BARAC=$P(BARXX,U,3)  ;A/R Account IEN
 S BARITYP=$$GET1^DIQ(90050.02,BARAC,1.08)  ;Ins Typ
 Q BARITYP="INDIAN PATIENT"
 Q
