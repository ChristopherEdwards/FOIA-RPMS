ABMMUMUP ;IHS/SD/SDR - MU Report Parameters ;
 ;;2.6;IHS 3P BILLING SYSTEM;**7,8**;NOV 12, 2009
 ;
 W !!
 I $P($G(^ABMMUPRM(1,0)),U,2)'="" D  Q
 .W !!,"Setup has already been done.  Contact OIT if changes need to be made",!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("A",1)="You are setting up the Report Parameters.  Once completed, you will not be able to edit."
 S DIR("A")="Continue"
 S DIR("B")="N"
 D ^DIR K DIR
 Q:Y<1
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("A")="Do you wish to designate a Facility as an FQHC or RHC"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 S ABMANS=+Y
EN ;
 I ABMANS=1 D
 .D GETFACS
 .W !!
 .S ABMCNT=0,ABMDIR=""
 .F  S ABMCNT=$O(ABMFLIST(ABMCNT)) Q:'ABMCNT  D
 ..W !?2,ABMCNT_".",?6,$$GET1^DIQ(9999999.06,$G(ABMFLIST(ABMCNT)),.01,"E")
 ..S:ABMDIR'="" ABMDIR=ABMDIR_";"_ABMCNT_":"_$$GET1^DIQ(9999999.06,$G(ABMFLIST(ABMCNT)),.01,"E")
 ..S:ABMDIR="" ABMDIR=ABMCNT_":"_$$GET1^DIQ(9999999.06,$G(ABMFLIST(ABMCNT)),.01,"E")
 .S ABMCNT=$O(ABMFLIST(99999),-1)  ;get last entry#
 .S (ABMCNT,ABMTOT)=ABMCNT+1
 .W !!
 .K ABMFANS,ABMF
 .F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)  ;they didn't answer
 ..D ^XBFMK
 ..S DIR(0)="SAO^"_$G(ABMDIR)
 ..S DIR("A")="Select one or more facilities to designate as an FQHC or RHC: "
 ..D ^DIR K DIR
 ..Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 ..Q:+$G(Y)<0
 ..S ABMFANS=Y
 ..S ABMF($G(ABMFLIST(ABMFANS)))=""
 ..D ^XBFMK
 ..S DIR(0)="Y"
 ..S DIR("A")="Is this FQHC led by a PA? "
 ..D ^DIR K DIR
 ..Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 ..S ABMF($G(ABMFLIST(ABMFANS)))=Y
 ..I ABMFANS=(ABMCNT+1) D
 ...S ABMCNT=0
 ...F  S ABMCNT=$O(ABMF(ABMCNT)) Q:'ABMCNT  S ABMF($G(ABMFLIST(ABMFANS)))=ABMFANS2
 I $D(ABMF) D
 .W !!!,"The following have been identified by you as FQHC/RHC facilities"
 .S ABMCNT=0
 .F  S ABMCNT=$O(ABMF(ABMCNT)) Q:'ABMCNT  D
 ..W !?2,$$GET1^DIQ(9999999.06,ABMCNT,.01,"E")
 ..W:+$G(ABMF(ABMCNT))=0 " (FQHC)"
 ..W:+$G(ABMF(ABMCNT))=1 " (FQHC led by PA)"
 .D ^XBFMK
 .S DIR(0)="Y"
 .S DIR("A",1)=""
 .S DIR("A",2)="By answering YES the entries below will be added and the list may not be edited without contacting OIT"
 .S DIR("A",3)=""
 .S DIR("A")="Are you sure"
 .D ^DIR K DIR
 .Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .S ABMFANS=Y
 S DIE="^ABMMUPRM("
 S DR=".02////Y"
 S DA=1
 D ^DIE
 ;
 S ABMLOC=0
 F  S ABMLOC=$O(ABMF(ABMLOC)) Q:'ABMLOC  D ADDENTRY(ABMLOC)
 K ABMDIR,ABMFLIST
 W !!,"Some states consider Optometrists, Podiatrists, etc., as Physicians."
 W !!,"The next prompt will allow the identification of these provider classes as"
 W !,"EP types to generate volume reports."
 W !!,"Please note: Defaults have been provided so there are already entries in this"
 W !,"file that don't need to be entered again."
 D ^XBFMK
 S DIR(0)="Y"
 S DIR("A")="Are there additional EP types for your state"
 D ^DIR K DIR
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 Q:Y=0
 F  D  Q:+$G(Y)<0!$D(DTOUT)!$D(DUOUT)!$D(DIRUT)!$D(DIROUT)
 .D ^XBFMK
 .S DA(1)=1
 .S DIC="^ABMMUPRM("_DA(1)_",2,"
 .S DIC("P")=$P(^DD(9002274.55,2,0),U,2)
 .S DIC(0)="AELMQ"
 .D ^DIC
 Q
ADDENTRY(ABMLOC) ;
 D ^XBFMK
 S DA(1)=1
 S DIC="^ABMMUPRM("_DA(1)_",1,"
 S DIC("P")=$P(^DD(9002274.55,1,0),U,2)
 S DIC(0)="LMQ"
 S X="`"_ABMLOC
 D ^DIC
 ;start old code abm*2.6*8
 ;S DIE=DIC
 ;S DA(1)=1
 ;S DA=ABMLOC
 ;end old code start new code
 S ABMIEN=+Y
 D ^XBFMK
 S DA(1)=1
 S DA=ABMIEN
 S DIE="^ABMMUPRM("_DA(1)_",1,"
 ;end new code
 S DR=".02////"_$G(ABMF(ABMLOC))
 D ^DIE
 Q
GETFACS ;EP
 K ABMPSFLG,ABMFLIST
 S ABMPAR=0
 S ABMCNT=1
 F  S ABMPAR=$O(^BAR(90052.05,ABMPAR)) Q:+ABMPAR=0  D  Q:($G(ABMPSFLG)=1)
 .I $D(^BAR(90052.05,ABMPAR,DUZ(2))) D
 ..; Use A/R parent/sat is yes, but DUZ(2) is not the parent for this 
 ..; visit location
 ..Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,3)'=ABMPAR
 ..Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,6)>DT
 ..Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,7)&($P(^(0),U,7)<DT)
 ..S ABMPSFLG=1
 S ABMFLIST(ABMCNT)=ABMPAR
 S ABMCNT=+$G(ABMCNT)+1
 S ABML=0
 F  S ABML=$O(^BAR(90052.05,ABMPAR,ABML)) Q:'ABML  D
 .Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,6)>DT
 .Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,7)&($P(^(0),U,7)<DT)
 .Q:ABMPAR=ABML
 .S ABMFLIST(ABMCNT)=ABML
 .S ABMCNT=+$G(ABMCNT)+1
 Q
