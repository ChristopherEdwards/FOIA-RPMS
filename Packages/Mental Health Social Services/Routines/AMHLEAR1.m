AMHLEAR1 ; IHS/CMI/LAB - ACTIVITY RECORD FORM DATA ENTRY CREATE RECORD ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;loop and get patients until AMHNUM
CREATE ;create mhss record
 S AMHACTN=1 K AMHAWIXX
 W !!,"Creating new record " K DD,D0,DO,DIC,DA,DR S DIC("DR")="",DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE Q
 S (DA,AMHR)=+Y,DIE="^AMHREC(",DR="[AMH ADD ACT RECORD NO INTERACT]" D CALLDIE^AMHLEIN
 I $D(Y) W !!,"ERROR -- Incomplete record!! Deleting record!!" D DEL Q
PROV ;create provider entries
 S AMHX=0 F  S AMHX=$O(AMHPROV(AMHX)) Q:AMHX'=+AMHX  D
 .K DD,D0,DO,DIC,DA,DR S DIC="^AMHRPROV(",DIC(0)="EL",DLAYGO=9002011.02,DIADD=1,X=$P(AMHPROV(AMHX),U),DIC("DR")=".03////^S X=AMHR;.04///^S X=$P(AMHPROV(AMHX),U,2)" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,DO
 .I Y<0 W !!,"Creating provider record failed.!!  Notify site manager!",!!
POV ;create pov records
 S AMHX=0 F  S AMHX=$O(AMHPOV(AMHX)) Q:AMHX'=+AMHX  D
 .K DD,D0,DO,DIC,DA,DR S DIC="^AMHRPRO(",DIC(0)="EL",DLAYGO=9002011.01,DIADD=1,X=$P(AMHPOV(AMHX),U),DIC("DR")=".03////^S X=AMHR;.04///^S X=$P(AMHPOV(AMHX),U,2)" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,DO
 .I Y<0 W !!,"Creating pov visit failed.!!  Notify site manager!",!!
 S AMHOKAY=0 D RECCHECK^AMHLE2 I AMHOKAY W !,"Incomplete record!! Deleting record!!"  D DEL Q
 W !!?20,"***COMPLETED SUCCESSFUL ENTRY OF RECORD***",!!!!
 W ?25,"You may now enter a new Encounter Date",!
 W ?40,"OR",!
 W ?23,"You may '^' to discontinue Data Entry",!!
 Q
XIT ;clean up and exit
 K DIC,DR,DA,X,Y,DIU,DIU,D0,DO,DI
 K AMHHIT,AMHX
 Q
PAUSE ;
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
DEL ;
 I $$IINTAKE^AMHLEDEL(AMHR) W !!,"This visit has an Initial Intake with Updates, it can not be deleted",!,"until the update documents have been deleted." D PAUSE Q
 S AMHRDEL=AMHR
 D EN^AMHLEDEL
 D PAUSE
 Q
