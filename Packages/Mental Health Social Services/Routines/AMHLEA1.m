AMHLEA1 ; IHS/CMI/LAB - ADD NEW CHR ACTIVITY RECORDS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;add new records
 ;get all items for a record, check record, file record
 ;if not complete record, issue warning and delete record
BEGIN ;add adm record
 D GETTYPE
 I AMHPTYPE="" D EXIT Q
 D GETDATE
 I AMHDATE="" D EXIT Q
 D CREATE
 D EXIT
 Q
GETTYPE ;EP
 S AMHPTYPE=""
 S DIR(0)="S^M:MENTAL HEALTH DEFAULTS;S:SOCIAL SERVICES DEFAULTS;C:CHEMICAL DEPENDENCY or ALCOHOL/SUBSTANCE ABUSE;O:OTHER",DIR("A")="Which set of defaults do you want to use in Data Entry" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S AMHPTYPE=Y
 Q
GETDATE ;EP - GET DATE OF ENCOUNTER
 W !!
 S AMHDATE="",DIR(0)="DO^:"_DT_":EPTX",DIR("A")="Enter ENCOUNTER DATE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S AMHDATE=Y
 Q
CREATE ;EP
 S AMHACTN=1
 S APCDOVRR=""
 K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE Q
 S AMHR=+Y,DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 D GETPROV
 S DA=AMHR,DIE="^AMHREC(",DR="[AMH ADD ADM RECORD]" D CALLDIE^AMHLEIN
 I $D(Y)!('$D(^AMHRPROV("AD",AMHR))) W !!,"Incomplete record!! Deleting record!!" D DEL G EXIT
 D GETPOV
 I '$D(^AMHRPRO("AD",AMHR))!('$D(^AMHRPROV("AD",AMHR))) W !!,"Incomplete record!! Deleting record!!" D DEL G EXIT
 S AMHOKAY=0 D RECCHECK^AMHLE2 I AMHOKAY W !,"Incomplete record!! Deleting record!!"  D DEL G EXIT
 W ! S DIE="^AMHREC(",DR="8101",DA=AMHR D CALLDIE^AMHLEIN
 ;S X=$$ESIG^AMHESIG(AMHR)
 ;I X D ESIGGFI^AMHESIG
 D EXIT
 Q
EXIT ;
 D ^XBFMK
 D EN^XBVK("AMH")
 Q
DEL ;EP
 I $$IINTAKE^AMHLEDEL(AMHR) W !!,"This visit has an Initial Intake with Updates, it can not be deleted",!,"until the update documents have been deleted." D PAUSE Q
 S AMHVDLT=$P(^AMHREC(AMHR,0),U,16)
 S AMHRDEL=AMHR
 D EN^AMHLEDEL
 W !,"Record deleted." D PAUSE
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
GETPROV ;get providers
 K DIR,DIC,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR("B")=$P(^VA(200,DUZ,0),U),DIR(0)="9002011.02,.01O",DIR("A")="Enter PRIMARY PROVIDER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S X=+Y,DIC("DR")=".02////"_$G(AMHPAT)_";.03////"_AMHR_";.04///PRIMARY",DIC="^AMHRPROV(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.02 K DD,DO D FILE^DICN K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 I Y=-1 W !!,"Creating Primary Provider entry failed!!!",$C(7),$C(7) H 2
 Q
GETPOV ;
 D EN^XBNEW("EP^AMHLEA1","AMH*")
 Q
EP ;EP  -  ask for POV and file each
 I 'AMHR W !!,"NO RECORD DEFINED!!"  Q
 I '$D(^AMHREC(AMHR)) W !!,"NO RECORD!!"  Q
 S APCDOVRR=""
 D POV
 D CHK
 Q
CHK ;
 Q:$D(^AMHRPRO("AD",AMHR))
 W !!,$C(7),$C(7),"At least ONE POV is REQUIRED!!"
 S DIR(0)="Y",DIR("A")="Do you wish to exit and delete this record",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $G(Y)=0 G EP
 Q
POV ;
 S DIC("A")=$S($G(AMHGROUP):"Enter another Problem (POV): ",'$D(^AMHRPRO("AD",AMHR)):"Enter PRIMARY Problem-POV: ",1:"Enter ANOTHER Problem-POV: "),DIC("S")="I '$P(^(0),U,13)",DIC="^AMHPROB(",DIC(0)="AEMQ",DIC("B")=99
 W ! D ^DIC
 I Y=-1 D ^XBFMK Q
 S AMHPOV=$P(Y,U,2),AMHPOVP=+Y
 ;call FILE^DICN to file this POV
FILE ;
 D ^XBFMK
 K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^AMHRPRO(",DLAYGO=9002011.01,DIADD=1,X=AMHPOVP,DIC("DR")="" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 D ^XBFMK W !!,$C(7),$C(7),"Behavioral Health POV failed!!  Notify Site Manager." Q
 S AMHRPRO=+Y,AMHPOVR=^AMHRPRO(AMHRPRO,0)
 D ^XBFMK
 S DIE("NO^")="",DA=AMHRPRO,DIE="^AMHRPRO(",DR=".02////"_$G(AMHPAT)_";.03////"_AMHR_";.04  Provider Narrative.....:" S DIE("NO^")="" D CALLDIE^AMHLEIN
 S AMHPOVR=^AMHRPRO(AMHRPRO,0)
 I $P(AMHPOVR,U,4)="" S X=$E($P(^AMHPROB($P(AMHPOVR,U),0),U,2),1,79),X=$TR(X,";"," "),DIE="^AMHRPRO(",DR=".04///"_X,DA=AMHRPRO S DIE("NO^")="" D CALLDIE^AMHLEIN
 I $D(Y) D ^XBFMK W !!,$C(7),$C(7),"DIE failed when updating POV" D PAUSE^AMHLEA Q
 Q
