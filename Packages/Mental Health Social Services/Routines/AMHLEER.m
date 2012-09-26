AMHLEER ; IHS/CMI/LAB - EDIT A RECORD ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**2**;JUN 18, 2010;Build 23
 ;
 D GETDATE
 I AMHDATE="" W !!,"No Date entered!" D EOJ Q
 D GETLOC
 D GETPAT
 D RECLKUP
 I '$G(AMHR) D EOJ Q
 D EDIT
 D EOJ
 Q
GETDATE ; GET DATE OF ENCOUNTER
 W !
 S AMHDATE=""
 S DIR(0)="DO^:"_DT_":EPT",DIR("A")="Enter ENCOUNTER DATE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 S %DT="ET" D ^%DT G:Y<0 GETDATE
 I Y>DT W "  <Future dates not allowed>",$C(7),$C(7) K X G GETDATE
 K AMHODAT
 S AMHDATE=Y
 ;
 Q
GETPAT ; GET PATIENT
 S AMHPAT=""
 S DIC("A")="Enter PATIENT (if known, otherwise press ENTER): ",DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DR,DA
 Q:Y<0
 S AMHPAT=+Y
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
 Q
 ;
GETLOC ;get location of encounter
 S AMHLOC=""
 S DIC("A")="Enter LOCATION OF ENCOUNTER (if known, otherwise press ENTER): ",DIC="^AUTTLOC(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 Q:Y<0
 S AMHLOC=+Y
 Q
EDIT ;
 S AMHPAT=$P(^AMHREC(AMHR,0),U,8)
 S AMHACTN=2
 S DIADD=1,DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR K DIADD
 S DR=$S(AMHPAT:"[AMH EDIT RECORD]",1:"[AMH ADD NON-PAT RECORD]"),DA=AMHR,DDSFILE=9002011 D ^DDS I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ** NOTIFY PROGRAMMER **" S AMHQUIT=1 K DIMSG Q
 I $P(^AMHREC(AMHR,0),U,8)]"" D OTHER^AMHLEA
 S AMHERROR=0 D RECCHECK^AMHLE2 I AMHERROR D PAUSE^AMHLEA
 D PCCLINK^AMHLEA
 Q
 ;
RECLKUP ;
 D ^AMHRLKUP
 Q
EOJ ; END OF JOB
 K AMHPROV,AMHDATE,AMHPAT,AMHODAT,AMHR
 Q
TEXT ;
 ;;BH Data Entry Module
 ;;
 ;;************************
 ;;* Update BH Records *
 ;;************************
 ;;
 Q
 ;
PL ;EP - called from SDE to update the problem list
 D FULL^VALM1
 W !,"Problem List updates must be attached to a visit. If you are updating the "
 W !,"Problem List in the context of a patient visit select the appropriate existing"
 W !,"visit and then update the Problem List. If you are updating the Problem List "
 W !,"outside of the context of a patient visit, first create a chart review visit "
 W !,"and then update the Problem List."
 I AMHRCNT=0 W !,"There are no visits to select." D PAUSE^AMHLEA D XIT^AMHLEE Q
 K DIR S DIR(0)="N^1:"_AMHRCNT_":0",DIR("A")="Select record to associate the Problem List update to" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No record selected." G XIT^AMHLEE
 S AMHR1=+Y I 'AMHR1 K VALMY,XQORNOD W !,"No record selected." G XIT^AMHLEE
 S AMHR=^TMP("AMHVRECS",$J,"IDX",AMHR1,AMHR1) I 'AMHR K AMHRDEL,AMHR D PAUSE^AMHLEA D XIT^AMHLEE Q
 I '$D(^AMHREC(AMHR,0)) W !,"Not a valid BH RECORD." K AMHRDEL,AMHR D PAUSE^AMHLEA D XIT^AMHLEE Q
DGSECDS ;
 I '$P(^AMHREC(AMHR,0),U,8) W !!,"This is not a patient visit." D PAUSE^AMHLEA,XIT^AMHLEE Q
 S AMHPAT=$P(^AMHREC(AMHR,0),U,8)
 S AMHLOC=$P(^AMHREC(AMHR,0),U,4)
 D PTSEC^AMHUTIL2(.AMHRESU,AMHPAT,1)
 I '$G(AMHRESU(1)) G PL1
 I $G(AMHRESU(1))=3!($G(AMHRESU(1))=4)!($G(AMHRESU(1))=5) D DISPDG^AMHLE,PAUSE^AMHLEA,XIT^AMHLEE Q
 D DISPDG^AMHLE
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue to select this record",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I 'Y D XIT^AMHLEE Q
 K AMHRESU
 D NOTICE^DGSEC4(.AMHRESU,AMHPAT,,3)
PL1 ;
 D START^AMHBPL(AMHR)
 D XIT^AMHLEE
 Q
