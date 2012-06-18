SDWLPE ;IOFO BAY PINES/TEH - WAIT LIST - PARAMETER WAIT LIST ENTER/EDIT ;20 Aug 2002
 ;;5.3;scheduling;**263,280,288**;AUG 13 1993
 ;
 ;
EN ;
 ;OPTION HEADER
 ;
 D HD
 ;
 ;SELECT FILE TO EDIT
 ;
EN1 D SEL G END:X["^",END:X=""
 ;
 ;EDIT PARAMETER FILE
 ;
 D EDIT G EN:'$D(Y)
 G END
 Q
 ;
SEL ;SELECT PARAMETER FILE
 S DIR(0)="SO^1:Wait List Service/Specialty File;2:Wait List Clinic Location"
 S DIR("L",1)="Select one of the following:"
 S DIR("L",2)=""
 S DIR("L",3)="    1. Wait List Service/Specialty (409.31)"
 S DIR("L")="    2. Wait List Clinic Location (409.32)"
 D ^DIR S SDWLF=X
 K DIR,DILN,DINDEX
 Q
EDIT ;EDIT FILE PARAMETERS
 I SDWLF=1 D SB1 Q:$D(DUOUT)
 I SDWLF=2 D SB2 Q:$D(DUOUT)
 Q
SB1 S DIC(0)="AEQMZ",DIC("A")="Select DSS ID: ",DIC="^DIC(40.7,",DIC("S")="I '$P(^DIC(40.7,+Y,0),U,3)"
 D ^DIC
 I X["^" I $D(DA),'$D(^SDWL(409.31,DA,"I")) S DIK="^SDWL(409.31," D ^DIK S DUOUT=1 Q
 Q:Y<0  Q:$D(DUOUT)  S SDWLDSS=+Y
 I '$D(^SDWL(409.31,"B",SDWLDSS)) D
 .S DIC(0)="LX",X=SDWLDSS,DIC="^SDWL(409.31," K DO D FILE^DICN
 S DA=$O(^SDWL(409.31,"B",SDWLDSS,""))
 S DIR(0)="PAO^4:EMZ" D ^DIR
 I X["^" S DIK="^SDWL(409.31," D ^DIK S DUOUT=1 Q
 S X=$$GET1^DIQ(4,+Y_",",11)
 I X'["N"!'$$TF^XUAF4(+Y) W !,*7,"Invalid Entry. Must be 'National' Institution." G SB1
 I X="" D  W *7," Required" G SB1
 .I '$D(^SDWL(409.31,DA,"I")) S DIK="^SDWL(409.31," D ^DIK
 I '$D(^SDWL(409.31,DA,"I","B",+Y)) D
 .S DA(1)=DA,DIC="^SDWL(409.31,"_DA(1)_","_"""I"""_",",DIC("P")=409.311,X=+Y K D0 D FILE^DICN I +Y S DA=+Y
 I $D(^SDWL(409.31,DA,"I","B",+Y)) S DA(1)=DA,DA=$O(^(+Y,0))
 K DIC,DIE,DIR,DR
 W ! S DR="1;3",DIE="^SDWL(409.31,"_DA(1)_","_"""I"""_"," D ^DIE
 I $P(^SDWL(409.31,DA(1),"I",DA,0),U,2)="" D
 .W *7," This ENTRY requires an ACTIVATION DATE. ENTRY deleted."
 .S DIK="^SDWL(409.31,"_DA(1)_","_"""I"""_"," D ^DIK I '$P(^SDWL(409.31,DA(1),"I",0),U,3) D
 ..S DIK="^SDWL(409.31,",DA=DA(1) D ^DIK
 K DA,DA(1),SDWLDSS,DIC,DR,DIE,DI,DIEDA,DIG,DIH,DIIENS,DIR,DIU,DIV
 Q
SB2 S SDWLSTOP=0
 W ! S DIC(0)="AEQMNZ",DIC("A")="Select Clinic: ",DIC=44
 S DIC("S")="S SDWLX=$G(^SC(+Y,0)),SDWLY=$G(^(""I"")) I $P(SDWLX,U,3)=""C"",$P(SDWLY,U,1)'>$P(SDWLY,U,2) I $P(^SC(+Y,0),U,4)"
 S DIC("W")="I $P(^SC(+Y,0),U,4) W ?50,""- "",$E($P(^DIC(4,$P(^SC(+Y,0),U,4),0),U,1),1,25)"
 D ^DIC Q:Y<1  Q:$D(DUOUT)  S SDWLSC=+Y
 S INST=$$GET1^DIQ(44,+Y,3,"I")
 S X=$$GET1^DIQ(4,+INST_",",11) I X'["N"!'$$TF^XUAF4(+INST) W !,*7,"Invalid Entry. Must be 'National' Institution." G SB2
 I '$D(^SDWL(409.32,"B",SDWLSC)) D
 .S DIC(0)="LX",X=SDWLSC,DIC="^SDWL(409.32," D FILE^DICN
 S DA=$O(^SDWL(409.32,"B",SDWLSC,""))
 K DIC,DIC(0)
 S SDWLSCN=$P($G(^SDWL(409.32,DA,0)),U,1) D
 .I $D(^SDWL(409.3,"C",SDWLSCN)) D
 ..S SDWLN="",SDWLCNT=0 F  S SDWLN=$O(^SDWL(409.3,"C",SDWLSCN,SDWLN)) Q:SDWLN=""  D
 ...S X=$G(^SDWL(409.3,SDWLN,0)) I '$D(^SDWL(409.3,SDWLN,"DIS")) S SDWLCNT=SDWLCNT+1,^TMP("SDWLPE",$J,"DIS",SDWLN,SDWLCNT)=X,SDWLSTOP=1
 W ! I SDWLSTOP W "This Clinic has Patients on the Wait List and can not be inactivated." Q
 S DR="1",DIE="^SDWL(409.32," D ^DIE I X S DR="2////^S X=DUZ" D ^DIE
 S DR="3",DIE="^SDWL(409.32," D ^DIE I X S DR="4////^S X=DUZ" D ^DIE
 K DR,DIE,DIC,Y,X,SDWLY,DIC(0),DO,DA,DI,DIW,SDWLX,SDWLSCN,SDWLF
 Q
SWT ;SWITCH FOR INACTIVIATION OF PARAMETER FILE
 Q
HD ;HEADER
 W:$D(IOF) @IOF W !!,?80-$L("Wait List Parameter Enter/Edit")\2,"Wait List Parameter Enter/Edit",!
 W !,?80-$L("------------------------------")\2,"------------------------------",!
END K SDWLSTOP,DIR,DIC,DR,DIK,SDWLX,SDWLSCN,SDWLF,SDWLY,SDWLSC,SDWLN,SDWLCNT,SDWLDSS,DUOUT,X,Y
 Q
