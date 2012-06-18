AMHLEA2 ; IHS/CMI/LAB - ADD NEW CHR ACTIVITY RECORDS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;add new records
 ;get all items for a record, check record, file record
 ;if not complete record, issue warning and delete record
BEGIN ;add adm record
 W:$D(IOF) @IOF
 W !!,"Update Case Tracking Visit Record",!
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
 D GETPAT
 I '$G(AMHPAT) W !!,"No Patient Selected." D EXIT Q
 K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE,DIC("DR")=".03////"_DUZ_";.19////"_DT_";.21////"_DT_";.22////A;.08////"_$G(AMHPAT)_";1111////1" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE Q
 S AMHR=+Y,DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 D GETPROV
 S DA=AMHR,DDSFILE=9002011,DR="[AMH ADD CASE TRACKING REC]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 I '$D(^AMHRPRO("AD",AMHR))!('$D(^AMHRPROV("AD",AMHR))) W !!,"Incomplete record!! Deleting record!!" D DEL G EXIT
 S AMHOKAY=0 D RECCHECK^AMHLE2 I AMHOKAY W !,"Incomplete record!! Deleting record!!"  D DEL G EXIT
 D EXIT
 Q
GETPAT ;EP
 D ^XBFMK
 S AMHC=0
GETPAT1 ;
 S AMHPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 K AMHC Q
 S AMHPAT=+Y
 S X=AMHPAT D ^AMHPEDIT I '$D(X) S AMHC=AMHC+1 G GETPAT1
 W !?25,"Ok" S %=1 D YN^DICN I %'=1 S AMHPAT="" K AMHC Q
 K AMHC
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
