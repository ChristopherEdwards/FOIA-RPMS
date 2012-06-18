AMHLEP1 ; IHS/CMI/LAB - DEMO/APPTS ACTION 08 Aug 2007 1:27 PM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 Q
OTHER ;EP
 S (AMHPAT,AMHHDFN)=DFN
 D OTHER^AMHLEP2
 D RESET^AMHVRL K AMHHDFN
 Q
DUP ;EP called from protocol
 S AMHHDFN=DFN,AMHPAT=DFN
 D EP1^AMHLEDV
 S (DFN,AMHPAT)=AMHHDFN
 D RESET^AMHVRL K AMHHDFN
 Q
CONTACT(P,AMHY) ;EP; called by AMHV UPDATE CLIENT CONTACT protocol
 NEW DFN
 Q:'$G(P)
 S (DFN,AMHPAT)=P
 S AMHHDFN=AMHPAT
 ;
MENU ; -- menu of scheduling actions
 D FULL^VALM1
 D @AMHY
 D RESET^AMHVRL K AMHHDFN
 Q
 ;
1 ; -- add visit
 D ^AMHLEIN
 S AMHPATCE=1
 ;get defaults
 S (DFN,AMHPAT)=AMHHDFN
 D GETTYPE^AMHLE
 I $G(AMHPTYPE)="" D XIT Q
 D GETDATE^AMHLE
 I $G(AMHDATE)="" D XIT Q
 ;D GETVTYP
 S AMHVTYPE="R"
 I $G(AMHVTYPE)="" D XIT Q
 D ADD^AMHLEP2
 D XIT
 D EN2^AMHEKL
 Q
 ;
2 ; -- edit visit
 S AMHDET="S"
 D ^AMHLEIN
 S (AMHPAT,DFN)=AMHHDFN
 S AMHPATCE=1
 ;get defaults
 D GETTYPE^AMHLE
 I $G(AMHPTYPE)="" D XIT Q
 D GETDATE^AMHLE
 I $G(AMHDATE)="" D XIT Q
 S AMHPAT=DFN,AMHLOC=""
 D EN^AMHRLKUP
 I '$G(AMHR) D XIT Q
 I $P(^AMHREC(AMHR,0),U,34) W !!,"This is a group encounter.  You must edit this group visit through the Group",!,"Form Data Entry menu option.",! D PAUSE^AMHLEA,XIT Q
 I $$EHR^AMHUTIL(AMHR) D EHRE^AMHEHR D PAUSE^AMHLEA,XIT Q
 I $P($G(^AMHREC(AMHR,11)),U,12)]"",$O(^AMHREC(AMHR,31,0)) D
 .W !!,"The progress note has been electronically signed.  You will not be able to edit the note.",!,"You will be able to edit the other visit items when you press enter to continue.",! D PAUSE^AMHLEA
 D EDIT^AMHLEE
 S (AMHPAT,DFN)=AMHHDFN
 D XIT
 D EN2^AMHEKL
 Q
 ;
3 ; -- display visit
 D ^AMHLEIN
 S (AMHPAT,DFN)=AMHHDFN
 S AMHPATCE=1
 D GETDATE^AMHLE
 I $G(AMHDATE)="" D XIT Q
 S AMHPAT=DFN,AMHLOC=""
 D EN^AMHRLKUP
 I '$G(AMHR) D XIT Q
 D ^AMHDVD
 S (AMHPAT,DFN)=AMHHDFN
 D REGULAR^AMHLEP2
 S AMHZDO=1
 D OTHER^AMHLEP2
 D EN2^AMHEKL
 K AMHZDO
 Q
 ;
4 ; -- soap update
 D ^AMHLEIN
 S (AMHPAT,DFN)=AMHHDFN
 S AMHPATCE=1
 D GETDATE^AMHLE
 I $G(AMHDATE)="" D XIT Q
 S AMHPAT=DFN,AMHLOC=""
 D EN^AMHRLKUP
 I '$G(AMHR) D XIT Q
 I $P(^AMHREC(AMHR,0),U,34) W !!,"This is a group encounter.  You must edit this group visit through the Group",!,"Form Data Entry menu option.",! D PAUSE^AMHLEA,XIT Q
 I $$EHR^AMHUTIL(AMHR) D EHRE^AMHEHR D PAUSE^AMHLEA,XIT Q
 I $P($G(^AMHREC(AMHR,11)),U,12)]"",$O(^AMHREC(AMHR,31,0)) W !!,"You cannot edit this note, it has been electronically signed." D PAUSE^AMHLEA,XIT Q
 S AMHACTN=2
 S DA=AMHR,DR="[AMH EDIT SOAP/CC]",DIE="^AMHREC(" D CALLDIE^AMHLEIN
 D REGULAR^AMHLEP2
 D OTHER^AMHLEP2
 D PCCLINK^AMHLEA
 D EN2^AMHEKL
 Q
5 ; -- delete visit
 ;add code to not allow delete unless they have the key
 I '$D(^XUSEC("AMHZ DELETE RECORD",DUZ)) W !!,"You do not have the security access to delete a Visit.",!,"Please see your supervisor or program manager.",! D PAUSE^AMHLEP2,XIT Q
 D ^AMHLEIN
 S (AMHPAT,DFN)=AMHHDFN
 S AMHPATCE=1
 D FULL^VALM1 W:$D(IOF) @IOF
 D GETDATE^AMHLE
 I $G(AMHDATE)="" D XIT Q
 S AMHPAT=DFN,AMHLOC=""
 D EN^AMHRLKUP
 I '$G(AMHR) D XIT Q
 I $$EHR^AMHUTIL(AMHR) D EHRE^AMHEHR D PAUSE^AMHLEA,XIT Q
 I $P($G(^AMHREC(AMHR,11)),U,12)]"",'$D(^XUSEC("AMHZ DELETE SIGNED NOTE",DUZ)),$O(^AMHREC(AMHR,31,0)) D  Q
 .W !!,"You cannot delete this record, the note has been electronically signed.",!,"Please see your supervisor or program manager." D PAUSE^AMHLEP2,XIT Q
 D DEL^AMHLEE
 D EN2^AMHEKL
 Q
6 ; -- print encounter form
 D ^AMHLEIN
 S (AMHPAT,DFN)=AMHHDFN
 S AMHPATCE=1
 D FULL^VALM1 W:$D(IOF) @IOF
 D GETDATE^AMHLE
 I $G(AMHDATE)="" D XIT Q
 S AMHPAT=DFN,AMHLOC=""
 D EN^AMHRLKUP
 I '$G(AMHR) D XIT Q
 K AMHEFT
 ;W !! S DIR(0)="S^F:Full Encounter Form;S:Suppressed Encounter Form;B:Both a Suppressed & Full;T:2 copies of the Suppressed;E:2 copies of the Full"
 ;S DIR("A")="What type of form do you want to print"
 ;S DIR("B")=$S($P(^AMHSITE(DUZ(2),0),U,23)]"":$P(^AMHSITE(DUZ(2),0),U,23),1:"B") K DA D ^DIR K DIR
 D FORMDIR^AMHLEFP(AMHR)
 I $D(DIRUT) D XIT Q
 S AMHEFT=Y
 S AMHACTN=5
 S XBRC="COMP^AMHLEFP",XBRP="^AMHLEFP2",XBNS="AMH",XBRX="XIT^AMHLEFP"
 D ^XBDBQUE
 D XIT
 D EN2^AMHEKL
 S (AMHPAT,DFN)=AMHHDFN
 Q
 ;
7 ; -- EHR visit
 S AMHDET="S"
 D ^AMHLEIN
 S (AMHPAT,DFN)=AMHHDFN
 D GETDATE^AMHLE
 I $G(AMHDATE)="" D XIT Q
 S AMHPAT=DFN,AMHLOC=""
 S AMHEHR=1 D EN^AMHRLKUP K AMHEHR
 I '$G(AMHR) W !,"There are no EHR created visits on that date." D XIT Q
 D EDITEHR^AMHLEE
 S (AMHPAT,DFN)=AMHHDFN
 D XIT
 D EN2^AMHEKL
 K AMHEHR
 Q
 ;
8 ; -- TIU NOTE
 S AMHDET="S"
 D ^AMHLEIN
 S (AMHPAT,DFN)=AMHHDFN
 D GETDATE^AMHLE
 I $G(AMHDATE)="" D XIT Q
 S AMHPAT=DFN,AMHLOC=""
 D EN^AMHRLKUP K AMHEHR
 I '$G(AMHR) W !,"There are no EHR created visits on that date." D XIT Q
 D TIU^AMHEHR
 S (AMHPAT,DFN)=AMHHDFN
 D XIT
 D EN2^AMHEKL
 K AMHEHR
 Q
 ;
9 ;EP - called from protocol to sign visit
 ;list visits for this patient since the esig start date
 ;select visit
 ;display visit
 ;do you wish to edit?  if so, edit
 ;d esig^amhesig
 D FULL^VALM1
 S AMHDET="S"
 D ^AMHLEIN
 S (AMHPAT,DFN)=AMHHDFN
 S AMHPATCE=1
 NEW D,AMHRRECS,X,V,AMHD
 ;gather all visits w/o signature from D to DT
 S AMHD=$$DATE^AMHESIG()
 S AMHRCNT=0 F  S AMHD=$O(^AMHREC("AF",AMHPAT,AMHD)) Q:AMHD'=+AMHD  D
 .S V=0 F  S V=$O(^AMHREC("AF",AMHPAT,AMHD,V)) Q:V'=+V  D
 ..I $P($G(^AMHREC(V,11)),U,12)]"" Q  ;already signed
 ..Q:$$EHR^AMHUTIL(V)  ;EHR VISIT
 ..Q:$P(^AMHREC(V,0),U,34)  ;GROUP
 ..S X=$$ESIG^AMHESIG(V)
 ..I 'X Q  ;doesn't need signed
 ..S AMHRCNT=AMHRCNT+1,AMHRRECS(AMHRCNT)=V
 ..Q
 I AMHRCNT=0 W !!,"There are no records with unsigned notes that need to be signed.",! D PAUSE^AMHLEP2,XIT Q
 D DISPRECS
 W ! S DIR(0)="NO^1:"_AMHRCNT_":0",DIR("A")="Which record do you want to display" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No Records selected to display." D PAUSE^AMHLEP2,XIT Q
 I '$D(AMHRRECS(+Y)) W !,"Invalid selection!!" G SELECT
 S AMHR=AMHRRECS(+Y)
 ;display record
 D ^AMHDVD
 S (AMHPAT,DFN)=AMHHDFN
E9 ;edit?
 W !!
 S DIR(0)="Y",DIR("A")="Do you wish to edit this record",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D ESIG9 Q
 I 'Y D ESIG9 Q
 ;edit record
 S AMHDATE=$P($P(^AMHREC(AMHR,0),U),".")
 D EDIT^AMHLEE
 S (AMHPAT,DFN)=AMHHDFN
 D XIT
 D EN2^AMHEKL
 Q
ESIG9 ;
 S AMHACTN=2
 D OTHER^AMHLEP2
 D PCCLINK^AMHLEA
 D XIT
 D EN2^AMHEKL
 Q
GETVTYP ;
 S DIR(0)="S^R:Regular Visit;I:Intake;B:Abbreviated Version of Regular Visit;C:Info/Contact;N:No Show;A:A/SA Encounter"
 S DIR("A")="Enter Visit Type",DIR("B")="R" K DA D ^DIR K DIR
 I $D(DIRUT) S AMHVTYPE="" Q
 S AMHVTYPE=Y,AMHVT=Y(0)
 Q
XIT ;
 K AMHR,AMHLOC,AMHPATCE,AMHDATE,AMHDET,AMHRCNT,AMHRRECS,D,V,AMHRIEN,AMHP,AMHR0,AMHRCTR,AMHPG
 Q
HEAD ;
 I 'AMHPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT="" Q
HEAD1 ;
 S AMHPG=AMHPG+1
 W:$D(IOF) @IOF
 W !,AMHDASH
 W !?13,"Behavioral Health visits for ",$P(^DPT(AMHPAT,0),U)
 W !,AMHDASH
 W !," #",?7,"PROVIDER",?18,"LOC",?23,"DATE",?33,"ACT",?37,"CONT",?42,"PATIENT",?55,"PROB",?63,"NARRATIVE",!,AMHDASH
 Q
SELECT ;
 W ! S DIR(0)="NO^1:"_AMHRCNT_":0",DIR("A")="Which record do you want to display" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No Records selected to display." D PAUSE^AMHLEIN Q
 I '$D(AMHRRECS(+Y)) W !,"Invalid selection!!" G SELECT
 S AMHR=AMHRRECS(+Y)
 Q
 ;
DISPRECS ;display visits for selection by user
 S (AMHPG,AMHRCTR,AMHRIEN)=0
 D HEAD
 S AMHRCTR="",AMHCNTR=0
 F  S AMHRCTR=$O(AMHRRECS(AMHRCTR),-1) Q:AMHRCTR'=+AMHRCTR  S AMHRIEN=AMHRRECS(AMHRCTR),AMHR0=^AMHREC(AMHRIEN,0) D
 .S AMHCNTR=AMHCNTR+1
 .I $Y>(IOSL-1) D HEAD Q:$D(AMHQUIT)
 .W !,AMHCNTR,?5,$E($$PPNAME^AMHUTIL(AMHRIEN),1,12)
 .W:$P(AMHR0,U,4) ?18,$S($P(^AUTTLOC($P(AMHR0,U,4),0),U,7)]"":$P(^(0),U,7),1:$E($P(^AUTTLOC($P(AMHR0,U,4),0),U),1,4))
 .;W:$P(AMHR0,U,5) ?23,$E($P(^AUTTCOM($P(AMHR0,U,5),0),U),1,10)
 .W ?23,$$DATE^AMHVRL($P($P(AMHR0,U),"."))
 .W ?34,$S($P(AMHR0,U,6)]"":$P(^AMHTACT($P(AMHR0,U,6),0),U),1:""),?37,$S($P(AMHR0,U,7)]"":$E($P(^AMHTSET($P(AMHR0,U,7),0),U),1,4),1:"")
 .I $P(AMHR0,U,8)]""  D
 ..I $P(AMHR0,U,4),$D(^AUPNPAT($P(AMHR0,U,8),41,$P(AMHR0,U,4))) W ?42,$P(^AUTTLOC($P(AMHR0,U,4),0),U,7)," ",$P(^AUPNPAT($P(AMHR0,U,8),41,$P(AMHR0,U,4),0),U,2) Q
 ..I $D(^AUPNPAT($P(AMHR0,U,8),41,DUZ(2))) W ?42,$P(^AUTTLOC(DUZ(2),0),U,7)," ",$P(^AUPNPAT($P(AMHR0,U,8),41,DUZ(2),0),U,2)
 .E  W ?42,"-----"
 .S AMHP=$O(^AMHRPRO("AD",AMHRIEN,0)) I AMHP="" W ?55,"No Problems recorded." Q
 .W ?55,$P(^AMHPROB($P(^AMHRPRO(AMHP,0),U),0),U) W:$P(^AMHRPRO(AMHP,0),U,4) ?63,$E($P(^AUTNPOV($P(^AMHRPRO(AMHP,0),U,4),0),U),1,15)
 .Q
 Q
 ;
HDR ; -- print header
 NEW X
 S X=IOUON_$$PAD($$SP(10)_"PATIENT VISITS"_$$SP(8)_$$NOW,77)_IOUOFF
 D MSG^AMHVU(X,1,0,0)
 D MSG^AMHVU($$SP(10)_$$CONFID^AMHVU("Patient"),0,0,0)
 D MSG^AMHVU($$NAME_$$SP(5)_$$HRCN,1,0,0)
 D MSG^AMHVU($$REPEAT^XLFSTR("_",80),1,1,0)
 Q
 ;
NOW() ; -- returns readable now
 Q $$FMTE^XLFDT($$NOW^XLFDT,1)
 ;
NAME() ; -- returns printable name
 Q $$VAL^XBDIQ1(9000001,DFN,.01)
 ;
HRCN() ; -- returns chart # for this facility
 Q "#"_$P($G(^AUPNPAT(DFN,41,+DUZ(2),0)),U,2)
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
 ;
CHOICE ;;
 ;; 1. ADD PATIENT VISIT
 ;; 2. EDIT PATIENT VISIT
 ;; 3. DISPLAY PATIENT VISIT
 ;; 4. EDIT SOAP ON A VISIT RECORD
 ;; 5. DELETE PATIENT VISIT
 ;; 6. PRINT ENCOUNTER FORM
