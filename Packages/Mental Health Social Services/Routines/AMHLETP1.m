AMHLETP1 ; IHS/CMI/LAB - treatment plan update ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**1**;JUN 18, 2010;Build 8
 ;
HS ;EP - Display Patient Profile
 S AMHPAT=DFN
 I 'AMHPAT W !,"NO Patient selected!",! D PAUSE Q
 D ^AMHDPP
 D PAUSE
 D EXIT
 Q
ADD ;EP
 D FULL^VALM1
 I '$D(DFN) W !!,"Patient not entered." H 5 Q
 S AMHQUIT=0
 D HEADER
 W !,"Creating new Treatment Plan..."
 K DIR
 S DIR(0)="D^:"_":EP",DIR("A")="Enter Date Established" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) K DIR,AMHQUIT Q
 S X=Y
 K DD,D0,DO,DINUM,DIC,DA,DR S DIC(0)="EALMQ",DIC="^AMHPTXP(",DLAYGO=9002011.56,DIADD=1,DIC("DR")=".02////"_DFN D FILE^DICN K DIC,DR,DIE,DIADD,DLAYGO,X,D0
 I Y=-1,'$P($G(^AMHPTXP(AMHTP,0)),U,4),'$P($G(^AMHPTXP(AMHTP,0)),U,11) W !!,$C(7),$C(7),"Behavioral Health Treatment Plan is NOT complete!!  Deleting Record.",! D DEL Q
 S AMHTP=+Y
 D EDITTP
 S DFN=$P(^AMHPTXP(AMHTP,0),U,2)
 D EXIT
 Q
PART ;
 W !!?3,"Participants in the development of this plan:"
 I '$O(^AMHPTXP(AMHTP,17,0)) S AMHC=0 W "  None recorded" G FM12
 D EN^DDIOL($$REPEAT^XLFSTR("-",75),"","!?3")
 K AMHCM S X=0,AMHC=0 F  S X=$O(^AMHPTXP(AMHTP,17,X)) Q:X'=+X  D
 .S AMHC=AMHC+1,AMHCM(AMHC)=X
 .W !?2,AMHC,")  ",$P(^AMHPTXP(AMHTP,17,X,0),U,1),?40,$P(^AMHPTXP(AMHTP,17,X,0),U,2)
FM12 ;
 D EN^DDIOL("","","!")
 K DIR
 S DIR(0)="S^A:Add a Participant"_$S(AMHC:";E:Edit an Existing Participant;D:Delete a Participant",1:"")_";N:No Change"
 S DIR("A")="Which action",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G FM13
 I Y="N" S AMHDONE=1 G FM13
 S Y="FM"_Y
 D @Y
 G PART
FM13 ; 
 K Y
 Q
 ;
FME ;
 D EN^DDIOL("","","!")
 K DIR
 S DIR(0)="N^1:"_AMHC_":0",DIR("A")="Edit Which One" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 K DIC,DA,DR
 S DA=AMHCM(Y)
 S DA(1)=AMHTP,DIE="^AMHPTXP("_DA(1)_",17,",DR=".01;.02" D ^DIE K DIE,DA,DR
 Q
FMD ;
 D EN^DDIOL("","","!")
 K DIR
 S DIR(0)="N^1:"_AMHC_":0",DIR("A")="Delete Which One" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S DA=AMHCM(Y)
 S DA(1)=AMHTP,DIE="^AMHPTXP("_DA(1)_",17,",DR=".01///@" D ^DIE K DIE,DA,DR
 K DIC,DA,DR
 Q
FMA ;
 ;ADDING NEW
 S (AMHPTN,AMHPTREL)=""
 S DIR(0)="FO^3:30",DIR("A")="Enter the Participant Name" KILL DA D ^DIR KILL DIR
 I X="" Q
 I $D(DIRUT) Q
 S AMHPTN=Y
 S DIR(0)="FO^2:30",DIR("A")="Enter the Relationship to the Client" KILL DA D ^DIR KILL DIR
 I X="" Q
 I $D(DIRUT) Q
 S AMHPTREL=Y
 S DIE="^AMHPTXP("
 S DA=AMHTP
 S DR="1701///"_AMHPTN
 S DR(2,9002011.561701)=".02///"_AMHPTREL
 D ^DIE
 K DIE,DA,DR
 Q
 Q
EDITTP ;
 S DIE("NO^")=1,DA=AMHTP,DIE="^AMHPTXP(",DR="[AMH EDIT TX PLAN]" D CALLDIE^AMHLEIN
 ;I $D(Y),'$P($G(^AMHPTXP(AMHTP,0)),U,4) W !!,"Treatment Plan is NOT COMPLETE!!  Deleting Plan...",! D DEL Q
NRD ;
 W ! S DA=AMHTP,DR=".09Review Date..............",DIE="^AMHPTXP(" D CALLDIE^AMHLEIN
 S X=$P(^AMHPTXP(AMHTP,0),U,9)
 I X,X<$P(^AMHPTXP(AMHTP,0),U,1) W !!,"Next Review Date cannot be earlier than the date established." S DA=AMHTP,DR=".09///@",DIE="^AMHPTXP(" D CALLDIE^AMHLEIN G NRD
SC ;
 W ! S DA=AMHTP,DR=".05Concurring Supervisor....",DIE="^AMHPTXP(" D CALLDIE^AMHLEIN
 I $P(^AMHPTXP(AMHTP,0),U,5)="" G DC
SCD ;
 S DA=AMHTP,DR=".06Date Concurred...........",DIE="^AMHPTXP(" D CALLDIE^AMHLEIN
 S X=$P(^AMHPTXP(AMHTP,0),U,6)
 I X,X<$P(^AMHPTXP(AMHTP,0),U,1) W !!,"Date Concurred cannot be earlier than the date established." S DA=AMHTP,DR=".06///@",DIE="^AMHPTXP(" D CALLDIE^AMHLEIN G SCD
DC ;
 D PART
 W ! S DA=AMHTP,DR=".12Date Closed..............",DIE="^AMHPTXP(" D CALLDIE^AMHLEIN
 S X=$P(^AMHPTXP(AMHTP,0),U,12)
 I X,X<$P(^AMHPTXP(AMHTP,0),U,1) W !!,"Date Completed/Closed cannot be earlier than the date established." S DA=AMHTP,DR=".12///@",DIE="^AMHPTXP(" D CALLDIE^AMHLEIN G DC
 ;D EXIT
 Q
SHARE ;EP
 D EP^AMHLETPS
 D EXIT
 Q
EDITR ;EP
 K DIR S DIR(0)="N^1:"_AMHRCNT_":0",DIR("A")="Select BH Treatment Plan" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No treatment plan selected." G EXIT
 S AMHTPN=+Y I 'AMHTPN K AMHTP,VALMY,XQORNOD W !,"No treatment plan selected." G EXIT
 S AMHTP=$O(AMHPTP("IDX",AMHTPN,0)) I 'AMHTP K AMHTPDEL,AMHTP D PAUSE,EXIT Q
 S AMHTP=AMHPTP("IDX",AMHTPN,AMHTP) I 'AMHTP K AMHTP D PAUSE,EXIT Q
 I '$D(^AMHPTXP(AMHTP,0)) W !,"Not a valid TREATMENT PLAN." K AMHTPDEL,AMHTP D PAUSE,EXIT Q
 D FULL^VALM1
EDIT ;
 W:$D(IOF) @IOF
 D EDITTP
 S DFN=$P(^AMHPTXP(AMHTP,0),U,2)
 D EXIT
 Q
DISP ;EP
 K DIR S DIR(0)="N^1:"_AMHRCNT_":0",DIR("A")="Select BH Treatment Plan" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No treatment plan selected." G EXIT
 S AMHTPN=+Y I 'AMHTPN K AMHTP,VALMY,XQORNOD W !,"No treatment plan selected." G EXIT
 S AMHTP=$O(AMHPTP("IDX",AMHTPN,0)) I 'AMHTP K AMHTPDEL,AMHTP D PAUSE,EXIT Q
 S AMHTP=AMHPTP("IDX",AMHTPN,AMHTP) I 'AMHTP K AMHTP D PAUSE,EXIT Q
 I '$D(^AMHPTXP(AMHTP,0)) W !,"Not a valid TREATMENT PLAN." K AMHTPDEL,AMHTP D PAUSE,EXIT Q
 D FULL^VALM1
 W:$D(IOF) @IOF
REVCH ;
 S AMHPREV=""
 S DIR(0)="S^T:Treatment Plan Only;R:Treatment Plan REVIEWS Only;B:Both the Treatment Plan and Reviews",DIR("A")="What would you like to print",DIR("B")="T" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D PAUSE,EXIT Q
 S AMHPREV=Y
 I AMHPREV="T" G PB
 K AMHREVS,AMHREVP
 I AMHPREV="R",'$O(^AMHPTXP(AMHTP,41,0)) W !!,"There are no reviews on file to print." D PAUSE G REVCH
 ;display all reviews and have user choose
 S (X,AMHC)=0 F  S X=$O(^AMHPTXP(AMHTP,41,X)) Q:X'=+X  D
 .S AMHC=AMHC+1,AMHREVS(AMHC)=X
 .W !,?4,AMHC,")  ",$$FMTE^XLFDT($P(^AMHPTXP(AMHTP,41,X,0),U))
 .Q
 S AMHC=AMHC+1 W !?4,AMHC,")  ALL Reviews"
 K DIR
 S DIR(0)="L^1:"_AMHC,DIR("A")="Which Reviews would you like to Print",DIR("B")=AMHC KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G REVCH
 I Y[AMHC D   K AMHREVS G PB
 .F I=1:1:(AMHC-1) S AMHREVP(AMHREVS(I))=""
 S A=Y,C="" F I=1:1 S C=$P(A,",",I) Q:C=""  S J=AMHREVS(C) S AMHREVP(AMHREVS(C))=""
 K AMHREVS
PB ;print or browse
 W ! S DIR(0)="S^P:PRINT Output on Paper;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) D PAUSE,EXIT Q
 I $G(Y)="B" D BROWSE D EXIT Q
 D EN1^AMHLETPU
 D EXIT
 Q
BROWSE ;
 S AMHBROW=1 D VIEWR^XBLM("PRINT^AMHLETPP","Display of Treatment Plan") K AMHBROW
 Q
REV ;EP
 K DIR S DIR(0)="N^1:"_AMHRCNT_":0",DIR("A")="Select BH Treatment Plan" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No treatment plan selected." G EXIT
 S AMHTPN=+Y I 'AMHTPN K AMHTP,VALMY,XQORNOD W !,"No treatment plan selected." G EXIT
 S AMHTP=$O(AMHPTP("IDX",AMHTPN,0)) I 'AMHTP K AMHTPDEL,AMHTP D PAUSE,EXIT Q
 S AMHTP=AMHPTP("IDX",AMHTPN,AMHTP) I 'AMHTP K AMHTP D PAUSE,EXIT Q
 I '$D(^AMHPTXP(AMHTP,0)) W !,"Not a valid TREATMENT PLAN." K AMHTPDEL,AMHTP D PAUSE,EXIT Q
 D FULL^VALM1
 W:$D(IOF) @IOF
 S DA=AMHTP,DIE="^AMHPTXP(",DR="[AMH TP REVIEW]" D CALLDIE^AMHLEIN
 D EXIT
 Q
DELETE ;EP
 ;add code to not allow delete unless they have the key
 I '$D(^XUSEC("AMHZ DELETE RECORD",DUZ)) W !!,"You do not have the security access to delete a Treatment Plan.",!,"Please see your supervisor or program manager.",! D PAUSE,EXIT Q
 K DIR S DIR(0)="N^1:"_AMHRCNT_":0",DIR("A")="Select BH Treatment Plan" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No treatment plan selected." G EXIT
 S AMHTPN=+Y I 'AMHTPN K AMHTP,VALMY,XQORNOD W !,"No treatment plan selected." G EXIT
 S AMHTP=$O(AMHPTP("IDX",AMHTPN,0)) I 'AMHTP K AMHTPDEL,AMHTP D PAUSE,EXIT Q
 S AMHTP=AMHPTP("IDX",AMHTPN,AMHTP) I 'AMHTP K AMHTP D PAUSE,EXIT Q
 I '$D(^AMHPTXP(AMHTP,0)) W !,"Not a valid TREATMENT PLAN." K AMHTPDEL,AMHTP D PAUSE,EXIT Q
 D FULL^VALM1
DEL ;
 W !! S DIR(0)="Y",DIR("A")="Are you sure you want to DELETE this Treatment Plan",DIR("B")="N" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 S DA=AMHTP,DIK="^AMHPTPP(" D ^DIK
 W !,"Deleting Treatment Plan..." S DA=AMHTP,DIK="^AMHPTXP(" D ^DIK K DA,DIK
 W !!,"Treatment Plan for ",$P(^DPT(DFN,0),U)," DELETED." D PAUSE
 D EXIT
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
HEADER ;
 W:$D(IOF) @IOF
 W !,$TR($J(" ",80)," ","-"),!,"Patient Name:  ",$P(^DPT(DFN,0),U),"   DOB:  ",$$FTIME^VALM1($P(^DPT(DFN,0),U,3)),"  Sex:  ",$$VAL^XBDIQ1(2,DFN,.02),!,$TR($J(" ",80)," ","-")
 Q
EXIT ;
 D TERM^VALM0
 S VALMBCK="R"
 D GATHER^AMHLETP
 S VALMCNT=AMHLINE
 D HDR^AMHLETP
 K AMHX,AMHQUIT,AMHTP,AMHNODE,AMHG,AMHDA,AMHFILE,AMHC,AMHGIEN,AMHLEC,AMHLETP,AMHLETXT,AMHPCNT,AMHPRNM,AMHTP,AMHRMETH,AMHMETH0
 K D,D0,DA,DD,DIADD,DIC,DICR,DIE,DIG,DIH,DIK,DINUM,DIR,DIRUT,DIU,DIV,DIW,DIWF,DIWL,DIWR,DIY,DLAYGO,DO,DQ,DR,DTOUT,DUOUT
 K X,Y,Z,I
 Q
