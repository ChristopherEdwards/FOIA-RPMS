BLSMIT ;IHS/CMI/LAB - map individual test; [ SEP 10, 2010  6:48 AM ]
 ;;5.2;IHS LABORATORY;**1015,1028**;NOV 01, 1997;Build 46
 ;;5.2;LAB SERVICE;**215**;Sep 27,1994
 ;=================================================================
 ; Ask VistA test to map-Lookup in Lab Test file #60
 ;
 ; This routine has been modified extensively since patch 1015 for patch 1028.  
 ; It has been altered to allow mapping of panels and non-CH subscripted tests.
 ; Corrected undefined error during lookup.
 ;
START ;entry point from option BLS LOINC MAPPING
 S BLSEND=0 D TEST
 I $G(BLSEND) G EXIT
 D SPEC
 I $G(BLSEND) D EXIT G START
 W !!
 D ENTERLNC
 I $G(BLSEND) D EXIT G START
CORRECT W !!
 S DIR(0)="Y",DIR("A")="Is this the correct one",DIR("B")="N"
 S DIR("?")="Enter 'NO' to select a different code."
 D ^DIR K DIR
 I $D(DIRUT)!($G(BLSEND)) D EXIT G START
 ;I 'Y,$G(BLSNO) D ENTERLNC
 ;I 'Y,'$G(BLSNO) D LOINC
 I 'Y D ENTERLNC
 I $G(BLSEND) D EXIT G START
 D MAP
 D EXIT
 G START
EXIT K DA,DIC,DIE,DINUM,DIR,DIRUT,DR,DTOUT,I,BLSCODE,BLSDATA,BLSEND,BLSLNC,BLSLNC0,BLSLOINC,BLSELEC,BLSIEN,BLSNLT,BLSSPEC,BLSSPECL,BLSSPECN,BLSTIME,BLSTEST,BLSUNITS,S,Y
 K DD,DO,DLAYGO,BLSNAM,BLSNO,X
 QUIT
TEST W !!
 K DIR
 ;[LR*5.2*1028;09/10/10;IHS/OIT/MPW]S DIR(0)="P^60:QEMZ,",DIR("A")="Enter Lab Test to Link/Map to LOINC ",DIR("S")="I ""BO""[$P(^(0),U,3),$L($P(^(0),U,12)),$P(^(0),U,4)=""CH"""
 S DIR(0)="P^60:QEMZ,",DIR("A")="Enter Lab Test to Link/Map to LOINC "
 S DIR("?")="Select Lab test you wish to link/map to a LOINC Code"
 D ^DIR K DIR
 I $D(DIRUT)!'Y K DIRUT S BLSEND=1 Q
 S BLSIEN=+Y,BLSTEST=$P(Y,U,2)
 W !
 Q
SPEC ; Ask Specimen- Lookup in Specimen multiple in Lab Test file #60
 S BLSEND=0
 ;display test in 60 and select specimen in multiple
 ;display all site specimens
 W !!,"You have selected the following test:"
 K DIC,DR,DIQ
 S DIC="^LAB(60,",DA=BLSIEN,DIQ(0)="R" D EN^DIQ
SPEC1 ;
 ;[LR*5.2*1028;09/10/10;IHS/OIT/MPW]I '$O(^LAB(60,BLSIEN,1,0)) W !!,"There are no site/specimens defined for this test.",!! S BLSEND=1 H 2 Q
 I '$O(^LAB(60,BLSIEN,1,0)) W !!,"There are no site/specimens defined for this test.",!! H 2 Q
 W !,"Select from the available site/specimens:",!
 W !?4,"SITE/SPECIMEN",?35,"UNITS",?50,"LOINC CODE"
 W !?4,"-------------",?35,"-----",?50,"----------"
 K BLSSS
 S (BLSC,BLSX)=0 F  S BLSX=$O(^LAB(60,BLSIEN,1,BLSX)) Q:BLSX'=+BLSX  D
 .S BLSC=BLSC+1
 .S BLSS=^LAB(60,BLSIEN,1,BLSX,0),BLSSS(BLSC)=BLSX
 .;[LR*5.2*1028;09/10/10;IHS/OIT/MPW]W !,BLSC,")",?4,$P(^LAB(61,$P(BLSS,U),0),U),?35,$P(BLSS,U,7),?50,$P($G(^LAB(60,BLSIEN,1,BLSX,95.3)),U)
 .;[LR*5.2*1028;09/28/10;IHS/OIT/MPW]Broke up previous line into 3 new lines.
 .W !,BLSC,")",?4,$P(^LAB(61,$P(BLSS,U),0),U),?35
 .W:$P(BLSS,U,7)?1N.N $P(^BLRUCUM($P(BLSS,U,7),0),U,1)
 .W ?50,$P($G(^LAB(60,BLSIEN,1,BLSX,95.3)),U)
 .Q
 K DIR
 S DIR(0)="N^1:"_BLSC_":0",DIR("A")="Select the Site/Specimen Entry for this test" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) S BLSEND=1 Q
 S BLSSPEC=BLSSS(+Y)
 Q
LOINC ;Lookup possible LOINC matches in LAB LOINC file #95.3
 ;[LR*5.2*1028;09/14/10;IHS/OIT/MPW]D FIND^DIC(95.3,"","80","M",BLSTEST,"","","I $P(^(0),U,8)=$G(BLSELEC)!(BLSELEC=74!(BLSELEC=83)!(BLSELEC=114)!(BLSELEC=1376)&(""SER PLAS BLD""[$P(^(80),"":"",4)))","","BLSLOINC","")
 D FIND^DIC(95.3,"","80","M",BLSTEST,"","","I $G(BLSELEC),$P(^(0),U,8)=$G(BLSELEC)!(BLSELEC=74!(BLSELEC=83)!(BLSELEC=114)!(BLSELEC=1376)&(""SER PLAS BLD""[$P(^(80),"":"",4)))","","BLSLOINC","")
CODE ;ask which code to map
 I +BLSLOINC("DILIST",0)=0 D  Q
 .W !!,"No matches found."
 .S BLSNO=1
 W !! S I=0
 F  S I=$O(BLSLOINC("DILIST","ID",I)) Q:'I!$G(BLSEND)  D
 .I $E(IOST,1,2)="C-",'(I#18) D  Q:$G(BLSEND)
 ..S DIR(0)="E" D ^DIR
 ..S:$S($G(DIRUT):1,$G(DUOUT):1,1:0) BLSEND=1
 .W !,I,":",BLSLOINC("DILIST","ID",I,80)
 K DIRUT,DUOUT
 W !!
 S DIR(0)="N^1:"_$S($G(BLSEND):I-2,1:$P(BLSLOINC("DILIST",0),U),1:0)
 S DIR("A")="LOINC code to map this test"
 D ^DIR K DIR,BLSEND
 I $D(DIRUT) S BLSEND=1 Q
 S BLSCODE=BLSLOINC("DILIST",1,+Y)
DISPL ;Show LOINC entry selected in file 95.3
 ;display header-system and class
 ;display LOINC code, component, property, time aspect, scale type and method type
 S DA=BLSCODE
 S BLSLNC0=^LAB(95.3,DA,0)
 F I=2,6,7,8,9,10,11,14 S BLSLNC0(I)=$P(BLSLNC0,U,I)
 S BLSNAM=$P($G(^LAB(95.3,DA,80)),U)
 W @IOF
 W !,"LOINC CODE: ",BLSCODE,"   ",BLSNAM
 W !,"SYSTEM: ",$P($G(^LAB(64.061,+BLSLNC0(8),0)),U),?40,"CLASS: ",$P($G(^LAB(64.061,+BLSLNC0(11),0)),U)
 W:BLSLNC0(2) !,"COMPONENT: ",$P($G(^LAB(95.31,+BLSLNC0(2),0)),U)
 W:BLSLNC0(6) !,"PROPERTY: ",$P($G(^LAB(64.061,+BLSLNC0(6),0)),U)
 W:BLSLNC0(7) !,"TIME ASPECT: ",$P($G(^LAB(64.061,+BLSLNC0(7),0)),U)
 W:BLSLNC0(9) !,"SCALE TYPE: ",$P($G(^LAB(64.061,+BLSLNC0(9),0)),U)
 W:BLSLNC0(10) !,"METHOD TYPE: ",$P($G(^LAB(64.2,+BLSLNC0(10),0)),U)
 ;[LR*5.2*1028;09/14/10;IHS/OIT/MPW]W:BLSLNC0(14) !,"UNITS: ",$P($G(^LAB(64.061,+BLSLNC0(14),0)),U)
 W:BLSLNC0(14) !,"UNITS: ",$P($G(^BLRUCUM(+BLSLNC0(14),0)),U,3)
 Q
MAP ;DIE call to add data name,time aspect,units, LOINC code, and lab test fields
 W !!,"LOINC Code ",$P(^LAB(95.3,BLSCODE,0),U)," will be mapped to test ",$P(^LAB(60,BLSIEN,0),U),!
 S DIR(0)="Y",DIR("A")="Are you sure you want to Map this code to this test"
 S DIR("?")="If you enter yes, the current LOINC code will be overwritten with the LOINC code that you have chosen."
 D ^DIR K DIR
 I $D(DIRUT) S BLSEND=1 Q
 I 'Y S BLSEND=1 Q
INDEX60 ;Stores LOINC code in Laboratory Test file (#60) so know what tests are mapped.
 ;[LR*5.2*1028;09/10/10;IHS/OIT/MPW]K DIE,DA,DR S DA=BLSSPEC,DA(1)=BLSIEN,DIE="^LAB(60,"_DA(1)_",1,",DR="95.3///"_BLSCODE D ^DIE
 I $G(BLSSPEC) K DIE,DA,DR S DA=BLSSPEC,DA(1)=BLSIEN,DIE="^LAB(60,"_DA(1)_",1,",DR="95.3///"_BLSCODE D ^DIE
 I '$G(BLSSPEC) K DIE,DA,DR S DA=BLSIEN,DIE="^LAB(60,",DR="999999902///"_BLSCODE D ^DIE
 ;[LR*5.2*1028;09/10/10;IHS/OIT/MPW]S ^LAB(60,BLSIEN,1,BLSSPEC,95.3)=BLSCODE
 I $D(Y) W !!,"LOINC CODE mapping failed.",! H 2 Q
 W !!,"Loinc Code has been successfully mapped.",!
 K DIC,DR,DIQ
 S DIC="^LAB(60,",DA=BLSIEN,DIQ(0)="R" D EN^DIQ
 Q
SHOWPRE ;DISPLAY LOINC CODE ABLSEADY MAPPED TO NLT
 S BLSLNC=$P($G(^LAM(BLSNLT,5,BLSSPEC,1,BLSTIME,1)),U)
 W !!,"This test and specimen is already mapped to:"
 W !,"LOINC code: ",BLSLNC,"  ",$G(^LAB(95.3,+BLSLNC,80))
 W !!
 S DIR(0)="Y",DIR("A")="Do you want to change this mapping"
 S DIR("?")="If you enter yes, the current LOINC code will be overwritten with the LOINC code that you have chosen."
 D ^DIR K DIR
 Q
ENTERLNC ;Enter LOINC code when already know the LOINC code
 W !! K DIR S BLSEND=0,DIR(0)="P^95.3:AEMZ",DIR("A")="Enter LOINC Code/Name "
 S DIR("?")="Enter LOINC Code Name or LOINC Number"
 S DIR("?",1)="You can see possible LOINC CODES/Specimen by entering the"
 ;[LR*5.2*1028;10/14/10;IHS/OIT/MPW] Begin changes
 ;S DIR("?",2)="LOINC Test Name..Specimen   example( GLUCOSE..UR )"
 S DIR("?",2)="LOINC Test Name   example( GLUCOSE )"
 ;S DIR("?",3)=" "
  ;[LR*5.2*1028;10/14/10;IHS/OIT/MPW] End changes
 D ^DIR K DIR
 I $D(DUOUT)!($D(DTOUT))!(Y=-1) K DTOUT,DUOUT S BLSEND=1 Q
 S BLSCODE=+Y
 D DISPL
 Q
