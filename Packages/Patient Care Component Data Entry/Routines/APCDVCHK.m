APCDVCHK ; IHS/CMI/LAB - CHECK VISIT ;
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;
 ; APCDVSIT must equal the VISIT DFN to be checked.
 ; U must exist and be equal to "^".
 ;
START ;
 ;D EN1^APCDKMM ;for future use with X Linkage
 Q:'$D(^AUPNVSIT(APCDVSIT))
 S APCDVREC=^AUPNVSIT(APCDVSIT,0)
 Q:"EX"[$P(APCDVREC,U,7)
 S APCDVCLC=$P(APCDVREC,U,6)
 Q:APCDVCLC=""
 S APCDVCLC=$E($P(^AUTTLOC(APCDVCLC,0),U,10),5,6)
 I '$D(^AUPNVPOV("AD",APCDVSIT)) W !,"WARNING:  No purpose of visit entered for this visit!",!,$C(7)
 I '$D(^AUPNVPRV("AD",APCDVSIT)) W !,"WARNING:  No provider of service entered for this VISIT!",!,$C(7)
 I $P(APCDVREC,U,8)="",$P(APCDVREC,U,7)="A","I6TP"[$P(APCDVREC,U,3),APCDVCLC>0,APCDVCLC<50 W !,"WARNING:  No Clinic Type entered for this visit!",!,$C(7) S APCDNOCL=""
 I $P(APCDVREC,U,7)="H",$P(APCDVREC,U,3)'="C",'$D(^AUPNVINP("AD",APCDVSIT)) W !,"WARNING:  No V Hospitalization record has been created!",$C(7)
 I $P(APCDVREC,U,3)="C",'$D(^AUPNVCHS("AD",APCDVSIT)) W !,"WARNING:  No V CHS record has been created!",$C(7)
 I $P(APCDVREC,U,7)="H",$P(APCDVREC,U,3)'["CV" D ^APCDVCH
 S (APCDVC1,APCDVC2)=0 F APCDVCL=0:0 S APCDVC2=$O(^AUPNVPRV("AD",APCDVSIT,APCDVC2)) Q:APCDVC2=""  I $P(^AUPNVPRV(APCDVC2,0),U,4)="P" S APCDVC1=APCDVC1+1
 I APCDVC1=0 W !,"WARNING:  No primary provider entered for this visit!",!,$C(7)
 E  I APCDVC1>1 W !,"WARNING:  Multiple primary providers were entered for this visit!",!,$C(7) S APCDMPQ=0
 I $D(^AUPNVPRC("AD",APCDVSIT)),$P(APCDVREC,U,7)'="H" D CHKPRC
 I $$CLINIC^APCLV(APCDVSIT,"C")=30 D CHKER   ;IHS/CMI/GRL
 I "AOSCTR"[$P(^AUPNVSIT(APCDVSIT,0),U,7),$P(^APCCCTRL(DUZ(2),0),U,12)]"",$P($P(^AUPNVSIT(APCDVSIT,0),U),".")>$P(^APCCCTRL(DUZ(2),0),U,12) D CHKEHR
 ;above added for EHR and auditing of visits, d/e created
CHKH ;
 I $P(APCDVREC,U,7)="H",$P(APCDVREC,U,3)'="C" D CHKH1
 D CHKCHA
 K APCDVC1,APCDVC2,APCDVCL,APCDVCLC,APCDERR,APCD1,APCD2,APCDVCPV,APCDTS,APCDDS,APCDVREC,APCDDX,APCDOPDX,APCDDXP,APCDFOUN,APCDPX
 Q
 ;
CHKPRC ;check outpatient procedures vs. dx for priv. billing
 K APCDDXP S APCDDX=0 F  S APCDDX=$O(^AUPNVPOV("AD",APCDVSIT,APCDDX)) Q:APCDDX=""  S APCDDXP($P(^AUPNVPOV(APCDDX,0),U))=""
 K APCDOPDX S APCDPX=0 F  S APCDPX=$O(^AUPNVPRC("AD",APCDVSIT,APCDPX)) Q:APCDPX=""  S APCDOPDX=$P(^AUPNVPRC(APCDPX,0),U,5) I APCDOPDX]"" D CHKDXOP2
 Q
CHKDXOP2 ;
 K APCDFOUN F  S APCDDX=$O(APCDDXP(APCDDX)) Q:APCDDX=""  I APCDDX=APCDOPDX S APCDFOUN=1
 I '$D(APCDFOUN) W !,$C(7),"WARNING: Operation ",$P($$ICDOP^ICDCODE($P(^AUPNVPRC(APCDPX,0),U,1)),U,2)," Not for Diagnosis in V POV file!",!,"Notify your Supervisor or Correct!",!
 Q
 ;
CHKH1 ;
 ;NO LONGER NECESSARY WITH THE DATA WAREHOUSE EXPORT, PCC EXPORT NO LONGER USED
 Q:'$D(^AUPNVINP("AD",APCDVSIT))
 Q:'$D(^AUPNVPRV("AD",APCDVSIT))
 Q:'$D(^AUPNVPOV("AD",APCDVSIT))
 K DIR,DIRUT,DUOUT,DTOUT,X,Y
 S DIR(0)="Y",DIR("A")="Is this Hospitalization visit ready for export to Headquarters (coding complete)",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 W !,"This visit will be exported to the Data Warehouse."
 I Y=0 W !,"Don't forget to finalize the coding so this Hospitalization visit ",!,"can be exported.",! Q
 ;W !,"This Hospitalization Visit will now be considered complete and will be",!,"exported to Headquarters with your next regular PCC export!",!
 ;W !,"This visit will be exported to the Data Warehouse."
 S DIE="^AUPNVINP(",DA=$O(^AUPNVINP("AD",APCDVSIT,"")),DR=".15///@" D ^DIE
 Q
CHKEHR ;
 Q:$G(APCDCAF)="IN CAF"
 ;Q:'$D(^AUPNVPRV("AD",APCDVSIT))
 ;Q:'$D(^AUPNVPOV("AD",APCDVSIT))
 K DIR,DIRUT,DUOUT,DTOUT,X,Y
 S DIR(0)="Y",DIR("A")="Is coding complete for this visit (is all data entry completed)",DIR("B")=$P($G(^APCDSITE(DUZ(2),0)),U,29) D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S APCDYN="N"
 S APCDYN=Y
 W !!,"Please update the visit status for this visit.",! D UPDATE Q
 ;S DIE="^AUPNVSIT(",DA=APCDVSIT,DR="1111///R" D ^DIE K DIE,DA,R
 Q
CHKCHA ;
 Q:'$P($G(^APCDSITE(DUZ(2),0)),U,35)
CHA ;
 Q:DUZ("AG")'="I"
 Q:"ETC"[$P(APCDVREC,U,7)
 Q:"V"[$P(APCDVREC,U,3)
 Q:'$D(^AUPNVPRV("AD",APCDVSIT))
 Q:'$D(^AUPNVPOV("AD",APCDVSIT))
 S APCDRV("CHA")=0
 S (APCDRV(1),APCDRV(2))=0
 F  S APCDRV(2)=$O(^AUPNVPRV("AD",APCDVSIT,APCDRV(2))) Q:APCDRV(2)=""   D DISC
 ;check secondary providers
CHA2 ;
 Q:APCDRV("CHA")=0
 I '$D(^AUPNVTM("AD",APCDVSIT)) W !!,"WARNING:  COMMUNITY HEALTH NURSE RECORD - NO ACTIVITY TIME ENTERED",$C(7)
 K APCDRV
 Q
DISC ;
 D DISC200
 Q
DISC200 ;
 S APCDRV("AP")=$P(^AUPNVPRV(APCDRV(2),0),U,1),APCDRV("DISC")=""
 Q:'$D(^VA(200,APCDRV("AP")))
 S APCDRV("CHA DISC")=$$PROVCLSC^XBFUNC1(APCDRV("AP"))
 Q:APCDRV("CHA DISC")'=13&(APCDRV("CHA DISC")'=32)
 S APCDRV("CHA")=APCDRV("CHA")+1
 Q
CHKER ;IHS/CMI/GRL  Check for ER visit w/o V ER record
 K DIR,DA,X,Y
 Q:$D(^AUPNVER("AD",APCDVSIT))
 W !!,"WARNING ... Emergency Clinic visit with NO ER record!",$C(7),!
 S DIR(0)="Y",DIR("A")="Quit without entering ER Record"
 S DIR("A",1)="ER record with a minimum of Disposition and Departure date and time recommended."
 S DIR("A",2)=""
 S DIR("B")="N"
 D ^DIR K DIR
 I Y=1 Q
 I Y=0 S APCDMPQ=0 Q
 Q
 ;
UPDATE ;
 K DIC,DD,D0,DO
 S X=$$NOW^XLFDT,DIC="^AUPNVCA(",DIC(0)="L",DIADD=1,DLAYGO=9000010.45,DIC("DR")=".02////"_$P(^AUPNVSIT(APCDVSIT,0),U,5)_";.03////"_APCDVSIT_";.05////"_DUZ D FILE^DICN
 I Y=-1 W !!,"updating status failed" H 2 G UPDATEX
 K DIC,DD,D0,DIADD,DLAYGO
 S (APCDVCA,DA)=+Y
UPD1 ;
 D ^XBFMK
 S DA=APCDVCA,DIE="^AUPNVCA(",DR=".04//"_$S(APCDYN:"REVIEWED/COMPLETE",1:"INCOMPLETE") D ^DIE K DA,DIE,DR
R ;
 I 'APCDYN S DA=APCDVCA,DIE="^AUPNVCA(",DR=".06"_$S($P($G(^APCDSITE(DUZ(2),0)),U,32):"R",1:"") D ^DIE K DA,DIE,DR I $P($G(^APCDSITE(DUZ(2),0)),U,32),$P(^AUPNVCA(APCDVCA,0),U,6)="" G R
 D ^XBFMK
 S APCDCAR=$P(^AUPNVCA(APCDVCA,0),U,4)
 I APCDCAR="" W !!,"You must enter a status" G UPD1
 S DIE="^AUPNVSIT(",DA=APCDVSIT,DR=".13////"_DT_";1111////"_APCDCAR D ^DIE K DIE,DA,DR
 ;PUT CHART AUDIT NOTE HERE
 K DIR S DIR(0)="Y",DIR("A")="Do you want to update the Chart Audit Notes for this visit",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G UPDATEX
 I 'Y G UPDATEX
 I '$D(^AUPNCANT(APCDVSIT)) D ADDCANT
 I '$D(^AUPNCANT(APCDVSIT)) W !!,"adding entry to chart audit notes failed." H 3 G UPDATEX
 S DA=APCDVSIT,DIE="^AUPNCANT(",DR=1100 D ^DIE K DIE,DA,DR
 ;
UPDATEX ;
 K DIADD,DLAYGO
 D ^XBFMK
 K APCDCAR,APCDVCA
 Q
 ;
ADDCANT ;
 S ^AUPNCANT(APCDVSIT,0)=APCDVSIT_U_$P(^AUPNVSIT(APCDVSIT,0),U,5)
 S DA=APCDVSIT,DIK="^AUPNCANT(" D IX1^DIK
 Q
