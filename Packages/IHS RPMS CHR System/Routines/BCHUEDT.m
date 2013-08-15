BCHUEDT ; IHS/CMI/LAB - EDIT A CHR RECORD ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;IHS/CMI/LAB - patch 6 9/21/98 added ability to enter a 
 ;IHS/CMI/LAB - patch 12 protected against bad narrative pointer
 ;registered patient on editing a record
 ;
 ;
 ;edit a chr record, called from protocol
 ;
EN ;EP
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) W !,"No records selected." G XIT
 S BCHR=$O(VALMY(0)) I 'BCHR K BCHR,VALMY,XQORNOD W !,"No record selected." G XIT
 S BCHR=BCHVRECS("IDX",BCHR,BCHR) I 'BCHR K BCHRDEL,BCHR D PAUSE^BCHUTIL1 D XIT Q
 I '$D(^BCHR(BCHR,0)) W !,"Not a valid CHR RECORD." K BCHRDEL,BCHR D PAUSE^BCHUTIL1 D XIT Q
 D FULL^VALM1
DISP ;EP
 D EN^BCHUDSP
 S BCHUEDT=1,BCHRWDEL="" ;in edit
 S BCHR0=^BCHR(BCHR,0)
 S DFN=$P(BCHR0,U,4)
 S BCHTYPE="" D TYPE I BCHTYPE="" D XIT Q
 D RECCHECK^BCHUADD1
 I $D(BCHERROR),'BCHRWDEL W !!,$C(7),$C(7),"PLEASE RE-EDIT THE RECORD AND CORRECT THIS ERROR!!!",! H 5
 D XIT
 Q
TYPE ; get type of data to edit
 S BCHTYPE=""
 W !!
 S DIR(0)="SO^1:Patient Demographic Data;2:All Other Record Data",DIR("A")="EDIT Which Data Item" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:Y=""
 S BCHTYPE=+Y
 D @BCHTYPE
 Q
XIT ;eof
 ;do event protocol call
 ;S BCHEV("TYPE")="E"
 ;set up bchev with all pcc ptrs
 ;wipe out pcc ptrs in chr record
 ;S BCHEV("VFILES",9000010)=$P(^BCHR(BCHR,0),U,15)
 ;S X=0 F  S X=$O(^BCHR(BCHR,31,X)) Q:X'=+X  S F=$P(^BCHR(BCHR,31,X,0),U),N=$P(^(0),U,2) I F,N S BCHEV("VFILES",F,N)=""
 ;K ^BCHR(BCHR,31)
 ;D PROTOCOL^BCHUADD1
REF ;
 I $G(BCHEN1) G EOJ
 S VALMBCK="R"
 D TERM^VALM0
 D GATHER^BCHUARL
 S VALMCNT=BCHRCNT
 D HDR^BCHUAR
EOJ K BCHR,BCHTYPE,BCHR0,BCHERROR,BCHC,BCHRPOV,DFN,BCHX,BCHUEDT,BCHRWDEL
 K BCHTYPE
 Q
 ;
1 ;PATIENT demographic
 ;WILL be different depending if patient pointer or other data
 I $P(^BCHR(BCHR,0),U,4)]"" D  Q
 .W !,"This is a REGISTERED Patient.  You cannot edit any of ",$S($P(^DPT($P(^BCHR(BCHR,0),U,4),0),U,2)="M":"his",1:"her")," demographic data.",!,"You may enter a different patient if this was entered in error.",!
 .S BCHODFN=DFN,DIE="^BCHR(",DA=BCHR,DR=".04" D ^DIE K DIE,DA,DR
 .S DFN=$P(^BCHR(BCHR,0),U,4)
 .Q:DFN=BCHODFN
 .;backfill pt ptr in CHR POV
 .S BCHX=0 F  S BCHX=$O(^BCHRPROB("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 ..S DIE="^BCHRPROB(",DA=BCHX,DR=".02////"_DFN,DITC=""
 ..D ^DIE
 ..K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 ..I $D(Y) W !,"error updating pov's with patient, NOTIFY PROGRAMMER" H 5
 ..Q
 .;backfill pt ptr in CHR EDUC
 .S BCHX=0 F  S BCHX=$O(^BCHRPED("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 ..S DIE="^BCHRPED(",DA=BCHX,DR=".02////"_DFN,DITC=""
 ..D ^DIE
 ..K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 ..I $D(Y) W !,"error updating educ's with patient, NOTIFY PROGRAMMER" H 5
 ..Q
 .Q
 ;IHS/CMI/LAB - PATCH 6 ADDED THESE LINES TO ALLOW ENTRY OF A 
 ;REGISTERED PATIENT ON EDIT
 W !!,"If this is a registered patient, enter their name or chart number",!,"otherwise type an ""^"" to update a non-registered patient's data.",!! ;IHS/CMI/LAB added patch 6
 S DIE="^BCHR(",DA=BCHR,DR=".04" D ^DIE K DIE,DA,DR ;IHS/CMI/LAB added patch 6
 I $P(^BCHR(BCHR,0),U,4) S BCHXX=$P(^BCHR(BCHR,0),U,4) S DA=BCHR,DIE="^BCHR(",DR="1112///@;.04///@" D ^DIE K DA,DIE,DR S DIE="^BCHR(",DA=BCHR,DR=".04////"_BCHXX D ^DIE K DIE,DA,DR Q  ;IF ADDED A REAL PATIENT DELETE OUT NON-REG PATIENT
 S DA=BCHR,DIE=90002,DR=1112 D ^DIE K DA,DIE,DR,DIU,DIV
 I $P($G(^BCHR(BCHR,11)),U,12) S (BCHXX,DA)=$P($G(^BCHR(BCHR,11)),U,12),DR="[BCH EDIT NON REG PT]",DIE="^BCHRPAT(" D ^DIE K DA,DR,DIE D
 .S DA=BCHR,DIE=90002,DR="1112///@;.04///@" D ^DIE K DA,DIE,DR S DIE="^BCHR(",DA=BCHR,DR="1112////"_BCHXX D ^DIE K DIE,DA,DR
 K DR,DA,DDSFILE,DIC,DIE
 Q
2 ;EP - OTHER record data
 W !
 S DA=BCHR,DIE="^BCHR(",DR=".17////"_DT D ^DIE K DIE,DA,DIE
 S DA=BCHR,DDSFILE=90002,DR=$S('$G(BCHUABFO):"[BCHE1 ENTER CHR DATA (535)]",1:"[BCHEA1 ENTER CHR DATA (535)]") D ^DDS
 K DR,DA,DDSFILE,DIC,DIE
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG Q
 S DFN=$P(^BCHR(BCHR,0),U,4)
 Q:DFN=""
 ;backfill pt ptr in CHR POV
 S BCHX=0 F  S BCHX=$O(^BCHRPROB("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 .S DIE="^BCHRPROB(",DA=BCHX,DR=".02////"_DFN,DITC=""
 .D ^DIE
 .K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 .I $D(Y) W !,"error updating pov's with patient, NOTIFY PROGRAMMER" H 5
 .Q
 ;backfill pt ptr in CHR EDUC
 S BCHX=0 F  S BCHX=$O(^BCHRPED("AD",BCHR,BCHX)) Q:BCHX'=+BCHX  D
 .S DIE="^BCHRPED(",DA=BCHX,DR=".02////"_DFN,DITC=""
 .D ^DIE
 .K DIE,DA,DR,DIU,DIV,DIW,DIY,DITC
 .I $D(Y) W !,"error updating educ's with patient, NOTIFY PROGRAMMER" H 5
 .Q
 Q
DISPPOVS ;
 W !
 S (X,BCHC)=0 F  S X=$O(^BCHRPROB("AD",BCHR,X)) Q:X'=+X  S BCHC=BCHC+1,BCHRPOV(BCHC)=X D
 .S N=$P(^BCHRPROB(X,0),U,6) I N,$D(^AUTNPOV(N,0)) S N=$P(^AUTNPOV(N,0),U)
 .W !?2,BCHC,") ",$E($P(^BCHTPROB($P(^BCHRPROB(X,0),U),0),U),1,20),?29,$E($P(^BCHTSERV($P(^BCHRPROB(X,0),U,4),0),U),1,20),?52,$P(^BCHRPROB(X,0),U,5),?57,$E(N,1,21)
 .Q
 Q
EPOV ;edit an existing pov
 D DISPPOVS
 W ! S DIR(0)="N^1:"_BCHC_":",DIR("A")="Which One do you wish to EDIT" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 Q:'Y
 I '$D(BCHRPOV(BCHC)) W !!,"Invalid choice." Q
 S DA=BCHRPOV(Y),DIE="^BCHRPROB(",DR="[BCH EDIT POV]" D ^DIE K DIE,DA,DIU,DIV,DIY,DIW,DR
 I $D(Y) W !!,"ERROR ENCOUNTERED IN EDITING A POV" Q
 Q
APOV ;add a new pov
 W !!,"Adding a NEW POV...",!
 S DIE="^BCHR(",DR="[BCH ADD POV]",DA=BCHR D ^DIE K DIE,DA,DR,DIU,DIV,DIY,DIW
 I $D(Y) W !!,"NO POV ADDED!"
 Q
DPOV ;delete pov
 D DISPPOVS
 S DIR(0)="N^1:"_BCHC_":",DIR("A")="Which One do you wish to DELETE" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) Q
 Q:'Y
 I '$D(BCHRPOV(BCHC)) W !!,"Invalid choice." Q
 ;
 S DIR(0)="Y",DIR("A")="Are you sure you want to delete this POV",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 I 'Y W !,"Okay, not deleted." Q
 S DA=BCHRPOV(Y),DIK="^BCHRPROB(" D ^DIK W !,"POV DELETED" K DA,DIK Q
 Q
CP ;EP - CHANGE PROVIDER
 D FULL^VALM1
 S BCHOPROV=BCHPROV
 D GETPROV^BCHUAR
 I BCHPROV="" W !!,"No provider selected." S BCHPROV=BCHOPROV D PAUSE^BCHUTIL1
 S VALMBCK="R"
 D TERM^VALM0
 D GATHER^BCHUARL
 S VALMCNT=BCHRCNT
 D HDR^BCHUAR
 Q
CD ;EP - CHANGE DATE
 D FULL^VALM1
 S BCHODATE=BCHDATE
 D GETDATE^BCHUAR
 I BCHDATE="" W !!,"No new date selected." S BCHDATE=BCHODATE D PAUSE^BCHUTIL1
 S VALMBCK="R"
 D TERM^VALM0
 D GATHER^BCHUARL
 S VALMCNT=BCHRCNT
 D HDR^BCHUAR
 Q
CF ;EP - CHANGE FORM
 D FULL^VALM1
 I $G(BCHUABFO) K BCHUABFO W !,"Form changed to 535 Comprehensive." G CF1
 S BCHUABFO=1 W !,"Form changed to 535-1 Abbreviated."
CF1 D PAUSE^BCHUTIL1
 S VALMBCK="R"
 D TERM^VALM0
 D GATHER^BCHUARL
 S VALMCNT=BCHRCNT
 D HDR^BCHUAR
 Q
