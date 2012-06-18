BADEASU ; IHS/OIT/FJE  MSC/VAC/AMF - Dentrix HL7 UTILITIES  DISPLAY EDR ASUFAC ;14-Sep-2010 13:29;EDR
 ;;1.0;DENTAL/EDR INTERFACE;**1**;AUG 22, 2011
 ;; Modified - IHS/MSC/VAC - 8/2010 - Move from BEE namespace to BADE namespace
 ;; Modified - IHS/MSC/AMF - 10/2010 - Trace Function
 ;;
 Q
CLEAN ;EP for diagnostic use only by programmer
 ;K ^HLB
 ;K ^HLA
 S ^HLB(0)="HLO MESSAGES^778O^^"
 S ^HLA(0)="HLO MESSAGE BODY^777D^^"
 S ^HLC("QUEUECOUNT","OUT","DENTRIX:5012","DENT ADT")=0
 S ^HLC("QUEUECOUNT","IN","DENTRIX:5012","DENT ADT")=0
 S ^HLC("QUEUECOUNT","OUT","DENTRIX:5012","DENT MFE")=0
 S ^HLC("QUEUECOUNT","IN","DENTRIX:5012","DENT MFE")=0
 S ^HLC("FILE777","OUT")=0
 S ^HLC("FILE778","OUT","TCP")=0
 Q
RSEND ;EP
 N X
 W !,"Reset a message in HLO for EIE transport"
 W !!,"Are you sure you want to reset an HLO message" S %=2 D YN^DICN I %'=1 S Y=-1 Q
 S DIR(0)="N",DIR("A")="Enter IEN to remove 16,17,20,21 DATA" D ^DIR K DIR
 Q:Y="^"  S X=Y
 I '$D(^HLB(X,0)) W !,"Message IEN not identified..",! Q
 S $P(^HLB(X,0),"^",16)=""
 S $P(^HLB(X,0),"^",17)=""
 S $P(^HLB(X,0),"^",20)=""
 S $P(^HLB(X,0),"^",21)=""
 S ^HLB(X,4)=""
 W !,"Message IEN "_X_" reset.."
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
ASUFAC ;EP LOOK FOR ALL ACTIVE ASUFAC NUMBERS
 N X,X1,X2,BADEX
 S X=0 F  S X=$O(^AUPNPAT(X)) Q:+X=0  D
 .S X1=0 F  S X1=$O(^AUPNPAT(X,41,X1)) Q:+X1=0  D
 ..S X2=$P($G(^AUPNPAT(X,41,X1,0)),"^",3)
 ..I $L(X2) D
 ...I '$D(BADEX("I",X1)) S BADEX("I",X1)=0
 ...S BADEX("I",X1)=BADEX("I",X1)+1
 ..I '$L(X2) D
 ...I '$D(BADEX("A",X1)) S BADEX("A",X1)=0
 ...S BADEX("A",X1)=BADEX("A",X1)+1
 W @IOF,!,"     A S U F A C  D I S P L A Y",!
 W !!,"Active  Count",?15,"Facility",?55,"ASUFAC"
 S X=0 F  S X=$O(BADEX("A",X)) Q:+X=0  D
 .S $P(BADEX("A",X),"^",2)=$P($G(^DIC(4,X,0)),"^",1)
 .S $P(BADEX("A",X),"^",3)=$P($G(^AUTTLOC(X,0)),"^",10)
 .W !,"Active:  ",$P(BADEX("A",X),"^",1),?15,$P(BADEX("A",X),"^",2),?55,$P(BADEX("A",X),"^",3)
 W !!,"Inactive Count",?15,"Facility",?55,"ASUFAC"
 S X=0 F  S X=$O(BADEX("I",X)) Q:+X=0  D
 .S $P(BADEX("I",X),"^",2)=$P($G(^DIC(4,X,0)),"^",1)
 .S $P(BADEX("I",X),"^",3)=$P($G(^AUTTLOC(X,0)),"^",10)
 .W !,"Inactive:",$P(BADEX("I",X),"^",1),?15,$P(BADEX("I",X),"^",2),?55,$P(BADEX("I",X),"^",3)
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
TRACE ;EP
 ;Toggles globals for EIE Trace
 N OUT,IN,DIR,QUIT
 W !!,"This option is used to toggle the Ensemble Engine Trace."
 W !,"When the trace is enabled, it can slow down the system, so it should only be used for less than 5 minutes at a time.",!
 S OUT=+$G(^BEEICTRL("TRACE","Dental"))
 S IN=+$G(^BEEICTRL("TRACE","DENTRIX"))
 S QUIT=0
 I OUT D  Q:QUIT
 .W !!,"Currently, your OUTBOUND trace is enabled."
 .S DIR(0)="Y",DIR("A")="Do you want to stop the OUTBOUND trace",DIR("B")="Yes" D ^DIR K DIR
 .S:Y=U QUIT=1
 .I Y S ^BEEICTRL("TRACE","Dental")=0 W !,"OUTBOUND trace has been stopped." D CON
 I 'OUT D  Q:QUIT
 .W ! S DIR(0)="Y",DIR("A")="Do you want to start the OUTBOUND trace",DIR("B")="Yes" D ^DIR K DIR
 .S:Y=U QUIT=1
 .I Y S ^BEEICTRL("TRACE","Dental")=1 W !,"OUTBOUND trace has been enabled.",!,"Remember to discontinue it within a few minutes." D CON
 I IN D  Q:QUIT
 .W !!,"Currently, your INBOUND trace is enabled."
 .S DIR(0)="Y",DIR("A")="Do you want to stop the INBOUND trace",DIR("B")="Yes" D ^DIR K DIR
 .S:Y=U QUIT=1
 .I Y S ^BEEICTRL("TRACE","DENTRIX")=0 W !,"INBOUND trace has been stopped." D CON
 I 'IN D  Q:QUIT
 .W ! S DIR(0)="Y",DIR("A")="Do you want to start the INBOUND trace",DIR("B")="Yes" D ^DIR K DIR
 .S:Y=U QUIT=1
 .I Y S ^BEEICTRL("TRACE","DENTRIX")=1 W !,"INBOUND trace has been enabled.",!,"Remember to discontinue it within a few minutes." D CON
 Q
 ;
CON ;
 S DIR(0)="EA",DIR("?")="",DIR("A")="Press ENTER to continue..." D ^DIR K DIR
 Q
 ;
