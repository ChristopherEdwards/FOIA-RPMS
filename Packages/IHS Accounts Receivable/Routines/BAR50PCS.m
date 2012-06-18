BAR50PCS ; IHS/SD/SDR - ERA Check Summary Report ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**20,21**;OCT 26,2005
 ; new routine
 ; *******************************************************************
EN ;
 D SELFL^BAR50P00  ;prompt for Import name/Check/EFT trace
EN1 ;
 F  D  Q:$D(DIRUT)  Q:$D(BARMEDIA)                   ; Ask Browse or print
 .D ASK^BAR50P10  ;prompt for print/browse
 I ('$D(IMPDA)!('$D(BARMEDIA))) D  Q
 .D PAZ^BARRUTL
 .D XIT
 S $P(BARDASH,"-",81)=""
 S $P(BARSTAR,"*",81)=""
 D SETHDR                   ; Set up report header
 I BARMEDIA="B" D BROWSE
 I BARMEDIA="P" D PRINT
 D XIT
 Q
SETHDR ;
 ; Set up Report Header lines
 K BARPCIEN,BARPC,BARIIEN,BARAIEN
 K IMP
 D ENP^XBDIQ1(90056.02,IMPDA,".01;.05","IMP(")
 S BAR("HD",0)="ERA CHECK NUMBER AND CHECK AMOUNTS REPORT"
 S BAR("HD",1)="LOCATION: "_$$GET1^DIQ(4,DUZ(2),.01)
 S BAR("HD",2)="FOR FILE NAME: "_IMP(.05)
 S BARTMP=BAR("HD",2)  ;IHS/SD/TPF 7/27/2011 H42678
 D PAD
 S BAR("HD",3)="FOR RPMS FILE: "_IMP(.01)
 S BAR("HD",4)=BARDASH
 Q
PAD ;
 N L,I
 S L=$L(BARTMP)
 F I=L:1:50 S BARTMP=BARTMP_" "
 Q
BROWSE ;
 ; Browse report to screen
 ; GET DEVICE (QUEUEING ALLOWED)
 S XBFLD("BROWSE")=1
 S BARIOSL=IOSL
 S IOSL=600
 D VIEWR^XBLM("PRINTD^BAR50PCS")
 D FULL^VALM1
 W $$EN^BARVDF("IOF")
 D CLEAR^VALM1  ;clears out all list man stuff
 K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF
 K VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMLFT,VALMLST,VALMMENU,VALMSGR,VALMUP
 K VALMY,XQORS,XQORSPEW,VALMCOFF
 S IOSL=BARIOSL
 Q
 ; ********************************************************************
 ;
PRINT ;
 ; Print report to device.  Queuing allowed.
 S BARQ("RC")="COMPUTE^BAR50PCS"      ; Build tmp global with data
 S BARQ("RP")="PRINTD^BAR50PCS"       ; Print reports from tmp global
 S BARQ("NS")="BAR"                  ; Namespace for variables
 S ZTSAVE("IMPDA")=""
 S BARQ("RX")="POUT^BARRUTL"         ; Clean-up routine
 D ^BARDBQUE                         ; Double queuing
 Q
COMPUTE ;EP
 ; Compute line tag required by BARDBQUE but all processing
 ; is done under PRINT so just quit here
 Q
 ; ********************************************************************
 ;
PRINTD ; EP
 ; PRINT the report (Browse or Print)
 S BAR("PG")=0
 D DETAIL
 W !!!,"**This 835 ERA File contains "_BARTCHKS_" BPR segments totaling $"_$FN(BARTAMT,",",2)
 W !,"**Use the Check Posting Summary (CPS) to confirm checks have been batched",!
 I $G(BAR("F1"))="" D
 . W !,$$CJ^XLFSTR("* * E N D   O F   R E P O R T * *",IOM)
 . D PAZ^BARRUTL
 Q
 ; ********************************************************************
 ;
HD ; EP
 D PAZ^BARRUTL
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S BAR("F1")=1 Q
 ; -------------------------------
 ;
HDB ; EP
 S BAR("COL")="W !,""SET"",?11,""PAYER"",?26,""CD"",?30,""PAYMENT"",?45,""CHECK"",?71,""CHK DATE"""
 S BAR("PG")=BAR("PG")+1
 I BAR("PG")>1 S BAR("LVL")=4
 D WHD^BARRHD
 X BAR("COL")
 W !,BARDASH
 Q
 ; ********************************************************************
 ;
DETAIL ;
 ; Print report in brief and detail format
 D HDB
 I $Y>(IOSL-5) D HD Q:$G(BAR("F1"))
 S BARCK=""
 K BARTAMT,BARAMT,BARTCHKS
 S BARCK=0,BARTCHKS=0,BARTAMT=0
 F  S BARCK=$O(^BAREDI("I",DUZ(2),IMPDA,5,BARCK)) Q:'BARCK  D  Q:$G(BAR("F1"))
 .Q:$G(BAR("F1"))
 .S BARCHK=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCK,0)),U)  ;check
 .S BARST=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCK,0)),U,2)  ;trans set control#
 .S BARAMT=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCK,0)),U,3)  ;check amount
 .S BARTCD=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCK,0)),U,4)  ;trans handling code
 .S BARDT=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCK,0)),U,5)  ;check issue date
 .S BARPYR=$P($G(^BAREDI("I",DUZ(2),IMPDA,5,BARCK,0)),U,6)  ;payer
 .W !,$E(BARST,($L(BARST)-3),$L(BARST)),?6,$E(BARPYR,1,18),?26,BARTCD,?28,$J($FN(BARAMT,",",2),12),?41,BARCHK,?71,$$SHDT^BARDUTL(BARDT)
 .S BARTCHKS=+$G(BARTCHKS)+1  ;count # of ERA checks
 .S BARTAMT=+$G(BARTAMT)+BARAMT  ;count total ERA amount
 Q
XIT ;
 D ^BARVKL0
 Q
