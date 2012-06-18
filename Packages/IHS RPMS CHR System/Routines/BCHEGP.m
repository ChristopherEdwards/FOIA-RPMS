BCHEGP ; IHS/CMI/TUCSON - group preventive services group form ; [ 07/21/05  7:43 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**16**;OCT 28, 1996
 ;
START ;
 D INIT
 K BCHQUIT
 D GETDATA
 I $D(BCHQUIT) W !!,"Exiting group form entry" H 2 D EOJ Q
 D ^BCHEGP1
 ;print forms?
PRINT ;
 W !! S DIR(0)="Y",DIR("A")="Do you wish to PRINT a hard copy encounter form for each patient in the group",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q:$D(DIRUT)
 Q:'Y
 S XBRP="PRINT1^BCHEGP",XBRC="",XBRX="EOJ^BCHEGP",XBNS="BCH"
 D ^XBDBQUE
 ;loop through all patients, records and print forms
 W !!!!
 Q
PRINT1 ;
 S BCHR=0 F  S BCHR=$O(^BCHGROUP(BCHFID,21,BCHR)) Q:BCHR'=+BCHR!($G(BCHQUIT))  D PRINT1^BCHUFPP
 Q
INIT ; Write Header
 D ^XBFMK K DIADD,DLAYGO
 D TERM^VALM0
 W:$D(IOF) @IOF
 F BCHEGJ=1:1:11 S BCHEGX=$P($T(TEXT+BCHEGJ),";;",2) W !?80-$L(BCHEGX)\2,BCHEGX
 K BCHEGX,BCHEGJ
 W !!
 S BCHQUIT=""
 D ^BCHUIN
 K ^TMP("BCHEGP",$J)
 D KILL^AUPNPAT
 Q
EOJ ;
 D EN^XBVK("BCH")
 K AUPNPAT,AUPNDAYS,AUPNSEX,AUPNDOB,AUPNDOD
 K %,%W,%Y,X,Y,DIR,DIRUT,DIC,DIE,DA,DR,DTOUT,DUOUT,%DT,DIU,DIV,DIW,DIPGM,DQ,DI,DIG,DIH,X1,X2,ZTSAVE
 D ^XBFMK K DIADD,DLAYGO
 Q
GETDATA ; GET LOCATION OF ENCOUNTER
 W !
 ;create new group form entry
 S X="XXX",DIADD=1,DLAYGO=90002.97,DIC="^BCHGROUP(",DIC(0)="L" K DD,DO D FILE^DICN
 K DIADD,DLAYGO,DIC
 I Y=-1 W !!,"error creating group entry." S BCHQUIT=1
 S BCHFID=+Y
 D ^XBFMK
 S DA=BCHFID,Z="G"_BCHFID,DIE="^BCHGROUP(",DR=".01///"_Z D ^DIE K DIE,DR,DA
 W !!,"The form ID for this group form is ",$P(^BCHGROUP(BCHFID,0),U),".",!,"Please make a note of this.  It will be needed if and when you need to ",!,"re-print forms.",!!
 K DIR S DIR(0)="E",DIR("A")="Press enter to continue" D ^DIR K DIR
EDIT ;
 S DA=BCHFID,DDSFILE=90002.97,DR="[BCH GROUP ENTRY]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" S BCHQUIT=1 K DIMSG Q
 S C=0 I '$O(^BCHGROUP(BCHFID,91,0)) W !!,"At least one POV is required!" S C=1
 F X=1:1:4,6,11,12 I $P(^BCHGROUP(BCHFID,0),U,X)="" S C=1
 S Y=0 F  S Y=$O(^BCHGROUP(BCHFID,91,Y)) Q:Y'=+Y  F X=1:1:4 I $P(^BCHGROUP(BCHFID,91,Y,0),U,X)="" S C=1
 I C W !!,"Not all required data elements have been entered." D  G:Y="E" EDIT W !,"Deleting group definition..." S DA=BCHFID,DIK="^BCHGROUP" D ^DIK K DIK,DA S BCHQUIT=1 K DIR S DIR(0)="E" D ^DIR K DIR
 .S DIR(0)="S^E:Edit and Complete the Group Definition;D:Delete the Incomplete Definition",DIR("A")="What do you want to do",DIR("B")="E" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S Y="L"
 .Q
 Q:$D(BCHQUIT)
 S BCHNUM=$P(^BCHGROUP(BCHFID,0),U,12)
 ;DISPLAY AND CONFIRM
 W !!,"I am going to ask you to enter ",BCHNUM," patient names.  I will then create a",!,"record in the CHR file for each patient.  The record will contain the",!,"following information: ",!
 S DIC="^BCHGROUP(",DA=BCHFID,DR="0;91" D EN^DIQ K DIC
 K DIR,DA,DTOUT,DIRUT,DUOUT,DIC,X,Y S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT=1 Q
 I 'Y S BCHQUIT=1 Q
 Q
 ;
 ;
FORMID ;
 ;generate form id in file
 K DIC,DO,DD,D0 S X="XXX",DIC(0)="L",DIC="^BCHGROUP(",DIADD=1,DLAYGO=9001002.3,DIC("DR")=".02////"_DUZ_";.03////"_DT_";.04////"_BCHDATE D FILE^DICN I Y=-1 D  Q
 .D ^XBFMK K DIADD,DLAYGO,DLAYGO,DR,DD S BCHQUIT=1 W !!,"Failure to create FORM ID.  Notify programmer.",! Q
 S BCHFID=+Y
 K DIADD,DLAYGO D ^XBFMK
 S DA=BCHFID,Z="G"_BCHFID,DIE="^BCHGROUP(",DR=".01///"_Z D ^DIE K DIE,DR,DA
 W !,"The form ID for this group form is ",$P(^BCHGRP(BCHFID,0),U),".",!,"Please make a note of this.  It will be needed if and when you need to ",!,"re-print forms.",!
 Q
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
TEXT ;
 ;;IHS/RPMS CHR REPORTING SYSTEM
 ;;
 ;;*************************
 ;;* GROUP FORM ENTER Mode *
 ;;*************************
 ;;
 ;;You will be asked to enter the data that will be included
 ;;on each patient's visit.  You will then be asked to enter
 ;;each patient's name who attended the group session.  Afer
 ;;that you will be given the opportunity to add measurements
 ;;and/or edit each patient's visit record.
 ;;
 ;
REPRINT ;EP - called from option
 D RXIT
 W:$D(IOF) @IOF
 W !!,"This option should be used to print or re-print group encounter forms.",!!,"You must know the group ID form number or the date of the group visit."
 W !!,"Only group forms entered after PCC Data Entry Patch 5 was installed",!,"are available for re-printing.",!!
 W !!,"Please enter the group ID form or the date of the visit.",!
 D ^XBFMK
 S DIC="^BCHGROUP(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 W !!,"No form selected" H 2 D RXIT Q
 S BCHFID=+Y
 S X=0 F  S X=$O(^BCHGROUP(BCHFID,21,X)) Q:X'=+X  S BCHEGP("FORMS",X)=""
 I '$D(BCHEGP("FORMS")) W !!,"There are no visits to print.",! H 2 D RXIT Q
 W !,"The following visit forms will be printed: "
 S X=0 F  S X=$O(BCHEGP("FORMS",X)) Q:X'=+X  D
 .W !?5,$$VAL^XBDIQ1(90002,X,.01),?30,$$VAL^XBDIQ1(90002,X,.04)
 D PRINT
 D RXIT
 Q
RXIT ;
 D EN^XBVK("BCH")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
