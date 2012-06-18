AMHLEA ; IHS/CMI/LAB - ADD NEW CHR ACTIVITY RECORDS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
 ;add new records
 ;get all items for a record, check record, file record
 ;if not complete record, issue warning and delete record
ADDR ;EP
 D FULL^VALM1
 I '$D(AMHDATE) W !!,"Date not entered." H 5 Q
 S AMHQUIT=0,AMHACTN=1
 I '$G(AMHADPTV) K AMHPAT
 I AMHDET="S" D ADDSCR Q
 ;I $G(AMHADPTV) D GETVTYP
 ;I '$G(AMHADPTV) S AMHVTYPE="R"
 S AMHVTYPE="R"
 ;I AMHVTYPE="B" S AMHVTYPE="R"
 ;I AMHVTYPE="" K AMHVTYPE W !,"Visit type is required!" G EXIT
 ;I AMHVTYPE="C" D IC^AMHLEIC D EXIT Q
 ;I AMHVTYPE="N" D NS^AMHLENS1 D EXIT Q
 D HEADER
 S APCDOVRR=""
 I '$D(AMHPATCE) K AMHPAT
 W !,"Creating new record..." K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE,DIC("DR")="1111////1" D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE Q
 S AMHR=+Y,DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 S DA=AMHR,DIE="^AMHREC(",DR=$S(AMHVTYPE="A":"[AMHASA ADD RECORD]",$G(AMHADPTV):"[AMH ADD RECORD]",1:"[AMH ADD NON-PATIENT RECORD]") D CALLDIE^AMHLEIN
 I $D(Y)!('$D(^AMHRPROV("AD",AMHR))) W !!,"Incomplete record!! Deleting record!!" D DEL G EXIT
 D ^AMHLEPOV
 I '$D(^AMHRPRO("AD",AMHR))!('$D(^AMHRPROV("AD",AMHR))) W !!,"Incomplete record!! Deleting record!!" D DEL G EXIT
 S DA=AMHR,DIE="^AMHREC(",DR=$S(AMHVTYPE="A":"[AMH ADD RECORD 2 ASA]",1:"[AMH ADD RECORD 2]") D CALLDIE^AMHLEIN
 I $D(Y) W !!,"Incomplete record!! Deleting record!!" D DEL G EXIT
 S AMHOKAY=0 D RECCHECK^AMHLE2 I AMHOKAY W !,"Incomplete record!! Deleting record!!"  D DEL G EXIT
 W ! S DIE="^AMHREC(",DR="8101",DA=AMHR D CALLDIE^AMHLEIN
 I $G(AMHADPTV),AMHVTYPE="R" D REGULAR^AMHLEP2
 ;I $P(^AMHREC(AMHR,0),U,2)="C"!($P($G(^AMHREC(AMHR,91)),U)="Y") D CDST
 I $P(^AMHREC(AMHR,0),U,8)]"" D SUIC,OTHER
 I $P(^AMHREC(AMHR,0),U,8) D ESIG^AMHESIG(AMHR)
 D PCCLINK
 D EXIT
 Q
ADDNS ;EP
 D FULL^VALM1
 I '$D(AMHDATE) W !!,"Date not entered." H 5 Q
 S AMHQUIT=0,AMHACTN=1
 S APCDOVRR=1
 D ADDR^AMHLENS
 D EXIT
 Q
ADDSCR ;screenman mode
 S APCDOVRR=""
 I '$D(AMHPATCE) K AMHPAT
 D FULL^VALM1
 I '$D(AMHDATE) W !!,"Date not entered." H 5 Q
 S AMHQUIT=0,AMHACTN=1
 ;I $G(AMHADPTV) D GETVTYP
 ;I '$G(AMHADPTV) S AMHVTYPE="R"
 ;I AMHVTYPE="" K AMHVTYPE W !,"Visit type is required!" G EXIT
 ;I AMHVTYPE="N" D ADDR^AMHLENS D EXIT Q
 S AMHVTYPE="R"
 K DIC S DIC(0)="EL",DIC="^AMHREC(",DLAYGO=9002011,DIADD=1,X=AMHDATE,DIC("DR")=".02///"_AMHPTYPE_";.03///^S X=DT;.19////"_DUZ_";.33////"_AMHVTYPE_";.28////"_DUZ_";.22///A;.21///^S X=DT"_";1111////1"
 K DD,DO,D0 D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1 W !!,$C(7),$C(7),"Behavioral Health Record is NOT complete!!  Deleting Record.",! D PAUSE Q
 ;update multiple of user last update/date edited
 S AMHR=+Y
 S DIE="^AMHREC(",DA=AMHR,DR="5100///NOW",DR(2,9002011.5101)=".02////^S X=DUZ" D ^DIE K DIE,DA,DR
 I $G(AMHADPTV)=1 D:'$D(AMHPATCE) GETPAT D:'$G(AMHPAT) DEL,EXIT Q:'$G(AMHPAT)  S DA=AMHR,DR=".08////"_AMHPAT,DIE="^AMHREC(" D CALLDIE^AMHLEIN
 S DA=AMHR,DIE="^AMHREC(",DR=".02///"_AMHPTYPE_$S($$GETLOC^AMHLEIN(DUZ(2),AMHPTYPE):";.04///`"_$$GETLOC^AMHLEIN(DUZ(2),AMHPTYPE),1:"")_$S($$GETCOMM^AMHLEIN(DUZ(2),AMHPTYPE):";.05///`"_$$GETCOMM^AMHLEIN(DUZ(2),AMHPTYPE),1:"")
 S DR=DR_$S($$GETCLN^AMHLEIN(DUZ(2),AMHPTYPE):";.25///`"_$$GETCLN^AMHLEIN(DUZ(2),AMHPTYPE),1:"")
 S DR=DR_";.11///"_$$GETAWI^AMHLEIN(DUZ(2))_$S($$GETTOC^AMHLEIN(DUZ(2)):";.07///`"_$$GETTOC^AMHLEIN(DUZ(2)),1:"")
 D ^DIE I $D(Y) W !!,"Error updating record......" H 5
 K DR,DA,DIE
 D GETPROV I '$$PPINT^AMHUTIL(AMHR) W !,"No PRIMARY PROVIDER entered!! - Required element" D DEL,EXIT Q
 ;
ADD1 ;
 I AMHVTYPE="R" S DA=AMHR,DDSFILE=9002011,DR=$S($G(AMHADPTV):"[AMH ADD RECORD]",1:"[AMH ADD NON-PAT RECORD]") D ^DDS
 ;I AMHVTYPE="A" S DA=AMHR,DDSFILE=9002011,DR="[AMHASA ADD RECORD]" D ^DDS
 ;I AMHVTYPE="B" S AMHVTYPE="R",DA=AMHR,DDSFILE=9002011,DR=$S($G(AMHADPTV):"[AMHB ADD RECORD]",1:"[AMH ADD NON-PAT RECORD]") D ^DDS
 ;I AMHVTYPE="I"!(AMHVTYPE="P") S DA=AMHR,DDSFILE=9002011,DR="[AMHVT ADD RECORD]" D ^DDS
 ;I AMHVTYPE="C" S DA=AMHR,DDSFILE=9002011,DR="[AMH ADD CASE TRACKING REC]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 ;CHECK RECORD
 D CHECK
 I AMHZDEL D EXIT Q
 I AMHZED G ADD1
 ;I $G(AMHADPTV),(AMHVTYPE="I"!(AMHVTYPE="P")) D INTAKE^AMHLEP4
 I $G(AMHADPTV),AMHVTYPE="R" D REGULAR^AMHLEP2
 ;I $G(AMHADPTV),AMHVTYPE="C" D REGULAR^AMHLEP2
 I $G(AMHERROR) W !!,$C(7),$C(7),"PLEASE EDIT THIS RECORD!!",!!
 ;I $P(^AMHREC(AMHR,0),U,2)="C"!($P($G(^AMHREC(AMHR,91)),U)="Y") D CDST
 I $G(AMHADPTV) D SUIC,OTHER
 I $G(AMHADPTV) D PCCLINK
 ;I '$G(AMHADPTV) D ESIG^AMHESIG(AMHR)
 D EXIT
 Q
 ;
INDS(R) ;is this a initial or a discharge
 I '$G(R) Q 0
 I $P(^AMHREC(R,0),U,32)]"" Q 1
 Q 0
PRIMPROB(R) ;EP
 I '$G(R) Q ""
 NEW X S X=$O(^AMHRPRO("AD",R,0))
 I 'X Q ""
 Q $P(^AMHRPRO(X,0),U)
GETVTYP ;
 I AMHDET="S" S DIR(0)="S^R:Regular Visit;B:Abbreviated Version of Regular Visit;C:Info/Contact;N:No Show;A:A/SA Encounter"
 I AMHDET="R" S DIR(0)="S^R:Regular Visit;C:Info/Contact;N:No Show;A:A/SA Encounter"
 S DIR("A")="Enter Visit Type",DIR("B")="R" KILL DA
 D ^DIR KILL DIR
 I $D(DIRUT) S AMHVTYPE="" Q
 S AMHVTYPE=Y,AMHVT=Y(0)
 Q
CDST ;EP
 ;create record in CDMIS Staging file
 ;I '$$INDS(AMHR),$D(^AMHRCDST("B",AMHR)) D CDSTDEL Q
 I $P($G(^AMHREC(AMHR,91)),U)'="Y" Q
 I $D(^AMHRCDST("B",AMHR)) W !!,"There is already a initial/discharge entry for this visit.",!,"Editing existing data...." H 2 S AMHCDR=$O(^AMHRCDST("B",AMHR,0)) G CDST1
 W !!,"Creating Initial Chemical Dependency data record..." H 1
 D ^XBFMK S DIC="^AMHRCDST(",DIC(0)="AEMQ",DIADD=1,DLAYGO=9002011.06,X=AMHR K DD,DO D FILE^DICN K DIADD,DLAYGO,DD,DO,D0,DIC
 I Y=-1 W !!,$C(7),$C(7),"Notify supervisor....error in creating Initial Staging record.." D PAUSE Q
 S AMHCDR=+Y
CDST1 K DIADD,DLAYGO D ^XBFMK
 S DA=AMHCDR,DIE="^AMHRCDST(",DR=".02////"_AMHPAT_";.03////"_$$PRIMPROB(AMHR)_";.04////"_DT_";.05////"_DUZ_";.19////"_$P(^AMHREC(AMHR,0),U,32) D ^DIE
 I $D(Y) W !!,$C(7),$C(7),"Notify supervisor....error in creating Initial Staging record.." D PAUSE D ^XBFMK Q
 S DA=AMHCDR,DDSFILE=9002011.06,DR="[AMH ENTER/EDIT STAGING TOOL]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 D ^XBFMK
 Q
CDSTDEL ;
 W !!,"There is a staging tool entry for this visit and this visit",!,"is not an INITIAL, REOPEN, TRAN/DISC/CLOSE or FOLLOW UP.",!
 S DIR(0)="Y",DIR("A")="Do you want to delete this staging tool entry",DIR("B")="N" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:'Y
 S DA=$O(^AMHRCDST("B",AMHR,0)),DIK="^AMHRCDST(" D ^DIK
 Q
SUIC ;EP - is this a suicide visit?  IF so, pop into suicide form
 Q:'$G(AMHPAT)
 NEW X,G,Y S (X,Y,G)=0 F  S X=$O(^AMHRPRO("AD",AMHR,X)) Q:X'=+X  S Y=$P(^AMHRPRO(X,0),U),Y=$P(^AMHPROB(Y,0),U) I Y=39!(Y=40)!(Y=41)!(Y="V62.84") S G=1
 Q:'G
 W !!,"You have entered a diagnosis relating to Suicide.  ",!
 W !,"IHS Suicide Forms should be filled out for all Suicide Ideations with Plan",!,"and Intent, for all Suicide Attempts and for all Completed Suicides.",!
 S DIR(0)="Y",DIR("A")="Would you like to add/review the IHS Suicide forms for this patient",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 Q:$D(DIRUT)
 Q:'Y
 S (DFN,AMHLEAP)=AMHPAT
 ;D EN^XBNEW("EN^AMHLESF","DFN;AMHPAT")
 D EN^AMHLESF
 S AMHPAT=AMHLEAP
 S DFN=AMHLEAP
 Q
OTHER ;EP - collect other data if patient related
 S AMHFIRST=0
 D FULL^VALM1
OTHERN ;
 I AMHFIRST G OTHERO
 K AMHXX
 S AMHANS=""
 S AMHXX=$$ESIG^AMHESIG(AMHR)
 I '$G(AMHXX) D  I $P(AMHXX,U,4),AMHANS G OTHER
 .W !!,$P(AMHXX,U,3),!
 .I '$P(AMHXX,U,4) D PAUSE Q
 .S DIR(0)="Y",DIR("A")="Do you wish to enter a SOAP/Progress Note",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 .Q:$D(DIRUT)
 .S AMHANS=Y Q:'Y
 .S DIE="^AMHREC(",DR=3101,DA=AMHR D ^DIE K DA,DIE,DR
 I AMHXX D ESIGGFI^AMHESIG(AMHR)
 S AMHFIRST=AMHFIRST+1
OTHERO ;
 W @IOF,!!!?20,"*******  OTHER INFORMATION  *******",!!
 D RMENU
 S DIR("B")=9,DIR(0)="NO^1:9",DIR("A")="Choose one of the above" D ^DIR K DIR ;S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=9
 S AMHSELE=+Y D OTHER1
 G OTHERN
OTHER1 ;
 I AMHSELE'=6,'$G(AMHPAT) W $C(7),"You MUST Identify the Patient first!!" S AMHPAT="" D GETPAT Q:'AMHPAT
 W !
 D @AMHSELE
 Q
GETPROV ;get providers
 I '$G(AMHADPTV) W:$D(IOF) @IOF W !!!!!!!
 E  W !!!
 K DIR,DIC,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR("B")=$P(^VA(200,DUZ,0),U),DIR(0)="9002011.02,.01O",DIR("A")="                    Enter PRIMARY PROVIDER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S X=+Y,DIC("DR")=".02////"_$G(AMHPAT)_";.03////"_AMHR_";.04///PRIMARY",DIC="^AMHRPROV(",DIC(0)="MLQ",DIADD=1,DLAYGO=9002011.02 K DD,DO D FILE^DICN K DIC,DA,DO,DD,D0,DG,DH,DI,DIW,DIU,DIADD,DIE,DQ,DLAYGO
 I Y=-1 W !!,"Creating Primary Provider entry failed!!!",$C(7),$C(7) H 2
 Q
GETPAT ;EP
 D ^XBFMK
 S AMHC=0
GETPAT1 I $G(AMHDET)="S" W:$D(IOF)&(AMHC=0) @IOF W !!!!!!!!?20,"TYPE THE PATIENT'S HRN, NAME, SSN OR DOB" S DIC("A")="                    Patient:  "
 S AMHPAT=""
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DLAYGO,DIADD
 I Y<0 K AMHC Q
 S AMHPAT=+Y
 S X=AMHPAT D ^AMHPEDIT I '$D(X) S AMHC=AMHC+1 G GETPAT1
 W !?25,"Ok" S %=1 D YN^DICN I %'=1 S AMHPAT="" K AMHC Q
 I AMHPAT,'$$ALLOWP^AMHUTIL(DUZ,AMHPAT) D NALLOWP^AMHUTIL D PAUSE G GETPAT
 K AMHC
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
RMENU ;EP - called form AMHLEA
 W:AMHACTN'=1 !
 W !,"Update, add or append any of the following data"
 W !!,?5,"1). Update any of the following information:"
 W !,?10,"Designated Providers, Patient Flag"
 W !,?5,"2). Patient Case Open/Admit/Closed Data"
 W !,?5,"3). Personal History Information"
 W !?5,"4). Appointments (Scheduling System)"
 W !?5,"5). Treatment Plan Update"
 W !?5,"6). Print an Encounter Form"
 W !?5,"7). Add/Update/Print Intake Document"
 W !?5,"8). Add/Update Suicide Forms"
 W !,?5,"9). None of the Above (Quit)"
 Q
HEADER ;EP
 W:$D(IOF) @IOF
 W !,AMHDASH
 W !,"Date of Service:  ",$$FTIME^VALM1(AMHDATE),!,AMHDASH
 Q
PCCLINK ;EP -PCC LINK
 D PCCLINK^AMHLE2
 Q
 ;
EXIT ;CLEAN UP AND EXIT
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER^AMHLEL
 S VALMCNT=AMHRCNT
 D HDR^AMHLE
 K AMHV,AMHF,AMHDR,AMHR,AMHQUIT,AMHRDEL,AMHV,AMHVDLT,AMHNAME,AMHPTSV,AMHX,AMHERROR,AMHR0,APCDPKG,APCDV,AMHNONE,AMHOKAY,AMHOTH,AMHSHIGH
 K X,Y,Z,I
 Q
1 ;EP
 D CLEAR^VALM1
 D FULL^VALM1
 I '$D(^AMHPATR(AMHPAT)) S DIC="^AMHPATR(",DIC(0)="L",DLAYGO=9002011.55,X="`"_AMHPAT D ^DIC I Y=-1 D ^XBFMK W !!,"FAILED TO ADD PATIENT TO BH PATIENT DATA FILE" Q
 S DA=AMHPAT,DDSFILE=9002011.55,DR="[AMH PATIENT RELATED DATA]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S AMHQUIT=1 K DIMSG Q
 Q
2 ;
 D EP^AMHLCD
 D FULL^VALM1
 Q
3 ;
 D PHX^AMHLE3
 Q
6 ;print encounter form
 I $G(AMHR) S %=AMHR,%1=$G(AMHPAT) D EN^XBNEW("PEF^AMHLE3","%;%1") Q
 S AMHNOLOG=1
 D ^AMHLEFP
 K AMHNOLOG
 Q
4 ;scheduling system
 D APPT^AMHVRL2(AMHPAT)
 Q
5 ;treatment Plan
 D EP1^AMHLETP(AMHPAT)
 Q
7 ;intake
 I $G(AMHR),$P(^AMHREC(AMHR,0),U,8)="" W !!,"This is not a patient related encounter.  Use ID to update an Intake document." D PAUSE^AMHLEA Q
 I $G(AMHR) D
 .I $P(^AMHREC(AMHR,0),U,34) W !!,"You cannot add/update an intake on a visit created in a group.",! D PAUSE^AMHLEA Q
 .D EP1^AMHLEIV(AMHR,AMHPAT)
 Q
8 ;suicide forms
 I $G(AMHR),$P(^AMHREC(AMHR,0),U,8)="" W !!,"This is not a patient related encounter.  Use SFR to update suicide forms." D PAUSE^AMHLEA Q
 I $G(AMHR) D
 .I $P(^AMHREC(AMHR,0),U,34) W !!,"You cannot add/update a suicide form on a visit created in a group.",! D PAUSE^AMHLEA Q
 .S DFN=$P(^AMHREC(AMHR,0),U,8) D EN^AMHLESF
 .Q
 Q
CHECK ;EP
 S AMHZDEL=0,AMHZED=0
 S AMHOKAY=0 D RECCHECK^AMHLE2 Q:'AMHOKAY
 W !!,"Incomplete record!!"
 S DIR(0)="Y",DIR("A")="Do you wish to edit this record",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I Y S AMHZED=1 Q
 Q:$G(AMHACTN)'=1
 W !!,"Deleting record." D DEL
 S AMHZDEL=1
 Q
