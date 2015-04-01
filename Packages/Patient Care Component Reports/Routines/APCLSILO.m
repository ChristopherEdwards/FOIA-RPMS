APCLSILO ; IHS/CMI/LAB - ILI surveillance export ; 
 ;;3.0;IHS PCC REPORTS;**29**;FEB 05, 1997;Build 35
 ;
 ;
START ;
 W:$D(IOF) @IOF
 D EXIT
 W !!,"This option can be used to send an ILI Surveillance (""FLU"") file or a FLU POP"
 W !,"file to the IHS EPI program.  This should only be done if the EPI program"
 W !,"has requested that you do so because previous exports have failed.",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
 I $P(^AUTTSITE(1,0),U)'=DUZ(2) W !!,"You must be logged into the main facility to do this export.",!,"Your main facility is: ",$$GET1^DIQ(9999999.39,1,.01),! D PAUSE^APCLVL01,EXIT Q
 I '$D(^BGPSITE(DUZ(2),0)) W !!,"Your CRS Site Parameters are not setup for this facility: ",!,$P(^DIC(4,DUZ(2),0),U,1)," can not continue.",! D PAUSE^APCLVL01,EXIT Q
 I $P($G(^AUTTLOC(DUZ(2),1)),U,3)="" W !!,"Your DBID is missing, cannot continue.",! D PAUSE^APCLVL01,EXIT Q
 S APCLWEXP=""
 S DIR(0)="S^F:FLU visit data export;P:FLU POP - Flu Population export;B:BOTH",DIR("A")="Which export would you like to run",DIR("B")="P" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 S APCLWEXP=Y
 I APCLWEXP="B" S APCL1ST=1
 I APCLWEXP="P" S APCL1ST=1
 K APCLLOCT,APCLALLT,APCLHTOT,APCLALL1
 K ^APCLDATA($J)  ;export global
 S APCLCTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))  ;clinic taxonomy
 S APCLDTAX=$O(^ATXAX("B","SURVEILLANCE ILI",0))  ;dx taxonomy
 S APCLTTAX=$O(^ATXAX("B","SURVEILLANCE ILI NO TMP NEEDED",0))
 I 'APCLCTAX W !!,$P(^ATXAX(APCLCTAX,0),U,1)," is missing." D PAUSE^APCLVL01 D EXIT Q
 I 'APCLDTAX W !!,$P(^ATXAX(APCLDTAX,0),U,1)," is missing." D PAUSE^APCLVL01 D EXIT Q
 I 'APCLTTAX W !!,$P(^ATXAX(APCLTTAX,0),U,1)," is missing." D PAUSE^APCLVL01 D EXIT Q
 I APCLWEXP="P" G ZIS  ;cmi/maw 03/03/2014 skip dates if monthly FLUPOP
 ;
TP ;
 S DIR(0)="S^1:90 days (the past 90 days);2:2009 - all visits since 01/01/2009;3:User defined Date Range",DIR("A")="For which time period would you like to export ILI/FLU visits",DIR("B")=1 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G START
 S APCLY=Y
 I APCLY=1 S APCLSD=$$FMADD^XLFDT(DT,-91)_".9999",APCLBDAT=$$FMADD^XLFDT(DT,-90)
 I APCLY=2 S APCLSD=3081231.9999,$P(^APCLILIC(1,0),U,4)=1,APCLBDAT=3090101,APCLFLF=1
 I APCLY=1!(APCLY=2) S APCLED=$$FMADD^XLFDT(DT,-1)
 I APCLY=2 D  G:APCLQ=1 START
 .W !!,"WARNING:  exporting that date range will take a while to run and will"
 .W !,"require a large amount of space in the HL 7 message file."
 .S APCLQ=0
 .S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCLQ=1 Q
 .I 'Y S APCLQ=1
 I APCLY=3 D GETDATES
 I APCLSD=""!(APCLED="") W !,"Dates not entered." D PAUSE^APCLVL01 G START
 ;GET DEVICE AND QUEUE
ZIS ;call to XBDBQUE
 S APCLZHSD=DT
 S XBRP="",XBRC="EP1^APCLSILI",XBRX="EXIT^APCLSILO",XBNS="APCL"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;clean up and exit
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
GETDATES ;
 W !!,"You will supply the beginning date, the ending date will be yesterday.",!
 S (APCLSD,APCLBDAT,APCLED)=""
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Date"
 D ^DIR
 Q:$D(DIRUT)
 Q:Y<1
 I Y>DT W !!,"Future dates not allowed." G GETDATES
 S APCLBDAT=Y
 ;
 S APCLED=$$FMADD^XLFDT(DT,-1)
 S APCLSD=$$FMADD^XLFDT(APCLBDAT,-1)_".9999"
 ;
 I APCLED<APCLBDAT D  G GETDATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 Q
