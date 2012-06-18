AMHLEDV ; IHS/CMI/LAB - ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
START ;
 W !!,"This option has been disabled." H 4 Q
 D FULL^VALM1
 ;D EN^AMHEKL
 D ^AMHLEIN
 W:$D(IOF) @IOF
 W !!,"This option is used to duplicate a patient visit that occurred on a different",!,"day.  The user selects a visit, enters a new date, and then the visit",!,"is copied to the new date.",!!
 W !,"You must first identify the patient and the visit to duplicate.",!
GETPAT ;EP
 D ^XBFMK
 S AMHC=0
 I $G(AMHPAT) G GETDATE
GETPAT1 W !!!?20,"TYPE THE PATIENT'S HRN, NAME, SSN OR DOB" S DIC("A")="                    Patient:  "
 S AMHPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 D XIT Q
 S AMHPAT=+Y
 I AMHPAT,'$$ALLOWP^AMHUTIL(DUZ,AMHPAT) D NALLOWP^AMHUTIL D PAUSE^AMHLEA G GETPAT1
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2
 W !?25,"Ok" S %=1 D YN^DICN I %'=1 S AMHPAT="" K AMHC Q
GETDATE ;EP
 S AMHDATE=""
 S DIR(0)="DO^::EP",DIR("A")="Enter PREVIOUS DATE OF ENCOUNTER (if known, otherwise press ENTER)" KILL DA D ^DIR KILL DIR
 I $D(DUOUT) D XIT Q
 S AMHDATE=Y
GETPROV ;
 S DIC=200,DIC(0)="AEMQ",DIC("A")="Enter PROVIDER of SERVICE: " D ^DIC K DIC,DA
 I Y=-1 G GETDATE
 S AMHPROV=+Y
GETVISIT ;
 I '$D(^AMHREC("C",AMHPAT)) W $C(7),$C(7),!,"Patient has no visits to duplicate" D PAUSE,XIT Q
 ;gather visits for this provider in array AMHPATV
 K AMHPATV
 S AMHX=0 F  S AMHX=$O(^AMHREC("C",AMHPAT,AMHX)) Q:AMHX'=+AMHX  D
 .I AMHDATE]"",$P($P(^AMHREC(AMHX,0),U),".")'=AMHDATE Q
 .Q:'$$ALLOWVI^AMHUTIL(DUZ,AMHX)
 .I $$PPINT^AMHUTIL(AMHX)'=AMHPROV Q
 .S AMHPATV(AMHX)=""
 .Q
 I '$D(AMHPATV) W $C(7),$C(7),!,"Patient has no visits to meeting your criteria to duplicate.",! D PAUSE,XIT Q
EN ; EP -- main entry point for AMH UPDATE ACTIVITY RECORDS
 S VALMCC=1
 D EN^VALM("AMH DE LIST PATIENTS VISITS")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP -- header code
 S VALMHDR(1)=$TR($J(" ",80)," ","-")
 D GETHRN
 S VALMHDR(2)="Visits for "_$P(^DPT(AMHPAT,0),U)_"   HRN:  "_AMHHRN
 S VALMHDR(3)="Provider:  "_$P(^VA(200,AMHPROV,0),U)
 S VALMHDR(4)=$TR($J(" ",80)," ","-")
 K AMHHRN
 S VALMHDR(5)=" #  PRV VISIT DATE          CONTACT   LOC     ACT   PROB    NARRATIVE"
 Q
 ;
INIT ;EP -- init variables and list array
 S VALMSG="QU - Quit ?? for more actions + next screen - prev screen"
 D GATHER^AMHLEDV1 ;gather up all records for display
 S VALMCNT=AMHRCNT
 Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K AMHRCNT,^TMP("AMHPATV",$J)
 K VALMCC,VALMHDR
 Q
 ;
XIT ;kill variables and quit
 D CLEAR^VALM1
 D EN^AMHEKL
 K ^TMP("AMHPATV",$J)
 K AMHPAT,AMHDATE,AMHPROV,AMHPATV,AMHX,AMHC,AMHNEWD,AMHR1
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
EXPND ; -- expand code
 Q
 ;
GETHRN ;
 S AMHHRN=""
 I AMHPAT]""  D
 .I $D(^AUPNPAT(AMHPAT,41,AMHPAT)) S AMHHRN=$P(^AUTTLOC(AMHPAT,0),U,7)_" "_$P(^AUPNPAT(AMHPAT,41,AMHPAT,0),U,2) Q
 .I $D(^AUPNPAT(AMHPAT,41,DUZ(2))) S AMHHRN=$P(^AUTTLOC(DUZ(2),0),U,7)_" "_$P(^AUPNPAT(AMHPAT,41,DUZ(2),0),U,2) Q
 .S AMHHRN="<none>"
 E  S AMHHRN="  --  "
 Q
SELECT ;select record, get new date, confirm, duplicate
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G XIT
 S AMHR1=$O(VALMY(0)) I 'AMHR1 K AMHR1,VALMY,XQORNOD W !,"No record selected." G XIT
 S AMHR1=^TMP("AMHPATV",$J,"IDX",AMHR1,AMHR1) I 'AMHR1 K AMHRDEL,AMHR1 D PAUSE D XIT Q
 I '$D(^AMHREC(AMHR1,0)) W !,"Not a valid BH RECORD." K AMHRDEL,AMHR1 D PAUSE D XIT Q
 D FULL^VALM1
 W !,"The following visit will be duplicated:",!
 W !,$TR($J(" ",80)," ","-"),! W ^TMP("AMHPATV",$J,$O(VALMY(0)),0),!!!
 S AMHNEWD=""
NEWDATE ;get new date
 D FULL^VALM1 W:$D(IOF) @IOF
 S DIR(0)="D^::EP",DIR("A")="Enter NEW Visit Date" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) W !,$C(7),$C(7),"New date not entered" D BACK
 S AMHNEWD=Y
DUPLICAT ;
 W !,"Duplicating visit to ",$$FMTE^XLFDT(AMHNEWD)," HOLD ON..."
 S AMHPTYPE=$P(^AMHREC(AMHR1,0),U,2)
 S APCDOVRR=""
 S AMHQUIT=0,AMHACTN=1
CREATE ;
 W !,"Creating new record..." K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHNEWD,DIC("DR")=".03///^S X=DT;.19////"_DUZ_";.21///^S X=DT;.22///A;.28////"_DUZ_";1111////1"
 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE Q
 ;update multiple of user last update/date edited
 S AMHR=+Y
 S DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 S DA=AMHR,DR=".08////"_AMHPAT,DIE="^AMHREC(" D CALLDIE^AMHLEIN
 ;set up DIE string and 4 slash
 F X=2,4,5,6,7,8,9,25,26,29,31,33 S $P(^AMHREC(AMHR,0),U,X)=$P(^AMHREC(AMHR1,0),U,X)
 S DA=AMHR,DIK="^AMHREC(" D IX1^DIK
POVS ;
 S AMHX=0 F  S AMHX=$O(^AMHRPRO("AD",AMHR1,AMHX)) Q:AMHX'=+AMHX  D
 .S DIC="^AMHRPRO(",X=+^AMHRPRO(AMHX,0),DIC("DR")=".02////"_AMHPAT_";.03////"_AMHR_";.04////"_$P(^AMHRPRO(AMHX,0),U,4),DIADD=1,DLAYGO=9002011.01,DIC(0)="L" K DD,DA,D0,DO D FILE^DICN K DIADD,DIC,DR,DA,DD,D0,DLAYGO
 .I Y=-1 W !!,"Creating pov FAILED!" H 5 Q
 ;copy all povs from 1 visit to another
PROVS ;
 S AMHX=0 F  S AMHX=$O(^AMHRPROV("AD",AMHR1,AMHX)) Q:AMHX'=+AMHX  D
 .S DIC="^AMHRPROV(",X=+^AMHRPROV(AMHX,0),DIC("DR")=".02////"_AMHPAT_";.03////"_AMHR_";.04////"_$P(^AMHRPROV(AMHX,0),U,4),DIADD=1,DLAYGO=9002011.02,DIC(0)="L" K DD,DA,D0,DO D FILE^DICN K DIADD,DIC,DR,DA,DD,D0,DLAYGO
SM ;
 S DA=AMHR,AMHDATE=$P(^AMHREC(AMHR,0),U),DDSFILE=9002011,DR="[AMH ADD RECORD]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 ;CHECK RECORD
 S AMHOKAY=0 D RECCHECK^AMHLE2 I AMHOKAY W !!,"Incomplete record!! Deleting record!!" D DEL^AMHLEA,EXIT Q
 I $G(AMHERROR) W !!,$C(7),$C(7),"PLEASE EDIT THIS RECORD!!",!!
 D OTHER^AMHLEA
 D PCCLINK^AMHLE2
 D XIT
 Q
DISPLAY ;EP-DISPLAY AN ACTIVITY RECORD
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G XIT
 S AMHR=$O(VALMY(0)) I 'AMHR K AMHR,VALMY,XQORNOD W !,"No record selected." G XIT
 S AMHR=^TMP("AMHPATV",$J,"IDX",AMHR,AMHR) I 'AMHR K AMHRDEL,AMHR D PAUSE D XIT Q
 I '$D(^AMHREC(AMHR,0)) W !,"Not a valid BH RECORD." K AMHRDEL,AMHR D PAUSE D XIT Q
 D FULL^VALM1
DISP ;
 NEW AMHPAT,AMHPROV,AMHDATE
 D ^AMHDVD
 D XIT
 Q
BACK ;
 S VALMBCK="R"
 D TERM^VALM0
 D GATHER^AMHLEDV1
 S VALMCNT=AMHRCNT
 D HDR
 K AMHNEWD
 Q
EP1 ;EP
 I '$G(AMHPAT) W "No patient defined." Q
 D FULL^VALM1
 ;D EN^AMHEKL
 D ^AMHLEIN
 W:$D(IOF) @IOF
 W !!,"This option is used to duplicate a patient visit that occurred on a different",!,"day.  The user selects a visit, enters a new date, and then the visit",!,"is copied to the new date.",!!
 W !,"You must first identify the patient and the visit to duplicate.",!
 G GETDATE
RBLK(V,L) ;EP - right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
