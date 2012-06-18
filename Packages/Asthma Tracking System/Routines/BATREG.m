BATREG ; IHS/CMI/LAB - NO DESCRIPTION PROVIDED ;
 ;;1.0;IHS ASTHMA REGISTER;;FEB 19, 2003
 ;
 ;
A ;EP;add/edit register patient
 K DIC
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("Update Asthma Register Data")
 W !!,"This option is used to either Add a new patient to the Asthma register or to",!,"update an existing patient.",!!
 S DIC="^BATREG(",DIC(0)="AEMQL" D ^DIC
 I Y=-1 D EXIT Q
 S DFN=+Y
 W !
 S DA=DFN,DIE="^BATREG(",DR=".02;.06;.07;.08;.12;W !;1100" D ^DIE
 W !! S DIR(0)="Y",DIR("A")="Do you want to update/add another patient",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
 G A
 Q
AI ;EP - update status only
 K DIC
 W:$D(IOF) @IOF
 W !!,$$CTR^BATU("Update Asthma Register Data")
 W !!,"This option is used to update the STATUS field of a patient in the register",!
 S DIC="^BATREG(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 D EXIT Q
 S DFN=+Y
 W !
 S DA=DFN,DIE="^BATREG(",DR=".02" D ^DIE
 D EXIT
 Q
EXIT ;
 D EN^XBVK("BAT")
 D ^XBFMK
 K DIADD,DLAYGO,DINUM
 Q
 ;
EP(BATDFN,BATVIEN,BATVSIT) ;EP;entry point from APCD AST templates
 I '$G(BATDFN) Q
 D EN^XBNEW("EP1^BATREG","BATDFN;BATVIEN;BATVSIT")
 Q
EP1 ;
 ;check to see if on register, if not add them and send bulletin
 I $P($G(^BATSITE(DUZ(2),0)),U,7)'=1 Q  ;site parameter is off or blank
 S BATQUIT=""
 ;Q:$$LASTSEV^BATU(BATDFN)=""  ;no severity
 ;Q:$$LASTSEV^BATU(BATDFN)=1  ;severity is 1 do not add
 I '$D(^BATREG(BATDFN)) D EPADD I BATQUIT D EXIT Q
 ;update .05
 S BATVST=$$LASTAV^BATU(BATDFN,1)
 S BATSTAT=$P(^BATREG(BATDFN,0),U,2) ;status
 I BATSTAT="I" S BATSTAT="U"
 S DIE="^BATREG(",DR=".02///"_BATSTAT_";.05////"_BATVST,DA=BATDFN D ^DIE
 I $D(Y) W !!,"Unable to update ASTHMA REGISTER.  Notify Site Manager.",!
 Q
EPADD ;
 ;I $P($G(^BATSITE(DUZ(2),0)),U,2)=0 S BATQUIT=1 Q  ;do not add anyone to the register
 I $P($G(^BATSITE(DUZ(2),0)),U,2)]"",$$AGE^AUPNPAT(BATDFN)>$P($G(^BATSITE(DUZ(2),0)),U,2) S BATQUIT=1 Q
 I $P($G(^BATSITE(DUZ(2),0)),U,6)]"",$$AGE^AUPNPAT(BATDFN)<$P($G(^BATSITE(DUZ(2),0)),U,6) S BATQUIT=1 Q
 I $P($G(^BATSITE(DUZ(2),0)),U,3)=0,$G(BATVIEN),$G(BATVSIT),$$FIRSTAP(BATDFN,BATVIEN,BATVSIT) S BATQUIT=1 Q
 S (DINUM,X)=BATDFN,DIC(0)="L",DIC="^BATREG(",DIC("DR")=".02///U",DLAYGO=90181.01,DIADD=1 K DD,DO D FILE^DICN K DINUM,DLAYGO,DIADD
 I Y=-1 S BATQUIT=1 Q
 ;send bulletin
 K XMB
 S XMB(1)=$P(^DPT(BATDFN,0),U),XMB(2)=$$DOB^AUPNPAT(BATDFN,"E"),XMB(3)=$$HRN^AUPNPAT(BATDFN,DUZ(2)),XMB(4)=$$VAL^XBDIQ1(9000010.41,BATDFN,.03),XMB(5)=$$LASTSEV^BATU(BATDFN,5)
 S XMB="BAT NEW PATIENT ON REGISTER",BATDUZ=DUZ,DUZ=.5
 D ^XMB S DUZ=BATDUZ K XMB
 Q
UPLOAD ;EP - called from option to upload patients from search template
 W:$D(IOF) @IOF
UPL1 D EXIT
 W !!,$$CTR^BATU("Upload Patients into Asthma Register from Template",80)
 W !!,"This option is used to upload a group of patients from a template into the ",!,"Asthma Register.  You should have created a template using a utility such as",!,"QMAN.",!!
TEMP ;get template
 S BATTEMP=""
 W ! S DIC("S")="I $P(^(0),U,4)=9000001" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 D EXIT Q
 S BATTEMP=+Y
 ;
WSTAT ;
 S BATSTAT=""
 W !!,"What status should be assigned to the patients when they are uploaded.",!
 S DIR(0)="90181.01,.02",DIR("A")="Enter Status to be used",DIR("B")="U" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G UPL1
 S BATSTAT=Y,BATSTAT(0)=Y(0)
CONT ;
 S X=0,C=0 F  S X=$O(^DIBT(BATTEMP,1,X)) Q:X'=+X  S C=C+1
 W !!,"A total of ",C," patients will be uploaded with a status of ",BATSTAT(0),".",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D EXIT Q
 I 'Y D EXIT Q
UPL2 ;process uploading
 W !
 S BATDFN=0,BATCNT=0 F  S BATDFN=$O(^DIBT(BATTEMP,1,BATDFN)) Q:BATDFN'=+BATDFN  D
 .D ^XBFMK
 .I $D(^BATREG(BATDFN,0)) W !,"Patient ",$P(^DPT(BATDFN,0),U)," already on Register.",! Q
 .S DIC="^BATREG(",(DINUM,X)=BATDFN,DIC(0)="L",DIC("DR")=".02////"_BATSTAT,DLAYGO=90181.01,DIADD=1 K DD,DO D FILE^DICN K DIC,DLAYGO,DIADD,DINUM K DIC
 .I Y=-1 W !,"error uploading patient dfn ",BATDFN,!
 .S BATCNT=BATCNT+1
 .W ".",BATCNT
 .Q
 W !!,"A total of ",BATCNT," patients were uploaded into the Asthma Register.",!
 D PAUSE
 D EXIT
 Q
PAUSE ;EP
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
FIRSTAP(P,VIEN,VSIT) ;
 I $G(P)="" Q 0
 I $G(VSIT)="" Q 0
 I $G(VIEN)="" Q 0
 NEW BATX,BATY,I,S,E
 K BATX
 S BATY="BATX("
 S S=P_"^FIRST DX [BAT ASTHMA DIAGNOSES" S E=$$START1^APCLDF(S,BATY)
 I E Q 0
 I $D(BATX(1)) Q 0
 Q 1
SITE ;EP - update site parameters
 W:$D(IOF) @IOF W !!,$$CTR^BATU("Update Site Parameters"),!
 K DIC S DIC="^BATSITE(",DIC(0)="AEMQL",DIC("B")=$P(^DIC(4,DUZ(2),0),U) D ^DIC
 I Y=-1 D ^XBFMK Q
 S DA=+Y,DIE="^BATSITE(",DR="[BAT UPDATE SITE PARAMETERS]" D ^DIE
 D ^XBFMK
 Q
