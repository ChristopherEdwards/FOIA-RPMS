AMHLEGP1 ; IHS/CMI/LAB - GROUP FORM DATA ENTRY CREATE RECORD ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;loop and get patients until AMHNUM
 ;create mhss record calling DIE with [AMH CREATE RECORD]
START ;EP - called from AMHLEGP
 S (AMHQUIT,AMHHIT)=0
 F AMHLEGPI=1:1:AMHNUM D PROCESS Q:AMHQUIT
 D EXIT
 Q
PROCESS ;
 S AMHPAT=""
 W !
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 S AMHPAT=+Y
 I Y<0 D ERROR Q:AMHQUIT
 I +AMHPAT<0 G PROCESS
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
 W !?25,"Ok" S %=1 D YN^DICN G:%'=1 PROCESS
 S AMHPAT=+Y
 I AMHPAT,'$$ALLOWP^AMHUTIL(DUZ,AMHPAT) D NALLOWP^AMHUTIL D PAUSE^AMHLEA G PROCESS
 S AMHHIT=AMHHIT+1
CREATE ;create mhss record
 S AMHACTN=1
 W !!,"Creating new record for ",$P(^DPT(AMHPAT,0),U),"." K DD,D0,DO,DIC,DA,DR S DIC("DR")="",DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE,^XBFMK Q
 S (DA,AMHR)=+Y,AMHAWIXX="A",DIE="^AMHREC(",DR="[AMH ADD RECORD NO INTERACT]" D CALLDIE^AMHLEIN K AMHAWIXX
 I $D(Y) W !!,"ERROR -- Incomplete record!! Deleting record!!" D DEL Q
 S AMHVTYPE=$P(^AMHREC(AMHR,0),U,33)
PROV ;create provider entries
 S AMHX=0 F  S AMHX=$O(AMHPROV(AMHX)) Q:AMHX'=+AMHX  D
 .K DD,D0,DO,DIC,DA,DR S DIC="^AMHRPROV(",DIC(0)="EL",DLAYGO=9002011.02,DIADD=1,X=$P(AMHPROV(AMHX),U),DIC("DR")=".02////^S X=AMHPAT;.03////^S X=AMHR;.04///^S X=$P(AMHPROV(AMHX),U,2)" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,DO
 .I Y<0 W !!,"Creating provider record failed.!!  Notify site manager!",!!
POV ;create pov records
 S AMHX=0 F  S AMHX=$O(AMHPOV(AMHX)) Q:AMHX'=+AMHX  D
 .K DD,D0,DO,DIC,DA,DR S DIC="^AMHRPRO(",DIC(0)="EL",DLAYGO=9002011.01,DIADD=1,X=$P(AMHPOV(AMHX),U),DIC("DR")=".02////^S X=AMHPAT;.03////^S X=AMHR;.04////^S X=$P(AMHPOV(AMHX),U,2)" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,DO
 .I Y<0 W !!,"Creating pov record failed.!!  Notify site manager!",!!
 S AMHOKAY=0 D RECCHECK^AMHLE2 I AMHOKAY W !,"Incomplete record!! Deleting record!!"  D DEL Q
 D EP2^AMHLEPOV
CPT ;
 S AMHX=0 F  S AMHX=$O(AMHCPT(AMHX)) Q:AMHX'=+AMHX  D
 .K DD,D0,DO,DIC,DA,DR S DIC="^AMHRPROC(",DIC(0)="EL",DLAYGO=9002011.04,DIADD=1,X=$P(AMHCPT(AMHX),U),DIC("DR")=".02////^S X=AMHPAT;.03////^S X=AMHR" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,DO
 .I Y<0 W !!,"Creating cpt record failed.!!  Notify site manager!",!!
EDUC ;
 S AMHX=0 F  S AMHX=$O(AMHEDUC(AMHX)) Q:AMHX'=+AMHX  D
 .K DD,D0,DO,DIC,DA,DR S DIC="^AMHREDU(",DIC(0)="EL",DLAYGO=9002011.05,DIADD=1
 .S X=$P(AMHEDUC(AMHX),U),DIC("DR")=".02////^S X=AMHPAT;.03////^S X=AMHR;.04///"_$P(AMHEDUC(AMHX),U,2)_";.05///G;.06///"_$P(AMHEDUC(AMHX),U,3)_";.07///"_$P(AMHEDUC(AMHX),U,4)_";.08///4;1101///"_$P(AMHEDUC(AMHX),U,5)
 .D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,DO
 .I Y<0 W !!,"Creating PT ED record failed.!!  Notify site manager!",!!
 W !
SOAP ;
 W ! S DIE="^AMHREC(",DR=$S($P(^AMHSITE(DUZ(2),0),U,16):"3101;8101",1:"8101"),DA=AMHR D CALLDIE^AMHLEIN
 ;DO PCC LINK
 D PCCLINK^AMHLE2
 S AMHLEGP("RECS ADDED",AMHHIT)=AMHR
 Q
EXIT ;clean up and exit
 K DIC,DR,DA,X,Y,DIU,DIU,D0,DO,DI
 K AMHHIT,AMHX
 K DIR,X,Y,DIC,DR,DA,D0,DO,DIZ,D
 Q
ERROR ;
 W !!,$C(7),$C(7),"You have NOT completed entry of all of the ",AMHNUM," patients!!",!,"This means that you MUST enter each of the remaining visits individually,",!,"using ",AMHTIME\AMHNUM," minutes activity time for each patient.",!!!
 S DIR(0)="Y",DIR("A")="Are you sure you want to QUIT this group entry",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S AMHQUIT=1 Q
 I Y S AMHQUIT=1 Q
 Q
INFORM ;EP
 W:$D(IOF) @IOF
 D TERM^VALM0
 W !!,IORVON,"The GRP option will be deactivated in the next application release.",!,"Users are encouraged to begin utilizing the option GP Group Form Data",!,"Entry Using Group Definition.",IORVOFF
 D PAUSE
 W !!,"This is the GROUP Data Entry Option:  You will be asked to enter the total",!,"number of visits , the total Activity Time for ALL Patients listed on the",!,"Group Form,"
 W "and all other pertinent information required for a visit.",!!
 W "     .....You MUST complete ALL entries prior to leaving this option.....",!
 Q
XIT ;EP
 K AMHDATE,AMHLOC,AMHPROG,AMHPROV,AMHCOMM,AMHACT,AMHCONT,AMHPOVS,AMHPOVP,AMHC,AMHPOV,AMHNARR,AMHTIME,AMHNUM,AMHPOVP,AMHBEEP,AMHGOT,AMHLPCC,AMHVISIT,AMHLEGPI,AMHLEIN,AMHOKAY,AMHPAT,AMHQUIT,AMHREC,AMHDASH,AMHBT
 K AMHR,AMHACTN,AMHNUM,AMHCLN,AMHTOD,AMHLEGP,AMHPTYPE,APCDOVRR,AMHOL,AMHGROUP
 K AMHHRN,AMHL,AMHLPCCT,AMHR0,AMHTICL,AMHTNRQ,AMHTQ,AMHTTXT
 D KILL^AUPNPAT
 Q
PAUSE ;
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
DEL ;
 S AMHRDEL=AMHR
 D EN^AMHLEDEL
 D PAUSE
 Q
