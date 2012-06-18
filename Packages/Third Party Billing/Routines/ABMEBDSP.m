ABMEBDSP ; IHS/ASDST/DMJ - ELECTRONIC CLAIMS DISPLAY ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**3,6,8**;NOV 12, 2009
 ;Original;DMJ;
 ; IHS/ASDS/DMJ - V2.4 P7 - 9/7/01 - NOIS NDA-0301-180017 - Modified to resolve <UNDEF>PCN+1^ABMERUTL for all electronic
 ;     modes of export.
 ; IHS/SD/SDR 10/10/02 - V2.5 P2 - XAA-0501-200006 - Modified to display # of bills on the bill total line
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - clearinghouse changes
DOC ;
 ; The purpose of this routine is to show the user summary
 ; information of a specified electronically transmitted batch
 ; of bills. The data is grouped by bill type within site with
 ; subtotals shown. A grand total (amt billed) is also shown.
 ; The data fields are: bill number, health record number,
 ; patient name, service date from, and amount billed.
 ;
 ;  INPUT:   none
 ;
 ; OUTPUT:   none
 ;
START ;START HERE
 ; Find the requested transmission batch in the transmission
 ; file. Screen out those entries that don't have an EMC 
 ; file name.
 ;
BEG ;
 ; Find beginning export batch
 W !
 S DIC="^ABMDTXST(DUZ(2),"
 S DIC("S")="I $L($P($G(^(1)),""^"",4))"
 S DIC(0)="AEMQ"
 S DIC("A")="Select beginning export batch: "
 D ^DIC
 Q:Y<0
 S ABME("XMITB")=+Y
 ;
END ;
 ; Find ending export batch
 W !
 S DIC("A")="Select ending export batch: "
 D ^DIC
 K DIC
 Q:Y<0
 S ABME("XMITE")=+Y
 I ABME("XMITE")<ABME("XMITB") W !!,"INVALID RANGE!" G BEG
 ;
 ;start new code abm*2.6*6 5010
LIST ; EP
 W !!,"Checking...",!
 K ABMP("XLIST")
 K ABMP("CHKLIST")
 S ABMP("XCNT")=0
 S ABMP("XMIT")=ABME("XMITB")-1
 F  S ABMP("XMIT")=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"))) Q:'+ABMP("XMIT")!(ABMP("XMIT")>ABME("XMITE"))  D
 .Q:$P($G(^ABMDEXP($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,2),0)),U)'["837"
 .S ABMP("SIEN")=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,9999999),-1)  ;look at last entry only
 .I ABMP("SIEN")'="" S ABMP("GCN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,2)
 .;I $G(ABMP("GCN"))="" S ABMP("GCN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),1)),U,6)  ;abm*2.6*8 HEAT42133
 .I $G(ABMP("GCN"))="" S ABMP("GCN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),1)),U,6),ABMP("SIEN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U)  ;abm*2.6*8 HEAT42133
 .S ABMP("CHKLIST",ABMP("XMIT"))=1
 .S ABMP("XCNT")=+$G(ABMP("XCNT"))+1
 .S ABMP("XLIST",ABMP("XCNT"),ABMP("XMIT"),ABMP("SIEN"),ABMP("GCN"))=""
 .S ABMP("GLIST",ABMP("GCN"))=""
 S ABMP("XCNTL")=0
 F  S ABMP("XCNTL")=$O(ABMP("GLIST",ABMP("XCNTL"))) Q:'ABMP("XCNTL")  D
 .S ABMP("GCN")=0
 .F  S ABMP("GCN")=$O(ABMP("GLIST",ABMP("GCN"))) Q:'ABMP("GCN")  D
 ..S ABMP("XGMIT")=0
 ..F  S ABMP("XGMIT")=$O(^ABMDTXST(DUZ(2),"EGCN",ABMP("GCN"),ABMP("XGMIT"))) Q:'ABMP("XGMIT")  D
 ...S ABMP("SIEN")=$O(^ABMDTXST(DUZ(2),"EGCN",ABMP("GCN"),ABMP("XGMIT"),99999),-1)
 ...I +$G(ABMP("CHKLIST",ABMP("XGMIT")))'=0 Q  ;already have transmission on list
 ...S ABMP("CHKLIST",ABMP("XGMIT"))=1
 ...S ABMP("XCNT")=+$G(ABMP("XCNT"))+1
 ...S ABMP("XLIST",ABMP("XCNT"),ABMP("XGMIT"),ABMP("SIEN"),ABMP("GCN"))=""
 ;
 I ABMP("XCNT")=1 S ABMP("ANS")=2,ABMSEL=1  ;default to one entry if only one found
 I +$G(ABMP("XCNT"))>1 D
 .W !,"There are multiple batches associated with your selection."
 .W !!,"Select from the following:",!
 .D BATCHLST
 S ABMQUIT=0
 I +$G(ABMP("XCNT"))>1 D
 .K DIR,DIE,DIC,X,Y,DA
 .S DIR(0)="SO^1:All associated batches;2:A single batch entry;3:Reselect export dates;4:Quit"
 .S DIR("A")="Select"
 .D ^DIR K DIR
 .S ABMP("ANS")=+Y
 .I ABMP("ANS")=1  ;print all entries
 .I ABMP("ANS")=2 D  ;select one entry
 ..D BATCHLST
 ..K DIR,DIE,DIC,X,Y,DA
 ..S DIR(0)="NO^1:"_(ABMP("XCNT")-1)
 ..S DIR("A")="Select"
 ..D ^DIR K DIR
 ..I +Y=0 S ABMQUIT=1
 ..S ABMSEL=Y
 .I ABMP("ANS")=3 G START  ;start over
 .I ABMP("ANS")=4 S ABMQUIT=1 Q  ;quit w/out printing anything
 Q:ABMQUIT
 I ABMP("ANS")=2 D
 .S ABMECHK=0
 .F  S ABMECHK=$O(ABMP("XLIST",ABMECHK)) Q:'ABMECHK  D
 ..I ABMECHK'=ABMSEL K ABMP("XLIST",ABMECHK)
 ;end new code 5010
SEL ;
 ; Select device
 S %ZIS="NQ"
 S %ZIS("A")="Enter DEVICE: "
 D ^%ZIS Q:POP
 I IO'=IO(0) D QUE,HOME^%ZIS S DIR(0)="E" D ^DIR K DIR Q
 I $D(IO("S")) S IOP=ION D ^%ZIS
 ;
PRINT ;
 ; Callable point for queuing
 S ABME("PG")=0
 ;start old code abm*2.6*6 5010
 ;S ABMP("XMIT")=ABME("XMITB")-1
 ;F  S ABMP("XMIT")=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"))) Q:'+ABMP("XMIT")!(ABMP("XMIT")>ABME("XMITE"))  D SET
 ;Q:Y=0
 ;end old code start new code 5010
 S ABME("CUMTOT")=0
 S ABME("CUMCNT")=0
 ;
 S ABME("XCNT")=0
 F  S ABME("XCNT")=$O(ABMP("XLIST",ABME("XCNT"))) Q:'ABME("XCNT")  D
 .S ABMP("XMIT")=0
 .F  S ABMP("XMIT")=$O(ABMP("XLIST",ABME("XCNT"),ABMP("XMIT"))) Q:'ABMP("XMIT")  D
 ..S ABMP("SIEN")=0
 ..F  S ABMP("SIEN")=$O(ABMP("XLIST",ABME("XCNT"),ABMP("XMIT"),ABMP("SIEN"))) Q:'ABMP("SIEN")  D
 ...S ABMP("GCN")=0
 ...F  S ABMP("GCN")=$O(ABMP("XLIST",ABME("XCNT"),ABMP("XMIT"),ABMP("SIEN"),ABMP("GCN"))) Q:'ABMP("GCN")  D
 ....D SET
 ....Q:Y=0
 ;end new code 5010
 W !!,$$EN^ABMVDF("HIN"),"E N D   O F   R E P O R T",$$EN^ABMVDF("HIF"),!
 I $E(IOST)="C" S DIR(0)="E" D ^DIR K DIR
 I $E(IOST)="P" W $$EN^ABMVDF("IOF")
 I $D(IO("S")) D ^%ZISC
 K ABME
 Q
 ;
SET ;SET UP SOME THINGS
 ;
 ; ABME("BDATE")     = Batch export date
 ; ABMP("EXP")       = Export mode
 ; ABME("FORMAT")    = Format
 ; ABMP("INS")       = Insurer IEN
 ; ABME("INS")       = Insurer name
 ; ABME("EMC")       = EMC file name
 ;
 S Y=$P(^ABMDTXST(DUZ(2),ABMP("XMIT"),0),U)
 S ABMP("SAV")=0  ;abm*2.6*6
 D DD^%DT
 S ABME("BDATE")=Y
 S ABMP("EXP")=$P(^ABMDTXST(DUZ(2),ABMP("XMIT"),0),"^",2)
 Q:$P($G(^ABMDEXP(ABMP("EXP"),1)),U,5)'["E"  ; Quit if not electronic
 S ABME("FORMAT")=$P(^ABMDEXP(ABMP("EXP"),0),U,7)
 S ABMP("INS")=$P(^ABMDTXST(DUZ(2),ABMP("XMIT"),0),"^",4)
 S ABME("INS")=$P(^AUTNINS(ABMP("INS"),0),U)
 S ABME("EMC")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),1)),U,4)
 ;S ABME("GRPN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),1)),U,6)  ;Control number  ;abm*2.6*3
 ;start new code abm*2.6*3
 S ABMGDT=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,"B",9999999),-1)
 I $G(ABMGDT)'="" D
 .S ABMGIEN=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,"B",ABMGDT,0))
 .S ABME("GRPN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMGIEN,0)),U,2)
 I $G(ABME("GRPN"))="" S ABME("GRPN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),1)),U,6)
 ;end new code abm*2.6*3
 S ABME("TOT")=0
 S ABME("STOT")=0
 S ABME("CNT")=0
 S ABME("OLDLOC")=0
 S ABME("OLDBTYP")=0
 S $P(ABME("-"),"-",81)=""
 S $P(ABME("EQ"),"=",81)=""
 D HD
 ;
LOOP ; Loop through the bills of specified batch to gather data and
 ; print the report.
 S I=0
 F  S I=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"),2,I)) Q:'I  D  Q:Y=0
 .S DA=+^ABMDTXST(DUZ(2),ABMP("XMIT"),2,I,0)   ; Bill number (IEN)
 .Q:'$D(^ABMDBILL(DUZ(2),DA,0))  ; Quit if not in file (wrong site)
 .Q:$P(^ABMDBILL(DUZ(2),DA,0),U,4)="X"  ; Quit if bill cancelled
 .D DTAIL Q:Y=0
 .S ABME("STOT")=ABME("STOT")+$G(ABME(21))
 .S ABME("TOT")=ABME("TOT")+$G(ABME(21))
 .S ABME("CNT")=ABME("CNT")+1
 .Q
 S ABME("CUMCNT")=+$G(ABME("CUMCNT"))+ABME("CNT")
 S ABME("CUMTOT")=+$G(ABME("CUMTOT"))+ABME("TOT")
 Q:Y=0
 ;W !!,$$EN^ABMVDF("HIN"),"BATCH TOTAL: ",$$EN^ABMVDF("HIF"),?40,ABME("CNT")_"bills",?68,$J($FN(ABME("TOT"),",",2),10)  ;abm*2.6*6 5010
 I $D(ABMP("XLIST",ABME("XCNT"))) W !!?20,$$EN^ABMVDF("HIN"),"Insurer total: ",$$EN^ABMVDF("HIF"),?40,ABME("CNT")_$S(ABME("CNT")=1:" bill",1:" bills"),?68,$J($FN(ABME("TOT"),",",2),10)  ;abm*2.6*6 5010
 I +$O(ABMP("XLIST",ABME("XCNT")))=0 W !!,$$EN^ABMVDF("HIN"),"BATCH TOTAL: ",$$EN^ABMVDF("HIF"),?40,ABME("CUMCNT")_$S(ABME("CUMCNT")=1:" bill",1:" bills"),?68,$J($FN(ABME("CUMTOT"),",",2),10)  ;abm*2.6*6 5010
 S ABME("TOT")=0
 Q
 ;
DTAIL ;DISPLAY DETAIL
 ;
 ; ABME(1)  = Bill number
 ; ABME(2)  = Bill type
 ; ABME(3)  = Visit location
 ; ABME(5)  = Patient IEN
 ; ABME(8)  = Active Insurer IEN
 ; ABME(21) = Bill amount
 ; ABME(71) = Service date from
 ;
 N I
 Q:'$D(^ABMDBILL(DUZ(2),DA))   ; Quit if no bill data
 F I=1,2,3,5,8 S ABME(I)=$P(^ABMDBILL(DUZ(2),DA,0),"^",I)
 I ABME(3)'=ABME("OLDLOC")!(ABME(2)'=ABME("OLDBTYP")) D
 .I ABME("OLDLOC") D STOT
 .W !!,$$EN^ABMVDF("HIN"),"SITE: ",$$EN^ABMVDF("HIF"),$P($G(^AUTTLOC(+ABME(3),0)),"^",2)
 .W ?41,$$EN^ABMVDF("HIN"),"BILL TYPE: ",$$EN^ABMVDF("HIF"),ABME(2),!
 .;start new code abm*2.6*6 5010
 .I $P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,7)'="" D
 ..W ?1,$$EN^ABMVDF("HIN"),"INSURER: ",ABME("INS"),?40,"ST02: ",$$FMT^ABMERUTL($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),1)),U,7),"4NR"),$$EN^ABMVDF("HIF")
 .;end new code 5010
 .S ABME("OLDLOC")=ABME(3)
 .S ABME("OLDBTYP")=ABME(2)
 .S ABME("OLDINS")=ABME("INS")  ;abm*2.6*6 5010
 .Q
 S ABME(21)=$P($G(^ABMDBILL(DUZ(2),DA,2)),U)
 S ABME(71)=$P($G(^ABMDBILL(DUZ(2),DA,7)),U)
 S Y=ABME(71)
 D DD^%DT
 S ABME(71)=Y
 S ABME("HRN")=$P($G(^AUPNPAT(+ABME(5),41,+ABME(3),0)),"^",2)
 W !?3,ABME(1),?13,ABME("HRN"),?21,$P($G(^DPT(+ABME(5),0)),U),?51,ABME(71),?68,$J($FN(ABME(21),",",2),10)
 I $Y+5>IOSL D HD Q:Y=0
 Q
 ;
HD ;HEADER FOR DETAIL LISTING
 I ABME("PG"),$E(IOST)="C" S DIR(0)="E" D ^DIR K DIR Q:Y=0
 S ABME("PG")=ABME("PG")+1
 I (ABME("XCNT")>1&(($E(IOST)'="C")&($Y+5<IOSL))&(ABMP("XMIT")=ABMP("SAV"))) W ! Q  ;abm*2.6*6 5010
 S ABMP("SAV")=ABMP("XMIT")  ;abm*2.6*6
 W $$EN^ABMVDF("IOF"),!,?30,$$EN^ABMVDF("HIN"),"BATCH SUMMARY",?70,"Page: ",$$EN^ABMVDF("HIF"),ABME("PG")
 W !,$$EN^ABMVDF("HIN"),"BATCH DATE: ",$$EN^ABMVDF("HIF"),ABME("BDATE")
 ;W !,$$EN^ABMVDF("HIN"),"INSURER: ",$$EN^ABMVDF("HIF"),ABME("INS")  ;abm*2.6*6 5010
 I $P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,7)="" W !,$$EN^ABMVDF("HIN"),"INSURER: ",$$EN^ABMVDF("HIF"),ABME("INS")  ;abm*2.6*6 5010
 I $P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,7)'="" W !,$$EN^ABMVDF("HIN"),"CLEARINGHOUSE: ",$$EN^ABMVDF("HIF"),$P($G(^ABMRECVR($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,7),0)),U)  ;abm*2.6*6 5010
 W !,$$EN^ABMVDF("HIN"),"FORMAT: ",$$EN^ABMVDF("HIF"),ABME("FORMAT")
 W !,$$EN^ABMVDF("HIN"),"EMC FILE NAME: ",$$EN^ABMVDF("HIF"),ABME("EMC")
 W ?50,$$EN^ABMVDF("HIN"),"GROUP CONTROL #: ",$$EN^ABMVDF("HIF"),ABME("GRPN")  ;grp control #
 W !,$$EN^ABMVDF("HIN"),ABME("EQ")
 W !,"BILL #",?13,"HRN",?21,"PATIENT",?48,"SERVICE DATE FROM",?72,"AMOUNT"
 W !,ABME("-"),!,$$EN^ABMVDF("HIF")
 Q
 ;
STOT ;SITE TOTAL
 W !!,$$EN^ABMVDF("HIN"),"SITE/BILL TYPE  TOTAL:",$$EN^ABMVDF("HIF"),?68,$J($FN(ABME("STOT"),",",2),10)
 S ABME("STOT")=0
 Q
 ;
QUE ;QUE TO TASKMAN
 S ZTRTN="PRINT^ABMEBDSP"
 S ZTDESC="3P TX BATCH SUMMARY"
 S ZTSAVE("ABME(""XMITE"")")=""
 S ZTSAVE("ABME(""XMITB"")")=""
 S ZTSAVE("ABM*")=""
 K ZTSK
 D ^%ZTLOAD
 W:$G(ZTSK) !,"Task # ",ZTSK," queued.",!
 Q
 ;start new code abm*2.6*6 5010
BATCHLST ;
 W !
 S ABME("XCNT")=0
 F  S ABME("XCNT")=$O(ABMP("XLIST",ABME("XCNT"))) Q:'ABME("XCNT")  D
 .S ABMP("XMIT")=0
 .F  S ABMP("XMIT")=$O(ABMP("XLIST",ABME("XCNT"),ABMP("XMIT"))) Q:'ABMP("XMIT")  D
 ..S ABMP("SIEN")=0
 ..F  S ABMP("SIEN")=$O(ABMP("XLIST",ABME("XCNT"),ABMP("XMIT"),ABMP("SIEN"))) Q:'ABMP("SIEN")  D
 ...S ABMP("GCN")=0
 ...F  S ABMP("GCN")=$O(ABMP("XLIST",ABME("XCNT"),ABMP("XMIT"),ABMP("SIEN"),ABMP("GCN"))) Q:'ABMP("GCN")  D
 ....S ABMPIT=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,3)
 ....S ABMP("ITYP")=$S(ABMPIT="P":"PRIVATE",ABMPIT="D":"MEDICAID",ABMPIT="R":"MEDICARE",ABMPIT="N":"NON-BEN",ABMPIT="W":"WORK.COMP",ABMPIT="C":"CHAMPUS",1:"ALL SOURCES")
 ....W ABME("XCNT"),?3,$$BDT^ABMDUTL($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U)),?23,ABMP("GCN")
 ....W ?30,$P($G(^ABMDEXP($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,2),0)),U)
 ....W ?47,ABMP("ITYP")
 ....W:$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,7) ?59,$P($G(^ABMRECVR($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,7),0)),U)
 ....W !?23,$P($G(^AUTNINS($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,4),0)),U)
 ....W:$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,5) ?46,$P($G(^VA(200,$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,5),0)),U)
 ....W:$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,6) ?70,"ST02: ",$$FMT^ABMERUTL($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,6),"4NR")
 ....W !
 Q
 ;end new code 5010
