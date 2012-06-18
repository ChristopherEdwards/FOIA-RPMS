AGDELHRN ; IHS/ASDS/EFG - DELETE HRNS FROM DDPS ;  
 ;;7.1;PATIENT REGISTRATION;;AUG 25,2005
 ;
 ;THIS MENU OPTION HAS BEEN REMOVED PER RAY WILLIE, ITSC.
 ;
 ;allows the facility to delete HRNs from DDPS when the patient
 ;does not exist at the facility
 W !,"For DELETION of DDPS HRNs when you do not have the HRN on your System."
 W !,"You will be asked to enter facility, HRN, 2-Initials (FL), and Sex",!
FAC W ! S DIC="^AGFAC(",DIC(0)="AEQM",DIC("S")="I $P(^(0),U,21)=""Y"""
 S DIC("A")="Select Official Registering Facility: "
 D ^DIC G:Y'>0 EXIT
 S AGFACIEN=+Y,AGFACNM=$P(^DIC(4,AGFACIEN,0),U),AGSUFAC=$P(^AUTTLOC(AGFACIEN,0),U,10)
HRN W @IOF,!!,AGFACNM,! K DIR S DIR(0)="N^100000:999999:0",DIR("A")="HRN to be deleted" D ^DIR
 I Y'>0 G FAC
 S AGHRN=+Y,DFN=0
 I $D(^AUPNPAT("D",AGHRN)) S DFN=0 F  S DFN=$O(^AUPNPAT("D",AGHRN,DFN)) Q:DFN=""  Q:$D(^AUPNPAT("D",AGHRN,DFN,AGFACIEN))
 I DFN W *7,!!,AGHRN," belongs to ",$P(^DPT(DFN,0),U) K DIR S DIR(0)="E" D ^DIR K DIR G:Y="^" EXIT G HRN
INT ;gather initials
 K DIR S DIR(0)="F^2:2",DIR("A")="2-Initials (FstLst)" D ^DIR
 G:Y="^" EXIT
 I (Y'?2U) W !,"UPPER CASE LETTERS PLEASE" G INT
 S AGINT=Y
SEX K DIR S DIR(0)="S^M:MALE;F:FEMALE",DIR("A")="SEX" D ^DIR K DIR
 G:Y="^" INT
 S AGSEX=Y
 W !!,"Facility:",?15,AGFACNM
 W !,"Health Record",?15,AGHRN
 W !,"Initials",?15,AGINT
 W !,"Sex",?15,AGSEX
 K DIR S DIR(0)="Y",DIR("A")="Is the ablove correct ?",DIR("B")="Y" D ^DIR
 I Y'=1 D EXIT G FAC
 S AGSUB="RG3"_U_AGSUFAC_U_AGHRN_U_U_AGINT_U_AGSEX
 S ^AGPATCH("DEL",AGSUB)=""
 W !,"Transmission is set" K DIR S DIR(0)="E" D ^DIR K DIR
 G:Y="^" EXIT
 G HRN
EXIT Q
