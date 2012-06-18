ABMDTX ; IHS/ASDST/DMJ - EXPORT BILLS FROM FACILITY ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
ENT K ABM S ABM("PG")=0,ABM("REDO")=0,ABM("XIT")=0
 I '$D(IO) S IOP="HOME" D ^%ZIS
 D AFFL
 I $D(ABMP("AUTO")) S ZTQUEUED="",XBMED="F" G AUTO
 W !! K DIR S DIR(0)="Y",DIR("A")="Do you wish to rerun a Previous Export",DIR("B")="N",DIR("?")="If a previous export was corrupted or lost and requires regeneration answer YES." D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S ABM("XIT")=5 G XIT
 I Y=1 S ABM("REDO")=1 D REDO G XIT:ABM("XIT")
 G AUTO
 ;--------------------------------------------------------------------
PRQUE ;TASKMAN ENTRY POINT
 S ABMP("AUTO")=1 D AFFL
 ;--------------------------------------------------------------------
AUTO D RECD:'ABM("REDO") G XIT:ABM("XIT")
 D ^ABMDTX0 I ABM("CNT")<1 S ABM("XIT")=9 G XIT
 D DEV:'$D(ABMP("AUTO")) G XIT:ABM("XIT")
 I $D(^TMP("ABMDTX",$J,"INS-ERR")) D ^ABMDTX1 S ABM("XIT")=8 G XIT
 D ^ABMDTX2
 G XIT
 ;--------------------------------------------------------------------
DEV W ! S DIR(0)="Y",DIR("A")="Generate a Transmittal List of the Records Exported (Y/N)",DIR("B")="Y" D ^DIR K DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) S ABM("XIT")=5 Q
 Q:'Y  S ABMP("TLIST")=1
 S ABM("LTYPE")="Transmittal"
DEV2 ;EP FROM ABMDTX1 (PRINT ERROR LIST)
 W ! S %ZIS="PN",%ZIS("B")="",%ZIS("A")="Print "_ABM("LTYPE")_" List on DEVICE: " D ^%ZIS I $G(POP) S ABM("XIT")=1 Q
 I IO=IO(0) W *7,!!,"This Report can not be Printed to the Screen, Please Select another Device." G DEV
 S ABM("IOP")=ION,IOP=ION D ^%ZIS I $G(POP) S ABM("XIT")=1 Q
 D ^ABMDR16 I $D(DTOUT)!$D(DUOUT) S ABM("XIT")=5
 D ^%ZISC
 Q
 ;--------------------------------------------------------------------
OPEN ;EP for Opening Device
 S IOP=ABM("IOP")_";132" D ^%ZIS I $G(POP) S ABM("XIT")=1 Q
 U IO W:$D(ABM("PRINT",16)) @ABM("PRINT",16)
 Q
 ;--------------------------------------------------------------------
RECD I $D(^ABMDAOTX(DUZ(2),DT,0)) D  Q
 .I $P(^ABMDAOTX(DUZ(2),DT,0),U,3)]""!'$P(^(0),U,2) S ABM("ADFN")=DT Q
 .S ABM("XIT")=2
 S DA=0,DIK="^ABMDAOTX(DUZ(2),"
 F  S DA=$O(^ABMDAOTX(DUZ(2),DA)) Q:'DA  I $P(^(DA,0),U,3)]"",'$P(^(0),U,2) D ^DIK
 ;I don't know where the unlock is for this lock
 L +(^AUTNINS,^ABMDAOTX):1
 I '$T S ABM("XIT")=3
 S DIC="^ABMDAOTX(DUZ(2),",(DINUM,X)=DT,DIC(0)="L" K DD,DO D FILE^DICN
 I +Y<1 S ABM("XIT")=4
 S ABM("ADFN")=+Y
 Q
 ;--------------------------------------------------------------------
REDO ;  EP
 W !! K DIC S DIC="^ABMDAOTX(DUZ(2),",DIC(0)="QEAM",DIC("A")="Select DATE EXPORTED to AREA OFFICE: "
 D ^DIC K DIC
 I $D(DTOUT)!$D(DUOUT)!(X="") S ABM("XIT")=5 Q
 G REDO:+Y<1
 I $P(^ABMDAOTX(DUZ(2),+Y,0),"^",3)'="" D
 .W !!,*7,$$EN^ABMVDF("RVN"),"EXPORT BATCH ERROR:",$$EN^ABMVDF("RVF")," ",$P(^ABMDAOTX(DUZ(2),+Y,0),"^",3)
 S ABM("ADFN")=+Y
 Q
 ;--------------------------------------------------------------------
XIT I $D(ABM("PRINT",16)) U IO D 10^ABMDR16 W $$EN^ABMVDF("IOF")
 D ^%ZISC
 I ABM("XIT") D ERR I 1
 E  I $P(^ABMDAOTX(DUZ(2),ABM("ADFN"),0),U,3)]"" S DIE="^ABMDAOTX(DUZ(2),",DA=ABM("ADFN"),DR=".03///@" D ^ABMDDIE
 I $D(ABMP("AUTO")),$D(ZTQUEUED) D KILL^%ZTLOAD
 L -(^AUTNINS,^ABMDAOTX)
 K ABM,ABMP,ABME,ABMV,^TMP("ABMDTX",$J),DIR,XBGL,XBTLE,XBMED,XBFLG,ZTQUEUED
 Q
 ;--------------------------------------------------------------------
QUE S ZTRTN="PRQUE^ABMDTX",ZTDESC="3P EXPORT TO AO TRACKING"
 D QUE^ABMDRUTL
 S ABM("XIT")=7
 Q
 ;--------------------------------------------------------------------
ERR S:ABM("XIT")=1 ABM="Printer not Selected or Unable to OPEN Printer."
 S:ABM("XIT")=2 ABM="Data was already exported to Area Office TODAY."
 S:ABM("XIT")=3 ABM="AREA OFFICE EXPORT File or INSURER File in Use."
 S:ABM("XIT")=4 ABM="Area Office Log Entry not created, Job Canceled."
 S:ABM("XIT")=5 ABM="Job Terminated as Requested or Timed Out."
 S:ABM("XIT")=6 ABM=$S($D(XBFLG(1)):XBFLG(1),1:"FILE not SAVED Error occurred during Export.")
 S:ABM("XIT")=7 ABM="Job Queued as Requested."
 S:ABM("XIT")=8 ABM="INSURER Errors Exist."
 S:ABM("XIT")=9 ABM="No Records Available for Export."
 S ABM(1)="***** "_ABM_" *****"
 I '$D(ABMP("AUTO")) W *7,!!?(40-($L(ABM(1))/2)),ABM(1),!!,"ABNORMAL END - THIS JOB HAS BEEN CANCELLED." K DIR S DIR(0)="E",DIR("A")="  (Press [RETURN] to Continue)" D ^DIR K DIR
 I $D(ABM("ADFN")),45'[ABM("XIT") S DIE="^ABMDAOTX(DUZ(2),",DA=ABM("ADFN"),DR=".03////"_ABM D ^ABMDDIE
 Q
 ;--------------------------------------------------------------------
AFFL S ABMP("AFFL")=1 Q:'$D(^ABMDPARM(DUZ(2),1,0))  S ABM("X")=$P(^(0),U)
 Q:'$D(^AUTTLOC(ABM("X"),0))  S ABM("LCD")=$P(^(0),U,7)
 S ABMP("AFFL")="",ABM("I")=0
 F  S ABM("I")=$O(^AUTTLOC(ABM("X"),11,ABM("I"))) Q:'ABM("I")  S ABM("IDT")=$S($P(^(ABM("I"),0),U,2)]"":$P(^(0),U,2),1:9999999) I DT>$P(^(0),U)&(DT<ABM("IDT")) S ABMP("AFFL")=$P(^(0),U,3)
 I ABMP("AFFL")="" S ABMP("AFFL")=1
 Q
