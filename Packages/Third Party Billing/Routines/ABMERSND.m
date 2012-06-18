ABMERSND ; IHS/ASDST/DMJ - RE-SEND A BATCH OF BILLS ELECTRONIC FORMAT ; 
 ;;2.6;IHS Third Party Billing System;**2,6,8**;NOV 12, 2009
 ;Original;DMJ;
 ; IHS/SD/SDR - abm*2.6*2 - 5PMS10005 - Set var for 3P Bill EXPORT NUMBER RE-EXPORT multiple
 ; IHS/SD/SDR - abm*2.6*6 - 5010 - Changes for clearinghouse
 ;
START ;START HERE   
 W !
 S DIC="^ABMDTXST(DUZ(2),"
 S DIC(0)="AEMQ"
 S DIC("S")="I $L($P($G(^(1)),""^"",4))"
 D ^DIC
 K DIC
 Q:Y<0
 S ABMP("XMIT")=+Y
 ;start new code abm*2.6*6 5010
LIST ; EP
 W !!,"Checking...",!
 K ABMT("XLIST")
 K ABMT("CHKLIST")
 S ABMT("XCNT")=0
 S ABMT("XLINE")=1
 S ABMT("SIEN")=$O(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,9999999),-1)  ;look at last entry only
 I ABMT("SIEN")'="" S ABMT("ORIGGCN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMT("SIEN"),0)),U,2)
 I $G(ABMT("ORIGGCN"))="" S ABMT("ORIGGCN")=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),1)),U,6)
 ;
 S ABMT("XMIT")=0
 F  S ABMT("XMIT")=$O(^ABMDTXST(DUZ(2),"EGCN",ABMT("ORIGGCN"),ABMT("XMIT"))) Q:'+ABMT("XMIT")  D
 .S ABMT("SIEN")=$O(^ABMDTXST(DUZ(2),ABMT("XMIT"),3,9999999),-1)  ;look at last entry only
 .I ABMT("SIEN")'="" S ABMT("GCN")=$P($G(^ABMDTXST(DUZ(2),ABMT("XMIT"),3,ABMT("SIEN"),0)),U,2)
 .I $G(ABMT("GCN"))="" S ABMT("GCN")=$P($G(^ABMDTXST(DUZ(2),ABMT("XMIT"),1)),U,6)
 .Q:(ABMT("GCN")'=ABMT("ORIGGCN"))
 .S ABMT("CHKLIST",ABMT("XMIT"))=1
 .S ABMT("XLIST",ABMT("XLINE"),ABMT("XMIT"),ABMT("SIEN"),ABMT("GCN"))=""
 .S ABMT("GLIST",ABMT("GCN"))=""
 .S ABMT("XCNT")=+$G(ABMT("XCNT"))+1,ABMT("XLINE")=+$G(ABMT("XLINE"))+1
 I '$D(ABMT("XLIST")) D
 .F  S ABMT("XMIT")=$O(^ABMDTXST(DUZ(2),"C",ABMT("ORIGGCN"),ABMT("XMIT"))) Q:'+ABMT("XMIT")
 ..I $G(ABMT("GCN"))="" S ABMT("GCN")=$P($G(^ABMDTXST(DUZ(2),ABMT("XMIT"),1)),U,6)
 ..Q:(ABMT("GCN")'=ABMT("ORIGGCN"))
 ..S ABMT("CHKLIST",ABMT("XMIT"))=1
 ..S ABMT("XLIST",ABMT("XLINE"),ABMT("XMIT"))=""
 ..S ABMT("GLIST",ABMT("GCN"))=""
 .S ABMT("XCNT")=+$G(ABMT("XCNT"))+1,ABMT("XLINE")=+$G(ABMT("XLINE"))+1
 S ABMER("LAST")=+$G(ABMT("XCNT"))  ;abm*2.6*8
 ;
 I +$G(ABMT("XCNT"))>1 D
 .W !,"There are multiple batches associated with your selection."
 .W !!,"Select from the following:",!
 D BATCHLST
 S ABMQUIT=0
 I +$G(ABMT("XCNT"))>1 D
 .K DIR,DIE,DIC,X,Y,DA
 .S DIR(0)="SO^1:All associated batches;2:A single batch entry;3:Reselect export dates;4:Quit"
 .S DIR("A")="Select"
 .D ^DIR K DIR
 .S ABMANS=+Y
 .I ABMANS=1  ;print all entries
 .I ABMANS=2 D  ;select one entry
 ..D BATCHLST
 ..K DIR,DIE,DIC,X,Y,DA
 ..S DIR(0)="NO^1:"_(ABMT("XCNT")-1)
 ..S DIR("A")="Select"
 ..D ^DIR K DIR
 ..I +Y=0 S ABMQUIT=1
 ..S ABMSEL=Y
 .I ABMANS=3 G START  ;start over
 .I ABMANS=4 S ABMQUIT=1 Q  ;quit w/out printing anything
 Q:ABMQUIT
 I $G(ABMANS)=2 D
 .S ABMT("XCNT")=ABMSEL
 .S ABMECHK=0
 .F  S ABMECHK=$O(ABMT("XLIST",ABMECHK)) Q:'ABMECHK  D
 ..I ABMECHK'=ABMSEL K ABMT("XLIST",ABMECHK)
 .M ABMT("XLIST",1)=ABMT("XLIST",ABMSEL)
 .S (ABMER("CNT"),ABMER("LAST"))=1
 ;
 S:+$G(ABMER("LAST"))=0 ABMER("LAST")=(ABMT("XCNT")-1)
 S ABMT("XCNT")=0
 S ABMER("CNT")=0  ;abm*2.6*8
 F  S ABMT("XCNT")=$O(ABMT("XLIST",ABMT("XCNT"))) Q:'ABMT("XCNT")  D
 .S ABMT("XMIT")=0
 .F  S ABMT("XMIT")=$O(ABMT("XLIST",ABMT("XCNT"),ABMT("XMIT"))) Q:'ABMT("XMIT")  D
 ..;I $D(ABMP("XLIST",ABMT("XCNT"),ABMP("XMIT")))<11 D  Q  ;this is for entries created prior to p6 install  ;abm*2.6*8
 ..I $D(ABMP("XLIST",ABMT("XCNT"),ABMT("XMIT")))<11 D  Q  ;this is for entries created prior to p6 install  ;abm*2.6*8
 ...;S ABMP("XMIT")=ABMT("XMIT"),ABMER("CNT")=ABMT("XCNT")  ;abm*2.6*8
 ...S ABMP("XMIT")=ABMT("XMIT"),ABMER("CNT")=+$G(ABMER("CNT"))+1  ;abm*2.6*8
 ...K ABMP("INS")  ;abm*2.6*8
 ...D CRBATCH
 ..S ABMT("SIEN")=0
 ..F  S ABMT("SIEN")=$O(ABMT("XLIST",ABMT("XCNT"),ABMT("XMIT"),ABMT("SIEN"))) Q:'ABMT("SIEN")  D
 ...S ABMT("GCN")=0
 ...F  S ABMT("GCN")=$O(ABMT("XLIST",ABMT("XCNT"),ABMT("XMIT"),ABMT("SIEN"),ABMT("GCN"))) Q:'ABMT("GCN")  D
 ....;S ABMP("XMIT")=ABMT("XMIT"),ABMER("CNT")=ABMT("XCNT")  ;abm*2.6*8
 ....S ABMP("XMIT")=ABMT("XMIT"),ABMER("CNT")=+$G(ABMER("CNT"))+1  ;abm*2.6*8
 ....K ABMP("INS")  ;abm*2.6*8
 ....D CRBATCH
 K ABMP
 K ABME
 K ABMT
 S DIR(0)="E"
 D ^DIR
 K DIR
 Q
 ;end new code 5010
CRBATCH S ABMP("EXP")=$P(^ABMDTXST(DUZ(2),ABMP("XMIT"),0),"^",2)
 S ABMP("XRTN")=$P($G(^ABMDEXP(+ABMP("EXP"),0)),"^",4)
 S X=ABMP("XRTN")
 X ^%ZOSF("TEST")
 I '$T D  K ABMP Q
 .W !!,"Routine :",ABMP("XRTN")," not found.Cannot proceed.",!
 .S DIR(0)="E"
 .D ^DIR
 .K DIR
 ;start old code abm*2.6*3 5PMS10005#2
 ;S DIE="^ABMDTXST(DUZ(2),"
 ;S DA=ABMP("XMIT")
 ;S DR=".16///"_$$NSN^ABMERUTL()
 ;D ^DIE
 ;end old code abm*2.6*3 5PMS10005#2
 S ABMREX("RECREATE")=1  ;abm*2.6*2 5PMS10005
 ;D GCNMULT^ABMERUTL("C",1)  ;abm*2.6*3 5PMS10005#2  ;abm*2.6*6 5010
 I ABMER("CNT")=1 D GCNMULT^ABMERUTL("C",1)  ;abm*2.6*3 5PMS10005#2  ;abm*2.6*6 5010
 ;start new code abm*2.6*8
 I ABMER("CNT")>1 D
 .S DA(1)=ABMP("XMIT")
 .S DIC="^ABMDTXST(DUZ(2),"_DA(1)_",3,"
 .S DIC("P")=$P(^DD(9002274.6,3,0),U,2)
 .S DIC(0)="L"
 .D NOW^%DTC
 .S (X,ABMXMTDT)=%
 .S DIC("DR")=".02////"_ABMGCN
 .S DIC("DR")=DIC("DR")_";.03////C"
 .S DIC("DR")=DIC("DR")_";.04////"_DUZ
 .I +$G(ABM("CHIEN"))'=0  S DIC("DR")=DIC("DR")_";.07////"_+$G(ABM("CHIEN"))
 .D ^DIC
 ;end new code abm*2.6*8
 D @("^"_ABMP("XRTN"))
 ;start old code abm*2.6*6 5010
 ;S DIR(0)="E"
 ;D ^DIR
 ;K DIR
 ;K ABMP
 ;end old code abm*2.6*6 5010
 Q
 ;start new code abm*2.6*6 5010
BATCHLST ;
 W !
 S ABME("XCNT")=0
 F  S ABME("XCNT")=$O(ABMP("XLIST",ABME("XCNT"))) Q:'ABME("XCNT")  D
 .S ABMP("XMIT")=0
 .F  S ABMP("XMIT")=$O(ABMP("XLIST",ABME("XCNT"),ABMP("XMIT"))) Q:'ABMP("XMIT")  D
 ..I $D(ABMP("XLIST",ABME("XCNT"),ABMP("XMIT")))<11 D  Q  ;this is for entries created prior to p6 install
 ...S ABMPIT=$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,3)
 ...S ABMP("ITYP")=$S(ABMPIT="P":"PRIVATE",ABMPIT="D":"MEDICAID",ABMPIT="R":"MEDICARE",ABMPIT="N":"NON-BEN",ABMPIT="W":"WORK.COMP",ABMPIT="C":"CHAMPUS",1:"ALL SOURCES")
 ...W ABME("XCNT"),?3,$$BDT^ABMDUTL($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U)),?23,ABMP("GCN")
 ...W ?30,$P($G(^ABMDEXP($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,2),0)),U)
 ...W ?47,ABMP("ITYP")
 ...W:$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,7) ?59,$P($G(^ABMRECVR($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,7),0)),U)
 ...W !?23,$P($G(^AUTNINS($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,4),0)),U)
 ...W ?46,$P($G(^VA(200,$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,5),0)),U)
 ...W:$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,6) ?70,"ST02: ",$$FMT^ABMERUTL($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,6),"4NR")
 ...W !
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
 ....W ?46,$P($G(^VA(200,$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),0)),U,5),0)),U)
 ....W:$P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,6) ?70,"ST02: ",$$FMT^ABMERUTL($P($G(^ABMDTXST(DUZ(2),ABMP("XMIT"),3,ABMP("SIEN"),0)),U,6),"4NR")
 ....W !
 Q
 ;end new code 5010
