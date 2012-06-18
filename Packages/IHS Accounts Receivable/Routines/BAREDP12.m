BAREDP12 ; IHS/SD/SDR - AR ERA Batch/Item matching ; 01/30/2009
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**20**;OCT 26,2005
 Q
EN ;
 S BAR("PG")=0
 S $P(BARDASH,"-",81)=""
 D SETHDR
 D HDB
 S BARI=0
 F  S BARI=$O(^BAREDI("I",DUZ(2),IMPDA,5,BARI)) Q:'BARI  D
 .S BARREC=$G(^BAREDI("I",DUZ(2),IMPDA,5,BARI,0))
 .S BARST=$P(BARREC,U,2)
 .Q:($P(BARREC,U,7)'="")
 .W !?1,$E(BARST,($L(BARST)-3),$L(BARST))  ;ST
 .I $P(BARREC,U,9) W "*" S BARPLB=1  ;PLB on chk
 .W ?12,$E($P(BARREC,U,6),1,25)  ;payer
 .W ?40,$P(BARREC,U)  ;Check#
 .W ?65,$J($FN($P(BARREC,U,3),",",2),12)
 I +$G(BARPLB)>0 W !!?1,"* - Indicates a PLB segment has been located on this check."
 W !!,$$CJ^XLFSTR("* * E N D   O F   R E P O R T * *",IOM)
 D PAZ^BARRUTL
 Q
SETHDR ;
 ;Set up Rpt Hdr
 K BARPCIEN,BARPC,BARIIEN,BARAIEN
 K IMP
 D ENP^XBDIQ1(90056.02,IMPDA,".01;.05","IMP(")
 S BAR("HD",0)="NOT FOUND REPORT"
 S BAR("HD",1)="LOCATION: "_$$GET1^DIQ(4,DUZ(2),.05)
 S BAR("HD",2)="FOR RPMS FILE: "_IMP(.01)
 Q
HDB ;EP
 S BAR("COL")="W !,""ST"",?12,""PAYER"",?40,""CHECK# (TRN02)"",?65,""PAYMENT (BPR02)"""
 S BAR("PG")=BAR("PG")+1
 I BAR("PG")>1 S BAR("LVL")=4
 D WHD^BARRHD
 X BAR("COL")
 W !,BARDASH,!
 Q
