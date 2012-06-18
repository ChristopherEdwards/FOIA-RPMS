AMQQMGR1 ;IHS/CMI/THL - CHECKS AND SETS THE 'AQ' XREF ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;-----
 W:$D(IOF) @IOF
START I '$D(^AUTTSITE(1,0)) W !!,"RPMS SITE PARAMETER FILE NOT PRESENT...REQUEST CANCELLED"
 I $P(^AUTTSITE(1,0),U,19)'="Y" D NEW G EXIT
 W !!,"Q-Man indices are active!",!!!
 W ?3,"V EXAM 'AQ' index is "
 W:'$D(^AUPNVXAM("AQ")) "not "
 W "present",!
 W ?3,"V NUTRITION RISK SCREENING 'AQ' index is " ;PATCH XXX
 W:'$D(^AUPNVNTS("AQ")) "not "
 W "present",!
 W ?3,"The INDIAN BLOOD QUANTUM 'AQ1' index of the PATIENT file is "
 W:'$D(^AUPNPAT("AQ1")) "not "
 W "present",!
 W ?3,"V IMMUNIZATION 'AQ' index is "
 W:'$D(^AUPNVIMM("AQ")) "not "
 W "present",!
 W ?3,"V LAB 'AQ' index is "
 W:'$D(^AUPNVLAB("AQ")) "not "
 W "present",!
 W ?3,"V MEASUREMENT 'AQ' index is "
 W:'$D(^AUPNVMSR("AQ")) "not "
 W "present",!
 W ?3,"V SKIN TEST 'AQ' index is "
 W:'$D(^AUPNVSK("AQ")) "not "
 W "present",!
 W !!!
 S DIR(0)="E"
 D ^DIR
 K DIRUT,DUOUT,DTOUT,DIR
EXIT K %Y
 Q
 ;
NEW W !!,"Q-Man indices have not been activated!",!!
 W "I can create the Q-Man indices now.  This will significantly improve the",!
 W "performance of Q-Man and reduce stress on the CPU.  However, the new indices",!
 W "will increase the size of the PCC database by approximately 1%"
 W !!,"Want me to create the indices?"
 S %=0
 D YN^DICN
 K DIR,%
 I $E(%Y)=U!("Yy"'[%Y)!(%Y="")!($D(DUOUT))!($D(DTOUT)) K DUOUT,DTOUT,%Y Q
 W !,"OK, I'll run the job in background.  This job will take 1-72 hours to complete.",!!
MAILTASK S ZTRTN="JOB^AMQQMGR1"
 S ZTDTH="NOW"
 S ZTIO=""
 S ZTDESC="CREATE Q-MAN INDICES"
 D ^%ZTLOAD
 W !!,$S($D(ZTSK):"Request queued!",1:"Request cancelled!"),!!!
 H 3
 Q
 ;
JOB ;
 S G=U_"AUTTSITE"
 S $P(@G@(1,0),U,19)="Y"
 K G,AMQQAQF
 I $P($G(^AUTTSITE(1,0)),U,19)'="Y" Q
 ;
VIMM ; re-indexing v immunization
 K ^AUPNVIMM("AQ")
 S DIK="^AUPNVIMM("
 S DIK(1)=".01^AQTOO"
 D ENALL^DIK
 K DIK
 ;
PAT ; re-indexing aq1 on Patient
 K AUPNPAT("AQ1")
 F DA=0:0 S DA=$O(^AUPNPAT(DA)) Q:'DA  S X=$P($G(^(DA,11)),U,10) K AMQQQXR D QXR I $D(AMQQQXR) S ^AUPNPAT("AQ1",AMQQQXR,DA)=""
 ;
VMSR ; re-indexing aq on v measurement
 K ^AUPNVMSR("AQ")
 F DA=0:0 S DA=$O(^AUPNVMSR(DA)) Q:'DA  S AUPNCIXF="S",AUPNCIXV=$G(^(DA,0)),X=$P(AUPNCIXV,U,4) I X'="" D VMSR04^AUPNCIX
 ;
VDXP ; Re-indexing AQ on V DIAGNOSTIC PROCEDURE RESULT
 K ^AUPNVDXP("AQ")
 S AMQQX=0
 F  S AMQQX=$O(^AUPNVDXP(AMQQX)) Q:AMQQX'=+AMQQX  I $D(^AUPNVDXP(AMQQX,0)) S DA=AMQQX,X=$P(^AUPNVDXP(AMQQX,0),U,1),AUPNDXQF="S1" D ^AUPNVDXP
 ;
VXAM ;re-index AQ on V exam
 K ^AUPNVXAM("AQ")
 S AMQQX=0
 F  S AMQQX=$O(^AUPNVXAM(AMQQX)) Q:AMQQX'=+AMQQX  I $D(^AUPNVXAM(AMQQX,0)) S DA=AMQQX,X=$P(^AUPNVXAM(AMQQX,0),U,1) D AQE1^AUPNCIXL
 K ^AUPNVNTS("AQ")
 S AMQQX=0
 F  S AMQQX=$O(^AUPNVNTS(AMQQX)) Q:AMQQX'=+AMQQX  I $D(^AUPNVNTS(AMQQX,0)) S DA=AMQQX,X=$P(^AUPNVNTS(AMQQX,0),U,1) D AQE1^AUPNCIXL
 ;
VSK ;re-index aq on v skin test
 K ^AUPNVSK("AQ")
 S AMQQX=0
 F  S AMQQX=$O(^AUPNVSK(AMQQX)) Q:AMQQX'=+AMQQX  I $D(^AUPNVSK(AMQQX,0)) S DA=AMQQX,X=$P(^AUPNVSK(AMQQX,0),U,1) D AQS1^AUPNCIXL
 ;
VRAD ; re-index aq on v radiology
 K ^AUPNVRAD("AQ")
 S AMQQX=0
 F  S AMQQX=$O(^AUPNVRAD(AMQQX)) Q:AMQQX'=+AMQQX  I $D(^AUPNVRAD(AMQQX,0))  S DA=AMQQX,X=$P(^AUPNVRAD(AMQQX,0),U,1) D AQR1^AUPNCIXL
 ;
VLAB ; re-index aq on v lab
 K ^AUPNVLAB("AQ")
 S AMQQX=0
 F  S AMQQX=$O(^AUPNVLAB(AMQQX)) Q:AMQQX'=+AMQQX  I $D(^AUPNVLAB(AMQQX,0))  S DA=AMQQX,X=$P(^AUPNVLAB(AMQQX,0),U,1) D AQ1^AUPNCIXL
 ;
KILL K AMQQX,DA,DIE,DIK,AUPNDXQF
 Q
 ;
QXR ; ENTRY POINT
 I X="" Q
 N %
 S %=X
 N X
 I %["/" S %=(+%/$S($P(%,"/",2):$P(%,"/",2),1:1)) S:$E(%)="." %=0_%,AMQQQXR=$E(%,1,5)+1 S:'$D(AMQQQXR) AMQQQXR=%+1 Q
 S %=$S($E(%)="F":2,$E(%)="N":1,$E(%,1,3)="UNK":2.1,$E(%,1,3)="UNS":2.2,1:"")
 I %'="" S AMQQQXR=%
 Q
 ;
